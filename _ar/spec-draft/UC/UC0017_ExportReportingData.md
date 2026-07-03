# UC0017 — Export Reporting Data (CSV)

## Header

| Field | Value |
|---|---|
| UC ID | UC0017 |
| Name | Export Reporting Data (CSV) |
| Bounded Context | C5 |
| Primary Actor(s) | Admin, Scheduler |
| Trigger Type | UI/Cron |

## Actors & Responsibilities

- **Admin** — authenticated back-office user who opens the downloads listing and requests a specific reporting export on demand.
- **Scheduler** — daily automated job that produces the standard set of reporting exports without human intervention.
- **System** — evaluates permissions, reads source records, assembles CSV content, and returns/persists the resulting file.

## Intent

Give administrators access to consolidated, downloadable CSV extracts of donation, application, and contract data for finance, risk, and campaign reporting — either refreshed automatically once per day or generated on demand — without altering any domain record.

## Preconditions

- The Admin actor is authenticated and holds the permission required for the requested export category (general reporting access, leads-specific access, or accounting-specific access, depending on the export).
- For scheduled runs, the daily export window has not yet run for the current day.
- The underlying data (Application EN0001, ApplicationProfile EN0002, Contact EN0006, Transaction EN0009, Campaign EN0004, Contract EN0011) already exists from prior process flows (application intake, donation processing, contracting).

## Main Flow

### UC0017.1 — Scheduled daily export batch

1. Scheduler: at the daily export window, checks whether an export batch has already run today.
2. System: if no batch has run yet today, starts the daily export batch covering the full set of standard reporting exports (payments, supporters, vouchers, accounting, leads, campaigns, patrons, fundraisers, gift payments, contracts, scoring/risk outcomes, blacklist entries, region summaries).
3. System: for each standard export in the batch, discards any previously generated file for that export from the prior day and from today (if one already exists).
4. System: for each standard export, reads the relevant records — Application (EN0001), ApplicationProfile (EN0002), Contact (EN0006), Transaction (EN0009), Campaign (EN0004), Contract (EN0011) as applicable to that export — and assembles a CSV file with a fixed column header and one row per matching record.
5. System: stores the assembled CSV file, named for its export type and the current date, for same-day reuse.
6. System: records a completion log entry for each export in the batch.
7. System: if an individual export in the batch fails, logs the failure and continues with the remaining exports in the batch.

Outcome: up to sixteen standard reporting CSV files are refreshed once per calendar day, ready to be served to Admins without re-querying.

### UC0017.2 — On-demand export request

1. Admin: opens the downloads listing page showing the available reporting export links.
2. System: verifies the Admin holds the permission required for the export category being listed (general reporting, leads, or accounting).
3. Admin: selects one specific export link (e.g. payments, supporters, leads, accounting, contracts, campaigns, patrons, fundraisers, blacklist, scoring outcome, region summary).
4. System: checks whether a same-day file already exists for the requested export (produced earlier by the scheduled batch or by an earlier on-demand request).
5. System: if a same-day file exists, serves that file to the Admin as a CSV download without re-reading source records.
6. System: if no same-day file exists, reads the relevant records for the requested export — Application (EN0001), ApplicationProfile (EN0002), Contact (EN0006), Transaction (EN0009), Campaign (EN0004), Contract (EN0011) as applicable — and assembles a new CSV file.
7. System: for the payments-related exports, narrows the assembled rows to the Campaign (EN0004) identified by an optional campaign filter, when the Admin supplied one.
8. System: stores the newly assembled file for same-day reuse and streams it to the Admin as a CSV download.
9. System: if record retrieval or file assembly fails, displays an error message to the Admin instead of a download.

Outcome: the Admin receives a CSV file for the requested reporting export, either freshly assembled or reused from the same day's cache.

### UC0017.3 — Reporting read-model access (dashboards)

1. Admin: opens a reporting dashboard view.
2. System: reads previously captured reporting figures — monthly cost/target entries (CostsSnapshot, EN0031) and named point-in-time metrics (ReportSnapshot, EN0032) — filtered to the requested date range.
3. System: renders the dashboard using the retrieved figures.

