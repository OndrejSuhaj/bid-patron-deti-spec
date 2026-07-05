---
doc_id: QUERY0005
title: Gift Categories Reference List
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: list
references:
  - EN0033
  - UC0023
  - FN0026
  - ARCH0005
---

# QUERY0005 – Gift Categories Reference List

## Purpose

Reference read-model exposing the gift-category taxonomy used to categorise stories and to drive the
category facet on the story catalogue. Provides the selectable set of published child (non-root)
categories.

Evidence: `config/views.view.gift_categories.yml` (base `taxonomy_term_field_data`, vocabulary
`category`; also an `entity_reference` display used as a reference-selection source).

## Consumers

- Story catalogue category facet (see QUERY0003).
- Entity-reference selection widgets that pick a gift category.

## Source Entities

- EN0033 – GiftCategory (taxonomy term in vocabulary `category`)

## Filters and Grouping

| Filter / Grouping | Meaning | Notes |
|---|---|---|
| `vid = category` | Only the gift-category vocabulary | Confirmed. |
| `parent_target_id > 0` | Only child terms (excludes root/top-level) | Confirmed. |
| `status = 1` | Only published terms | Confirmed. |
| access: `access content` | Public read | Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| `name` | Category display name | Confirmed. |
| entity-reference match | Term id + name for reference selection display | `entity_reference` display. Confirmed. |

## Result Shape

- Small paged list (10/page) of category names; entity-reference display returns id/name pairs.

## References

- UC: UC0023 (Browse / Filter Story Catalogue)
- FN: FN0026 (Reference Data Lookup)
- EN: EN0033
- ARCH: ARCH0005 (Campaign & Story Domain)

## Open Items

- Localisation/country scoping of the category vocabulary is not evidenced in this view; assumed
  per-site vocabulary content. Partial.
