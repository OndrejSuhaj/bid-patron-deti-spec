---
doc_id: JOB0019
title: Netopia Transaction Status Reconciliation
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: batch
references:
  - FN0008
  - FN0012
  - EN0009
  - ES0002
---

# JOB0019 – Netopia Transaction Status Reconciliation

## Purpose

Reconcile local Transaction statuses against the RO gateway (Netopia/MobilPay): query the gateway for
each Transaction's authoritative status and report (and optionally update) mismatches. Supports
FN0008 / FN0012 for the RO region.

Classification: **Confirmed**.

## Trigger Model

- Batch / CLI (Drush) commands: `netopia:sync` (full report to CSV) and `netopia:sync:20 {period}
  --update` (last-N-days status check, optionally writing corrected statuses). Operator-invoked; no
  cron wiring in source.
- Evidence: `netopia/src/Commands/NetopiaCommands.php` (`@command netopia:sync`, `netopia:sync:20`).

## Input Scope

- `netopia:sync`: all parent Transactions. `netopia:sync:20`: Transactions created within the given
  day window, joined to their user. RO-only. See EN0009.

## Processing Rules

- Per Transaction: build a MobilPay status request (seller-account hash) and call the gateway; map the
  returned external status code to the internal status; compose a report row.
- In `--update` mode, when the mapped status is valid and differs from the stored status, load the
  Transaction and save the corrected external status.

## Side Effects

- `--update` mode: Transaction external-status write **via entity save** (so save hooks fire — unlike
  the raw-SQL ComGate reconciliation JOB0016). Report mode writes a CSV to a temp path. See EN0009.
- Cross-system call: Netopia/MobilPay status SOAP (ES0002). Telegram ops alert on gateway error
  (FN0023).

## Idempotency

- **Idempotent** — re-running re-queries the gateway and only writes when the status changed; a
  converged Transaction is left unchanged.

## Failure Handling

- Per-Transaction SOAP faults are caught (skip / no update) or Telegram-alerted; the run continues.
  No batch-level abort on a single failure.

## References

- FN: FN0008, FN0012, FN0023
- UC: UC0005, UC0006, UC0008
- EN: EN0009
- ES: ES0002
- Evidence: NetopiaCommands (`netopia:sync`, `netopia:sync:20`)

## Open Items

- MobilPay seller-account id and hash password are hardcoded in the command (`<redacted>`). A
  hardcoded `parent == 30` skip and a fixed sandbox/production WSDL switch are present. `Confirmed`
  mechanism; scheduling not evidenced.
