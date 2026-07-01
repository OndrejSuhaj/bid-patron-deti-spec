# Wireframe Specification Documentation Rules (WIRE)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

WIRE documents reconstruct a **single screen** from observed UI evidence: layout zones, the
components it uses, interactions, states, validation surfaces, data bindings, conditional
visibility, and accessibility. There is **one WIRE document per screen**.

WIRE describes the screen surface — *what is on the screen and how it behaves* — not the
navigation map (IA), reusable component contracts (COMP), text (COPY), or backend logic (UC/API).

---

## Naming

`WIRExxxx – <Screen Name>`

- `xxxx` = zero-padded screen number
- Title is the screen name

File naming (draft): `WIRE{xxxx}_{ScreenName}.md`. Published form: `WIRE####-kebab-title.md`
(SpecFinalGenerator conforms the envelope; see `rules-spec-final.md`).

---

## Required Frontmatter

```yaml
---
doc_id: WIRExxxx
title: <Screen Name>
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: Sxxx            # matches the IA Screen Map id
realizes_uc: [UCxxxx]      # REQUIRED — a screen without a use case is invalid
status: draft | canonical
references:
  # - UCxxxx, COMPxxxx, ENxxxx, QUERYxxxx, BRxxxx, ACLxxxx, CSxxxx
---
```

`realizes_uc` is **mandatory** (at least one UC). `screen_id` must match the IA Screen Map.

---

## Recommended Structure

1. Purpose (which UC it realizes, actor, entry context)
2. Layout Zones (ASCII sketch optional)
3. Components Used (each → `COMPxxxx` or explicit `inline`)
4. Interactions (Entry, Primary, Secondary, Exit)
5. States — **default, empty, loading, error** (each addressed or explicit `N/A — <reason>`)
6. Validation Surfaces (each → `BRxxxx`)
7. Data Bindings (→ `ENxxxx` / `QUERYxxxx`)
8. Conditional Visibility (→ `ACLxxxx` / `BRxxxx`)
9. Accessibility Notes

---

## Cross-references (reference, don't restate)

- `realizes_uc:` — at least one `UCxxxx`.
- Components Used — every entry is a `COMPxxxx` doc_id or flagged `inline`.
- Validation Surfaces — every entry references the triggering `BRxxxx`.
- Data Bindings — `ENxxxx` / `QUERYxxxx` (recommended).
- Conditional Visibility — `ACLxxxx` / `BRxxxx` (recommended).

Dangling COMP/UC/BR references block completion.

---

## Restrictions (NOT-FOR)

WIRE must NOT contain inline:

- navigation / screen map → `IA`
- reusable component contracts → `COMP`
- text content → `COPY`
- backend logic / contracts → `UC` / `API` / `FN`

---

## Evidence convention (reconstruction)

- Primary evidence: `_ar/prtsc/**`, `_ar/evidence/ui/ui-observed-areas.md`,
  `_ar/coverage/ui-screen-index.md`, CS scenarios + their screenshots, `_ar/evidence/flow/**`.
- Observed UI wins for what is on the screen, but is **suggestive** for unobserved states: if
  `empty` / `loading` / `error` were not observed, declare the state and mark it
  `Assumed`/`Uncertain` (Open Question) rather than fabricating behavior.
- Classify claims: `Confirmed` (seen in evidence) / `Probable` / `Assumed` / `Uncertain`.
- Cite screenshots by path. Do not invent zones, components, or interactions without evidence.
