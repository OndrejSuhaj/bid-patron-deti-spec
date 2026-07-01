# FLW0019 — Transactional email dispatch
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL048 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL048 (dossier FLW0019)
- Flow Name: Transactional email dispatch
- Primary SRV: SRV0013 (Transactional-Messaging-Orchestrator + Email-Adapter, see [../../spec-draft/SRV-target-list.md](../../spec-draft/SRV-target-list.md))
- Trigger Evidence: `patron_base.smartmailing` service (`APIMailingService::handleMail`) invoked by ~30 call sites; declared trigger is queue worker `patron_base/src/Plugin/QueueWorker/MailingQueue.php:20` (`processItem` → `doHandleMail`). Service wiring: `patron_base/patron_base.services.yml` (`patron_base.smartmailing` → `Drupal\patron_base\APIMailingService`, arg `@queue`).
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Any context calls `patron_base.smartmailing->handleMail($toEmails,$params,$template_name,$reply_to,$attachments,$arguments)`. Because `APIMailingService::USE_QUEUE = FALSE` (`patron_base/src/APIMailingService.php:16`), the queue branch is dead and dispatch is **always synchronous** — `handleMail` calls `doHandleMail` inline (`APIMailingService.php:68-83`). The `mailing_queue` QueueWorker (`MailingQueue.php`) exists but is only reachable if `USE_QUEUE` were TRUE, so in current state it is never fed.
- Preconditions:
  - `Settings::get('mailing')` must contain non-empty `user`/`passwd`; otherwise the constructor returns early and `emailApi`/`contactApi` stay null (`APIMailingService.php:43-58`) → sending later fails silently, but archiving still runs.
  - `$toEmails` non-empty; single string address must pass `patron_base.default->isEmailValid()` (`APIMailingService.php:91`, `PatronBaseService.php:114`). Array recipients are NOT validated here.
  - `template_name` must exist in the per-country template-id map for the resolved `Settings::get('country')`; otherwise logged as `Wrong template name` and dropped (`APIMailingService.php:182-186`).
- Main Steps (each `file:symbol`):
  1. Caller → `APIMailingService::handleMail` (`APIMailingService.php:67`); USE_QUEUE=FALSE → `doHandleMail` (`APIMailingService.php:82`).
  2. Validate recipients; normalize scalar to array (`doHandleMail`, `APIMailingService.php:91-97`).
  3. Resolve country template map via `Settings::get('country')` — separate maps for `md`, `ro`, else (CZ default) (`APIMailingService.php:99-177`). Maps hold `template_name → numeric Mautic email id`.
  4. If `template_name` in map → `sendEmail(...)` (`APIMailingService.php:183`), else log error and stop (`APIMailingService.php:185`).
  5. `sendEmail` builds `$replace` token list from `$params`; chunks recipients by 50 (`APIMailingService.php:199-213`).
  6. Per recipient: **archive** an `EmailEntity` (name/subject, campaign, application, to, from, body, arguments=json params, template_name) and `->save()` (`APIMailingService.php:217-230`).
  7. Gate actual send: only if `Settings::get('environment') === 'production'` OR `isEmailAllowed($toEmail)` (substrings `leerimich`/`test20`/`patrondeti`) (`APIMailingService.php:233`, `261-269`).
  8. Send: `contactApi->create(['email'=>$toEmail])` upserts a Mautic contact, then `emailApi->sendToContact($templateID,$contactId,$parameters)` with `tokens`+`assetAttachments` (`APIMailingService.php:246-254`). On missing contact id, logs the contact response to channel `mailing`.
- Postconditions: One `email` row persisted per recipient regardless of send outcome; a Mautic contact created/updated and a templated email queued at Mautic for prod/allowed recipients.
- Side Effects:
  - DB insert into `email` table (one per recipient).
  - `EmailEntity::preSave` resolves `to_user_id` by loading a `user` whose `mail` = recipient (`EmailEntity.php:70-81`) — an extra read per send.
  - `EmailEntity::preCreate` stamps `user_id` = current user (`EmailEntity.php:63-68`).
  - Log writes to channels `smartemail_mailing` (wrong template) and `mailing` (contact failure).
- Integration Calls: Mautic REST API via `Mautic\MauticApi` (`emails`, `contacts` resources) authenticated `BasicAuth` against `Settings::get('mailing')['base_uri']` (`APIMailingService.php:53-57`). Despite the `SmartMailing` naming/service id, the actual outbound client is **Mautic** (base URI `https://m.patrondeti.cz/api` per [../../repo-map/integrations.md](../../repo-map/integrations.md) §3). No direct SMTP in this path.
- Failure Modes:
  - Missing `mailing` credentials → null API objects; `sendEmail` will fatally error on `$this->contactApi->create()` for prod/allowed recipients (archive already saved). `Hypothesis` on exact fatal vs. warning without runtime.
  - Unknown `template_name` → silently dropped (logged only) (`APIMailingService.php:185`). Notable: `campaign_successful_finish` path also fires `zz-uspesne-uzavreni-pribehu` / `patron-uspesne-uzavreni-pribehu` (`campaign/src/Entity/CampaignEntity.php:1149,1156`) which are **commented out** in the CZ map (`APIMailingService.php:167-168`) → those hit the drop path in CZ.
  - No send-status write-back: `email.sent` and `email.error` base fields exist (`EmailEntity.php:339-345`) but APIMailingService never sets them; `status` defaults TRUE at create. So archive cannot distinguish sent vs. failed vs. suppressed. (`Confirmed` — no `set('sent')`/`setError()` call in mailing path; grep shows the only `set('sent')` is in `feedback`.)
  - Non-prod, non-allowed recipient → archived but never sent (env gate), no flag distinguishes suppression from delivery.
  - Array recipients bypass `isEmailValid`; empty per-item addresses are skipped (`APIMailingService.php:212`).
  - No idempotency key: re-invocation re-archives and re-sends (e.g. entity postSave loops). Mautic `sendToContact` de-dup not enforced here.
