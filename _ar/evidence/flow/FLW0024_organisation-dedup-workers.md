# FLW0024 — Organisation de-dup + worker management
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL053 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL053 (dossier FLW0024)
- Flow Name: Organisation de-dup + worker management
- Primary SRV: SRV0012
- Trigger Evidence: three co-located triggers in the `organisation` module (repo paths under `PSRC/ = intake/current-solution/_source/patronus/`):
  - De-dup UI form: route `organisation.remove_organisation_duplicates_form` → `PSRC/web/modules/custom/organisation/organisation.routing.yml` (path `/admin/organisation/remove_duplicates`) → `\Drupal\organisation\Form\OrganisationRemoveDuplicatesForm::submitForm`.
  - Worker mgmt UI forms: routes `organisation.workers.add_form` (path `/admin/organisation/{organisation}/worker/add`) and `organisation.workers.edit_form` (path `/admin/organisation/{organisation}/worker/{user}/edit`) → `_entity_form: user.organisation_worker` bound to `\Drupal\organisation\Form\OrganisationWorkerForm` via `organisation.module:organisation_entity_type_alter()`; listing route `organisation.workers_list` → `OrganisationWorkersListController::getList`.
  - Daily Elasticsearch sync: `organisation.module:organisation_cron()` → `\Drupal\organisation\OrganisationCron::execute()`.
- Confidence Level: Confirmed
- START-hint corrections (Conflict, minor):
  - Worker route segment is singular `worker/…` not `workers/add|{user}/edit` (see `organisation.routing.yml`). `Confirmed`.
  - The cron does NOT sync to a local `elasticsearch:9200` index. `OrganisationCron::sendToElastic()` posts to a hardcoded **Elastic Cloud** endpoint `https://my-deployment.es.eu-central-1.aws.cloud.es.io:9243/organisations/_doc/{id}` with `ELASTIC_USERNAME`/`ELASTIC_PASS` from `$_ENV` (`OrganisationCron.php:24-38`). This is distinct from the `patron_search` full-text index and from the `elasticsearch` audit-log module noted in [../../repo-map/integrations.md](../../repo-map/integrations.md). `Confirmed`.

## B. Behavior Digest
- Trigger: back-office staff action on three admin surfaces (de-dup merge form, worker add/edit form), plus Drupal `hook_cron` daily push to Elastic Cloud.
- Preconditions:
  - De-dup form: `_permission: 'edit application profile entities'` (`organisation.routing.yml`) — note this is an **application-profile** permission gating an **organisation** merge (Conflict/odd coupling, `Partial` on intent).
  - Worker add/list: `_permission: 'view published organisation entity entities'`; worker edit: `_permission: 'edit organisation entity entities'`.
  - Cron: state `organisation_cron_time` must be set and older than +1 day; env `ELASTIC_USERNAME` and `ELASTIC_PASS` must be present or `sendToElastic` returns early (`OrganisationCron.php:28-30`).
- Main Steps:
  - **De-dup (merge)** — `OrganisationRemoveDuplicatesForm`:
    1. `buildForm` lists organisations via raw SQL `SELECT id, name FROM organisation …` (name filter `LIKE :name`, else `limit 300`) (`OrganisationRemoveDuplicatesForm.php:29,31`); renders inline `<button name='main_organisation'>` + `<input name='duplicate_organisations[]'>` checkboxes as raw markup.
    2. `submitForm` reads `main_organisation`, `duplicate_organisations`, `name` straight off the request (`:89-91`); a name-only submit rebuilds the filtered list (`:92-96`).
    3. **Reparent**: raw SQL `UPDATE application SET patron_employer_id = $main_organisation_id WHERE patron_employer_id IN ('…','…')` over the selected duplicate ids (`:106`) — string-interpolated ids, no parameter binding.
    4. **Delete duplicates**: `OrganisationEntity::loadMultiple($duplicate_organisations_ids)` then `$organisation->delete()` for each id ≠ main (`:105,107-112`).
    5. Adds messenger message literally `'success'` (`:113`).
  - **Worker add/edit** — `OrganisationWorkerForm` (a `user` entity form, i.e. it saves a **User**):
    1. `buildForm` loads the organisation, injects hidden `organisation` id, `worker_available` checkbox (User `isWorkerAvailable()`), and derives current `is_admin` by scanning `organisation.worker` items for the edited user (`OrganisationWorkerForm.php:48-62`).
    2. `validateForm` requires name+email; on new user, rejects if a `user` with that mail already exists; validates phone = 9 numeric chars (`:70-98`).
    3. `save`: loads a `contact` by email via `patron_base.default` storage; sets User `name`/`mail`=email, `first_name`, `last_name`, `contact` ref; `addRole('organisation_worker')`; `$user->save()` (`:112-128`).
    4. Attaches user to organisation `worker` multivalue field: replaces existing item (preserving position) or appends new item, carrying `is_admin` boolean; `$organisation->save()` (`:132-153`).
    5. If the (new) user is blocked, sends activation email via `account` service (`sendActivationEmail($user,'organisation_worker',['organisation_name'=>…])`, `:160-162`).
    6. Redirects to `organisation.workers_list` (`:164`).
  - **Daily Elastic sync** — `OrganisationCron`:
    1. `hook_cron` gates on `organisation_cron_time` state, one run/day, sets next-run marker to `Y-m-d 05:00:00` (`organisation.module:31-49`).
    2. `sendDataToElastic` reads **all** rows `select id, name from organisation order by id desc` (`OrganisationCron.php:18`).
    3. `sendToElastic` PUT/POST-upserts each `{id,name}` doc to `…/organisations/_doc/{id}` via cURL basic-auth; logs per-item success/failure (`:24-55`).
