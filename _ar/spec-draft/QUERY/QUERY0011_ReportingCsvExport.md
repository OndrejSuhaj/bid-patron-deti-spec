---
doc_id: QUERY0011
title: Reporting CSV Export Bundle
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: export
references:
  - EN0001
  - EN0002
  - EN0006
  - EN0004
  - EN0009
  - EN0013
  - EN0011
  - EN0016
  - EN0017
  - EN0005
  - EN0008
  - UC0017
  - FN0020
  - FN0021
  - ARCH0006
  - ARCH0012
---

# QUERY0011 – Reporting CSV Export Bundle

## Purpose

The bulk CSV export surface: ~20 endpoints that dump business data (payments, leads, fundraisers,
patrons, supporters, campaigns/stories, vouchers, contracts, accounting, blacklist, low-risk,
scoring-KO, patroni report) as downloadable CSV. Grouped as one contract because they share one
controller, one output mechanism, and one set of systemic hazards.

Evidence: `web/modules/custom/export_csv/src/Controller/ExportCSVController.php` (dump* methods),
`export_csv.routing.yml`, `export_csv.permissions.yml`,
`web/modules/custom/export_csv/src/Controller/DownloadsController.php`,
`web/modules/custom/export_csv/src/ExportCsvCron.php`.

## Consumers

- Staff with `access reports` (most exports), `access accounting reports` (accounting export),
  `export leads` (leads export only). Downloads index at `admin/downloads`.

## Source Entities

- EN0001 Application, EN0002 ApplicationProfile, EN0006 Contact, EN0004 Campaign, EN0009 Transaction,
  EN0013 Voucher, EN0011 Contract, EN0016 Blacklist, EN0017 ScoringRecord, EN0005 Patron, EN0008 User.

## Filters and Grouping

| Export (route) | Content / filter | Notes |
|---|---|---|
| export-payments / -original-payments (`.../export-payments`) | Transactions; optional `?campaign=` filter; original = `parent IS NULL` | `is_donation` shown as Yes/No. Confirmed. |
| export-gift-payments / -ready-gift-payments | Applications reaching `gift_paid` / `gift_payment` state | via `application_states`. Confirmed. |
| export-leads (`.../export-leads`) | Full lead/story rows with fundraiser + patron PII | perm `export leads`. Confirmed. |
| export-fundraisers / -fundraisers-fulls | Fundraiser contact rows | Confirmed. |
| export-patrons / -unique-patrons | Patron lead rows / distinct patrons with campaign counts | `GROUP BY patron_profile`. Confirmed. |
| export-supporters | Donor mail + name + `SUM(price)` + `COUNT(*)` | `ext_status=PAID AND test=0`, GROUP BY mail. Confirmed. |
| export-campaigns | Story rows with fundraiser + patron PII | `app.campaign IS NOT NULL`. Confirmed. |
| export-vouchers | Voucher/transaction rows incl. sender/recipient email | Confirmed. |
| export-accounting | `[campaign_id, SUM(price), bank_month]` | `ext_status=PAID`, GROUP BY campaign, bank_month. Confirmed. |
| export-contracts | Applications with a contract | `app.contract IS NOT NULL`. Confirmed. |
| export-blacklist | Applications where scoring JSON has `fundraiser_blacklist='bl'` OR `patron_blacklist='bl'` | `JSON_EXTRACT`. Confirmed. |
| export-lowrisk / -scoring-ko | Applications in `scoring_ko`/`scoring_ok` state history / scoring-KO detail | Confirmed. |
| report-patroni | Wide patron activity matrix: leads/campaigns counts per year and per month (2017..2022, hard-coded) | `COUNT(IF(YEAR(...)=YYYY ...))`. Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| PII columns | name, last_name, `rc` (birth number), phone, email, street, city, `psc`, employer, occupation, `child_handicapped` | leads/patrons/campaigns/fundraisers dumps. **Sensitive.** Confirmed. |
| aggregates | `SUM(price)`, `COUNT(*)`, per-year/per-month counts | supporters, accounting, patroni. Confirmed. |
| paid/settlement columns | `ext_status`, bank_vs/date/month, ext_trans_id, ext_fee | payments/vouchers dumps. Confirmed. |

## Result Shape

- CSV file download (`Content-Disposition: attachment`), one file per endpoint.
- Header row emitted as a literal `SELECT '...'` UNION ALL data (column labels in row 1).

## References

- UC: UC0017 (Export Reporting Data)
- FN: FN0020 (Reporting Read-Model & CSV Export), FN0021 (Personal-Data Anonymisation — GDPR context)
- EN: EN0001, EN0002, EN0006, EN0004, EN0009, EN0013, EN0011, EN0016, EN0017, EN0005, EN0008
- ARCH: ARCH0006, ARCH0012

## Open Items

- **Hazard (PII at rest in shared /tmp):** each export runs raw SQL `... INTO OUTFILE '/tmp/<name>_<ts>.csv'`
  then re-reads it via `LOAD_FILE`. The generated file (containing `rc`/birth number, emails, phones,
  addresses, `child_handicapped`) is written to a world-scoped `/tmp` path on the DB host and is not
  guaranteed to be deleted; the constructor even serves a same-day cached `/tmp/<name>_YYYY_MM_DD.csv`
  if it already exists. This is a GDPR-relevant data-at-rest exposure. Confirm retention/cleanup.
  `Conflict — requires clarification.`
- **Hazard (raw SQL, no tenant filter):** every dump is a hand-written SQL string with `INTO OUTFILE`;
  none applies a country/tenant filter, so on a shared DB an export would span all countries.
- **Hazard (hard-coded time windows):** the patroni report enumerates years/months 2017–2022 in code;
  it silently omits later periods. Partial.
- **Hazard (interpolated request param):** `export-payments`/`-lowrisk` build a `WHERE campaign = <id>`
  fragment from the request; the value is cast to `(int)` before concatenation (mitigation noted), but
  the pattern is fragile — flag for the rewrite.
- Secrets/credentials: none embedded in these queries (`<redacted>` — nothing to redact).
