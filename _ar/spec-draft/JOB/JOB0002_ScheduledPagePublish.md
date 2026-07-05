---
doc_id: JOB0002
title: Scheduled Page Publish and Homepage Swap
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: scheduler
references:
  - FN0025
  - EN0004
---

# JOB0002 – Scheduled Page Publish and Homepage Swap

## Purpose

Publish date-gated CMS content pages whose publish date is today, and optionally swap the site
homepage to a newly published page. Realises the ScheduledPublish arm of FN0025 (Workflow /
Transition-Legality Engine & Scheduled Publish).

Classification: **Confirmed** (dedicated cron service class, fully evidenced).

## Trigger Model

- Scheduled. Runs on every platform cron tick (hourly, `0 * * * *` — `docker-compose.yml:70`) as
  the third unit of the `patron_base` cron hook. **No** internal daily-window throttle (unlike the
  export/reconciliation crons), so it evaluates candidates on every tick.
- Evidence: `patron_base/patron_base.module:163,176` → service `patron_base.scheduled_publish_cron`
  (`patron_base/src/PatronBaseScheduledPublishCron.php:60`). Dossier: FLW0033.

## Input Scope

- Unpublished CMS page nodes (bundles `page` / `page_cz`) whose date-only publish date equals
  **today** in the site default timezone. Selection uses strict equality (`= today`), not `<= today`.
- Runs in system context with access checks disabled; ordered by node id ascending.

## Processing Rules

- Publish each due node (unpublished → published), in nid order.
- Homepage swap (first flagged node only): if a due node carries the replace-homepage flag and the
  homepage has not yet been swapped this run, repoint the `/homepage` alias to the new node, rename
  the previous `/homepage` alias to `/homepage-{oldNid}`, and unpublish the previously-homepaged
  node. A per-run latch ensures at most one homepage swap (lowest nid wins).

## Side Effects

- Content node writes: publish flag flipped on each due node; the prior homepage node unpublished on
  swap. Path-alias writes: old alias renamed, new alias created. See EN0004 for the campaign/story
  domain; note this job targets **CMS pages**, not Campaigns/Stories.
- Each node save triggers the standard content-save pipeline (cache invalidation, and search-index
  enqueue if configured → JOB0013). Downstream node-hook effects are not traced here (Hypothesis).
- Info log summary of published node ids and whether the homepage was swapped.
- No external system calls; no queue of its own.

## Idempotency

- **Idempotent within a day.** Once published, a node has published status and no longer matches the
  `status=0` predicate; the homepage swap is likewise naturally idempotent because the swap source
  becomes published. Re-running the same day is safe.

## Failure Handling

- The publish loop and homepage swap perform several independent saves with **no transaction**; a
  fatal mid-run (e.g. between old-alias rename and new-alias create) can leave `/homepage` with no
  serving alias, with no rollback.
- Any exception is logged and **re-thrown**, aborting the remainder of the platform cron run.
- **Strict-equality miss (data-loss risk):** because selection is `publish_date = today`, a whole
  missed cron day (host down, deploy) means the page is never auto-published and stays unpublished
  until manual action. Documented current-state hazard (FLW0033).

## References

- FN: FN0025
- UC: UC0022, UC0011
- EN: EN0004 (domain contrast — campaign publish is JOB0003, not this job)
- Evidence: FLW0033

## Open Items

- Multi-language homepage: the `/homepage` lookup has no language filter, so which language's
  homepage is swapped on a multi-language site is non-deterministic. `Confirmed` mechanism,
  `Hypothesis` real-world ambiguity.
