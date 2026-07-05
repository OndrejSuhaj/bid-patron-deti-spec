---
doc_id: JOB0010
title: Application Auto Status Transition
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: scheduler
references:
  - FN0003
  - EN0001
  - EN0027
---

# JOB0010 – Application Auto Status Transition

## Purpose

Advance Applications from a source status to a target status after they have dwelt in the source
status longer than a configured interval, and run each rule's associated action. Realises FN0003
(Scheduled / Automatic Status Transitions) — the **automatická změna statusu** / cron action
(glossary C044).

Classification: **Confirmed** (cron trigger + config-driven transition loop evidenced).

## Trigger Model

- Scheduled. Runs as the `application_action` cron unit on the platform cron tick (hourly,
  `0 * * * *`). No internal daily throttle.
- Evidence: `application_action/application_action.module:34` →
  `application_action/src/ApplicationActionCron.php:13`. (An older status-snapshot / daily-1pm mailer
  block in the same hook is entirely commented out.)

## Input Scope

- Active application-action rules whose initiator is `cron` (config entities carrying source status,
  target status, dwell interval, and an action name).
- For each rule: Applications currently in the rule's source status whose last-changed timestamp is
  older than the rule's interval. See EN0001, EN0027.

## Processing Rules

- For each matched Application (re-checking it is still in the source status): set it to the target
  status with the CRM-robot actor and save, then run the rule's configured action.

## Side Effects

- Application status transition (new revision + status-history audit row) per matched record, driven
  through the same non-guarded status seam used by FN0002 (so it inherits that fan-out: search-index
  enqueue → JOB0013, status-change events, any transactional message the target status triggers).
- Rule-specific action side effects (the only action evidenced in current sources is remove-patron;
  see FN0003).
- No external system calls of its own.

## Idempotency

- Guarded by the re-check that the Application is still in the source status before transitioning;
  once moved it no longer matches, so re-runs are safe for the transition itself. Any non-idempotent
  rule action is a per-action concern.

## Failure Handling

- The cron hook wraps the run in try/catch and only **logs** (does not re-throw), so a failure does
  not abort the platform cron tick. There is no per-item guard inside the loop.

## References

- FN: FN0003, FN0002
- UC: UC0002 (sub-flow UC0002.3)
- EN: EN0001, EN0027
- Evidence: ApplicationActionCron

## Open Items

- The transition seam performs no server-side transition-legality/role check (see FN0025); the set
  of live cron rules depends on runtime config not present in scrubbed source. `Partial`.
