# Task — MSGSynthesizer

Run AR:MSGSynthesizer

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/MSGSynthesizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/UC/`
- `_ar/spec-draft/FN/`
- `_ar/spec-draft/EN/` if present
- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/ARCH/` if present
- `_ar/spec-draft/BR/` if present
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-MSG.md` if present
- `tooling/templates/template-MSG.md` if present

Optional evidence inputs may be used if present.

---

## Deliverables

Create or refresh:

- MSG files in `_ar/spec-draft/MSG/`
- `_ar/spec-draft/MSG-message-map.md`
- `_ar/spec-draft/MSG-synthesis-report.md`

Optional:

- `_ar/evidence/msg-synthesis-notes.md`

---

## Rules

- Keep MSG message-oriented and implementation-agnostic.
- Keep trigger, recipients, and business message purpose explicit.
- Keep infrastructure detail out of canonical MSG text.
- If evidence is weak, keep the MSG broader and record the reason.

