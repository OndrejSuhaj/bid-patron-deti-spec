---
doc_id: EN0025
title: ApplicationLog
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application (logged aggregate)
  - EN0008  # User (author)
  - EN0026  # ApplicationReaction (reaction driving a log entry)
  - EN0003  # ApplicationSession (session-cancellation log entry)
  - UC0002  # Orchestrate Application Status Change (reaction/session-cancel log entries)
  - UC0004  # Manage Contract And Signature (contract activity log entries)
  - BR-ApplicationStatusGovernance  # status-change side effects incl. audit logging
---

# EN0025 — ApplicationLog

## Purpose

An immutable per-Application activity/audit record, surfaced to administrators as the Application's
activity history. Each ApplicationLog entry captures one discrete event against an Application
(EN0001): a logged communication (call/email/sms), a system-driven action (e.g. a reaction triggered
by a status change, or a session cancellation), or a note. Entries accumulate over the Application's
lifetime and together form its activity trail.

---

## Lifecycle

Recorded — the only state. An ApplicationLog entry is created once and is never subsequently changed
or removed; there is no further lifecycle beyond its creation.

---

## State Transitions

(none) → Recorded
trigger: UC0002 — Orchestrate Application Status Change (a matching ApplicationReaction, EN0026,
produces a log entry; a session-invalidating status change produces a log entry recording the
session cancellation)

(none) → Recorded
trigger: UC0004 — Manage Contract And Signature (contract-review and contract-signing steps each
record an activity log entry on the Application)

No transition out of Recorded is evidenced — entries are append-only.

---

## Attributes

### System-managed attributes

- Application (reference to EN0001; required) — the Application this entry is recorded against.
- Author (reference to EN0008; required) — the user attributed as author of the entry; defaults to
  the current user, or to the system service account for system-generated entries (see BR-ApplicationStatusGovernance).
- Recorded at (timestamp; required) — when the entry was created.
- Last touched at (timestamp; required) — administrative/technical timestamp alongside the recorded
  time; no update use case is evidenced for entry content.

### User-provided attributes

- Activity descriptor (text, up to 50 characters; required) — short label identifying the changed
  field or the activity type.
- Associated value (text, up to 255 characters; optional) — value associated with the activity
  descriptor.
- Note (long text; optional) — free-text note ("Poznámka").

---

## Invariants

- An ApplicationLog entry, once recorded, is immutable — see BR-ApplicationStatusGovernance
  (status-change side effects and idempotence).
- Every status change that matches a configured ApplicationReaction (EN0026), and every status
  change that invalidates ApplicationSession (EN0003) records, produces a corresponding
  ApplicationLog entry — see BR-ApplicationStatusGovernance.
- No lifecycle-state attribute is defined on this entity — Recorded is the entity's only state, not
  a status value chosen from a vocabulary.

---

## Relationships

- EN0001 — Application (the logged aggregate; required, one Application per entry)
- EN0008 — User (the author of the entry)
- EN0026 — ApplicationReaction (configuration that can cause a log entry to be produced)
- EN0003 — ApplicationSession (session-cancellation events logged against the Application)

---

## Open Questions

1. Is there a controlled vocabulary of activity types (call/email/sms/system-action/field-change)
   behind the activity descriptor and associated value, or is content free-form per writer? Not
   evidenced in canonical artifacts.
2. Conflict — requires clarification: prior evidence noted two scaffolding-level attribute mappings
   without any corresponding backing field, suggesting either dead configuration or a lost/never-
   implemented attribute. Not resolved; carried forward as an open question rather than a canonical
   fact.
3. Uncertain: the entity's field descriptions were found to closely mirror a comparable log entity
   used elsewhere in the system (campaign-side activity logging); it is not confirmed whether this
   is coincidental convergence or shared/copied definition, and whether any Campaign-specific
   semantics were unintentionally carried over.
