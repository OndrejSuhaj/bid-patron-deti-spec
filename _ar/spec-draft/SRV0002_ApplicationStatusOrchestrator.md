# SRV0002 — Application Status Orchestrator

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C1 — Application & Lead Management (Žádost)

## SRV Category
Domain Service

## Responsibility Type
Orchestrator

## Purpose
Coordinates all side-effects of an application status change. When an application's status/state changes, this seam fans out to messaging, scoring re-evaluation, and user-facing reaction configuration. It is the platform's primary orchestration point — currently physically embedded in the application aggregate rather than being a standalone service.

## Current Implementation Shape
- **Event contract:** `ApplicationStatusUpdateEvent` (`STATUS_UPDATE_EVENT`) carrying the `ApplicationEntity`. `Evidence:` `PSRC/web/modules/custom/application/src/Event/ApplicationStatusUpdateEvent.php`.
- **Dispatch site:** `ApplicationEntity::dispatchStatusUpdateEvent()` invoked from `postSave`. `Evidence:` `ApplicationEntity.php:202` and `:228-230` (`event_dispatcher->dispatch(...)`).
- **Subscribers (synchronous fan-out, 3):** `ApplicationStatusUpdateSubscriber` in `notification`, `scoring`, and `application_reaction`. `Evidence:` [entrypoints.md §6](../repo-map/entrypoints.md); `PSRC/web/modules/custom/{notification,scoring,application_reaction}/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php`.
- **Reaction config data:** `application_reaction` entity (revisionable) drives zone messages / e-mail notification / action buttons per status+role. `Evidence:` [db-models.md `application_reaction`](../evidence/db-models.md).
- **Scheduled transitions:** `application_action` config entity (initiator cron/patron/fundraiser, `cron_action` e.g. `removePatron`) executed via cron. `Evidence:` `PSRC/web/modules/custom/application_action/src/Entity/ApplicationActionEntity.php`; [db-models.md `application_action`](../evidence/db-models.md).

## Structural Issues
- **Orchestration smell** — a single `postSave` synchronously invokes 3 subscribers across 3 contexts (messaging C8, scoring C2, reactions C1); a mailing failure can block the save path (no queue — see SRV0013). `Evidence:` [SRV-candidates.md §5](SRV-candidates.md).
- **Cross-context reach** — this orchestrator triggers C8 (messaging), C2 (scoring), and downstream C6 (documents) work, so it structurally spans contexts while nominally living in C1.
- **Coupling to aggregate** — orchestration logic is not separable from `ApplicationEntity` today (dispatch is a private method on the entity).
- **Unclear call-graph** — whether `ApplicationReactionService::execute()` runs via listener or manual call is unverified. `Evidence:` [SRV-candidates.md §7 Tier 1](SRV-candidates.md).

## Target Shape (for rewrite)
Extract a standalone orchestrator invoked explicitly by the application service after a state transition commits. Make fan-out asynchronous (queue/outbox) so downstream failures don't block the domain write. Model subscribers as explicit handlers behind stable ports (Messaging, Scoring, Reaction).

## Integration Dependencies
None directly (internal orchestration). Reaches external systems only through SRV0013 (messaging) and SRV0003→SRV0004 (scoring/registry).

## Boundaries
Does NOT own application state itself → SRV0001. Does NOT send mail → SRV0013. Does NOT compute scores → SRV0003. Does NOT render zone content (only supplies reaction config).

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Real subscriber call-graph and ordering of the 3 `ApplicationStatusUpdateSubscriber`s. `Missing evidence: dispatch/consumer trace (FlowMiner).`
- Is `ApplicationReactionService::execute()` listener-driven or called manually? `Missing evidence: reaction execution call-site.`
- Which crons run `application_action` transitions and their environment gating. `Missing evidence: per-cron environment guard trace.`
