---
doc_id: FN0022
title: Search Indexing & Synchronisation
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0018
  - UC0002
  - UC0011
  - UC0016
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
---

# FN0022 – Search Indexing & Synchronisation

## Purpose

Provide the search-indexing capability used by UC0018: as searchable entities change, their
representations are propagated to an external search index so lookup and full-text features read fresh
data instead of reading primary storage directly.

---

## Responsibilities

The capability is responsible for:

- Detecting that a searchable entity was created or changed and enqueuing it for indexing as a
  save-time side-effect.
- Draining the indexing queue on a periodic job, building a search-index document from the entity's
  current data, and upserting it into the external search index.
- Leaving an entity queued, or re-queuing it, when an indexing call fails, so it can be retried on a
  later run.
- Supporting a separate, independently scheduled full re-push of the Organisation registry into a
  distinct external organisation index.

---

## Related Use Cases

- UC0018 – Index Entities for Search
- UC0002 – Orchestrate Application Status Change (search-indexing side-effect trigger)
- UC0011 – Manage Campaign/Story Lifecycle (search-indexing side-effect trigger)
- UC0016 – Maintain Party Records (search-indexing side-effect trigger)

---

## Related Entities

- EN0001 – Application
- EN0004 – Campaign
- EN0009 – Transaction
- EN0018 – Organisation
- EN0008 – User

---

## Integrations

- Elasticsearch / App Search — primary full-text search index for the searchable entities
  (see ARCH0002_ContextInteractionMap.md, C10 Search & Indexing).
- A separate, distinct external Elastic Cloud organisation index, updated by an independent daily
  full re-push (see ARCH0002_ContextInteractionMap.md).

---

## Constraints

- The core search-index synchronisation flow is un-mined — Status: Partial. No detailed step-level
  behavior beyond UC0018 is evidenced.
- The indexing side-effect is Confirmed only as it appears within other use cases (UC0002, UC0011,
  UC0016); it has no dedicated mined dossier of its own.
- The Organisation index re-push is a full re-push on every scheduled run, with no incremental
  cursor, and targets a distinct hardcoded external endpoint separate from the main search index.
- This is one of the few genuinely asynchronous, decoupled paths in the reconstructed system
  (queue + periodic job, rather than inline synchronous processing).
