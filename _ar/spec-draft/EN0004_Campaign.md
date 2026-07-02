---
doc_id: EN0004
title: Campaign
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001 (Application)
  - EN0005 (Patron)
  - EN0008 (User)
---

# EN0004 — Campaign

## Description
The Campaign (Story / Příběh) is the public-facing fundraising story generated from an approved Application. It carries the target amount (`gift_price`), the running total (`campaign_raised`), a deadline, and a `campaign_status` that mirrors the fundraising lifecycle (in-progress → active → completed / campaign_uncompleted). Campaigns can self-reference a `parent` (promo/group campaigns) and hold a public Patron profile. It is a core aggregate: transaction saves recompute its raised amount and auto-complete it when funded.

## Entity Category
Persisted  ·  Confidence: High

## Origin
- DB artifacts: base_table `campaign`; not revisionable; translatable via config (`language.content_settings.campaign.campaign.yml`); source *mixed* (base fields + attached config field `metatags`). Old slugs archived to external table `campaign_slug_archive`.
- Code touchpoints: `campaign/src/Entity/CampaignEntity.php` (`preSave` recompute + `isCampaignReadyToComplete`/`setComplete`, `activate()`, `setApplicationComplete`, `setRegionByZip`); `CampaignEntityStorageSchema.php` (indexes); `campaign/PublishController::setActive`; auto-complete driven from `TransactionEntity::postSave`.
Evidence: `CampaignEntity.php`; `CampaignEntityStorageSchema.php`; `config/field.storage.campaign.metatags.yml`

## Core Fields
- gift_price (integer; **required**; target amount, min=100)
- campaign_deadline (datetime; **required**; constraint `campaign_deadline_working_day` — RO working day)
- campaign_status (list_string; in-progress / active / suspended / completed / uncompleted / campaign_uncompleted / completed_partly / canceled; runtime also `campaign_uncompleted_inprocess`, undeclared/legacy)
- type (list_string; **required**; basic / promo / long_term / short_term; default basic)
- button_text (string(30); **required**)
- name / name_covid19 (string; entity label)
- campaign_raised (integer; recomputed in preSave from transactions), campaign_percentual_raised (decimal 6,3)
- patron_profile (entity_reference → EN0005 Patron; optional; inline_entity_form)
- gift_category (entity_reference → taxonomy_term `category`; optional; Účel žádosti)
- published / completed / uncompleted / canceled (timestamp; lifecycle dates)
- slug (string(100); auto-generated)
- single_parent, hide_campaign_raised, is_*_email_sent (boolean flags)

## Technical Fields
- uuid / langcode (framework). Image fields (photo, gift_photos, photo_detail_page, photo_list_page, og_image) → file (public). `metatags` attached config field (metatag; translatable storage).

## Relations
Soft entity_reference (no DB FK): user_id, published_user_id, processing_user_id → EN0008 User; parent → EN0004 Campaign (self-reference; `getKidsCount` WHERE parent=id); patron_profile → EN0005 Patron; gift_category → taxonomy_term(category); kraj → kraj. Inbound: EN0001 Application references this via `campaign` (bidirectional status+category sync).

## Allowed Statuses
`campaign_status` allowed values: in-progress, active, suspended, completed, uncompleted, campaign_uncompleted, completed_partly, canceled. Runtime value `campaign_uncompleted_inprocess` is used but NOT in allowed_values (legacy/undeclared).
Evidence: `CampaignEntity.php` baseFieldDefinitions (verified `Confirmed`)

## Lifecycle
Confirmed transitions (code-path evidenced):
- in-progress → active (`published` + `published_user_id` stamped) — `CampaignEntity::activate()`; `PublishController`. [FLW0021]
- active → completed (when `campaign_raised ≥ gift_price` at save; `campaign_order=1000`; success emails in prod) — `CampaignEntity::preSave` via `isCampaignReadyToComplete` → `setComplete`; payment-driven from `TransactionEntity::postSave`. [FLW0021, FLW0022, FLW0003]
- active → `campaign_uncompleted` (deadline passed AND raised < gift_price) — `CampaignCron::setState('campaign_uncompleted')`. [FLW0022]
- `campaign_status`/`gift_category` synced from owning Application state — `ApplicationEntity::updateCampaignStatus/Category`. [FLW0002]

Partial: set-active (publish) also stamps the Application active [FLW0021]. Media unblur (blurred→unblurred) is a cron side-effect, not a status transition [FLW0022].

Missing evidence: `canceled` / `suspended` / `completed_partly` transition triggers not deep-mined; `campaign_uncompleted_inprocess` origin unconfirmed.

## Spec Alignment
N/A — No EN spec files found in repository (see EN-candidates.md §Spec Discovery).

## Open Questions
- What triggers `suspended`, `canceled`, and `completed_partly` states?
- How is the undeclared `campaign_uncompleted_inprocess` reached and cleared?
- What is the group/promo (`parent`) completion semantics vs. child campaigns?
