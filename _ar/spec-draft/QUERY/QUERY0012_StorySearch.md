---
doc_id: QUERY0012
title: Story / Entity Full-Text Search
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: search
references:
  - EN0004
  - EN0001
  - ES0014
  - UC0018
  - FN0022
  - ARCH0012
---

# QUERY0012 – Story / Entity Full-Text Search

## Purpose

The full-text search read-model. Indexed content (stories/applications and related records) is
synchronised to an external Elasticsearch cluster and queried by a front-end search app; the Drupal
side only mounts that app and maintains the index. This is the search read surface, distinct from the
structured catalogue filters (QUERY0003).

Evidence: `web/modules/custom/patron_search/src/Plugin/Block/SearchBlock.php` (mounts the external
search UI from `els1.patrondeti.cz` / staging / localhost, admin-only),
`web/modules/custom/patron_search/src/Command/EsUploadCommand.php`,
`web/modules/custom/patron_search/src/Plugin/QueueWorker/EsUploadQueue.php`,
`web/modules/custom/patron_search/src/PatronSearchCron.php`.

## Consumers

- Back-office searchers (the search block renders only for admins per `isAdmin()` check).
- Indexing pipeline (cron + queue worker) as the write side of this read-model.

## Source Entities

- EN0004 – Campaign (indexed story documents)
- EN0001 – Application (indexed application documents)
- ES0014 – Elasticsearch (external index / query engine)

## Filters and Grouping

| Filter / Grouping | Meaning | Notes |
|---|---|---|
| free-text query | Full-text match executed by the external ES app | Query semantics live in the external app, not in Drupal. Uncertain (out of source). |
| index membership | Which entities are pushed to ES | Governed by the upload command / queue worker (FN0022). Confirmed. |
| audience | Search UI only rendered for admins | `SearchBlock::build()` gate. Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| search hits | Documents returned by ES for a query | Shape defined by the external app; not evidenced in Patronus source. Uncertain. |

## Result Shape

- Interactive search results rendered by the embedded external JS app; Drupal returns only the mount
  point and attached script tags.

## References

- UC: UC0018 (Index Entities for Search)
- FN: FN0022 (Search Indexing & Synchronisation)
- EN: EN0004, EN0001
- ES: ES0014 (Elasticsearch)
- ARCH: ARCH0012 (Platform, Search & Operations)

## Open Items

- **Query semantics are outside the analysed source:** the actual search fields, ranking, and result
  shape are implemented in the external search app (`els1.patrondeti.cz`), which is not part of the
  Patronus code under analysis. Marked `Hypothesis — Not evidenced in current sources.` for anything
  beyond "free-text search over indexed stories/applications".
- Confirm whether the search UI is truly admin-only in production or whether a public search variant
  exists elsewhere. `Uncertain`.
