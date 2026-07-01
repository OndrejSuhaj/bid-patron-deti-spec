# FLW0002 — Application status change (workflow transition)
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL004 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL004 (dossier FLW0002)
- Flow Name: Application status change (workflow transition)
- Primary SRV: SRV0002
- Trigger Evidence:
  - Route `application.change_mod_state_form` → `/admin/application/{application}/change_mod_state` → `\Drupal\application\Form\ChangeModStateForm` — `application/application.routing.yml:73-79` (perm `change entity moderation state`)
  - Route `application.workflow_status_form` → `/admin/application/form/workflow_status` → `\Drupal\application\Form\WorkflowStatusForm` — `application/application.routing.yml:81-87` (perm `add leads`)
  - Also `\Drupal\application\Form\ChangeStateForm` (role-aware "Změnit na" widget; used from the application view via `getAllowedStates()`) — `application/src/Form/ChangeStateForm.php:96`
  - Core mutation: `ApplicationEntity::setState()` + private `ApplicationEntity::insertState()` (raw SQL) — `application/src/Entity/ApplicationEntity.php:292,312`
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Back-office user submits one of the state-change forms on an Application (Žádost). All three forms funnel to the same mutation `ApplicationEntity::setState($value, true, $log)` then `->save()` (`ChangeModStateForm::submitForm` L76-89; `ChangeStateForm::submitForm` L91-105; `WorkflowStatusForm` is effectively **read-only** — its submit only echoes values and its submit button is commented out, `WorkflowStatusForm.php:38-41,56-62`).
- Preconditions:
  - Route permission passes (`change entity moderation state` / `add leads`); `\Drupal\application\Access\StatusAccessCheck` guards a *different* set of status-gated FE routes (`application/src/Access/StatusAccessCheck.php:36`), not the two admin routes above.
  - `ChangeStateForm` only *offers* states allowed for the current state + user roles via `ApplicationEntity::getAllowedStates()` (reads `application_states.yml` `transitions` + `transition_roles`; admins bypass, `ApplicationEntity.php:1396-1425`). `ChangeModStateForm` and `WorkflowStatusForm` offer **all ~66 states** unfiltered via `ApplicationService::getApplicationModStats()` (`ApplicationService.php:183-191`).
- Main Steps (ordered, with evidence):
  1. Form submit reads `moderation_state` (+ optional `log_message`) — `ChangeModStateForm.php:77` / `ChangeStateForm.php:92-93`.
  2. `setState($value, true, $note)` sets BOTH `moderation_state` and `state` base fields to the same value (kept in lock-step) — `ApplicationEntity.php:294-295`.
  3. `setState` calls private `insertState()` → **raw `INSERT INTO application_states (application_id, state, uid, note, changed)`** audit row — `ApplicationEntity.php:300,318-321`. `uid` defaults to `\Drupal::currentUser()` (L296-297).
  4. `setState` forces a new entity revision (`setNewRevision(TRUE)`, revision log = note, revision user = uid) — `ApplicationEntity.php:301-307`.
  5. `->save()` runs `preSave()` — `ApplicationEntity.php:159-192`: on `returned_new_patron` (newly entered) calls `removePatron()`; hard-codes a covid19 flag if patron id == 27280 (L186-188); bumps `changed` if state differs from `$this->original` state.
  6. `->save()` runs `postSave()` — `ApplicationEntity.php:197-226`: (a) enqueues ES re-index (`patron_base.default::addToQueue('application', id)`, L199); (b) **dispatches `ApplicationStatusUpdateEvent`** (L202,228-231) → the FL005 fan-out (3 subscribers); (c) if a `campaign` is attached, syncs campaign status/category and re-saves the campaign (L206-220); (d) resets the entity cache (L221); (e) if state == `new` and no prior audit row exists, inserts an initial `application_states` row (L222-225).
- Postconditions:
  - `application.state` + `application.moderation_state` = new value; a new `application` revision exists; one `application_states` audit row appended; `changed` updated when the value actually changed.
  - Attached `campaign.campaign_status` / `campaign.gift_category` (and one of `canceled`/`uncompleted`/`completed` timestamps) may be updated and the campaign re-saved (`updateCampaignStatus` L1176-1212, `updateCampaignCategory` L1214-1228).
