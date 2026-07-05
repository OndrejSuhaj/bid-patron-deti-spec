---
doc_id: JOB0016
title: ComGate Transfer-List Reconciliation
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: batch
references:
  - FN0012
  - EN0009
  - ES0001
---

# JOB0016 – ComGate Transfer-List Reconciliation

## Purpose

Reconcile local Transactions against ComGate's daily transfer/settlement list: for each settled
transfer, stamp the matching Transaction with its variable symbol and mark it sent-to-bank. The
ComGate leg of FN0012 (Bank & Gateway Reconciliation / Matching) — glossary C051 (ComGate → bank
settlement).

Classification: **Confirmed** (CLI path); **Hypothesis** on any automatic scheduling.

## Trigger Model

- Batch / CLI command `comgatesync {days}` (optional day-count arg, default 1). There is **no cron
  hook** wiring this flow — it is invoked by an operator or an external scheduler.
- Evidence: `bank_integration/src/Command/ComgateSyncCommand.php` (`setName('comgatesync')`).
  Dossier: FLW0013.
- **Scope correction (recorded):** the ComGate cron (`comgate_cron`) runs the recurring-charge job
  (JOB0001), NOT this reconciliation. transferList reconciliation exists only in this CLI command.

## Input Scope

- For each of the last N days: the ComGate day transfer list, then each transfer's detail lines
  (payment rows only), from which the variable symbol and ComGate id are extracted. See EN0009.

## Processing Rules

- Per payment row: raw-SQL UPDATE the Transaction matched by ComGate id, setting variable symbol and
  the sent-to-bank flag, **capped at 30 rows per ComGate id** (split settlements beyond 30 are not
  marked).

## Side Effects

- Direct raw-SQL write to the Transaction table (variable symbol + sent-to-bank). **The entity
  lifecycle is bypassed** — no save hooks, no PAID cascade, no search re-index, no cache
  invalidation. See EN0009.
- Cross-system calls: ComGate transferList + singleTransfer (ES0001). Per-unmatched-row CLI error log
  and a 10-second sleep.

## Idempotency

- **Idempotent for matched rows** — re-running overwrites the same variable symbol and re-sets the
  sent-to-bank flag; no new rows are created. The 30-row cap is the only partial-reconciliation
  limit (documented data-loss risk).

## Failure Handling

- **No HTTP/JSON error handling:** a gateway 4xx/5xx/timeout throws and aborts the whole run for that
  day and remaining days. Unmatched ComGate ids only log + sleep, no retry/queue. Documented
  current-state hazards (FLW0013).

## References

- FN: FN0012
- UC: UC0008
- EN: EN0009
- ES: ES0001
- Evidence: FLW0013

## Open Items

- Automatic scheduling of this command is **unconfirmed** (no cron wiring; only the manual CLI path
  is evidenced). `Conflict/Hypothesis` recorded in FLW0013.
