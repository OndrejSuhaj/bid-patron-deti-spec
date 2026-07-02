---
doc_id: BR-OperationalAlerting
title: Operational Alerting & Audit Trail
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - SYSTEM
references:
  - EN0001
  - EN0004
  - UC0020
---

# BR – Operational Alerting & Audit Trail

## Purpose

Governs operational alerting and audit-trail retention as a best-effort, cross-cutting side channel
raised by other processes, and records that a detected Application↔Campaign consistency desync is
alerted, not repaired.

---

## Alerting

- A loggable operational condition or notable business event raised elsewhere in the system SHALL be
  formatted into an alert and fanned out to the configured operational alert channel(s) at the
  appropriate severity.
- Alert delivery SHALL be best-effort — failure to deliver an alert SHALL affect only the alert
  itself and SHALL NOT change the outcome, state, or result of the originating process.

---

## Audit trail

- Outcome records and request/response records SHALL be forwarded to the durable audit/search store
  so that processed records remain retrievable for audit and search purposes.

---

## Consistency-alert-only delivery

- The Application↔Campaign desync condition (the alert-only-and-not-repaired policy is owned by
  `BR-ApplicationStatusGovernance`) SHALL be routed through this alerting channel like any other
  operational condition — best-effort, and without altering the outcome of the originating process.

---

## Non-Goals

- This rule does not define user-facing transactional messaging (recipients, channels, or send
  gating for donor/fundraiser-facing communication) — see BR-TransactionalMessaging.
- This rule does not define the Application↔Campaign consistency rule itself (when a desync arises or
  how the two are kept in lock-step) — see BR-ApplicationStatusGovernance; this rule owns only how the
  resulting alert is delivered.
- This rule does not define the step-by-step alert/audit processing flow — see UC0020.
- This rule owns no domain entity.
