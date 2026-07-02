---
doc_id: MSG0001
title: Application Received Confirmation
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0001
  - UC0002
references:
  - EN0001
  - EN0002
  - EN0022
  - ES0006
---

# MSG0001 – Application Received Confirmation

## Purpose

Acknowledge to the party who has just submitted their part of an Application (Žádost) that it has
been received, and communicate the resulting waiting state: either that the counterpart (Parent/
Žadatel or Patron) still needs to complete their part, or — once both parts are in — that the case
has moved into coordinator review. The message reassures the initiating party that submission
succeeded and orients them to what happens next, without yet requiring any further action from them.

---

## Trigger

- UC0001 – Submit Application (Žádost): the Customer's self-registration/form submission that
  creates or completes one side of the Application (EN0001).
- UC0002 – Orchestrate Application Status Change (downstream reaction fan-out, UC0002.2): the
  Application (EN0001) save that first sets its status to a waiting-for-counterpart status
  (`waiting_for_patron`, `waiting_for_fundraiser`) or, once both parts are present, to the
  coordinator-review status (`to_check`).

Per the Notification Matrix (`intake/test-scenarios/test-scenarios.md`) and acceptance scenarios
SC-1A (step 8–11: Parent submits first → status `waiting_for_patron`), SC-1B (step 7–8: Patron
submits first → status `waiting_for_fundraiser`), and SC-4A (step 1–2: both forms joined → status
`to_check`), this message fires once per status-entry event, not once per form field submitted.

---

## Recipients

Party × channel, resolved by the status-entry role/reaction configuration (ApplicationReaction,
EN0026 — cited, not restated) and dispatched through ES0006 (Mautic, email) plus an in-zone
notification:

| Status (firing) | Parent/Žadatel — Email | Parent/Žadatel — In-zone | Patron — Email | Patron — In-zone |
|---|---|---|---|---|
| `waiting_for_patron` (Parent submitted first) | YES | YES | NO | YES |
| `waiting_for_fundraiser` (Patron submitted first) | NO | YES | YES | YES |
| `to_check` (both parts joined, coordinator review) | YES | YES | YES | YES |

- The party who just submitted receives the confirmation-flavored variant of the message; the
  counterpart (when already known, e.g. Patron email supplied by the Parent) receives the
  action-required variant carrying the link to complete their part — that action-required content is
  MSG0002, kept distinct from this confirmation message (see MSG0002 boundary note below).
- CZ is the primary evidenced market; the same status-driven trigger applies in RO/MD via the
  per-country template map at the delivery layer (ES0006/FN0019) — country-specific wording is a
  delivery-template concern, not part of this message's contract.

---

## Message Content

Conceptual information elements the message must carry (no template text, no HTML, no subject-line
wording):

- Which party's submission was received (Parent/Žadatel's part, or Patron's part).
- The current human-readable status of the Application (Žádost) — e.g. "waiting for the
  counterpart" or "under coordinator review" — drawn from the same status vocabulary as the in-zone
  status display (`intake/statuses/`), not restated here as a fixed string set.
- Confirmation that no further action is required from the recipient at this moment (confirmation
  variant), distinguishing this from the action-required link sent to the counterpart (MSG0002).
- A reference/link back into the recipient's party zone to track the Application's progress.
- Identification of the Application/case the message concerns (child/case reference), sourced from
  the Application (EN0001) and its ApplicationProfile (EN0002) — attributes owned by those entities,
  not restated here.

---

## Boundary notes

- Distinct from MSG0002 (counterpart action-required / complete-your-part message), which is
  dispatched to the still-pending party in the same status-entry event but carries an actionable
  completion link rather than a confirmation.
- Delivery mechanics (per-country Mautic template resolution, synchronous send-gate, archival of the
  send attempt) are owned by FN0019 (Transactional Messaging & Templating) and the EmailArchive
  entity (EN0022) — cited here, not restated.
- The status-to-recipient-to-channel matching logic itself (which roles/statuses trigger which
  channel) is configuration owned by the ApplicationReaction entity (EN0026, referenced via UC0002)
  and the Notification Matrix evidence; this document describes the resulting message contract, not
  that configuration mechanism.
- **Ownership carve-out vs the status fan-out (MSG0005 email / MSG0006 in-zone).** MSG0001 is the
  higher-salience dedicated message that carves the three first-entry statuses (`to_check`,
  `waiting_for_patron`, `waiting_for_fundraiser`) out of the MSG0005 grouped status-email catch-all:
  the emailed "application received" event for these first-entry statuses is owned **here** (MSG0001),
  not by MSG0005. The **in-zone** variant of these same first-entry status events is not owned here —
  it is the same status fan-out event that MSG0006 (the grouped in-zone status notification) groups.
  Ownership is therefore: MSG0001 = the email confirmation on first entry into
  `to_check` / `waiting_for_patron` / `waiting_for_fundraiser`; MSG0006 = the in-zone status message
  for those same status entries; MSG0005 = the emailed catch-all for the remaining (non-carved-out)
  status rows. (See MSG0005 and MSG0006.)

---

## Evidence Level

Confirmed for the trigger statuses and role×channel matrix (Notification Matrix rows for
`waiting_for_patron`, `waiting_for_fundraiser`, `to_check`; SC-1A steps 8–11; SC-1B steps 7–8;
SC-4A steps 1–2).

**Conflict — requires clarification (`to_check` email channel).** For the "both forms joined /
application received" event, SC-4A steps 1–2 mark Email = NO for both Parent and Patron, while the
Notification Matrix row for `to_check` marks Email = YES for both Parent and Patron. The two evidence
sources disagree on whether the confirmation email fires on first entry into `to_check`; this is
recorded as a conflict rather than resolved to either figure alone (per the evidence rule, code/flow
wins for current behavior, but the disagreement is stated and both sources are cited:
`intake/test-scenarios/test-scenarios.md` — SC-4A steps 1–2 and the Notification Matrix `to_check`
rows). Do not treat the Matrix YES/YES as settled for this event until clarified.

Partial on exact wording/subject differentiation between confirmation and
action-required variants at the same status, since the Notification Matrix records channel/status
outcomes, not per-recipient content text — content elements above are reconstructed from the shared
status vocabulary and UC0001/UC0002 flow evidence, not from a captured message body.
