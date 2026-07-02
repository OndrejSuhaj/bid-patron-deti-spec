---
doc_id: MSG0021
title: Donation Cancelled Notice
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0006
references:
  - EN0009
  - EN0010
  - EN0022
  - ES0006
---

# MSG0021 – Donation Cancelled Notice

## Purpose

Tell the Donor that a donation/payment did not go through — either a one-time payment left PENDING at
a gateway was ultimately cancelled (timed out) with nothing charged, or a recurring donation the Donor
asked to stop has been cancelled as requested. In both cases the message confirms no further money will
move on that Transaction (EN0009) / RecurringTransaction (EN0010) until the Donor starts a new one.

---

## Trigger

- UC0006 (Confirm Payment — Gateway Callback): a Transaction (EN0009) that is left PENDING is reported
  by the gateway as cancelled/timed out and the System records the CANCELLED status on the Transaction
  (per SC-10B steps 1–2 and 7: Donor starts but does not finish payment → status PENDING → gateway sends
  a completion request → if not completed, gateway cancels after timeout → status CANCELLED).
- Donor-initiated recurring cancellation (Donor Zone self-service): the Donor cancels a regular/standing
  donation from the Donor Zone and the System changes the associated RecurringTransaction (EN0010) to
  CANCELLED, confirming the cancellation back to the Donor (per SC-10E step 9–10: Donor cancels the
  regular donation via Donor Zone → System changes status to CANCELLED and confirms cancellation to
  Donor).
  **Hypothesis — Not evidenced at the UC layer; no UC currently models Donor-initiated recurring
  cancellation.** This trigger is scenario-evidenced only (SC-10E), so it is intentionally **not**
  listed in the frontmatter `trigger` (which stays honest: UC0006 covers only the gateway-callback
  PENDING→CANCELLED path). This self-service cancellation path should later be added as a dedicated UC
  or as an alternative flow of UC0007 (Process Recurring Donation), at which point this MSG's frontmatter
  trigger can reference it.
- Firing status: CANCELLED (Donor-facing donation/subscription status), evidenced in the Notification
  Matrix and SC-10B/SC-10E rather than the Application/Story status vocabulary used elsewhere in the
  Notification Matrix sheet.

---

## Recipients

- **Donor** — email, via ES0006 (Mautic) (SC-10B step 8: Donor receives a cancellation email; SC-10E
  step 10: System confirms cancellation to Donor by email). Also reflected as CANCELLED status in the
  Donor Zone (SC-10B step 9; SC-10E step 10).

No Parent or Patron recipient is evidenced for this message — SC-10B and SC-10E document only the
Donor-facing email and Donor Zone status change; this is a Donor/Transaction-scoped notice, not part of
the Application/Story status fan-out addressed to Parent and Patron (contrast MSG0005/MSG0006). No
RO/MD content variant is evidenced beyond the general per-country template resolution already
documented at the capability level (FN0019).

---

## Message Content

Conceptually, the message carries:

- That the donation/payment was cancelled and no payment was taken (one-time PENDING→CANCELLED case),
  or that the recurring/standing donation was stopped as requested (Donor-initiated recurring
  cancellation case) — the two cases share the same CANCELLED outcome communicated to the Donor.
- Enough context to identify which donation/subscription this refers to (e.g. the amount and/or the
  Story/Campaign the donation targeted), without restating payment-instrument detail.
- No indication that any charge will still occur on this Transaction (EN0009) / RecurringTransaction
  (EN0010); a new donation would need to be started separately.

No fixed subject-line text, template identifier, or body markup is asserted in this canonical document
(see rules-MSG restrictions).

Every dispatch attempt is archived as an EmailArchive (EN0022) record, consistent with FN0019.

---

## Notes / Uncertainty

- Evidence Level: Partial. The two triggers are scenario-evidenced (SC-10B, SC-10E) rather than tied to
  a specific mined template identifier; they are grouped here as one message type because both
  communicate the same CANCELLED outcome to the same recipient (Donor) over the same channel (email).
  The two triggers differ in UC coverage: the one-time PENDING→CANCELLED path is modeled by UC0006,
  whereas the Donor-initiated recurring cancellation path has **no UC** and is flagged as a Hypothesis
  in the Trigger section (candidate for a future UC / UC0007 alternative flow).
- Distinct from MSG0023 (recurring charge FAILED / dunning), which concerns a failed periodic charge
  attempt on an active RecurringTransaction rather than a PENDING timeout or a Donor-requested
  cancellation.
- Distinct from the Application/Story-level CANCELLED-family statuses in the Notification Matrix
  (e.g. `canceled_application`, `canceled_by_user`, `canceled_campaign`, `canceled_lead`,
  `canceled_timeout`) addressed to Parent/Patron — those concern the Application or Story lifecycle and
  are covered by the status-fan-out messages (MSG0005/MSG0006), not by this Donor-facing
  Transaction/RecurringTransaction notice.
