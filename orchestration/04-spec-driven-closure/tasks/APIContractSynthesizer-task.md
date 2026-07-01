# Task — APIContractSynthesizer

Run AR:APIContractSynthesizer

Load and strictly follow:

tooling/orchestration/04-spec-driven-closure/agents/APIContractSynthesizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/EN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/FN/`
- `_ar/spec-draft/BR/`
- `_ar/spec-draft/ARCH/`
- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/MSG/` if present
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-API.md` if present
- `tooling/templates/template-API.md` if present

---

## Deliverables

Create or refresh:

- API files in `_ar/spec-draft/API/`
- `_ar/spec-draft/API-contract-map.md`
- `_ar/spec-draft/API-synthesis-report.md`

Optional:

- `_ar/evidence/api-synthesis-notes.md`

---

## Rules

- Keep one document per stable API contract.
- Prefer business-facing contract names.
- Distinguish command and query contracts.
- Do not prescribe uncertain payload fields.
- Do not define controller/framework implementation.
- Keep API contracts aligned with EN, UC, FN, BR, and glossary.

---

## Success condition

This run is successful when:

- API layer is traceable to canonical artifacts
- major contract surfaces are documented
- uncertain fields remain explicit
- no unsupported endpoints were introduced