# FLW0020 — GDPR anonymization
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL019 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL019 (dossier FLW0020)
- Flow Name: GDPR anonymization
- Primary SRV: SRV0015
- Trigger Evidence: UI route `admin/gdpr/form/gdpr-mail` → form `\Drupal\gdpr\Form\GDPRMailForm` (`gdpr/gdpr.routing.yml:gdpr.gdpr_mail_form`; `gdpr/src/Form/GDPRMailForm.php:submitForm`→`deleteUser`)
- Confidence Level: Confirmed (with important caveats — see Behavior Digest / Data Footprint)

## B. Behavior Digest
- Trigger: Back-office operator submits an email address on the "GDPR delete user" form. Access gated by permission `access gdpr` (`gdpr/gdpr.permissions.yml`; `gdpr/gdpr.routing.yml`). Reachable via admin menu Management → Tools → GDPR (`gdpr/gdpr.links.menu.yml`).
- Preconditions: caller has `access gdpr`; a `user` entity exists whose `mail` equals the submitted email. No confirmation step, no CSRF-specific handling beyond Drupal form defaults, no re-authentication.
- Main Steps:
  1. `GDPRMailForm::buildForm` renders single `email` field + Delete submit (`gdpr/src/Form/GDPRMailForm.php:25`). `validateForm` only calls `parent::` — no real validation (`:43`).
  2. `submitForm` reads `email` value and calls `deleteUser($email)` (`gdpr/src/Form/GDPRMailForm.php:50-53`).
  3. `deleteUser` loads user by property `mail` via `entityTypeManager()->getStorage('user')->loadByProperties(['mail'=>$email])`, `reset()`s first match (`:62-65`). If none: messenger "doesn't exist" + return (`:66-69`).
  4. **Anonymization = in-place field mutation, NOT deletion:** `$user->set('mail','')` and `$user->set('name','u'.time().rand(1,100))`, then `$user->save()` (`gdpr/src/Form/GDPRMailForm.php:70-72`). No other fields touched.
  5. On save, `account_user_update` hook fires and dispatches `UserUpdateEvent::USER_UPDATE_EVENT` ('user.update.event') (`account/account.module:51-55`). **No subscriber listens to this event** (verified: only `getSubscribedEvents` in patron_form_access/notification/application_reaction/patron_base/scoring/campaign_recommendation, none key `user.update.event`) → dispatch is a no-op side channel.
  6. On save, entity class `Drupal\account\PatronUser::postSave` fires (`account/account.module:27-31` sets class; `account/src/PatronUser.php:50-54`): enqueues the (now-anonymized) user into `es_upload_queue` (Elasticsearch) and `mautic_queue` via `patron_base.default`→`PatronBaseService::addToQueue` (`patron_base/src/PatronBaseService.php:416`).
  7. Messenger "deleted" message (`gdpr/src/Form/GDPRMailForm.php:74`).
  8. **Only if** `Settings::get('environment') === 'production'`: calls `\Drupal::service('patron_base.smartmailing')->deleteContact($email)` (`gdpr/src/Form/GDPRMailForm.php:77-81`). The bound class is `Drupal\patron_base\APIMailingService` (`patron_base/patron_base.services.yml:8`), and its `deleteContact(string $email)` is an **empty method body — a no-op stub** (`patron_base/src/APIMailingService.php:278-280`). No Mautic/SmartMailing deletion actually occurs.
- Postconditions:
  - `user.mail` = '' (empty string, NOT null) and `user.name` = randomized `u{timestamp}{rand}`. User account remains ENABLED and PRESENT; no `user_cancel`/delete performed.
  - Two async queue items created (ES + Mautic) that will re-export the anonymized user on next `patron_base_cron`.
  - The intended external "delete from Mautic/SmartMailing" does NOT happen (stub).
