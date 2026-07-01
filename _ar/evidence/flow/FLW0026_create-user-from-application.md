# FLW0026 — Create user from application
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL008 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL008 (dossier FLW0026)
- Flow Name: Create user from application
- Primary SRV: SRV0015
- Trigger Evidence: route `application.create_user_controller_create` `/admin/application/{application}/create_user` → `application/src/Controller/CreateUserController.php:createUser` (`web/modules/custom/application/application.routing.yml:148-154`; `_permission: 'add leads'`)
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Admin/staff GET on `/admin/application/{application}/create_user` with query params `?user_role={fundraiser|patron|child}&application_profile={aprofile_id}`. Route `_permission: 'add leads'` (`application.routing.yml:154`). Handler `CreateUserController::createUser` (`CreateUserController.php:73`).
- Preconditions:
  - `ApplicationEntity::load($application)` and `ApplicationProfileEntity::load($application_profile)` both non-null AND `user_role` query param non-empty (`CreateUserController.php:74-86`); otherwise a Czech error message is shown ("Chybi id zadosti, profilu, nebo user_type…") and no writes occur.
  - `user_role` must be one of `fundraiser` / `patron` / `child` (`CreateUserController.php:94-100`); any other value silently does nothing except the final redirect.
- Main Steps:
  1. Load `ApplicationEntity` + `ApplicationProfileEntity`, read `user_role` (`CreateUserController.php:74-77`).
  2. Branch by role: `createFundraiser()` / `createPatron()` / `createChild()` (`CreateUserController.php:94-100`).
  3. **fundraiser/patron branch** — pull personal data from the application profile (`fundraiser_*` / `patron_*` fields) (`CreateUserController.php:107-116, 166-169`); `AccountService::loadByEmail($email)` (`AccountService.php:240-243`).
     - If no existing user: create `ContactEntity` (`type=person`, email/name/last_name/phone; fundraiser also street/city/zip/rc) and `save()` (`CreateUserController.php:127-139, 181-188`); then `AccountService::register([...roles=[role], contact=<id>])` (`AccountService.php:34-90`).
     - `register()` builds a `User` (`mail=name=email`, first/last name, generated `slug` via `createSlug`, roles, contact ref) (`AccountService.php:41-49`), runs `$user->validate()` (returns FALSE + logs to `account.register` on violations) (`AccountService.php:54-62`), then `$user->save()` (`AccountService.php:64`). Since `contact` is passed, the fallback contact-creation branch is skipped (`AccountService.php:66-82`).
  4. **child branch** — resolve child by `rc` via `patron_base.default->getStorage('contact')->loadByProperties(['rc'=>…])` (`CreateUserController.php:219-220`); if none, create `ContactEntity` (`field_name=child`, name/last_name/rc/street/city/zip) and `save()` (`CreateUserController.php:225-235`). No `User` is created for children.
  5. City strings are resolved to taxonomy terms via `getTermId()` which **creates** a `city` `taxonomy_term` if it does not exist (`CreateUserController.php:265-285`).
  6. Link result back to the application: fundraiser→`application.fundraiser`(user id), patron→`application.patron`(user id), child→`application.child`(contact id); each with `setNewRevision(FALSE)` then `$this->application->save()` (`CreateUserController.php:156-158, 204-206, 241-243`).
  7. Redirect to `/admin/application/{id}` (`CreateUserController.php:102`).
- Postconditions:
  - A `user` (patron/fundraiser) with the requested role + linked `contact` exists, OR an existing user was found and reused (no user for child).
  - The `ApplicationEntity` has its `fundraiser`/`patron` (user) or `child` (contact) reference set (revision suppressed via `setNewRevision(FALSE)`).
  - Possibly a new `city` taxonomy_term.
