---
doc_id: QUERY0010
title: Costs / Targets & Report Snapshot
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: summary
references:
  - EN0031
  - EN0032
  - EN0004
  - UC0017
  - FN0020
  - ARCH0012
---

# QUERY0010 – Costs / Targets & Report Snapshot

## Purpose

Two related back-office read-models for planning and trend reporting:

1. **Costs / targets** ("Naklady") — a manually- and cron-maintained monthly record of cost,
   targets, posted-story counts/values, donation-value targets and the "Obědy školákům" (school
   lunches) figures, listed for managers.
2. **Report snapshot** — periodic point-in-time captures of report metrics (`report_id`,
   `field_name`, `field_value`, `created`) enabling historical/trend comparison of the dashboards.

Evidence: `config/views.view.naklady.yml` (base `costs_entity`),
`web/modules/custom/reports/src/Entity/CostsEntity.php`,
`web/modules/custom/reports/src/Entity/SnapshotEntity.php`.

## Consumers

- administrator, manager (naklady list; costs entity view/edit permissions).
- Reporting dashboards that read snapshot history (QUERY0009).

## Source Entities

- EN0031 – CostsSnapshot (the `costs_entity`; fields incl. `year`, `month`, `cost`, `costs_target`, `campaigns_target`, `campaigns_target_value`, `donations_target_value`, `published_campaign_count`, `published_campaign_price`, `obedyskolakum_students`, `obedyskolakum_amount`)
- EN0032 – ReportSnapshot (the `snapshot_entity`; `report_id`, `field_name`, `field_value`, `created`, `user_id`)
- EN0004 – Campaign (published-count / published-price inputs)

## Filters and Grouping

| Filter / Grouping | Meaning | Notes |
|---|---|---|
| naklady: none (full list) | All costs rows | Role-gated list, 200/page. Confirmed. |
| snapshot lookup: `report_id` + `created BETWEEN begin,end` | Fetch a metric's values for a day/range | Entity query in `SnapshotEntity::...`. Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| cost / target columns | Monthly cost vs targets, posted stories (count & value), donations target value | Owned by EN0031. Confirmed. |
| Obědy školákům figures | School-lunch students count and paid amount | Owned by EN0031. Confirmed. |
| snapshot value | A single captured report metric at a timestamp | Owned by EN0032. Confirmed. |

## Result Shape

- naklady: paginated back-office table with row operations.
- snapshot: keyed lookup returning stored metric values for trend charts.

## References

- UC: UC0017 (Export Reporting Data)
- FN: FN0020 (Reporting Read-Model & CSV Export)
- EN: EN0031, EN0032, EN0004
- ARCH: ARCH0012 (Platform, Search & Operations)

## Open Items

- Whether costs rows are fully manual, partly cron-computed (published counts/values), or both is not
  fully evidenced in the list view alone; verify against the costs form / cron writer. Partial.
- Snapshot capture cadence (which job writes snapshots, when) is a JOB-layer concern, not restated
  here; cross-reference during closure.
