# FLW0015 — API register
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL013 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL013 (dossier FLW0015)
- Flow Name: API register
- Primary SRV: SRV0015
- Trigger Evidence: REST resource `account_register_resource` → `POST /api/2.3/account/register` (`intake/current-solution/_source/patronus/web/modules/custom/account/src/Plugin/rest/resource/AccountRegisterResource.php:15-21,78`). Real user-creation engine: `AccountService::register` (`account/src/AccountService.php:34`), exposed as service id `account` (`account/account.services.yml:2-4`).
- Confidence Level: Partial

## B. Behavior Digest
- Trigger: `POST /api/2.3/account/register` handled by `AccountRegisterResource::post` (`AccountRegisterResource.php:78`). NOTE (`Conflict — requires clarification`): the flow-index lists this as `/api/user/register`; the actual `uri_paths.create` annotation is `/api/2.3/account/register` (`AccountRegisterResource.php:18-20`). No `/api/user/register` or `/api/*/user/register` route exists in the `account` module scope (grep).
- Preconditions:
  - The REST resource itself has no explicit precondition logic — `AccountRegisterResource::post` accepts any `$data` and returns success (`AccountRegisterResource.php:78-80`). Effective auth/permission gating is whatever the Drupal REST config grants for `account_register_resource` (REST config not confirmed in custom scope — `Hypothesis`).
  - The `AccountService::register` engine (the path that actually creates accounts) presumes caller-supplied `values` incl. `email`, optional `first_name`/`last_name`/`phone`/`roles`/`contact` (`AccountService.php:39-49`). Callers first check `loadByEmail` to avoid duplicates (e.g. `transaction/src/TransactionService.php:154-156`).
- Main Steps:
  1. `POST /api/2.3/account/register` → `AccountRegisterResource::post` returns `['status'=>'success'], 200` UNCONDITIONALLY; it performs NO user creation, NO validation, NO persistence (`AccountRegisterResource.php:78-80`). This endpoint is a stub. (`Confirmed`.)
  2. Actual registration engine `AccountService::register($values)` (`AccountService.php:34`): builds slug via `createSlug` (`AccountService.php:46,221-234`), `User::create([...])` with mail=name=email, first/last name, roles, optional pre-set contact (`AccountService.php:41-49`).
  3. `$user->validate()`; on violations → log to `account.register` channel + return `FALSE` (`AccountService.php:54-62`). Else `$user->save()` (`AccountService.php:64`).
  4. If no `contact` was passed, create a `contact` entity (type `person`, `field_name`=first role, email/name/last_name/phone/title_prefix/title_suffix), save it, back-link `user.contact` and re-save user (`AccountService.php:66-82`).
  5. Return the `User` (or `FALSE` on any `\Exception`, logged to `account.register`) (`AccountService.php:84-89`).
  6. Sibling entry `AccountService::ensureUser($email,$role,$values)` (`AccountService.php:310`): loads existing user; if present, adds missing role / fills missing name / creates missing contact and saves (`AccountService.php:313-337`); else calls `register` with `roles=[role]` (`AccountService.php:338-342`). This is the idempotent wrapper used by upstream flows.
  7. Activation email is NOT sent by `register`/`ensureUser`; it is a separate step the caller invokes via `AccountService::sendActivationEmail($user,$role,...)` (`AccountService.php:254`) which builds a magic-link (`getUserMagicLink` `AccountService.php:274`) and dispatches template `activation_{role}` through `patron_base.smartmailing` (`AccountService.php:257-258`; `patron_base/src/APIMailingService.php:67`). See FLW0010 for the UI path that chains register→sendActivationEmail; the FL015 activation flow covers `/api/3.0/account/activate`.
