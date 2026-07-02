---
doc_id: MSG0008
title: Find New Patron Notice
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
references:
  - EN0001
  - EN0002
  - EN0005
  - EN0022
  - ES0006
---

# MSG0008 – Find New Patron Notice

## Purpose

Tell the Parent (Žadatel) that the current Patron will not be proceeding with the Application
(Žádost) — either because the Patron failed to complete their part after both reminders elapsed, or
because the Patron actively declined the nomination — and that the Parent must nominate a
replacement Patron for the case to continue. In the same event, tell the original Patron that their
involvement with this Application (EN0001) has ended. If the Parent does not supply a replacement
Patron in time, the request is restated to the Parent with escalating reminders.

This is a distinct, higher-salience message type broken out of the generic status-driven catch-all
(MSG0005/MSG0006): the patron-change event carries a specific call to action (nominate a
replacement) rather than a generic "your status changed" notice, and it addresses two different
parties with two different messages in the same event.

---

## Trigger

UC0002 (Orchestrate Application Status Change) — the downstream reaction fan-out (UC0002.2) firing on
entry into the `returned_new_patron` status, reached either:

- automatically, when the Patron has not completed their part of the Application within the
  configured window after the second reminder has elapsed (Patron-non-completion timeout path), or
- immediately, when the Patron actively declines the nomination (Patron 'Decline' action).

Entry into `returned_new_patron` also drives the associated data-scrub side effect on the Application
(EN0001) documented at UC0002 AF3 (patron-related profile and scoring data cleared) — that behavior is
owned by UC0002/EN0001, not restated here.

If the Parent has not supplied a replacement Patron's contact details, the same request is restated
to the Parent on two escalating reminder occasions: `returned_new_patron_reminder_1` and
`returned_new_patron_reminder_2`.

Evidenced by the Notification Matrix rows for `returned_new_patron`, `returned_new_patron_reminder_1`,
`returned_new_patron_reminder_2` (`intake/test-scenarios/test-scenarios.md`, "Notification Matrix"
sheet) and by acceptance scenarios SC-2C (Patron non-completion → patron change), SC-2D (Patron
declines), SC-6A (new Patron found and completes), and SC-6C (Parent never supplies a new Patron →
application cancelled).

---

## Recipients

Two different parties receive two different messages in the same triggering event:

| Party | Channel(s) | Notification Matrix evidence |
|---|---|---|
| Parent / Žadatel | Email (ES0006 Mautic) + in-zone (Parent Zone) | `returned_new_patron` → Parent: Email YES; in-zone: not evidenced as YES on the initial row, but the reminder rows (`returned_new_patron_reminder_1`, `returned_new_patron_reminder_2`) show both Email and in-zone YES for the Parent |
| Original Patron | Email (ES0006 Mautic) + in-zone (Patron Zone) | `returned_new_patron` → Patron: Email YES, in-zone YES |

The reminder variants (`returned_new_patron_reminder_1`, `returned_new_patron_reminder_2`) target the
Parent only — no corresponding reminder row addresses the original Patron, who has already been told
their involvement ended at the initial event.

CZ is the evidenced primary market for this message; no RO/MD-specific content variant is evidenced
beyond the platform's general per-country template resolution (FN0019).

---

## Message Content

Conceptual information elements the message must carry (no template markup, no subject-line wording):

**To the Parent (initial and both reminder occasions):**

- A statement that the current Patron will not be proceeding with the Application (EN0001) — either
  due to non-completion or an active decline — so the Parent understands why action is now required.
- A call to action: the Parent must provide a new Patron's identifying and contact information (name
  and email) so the Application can continue.
- A pointer to where in the Parent Zone this replacement-Patron information is to be entered.
- On the reminder occasions, the same request restated with an escalating urgency framing, tied to
  the outstanding deadline for the Parent to respond.

**To the original Patron (initial event only):**

- A statement that the Application (EN0001) cannot proceed with them — i.e., that their nomination
  has been returned/rejected — so they understand their involvement with this specific case has
  ended.
- No call to action for the Patron: this is a closing notice, not a request.

Every dispatch of the email variant of either message is archived as an EmailArchive (EN0022) record
regardless of whether the send is actually transmitted (FN0019).

---

## Notes / Uncertainty

- Groups the `returned_new_patron` status together with its two reminder statuses
  (`returned_new_patron_reminder_1`, `returned_new_patron_reminder_2`) as one message type with a
  Parent-facing request/reminder variant and a Patron-facing closing-notice variant, per the grouping
  instruction for this synthesis pass — it is not exploded per Notification Matrix row.
- If the Parent nominates a replacement Patron, that new Patron receives MSG0002 (Application
  Completion Link) to complete their part of the Application — a separate message dispatched off the
  patron-nomination action, not part of this message's own content (see MSG0002 Trigger, patron-change
  path).
- If the Parent never supplies a replacement Patron and all reminder deadlines lapse, the case ends
  via a separate cancellation notice (Notification Matrix status `canceled_timeout` / SC-6C) — outside
  this MSG's scope.
- The Notification Matrix marks the initial `returned_new_patron` → Parent row as in-zone
  notification "NO" while the SC-2C/SC-2D acceptance scenarios and their matrix rows (lines ~134,
  147) describe the Parent Zone showing a "Find a New Patron" action-required state at this same
  event — this is a **Conflict — requires clarification**: recorded here rather than silently
  resolved. Both the reminder rows for the Parent show in-zone = YES without ambiguity.
- Exact literal subject/body wording (e.g. "Najděte nového Patrona", "Zamítnutá žádost") is
  configuration/status-vocabulary data, not asserted as fixed template copy in this canonical
  document (see rules-MSG.md restrictions).
