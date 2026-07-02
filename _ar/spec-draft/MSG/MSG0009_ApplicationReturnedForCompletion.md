---
doc_id: MSG0009
title: Application Returned for Completion
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
references:
  - EN0001
  - EN0002
  - EN0022
  - ES0006
---

# MSG0009 – Application Returned for Completion

## Purpose

Tell the Parent (Žadatel) that the coordinator — or, indirectly, Risk acting through the coordinator
— has found the Application (EN0001) incomplete or unclear, and that it has been sent back to them for
completion: which information or documents are still missing, and that the case cannot move forward
until they respond. This is the actionable "please complete your application" message, distinct from
the generic status-change notification (MSG0005/MSG0006) because it carries a specific, case-authored
request rather than a plain state label.

---

## Trigger

UC0002 (Orchestrate Application Status Change) — the downstream reaction fan-out (UC0002.2) — fires
when the Application (EN0001) is saved into the "waiting" status (`waiting` — "Doplňte informace do
žádosti") for the Parent role. Evidenced entry paths into this status:

- The coordinator reviews the Application and finds missing information or attachments in the
  Parent's part, then returns the Application to the Parent for completion (Notification Matrix
  sheet SC-4B, steps 3–4).
- Risk finds missing or unclear information during scoring and requests it via the coordinator, who
  in turn returns the Application to the Parent if the Parent must supply it (Notification Matrix
  sheet SC-5D, steps 1–4).

In both paths, the actual dispatch of this message to the Parent is the same status-driven reaction
step evidenced at SC-4B step 5 / SC-5D step 5 ("System sends email to Parent requesting
completion/additional documents with details of what is missing").

Evidence Level: Confirmed for the trigger status and the two documented entry paths (Notification
Matrix rows for `waiting`, SC-4B, SC-5D); Partial for whether other, un-evidenced entry paths into the
same `waiting` status also route through this message — the status/role match on ApplicationReaction
(EN0026) is the general mechanism (UC0002.2), so any save into `waiting` for the Parent role is
expected to fire it.

---

## Recipients

- **Parent / Žadatel** — email (via ES0006, Mautic) **and** in-zone notification, both marked `YES`
  for the `waiting` status under the Parent columns in the Notification Matrix.
- **Patron** — no email and no dedicated notification for this status per the Notification Matrix
  (`waiting` / Patron row: Email = NO, Notification = NO); the Patron's zone instead shows a passive,
  internal status label ("Čekáme na informace od žadatele") reflecting that the case is paused waiting
  on the Parent — this is the in-zone status label owned by MSG0006, not a separate dispatch of this
  message.

No RO/MD content variance is evidenced for this message beyond the general per-country template
resolution already recorded at the capability level (FN0019); the Notification Matrix evidence cited
here is CZ-primary.

---

## Message Content

Conceptually, each dispatch of this message carries:

- A statement that the Application (EN0001) has been returned to the Parent and requires completion
  before the case can proceed.
- A description of what is missing or unclear — specific information fields or attached documents on
  the Parent's part of the Application/ApplicationProfile (EN0001/EN0002) that the coordinator (or
  Risk, via the coordinator) identified as incomplete. This list is authored per case by the
  coordinator at the time the Application is returned (Notification Matrix: "Sends email to Parent
  requesting completion with details of what is missing" / "requesting additional documents/information");
  it is not a fixed, predetermined content block.
- Direction on how and where to respond — that the Parent must go to their zone to supply the missing
  information/documents.
- An implicit warning that inaction has consequences: if the Parent does not respond, reminder
  messages follow and, ultimately, the Application may be auto-cancelled for timeout (per the same
  Notification Matrix sheets — see the reminder and cancellation messages, out of scope for this
  document).

No fixed subject-line text, body markup, or template structure is asserted here — the concrete wording
is instance data, and the specific missing-items list is coordinator-authored per case rather than
canonical message content (see rules-MSG.md restrictions).

Every dispatch is archived as an EmailArchive (EN0022) record regardless of whether the underlying
send was actually transmitted, per the platform's general email-archiving behavior (see MSG0005 for
the shared archiving caveat).

---

## Notes

- Split out from the generic status-change email (MSG0005) because this status carries a distinct,
  actionable, case-authored request rather than a plain status label — the Notification Matrix and the
  two SC scenarios (SC-4B, SC-5D) evidence a specific "what's missing" intent for the `waiting` status
  that the generic catch-all does not capture.
- Follow-on reminder messages for the same unanswered request (`waiting_reminder_1`,
  `waiting_reminder_2`, and the related `reminder_1`/`reminder_2` family) are a distinct message
  concern and are not covered by this document (see MSG0007 for the reminder message, where present in
  this spec draft).
- The Notification Matrix marks the `waiting` / Parent row `CHECK_PARSE`, meaning the source sheet
  parsing for that exact row carries a residual ambiguity flag; the status label and Email/Notification
  YES/YES values themselves are otherwise unambiguous and used as evidenced here.
- Evidence Level for the overall trigger/recipient mechanism: Confirmed. Evidence Level for the
  complete enumeration of what counts as "missing" content per case: Partial/Not applicable — that
  detail is case data, not a fixed message contract element.
