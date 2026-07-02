---
doc_id: FN0004
title: Risk Scoring & Assessment
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0003
  - UC0002
  - EN0017
  - EN0016
  - EN0001
  - EN0006
---

# FN0004 – Risk Scoring & Assessment

## Purpose

Assess the risk of an applicant case and produce a risk verdict — a manual scoring outcome and an automatic
low-risk score — that gates the case's progression (e.g. into `scoring_ok`) and classifies the involved parties.
This is the C2 risk capability exercised by UC0003 and re-invoked from the status spine (UC0002).

## Responsibilities

- Persist the manual scoring outcome (ScoringRecord, EN0017) for a case, including the ok/ko verdict.
- Recompute the derived low-risk score on the Application (EN0001) when the case enters the risk-review status
  (`to_check`), and support a coordinator low-risk override.
- Set the Application to `scoring_ok` only from the scoring-control status as part of an approval.
- Classify the involved parties (Contact, EN0006) with a white/black risk classification and create the
  corresponding blacklist entries (Blacklist, EN0016) tied to the case.
- Delegate identity/registry verification lookups to FN0005.

## Related Use Cases

UC0003 (primary), UC0002 (the `to_check` recalc leg).

## Related Entities

EN0017 (scoring outcome), EN0016 (blacklist entries), EN0001 (case + attached low-risk score), EN0006 (party
classified).

## Integrations

None directly — external identity/registry checks are isolated in FN0005.

## Constraints

- The live scoring data physically rides on the Application record as JSON; a separate scoring-carrier entity is
  defined but dormant / has no evidenced writer (Hypothesis).
- The party classification write is a raw, email-keyed update with no row limit — it can overwrite classification
  on unrelated Contacts sharing the email (a cross-aggregate hazard).
- Scoring, case-status, and party-classification writes span aggregates in one non-transactional flow.
