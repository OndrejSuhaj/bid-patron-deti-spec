---
doc_id: ARCH0012
title: Platform, Search & Operations Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
references:
  - ARCH0001
  - ARCH0002
  - UC0018
  - UC0020
  - UC0022
  - FN0022
  - FN0023
  - FN0025
  - FN0026
  - ES0014
  - ES0015
  - ES0016
  - BR-SearchIndexingConsistency
  - BR-OperationalAlerting
  - BR-ApplicationStatusGovernance
---

# ARCH0012 – Platform, Search & Operations Domain

> Domain navigation document covering **two merged bounded contexts**: **C10 Search & Indexing** and
> **C11 Platform / Integration Fabric** (ARCH0001 §4). Navigation layer only — links deeper artifacts
> by `doc_id`, does not restate them. Current-state.

## Purpose

Explains the architectural perspective of the **cross-cutting platform fabric**: search indexing, the
workflow engine and its (largely unenforced) transition-legality gate, scheduled publishing, reference
/ geographic lookup data, and operational alerting + audit. None of these are a business domain in
themselves; they are the infrastructure the business domains stand on.

**Merge rationale.** C10 and C11 are both **thin / partially-mined** contexts (ARCH0001 §4 note; HS16):
C10 owns no resident aggregate and indexes other aggregates as a save-time side-effect, and C11 owns no
resident aggregate either (only reference/config entities). Their core flows (search index-sync,
scheduled publish, the ops-alert listener) were never fully mined. Per the task's guidance to merge
genuinely thin/adjacent contexts (Search + Ops-infra), they are documented together here as one
platform/operations navigation surface, with each sub-context kept identifiable below.

---

## System Overview

The platform fabric provides four capabilities that every other domain leans on:

- **Search indexing (C10)** — entity → external index synchronisation, one of the few genuinely async
  paths, plus a daily full re-push of the organisation index; the core sync flow is now mined (FLW0032) — Confirmed; residual Partial on drain scheduling only
  ([ARCH0001](../ARCH0001_ApplicationOverview.md) §4, §7; FN0022, HS16).
- **Workflow engine & scheduled publish (C11)** — holds the ~66-state workflow config and the
  transition/readiness gate that publish/uncompletion pass through, plus the scheduled-publish tick.
  **Critically, transition legality is largely not enforced on the live change forms today** (ARCH0001
  §8; FN0025, HS02) — this gate is more a target-shape reconstruction than confirmed current behaviour.
- **Reference / geographic data (C11)** — the CZ geo hierarchy and shared reference value-lists used
  for address capture and validation; owns no domain aggregate (FN0026).
- **Operational alerting & audit (C11)** — best-effort error/health alerting to Slack/Telegram and a
  request/response audit store; owns no domain entity and carries the Application↔Campaign desync alert
  (alert-only, not repaired) (FN0023, HS16).

---

## Structural Components

- **SearchIndex-Processor + Elasticsearch adapter** (Async processor + Integration adapter, C10) —
  capability: [FN0022](../FN/FN0022_SearchIndexing.md).
- **Workflow-Engine + ScheduledPublish-Processor** (Orchestrator + Async processor, C11) — capability:
  [FN0025](../FN/FN0025_WorkflowEngineScheduledPublish.md) (shared with C1's status governance).
- **Reference-Data** (Domain service, C11) — capability:
  [FN0026](../FN/FN0026_ReferenceDataLookup.md).
- **Ops-Logging-Adapters + audit store** (Integration adapters, C11) — capability:
  [FN0023](../FN/FN0023_OperationalAlertingAudit.md).
- **No resident aggregate** in either context — C10 indexes AG1/AG2/AG3/AG8 as a side-effect; C11 holds
  only reference/config entities (ApplicationReaction/ApplicationAction are navigated from C1; geo/zip
  reference data owns no aggregate).

---

## Interaction Model

Per [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(b)/(c):

- **Search (C10):** case/campaign/transaction/party saves in C1/C3/C4/C7 enqueue an index update that
  a worker drains out to Elasticsearch — genuinely async ([UC0018](../UC/UC0018_IndexEntitiesForSearch.md);
  [ES0014](../ES/ES0014_Elasticsearch.md); ARCH0002 §(b)).
- **Workflow / scheduled publish (C11):** the scheduled-publish cron transitions C1/C3 entities to
  published ([UC0022](../UC/UC0022_RunPlatformWorkflowEngine.md); ARCH0002 §(b)); the legality/readiness
  gate is exercised by C3 publish/uncompletion and C1 status changes.
- **Reference data (C11):** consulted synchronously for address capture during C1 submit and
  incidentally during publish/validation (FN0026).
- **Ops alerting (C11):** any domain's error/severity event is forwarded best-effort to Slack/Telegram,
  and requests are written to the audit store ([UC0020](../UC/UC0020_EmitOpsAlertsAudit.md);
  [ES0015](../ES/ES0015_Slack.md), [ES0016](../ES/ES0016_Telegram.md),
  [ES0014](../ES/ES0014_Elasticsearch.md); ARCH0002 §(c)).

---

## Cross-links

- **relatedEN:** (none resident — C10/C11 own no aggregate; reference/config entities EN0026/EN0027 are
  navigated from C1, geo/zip reference data owns no promoted EN)
- **relatedUC:** UC0018 (Partial), UC0020 (Partial), UC0022 (Partial)
- **relatedFN:** FN0022, FN0023, FN0025, FN0026
- **relatedES:** ES0014 (Elasticsearch — index + audit + org index), ES0015 (Slack), ES0016 (Telegram)
- **relatedMSG:** (none — ops alerting is explicitly **not** user-facing transactional messaging, MSG-message-map)
- **relatedBR:** BR-SearchIndexingConsistency
  ([../BR/BR-SearchIndexingConsistency.md](../BR/BR-SearchIndexingConsistency.md)),
  BR-OperationalAlerting ([../BR/BR-OperationalAlerting.md](../BR/BR-OperationalAlerting.md)),
  BR-ApplicationStatusGovernance ([../BR/BR-ApplicationStatusGovernance.md](../BR/BR-ApplicationStatusGovernance.md))
  (shared transition-legality concern, owned by C1)

> **Coverage note.** This is the merged home for the two thinnest contexts; several of its flows
> (FLW0032 search-sync, FLW0033 scheduled publish, FLW0034 ops listener; was FL055/FL057/FL059) are
> now mined; mining confirmed them but surfaced residual current-state gaps (drain scheduling,
> transition-legality, ES audit) (Partial residuals, HS16). A rewrite must resolve these before
> treating the platform fabric's behaviour as complete (ARCH0001 §8 Risk 5).
