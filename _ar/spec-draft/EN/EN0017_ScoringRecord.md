---
doc_id: EN0017
title: ScoringRecord
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — scoring snapshot and low-risk score are attributes of the Application
  - EN0002  # ApplicationProfile — fundraiser/patron profile data consumed to compute scoring
  - EN0006  # Contact — blacklist classification propagated by scoring
  - EN0016  # Blacklist — risk-list entries created alongside scoring
  - BR-ScoringAndRiskGating
  - UC0003
---

# EN0017 — ScoringRecord

## Purpose

ScoringRecord represents the risk-assessment outcome for an Application (EN0001): the manually
reviewed scoring assessment (fundraiser, patron, gift, and child risk factors, an approval verdict,
and a blacklist classification decision) together with a system-derived low-risk score and its
per-component breakdown. It is the record that gates whether an Application may advance toward
fulfilment and that drives the risk classification propagated onto the Contact (EN0006) and
Blacklist (EN0016) records.

ScoringRecord has no independent identity or lifecycle of its own: the manual scoring snapshot and
the low-risk score are carried as attributes of the Application (EN0001) they assess, not as a
separate addressable record. A separate carrier for scoring data, keyed by an arbitrary scored-entity
name and identifier, is defined in the domain but is not produced by any current-state process —
Status: Planned/dormant.

---

## Lifecycle

ScoringRecord does not have its own lifecycle states. It is produced and refreshed as a byproduct of
Application (EN0001) lifecycle events:

- **Absent** — no scoring assessment has yet been recorded for the Application.
- **Manually assessed** — a scoring verdict and supporting fields have been submitted and persisted for
  the Application.
- **Low-risk assessed** — a system-derived low-risk score and breakdown have been computed and
  persisted for the Application.

These are not mutually exclusive: an Application may carry a low-risk assessment, a manual assessment,
or both concurrently, each independently refreshed.

---

## State Transitions

Absent → Manually assessed
trigger: UC0003 (UC0003.1 — manual risk scoring)

Manually assessed → Manually assessed (re-assessed)
trigger: UC0003 (UC0003.1 — every scoring form submission re-persists the snapshot)

Absent → Low-risk assessed
trigger: UC0003 (UC0003.2 — automatic low-risk scoring on Application state change)

Low-risk assessed → Low-risk assessed (recomputed)
trigger: UC0003 (UC0003.2 — recomputed on each qualifying Application state change)

---

## Attributes

### System-managed attributes

- Low-risk score (integer; optional; total derived risk score; recorded as unavailable when required
  actor or profile data is missing; see BR-ScoringAndRiskGating)
- Low-risk breakdown (structured; optional; per-component contributions underlying the low-risk score)
- Assessing user (reference to EN0008 – User; optional; the Admin who performed the manual assessment)
- Assessment recorded at (timestamp; system-managed)
- Assessment assigned at (timestamp; optional)

### User-provided attributes

- Fundraiser risk fields (structured; conditional; fundraiser-related assessment inputs, values:
  ok/ko per field)
- Patron risk fields (structured; conditional; patron-related assessment inputs, values: ok/ko per
  field)
- Gift risk fields (structured; conditional; gift-related assessment inputs, values: ok/ko per field)
- Coordinator note (text; optional)
- Coordinator decision (boolean; optional)
- Approval verdict (string; required for manual assessment; the submitted scoring decision, e.g.
  approved/not approved/intermediate; gates the Application transition, see BR-ScoringAndRiskGating)
- Blacklist classification (reference to EN0016 – Blacklist; conditional; classification selected for
  the fundraiser and/or patron during assessment)

---

## Invariants

- The manual assessment and the low-risk assessment are independently maintained representations of
  scoring for the same Application and may both exist without one superseding the other; see
  BR-ScoringAndRiskGating.
- Advancing the Application's status as a result of scoring is gated by rules defined in
  BR-ScoringAndRiskGating (approval-verdict gate and coordinator low-risk-threshold override), not by
  ScoringRecord itself.
- A blacklist classification produced during assessment is reflected onto the Contact (EN0006) record;
  scope and hazard characteristics of that propagation are governed by BR-ScoringAndRiskGating.
- The dormant scored-entity carrier is not populated by any current-state process; see Open Questions.

---

## Relationships

- EN0001 – Application (the entity the scoring assessment and low-risk score are attached to)
- EN0002 – ApplicationProfile (fundraiser/patron profile data consumed to compute the assessment)
- EN0006 – Contact (party record whose blacklist classification is updated as a side effect of
  assessment)
- EN0016 – Blacklist (risk-list entry created alongside a manual assessment)

---

## Open Questions

1. Is the dormant scored-entity carrier (a generic, entity-agnostic scoring-JSON store keyed by a
   scored-entity name and identifier) legacy/abandoned, or intended to be fed by an out-of-scope or
   external client? No current-state process produces records for it. Hypothesis — Not evidenced in
   current sources.
2. Relationship between the manually assessed representation and the low-risk assessed representation:
   are both consumed downstream on an ongoing basis, or does one representation supersede the other
   once produced? Conflict — requires clarification.
3. The low-risk score computation reads patron-side occupation and gift-payment inputs from the
   fundraiser's profile (EN0002) rather than the patron's — see BR-ScoringAndRiskGating for the
   current-state owner-coupling this produces.
