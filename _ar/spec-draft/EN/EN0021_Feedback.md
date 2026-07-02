---
doc_id: EN0021
title: Feedback
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — feedback captured from an application's fundraiser/campaign
  - EN0004  # Campaign — feedback.campaign → campaign
  - EN0008  # User — feedback.fundraiser / feedback.user_id → user
---

# EN0021 — Feedback

## Description
Post-campaign feedback authored by a fundraiser for the donors who helped them ("Feedback for donors who helped you"). Captures a free-text body plus optional attached images, tied to the fundraiser and the campaign (Story). Created from back-office / fundraiser feedback forms; a `sent` timestamp records dispatch.

## Entity Category
Persisted · Confidence: Medium
(Schema confirmed + create usage in two feedback forms; `sent` write confirmed. Lifecycle beyond create/sent not deeply mined.)

## Origin
- DB artifacts: base_table `feedback`. No `.install` / no hook_schema.
- Code touchpoints:
  - `feedback/src/Entity/FeedbackEntity.php` — entity.
  - `feedback/src/Form/FundraiserFeedbackForm.php:109` — `FeedbackEntity::create(['campaign', 'name', 'body', 'fundraiser'])`; resolves fundraiser + campaign from a parent Application.
  - `feedback/src/Form/CampaignFeedbackForm.php:182` — create; `:276` sets `feedback.sent = time()`.
Evidence: db-models.md `feedback`; grep (FeedbackEntity::create at both forms; set('sent') at CampaignFeedbackForm:276).

## Core Fields
- `name` (string 50; required; entity label — e.g. "Zpětná vazba vložena manuálně")
- `body` (string_long; required; "Feedback for donors who helped you")
- `fundraiser` (er → EN0008 User; optional; authoring fundraiser)
- `campaign` (er → EN0004 Campaign; optional; the Story)
- `fundraiser_images` (file, private, images; optional; cardinality ∞; attachments)
- `sent` (timestamp; optional; dispatch time)
- `status` (boolean; publish flag; default TRUE)

## Technical Fields
- `user_id` (er → EN0008 User; optional; author/owner)
- `created` / `changed` (timestamps)
Evidence: db-models.md `feedback`.

## Relations
- `user_id` → EN0008 User (author). Evidence: db-models.md.
- `fundraiser` → EN0008 User. Evidence: db-models.md; FundraiserFeedbackForm.php:110.
- `campaign` → EN0004 Campaign. Evidence: db-models.md; FundraiserFeedbackForm.php:109.
- `fundraiser_images` → file. Evidence: db-models.md.
- Contextual: sourced from an EN0001 Application (fundraiser + campaign derived from `ApplicationEntity::load`). Evidence: FundraiserFeedbackForm.php:105-111.

## Allowed Statuses
`status` boolean only (published / unpublished); no domain status enum. Evidence: db-models.md `feedback`.

## Lifecycle
- (create) → published (`status` default TRUE); `body`, `fundraiser`, `campaign` populated from the source Application/campaign context. Confirmed (FundraiserFeedbackForm.php:109; CampaignFeedbackForm.php:182).
- created → sent (`sent = time()`) on the campaign feedback path. Confirmed (CampaignFeedbackForm.php:276).
- Application-side: transition to `waiting_for_feetback*` creates a feedback + signing session (notification subscriber). Partial (EN-lifecycle-evidence FLW0001 — feedback creation is adjacent; exact linkage to this entity not fully traced).

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Is feedback shown publicly to donors, and does `status` gate that? Consumer not mined.
2. `FundraiserFeedbackForm` does not set `sent` (only `CampaignFeedbackForm` does) — is `sent` meaningful across both entry points?
3. Relationship to the `waiting_for_feetback` Application status (FLW0001) — one feedback per application, or per campaign?
