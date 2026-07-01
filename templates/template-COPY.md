---
doc_id: COPY-<scope>
title: <Human-readable scope title>
canonical_layer: COPY
spec_type: copy
scope: module-<slug> | shared-<purpose>
modules: []
language: cs | en | multi
status: draft | canonical
references: []
---

# COPY-<scope> – <Title>

## Purpose

<One paragraph: what scope this COPY covers, which modules consume it, tone/voice rules. Text is transcribed verbatim from observed UI.>

---

## Labels

| Key | Text | Usage (WIRE/COMP ref) |
|---|---|---|
| `<scope>.<screen-or-component>.<role>` | `<Label text>` | `WIRExxxx` / `COMPxxxx` |

---

## Helper Texts

| Key | Text | Usage |
|---|---|---|
| `<scope>.<screen-or-component>.<role>-helper` | `<Helper text>` | `WIRExxxx` |

---

## Empty States

| Key | Text | Shown when |
|---|---|---|
| `<scope>.<screen>.empty-state` | `<Empty state text>` | `<condition>` |

---

## Loading Texts

| Key | Text | Shown during |
|---|---|---|
| `<scope>.<screen>.loading` | `<Loading text>` | `<async operation>` |

---

## Error / Validation Messages

Every message references the triggering rule or invariant.

| Key | Text | Trigger |
|---|---|---|
| `<scope>.<screen>.<field>.validation-error` | `<Error text>` | `BRxxxx` / `ENxxxx` |

---

## CTAs

Every CTA references the use case it realizes.

| Key | Text | Action |
|---|---|---|
| `<scope>.<screen>.submit-cta` | `<CTA text>` | `UCxxxx` |

---

## Microcopy Conventions

- Tone: <formal | casual | neutral>
- Person: <1st | 2nd | 3rd>
- Capitalization: <sentence case | title case>
- Punctuation: <rules>

---

## Evidence

Text is transcribed verbatim from observed UI; mark unobserved (implied) strings as
`Assumed`/`Uncertain`.

| Key area | Certainty | Evidence |
|---|---|---|
| Labels / CTAs / messages | Confirmed / Assumed / Uncertain | `_ar/prtsc/<file>.png`, `ui-observed-areas.md` |
