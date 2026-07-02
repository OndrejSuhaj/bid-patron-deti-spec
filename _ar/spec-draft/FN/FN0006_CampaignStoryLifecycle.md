---
doc_id: FN0006
title: Campaign / Story Lifecycle Management
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0011
  - UC0005
  - UC0006
  - EN0004
  - EN0005
  - EN0021
  - EN0028
  - EN0001
  - BR-CampaignStoryLifecycle
  - FN0007
---

# FN0006 – Campaign / Story Lifecycle Management

## Purpose

Manage the public fundraising story (Campaign / Příběh, EN0004) generated from an approved Application through its
funding lifecycle — publish/activate, track raised total against target, auto-complete or uncomplete on the
deadline — and keep it consistent with its owning case. This is the C3 story capability exercised by UC0011.

## Responsibilities

- Generate and publish/activate a Campaign (EN0004) from an approved Application, subject to a publish-readiness
  gate.
- Recompute the running raised total and percentage funded from paid donations (delegating the summation trigger to
  FN0007's money side-effects), then auto-complete and deadline-uncomplete the story per the campaign
  completion/uncompletion rules (BR-CampaignStoryLifecycle).
- Maintain the public patron display profile (Patron, EN0005), post-campaign feedback (Feedback, EN0021), and the
  campaign audit log (CampaignLog, EN0028).
- Keep the story's status/category in lock-step with the owning Application (EN0001), delegating the case side to
  FN0002.

## Related Use Cases

UC0011 (primary); participates in UC0005 / UC0006 as the donation target.

## Related Entities

EN0004 (root), EN0005 / EN0021 / EN0028 (composed members), EN0001 (owning case, coupled).

## Integrations

Nager.Date (public-holiday calendar) — consulted for the RO campaign-deadline working-day rule.

## Constraints

- Publish transitions the Campaign and its Application without transaction wrapping (partial-failure risk).
- Application↔Campaign lock-step is a bidirectional save side-effect; a detected desync is alerted (Slack /
  Telegram) but not repaired.
- The RO working-day deadline check is fail-open: if Nager.Date is unavailable, the date is treated as a working
  day and the rule is silently bypassed.
- CampaignLog writer is unevidenced (Hypothesis); several campaign statuses have no evidenced trigger.
