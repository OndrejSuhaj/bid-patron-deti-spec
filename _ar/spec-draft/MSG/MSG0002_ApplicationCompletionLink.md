---
doc_id: MSG0002
title: Application Completion Link (Cross-Invite)
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0001
  - UC0002
references:
  - EN0001
  - EN0003
  - ES0006
---

# MSG0002 – Application Completion Link (Cross-Invite)

## Purpose

Invite the counterpart party on a two-sided Application (Žádost) to complete their own half of the
application form. Whichever party (Parent/Žadatel or Patron) submits their part first, the system
sends this message to the other, not-yet-participating party so the Application can be completed.
The same message type is reused when a new Patron is nominated after the original Patron did not
complete or declined — the newly nominated Patron receives the identical kind of invitation to
complete their part.

This is a distinct dispatch from the status-driven notification fan-out (see MSG0001-class,
status→role messages driven by ApplicationReaction, UC0002.2): it is fired directly off the
form-submission / patron-nomination action, not off a generic status change reaction.

---

## Trigger

- **UC0001 (Submit Application)** — the self-registration/submission sub-flow, at the point the
  first party's part of the Application is received and the Application (EN0001) is created with
  its two role sessions (Confirmed — UC0001 Main Flow step 9; grounded in FLW0010: one session is
  created for the submitting role with an `authenticated`/default interface and one for the
  counterpart role with an `invited` interface).
- **UC0002 (Orchestrate Application Status Change)**, patron-change path — when the Application
  enters the "returned application / find a new Patron" status (original Patron did not complete in
  time or actively declined) and the Parent subsequently supplies a new Patron's contact details,
  the same completion-link message is sent to that newly nominated Patron.

Firing statuses/events observed in the Notification Matrix and SC acceptance scenarios:

- Parent submits first → link sent to Patron (`waiting_for_patron` status is entered) — SC-1A step
  11.
- Patron submits first → link sent to Parent (`waiting_for_fundraiser` status is entered) — SC-1B
  step 12.
- Parent supplies a new Patron's contact info after the original Patron did not complete / declined
  → link sent to the new Patron (`waiting_for_patron` status is (re-)entered) — SC-2C, SC-2D step 9,
  SC-6A step 6.

---

## Recipients

The invited counterpart on the Application — never the party who just submitted:

| Scenario | Recipient | Channel |
|---|---|---|
| Parent submitted first | Patron (incl. a newly nominated Patron in the patron-change path) | Email via ES0006 (Mautic) |
| Patron submitted first | Parent/Žadatel | Email via ES0006 (Mautic) |
| New Patron nominated after original Patron's non-completion/decline | New Patron | Email via ES0006 (Mautic) |

The in-zone account notification is not the primary channel for this message: the working link
itself is delivered by email; the corresponding zone status ("Waiting for Patron", "Complete the
application", etc.) is a status-display consequence, not a copy of this message, and is owned by the
status-driven notification set, not by this MSG.

CZ is the primary evidenced locale; RO/MD are expected to receive a localized equivalent of the same
message type, consistent with the platform's per-country template resolution (FN0019), but no
RO/MD-specific content variant is evidenced for this particular message beyond localization.

---

## Message Content

Conceptual information elements the message must carry (no template markup, no subject-line
wording):

- An indication of who initiated the Application and on whose behalf the recipient is being invited
  (e.g. that a Parent/Žadatel has started an application for a child, or that a Patron has offered
  to support a child, naming the child where evidenced by the flow).
- A unique, working link that opens the recipient's own part of the Application form — realized as
  the invited-role ApplicationSession (EN0003) created for the Application (EN0001) at submission
  time (or created afresh for a newly nominated Patron).
- A statement of what is expected of the recipient — completing their part of the application/story
  so the Application can proceed.
- An implicit expectation that the link is tied to this specific invitation and will later become
  invalid (superseded by a new link) if the recipient does not act and the counterpart is changed —
  see the session-invalidation behavior on the patron-change path (UC0002.2 Main Flow step 7
  (session-invalidation reaction), co-occurring with the AF3 patron-data-scrub path), which is a
  separate lifecycle event, not part of this message's own content.

No HTML, styling, mail-provider/SMTP detail, or literal subject-line text is defined here; the actual
wording/template resolution belongs to the messaging capability (FN0019) and is out of scope for this
MSG contract.
