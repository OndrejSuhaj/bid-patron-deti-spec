---
doc_id: COMP0020
title: Icon
canonical_layer: COMP
spec_type: component
modules: []
status: draft
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Icon/
references:
  - WIRE0001
  - WIRE0002
  - COMP0018
  - COMP0016
  - COMP0017
  - COMP0019
  - EN0004
  - EN0005
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0020 – Icon

*(promoted from inline evidence; canonical @patron/ui component: Icon)*

## Purpose

This document promotes **Icon**, a canonical `@patron/ui` **Atom**, per the task instruction ("this
component was left inline in the reconstruction; promote it now"). It holds **two clearly separated
bodies of fact** per the project's current-vs-target discipline:

- **Design-system alignment (target)** — the authoritative canonical contract for `Icon` as built in
  the `bid-patron-deti` rebuild library (`packages/ui/src/components/Icon/`): a pictogram atom with a
  dual glyph set (line/filled), tenant-selected via CSS, inheriting `currentColor`, composed by
  several other canonical Atoms/Blocks (`CategoryChip`, `TimeLeftPill`, `Brandmark`, `PatronCard`,
  `RailCta`, `SiteHeader`, `DonationBox`).
- **Current-state (observed)** — the many places pictograms/icons were observed inline on the live
  Patronus site during current-state UX reconstruction (`WIRE0001`, `WIRE0002`), none of which were
  promoted to a standalone reusable COMP at the time, because current-state evidence could not
  establish a single shared icon component versus per-context inline glyphs/emoji.

These two parts describe **different systems** (rebuild target vs. reconstructed current Patronus)
and must not be merged into one fact. Per `DESIGN-component-index.md` §2, this component's target
contract does not resolve or "correct" the current-state ambiguity — it is recorded here separately,
per row 3 of the index and `_ar/evidence/design-system/components.md` §1 "Icon".

Cross-reference: this doc reconciles against `DESIGN-component-index.md` row 3 and
`_ar/evidence/design-system/components.md` §1 "Icon". `Icon` has **no** reconstructed current-state
COMP counterpart per `DESIGN-component-index.md` §2/§3 — icons were left `inline` throughout the
current-state WIRE reconstruction.

---

## Design-system alignment (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Everything in this part describes the rebuild's canonical component
> (`packages/ui/src/components/Icon/`), not Patronus's current behavior. Authoritative source:
> `_ar/evidence/design-system/components.md` §1 "Icon" and `DESIGN-component-index.md` row 3.

### Purpose (target)

A pictogram atom rendering one of a fixed set of named glyphs. The component ships a **dual glyph
set** — line-style and filled-style artwork for each `name` — and the active set is chosen entirely
by CSS (`display` toggling under `[data-theme]`), not by a prop. The rendered glyph inherits
`currentColor`, so its visible color is fully controlled by the consuming component/context (no
color prop, no color token consumed internally).

### Props / Inputs (target)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `name` | `IconName` (`"development" \| "health" \| "subsistence" \| "clock" \| "check" \| "arrow" \| "heart" \| "give" \| "user"`) | yes | — | Selects which glyph renders. Fixed enum — no arbitrary/custom icon names. |
| `size` | `number` (px) | no | `20` | Glyph render size in pixels. |

Exported types: `IconProps`, `IconName` (per `components.md` §1 "Icon").

### Variants (target)

- **glyph style:** LINE (CZ default) | FILLED (RO) — selected by `[data-theme]` in CSS, **not** a
  prop on `IconProps`. The glyph *style* is a theme concern, identical to how `Brandmark`
  (`COMP0019`) and `radius.icon` shape (circle CZ / squircle RO) are theme-driven rather than
  prop-driven.
- **size:** any `size` px value; no discrete size-variant enum (free-form pixel value, default `20`).

### States (target)

#### idle
Default and only state — a static glyph render. No interaction affordance is part of the contract.

#### hover
N/A — `Icon` itself defines no hover treatment; per `components.md` §1, hover-reactive icon color
(e.g. `ShareRow`'s glyphs adopting `color.action` on hover) is implemented by the **composing**
component's CSS, not by `Icon`.

#### focused
N/A — `Icon` is not independently focusable; it carries no ARIA role or tabindex of its own (see
Accessibility below).

#### disabled
N/A — no disabled rendering is part of the canonical contract; `Icon` is a pure presentational leaf,
not a control.

#### loading
N/A — not itemized in the canonical catalogue; no skeleton/loading state.

#### error
N/A — the `name` union is a closed enum; there is no "unknown icon" fallback rendering documented.

### Events (target)

No events emitted — `Icon` is a pure presentational Atom with no documented callback props
(`IconProps` per `components.md` §1 lists only `name` and `size`).

### Accessibility (target)

- **ARIA role:** none intrinsic — the component is **decorative by default**: it carries no
  built-in `role` or accessible name/label of its own.
- **Consumer responsibility:** per `DESIGN-component-index.md` row 3 A11y notes, "consuming
  component must supply `aria-label` where meaningful" — i.e. when an `Icon` instance is the *sole*
  carrier of meaning (not accompanied by adjacent visible text), the composing component is
  responsible for adding an accessible name (e.g. `CategoryChip`'s `label` prop carries the
  accessible name for its composed `Icon`, per `DESIGN-component-index.md` row 5).
- **Keyboard navigation:** N/A — not focusable.
- **Focus management:** N/A — no focus-visible treatment of its own.
- **Screen reader:** by default, an `Icon` instance is invisible to screen readers (decorative);
  whether it is announced depends entirely on the composing component's own accessibility contract,
  not on `Icon` itself.

### Tenant behavior (target — CZ/RO via `data-theme`)

- **Glyph *style* (line vs. filled) is theme-driven, not a prop:** CZ (`data-theme="cz"`) renders the
  LINE artwork; RO (`data-theme="ro"`) renders the FILLED artwork, toggled purely via CSS `display`
  rules — both glyph sets exist in the DOM/markup simultaneously and CSS selects the active one (the
  same simultaneous-both-in-DOM pattern used by `Brandmark`, `COMP0019`).
- **No color tokens consumed internally:** `Icon` reads no `var(--color-…)` slot itself — it inherits
  `currentColor` from its container, so the *composing* component's own token usage (e.g.
  `CategoryChip`'s `--color-category-*`, `SiteHeader`'s `--color-muted`/`--color-action`) determines
  the rendered color per tenant. There is therefore no tenant-bound token table for `Icon` itself
  (see Token slots below — "none").
- **Size is theme-neutral:** the `size` prop and its `20`px default apply identically under both
  `data-theme="cz"` and `data-theme="ro"`.

### Usage Constraints (target)

- Use when: a component needs one of the nine fixed pictograms (`development`, `health`,
  `subsistence`, `clock`, `check`, `arrow`, `heart`, `give`, `user`) at a controlled size, inheriting
  the caller's text color.
- Do not use when: a custom/arbitrary glyph outside the closed `IconName` enum is needed — the
  canonical catalogue does not document an escape hatch (e.g. arbitrary SVG passthrough) for `Icon`.
- Cardinality: many instances per screen; composed repeatedly across the library (see Composition).
- Placement: always as a leaf inside a composing component (`CategoryChip`, `TimeLeftPill`,
  `Brandmark`, `PatronCard`, `RailCta`, `SiteHeader`, `DonationBox`) — never itself the outermost
  element of a screen region per the catalogued compositions.

### Dependencies (target)

- Other COMPs (composition): none — `Icon` is a pure leaf; it composes nothing.
- Data entities: none — purely presentational, no entity-typed props.
- ACL: none documented.
- External libraries: none documented (pure inline/embedded SVG per `components.md` §1 "pure SVG").

### Composition (target)

`Icon` is a **leaf** component. It is itself composed by, per `_ar/evidence/design-system/components.md`
§1 and `DESIGN-component-index.md`:

| Composing component | `name` used | Doc_id |
|---|---|---|
| `CategoryChip` | category-matched (`development`\|`health`\|`subsistence`), size 15 | `COMP0018` |
| `TimeLeftPill` | `clock`, size 15 | `COMP0017` |
| `Brandmark` | `give` (CZ symbol) | `COMP0019` |
| `PatronCard` | `check` (verification seal) | *(target-only Block, no reconstructed COMP yet — `COMP0012` per index)* |
| `RailCta` | `arrow` | *(target-only Block, no reconstructed COMP yet — `COMP0014` per index)* |
| `SiteHeader` | `user` | `COMP0002` |
| `DonationBox` | `check`, `give` | *(target-only Block, no reconstructed COMP yet — `COMP0010` per index)* |

```
Icon (canonical, target)
  (leaf — no sub-components; consumed by CategoryChip, TimeLeftPill, Brandmark,
   PatronCard, RailCta, SiteHeader, DonationBox)
```

### Token slots (target — canonical CSS vars, see `DESIGN-tokens.md`)

| Token | Role here |
|---|---|
| *(none)* | `Icon` consumes **no** `var(--color-…)`/`var(--space-…)`/`var(--radius-…)` slot of its own — per `DESIGN-component-index.md` row 3 "Token slots: none (uses `currentColor`; CSS `display` toggles glyph set)". Color and any surrounding sizing/spacing are entirely the composing component's responsibility. |

Note: the *tile* that sometimes visually surrounds an icon (e.g. `radius.icon`, tenant-bound circle
CZ / squircle RO, per `DESIGN-tokens.md` §6/§7) is a token owned by the **composing** component
(e.g. `Brandmark`), not by `Icon` itself — `Icon` renders only the glyph.

### Examples (target)

```
<Icon name="clock" size={15} />          {/* composed inside TimeLeftPill */}
<Icon name="check" />                     {/* composed inside PatronCard verification seal */}
<Icon name="give" />                      {/* composed inside Brandmark, CZ symbol */}
<Icon name="development" size={15} />    {/* composed inside CategoryChip */}
```

---

## Current-state (observed — reconstructed Patronus current-state UX)

> **STATE: CURRENT.** Everything in this part describes what was actually observed on the live
> Patronus site, from static screenshot evidence captured during current-state UX reconstruction
> (`WIRE0001_HomepageStoryCatalogue.md`, `WIRE0002_StoryDetailAndDonationModal.md`). It does **not**
> describe the rebuild target above. Per `rules-COMP.md`, a COMP is only created "when reuse is
> observable across two or more WIRE screens/screenshots" — pictograms/icons were observed
> repeatedly across **both** captured WIRE screens, but current-state evidence never establishes them
> as a single shared, independently reusable component versus a set of unrelated per-context inline
> glyphs (native emoji, badge icons, category icons, social-network icons). This current-state part is
> therefore evidence-thin by design: it inventories *where* icon-like elements were observed, without
> asserting they share one underlying implementation.

### Where it appears on the live site today

Icon-like pictograms were recorded, always `inline`, at the following current-state locations:

- **`WIRE0001` — Homepage/Catalogue (`S001`):**
  - Story card — category icon badge on each catalogue card (`WIRE0001` line 90: "each: category
    icon badge, photo, …").
  - Header nav — "Můj účet" entry rendered as icon+label (`WIRE0001` line 83: `"Můj účet" (icon+label)`).
  - "Jak to funguje?" 3-column explainer — one icon per column alongside title+text (`WIRE0001`
    lines 67, 103).
  - Story card — small Patron badge icon on card corner, "if present" (`WIRE0001` line 252) —
    Confirmed icon presence per screenshots; the badge-to-Patron-profile linkage itself is only
    Probable (inferred from `UC0023` Actors, not a distinct clickable element confirmed in evidence).
- **`WIRE0002` — Story detail (`S002`):**
  - Category tag ("Rozvoj a vzdělání") rendered **with an icon**, inside the donation sidebar
    (`WIRE0002` line 64).
  - An illustrative icon (backpack) elsewhere on the page (`WIRE0002` line 66).
  - Voucher CTA "Mám dobrošek" — red button carrying a ticket icon (`WIRE0002` line 73, line 140).
  - Share row — Facebook / X / Instagram / LinkedIn / WhatsApp / Messenger icons, one per network
    (`WIRE0002` line 74, line 141: "icon button row… no share behavior observed beyond icon
    presence").
  - Patron comment card — "Přispět můžete na" text accompanied by an icon (`WIRE0002` line 92).
  - Primary donate CTA — rendered with a handshake pictogram ("Přispět 🤝"), recorded literally as
    an emoji character in the reconstructed evidence, not confirmed to be an SVG icon component
    (`WIRE0002` line 138).
- **Screenshot evidence:** `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`
  (catalogue); `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`
  (story detail), per the respective WIRE Evidence tables.

### Current-state props/behavior observed

- **No single implementation confirmed.** The reconstructed evidence records icons as a recurring
  *visual pattern* (category badges, nav icon+label, explainer icons, ticket icon, share-network
  icons, verification/handshake glyphs) across many unrelated screen zones, but neither `WIRE0001`
  nor `WIRE0002` asserts these share one underlying reusable component — each was recorded `inline`
  at its point of use.
- **At least one instance is a literal emoji, not necessarily an icon-font/SVG glyph.** The primary
  donate CTA is recorded as `"Přispět 🤝"` (`WIRE0002` line 138) — a Unicode emoji character embedded
  in button text, distinct in kind from an SVG/icon-font pictogram. This is a concrete signal that
  current-state "icons" are **not uniform in implementation** — some observed glyphs may be plain
  text/emoji rather than a dedicated icon component at all. Do not assume all inventoried instances
  above are the same kind of artifact.
- **Fixed glyph set: `Uncertain`.** Whether current-state Patronus draws from a fixed, closed set of
  glyphs (as the target `IconName` enum does) or renders arbitrary/ad-hoc icons per context (icon
  font subset, inline SVGs per module, theme-provided sprite, etc.) is not evidenced — no DOM/CSS
  source inspection was performed as part of this static-screenshot reconstruction.
- **Line vs. filled style / tenant variation: `Uncertain`.** Current-state evidence is CZ-only
  (`patrondeti.cz`); no RO (`kidshero.ro` or equivalent current-state RO surface) screenshot exists
  to compare icon style across tenants.

### Current-state Variants / States / Events / Accessibility

Per `rules-COMP.md` evidence discipline, unobserved axes are recorded as `Uncertain`, not fabricated:

- **Variants:** `Uncertain — no evidence of a line/filled style axis, or any other stylistic variant, in current-state Patronus; each inventoried instance was captured once, in one visual treatment.`
- **States (hover/focused/disabled/loading/error):** `Uncertain — not observable from static evidence`, except where the icon sits inside an otherwise-interactive element (e.g. the share-row icon buttons, the "Mám dobrošek" CTA, the primary donate CTA) — in those cases any hover/focus behavior belongs to the *composing control*, not confirmed to be owned by the icon glyph itself.
- **Events:** No events emitted by the icons themselves in any inventoried instance; where icons sit inside clickable elements (share-row buttons, CTAs), the click/navigation behavior is recorded at the WIRE/UC level against the composing element, not against the icon.
- **Accessibility:** `Uncertain — no DOM/recording evidence for any inventoried instance`, consistent with both WIRE documents' overall a11y posture (`WIRE0002` line 141 explicitly notes "no share behavior observed beyond icon presence" — i.e. even functional confirmation, let alone accessible-name confirmation, is absent for the share row).

### Current-vs-target divergence (record, do not "correct")

Per `_ar/evidence/design-system/components.md` §2 and `DESIGN-component-index.md` §3, `Icon` has no
mapped reconstructed current-state COMP — it was never promoted during the original UX
reconstruction pass. This is itself the primary divergence to record:

1. **No shared current-state component confirmed.** The target contract is a single, closed-enum
   Atom (`IconName`, 9 values) reused by 7 other canonical components. Current-state evidence shows
   the *visual pattern* of icons recurring across many screen zones, but never confirms one
   underlying implementation — it may equally be several unrelated per-module icon fonts, inline
   SVGs, or plain emoji/text glyphs (the "🤝" instance is direct evidence of at least one
   non-SVG-icon case). Treat the target's "one Icon atom, dual glyph set" as target intent only.
2. **No closed glyph enum observed.** The target's 9-name closed set (`development`, `health`,
   `subsistence`, `clock`, `check`, `arrow`, `heart`, `give`, `user`) has no confirmed current-state
   counterpart; current-state icon subjects observed (category badge, nav/account, explainer topics,
   ticket, 6 social networks, handshake, Patron badge) only partially overlap the target names
   (category and possibly "check"/verification-adjacent) and otherwise diverge (ticket, social
   networks, handshake emoji have no target `IconName` equivalent, and vice versa — `arrow`/`heart`/
   `user` were not distinctly observed as standalone current-state icon subjects).
3. **No line/filled tenant-style axis observed.** Current-state evidence is single-tenant (CZ) with
   no comparison surface; the target's LINE(CZ)/FILLED(RO) `data-theme` toggle is unconfirmable
   against current Patronus.
4. **Reuse threshold not straightforwardly met.** `rules-COMP.md` requires "reuse observable across
   two or more WIRE screens" before promoting a current-state COMP. Icon-*like elements* do recur
   across `WIRE0001` and `WIRE0002` (≥2 screens), but per point 1 above, reuse of the *visual
   pattern* "an icon appears here" is not the same evidentiary claim as reuse of *one reusable
   component* — the latter, which `rules-COMP.md` is really gating on, remains `Uncertain`. This is
   why no current-state Icon COMP was promoted during the original reconstruction, and why this
   promotion is explicitly a **target-side** promotion, not a retroactive current-state one.

### Dependencies (current-state)

- Other COMPs: none confirmed — every inventoried instance was recorded `inline` within its own WIRE
  screen zone (category badge on `COMP0008` StoryCard per `WIRE0001`; various inline elements per
  `WIRE0002`), never as a cross-referenced shared COMP.
- Data entities: `EN0004` Campaign (category, per the category-icon-badge instances) and `EN0005`
  Patron (per the Patron-badge instance, `WIRE0001` line 252 — Probable linkage only, per that row's
  own certainty marking).
- ACL: none evidenced.
- External libraries: none evidenced (no DOM/source inspection performed; icon font vs. SVG vs.
  emoji origin is unconfirmed per-instance, see above).

### Composition (current-state)

```
(no confirmed shared current-state Icon component)
  ├─ Story card category icon badge (WIRE0001, inline within COMP0008 StoryCard)
  ├─ Header "Můj účet" icon+label (WIRE0001, inline within COMP0002 GlobalHeader)
  ├─ "Jak to funguje?" explainer icons ×3 (WIRE0001, inline)
  ├─ Story card Patron badge icon (WIRE0001, inline; Probable EN0005 linkage)
  ├─ Category tag icon in donation sidebar (WIRE0002, inline)
  ├─ Illustrative "backpack" icon (WIRE0002, inline)
  ├─ Voucher CTA ticket icon (WIRE0002, inline)
  ├─ Share row network icons ×6 (WIRE0002, inline)
  ├─ Patron comment card icon (WIRE0002, inline)
  └─ Primary donate CTA "🤝" emoji glyph (WIRE0002, inline — confirmed non-SVG instance)
```

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Icon-like pictograms recur across ≥2 current-state screens | Confirmed | `WIRE0001` lines 67, 83, 90, 103, 252; `WIRE0002` lines 64, 66, 73–74, 92, 138, 140–141 |
| Category icon badge on catalogue cards | Confirmed | `WIRE0001` line 90; `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` |
| Header "Můj účet" icon+label | Confirmed | `WIRE0001` line 83 |
| Patron badge icon on card (linkage to EN0005) | Confirmed (icon) / Probable (linkage) | `WIRE0001` line 252 |
| Category tag icon in donation sidebar | Confirmed | `WIRE0002` line 64; `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png` |
| Share row icons ×6 networks | Confirmed (presence only, no behavior) | `WIRE0002` line 74, 141 |
| Primary CTA rendered as literal emoji, not confirmed SVG icon | Confirmed | `WIRE0002` line 138 |
| Single shared reusable current-state Icon component | Uncertain / not established | no COMP was promoted for icons in the original reconstruction; `DESIGN-component-index.md` §2/§3 confirms no mapped current-state COMP exists |
| Closed glyph enum matching target `IconName` | Uncertain | current-state icon subjects only partially overlap target's 9-name set; no source/DOM inspection performed |
| Tenant (line/filled) style axis | Uncertain | current-state evidence is CZ-only, no RO comparison surface |
| Accessibility (any instance) | Uncertain | no DOM/recording evidence for any inventoried instance |
| Target canonical contract (props/variants/states/tokens/a11y) | Confirmed (as target fact) | `_ar/evidence/design-system/components.md` §1 "Icon"; `DESIGN-component-index.md` row 3; source `packages/ui/src/components/Icon/{Icon.tsx, Icon.contract.md, Icon.module.css}` |

---

## Open Questions

- Whether current-state Patronus implements any of the inventoried icon-like elements via a single
  shared component (icon font, sprite, or shared SVG wrapper) versus fully independent per-module
  markup — not resolvable from static screenshots; would require source/DOM inspection of
  `intake/current-solution/_source/patronus/` (out of this document's evidence scope as written) to
  close.
- Whether the "Přispět 🤝" primary-CTA glyph is representative (i.e. current-state icons are broadly
  emoji/text-based) or an isolated case alongside otherwise-SVG/icon-font pictograms elsewhere —
  `Uncertain`, only one literal-emoji instance was recorded.
- Whether current-state Patronus has any RO-tenant surface with a comparable icon set, and if so
  whether it shows a line/filled stylistic distinction analogous to the target's `data-theme` toggle
  — no RO current-state evidence exists in the current evidence set.
- Whether the target's closed 9-name `IconName` enum is intended to be a superset, subset, or
  simple replacement of the ad hoc current-state icon subjects observed (ticket, social networks,
  handshake, backpack, "Můj účet" have no direct target-name equivalent) — this is a rebuild-design
  decision, not resolvable from current-state evidence, and is flagged here for the rebuild team's
  awareness rather than answered.

---

## Source references

**Target:** `DESIGN-component-index.md` row 3 (Index table); full catalogue entry
`_ar/evidence/design-system/components.md` §1 "Icon" and mapping in §2–§4; token slot note
`DESIGN-tokens.md` (no dedicated Icon-owned token — see Token slots above). Canonical source path:
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Icon/`
(`Icon.tsx`, `Icon.stories.tsx`, `Icon.module.css`, `Icon.contract.md`, `index.ts`).

**Current-state:** `_ar/spec-draft/WIRE/WIRE0001_HomepageStoryCatalogue.md` (lines 67, 83, 90, 103,
139, 252, 265); `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` (lines 64, 66, 73–74,
92, 138, 140–141, 264); screenshots
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
`_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`.
