# Task — FNSynthesizer

Run AR:FNSynthesizer

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/FNSynthesizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/EN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/ARCH/` if present
- `_ar/spec-draft/SRV-target-list.md` if present
- `_ar/spec-draft/SRV-flow-traceability.md` if present
- `_ar/spec-draft/EN-lifecycle-evidence.md` if present
- `_ar/evidence/flow/` if present
- `_ar/spec-draft/BR/` if present
- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/MSG/` if present
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-FN.md` if present
- `tooling/templates/template-FN.md` if present

---

## Deliverables

Create or refresh:

- FN files in `_ar/spec-draft/FN/`
- `_ar/spec-draft/FN-capability-map.md`
- `_ar/spec-draft/FN-synthesis-report.md`

Optional:

- `_ar/evidence/fn-synthesis-notes.md`

---

## Rules

- Keep the FN layer capability-oriented and implementation-agnostic.
- Do not mirror SRV one-to-one.
- Do not mirror FLOW one-to-one.
- If evidence is too orchestration-heavy, keep capabilities broader and record the reason.


