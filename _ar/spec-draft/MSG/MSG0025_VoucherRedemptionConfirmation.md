---
doc_id: MSG0025
title: Voucher Redemption Confirmation
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0009
references:
  - EN0013
  - EN0009
  - EN0004
  - EN0022
  - ES0006
---

# MSG0025 – Voucher Redemption Confirmation

## Purpose

Confirms that a gift Voucher ("Dobrošek", EN0013) has been successfully redeemed and applied as a
donation to a chosen child's Story (Campaign, EN0004). The message closes the redemption step of the
voucher lifecycle for whoever triggered it — the message itself does not carry payment-instrument
detail, only the outcome of the redemption.

## Trigger

UC0009 – Redeem / Validate Voucher, sub-flow **UC0009.2 — Apply (Redeem) a Voucher**, on the
successful-outcome step (Voucher bound to the target Campaign, marked redeemed). Firing condition:
the Voucher was found paid and not-yet-redeemed and the apply operation completed without error. Not
sent on validate-only (UC0009.1) and not sent on a failed apply (AF2).

## Recipients

**Conflict — requires clarification.** Two evidence sources disagree on who receives this message:

- **Code/flow reading (FLW0018, UC0009.2 step 8) — authoritative for current behavior:** the sole
  recipient is always the e-mail address recorded on the Voucher's originating purchase Transaction
  (EN0009), regardless of who performed the redemption. The dispatch resolves its addressee from the
  linked Transaction, so both the Option A (buyer redeems) and Option B (gifted recipient redeems)
  paths of UC0009.2 send to the same purchase-Transaction e-mail — not to whoever actually redeemed.
- **Notification Matrix reading (intake test-scenarios, SC-10F rows 6 and 9):** names two *different*
  addressees by option — the Donor for Option A (row 6) and the Recipient for Option B (row 9).

Per the trust default (code/flow wins for current behavior), the current system sends to the
purchase-Transaction e-mail in both paths; the Matrix's Donor-vs-Recipient split is **not** confirmed
by the code and is recorded here as a disagreement to be clarified, not silently reconciled. Whether
the Matrix describes intended target-state behavior is out of scope for MSG (current-state only).

- Delivered by e-mail via ES0006 (Mautic).
- No in-zone notification variant is evidenced for this message.
- No RO/MD variant is evidenced; voucher purchase/redemption is evidenced as CZ-scoped (see EN0013).

## Message Content

The conceptual information elements the message must carry:

- Confirmation that the gift voucher has been redeemed / applied successfully.
- The value of the voucher that was applied as a donation (EN0013 price).
- Identification of the Story/Campaign (EN0004) the donation was applied to, sufficient for the
  recipient to recognize which child it now supports.
- No further donation-instrument, payment-method, or Transaction detail is carried.

## Cross-references

- Trigger: UC0009 (Redeem / Validate Voucher).
- Subject entities: EN0013 (Voucher — redeemed instrument), EN0009 (Transaction — recipient-e-mail
  source), EN0004 (Campaign — redemption target/Story).
- Delivery channel: ES0006 (Mautic, transactional e-mail transport).
- Delivery record: EN0022 (EmailArchive) — if the platform's e-mail archive captures this dispatch,
  it is recorded there; not restated here.
- Distinct from the voucher-purchase confirmation message (sent earlier in the voucher lifecycle, at
  purchase/PAID time, to the buyer) — this message covers only the later redemption/apply step.
- The redemption flow's data-integrity caveats (non-unique voucher code; no concurrency guard on
  double-apply; no null-guard if the Voucher lacks a linked Transaction) are UC0009/FLW0018 concerns,
  not restated here.

## Evidence Level

Partial (Conflict on recipient) — the trigger and the *existence* of this redemption-confirmation
message are Confirmed, grounded in FLW0018 (Confirmed confidence) and UC0009's Apply sub-flow (steps
7–8), and corroborated by the Notification Matrix SC-10F rows 6 and 9 (which confirm a confirmation
is sent on redemption). The **recipient identity is a Conflict — requires clarification**: code/flow
(authoritative for current behavior) says the sole addressee is always the purchase-Transaction
e-mail, while the Matrix names the Donor (row 6) vs the Recipient (row 9) per option — see Recipients.
Content scope (value + story, no instrument detail) is Partial / Hypothesis — inferred from the
entity/flow evidence, since no template text is in scope for MSG and none is retained as evidence.
