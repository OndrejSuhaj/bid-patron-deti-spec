---
doc_id: EN0010
title: RecurringTransaction
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0009  # Transaction — the originating / linked payment
  - BR-RecurringDonationPolicy
  - BR-PaymentGatewayCallbacks
  - UC0005
  - UC0006
  - UC0007
---

# EN0010 — RecurringTransaction

## Purpose

A recurring donation schedule: the standing arrangement that authorizes a donor's payment to be
charged repeatedly (a "recurring" / subscription donation) rather than once. It carries the
recurring contribution amount, charging period and day-of-month, the gateway authorization needed
to charge future payments without donor re-entry, and the record of when it was last charged or
cancelled.

---

## Lifecycle

- Inactive — created alongside the donor's first payment; not yet authorized to charge.
- Active — authorized; eligible for periodic charging by its configured schedule.

Hypothesis — Not evidenced: a distinct Cancelled state may exist once a cancellation timestamp is
recorded; whether cancellation flips the Activation state (vs. only stamping a timestamp) is
unresolved — see Open Questions #1. The Activation state attribute evidences only Inactive / Active.

---

## State Transitions

(none) → Inactive
trigger: UC0005 — Make a Donation (created together with the first, originating payment)

Inactive → Active
trigger: UC0006 — Confirm Payment (Gateway Callback), when the linked Transaction (EN0009) reaches
its PAID state; see INV01. The transition is idempotent — re-confirmation while already Active has
no further effect.

Active → Active (charged)
trigger: UC0007 — Process Recurring Donation; a periodic charge creates a new child Transaction
(EN0009) and, on success, advances the schedule's last-successful-charge record; see INV02.

Active → Active (gateway authorization updated)
trigger: UC0006 — Confirm Payment (Gateway Callback); the gateway authorization used for future
charges may be (re-)established from a region's confirmation callback.

(No Active → Cancelled transition is listed: its trigger and even the existence of a distinct
Cancelled state are not evidenced — see Lifecycle Hypothesis note and Open Questions #1.)

---

## Attributes

### System-managed attributes

- Recurring contribution amount (numeric; optional; the periodic donation amount)
- Charging period (categorical; the recurrence cadence)
- Payment provider (categorical; the gateway routing this schedule's charges)
- Charge day (numeric; the day-of-month on which the schedule becomes due)
- Activation state (categorical; values: Inactive / Active — see Lifecycle)
- Gateway authorization (opaque; conditional; the token enabling future charges without donor
  re-entry; not established for every gateway — see Open Questions)
- Gateway authorization expiry (date/time; conditional; when present, the point after which the
  gateway authorization is no longer usable)
- Last successful charge (date/time; optional; timestamp of the most recent successful periodic
  charge)
- Cancellation timestamp (date/time; optional; when a cancellation was recorded)

### User-provided attributes

- Label (text; required; the schedule's identifying name)

---

## Invariants

- INV01 — Activation depends on the originating Transaction (EN0009) reaching PAID; see BR-RecurringDonationPolicy.
- INV02 — Each periodic charge derives a new child Transaction (EN0009) from the schedule and its
  originating Transaction, and due-selection for charging is governed jointly by the schedule and
  that Transaction; see BR-RecurringDonationPolicy.
- INV03 — A RecurringTransaction cannot exist without its originating Transaction (EN0009); see
  BR-RecurringDonationPolicy.
- INV04 — Gateway confirmations that establish or update the gateway authorization are authenticated
  and mapped per BR-PaymentGatewayCallbacks.

---

## Relationships

- EN0009 — Transaction (the originating and each subsequently charged payment; sole relation)

---

## Open Questions

1. Cancellation effect — a cancellation timestamp is recorded, but whether cancellation also
   transitions Activation state from Active to Inactive/Cancelled is not evidenced. Status:
   Uncertain.
2. Charging period granularity — the charging period is a canonical value from an underlying
   free-form field; which discrete cadences occur in practice (e.g., monthly only) is not
   evidenced. Status: Uncertain.
3. Gateway authorization coverage — a gateway authorization value has only been evidenced for one
   regional gateway; whether other gateways charge this schedule without any stored authorization,
   or via a different mechanism, is not evidenced. Status: Uncertain.
