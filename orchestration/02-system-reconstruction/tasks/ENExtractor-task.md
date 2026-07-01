# Task Prompt — ENExtractor (AR)

Run AR:ENExtractor

Load and strictly follow:

tooling/orchestration/02-system-reconstruction/agents/ENExtractor.md

Write ONLY to `_ar/spec-draft/**`.

---

## Pre-execution checklist

Spec Discovery must be performed.

Report:

1. how many EN spec files were found
2. their paths

Confirm reading of:

- `_ar/evidence/db-inventory.md`
- `_ar/evidence/db-models.md`
- `_ar/evidence/db-constraints-and-validation.md`
- `_ar/repo-map/modules.md`
- `_ar/repo-map/integrations.md`

---

## Enforcement rules

- If ANY EN spec file exists, Spec Alignment is mandatory.
- Do NOT claim "no spec found" without reporting search results.
- Confidence cannot be High without usage evidence.
- Enum does NOT imply lifecycle transitions.
- Keep domain separate from infrastructure.

---

## Required deliverables

Create or update:

- `_ar/spec-draft/EN-candidates.md`
- EN drafts under `_ar/spec-draft/`