# FLW0010 — Fundraiser/Patron self-registration
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL001 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL001 (dossier FLW0010)
- Flow Name: Fundraiser/Patron self-registration
- Primary SRV: SRV0001
- Trigger Evidence: route `application.user.create` → `/application/start/{role<fill|apply>}` (`application/application.routing.yml:227`), form `\Drupal\application\Form\UserCreateForm::submitForm` (`application/src/Form/UserCreateForm.php:197`). Sibling trigger `application.application.start` → `/application/{role}` (`application.routing.yml:220`) dispatches via `ApplicationHelperController::redirectToForm` (`application/src/Controller/ApplicationHelperController.php:59`).
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Anonymous visitor hits `/application/{fill|apply}`. `ApplicationHelperController::redirectToForm` (`ApplicationHelperController.php:59`) checks `currentUser()->isAnonymous()`; anonymous → redirect to `application.user.create` (`UserCreateForm`); `fill`→fundraiser, `apply`→patron (mapping `UserCreateForm::getRole` `UserCreateForm.php:226`).
- Preconditions: Route `application.user.create` requires `_user_is_logged_in: 'FALSE'` (`application.routing.yml:232`) — logged-in users are blocked here and are instead handled inline by `redirectToForm` (which creates the application directly, `ApplicationHelperController.php:95`). Country is read from `Settings::get('country','ro')` and drives GDPR/consent fields (`UserCreateForm.php:93`).
- Main Steps:
  1. Build minimal form: email + phone (+ per-country GDPR/regulations checkboxes) — `UserCreateForm::buildForm` (`UserCreateForm.php:91`); phone restricted to the configured country (`UserCreateForm.php:117`).
  2. Validate email format AND domain, plus CZ GDPR consent — `UserCreateForm::validateForm` (`UserCreateForm.php:181`) → `PatronBaseService::isEmailValid` (`patron_base/src/PatronBaseService.php:114`) → `email` service `EmailService::validateDomain` (`email/src/EmailService.php:42`, WhoisXMLAPI call at `EmailService.php:18`).
  3. Look up existing user by mail — `UserCreateForm::submitForm` (`UserCreateForm.php:200`).
  4. Ensure a user exists with the requested role + linked contact — `AccountService::ensureUser` (`account/src/AccountService.php:310`). New user branch → `AccountService::register` (`AccountService.php:34`) creates `user` (+ slug, role) and a `contact` (`AccountService.php:64,67-81`). Existing user branch adds missing role / creates missing contact (`AccountService.php:317-336`).
  5. Only for a brand-new user: build+save a stub Application — `UserCreateForm::createApplication` (`UserCreateForm.php:245`) with `state='new'`, `moderation_state='new'`, `lead_source='zone'`, `lead_role=role`, `lead_contact=user->contact`, `{role}=user->id()`; `$application->save()` (`UserCreateForm.php:205`).
  6. On save, entity hooks fire (see Side Effects) — `ApplicationEntity::postCreate` (`application/src/Entity/ApplicationEntity.php:96`) + `postSave` (`ApplicationEntity.php:197`).
  7. Send activation magic-link email — `AccountService::sendActivationEmail` (`AccountService.php:254`) using template `activation_{role}`; destination = the role-specific application form URL for new users (`UserCreateForm.php:206-207`) or `/account` for existing users (`UserCreateForm.php:210`).
  8. Store email in session, redirect to `/application/result` — `UserCreateForm.php:213-214`; result page rendered by `ApplicationHelperController::result` (`ApplicationHelperController.php:152`).
