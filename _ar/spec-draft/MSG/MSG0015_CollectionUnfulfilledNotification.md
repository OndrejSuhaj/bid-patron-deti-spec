---
doc_id: MSG0015
title: Collection Unfulfilled / Partial Notification
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0011
  - UC0022
references:
  - EN0004
  - EN0001
  - EN0009
  - EN0022
---

# MSG0015 – Collection Unfulfilled / Partial Notification

## Purpose

Tell the Parent (Žadatel) and the Patron that the Story's (Campaign, EN0004) fundraising collection
did not reach its target amount by the deadline — either fully unfulfilled (0% raised) or partially
fulfilled (1–99% raised) — and that the coordinator will follow up to discuss what happens next with
the raised amount (use it with an adjusted gift, or redistribute it to other children's Stories). This
is the deadline-driven "collection failed to complete" message family, distinct from the
success/completion message for a Campaign that reaches its target.

---

## Trigger

UC0011 (Manage Campaign / Story Lifecycle), sub-flow UC0011.2 (Scheduled lifecycle transitions —
deadline expiry / auto-completion): the Scheduler identifies an active Campaign whose deadline has
passed and whose raised amount is still below the target amount, sets the linked Application's
(EN0001) status to "campaign uncompleted" (`campaign_uncompleted` — cílová částka nevybrána), mirrors
the status onto the Campaign, and — per UC0011.3 — resolves the notification recipient list and
dispatches the "uncompleted campaign" message. UC0022 (Run Platform Workflow Engine) is cross-referenced
only: it owns the scheduled-publish cron mechanism but explicitly defers this deadline-driven
uncompletion flow and its notification to UC0011.

Confirmed narratively by SC-8C ("Collection Partially Fulfilled (1–99%)") steps 1–3 and SC-8D
("Collection 0% Unfulfilled") steps 1–3: the System detects the raised amount relative to target,
changes status to "Target Amount Not Reached," and sends the notification to Parent and Patron.

This message groups the related deadline-outcome statuses that share the same "collection did not
reach target" concept and downstream coordinator-decision step, per the Notification Matrix and
SC-8C/SC-8D:

- `campaign_uncompleted` (cílová částka nevybrána) — the deadline-expiry trigger event itself (both
  the 0% and partial cases pass through this status per UC0011.2).
- `campaign_uncompleted_inprocess` (nesplněný příběh — vypořádání darů) — the in-process/settlement
  variant of the same outcome while the coordinator's follow-up is pending.
- `uncompleted` (nesplněný příběh) — the Parent's decision path where the partial amount is declined
  and the Story is marked unfulfilled for gift redistribution (SC-8C steps 9–12), and the terminal
  status for the 0%-raised path (SC-8D).
- `completed_partly` (splněný příběh — částečné plnění / uzavřeno — částečné plnění) — the alternate
  Parent decision path where the partial amount is accepted and the back-office flow continues with an
  adjusted gift (SC-8C steps 5–8).

Evidence Level: Confirmed for the `campaign_uncompleted` deadline-expiry trigger and dual-recipient
intent (UC0011.2/UC0011.3, SC-8C, SC-8D). Partial for `campaign_uncompleted_inprocess`,
`uncompleted`, and `completed_partly` as distinct message instances — these follow-on statuses are
attested in the Notification Matrix and the SC-8C/SC-8D coordinator-decision narrative but are not
separately walked in UC0011's numbered flow; grouped here rather than split into unsupported separate
documents (see Notes).

---

## Recipients

- **Parent / Žadatel** — notified that the collection did not reach its target (fully or partially),
  that the coordinator will be in touch to discuss options for the collected amount.
- **Patron** — notified in parallel of the same outcome.

Channel — email via ES0006 (Mautic) and in-zone notification (Parent Zone / Patron Zone), per role and
status, evidenced by the Notification Matrix (`intake/test-scenarios/test-scenarios.md`, "Notification
Matrix" sheet):

| Status | Parent — Email | Parent — in-zone | Patron — Email | Patron — in-zone |
|---|---|---|---|---|
| `campaign_uncompleted` | YES | YES | YES | NO |
| `campaign_uncompleted_inprocess` | NO | NO | NO | YES |
| `uncompleted` | NO | YES | NO | NO |
| `completed_partly` | NO | NO | NO | NO |

SC-8C step 1–3 (system-level "partial collection" detection) additionally shows YES/YES/YES/YES across
Parent and Patron email + in-zone for the initial `campaign_uncompleted` transition, before the
Parent's decision branches the outcome to `uncompleted` or `completed_partly` — the narrower
per-status matrix rows above are treated as the current-state channel-of-record, consistent with the
project's evidence precedence for configuration-level detail.

Recipient scope beyond Parent/Patron: the underlying deadline-expiry dispatch resolves a recipient
list that also includes other contributors to the Campaign (donors) and a fixed oversight/operational
contact, in addition to Parent and Patron — evidenced narratively but not itemised per-role in the
Notification Matrix, which only tracks Parent/Patron/Donor role columns for the SC-8C/SC-8D sheets
(Donor columns are absent from those two sheets specifically). Treated as Partial evidence; the
Parent/Patron contract above is the Confirmed core of this message.

No CZ/RO/MD channel variants beyond the above are evidenced; delivery is per-country templated via
ES0006 but the recipient/channel contract itself is not shown to differ by market in current sources.

---

## Message Content

Conceptually, each instance of this message carries:

- A status message confirming the outcome, per the Notification Matrix literals:
  - `campaign_uncompleted`: "Spojíme se s vámi" (Parent) / "Dokončeno" (Patron).
  - `campaign_uncompleted_inprocess`: "Nesplněný příběh" (Parent) / "Nesplněný příběh v plné výši"
    (Patron).
  - `uncompleted`: "Nesplněný příběh" (Parent) / "Nesplněný příběh" (Patron).
  - `completed_partly`: "Částečně splněno" (Parent) / "Částečně splněno" (Patron).
- That the fundraising target was not reached (fully or only partially raised) by the deadline.
- That the coordinator will make contact (or has already made contact) to discuss what happens with
  the collected amount — either using it with a different/cheaper gift, or redistributing it to other
  children's Stories.
- Implicit case reference: shown in the context of the recipient's own Parent Zone / Patron Zone view
  of their Application (EN0001) / Story (Campaign, EN0004), reflecting the current status.

Excluded from this contract (delivery/implementation, not message content): exact copy/subject-line
text beyond the matrix literals cited above, HTML/visual presentation, per-country template selection,
and the mechanics of recipient-list resolution.

---

## Notes / Uncertainty

- This document groups four related statuses (`campaign_uncompleted`, `campaign_uncompleted_inprocess`,
  `uncompleted`, `completed_partly`) under one message contract because they represent stages of the
  same "collection did not complete" narrative (SC-8C, SC-8D) rather than four independent message
  types, per the task's grouping instruction (one MSG per distinct message type, not per matrix row).
  If future evidence shows materially different content per status beyond the literals already
  captured above, this may warrant splitting.
- Distinct from the terminal Story-cancellation message (`canceled_campaign`, when the Parent declines
  the partial amount and redistribution proceeds, or the 0%-raised case is formally cancelled per
  SC-8D steps 7–11) — cancellation is a separate downstream outcome, not part of this contract.
- The underlying dispatch for the `campaign_uncompleted` deadline-expiry event is evidenced (FLW0022)
  as lacking a resend/duplicate-send guard that other terminal-outcome messages in the same lifecycle
  have — i.e. if the status transition and the message dispatch are ever decoupled or re-run, a
  duplicate send to the same recipients is a possibility in the current system. Recorded here as a
  current-state characteristic of this message's delivery reliability, not as a message-content fact.
- Evidence Level: Confirmed for the `campaign_uncompleted` trigger, dual-recipient intent, and its
  Notification Matrix channel row; Partial for the downstream `campaign_uncompleted_inprocess` /
  `uncompleted` / `completed_partly` statuses as distinct sends and for the full non-Parent/Patron
  recipient scope, as recorded above.
