# UC0020 — Emit Ops Alerts & Audit

## Header

| Field | Value |
|---|---|
| UC ID | UC0020 |
| Name | Emit Ops Alerts & Audit |
| Bounded Context | C11 |
| Primary Actor(s) | System |
| Trigger Type | Listener |

## Actors & Responsibilities

- **System** — detects an operational condition worth surfacing to staff (an error, a data-consistency anomaly, or a noteworthy business event) and routes it to the configured alert channel(s); separately, forwards outcome/audit records to the search-index/audit store.
- **Integration(Slack)** — receives operational and business-event alert messages posted to a channel.
- **Integration(Telegram)** — receives operational error/alert messages posted to a channel.
- **Integration(Elasticsearch)** — receives indexed records that constitute the durable audit/search trail.

## Intent

Give operations staff near-real-time visibility into error conditions and selected business events occurring elsewhere in the platform, and retain a durable, searchable audit trail of processed records, without requiring any user-facing interaction.

## Preconditions

- A logger/alerting channel is configured and reachable (Slack channel and/or Telegram channel).
- An indexing/audit sink (Elasticsearch) is configured and reachable.
- Some other use case in the platform has emitted a loggable event (error, anomaly, or notable state change) that this listener channel picks up.

## Main Flow

### UC0020.1 — Ops alert fan-out (Slack / Telegram)
1. System: detects a loggable operational condition (e.g. an error, a failed background step, or a flagged anomaly) raised by another process.
2. System: formats the condition into an alert message.
3. Integration(Slack): receives the alert message on a configured channel.
4. Integration(Telegram): receives the alert message on a configured channel.

### UC0020.2 — Audit trail indexing
1. System: receives a record (entity change or processed item) destined for the audit/search trail.
2. Integration(Elasticsearch): stores the record so it is retrievable for audit and search purposes.

## Alternative Flows

### AF1 — Alert channel unreachable
1. System: attempts to deliver an alert to Slack or Telegram and the delivery fails or is silently absent.

Outcome: Evidence for this path is not mined (FL059, Depth=Skip); behavior on delivery failure is unknown — recorded as a gap, not assumed.

## Postconditions

- An operational alert has been posted to the configured channel(s) (Slack and/or Telegram), if delivery succeeded.
- A corresponding record exists in the audit/search store (Elasticsearch), if indexing succeeded.
- No domain entity is created, transitioned, or owned by this use case — it is a cross-cutting side effect of other use cases.

## Traceability

Target SRVs:
- Ops-Logging-Adapters
- Elasticsearch-Adapter

EN entities:
- (none — infrastructure UC; no owned domain entity)

Integration boundaries:
- Slack
- Telegram
- Elasticsearch

Flow Evidence:
- FL059 (un-mined, Depth=Skip — coverage stub only)

## Evidence Level

Partial — anchored only to the un-mined FL059 listener flow (Depth=Skip); SRV-target-list.md and UC-srv-traceability.md confirm Ops-Logging-Adapters/Elasticsearch-Adapter exist as target SRVs with no dedicated mined dossier, and no EN entity is owned here, so behavior beyond this coverage stub must not be assumed.
