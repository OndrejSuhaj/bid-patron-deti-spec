---
doc_id: FN0002
title: Application Status Orchestration & Reaction Fan-out
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0002
  - UC0004
  - UC0011
  - UC0019
  - EN0001
  - EN0025
  - EN0026
  - EN0003
  - EN0004
---

# FN0002 – Application Status Orchestration & Reaction Fan-out

## Purpose

Provide the single seam through which an Application's (EN0001) status changes and, on every change, drive the
configured downstream reactions consistently — audit logging, in-app/zone messaging, session lifecycle, risk
recomputation, and document/search side-effects — regardless of whether the change came from a human, a rule, or
system logic. This is the orchestration backbone of the case lifecycle described in UC0002.

## Responsibilities

- Apply a new status to an Application (EN0001), record a status-history/audit entry (ApplicationLog, EN0025), and
  create a new revision.
- Match the new status (and role) against configured reaction rules (ApplicationReaction, EN0026) and fan out the
  resulting log entries, session creation, and notification triggers.
- Create and bulk-deactivate role-scoped sessions (ApplicationSession, EN0003) as dictated by the status.
- Trigger status-driven transactional notifications, document generation, and risk recomputation where the status
  requires them.
- Enqueue the case for search re-indexing and keep an attached Story/Campaign status in lock-step.

## Related Use Cases

UC0002 (primary); consumed by UC0004 (contract signature drives status), UC0011 (campaign lock-step), UC0019
(attachment save re-enters the orchestration even though only the attachment changed).

## Related Entities

EN0001 (subject), EN0025 (audit rows), EN0026 (reaction configuration), EN0003 (sessions), EN0004 (attached Story/Campaign kept in status lock-step).

## Integrations

None (downstream messaging/search/document effects reach external systems only through their own capabilities).

## Constraints

- Realized today as an entity-save side-effect, not a first-class service: every save raises the event and fans
  out synchronously, in-request, with no changed-status guard and no idempotence — an unchanged re-save still
  re-logs and can re-notify.
- The fan-out is non-transactional: a mid-sequence failure can leave the case with some reactions run and others
  not.
- No server-side transition-legality enforcement on the change itself is part of this capability.
