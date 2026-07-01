# Task Prompt — UCComposer (AR)

Run AR:UCComposer

Load and strictly follow:

tooling/orchestration/02-system-reconstruction/agents/UCComposer.md

Write ONLY to `_ar/spec-draft/**`.

---

## Pre-check

Confirm reading of:

### Architecture inputs
- `_ar/spec-draft/SRV-architecture-map.md`
- `_ar/spec-draft/SRV-target-list.md`
- `_ar/spec-draft/SRV-candidates.md`

### Entity inputs
- all `EN*.md` files under `_ar/spec-draft/`

### Flow evidence inputs
- `_ar/evidence/flow-index.md`
- `_ar/spec-draft/FLOW-candidates.md`
- `_ar/spec-draft/SRV-flow-traceability.md` if it exists
- `_ar/spec-draft/EN-lifecycle-evidence.md` if it exists

### Coverage inputs
- `_ar/coverage/unmapped.md` if it exists

---

## Deliverables

Create or update:

- `_ar/spec-draft/UC-candidates.md`
- `_ar/spec-draft/UC-srv-traceability.md`
- one UC file per root-level UC

---

## Format constraints

Every Main Flow step must be prefixed with an actor and colon.

Examples:

- Customer:
- Admin:
- System:
- External(<System>):

Alternative flows must follow the same rule.

---

## Flow-aware constraint

When FlowMiner evidence exists:

- prefer those flows as UC anchors
- reference FlowIDs in Traceability
- do not invent flows that contradict mined evidence