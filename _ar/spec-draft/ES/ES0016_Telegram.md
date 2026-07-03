---
doc_id: ES0016
title: Telegram
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0023
  - FN0006
  - UC0020
---

# ES0016 – Telegram

## Purpose

Telegram gives operations staff a second, independent channel for receiving error-severity
operational alerts raised by the platform's logger — including the Application↔Campaign desync
warning — so that a loggable error condition is not visible through only one notification surface
(`ARCH0001` §5 row 16; `FN0023`).

---

## System Overview

Telegram is a messaging platform. For this integration, the platform's boundary with Telegram is
its Bot API: an outbound message posted to a configured chat, which then surfaces as a notification
to whoever is watching that chat. Patronus does not use Telegram for any end-user-facing messaging —
only as an ops-alert recipient (`ARCH0001` §5 row 16).

---

## Integration Model

Outbound only. The platform's logger forwards error-severity log entries to a configured Telegram
chat as a best-effort, fire-and-forget side-effect of whatever process raised the loggable
condition — it is not part of that process's own success/failure path (`UC0020`, main flow
UC0020.1; `ARCH0002` — ops-alert/audit listener chain). There is no inbound direction: Telegram does
not send anything back into the platform.

---

## Data Exchange

Outbound only: operational error/severity alert messages, conceptually equivalent to what is also
sent to the Slack ops channel — including the Application↔Campaign status desync alert (`INV04`,
carried by `FN0006`'s lock-step constraint). This is described only at the level of "an alert
message exists"; no message payload, field, or formatting detail is asserted here (`UC0020`).

---

## Constraints

- **Failure impact:** best-effort delivery — if the Telegram channel is unreachable, the only
  consequence is that the alert is lost; it does not affect the outcome of the originating process
  (`ARCH0001` §5 row 16).
- **Alert-only, not repair:** the Application↔Campaign desync alert (`INV04`) that this channel
  carries is a notification of an inconsistency, not an automated reconciliation of it.
- **Evidence level:** the listener/fan-out flow that feeds this channel is now mined (FLW0034) —
  Confirmed for the fan-out (`Partial` residual on the ES audit sub-flow only,
  `HS16`) — behavior beyond "an error-severity alert is forwarded here" is not further evidenced.
- **Distinct vendor boundary:** grouped with Slack under the same ops-alerting cluster (`FN0023`)
  but is a separate external-system boundary from it — the two channels are alternative/parallel
  recipients of the same class of alert, not the same integration.
- **Current-state only:** reflects the integration as evidenced today; no target-state change is
  asserted here.
