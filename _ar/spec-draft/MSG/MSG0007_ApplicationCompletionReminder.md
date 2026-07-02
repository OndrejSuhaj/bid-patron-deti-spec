---
doc_id: MSG0007
title: Application Completion Reminder (1st / 2nd)
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
references:
  - EN0001
  - EN0002
  - ES0006
---

# MSG0007 – Application Completion Reminder (1st / 2nd)

## Purpose

Remind whichever party has not yet completed their part of the Application (EN0001) — the Patron or
the Parent/Žadatel — to finish it, escalating from a first reminder to a second reminder that also
alerts the counterpart, before the case times out and is cancelled [UC0002].

---

## Trigger

UC0002 – Orchestrate Application Status Change — specifically the scheduler-driven automatic
status-transition sub-flow (UC0002.3) that ages an Application (EN0001) out of a waiting status into
one of the reminder statuses, which then re-enters the Main Flow and fires the status-driven
notification fan-out (UC0002.2 step 6).

Firing statuses (Status vocabulary, Confirmed against the Notification Matrix):

- **1st reminder:** `reminder_1_patron`, `reminder_1_fundraiser`, `reminder_1`, `waiting_reminder_1`
  — reached after the configured aging period (evidenced as 2 days) with no completion.
- **2nd reminder:** `reminder_2_patron`, `reminder_2_fundraiser`, `reminder_2`, `waiting_reminder_2`
  — reached after a further aging period (evidenced as +5 days after the 1st reminder) with still no
  completion.

`reminder_1_fundraiser` / `reminder_2_fundraiser` address the Parent/Žadatel side (called
"fundraiser" in the status vocabulary); `reminder_1_patron` / `reminder_2_patron` and the generic
`reminder_1` / `reminder_2` address the Patron side; `waiting_reminder_1` / `waiting_reminder_2`
address the same escalation pattern for a case already returned for completion (missing info/
documents). All are driven by the same ApplicationReaction (EN0026) configuration and cron-aging
mechanism described in UC0002.3 — this document treats them as one message type with role/step
variants, not as separate messages.

Distinct from the "find a new Patron" reminder pair (`returned_new_patron_reminder_1/2`, not covered
by this document) and from the signature and feedback reminder pairs (also status-driven but tied to
contract-signature and post-donation feedback waiting states, not application completion).

---

## Recipients

- **1st reminder** — the delinquent party (whichever role, Patron or Parent/Žadatel, has not yet
  completed their part of the Application (EN0001)) via email (ES0006 Mautic) and in-zone
  notification, per the Notification Matrix. Counterpart handling is **not uniform** across the
  variants and must be read per firing status:
    - `reminder_1_patron` and `waiting_reminder_1` (Patron / return-for-completion) — the counterpart
      receives nothing at this step (Matrix Parent flags both NO for `reminder_1_patron`; Patron
      flags both NO for `waiting_reminder_1`).
    - `reminder_1_fundraiser` (Parent/Žadatel side) — the Patron counterpart **does** get an in-zone
      status notification (no email): Matrix `reminder_1_fundraiser` row is Patron Email=NO,
      Notification=YES.
- **2nd reminder** — the delinquent party again, **and** the counterpart is also informed that the
  other side has still not completed (Notification Matrix rows for `reminder_2_patron`,
  `reminder_2_fundraiser`, `reminder_2`, `waiting_reminder_2` set both Parent and Patron flags).
  Channel: email (via ES0006 Mautic) and in-zone notification for both parties, subject to the
  per-status flag combination recorded in the Notification Matrix (some rows omit the in-zone flag
  for one side — e.g. `waiting_reminder_2` Patron is email-only in the matrix).
- No CZ/RO/MD content variance is evidenced beyond the general per-country template resolution that
  applies to all transactional messages [ES0006]; the status labels are localized in the source
  vocabulary (e.g. RO "reamintire" for "urgence"/reminder), but this is a naming/translation fact
  about the status vocabulary, not a distinct message variant.

---

## Message Content

The conceptual information elements the message must carry:

- A statement that the recipient's part of the Application (EN0001) — or, for the return-for-
  completion variant, the requested missing information/documents on the ApplicationProfile
  (EN0002) — is still outstanding.
- A working link that lets the recipient resume and complete their part of the Application; this
  reuses the same completion link issued at the original request-to-complete step, not a newly
  generated one.
- An indication of which reminder this is (1st vs. 2nd), so the recipient understands the escalation
  they are in.
- On the 2nd reminder only: a statement to the counterpart that the other party has still not
  completed their part, so they are aware of the delay.
- An implicit sense of urgency: continued non-completion after this reminder cycle leads to
  cancellation of the Application (EN0001) or, on the Patron side, initiation of a patron-change
  request — the reminder itself does not need to spell out the exact subsequent deadline, but exists
  to head that outcome off.

No template markup, subject-line wording, or styling is specified here — those are delivery/template
concerns owned by the outbound transport, not this contract [ES0006].

---

## Uncertainty / Notes

- Kept as **one grouped message type** covering the 1st/2nd reminder escalation across the Patron
  side (`reminder_1_patron`/`reminder_2_patron`, generic `reminder_1`/`reminder_2`), the
  Parent/Žadatel side (`reminder_1_fundraiser`/`reminder_2_fundraiser`), and the return-for-
  completion variant (`waiting_reminder_1`/`waiting_reminder_2`), rather than exploding into a
  separate document per status row — evidence (Notification Matrix + UC0002.3) supports a single
  reminder-escalation mechanism parameterized by role and step, not distinct message designs.
  `Confirmed` for the existence, escalation shape (1st → 2nd with counterpart CC), and channel mix;
  `Partial` for the exact aging thresholds (2 days / +5 days), which are evidenced only in the SC-*
  acceptance scenarios (test-scenarios.md) and not independently cross-checked against a mined flow
  dossier for the cron-aging rule itself (UC0002.3 is itself rated Partial on this point).
  `Hypothesis — Not evidenced in current sources` regarding the exact wording of the subsequent
  cancellation/patron-change deadline stated (or not) inside the reminder message itself; only the
  outcome (cancellation/patron-change follows further non-completion) is evidenced by the surrounding
  scenario steps, not the reminder message's own content.
- **Conflict — requires clarification:** `reminder_1` / `reminder_2` (the generic pair) are typed as
  **Lead**-entity statuses in the status model (intake/statuses/statuses.md), whereas the
  `*_patron` / `*_fundraiser` / `waiting_*` variants grouped here are all typed **Application**. Their
  inclusion in this document as EN0001 Application-completion reminders therefore contradicts the
  status model's entity typing and requires clarification.
- The `waiting_signature_reminder_1/2` and `waiting_feedback_reminder_1/2` status rows in the
  Notification Matrix follow the same 1st/2nd escalation shape but concern contract signature and
  post-donation feedback, not application completion — they are out of scope for this document and
  belong to their own message type(s).
