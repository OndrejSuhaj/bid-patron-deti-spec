---
doc_id: EN0009
title: Transaction
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004  # Campaign (Story) — donation target
  - EN0008  # User — owner / donor
  - EN0010  # RecurringTransaction — subscription schedule promoted from a paid transaction
  - EN0013  # Voucher — Dobrošek promoted from a paid transaction
  - BR-PaymentAndMoneyIntegrity
  - BR-PaymentGatewayCallbacks
  - BR-BankReconciliationAndMatching
  - BR-RecurringDonationPolicy
  - BR-VoucherPolicy
---

# EN0009 — Transaction

## Purpose

A Transaction is the record of a single money movement into the platform: a one-off donation, a
corporate gift, a voucher purchase, a recurring child charge, or an imported bank/gateway credit.
It is the central money-side entity of the domain — reaching the paid state on a Transaction is
what drives the donation target's raised total, promotes recurring schedules and vouchers, and
triggers donor-facing confirmation.

## Lifecycle

- PENDING
- AUTHORIZED
- PAID
- CANCELLED
- REFUNDED

## State Transitions

(none) → PENDING
trigger: UC0005 – Make a Donation (transaction created with a gateway reference at donation/voucher purchase)

PENDING | AUTHORIZED → PAID | CANCELLED | REFUNDED
trigger: UC0006 – Confirm Payment (Gateway Callback)

(none) → PAID
trigger: UC0008 – Reconcile Bank Transactions (bank/AISP import creates a Transaction already in the paid state)

PAID (unreconciled) → PAID (reconciled)
trigger: UC0008 – Reconcile Bank Transactions (bank date/period and matching identifiers are stamped on the Transaction; see BR-BankReconciliationAndMatching)

PAID → new child Transaction (overpayment split)
trigger: UC0005 / UC0006 / UC0007 (a paid Transaction whose donation target is overfunded is split into a new child Transaction booked to the transparent/collection account; see BR-PaymentAndMoneyIntegrity)

PAID → promotes EN0010 (RecurringTransaction) and EN0013 (Voucher)
trigger: UC0006 – Confirm Payment (Gateway Callback) (first reaching paid activates a linked RecurringTransaction and/or marks a linked Voucher as paid; see BR-RecurringDonationPolicy, BR-VoucherPolicy)

Conflict — requires clarification: REFUNDED is a declared status value; whether it is reachable only via a gateway callback (UC0006) or through another path is not evidenced (see Open Questions).

## Attributes

### System-managed attributes

- status (enumeration; required; values: PENDING, AUTHORIZED, PAID, CANCELLED, REFUNDED — the external payment status)
- fee (decimal; optional; gateway-reported processing fee)
- gateway reference (string; optional; the payment gateway's identifier for this Transaction)
- payment-identity key (string; optional; intended application-level unique identity for the Transaction; see Invariants)
- reconciliation markers (date/period and matching identifiers; optional; set when a Transaction is matched to a bank credit — see BR-BankReconciliationAndMatching)
- confirmation-sent flag (boolean; optional; whether the donor confirmation/thank-you has been sent for this Transaction)
- reconciled flag (boolean; optional; whether the Transaction has been matched to a bank/gateway settlement)
- donation-kind flags (boolean set; optional; donation / voucher / recurring / transparent-account — describe what the Transaction represents; not a single enumeration)
- kind (enumeration; optional; values: corporate, owner)
- parent (reference to EN0009 – Transaction; optional; set on a child Transaction created by an overpayment split)
- original donation target (reference to EN0004 – Campaign; optional; the donation target recorded at Transaction creation, retained if the target is later changed)

### User-provided attributes

- amount (decimal; required; the donated/paid amount)
- donation target (reference to EN0004 – Campaign; required; the Campaign the Transaction contributes to)
- owner (reference to EN0008 – User; optional; the donor/buyer, when identifiable)
- payment method (string; optional)
- comment (string; optional; donor-supplied note)
- voucher selection data (structured value; optional; present on a voucher-purchase Transaction; drives voucher creation — see EN0013, BR-VoucherPolicy)

## Invariants

- A Transaction's contribution to its Campaign's raised total is counted only while in the paid state; see BR-PaymentAndMoneyIntegrity.
- A donation target's raised total is a derived sum over its paid Transactions, recomputed whenever a Transaction is saved; see BR-PaymentAndMoneyIntegrity.
- A new Transaction cannot be created against a Campaign whose raised total already meets its target; see BR-PaymentAndMoneyIntegrity.
- An overpaying paid Transaction is split so the excess is booked to a new child Transaction linked to the parent via the self-referencing relationship, preserving the "raised does not exceed target" invariant; see BR-PaymentAndMoneyIntegrity.
- Gateway callback status mapping and callback authenticity are governed by BR-PaymentGatewayCallbacks; a Transaction's status must only change through a route permitted by that policy.
- The payment-identity key is intended to be unique per Transaction, but this uniqueness is enforced only at the application level, not by a database-level constraint; see Invariants gap in Open Questions and BR-PaymentAndMoneyIntegrity.
- A RecurringTransaction's activation depends on its originating Transaction reaching paid; see BR-RecurringDonationPolicy.
- A Voucher's paid/published state depends on its purchasing Transaction reaching paid; see BR-VoucherPolicy.
- The first Transaction an owning User brings to paid grants that User a donor-role promotion; rule content owned by BR-PaymentAndMoneyIntegrity (party-role side effect).

## Relationships

- EN0004 – Campaign (Story): donation target and original donation target
- EN0008 – User: owner/donor
- EN0009 – Transaction (self): parent, for a child Transaction created by an overpayment split
- EN0010 – RecurringTransaction: promoted/activated when this Transaction reaches paid
- EN0013 – Voucher: promoted/marked paid when this Transaction reaches paid

## Open Questions

1. Is REFUNDED reachable only from PAID via a gateway callback route, or through another path? Not fully evidenced.
2. What drives an AUTHORIZED → PAID capture outside the recurring-charge cron path? Not fully evidenced.
3. The payment-identity key has no database-level uniqueness constraint — concurrent callbacks or repeated submissions may be able to create duplicate Transactions or race the identity check. Flagged as a money-integrity gap under BR-PaymentAndMoneyIntegrity rather than a confirmed invariant.
