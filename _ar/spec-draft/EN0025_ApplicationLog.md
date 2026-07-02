---
doc_id: EN0025
title: ApplicationLog
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application (logged aggregate)
  - EN0008  # User (author)
---

# EN0025 — ApplicationLog

## Description
Immutable per-Application activity/audit row surfaced in the admin "Aktivity" tab. Records a discrete
event against a Lead/Application — a logged call/email/sms, a system action (e.g. reaction-driven
notification, session cancellation), or a field change. Rows are appended, never mutated.

## Entity Category
Content · Confidence: Medium

## Origin
- DB artifacts: base_table `application_log` (content entity; no revision/translation; no `hook_schema` — physical DDL Drupal-generated)
- Code touchpoints:
  - `application_log/src/Entity/ApplicationLogEntity.php` — entity + `baseFieldDefinitions()`
  - Written by `ApplicationReactionService::addApplicationLog` and `application_reaction/.../ApplicationStatusUpdateSubscriber::addApplicationLog` (reaction + session-cancel audit rows)
  - Also written by contract flow `ApplicationContractController` (activity note rows)
Evidence: db-models.md `application_log`; FLW0001 §C (Entities Written); FLW0008 §D.

## Core Fields
- `application_id` (entity_reference → Application EN0001; card. 1) — the logged Application
- `user_id` (entity_reference → User EN0008; card. 1) — author; default current user (crm_robot_uid for system rows)
- `field_name` (string 50) — changed field / activity descriptor
- `field_value` (string 255) — associated value
- `note` (string_long) — "Poznámka" free-text note
Evidence: db-models.md `application_log` field table.

## Technical Fields
- `start` (created accessor `getStartTime()`), `finish` (changed accessor `getFinishTime()`) — timestamps.

## Relations
- `application_id` → Application (EN0001)
- `user_id` → User (EN0008)

## Allowed Statuses
None. No status/state field is defined on this entity.
Evidence: db-models.md notes entity_keys `label`→`name` and `status`→`status` point at **undefined** fields (scaffolding mismatch); no backing status field exists — `Conflict — requires clarification` (recorded, not resolved).

## Lifecycle
Append-only audit log — created, never transitioned. Rows are inserted as a side effect of Application
status fan-out and contract activity; no state machine, no update/delete path evidenced.
Evidence: FLW0001 §B step 4 (per-reaction log row) + §B step 7 (session-cancel log row); FLW0008 activity-note rows. No transition evidence exists (created-only).

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. `field_name`/`field_value` are generic; is there a controlled vocabulary of activity types (call/email/sms/system) or is it free-form per writer?
2. The dangling `label`→`name` / `status` entity_keys — dead scaffolding or a lost field? (db-models `Conflict`.)
3. Field descriptions are copy-pasted from "Campaign Log entity" — confirm they were not intended to carry Campaign semantics.
