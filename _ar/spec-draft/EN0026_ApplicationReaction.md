---
doc_id: EN0026
title: ApplicationReaction
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application (matched by status)
  - EN0003  # ApplicationSession (created by reaction)
  - EN0008  # User (owner)
---

# EN0026 — ApplicationReaction

## Description
Configuration record describing what the platform should do when an Application enters a given status,
for a given user role. Each active reaction can render a zone status message, drive user-action buttons,
create an ApplicationSession, and send a status-driven notification e-mail. Reactions are matched at
runtime by `application_status` + `role` (+ optional `initiator`), so this is config-driving-behavior,
not a per-Application record.

## Entity Category
Persisted · Confidence: Medium

## Origin
- DB artifacts: base_table `application_reaction` (content entity; **revisionable** — `application_reaction_revision` / `_field_revision`; not translatable; no `hook_schema`)
- Code touchpoints:
  - `application_reaction/src/Entity/ApplicationReactionEntity.php` — entity + `baseFieldDefinitions()`
  - Consumed by `ApplicationReactionService::execute/getApplicationsReactions/createReaction/sendEmail` (matched per state via `loadByProperties(['application_status'=>state])`, filtered by `initiator`)
Evidence: db-models.md `application_reaction`; FLW0001 §B step 4–5.

## Core Fields
- `role` (list_string; **required**) — patron / fundraiser / supporter / organisation_worker / anonymous — recipient/target role
- `application_status` (list_string; **required**) — dynamic allowed values from `application` service `getState()`; the matched status
- `initiator` (list_string) — patron / fundraiser / organisation_worker — optional match filter (NULL = any)
- `status_message` / `status_description` (string 100 / 255) — zone status text
- `button_action_enabled` / `button_action` (application_refill / application_repeat / redirect) / `redirect_route` / `button_text` / `button_modal` — user-action button config
- `session_interface` (list_string) — default / custom / upload_* / authenticated / new_patron / invited — interface for a created session
- `theme_color` / `theme_icon` (list_string) — zone display styling
- `notification_email_enabled` / `notification_email` (body) / `notification_email_subject` — e-mail notification content
- `notification_zone_enabled` / `notification_zone` / `notification_zone_icon` — zone notification content
- `fundraiser_show_application` / `fundraiser_show_campaign` / `patron_show_fundraiser_application` (boolean) — visibility toggles
- `status` (boolean; default FALSE) — "Zobrazit pribeh v zone" publish/enable flag
Evidence: db-models.md `application_reaction` field table.

## Technical Fields
- `user_id` (entity_reference → User EN0008) — owner; only translatable field.
- `notification_email_ukr` / `notification_email_subject_ukr` — non-revisionable UKR temp fields.
- `created` / `changed` — not revisionable.

## Relations
- `user_id` → User (EN0008)
- Drives: ApplicationSession (EN0003) create; matched against Application (EN0001) state.

## Allowed Statuses
`status` boolean = enable/disable of the reaction (publish flag), default FALSE. No workflow states.
Evidence: db-models.md — `status` = "Zobrazit pribeh v zone" flag; `getAction()` reads a field `action` whose definition is **commented out** → treat `action` as a dead/legacy field (`Hypothesis`).

## Lifecycle
Config entity — created/edited by administrators; revisionable (history retained), but no domain state
machine. It is *read* during Application status fan-out to produce sessions, logs, and e-mail; the
reaction itself does not transition.
Evidence: FLW0001 §C (`application_reaction` under Entities Read — config-driven reaction rows). Enum ≠ transition; created/edited-only.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Is `application_status` single-valued match only (card. 1) — how are multi-status reactions expressed (one row per status)?
2. Commented-out `action` field vs. live `button_action` — confirm which drives button behavior.
3. UKR notification fields being non-revisionable while the rest are revisionable — intentional or oversight?
