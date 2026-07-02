---
doc_id: ARCH0005
title: Campaign & Story Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
references:
  - ARCH0001
  - ARCH0002
  - EN0004
  - EN0005
  - EN0021
  - EN0028
  - UC0011
  - UC0021
  - FN0006
  - FN0024
  - ES0012
  - MSG0013
  - MSG0014
  - MSG0015
  - MSG0016
  - MSG0030
  - BR-CampaignStoryLifecycle
  - BR-CampaignRecommendationDormant
---

# ARCH0005 – Campaign & Story Domain

> Domain navigation document for bounded context **C3 Campaign & Story** (ARCH0001 §4).
> Navigation layer only — links deeper artifacts by `doc_id`, does not restate them. Current-state.

## Purpose

Explains the architectural perspective of the **public fundraising story (Příběh)**: how an approved
application is turned into a public campaign that carries a target amount, a running raised total, a
deadline and a fundraising lifecycle — and how it completes, uncompletes, or is cancelled. It also
covers the **dormant** campaign-recommendation subsystem present in the codebase but inert today.

---

## System Overview

C3 owns the campaign lifecycle (in-progress → active → completed / campaign_uncompleted). A campaign
is 1:1 with its owning Application (C1) and kept in status lock-step with it; the raised total is a
derived sum of paid donations that lives in C4 ([EN0004](../EN/EN0004_Campaign.md); ARCH0001 §4). The
context also hosts the public patron display profile, post-campaign feedback, and a campaign audit log.

Two architectural traits stand out: publish transitions both the Campaign and its Application without a
transaction (partial-failure risk), and the RO deadline working-day check is **fail-open** against an
external holiday calendar ([ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)). The
recommendation subsystem is dormant on five independent grounds — a drop-or-rebuild decision, not live
behaviour (ARCH0001 §8 Risk 5).

---

## Structural Components

- **Campaign-&-Story-Lifecycle** (Domain service) — generate/publish/complete/uncomplete the story,
  edit the public patron profile, author feedback. Capability:
  [FN0006](../FN/FN0006_CampaignStoryLifecycle.md).
- **CampaignRecommendation-Processor** (Async processor, **dormant**) — would score/recommend
  campaigns; inert today. Capability: [FN0024](../FN/FN0024_CampaignRecommendation.md).
- **Resident aggregate AG2 Campaign** — root [EN0004](../EN/EN0004_Campaign.md); members Patron
  public profile ([EN0005](../EN/EN0005_Patron.md), ≤1), Feedback
  ([EN0021](../EN/EN0021_Feedback.md)), CampaignLog ([EN0028](../EN/EN0028_CampaignLog.md), audit
  child; writer unevidenced).

---

## Interaction Model

Per [ARCH0002](../ARCH0002_ContextInteractionMap.md):

- Publish transitions the Campaign **and** writes back to **C1** (Application → `active`); completion
  and uncompletion likewise co-transition the Application, all without transaction wrapping
  ([UC0011](../UC/UC0011_ManageCampaignStoryLifecycle.md); ARCH0002 §(a)/(c)).
- Serves as the **donation target** for **C4 Donations & Payments**: the money hub recomputes the
  raised total on the Campaign and auto-completes it when raised ≥ target (ARCH0002 chain A).
- Calls out synchronously to **Nager.Date** for the RO deadline working-day rule — fail-open
  ([ES0012](../ES/ES0012_NagerDate.md); ARCH0002 §(a)).
- Emits story-lifecycle messages via **C8** (published / collection successful / unfulfilled /
  cancelled / donor thank-you) and the desync alert via **C11** ops alerting.
- The **dormant** recommendation path would consume the C4 PAID event and write into C7's Account —
  inert today (ARCH0002 §(c); [UC0021](../UC/UC0021_RecommendCampaigns.md)).

---

## Cross-links

- **relatedEN:** EN0004, EN0005, EN0021, EN0028
- **relatedUC:** UC0011, UC0021 (dormant)
- **relatedFN:** FN0006, FN0024 (dormant)
- **relatedES:** ES0012 (Nager.Date)
- **relatedMSG:** MSG0013, MSG0014, MSG0015, MSG0016, MSG0030 (story-lifecycle & post-campaign; transport owned by C8)
- **relatedBR:** BR-CampaignStoryLifecycle
  ([../BR/BR-CampaignStoryLifecycle.md](../BR/BR-CampaignStoryLifecycle.md)),
  BR-CampaignRecommendationDormant
  ([../BR/BR-CampaignRecommendationDormant.md](../BR/BR-CampaignRecommendationDormant.md))

---

## Open Questions

- CampaignLog's writer is not evidenced — `Hypothesis`
  ([DOMAIN-aggregates](../DOMAIN-aggregates.md) AG2 / §5).
- The recommendation subsystem is navigable here but marked dormant throughout; a rewrite needs an
  explicit drop-or-rebuild decision before treating it as current behaviour (ARCH0001 §8 Risk 5).