- Side Effects (cascading, via entity save hooks — not visible in the controller):
  - **User save → `PatronUser::postSave`** (`account/src/PatronUser.php:50-54`): enqueues the new user into `es_upload_queue` (Elasticsearch/App Search indexing) AND `mautic_queue` (Mautic CRM sync) via `patron_base.default->addToQueue()` (`patron_base/src/PatronBaseService.php:416-426`, writes rows to the Drupal `queue` DB table; dedups; logs to Telegram on `createItem` failure).
  - **User insert → `account_user_insert` hook** (`account/account.module:38-42`): dispatches `UserUpdateEvent::USER_UPDATE_EVENT` — **no subscribers found** in custom code (dispatched-but-unhandled; effectively inert). `patron_base_user_insert` (`patron_base/patron_base.module:32-40`) only acts on display names starting `patron_`, so it is a no-op here (name is the email).
  - **Application save → `ApplicationEntity::postSave`** (`application/src/Entity/ApplicationEntity.php:197-226`), which unconditionally: (a) enqueues the application into `es_upload_queue`; (b) `dispatchStatusUpdateEvent()` fires `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` (`:228-231`) → 3 subscribers (`notification`, `scoring`, `application_reaction`) run their guards; (c) campaign status/category sync if a campaign is attached; (d) inserts an `application_states` audit row only if status=='new' and none exists. Because this flow does NOT change status, the notification subscriber's transition guards (`original->getState()` comparisons, `notification/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:64-118`) are mostly not satisfied → typically no mail sent, but the full event chain still executes.
  - Contact save has **no** ES/Mautic queueing (`contact/src/Entity/ContactEntity.php` has only `preSave`, no `postSave`).
  - User-visible Drupal messages (Czech) at each step.
- Integration Calls: **None invoked synchronously by this flow.** Downstream integrations (Elasticsearch, Mautic) occur only when the enqueued `es_upload_queue` / `mautic_queue` items are later processed by their queue workers (SRV0016 / SRV0014).
- Failure Modes:
  - Missing/invalid application, application_profile, or user_role → Czech error message, `#markup:'ups'`, no writes (`CreateUserController.php:80-86`).
  - `AccountService::register` catches all exceptions and returns FALSE, logging to `account.register` (`AccountService.php:86-89`); validation violations also return FALSE + log (`:54-62`). On FALSE, the controller's `if($user)` guard skips the application update (`CreateUserController.php:155,203`) — contact is already saved but never linked (orphaned contact) → **partial-write / data-integrity risk**.
  - **Existing-user detection is inconsistent between branches** (potential bug): fundraiser uses `if (!$user)` (`CreateUserController.php:124`) while patron uses `if ($user === false)` (`CreateUserController.php:178`). `loadByEmail` returns `FALSE` when absent (`AccountService.php:242`), so both paths work for the absent case; but any truthy-but-non-User return would diverge. Recorded as `Hypothesis` (no runtime evidence of divergence). `Conflict — requires clarification.`
  - No CSRF token / write-guard on this GET route beyond `_permission: 'add leads'` (state-changing GET). Recorded as current-state security observation.
  - No DB transaction wraps contact→user→application; a mid-sequence failure leaves partial state.
- **START-hint correction (Conflict):** the mining hint said "may send activation/magic-link". This controller path does **NOT** call `AccountService::sendActivationEmail` or `getUserMagicLink`. Grep of all callers (`sendActivationEmail` at `AccountService.php:254`) shows activation mail is sent from *other* flows only — `application/src/Form/UserCreateForm.php:212`, `ApplicationPOSTResource` v30/v32 (`:545-547` / `:639-641`), transaction, organisation, and the send-activation REST/CLI endpoints — never from `CreateUserController`. Newly created users are therefore **blocked / password-less** until a separate activation/magic-link flow runs (`getUserMagicLink` activates+password-sets a blocked user, `AccountService.php:274-285`).

## C. Data Footprint
- Entities Written:
  - `user` (`web/modules/custom/account`, base_table `users`/`users_field_data`; class `Drupal\account\PatronUser`) — created for role fundraiser/patron when email is new. Custom base fields set: `first_name`, `last_name`, `slug`, `roles`, `contact` (`account/account.module:73-` base fields; `AccountService.php:41-49`).
  - `contact` (`web/modules/custom/contact`, base_table `contact`, revisionable) — created for fundraiser/patron (when new) and for child (keyed by `rc`). Fields: `type`, `email`, `name`, `last_name`, `phone`, `street`, `city`(→taxonomy_term), `zip`, `rc`, `field_name`.
  - `application` (base_table `application`, revisionable — revision suppressed here) — sets one of `fundraiser`(→user), `patron`(→user), `child`(→contact) (`ApplicationEntity.php:629-648`).
  - `taxonomy_term` (vid `city`) — created on demand by `getTermId` (`CreateUserController.php:277-283`).
  - `queue` (Drupal DB table) — `es_upload_queue` + `mautic_queue` items for the new user; `es_upload_queue` item for the application (`PatronBaseService.php:416-426`).
  - `application_states` (raw audit table) — a row **only** if application status=='new' with no prior state (`ApplicationEntity.php:222-224`).
  - `watchdog`/logger — on validation/exception (`account.register`), and Telegram on queue-insert failure.
