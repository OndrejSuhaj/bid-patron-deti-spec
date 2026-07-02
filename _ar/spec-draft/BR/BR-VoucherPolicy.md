---
doc_id: BR-VoucherPolicy
title: Voucher (Dobrošek) Policy
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0013
  - EN0009
  - EN0004
  - SYSTEM
references:
  - EN0013
  - EN0009
  - EN0004
  - UC0009
  - UC0006
---

# BR – Voucher (Dobrošek) Policy

## Purpose

Governs the Voucher (EN0013) across its two coupled state dimensions — paid and redeemed — including
single-use redemption, single-recipient re-attribution of the purchasing donation, and the current-state
code non-uniqueness and redemption race conditions.

---

## Paid dimension

- A Voucher SHALL become paid/ready-to-use only when its purchasing Transaction (EN0009) reaches the PAID
  state.
- A Voucher's owner SHALL be derived from its purchasing Transaction (EN0009) and SHALL NOT be stored
  independently of that Transaction.

---

## Redemption (single-use, single recipient)

- A Voucher SHALL be redeemable only when it is already paid and has not already been redeemed.
- On redemption, a Voucher SHALL be bound to exactly one target Campaign (EN0004), marked redeemed, and
  stamped with a redemption timestamp.
- On redemption, the purchasing Transaction (EN0009) SHALL be re-attributed to the target Campaign
  (EN0004), so the donated amount lands against the Campaign the recipient chose.
- Validation of a Voucher and redemption of a Voucher SHALL both require the Voucher to be in the paid
  and not-yet-redeemed state; a Voucher that is unpaid or already redeemed SHALL NOT be validated as
  usable or redeemed again.

---

## Current-state uniqueness and concurrency risks

- Current-state: a Voucher code SHALL NOT be assumed unique at the data level; the system does NOT
  currently enforce uniqueness of the Voucher code (current-state gap). Redemption by code can resolve to
  an arbitrary matching Voucher when codes collide.
- Current-state: the not-yet-redeemed check and the redemption update SHALL NOT be assumed to be executed
  as a single guarded operation; the system does NOT currently enforce mutual exclusion between them
  (current-state gap). Two near-simultaneous redemption requests for the same Voucher can both pass the
  not-yet-redeemed check before either update is saved, producing a double-apply.
- Current-state: Voucher validation and redemption SHALL NOT be assumed to require authentication or to
  be rate-limited; the system does NOT currently enforce either control (current-state gap).

---

## Non-Goals

- This rule does not define the Voucher's persisted attributes, field types, or storage shape — see EN0013.
- This rule does not define the step-by-step validation/redemption request flow — see UC0009.
- This rule does not define the payment-side PAID transition mechanics of the purchasing Transaction — see
  BR-PaymentAndMoneyIntegrity (owns the PAID cascade) and UC0006.
- This rule does not define the content or dispatch conditions of the purchase- or redemption-confirmation
  messages — see BR-TransactionalMessaging.