- Retry/queue: Configured queue path is disabled (USE_QUEUE=FALSE); no retry/backoff in synchronous path.

## C. Data Footprint
- Entities Written: `email` (EmailEntity, base_table `email`) — one insert per recipient (`APIMailingService.php:217-230`). External: Mautic `contact` (create/upsert) and Mautic `email` send (not a local entity).
- Entities Read: `user` (via `EmailEntity::preSave` mail→user lookup, `EmailEntity.php:75`); `application`/`campaign` only as passed-in ids in `$arguments` (stored as entity_reference, not loaded here). Caller-side reads (application/contact/transaction) belong to the invoking flows, not this dispatch.
- Constraints involved: `email.application` is a **required** entity_reference (`EmailEntity.php:243-249`) and `email.name/to/from/template_name` are required strings (max_length to/from=50, name=200, template_name=50). Callers omitting `arguments['application']` create with `application => ''` (`APIMailingService.php:220`) → relies on required being validation-level only, not DB NOT NULL (per [../db-models.md](../db-models.md) L482-486 the `email` table has no hook_schema NOT NULL). `to`/`from` capped at 50 chars — long addresses truncate. `Partial` on whether empty `application` save is rejected at runtime.
- Multi-tenant scope assumptions: Country routing is **global** via `Settings::get('country')` — a single-country deployment assumption; there is no per-message country param. The env gate + allow-list (`isEmailAllowed`, hardcoded `leerimich`/`test20`/`patrondeti`) and hardcoded `senderEmail`/`customId` (`APIMailingService.php:39-40`) are instance-wide. Template-id maps are hardcoded per country in code, not config.

## D. Evidence Block
- Controller paths: `application/src/Controller/ApplicationStatusMailerController.php:77,111,124` (urgence cron mails); `application/src/Controller/SendLinkToApplicationController.php`; `contract/src/Controller/ApplicationContractController.php` (senders). Representative — full caller list below.
- Service methods: `patron_base/src/APIMailingService.php` — `__construct` (:37), `handleMail` (:67), `doHandleMail` (:89), `sendEmail` (:199), `isEmailAllowed` (:261). Service def: `patron_base/patron_base.services.yml` (`patron_base.smartmailing`).
- Repository usage: `EmailEntity::create()/->save()` (`APIMailingService.php:217-230`); entity hooks `EmailEntity::preCreate` (`EmailEntity.php:63`), `EmailEntity::preSave` (`EmailEntity.php:70`), `baseFieldDefinitions` (`EmailEntity.php:170`). Table `email` — no `email.install` hook_schema for it (only `email_domain`), per [../db-models.md](../db-models.md) L466-467.
- Event listeners: None drive this send. `notification/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php` (the `notification` module cited near this SRV in [../../repo-map/integrations.md](../../repo-map/integrations.md) §2) does **NOT** send mail — it builds acceptance-protocol contracts and application sessions on `waiting_signature`/`waiting_for_feetback` transitions. Status→email fan-out instead happens inside entity hooks (see Async messages).
- Async messages: `patron_base/src/Plugin/QueueWorker/MailingQueue.php` (`@QueueWorker id="mailing_queue"`) — present but **unused** (USE_QUEUE=FALSE). Real trigger surface is synchronous calls, many from entity hooks: `transaction/src/Entity/TransactionEntity.php` `sendEmailThanksForPayment()` (:726, sends at :756) invoked from `postSave` (:633); `campaign/src/Entity/CampaignEntity.php:1139,1149,1156,1184`; `voucher/src/Entity/VoucherEntity.php`. REST/form senders: `account/**` (password/activation/magic-link), `application/**` (POST/repeat/create + refill/mass/update forms), `donation_confirmation/**`, `feedback/**`, `gdpr/src/Form/GDPRMailForm.php`, `contact/src/Form/SendContactForm.php`, `netopia/src/NetopiaCron.php`, `bank_integration/src/Controller/BankIntegrationPageController.php`, `patron_base/src/Form/ManagerCreateUserForm.php`, `patron_base/src/Command/MigratePromoCommand.php`, `transaction/src/Plugin/rest/resource/TransactionVouchersResource.php`, `voucher/src/{VoucherCartService,MultipleVouchersGenerator}.php`.
- Config evidence: `Settings::get('mailing')` (user/passwd/base_uri) (`APIMailingService.php:43-57`); `Settings::get('country')` (md/ro/CZ-default template maps) (`APIMailingService.php:99-177`); `Settings::get('environment')` prod send-gate (`APIMailingService.php:233`). Mautic base URI `https://m.patrondeti.cz/api`, BasicAuth from env `MAUTIC_USER`/`MAUTIC_PASS` per [../../repo-map/integrations.md](../../repo-map/integrations.md) §3 (values <redacted>). Hardcoded `customId`/`senderEmail` at `APIMailingService.php:39-40`. No secrets reproduced.
