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
  condition or event. FLW0034 confirms it is both a passive logger-channel sink (ERROR/CRITICAL
  records fan out to both channels) and an actively-invoked service (~48 direct forced-alert
  `->log(3,…)` call sites across payments/finance/cron/queue code).
- The underlying ops-logger flow (FLW0034, was flow-index FL059) is now mined (Confirmed). Delivery
  behavior on failure is evidenced: a failed POST is only self-logged and the alert is lost — there
  is no queue, retry, backoff, or dead-letter (the `slack_queue` is created but never used). If the
  Slack/Telegram config is absent, `log()` returns silently without posting.
- Alert delivery is best-effort AND synchronous on the hot path: the outbound POST carries no timeout
  override, so a slow/unreachable Slack/Telegram can block the emitting request/cron path (FLW0034).
- Level routing (FLW0034): Slack routes ERROR→errors-webhook and CRITICAL→checks-webhook and drops
  EMERGENCY/ALERT entirely; Telegram posts every passing level to a single bot chat. Direct
  `->log(3,…)` callers hard-code ERROR for many routine operational notices → alert-fatigue / signal
  dilution.
- `sendMessageToZoneChannel()` (the Slack "activity feed" path, ~25 call sites: logins, profile /
  password changes, new-lead creation, contact-form submissions) is an **empty no-op** — those
  signals are silently dropped and never reach Slack (FLW0034).
- PII / sensitive data can leave the platform boundary: direct callers interpolate user identifiers
  and business data (incl. exception bodies) into the message before POSTing to Slack/Telegram;
  strip_tags + 1800-char truncation do not redact PII (FLW0034).
- No tenant/country (CZ/RO/MD) partitioning of alerts — all-region errors land in the same global
  channel(s) (FLW0034).
- A hardcoded Slack webhook exists on a live entity-save path (evidenced in the current-state
  reconstruction) — an operational/architectural weakness of the current implementation, not a
  designed configuration mechanism.
- The Application↔Campaign desync alert is alert-only: it surfaces the inconsistency to operations
  staff but does not itself reconcile or repair the underlying state.