- Side Effects:
  - **Audit row**: raw INSERT into `application_states` on every `setState` (`ApplicationEntity.php:318`).
  - **ES re-index enqueue**: `es_upload_queue` item for this application (`PatronBaseService::addToQueue`, `patron_base/src/PatronBaseService.php:416-426`).
  - **Event fan-out (FL005 / SRV0002 orchestration)** via `ApplicationStatusUpdateEvent`, 3 subscribers:
    - `notification` `ApplicationStatusUpdateSubscriber::updateApplicationStatus` — on entering `waiting_signature*` creates an acceptance-protocol contract + a `fundraiser`/`custom` `application_session`; on entering `waiting_for_feetback*` similar. Gated by feature flag `feature_digital_signature`. Writes `application.acceptance_protocol` via **raw UPDATE** and creates `ContractEntity` + `ApplicationSessionEntity`, invalidates cache tags (`notification/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:54-220`). This is the user-facing message/notification path (SRV0013/SRV0011).
    - `application_reaction` `ApplicationStatusUpdateSubscriber::updateApplicationStatus` — if state changed, calls `application_reaction::execute()` (zone reactions + e-mail notifications) and cancels sessions for statuses listed in config `patron_base.application_statuses.invalidate_sessions`, logging an `application_log` "Aktivity" row (`application_reaction/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:48-103`).
    - `scoring` `ApplicationStatusUpdateSubscriber::updateApplicationStatus` — only when new state == `to_check`: recomputes low-risk score and **raw UPDATEs** `application.scoring_low_risk_score` + `application.scoring_low_risk` (`scoring/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:67-118`).
  - **Campaign (Story) mutation + re-save** when a campaign is attached (`ApplicationEntity.php:206-220`) — bidirectional Application↔Campaign status/category coupling; adds a Drupal messenger notice (L1205).
  - **Telegram alert** (ops) if campaign/application status desync is detected after re-save (`\Drupal::service('logger.telegram')->log(3, ...)`, `ApplicationEntity.php:217`) and if the raw `application_states` INSERT throws (`ApplicationEntity.php:323`).
  - `removePatron()` (on entering `returned_new_patron`) scrubs patron fields from scoring/profile (`ApplicationEntity.php:181-183,1283+`).
- Integration Calls: None direct in the transition itself. Indirect/downstream (via the dispatched event and postSave): Elasticsearch (async, via `es_upload_queue` → SRV0016), transactional e-mail (via `application_reaction`/SRV0013), Telegram ops alerting (SRV0018). No payment/bank/CRM boundary is touched by the transition.
- Failure Modes:
  - **No transition validation on two of three entry forms.** `ChangeModStateForm` and `WorkflowStatusForm` build the select from *all* states (`getApplicationModStats`) and `submitForm` performs `setState()` with **no check against `application_states.yml` transitions**. Only `ChangeStateForm` filters *offered* options; even there the submit handler re-does no server-side transition/authorization validation (`ChangeStateForm.php:91-105`). ⇒ any allowed-permission user can force any state (illegal transitions possible). `Confirmed`.
  - **Not idempotent / no dedupe.** `insertState()` appends an audit row on *every* `setState`, even when the value is unchanged (no "state actually changed" guard around the INSERT). Re-submitting duplicates audit rows and revisions. `Confirmed`.
  - **Raw SQL INSERT bypasses the entity layer.** `application_states` is written by hand-built SQL, not an entity; on failure it logs to Telegram and rethrows (`ApplicationEntity.php:322-325`) — the surrounding `save()` may partially complete (revision set) before the exception surfaces; the form catch (`catch (\Exception)`) only shows a generic message (`ChangeModStateForm.php:85-88`). `Partial` (transaction boundary of `save()` not fully traced).
  - **Event fan-out failures are unguarded / synchronous.** Subscribers run inline within `postSave`; a throw in any subscriber (e.g. contract creation on `waiting_signature`) can abort the save. The event itself has no changed/old-vs-new gate — subscribers each re-check `$this->application->original` (`isApplicationModified`). `Partial`.
  - **Campaign re-save inside postSave** (`ApplicationEntity.php:211`) is a nested save that can itself dispatch/side-effect; desync is only *detected and Telegram-logged*, not repaired (L213-218). `Confirmed` (detection-only).
  - **`WorkflowStatusForm` is effectively dead** as a mutator (submit button commented out; submit only echoes) — `Confirmed`; treat `/admin/application/form/workflow_status` as a read-only status list, not a transition action.

## C. Data Footprint
- Entities Written:
  - `application` (base fields `state`, `moderation_state`; `changed`; new revision in `application_revision`/`application_field_revision`; revision log/user) — `ApplicationEntity.php:294-307`.
  - `application_states` (raw side table; cols `application_id, state, uid, note, changed`) — `ApplicationEntity.php:318-321`.
  - `campaign` (fields `campaign_status`, `gift_category`, `canceled`/`uncompleted`/`completed`) — re-saved in postSave when attached — `ApplicationEntity.php:1176-1228`.
  - **Downstream (via event, cross-context):** `contract` + `application.acceptance_protocol` (raw UPDATE), `application_session` (create) — notification subscriber; `application.scoring_low_risk*` (raw UPDATE) — scoring subscriber; `application_log` (create) — application_reaction subscriber; `queue` (es_upload_queue item) — postSave.
