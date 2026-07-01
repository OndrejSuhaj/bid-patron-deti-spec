# Task — BRExtractor

Run AR:BRExtractor

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/BRExtractor.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/FN/`
- `_ar/spec-draft/EN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/ARCH/` if present
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/MSG/` if present
- `_ar/spec-draft/BR/` if present
- `_ar/spec-draft/DOMAIN-kernel.md` if present
- `_ar/spec-draft/DOMAIN-aggregates.md` if present
- `_ar/spec-draft/DOMAIN-ubiquitous-language.md` if present
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-BR.md` if present
- `tooling/templates/template-BR.md` if present

---

## Deliverables

Create or refresh:

- canonical BR files in `_ar/spec-draft/BR/`
- `_ar/spec-draft/BR-rule-map.md`
- `_ar/spec-draft/BR-extraction-report.md`

Optional:

- `_ar/evidence/br-extraction-notes.md`

---

## Rules

- Refresh existing canonical BR files in place.
- Preserve existing grouped BR structure when present.
- Keep BR rule-oriented, deterministic, and implementation-agnostic.
- Keep unresolved evidence gaps out of canonical BR text and move them to the report.