- Side Effects:
  - Async: `mautic_queue` item → drained by `PatronBaseMauticCron::execute`→`processQueue('mautic_queue')` (`patron_base/patron_base.module:patron_base_cron` at ~`:160-172`; `patron_base/src/PatronBaseMauticCron.php:13-15`), processed by `MauticQueue` worker.
  - Async: `es_upload_queue` item (Elasticsearch re-index of anonymized record).
  - Contradictory external behavior (see Failure Modes / Integration Calls): the Mautic queue UPSERTS the anonymized record to Mautic rather than deleting it.
  - `UserUpdateEvent` dispatched but unconsumed.
- Integration Calls:
  - **Mautic (via async `mautic_queue` worker, NOT synchronous in this flow):** `patron_base/src/Plugin/QueueWorker/MauticQueue.php`. Guarded by `feature_is_enabled('feature_mautic_api_export')` (`:30`; flag = `\Drupal::state()->get(...)`, `patron_base/patron_base.module:146`). Reads `uid, first_name, last_name, mail as email from users_field_data where (first_name is not null or last_name is not null) and mail is not null and uid=:id` (`:39-42`) → `contactsApi->create($data)` at `https://m.patrondeti.cz/api` with BasicAuth env `MAUTIC_USER`/`MAUTIC_PASS` (<redacted>) (`:52-61`). Because the row still has `first_name`/`last_name` (never anonymized by this flow) and `mail=''` (not null), the anonymized user is re-created/updated in Mautic with names intact and blank email.
  - **SmartMailing:** intended synchronous `deleteContact` — no-op stub (`patron_base/src/APIMailingService.php:278`); the SmartMailing/Mautic client (`APIMailingService`) is built on `Mautic\MauticApi` with `Settings::get('mailing')` creds (`:43-57`) but the delete path is unimplemented.
  - **Elasticsearch:** anonymized user re-indexed via `es_upload_queue` (`PatronUser::postSave`, `patron_base/src/PatronBaseService.php:416`).
- Failure Modes:
  - **Data Loss / Legal-Gov (incomplete anonymization):** only `user.mail` + `user.name` are cleared. All PII duplicated onto `application` (fundraiser/patron/child first_name, last_name, email, phone, `rc` national/birth number, ID series/number, addresses — see `_ar/evidence/db-models.md`), onto `contact`, and `user.first_name`/`user.last_name` base fields (`account/account.module:79,99`) are LEFT INTACT. Right-to-erasure is not satisfied by this flow.
  - **External-Integration / Legal-Gov (anti-erasure):** the Mautic queue re-exports (creates/updates) the record with names and empty email instead of deleting; `deleteContact` stub means nothing is removed downstream.
  - **Security:** no confirmation, weak validation (`validateForm` empty), any holder of `access gdpr` can blank any account's login email by email lookup; anonymization is irreversible for `mail`/`name` (no audit of prior value beyond ES/Mautic copies).
  - **Idempotence:** repeated submit for same email fails to match after first run (mail is now '') → "doesn't exist" message; but each successful run re-randomizes name and re-enqueues.
  - Exception handling: whole `deleteUser` wrapped in try/catch → logs to `gdpr` channel and shows generic "doesn't delete" message (`gdpr/src/Form/GDPRMailForm.php:82-85`).
  - `addToQueue` dedupes by LIKE match on serialized data (`patron_base/src/PatronBaseService.php:417-420`) — a coarse, collision-prone check.

