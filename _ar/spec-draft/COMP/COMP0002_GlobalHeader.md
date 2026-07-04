---
doc_id: COMP0002
title: Global Site Header
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0005
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
  - WIRE0021
  - WIRE0023
  - WIRE0024
  - WIRE0025
  - IA-patronus
---

# COMP0002 – Global Site Header

## Purpose

The persistent top navigation bar shown on essentially every Patronus screen: brand lockup, primary
nav links, the "Požádat o pomoc" CTA, and the "Můj účet" auth entry point. It is shared chrome
identically described across at least 19 of the 22 written WIRE docs
(`_ar/spec-draft/WIRE-synthesis-report.md` §6, "Global header nav ... present as chrome on
essentially every screen"). Navigation targets themselves are IA-owned (`IA-patronus.md`); this COMP
owns only the header's visual/interaction shell.

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `isAuthenticated` | `boolean` | no | `false` | Controls the `Můj účet` link's downstream destination (own account vs. login), owned by IA/UC, not restated here. |
| `activeNavItem` | `string` | no | `none` | Which of the nav links (if any) is visually marked active; not confirmed as implemented in any capture (Uncertain). |

## Variants

- **context:** public (nav: "Jak to funguje", "Blog", "O nás", "Požádat o pomoc", "Můj účet" —
  Confirmed on `WIRE0001`, `WIRE0006`–`WIRE0013`, `WIRE0015`, `WIRE0019`, `WIRE0024`, `WIRE0025`) |
  authenticated-account (adds an auth account-menu affordance behind "Můj účet" — Probable,
  `WIRE0014`, `WIRE0021`, `WIRE0023`; exact menu contents not evidenced)

## States

### idle
White background, left-aligned "patron dětí" wordmark + tagline, centered nav links, right-aligned
red "Požádat o pomoc" button + "Můj účet" text link with person icon. Confirmed on every screen
citing it, e.g. `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`.

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — header has no disabled state.

### loading
N/A — static chrome, not tied to any async operation in evidence.

### error
N/A — no error rendering owned by the header itself.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onNavigate` | target route | click on any nav link/CTA/logo | Targets are IA-owned; this COMP only emits the interaction, not the destination. |

## Accessibility

- **ARIA role:** `Uncertain` — Assumed `<header>`/`<nav>` native landmark semantics; not confirmed from DOM evidence.
- **Keyboard navigation:** `Uncertain` — not observable from static screenshots.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain` — nav-link announcement assumed to equal visible label text; not confirmed.

## Usage Constraints

- Use when: rendering the top of any Patronus-built screen (public or authenticated).
- Do not use when: rendering external/vendor surfaces (Comgate, Revolut 3DS — explicitly out of
  WIRE/COMP scope per `WIRE-screen-coverage.md` "Excluded / platform surfaces").
- Cardinality: exactly one per screen, top-most position.
- Placement: page-level, above all other content zones.

## Dependencies

- Other COMPs: none (composes no sub-COMPs in current evidence — the "Požádat o pomoc" element
  visually resembles `COMP0001` Primary Button but is smaller/nav-scoped; not confirmed identical,
  left as an open question rather than asserted composition).
- Data entities: none directly; `isAuthenticated` reflects session state, not an entity attribute.
- ACL: none evidenced — no role-gated nav item was observed to differ from the base set.
- External libraries: none evidenced.

## Composition

Leaf-level chrome component; no confirmed sub-COMP composition (see Dependencies note on the
"Požádat o pomoc" nav button).

## Examples

```
GlobalHeader isAuthenticated={false} />   // WIRE0001, WIRE0006–WIRE0013 (public/anonymous)
GlobalHeader isAuthenticated={true} />    // WIRE0014, WIRE0021, WIRE0023 (account screens, Probable)
```

## Open Questions

- Whether the "Požádat o pomoc" header button is the same reusable component as `COMP0001` Primary
  Button (smaller/nav-styled) or a distinct nav-scoped button — not resolved from static evidence.
- Whether an authenticated-state header renders a dropdown/menu behind "Můj účet" — no capture shows
  this interaction; `WIRE0014`/`WIRE0021`/`WIRE0023` assume its presence by analogy only.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed | 19+ WIRE docs cite an identical header pattern; `WIRE-synthesis-report.md` §6 |
| Visual idle state (public context) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`, `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` |
| Authenticated-context variant | Probable | inferred from `_ar/spec-draft/WIRE/WIRE0014_AccountSettingsProfile.md` single screenshot; no dedicated authenticated-header capture exists |
| Accessibility | Uncertain | no DOM/recording evidence available |
