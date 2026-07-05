---
doc_id: COMP0015
title: ShareRow
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0002
  - WIRE0003
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0015 – ShareRow

*(promoted from `inline` — canonical @patron/ui component: ShareRow)*

---

## Current-state (observed)

> The section below (through "Evidence") documents Patronus's **current-state UI as observed in
> live-site screenshots**. This component was left `inline` in the original WIRE reconstruction
> (no dedicated COMP existed); it is promoted here per `DESIGN-component-index.md` row 12 /
> `components.md` §2 mapping ("Share row | inline | icon button row ... | **GAP→recon**"). Do not
> read anything in this section as a description of the rebuild design system; see
> "Design-system alignment (target)" further down for the `@patron/ui` `ShareRow` contract.

## Purpose

A compact row of social-network icon links for sharing a Story or a completed-donation moment.
Observed in two independently confirmed screens: the Story detail sidebar (`WIRE0002`, "share row"
under the recurring/voucher CTAs) and the payment-success hero (`WIRE0003`, "social-share icon
row"). Both instances render icon-only buttons with no visible text labels and no share-behavior
target content (URL/text shared) observable from static evidence. Reuse across ≥2 confirmed-built
screens is Confirmed, which is the basis for promoting this out of `inline` status per the COMP
evidence rule (`tooling/docs/rules-COMP.md`: "Create a COMP only when reuse is observable across
two or more WIRE screens").

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `networks` | `string[]` (network identifiers) | no | Uncertain — not evidenced whether a default/full set vs. a per-screen curated set is used | Icon set rendered, in order. `WIRE0002` shows 6: Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger. `WIRE0003` shows 7: Facebook/X/Instagram/LinkedIn/WhatsApp/**Email**/Messenger. The discrepancy (Email present on `WIRE0003`, absent on `WIRE0002`) is recorded as observed, not reconciled — see Open Questions. |
| `label` | `string` | Uncertain | — | Neither screen shows a visible "Sdílet příběh:" style caption from static evidence; `WIRE0002`/`WIRE0003` record the zone only as an "icon button row" / "social-share icon row" with "no visible labels, icon-only buttons" (`WIRE0003` Components Used). Whether an off-screen/visually-hidden label exists is Uncertain. |
| `shareTarget` | Uncertain | Uncertain | — | The URL/text/story-identifier actually shared by each link is explicitly flagged Uncertain in both source WIREs (`WIRE0002` Interactions #: "no share behavior observed beyond icon presence"; `WIRE0003` Data Bindings Open Question: "whether the social-share buttons carry any bound share-target (story slug/URL) is Uncertain"). Not fabricated here. |

## Variants

- **network-count:** 6-icon set (`WIRE0002`, Story detail sidebar: Facebook/X/Instagram/LinkedIn/
  WhatsApp/Messenger) | 7-icon set (`WIRE0003`, payment-success hero: adds Email). Whether this is
  one component with a configurable icon set, or two independently-built rows that happen to look
  similar, is `Uncertain` — carried forward as an Open Question rather than resolved.

## States

### idle
Static icon-only row, monochrome/neutral rendering (no confirmed hover/active tint observed).
Confirmed — `WIRE0002` sidebar screenshot; `WIRE0003` hero screenshot
(`_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png`).

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — no disabled rendering observed; all icons appear uniformly interactive in both screens.

### loading
N/A — no async behavior observed (icons link out to external share targets; no in-page loading
state evidenced).

### error
N/A — no error state observed.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onShareClick` | network identifier | click on one icon link | `WIRE0002`: "no share behavior observed beyond icon presence" (Interactions not itemized for this zone). `WIRE0003` Interactions #3: click opens "the respective external share flow (Facebook/X/Instagram/LinkedIn/WhatsApp/Email/Messenger)" — Confirmed as an external-navigation action, but the shared content/target is Uncertain (see Props). |

## Accessibility

Usually not directly observable from screenshots — marked `Uncertain` per `rules-COMP.md`.

- **ARIA role:** `Uncertain` — Assumed native `<a>` link semantics per icon; not confirmed.
- **Keyboard navigation:** `Uncertain`. `WIRE0003` Accessibility Notes Assumed a tab order of
  "header nav → hero share icons → primary CTA → footer links" following visual top-to-bottom,
  left-to-right order — explicitly marked "Assumed... Not evidenced," not observed fact.
- **Focus management:** `Uncertain` — no evidence of visible focus-ring styling on the icons in
  either source WIRE.
- **Screen reader:** `Uncertain` — whether each icon carries an accessible name (e.g. "Share on
  Facebook") distinguishing it from a purely decorative icon is not observable from a static
  screenshot in either WIRE.

## Usage Constraints

- Use when: offering social distribution of a Story (detail sidebar) or of a completed-donation
  moment (payment-success page).
- Do not use when: `Uncertain` — no negative-usage evidence recorded in source WIREs.
- Cardinality: one instance per screen observed in both `WIRE0002` and `WIRE0003` (not repeated
  within a single screen).
- Placement: `WIRE0002` — bottom of the sticky donation sidebar, below the recurring/voucher CTAs;
  `WIRE0003` — inside the success hero, below the body paragraphs and above/beside the primary CTA
  (exact ordering "hero share icons → primary CTA" per `WIRE0003` Accessibility Notes tab-order
  Assumption).

## Dependencies

- Other COMPs: none confirmed as composed sub-elements — the icon glyphs are rendered inline
  within each source WIRE's own layout; no independent icon-glyph COMP exists in the current-state
  reconstruction.
- Data entities: none confirmed. The shared content (story slug/URL, or the donation `EN0009`
  Transaction context on `WIRE0003`) is explicitly **not** confirmed as bound data — `WIRE0003`
  Data Bindings: "the generic success page shows no amount/story name" and flags the share-target
  binding itself as an Open Question.
- ACL: none evidenced.
- External libraries: none evidenced (external share destinations — Facebook/X/Instagram/LinkedIn/
  WhatsApp/Email/Messenger — are third-party navigation targets, not embedded libraries).

## Composition

```
ShareRow (current-state, both observed instances)
  └─ icon link × N (Facebook / X / Instagram / LinkedIn / WhatsApp / [Email] / Messenger)
       — each icon-only, no visible text label, target/behavior Uncertain beyond
         "opens external share flow" (WIRE0003)
```

## Open Questions

- **Icon-set discrepancy (6 vs. 7):** `WIRE0002`'s sidebar instance lists 6 networks (no Email);
  `WIRE0003`'s hero instance lists 7 (adds Email). Whether this reflects one configurable component
  or two distinct, independently-built rows is `Uncertain` — not resolved by current-state evidence
  alone.
- **Share-target binding:** whether any instance carries a bound share URL/text (e.g. the specific
  Story's `/pribeh/<slug>` on `WIRE0002`, or a donation-specific value on `WIRE0003`) is Uncertain
  in both source WIREs — flagged there for "UC0006/COPY follow-up," not assumed here.
- **Visible label presence:** whether a caption like "Sdílet příběh:" precedes the icon row (as the
  target contract's `label` prop implies) or the row is icon-only with no adjacent text is
  Uncertain from static screenshots alone (`WIRE0003` explicitly notes "no visible labels").
- **`WIRE0002` duplicate-sidebar artifact:** `WIRE0002` records the entire donation sidebar
  (including its Share row) as appearing to repeat twice in the full-page capture — an unresolved
  Open Question (`WIRE0002-Q1`) at the WIRE level about whether this is a two-column reflow
  artifact or two genuinely distinct blocks. Not re-resolved here; carried by reference.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 confirmed-built screens | Confirmed | `WIRE0002` (Story detail sidebar) and `WIRE0003` (payment-success hero); both list a share/social-share icon row in Components Used |
| 6-icon set (Story detail) | Confirmed | `WIRE0002` §Screen Overview / Components Used: "Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger — no share behavior observed beyond icon presence" |
| 7-icon set incl. Email (payment success) | Confirmed | `WIRE0003` Components Used: "social-share icon row (Facebook, X, Instagram, LinkedIn, WhatsApp, Email, Messenger) ... Confirmed — 7 icons, no visible labels, icon-only buttons"; `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png` |
| Click opens external share flow | Confirmed | `WIRE0003` Interactions #3 |
| Share-target/bound content | Uncertain | `WIRE0003` Data Bindings Open Question; `WIRE0002` Components Used note |
| Accessibility (role/keyboard/focus/SR) | Uncertain | no DOM/recording evidence available in either source WIRE; `WIRE0003` Accessibility Notes marks tab order as "Assumed... Not evidenced" |

---

## Design-system alignment (target)

> **STATE: TARGET — `@patron/ui` `ShareRow` (Block).** This section describes the **rebuild
> design system's** canonical component contract, per `DESIGN-component-index.md` row 12 and
> `_ar/evidence/design-system/components.md` §1 "ShareRow". It sits at the same authority level as
> `it-zadani` (future/target), **not** current-state truth, and must not be read back into the
> "Current-state (observed)" section above. Per the reconciliation mapping
> (`components.md` §2), the relationship to this current-state observation is **GAP→recon**: "no
> reconstructed COMP existed" prior to this promotion — "Canonical `ShareRow` with a `SocialName`
> set. Reconstruction saw an inline icon row (no behavior)."

### Canonical contract summary

The canonical `ShareRow` is a **Block** — a compact, monochrome icon row for sharing a Story;
glyphs adopt the active tenant's action color on hover. It is composed inside the `StoryDetail`
page's sticky right rail (`SiteHeader` → ... → `DonationBox` → `RailCta` (recurring) → `RailCta`
(promo, CZ-only) → **`ShareRow`**), per `DESIGN-component-index.md` §1 row 16 (StoryDetail
composition). It composes one internal, non-exported sub-element:

```
ShareRow (canonical, target)
  └─ SocialGlyph  (internal, _socialIcons.tsx — not independently exported/catalogued)
```

### Props

All props are **display-ready**; `label` is required, `networks` is optional and defaults to the
full 7-network set:

| Prop | Type | Required | Default | Notes |
|---|---|---|---|---|
| `label` | `string` | yes | — | Leading caption (e.g. "Sdílet příběh:"), per `ShareRow.contract.md` Anatomy: `Sdílet příběh:  (f) (x) (ig) (in) (wa) (@) (m)`. |
| `networks` | `SocialName[]` | no | full 7-network set, in fixed order: `facebook, x, instagram, linkedin, whatsapp, email, messenger` | `SocialName` union: `"facebook" \| "x" \| "instagram" \| "linkedin" \| "whatsapp" \| "email" \| "messenger"`. Supplying `networks` restricts **and** reorders the rendered set to just the chosen values. |

Source: `packages/ui/src/components/ShareRow/ShareRow.tsx` (`ShareRowProps` interface,
`DEFAULT_NETWORKS` constant); `ShareRow.contract.md` §Props.

### Variants, sizes, states

- **Variant axis:** default set (all 7 networks, default order) | custom set (`networks` prop
  restricts/reorders). No size axis is itemized (fixed row size per `components.md` §1).
- **States:**
  - `default` — monochrome glyphs, reading `color.muted` / text token (not brand-tinted at rest).
  - `hover` / `focus` — glyph adopts the **active tenant's** action color (`color.action`); focus
    ring reads `color.accent`. Per `ShareRow.contract.md` §Stavy: "glyf adoptuje barvu tenanta;
    focus ring `color.accent`."

### Token slots

`--space-sm`, `--font-body`, `--color-muted`, `--color-surface`, `--color-border`,
`--color-action`. Per `DESIGN-tokens.md` §10, all are consumed via `var(--…)` in the component's
colocated `ShareRow.module.css` — no hex/px literals. Source:
`packages/ui/src/components/ShareRow/ShareRow.module.css`;
`_ar/evidence/design-system/components.md` §1 "ShareRow" token list.

### Accessibility (target)

- Each link carries an **`aria-label` naming the network** (`socialLabel(n)` helper in
  `_socialIcons.tsx`) — e.g. "Share on Facebook" equivalent per network; the glyph itself is
  **decorative** (no independent accessible name on the SVG/icon).
- Links are keyboard-reachable (native `<a>` semantics) with a **visible focus state** reading
  `color.accent`.
- Glyph-to-surface contrast is verified on **both tenants** via the Storybook a11y panel
  (`.storybook/preview.tsx` `a11y: { test: "error" }` enforcement, per
  `_ar/evidence/design-system/components.md` §0).
- Source: `ShareRow.contract.md` §Přístupnost ("Každý odkaz má `aria-label` s názvem sítě
  (`socialLabel(n)`); glyf sám je dekorativní... Odkazy klávesnicí dostupné, focus stav viditelný
  (`color.accent`)... Kontrast glyfů... ověřen na obou tématech").

### Tenant (CZ/RO) behaviour

- `ShareRow` itself is **theme-neutral** — it takes no tenant-specific props; the network set is
  customizable per instance via `networks`, not by tenant.
- What *is* tenant-driven is the **hover/focus glyph color**: switching `data-theme="cz"|"ro"`
  remaps `color.action` (and `color.accent` for the focus ring) with **no code change** — per
  `ShareRow.contract.md` §Acceptance: "Přepnutí tenanta CZ↔RO změní hover barvu glyfů beze změny
  kódu." (CZ `color.action` = `#EC4B34`; RO `color.action` = `#16235A`, per `DESIGN-tokens.md`
  §3.1.)
- RO omission behavior (the StoryDetail page's promo `RailCta` is CZ-only and hidden in RO) does
  **not** extend to `ShareRow` — it is present in the composition for both tenants; no per-tenant
  network-list difference is documented in `components.md`.

### Divergences from current-state (flagged, not resolved)

- **Icon-set count and membership.** Current-state observation splits into two inconsistent counts
  across the two screens where this element appears — `WIRE0002` (6, no Email) vs. `WIRE0003` (7,
  incl. Email). The canonical contract's **default** is the full 7-network set (matching
  `WIRE0003`'s count exactly, including Email) — but this is *not* evidence that `WIRE0002`'s
  6-icon instance is a "wrong" or partial rendering of the same component; it may instead reflect
  a `networks`-restricted custom set, a different screen-specific instance, or simply an
  unreconciled current-state inconsistency. Recorded as a divergence, not silently resolved in
  either direction.
- **Visible caption (`label`).** The canonical contract makes `label` a **required** prop with a
  visible leading caption (e.g. "Sdílet příběh:") per its Anatomy diagram. Both current-state WIREs
  record the icon row as **icon-only, with no visible label** (`WIRE0003`: "no visible labels,
  icon-only buttons"). This is a genuine current-vs-target presentation difference — whether the
  live rendering actually omits the caption, or the caption exists but was not evidenced/legible
  in the captured screenshots, is `Uncertain`, not asserted as a confirmed contradiction.
- **Hover/focus tenant-color behavior.** The canonical contract specifies an explicit, tested
  hover/focus color change (glyph → `color.action`, focus ring → `color.accent`). Both current-state
  WIREs mark hover/focus as `Uncertain — not observable from static evidence`; no confirmed
  contradiction exists, only an evidence gap on the current-state side.
- **Bound share-target content.** The canonical contract does not itemize a `shareTarget`/URL prop
  at all (its `ShareRowProps` is only `label` + `networks`) — implying the actual shared
  URL/content is composed/handled by the consumer (e.g. the `StoryDetail` page), not by `ShareRow`
  itself. This is consistent with, but does not resolve, the current-state Open Question of what
  each current-site icon link actually shares.

### Source references

`DESIGN-component-index.md` row 12 (Index table) and §2 (doc_id assignment: "ShareRow → COMP0015");
full catalogue entry `_ar/evidence/design-system/components.md` §1 "ShareRow" and mapping row §2
"ShareRow" ("GAP→recon... Canonical ShareRow with a SocialName set. Reconstruction saw an inline
icon row (no behavior)."); token values/naming `DESIGN-tokens.md` §3.1, §5, §10. Package source:
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/ShareRow/`
(`ShareRow.tsx`, `ShareRow.module.css`, `ShareRow.contract.md`, `_socialIcons.tsx`,
`ShareRow.stories.tsx`, `index.ts`).
