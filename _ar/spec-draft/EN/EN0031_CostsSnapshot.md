---
doc_id: EN0031
title: CostsSnapshot
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0008
  - BR-ReportingAndDataAccess
  - UC0017
---

# EN0031 — CostsSnapshot

## Purpose

CostsSnapshot represents one month's cost and target figures entered for reporting purposes:
published-campaign counts and cost, monetary cost and cost target, campaign and donation targets,
and a school-lunches ("obědy školákům") student-count and amount target. It is a reporting
projection consumed by the reporting dashboards (see `UC0017`, sub-flow UC0017.3) rather than a
transactional case, party, or money record.

## Lifecycle

Existing — a single, non-workflow state. CostsSnapshot has no domain lifecycle: it is only ever
created (entered) and optionally edited; it does not progress through business states and has no
observed terminal or rejected state.

*Confidence: Low — no writer flow was mined; see Open Questions.*

## State Transitions

(none) — CostsSnapshot has no state machine and no observed status-driven transitions.

- Creation / edit as reporting input: consumed read-only by the reporting dashboard capability,
  trigger: UC0017 (sub-flow UC0017.3). Evidence for this consumption path is Partial — see
  `BR-ReportingAndDataAccess`.

## Attributes

### System-managed attributes

- Author (reference to EN0008 – User; required) — the user recorded as the entry's author.
- Created timestamp (datetime; required)
- Changed timestamp (datetime; required)

### User-provided attributes

- Year (integer, 4-digit; required)
- Month (integer, 1–12; required) — *Conflict: the underlying default value observed for this
  attribute is a string literal rather than an integer; whether month is treated as numeric or
  textual in practice is unresolved. See Open Questions.*
- Published campaign count (integer; optional)
- Published campaign cost (integer; optional)
- Cost (integer; optional)
- Cost target (integer; optional)
- Campaigns target (integer; optional)
- Campaigns target value (integer; optional)
- Donations target value (integer; optional)
- School-lunches ("obědy školákům") student target (integer; optional)
- School-lunches ("obědy školákům") amount target (integer; optional)
- Published flag (boolean; optional) — marks whether the entry is published for reporting display;
  no other status values exist for this attribute.

## Invariants

- Reporting figures held by CostsSnapshot are read-only from the perspective of case, party, money,
  campaign, and contract records — see `BR-ReportingAndDataAccess`.
- CostsSnapshot creation/edit is not gated by a case-style workflow; the only recorded state is the
  published flag (no rule governs transitions between published/unpublished beyond that flag itself).

## Relationships

- EN0008 – User (author of the entry)

## Open Questions

1. Month is declared with integer allowed values (1–12) but the observed default is a string
   literal — is month stored/compared as an integer or as a string in practice? Unresolved.
2. An additional, undeclared dimension-like field is referenced by display configuration but has no
   backing attribute (`Hypothesis` — possibly a dead artifact, or a missing cost-category
   dimension). Unresolved.
3. Whether entries are keyed in manually by finance staff or populated by an automated job is
   unresolved — no writer flow was mined for this entity.
