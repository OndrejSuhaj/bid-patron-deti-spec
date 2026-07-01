# SRV0006 — Campaign Recommendation

Status: Transitional
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C3 — Campaign & Story (Příběh)

## SRV Category
Background Processing

## Responsibility Type
Orchestrator

## Purpose
Intended to recommend campaigns (stories) to donors via a per-account ML model — training a classifier per user and scoring candidate campaigns. In the current source the workers exist but the scheduled trigger that would populate the queues is disabled, so the capability is present in code but not driven in practice.

## Current Implementation Shape
- **Queue workers:** `CampaignTrainingQueue` (`id = campaign_training_queue`, calls `$account->trainModel()` then enqueues scoring) and `CampaignScoringQueue` (`id = campaign_scoring_queue`). `Evidence:` `PSRC/web/modules/custom/campaign_recommendation/src/Plugin/QueueWorker/{CampaignTrainingQueue,CampaignScoringQueue}.php`; [entrypoints.md §8](../repo-map/entrypoints.md).
- **Model storage:** `account.model` (serialized `Phpml\Classification\Classifier`) + `account.campaign_recommendation` weighted campaign refs (conditional field). `Evidence:` [db-models.md `account`](../evidence/db-models.md).
- **Subscriber:** `CampaignRecommendationSubscriber`. `Evidence:` [entrypoints.md §6](../repo-map/entrypoints.md); `PSRC/web/modules/custom/campaign_recommendation/src/EventSubscriber/`.
- **Trigger (DISABLED):** `campaign_recommendation_cron()` — the entire `hook_cron` that would enqueue all accounts for scoring/training is commented out. `Evidence:` `PSRC/web/modules/custom/campaign_recommendation/campaign_recommendation.module:7-26` (whole function commented; 23/26 lines are comment/dead).

## Structural Issues
- **Weak/absent trigger → Transitional** — worker Input/Output paths exist, but the scheduled Trigger that feeds them is commented out; nothing populates the queues on a schedule. `Evidence:` `campaign_recommendation.module:7-26`.
- **Dead-code smell** — the module ships live workers whose only production enqueue path is disabled. `Evidence:` [SRV-candidates.md §5 Disabled/dead paths](SRV-candidates.md).
- **ML model persisted in a relational text field** — `account.model` holds a serialized PHP classifier, coupling model lifecycle to entity save. `Evidence:` [db-models.md `account`](../evidence/db-models.md).
- **Drush command present** — a `campaign_recommendation` command exists as an alternate manual trigger. `Evidence:` [entrypoints.md §8 Drush](../repo-map/entrypoints.md).

## Target Shape (for rewrite)
If retained: a separate recommendation service with an explicit scheduled trigger, model artifacts stored outside the domain entity, and a clean read-model of recommendations consumed by the storefront. If not retained: retire the module. Decision needed before rebuild.

## Integration Dependencies
None (internal; PHP-ML in-process). No external endpoint.

## Boundaries
Does NOT own campaign/story lifecycle → SRV0005. Does NOT own the account/party record it writes the model onto → SRV0012/SRV0015. Does NOT drive donations → SRV0007.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Is any recommendation live (Drush-invoked) despite the disabled cron? `Missing evidence: production invocation trace of the Drush command.`
- How much of `account->trainModel()` / storefront rendering of recommendations is wired? `Missing evidence: commented-block audit + storefront consumer.`
- Should recommendation survive the rebuild at all? `Missing evidence: client intent vs it-zadani target scope.`
