---
doc_id: JOB0008
title: Voucher Expiry Reminder and Expired-Voucher Sweep
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: scheduler
references:
  - FN0011
  - EN0013
  - MSG0025
---

# JOB0008 – Voucher Expiry Reminder and Expired-Voucher Sweep

## Purpose

Remind recipients of unredeemed vouchers (**voucher**, glossary C023 — Dobrošek) whose validity ends
in 7 days, and raise an ops alert listing already-expired unredeemed vouchers. Supports FN0011
(Voucher Issuance & Redemption).

Classification: **Confirmed**.

## Trigger Model

- Scheduled. Runs as the `voucher` cron unit on the platform cron tick (hourly, `0 * * * *`). Two
  sub-steps, each self-throttled to **at most once per day** via its own persisted state key
  (seeded to 02:00); first-ever run of each only seeds and returns.
- Note: an environment-production guard around the whole run is present but **commented out**, so the
  job currently runs in every environment. `Confirmed`.
- Evidence: `voucher/voucher.module:11` → `voucher/src/VoucherCron.php:13`.

## Input Scope

- Reminder step: up to 10 paid, unredeemed, un-reminded vouchers with a recipient email whose
  expiry is within 7 days.
- Expired step: paid, unredeemed vouchers already past expiry (same base predicate, 0-day window).
  See EN0013.

## Processing Rules

- Reminder step: for each due voucher, send its deadline reminder (which also marks it reminded).
- Expired step: collect expired voucher ids and emit a single Slack alert listing them (no entity
  mutation).

## Side Effects

- Reminder message dispatched per due voucher (voucher-related transactional message via FN0019 —
  see MSG0025 family) and the voucher marked reminded.
- Slack ops alert listing expired voucher ids (FN0023).
- Persisted state-key writes (throttle cursors).

## Idempotency

- Reminder step is guarded by the un-reminded predicate (a voucher already reminded is not selected
  again), so re-runs do not double-remind. The expired-alert step is a read + alert (no dedup on the
  alert itself — the same ids can be re-listed on subsequent days until redeemed/handled).

## Failure Handling

- No per-item try/catch inside the loop; the cron hook has no wrapper try/catch either, so an
  exception propagates and can abort the platform cron tick. Documented as current-state behaviour.

## References

- FN: FN0011, FN0019, FN0023
- UC: UC0009
- EN: EN0013
- MSG: voucher reminder (MSG0024 / MSG0025 family — see MSG layer)
- Evidence: VoucherCron

## Open Items

- Whether a dedicated MSG doc covers the voucher **expiry reminder** (distinct from purchase /
  redemption confirmations) is a MSG-layer follow-up. `Partial`.
