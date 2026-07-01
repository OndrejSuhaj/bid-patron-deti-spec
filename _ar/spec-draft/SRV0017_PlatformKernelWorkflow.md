# SRV0017 — Platform Kernel & Workflow Engine

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C11 — Platform / Integration Fabric

## SRV Category
Infrastructure / Security

## Responsibility Type
Infrastructure

## Purpose
The platform kernel: the application-workflow engine (state machine over ~66 states / ~40 transitions), token/placeholder rendering, scheduled-publish cron, and shared reference data (ZIP/geo). It provides the cross-cutting platform services that other contexts build on, rather than any single business capability.

## Current Implementation Shape
- **Workflow engine:** `workflow.application` service + `application_workflow` (content_moderation) config — ~66 states / ~40 transitions, the canonical status enum bound to `application`. `Evidence:` `PSRC/web/modules/custom/patron_base/patron_base.services.yml`; `PSRC/config/workflows.workflow.application_workflow.yml`; [data-model-signals.md §5](../repo-map/data-model-signals.md).
- **Action service:** `patron.action` service (action execution). `Evidence:` [entrypoints.md §5](../repo-map/entrypoints.md). Note: service-id presence is listed but not independently re-verified — see Open Questions.
- **Tokens:** `patron_base.token` service (placeholder/token rendering). `Evidence:` `PSRC/web/modules/custom/patron_base/patron_base.services.yml`.
- **Scheduled publish:** `patron_base.scheduled_publish_cron` service + `hook_cron`. `Evidence:` [entrypoints.md §5,§8](../repo-map/entrypoints.md).
- **Status-group presets:** `application_statuses` config entity (24 instances — all_leads/funnel_step_*/…). `Evidence:` `PSRC/web/modules/custom/patron_base/src/Entity/ApplicationStatusesEntity.php`; [db-models.md `application_statuses`](../evidence/db-models.md).
- **Reference data:** `zip` module geo entities (`kraj`/`obec`/`okres`/`psc`). `Evidence:` `PSRC/web/modules/custom/zip/src/Entity/`; [db-models.md](../evidence/db-models.md) (folded here per [SRV-candidates.md §4](SRV-candidates.md)).

## Structural Issues
- **Kernel as catch-all** — `patron_base` bundles workflow, tokens, mailing, scheduled publish, and migrations, making the platform kernel a wide surface. `Evidence:` [modules.md §2](../repo-map/modules.md).
- **Workflow lives in config + code split** — the ~66-state machine is content_moderation config, but state transitions also happen via `setState()`/`moderation_state` sync in the entity. `Evidence:` [db-models.md `application`](../evidence/db-models.md).
- **`patron.action` provenance uncertain** — whether it is a real DI service or pseudo-service is unconfirmed. `Evidence:` [SRV-candidates.md §7 Tier 1](SRV-candidates.md).
- **Reference-data entities are passive** — geo entities carry no behaviour; folded here only as a reference-data provider. `Evidence:` [SRV-candidates.md §4 Rejected](SRV-candidates.md).

## Target Shape (for rewrite)
Split the kernel: a Workflow engine service (single source of truth for the state machine), a Tokens/templating utility, a scheduler, and a Reference-data service. Business modules depend on these via narrow interfaces rather than on a monolithic `patron_base`.

## Integration Dependencies
None (internal platform services).

## Boundaries
Does NOT own application state itself → SRV0001 (kernel provides the machine; the aggregate holds the value). Does NOT send mail (kernel hosts the mailing service class, but the messaging boundary is) → SRV0013. Does NOT own auth/access → SRV0015. Does NOT own ops alerting → SRV0018.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Is `patron.action` a real `services.yml` id or a pseudo-service? `Missing evidence: patron_base.services.yml patron.action entry.`
- Full ~66-state / ~40-transition workflow definition vs. intake/statuses. `Missing evidence: workflows.workflow.application_workflow.yml expansion.`
- How `scheduled_publish_cron` interacts with campaign/blog publish. `Missing evidence: scheduled_publish consumer trace.`
