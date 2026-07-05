---
doc_id: JOB0004
title: Daily Report CSV Export Batch
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: batch
references:
  - FN0020
  - EN0009
  - EN0001
---

# JOB0004 – Daily Report CSV Export Batch

## Purpose

Materialise the full set of daily reporting CSV extracts (payments, leads, supporters, fundraisers,
patrons, campaigns, vouchers, accounting, contracts, gift payments, blacklist, low-risk, scoring-KO,
patron report) as same-day cache files, so on-demand admin downloads serve pre-built files without
re-querying. Realises the export arm of FN0020 (Reporting Read-Model & CSV Export).

Classification: **Confirmed**.

## Trigger Model

- Scheduled batch. Runs as the `export_csv` cron unit on the platform cron tick (hourly,
  `0 * * * *`), self-throttled via a persisted state key to run **at most once per calendar day**,
  first opportunity after 03:00. First-ever run only seeds the state key and returns.
- Evidence: `export_csv/export_csv.module:5` → `export_csv/src/ExportCsvCron.php:13`. Dossier: FLW0027.

## Input Scope

- A fixed map of 16 export jobs, each a read-only aggregate over reporting tables (Transaction,
  Application, profile/party, campaign, voucher, accounting, cost data). No caller parameters in the
  cron path (the on-demand path additionally accepts a campaign filter). See EN0009, EN0001.

## Processing Rules

- For each of the 16 jobs: delete yesterday's and today's target file if present, run the export
  method writing to a per-route dated file, and log completion.
- Each export runs one raw SQL dump to a temp file and reads it back to persist the dated cache file.
- Read-only: no domain entity mutation, no status transition.

## Side Effects

- Up to 16 dated CSV cache files written to a temp directory per run; previous-day and same-day
  files removed then re-created. These become the same-day cache the on-demand download path serves.
- **PII at rest (Legal/Security hazard):** extracts contain unencrypted birth numbers, names,
  addresses, emails, phones, contract numbers written to plaintext temp files that are never cleaned
  up. Randomized intermediate dump files also accumulate. No CZ/RO/MD tenant scoping (global).
- Log writes to reporting log channels. No external system calls (local filesystem sink only).

## Idempotency

- **Idempotent per day** by design: each run deletes and re-creates the day's files. Because the
  underlying dump refuses to overwrite an existing temp file, same-second collisions are rare but
  possible and would fail that one export.

## Failure Handling

- Per-export errors are caught and logged; the loop continues, so a batch can leave some files stale
  or missing while others succeed.
- Exceptions escaping the batch are logged and **re-thrown** by the cron wrapper (can abort the
  platform cron tick).
- Split web/DB host configurations can silently produce empty CSVs (temp-file round-trip failure).
  Documented current-state hazard (FLW0027).

## References

- FN: FN0020
- UC: UC0017
- EN: EN0009, EN0001, EN0002, EN0006, EN0004, EN0011
- Evidence: FLW0027 (scheduled path; on-demand download path is FN0020 / not a JOB)

## Open Items

- The daily export depends on database-server file privileges and temp-directory access; exact
  server configuration is environment-specific. `Hypothesis` on deployment specifics.
