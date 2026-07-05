---
doc_id: COMP0002
title: SiteHeader
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
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0002 – SiteHeader

*(reconstructed as Global Site Header / GlobalHeader; canonical `@patron/ui` component: **SiteHeader**)*

> This document reconciles a **current-state (observed)** reconstruction against the **target**
> `bid-patron-deti` design system. The two are kept strictly separate per the project constitution's
> current-vs-target rule: the observed section below is not rewritten toward the target, and the
> target section is not treated as evidence of current Patronus behavior.

---

## Current-state (observed)

### Purpose

The persistent top navigation bar shown on essentially every Patronus screen: brand lockup, primary
nav links, the "Požádat o pomoc" CTA, and the "Můj účet" auth entry point. It is shared chrome
identically described across at least 19 of the 22 written WIRE docs
(`_ar/spec-draft/WIRE-synthesis-report.md` §6, "Global header nav ... present as chrome on
essentially every screen"). Navigation targets themselves are IA-owned (`IA-patronus.md`); this COMP
owns only the header's visual/interaction shell.

### Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `isAuthenticated` | `boolean` | no | `false` | Controls the `Můj účet` link's downstream destination (own account vs. login), owned by IA/UC, not restated here. |
| `activeNavItem` | `string` | no | `none` | Which of the nav links (if any) is visually marked active; not confirmed as implemented in any capture (Uncertain). |

### Variants

- **context:** public (nav: "Jak to funguje", "Blog", "O nás", "Požádat o pomoc", "Můj účet" —
  Confirmed on `WIRE0001`, `WIRE0006`–`WIRE0013`, `WIRE0015`, `WIRE0019`, `WIRE0024`, `WIRE0025`) |
  authenticated-account (adds an auth account-menu affordance behind "Můj účet" — Probable,
  `WIRE0014`, `WIRE0021`, `WIRE0023`; exact menu contents not evidenced)

### States

#### idle
White background, left-aligned "patron dětí" wordmark + tagline, centered nav links, right-aligned
red "Požádat o pomoc" button + "Můj účet" text link with person icon. Confirmed on every screen
citing it, e.g. `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`.

#### hover
`Uncertain — not observable from static evidence.`

#### focused
`Uncertain — not observable from static evidence.`

#### disabled
N/A — header has no disabled state.

#### loading
N/A — static chrome, not tied to any async operation in evidence.

#### error
N/A — no error rendering owned by the header itself.

### Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onNavigate` | target route | click on any nav link/CTA/logo | Targets are IA-owned; this COMP only emits the interaction, not the destination. |

### Accessibility

- **ARIA role:** `Uncertain` — Assumed `<header>`/`<nav>` native landmark semantics; not confirmed from DOM evidence.
- **Keyboard navigation:** `Uncertain` — not observable from static screenshots.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain` — nav-link announcement assumed to equal visible label text; not confirmed.

### Usage Constraints

- Use when: rendering the top of any Patronus-built screen (public or authenticated).
- Do not use when: rendering external/vendor surfaces (Comgate, Revolut 3DS — explicitly out of
  WIRE/COMP scope per `WIRE-screen-coverage.md` "Excluded / platform surfaces").
- Cardinality: exactly one per screen, top-most position.
- Placement: page-level, above all other content zones.

### Dependencies

- Other COMPs: none (composes no sub-COMPs in current evidence — the "Požádat o pomoc" element
  visually resembles `COMP0001` Primary Button but is smaller/nav-scoped; not confirmed identical,
  left as an open question rather than asserted composition).
- Data entities: none directly; `isAuthenticated` reflects session state, not an entity attribute.
- ACL: none evidenced — no role-gated nav item was observed to differ from the base set.
- External libraries: none evidenced.

### Composition

Leaf-level chrome component; no confirmed sub-COMP composition (see Dependencies note on the
"Požádat o pomoc" nav button).

### Examples

```
GlobalHeader isAuthenticated={false} />   // WIRE0001, WIRE0006–WIRE0013 (public/anonymous)
GlobalHeader isAuthenticated={true} />    // WIRE0014, WIRE0021, WIRE0023 (account screens, Probable)
```

### Open Questions

- Whether the "Požádat o pomoc" header button is the same reusable component as `COMP0001` Primary
  Button (smaller/nav-styled) or a distinct nav-scoped button — not resolved from static evidence.
- Whether an authenticated-state header renders a dropdown/menu behind "Můj účet" — no capture shows
  this interaction; `WIRE0014`/`WIRE0021`/`WIRE0023` assume its presence by analogy only.

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed | 19+ WIRE docs cite an identical header pattern; `WIRE-synthesis-report.md` §6 |
| Visual idle state (public context) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`, `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` |
| Authenticated-context variant | Probable | inferred from `_ar/spec-draft/WIRE/WIRE0014_AccountSettingsProfile.md` single screenshot; no dedicated authenticated-header capture exists |
| Accessibility | Uncertain | no DOM/recording evidence available |

---

## Design-system alignment (target — @patron/ui + @patron/tokens)

> **STATE: TARGET.** Everything below describes the canonical `@patron/ui` **`SiteHeader`** Block
> component (rebuild library, `packages/ui/src/components/SiteHeader/`) per
> `_ar/spec-draft/DESIGN-component-index.md` row 14 and `_ar/evidence/design-system/components.md`
> §1 "SiteHeader — `components/SiteHeader/`". It is **not** current-state evidence and must not be
> read as a claim about how the observed Patronus header behaves today — see the "Current-state
> (observed)" section above for that. Where the two disagree (they do, substantially — see
> reconciliation notes at the end of each subsection), the disagreement is recorded, not resolved.

