---
doc_id: JOB0012
title: Mautic Contact Sync Queue Drain (Cron)
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: scheduler
references:
  - FN0015
  - EN0008
  - ES0006
---

# JOB0012 – Mautic Contact Sync Queue Drain (Cron)

## Purpose

Drain the Mautic contact-sync queue on each cron tick, upserting each queued user to the Mautic
marketing/CRM system. This is the scheduled driver for the async consumer JOB0014-style worker
described in JOB0013's sibling; realises the queue-drain arm of FN0015 (Marketing / CRM
Synchronisation).

Classification: **Confirmed** (cron trigger + drain loop evidenced).

## Trigger Model

- Scheduled. Runs as the second unit of the `patron_base` cron hook on the platform cron tick
  (hourly, `0 * * * *`). No internal daily throttle — it drains up to 500 items per tick.
- Evidence: `patron_base/patron_base.module:163,167` → `patron_base/src/PatronBaseMauticCron.php:14`
  → `processQueue('mautic_queue')`. The worker itself is JOB0015's Mautic consumer contract.

## Input Scope

- Items on the Mautic sync queue (each carries a user id). Items are enqueued when a user is saved
  (the user save handler adds the user to this queue). Up to 500 items claimed per run, each with a
  1-hour claim lease.

## Processing Rules

- Loop up to 500 times: claim an item, invoke the Mautic queue worker on it, and delete on success.
- The worker upserts the user's contact fields to Mautic **only when** the Mautic-export feature
  flag is enabled; otherwise it returns without sending. See EN0008.

## Side Effects

- Outbound contact upsert to Mautic (ES0006) per processed user (feature-flag gated). No local
  entity mutation. Queue rows claimed/deleted/released.
- Telegram ops alert on worker error (FN0023).

## Idempotency

- Contact upsert is keyed by contact identity on the Mautic side, so re-processing overwrites the
  same contact (idempotent externally). Queue delivery is at-least-once (claim → delete on success).

## Failure Handling

- Per-item exception handling: requeue on transient/server exceptions; on a generic exception the
  item is **released** (retryable), not deleted (the delete line is commented out) — so a
  persistently failing item retries indefinitely. `Confirmed`.
- The cron hook wraps this unit and **re-throws** on escape, which can abort the platform cron tick.

## References

- FN: FN0015, FN0023
- UC: UC0012, UC0013, UC0015
- EN: EN0008
- ES: ES0006
- Evidence: PatronBaseMauticCron, MauticQueue worker (see JOB0015)

## Open Items

- **Anti-erasure hazard (Confirmed, FN0015):** the Mautic sync re-upserts users including first/last
  name, so it can re-create a contact after GDPR anonymisation. Recorded as a cross-cutting risk.
- The Mautic API base URL is chosen by country in the worker/command; there is also a separate CLI
  sync path (JOB0020). `Partial` on which path is authoritative in production.
