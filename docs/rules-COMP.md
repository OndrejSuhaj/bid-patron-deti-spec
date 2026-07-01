# Component Specification Documentation Rules (COMP)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

COMP documents reconstruct a **single reusable UI component** from observed UI evidence: its
props, variants, states, events, accessibility, usage constraints, dependencies, and
composition. There is **one COMP document per component**.

COMP describes a reusable component contract — *what the component is and how it behaves* — not
where it appears (WIRE), its text (COPY), or backend behavior (API/FN/UC).

---

## Naming

`COMPxxxx – <Component Name>`

- `xxxx` = zero-padded component number
- Title is the component name (e.g. Button, PipelineCard)

File naming (draft): `COMP{xxxx}_{ComponentName}.md`. Published form: `COMP####-kebab-title.md`
(SpecFinalGenerator conforms the envelope; see `rules-spec-final.md`).

Cross-module shared components live in the flat COMP folder; `modules:` lists all consumers.

---

## Required Frontmatter

```yaml
---
doc_id: COMPxxxx
title: <Component Name>
canonical_layer: COMP
spec_type: component
modules: []
status: draft | canonical
design_source: <Figma / Storybook URL>   # optional
references:
  # - COMPxxxx (sub-components), ENxxxx (typed props), ACLxxxx (role-gated visibility)
---
```

---

## Recommended Structure

1. Purpose (module-scoped or shared)
2. Props / Inputs (table)
3. Variants (axes and values)
4. States — **idle, hover, focused, disabled, loading, error** (each addressed or `N/A`)
5. Events (table; or explicit "No events emitted")
6. Accessibility — **ARIA role, keyboard navigation, focus management, screen reader** (minimum)
7. Usage Constraints
8. Dependencies
9. Composition (→ `COMPxxxx`)
10. Examples (optional)

---

## Cross-references (reference, don't restate)

- `modules:` lists all consuming modules.
- Composition references sub-`COMPxxxx` doc_ids when the component composes others.
- Entity-typed props reference `ENxxxx` (recommended).
- Role-gated visibility references `ACLxxxx` (recommended).

---

## Restrictions (NOT-FOR)

COMP must NOT contain inline:

- screen-level layout → `WIRE`
- text content → `COPY`
- backend behavior → `API` / `FN` / `UC`
- entity attribute definitions → `EN` (reference doc_id for typed props)
- access rules → `ACL` (reference doc_id for visibility)
- child component contracts → reference by doc_id, not inline

---

## Evidence convention (reconstruction — evidence-gated)

COMP is the most evidence-thin UX layer. Reconstruct conservatively:

- Create a COMP **only when reuse is observable** across two or more WIRE screens / screenshots.
  If reuse cannot be evidenced, leave the element as a WIRE `inline` component — **do not invent
  a reusable component**.
- Props, variants, and states are reconstructed from observed renderings; unobserved states
  (hover/focus/disabled/loading/error) are marked `Assumed`/`Uncertain`, not fabricated.
- Accessibility (ARIA/keyboard/focus/SR) is usually unobservable from screenshots — record it as
  `Uncertain` / Open Question unless evidence (e.g. recordings, DOM) supports it.
- Classify every claim: `Confirmed` / `Probable` / `Assumed` / `Uncertain`. Cite evidence.