- Postconditions:
  - De-dup: all `application.patron_employer_id` pointing at duplicates now point at the main organisation; duplicate `organisation` rows deleted.
  - Worker: a `user` with role `organisation_worker` exists, linked to a `contact`, and referenced in the organisation's `worker` field with an `is_admin` flag; optional activation email queued.
  - Cron: Elastic Cloud `organisations` index reflects every organisation's current `{id,name}` (full re-push each run).
- Side Effects:
  - `OrganisationEntity::postSave` enqueues the org into `es_upload_queue` via `patron_base.default::addToQueue` on every save/merge-survivor save (`OrganisationEntity.php:71-74`; `PatronBaseService.php:416-426`) — feeds the separate `patron_search` full-text index.
  - Worker save mutates a **User** entity (role grant, contact link) — cross-context write into Identity/Account domain.
  - Activation email dispatch (transactional message) for blocked new workers.
  - Telegram alerting on queue-insert failure (`PatronBaseService.php:424`) and on Elastic push errors (`OrganisationCron.php:57-59`, `logger.telegram`).
- Integration Calls:
  - Elastic Cloud REST (`OrganisationCron.php:31-38`) — cURL basic-auth, hardcoded host, creds from env `<redacted>`.
  - `patron_search` / `es_upload_queue` (async) full-text index (via postSave enqueue).
  - Account/activation email service (`account` → `sendActivationEmail`, `AccountService.php:254`).
  - Telegram logger (`logger.telegram`).
- Failure Modes:
  - **SQL injection**: `$main_organisation_id` and imploded `$duplicate_organisations_ids` are interpolated into the `UPDATE application …` string with no binding (`OrganisationRemoveDuplicatesForm.php:106`); values come directly from request input (`:89-90`). `Confirmed` (Security).
  - **Orphaned FKs / partial merge**: the `UPDATE application` and the per-org `delete()` loop are not wrapped in a transaction; failure between them leaves duplicates deleted but some `patron_employer_id` unreparented, or vice-versa. Only `application.patron_employer_id` is reparented — any other reference to a duplicate org id (e.g. worker links, contacts, other tables) is left dangling. `Confirmed` (Data Loss).
  - **No merge guard**: no check that `$main_organisation_id` itself is in the duplicate set beyond the `id() == main` skip in the delete loop; `main` need not be one of the loaded `$duplicate_organisations_ids`, so the main org is loaded only if selected — logic relies on operator discipline. `Partial`.
  - **Cron full-scan cost**: every daily run re-pushes ALL organisations (no incremental cursor / no change tracking) — O(n) cURL calls per day (`OrganisationCron.php:18-22`). `Confirmed` (scalability).
  - **Silent Elastic skip**: missing env creds → `sendToElastic` returns with no log/alert (`:28-30`); index silently goes stale. `Confirmed`.
  - **Worker uniqueness on edit**: duplicate-mail guard only runs when `$this->entity->isNew()` (`OrganisationWorkerForm.php:85`); edits can set mail without that check. `Partial`.
  - **Cron double-schedule bug (Hypothesis)**: first-ever run sets marker to today 05:00 and returns without syncing; thereafter `+1 day` gate compares against a 05:00 baseline — timing may drift so the daily push can run late or be skipped on days the cron queue does not fire near 05:00. `Hypothesis`.

## C. Data Footprint
- Entities Written:
  - `organisation` (base_table `organisation`) — deleted (duplicates) and updated (worker field, survivor postSave) — `OrganisationEntity.php`, `OrganisationRemoveDuplicatesForm.php:107-112`, `OrganisationWorkerForm.php:152`.
  - `application` (column `patron_employer_id`) — bulk UPDATE reparent — `OrganisationRemoveDuplicatesForm.php:106`.
  - `user` — created/updated, role `organisation_worker` granted, `contact` linked — `OrganisationWorkerForm.php:118-128` (cross-context, Identity domain).
  - `organisation.worker` field rows (columns `target_id`, `is_admin`) — `WorkerEntityReferenceItemFieldType::schema` defines `is_admin` tinyint + index `(target_id,is_admin)`.
  - `queue` table — `es_upload_queue` item inserted on org postSave — `PatronBaseService.php:421-422`.
  - Drupal `state` (`organisation_cron_time`) — cron marker — `organisation.module:35,42`.
  - `contact` — created lazily by `OrganisationEntity::getEntityByName()` (not on the primary paths, but same entity family) — `OrganisationEntity.php:313-318`.
  - External: Elastic Cloud `organisations/_doc/{id}` documents — `OrganisationCron.php:31-38`.
