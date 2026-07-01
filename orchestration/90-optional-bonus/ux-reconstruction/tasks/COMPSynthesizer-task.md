# Task — COMPSynthesizer

Run AR:COMPSynthesizer

Load and strictly follow:

tooling/orchestration/90-optional-bonus/ux-reconstruction/agents/COMPSynthesizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify `_ar/coverage/**` or production code. WIRE edits limited to replacing an `inline`
flag with a new `COMPxxxx` reference.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/WIRE/`, `_ar/spec-draft/WIRE-screen-coverage.md`
- `_ar/evidence/ui/ui-observed-areas.md`, `_ar/prtsc/**`
- `_ar/spec-draft/EN/`, `_ar/spec-draft/ACL/` if present
- `_ar/evidence/runtime/prtsc/**` if present
- `_ar/repo-map/glossary.md`
- `tooling/docs/rules-COMP.md`, `tooling/templates/template-COMP.md` if present

---

## Deliverables

- COMP files in `_ar/spec-draft/COMP/` (only for components with evidenced reuse)
- `_ar/spec-draft/COMP-inventory-map.md`
- `_ar/spec-draft/COMP-synthesis-report.md`

---

## Rules

- Create a COMP ONLY when reuse is observable across ≥2 WIRE screens; otherwise leave as WIRE `inline`.
- Cover the six states or declare `N/A`/`Uncertain`; mark unobservable a11y as Uncertain — do not fabricate.
- Reference EN (typed props), ACL (visibility), and sub-COMP (composition) by doc_id; never inline.
- `modules: []` default; classify claims and cite reuse evidence.
