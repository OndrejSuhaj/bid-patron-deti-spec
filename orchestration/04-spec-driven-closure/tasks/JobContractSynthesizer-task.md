# Task — JobContractSynthesizer

Run AR:JobContractSynthesizer

Load and strictly follow:

tooling/orchestration/04-spec-driven-closure/agents/JobContractSynthesizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/FN/`
- `_ar/spec-draft/ARCH/`
- `_ar/evidence/flow/`
- `_ar/spec-draft/BR/`
- `_ar/spec-draft/UC/` if present
- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/MSG/` if present
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-JOB.md` if present
- `tooling/templates/template-JOB.md` if present

---

## Deliverables

Create or refresh:

- JOB files in `_ar/spec-draft/JOB/`
- `_ar/spec-draft/JOB-map.md`
- `_ar/spec-draft/JOB-synthesis-report.md`

Optional:

- `_ar/evidence/job-synthesis-notes.md`

---

## Rules

- Keep one document per stable background contract.
- Make trigger model explicit.
- Keep idempotency visible.
- Keep transport/infrastructure details out unless needed for contract meaning.
- Preserve uncertainty instead of inventing scheduler mechanics.

---

## Success condition

This run is successful when:

- major background contracts are documented
- job scope and side effects are explicit
- unsupported scheduler details were not invented