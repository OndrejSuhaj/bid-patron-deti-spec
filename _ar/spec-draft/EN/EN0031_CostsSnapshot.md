---
doc_id: EN0031
title: CostsSnapshot
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0008  # User (author)
---

# EN0031 — CostsSnapshot

## Description
Per-month cost/target figures entered for reporting: published-campaign counts, costs, and various
targets (campaigns, donations, "obědy školákům" students/amount). A reporting projection/input read by
the reports module to render financial dashboards. Not a transactional domain record.

## Entity Category
Projection · Confidence: Low

## Origin
- DB artifacts: base_table `costs_entity` (content entity; not revisionable; not translatable; reports module has no `.install` → no `hook_schema`)
- Code touchpoints:
  - `reports/src/Entity/CostsEntity.php` — entity + `baseFieldDefinitions()`
  - Read by the reports module (report rendering, FL034)
Evidence: db-models.md `costs_entity`; EN-candidates.md (Projection, reports FL034).

## Core Fields
- `year` (integer, 4-digit unsigned; **required**; default 2018)
- `month` (list_integer 1–12; **required**; default `'1'` — string-literal default, type mismatch recorded as-is)
- `published_campaign_count` / `published_campaign_price` (integer; default 0)
- `cost` / `costs_target` (integer; default 0)
- `campaigns_target` / `campaigns_target_value` / `donations_target_value` (integer; default 0)
- `obedyskolakum_students` / `obedyskolakum_amount` (integer; default 0)
- `status` (boolean) — publish flag
Evidence: db-models.md `costs_entity` field table.

## Technical Fields
- `user_id` (entity_reference → User EN0008) — author.
- `created` / `changed` (created / changed).

## Relations
- `user_id` → User (EN0008) — only declared relation.

## Allowed Statuses
`status` boolean = publish flag only; no workflow states.
Evidence: db-models.md — form/view-display config references an undeclared `type` field (orphaned display artifact, `Hypothesis`); no state field.

## Lifecycle
Reporting projection — created/edited as report input; created-only from a lifecycle standpoint (no
state machine, no observed transitions). Consumed read-only by reports.
Evidence: EN-candidates.md classifies as Projection with "no domain lifecycle"; db-models.md (report-input entity). Created/edited-only.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. `month` allowed values are integers but the default is the string `'1'` — is month stored as int or string in practice? (db-models flags the mismatch.)
2. The orphaned `type` field in form/view-display config — dead artifact or a missing dimension (e.g. cost category)?
3. Is `costs_entity` manually keyed in by finance staff, or populated by a job? No writer flow was mined.
