---
doc_id: EN0022
title: EmailArchive
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — required reference on every archive record
  - EN0004  # Campaign — optional reference
  - EN0008  # User — author and resolved-recipient references
  - BR-TransactionalMessaging  # governs archiving / delivery-status policy
  - UC0012  # Dispatch Transactional Message — sole creation trigger
---

# EN0022 — EmailArchive

## Purpose

EmailArchive is the durable, per-recipient record of an outbound transactional message. Every time
the messaging orchestrator dispatches a templated message, one EmailArchive record is written for
each recipient, independent of whether the message was actually transmitted. It captures what was
sent (or attempted): the resolved addresses, subject, rendered body, the template used, and the
arguments supplied to that template, together with the business context the message relates to
(the driving Application, and optionally a Campaign). EmailArchive functions as an audit trail for
transactional messaging rather than as a business workflow object in its own right.

---

## Lifecycle

- Created (published)

EmailArchive has a single effective lifecycle state after creation: it exists and is published. It
does not carry a delivery-status state (e.g. sent, failed, suppressed) — see Invariants.

---

## State Transitions

(none) → Created  
trigger: UC0012 (Dispatch Transactional Message) — one EmailArchive record is created per recipient
during archiving (UC0012.2), for every dispatch attempt that passed template resolution.

No further state transitions occur after creation: EmailArchive records are not updated with a
delivery outcome (see Invariants).

---

## Attributes

### System-managed attributes

- to (string; required; resolved recipient address)
- from (string; required; resolved sender address)
- body (text; optional; rendered message body)
- template_name (string; required; identifies the template used, resolved per country)
- arguments (text; optional; the template's substitution values, recorded as supplied)
- to_user (reference to EN0008 – User; optional; recipient, auto-resolved from the `to` address)
- author (reference to EN0008 – User; optional; the user context active at creation time)
- status (boolean; published flag; defaults to published)

### User-provided attributes

- application (reference to EN0001 – Application; required; the business context the message relates to)
- campaign (reference to EN0004 – Campaign; optional; the campaign context the message relates to, when applicable)

Note: "user-provided" here means supplied by the calling business context that requests the
dispatch (per UC0012 preconditions), not entered by an end user through a form.

---

## Invariants

- Exactly one EmailArchive record is created per recipient per dispatch attempt that passes
  template resolution; a dispatch attempt with an unresolvable template name creates none
  (archiving policy owned by BR-TransactionalMessaging; see UC0012, AF1).
- An EmailArchive record, once created, does not carry a delivery-status outcome — a delivered
  message is indistinguishable from a suppressed or failed one (per BR-TransactionalMessaging; see
  UC0012 AF2, Postconditions).
- An EmailArchive record always references an Application (EN0001); no confirmed case of a valid
  EmailArchive without one is evidenced.

---

## Relationships

- EN0001 – Application (required; the business context of the message)
- EN0004 – Campaign (optional)
- EN0008 – User (author, and separately the resolved recipient)

---

## Open Questions

1. EmailArchive's data model reserves fields for a delivery outcome (sent/error), but no confirmed
   path ever populates them after creation — is delivery-status tracking a planned-but-unrealized
   capability, or intentionally out of scope for this entity?
2. The `to`/`from` attributes truncate long addresses at a fixed length in the current
   implementation — unclear whether this is an accepted constraint or a data-integrity gap.
3. `application` is treated as required by validation, but current evidence does not confirm this
   is enforced at the data-storage level — is an EmailArchive record with no Application reference
   ever valid?
4. No de-duplication or idempotency key exists on EmailArchive — re-invocation of a dispatch for the
   same logical message produces additional archive records and, where the send-gate allows it,
   additional transmissions. Uncertain — Not evidenced whether this is an accepted characteristic or
   an unaddressed gap.
