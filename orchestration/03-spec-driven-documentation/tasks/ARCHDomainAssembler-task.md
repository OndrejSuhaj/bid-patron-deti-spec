# Task — ARCHDomainAssembler

Run AR:ARCHDomainAssembler

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/ARCHDomainAssembler.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/spec-draft/DOMAIN-ubiquitous-language.md` if present
- `_ar/spec-draft/BR/` if present
- `_ar/spec-draft/EN/` if present
- `_ar/spec-draft/UC/` if present
- `_ar/spec-draft/FN/` if present
- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/MSG/` if present
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-ARCH.md` if present
- `tooling/templates/template-ARCH.md` if present

---

## Deliverables

Create or refresh:

- domain ARCH files in `_ar/spec-draft/ARCH/`
- `_ar/spec-draft/ARCH-domain-map.md`
- `_ar/spec-draft/ARCH-domain-assembly-report.md`

Optional:

- `_ar/evidence/arch-domain-assembly-notes.md`

---

## Rules

- Refresh existing target files in place.
- Do not create duplicate variants.
- Do not include workflow detail or implementation detail.
- Keep ARCH domain-oriented and navigational.
- Preserve deeper reading paths to EN, UC, FN, ES, and MSG.