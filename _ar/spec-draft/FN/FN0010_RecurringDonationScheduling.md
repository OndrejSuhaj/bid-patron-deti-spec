---
doc_id: FN0010
title: Recurring Donation Scheduling & Charging
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0007
  - UC0006
  - EN0010
  - EN0009
  - EN0004
---

# FN0010 – Recurring Donation Scheduling & Charging

## Purpose

Manage the recurring-donation subscription schedule (RecurringTransaction, EN0010): create it inactive alongside
the first donation, activate it once that donation is confirmed PAID, and periodically charge it — each charge
spawning a new donation Transaction (EN0009) that enters the money hub (FN0007). This is the subscription
capability exercised by UC0007 and activated as a side effect of UC0006.

## Responsibilities

- Create a subscription schedule (EN0010) alongside the first donation, initially inactive, holding the charge
  period and day, and (Netopia/RO) the gateway token.
- Activate the schedule (inactive → active) idempotently when its originating Transaction (EN0009) reaches PAID,
  as part of the shared confirmation side effects (FN0007).
- Select the schedules due for charge on a periodic run and charge each through the region-appropriate gateway
  (FN0008), creating a new child donation Transaction (EN0009) that enters the money hub (FN0007).
- Advance the schedule's per-charge timestamp on a successful charge, and support cancellation of the schedule.

## Related Use Cases

UC0007 – Process Recurring Donation (primary: due-schedule selection, charging, advancing).
UC0006 – Confirm Payment (Gateway Callback) (schedule activation and, for Netopia/RO, token capture, as a shared
confirmation side effect).

## Related Entities

EN0010 – RecurringTransaction (the schedule root: period, day, token, activation and last-charge state).
EN0009 – Transaction (the originating payment that seeds the schedule, and each new child Transaction spawned by
a charge).
EN0004 – Campaign (the funded target recomputed by FN0007 after each successful charge).

## Integrations

None directly. Each periodic charge is executed through the region gateway capability (FN0008), which isolates
the ComGate (CZ) and Netopia/MobilPay (RO) boundaries; the resulting outcome is handed to FN0007 as an ordinary
Transaction save.

## Constraints

- A charge is booked optimistically as PAID on a gateway call that completes without error, ahead of the
  gateway's own asynchronous confirmation of the outcome — a recorded money-integrity risk rather than an
  intended business rule.
- Due-schedule selection and the last-charge advance are not atomic with the charge itself: no claim/lock is held
  on the schedule while charging, so the dwell/dedup window is an application-level guard, not a uniqueness
  constraint — a double-charge risk under overlapping runs.
- A failed or declined charge does not advance the schedule's last-charge timestamp and does not cancel or
  deactivate the schedule; the schedule remains due and is retried on the next scheduled run.
- Whether cancelling a schedule also flips its active state is unevidenced (Hypothesis).
- Charge eligibility and execution are gated per region: hardcoded environment/country checks select which
  gateway's periodic run applies, and the RO (Netopia) leg is evidenced without an equivalent production-only
  guard.
- No confirmed current-state periodic charging path exists for the MD gateway; recurring charging via that
  gateway is Partial/Hypothesis, not confirmed.
