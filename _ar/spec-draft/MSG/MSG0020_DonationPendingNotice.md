---
doc_id: MSG0020
title: Donation Pending Notice
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0005
  - UC0006
references:
  - EN0009
  - EN0004
  - EN0022
  - ES0006
---

# MSG0020 – Donation Pending Notice

## Purpose

Tell the Donor that a donation they started but did not finish is currently in a PENDING state, and
give them a way to go back and complete the payment. This is a recovery/nudge message for an
abandoned-in-progress payment — distinct from the payment thank-you confirmation sent once a
Transaction (EN0009) first reaches PAID, and distinct from the notice sent if the pending attempt is
later abandoned for good and the Transaction is set to CANCELLED.

---

## Trigger

- UC0005 (Make a Donation), UC0005.1 step 10: the System creates the Transaction (EN0009) in PENDING
  status when the Customer submits the donation request and is handed off to the country payment
  gateway.
- UC0006 (Confirm Payment — Gateway Callback): the Transaction (EN0009) remains in, or is confirmed
  back into, PENDING status when the Donor starts the gateway payment but does not complete it (browser
  closed, session timed out, or the gateway itself reports a pending/incomplete outcome — see
  UC0006.1 step 5, UC0006.2 step 4, and UC0006.3 step 5/AF3).
- Firing status: Transaction (EN0009) `ext_status` = PENDING, reached without a same-request PAID
  confirmation. Evidenced by SC-10B ("Donation via Website – Not Completed (PENDING → CANCELLED)"),
  steps 2–3: the System sets the donation status to PENDING and sends a PENDING notification email to
  the Donor with the option to complete payment.

---

## Recipients

- **Donor** — email, via ES0006 (Mautic). Per SC-10B step 3, the email is sent to the Donor only; no
  Parent/Patron recipient is evidenced for this message (the Notification Matrix's status-fan-out
  sheet covers Application/Story statuses for Parent and Patron, not the donation Transaction's own
  PENDING/CANCELLED states covered here).
- Also reflected as a PENDING donation status in the Donor Zone (SC-10B step 4) — an in-zone status
  view rather than a separate notification channel.
- No CZ/RO/MD content variant is evidenced for this message.

---

## Message Content

Conceptually, the message carries:

- Notice that a donation payment was started but not completed, and is currently pending.
- Enough identification of the donation attempt (target Story/Campaign, EN0004, and/or amount) for the
  Donor to recognise which payment this refers to.
- A way for the Donor to return and complete the payment.

No fixed subject-line text, template identifier, or body markup is asserted in this canonical
document (see rules-MSG restrictions). No payment-instrument detail (card number, gateway session
data) is part of this message's content.

Every dispatch attempt is archived as an EmailArchive (EN0022) record, consistent with FN0019; the
archive does not distinguish a delivered send from one suppressed by the environment send-gate.

---

## Notes / Uncertainty

- Evidence Level: Partial. SC-10B asserts a platform-sent PENDING email to the Donor, but no dedicated
  PENDING-notice template or dispatch step was surfaced in the mined UC0005/UC0006 flow evidence
  (FLW0006, FLW0003, FLW0004, FLW0005) beyond the Transaction being created/left in PENDING status; the
  step-5 completion nudge in SC-10B ("Comgate sends a completion request to Donor") is explicitly the
  payment gateway's own reminder, external to the platform's transactional-messaging capability
  (FN0019), not this message. Recorded as scenario-evidenced rather than flow-confirmed, per
  anti-hallucination policy — do not conflate with the gateway's own reminder.
- This message is scoped to the PENDING milestone only. The completion outcome (Transaction reaches
  PAID) and the abandonment outcome (Transaction reaches CANCELLED after timeout, per SC-10B steps
  7–8) are each their own message and are not restated here.
