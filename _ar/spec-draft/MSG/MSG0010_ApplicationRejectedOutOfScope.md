---
doc_id: MSG0010
title: Application Rejected — Out of Scope
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
references:
  - EN0001
  - EN0022
  - EN0026
  - ES0006
---

# MSG0010 – Application Rejected — Out of Scope

## Purpose

Inform both the Parent (Žadatel/fundraiser) and the Patron that the Coordinator has rejected the
Application (EN0001) because it does not meet the project's eligibility conditions — the case is
closed as "out of scope," not because of a risk decision, a data problem, or the parties' own
inaction. This is a distinct rejection-milestone message: the `out_of_scope` status is split out of
the generic status-change email (MSG0005) into this dedicated, higher-salience contract because a
coordinator's manual eligibility rejection is a human-authored decision point in the Application
(EN0001) lifecycle, evidenced by its own acceptance scenario (SC-4C). Mechanically it still rides the
same status/role reaction fan-out (EN0026) as MSG0005/MSG0006 — the split is one of salience and
documentation ownership, not a separate delivery path.

---

## Trigger

UC0002 (Orchestrate Application Status Change) — specifically the downstream reaction fan-out
(UC0002.2): the Coordinator manually rejects the Application (EN0001) in the back office after
determining it does not meet the project's eligibility conditions (e.g. the child is outside the
supported age range); the Application is saved into the `out_of_scope` status, and the System looks
up the matching ApplicationReaction (EN0026) configuration for that status and role, dispatching
this message on each channel enabled for it.

Evidenced directly by SC-4C ("Application Rejected – Out of Scope"), steps 1–6: the Coordinator
reviews the Application against project eligibility conditions (step 1), determines it does not meet
them and documents a specific rejection reason in the case notes (step 2), manually rejects it in the
back office (step 3), the System changes the status to `out_of_scope` (step 4), and then sends the
rejection email to the Parent with an accompanying notification (step 5) and a rejection notification
to the Patron (step 6).

---

## Recipients

- **Parent / Žadatel** — email (channel: ES0006, Mautic) + in-zone notification in the Parent Zone,
  both marked Email = YES and User account notification = YES for `out_of_scope`/Parent in the
  Notification Matrix.
- **Patron** — email (channel: ES0006, Mautic) + in-zone notification in the Patron Zone, both marked
  Email = YES and User account notification = YES for `out_of_scope`/Patron in the Notification
  Matrix.

Both parties receive both channels for this status — unlike many other status-driven messages, where
a given role may get only one channel or neither. SC-4C steps 7–8 additionally confirm the same
"Out of Scope" status is visible to each party inside their own zone on next login, consistent with
the in-zone notification. CZ is the evidenced primary market; no RO/MD-specific content or channel
variance is evidenced for this message beyond the per-country template resolution already documented
at the capability level (FN0019).

---

## Message Content

- A statement that the Application (EN0001) cannot be supported and has been closed because it falls
  outside the project's scope/eligibility conditions — phrased per role/zone per the
  ApplicationReaction (EN0026) and Notification Matrix "Status message" resolution for `out_of_scope`
  (recorded there as a two-part status phrase; exact wording is configuration/status data and is not
  asserted as fixed template copy in this document — see rules-MSG.md restrictions).
- The specific rejection reason, where the Coordinator has documented one in the case notes at the
  point of decision (SC-4C step 2) — content-wise this is case-authored data attached to the
  Application (EN0001), not fixed template text; this document does not assert whether the reason
  text itself is surfaced inside the message body or only held internally on the case record, which is
  **Uncertain** from the cited evidence.
- A courteous close indicating the case is finished and no further action is expected from either
  party — distinguishing this message from status notifications that carry an action-required cue.
- Identification of the subject Application (EN0001), scoped implicitly by the party's own zone view
  (Parent Zone / Patron Zone) for the in-zone variant, and by the recipient resolution on the
  Application/Contact record for the email variant.
- Every email dispatch of this message is archived as an EmailArchive (EN0022) record per the
  standard dispatch/archive mechanism, regardless of whether the send was actually transmitted (see
  MSG0005 / FN0019 Constraints on the send-gate/archive limitation).

Excluded from this contract: exact subject-line/body copy strings, HTML/visual presentation, and
mail-provider/delivery configuration — see MSG0005 (Application Status-Change Email) and MSG0006
(In-Zone Status Notification) for the shared dispatch mechanism this message rides on.

---

## Notes / Uncertainty

- This document owns the coordinator's manual eligibility rejection (`out_of_scope`) as its own named
  message, split out of the generic status-change email (MSG0005) and its in-zone counterpart
  (MSG0006), and distinct from other rejection/closure intents in the case lifecycle that fire under
  different statuses (e.g. a risk-decision rejection, or an applicant/coordinator-inaction
  cancellation) — those are separate message families, not restated here. `out_of_scope` is
  therefore documented here rather than as one of MSG0005's grouped catch-all rows. Mechanically,
  this message is still dispatched through the same status/role-driven ApplicationReaction (EN0026)
  fan-out as MSG0005/MSG0006; this MSG does not introduce a separate delivery mechanism.
- The Notification Matrix records the `out_of_scope` status message as a two-part phrase ("Zrušená
  žádost; Nemůžeme vám pomoci" for both Parent and Patron) and flags the row `CHECK_PARSE` — which of
  the two phrases (or both, in sequence) is the resolved single status message is **Uncertain** and
  left to the status-model / ApplicationReaction (EN0026) evidence rather than asserted here.
- Whether the case-authored rejection reason (SC-4C step 2) is included in the message body itself, or
  is an internal-only case note not exposed to the Parent/Patron, is **Uncertain** — not resolved by
  the cited evidence; kept broad rather than invented.
- Evidence Level: Confirmed for the trigger, both-channel/both-role recipient shape, and existence of
  a case-documented rejection reason (SC-4C, Notification Matrix). Partial/Uncertain for the exact
  resolved status-message text and for whether the rejection reason text is surfaced to the parties or
  kept internal.
