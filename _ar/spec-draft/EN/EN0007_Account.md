---
doc_id: EN0007
title: Account
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004 (Campaign)
  - EN0008 (User)
  - BR-CampaignRecommendationDormant
---

# EN0007 — Account

## Purpose

The Account is an owner-scoped patron/fundraiser record, distinguished by `type` (patron /
fundraiser). It is the intended holder of a trained recommendation model and a ranked list of
predicted Campaigns (EN0004) for its owning User (EN0008), as part of a campaign-recommendation
capability. That capability is confirmed dormant in the current state — see
`BR-CampaignRecommendationDormant`. With the recommendation capability inert, Account functions
today as a thin owner-scoped record carrying little independent behavior.

Account is distinct from a bank account and from the User/Party identity itself (see
`DOMAIN-ubiquitous-language.md` §Account for the three-way terminology conflict).

---

## Lifecycle

- **Existing** — the only observed state. Account carries no status/workflow enum of its own; it is
  either present (owned by a User) or absent.

Hypothesis — Not evidenced in current sources: whether Account is created for every User, only for
certain roles, or effectively never in current operation. No confirmed use case exercises Account
creation (see State Transitions and Open Questions).

---

## State Transitions

No confirmed creation or update trigger exists in the current state.

- UC0014 (Authenticate & Manage Access) references Account for completeness as the owner-scoped
  record associated with a User, but does not itself create, update, or otherwise exercise it.
- UC0021 (Recommend Campaigns) describes the only flow that would write to Account (storing a
  trained model / ranked recommendations), but UC0021 is dormant end-to-end — see
  `BR-CampaignRecommendationDormant`. No current-state transition results from it.

Hypothesis — Not evidenced in current sources: the actual creation trigger for an Account record.

---

## Attributes

### System-managed attributes

- status (boolean; required; publish flag; default true)

### User-provided attributes

- type (list of values; optional; `patron` / `fundraiser`)
- name / last_name (text, max 50 characters; optional; used as the entity's display label; default
  empty)

---

## Invariants

- Account-to-Campaign recommendation coupling is not an active current-state invariant — see
  `BR-CampaignRecommendationDormant`.

---

## Relationships

- EN0008 (User) — owning Party; an Account belongs to one User.
- EN0004 (Campaign) — candidate recommendation target; the association is part of the dormant
  recommendation capability (see `BR-CampaignRecommendationDormant`) and does not reflect an active
  current-state relationship.

---

## Open Questions

- Is an Account record actually created anywhere in current operation, or is it fully dormant along
  with the recommendation capability it was built to support?
- What is the intended relationship between the recommendation-model data associated with Account
  and the equivalent data associated with User (EN0008) — are these two representations of the same
  concept, and if so, which is authoritative?
- Under what conditions, if any, has the recommendation capability been active in production?
