---
doc_id: MSG0024
title: Voucher Purchase Confirmation
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0006
references:
  - EN0013
  - EN0009
  - EN0022
  - ES0006
  - UC0009  # contrast only — redemption-confirmation intent, does NOT trigger this message
---

# MSG0024 – Voucher Purchase Confirmation

## Purpose

Confirm that a gift voucher (Dobrošek) purchase has been paid, and deliver the voucher itself — its
code and the information needed to redeem it — to the Voucher's recipient (UC0006.4 step 6). This is
the buy-side counterpart to the voucher; it is distinct from the later redemption-confirmation
message sent when the voucher is actually applied to a Story (UC0009), which is a separate message
intent not covered by this document.

---

## Trigger

UC0006 (Confirm Payment — Gateway Callback), shared side-effect step UC0006.4 — fired when the
Transaction (EN0009) funding a Voucher (EN0013) purchase reaches its first PAID confirmation and the
System promotes the matching unpaid Voucher to paid/ready-to-use (UC0006.4 steps 5–6). SC-10F
(steps 2–3) confirms the outcome: after the Donor pays for the voucher via the web purchase flow,
the Voucher is set to PAID and the purchase confirmation is dispatched (to the Voucher's recipient,
per UC0006.4 step 6).

Evidence: UC0006 step UC0006.4.5–6; SC-10F steps 2.0–3.0 (`intake/test-scenarios/test-scenarios.md`).

---

## Recipients

- **Voucher recipient** — email, via ES0006 (Mautic). Per UC0006.4 step 6 the voucher-purchase
  confirmation is sent to the Voucher's recipient — i.e. the `recipient_email` / `recipient_name`
  captured on the Voucher (EN0013), distinct from the purchasing Donor who owns the funding
  Transaction (EN0009). This addressee is corroborated by sibling MSG0019, which records the
  voucher-purchase confirmation as addressed to the Voucher's recipient. The eventual redemption of
  the voucher against a Story is a separate later step (UC0009), out of scope for this message.
- The voucher purchase and its status are additionally visible to the purchasing Donor in the Donor
  Zone (in-application; SC-10F step 10), not part of this transactional-message contract.
- No CZ/RO/MD content variance is evidenced for this message; voucher purchase itself is evidenced
  only for the CZ/ComGate path.

---

## Message Content

Conceptually, each instance of this message carries:

- Confirmation that the voucher purchase has been paid (Voucher, EN0013, promoted to paid/ready-to-use
  status).
- The voucher code needed to gift or redeem it.
- The voucher's value ("Hodnota") and its expiration.
- How the voucher can be given to a recipient and subsequently redeemed/validated (i.e. that it can be
  applied to a chosen Story via the redemption flow, UC0009).
- Where the underlying purchase generated more than one voucher in the same Transaction, the
  fulfilment document(s) for the voucher(s) may accompany the message as an attachment.
- No card, bank-account, or other payment-instrument detail is included.

No fixed subject-line text, body markup, or template structure is asserted in this canonical
document — the concrete wording is instance/configuration data and out of scope for the MSG layer
(see rules-MSG.md restrictions). Every dispatch is archived as an EmailArchive (EN0022) record.

---

## Notes

- Distinct from the voucher redemption-confirmation message, sent to the purchase Transaction's
  e-mail address when a recipient applies the voucher to a Story (UC0009.2 step 8) — that is a
  separate message intent, not documented here.
- Distinct from the general donation-paid thank-you confirmation (MSG0019), which is addressed to
  Donors for non-voucher donation paths.
- Distinct from the internal ops-only voucher event notification on ES0015 (Slack): that is a
  separate, non-user-facing channel for operations staff and is out of scope for this MSG.
- A voucher expiry/reminder message is **not evidenced** as an active, currently-firing behavior —
  the Voucher entity (EN0013) carries a `reminded` timestamp field suggestive of a reminder job, but
  no dispatch mechanism for it was found in the mined flows. Uncertain — excluded from this document
  pending further evidence (see EN0013 Open Questions).
- Evidence Level: Confirmed for the trigger mechanism (PAID promotion of a linked Voucher) and the
  addressee being the Voucher's recipient (UC0006.4 step 6; corroborated by MSG0019; EN0013
  `recipient_email` / `recipient_name`). Partial for the precise conceptual content split
  when a single Transaction yields multiple vouchers, since the multi-voucher fulfilment-document
  attachment behavior is evidenced at the capability level but its exact presentation in this message
  is not fully visible from the cited sources.
