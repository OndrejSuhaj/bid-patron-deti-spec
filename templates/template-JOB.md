---
doc_id: JOBxxxx
title: <Job Name>
canonical_layer: JOB
spec_type: job-contract
status: draft | canonical
job_type: scheduler
references:
  - FNxxxx
  - ENxxxx
  - ESxxxx
---

# JOBxxxx – <Job Name>

## Purpose

<What this job exists to achieve.>

## Trigger Model

- <schedule / event / queue / poll pattern>
- <open item if exact cadence is not confirmed>

## Input Scope

- <what records or entities the job scans or receives>

## Processing Rules

- <high-level steps only>
- <no implementation mechanics>

## Side Effects

- <created/updated entities>
- <messages or alerts emitted>
- <cross-system writes if relevant>

## Idempotency

- <how duplicate or repeated execution is tolerated or prevented>

## Failure Handling

- <retry / partial completion / alerting / open items>

## References

- FN:
- UC:
- EN:
- ES:

## Open Items

- <unknown trigger cadence or failure semantics>