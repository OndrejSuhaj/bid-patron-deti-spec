# Task — QuerySpecSynthesizer

Run AR:QuerySpecSynthesizer

Load and strictly follow:

tooling/orchestration/04-spec-driven-closure/agents/QuerySpecSynthesizer.md

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
- `_ar/spec-draft/DOMAIN-kernel.md` if present
- `_ar/spec-draft/DOMAIN-aggregates.md` if present
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-QUERY.md` if present
- `tooling/templates/template-QUERY.md` if present

Optional evidence inputs may be used if present.

---

## Deliverables

Create or refresh:

- QUERY files in `_ar/spec-draft/QUERY/`
- `_ar/spec-draft/QUERY-map.md`
- `_ar/spec-draft/QUERY-synthesis-report.md`

Optional:

- `_ar/evidence/query-synthesis-notes.md`

---

## Rules

- Keep one document per stable read-side contract.
- Focus on purpose, source entities, filters, derived outputs, and output intent.
- Do not include SQL or implementation queries.
- Keep uncertain computation rules explicit.

---

## Success condition

This run is successful when:

- major query/report contracts are documented
- read-side semantics are explicit
- unsupported reporting behavior was not invented