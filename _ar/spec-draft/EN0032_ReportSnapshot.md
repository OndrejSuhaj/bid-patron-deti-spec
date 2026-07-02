---
doc_id: EN0032
title: ReportSnapshot
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0008  # User (author)
---

# EN0032 — ReportSnapshot

## Description
Point-in-time reporting datum: a named metric (`field_name` / `field_value`) tagged with a `report_id`
and captured at a `created` timestamp, so reports can query values over a date range. A generic
key/value reporting projection, not a transactional domain record.

## Entity Category
Projection · Confidence: Low

## Origin
- DB artifacts: base_table `snapshot_entity` (content entity; not revisionable; not translatable; reports module has no `.install` → no `hook_schema`)
- Code touchpoints:
  - `reports/src/Entity/SnapshotEntity.php` — entity + `baseFieldDefinitions()` + `getEntityBetwCreated()` (range query filtered by `report_id`, `created` BETWEEN)
Evidence: db-models.md `snapshot_entity`; EN-candidates.md (Projection, reports FL034).

## Core Fields
- `report_id` (string 50) — filter/grouping key used in `getEntityBetwCreated()`
- `field_name` (string 50) — metric name (descriptions copy-pasted from Campaign Log)
- `field_value` (string 50) — metric value
Evidence: db-models.md `snapshot_entity` field table.

## Technical Fields
- `user_id` (entity_reference → User EN0008) — author.
- `created` / `changed` — `created` used as the BETWEEN range key.

## Relations
- `user_id` → User (EN0008) — only declared relation.

## Allowed Statuses
None as a live field. A `status` entity_key is declared but has no publishing interface/backing field.
Evidence: db-models.md — `status` entity_key with no publishing interface/field; per-field revisionable/translatable flags + language content-settings contradict the single-table non-revisionable/non-translatable annotation (`Conflict`, flagged not resolved).

## Lifecycle
Reporting projection — snapshot rows are written (presumably by a report/snapshot job) and read back by
range query; created-only, no state machine, no update/delete path evidenced.
Evidence: db-models.md (`getEntityBetwCreated` range read; snapshot semantics). No writer flow mined → `Hypothesis` that a job populates snapshots; **Missing evidence** for the writer. Created-only.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. What writes `snapshot_entity` and on what cadence (cron snapshot job vs. manual)? No flow dossier covers the writer.
2. `field_value` is a string(50) — how are numeric metrics aggregated in reports (cast at read time)?
3. The `status` entity_key without a backing field, plus contradictory revisionable/translatable flags — dead scaffolding to confirm.
