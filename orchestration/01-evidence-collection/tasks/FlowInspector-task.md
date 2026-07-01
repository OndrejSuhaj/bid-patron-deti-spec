# Task Prompt — FlowInspector (AR)

Run AR:FlowInspector

Load and strictly follow:

tooling/orchestration/01-evidence-collection/agents/FlowInspector.md

Write ONLY to `_ar/**`.

---

## Pre-execution Checklist

Confirm reading of:

- `_ar/spec-draft/SRV-architecture-map.md`
- `_ar/spec-draft/SRV-target-list.md`
- `_ar/repo-map/entrypoints.md` if it exists
- `_ar/repo-map/modules.md` if it exists
- `_ar/repo-map/integrations.md` if it exists
- `_ar/evidence/db-inventory.md` if it exists
- `_ar/coverage/mapped.md` if it exists
- `_ar/coverage/unmapped.md` if it exists
- `_ar/spec-draft/FLOW-risk-heuristics.md` if it exists

List which of the above files exist and which are missing.

Do not proceed if `_ar/spec-draft/SRV-architecture-map.md` or `_ar/spec-draft/SRV-target-list.md` are missing.

---

## Mandatory Execution Phases

1. Trigger Discovery
2. Flow Candidate Identification
3. SRV Mapping
4. Entity Touchpoint Scan
5. Integration Boundary Detection
6. Risk Tagging

All phases are required.

---

## Flow Candidate Requirements

Each flow MUST contain:

- FlowID
- TriggerType
- TriggerEvidence
- Primary SRV Candidate
- Entity Touchpoints
- Integration Boundaries
- Risk Tags
- Depth Recommendation
- Confidence Level

If evidence is weak, mark `Hypothesis`.

---

## Risk Tag Set

Use one or more of:

- Money/VAT
- Async
- External Integration
- Multi-tenant
- Security
- Legal/Gov
- Data Loss
- Idempotence

---

## Prohibited

- deep reconstruction of flow logic
- writing Use Cases
- writing Entity pages
- modifying SRV documents
- inventing behavior

FlowInspector only discovers where flows exist.

---

## Required Deliverables

Create or update:

- `_ar/evidence/flow-index.md`
- `_ar/spec-draft/FLOW-candidates.md`

Optional but recommended:

- `_ar/spec-draft/FLOW-trigger-map.md`

---

## Exit Criteria

FlowInspector run is valid only if:

- at least 30 flows are discovered, or all if fewer exist
- at least 15 flows are recommended for mining
- every discovered flow is mapped to a Primary SRV
- at least 5 high-risk flows are identified