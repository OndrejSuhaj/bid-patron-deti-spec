---
doc_id: ARCH0004
title: Risk & Scoring Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
references:
  - ARCH0001
  - ARCH0002
  - EN0016
  - EN0017
  - UC0003
  - FN0004
  - FN0005
  - ES0010
  - ES0011
  - MSG0011
  - BR-ScoringAndRiskGating
---

# ARCH0004 – Risk & Scoring Domain

> Domain navigation document for bounded context **C2 Risk & Scoring** (ARCH0001 §4).
> Navigation layer only — links deeper artifacts by `doc_id`, does not restate them. Current-state.

## Purpose

Explains the architectural perspective of the **risk gate**: how an application is assessed for risk,
scored for the low-risk fast-path, blacklisted, and identity/registry-checked before it can proceed to
a contract and become a public story. This is the gate that guards the case record (C1) between intake
and publication.

---

## System Overview

C2 performs manual risk scoring plus an automatic low-risk recalculation, records white/black
classifications, and verifies applicant identity against Czech government registries. Its **live
scoring data physically rides on the Application record** (as attached JSON); a separate scoring
carrier entity is defined but dormant ([EN0017](../EN/EN0017_ScoringRecord.md); ARCH0001 §4). The
context is modelled as a distinct aggregate because scoring has its own command surface and its own
classification child, even though its live state sits on C1's record.

A defining architectural risk: the scoring approval propagates the classification onto the matching
party by a raw email-keyed write with no bound — a cross-context write into C7's Contact store
(ARCH0002 §(c); the write hazard is HS08).

---

## Structural Components

- **Scoring-&-Risk** (Domain service) — manual score, `to_check` low-risk recalc, blacklist creation,
  party classification. Capability: [FN0004](../FN/FN0004_RiskScoringAssessment.md).
- **Registry / identity verification adapters** (Integration adapters) — the two CZ verification
  boundaries grouped as one capability. Capability:
  [FN0005](../FN/FN0005_ExternalRegistryVerification.md).
- **Resident aggregate AG9 Risk** — root ScoringRecord ([EN0017](../EN/EN0017_ScoringRecord.md));
  member Blacklist ([EN0016](../EN/EN0016_Blacklist.md), classification child requiring an
  Application).

---

## Interaction Model

Per [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(c):

- Invoked **synchronously** from **C1**'s status fan-out on `to_check` (low-risk recalc) and from the
  scoring workflow ([UC0003](../UC/UC0003_AssessApplicantRisk.md);
  [UC0002](../UC/UC0002_OrchestrateApplicationStatusChange.md)).
- On approval, writes back to **C1** (`scoring_ok`) and into **C7 Party / CRM** (Contact
  classification, raw email-keyed, no LIMIT — ARCH0002 §(c)).
- Calls out **synchronously** to two external CZ systems: ARES (business registry) and MVČR
  (invalid-document check) — CZ-scoped only, no RO/MD equivalent; the ARES call has no timeout
  (ARCH0002 §(a); [ES0010](../ES/ES0010_Ares.md), [ES0011](../ES/ES0011_Mvcr.md)).
- A scoring rejection triggers the "Application Rejected — Scoring KO" message via C8
  ([MSG0011](../MSG/MSG0011_ApplicationRejectedScoringKo.md)); approval sends no email (in-zone only).

---

## Cross-links

- **relatedEN:** EN0016, EN0017
- **relatedUC:** UC0003 (participates in UC0002)
- **relatedFN:** FN0004, FN0005
- **relatedES:** ES0010 (ARES), ES0011 (MVČR)
- **relatedMSG:** MSG0011 (scoring-KO rejection; transport owned by C8)
- **relatedBR:** BR-ScoringAndRiskGating
  ([../BR/BR-ScoringAndRiskGating.md](../BR/BR-ScoringAndRiskGating.md)) — the absence of party
  identity uniqueness that makes the classification write hazardous is owned by C7's
  [BR-PartyIdentityAndDeduplication](../BR/BR-PartyIdentityAndDeduplication.md).
