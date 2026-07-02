---
doc_id: ES0014
title: Elasticsearch
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0022
  - FN0023
  - UC0016
  - UC0018
  - UC0020
---

# ES0014 – Elasticsearch

## Purpose

Elasticsearch is integrated as the platform's search/indexing engine, serving three distinct
purposes in the current landscape: a full-text search index for domain entities, a separate
request/response audit-log store, and a separate Elastic Cloud index of organisations. It is one of
the outbound service targets named in the Integration Landscape (`ARCH0001` §5, row 14).

---

## System Overview

Elasticsearch is a third-party search/indexing engine. Patronus consults it in three current,
distinct roles rather than one:

- as a **full-text search index** over domain entities, so that search queries can be served from an
  index rather than the primary data store;
- as a **request/response audit-log store**, recording a log of platform requests and their
  responses for later inspection;
- as a **hosted Elastic Cloud index of organisations**, a separate deployment holding organisation
  identity records for lookup.

These three uses are documented here as a single ES because they share the same external vendor
system, even though they represent three separate integration boundaries and current uses
(`ARCH0001` §5 row 14 note; integrations.md §4).

---

## Integration Model

Outbound (write/index) in all three roles — the platform pushes data to Elasticsearch; it does not
describe Elasticsearch as querying back into the platform:

- **Search index:** entity saves enqueue documents for indexing; a worker/cron drains the queue and
  bulk-indexes them into the search index. This path is genuinely asynchronous (`UC0018`;
  `ARCH0002` (b) search-index queue).
- **Audit-log store:** a request/response audit record is written per request, on an audit-listener
  path (`UC0020`; `ARCH0002` (c) audit listener). This role only writes — it does not serve queries
  back to the platform.
- **Organisations index (Elastic Cloud):** a daily scheduled job re-pushes every organisation to the
  Elastic Cloud organisations index as a full re-push, with no incremental cursor (`UC0016`;
  `UC0018`; `ARCH0002` (b) daily org index).

**Evidence level:** the search-index role's boundary is confirmed at the architecture level, but the
index-sync flow itself is thinly evidenced (`Partial`, HS16). The audit-log and organisations-index
roles are confirmed (`ARCH0001` §5 row 14).

---

## Data Exchange

- **Outbound (search index):** indexable representations of domain entities, sent for full-text
  search indexing (conceptual only; see `EN0001`, `EN0004`, `EN0009`, `EN0018` for the entities
  concerned — not restated here).
- **Outbound (audit-log store):** request/response audit records describing platform requests and
  their outcomes (conceptual only; see `EN0008`/audit-record entity, not restated here).
- **Outbound (organisations index):** organisation identity records, re-sent in full on each
  scheduled run (conceptual only; see `EN0018`, not restated here).
- **Inbound:** none of these three roles is documented as returning data used within a reconstructed
  use case; the search index and organisations index exist to be queried by other means outside the
  scope of the mined evidence.

No payload or field-level detail is asserted here.

---

## Constraints

- **Failure impact — search index:** if unavailable, newly saved/changed entities do not reach the
  search index; the write path itself is genuinely asynchronous via a queue, so a platform request is
  not blocked, but search results may fall behind (`ARCH0001` §5 row 14).
- **Failure impact — audit-log store:** if unavailable, request/response audit records are not
  captured; this is a write-only integration and does not affect request processing outcomes
  (`ARCH0001` §5 row 14; integrations.md §4).
- **Failure impact — organisations index:** if unavailable, the daily full re-push fails for that
  run; because there is no incremental cursor, the index can fall out of date until the next
  successful full run (`ARCH0001` §5 row 14; `ARCH0002` (b)).
- **No incremental sync for the organisations index:** each scheduled run re-pushes every
  organisation in full rather than only changes since the last run (`ARCH0001` §5 row 14;
  `ARCH0002` (b)).
- **Distinct endpoints per role:** the search index, audit-log store, and organisations index are
  reached as separate, hardcoded destinations rather than one unified endpoint (`ARCH0001` §5 row 14).
- **Write-only audit role:** the audit-log store role only writes records; it is not used to serve
  queries back into the platform.
- **Boundary role only:** this ES describes the external Elasticsearch/Elastic Cloud boundary only.
  The internal component that prepares and enqueues documents for indexing is not itself an external
  system and is out of scope for this ES (`FN0022`).
- **Current-state only:** this reflects the integration as evidenced today; no target-state change is
  asserted here.
- **Evidence level:** `Partial` for the search-index synchronisation flow (HS16); `Confirmed` for the
  audit-log store and organisations-index roles at the architecture/integration-landscape level
  (`ARCH0001` §5 row 14).
