# UC0021 — Recommend Campaigns (DORMANT)

## Header

| Field | Value |
|---|---|
| UC ID | UC0021 |
| Name | Recommend Campaigns (DORMANT) |
| Bounded Context | C3 |
| Primary Actor(s) | System |
| Trigger Type | Event (disabled) |

## Actors & Responsibilities

- **System** — would detect a paid Transaction (EN0009), would train a per-User predictive model, and would rank Campaigns (EN0004) for that User; today performs none of this because the feature is dormant.
- **Scheduler** — would periodically re-trigger scoring/training in the background; the periodic driver is disabled, so this actor never actually runs this use case.

## Intent

(Would-be intent, not live today.) Automatically learn each User's (EN0008) giving pattern from their paid Transactions (EN0009) and recommend a personalized, ranked list of Campaigns (EN0004) they are likely to support, stored against their Account (EN0007), to increase future donation conversion.

## Preconditions

- **Dormant precondition (blocking, current state):** the recommendation capability is disabled end-to-end — the responsible module is not installed, the scoring/classification service is not configured, the supporting machine-learning library is absent, the campaign feature-set lookup is disabled, and the storage field for results does not exist. None of the preconditions below can currently be satisfied because the use case cannot start.
- (Would-be, if reactivated) A Transaction (EN0009) reaches status PAID and has an identifiable owning User (EN0008).
- (Would-be, if reactivated) The User (EN0008) has an associated Account (EN0007) capable of storing a trained model and ranked recommendations.

## Main Flow

> **Evidence status: Hypothesis / dormant.** The steps below describe the contract that WOULD execute if every disabled piece were reactivated. As of the current source, this flow does not run: the triggering event is never dispatched, the responsible module is not enabled, and required storage does not exist. No step in this section reflects live current-state behavior.

### UC0021.1 — Trigger and training (would-fire, currently dormant)
1. System: a Transaction (EN0009) is saved and would normally raise a "transaction updated" notification — this notification is currently never actually raised (dead code path).
2. System: if the notification were raised and the Transaction's (EN0009) status is PAID with an identifiable owning User (EN0008), the System would queue a training task for that User.
3. System: the training task would load the User (EN0008) and count their PAID Transactions (EN0009) to size the training sample.
4. System: the training task would assemble a set of positive examples (campaigns the User actually supported) and a larger set of negative examples (campaigns they did not), drawn from the User's (EN0008) history, Application, and Campaign (EN0004) data.
5. System: the training task would submit these examples to a classification service to produce a predictive model.
6. System: the training task would store the trained model on the User's (EN0008) record and then would queue a scoring task for the same User.

### UC0021.2 — Scoring and recommendation storage (would-fire, currently dormant)
1. System: the scoring task would load the User (EN0008) and retrieve the set of candidate Campaigns (EN0004) eligible for recommendation — this candidate lookup currently always returns nothing, because the underlying logic is disabled.
2. System: the scoring task would apply the User's (EN0008) trained model to the candidate Campaigns (EN0004) to predict a preference score for each.
3. System: the scoring task would sort the scored Campaigns (EN0004) by predicted preference, highest first.
4. System: the scoring task would rewrite the User's (EN0008) or Account's (EN0007) ranked-recommendation record with the sorted Campaign (EN0004) list and their scores — this write currently has no place to persist to, because the storage field for recommendations does not exist.

## Alternative Flows

### AF1 — Manual/administrative re-trigger (would-fire, currently dormant)
1. Admin: would invoke an administrative command to retrain the model for all Users (EN0008) at once, bypassing the per-Transaction trigger.
2. Admin: would invoke a separate administrative command to re-score all Users (EN0008) against current Campaigns (EN0004).

Outcome: (would-be) same end-state as UC0021.1/.2, triggered on demand instead of per-Transaction; currently unavailable for the same reasons as the main flow — the module that would expose these commands is not installed.

### AF2 — Scheduled re-scoring (would-fire, currently dormant)
1. Scheduler: would periodically re-run scoring for all Users (EN0008) so recommendations stay current as new Campaigns (EN0004) appear.

Outcome: (would-be) periodically refreshed recommendations; currently never runs — the scheduled driver for this is disabled.

## Postconditions

- **Current state (actual):** no state changes occur anywhere in this use case. No model is trained, no recommendation is stored, no queue item is created.
- (Would-be, if reactivated) The User's (EN0008) record would hold a serialized trained model.
- (Would-be, if reactivated) The User's (EN0008) or Account's (EN0007) record would hold a ranked list of recommended Campaigns (EN0004) with associated preference scores.

## Traceability

Target SRVs:
- CampaignRecommendation-Processor (Transitional)

EN entities:
- EN0009 Transaction — the would-be trigger (PAID status change)
- EN0008 User — the subject of training and the (would-be) holder of the trained model
- EN0007 Account — the (would-be) holder of the stored ranked-recommendation list
- EN0004 Campaign — the entity being ranked/recommended

Integration boundaries:
- None (no external system involved even if reactivated — the classification step is in-process, not a network integration).

Flow Evidence:
- FLW0030 (dormant — Confirmed dormancy on multiple independent grounds; behavior described here is the would-fire contract only)

## Evidence Level

Hypothesis — dormancy of the trigger, module, service, library, and storage is Confirmed per FLW0030 and SRV0006/CampaignRecommendation-Processor (marked Transitional/dead cron in SRV-target-list.md); the step-by-step behavior described is a reconstructed "would-fire" contract only, grounded in EN0009/EN0008/EN0007/EN0004, and is not observable current-state behavior.
