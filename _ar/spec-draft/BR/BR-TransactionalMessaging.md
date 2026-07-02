---
doc_id: BR-TransactionalMessaging
title: Transactional Messaging & Send-Gate
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0022
  - EN0001
  - SYSTEM
references:
  - EN0022
  - EN0001
  - EN0026
  - UC0012
  - UC0002
---

# BR – Transactional Messaging & Send-Gate

## Purpose

Governs how transactional messages are gated, templated, archived, and dispatched, including the
environment send-gate, per-country template resolution, single-send guards, and the current-state
synchronous-send and untracked-delivery gaps.

## Send-gate and template resolution

- A transactional message SHALL be transmitted only when the environment send-gate permits it — in
  production, or to recipients on an internal allow-list — and SHALL otherwise be suppressed.
- A message SHALL resolve its template against the per-country template map; an unresolvable
  template name SHALL abort dispatch with a logged error.
- Current-state: when a template is defined only for one country, the other countries SHALL NOT be
  assumed to send that message (for example, the CZ-only donation confirmation).

## Archiving

- A message SHALL be archived per recipient (EN0022) regardless of whether it was transmitted,
  except that an aborted unresolvable-template attempt SHALL NOT create an archive record.
- Current-state: the archive delivery-status fields SHALL NOT be relied upon — they are never
  written, so a suppressed send is indistinguishable from a delivered one.

## Single-send guards (current-state)

- A paid-donation thank-you SHALL be sent at most once per donation.
- Current-state: the deadline-uncompletion notification carries no single-send guard and SHALL be
  treated as at-risk of resend.

## Dispatch coupling (current-state)

- Current-state: message dispatch is synchronous within the caller's request or save (the queue is
  disabled), so a slow or failing transport can block or abort the enclosing persistence operation,
  and there is no retry.

## Non-Goals

This rule does not define per-message triggers, recipients, or content (owned individually by the
MSG layer — see the MSG catalog, e.g. MSG0019 for the paid-donation thank-you and MSG0015 for the
deadline-uncompletion notification), the Application (EN0001) or Campaign status lifecycle that
originates a given message (see BR-ApplicationStatusGovernance, BR-CampaignStoryLifecycle), or
operational/ops-facing alerting (Slack/Telegram), which is out of scope here and owned by
BR-OperationalAlerting.
