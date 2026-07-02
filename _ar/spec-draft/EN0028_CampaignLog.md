---
doc_id: EN0028
title: CampaignLog
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004  # Campaign (logged Story)
  - EN0008  # User (author)
---

# EN0028 — CampaignLog

## Description
Per-Campaign (Story/Příběh) field-change audit row with start/finish timestamps, recording how long a
value/state was held. Structurally a lightweight audit log keyed to a Campaign; rows are appended.

## Entity Category
Content · Confidence: Low

## Origin
- DB artifacts: base_table `campaign_log` (content entity; not revisionable; not translatable; no `hook_schema`)
- Code touchpoints:
  - `campaign_log/src/Entity/CampaignLogEntity.php` — entity + `baseFieldDefinitions()`
Evidence: db-models.md `campaign_log`; db-inventory.md line 45 (entity row).

## Core Fields
- `campaign_id` (entity_reference → Campaign EN0004; card. 1) — the logged Campaign
- `user_id` (entity_reference → User EN0008; card. 1) — author
- `field_name` (string 50; default `''`) — changed field name
- `field_value` (string 255; default `''`) — associated value
Evidence: db-models.md `campaign_log` field table.

## Technical Fields
- `start` (created accessor), `finish` (changed accessor) — per-interval timestamps.

## Relations
- `campaign_id` → Campaign (EN0004)
- `user_id` → User (EN0008)

## Allowed Statuses
None. No status/state field is defined.
Evidence: db-models.md — entity_keys `label`→`name` and `status`→`status` reference **undefined** fields (scaffolding inconsistency); `Conflict — requires clarification`.

## Lifecycle
Append-only audit log — created, never transitioned. No writer flow was deep-mined; no update/delete
path or state machine is evidenced.
Evidence: db-models.md (audit-log entity, `field_name`/`field_value` + start/finish). No FLW dossier exercises this table (DB-only per EN-candidates.md) → `Hypothesis` that rows are written on Campaign field changes; **Missing evidence** for the actual writer.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Which code path writes `campaign_log`? No flow dossier touches it (EN-candidates lists it as db-only).
2. Are start/finish meant to bracket the duration a specific `field_value` was held (interval audit) or just created/changed?
3. Dangling `label`/`status` entity_keys — dead scaffolding shared with ApplicationLog (same copy-pasted descriptions)?
