---
doc_id: MSG0017
title: Application Cancelled — Timeout
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

# MSG0017 – Application Cancelled — Timeout

## Purpose

Notify both the Parent (Žadatel) and the Patron that the Application (Žádost, EN0001) has been
automatically cancelled because a required step — completing the Parent's or Patron's part of the
form, or the Parent nominating a replacement Patron — was not carried out within the configured
reminder-and-deadline window. This is the terminal, system-initiated (not human-initiated) closure
message for the timeout path, distinct from a voluntary cancellation by a party and from a Story-side
cancellation.

---

## Trigger

UC0002 (Orchestrate Application Status Change) — specifically the scheduler-driven automatic
status-transition sub-flow (UC0002.3): once an Application (EN0001) has aged past its second reminder
by the configured further period (evidenced as 7 calendar days) with still no completion, the
Scheduler moves it into the timeout-cancellation status, which re-enters the Main Flow (UC0002.1) and
fires the status-driven notification fan-out (UC0002.2 step 6).

Firing statuses (Status vocabulary, Confirmed against the Notification Matrix):

- `canceled_timeout` — reached from the Parent-completion timeout path (SC-3C), the return-for-
  completion timeout path (SC-4B step 13), the new-patron-does-not-complete path (SC-6B step 6), and
  the Parent-does-not-provide-new-patron-info path (SC-6C step 4). In every one of these acceptance
  scenarios, both Parent and Patron receive the message (email + in-zone notification), consistent
  with the Notification Matrix `canceled_timeout` rows for both roles.
- `canceled_fundraiser` — the equivalent timeout-cancellation outcome on the Patron-initiated
  ("fundraiser"/Parent-side-pending) variant of the application flow (SC-2* Patron-initiates-first
  path), evidenced in the Notification Matrix as a Patron-only row (Email = YES, Notification = YES);
  no corresponding Parent-role matrix row is evidenced for this status.

Both statuses represent the same conceptual event — automatic cancellation after exhausting the
reminder/deadline sequence — applied to different origination paths of the Application. This document
treats them as one message type with a status/role variant, not as two separate messages.

Evidence Level: Confirmed for the existence, trigger mechanism, and both-party delivery shape on
`canceled_timeout` (cross-checked across SC-3C, SC-4B, SC-6B, SC-6C and the Notification Matrix).
Partial for `canceled_fundraiser`: evidenced only as a single Notification Matrix row (Patron-facing),
without a matching acceptance-scenario walkthrough or a confirmed Parent-side counterpart row.

---

## Recipients

- **Parent (Žadatel)** — email (via ES0006 Mautic) and in-zone notification, for the `canceled_timeout`
  status (Notification Matrix: Email = YES, Notification = YES). Not separately evidenced for
  `canceled_fundraiser` (no Parent-role row present in the matrix for that status).
- **Patron** — email (via ES0006 Mautic) and in-zone notification, for both `canceled_timeout` and
  `canceled_fundraiser` (Notification Matrix: Email = YES, Notification = YES on both statuses).

No CZ/RO/MD content variance is evidenced beyond the general per-country template resolution that
applies to all transactional messages [ES0006].

---

## Message Content

The conceptual information elements the message must carry:

- A statement that the Application (EN0001) has been cancelled, and that the reason is a timeout —
  the required step (completing the form, or nominating a replacement Patron) was not done within
  the deadlines given across the reminder sequence.
- Identification of the subject Application (EN0001) and, where relevant, its associated child, so
  the recipient recognises which case is being closed.
- A courteous closing tone acknowledging the outcome, without assigning blame in the wording itself
  (the underlying cause — non-completion — is implicit from context, not necessarily spelled out
  verbatim).
- An invitation to re-apply / start a new application if the recipient is still interested in
  participating, consistent with the cancellation being a process-timeout outcome rather than a
  content-based rejection.
- A pointer back to the recipient's zone (Parent zone / Patron zone), where the cancelled status
  remains visible after the message is sent.

No fixed subject-line text, body markup, or template structure is asserted in this canonical
document — the concrete wording is instance data per ApplicationReaction configuration and is out of
scope for the MSG layer. Every dispatch is archived as an EmailArchive (EN0022) record, per the
general transactional-messaging archival behavior.

---

## Uncertainty / Notes

- This message is the **system/automatic** cancellation-on-timeout outcome. It is distinct from:
  - a **voluntary**, human-initiated cancellation by the Parent, Patron, or Coordinator (a separate
    message type, not covered here);
  - a **Story-side** cancellation (campaign/collection-level cancellation, a separate message type,
    not covered here);
  - the `canceled_lead` status, which is folded into the generic status-driven catch-all message
    rather than treated as its own document.
- `canceled_fundraiser` is kept grouped with `canceled_timeout` under this one message type because
  both represent the same conceptual event (automatic cancellation after the reminder/deadline
  sequence lapses) on different origination paths of the Application; the Patron-only recipient
  evidence for `canceled_fundraiser` is recorded above as a Partial-evidence gap rather than resolved
  by assumption.
- `Hypothesis — Not evidenced in current sources`: the exact wording of the re-apply invitation and
  whether it is present on every instance of this message, versus being general boilerplate shared
  with other cancellation-family messages — only the overall intent (courteous close, re-apply
  possibility) is inferable from the status semantics and the surrounding acceptance scenarios, not
  from a captured message body.
