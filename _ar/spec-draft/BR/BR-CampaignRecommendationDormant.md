---
doc_id: BR-CampaignRecommendationDormant
title: Campaign Recommendation (Dormant)
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0007
  - EN0008
  - EN0004
  - EN0009
  - SYSTEM
references:
  - EN0007
  - EN0008
  - EN0004
  - EN0009
  - UC0021
---

# BR – Campaign Recommendation (Dormant)

## Purpose

Records that the campaign-recommendation subsystem is inert in the current state so downstream
layers do not treat it as live behaviour.

## Dormancy

- Current-state: the campaign-recommendation subsystem SHALL be treated as dormant and SHALL NOT
  be relied upon as live current-state behaviour.
- Current-state: no active path derives, stores, or serves per-User campaign recommendations, and
  any Account-to-Campaign recommendation coupling SHALL NOT be treated as an active invariant.
- A description of recommendation behaviour SHALL be read as a would-fire contract only (see
  UC0021), not as observable current-state behaviour.

## Non-Goals

This rule does not define, constrain, or approve a future recommendation algorithm, scoring
method, or reactivation path — it only establishes the current-state dormancy status.
