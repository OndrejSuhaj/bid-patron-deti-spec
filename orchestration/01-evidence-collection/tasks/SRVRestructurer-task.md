# Task Prompt — SRVRestructurer (AR)

Run AR:SRVRestructurer

Load and strictly follow:

tooling/orchestration/01-evidence-collection/agents/SRVRestructurer.md

Write ONLY to `_ar/spec-draft/**`.

Do not modify any other files.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/SRV-candidates.md`
- all `_ar/spec-draft/SRV*.md`
- `_ar/spec-draft/EN-candidates.md` if it exists
- `_ar/repo-map/modules.md` if it exists
- `_ar/repo-map/integrations.md` if it exists

If some optional files are missing, report them and proceed with what exists.

---

## Required Deliverables

Create or update:

- `_ar/spec-draft/SRV-architecture-map.md`
- `_ar/spec-draft/SRV-restructuring-actions.md`
- `_ar/spec-draft/SRV-target-list.md`

Also append to:

- `_ar/spec-draft/SRV-candidates.md`

using the section title:

`Architecture-First Restructuring Summary`

---

## Execution Rules

- Do NOT discover new SRVs from code.
- Use only existing SRV drafts, SRV candidates, and allowed context files.
- Do NOT modify prior SRV drafts.
- Do NOT modify EN drafts.
- Do NOT invent behavior or hidden responsibilities.
- If metadata is missing, state:
  - `Unclear from SRV drafts`

---

## Exit Criteria

The run is valid only if:

- the four-layer taxonomy is applied
- restructuring actions are explicit
- the target SRV list is traceable to source SRVs
- the append-only summary was added to `SRV-candidates.md`