---
doc_id: QUERY0004
title: Story Region Counts (CZ Map)
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: summary
references:
  - EN0004
  - UC0023
  - FN0006
  - ARCH0005
---

# QUERY0004 – Story Region Counts (CZ Map)

## Purpose

Read-model behind the CZ regional map / region selector on the story-listing page: the number of
**active** stories per region (kraj), used to label the map and disable empty regions.

Evidence: `web/modules/custom/campaign/src/Controller/RenderRegionsController.php`
(route `/campaign/regions/render`).

## Consumers

- Public story-listing UI (mobile region `<select>` and desktop SVG map).

## Source Entities

- EN0004 – Campaign (grouped by `kraj`; `campaign_status`)
- Reference: kraj entity (region names, loaded via entity storage for labels)

## Filters and Grouping

| Filter / Grouping | Meaning | Notes |
|---|---|---|
| `kraj IS NOT NULL` | Only stories assigned to a region | Confirmed. |
| `campaign_status = 'active'` | Only active stories are counted | Hard-coded. Confirmed. |
| group by `kraj` | One count per region | Raw SQL `COUNT(*) ... GROUP BY kraj`. Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| region label | `"<region name> (<count>)"`, "kraj" suffix appended when name ends with "ý" | Confirmed. |
| count per slug | Active-story count keyed by region slug (14 CZ regions) | Region id→slug map hard-coded (1..14). Confirmed. |
| disabled flag | Region option disabled when count is 0 | Confirmed. |

## Result Shape

- HTML fragment: a `<select>` of regions + rendered map, counts embedded in labels.

## References

- UC: UC0023 (Browse / Filter Story Catalogue)
- FN: FN0006 (Campaign / Story Lifecycle)
- EN: EN0004
- ARCH: ARCH0005 (Campaign & Story Domain)

## Open Items

- **Hazard (hard-coded, CZ-only):** the region id→slug map (1..14) and the "ý"→" kraj" label rule are
  CZ-specific and hard-coded; this read-model is not evidenced for RO/MD tenants. Partial.
- The count uses raw `campaign_status = 'active'` and does not reconcile with the catalogue's
  status filter (QUERY0003) — a story visible under a different status is not counted. Observation.
