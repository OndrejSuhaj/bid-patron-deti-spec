---
doc_id: MSG0019
title: Donation Confirmation — Paid (Thank-You)
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0006
references:
  - EN0009
  - EN0004
  - EN0008
  - EN0022
  - ES0006
---

# MSG0019 – Donation Confirmation — Paid (Thank-You)

## Purpose

Thank the Donor and confirm that their donation has been successfully received — i.e. the underlying
Transaction (EN0009) has reached the PAID status. This message covers the three donor-initiated
money paths that resolve to a first PAID confirmation: a one-time donation to a specific Story
(Campaign, EN0004), a donation to the general/transparent collection account, and a bank transfer
reconciled against the collection account. It is the donor-facing counterpart to the status-driven
Parent/Patron messaging (MSG0005/MSG0006) — this message is addressed to the Donor, not to the
Parent or Patron.

---

## Trigger

UC0006 (Confirm Payment — Gateway Callback), shared side-effect step UC0006.4 — fired on the first
time a given Transaction (EN0009) is saved into the PAID status, regardless of which regional
gateway path resolved it (ComGate/CZ, Netopia/RO, MAIB/MD callback or poll) or whether the PAID
status was instead set from a reconciled bank transfer. The System marks the Transaction as having
already sent this confirmation so that a later re-save that leaves the status unchanged does not
re-trigger it (UC0006.4 step 2; UC0006 AF2).

For the bank-transfer path, the trigger additionally requires that the Donor supplied a matching
email address (recorded against the transfer at reconciliation) — if no email was captured, this
message does not fire for that Transaction.

Evidence: UC0006 step UC0006.4.1–2; Notification Matrix acceptance scenarios SC-10A (step 8), SC-10C
(step 6), SC-10D (step 5) in `intake/test-scenarios/test-scenarios.md`.

---

## Recipients

- **Donor** — email, via ES0006 (Mautic). This is the sole party addressed by this message; it is not
  sent to the Parent, Patron, or any operations role.
  - One-time Story donation and general/transparent collection-account donation: always sent (the
    email address is a mandatory field captured at donation time).
  - Bank transfer: sent only if the Donor included a matching email address at the time of transfer
    (SC-10D); otherwise the Donor receives no email for that Transaction.
- The confirmed PAID status and the donation are additionally visible to the Donor in the Donor Zone
  (in-application, not part of this transactional-message contract).
- No CZ/RO/MD content variance is evidenced for this message beyond the per-country template
  resolution already documented at the capability level (FN0019); the underlying gateway differs by
  region (ComGate/CZ, Netopia/RO, MAIB/MD) but the message contract itself is not shown to differ by
  region.

---

## Message Content

Conceptually, each instance of this message carries:

- A thank-you addressed to the Donor for their support.
- Confirmation that the donation's payment has been successfully received (status PAID) — not merely
  initiated or pending.
- The confirmed donation amount.
- Identification of what the donation supports, where attributable: the specific Story/Campaign
  (EN0004) for a story-targeted donation, or the general/transparent collection account for a
  collection-account donation or a reconciled bank transfer without a specific-story assignment at
  send time.
- No card, bank-account, or other payment-instrument detail is included.

No fixed subject-line text, body markup, or template structure is asserted in this canonical
document — the concrete wording is instance/configuration data and out of scope for the MSG layer
(see rules-MSG.md restrictions). Every dispatch is archived as an EmailArchive (EN0022) record.

---

## Notes

- Two distinct message variants exist at the configuration level depending on the donation's target
  (story-attributed vs. general/transparent collection-account), but both realise the same message
  contract described above — thank-you + PAID confirmation + amount + (where attributable) the
  supported Story; this document treats them as one canonical message rather than two, per the
  MSG grouping rule (group by message type, not by config variant or matrix row).
- Sent once per Transaction (EN0009), guarded by an already-sent marker on the Transaction
  (UC0006.4 step 2); a later re-processing of the same Transaction that does not change its status
  does not re-send this message (UC0006 AF2).
- Dispatch happens synchronously as part of the payment-confirmation processing in UC0006.4, not as
  a deferred/batched send.
- Distinct from the internal ops-only donation event notification on ES0015 (Slack): that is a
  separate, non-user-facing channel for operations staff and is out of scope for this MSG.
- Distinct from the voucher-purchase confirmation (also triggered in UC0006.4, addressed to the
  Voucher's recipient) and from the campaign-success confirmation (triggered when the Campaign's
  target is met) — both are separate message intents not covered by this document.
- Evidence Level: Confirmed for the trigger mechanism, the PAID-guard, and the Donor-as-recipient
  contract (UC0006.4; SC-10A/10C/10D). Partial for the exact conceptual content split between the
  story-attributed and collection-account variants, since the precise wording differences are
  configuration data not fully visible from the cited sources.
