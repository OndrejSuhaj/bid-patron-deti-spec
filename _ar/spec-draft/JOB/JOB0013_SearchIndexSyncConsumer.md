---
doc_id: JOB0013
title: Search Index Sync Consumer
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: async-consumer
references:
  - FN0022
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
  - ES0014
---

# JOB0013 – Search Index Sync Consumer

## Purpose

Drain the entity search-index queue, building and upserting one search document per changed entity
(user, application, campaign, organisation, transaction) into the external App Search index.
The core async path of FN0022 (Search Indexing & Synchronisation).

Classification: **Confirmed** (queue path); **Partial** (drain scheduling — see Trigger Model).

## Trigger Model

- Asynchronous consumer. Items are enqueued from the save handler of five indexed entity types.
- **Drain is NOT automatic:** the queue worker has no cron key, and this module's own cron drain is
  **commented out**, so Drupal core cron does not claim it. Draining happens only when an operator or
  external scheduler invokes the drain CLI (see JOB0022). If nothing runs the drain, the queue grows
  unbounded and the index goes stale.
- Evidence: enqueue via the shared add-to-queue helper from five entity save handlers; worker
  `patron_search/src/Plugin/QueueWorker/EsUploadQueue.php` (`id="es_upload_queue"`, no cron key).
  Dossier: FLW0032.

## Input Scope

- Queue items carrying an entity type + id. The worker reloads the **live** entity at drain time
  (indexes latest state, not enqueue-time state). Up to 500 items per drain invocation, 1-hour claim
  lease each. See EN0001, EN0004, EN0009, EN0018, EN0008.

## Processing Rules

- Per item: dispatch by entity type to the matching document builder; append common fields
  (composite id, type, label, links, timestamps); strip empty fields; upsert one document to the
  external App Search index via an outbound POST; throttle with a 1-second sleep per document.

## Side Effects

- One search document upserted per processed entity to the App Search index (ES0014). No local entity
  mutation (pure read + outbound POST).
- **PII egress (Legal/GDPR hazard):** application documents ship birth numbers, emails, phones and
  names of fundraiser and child to the external index with no masking. All tenants co-mingle in one
  index. `Confirmed`.
- Telegram ops alert on send error (FN0023).

## Idempotency

- Upsert is keyed by the composite entity id, so re-processing overwrites the same document
  (idempotent externally). An enqueue-side dedup guard collapses repeat saves into one pending item
  (but its substring match can suppress a legitimate enqueue — see Failure Handling).

## Failure Handling

- On a per-doc error the item is **released** (retryable) and an alert fired; persistent doc errors
  retry indefinitely. Missing index credentials → the worker throws and the item retries forever
  with no progress.
- **Silent index gap:** a hard network failure yields an empty parsed response, the error loop
  iterates nothing, the item is treated as success and **deleted** while nothing was indexed.
- **No delete-from-index:** deleted entities keep orphan documents (PII persists after deletion).
- Dedup substring-collision can drop a legitimate index update. All documented current-state hazards
  (FLW0032).

## References

- FN: FN0022, FN0023
- UC: UC0018, UC0016
- EN: EN0001, EN0004, EN0009, EN0018, EN0008
- ES: ES0014
- Evidence: FLW0032

## Open Items

- Whether an external scheduler actually invokes the drain CLI is **not evidenced in source**
  (`Hypothesis`); the module's own cron drain is commented out. This is the residual Partial for
  FN0022. See JOB0022 for the drain / full-reindex commands.
