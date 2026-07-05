# QUERY Synthesis Report — AR:QuerySpecSynthesizer

**Agent:** AR:QuerySpecSynthesizer (closure phase 04)
**Scope:** read-side contracts (read-models + reports) for Patronus current state.
**Ground truth:** Patronus source — Drupal 10 custom modules + Views config under
`intake/current-solution/_source/patronus/`. Every contract was verified against code/config; the BA
prose layers (EN/UC/FN/BR/ARCH/ES/MSG) were used only for terminology and cross-references.

## What was produced

- 14 QUERY docs: `_ar/spec-draft/QUERY/QUERY0001..QUERY0014`.
- `_ar/spec-draft/QUERY-map.md` (index, domain coverage, views disposition, systemic hazards).
- This report.
- Evidence notes: `_ar/evidence/query-synthesis-notes.md`.

## Method

1. Enumerated all 48 Views (45 in `config/`, 3 account zones in `sync_config/config_czech/`) and
   summarised base table, fields (with aggregation), filters, arguments, sorts, access, paths via a
   YAML extraction pass (deterministic, no guessing).
2. Traced the code-side read paths not expressible as Views: the public story catalogue REST resource
   (`CampaignsResource` v33), region counts (`RenderRegionsController`), the `reports` module
   controllers, the `export_csv` controller, the costs/snapshot entities, and the Elasticsearch
   search mount.
3. Grouped overlapping read surfaces into stable contracts (one QUERY per read-model/report),
   following the task's requested grouping (account zones, gift categories, story catalogue + region
   counts, reporting/costs/snapshot + CSV export, admin lists).
4. Wrote each doc with purpose, base entity (→EN by doc_id), filters, aggregations, derived fields,
   sort/paging, output intent, role scope, and documented hazards. No SQL reproduced.

## Evidence classification

| Class | Count | Notes |
|---|---|---|
| Confirmed | 9 | QUERY0002, 0003, 0005, 0006, 0007, 0008, 0009, 0011, 0013, 0014 — verified directly in config/code (fields, filters, roles, paths). (QUERY0014 Confirmed.) |
| Partial | 5 | QUERY0001 (donor headline-sum semantics), QUERY0004 (CZ-only hard-coding), QUERY0010 (manual vs cron costs inputs), QUERY0012 (search semantics live in external app). |
| Uncertain | 0 (doc-level) | Some in-doc items marked Uncertain (external ES query semantics, detailed productivity arithmetic). |
| Blocked | 0 | — |

Count note: 10 docs are doc-level Confirmed and 4 are doc-level Partial (14 total). Partial docs carry
Confirmed structural facts plus explicitly-flagged unverified semantics.

## Key read-side findings (verified in source)

1. **Two "raised money" definitions.** `CampaignEntity::getCampaignRaisedMoney()` computes
   `SUM(price) WHERE campaign=id AND ext_status='PAID'` and persists to `campaign_raised`; the admin
   story list and catalogue read the persisted field, while several reports and the donor zone
   re-sum on demand. Persisted value freshness depends on `updateCampaignRaisedMoney()` runs.
2. **CSV export writes PII to shared `/tmp`.** Every `export_csv` dump runs raw SQL
   `... INTO OUTFILE '/tmp/<name>_<ts>.csv'` then `LOAD_FILE`s it back; leads/patrons/campaigns dumps
   contain `rc` (birth number), email, phone, address and `child_handicapped`. The controller
   constructor also serves a same-day cached `/tmp/<name>_YYYY_MM_DD.csv`. Data-at-rest GDPR exposure.
3. **Magic constants and country branches in reports.** `TransactionsReportsController` hard-codes
   `campaign = 3100` for a "balance" scalar; `MonthlyReportController` guards `campaign <> 2200` /
   `id <> 2200` behind `Settings::get('country') == 'cz'`. Donor sums in `CampaignsResource` branch on
   `country === 'cz'` (`transparent=1`) vs non-CZ (`is_recurring=1`).
4. **`LIKE`/`NOT LIKE` on status strings** in reports (`state NOT LIKE 'mistake'`,
   `ext_status LIKE 'PAID'`) — substring, not equality.
5. **No tenant filter** on back-office lists and exports; multi-country safety depends on a
   single-DB-per-country deployment (unconfirmed).
6. **Unguarded view access.** `payments_report` and `application_activity` displays have
   `access: type=none`, relying on route/menu wrappers.
7. **CZ-only region map** duplicated across `CampaignsResource` and `RenderRegionsController`
   (14 hard-coded kraj slugs).

## Cross-layer discipline

- Entity attributes are referenced by EN doc_id, never restated (status vocabulary → EN/STAT;
  message content / notification matrix → MSG; rule content → BR).
- No SQL, ORM builders, controller class names as contract fields, or UI component trees were placed
  in the read-side contract sections (source file paths appear only as evidence provenance).

## Open items handed forward

- **ACL closure:** `payments_report`, `application_activity` unguarded displays; PII-list role scope
  (`accounts.rc`, email archive breadth). See QUERY0008, QUERY0013, QUERY0014.
- **JOB closure:** costs/snapshot capture cadence and `updateCampaignRaisedMoney()` refresh schedule
  (QUERY0007, QUERY0010).
- **BR/FN clarification:** donor "donated/allocated" sum semantics and the `transparent` vs
  `is_recurring` split (QUERY0001); `LIKE` vs equality intent (QUERY0009).
- **Rewrite backlog:** PII-at-rest export mechanism, magic campaign ids, per-tenant scoping.

## Idempotency

Re-runnable: docs are keyed by stable doc_id and derived deterministically from source; a re-run
regenerates the same set. `status: draft` throughout; `modules` frontmatter omitted at draft per
convention.
