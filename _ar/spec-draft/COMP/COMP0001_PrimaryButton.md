---
doc_id: COMP0001
title: Primary Button
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0019
  - WIRE0024
---

# COMP0001 – Primary Button

## Purpose

A filled, high-emphasis call-to-action button used for the single primary action on a screen or
form step (submit a step, confirm a donation, log in, activate an account, request a document).
Shared cross-module — the identical red/filled visual and interaction shape recurs across the
Public site, the Application wizard, Authentication, and Account modules. Reuse is directly
observed across at least 14 of the 22 written WIRE screens (`WIRE0001`, `WIRE0002`, `WIRE0003`,
`WIRE0006`–`WIRE0015`, `WIRE0019`, `WIRE0024`), satisfying the ≥2-screen reuse rule with a wide
margin — this is the single most-repeated inline element identified in
`_ar/spec-draft/WIRE-synthesis-report.md` §6.

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `label` | `string` | yes | — | Button text; COPY-owned per screen (e.g. "Pokračovat", "Odeslat", "Přispět 🤝", "Přihlásit se", "Aktivovat účet", "Uložit změny", "Ziskat potvrzení"). This COMP does not own or enumerate label text. |
| `onClick` | `function` | yes | — | Handler; per-screen target/submission is owned by the consuming UC (see Composition/Usage). |
| `type` | `"button" \| "submit"` | no | `"submit"` | Native button semantics; `submit` observed as the dominant usage inside forms/wizard steps. |
| `disabled` | `boolean` | no | `false` | Gates the click when required fields are unmet; the specific gating rule is UC/BR-owned (e.g. `UC0001` step-submit gates), not restated here. |
| `icon` | `string` | no | `none` | Optional trailing/leading emoji or icon glyph observed once (🤝 on the donation CTA, `WIRE0002`); otherwise text-only. |

## Variants

- **emphasis:** primary (filled red) — the only emphasis level directly observed with this exact
  visual identity. A visually distinct **secondary** (outlined/green) button also recurs (e.g.
  "Chci podporovat... pravidelně" on `WIRE0002`, "Vybrat"/"Více informací" row actions on
  `WIRE0008`) but its shape is not consistently identical across occurrences (color, fill, and
  underline-vs-button styling vary) — left as a distinct `Uncertain` sibling variant, not folded
  into this COMP's confirmed contract. See Open Question below.
- **width:** content-width (most screens) | full-width (Uncertain — not clearly distinguishable in
  static captures at desktop width)

## States

### idle
Filled red background, white bold label text, rounded rectangle. Confirmed on every cited
screenshot (e.g. `screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` "Pokračovat";
`screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` "Přihlásit se").

### hover
`Uncertain — not observable from static screenshot evidence.`

### focused
`Uncertain — not observable from static screenshot evidence.`

### disabled
`Uncertain — no disabled-state rendering was captured anywhere in the evidence set; whether the
button visually greys out or simply blocks submission on click is not evidenced.`

### loading
`Uncertain — no in-flight/spinner state was captured for any submit action (e.g. donation payment
handoff, wizard step submission). Evidence Pending per WIRE0002/WIRE0007/WIRE0011 loading-state
notes.`

### error
N/A — the button itself has no error rendering; validation errors surface on the associated form
fields (see e.g. `WIRE0010` phone-mismatch inline error), not on this component.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onClick` | none | user click/tap or Enter-key submit on a focused form | Downstream effect (navigation, UC submission, modal open) is owned by the consuming WIRE's Interactions section, not this COMP. |

## Accessibility

Usually not directly observable from screenshots — mark `Uncertain` / Open Question unless
recordings or DOM evidence supports it.

- **ARIA role:** `Uncertain` — inherits native semantics from `<button>` is the Assumed baseline; no DOM evidence available to confirm no ARIA override is applied.
- **Keyboard navigation:** `Uncertain` — Assumed reachable via standard Tab order; not confirmed.
- **Focus management:** `Uncertain` — not observable from static evidence.
- **Screen reader:** `Uncertain` — announced label assumed to equal the visible `label` text; not confirmed.

## Usage Constraints

- Use when: a screen or form step has exactly one dominant next-action (Confirmed pattern: one
  primary button per screen/step in all cited evidence — no screen shows two primary-emphasis
  buttons side by side).
- Do not use when: the action is secondary/optional (see secondary-button Open Question) or purely
  navigational (→ text link pattern, not this COMP).
- Cardinality: one per screen/step (Confirmed by observation; no counter-evidence).
- Placement: end of a form/content block, typically right-aligned or full-width within the content
  panel (Confirmed across wizard steps `WIRE0007`–`WIRE0011`).

## Dependencies

- Other COMPs: none (leaf component).
- Data entities: none — button carries no entity-typed prop itself.
- ACL: none observed — visibility/enablement gating tied to form completeness (BR/UC-owned), not
  role-based, in all cited evidence.
- External libraries: none evidenced.

## Composition

Leaf component; not composed of other COMPs. It is itself frequently the trailing element inside
form-shaped screens (see `COMP0005` Wizard Stepper screens, `COMP0006` Consent Checkbox screens,
`COMP0009` Email-Entry Form).

## Examples

```
PrimaryButton label="Pokračovat" type="submit" />          // WIRE0007–WIRE0011 (wizard steps)
PrimaryButton label="Přihlásit se" type="submit" />         // WIRE0012 (login)
PrimaryButton label="Přispět 🤝" type="submit" icon="🤝" /> // WIRE0002 (donation)
PrimaryButton label="Aktivovat účet" type="submit" />       // WIRE0013 (activation)
```

## Open Questions

- Whether a visually distinct **secondary-button** variant (outline/green, e.g. "Chci podporovat...
  pravidelně") is a true variant of this same component or a wholly separate COMP — evidence is
  inconsistent across screens (color/fill differs) and was not promoted here to avoid overstating
  reuse-as-identical. Left inline in `WIRE0002`/`WIRE0008` pending clearer evidence.
- Disabled/loading/hover/focus states are entirely unevidenced; if a future runtime capture becomes
  available (see `_ar/tasks/Runtime-truth-policy.md`), this COMP should be revisited.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed | 14+ WIRE docs cite an identical filled-red button pattern; `_ar/spec-draft/WIRE-synthesis-report.md` §6 "Primary/secondary CTA button" |
| Visual idle state | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`, `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`, `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png` |
| hover/focused/disabled/loading states | Uncertain | no capture in `_ar/prtsc/` shows any of these states |
| Accessibility | Uncertain | no DOM/recording evidence available |
