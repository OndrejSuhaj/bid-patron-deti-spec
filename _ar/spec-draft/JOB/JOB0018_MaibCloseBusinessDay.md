---
doc_id: JOB0018
title: MAIB Close Business Day
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: batch
references:
  - FN0008
  - ES0003
---

# JOB0018 – MAIB Close Business Day

## Purpose

Close the MD payment gateway (MAIB) business day, settling the day's authorised transactions.
Supports FN0008 (Payment Gateway Integration) for the MD region.

Classification: **Confirmed**.

## Trigger Model

- Batch / CLI (Drush) command `maib:close`. **Externally scheduled** — the source carries the exact
  intended crontab line in a code comment:
  `59 21 * * * docker exec patronus sh -c "cd /var/www/patronus && vendor/bin/drush @self.md-stag maib:close"`
  (i.e. daily at 21:59, MD instance). This is an OS-level cron entry, distinct from the Drupal
  platform cron.
- Evidence: `maib/src/Commands/MaibCommands.php:66` (`@command maib:close`, crontab comment at :62).

## Input Scope

- No local input scope — issues a single "close business day" command to MAIB for the current day.
  MD-only.

## Processing Rules

- POST the close-business-day command to the MAIB gateway; interpret the result (OK vs failure).

## Side Effects

- Outbound close-day call to MAIB (ES0003). No local domain-entity mutation.
- On failure result: Telegram ops alert (FN0023). Result logged.

## Idempotency

- Business-day close is a gateway-side operation; re-issuing on the same day is a gateway concern
  (typically a no-op or benign after the first success). The job itself keeps no local dedup state.

## Failure Handling

- A non-OK gateway result raises a Telegram ops alert and is logged; there is no automatic retry.
- Because it is an OS-cron single-shot, a missed run is a missed close for that day (operational
  concern).

## References

- FN: FN0008, FN0023
- UC: UC0005, UC0006
- ES: ES0003
- Evidence: MaibCommands (`maib:close`)

## Open Items

- The crontab line in source targets the `md-stag` alias; the production alias/host is not evidenced
  in scrubbed source. Secrets (MAIB command auth) are `<redacted>`. `Partial`.
