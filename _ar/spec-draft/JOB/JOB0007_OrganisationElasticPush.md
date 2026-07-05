---
doc_id: JOB0007
title: Organisation Elastic Cloud Daily Re-push
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: scheduler
references:
  - FN0022
  - EN0018
  - ES0014
---

# JOB0007 – Organisation Elastic Cloud Daily Re-push

## Purpose

Push every Organisation (id + name) to the hosted Elastic Cloud `organisations` index once per day.
A distinct current use of FN0022 (Search Indexing & Synchronisation), separate from the entity
search-index queue (JOB0013).

Classification: **Confirmed**.

## Trigger Model

- Scheduled. Runs as the `organisation` cron unit on the platform cron tick (hourly, `0 * * * *`),
  self-throttled to **at most once per day** via a persisted last-run key (seeded to 05:00).
- Evidence: `organisation/organisation.module:31` → `organisation/src/OrganisationCron.php:13`.
  Corroborated in FLW0032 as the distinct daily Organisation index push.

## Input Scope

- **All** Organisation rows (full table, id + name), every run — there is no cursor or delta; it is
  a full re-push each execution. See EN0018.

## Processing Rules

- Read all organisations; for each, upsert a document to the Elastic Cloud organisations index
  (document keyed by organisation id).
- Skips the push entirely when the Elastic credentials env vars are absent.

## Side Effects

- One outbound upsert per organisation per run to the Elastic Cloud organisations index (ES0014).
  No local entity mutation.
- Telegram ops alert per failed document (FN0023).

## Idempotency

- **Idempotent** — the index document is keyed by organisation id, so re-pushing overwrites the same
  document. The trade-off is cost: a full re-push of the whole table every run (no delta).

## Failure Handling

- Missing Elastic credentials → silent skip (no push, no error).
- Per-document errors are alerted (Telegram) and skipped; the cron hook wraps the run in try/catch
  and only logs (does not re-throw), so a failure does not abort the platform cron tick.

## References

- FN: FN0022, FN0023
- UC: UC0018
- EN: EN0018
- ES: ES0014
- Evidence: FLW0032 (Organisation-index note), OrganisationCron

## Open Items

- The Elastic Cloud organisations index is a **distinct** Elastic surface from the App Search entity
  index used by JOB0013 and from the audit store; endpoints are hardcoded. Recorded so the rebuild
  keeps the two search surfaces separate.
