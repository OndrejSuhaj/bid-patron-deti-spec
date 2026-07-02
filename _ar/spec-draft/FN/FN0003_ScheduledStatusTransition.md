---
doc_id: FN0003
title: Scheduled / Automatic Status Transitions
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0002
  - EN0001
  - EN0027
---

# FN0003 – Scheduled / Automatic Status Transitions

## Purpose

Move Applications (EN0001) that have sat too long in a source status to a configured target status without a
human actor, according to time-based rules (ApplicationAction, EN0027). This is the automatic, cron-driven arm of
the status spine (UC0002.3) — distinct from the human-driven change and the reaction fan-out (FN0002).

## Responsibilities

- Load active auto-transition rules whose trigger is configured as scheduled/cron.
- Select Applications currently in each rule's source status whose dwell time exceeds the rule's age threshold.
- Change each selected Application's status to the rule's target status, attributed to the system service
  account, re-entering the status orchestration seam (FN0002).
- Execute any additional rule-specified action against the Application (e.g. the remove-patron action).

## Related Use Cases

UC0002 (sub-flow UC0002.3).

## Related Entities

EN0001 (subject), EN0027 (auto-transition rule configuration).

## Integrations

None. This capability acts only on the Application (EN0001) aggregate and delegates all onward status effects
to the shared orchestration seam (FN0002); it makes no direct external-system call itself.

## Constraints

- Partial / kept broad: the cron flow itself was not mined; behaviour is grounded only in the EN0027 rule
  configuration, so exact trigger cadence and error handling are inferred, not confirmed.
- Only the remove-patron action is evidenced as implemented among the possible rule actions.
- Transitions re-use the non-guarded status seam (FN0002), so the same non-transactional / no-legality-check
  limits apply.
