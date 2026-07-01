# Task — ACLMatrixSynthesizer

Run AR:ACLMatrixSynthesizer

Load and strictly follow:

tooling/orchestration/04-spec-driven-closure/agents/ACLMatrixSynthesizer.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/FN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/BR/`
- `_ar/spec-draft/ARCH/`
- `_ar/spec-draft/EN/`
- `_ar/spec-draft/DOMAIN-kernel.md` if present
- `_ar/spec-draft/DOMAIN-aggregates.md` if present
- `_ar/repo-map/glossary.md` if present
- `tooling/docs/rules-ACL.md` if present
- `tooling/templates/template-ACL.md` if present

---

## Deliverables

Create or refresh:

- ACL files in `_ar/spec-draft/ACL/`
- `_ar/spec-draft/ACL-matrix.md`
- `_ar/spec-draft/ACL-synthesis-report.md`

Optional:

- `_ar/evidence/acl-synthesis-notes.md`

---

## Rules

- Express access as resource/action/scope rules.
- Keep business position and technical auth distinct.
- Keep tenant scoping visible.
- Keep unresolved permissions explicit.
- Do not infer authorization only from UI visibility.

---

## Success condition

This run is successful when:

- the ACL matrix is explicit and reviewable
- unresolved access behavior is visible
- no unsupported grants were introduced