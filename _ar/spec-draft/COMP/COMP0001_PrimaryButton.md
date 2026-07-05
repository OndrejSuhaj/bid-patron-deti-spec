---
doc_id: COMP0001
title: Button
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
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0001 – Button

*(reconstructed as Primary Button; canonical @patron/ui component: Button)*

---

## Current-state (observed)

> The section below (through "Evidence") documents Patronus's **current-state UI as observed in
> live-site screenshots**. It is unchanged reconstruction content — only the title/doc heading
> above was renamed to align with the canonical component name. Do not read anything in this
> section as a description of the rebuild design system; see "Design-system alignment (target)"
> below for that.

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

- ~~Whether a visually distinct **secondary-button** variant (outline/green, e.g. "Chci
  podporovat... pravidelně") is a true variant of this same component or a wholly separate
  COMP~~ — **Resolved at the target layer, not the current-state layer.** Current-state evidence
  remains as recorded above (inconsistent color/fill across occurrences; left inline in
  `WIRE0002`/`WIRE0008`, not folded into this COMP's confirmed current-state contract). The
  canonical `@patron/ui` **Button** component (target) *does* define `secondary` as a first-class
  `variant` value alongside `primary`/`ghost` — see "Design-system alignment (target)" below. This
  does not retroactively confirm a current-state secondary-button contract; it means the rebuild's
  Button absorbs that concern going forward.
- ~~Whether **full-width** is a real width variant~~ — **Resolved at the target layer.** Current-
  state observation is unchanged (`Uncertain` — not clearly distinguishable in static captures).
  The canonical Button defines an explicit `block` boolean prop for this. See target section below.
- Disabled/loading/hover/focus states are entirely unevidenced in current-state; if a future
  runtime capture becomes available (see `_ar/tasks/Runtime-truth-policy.md`), this COMP's
  current-state section should be revisited. (The target Button's states for these are separately
  and fully specified — see below.)

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed | 14+ WIRE docs cite an identical filled-red button pattern; `_ar/spec-draft/WIRE-synthesis-report.md` §6 "Primary/secondary CTA button" |
| Visual idle state | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`, `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`, `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png` |
| hover/focused/disabled/loading states | Uncertain | no capture in `_ar/prtsc/` shows any of these states |
| Accessibility | Uncertain | no DOM/recording evidence available |

---

## Design-system alignment (target — @patron/ui + @patron/tokens)

> **STATE: TARGET.** Everything below describes the **rebuild's canonical `@patron/ui` `Button`
> component** — the future design-system contract for `bid-patron-deti`. It is **not** current-
> state truth about Patronus and must not be read as a description of how the button behaves on
> patrondeti.cz/kidshero.ro today (see "Current-state (observed)" above for that). Source:
> `_ar/spec-draft/DESIGN-component-index.md` row 1, cross-checked against
> `_ar/evidence/design-system/components.md` ("Button — `components/Button/`") and
> `_ar/spec-draft/DESIGN-tokens.md`. Canonical library path:
> `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Button/`.

### Relationship to current-state contract

The canonical Button is a **superset** of the reconstructed Primary Button contract above: it
absorbs the emphasis axis (this COMP's confirmed `primary` + the two current-state Open Questions
around a secondary/outline sibling and full-width sizing) into one component with explicit
`variant` and `block` props, plus a `ghost` emphasis level and a `size` axis not observed at all in
current-state evidence. Rename `PrimaryButton` → **`Button`**; doc_id stays `COMP0001`.

### Purpose (target)

Base action element for CTA/secondary/link-style actions. Renders a native `<button>`, or an `<a>`
when `href` is supplied, on the *same* visual contract — current-state evidence never observed an
anchor-styled-as-button case, so this is a target-only capability.

### Props (target)

| Name | Type | Required | Default | Notes vs. current-state |
|---|---|---|---|---|
| `label` | `string` | yes | — | Matches current-state `label` prop 1:1. |
| `variant` | `"primary" \| "secondary" \| "ghost"` | no | `"primary"` | Resolves the current-state secondary-button Open Question: target formalizes it as one of three `variant` values on the same component, not a separate COMP. `ghost` (outline, no fill) has no current-state counterpart in this COMP's evidence. |
| `size` | `"md" \| "lg"` | no | `"md"` | Not observed in current-state evidence (no size axis was distinguishable in static captures). |
| `block` | `boolean` | no | `false` | Resolves the current-state full-width Open Question: explicit boolean prop rather than an inferred layout. |
| `iconBefore` / `iconAfter` | `node` | no | — | Generalizes the current-state `icon` prop (single emoji glyph, e.g. 🤝) into two named slots. |
| native `<button>`/`<a>` attrs | `onClick`, `type`, `href`, `disabled`, `target`, `rel`, `className` | — | — | `onClick`, `type`, `disabled` map directly to current-state props of the same name; `href`/`target`/`rel` are target-only (anchor rendering mode). |

Exported types: `ButtonProps`, `ButtonVariant`, `ButtonSize`.

### Sizes (target)

- `md` (default), `lg` — height/padding differ; no current-state size axis to reconcile against
  (`Uncertain` in current-state, silent/unaddressed in target — target simply defines two sizes
  without claiming to match an observed current-state size distinction).

### States (target)

| State | Target definition | vs. current-state |
|---|---|---|
| default | Base rendering per `variant`/`size`. | Matches current-state `idle`. |
| hover | Brightness shift on the fill/border. | Current-state: `Uncertain — not observable from static evidence`. Target resolves this with a concrete rule; does not retroactively confirm current-state hover styling. |
| focus-visible | Focus ring reads `var(--color-accent)`. | Current-state: `Uncertain`. Target defines a concrete token-driven ring. |
| active | Press state (visual feedback on pointer-down). | No current-state equivalent state was enumerated (current-state COMP has no `active` state row). |
| disabled | Opacity `0.5`; **`<button>` only** — the `<a>` render mode has no native `disabled`, so anchor-mode Buttons cannot express this state. | Current-state: `Uncertain — no disabled-state rendering was captured anywhere in the evidence set`. Target defines the rule; current-state evidence gap is unchanged. |
| loading | `Not part of the canonical Button contract` — `components.md`/`DESIGN-component-index.md` do not list a loading/spinner state for Button. | Current-state: `Uncertain — no in-flight/spinner state was captured`. Both layers lack a defined loading state; this is not a target/current-state conflict, just an unspecified state on both sides. |
| error | N/A — same as current-state; the target Button itself has no error rendering (validation errors are a consumer/form concern, e.g. `Input`'s `aria-invalid` pairing). | Matches current-state N/A rationale. |

### Token slots (target)

Per `DESIGN-tokens.md` §10 canonical CSS-variable naming; components read tokens only via
`var(--…)`, never hex/px literals:

- Typography: `var(--font-body)`.
- Shape: `var(--radius-pill)` (button shape — full round, per `radius.pill` = `999px` both
  tenants).
- Sizing: `var(--size-base)`, `var(--size-lg)` (paired with the `size` prop).
- Spacing: `var(--space-sm)`, `var(--space-md)`, `var(--space-lg)`, `var(--space-xl)` (padding
  axes).
- Color: `var(--color-action)` (primary fill — CZ `#EC4B34` / RO `#16235A`, per `DESIGN-tokens.md`
  §3.1 — note this is a `color.action` slot, not `color.brand`, despite the current-state doc's
  "filled red" description being specific to the CZ tenant), `var(--color-on-brand)` (label text on
  filled variants), `var(--color-surface)`, `var(--color-text)`, `var(--color-border)` (secondary/
  ghost variants), `var(--color-accent)` (focus ring, both tenants — `#6D4AFF` CZ / `#FF7A2F` RO).
- Sample consumer reference (`Button.module.css`, per `DESIGN-tokens.md` §10): `background:
  var(--color-action); color: var(--color-on-brand); border-radius: var(--radius-pill); font-
  family: var(--font-body); padding: var(--space-sm) var(--space-lg); outline: 2px solid
  var(--color-accent)` (focus).

### Accessibility (target)

Unlike the current-state section above (uniformly `Uncertain` — no DOM/recording evidence), the
target contract has enforced, concrete a11y decisions per `components.md` and Storybook config
(`@storybook/addon-a11y`, `a11y: { test: "error" }`):

- **ARIA role:** native `<button>` semantics when rendered as a button; native `<a>` semantics
  (link role) when `href` is present — no ARIA role override.
- **Focus-visible:** ring reads `var(--color-accent)` — token-driven, not hardcoded, so it re-skins
  per tenant automatically.
- **Disabled:** expressed via the native `disabled` attribute, **button-render-mode only** — anchor
  mode has no disabled semantics (a target-level constraint absent from current-state, which never
  evidenced a disabled state at all).
- **Keyboard navigation:** standard Tab order (native element semantics); no custom keyboard
  handling documented.
- Contrast is verified for both tenants as part of the canonical library's a11y enforcement
  (`components.md`), a guarantee current-state evidence cannot make (screenshots only).

### Tenant (CZ/RO) behaviour (target)

Theme-neutral component: no tenant-specific **props**. All variance is via `data-theme="cz"|"ro"`
token remapping — the component code and DOM never fork by tenant:

- `variant="primary"` resolves to `var(--color-action)`, which is itself tenant-bound: CZ =
  `#EC4B34` (brand red — this is the value that matches the current-state "filled red" idle-state
  description), RO = `#16235A` (navy). The visual color changes per tenant; the component contract
  does not.
- Focus ring (`var(--color-accent)`) is tenant-bound too: CZ `#6D4AFF`, RO `#FF7A2F` — both distinct
  from the primary action color in their own tenant.
- No current-state evidence exists for an RO-tenant rendering of this button (current-state capture
  set is CZ-only, per the reconstructed Evidence table above), so no current/target tenant
  comparison is possible for RO — flagged here, not fabricated.

### Composition (target)

Leaf/atom — matches current-state (`Leaf component; not composed of other COMPs`). Consumed by
several canonical Blocks per `DESIGN-component-index.md`: `RailCta` (ghost, block), `SiteHeader`
(ghost, desktop CTA), `DonationBox` (primary, block).

### Open-question resolution summary

| Current-state Open Question | Target resolution |
|---|---|
| Secondary-button variant: same component or separate COMP? | Target: same component, `variant="secondary"` (plus a third `ghost` level not previously considered). Current-state evidence is left as-is — this is a target design decision, not a current-state finding. |
| Full-width: real variant or not observable? | Target: explicit `block: boolean` prop. Current-state remains `Uncertain`. |
| Disabled/loading/hover/focus states unevidenced | Target defines hover/focus-visible/disabled/active concretely; loading remains undefined on **both** layers (not a target/current-state gap, just unspecified everywhere). |

### Source references

- `_ar/spec-draft/DESIGN-component-index.md` (row 1, "Button")
- `_ar/evidence/design-system/components.md` ("Button — `components/Button/`")
- `_ar/spec-draft/DESIGN-tokens.md` (§3, §6, §10, §11)
- Canonical source: `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Button/` (`Button.tsx`, `Button.module.css`, `Button.contract.md`, `Button.stories.tsx`)
