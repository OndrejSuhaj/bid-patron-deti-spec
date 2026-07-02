---
doc_id: BR-SearchIndexingConsistency
title: Search Indexing Consistency
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
  - SYSTEM
references:
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
  - UC0018
---

# BR – Search Indexing Consistency

## Purpose

Governs how changes to searchable entities propagate to the external search index, the
retry-on-failure guarantee for that propagation, and the current-state full-re-push behavior of
the organisation index (UC0018).

---

## Propagation and Retry

- A created or changed searchable entity (Application `EN0001`, Campaign `EN0004`, Transaction
  `EN0009`, Organisation `EN0018`, User `EN0008`) SHALL be enqueued for search indexing as a
  save-time side effect.
- The search-index document for a queued entity SHALL be built from that entity's current data at
  the time the periodic indexing job drains the queue.
- An entity whose indexing call fails SHALL remain queued, or SHALL be re-queued, so that indexing
  is retried on a later run.
- Search indexing SHALL be treated as an asynchronous, eventually-consistent path: the search index
  MAY lag behind primary storage, and primary entity data SHALL NOT be affected by indexing
  outcomes (success or failure).

---

## Organisation Index (Current-State)

- The Organisation registry (`EN0018`) SHALL be pushed to a distinct, dedicated organisation search
  index on an independent schedule from the main search-indexing queue.
- Current-state: the organisation index run is a full re-push of the registry with no incremental
  cursor — it does NOT currently propagate only the changed subset (current-state gap).
- Current-state: the core search-index synchronisation flow beyond the save-time enqueue and
  periodic-drain behavior described in `UC0018` is un-mined; no further step-level indexing
  behavior SHALL be assumed.

---

## Non-Goals

This rule does not define the search-index document schema, the indexing queue's storage
mechanism, or the external search integration's request/response contract. It does not govern
which entity changes trigger enqueueing — that trigger behavior belongs to the use cases that
change Application, Campaign, Transaction, Organisation, and User records. This rule owns only the
indexing propagation and consistency guarantees themselves.
