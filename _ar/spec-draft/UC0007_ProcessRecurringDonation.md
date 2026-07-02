# UC0007 — Process Recurring Donation

## Header

| Field | Value |
|---|---|
| UC ID | UC0007 |
| Name | Process Recurring Donation |
| Bounded Context | C4 |
| Primary Actor(s) | Scheduler, Integration(ComGate), Integration(Netopia) |
| Trigger Type | Cron |

## Actors & Responsibilities

- **Scheduler** — runs the per-gateway recurring-charge job on a daily cadence, throttled so each gateway job executes at most once per day.
- **Integration(ComGate)** — payment gateway for CZ; charges the stored recurring reference and returns a charge acknowledgement.
- **Integration(Netopia)** — payment gateway for RO; charges the stored gateway token and returns a synchronous charge result.
- **System** — selects due recurring schedules, creates the child Transaction (EN0009) per charge, records the outcome, advances the schedule, and triggers downstream side effects (notification, campaign recompute, indexing).

## Intent

Automatically charge donors who have an active recurring donation schedule (EN0010) on their scheduled day, creating a new Transaction (EN0009) for each successful or attempted charge, so that recurring support continues without manual donor action.

## Preconditions

- A RecurringTransaction (EN0010) exists in the active state, linked to an originating Transaction (EN0009) that previously reached PAID.
- The RecurringTransaction's scheduled day-of-month matches the current run date (days beyond 28 fold to day 1), it is not already canceled, and at least 28 days have passed since its last successful charge (or it has never been charged).
- For the CZ gateway path: the originating Transaction carries a gateway charge reference usable for recurring charges, and the run is on a production CZ instance.
- For the RO gateway path: the RecurringTransaction holds a non-expired gateway token, and the run is on an RO instance; if the donor's most recent canceled recurring charge is very recent (within a short cool-off window), that donor is skipped on day-fold runs.
- No confirmed current-state cron path exists for the MD gateway; recurring charging via that gateway is not evidenced (see Evidence Level).

## Main Flow

### UC0007.1 — Due-schedule selection (per gateway)

1. Scheduler: trigger the CZ recurring-charge job once the daily throttle window has elapsed.
2. Scheduler: trigger the RO recurring-charge job once its own daily throttle window has elapsed.
3. System: select all RecurringTransactions (EN0010) due for charge today (day-of-month match, not canceled, ≥28 days since last charge).
4. System: for each due RecurringTransaction, load the originating Transaction (EN0009) and the schedule details.
5. System: skip the schedule and continue to the next one if required charge data is missing (e.g. missing gateway charge reference for CZ, or missing/expired token for RO).

### UC0007.2 — Charge execution and child Transaction creation

1. System: create a new child Transaction (EN0009) carrying the donation amount, donor, and campaign (EN0004) from the originating Transaction, marked as recurring and initially pending.
2. Integration(ComGate): for a CZ schedule, charge the donor using the stored recurring reference from the originating Transaction.
3. Integration(Netopia): for an RO schedule, charge the donor using the stored gateway token on the RecurringTransaction.
4. System: mark the new Transaction as paid when the gateway call completes without error, or as canceled when the gateway call fails or reports an error.
5. System: record the gateway's returned charge reference on the new Transaction.
6. System: advance the RecurringTransaction's last-charge timestamp to the current time only when the gateway call did not fail.

### UC0007.3 — Post-charge side effects (on successful charge)

1. System: send a thank-you notification to the donor for the recurring payment.
2. System: reactivate the donor's account with an activation notification if the donor's account was previously blocked.
3. System: recompute the target Campaign's (EN0004) raised amount to include the new Transaction.
4. System: split the new Transaction into two — the funded portion and an overpayment portion routed to the transparent/general account — when the Campaign's raised amount would exceed its target.
5. System: send an internal ops notification for the successful CZ recurring charge (production environment only).
6. System: enqueue the new Transaction for search-index update.

## Alternative Flows

### AF1 — Gateway charge fails or is declined

1. Integration(ComGate): report a failure or the ComGate charge attempt raises an error.
2. Integration(Netopia): report a charge error code in the gateway response.
3. System: mark the new child Transaction as canceled.
4. System: leave the RecurringTransaction's last-charge timestamp unadvanced, so the schedule remains due and will be retried on a later scheduled run.
5. System: send a payment-canceled notification to the donor (RO/Netopia path only; no equivalent notification is evidenced on the CZ/ComGate path).

Outcome: No successful charge is recorded; the recurring schedule stays open for retry; the donor is notified only on the RO path.

### AF2 — First-ever run of a gateway's scheduler job

1. Scheduler: trigger the recurring-charge job for a gateway that has never recorded a previous run.
2. System: record the current run time as the baseline for future throttling.

Outcome: No charges are attempted on this run; charging begins from the next scheduled window.

### AF3 — Charge optimistically marked paid ahead of gateway confirmation (CZ/ComGate path)

1. Integration(ComGate): accept the charge request without an immediate error.
2. System: mark the new child Transaction as paid based on the absence of an error alone, without waiting for the gateway's asynchronous confirmation of the charge outcome.

Outcome: The Transaction is provisionally paid; final confirmation of the charge result depends on a separate asynchronous gateway notification handled outside this use case. This is a recorded money-integrity risk, not an intended business rule.

## Postconditions

- One new Transaction (EN0009) exists per due RecurringTransaction processed in the run, in either paid or canceled state.
- The RecurringTransaction's (EN0010) last-charge timestamp is advanced only for runs where the gateway call did not fail; failed runs leave the schedule due again on the next scheduled run.
- The target Campaign's (EN0004) raised amount reflects any newly paid Transaction, including any overpayment split.
- No RecurringTransaction is canceled or deactivated by this use case solely due to a failed charge attempt.

## Traceability

Target SRVs:
- RecurringPayment-Processor
- Payment-Processing
- ComGate-Adapter
- Netopia-Adapter
- MAIB-Adapter

EN entities:
- EN0010 RecurringTransaction — the recurring schedule selected, charged, and advanced by this UC
- EN0009 Transaction — the originating payment (source of charge reference) and the new child Transaction created per charge
- EN0004 Campaign — the donation target whose raised amount is recomputed after a successful charge

Integration boundaries:
- Integration(ComGate) — CZ recurring charge execution
- Integration(Netopia) — RO recurring charge execution
- MAIB (MD) — listed as a target adapter boundary in scope, but no current-state recurring-cron integration is evidenced for this gateway (see Evidence Level)

Flow Evidence:
- FLW0007 (recurring donation charge cron — CZ/ComGate and RO/Netopia paths)

## Evidence Level

Confirmed for the ComGate (CZ) and Netopia (RO) cron paths, the due-schedule selection guard, the optimistic-PAID and failed-charge-not-descheduled behaviors, and the post-charge side effects, all per FLW0007 and consistent with EN0010/EN0009/EN0004 lifecycles; Partial/Hypothesis for the MAIB (MD) adapter path, which appears in the SRV target list but has no confirmed recurring-cron flow in FLW0007 ("MD has no recurring cron in this flow").