- Postconditions: A `user` (role fundraiser|patron), a linked `contact`, and — for new users only — an `application` in state `new` with two `application_session` rows (patron+fundraiser) exist. An `application_states` audit row `new` is inserted (`ApplicationEntity.php:222-224`). An `email` archive row is written and a magic-link activation mail is dispatched.
- Side Effects:
  - `application_session` ×2 created in `ApplicationEntity::postCreate` → `createPatronSession`/`createFundraiserSession` (`ApplicationEntity.php:100-123`); interface computed by `getPatronInterface`/`getFundraiserInterface` (`ApplicationEntity.php:125-148`) — for self-registration `lead_role==role` so that role's session interface = `default`, the other = `invited`.
  - Search-index enqueue: `PatronBaseService::addToQueue('application', id, 'es_upload_queue')` in `postSave` (`ApplicationEntity.php:199`; `patron_base/src/PatronBaseService.php:416`) — dedup via raw `queue` table LIKE query (`PatronBaseService.php:417`).
  - Status-update event dispatched: `ApplicationEntity::dispatchStatusUpdateEvent` (`ApplicationEntity.php:202,228`) → `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` (3 subscribers: notification, scoring, application_reaction — see FLW/FL005). Fires on EVERY save incl. this `new` creation.
  - `application_states` audit insert for `new` on first save (`ApplicationEntity.php:222-224`, raw SQL `insertState` `ApplicationEntity.php:312`).
  - Entity cache reset (`ApplicationEntity.php:221`).
  - Email archive row (`email` entity) written in `APIMailingService::doHandleMail` (`patron_base/src/APIMailingService.php:217-230`).
  - Magic-link generation may mutate the user: `AccountService::getUserMagicLink` activates a blocked user and resets its password (`AccountService.php:274-279`).
  - SmartMailing/Mautic contact upsert on send (production/allowlist only) — `APIMailingService.php:246-251`.
- Integration Calls:
  - WhoisXMLAPI domain-availability check during validation — `EmailService::validateDomain` → `EmailService.php:18` (`https://domain-availability.whoisxmlapi.com/api/v1`, apiKey hardcoded `<redacted>`).
  - SmartMailing transactional-email API (`activation_{role}` template) — `APIMailingService::doHandleMail` → `contactApi->create` + `emailApi->sendToContact` (`APIMailingService.php:246-251`); gated by `Settings::get('environment')==='production'` or `isEmailAllowed()` (`APIMailingService.php:233`).
  - Elasticsearch/App Search indexing is deferred (queue only; actual ES call is FLW/FL055).
- Failure Modes:
  - Email domain check hard-fails registration if WhoisXMLAPI is down/returns non-MX: `validateDomain` catches exceptions and logs, returning implicitly (`EmailService.php:36`) — a failed lookup can block a legitimate signup (availability of an external service gates registration). `Partial`.
  - `AccountService::register` swallows all exceptions and returns `FALSE` (`AccountService.php:86-89`); `submitForm` does not check the return of `ensureUser`, so a failed user creation still proceeds to `createApplication($user)` / `sendActivationEmail($user)` with a falsy `$user` → fatal/`Hypothesis` (unguarded).
  - `insertState` raw INSERT into `application_states` can throw and is re-thrown after Telegram alert (`ApplicationEntity.php:322-325`) — a DB error here aborts the save.
  - No idempotence on the user side beyond email uniqueness: repeated submits for an existing email do NOT create a new application (guarded by `empty($existing)` `UserCreateForm.php:203`) but DO re-send an activation email each time and may add roles/contact.
  - Application stub is created with no aprofile/child yet — the actual applicant data (`aprofile`) is filled later via `/application/{application}/form/{role}` (FL002), so an abandoned registration leaves a bare `new` lead + 2 sessions + user + contact.

## C. Data Footprint
- Entities Written:
  - `user` — created/updated; role fundraiser|patron added; fields mail, name, slug, first_name/last_name, contact (`AccountService.php:41-64`, `:317-336`); possibly reactivated + password reset via magic link (`AccountService.php:274-279`).
  - `contact` — created (type=person, field_name=role, email, phone, name/last_name) `AccountService.php:67-81` / `:329`.
  - `application` — created; fields state=`new`, moderation_state=`new`, lead_source=`zone`, lead_role, lead_contact, {role}=uid (`UserCreateForm.php:245-256`); user_id defaulted to current (anon uid 0) in `preCreate` (`ApplicationEntity.php:89-93`).
  - `application_session` ×2 — role patron + fundraiser, application_uuid, interface (`ApplicationEntity.php:107-123`).
  - `application_states` (raw side table) — one `new` row (application_id, state, uid, note, changed) `ApplicationEntity.php:319`.
  - `email` — one archive row per activation mail (`APIMailingService.php:217-230`).
  - `queue` (raw) — one `es_upload_queue` item (`PatronBaseService.php:421`).
