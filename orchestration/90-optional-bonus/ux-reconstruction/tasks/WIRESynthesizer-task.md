# Task — WIRESynthesizer

Run AR:WIRESynthesizer

Load and strictly follow:

tooling/orchestration/90-optional-bonus/ux-reconstruction/agents/WIRESynthesizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify `_ar/coverage/**` or production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/IA/IA-<project-slug>.md`, `_ar/spec-draft/IA-screen-map.md`
- `_ar/spec-draft/UC/`
- `_ar/prtsc/**`, `_ar/evidence/ui/ui-observed-areas.md`
- `_ar/coverage/ui-screen-index.md`
- `_ar/spec-draft/EN/`, `_ar/spec-draft/BR/`, `_ar/spec-draft/QUERY/`, `_ar/spec-draft/ACL/`, `_ar/spec-draft/COMP/` if present
- `_ar/spec-draft/CS/`, `_ar/evidence/runtime/prtsc/**` if present
- `_ar/repo-map/glossary.md`
- `tooling/docs/rules-WIRE.md`, `tooling/templates/template-WIRE.md` if present

---

## Deliverables

- WIRE files in `_ar/spec-draft/WIRE/` (one per screen)
- `_ar/spec-draft/WIRE-screen-coverage.md`
- `_ar/spec-draft/WIRE-synthesis-report.md`

---

## Rules

- Every WIRE sets `realizes_uc:` (≥1 UC) and a `screen_id:` matching the IA Screen Map.
- Address the four states (default/empty/loading/error) or declare `N/A — <reason>`.
- Components trace to `COMPxxxx` or `inline`; validations trace to `BRxxxx`.
- Never inline IA / COMP / COPY / backend content; observed UI is suggestive for unobserved states.
- Classify claims (Confirmed/Probable/Assumed/Uncertain) and cite screenshot evidence.
