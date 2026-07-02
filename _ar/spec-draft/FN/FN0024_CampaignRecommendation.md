---
doc_id: FN0024
title: Campaign Recommendation (Dormant)
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0021
  - EN0004
  - EN0007
  - EN0008
  - EN0009
---

# FN0024 – Campaign Recommendation (Dormant)

## Purpose

The would-be capability to learn each User's giving pattern from their paid Transactions, train a
per-User predictive model, and store a personalized ranked list of recommended Campaigns against the
User/Account. This capability is inert in the current system on multiple independent grounds and
describes a would-fire contract only, not live current-state behavior.

## Responsibilities

- (Would-fire) On a paid Transaction with an identifiable owner, queue a training task that
  assembles positive/negative campaign examples and submits them to an in-process classification
  service to produce a per-User model.
- (Would-fire) Score candidate Campaigns with the trained model, rank by predicted preference, and
  rewrite the User/Account ranked-recommendation record.
- (Would-fire) Support administrative retrain-all / re-score-all commands and a scheduled
  re-scoring driver as alternative entry points to the same training/scoring capability.

## Related Use Cases

UC0021 – Recommend Campaigns (DORMANT)

## Related Entities

EN0009 – Transaction

EN0008 – User

EN0007 – Account

EN0004 – Campaign

## Integrations

None. Model training and scoring is an in-process classification capability, not a network
integration with an external system — consistent with the integration landscape named in
ARCH0002 (Context Interaction Map), which does not list this capability among the platform's
external integrations.

## Constraints

- **Status: Dormant.** The capability is inert end-to-end on five independent grounds: the
  triggering "Transaction updated" notification is never actually raised, the responsible module is
  not installed, the classification service is not configured, the supporting machine-learning
  library is absent, and the storage location for the ranked-recommendation result does not exist.
  Any one of these grounds alone would be sufficient to block the capability.
- The description in this document is a reconstructed would-fire contract only (per UC0021 and its
  underlying flow evidence), not observable current-state behavior.
- If reactivated, the stored trained model would be subject to a deserialization risk on load, and
  the training/scoring logic carries no tenant scoping — a reactivated capability would compute
  recommendations without regard to CZ/RO/MD tenant boundaries.
- This is the canonical slot other layers cite for "campaign recommendation" (FN0024) without
  restating this dormancy status.
