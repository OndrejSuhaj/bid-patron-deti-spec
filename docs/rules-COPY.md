# Copy Specification Documentation Rules (COPY)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

COPY documents reconstruct user-facing **text** from observed UI evidence: labels, helper texts,
empty states, loading texts, error/validation messages, and CTAs — keyed for i18n. There is
**one COPY document per scope** (a module or a shared purpose).

COPY describes the text surface — *the words shown to the user* — not entity attributes (EN),
business rules (BR), screen layout (WIRE), or component contracts (COMP).

---

## Naming

`COPY-<scope>` where scope is `module-<slug>` or `shared-<purpose>`
(e.g. `COPY-module-core`, `COPY-shared-validation`).

File naming: `COPY-<scope>.md`

Copy **keys** follow `<scope>.<screen-or-component>.<role>` (i18n-friendly, collision-safe):
e.g. `core.login.submit-cta`, `shared-validation.password-min-length`.

---

## Required Frontmatter

```yaml
---
doc_id: COPY-<scope>
title: <Human-readable scope title>
canonical_layer: COPY
spec_type: copy
scope: module-<slug> | shared-<purpose>
modules: []
language: cs | en | multi
status: draft | canonical
references:
  # - WIRExxxx, COMPxxxx (where text appears), BRxxxx / ENxxxx (validation triggers), UCxxxx (CTAs)
---
```

---

## Recommended Structure

1. Purpose (scope, consuming modules, tone/voice)
2. Labels (Key | Text | Usage → `WIRE`/`COMP`)
3. Helper Texts
4. Empty States
5. Loading Texts
6. Error / Validation Messages (each → `BRxxxx` / `ENxxxx`)
7. CTAs (each → `UCxxxx`)
8. Microcopy Conventions

---

## Cross-references (reference, don't restate)

- Every validation message references the triggering `BRxxxx` or `ENxxxx` invariant.
- Every CTA references the `UCxxxx` it realizes.
- Labels and helper texts reference the `WIRExxxx` / `COMPxxxx` where they appear (recommended).

---

## Restrictions (NOT-FOR)

COPY must NOT contain inline:

- entity attribute definitions → `EN`
- business rule content → `BR` (reference the trigger doc_id)
- screen logic → `WIRE`
- component contracts → `COMP`

---

## Evidence convention (reconstruction)

- Primary evidence: `_ar/prtsc/**` (screenshots literally contain the text),
  `_ar/evidence/ui/ui-observed-areas.md` (transcribed text), CS scenarios.
- Transcribe text **verbatim** from observed UI; do not paraphrase or invent strings.
- Use `_ar/repo-map/glossary.md` to normalize terminology and resolve cs/en equivalents.
- Mark text that is implied but not directly observed (e.g. an error message for an unobserved
  validation) as `Assumed`/`Uncertain` (Open Question), not as confirmed copy.
- Scope note: AR reconstruction has no module decomposition; default to `shared-<purpose>` or a
  single `module-<project-slug>` scope, `modules: []`. arg-emitee Mode M re-scopes after hand-off.
