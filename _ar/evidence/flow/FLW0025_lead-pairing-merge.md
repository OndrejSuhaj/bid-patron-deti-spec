# FLW0025 — Lead pairing / merge
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL007 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL007 (dossier FLW0025)
- Flow Name: Lead pairing / merge
- Primary SRV: SRV0001 (Application Lifecycle) — downstream SRV0016 (Search Indexing / ES reindex), SRV0005 (Campaign sync), SRV0018 (Telegram alerting); `application_reaction` fan-out on state change.
- Trigger Evidence: route `application.pairing_form` → `\Drupal\application\Form\PairingForm` at `intake/current-solution/_source/patronus/web/modules/custom/application/application.routing.yml:57-64` (path `/admin/application/form/pairing`, `_permission: 'application pairing'`). Form: `web/modules/custom/application/src/Form/PairingForm.php`. Admin menu item `application.pairing` (title "Sloučení leadu", parent `tools.menu`) at `web/modules/custom/application/application.links.menu.yml:21-27`. Permission declared at `application.permissions.yml:63-64`.
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Coordinator/admin (permission `application pairing`) opens `/admin/application/form/pairing`, enters two Application (Žádost/lead) IDs — "Hlavní lead ZZ (zůstane)" (the surviving main lead, pre-fillable via `?application_main=` query param) and "Lead od Patrona (duplikat)" (the patron-originated duplicate) — and clicks "Sloučit". `Evidence:` `PairingForm::buildForm` (`PairingForm.php:27-54`).
- Preconditions:
  - Both IDs must resolve to existing `ApplicationEntity` records. `Evidence:` `PairingForm::validateForm` (`PairingForm.php:63-75`).
  - The duplicate (`application_pairing`) MUST have a non-empty `patron_profile.target_id`, else validation error "Lead {id} neobsahuje zadost Patrona". `Evidence:` `PairingForm.php:77-79`.
  - Caller holds `application pairing` permission. `Evidence:` route requirement `application.routing.yml:63`.
- Main Steps (ordered):
  1. Load both entities in `submitForm`; if either is NULL, add a messenger message and abort (no exception). `Evidence:` `PairingForm::submitForm` (`PairingForm.php:87-96`).
  2. `updateApplicationMain($main, $pairing)`: set `main.patron_profile = pairing.patron_profile.target_id`; if `pairing.patron.target_id` set, also copy `main.patron = pairing.patron.target_id`; then `main.save()`. `Evidence:` `PairingForm.php:108-121`.
  3. `updateApplicationDuplicate($pairing)`: `pairing.setState('duplicate')`, then NULL out `patron_profile`, `fundraiser_profile`, `fundraiser`, `patron`, `child`; then `pairing.save()`. `Evidence:` `PairingForm.php:133-153`.
  4. On success: messenger "Leads successfully paired" + `logger('leads_pairing')->info(...)` with full form values JSON. `Evidence:` `PairingForm::success` (`PairingForm.php:123-126`).
  - Each `save()` triggers `ApplicationEntity::preSave`/`postSave` heavy work (see Side Effects). `Evidence:` `ApplicationEntity.php:159-226`.
- Postconditions:
  - Main lead now points to the duplicate's `patron_profile` (aprofile) and, conditionally, its `patron` user; main lead state UNCHANGED. `Evidence:` `PairingForm.php:108-115`.
  - Duplicate lead state = `duplicate`, with `patron_profile`/`fundraiser_profile`/`fundraiser`/`patron`/`child` references cleared; a new revision + an `application_states` history row written. `Evidence:` `PairingForm.php:133-145`; `ApplicationEntity::setState` (`ApplicationEntity.php:292-310`) → `insertState` (`:312-327`).
- Side Effects (per `postSave`, fired on BOTH saves): `Evidence:` `ApplicationEntity::postSave` (`ApplicationEntity.php:197-226`):
  1. `patron_base.default->addToQueue('application', id)` → enqueues into `es_upload_queue` (default queue name; Elasticsearch reindex). Deduped by name+data LIKE match. `Evidence:` `PatronBaseService::addToQueue` (`patron_base/src/PatronBaseService.php:416-426`); service map `patron_base.services.yml:12-14`.
  2. `dispatchStatusUpdateEvent()` → `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` fired unconditionally on every save. `Evidence:` `ApplicationEntity.php:202,228-231`. Subscribers:
     - `application_reaction` subscriber: runs `application_reaction->execute()` + `cancelSessions()` ONLY when `isApplicationModified()` (state changed vs original OR new). → Fires for the **duplicate** save (state new→`duplicate`), does NOT fire for the **main** save (state unchanged). `Evidence:` `application_reaction/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:47-56,62-75`; `cancelSessions` (`:82-92`) deactivates sessions if new state is in `patron_base.application_statuses.invalidate_sessions` config.
     - `scoring` subscriber: acts only when new state === `to_check`; `duplicate` does not match → no-op. `Evidence:` `scoring/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:66-74`.
     - `notification` subscriber: early-returns unless `feature_digital_signature` enabled and state contains `waiting_signature`; `duplicate` does not match → no-op. `Evidence:` `notification/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:54-66`.
  3. Campaign sync: if `main`/`pairing` has a `campaign.target_id`, `updateCampaignStatus()` + `updateCampaignCategory()` run; a mismatch triggers a Telegram (severity 3) alert. Neither pairing entity is expected to carry a campaign at merge time, so usually inert. `Evidence:` `ApplicationEntity.php:206-220`.
  4. `resetCache([id])` on application storage. `Evidence:` `ApplicationEntity.php:221`.
