---
doc_id: QUERY0009
title: On-Screen Reporting Dashboards & Reports
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: dashboard
references:
  - EN0009
  - EN0001
  - EN0004
  - EN0025
  - EN0008
  - UC0017
  - FN0020
  - ARCH0006
  - ARCH0012
---

# QUERY0009 – On-Screen Reporting Dashboards & Reports

## Purpose

The back-office reporting surfaces rendered as HTML tables/charts by the `reports` module: donations
dashboard, monthly/annual transaction summaries, campaign reports (by coordinator, by days),
applications/leads report, productivity reports, and the accounting (paid-campaigns) report. These
are computed read-models, not entity list views.

Evidence: `web/modules/custom/reports/src/Controller/` — `DashboardController`,
`TransactionsReportsController`, `CampaignsReportsController`, `ApplicationsReportsController`,
`ProductivityReportsController`, `CurrentProductivityReportsController`, `MonthlyReportController`,
`AccountingReportsController`; routes in `reports.routing.yml`.

## Consumers

- Staff holding `access reports`; accounting report needs `access accounting reports`; productivity
  needs `access productivity reports`.

## Source Entities

- EN0009 – Transaction (donations sums, dashboard, monthly, campaigns, accounting)
- EN0001 – Application (applications/leads counts, productivity)
- EN0004 – Campaign (campaign reports, productivity, accounting join)
- EN0025 – ApplicationLog (productivity: state-change timing)
- EN0008 – User (coordinator dimension)

## Filters and Grouping

| Report (route) | Grouping / filter | Notes |
|---|---|---|
| Dashboard (`admin/reports/dashboard`) | Paid transactions by weekday; by weekday×hour heatmap; counts | `ext_status LIKE 'PAID'`. Confirmed. |
| Transactions/Payments (`admin/reports/payments`) | Paid donations by year and year×month: count, sum, average | `ext_status=PAID AND is_donation=1`, GROUP BY year(,month). Plus headline scalars. Confirmed. |
| Campaigns (`admin/reports/campaigns/{begin}/{end}`, `/{uid}`, campaigns-by-days) | Campaigns published in a month range, optionally by coordinator or by day | `published BETWEEN :begin AND :end`. Confirmed. |
| Applications/Leads (`admin/reports/leads`) | Application counts by year/month excluding `mistake`/`duplicate` states | `state NOT LIKE 'mistake'/'duplicate'`. Confirmed. |
| Monthly (`admin/reports/monthly-report`) | Monthly/annual application + active-campaign + gift totals | Country-aware (see Open Items). Confirmed. |
| Productivity (`admin/reports/productivity`, cord-applications) | Per-coordinator published campaigns, gift-price sums, app throughput by week | Confirmed. |
| Accounting (`admin/reports/accounting`) | Paid sum per campaign per bank month | `ext_status=PAID`, GROUP BY campaign, bank_month. Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| donation sum / count / average | Aggregated paid-donation metrics | `SUM(price)`, `COUNT(*)`, `SUM/COUNT`. Confirmed. |
| headline scalars (Transactions report) | Stories supported, overall donated, donors, unique donors, "balance" | Raw SQL with `transparent=1 AND test=0 AND ext_status=PAID`; "balance" hard-codes `campaign = 3100`. Confirmed. |
| campaign/coordinator throughput | Published counts, gift-price sums per coordinator/day/week | Confirmed. |
| application counts | By period, excluding mistake/duplicate | Confirmed. |
| accounting rows | `[campaign_id, paid_sum, bank_month]` | Confirmed. |

## Result Shape

- Rendered HTML tables and chart data (Twig `dashboard.html.twig` / `reports.html.twig`); some
  offer a companion CSV download (see QUERY0011).

## References

- UC: UC0017 (Export Reporting Data — on-screen + export together)
- FN: FN0020 (Reporting Read-Model & CSV Export)
- EN: EN0009, EN0001, EN0004, EN0025, EN0008
- ARCH: ARCH0006 (Donations & Payments), ARCH0012 (Platform, Search & Operations)

## Open Items

- **Hazard (raw SQL, magic constants, no tenant filter):** the reports are built from ad-hoc raw SQL
  strings (`$this->database->query("...")`); several hard-code campaign ids (`campaign = 3100` for the
  "balance" scalar; `campaign <> 2200`/`id <> 2200` guarded by `Settings::get('country') == 'cz'` in
  MonthlyReport). Numbers are global — no country/tenant filter beyond those constants. Observation.
- **Hazard (LIKE for status/state matching):** state filters use `LIKE`/`NOT LIKE` on status strings
  (e.g. `state NOT LIKE 'mistake'`, `ext_status LIKE 'PAID'`), which is a substring match, not an
  exact-equality match; a status whose name contains another as a substring could be mis-counted.
  Confirm intended exactness. `Conflict — requires clarification.`
- Exact metric formulas for productivity weekly aggregation are extensive; only the shape is captured
  here — treat detailed per-metric arithmetic as `Uncertain` until individually verified.
