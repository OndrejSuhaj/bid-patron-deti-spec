---
doc_id: BR-ScoringAndRiskGating
title: Scoring & Risk Gating
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0017
  - EN0016
  - EN0001
  - EN0006
  - EN0002
  - SYSTEM
references:
  - EN0017
  - EN0016
  - EN0001
  - EN0006
  - EN0002
  - UC0003
  - UC0002
---

# BR – Scoring & Risk Gating

## Purpose

Governs the risk gate that a case (EN0001) must clear: the derived low-risk score, the manual scoring
approval threshold and status gate, blacklist creation, external verification degradation, and the
resulting party classification write.

## Derived low-risk score

- The case's (EN0001) low-risk score SHALL be recomputed as a derived value whenever the case enters
  the risk-review status, and SHALL be recorded as unavailable when required actor or profile data
  (EN0002) is missing.
- Current-state: the low-risk score reads occupation and gift-payment inputs from the fundraiser
  profile (EN0002) regardless of which party the input logically belongs to — a recorded
  owner-coupling defect.

## Scoring approval and status gate

- A scoring approval SHALL set the case (EN0001) to the scoring-approved status only when the case is
  currently in the scoring-control status and the submitted verdict is approve.
- A coordinator low-risk override SHALL be permitted to set the case (EN0001) to the scoring-approved
  status only when the low-risk score meets or exceeds the approval threshold and the case is in an
  eligible status.
- A scoring verdict other than approve SHALL persist the scoring outcome (EN0017) and any blacklist
  classification (EN0016) without changing the case's (EN0001) status.

## Blacklist and party classification

- Each blacklist entry (EN0016) SHALL be linked to the case (EN0001) that produced it.
- A scoring approval SHALL propagate the resulting white/black risk classification onto the matching
  party record (EN0006).
- Current-state: the party-classification write onto EN0006 is keyed by e-mail address with no limit
  on the number of records affected, and SHALL be treated as a recorded hazard — it can overwrite the
  classification of unrelated parties that share that e-mail address.
- Current-state: the scoring decision, the case status change, and the party classification write span
  the case aggregate (EN0001) and the party store (EN0006) in one non-transactional flow.

## External verification

- External identity-document and business-registry verification SHALL be consulted to support the risk
  gate for the CZ country only; no equivalent verification is provided for the RO or MD countries.
- Current-state: unavailability of either external verification SHALL degrade the risk gate rather than
  block it, and the business-registry lookup carries no call timeout.

## Non-Goals

- This rule does not define the case status vocabulary or the full status lifecycle of the case
  (EN0001) — see BR-ApplicationStatusGovernance.
- This rule does not define party-identity uniqueness or deduplication; the absence of uniqueness on
  the party store (EN0006) that makes the e-mail-keyed classification write hazardous is owned by
  BR-PartyIdentityAndDeduplication and is only referenced here.
- This rule does not prescribe target-state fixes (transactional scope, a scoped classification write,
  call timeouts); it records current-state behaviour only.
