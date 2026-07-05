---
doc_id: QUERY0007
title: Admin Story List
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: list
references:
  - EN0004
  - EN0001
  - EN0005
  - UC0011
  - FN0006
  - ARCH0005
---

# QUERY0007 – Admin Story List

## Purpose

Back-office list of stories ("Seznam příběhů" / Stories) for content and coordination staff:
status, category, gift price, raised amount, bank total, deadline, patron, region, completion dates.
This is the story-management counterpart to the public catalogue (QUERY0003).

Evidence: `config/views.view.view_campaign.yml` (base `campaign`; page `admin/campaign`).

## Consumers

- content_admin, coordinator, manager, marketing (view role gating).

## Source Entities

- EN0004 – Campaign (base row; `campaign_status`, `gift_category`, `gift_price`, `campaign_raised`, `campaign_deadline`, `kraj`, `completed`, `published`, `uncompleted`)
- EN0001 – Application (lead link, lead created date)
- EN0005 – Patron (patron column)

## Filters and Grouping

| Filter / Grouping | Meaning | Notes |
|---|---|---|
| `campaign_status` (exposed) | Filter by story status | Vocabulary owned by EN/STAT. Confirmed. |
| `id`, `application`, `status`, `name`, `kraj`, `lead_text` (exposed) | Story id, linked application, publish status, name word-search, region, lead text | Per display. Confirmed. |
| access: role set above | Back-office only | Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| `campaign_raised` | Money raised for the story | Persisted field, maintained by `CampaignEntity::updateCampaignRaisedMoney()` (see Open Items). Confirmed. |
| `bank_views_field` | Money received on the bank account for the story | Computed views field (`getCampaignReceivedMoney`: `is_sent_to_bank=1 AND ext_status=PAID`). Confirmed. |
| lead / patron / lead-created views fields | Cross-entity projections | Computed views fields. Confirmed. |
| `gift_price`, `gift_category`, `kraj`, `campaign_deadline`, `completed`, `published`, `uncompleted` | Story attributes | Owned by EN0004; surfaced as columns. Confirmed. |
| operations | Row actions (incl. set-active, pay-remaining) | Confirmed. |

## Result Shape

- Paginated back-office table (25/page), exposed filters.

## References

- UC: UC0011 (Manage Campaign / Story Lifecycle)
- FN: FN0006 (Campaign / Story Lifecycle)
- EN: EN0004, EN0001, EN0005
- ARCH: ARCH0005 (Campaign & Story Domain)

## Open Items

- **Hazard (dual definition of "raised"):** the list reads the persisted `campaign_raised` field,
  while other read paths recompute `SUM(price) WHERE ext_status=PAID` on demand (QUERY0001,
  QUERY0003, QUERY0010). The persisted value is only as fresh as the last
  `updateCampaignRaisedMoney()` run; stale rows can show a different total than the reports.
  Observation for BR/FN0006 ownership.
- The covid19-flag branch of the raised-money computation sums donations across all flagged
  campaigns, not a single story — relevant only to that special account. Partial.
