---
doc_id: EN0027
title: ApplicationAction
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application (transitioned by the action)
  - EN0008  # User (owner)
---

# EN0027 — ApplicationAction

## Description
Configuration record defining an automatic status transition for Applications. When `initiator = cron`,
the action cron loads all active `cron`-initiated actions and, for every Application sitting in the
source status (`application_status`) longer than `cron_interval`, moves it to `application_status_target`
(as the `crm_robot_uid` system user) and optionally runs a named `cron_action` method (only `removePatron`
is implemented). It is a rule definition consumed by the cron; it holds no per-Application state.

## Entity Category
Persisted · Confidence: Medium

## Origin
- DB artifacts: base_table `application_action` (content entity; not revisionable; translatable via config `language.content_settings.application_action.application_action.yml`; no `hook_schema`)
- Code touchpoints:
  - `application_action/src/Entity/ApplicationActionEntity.php` — entity + `baseFieldDefinitions()` + `runAction()` / `removePatron()`
  - `application_action/src/ApplicationActionCron.php` — `execute()` loads `initiator='cron' AND status=1`, selects `application` by `state` + `changed <= now-interval`, then `changeApplicationStatus()` → `ApplicationEntity::setState($target,...,crm_robot_uid)`; `application_action.module::application_action_cron()` is the trigger
Evidence: db-models.md `application_action`; `ApplicationActionCron.php` (execute/getApplicationActions/changeApplicationStatus — verified in source).

## Core Fields
- `initiator` (list_string; **required**) — cron / patron / fundraiser (only `cron` is executed by the cron)
- `application_status` (list_string; **required**; card. ∞) — "Stav původní"; allowed = `['*']` + runtime `getApplicationModStats()` (dynamic) — source status(es)
- `application_status_target` (list_string) — "Stav cílový"; dynamic allowed values — target status
- `session_interface` (list_string; **required**) — * / default / custom / upload_contract / upload_gift_proof / upload_feedback / authenticated / new_patron / invited
- `cron_interval` (string 30) — age threshold (`strtotime('now -'.interval)`) an Application must exceed
- `cron_action` (list_string; card. ∞) — method name dispatched by `runAction()`; only `removePatron` implemented
- `status` (boolean; default TRUE) — "Is Active?" enable flag
Evidence: db-models.md `application_action` field table; `ApplicationActionCron.php:47` (`initiator='cron'`, `status=1`).

## Technical Fields
- `user_id` (entity_reference → User EN0008) — owner; default current user.
- `name` (string 50) — entity label. `created` / `changed`.

## Relations
- `user_id` → User (EN0008)
- Acts on: Application (EN0001) — reads `state`, writes target `state` via `setState()`.

## Allowed Statuses
`status` boolean = active/inactive rule flag (default TRUE). No workflow states on this entity.
Evidence: db-models.md — `status` = "Is Active?". Form-display references a `cron_email_id` field whose base-field definition is **commented out** → `Conflict — stale form-display config`.

## Lifecycle
Config/rule entity — created/edited by administrators; created-only from a lifecycle standpoint. The
*Application* it targets undergoes the transition; the ApplicationAction record itself does not.
Evidence: `ApplicationActionCron::changeApplicationStatus` performs the Application transition (source→target), not a transition of this entity. No state machine on `application_action`. Enum ≠ transition.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Only `removePatron` is implemented despite `cron_action` being a list — are other action names configured but silently no-op?
2. `patron`/`fundraiser` `initiator` values exist but the cron only handles `cron` — where (if anywhere) are non-cron initiators consumed?
3. `application_status` is unlimited-cardinality but the cron compares `getState() === $status` against the whole value — confirm single-status matching semantics.
