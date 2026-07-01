# Job Contract Documentation Rules (JOB)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

JOB documents describe background execution contracts.

They define:

- why the job exists
- what triggers it
- what input scope it processes
- what side effects it causes
- how it handles failure and idempotency

JOB documents do not describe infrastructure deployment.

---

## Naming

JOBxxxx – <Job Name>

Examples:

JOB0001 – Generate Periodic Invoices
JOB0002 – Poll DataBox Messages

---

## Required Frontmatter

---
doc_id: JOBxxxx
title: <Job Name>
canonical_layer: JOB
spec_type: job-contract
status: draft | canonical
job_type: scheduler | poller | async-consumer | repair | batch
---

Optional:

references:
  - FNxxxx
  - UCxxxx
  - ENxxxx
  - ESxxxx

---

## Recommended Structure

## Purpose
## Trigger Model
## Input Scope
## Processing Rules
## Side Effects
## Idempotency
## Failure Handling
## References
## Open Items

---

## Cross-references (reference, don't restate)

JOB owns background execution contracts (trigger, scope, idempotency, failure handling). It
references other layers by `doc_id` and never restates their content:

- References: `FNxxxx`, `ENxxxx`, `BRxxxx`, `ESxxxx`.
- Never inline (cite instead): rule content (→ `BR`), entity attributes (→ `EN`).

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

JOB documents must not contain:

- infra configuration files
- cron syntax unless contractually required
- queue library names
- worker class names
- container/runtime deployment notes