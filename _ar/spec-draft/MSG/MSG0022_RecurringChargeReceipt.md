---
doc_id: MSG0022
title: Recurring Donation Charge Receipt
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0007
references:
  - EN0010
  - EN0009
  - EN0008
  - EN0022
  - ES0006
---

# MSG0022 – Recurring Donation Charge Receipt

## Purpose

Confirm to the Donor that a periodic charge against their standing recurring donation (RecurringTransaction,
EN0010) has been processed successfully. This is the per-charge receipt for an already-established recurring
subscription — distinct from the one-time donation confirmation (MSG0019), which covers the first/originating
payment that a subscription is later derived from.

---

## Trigger

UC0007 (Process Recurring Donation), step UC0007.3.1 — fired on each successful periodic charge, i.e. when the
newly created child Transaction (EN0009) spawned by that charge is marked PAID (UC0007.2 step 4). Not sent on a
failed or declined charge (UC0007 AF1), where the child Transaction is marked canceled instead.

Evidence: UC0007 step UC0007.3.1; Notification Matrix SC-10E step 7 ("Processes each regular card payment; sends
confirmation per payment" / "Donor receives confirmation for each payment") in
`intake/test-scenarios/test-scenarios.md`.

---

## Recipients

- **Donor** — email, via ES0006 (Mautic). Sole recipient; not sent to the Parent, Patron, or any operations role.
- The underlying recurring subscription and its charge history are additionally visible to the Donor in the Donor
  Zone (in-application; SC-10E step 8), separate from this transactional-message contract.
- No CZ/RO/MD content variance is evidenced for this message beyond the per-country template resolution already
  documented at the capability level (FN0019); the periodic charge itself runs through a region-specific gateway
  path (ComGate/CZ, Netopia/RO — UC0007), but the message contract is not shown to differ by region.

---

## Message Content

Conceptually, each instance of this message carries:

- A thank-you / confirmation addressed to the Donor for the periodic charge just processed.
- Confirmation that this charge belongs to their ongoing standing/recurring donation (EN0010), not a one-time
  gift.
- The charged amount for this occurrence.
- The recurring period the charge belongs to (e.g. the cadence of the standing donation), per EN0010.
- No card, bank-account, or other payment-instrument detail is included.

No fixed subject-line text, body markup, or template structure is asserted in this canonical document — the
concrete wording is instance/configuration data and out of scope for the MSG layer (see rules-MSG.md
restrictions). Every dispatch is archived as an EmailArchive (EN0022) record.

---

## Notes

- Evidence Level: Confirmed for the trigger mechanism (successful periodic charge → PAID child Transaction) and
  the Donor-as-sole-recipient contract, per UC0007.3.1 and SC-10E step 7. Partial for the exact content split
  (amount + period vs. any additional framing), since precise wording is configuration data not fully visible
  from the cited sources.
- Current-state defect on the CZ/ComGate path (recorded at FN0010, not restated here): the child Transaction may
  be marked PAID optimistically — on the gateway call completing without error — ahead of the gateway's own
  asynchronous confirmation of the charge outcome (UC0007 AF3). Because this message is triggered by the PAID
  status, a receipt may be sent for a charge whose outcome is not yet finally confirmed by the gateway.
- Distinct from the failed/declined-charge notification sent to the Donor on the RO/Netopia path only (UC0007
  AF1) — that is a separate message intent (a cancellation/dunning notice, not a receipt) and is not covered by
  this document.
- Distinct from the donor-cancellation confirmation sent when the Donor cancels their recurring subscription via
  the Donor Zone (SC-10E steps 9–10) — that is a separate message intent not covered by this document.
- Distinct from the account-reactivation notification sent to the Donor when a successful recurring charge
  reactivates a previously blocked account (UC0007.3 step 2) — that is a separate message intent, not part of
  this receipt's content.
- Distinct from the internal ops notification sent for a successful CZ recurring charge (UC0007.3 step 5,
  production only) — that is a non-user-facing operations channel, out of scope for this MSG.
