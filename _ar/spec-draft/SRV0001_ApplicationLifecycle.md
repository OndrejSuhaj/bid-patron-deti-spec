# SRV0001 — Application Lifecycle

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C1 — Application & Lead Management (Žádost)

## SRV Category
Domain Service

## Responsibility Type
Core Domain

## Purpose
Owns the `application` (Žádost) aggregate root — the platform's central domain object linking lead, applicant/fundraiser, patron, child contact, story (campaign), scoring outcome, and contracts. It holds the canonical application state and the lifecycle behaviour that mutates it (create, assign, score-decision, patron assignment/removal, campaign sync). This is the domain hub the rest of C1 (profiles, sessions, actions, logs, reactions) revolves around.

## Current Implementation Shape
- **Aggregate root:** `ApplicationEntity` (1510 LOC) — revisionable + translatable content entity, base_table `application`, ~20 entity_reference relations. `Evidence:` `PSRC/web/modules/custom/application/src/Entity/ApplicationEntity.php`; [db-models.md `application`](../evidence/db-models.md).
- **Application profile:** `ApplicationProfileEntity` (aprofile, 2390 LOC, ~100 base fields) — richest entity: applicant/household/child/patron/gift/story clusters. `Evidence:` `PSRC/web/modules/custom/application/src/Entity/ApplicationProfileEntity.php`.
- **Supporting entities:** `application_session` (multi-step form state), `application_states` raw-SQL status-history side table. `Evidence:` `PSRC/web/modules/custom/application/src/Entity/ApplicationSessionEntity.php`; `application/application.install`.
- **Triggers:** HTTP routes `/application/*`, `/application/start/{role}`, `/admin/application/*` (~23+ routes, ~18 controllers, ~33 forms); service id `application` + access checks `access_check.application.role|status`. `Evidence:` [entrypoints.md §2,§3,§5,§7](../repo-map/entrypoints.md); `PSRC/web/modules/custom/application/application.routing.yml`, `application.services.yml`.
- **Lifecycle hooks:** `postSave` dispatches the status-update event and performs campaign status/category sync; `setState()` keeps `state` in sync with `moderation_state`. `Evidence:` `ApplicationEntity.php:202` (`dispatchStatusUpdateEvent()`), `:229`.

## Structural Issues
- **God Entity** — 1510 LOC root + 2390 LOC profile mix persistence, validation, orchestration, and cross-aggregate sync in one class. `Evidence:` [SRV-candidates.md §5](SRV-candidates.md).
- **Hidden domain logic in lifecycle hooks** — campaign sync + cache flush + event dispatch happen inside `postSave`, invisible to callers.
- **Orchestration bleed** — the aggregate itself dispatches `ApplicationStatusUpdateEvent` (belongs to SRV0002, split needed).
- **No referential integrity** — all ~20 links are Drupal soft `entity_reference`; no DB FK. `Evidence:` [data-model-signals.md §3](../repo-map/data-model-signals.md).

## Target Shape (for rewrite)
Application as a pure aggregate exposing explicit commands (create/assign/decide/assignPatron/removePatron). Move all fan-out (event dispatch, campaign sync) into SRV0002 orchestrator, invoked by an application service — not by `postSave`. Introduce a value-object-backed profile instead of a 100-field flat entity. Enforce references via a persistence port.

## Integration Dependencies
None (internal domain). Downstream side-effects (messaging, scoring, documents) are reached via SRV0002.

## Boundaries
Does NOT own status fan-out/orchestration → SRV0002. Does NOT own scoring decisions → SRV0003. Does NOT own the contact/party records it references → SRV0012. Does NOT own campaign/story state → SRV0005. Does NOT own form-access gating → SRV0015.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Is `moderation_state` the source of truth or is `state`? Both exist; `state` has no backing published-status field. `Missing evidence: reconcile ApplicationEntity baseFieldDefinitions vs content_moderation workflow config.`
- Is `application` a Lead early-lifecycle and Application later, or two concepts in one table? `Missing evidence: lead-vs-application boundary trace in status model.`
- Exact route→command mapping for the ~23 application routes. `Missing evidence: FlowInspector route-to-service attribution.`