- Integration Calls:
  - Elasticsearch reindex (async, via queue `es_upload_queue`). `Evidence:` `addToQueue` default name (`PatronBaseService.php:416`); [../../repo-map/integrations.md](../../repo-map/integrations.md).
  - Telegram alerting (`logger.telegram`) — only on campaign/state sync mismatch or queue-insert failure; not on the normal path. `Evidence:` `ApplicationEntity.php:217`, `PatronBaseService.php:424`.
  - No direct payment/bank/CRM (Mautic) call in the pairing code path itself; Mautic/notification effects are gated by subscriber conditions that `duplicate` does not satisfy.
- Failure Modes:
  1. **No transaction wrapping the two saves.** `updateApplicationMain` saves the main lead first; if `updateApplicationDuplicate` (or its `save()`/`insertState`) throws, the main lead is ALREADY mutated (patron_profile reassigned) while the duplicate is not demoted → half-merged inconsistent state. `catch` only logs + shows a generic "Some error executed" message; no rollback. `Evidence:` `PairingForm::submitForm` (`PairingForm.php:98-106`), `error()` (`:128-131`). Tag: Data Loss / Idempotence.
  2. **Silent data loss on the main lead:** `updateApplicationMain` OVERWRITES `main.patron_profile` with the duplicate's value without preserving any pre-existing `patron_profile` on the main lead. If the main lead already had a patron profile, that reference is silently dropped (orphaned aprofile). `Evidence:` `PairingForm.php:109`.
  3. **Unmerged duplicate data is orphaned:** the merge copies ONLY `patron_profile` and (conditional) `patron` from the duplicate. The duplicate's `fundraiser_profile`, `fundraiser`, `child`, contact links, scoring, story, transactions, contracts are NOT carried to the main lead; then those references are NULLed on the duplicate (`PairingForm.php:137-143`). Any such data becomes unreachable via the merged lead. `Evidence:` `updateApplicationMain` (`:108-121`) vs `updateApplicationDuplicate` (`:133-145`). Tag: Data Loss.
  4. **Validation gap / NULL deref:** `validateForm` calls `$application_pairing->get('patron_profile')` after a null re-check, but if `application_main` fails to load, `submitForm` still guards with a messenger message + early return (no exception). Partial defensive coverage. `Evidence:` `PairingForm.php:63-79,87-96`.
  5. **`application_states` insert failure** during `setState('duplicate')` throws (re-raised after Telegram log) → propagates to the `submitForm` catch → generic error, main lead already saved. `Evidence:` `insertState` (`ApplicationEntity.php:317-325`).
  6. **No idempotence guard**: re-submitting the same pair after a successful merge fails validation because the (now-duplicate) lead's `patron_profile` was NULLed → "neobsahuje zadost Patrona". Accidental protection, not by design. `Evidence:` `PairingForm.php:77-79` + `:137`.
  7. Non-production only: `dbg()` debug output emitted when `Settings::get('environment') !== 'production'`. `Evidence:` `PairingForm.php:117-120,147-152`; `dbg()` in `patron_base.module:42`.

## C. Data Footprint
- Entities Written:
  - `application` (`ApplicationEntity`) — main lead: `patron_profile` (+ conditional `patron`) reassigned; new revision via `save()`. `Evidence:` `PairingForm.php:109-115`.
  - `application` — duplicate lead: `state`/`moderation_state` → `duplicate`, `patron_profile`/`fundraiser_profile`/`fundraiser`/`patron`/`child` → NULL; new revision. `Evidence:` `PairingForm.php:133-145`; `setState` (`ApplicationEntity.php:292-310`).
  - `application_states` (raw audit side-table) — one row (application_id, state=`duplicate`, uid, note, changed) inserted for the duplicate. `Evidence:` `insertState` (`ApplicationEntity.php:312-327`); [../db-models.md](../db-models.md) §application_states.
  - `queue` (`es_upload_queue`) — up to two enqueue items (one per saved application), deduped. `Evidence:` `addToQueue` (`PatronBaseService.php:416-426`).
  - `application_revision` / `application_field_revision` — new revision rows from each `save()` (revisionable entity). `Evidence:` [../db-models.md](../db-models.md) §application.
  - Conditional (only if state-change subscriber path applies to duplicate): `application_log` row + session deactivation (`application_session`) via `cancelSessions()`. `Evidence:` `application_reaction/.../ApplicationStatusUpdateSubscriber.php:82-105`.