- Postconditions: A `user` row (roles as supplied, e.g. `supporter`/`patron`/`fundraiser`) and a linked `contact` (`person`) exist; on validation failure or exception nothing persists and `FALSE` is returned (`AccountService.php:61,88`). No account status/blocked transition is set explicitly in `register` (relies on User defaults). No password is set by `register` (magic-link login model — password only forced later in `getUserMagicLink` `AccountService.php:277`).
- Side Effects:
  - `PatronUser::postSave` fires on EVERY user save (twice per new registration: after create and after contact back-link) — enqueues the user into `es_upload_queue` (default) and `mautic_queue` via `PatronBaseService::addToQueue` (`account/src/PatronUser.php:50-54`; `patron_base/src/PatronBaseService.php:416-426`). Dedup is a raw `queue` table `LIKE` query (`PatronBaseService.php:417`). → Elasticsearch index + Mautic contact sync downstream (async).
  - Email-domain validation, when performed by callers before register, writes/updates `email_domain` table (`email/src/EmailService.php:56-59,66-71`) and calls WhoisXMLAPI (see Integration Calls).
  - Activation email (when caller triggers it) writes an `email` archive entity and calls the mailing provider (`APIMailingService::doHandleMail` `patron_base/src/APIMailingService.php:89`).
  - Failure of queue insert logs to `logger.telegram` (`PatronBaseService.php:424`).
- Integration Calls:
  - WhoisXMLAPI domain-availability — `EmailService::domainExists` → `GET https://domain-availability.whoisxmlapi.com/api/v1?apiKey=<redacted>&domainName=...` via `\Drupal::httpClient()`, 10s timeouts (`email/src/EmailService.php:17-25`). NOTE: API key is hardcoded in source (`<redacted>`, `EmailService.php:18`) — see Risks. Reached from register callers via `PatronBaseService::isEmailValid` → `EmailService::validateDomain` (`patron_base/src/PatronBaseService.php:114-116`; `EmailService.php:42`). Not called inside `AccountService::register` itself.
  - Mautic (marketing automation) — indirect/async via `mautic_queue` enqueued in `PatronUser::postSave` (`PatronUser.php:53`); worker `mautic_queue` uses `Mautic\MauticApi` (per `_ar/repo-map/integrations.md:37`). Async, not inline.
  - Elasticsearch — indirect/async via `es_upload_queue` enqueued in `PatronUser::postSave` (`PatronUser.php:52`).
  - Mailing provider (SmartEmailing/Mautic-based `APIMailingService`) — only if a caller invokes `sendActivationEmail`; provider auth from `Settings::get('mailing')` BasicAuth (`APIMailingService.php:43-53`), creds `<redacted>`.
- Failure Modes:
  - Endpoint stub masks failure: `/api/2.3/account/register` always returns 200 `success` regardless of input; it never actually registers (`AccountRegisterResource.php:78-80`). (`Confirmed` — likely dead/legacy endpoint.)
  - `register` swallows all exceptions → returns `FALSE`, only a log line (`AccountService.php:86-89`); caller must null-check (`TransactionService.php:164` guards `$this->currentUser &&`).
  - Entity validation failure (e.g. duplicate `name`/`mail`) → `FALSE`, logged (`AccountService.php:55-62`).
  - WhoisXMLAPI failure/timeout/403 is fail-open: `domainExists` returns `true` on 403, on empty body, and on any exception (`EmailService.php:26-27,35-39`) — so domain validation never blocks registration on API error. (`Confirmed`.)
  - Non-idempotent duplicate risk if a caller skips the `loadByEmail` guard and posts the same email twice → user `name`/`mail` uniqueness violation → `FALSE` (validation), not a crash.
- Integration Calls (external, summary): WhoisXMLAPI (inline via callers), Mautic + Elasticsearch (async via queues), mailing provider (activation, caller-triggered).

## C. Data Footprint
- Entities Written:
  - `user` (Drupal user / `PatronUser`) — created & saved, roles + names + slug + contact back-link (`AccountService.php:41-64,80-81`).
  - `contact` (ContactEntity, bundle `person`) — created & saved when not pre-supplied (`AccountService.php:67-79`); or created in `ensureUser` existing-user branch (`AccountService.php:329-331`).
  - `queue` table rows — `es_upload_queue` + `mautic_queue` items via `postSave` (`PatronUser.php:52-53`; `PatronBaseService.php:421-422`).
  - `email_domain` table — insert/update by domain validation when callers validate (`EmailService.php:56-59,66-71`). (`Partial` — only on the validating call path, not in `register`.)
  - `email` entity + `mailing_queue` — only if `sendActivationEmail` is invoked by the caller (`APIMailingService.php:69-79,89`). (`Partial`.)
