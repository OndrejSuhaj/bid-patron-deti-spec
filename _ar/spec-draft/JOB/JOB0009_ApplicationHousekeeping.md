---
doc_id: JOB0009
title: Application Data Housekeeping
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: repair
references:
  - FN0001
  - EN0001
  - EN0006
---

# JOB0009 – Application Data Housekeeping

## Purpose

Periodic maintenance of Application data: prune old application-session records, strip attachment
files from applications a fixed window after they reached configured statuses, and run a
state-consistency diagnostic. Supports FN0001 (Application Intake & Case Management).

Classification: **Confirmed** (housekeeping steps); the state-fix step is **diagnostic-only** — its
actual state writes are commented out (see Processing Rules).

## Trigger Model

- Scheduled. Runs as the `application` cron unit on the platform cron tick (hourly, `0 * * * *`).
  No internal daily throttle — it runs on every tick.
- Evidence: `application/application.module:935` → `application/src/ApplicationCron.php:15`.

## Input Scope

- Application-session records older than ~6 months.
- Applications that reached the configured attachment-removal statuses within a ~30–32 day window
  (selected from the status-history table).
- The most recent 5 000 applications for the state-consistency diagnostic. See EN0001, EN0006.

## Processing Rules

- Delete stale application-session records.
- For applications in the removal window, clear the configured attachment file fields on the
  fundraiser profile and save (only when the application's current state is in the configured set).
- State-fix diagnostic: for the recent applications, compute the state each should be in vs its
  current state and log mismatches. **The corrective state writes are commented out** — this step
  currently only reports, it does not change states. `Confirmed`.
- Flushes all caches at the end of the run.

## Side Effects

- Deleted application-session entities; attachment file references cleared on matching profiles
  (attachment removal is the only entity mutation the job performs). See EN0006.
- Diagnostic log lines (and Telegram for flagged mismatches). Full cache flush.
- No external system calls.

## Idempotency

- **Idempotent** — session deletion and attachment clearing are naturally repeatable (an
  already-cleared field / already-deleted session is skipped or a no-op). The diagnostic is
  read-only.

## Failure Handling

- The cron hook wraps the run, logs on error, and **re-throws** (can abort the platform cron tick).
  No per-item guards inside the steps.

## References

- FN: FN0001
- UC: UC0001, UC0019
- EN: EN0001, EN0006
- Evidence: ApplicationCron

## Open Items

- The end-of-run full cache flush on an hourly cron is an operational concern (documented, not
  redesigned here). The attachment-removal window relies on a two-day band in the status-history
  table; a missed run can skip an application permanently. `Confirmed` mechanism.
