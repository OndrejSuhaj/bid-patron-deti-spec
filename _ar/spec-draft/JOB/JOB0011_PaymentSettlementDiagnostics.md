---
doc_id: JOB0011
title: Payment Settlement Health Diagnostics
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: scheduler
references:
  - FN0012
  - FN0018
  - EN0009
---

# JOB0011 – Payment Settlement Health Diagnostics

## Purpose

Emit daily operational health alerts about payment/settlement and role integrity: (1) PAID
gateway Transactions older than 7 days not yet reconciled to the bank, and (2) users who have
Transactions but lack the supporter role. Diagnostic-only; supports FN0012 (reconciliation
oversight) and FN0018 (role integrity).

Classification: **Confirmed**.

## Trigger Model

- Scheduled. Runs as the `transaction` cron unit on the platform cron tick (hourly, `0 * * * *`).
- The unreconciled-payments check is gated `environment=production` and self-throttled to **once per
  day** (state key seeded to 02:00). The missing-role check runs on every tick with no throttle.
- Evidence: `transaction/transaction.module:100` (`transaction_cron` →
  `is_comgate_money_in_bank`, `check_users_without_role`).

## Input Scope

- Unreconciled check: PAID, non-test Transactions with a gateway id, no bank date, created >7 days
  ago.
- Missing-role check: users who own Transactions but do not hold the supporter role. See EN0009.

## Processing Rules

- Count the unreconciled Transactions and, if any, raise an ops alert with the count.
- Collect the user ids missing the supporter role and, if any, raise an ops alert listing them.
- **Read-only** — no entity mutation, no status transition.

## Side Effects

- Telegram ops alerts only (FN0023). No domain writes, no external system calls beyond the alert
  transport. Persisted state-key write for the daily throttle.

## Idempotency

- **Idempotent** (read + alert). The same conditions re-alert on subsequent runs/days until resolved
  upstream; there is no alert-dedup state.

## Failure Handling

- No dedicated try/catch in the hook; an exception would propagate to the platform cron runner. The
  checks are lightweight queries.

## References

- FN: FN0012, FN0018, FN0023
- UC: UC0008, UC0020
- EN: EN0009, EN0008
- Evidence: transaction_cron (`transaction/transaction.module:100-144`)

## Open Items

- These are health signals, not repairs; nothing reconciles or grants the missing role
  automatically. Recorded so the rebuild does not mistake them for corrective jobs.