- Entities Read:
  - `user` — dedup lookups `AccountService::loadByEmail` / `loadByUuid` (`AccountService.php:240-252`), and `ensureUser` `loadByProperties(['mail'=>...])` (`AccountService.php:311`).
  - `contact` — `findContact` / `getContact` when back-filling (`AccountService.php:261-263`; `PatronUser::getContact`).
  - `email_domain` — SELECT before validate (`EmailService.php:48`).
  - `user.roles` — `hasRole`/`addRole` checks in callers & `ensureUser` (`AccountService.php:317`; `TransactionService.php:164`).
- Constraints involved:
  - User `name` and `mail` are set to the same email; Drupal core user uniqueness on `name`/`mail` enforced via `$user->validate()` (`AccountService.php:54`).
  - Contact `field_name` = `roles[0]` — assumes at least one role present; if `roles` is null/empty this indexes null (`AccountService.php:71`). (`Hypothesis` on downstream impact.)
  - No explicit DB transaction wrapping the multi-save (user→contact→user) — partial writes possible on mid-sequence failure (contact saved but back-link save fails). (`Confirmed` structurally; `AccountService.php:79-81`.)
- Multi-tenant scope assumptions:
  - Single-country-per-instance model: `Settings::get('country')` drives mail-template mapping (`APIMailingService.php:99-134`) and (in the UI sibling flow) GDPR fields. `register` itself is country-agnostic; tenancy is instance-level (CZ/RO/MD separate deployments), not row-level. No org/tenant scoping column on the created user/contact in this path. (`Partial`.)

## D. Evidence Block
- Controller paths:
  - `account/src/Plugin/rest/resource/AccountRegisterResource.php` (`account_register_resource`, `/api/2.3/account/register`, stub `post`).
  - `email/src/Plugin/rest/resource/EmailValidation.php` (`email_validation`, `/api/email_validation`) — companion pre-registration eligibility/email check calling `isEmailValid` + role eligibility (`EmailValidation.php:89-131`).
- Service methods:
  - `account/src/AccountService.php`: `register` (:34), `create` (:93), `ensureUser` (:310), `loadByEmail` (:240), `createSlug` (:221), `sendActivationEmail` (:254), `getUserMagicLink` (:274).
  - `patron_base/src/PatronBaseService.php`: `isEmailValid` (:114), `addToQueue` (:416).
  - `email/src/EmailService.php`: `validateDomain` (:42), `domainExists` (:17, WhoisXMLAPI).
  - `patron_base/src/APIMailingService.php`: `handleMail` (:67), `doHandleMail` (:89), ctor Mautic/BasicAuth (:37-58).
- Repository usage:
  - `entity_type.manager` storage for `user`/`contact` (`AccountService.php:26-27,241,311`).
  - Raw SQL: `email_domain` select/insert/update (`EmailService.php:48,56,67`); `queue` dedup select (`PatronBaseService.php:417`).
- Event listeners:
  - No event is dispatched by `register` directly. Indirect: `PatronUser::postSave` enqueues async work (`PatronUser.php:50-54`). (The application-status event fan-out in FLW0001/FLW0010 belongs to the application, not this user-register path.)
- Async messages:
  - `es_upload_queue` (Elasticsearch upload) and `mautic_queue` (Mautic contact sync) enqueued per user save (`PatronUser.php:52-53`).
  - `mailing_queue` for activation email — only if `APIMailingService::USE_QUEUE` were true; currently `USE_QUEUE = FALSE` so mail is sent synchronously in `doHandleMail` (`APIMailingService.php:16,68-83`). (`Confirmed`.)
- Config evidence:
  - `account/account.services.yml:2-4` — `account` → `Drupal\account\AccountService`.
  - `email/email.services.yml` — `email` → `Drupal\email\EmailService`.
  - `patron_base/patron_base.services.yml:8-12` — `patron_base.smartmailing` → `APIMailingService`, `patron_base.default` → `PatronBaseService`.
  - Callers of the `register` engine (for cross-ref): `transaction/src/TransactionService.php:156`, `transaction/src/Form/TransactionEntityForm.php:63`, `transaction/src/Plugin/rest/resource/v32/TransactionResource.php:147`, voucher resources (`transaction/src/Plugin/rest/resource/*Voucher*.php`), `transaction/src/Form/DivideTransactionForm.php:290`, and `AccountService::ensureUser` (used by the FLW0010 UI self-registration).
