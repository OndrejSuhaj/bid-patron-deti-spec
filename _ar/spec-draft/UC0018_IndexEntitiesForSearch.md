# UC0018 — Index Entities for Search

## Header

| Field | Value |
|---|---|
| UC ID | UC0018 |
| Name | Index Entities for Search |
| Bounded Context | C10 |
| Primary Actor(s) | System, Scheduler |
| Trigger Type | Async/Cron |

## Actors & Responsibilities

- **System** — detects that a searchable entity has changed and queues it for indexing; builds the index payload for a queued entity.
- **Scheduler** — periodically triggers the background job that drains the indexing queue.
- **Integration(Elasticsearch)** — external search index that stores and serves indexed entity documents.

## Intent

Keep an external search index synchronized with the Patron platform's searchable entities (Application, Campaign, Transaction, Organisation, User) so that search and lookup features can query up-to-date data without querying primary storage directly.

## Preconditions

- A searchable entity (Application (EN0001), Campaign (EN0004), Transaction (EN0009), Organisation (EN0018), or User (EN0008)) exists and has been created or changed.
- The Elasticsearch/App Search integration is reachable.
- A background indexing job (queue and/or cron) is configured to run.

## Main Flow

### UC0018.1 — Queue entity for indexing

1. System: Detect that a searchable entity (Application, Campaign, Transaction, Organisation, or User) was created or changed.
2. System: Queue the entity for search indexing.

### UC0018.2 — Process indexing queue

1. Scheduler: Trigger the periodic indexing job.
2. System: Read the next queued entity from the indexing queue.
3. System: Build a search-index document from the entity's current data.
4. Integration(Elasticsearch): Store or update the entity's document in the search index.
5. System: Remove the entity from the indexing queue after successful indexing.

## Alternative Flows

### AF1 — Indexing call fails

1. Integration(Elasticsearch): Reject or fail to process the indexing request.
2. System: Leave the entity queued (or re-queue it) for a later indexing attempt.

Outcome: The entity remains out of sync with the search index until a subsequent indexing attempt succeeds; no primary data is affected.

## Postconditions

- The search index holds an up-to-date document for the indexed entity (on success).
- The indexing queue no longer references successfully indexed entities.
- Primary entity data (Application, Campaign, Transaction, Organisation, User) is unchanged by indexing.

## Traceability

Target SRVs:
- SearchIndex-Processor
- Elasticsearch-Adapter

EN entities:
- EN0001 Application — searchable entity type indexed for lookup
- EN0004 Campaign — searchable entity type indexed for lookup
- EN0009 Transaction — searchable entity type indexed for lookup
- EN0018 Organisation — searchable entity type indexed for lookup
- EN0008 User — searchable entity type indexed for lookup

Integration boundaries:
- Elasticsearch / App Search

Flow Evidence:
- FL055 (search-index sync — not mined; cited as un-mined flow-index id in UC-candidates.md and UC-srv-traceability.md)

## Evidence Level

Partial — no mined flow dossier exists for search indexing (FL055 is listed as un-mined, Depth=Later, in UC-candidates.md); this UC is reconstructed as an infrastructure coverage stub from SRV-target-list.md (SearchIndex-Processor, Elasticsearch-Adapter, both C10) and from SearchIndex-Processor's confirmed side-effect appearances in UC0002, UC0011, and UC0016, cross-referenced against the searchable entities EN0001/EN0004/EN0009/EN0018/EN0008; no detailed step-level behavior is evidenced and none is invented here.
