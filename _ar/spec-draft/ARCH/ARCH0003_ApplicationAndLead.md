---
doc_id: ARCH0003
title: Application & Lead Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
references:
  - ARCH0001
  - ARCH0002
  - EN0001
  - EN0002
  - EN0003
  - EN0025
  - EN0026
  - EN0027
  - UC0001
  - UC0002
  - UC0016
  - UC0019
  - FN0001
  - FN0002
  - FN0003
  - FN0025
  - MSG0001
  - MSG0002
  - MSG0005
  - MSG0006
  - MSG0007
  - MSG0008
  - MSG0009
  - MSG0010
  - MSG0012
  - MSG0017
  - MSG0018
  - MSG0029
  - BR-ApplicationStatusGovernance
---

# ARCH0003 – Application & Lead Domain

> Domain navigation document for bounded context **C1 Application & Lead** (ARCH0001 §4).
> Navigation layer only — it links deeper artifacts by `doc_id` and does not restate their content.
> Current-state; system-wide overview stays in [ARCH0001](../ARCH0001_ApplicationOverview.md) /
> [ARCH0002](../ARCH0002_ContextInteractionMap.md).

## Purpose

Explains the architectural perspective of the **case record** — how a request for child help enters
the platform as a *Lead*, becomes an *Application (Žádost)*, and is driven through its multi-state
workflow. This is the spine of the whole platform: nearly every other domain reacts to an Application
status change. See [ARCH0001](../ARCH0001_ApplicationOverview.md) §1 for why the case record is the
first of the three primary domain concepts.

---

## System Overview

C1 owns the aggregate whose single status field carries the ~66-state workflow spanning both lead-era
and application-era states on one record — "Lead" is the intake phase of the *same* Application, not a
separate entity ([EN0001](../EN/EN0001_Application.md); [ARCH0001](../ARCH0001_ApplicationOverview.md)
§1). The case record is the heavyweight root of the domain: it ties together the applicant/patron
profiles, role-scoped access sessions, and an append-only activity log, and it is the source of the
status event that fans out to risk, documents, messaging and campaign (ARCH0002 chain B).

The context's defining architectural trait is that status orchestration is realised as an
**entity-save side-effect** rather than a first-class service — the platform's main orchestration seam
([ARCH0001](../ARCH0001_ApplicationOverview.md) §3, §7; ARCH0002 §(c)).

---

## Structural Components

Conceptual components resident in this context (names/roles only; see the SRV taxonomy in
[ARCH0001](../ARCH0001_ApplicationOverview.md) §3):

- **Application-Lifecycle** (Domain service) — creates and edits the case record; provisions the party
  on submit. Capability: [FN0001](../FN/FN0001_ApplicationIntakeManagement.md).
- **Application-Status-Orchestrator** (Orchestrator) — the status-change seam that fans out to three
  subscribers (reaction, scoring, notification). Capability:
  [FN0002](../FN/FN0002_ApplicationStatusOrchestration.md).
- **ApplicationAction-Processor** (Async processor) — cron-driven automatic status transitions.
  Capability: [FN0003](../FN/FN0003_ScheduledStatusTransition.md).
- **Workflow / transition-legality gate** — the ~66-state workflow config and the (largely
  unenforced today) transition/readiness gate. Capability:
  [FN0025](../FN/FN0025_WorkflowEngineScheduledPublish.md); shared with C11.
- **Resident aggregate AG1 Application** — root [EN0001](../EN/EN0001_Application.md); members
  ApplicationProfile ([EN0002](../EN/EN0002_ApplicationProfile.md), held ≤2),
  ApplicationSession ([EN0003](../EN/EN0003_ApplicationSession.md)),
  ApplicationLog ([EN0025](../EN/EN0025_ApplicationLog.md), append-only audit).
- **Behaviour-config reference entities** — ApplicationReaction
  ([EN0026](../EN/EN0026_ApplicationReaction.md), status×role reaction rules) and ApplicationAction
  ([EN0027](../EN/EN0027_ApplicationAction.md), cron transition rules), read during the status
  fan-out.

---

## Interaction Model

How C1 talks to the rest of the system (per [ARCH0002](../ARCH0002_ContextInteractionMap.md) chain B
and §(a)/(c) — all synchronous in-request today unless noted):

- On submit, Application-Lifecycle calls **C9 Identity & Access** to provision User+Contact
  ([UC0001](../UC/UC0001_SubmitApplication.md); ARCH0002 §(a)).
- Every Application save dispatches the status event to three subscribers: **C2 Risk & Scoring**
  (recompute on `to_check`), the C1 ApplicationReaction handler (zone message / buttons / session
  lifecycle), and **C8 Messaging** (notification) ([UC0002](../UC/UC0002_OrchestrateApplicationStatusChange.md);
  ARCH0002 §(c)).
- The status seam also creates the contract in **C6 Documents & Fulfilment** at the signing state, and
  keeps status in bidirectional lock-step with **C3 Campaign & Story** (desync is alert-only, not
  repaired — ARCH0002 §(c)).
- **C6 OneDrive invoice import** re-enters the status fan-out when it attaches to the Application
  ([UC0019](../UC/UC0019_ImportInvoicesFromOneDrive.md)).
- Party dedup / lead pairing spans **C7 Party / CRM** ([UC0016](../UC/UC0016_MaintainPartyRecords.md)).
- Each Application save enqueues a **C10 Search** index update (genuinely async — ARCH0002 §(b)).
- No external system is called directly by C1; external touches happen through the sibling domains.

---

## Cross-links

- **relatedEN:** EN0001, EN0002, EN0003, EN0025, EN0026, EN0027
- **relatedUC:** UC0001, UC0002, UC0016, UC0019
- **relatedFN:** FN0001, FN0002, FN0003, FN0025
- **relatedES:** (none — C1 reaches external systems only via sibling domains)
- **relatedMSG:** MSG0001, MSG0002, MSG0005, MSG0006, MSG0007, MSG0008, MSG0009, MSG0010, MSG0012,
  MSG0017, MSG0018, MSG0029 (status-driven case & completion/feedback-request messages carried by the
  status fan-out; message *transport* is owned by C8 /
  [FN0019](../FN/FN0019_TransactionalMessaging.md))
- **relatedBR:** BR-ApplicationStatusGovernance
  ([../BR/BR-ApplicationStatusGovernance.md](../BR/BR-ApplicationStatusGovernance.md)) — party
  provisioning & dedup rules are owned by C7's
  [BR-PartyIdentityAndDeduplication](../BR/BR-PartyIdentityAndDeduplication.md).

> **Navigation note.** Transition legality is a shared concern with C11
> ([ARCH0012](ARCH0012_PlatformSearchAndOperations.md)); it is documented as largely **not enforced**
> today (HS02) — see [BR-ApplicationStatusGovernance](../BR/BR-ApplicationStatusGovernance.md).
