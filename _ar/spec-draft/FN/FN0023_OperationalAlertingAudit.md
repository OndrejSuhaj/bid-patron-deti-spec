---
doc_id: FN0023
title: Operational Alerting & Audit Trail
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0020
---

# FN0023 – Operational Alerting & Audit Trail

## Purpose

Give operations staff near-real-time visibility into error conditions and selected business events
occurring elsewhere in the platform, and retain a durable, searchable audit/request trail — without
any user-facing interaction. This capability is a cross-cutting side effect surfaced by other
processes rather than a domain workflow of its own.

---

## Responsibilities

The capability is responsible for:

- Detecting a loggable operational condition (an error, a failed background step, a flagged
  anomaly, or a notable business event) raised elsewhere in the platform and formatting it into an
  alert message.
- Fanning the alert out to the configured Slack and/or Telegram channel(s) at the appropriate
  severity.
- Forwarding outcome/audit records — including request/response records — to the audit/search
  store so that processed records remain retrievable for audit and search purposes.
- Carrying cross-cutting consistency alerts, such as the Application↔Campaign status desync
  warning, to the operational channel(s) as an alert-only signal (not an automated repair).

---

## Related Use Cases

UC0020 – Emit Ops Alerts & Audit

---

## Related Entities

None — this is an infrastructure capability; it owns no domain entity of its own and acts only as a
side channel for events originated by other capabilities.

---

## Integrations

- Slack — operational error/alert channel and business-event notifications (e.g. donation and
  voucher-purchase pings).
- Telegram — operational error/alert channel.
- Elasticsearch — durable audit/search store for request/response and processed-record trails.

(No dedicated ES-layer document exists yet for these integrations; see ARCH0002_ContextInteractionMap
for the current integrations landscape.)

---

## Constraints

- Cross-cutting side effect of other use cases: this capability owns no domain entity and has no
  independent trigger of its own — it activates whenever another process raises a loggable
  condition or event.
- The underlying listener flow (FL059) was un-mined (Depth=Skip); behavior on alert-delivery
  failure is unknown and is recorded as an evidence gap, not assumed.
- Alert delivery is best-effort: failure to deliver an alert results only in the alert being lost,
  it does not affect the outcome of the originating process.
- A hardcoded Slack webhook exists on a live entity-save path (evidenced in the current-state
  reconstruction) — an operational/architectural weakness of the current implementation, not a
  designed configuration mechanism.
- The Application↔Campaign desync alert is alert-only: it surfaces the inconsistency to operations
  staff but does not itself reconcile or repair the underlying state.