## C. Data Footprint
- Entities Written: `user` (fields `mail`←'', `name`←random; `$user->save()` at `gdpr/src/Form/GDPRMailForm.php:70-72`). Side-effect writes: rows in Drupal `queue` table for `mautic_queue` and `es_upload_queue` (`patron_base/src/PatronBaseService.php:421-422`).
- Entities Read: `user` (loadByProperties on `mail`, `gdpr/src/Form/GDPRMailForm.php:62-64`); async worker reads `users_field_data` (`MauticQueue.php:39-42`); `\Drupal::state()` for feature flag / `Settings::get('environment'|'mailing')`.
- Entities NOT touched (evidence of missing cascade): `application` (holds fundraiser/patron/child PII incl. `rc`, ID docs, addresses), `contact`, `transaction`, `aprofile`, `contract`, `donation_confirmation`, `tax_payer`, `user.first_name`/`user.last_name`. No cascade/erasure to any related entity — verified: no `hook_user_delete`/`hook_user_cancel`/user-referencing cleanup in custom modules; only `account_user_insert`/`account_user_update` exist (`account/account.module:38,51`).
- Constraints involved: `user.name` core uniqueness (randomized value avoids collision by timestamp+rand); `mail` set to empty string (bypasses email format because value is emptied, not validated). No FK cascade because the user is anonymized-in-place, never deleted, so references from `application.fundraiser/patron`, `contact.user_id`, etc. remain valid but now point to an anonymized-login/still-PII-bearing account.
- Multi-tenant scope assumptions: flow is tenant-agnostic — operates on a single `user` by global email lookup with no CZ/RO/MD country scoping (contrast `APIMailingService` which reads `Settings::get('country')` elsewhere at `:99`). The Mautic export target is a single hardcoded CZ endpoint `https://m.patrondeti.cz/api` (`MauticQueue.php:54`) regardless of the user's country.

## D. Evidence Block
- Controller paths: none (Drupal `_form` route). Trigger form: `intake/current-solution/_source/patronus/web/modules/custom/gdpr/src/Form/GDPRMailForm.php` (`buildForm:25`, `validateForm:43`, `submitForm:50`, `deleteUser:60`). Route: `.../gdpr/gdpr.routing.yml`; permission `.../gdpr/gdpr.permissions.yml`; menu `.../gdpr/gdpr.links.menu.yml`.
- Service methods: `patron_base.smartmailing` = `Drupal\patron_base\APIMailingService::deleteContact` — **empty stub** (`.../patron_base/src/APIMailingService.php:278`; ctor/creds `:37-57`). `patron_base.default` = `PatronBaseService::addToQueue` (`.../patron_base/src/PatronBaseService.php:416`). Service defs: `.../patron_base/patron_base.services.yml:8,12`.
- Repository usage: `entityTypeManager()->getStorage('user')->loadByProperties(['mail'=>...])` (`GDPRMailForm.php:62`); raw SQL on `users_field_data` (`MauticQueue.php:39-42`); raw SQL on `queue` (`PatronBaseService.php:417`).
- Event listeners: `account_user_update`/`account_user_insert` dispatch `UserUpdateEvent::USER_UPDATE_EVENT` ('user.update.event') (`.../account/account.module:51-55`, `38-42`; event class `.../account/src/Event/UserUpdateEvent.php:13`) — **no subscriber consumes it** (Hypothesis-free: verified across all `getSubscribedEvents` in custom scope). Entity class swap to `PatronUser` via `account_entity_type_build` (`account/account.module:27-31`); `PatronUser::postSave` enqueues ES + Mautic (`.../account/src/PatronUser.php:50-54`).
- Async messages: `mautic_queue` → `MauticQueue` worker (`.../patron_base/src/Plugin/QueueWorker/MauticQueue.php`), drained by `PatronBaseMauticCron` from `patron_base_cron` (`.../patron_base/patron_base.module` `patron_base_cron`; `.../patron_base/src/PatronBaseMauticCron.php:13-40`). `es_upload_queue` (Elasticsearch re-index). Both created by `addToQueue` (`PatronBaseService.php:421-422`).
- Config evidence: module enabled `gdpr: 0` in `intake/current-solution/_source/patronus/config/core.extension.yml:55`. Feature gate `feature_mautic_api_export` via `\Drupal::state()` (`patron_base/patron_base.module:146-149`). Prod gate `Settings::get('environment')==='production'` (`GDPRMailForm.php:77-78`). Mautic endpoint hardcoded `https://m.patrondeti.cz/api`; creds env `MAUTIC_USER`/`MAUTIC_PASS` (<redacted>). Cross-ref: `_ar/repo-map/integrations.md:37` (Mautic), `_ar/evidence/db-models.md` (application/contact PII columns).
