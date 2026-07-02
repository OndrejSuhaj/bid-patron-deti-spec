---
doc_id: ES0011
title: MVČR (invalid-document check)
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0005
  - UC0003
---

# ES0011 – MVČR (invalid-document check)

## Purpose

MVČR feeds the risk gate with an authoritative signal on whether a Czech identity/ID-card document
presented on an Application is recorded as invalid, so scoring (`FN0005`) can factor a government
document-validity result into the applicant risk decision without the platform itself being the
authority on document validity.

---

## System Overview

MVČR is the Czech Ministry of the Interior's invalid-documents register — a government registry
that reports, for a given ID document, whether that document is currently recorded as invalid. It is
one of the government-registry boundaries named in the Integration Landscape (`ARCH0001` §5, row 12;
also listed among the "government registries" in `ARCH0001` §2), grouped with `ARES` under the same
CZ registry/identity-verification role in `FN0005` but a distinct external boundary from it — MVČR
answers a document-validity question, ARES answers a business-registry question.

---

## Integration Model

Outbound. The platform performs a document-validity lookup against MVČR as part of the scoring
identity check (`UC0003`), at the point where identity-card numbers named on the Application are
validated. This is a synchronous, on-demand call made during scoring (`ARCH0002` (a) synchronous
external), not a scheduled or bidirectional exchange — there is no inbound callback or feed from
MVČR into Patronus.

---

## Data Exchange

Outbound: an ID-card/document identifier to check, submitted for parties named on the Application
during scoring. Inbound: an invalid/valid indication for that document. This is conceptual only — no
request/response payload or field-level detail is asserted here; the identity data the check is
performed against is owned by `EN0006`, not restated in this document.

---

## Constraints

- **Failure impact:** if the document-validity check is unavailable, the risk gate is degraded rather
  than blocked — scoring proceeds without a confirmed document-validity result (`ARCH0001` §5 row 12;
  `UC0003`).
- **Scope:** CZ-scoped only; there is no RO or MD equivalent of this check (`FN0005`).
- **Boundary distinctness:** part of the CZ registry/identity-verification adapter cluster documented
  as one capability in `FN0005`, but MVČR is a separate external-system boundary from `ARES` — the two
  must not be merged into a single ES.
- **Current-state only:** this reflects the integration as evidenced today; no target-state change is
  asserted here.