Outcome: the Admin sees aggregated reporting figures independent of the CSV export files; this sub-flow is now evidenced by the mined reporting read-model dossier (FLW0031) and is described at capability level only.

## Alternative Flows

### AF1 — Permission denied

1. Admin: attempts to open an export link for a category not covered by their granted permission.
2. System: rejects the request and does not produce or return a file.

Outcome: no export is generated; the Admin sees an access-denied outcome.

### AF2 — Underlying storage unavailable

1. System: attempts to store or retrieve the assembled CSV content and the storage location is unavailable or unwritable.
2. System: logs the failure.
3. System: returns an error to the Admin (on-demand) or leaves the standard export missing for that batch (scheduled), without affecting any domain record.

Outcome: the export is absent or incomplete for that run; no domain data is changed.

### AF3 — Campaign-filtered payments export

1. Admin: requests a payments-related export with a specific Campaign (EN0004) filter.
2. System: assembles the export limited to Transaction (EN0009) records associated with that Campaign.

Outcome: the Admin receives a campaign-scoped subset of the payments export instead of the full data set.

## Postconditions

- Zero or more CSV export files exist for the current day, one per export type, available for repeated same-day download without re-assembly.
- No Application (EN0001), ApplicationProfile (EN0002), Contact (EN0006), Transaction (EN0009), Campaign (EN0004), or Contract (EN0011) record is created, updated, or transitioned by this use case — it is read-only with respect to domain entities.
- A log entry exists per completed or failed export in a scheduled batch.
- Exported CSV content and its sensitive-data handling follow BR-ReportingAndDataAccess § Sensitive-data handling (current-state) (BR-ReportingAndDataAccess — export PII, no extra protection).
- Export tenant/country scoping is governed by BR-MultiTenantCountryScoping § Cross-tenant data-path scoping (current-state) (BR-MultiTenantCountryScoping — exports global, no country filter).

## Traceability

Target SRVs:
- Reporting-ReadModel
- CSV-Export-Processor

EN entities:
- EN0009 Transaction — payments, supporters, vouchers, and accounting rows exported
- EN0001 Application — leads, campaigns-per-application, patrons, fundraisers, gift payments, contracts, scoring, blacklist, and region-summary rows exported
- EN0002 ApplicationProfile — profile fields joined into gift/patron/fundraiser exports
- EN0006 Contact — PII (name, identification number, phone, email, address) joined into multiple exports
- EN0004 Campaign — campaign attribution and optional filter for payments exports
- EN0011 Contract — contract identifiers joined into contract-related exports
- EN0031 CostsSnapshot — monthly cost/target read-model figures behind the reporting dashboards (UC0017.3)
- EN0032 ReportSnapshot — point-in-time named-metric read-model figures behind the reporting dashboards (UC0017.3)

Integration boundaries:
- None (no external system integration; the only boundary is the local export/storage sink used to persist and re-serve CSV files).

BR rules:
- BR-ReportingAndDataAccess — read-only reporting, request-time permission gating, and sensitive-data (PII) handling of exported files.
- BR-MultiTenantCountryScoping — absence of CZ/RO/MD country scoping on exports (exports global across tenants).

Flow Evidence:
- FLW0027 (mined) — scheduled and on-demand CSV export batch, covers UC0017.1, UC0017.2, AF1, AF2, AF3.
- FLW0031 (mined; was flow-index FL034) — reporting dashboards / read-model behind Reporting-ReadModel, covers UC0017.3; the read side (`/admin/reports/*`) is now evidenced as read-only SELECT-and-render controllers (no writes).

## Evidence Level

Confirmed for UC0017.1/.2 and AF1–AF3 (CSV-Export-Processor / SRV0010 export part, FLW0027, EN0001/EN0002/EN0004/EN0006/EN0009/EN0011). Confirmed for UC0017.3 (Reporting-ReadModel / SRV0010 read part, EN0031/EN0032), now that the reporting read-model flow is mined (FLW0031). Note: FLW0031 confirms the reporting figures are computed on page request (no read-model materialisation/cron) and that `snapshot_entity` is not actually read by any report controller — CostsSnapshot (EN0031) is read via `costs_entity`, ReportSnapshot (EN0032) is an independent CRUD entity with no report caller. This is a current-state modelling correction, not an evidence gap.
