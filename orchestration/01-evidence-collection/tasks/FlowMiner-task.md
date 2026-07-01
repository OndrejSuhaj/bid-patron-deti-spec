# Task Prompt — FlowMiner (AR)

Run AR:FlowMiner

Load and strictly follow:

tooling/orchestration/01-evidence-collection/agents/FlowMiner.md

Write ONLY to `_ar/**`.

---

## Pre-execution Checklist

Confirm reading of:

- `_ar/spec-draft/SRV-architecture-map.md`
- `_ar/spec-draft/SRV-target-list.md`
- `_ar/evidence/flow-index.md`
- `_ar/spec-draft/FLOW-candidates.md`
- `_ar/evidence/db-inventory.md` if it exists
- `_ar/evidence/db-models.md` if it exists
- `_ar/evidence/db-constraints-and-validation.md` if it exists
- `_ar/repo-map/integrations.md` if it exists
- `_ar/coverage/unmapped.md` if it exists

List which exist and which are missing.

Do not proceed if `_ar/evidence/flow-index.md` is missing.

---

## Scope Selection

Select flows for mining:

- default: top 10 flows from `_ar/spec-draft/FLOW-candidates.md`
- maximum: 20 flows per run

Each mined flow must reference a FlowID.

---

## Mandatory Execution Phases

1. Trigger Trace
2. Orchestration Trace
3. Side Effect Discovery
4. Data Footprint Mapping
5. Integration Detection
6. Failure Mode Discovery

All phases are required.

---

## Prohibited

- writing UC documents
- writing EN documents
- redesigning SRVs
- copying implementation code
- adding UI-level descriptions

FlowMiner produces behavior evidence, not design documents.

---

## Required Deliverables

Create:

- `_ar/evidence/flow/FLWxxxx_<slug>.md` one file per flow

Update:

- `_ar/spec-draft/SRV-flow-traceability.md`

Optional:

- `_ar/spec-draft/EN-lifecycle-evidence.md`

---

## Exit Criteria

FlowMiner run is valid only if:

- at least 10 flow dossiers were created unless fewer flows exist
- each dossier contains Behavior Digest, Data Footprint, and Evidence Block
- `SRV-flow-traceability.md` was updated
- at least 5 architectural risks were detected