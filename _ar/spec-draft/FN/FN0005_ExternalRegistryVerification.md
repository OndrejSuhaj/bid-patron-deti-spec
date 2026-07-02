---
doc_id: FN0005
title: External Registry & Identity Verification
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0003
  - EN0001
  - EN0006
---

# FN0005 – External Registry & Identity Verification

## Purpose

Verify applicant identity and business details against external government/registry sources during risk
assessment — CZ business-registry lookup (ARES) and CZ invalid-document / identity-card verification (MVČR) — so
that scoring (FN0004) can gate a case on verified data. Clusters the two verification adapter boundaries into one
capability.

## Responsibilities

- Perform a business-registry lookup (ARES) by company number to enrich/verify organisation and applicant
  business details during scoring.
- Perform an identity-document validity check (MVČR) to detect invalid/blocked documents in the risk gate.
- Return verification results to the scoring capability (FN0004); each lookup is invoked live per request —
  no caching layer is evidenced.

## Related Use Cases

UC0003 (scoring lookups).

## Related Entities

EN0001 (case under assessment), EN0006 (party whose identity/business is verified).

## Integrations

ARES (CZ business registry), MVČR (CZ invalid-document / identity-card check).

## Constraints

- CZ-scoped registries; no equivalent verification for RO/MD is evidenced.
- The ARES lookup has no timeout on the call — a hanging registry can stall the enclosing request.
- Failure degrades the risk gate rather than blocking it (verification-unavailable is tolerated).