- Entities Read:
  - `application` (both leads loaded via `ApplicationEntity::load`). `Evidence:` `PairingForm.php:63-72,87-88`.
  - `aprofile` (patron_profile / fundraiser_profile referenced entities) — read via target_id, not loaded fully. `Evidence:` `PairingForm.php:77,109`.
  - `queue` table (dedupe SELECT). `Evidence:` `PatronBaseService.php:417`.
  - config `patron_base.application_statuses.invalidate_sessions` (only in reaction path). `Evidence:` `application_reaction/.../ApplicationStatusUpdateSubscriber.php:84`.
- Constraints involved:
  - `application` indexes `application_lead_contact_created`, `application_created` (unaffected by merge, but `lead_contact` is NOT re-linked during merge — potential stale lead_contact on the surviving lead). `Evidence:` [../db-models.md](../db-models.md) §application constraints.
  - `state` allowed_values must include `duplicate` (list_string from `getAllStates()`/`application_states.yml`). `Evidence:` [../db-models.md](../db-models.md) `state` row; `ApplicationEntity::setState` (`:294-295`).
  - No FK/unique constraint enforcing that the two merged leads are distinct, same-region, or same-campaign. `Evidence:` absence in `PairingForm.php` (numeric inputs only).
- Multi-tenant scope assumptions:
  - Form accepts any two numeric application IDs; NO region (CZ/RO/MD) or tenant scoping/check that both leads belong to the same market. `Hypothesis` — cross-region merge is not prevented in code; no tenant column exists on `application` per [../db-models.md](../db-models.md). Tag: Multi-tenant.
  - Actor scoping is by Drupal permission `application pairing` only (roles coordinator/senior_coordinator/risk_manager/manager/front carry role configs referencing pairing). `Evidence:` `application.permissions.yml:63-64`; role configs under `config/user.role.*.yml`.

## D. Evidence Block
- Controller paths: form-based route (no controller) — `\Drupal\application\Form\PairingForm` via `_form` in `application.routing.yml:57-64`; source `web/modules/custom/application/src/Form/PairingForm.php`.
- Service methods:
  - `PairingForm::updateApplicationMain` (`PairingForm.php:108-121`), `PairingForm::updateApplicationDuplicate` (`:133-153`), `PairingForm::success`/`error` (`:123-131`).
  - `ApplicationEntity::setState` / `insertState` (`ApplicationEntity.php:292-327`), `preSave` (`:159-192`), `postSave` (`:197-226`), `dispatchStatusUpdateEvent` (`:228-231`).
  - `PatronBaseService::addToQueue` (`patron_base/src/PatronBaseService.php:416-426`), service `patron_base.default` (`patron_base.services.yml:12-14`).
- Repository usage: direct entity API (`ApplicationEntity::load`, `->set()`, `->save()`); raw SQL for `application_states` insert (`ApplicationEntity.php:318-321`) and `queue` dedupe SELECT (`PatronBaseService.php:417`); `entityTypeManager()->getStorage('application')->resetCache()` (`ApplicationEntity.php:221`).
- Event listeners (all on `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT`, fired by both saves):
  - `application_reaction/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php` — active for duplicate save (state changed).
  - `scoring/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php` — inactive (`to_check` only).
  - `notification/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php` — inactive (feature-flag + `waiting_signature` only).
  - Cross-ref: FLW0001 (application-status-event-fanout) and FLW0002 (status-change-workflow) document this event's full fan-out.
- Async messages: `es_upload_queue` items `{id, entity_type:'application'}` processed by patron_base queue workers (ES reindex). `Evidence:` `PatronBaseService::addToQueue` (`:416-426`); [../../repo-map/integrations.md](../../repo-map/integrations.md).
- Config evidence: route `application.routing.yml:57-64`; menu `application.links.menu.yml:21-27`; permission `application.permissions.yml:63-64`; role grants `config/user.role.{coordinator,senior_coordinator,risk_manager,front,manager}.yml`; session-invalidation config `patron_base.application_statuses.invalidate_sessions` (consulted only in reaction path).
