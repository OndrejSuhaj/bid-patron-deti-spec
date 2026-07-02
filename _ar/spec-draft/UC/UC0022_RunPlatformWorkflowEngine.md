# UC0022 — Run Platform Workflow Engine & Scheduled Publish

## Header

| Field | Value |
|---|---|
| UC ID | UC0022 |
| Name | Run Platform Workflow Engine & Scheduled Publish |
| Bounded Context | C11 |
| Primary Actor(s) | System, Scheduler |
| Trigger Type | Config/Cron |

## Actors & Responsibilities

- **Scheduler** — runs the platform's recurring scheduled-publish cron on a fixed tick, without human interaction (the lifecycle cron itself is owned by UC0011).
- **System** — hosts the Workflow-Engine allowed-transition/readiness gate that governs which state changes are legal, and (for the scheduled-publish path owned here) is expected to promote date-gated content to published state through that gate; the lifecycle transitions the gate governs are exercised by UC0011.
- **Admin** — (supporting, not primary) manually triggers a publish/activation action that passes through the same Workflow-Engine gate; included here only to name the gate, not as this UC's owning flow — that flow is UC0011.
- **Reference-Data** (supporting lookup) — provides shared reference values (e.g. geographic lookups) consulted incidentally by publish logic; not a decision-making actor.

## Intent

Provide the platform-wide Workflow-Engine allowed-transition/readiness gate that governs legal state changes, and run the scheduled-publish job that is expected to promote date-gated content to its published state through that gate without a human actor initiating each change. The lifecycle transitions this gate governs (campaign publish, deadline-driven uncompletion) are exercised by UC0011 and are not narrated here.

## Preconditions

- A workflow/transition configuration exists that defines allowed states and role-gated transitions for the Application (EN0001).
- The Scheduler tick (platform cron) is configured and running.
- For the scheduled-publish sub-flow owned here: content items exist with a future-dated publish condition (evidence not mined — see Evidence Level).

## Main Flow

> Scope note: the allowed-transition and readiness gate enforced by the Workflow-Engine SRV is not narrated here — it is exercised in full by UC0011 (campaign publish, UC0011.1; deadline-driven campaign uncompletion, UC0011.2). See UC0011 for that flow, its Alternative Flows, and its Postconditions. This UC owns only the FL057 scheduled-publish sub-flow below.

### UC0022.1 — Scheduled publish of date-gated content (Partial — coverage stub)

1. Scheduler: is expected to trigger a scheduled-publish job on a recurring tick to promote date-gated content items (e.g. Applications (EN0001) or Campaigns (EN0004) held for a future publish date) to their published state.
2. System: is expected to evaluate each pending item's scheduled publish date/time against the current time and apply the publish transition, through the same Workflow-Engine gate exercised by UC0011, when due.

> Status: Hypothesis-stub. This sub-flow's underlying job has not been mined (see Evidence Level). The steps above are stated at the minimum abstraction supported by the flow-index reference FL057 and must not be treated as a confirmed mechanism.

## Alternative Flows

> The failure and gate-rejection alternatives for the lifecycle-cron and readiness-gate paths (deadline-batch error handling, readiness/workflow configuration blocking a publish action) are owned by UC0011 (see UC0011 AF1–AF3) and are not restated here.

### AF1 — Scheduled-publish job not evidenced

1. System: no scheduled-publish job has been mined, so no confirmed failure or blocking behavior can be stated for the UC0022.1 coverage stub.

Outcome: undefined — see Evidence Level; this alternative is a placeholder pending mining of FL057.

## Postconditions

- The lifecycle-transition and readiness-gate postconditions (over-deadline uncompletion, gate-passing activation, and the resulting notifications and re-indexing) are owned by UC0011 — see UC0011 Postconditions; they are not restated here.
- No confirmed postcondition for the scheduled-publish sub-flow (UC0022.1) — see Evidence Level.

## Traceability

Target SRVs:
- Workflow-Engine
- ScheduledPublish-Processor
- Reference-Data

EN entities:
- EN0001 Application — candidate subject of the date-gated scheduled-publish transition (UC0022.1); its lifecycle transitions and status-history behavior are owned by UC0011.
- EN0004 Campaign — candidate subject of the date-gated scheduled-publish transition (UC0022.1); its deadline-driven and readiness-gated transitions are owned by UC0011.

Integration boundaries:
- None (internal scheduler/workflow-configuration behavior; no external system called directly by this UC).

Flow Evidence:
- FL057 (un-mined — scheduled publish of date-gated content, UC0022.1; this UC's own Partial anchor and only substantive content)
- FLW0021 / FLW0022 (borrowed from UC0011, not owned here — the Workflow-Engine allowed-transition/readiness gate is exercised by UC0011.1 campaign publish and UC0011.2 deadline-driven uncompletion; cited for cross-reference only, not as UC0022's confirmed anchors)

## Evidence Level

Partial — the Workflow-Engine allowed-transition/readiness gate is evidenced only indirectly here, by cross-reference to UC0011, which owns FLW0021 and FLW0022 as its Confirmed anchors; UC0022 does not re-narrate those flows and does not carry them as its own confirmed evidence. UC0022 itself contributes no independent mining beyond the un-mined flow-index reference FL057, which anchors the ScheduledPublish-Processor SRV claim (UC0022.1) at Hypothesis-stub level only. The UC's overall evidence level is therefore Partial.
