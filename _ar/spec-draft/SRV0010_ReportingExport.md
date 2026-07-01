# SRV0010 — Reporting & Export

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C5 — Finance & Reconciliation

## SRV Category
Projection / Reporting

## Responsibility Type
Infrastructure

## Purpose
Produces read-side outputs over the domain: dashboards and financial/productivity reports, point-in-time snapshots, cost/target inputs, and scheduled CSV exports. It aggregates across applications, campaigns, and transactions without owning any of them — a projection layer.

## Current Implementation Shape
- **Report inputs/snapshots:** `costs_entity` (per-month cost/target figures) + `snapshot_entity` (point-in-time report data, `getEntityBetwCreated()`). `Evidence:` `PSRC/web/modules/custom/reports/src/Entity/{CostsEntity,SnapshotEntity}.php`; [db-models.md](../evidence/db-models.md).
- **Report controllers:** `DashboardController`, `AccountingReportsController`, `MonthlyReportController`, `ProductivityReportsController` (~8 controllers). `Evidence:` [entrypoints.md §3](../repo-map/entrypoints.md); `PSRC/web/modules/custom/reports/src/Controller/`.
- **Aggregation scope:** `reports` module depends on `application` + `campaign` + `transaction`. `Evidence:` [modules.md §3](../repo-map/modules.md).
- **Scheduled CSV export:** `ExportCsvCron` — cron-invoked, writes `/tmp/{name}_{date}.csv` for payments, leads, supporters, patrons, campaigns, accounting, contracts; deletes prior file before regenerating. `Evidence:` `PSRC/web/modules/custom/export_csv/src/ExportCsvCron.php`; [integrations.md §8](../repo-map/integrations.md).
- **Status-group presets:** `application_statuses` config entities (all_leads/funnel_step_*/monthly_*/org_stats_*) drive dashboard queries. `Evidence:` [db-models.md `application_statuses`](../evidence/db-models.md).

## Structural Issues
- **Reads reach into source aggregates** — reporting queries application/campaign/transaction tables directly rather than via published read-models; tight coupling to storage shape. `Evidence:` [modules.md §3](../repo-map/modules.md).
- **Export to `/tmp`** — CSV exports write to `/tmp` and self-delete prior files; no retention/versioning; delivery mechanism unclear. `Evidence:` [integrations.md §8](../repo-map/integrations.md).
- **Snapshot entity inconsistencies** — `snapshot_entity` has a declared `status` key with no backing field and contradictory revision/translation flags. `Evidence:` [db-models.md `snapshot_entity`](../evidence/db-models.md).
- **Report metrics hardcoded in entity** — `costs_entity` carries many fixed metric columns (`obedyskolakum_*` etc.). `Evidence:` [db-models.md `costs_entity`](../evidence/db-models.md).

## Target Shape (for rewrite)
Explicit read-models/projections fed by domain events (payments, applications, campaigns), queried by report endpoints. Exports as a scheduled job writing to durable storage with retention and an explicit delivery target. Status-group presets as configuration consumed by the query layer.

## Integration Dependencies
None (internal projection). Output is CSV files on the filesystem (`/tmp`). `Confirmed` — [integrations.md §8](../repo-map/integrations.md).

## Boundaries
Does NOT own application/campaign/transaction state → SRV0001/SRV0005/SRV0007. Does NOT reconcile bank movements → SRV0009. Does NOT generate PDF documents → SRV0011.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Where do `/tmp` CSVs go (download route, external pickup, backup)? `Missing evidence: ExportCsvCron consumer/delivery trace.`
- Full report inventory and which are live vs. legacy. `Missing evidence: reports controller route inventory.`
- Cron gating for `export_csv` per environment. `Missing evidence: export_csv cron guard trace.`