- Entities Read: `application` (self + `$this->original` for change detection), `config` table row `workflows.workflow.application_workflow` (raw select in `WorkflowStatusForm::getApplicationModStats`, L70-77), `application_states.yml` module file (`getStatesConfig`, `ApplicationEntity.php:1373-1374`), `campaign` (attached), `contract`, `patron`/`fundraiser`/profiles (read during removePatron / scoring).
- Constraints involved:
  - `application_states`: `id` PK, `application_id`/`state`/`uid` NOT NULL, no unique key, **no DB foreign key** to `application` (`application_id` is a soft link) — `application/application.install:45-52` (created in `application_update_8005`). Confirms db-models note that `application_states` is a history side table, not an entity field.
  - `state` allowed_values sourced from `getAllStates()`/`application_states.yml`; `moderation_state` has **no backing base field definition** yet is written by `setState()` — recorded `Conflict` in db-models (moderation_state comes from content_moderation workflow config, not `baseFieldDefinitions`).
  - No DB-level guard enforces legal transitions; the state machine (`transitions` / `transition_roles`, 66 states) lives only in `application_states.yml` + `workflows.workflow.application_workflow.yml` config and is enforced (partially) only in `getAllowedStates()`.
- Multi-tenant scope assumptions: Single Drupal instance, path-prefix i18n (cs/en/ru/ro). No explicit CZ/RO/MD gating in the transition code; behaviour is uniform across countries. Some downstream reactions read country from `Settings`/config (`invalidate_sessions` preset, feature flag `feature_digital_signature`) but the core transition is country-agnostic. `Partial` (per-country reaction config not exhaustively traced).

## D. Evidence Block
- Controller paths: none — the flow is form-driven (`FormBase` submit handlers), not controllers.
  - `application/src/Form/ChangeModStateForm.php:76-89` (submit → setState/save)
  - `application/src/Form/ChangeStateForm.php:91-105` (role-aware submit)
  - `application/src/Form/WorkflowStatusForm.php:56-62` (read-only echo; submit button commented out)
- Service methods:
  - `ApplicationEntity::setState()` `:292`; `ApplicationEntity::insertState()` (private, raw INSERT) `:312`
  - `ApplicationEntity::preSave()` `:159`; `ApplicationEntity::postSave()` `:197`; `dispatchStatusUpdateEvent()` `:228`
  - `ApplicationEntity::updateCampaignStatus()` `:1176`; `updateCampaignCategory()` `:1214`; `removePatron()` `:1283`
  - `ApplicationEntity::getAllowedStates()` `:1396`; `getStatesConfig()`/`getStates()`/`getTransitions()` `:1373-1383`; `getStateLabel()` `:1390`
  - `ApplicationService::getApplicationModStats()` `application/src/ApplicationService.php:183`
  - `PatronBaseService::addToQueue()` `patron_base/src/PatronBaseService.php:416`
- Repository usage: raw SQL via `\Drupal::database()->query(...)` for the `application_states` INSERT (`ApplicationEntity.php:318`), the "state==new" existence check (`ApplicationEntity.php:223`), the `config` blob read (`WorkflowStatusForm.php:71-75`), and the downstream raw UPDATEs (notification `:214`, scoring `:112`). Entity storage `save()` for `application` and re-saved `campaign`.
- Event listeners (subscribe to `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT = 'application.status.update.event'`, defined `application/src/Event/ApplicationStatusUpdateEvent.php:13`):
  - `notification/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:44,54`
  - `application_reaction/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:38,48`
  - `scoring/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php:56,67`
- Async messages: `es_upload_queue` (Drupal queue, `PatronBaseService::addToQueue`) — drained by `patron_search` cron/CLI (SRV0016). The status *event* fan-out is **synchronous** (inline subscribers within `postSave`), not queued. Note per FLOW-candidates: `mailing_queue` used by messaging runs with `USE_QUEUE=FALSE` (mail sent inline, no retry) — relevant to the notification subscriber's downstream e-mail.
- Config evidence:
  - `application/application.routing.yml:73-87` (both routes)
  - `application/application_states.yml` (66 `states`, `transitions`, `transition_roles`; module-file source of truth for `getAllowedStates`)
  - `config/workflows.workflow.application_workflow.yml` (content_moderation workflow, `type_settings.states`; read raw from the `config` table by `WorkflowStatusForm`)
  - `application/application.install:43-54` (`application_update_8005` creates the raw `application_states` table)
  - `application/application.permissions.yml` (permissions `change entity moderation state`, `add leads`) — referenced by routes