- Entities Read:
  - `user` (loadByProperties mail) `UserCreateForm.php:200`, `AccountService.php:311`.
  - `contact` (via `$user->contact`) `AccountService.php:326`, `UserCreateForm.php:247`.
  - `system.site` config (mail) and `Settings` (`country`, `environment`, hash salt) — `UserCreateForm.php:93,140`, `APIMailingService.php:99,233`, `AccountService.php:292`.
  - `application` existence query (authenticated branch only) `ApplicationHelperController.php:69-73`.
- Constraints involved:
  - `contact` composite index `contact_email_phone_field_name_type` (email, phone, field_name, type) — non-unique; phone unique=NO (db-models `contact`). No DB uniqueness protects against duplicate contacts; dedup is app-level.
  - `application_session` composite non-unique index over (session_id, application_uuid, role, status); `application_uuid` is a plain string, NOT an FK to `application` (db-models `application_session`).
  - `application` indexes `application_lead_contact_created`, `application_created` (StorageSchema). `moderation_state`/published `status` keys are referenced but not declared as base fields (`Conflict — requires clarification`, db-models `application`).
  - User email uniqueness = Drupal `user.mail` (framework) — the only real uniqueness gate in this flow.
  - `application_states.application_id` is a soft-FK (raw table, no declared FK).
- Multi-tenant scope assumptions: Single Drupal instance; country from `Settings::get('country')` gates form fields (CZ GDPR checkbox / RO GDPR+regulations required) and phone country, and later selects the SmartMailing template-ID set (`APIMailingService.php:99-166`). No per-country DB partition; MD/RO/CZ share the same tables. `activation_{role}` template exists for CZ/RO; MD template map (`APIMailingService.php:100-105`) does NOT define `activation_fundraiser|patron|supporter` → MD activation email likely silently unmapped (`Hypothesis`).

## D. Evidence Block
- Controller paths:
  - `application/src/Controller/ApplicationHelperController.php` — `redirectToForm` (`:59`), `result` (`:152`), `thankYou` (`:131`).
  - `application/src/Controller/ApplicationFormController.php` — serves the follow-on aprofile forms (FL002), out of scope here.
  - `application/src/Controller/CreateUserController.php` — admin-side `create_user` (`/admin/application/{application}/create_user`, FL008) — distinct from this self-registration path.
- Service methods:
  - `account/src/AccountService.php` — `ensureUser` (`:310`), `register` (`:34`), `create` (`:93`), `sendActivationEmail` (`:254`), `getUserMagicLink` (`:274`), `userPassRehashMultiuse` (`:290`).
  - `patron_base/src/PatronBaseService.php` — `isEmailValid` (`:114`), `addToQueue` (`:416`).
  - `patron_base/src/APIMailingService.php` — `handleMail` (`:67`), `doHandleMail` (`:89`), `EmailEntity::create` (`:217`), `USE_QUEUE = FALSE` (`:16`).
  - `email/src/EmailService.php` — `validateDomain` (`:42`), WhoisXML URL (`:18`).
- Repository usage:
  - Entity storage via `entity_type.manager` for user/application (`UserCreateForm.php:200,255`).
  - Raw SQL: `application_states` INSERT (`ApplicationEntity.php:319`), `application_states` existence SELECT (`ApplicationEntity.php:222-223`), `queue` dedup SELECT (`PatronBaseService.php:417`).
- Event listeners:
  - `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` subscribers: `notification/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php` (`updateApplicationStatus` `:54`), `scoring/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php`, `application_reaction/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php` — dispatched from `ApplicationEntity.php:230`.
- Async messages:
  - `es_upload_queue` item enqueued in `postSave` (`PatronBaseService.php:421`); worker is patron_search (FL055).
  - Mail is synchronous: `APIMailingService::USE_QUEUE = FALSE` (`APIMailingService.php:16`) → `doHandleMail` runs inline (`APIMailingService.php:82`); the `mailing_queue` branch is dead here.
- Config evidence:
  - `application/application.routing.yml` — `application.user.create` (`:227`, `_user_is_logged_in: FALSE`), `application.application.start` (`:220`), `application.application.fundraiser|patron` (`:197,213`), `application.user.create_result` (`:238`).
  - `application/application.services.yml` — `application` service, `application.form_controller`, role/status access checks, `application.uuid.paramconverter`.
  - `account/account.routing.yml` — `account.login` `/magic-link/{base64hash}` (`:14`) = magic-link landing target (FL012).
  - `application/application_states.yml` — allowed application states incl. `new`.