- Entities Read:
  - `organisation` (raw SQL `SELECT id,name` in de-dup list + cron; `loadMultiple`; `load`) — `OrganisationRemoveDuplicatesForm.php:29,31,105`, `OrganisationCron.php:18`, `OrganisationWorkerForm.php:31,132`.
  - `user` (loadByProperties on mail for dup check) — `OrganisationWorkerForm.php:86`.
  - `contact` (loadByProperties on email) — `OrganisationWorkerForm.php:112`.
  - `queue` (dup-check before enqueue) — `PatronBaseService.php:417`.
- Constraints involved:
  - `organisation.worker` field storage: `is_admin` NOT NULL default 0, index `(target_id,is_admin)` — `WorkerEntityReferenceItemFieldType.php:38-49`.
  - New-worker mail uniqueness enforced in-form only (not a DB constraint) — `OrganisationWorkerForm.php:85-90`.
  - No FK/transaction enforcement on the de-dup reparent+delete.
- Multi-tenant scope assumptions:
  - No region (CZ/RO/MD) filtering anywhere in this flow — de-dup `SELECT`s and cron scan the entire `organisation` table globally; Elastic index is a single global `organisations` index. Multi-tenant boundary is not applied (`Multi-tenant` risk). `Confirmed`.

## D. Evidence Block
- Controller paths:
  - `PSRC/web/modules/custom/organisation/src/Controller/OrganisationWorkersListController.php` (`getList`, `getUserEditLink`).
- Service methods:
  - `PSRC/web/modules/custom/organisation/src/OrganisationCron.php` (`execute`, `sendDataToElastic`, `sendToElastic`, `printMsg`).
  - `PSRC/web/modules/custom/patron_base/src/PatronBaseService.php:416` (`addToQueue`).
  - `PSRC/web/modules/custom/account/src/AccountService.php:254` (`sendActivationEmail`); `PSRC/web/modules/custom/account/src/PatronUser.php:61` (`isWorkerAvailable`).
- Repository usage:
  - Raw `\Drupal::database()->query(...)` in `OrganisationRemoveDuplicatesForm` (list + UPDATE), `OrganisationCron` (list), `OrganisationEntity::getEntityByName`, `PatronBaseService::addToQueue`.
  - Entity storage via `patron_base.default->getStorage('contact')` and `\Drupal::entityTypeManager()->getStorage('user')`.
- Forms / entity hooks:
  - `PSRC/web/modules/custom/organisation/src/Form/OrganisationRemoveDuplicatesForm.php`.
  - `PSRC/web/modules/custom/organisation/src/Form/OrganisationWorkerForm.php` (bound to `user.organisation_worker` via `organisation.module:organisation_entity_type_alter`).
  - `PSRC/web/modules/custom/organisation/src/Entity/OrganisationEntity.php` (`postSave` → es_upload_queue; `preCreate`; `getWorkers`; `getEntityByName`).
  - `PSRC/web/modules/custom/organisation/src/Plugin/Field/FieldType/WorkerEntityReferenceItemFieldType.php` (`worker_entity_reference`, `is_admin` column).
  - `PSRC/web/modules/custom/organisation/organisation.module` (`organisation_cron`, `organisation_entity_operation`, `organisation_entity_type_alter`).
- Event listeners: none specific to this flow (no EventSubscriber; postSave enqueue is the only implicit fan-out).
- Async messages: `es_upload_queue` Drupal queue item `{id, entity_type:'organisation'}` (`PatronBaseService.php:421-422`), processed by `patron_search` worker (see [../../repo-map/integrations.md](../../repo-map/integrations.md)).
- Config evidence:
  - `PSRC/web/modules/custom/organisation/organisation.routing.yml` (4 routes), `organisation.permissions.yml`, `organisation.links.{action,menu,task}.yml`.
  - Env: `ELASTIC_USERNAME`, `ELASTIC_PASS` (`<redacted>`) — `OrganisationCron.php:25-26`.
- REST surface (adjacent, not the mining trigger): `PSRC/web/modules/custom/organisation/src/Plugin/rest/resource/v30|v32/OrganisationResource.php` expose read GET at `/api/3.x/organisation` (SRV0012 read side). `Partial`.
