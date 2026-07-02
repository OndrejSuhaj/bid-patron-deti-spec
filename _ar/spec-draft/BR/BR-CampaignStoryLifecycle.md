---
doc_id: BR-CampaignStoryLifecycle
title: Campaign / Story Lifecycle & Funding
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0004
  - EN0001
  - EN0005
  - EN0009
  - SYSTEM
references:
  - EN0004
  - EN0001
  - EN0005
  - EN0009
  - UC0011
---

# BR – Campaign / Story Lifecycle & Funding

## Purpose

Governs the public fundraising story (Campaign / Story, `EN0004`): its derived raised total, the
publish-readiness gate, auto-completion when funded, deadline-driven uncompletion, and the Romania
working-day deadline rule.

---

## Derived raised total

- A Campaign's running raised total SHALL be a derived value equal to the sum of the amounts of its
  *paid* donations, recomputed whenever the Campaign is recomputed.
- Pending, cancelled, and refunded donation amounts SHALL NOT contribute to a Campaign's raised total.
- A Campaign's percent-of-target progress SHALL be derived from its raised total against the target
  amount and SHALL NOT be maintained as a free-standing figure.

---

## Publish-readiness gate

- A Campaign SHALL be publishable only when all of the following hold: it has a linked case (`EN0001`),
  it carries a public patron profile (`EN0005`), its target amount is greater than zero, its deadline is
  in the future, and its required images are present.
- A Campaign SHALL hold at most one public patron profile (`EN0005`).
- On a successful publish, the Campaign and its linked case SHALL transition to their active states
  together.
- Current-state: publish SHALL NOT be assumed transaction-wrapped — a partial failure between the
  Campaign-side and case-side transitions can leave the Campaign and its linked case inconsistent
  (current-state gap; not enforced atomically).

---

## Completion and uncompletion

- A Campaign SHALL auto-complete when it is active and its running raised total meets or exceeds its
  target amount at recompute time.
- Completion of a Campaign SHALL cascade its linked case to a complete state.
- A Campaign SHALL uncomplete once its deadline has passed while it is still active with a raised total
  below its target amount.
- Uncompletion of a Campaign SHALL drive its linked case to the uncompleted status.
- Current-state: completion is evaluated on the money-driven recompute (triggered by a donation being
  recorded), not on a fixed schedule; deadline-driven uncompletion is the scheduled arm of this rule.

---

## Deadline working-day rule

- A Romania-market Campaign deadline SHALL fall on a working day.
- Current-state: the working-day check is fail-open — when the public-holiday calendar cannot be
  reached, the deadline date is treated as a working day and the rule is bypassed (not enforced under
  that failure condition).

---

## Non-Goals

This document does not govern:

- the rejection of donations against an already-funded Campaign (owned by `BR-PaymentAndMoneyIntegrity`);
- Application–Campaign status consistency as a case-side concern (owned by
  `BR-ApplicationStatusGovernance`);
- the content or dispatch of Campaign success/uncompleted notifications (owned by
  `BR-TransactionalMessaging`);
- profile-cardinality rules on the linked case's own aggregate (owned by
  `BR-ApplicationStatusGovernance`) — this document states only the ≤1 public-patron-profile cardinality
  on the Campaign itself.
