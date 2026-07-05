---
doc_id: JOB0015
title: Campaign Recommendation Train and Score Consumers
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: async-consumer
references:
  - FN0024
  - EN0008
  - EN0009
---

# JOB0015 – Campaign Recommendation Train and Score Consumers

## Purpose

Retrain and re-score the per-user campaign-recommendation model when a user makes a paid donation.
Two chained queue workers: a training consumer that trains the user's model then enqueues a scoring
item, and a scoring consumer that builds per-campaign scores for the user. Realises FN0024 (Campaign
Recommendation).

Classification: **Dormant** — this is a would-fire contract, not live current-state behaviour (see
Trigger Model).

## Trigger Model

- Asynchronous consumers: training queue (`id="campaign_training_queue"`) and scoring queue
  (`id="campaign_scoring_queue"`). A transaction-update subscriber enqueues a training item when a
  Transaction becomes PAID; the training worker chains a scoring item.
- **Dormant on multiple independent grounds (Confirmed):** the triggering transaction-update event
  dispatch is commented out; the recommendation module cron drain is commented out; the module /
  classifier config is not active; and the recommendation storage field does not exist. Neither queue
  is driven or consumed in current state.
- Evidence: `campaign_recommendation/src/EventSubscriber/CampaignRecommendationSubscriber.php`
  (enqueue on PAID); `campaign_recommendation/src/Plugin/QueueWorker/CampaignTrainingQueue.php`,
  `CampaignScoringQueue.php`; commented-out `campaign_recommendation_cron`. Dossier: FLW0030; FN0024.

## Input Scope

- Training item: a user id. Scoring item: a user id. See EN0008, EN0009.

## Processing Rules

- Training consumer: load the user, train the model, save, then enqueue a scoring item for the same
  user.
- Scoring consumer: load the user, build predicted scores across the candidate campaign set, save.

## Side Effects

- User model/score storage writes (were the path live). No external network integration — the
  classification is in-process. Chained enqueue from training → scoring.

## Idempotency

- Re-training/re-scoring a user overwrites the prior model/scores (idempotent per user). Delivery is
  at-least-once via the standard claim/delete loop (were a drain wired).

## Failure Handling

- No drain loop is wired today, so runtime failure semantics are not exercised. If revived, an
  object-injection deserialization risk and absent tenant scoping apply (FN0024).

## References

- FN: FN0024
- UC: UC0021
- EN: EN0008, EN0009, EN0007, EN0004
- Evidence: FLW0030; recommendation queue workers + subscriber

## Open Items

- **Status: Dormant / would-fire contract only.** Documented for completeness and for rebuild
  planning; not part of confirmed current-state behaviour. See also the manual CLI equivalents in
  JOB0022's family (train:all / campaign:scoring), which are the only way the model is exercised today.
