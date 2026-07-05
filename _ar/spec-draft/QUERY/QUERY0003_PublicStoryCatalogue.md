---
doc_id: QUERY0003
title: Public Story Catalogue
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: search
references:
  - EN0004
  - EN0033
  - EN0009
  - EN0008
  - UC0023
  - FN0006
  - FN0024
  - ARCH0005
---

# QUERY0003 – Public Story Catalogue

## Purpose

Read-model behind the public/front story listing (children's stories to support). A dynamic
select-query over campaigns (stories) with filtering, ordering, offset paging, exclusion, and
merchandising injection (infinite/transparent account, promo story, temporary promo story). This is
the primary browse-and-filter surface for donors choosing a story.

Evidence: `web/modules/custom/campaign/src/Plugin/rest/resource/v33/CampaignsResource.php`
(also v30–v32 predecessors). Region filter maps to `c.kraj`; category maps to `c.gift_category`.

## Consumers

- Public / anonymous and authenticated donors (front-end story listing and infinite scroll).
- Personalised variants for authenticated users (interacted / recommended stories).

## Source Entities

- EN0004 – Campaign (base row; the story; `campaign_status`, `kraj`, `gift_category`, `completed`, `campaign_deadline`, `campaign_percentual_raised`, `parent`)
- EN0033 – GiftCategory (category filter target)
- EN0009 – Transaction (join for interacted-at ordering / interacted set)
- EN0008 – User (recommended / interacted personalisation)

## Filters and Grouping

| Filter / Grouping | Meaning | Notes |
|---|---|---|
| `filter_status` → `c.campaign_status` | One or many story statuses (IN when multiple) | Status vocabulary owned by EN/STAT. Confirmed. |
| `filter_category` → `c.gift_category` | Gift category (mapped from a slug map) | Confirmed. |
| `filter_region` → `c.kraj` | Region (slug → kraj id map, 14 CZ regions) | Confirmed. |
| `filter_id` → `c.id` (IN) | Explicit story id list, numeric-filtered | Confirmed. |
| `filter_flag` → resolved to `c.id` IN | Flag names resolved to campaign ids via raw-SQL lookup on `application__flag` | Empty flag set forces empty result (`c.id = 0`). Confirmed. |
| `filter_organization_id` → `c.id` IN | Stories tied to an organisation (uuid → org → ids via raw SQL) | Confirmed. |
| `filter_user_interacted_campaigns` | Restrict to stories the current user donated to | Authenticated only; anonymous forced empty. Confirmed. |
| `filter_user_recommended_campaigns` | Restrict to recommended stories for the user | Authenticated only; anonymous forced empty. See FN0024 (dormant). Confirmed. |
| default published guard | `c.status = 1` applied in the default status branch | Confirmed. |
| `exclude` | Comma list of story ids removed (`NOT IN`), plus the infinite campaign id | Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| story short-data object | Per-story payload (`id`, `type`, `url_hash`, `status`, `category`, `name`, `photo`, `full_amount`, `raised_amount`, `hide_raised_amount`, `campaign_ends`, `campaign_finished`, `has_feedback`, `_percentual_support`) | From `CampaignEntity::getShortData()`; `raised_amount`/`_percentual_support` read the persisted `campaign_raised` / `campaign_percentual_raised` fields (see QUERY0008 for how those are maintained). Confirmed. |
| `interacted_at` / `total_amount_donated` | For interacted ordering: max donation date + summed donated per story | Raw-SQL UNION over `transaction` grouped by story/parent. Confirmed. |
| injected stories | Infinite/transparent account, promo story, temporary promo story spliced into result at fixed offsets | Merchandising, not a DB filter. Confirmed. |

## Filters and Grouping — ordering

| Order key | Sort | Notes |
|---|---|---|
| `latest` (default) | `id` DESC | Default when no/unknown order. Confirmed. |
| `finished_recently` | `completed` DESC | Confirmed. |
| `ends_soon` | `campaign_deadline` ASC + `HAVING deadline > now` | Adds computed unix deadline expression. Confirmed. |
| `least_percentual_support` | `campaign_percentual_raised` ASC | Confirmed. |
| `interacted_at` | join `transaction`, restrict to current user | Authenticated + has interactions only. Confirmed. |

## Result Shape

- Offset-paged list of story short-data objects (infinite scroll; `offset` request param, page size internal).
- Merchandising campaigns injected at fixed positions (offset < 6 for infinite; index 3 for promo; index 5 for tmp promo).

## References

- UC: UC0023 (Browse / Filter Story Catalogue)
- FN: FN0006 (Campaign / Story Lifecycle), FN0024 (Campaign Recommendation — dormant)
- EN: EN0004, EN0033, EN0009, EN0008
- ARCH: ARCH0005 (Campaign & Story Domain)

## Open Items

- **Hazard (raw-SQL inside a read resource):** flag→id, organisation→id, interacted-set, and the two
  donor amount helpers are ad-hoc raw SQL embedded in the REST resource; several bypass the entity
  read path. Kept as observation, not restated as BR.
- The region slug→id map (14 CZ regions) is hard-coded in code (also duplicated in
  RenderRegionsController, see QUERY0005) — non-CZ tenants have no region facet evidenced. Partial.
- Page-size / paging window constants are internal to the resource and not fully enumerated here.
