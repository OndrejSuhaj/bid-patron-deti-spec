---
doc_id: EN0013
title: Voucher
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0009  # Transaction — the purchasing payment; owner and money source
  - EN0004  # Campaign — the Story a voucher is applied to
  - BR-VoucherPolicy  # paid/redemption governance, uniqueness & concurrency gaps
  - UC0006  # Confirm Payment — drives unpaid → paid
  - UC0009  # Redeem / Validate Voucher — drives paid-not-redeemed → redeemed
---

# EN0013 — Voucher

## Purpose

A Voucher ("Dobrošek") is a prepaid gift donation code: purchased through a Transaction (EN0009) by
a buyer, and later applied by a recipient to a Campaign (EN0004) of their choosing. It represents a
donation whose target Campaign is deferred to redemption time rather than fixed at purchase.

A Voucher has two independent lifecycle dimensions: whether it has been paid for (ready to use), and
whether it has been redeemed (applied to a Campaign). Its owner is not stored on the Voucher itself —
it is derived from the purchasing Transaction (see BR-VoucherPolicy).

---

## Lifecycle

Paid dimension:
- Unpaid
- Paid (ready to use)

Redemption dimension:
- Not redeemed
- Redeemed

The two dimensions combine into the effective states a Voucher can be in: Unpaid; Paid & not
redeemed (usable); Paid & redeemed (spent). See BR-VoucherPolicy for the governing constraints
(paid is a prerequisite for redemption; redemption is single-use).

---

## State Transitions

Unpaid → Paid
trigger: UC0006 — Confirm Payment (Gateway Callback), when the purchasing Transaction (EN0009) reaches its PAID state.

Paid & not redeemed → Paid & redeemed
trigger: UC0009 — Redeem / Validate Voucher, when the recipient applies the Voucher to a chosen Campaign (EN0004).

Paid → Expired
Hypothesis — an expiration/reminder attribute pair exists on the entity, but no expiry or reminder
process was found in the mined evidence. Not confirmed as a reachable transition.

---

## Attributes

### System-managed attributes

- status (paid state; boolean; required; values: unpaid / paid-ready-to-use; see BR-VoucherPolicy for the transition rule)
- is_applied (redemption state; boolean; required; values: not-redeemed / redeemed; see BR-VoucherPolicy for the transition rule)
- applied (timestamp; conditional; set when the Voucher is redeemed — see Open Questions for a recorded ambiguity with the paid transition)
- expiration (timestamp; optional; present on the entity; no confirmed lifecycle behavior — see Open Questions)
- reminded (timestamp; optional; present on the entity; no confirmed lifecycle behavior — see Open Questions)
- transaction (reference to EN0009 — the purchasing payment; source of the Voucher's owner, per BR-VoucherPolicy)
- campaign (reference to EN0004 — the Campaign the Voucher is applied to; set at redemption)

### User-provided attributes

- name (text; required; the voucher code and display label; see Open Questions for a recorded uniqueness gap)
- price (amount; required; the voucher's donation value)
- recipient_name (text; optional)
- recipient_email (text; optional)
- user_phone (text; optional)
- recipient_message (long text; optional)
- delivery_type (list; required; values: email / print; default email)

---

## Invariants

- A Voucher's paid/redemption lifecycle and its coupling to the purchasing Transaction and target
  Campaign are governed by BR-VoucherPolicy (paid dimension, redemption rules).
- A Voucher's owner is derived, not stored — see BR-VoucherPolicy.
- Current-state uniqueness and concurrency gaps in Voucher code and redemption are governed by
  BR-VoucherPolicy (current-state uniqueness and concurrency risks).

---

## Relationships

- EN0009 — Transaction (the purchasing payment; source of the Voucher's owner)
- EN0004 — Campaign (the redemption target)

---

## Open Questions

1. The `applied` timestamp appears to be written both when the Voucher becomes paid and when it is
   redeemed — which occurrence is authoritative for "redeemed on" reporting is unresolved.
   Conflict — requires clarification.
2. The voucher code (`name`) has no confirmed uniqueness guarantee at generation time (see
   BR-VoucherPolicy, current-state uniqueness and concurrency risks). Missing evidence on whether
   any other safeguard exists.
3. `expiration` and `reminded` attributes exist on the entity, but no expiry or reminder process was
   found in the mined evidence. Missing evidence — status of any such behavior is Unknown.
