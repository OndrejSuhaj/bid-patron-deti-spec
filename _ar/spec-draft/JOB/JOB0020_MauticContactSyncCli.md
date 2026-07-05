---
doc_id: JOB0020
title: Mautic Contact Sync (CLI)
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: batch
references:
  - FN0015
  - EN0008
  - ES0006
---

# JOB0020 – Mautic Contact Sync (CLI)

## Purpose

Bulk-upsert platform users (with donation totals, roles, last-login/last-transaction dates) to the
Mautic marketing/CRM system via CLI. The batch/CLI arm of FN0015 (Marketing / CRM Synchronisation),
complementing the queue-drain cron (JOB0012).

Classification: **Confirmed**.

## Trigger Model

- Batch / CLI (Drush) commands: `mautic:sync:contacts` (production-gated; delta by supporter
  transaction time and by user changed time via persisted state keys) and `patron_base:mautic_sync`
  (full user sweep, feature-flag gated). Operator- or externally-invoked; no cron wiring.
- Evidence: `mautic/src/Commands/MauticCommands.php` (`mautic:sync:contacts`);
  `patron_base/src/Commands/PatronBaseCommands.php` (`patron_base:mautic_sync`).

## Input Scope

- `mautic:sync:contacts`: supporters with transactions since the last supporter-sync cursor, plus
  users changed since the last user-sync cursor. `patron_base:mautic_sync`: all users. See EN0008.

## Processing Rules

- Per user: assemble contact fields (name, email, role, zone/last-transaction dates, and for
  supporters donation total/count/average) and upsert to Mautic. Advance the sync-time cursors after
  each sweep (`mautic:sync:contacts` only).

## Side Effects

- Outbound contact upsert to Mautic (ES0006) per user; the API base URL is chosen by country. No
  local domain-entity mutation. Persisted sync-cursor writes (`mautic:sync:contacts`).

## Idempotency

- Upsert is keyed by contact identity on the Mautic side (idempotent externally). The delta cursors
  make `mautic:sync:contacts` re-runnable without reprocessing unchanged users; the full sweep
  reprocesses everyone.

## Failure Handling

- Per-user send failures are logged (error) and skipped; the sweep continues. The production gate on
  `mautic:sync:contacts` and the feature flag on `patron_base:mautic_sync` can silently no-op the run.

## References

- FN: FN0015
- UC: UC0012, UC0013
- EN: EN0008
- ES: ES0006
- Evidence: MauticCommands, PatronBaseCommands (`patron_base:mautic_sync`)

## Open Items

- **Anti-erasure hazard (Confirmed, FN0015):** these sweeps upsert first/last name and can re-create
  a Mautic contact after GDPR anonymisation. Overlap with the queue-drain path (JOB0012); which path
  is authoritative in production is a `Partial` open item.
