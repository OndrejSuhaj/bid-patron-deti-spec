---
doc_id: JOB0003
title: Campaign Lifecycle Deadline Sweep
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: scheduler
references:
  - FN0006
  - EN0004
  - EN0001
  - MSG0015
---

# JOB0003 – Campaign Lifecycle Deadline Sweep

## Purpose

Sweep active Stories/Campaigns past their deadline that have not reached their gift target and
auto-transition them to the uncompleted state, notifying supporters. Also runs money-integrity
diagnostics and (behind a feature flag) campaign image blurring. Realises the deadline arm of
FN0006 (Campaign / Story Lifecycle Management).

Classification: **Confirmed** (deadline path); auto-complete-on-target is **not** in this job (see
Open Items — it lives in the entity save path).

## Trigger Model

- Scheduled. Runs on every platform cron tick (hourly, `0 * * * *`) via the `campaign` cron hook.
- The diagnostic and blur sub-steps are further gated: money diagnostics run only in production and
  self-throttle daily (state keys seeded at 02:00 / 08:00); the deadline sweep runs in **every**
  environment on every tick (no throttle).
- Evidence: `campaign/campaign.module:223` → `campaign/src/CampaignCron.php:15`. Dossier: FLW0022.

## Input Scope

- Deadline sweep: active Campaigns whose deadline is before today and whose raised total is below
  the gift target (selected by SQL join Application→Campaign). Returns application ids.
- Money diagnostics (prod, daily): all campaigns (raised-money recompute vs stored value) and
  campaigns where raised exceeds gift price.
- Blur (feature-flag only): up to 10 campaigns past a persisted completed-cursor.

## Processing Rules

- For each over-deadline under-funded application: set state to the uncompleted state with the
  CRM-robot actor and save. The heavy work is in the entity save cascade, not the loop itself.
- Money diagnostics only alert (Telegram/Slack) on mismatch — **no** entity writes.
- Blur overwrites on-disk campaign image files in place and regenerates image styles.

## Side Effects

- Application → uncompleted state (new revision + status-history audit row); its Campaign →
  uncompleted status with timestamp, raised total refreshed (via the save cascade). See EN0001, EN0004.
- "Uncompleted campaign" / unfulfilled-collection message queued to supporters and admins
  (MSG0015 via FN0019 → JOB0014 mailing queue).
- Application and Campaign enqueued for search re-index (→ JOB0013); status-change events dispatched
  (FN0002 fan-out).
- Ops diagnostics: Telegram/Slack alerts (FN0023). Blur: destructive file overwrite (flag-gated).
- Persisted state cursor writes (throttle keys, blur cursor).

## Idempotency

- **Deadline transition is idempotent** via the SQL predicate: once flipped to uncompleted the
  campaign no longer matches `status=active`, so re-runs skip it.
- Caveat: the uncompleted-campaign message send has no is-sent guard set on this path, so if the
  status flip and message were ever decoupled, duplicate messages are possible (Hypothesis; single
  run is safe). Blur advances its cursor even on unwritable files (silent permanent skip).

## Failure Handling

- The status-history insert is wrapped in try/catch, logged (Telegram), and **re-thrown**; because
  the deadline loop is not per-item guarded, a single bad application can abort the whole cron run.
- Money-diagnostic and blur errors are contained to their sub-steps.

## References

- FN: FN0006, FN0002, FN0019, FN0023
- UC: UC0011
- EN: EN0004, EN0001
- MSG: MSG0015 (collection unfulfilled)
- Evidence: FLW0022

## Open Items

- **Scope correction (Confirmed):** auto-completion on raised ≥ target is NOT performed by this
  job; it lives in the Campaign entity save path and fires on any campaign save (payment-driven).
  Recorded so the rebuild does not co-locate it in the cron.
- RO working-day / holiday checks and Firebase sync are NOT in this path (dead / validation-time
  only). See FLW0022 Corrections.
