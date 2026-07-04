---
doc_id: COMP0005
title: Application Wizard Stepper
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - UC0001
  - EN0001
---

# COMP0005 – Application Wizard Stepper

## Purpose

A 5-step numbered progress indicator ("Příběh / Dar / O Vás / Patron / Přílohy") shown at the top of
every step of the Application intake wizard (`UC0001`, over `EN0001` Application). This is the
strongest reuse candidate in the WIRE set: the identical 5-step chrome, with only the
active/complete/upcoming step states differing, is directly observed on all five wizard-step WIRE
docs (`WIRE0007`–`WIRE0011`, screens S008a–S008e).

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `steps` | `string[]` | no | `["Příběh", "Dar", "O Vás", "Patron", "Přílohy"]` | Fixed 5-item label set observed identically across all five screens; not confirmed configurable. |
| `activeIndex` | `number (1-5)` | yes | — | Which step is currently active; drives the per-step highlight. |
| `completedIndices` | `number[]` | no | `[]` | Steps rendered with a checkmark instead of a number (steps before `activeIndex`). |

## Variants

- **step count:** 5 (only cardinality observed; no evidence of a variable step count).

## States

### idle
Horizontal row of 5 numbered circles connected by a line; each circle renders one of three visual
sub-states depending on its position relative to `activeIndex` (see below). Confirmed on all five
citing screenshots, e.g.
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` (step 1 active, all
others upcoming) and `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`
(step 1 complete/checkmarked, step 2 active).

Per-circle sub-states (all Confirmed by direct visual comparison across the five screens):
- **upcoming** — grey outline circle with grey step number, grey label.
- **active** — filled red circle with white step number, red bold label.
- **completed** — filled red circle with a white checkmark glyph (no number), red label.

### hover
`Uncertain — not observable from static evidence; steps do not appear clickable (no evidence of
backward-jump-by-click; back-navigation is via the separate "Krok zpět" link, not the stepper
itself).`

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — no disabled rendering observed; upcoming steps are visually de-emphasized (grey) but this is
the standard "not yet reached" idle sub-state, not a disabled interactive state.

### loading
N/A — the stepper itself has no async behavior; it reflects wizard position synchronously with
navigation.

### error
N/A — no error rendering is owned by the stepper; per-step validation errors surface on the step's
own form fields (see e.g. `WIRE0010`'s phone-mismatch inline error), not on the stepper.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| — | — | — | No events emitted. No evidence anywhere in the five captures of the stepper itself being clickable/interactive; it is read-only progress chrome. |

## Accessibility

- **ARIA role:** `Uncertain` — Assumed an ordered/list-like progress-indicator role; not confirmed.
- **Keyboard navigation:** `Uncertain` — likely none, given no click-interactivity evidence.
- **Focus management:** N/A — not a focusable control in evidence.
- **Screen reader:** `Uncertain` — whether "step 1 of 5, active" style announcement exists is not confirmable from screenshots.

## Usage Constraints

- Use when: rendering any step of the Application wizard (`UC0001`).
- Do not use when: outside the wizard flow — no other module in evidence uses this exact 5-step
  pattern (the donation modal, login, and account screens have no equivalent stepper).
- Cardinality: exactly one per wizard-step screen, top position (below global header).
- Placement: full-width band directly under `COMP0002` Global Header, above the step's own heading
  and back-link.

## Dependencies

- Other COMPs: none (leaf component).
- Data entities: `EN0001` Application — `activeIndex`/`completedIndices` conceptually track wizard
  progress through the Application intake session (`EN0003` ApplicationSession per IA), but no
  direct field-level binding is evidenced; recorded as a conceptual, not confirmed, dependency.
- ACL: none evidenced.
- External libraries: none evidenced.

## Composition

Leaf component; no sub-COMP composition observed.

## Examples

```
WizardStepper activeIndex={1} completedIndices={[]} />        // WIRE0007 (S008a, step 1 active)
WizardStepper activeIndex={2} completedIndices={[1]} />       // WIRE0008 (S008b, step 1 done)
WizardStepper activeIndex={3} completedIndices={[1,2]} />     // WIRE0009 (S008c)
WizardStepper activeIndex={4} completedIndices={[1,2,3]} />   // WIRE0010 (S008d)
WizardStepper activeIndex={5} completedIndices={[1,2,3,4]} /> // WIRE0011 (S008e, all prior checkmarked)
```

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed | Identical pattern on 5 screens (S008a–S008e); `WIRE-synthesis-report.md` §6 "Multi-step wizard stepper" |
| Visual sub-states (upcoming/active/completed) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_57.png` |
| Non-interactivity (no events) | Probable | no click-affordance styling observed in any capture; not confirmed via DOM/interaction recording |
| Accessibility | Uncertain | no DOM/recording evidence available |