### Contract summary

The canonical `SiteHeader` is a storefront Block: brandmark, main nav, login entry point, and an
"Ask for help" CTA, collapsing to a hamburger menu at ≤720px viewport width
(`_ar/evidence/design-system/components.md` §1; `DESIGN-component-index.md` row 14).

### Props

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `navItems` | `string[]` | — | — | Main nav link labels; prop-driven per tenant/locale (no hardcoded nav copy). |
| `loginLabel` | `string` | — | — | Label for the login/account entry point. |
| `applyLabel` | `string` | — | — | Label for the "Ask for help" CTA (target analogue of the observed "Požádat o pomoc" button). |

Exported type: `SiteHeaderProps`.

**Reconciliation note:** the observed `isAuthenticated` and `activeNavItem` props have **no**
canonical counterpart — `SiteHeaderProps` carries no auth-state or active-item flag. The canonical
contract is presentational/content-driven only; session-aware behavior (own account vs. login
destination) is not modeled in the target props surface per current evidence. Flag as an open
reconciliation gap, not silently mapped.

### Variants / sizes

- **desktop** — full nav row, all `navItems` visible inline.
- **mobile** (≤720px) — nav collapses to hamburger; login becomes icon-only.

No `size` prop/axis exists (unlike `Button`'s `size: md|lg`); the only variant axis is the
desktop/mobile responsive collapse, which is breakpoint-driven, not prop-driven.

### States

- **default** — desktop, nav fully visible.
- **menu closed** / **menu open** — mobile hamburger toggle, exposed via `aria-expanded`.

No hover/focus/disabled/loading/error states are catalogued separately for the header shell itself
(individual composed sub-elements — `Button`, nav links — carry their own interaction states per
their own contracts, not restated here per cross-layer discipline).

### Token slots

Per `components.md` §1 and `DESIGN-component-index.md` row 14:

`var(--space-lg)`, `var(--space-md)`, `var(--space-sm)`, `var(--space-xs)`, `var(--color-border)`,
`var(--color-muted)`, `var(--color-text)`, `var(--color-action)`, `var(--color-surface)`,
`var(--shadow-card)`, `var(--font-body)`.

All values resolve tenant-bound where the underlying slot is tenant-bound (`color.*`, `shadow.*` per
`DESIGN-tokens.md` §2) and shared where the slot is shared (`space.*`); the header itself takes no
tenant prop — re-skinning happens purely via `data-theme` token remap, per the multi-tenant theming
model (`DESIGN-tokens.md` §11).

### Composition

```
SiteHeader
  ├─ Brandmark        (in the home `<a>`)
  ├─ Button (ghost)   (desktop CTA — analogue of "Ask for help" / "Požádat o pomoc")
  └─ Icon (name="user")
```

Canonical doc_ids: `Brandmark` = COMP0019, `Button` = COMP0001, `Icon` = COMP0020 (per
`DESIGN-component-index.md` §2). Storybook stories: `Hlavička`, `Mobil`.

**Reconciliation note:** the current-state (observed) COMP explicitly left composition an "Open
Question" — whether the "Požádat o pomoc" button is `COMP0001` Primary Button reused, or a distinct
nav-scoped button, was not resolved from static evidence. The canonical target *does* compose a
`Button` (ghost variant) for this CTA. This resolves the open question only for the **target**;
it is not evidence that the current Patronus header composes `COMP0001` today.

### Accessibility (target)

- **Mobile menu toggle** exposes `aria-expanded` (open/closed state of the hamburger menu).
- Accessibility is **enforced by tooling**, not merely documented: `.storybook/main.ts` loads
  `@storybook/addon-a11y` and `preview.tsx` sets `a11y: { test: "error" }` library-wide
  (`_ar/evidence/design-system/components.md` intro notes).
- This is a direct contrast with the current-state (observed) section above, whose ARIA role,
  keyboard navigation, focus management, and screen-reader behavior are all `Uncertain` (no DOM/
  recording evidence available for the live Patronus header).

### Tenant (CZ/RO) behaviour

- No tenant-specific **props** exist on `SiteHeader` itself — nav items/labels are prop-driven per
  tenant/locale by the consumer, not switched internally.
- Composed `Brandmark` (COMP0019) *is* tenant-driven: CZ renders an in-repo icon-tile + wordmark
  composition; RO renders the live KidsHero logo (hotlinked, no binary in repo). Both tenant marks
  coexist in the DOM; `data-theme` CSS picks which is visible (`DESIGN-tokens.md` §11,
  `DESIGN-component-index.md` row 4).
- Color/shadow/spacing token slots resolve per the `data-theme="cz"` vs `data-theme="ro"` value sets
  in `DESIGN-tokens.md` §3–§7; the header component code does not fork per tenant.
- **MD (Moldova)**, present in current-state evidence as a served locale, has **no** implemented
  tenant theme in the target design system — only `cz`/`ro` exist today (`DESIGN-tokens.md` §11).
  This is a target-system gap relative to current-state scope, recorded here, not resolved.

### Reconciliation classification

Per `_ar/evidence/design-system/components.md` §2 mapping table and `DESIGN-component-index.md`
§2: **RENAME** — same concept (persistent top-of-page navigation chrome), different name
(`GlobalHeader`/"Global Site Header" observed → `SiteHeader` canonical), with a materially expanded
target contract (explicit responsive hamburger variant, `aria-expanded` state, enforced a11y testing)
relative to what static screenshot evidence could establish for the current system.
