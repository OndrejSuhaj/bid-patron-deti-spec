# Task — ENCanonicalizer

Run AR:ENCanonicalizer

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/ENCanonicalizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/EN/`
- `_ar/spec-draft/UC/` if present
- `_ar/spec-draft/FN/` if present
- `_ar/spec-draft/BR/` if present
- `_ar/spec-draft/ARCH/` if present
- `_ar/spec-draft/DOMAIN-kernel.md` if present
- `_ar/spec-draft/DOMAIN-aggregates.md` if present
- `_ar/spec-draft/DOMAIN-ubiquitous-language.md` if present
- `_ar/spec-draft/EN-lifecycle-evidence.md` if present
- `_ar/evidence/flow/` if present
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-EN.md` if present
- `tooling/templates/template-EN.md` if present

---

## Deliverables

Create or refresh:

- canonical EN files in `_ar/spec-draft/EN/`
- `_ar/spec-draft/EN-canonicalization-map.md`
- `_ar/spec-draft/EN-canonicalization-report.md`

Optional:

- `_ar/evidence/en-canonicalization-notes.md`

---

## Rules

- Refresh existing EN files in place.
- Remove implementation leakage from main EN text.
- Preserve business meaning, relations, invariants, lifecycle, and state transitions.
- Move unresolved implementation evidence to the report.