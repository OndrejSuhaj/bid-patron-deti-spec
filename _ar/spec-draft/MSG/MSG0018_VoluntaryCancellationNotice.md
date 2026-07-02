---
doc_id: MSG0018
title: Voluntary Cancellation Notice
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
references:
  - EN0001
  - EN0022
  - ES0006
---

# MSG0018 – Voluntary Cancellation Notice

## Purpose

Confirm to the Parent (Žadatel) that their Application (EN0001) has been cancelled at the party's own
request — a voluntary cancellation handled manually by a coordinator, as opposed to an automatic
timeout cancellation. This is a courteous acknowledgement that the requested cancellation has been
carried out, distinct from the generic status-change notification (MSG0005/MSG0006) because it closes
a request the party themselves initiated rather than announcing a state imposed on them.

---

## Trigger

UC0002 (Orchestrate Application Status Change) — the downstream reaction fan-out (UC0002.2) — fires
when the Application (EN0001) is saved into the `canceled_by_user` status ("Zrušeno žadatelem").

Evidenced entry path (Notification Matrix sheet SC-7A, steps 1–5): the Parent or Patron sends a
cancellation request to the coordinator by email (directly, or via a general contact address); the
coordinator front-office receives and acknowledges the request, then manually cancels the Application
in the back-office system; the System then changes the Application's status to `canceled_by_user` and
sends this confirmation message as part of the same status-driven reaction.

Per the updated scenario note (SC-7A, "updated"), only the Parent can initiate a voluntary cancellation
directly; the Patron cannot trigger this path themselves. The manual coordinator action (SC-7A step 3)
is outside the message contract — it is the precondition that produces the status save this message
reacts to.

Evidence Level: Confirmed for the trigger status, the manual-request/coordinator-action path, and the
Parent-only initiation rule (SC-7A, SC-7A updated, Notification Matrix `canceled_by_user` rows).

---

## Recipients

- **Parent / Žadatel** — email (via ES0006, Mautic) **and** in-zone notification, both marked `YES`
  for the `canceled_by_user` status under the Parent columns in the Notification Matrix (status label
  "Zrušeno žadatelem"). This message is the email; the in-zone counterpart for the same status/role is
  owned by MSG0006.
- **Patron** — email (via ES0006, Mautic) marked `YES` for the `canceled_by_user` status under the
  Patron column (status label "Příběh zrušen"); the Notification Matrix marks the Patron's in-zone
  ("user account notification") column `NO` for this status, so the Patron is reached by email only for
  this status, not by an in-zone message.

No RO/MD content variance is evidenced for this message beyond the general per-country template
resolution already recorded at the capability level (FN0019); the Notification Matrix evidence cited
here is CZ-primary.

---

## Message Content

Conceptually, each dispatch of this message carries:

- A statement confirming that the Application (EN0001) — and, from the Patron's side, the associated
  child's case/story — has been cancelled, and that the cancellation was carried out at the party's own
  request (voluntary cancellation), not for non-cooperation or timeout.
- Implicit identification of the subject Application (EN0001) so the recipient recognises which case is
  being confirmed as cancelled.
- For the Parent: an acknowledgement that their (or the Patron's forwarded) cancellation request has
  been actioned — a courteous confirmation closing the loop on the request received by the coordinator.
- For the Patron: a plain notice that the story/case they were involved with has been cancelled, without
  necessarily detailing that the Parent was the one who requested it.

No fixed subject-line text, body markup, or template structure is asserted here — the concrete wording
is instance/configuration data per role (ApplicationReaction-driven), not canonical message content
(see rules-MSG.md restrictions).

Every dispatch of the Parent and Patron emails is archived as an EmailArchive (EN0022) record
regardless of whether the underlying send was actually transmitted, per the platform's general
email-archiving behavior (see MSG0005 for the shared archiving caveat).

---

## Notes

- Split out from the generic status-change email (MSG0005) — which also lists `canceled_by_user` among
  its evidenced catch-all statuses — because this status carries a distinct, high-salience intent (a
  party-requested cancellation being confirmed back to the requester) rather than a plain state label;
  this document is the canonical, dedicated treatment of that intent, following the same
  split-out-from-catch-all pattern used for MSG0009 (Application Returned for Completion) and other
  distinct-intent messages.
- Distinguished from MSG0017 (auto-cancellation on timeout, `canceled_timeout`): MSG0018 is
  party-requested and manually actioned by a coordinator; MSG0017 is system-driven after unanswered
  reminders. The two share the same fan-out mechanism (UC0002.2) but fire on different statuses and
  carry different intent.
- The Notification Matrix records the `canceled_by_user` rows as `OK` (no parse ambiguity flag),
  unlike several neighbouring cancellation rows (`canceled_application`, `canceled_lead`,
  `canceled_timeout`) marked `CHECK_PARSE`; this message's status label and Email/Notification
  YES/NO/YES/NO pattern are used as evidenced without reconciliation uncertainty.
- Evidence Level for the overall trigger/recipient mechanism: Confirmed. Evidence Level for whether the
  Parent-only initiation rule (SC-7A updated) is fully enforced in the current system versus only in
  the acceptance scenario's stated intent: Partial — the manual coordinator step (SC-7A step 3) is the
  actual gate, not a system-enforced initiator check visible in this message's evidence.
