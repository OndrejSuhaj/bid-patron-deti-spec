---
doc_id: JOB0001
title: Recurring Donation Charge
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: scheduler
references:
  - FN0010
  - FN0008
  - FN0007
  - EN0009
  - EN0010
  - ES0001
  - ES0002
  - MSG0022
  - MSG0023
---

# JOB0001 – Recurring Donation Charge

## Purpose

Charge active recurring donation schedules (**recurring donation**, glossary C017) that have
reached their monthly due date, creating a new child donation Transaction per schedule and
booking it through the region payment gateway. Realises the charging arm of FN0010 (Recurring
Donation Scheduling & Charging).

Classification: **Confirmed** (cron trigger, due-selection, charge, and side-effect cascade all
evidenced in source).

## Trigger Model

- Scheduled. Two independent per-region cron units, each an implementation of the platform cron
  hook:
  - CZ gateway (ComGate) — gated `environment=production AND country=cz`.
  - RO gateway (Netopia/MobilPay) — gated `country=ro` (note: **no** environment guard on the RO
    leg — a non-production RO instance still attempts charges).
- Master cadence: the platform cron tick runs **hourly** (`0 * * * *`, dedicated cron container —
  evidence `intake/current-solution/_source/patronus/docker-compose.yml:70`). Each unit
  self-throttles via a persisted state key to run **at most once per day**, snapping the next
  window to 04:00. The first-ever run only seeds the state key and returns without charging.
- MD (MAIB) has **no** recurring-charge cron in current source. `Confirmed` absence.
- Evidence: `comgate/comgate.module:15` → `comgate/src/ComgateCron.php:15`; `netopia/netopia.module:15`
  → `netopia/src/NetopiaCron.php:17`. Full dossier: FLW0007.

## Input Scope

- Due recurring schedules selected by raw SQL over the recurring-schedule table: day-of-month
  matches today (day `>28` folded to `1`), not cancelled, and ≥28 days since last charge.
- ComGate additionally requires the parent Transaction to carry the gateway recurring/preauth id.
- Netopia additionally requires a non-expired stored card token, plus a day-fold cool-off skip
  (skip user if their latest cancelled recurring Transaction is ≤4 days old).

## Processing Rules

- For each due schedule: load the parent Transaction and its recurring record; create a new child
  Transaction copying price/user/campaign/flags with initial pending external status and the
  recurring flag set; call the gateway to charge (ComGate recurring endpoint / Netopia token
  charge SOAP); on a returned gateway id, record it on the child and advance the schedule's
  last-charge timestamp.
- ComGate hardcodes the child Transaction to the CZ transparent-account campaign, losing original
  story attribution. Netopia routes to the live campaign when active, else to the configured
  transparent account.

## Side Effects

- Creates one child donation Transaction per due schedule with external status PAID (optimistic)
  or CANCELLED. Advances the schedule's last-charge timestamp only when the gateway call did not
  fail (a failed schedule stays due and is retried next cron day). See EN0009, EN0010.
- The PAID child Transaction save fires the full donation PAID cascade (owned by FN0007): thank-you
  message (MSG0022 recurring-payment receipt via FN0019), campaign raised-money recompute,
  overpayment auto-split, search-index enqueue (→ JOB0013), blocked-owner reactivation, and CZ+prod
  Slack notification.
- Netopia CANCELLED branch additionally sends a dunning/failed-charge message to the user
  (MSG0023). ComGate has no equivalent dunning message.
- Cross-system calls: ComGate (ES0001) recurring charge; Netopia/MobilPay (ES0002) token charge;
  Telegram ops alert on missing data / recharge error (→ FN0023).

## Idempotency

- **Weak / at-risk.** The only dedup is the application-level 28-day SQL guard; there is no
  lock/claim on the schedule while charging, and the last-charge timestamp is written only after
  the gateway call. Overlapping cron runs, or a failure between charge and timestamp write, can
  double-charge the same schedule. No unique constraint enforces one charge per period.
- ComGate books the child as PAID merely because the charge call did not throw (authoritative
  result arrives later via the async payment callback), so a pending/declined charge can be
  recorded locally as PAID.

## Failure Handling

- Per-schedule charge errors are caught inside the loop and logged (Telegram); the schedule is not
  de-scheduled, so it retries on the next cron day with no cancel-after-N-failures policy.
- Setup/SQL errors are logged and **re-thrown** by the cron hook wrapper, which can abort the whole
  platform cron run for that tick.
- Money-integrity and double-charge hazards are documented current-state behaviour (see FLW0007
  Failure Modes; FN0010 notes).

## References

- FN: FN0010, FN0008, FN0007, FN0019
- UC: UC0007, UC0006
- EN: EN0009, EN0010, EN0004
- ES: ES0001, ES0002
- MSG: MSG0022 (recurring-charge receipt), MSG0023 (recurring-charge failed / RO dunning)
- Evidence: FLW0007

## Open Items

- Exact hourly-vs-daily interaction (the self-throttle snaps to 04:00 but the cron tick is hourly);
  the effective charge time depends on when the first post-04:00 tick lands. `Partial`.
- Whether cancellation flips the schedule inactive is unevidenced here (Hypothesis — see FN0010).
