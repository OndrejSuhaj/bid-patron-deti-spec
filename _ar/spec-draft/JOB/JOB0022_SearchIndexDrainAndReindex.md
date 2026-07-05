---
doc_id: JOB0022
title: Search Index Drain and Full Re-index
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: batch
references:
  - FN0022
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
  - ES0014
---

# JOB0022 – Search Index Drain and Full Re-index

## Purpose

CLI operations that drive the search index: (a) drain the entity search-index queue on demand, and
(b) perform a full re-index that walks all indexed entities and pushes them directly to the App
Search index, bypassing the queue. The manual driver for the JOB0013 consumer and the bulk-rebuild
path of FN0022 (Search Indexing & Synchronisation).

Classification: **Confirmed**.

## Trigger Model

- Batch / CLI (Drupal Console) commands: `patron_search:process_queue` (drain the queue via the
  drain loop) and `patron_search:upload_to_es` (full re-index, bypasses the queue, maintains a
  persisted last-id cursor). Operator- or externally-invoked; this is the only evidenced way the
  search index is drained/rebuilt (the module's own cron drain is commented out — see JOB0013).
- Evidence: `patron_search/src/Command/ProcessQueueCommand.php` (`patron_search:process_queue`) →
  the drain loop; `patron_search/src/Command/EsUploadCommand.php` (`patron_search:upload_to_es`).
  Dossier: FLW0032.

## Input Scope

- `process_queue`: pending items on the entity search-index queue (see JOB0013 for item shape).
- `upload_to_es`: all indexed entities (user, application, campaign, organisation, transaction),
  paged by a persisted last-id cursor. See EN0001, EN0004, EN0009, EN0018, EN0008.

## Processing Rules

- `process_queue`: run the shared drain loop (up to 500 items, 1-hour claim lease), invoking the
  search-index worker per item — identical contract to JOB0013.
- `upload_to_es`: iterate entities in id pages, build the same per-type documents as the worker,
  upsert each to the App Search index, advancing the state cursor as it goes.

## Side Effects

- Search documents upserted to the App Search index (ES0014). **Same PII-egress hazard** as JOB0013
  (birth numbers, names, emails, phones shipped unmasked; single shared engine for all tenants).
- Telegram ops alert on send error (FN0023). `upload_to_es` maintains a persisted cursor;
  `process_queue` deletes/releases queue items.

## Idempotency

- Upsert keyed by composite entity id (idempotent externally). `upload_to_es` is resumable via the
  last-id cursor; re-running from a reset cursor re-pushes everything.

## Failure Handling

- `process_queue` inherits the drain loop's failure semantics (release/requeue/delete per exception
  type; the silent-index-gap and retry-forever hazards of JOB0013 apply).
- `upload_to_es` alerts on per-document errors and continues by cursor; a hard failure interrupts the
  walk at the current cursor position (resumable next run).

## References

- FN: FN0022, FN0023
- UC: UC0018
- EN: EN0001, EN0004, EN0009, EN0018, EN0008
- ES: ES0014
- Evidence: FLW0032; ProcessQueueCommand, EsUploadCommand

## Open Items

- Whether an external scheduler invokes `process_queue` regularly is **not evidenced in source**
  (`Hypothesis`) — this is the residual scheduling gap for the whole search-index path (JOB0013 +
  this job). Index credentials are `<redacted>` (env-supplied, absent in scrubbed source).
