# Task Prompt — SRVCurator (AR)

Run AR:SRVCurator

Load and strictly follow:

tooling/orchestration/01-evidence-collection/agents/SRVCurator.md

Write ONLY to `_ar/spec-draft/**`.

Do not modify any other files.

---

## Pre-execution Checklist

1. SRV Spec Discovery performed:
   - count of SRV spec files found
   - exact paths listed

2. Confirm reading of:
   - `_ar/repo-map/entrypoints.md`
   - `_ar/repo-map/modules.md`
   - `_ar/repo-map/integrations.md`
   - `_ar/evidence/db-inventory.md` if it exists
   - `_ar/evidence/db-models.md` if it exists
   - `_ar/evidence/db-constraints-and-validation.md` if it exists
   - `_ar/spec-draft/EN-candidates.md` if it exists

3. Confirm detected deployables where visible from evidence:
   - backend
   - storefront
   - admin
   - shared modules

Do not proceed if any step is skipped.

---

## Mandatory Execution Phases

1. SRV Spec Discovery
2. Structural Discovery
3. Candidate Drafting
4. SRV Consolidation
5. SRV Smell Detection
6. Target SRV Map Proposal

All phases are required.

---

## Candidate Requirements

A Confirmed SRV must have:

- at least one Trigger
- at least one Input evidence
- at least one Output evidence

If missing, classify it as a Transitional SRV.

Each SRV must include:

- SRV Category
- Bounded Context
- Responsibility Type
- Deployment or Location when visible from evidence

---

## Prohibited

- deriving SRVs from passive join tables without behavior evidence
- inventing behavior
- skipping consolidation
- skipping architectural validation

---

## Required Deliverables

Write or update:

- `_ar/spec-draft/SRV-candidates.md`
- `_ar/spec-draft/SRVxxxx_<Name>.md` one file per SRV

`SRV-candidates.md` must include:

1. SRV Spec Discovery summary
2. Bounded Context map
3. Promotion table
4. Consolidation decisions
5. Smell detection summary
6. Proposed Target SRV Structure
7. Tiered gap list:
   - Tier 1
   - Tier 2
   - Tier 3

Do NOT write outside `_ar/spec-draft/**`.
Do NOT modify production code.