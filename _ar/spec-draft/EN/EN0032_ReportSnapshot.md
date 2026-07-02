---
doc_id: EN0032
title: ReportSnapshot
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0008
  - BR-ReportingAndDataAccess
  - UC0017
---

# EN0032 — ReportSnapshot

## Purpose

ReportSnapshot represents a single named reporting metric — a metric name and its value, tagged
with a report identifier and captured at a point in time — so that reporting dashboards can query
metric values over a date range. It is a generic key/value reporting projection consumed by the
reporting dashboards (see `UC0017`, sub-flow UC0017.3), not a transactional case, party, or money
record.

*Confidence: Low — see Open Questions.*

## Lifecycle

Existing — a single, non-workflow state. ReportSnapshot has no domain lifecycle: rows are captured
once and read back by range query; there is no observed update, delete, or status-driven progression.

*Confidence: Low — no writer flow was mined; see Open Questions.*

## State Transitions

(none) — ReportSnapshot has no state machine and no observed status-driven transitions.

- Creation: rows are captured (presumably by a reporting/snapshot job) — `Hypothesis`, no writer
  flow mined; see Open Questions.
- Read: consumed read-only by the reporting dashboard capability, filtered by report identifier and
  a date range on the capture timestamp, trigger: UC0017 (sub-flow UC0017.3). Evidence for this
  consumption path is Partial — see `BR-ReportingAndDataAccess`.

## Attributes

### System-managed attributes

- Author (reference to EN0008 – User; required) — the user recorded as the entry's author.
- Captured timestamp (datetime; required) — the point-in-time the metric was captured; also used as
  the range-query key when reports filter by date range.
- Changed timestamp (datetime; required)

### User-provided attributes

- Report identifier (string, max 50; required) — filter/grouping key identifying which report a
  metric row belongs to.
- Metric name (string, max 50; required) — the name of the captured metric.
- Metric value (string, max 50; required) — the captured value for the metric; *Open Question — see
  below on numeric handling.*

A status-like attribute is declared at the data-model level with no allowed values and no observed
use in creating, editing, or filtering rows — `Conflict`, not carried forward as a canonical
lifecycle state; see Open Questions.

## Invariants

- Reporting figures held by ReportSnapshot are read-only from the perspective of case, party, money,
  campaign, and contract records — see `BR-ReportingAndDataAccess`.
- ReportSnapshot capture is not gated by a case-style workflow; no rule governs transitions between
  states beyond the absence of one (see Lifecycle).

## Relationships

- EN0008 – User (author of the entry)

## Open Questions

1. What captures a ReportSnapshot row and on what cadence (scheduled job vs. manual entry) is
   unresolved — no writer flow was mined for this entity.
2. Metric value is held as a short text value — whether/how numeric metrics are aggregated or cast
   when reports read them back is unresolved.
3. A status-like attribute is declared without any allowed values or observed use — whether this is
   dead scaffolding or an unused reporting dimension is unresolved (`Conflict`).
