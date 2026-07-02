---
doc_id: MSG0029
title: Feedback Request & Reminders
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
references:
  - EN0001
  - EN0021
  - EN0022
  - ES0006
---

# MSG0029 – Feedback Request & Reminders

## Purpose

Ask the Parent/Žadatel to provide post-donation feedback — how the gift was used, told through the
Story's outcome, photos, and a description — within a deadline, and escalate with two reminders
(the second of which also notifies the Patron) before the case is marked non-cooperative. This is
the request/escalation side of the feedback cycle; it precedes and is distinct from the feedback
being forwarded on to Donors (MSG0030).

---

## Trigger

UC0002 – Orchestrate Application Status Change — the status-driven notification fan-out
(UC0002.2 step 6) fires this message each time an Application (EN0001) enters one of the following
statuses (Status vocabulary, Confirmed against the Notification Matrix):

- `waiting_for_feetback` — initial feedback request, entered once the donation/gift cycle is settled
  for the Story.
- `waiting_feedback_reminder_1` — 1st reminder, reached via the scheduler-driven aging sub-flow
  (UC0002.3) after the Parent has not submitted feedback within the configured deadline.
- `waiting_feedback_reminder_2` — 2nd reminder, reached after a further aging period with still no
  feedback; this is also the point at which the Patron is first informed of the delay.
- `waiting_feedback_uncooperative` — terminal escalation status reached after continued
  non-response; marks the Parent as non-cooperative for this cycle (feeding Risk's future
  assessment — out of scope for this message; see UC0003) and precedes distribution of a universal,
  non-personalized thank-you to Donors in place of the Parent's own feedback (covered by MSG0030,
  not this document).

Evidence: Notification Matrix rows for the four statuses above; SC-8A steps 22–25; SC-9C step 1;
SC-9D steps 1–3 (`intake/test-scenarios/test-scenarios.md`).

---

## Recipients

- **Parent/Žadatel** — the addressed party at every step of this escalation. Channel: email (via
  ES0006 Mautic) and in-zone notification, per the Notification Matrix, for `waiting_for_feetback`,
  `waiting_feedback_reminder_1`, and `waiting_feedback_reminder_2`. At the terminal
  `waiting_feedback_uncooperative` status the Notification Matrix records no further email/in-zone
  flags to the Parent for this specific status row — the escalation's active messaging ends at the
  2nd reminder.
- **Patron** — not addressed at the initial request or the 1st reminder (Notification Matrix: no
  email/notification flags for `waiting_for_feetback` or `waiting_feedback_reminder_1` on the Patron
  side). On the **2nd reminder** (`waiting_feedback_reminder_2`) the Patron is additionally notified
  by email (Notification Matrix: Patron email = YES), so they are aware the Parent has still not
  provided feedback; SC-9D step 2 confirms "Patron also notified" at this point.
- No CZ/RO/MD content variance is evidenced beyond the general per-country template resolution that
  applies to all transactional messages [ES0006]; the status vocabulary itself carries CZ/RO/MD
  aliases (see glossary) but this is a status-naming fact, not a distinct message design.

---

## Message Content

The conceptual information elements the message must carry:

- A request that the Parent/Žadatel provide feedback on how the gift/donation was used for their
  Story — described in the acceptance evidence as the outcome, photos, and a description of how the
  gift was used (SC-8A step 26; SC-9C).
- A deadline by which the feedback is expected, after which the escalation continues (SC-8A steps
  22–25 evidence a 14-day initial window and a further 14-day window before the 2nd reminder; kept
  as `Partial` — see Uncertainty below).
- Where/how to submit the feedback: through the Parent's zone (in-system submission of text and
  photos), or alternatively by email to the platform (SC-9C Options A/B/C document system
  submission, email submission, and email submission of video as alternative channels — the
  channel-handling itself is operational/back-office routing, not part of this outbound message
  contract).
- On the 1st and 2nd reminder: an indication that this is a reminder (escalation step) because
  feedback has not yet been received.
- On the 2nd reminder, to the Patron specifically: a statement that the Parent has not yet provided
  feedback for their sponsored Story.
- An implicit sense of consequence: continued non-response leads to the Parent being marked
  non-cooperative for this cycle and to a universal, non-personalized thank-you being sent to Donors
  in the Parent's place — the reminder messages themselves are not evidenced to spell out this exact
  consequence in their content, only the surrounding process steps establish the outcome (SC-9D
  steps 3–4).

No template markup, subject-line wording, or styling is specified here — those are delivery/template
concerns owned by the outbound transport, not this contract [ES0006]. Every dispatch is archived as
an EmailArchive (EN0022) record.

---

## Notes

- Grouped as **one message type** spanning the initial feedback request and both escalation
  reminders (`waiting_for_feetback` → `waiting_feedback_reminder_1` → `waiting_feedback_reminder_2`
  → `waiting_feedback_uncooperative`), per the MSG grouping rule (group by message type, not by
  matrix row): all four statuses realise the same request-and-escalate mechanism, differing only in
  role/step and in the addition of the Patron as a recipient at the 2nd reminder.
- Distinct from **MSG0030** (or equivalent, if separately documented): the subsequent forwarding of
  the Parent's actual feedback — or, on non-cooperation, a universal thank-you — onward to Donors
  (`feedback_to_proccess` → `feedback_sent`); that is a different message intent (Donor-addressed,
  content-distribution) and out of scope here.
- Distinct from the application-completion reminder pair (MSG0007) and the contract-signature
  reminder pair (`waiting_signature_reminder_1/2`, its own message type) — both follow a similar
  1st/2nd escalation shape but concern different waiting states.
- SC-11E (Mautic Integration) row 2 confirms feedback reminder emails to Parents are sent via
  Mautic, corroborating the ES0006 channel for this message.
- The `feedback` (EN0021) entity captures the feedback content itself once submitted by the Parent;
  this MSG concerns only the request/reminder messaging that precedes and elicits that submission,
  not the feedback record's own attributes (owned by EN0021).

---

## Uncertainty / Notes

- Evidence Level: `Confirmed` for the existence of the four-status escalation
  (request → reminder 1 → reminder 2 → non-cooperative), the channel mix (email + in-zone via
  ES0006), and the Patron being copied in at the 2nd reminder (Notification Matrix +
  SC-8A/SC-9C/SC-9D).
- `Partial` for the exact deadline lengths: SC-8A (step 22–25) and SC-9D (steps 1–3) both describe a
  multi-stage aging window but state it inconsistently — SC-8A implies roughly 14 days to the
  initial deadline and a further 14 days to the 2nd reminder, while SC-9D's own step 2 note flags an
  internal document discrepancy ("documents say 14 day interval[s]") and step 3 additionally cites a
  30-day final window before non-cooperative status; the precise cron-aging thresholds are not
  independently cross-checked here against a mined flow dossier for this specific escalation
  (`Conflict — requires clarification`, recorded per the evidence-first rule rather than resolved
  silently).
- `Hypothesis — Not evidenced in current sources` regarding whether the request/reminder message
  itself states the exact deadline date/count in its content, versus the deadline being enforced
  only by the surrounding scheduler logic (UC0002.3) without being spelled out to the recipient.
