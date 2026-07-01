# Task — COPYSynthesizer

Run AR:COPYSynthesizer

Load and strictly follow:

tooling/orchestration/90-optional-bonus/ux-reconstruction/agents/COPYSynthesizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify `_ar/coverage/**` or production code.

---

## Pre-check

Confirm reading of:

- `_ar/prtsc/**`, `_ar/evidence/ui/ui-observed-areas.md`
- `_ar/spec-draft/WIRE/`, `_ar/spec-draft/COMP/` if present
- `_ar/spec-draft/BR/`, `_ar/spec-draft/EN/`, `_ar/spec-draft/UC/` if present
- `_ar/spec-draft/CS/`, `_ar/evidence/runtime/prtsc/**` if present
- `_ar/repo-map/glossary.md`
- `tooling/docs/rules-COPY.md`, `tooling/templates/template-COPY.md` if present

---

## Deliverables

- COPY files in `_ar/spec-draft/COPY/` (one per scope)
- `_ar/spec-draft/COPY-key-index.md`
- `_ar/spec-draft/COPY-synthesis-report.md`

---

## Rules

- Transcribe text verbatim from observed UI; never paraphrase or invent strings.
- Keys follow `<scope>.<screen-or-component>.<role>`.
- Every validation message → `BRxxxx`/`ENxxxx`; every CTA → `UCxxxx`.
- Default scope `shared-<purpose>` or `module-<project-slug>`, `modules: []`, `language:` set.
- Mark implied (unobserved) strings as Assumed/Uncertain; use glossary for cs/en normalization.
