# SRV0016 — Search Indexing

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C10 — Search & Indexing

## SRV Category
Background Processing

## Responsibility Type
Adapter

## Purpose
Bulk-indexes domain content into Elasticsearch for full-text search, feeding the external search experience (an off-instance React SPA is hypothesised at `els1.patrondeti.cz`). It is the outbound indexing boundary — distinct from the Elasticsearch *audit-log* store owned by SRV0018.

## Current Implementation Shape
- **Index worker:** `EsUploadQueue` queue worker + `EsUploadCommand` (CLI bulk index). `Evidence:` `PSRC/web/modules/custom/patron_search/src/Plugin/QueueWorker/EsUploadQueue.php`; `PSRC/web/modules/custom/patron_search/src/Command/EsUploadCommand.php`; [entrypoints.md §8](../repo-map/entrypoints.md).
- **ES client:** `elasticsearch` module `Elasticsearch` class — hardcoded `http://elasticsearch:9200`. `Evidence:` `PSRC/web/modules/custom/elasticsearch/src/Elasticsearch.php`; [integrations.md §4](../repo-map/integrations.md).
- **Search SPA (external):** an external React search app injected by `patron_search` (`els1.patrondeti.cz`). `Hypothesis` — `Evidence:` [SRV-candidates.md §2](SRV-candidates.md).
- **Triggers:** `EsUploadQueue` (queue) + `EsUploadCommand` (CLI). Note: the cron batch enqueue path is commented out. `Evidence:` [SRV-candidates.md §5 Disabled/dead paths](SRV-candidates.md).

## Structural Issues
- **Partially disabled trigger** — `patron_search` cron batch enqueue is commented; live indexing relies on the queue/CLI. `Evidence:` [SRV-candidates.md §5](SRV-candidates.md).
- **Hardcoded ES endpoint** — `http://elasticsearch:9200` in code (dev orchestration name), plaintext HTTP. `Evidence:` [integrations.md §4](../repo-map/integrations.md).
- **Two ES uses conflated at infra level** — the same Elasticsearch cluster serves both search index (this SRV) and audit log (SRV0018); module named `elasticsearch` actually does audit, `patron_search` does search. `Evidence:` [integrations.md §4](../repo-map/integrations.md).
- **Endpoint not re-verified** — the search-index endpoint was not re-verified in the RepoCartographer verify pass. `Partial` — `Evidence:` [integrations.md §4](../repo-map/integrations.md).

## Target Shape (for rewrite)
A Search-Indexing adapter behind a `SearchIndex` port, fed by domain change events (campaign published/updated) via a reliable queue. ES endpoint/credentials from config; TLS. Clear separation of search cluster from audit-log store. Search SPA served a stable index contract.

## Integration Dependencies
- Elasticsearch (search index) — `http://elasticsearch:9200`. `Partial` (endpoint not re-verified) — [integrations.md §4](../repo-map/integrations.md).
- External React search SPA (`els1.patrondeti.cz`). `Hypothesis` — [SRV-candidates.md §2](SRV-candidates.md).

## Boundaries
Does NOT own the Elasticsearch audit-log write path → SRV0018. Does NOT own the campaigns/content it indexes → SRV0005. Does NOT render the search UI (external SPA).

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Which entities are indexed and the index mapping. `Missing evidence: EsUploadQueue/EsUploadCommand payload trace.`
- How much of the indexing path is live vs. commented. `Missing evidence: patron_search commented-block audit.`
- Confirm the external search SPA host and its index contract. `Missing evidence: patron_search SPA injection code.`
