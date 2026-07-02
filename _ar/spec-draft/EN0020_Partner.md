---
doc_id: EN0020
title: Partner
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0008  # User — owner
---

# EN0020 — Partner

## Description
Marketing partner / "podporují nás" (they support us) logo entry displayed on the site (typically the footer). A lightweight CMS-adjacent content record: a name, an outbound link, a logo image, a sort order, and a category distinguishing "support us" from "partners". No domain behavior beyond display ordering.

## Entity Category
Content · Confidence: Low
(Schema confirmed; no usage flow mined — presentation/marketing content, not domain logic. Note: a separate taxonomy `partners` bundle exists and is unrelated to this entity.)

## Origin
- DB artifacts: base_table `partner`. No `.install` / no hook_schema.
- Code touchpoints:
  - `partner/src/Entity/PartnerEntity.php` — entity.
Evidence: db-models.md `partner`. (Note: `field.field.taxonomy_term.partners.*` config belongs to the taxonomy `partners` bundle, NOT this entity — db-models.md.)

## Core Fields
- `category` (list_string; required; values: `support_us` / `partners`)
- `name` (string 50; optional; entity label)
- `link` (string 200; optional; outbound URL)
- `logo` (image, public; optional)
- `order` (integer; optional; sort order)
- `status` (boolean; publish flag)

## Technical Fields
- `user_id` (er → EN0008 User; optional; author)
- `created` / `changed` (timestamps)
Evidence: db-models.md `partner`.

## Relations
- `user_id` → EN0008 User (author). Evidence: db-models.md.
- `logo` → file. Evidence: db-models.md.

## Allowed Statuses
`status` boolean only (published / unpublished); no domain status enum. `category` (`support_us`/`partners`) is a classification enum, not a lifecycle state. Evidence: db-models.md `partner`.

## Lifecycle
Hypothesis — Not evidenced in current sources. No create/transition flow dossier covers Partner; only schema is confirmed. Missing evidence: admin create/edit path and display consumer.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. How is `order` used to render the partner list, and is it globally unique or free-form?
2. Is the `category` split (support_us vs partners) surfaced in distinct site regions?
3. Overlap/confusion risk with the taxonomy `partners` bundle — are both in active use?
