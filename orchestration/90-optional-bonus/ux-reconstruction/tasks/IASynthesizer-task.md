# Task — IASynthesizer

Run AR:IASynthesizer

Load and strictly follow:

tooling/orchestration/90-optional-bonus/ux-reconstruction/agents/IASynthesizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify `_ar/coverage/**` or production code.

---

## Pre-check

Confirm reading of:

- `_ar/coverage/ui-screen-index.md`
- `_ar/evidence/ui/ui-observed-areas.md`
- `_ar/prtsc/**`
- `_ar/spec-draft/UC/`, `_ar/spec-draft/EN/` if present
- `_ar/spec-draft/ACL/`, `_ar/spec-draft/ARCH/` if present
- `_ar/spec-draft/CS/`, `_ar/evidence/flow/` if present
- `_ar/repo-map/glossary.md`
- `tooling/docs/rules-IA.md`, `tooling/templates/template-IA.md` if present

---

## Deliverables

- `_ar/spec-draft/IA/IA-<project-slug>.md` (one per project)
- `_ar/spec-draft/IA-screen-map.md`
- `_ar/spec-draft/IA-synthesis-report.md`

---

## Rules

- Reconstruct from UI evidence; observed UI is suggestive, not authoritative.
- Mint stable screen-ids (S001…) and index them for downstream WIRE.
- Reference UC/EN/ACL/ARCH by doc_id; never inline cross-layer content.
- Open IA Questions is mandatory; surface every unresolved behavior with a named decider.
- Use `_ar/repo-map/glossary.md` for terminology; do not override `_ar/repo-map/modules.md`.
