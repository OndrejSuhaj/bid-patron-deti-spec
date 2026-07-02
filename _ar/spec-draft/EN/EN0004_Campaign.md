---
doc_id: EN0004
title: Campaign
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001
  - EN0005
  - EN0009
  - EN0021
  - EN0028
  - BR-CampaignStoryLifecycle
  - BR-PaymentAndMoneyIntegrity
  - BR-CampaignRecommendationDormant
  - UC0002
  - UC0011
---

# EN0004 — Campaign

## Purpose

The Campaign (Story / Příběh) is the public-facing fundraising story generated from an approved
Application (EN0001). It represents the fundraiser's case to the public: a target amount, a running
raised total, a deadline, and a public Patron profile (EN0005), progressing through a fundraising
lifecycle from readiness to publication to a funded or expired outcome. A Campaign can self-reference
a parent Campaign to express promo/group campaign groupings (group/collection-account variant not
fully evidenced — `Partial`).

---

## Lifecycle

- in-progress
- active
- completed
- campaign_uncompleted
- suspended
- canceled
- completed_partly

Runtime value `campaign_uncompleted_inprocess` has also been observed but is not part of the declared
status vocabulary — `Uncertain`, origin unconfirmed.

---

## State Transitions

in-progress → active
trigger: UC0011 (UC0011.1 — Admin publishes / sets a Campaign active)

active → completed
trigger: UC0011 (UC0011.1 step 7 — funding completion evaluated on Campaign save); see BR-CampaignStoryLifecycle (completion rule)

active → campaign_uncompleted
trigger: UC0011 (UC0011.2 — scheduled lifecycle check on deadline expiry); see BR-CampaignStoryLifecycle (uncompletion rule)

(status kept consistent with owning Application)
trigger: UC0002 (UC0002.2 step 10 — Application status change synchronizes the linked Campaign's status/category)

active → suspended — Hypothesis, no confirmed trigger evidenced.
active → canceled — Hypothesis, no confirmed trigger evidenced.
active → completed_partly — Hypothesis, no confirmed trigger evidenced.

---

## Attributes

### System-managed attributes

- campaign_raised (integer; system-managed; derived running total — see BR-CampaignStoryLifecycle)
- campaign_percentual_raised (decimal; system-managed; derived progress against target amount — see BR-CampaignStoryLifecycle)
- campaign_status (list; system-managed; allowed values: in-progress, active, suspended, completed, uncompleted, campaign_uncompleted, completed_partly, canceled)
- published / completed / uncompleted / canceled (timestamp; system-managed; lifecycle milestone dates)
- slug (string; system-managed; auto-generated public identifier; prior identifiers are archived when the public name changes)
- name / name_covid19 (string; system-managed; entity label)

### User-provided attributes

- gift_price (integer; required; target amount; minimum value applies)
- campaign_deadline (datetime; required; must be a future date; Romania-market deadlines are additionally constrained to a working day — see BR-CampaignStoryLifecycle)
- type (list; required; values: basic, promo, long_term, short_term; default basic)
- button_text (string; required)
- patron_profile (reference to EN0005 — Patron; optional; public patron profile shown on the Campaign)
- gift_category (reference to taxonomy category; optional; purpose of the case)
- single_parent, hide_campaign_raised (boolean; optional; display/behavior flags)
- is_*_email_sent (boolean; system-managed; notification-sent markers)
- required imagery (optional/conditional per role; precondition for publication — see BR-CampaignStoryLifecycle)

---

## Invariants

- Derived raised total and percent-of-target progress — see BR-CampaignStoryLifecycle.
- Publish-readiness gate (linked case, public Patron profile, positive target amount, future deadline, required images) — see BR-CampaignStoryLifecycle.
- At most one public Patron profile (EN0005) per Campaign — see BR-CampaignStoryLifecycle.
- Auto-completion and deadline-driven uncompletion, and their cascade to the linked Application — see BR-CampaignStoryLifecycle.
- Romania-market deadline working-day rule — see BR-CampaignStoryLifecycle.
- Donation admissibility against a funded Campaign — see BR-PaymentAndMoneyIntegrity (money admissibility).
- Overpayment handling for this Campaign — see BR-PaymentAndMoneyIntegrity (overpayment split).
- Any Campaign-recommendation coupling is dormant and not an active current-state invariant — see BR-CampaignRecommendationDormant.

Conflict — Application status and Campaign status are intended to stay mutually consistent, but the
publish transition (Campaign-side and Application-side) is not evidenced as atomic; a partial failure
between the two saves can leave them inconsistent, and a detected desync is only logged, not repaired
(current-state gap; see BR-CampaignStoryLifecycle).

---

## Relationships

- EN0001 — Application (linked case; 1:1; status kept in lock-step)
- EN0005 — Patron (public patron profile; at most one per Campaign)
- EN0004 — Campaign (self-reference; parent, for promo/group campaigns)
- EN0021 — Feedback (post-campaign fundraiser thank-you)
- EN0028 — CampaignLog (per-Campaign audit trail; writer not evidenced — `Hypothesis`)
- EN0009 — Transaction (paid Transactions determine the Campaign's derived raised total)

---

## Open Questions

- What triggers the `suspended`, `canceled`, and `completed_partly` states?
- How is the undeclared `campaign_uncompleted_inprocess` value reached and cleared?
- What is the completion semantics of a parent (promo/group) Campaign relative to its child campaigns?
