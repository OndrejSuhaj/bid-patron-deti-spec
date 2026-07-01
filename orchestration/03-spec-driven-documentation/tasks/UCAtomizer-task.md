# Task — UCAtomizer

Run AR:UCAtomizer

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/UCAtomizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/UC/`
- `_ar/spec-draft/EN/`
- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/SRV-target-list.md` if useful
- `_ar/spec-draft/SRV-flow-traceability.md` if useful
- `_ar/spec-draft/EN-lifecycle-evidence.md` if useful
- `_ar/evidence/flow/` if useful
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-UC.md` if present
- `tooling/templates/template-UC.md` if present

---

## Deliverables

Create or refresh:

- new atomized UC files in `_ar/spec-draft/UC/`
- `_ar/spec-draft/UC-atomization-map.md`
- `_ar/spec-draft/UC-atomization-report.md`

Optional:

- `_ar/evidence/uc-atomization-notes.md`

---

## Rules

- Keep the new UC layer smaller in granularity and more domain-oriented.
- Preserve origin continuity through numbering and decomposition origin.
- Do not introduce implementation detail.
- If a split is not safely supported, leave the UC grouped and record the reason.