- Entities Read:
  - `application` (`ApplicationEntity::load`), `aprofile` (`ApplicationProfileEntity::load`) — profile fields `fundraiser_*` / `patron_*` / `child_*` read (`CreateUserController.php:107-116, 166-169, 212-233`).
  - `user` (`loadByProperties(['mail'=>…])` in `loadByEmail`, `AccountService.php:241`).
  - `contact` (`loadByProperties(['rc'=>…])` for child, `CreateUserController.php:219`).
  - `taxonomy_term` (`loadByProperties(name,vid)` in `getTermId`, `CreateUserController.php:269-274`).
- Constraints involved:
  - `application` field target types: `fundraiser`/`patron`→`user`, `child`→`contact` (`db-models.md` application section; `ApplicationEntity.php:629-648`). Assigning the wrong-typed id would violate the entity_reference target.
  - User validation via `$user->validate()` (Drupal user name/mail uniqueness etc.) — `mail` and `name` both set to the email; duplicate email would surface as a violation (guarded upstream by `loadByEmail`).
  - Child identity keyed by `rc` (rodné číslo); child contact reused if `rc` matches (`CreateUserController.php:219-223`).
  - `contact.city` is an entity_reference to `taxonomy_term` (`getTermId` returns a term id).
- Multi-tenant scope assumptions:
  - No explicit CZ/RO/MD tenant filter in this flow. Patronus is single-instance, multi-country via URL path-prefix (`integrations.md §10`); the profile-language / country is implicit in the application/profile data, not enforced here. `Hypothesis` — no country guard on user/contact creation.

## D. Evidence Block
- Controller paths:
  - `web/modules/custom/application/src/Controller/CreateUserController.php` — `createUser` (`:73`), `createFundraiser` (`:106`), `createPatron` (`:165`), `createChild` (`:211`), `removeChild` (`:248`), `getTermId` (`:265`).
  - Route: `web/modules/custom/application/application.routing.yml:148-162`.
- Service methods:
  - `web/modules/custom/account/src/AccountService.php` — `register` (`:34-90`), `loadByEmail` (`:240-243`), `createSlug` (`:221-234`), `sendActivationEmail` (`:254-259`, NOT used here), `getUserMagicLink` (`:274-285`), `ensureUser` (`:310-344`, NOT used here). Service id `account` (`CreateUserController.php:62`).
  - `web/modules/custom/patron_base/src/PatronBaseService.php` — `addToQueue` (`:416-426`), service id `patron_base.default`.
- Repository usage:
  - `\Drupal::entityTypeManager()->getStorage('user'|'taxonomy_term')->loadByProperties(...)` (`AccountService.php:241`; `CreateUserController.php:269-274`).
  - `\Drupal::service('patron_base.default')->getStorage('contact')->loadByProperties(...)` (`CreateUserController.php:219`).
  - `ApplicationEntity::load`, `ApplicationProfileEntity::load`, `ContactEntity::create/save`, `Term::create/save`.
- Event listeners:
  - `account_user_insert` → `UserUpdateEvent::USER_UPDATE_EVENT` (`account/account.module:38-42`; constant `account/src/Event/UserUpdateEvent.php:13`) — **no subscribers in custom code**.
  - `ApplicationEntity::postSave` → `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` (`ApplicationEntity.php:202,228-231`); subscribers: `notification/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php`, `scoring/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php`, `application_reaction/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php` (transition-guarded; see FL005).
- Async messages:
  - `es_upload_queue` (user + application) and `mautic_queue` (user) enqueued via `addToQueue` (`PatronUser.php:52-53`, `ApplicationEntity.php:199`, `PatronBaseService.php:416-426`). Workers processed later (SRV0016 Elasticsearch/App Search; SRV0014 Mautic).
- Config evidence:
  - Permission `add leads` (`application.routing.yml:154`; defined in `application`/`patron_base` permissions).
  - User class override `Drupal\account\PatronUser` via `account_entity_type_build` (`account/account.module:30-34`); custom user base fields via `account_entity_base_field_info` (`account/account.module`).
