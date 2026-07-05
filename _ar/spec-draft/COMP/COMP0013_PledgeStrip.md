---
doc_id: COMP0013
title: PledgeStrip
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0002
  - EN0004
  - EN0005
  - DESIGN-component-index
  - DESIGN-tokens
  - COMP0010
---

# COMP0013 – PledgeStrip

*(promoted from inline: canonical `@patron/ui` component `PledgeStrip`; no reconstructed
current-state COMP existed for this element prior to this doc — see "Current-state (observed)"
below)*

---

## Design-system alignment (target)

> **STATE: TARGET — `@patron/ui` `PledgeStrip` (Block).** This section is the **authoritative
> contract** for this doc, because — unlike `COMP0001/0002/0003/0008` — no reconstructed
> current-state COMP existed for this element before this promotion; the element was only ever
> recorded `inline` inside `WIRE0002` ("Trust banner"). Per the project constitution's
> current-vs-target rule, this section describes the **rebuild design system**
> (`packages/ui`), sits at the same authority level as `it-zadani` (future/target), and is **not**
> current-state truth. Source: `DESIGN-component-index.md` row 16 / §1 "Note on PledgeStrip";
> `_ar/evidence/design-system/components.md` §0, §2 ("PledgeStrip" mapping row), §4; `design-canon.md`
> §4.1, §4.3, §4.4, §4.5.

### Canonical identity

- **Name:** `PledgeStrip` (Block-level component, `packages/ui/src/components/PledgeStrip/`
  per the library's per-component directory convention: `PledgeStrip.tsx`,
  `PledgeStrip.stories.tsx`, `PledgeStrip.module.css`, `PledgeStrip.contract.md`, `index.ts`).
- **Purpose:** full-width invariant banner carrying the platform's core trust guarantee —
  **"100 % of the donation reaches the child; money is never sent to the family; the vendor/supplier
  is named"** (`design-canon.md` §4.1: *"100 % of the donation goes to the child — money goes
  directly to the vendor's invoice, never to the family; the founder covers operations. Carried by
  PledgeStrip as a divider before 'Další děti'."*).
- **Placement in the `StoryDetail` page composition:** rendered as a **full-width divider**
  immediately after the two-column region (main column + sticky right rail) and immediately before
  the "Další děti čekají na pomoc" cross-sell grid (`design-canon.md` §4.2 anatomy diagram;
  `DESIGN-component-index.md` StoryDetail row, "Composition regions").
- **Presence guarantee:** `PledgeStrip` is present in **every** `StoryDetail`/`DonationBox` screen
  state (`live` / `urgent` / `funded`) — recorded as an explicit acceptance criterion: *"PledgeStrip
  is present in every state — the guarantee never disappears"* (`design-canon.md` §4.4). This
  mirrors the `DonationBox` `CollectionState` axis (`COMP0010`) but `PledgeStrip` itself carries
  **no state of its own** — it does not vary with `live`/`urgent`/`funded`.

### Props / Inputs (canonical)

`Uncertain — not itemized as its own catalogue subsection with a props table in
_ar/evidence/design-system/components.md §1.` `PledgeStrip` is documented there only via its role in
the `StoryDetail` composition (§4.2 "Full-width divider") and its mapping-table entry (§2), not with
a per-prop breakdown as the Atoms/other Blocks receive. By analogy with sibling Blocks that carry the
same "static invariant text + named entity" shape (`RailCta`, `PatronCard`), the following is the
most defensible **Hypothesis** — not confirmed against source:

| Name | Type | Notes |
|---|---|---|
| `vendorLabel` | `string` (Hypothesis) | Display-ready label for the vendor/supplier field, e.g. "Dodavatel". Not confirmed in `components.md`. |
| `vendorName` | `string` (Hypothesis) | Vendor/supplier name in **nominative case, machine-fillable from backend** — `design-canon.md` §4.1: *"Story vendor = label + value in nominative case → machine-fillable from backend without template declension."* This nominative-case constraint is the one concrete prop-shape detail evidenced, even though the prop name/table itself is not. |
| `pledgeText` | `string` (Hypothesis) | Display-ready pledge statement text (the "100 % to the child, never to the family" copy). Not confirmed as a prop vs. hardcoded copy in the component. |

Treat this table as `Uncertain` scaffolding, not as a confirmed canonical contract — re-verify
directly against `packages/ui/src/components/PledgeStrip/PledgeStrip.tsx` /
`PledgeStrip.contract.md` before generation-grade use.

### Variants / states (canonical)

`Uncertain — not itemized separately in components.md.` No variant axis or state list is recorded
for `PledgeStrip` beyond its constant presence across `DonationBox`/`StoryDetail`'s
`live | urgent | funded` states (see "Presence guarantee" above). Unlike `TimeLeftPill`
(`COMP0017`) or `DonationBox` (`COMP0010`), nothing in the evidence suggests `PledgeStrip` itself
re-renders differently per collection state — it is treated as a static, state-invariant divider.

### Token slots (canonical)

`Uncertain — not itemized separately in components.md §1` (`PledgeStrip` has no dedicated
per-component token list the way `Button`/`DonationBox`/etc. do). It is, however, included in the
shared "UI component inventory consuming these tokens" list (`_ar/evidence/design-system/tokens.md`
§11: *"Brandmark, Button, CategoryChip, DonationBox, Icon, Input, PatronCard, PledgeStrip,
ProgressBar, RailCta, ShareRow, SiteFooter, SiteHeader, StoryCard, StoryHero, TimeLeftPill"*), so it
is Confirmed to consume **some** subset of the shared token surface via `var(--…)` in its own
colocated CSS module (per-component, no hex/px literals — `docs/design/README.md` §2–3, ADR0003).
By analogy with the shared token surface and its role as a full-width text band with brand emphasis
(closest sibling: the `PatronCard`/`RailCta` surface treatment, and the "bold full-width strip"
description in §4.5), the most defensible **Hypothesis** for the slots actually in play:

- `var(--color-brand)` / `var(--color-brand-strong)` — strip background/emphasis color (the
  "translated into tenant color" full-width band per §4.5).
- `var(--color-on-brand)` — text color against the brand-colored band.
- `var(--font-body)` — body copy typeface for the pledge statement.
- `var(--font-display)` (+ `var(--font-display-weight)`, `var(--font-display-tracking)`) — if the
  vendor name or headline portion uses the display typeface.
- `var(--space-lg)` / `var(--space-md)` — internal padding of the full-width band.
- `var(--layout-container)` — inner content width constraint (1200px container), consistent with
  the rest of the `StoryDetail` page grid (`design-canon.md` §4.2).

These slot names are **not confirmed** against `PledgeStrip.module.css`; record as Hypothesis only.

### Accessibility (canonical)

`Uncertain — not itemized separately in components.md.` No ARIA role, keyboard, focus, or
screen-reader behavior is recorded for `PledgeStrip` specifically. Given its purpose (a static,
non-interactive trust statement with no CTA, no input, no link evidenced), the most defensible
default is that it needs no interactive ARIA role beyond native text-content semantics — but this is
**not confirmed** and should be re-verified against `PledgeStrip.contract.md` directly. Note for
contrast: the design system as a whole enforces accessibility via `@storybook/addon-a11y`
(`a11y: { test: "error" }`, `components.md` §0) — so a Storybook-verified a11y baseline almost
certainly exists in the source `.contract.md` even though it is not captured in the `components.md`
extraction consulted here.

### Tenant (CZ/RO) behaviour

- **Color re-skin:** the strip's brand-emphasis color is token-driven (`var(--color-brand)` /
  `var(--color-brand-strong)`), so it re-skins per `data-theme="cz"|"ro"` with no component code
  fork, consistent with every other canonical component's tenant model
  (`_ar/evidence/design-system/components.md` §0).
- **Vendor-name nominative-case constraint applies to both tenants** — the "machine-fillable from
  backend without template declension" design intent (§4.1) is a cross-tenant content-modelling
  rule, not a CZ-specific one.
- **No tenant-conditional visibility.** Unlike `RailCta`'s promo/voucher variant (CZ-only, hidden in
  RO) or `SiteFooter`'s per-tenant content, nothing in the evidence suggests `PledgeStrip` is
  hidden, varied, or content-forked between CZ and RO — it is recorded as present in **every** state
  for **both** tenants (`design-canon.md` §4.4 "acceptance criterion").
- **Deliberate shift vs. today, called out explicitly in source** (`design-canon.md` §4.5):
  *"100 % pledge + vendor as a bold full-width strip (inspired by today's CZ red band, translated
  into tenant color; placed as a closing divider, not a heavy header)."* This is the design team's
  own current→target framing — recorded here as target intent, not as a current-state fact (see
  "Current-state (observed)" below for what was actually observed).
- **Detailed "donation chain" step-by-step explicitly dropped** in the target design (§4.5): *"the
  guarantee is carried by one strong statement instead. Returns when target behavior is
  specified."* — i.e. `PledgeStrip` intentionally simplifies rather than itemizes the pledge
  mechanism.

### Composition (canonical)

`PledgeStrip` is documented as a **Block** with no composed sub-Atoms/Blocks recorded in
`components.md` — treated as a leaf full-width text/layout element in the source, in contrast to
composed Blocks like `StoryCard` (→ `CategoryChip` + `ProgressBar`) or `DonationBox`
(→ `TimeLeftPill` + `ProgressBar` + `Input` + `Button` + `Icon`). `Uncertain` whether it composes an
`Icon` (e.g. a "check"/"heart" glyph) for visual emphasis — not evidenced either way.

```
PledgeStrip (canonical, target)
  └─ (no composed sub-components evidenced — leaf Block; static text/layout only)
```

### Source references

`DESIGN-component-index.md` §1 row 16 / "Note on PledgeStrip"; `_ar/evidence/design-system/
components.md` §0 (layer taxonomy: PledgeStrip listed among the 9 Blocks), §2 (mapping table,
"PledgeStrip" row: *"Canonical PledgeStrip carries the '100% / never to the family / supplier name'
invariant. Reconstruction saw a static 'Trust banner'."*), §3 reconciliation-priority item 3, §4
(behavioral divergences); `_ar/evidence/design-system/design-canon.md` §4.1, §4.2, §4.3, §4.4, §4.5;
`_ar/evidence/design-system/tokens.md` §11 (component inventory list). Canonical library root
(unread directly in this pass): `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/
packages/ui/src/components/PledgeStrip/`.

---

## Current-state (observed)

> The section below documents Patronus's **current-state UI as observed in live-site
> screenshots**. It is the reconstructed evidence for the element that the canonical library calls
> `PledgeStrip`; the current-state UI itself never named or componentized this element — it was
> recorded purely `inline` inside `WIRE0002` under the label **"Trust banner"**. Nothing in this
> section should be read as a description of the rebuild design system — see "Design-system
> alignment (target)" above for the `@patron/ui` `PledgeStrip` contract.

### Purpose

A full-width, static text band on the Story detail page (`WIRE0002`) stating the platform's
100%-to-child pledge. Observed copy: **"Na pomoc dětem putuje vždy 100 % částky, kterou darujete."**
(*"Always 100% of the amount you donate goes to help children."*) — rendered as a red band
(`WIRE0002` §"Anatomy": *"Trust banner (full-width) — red band, 'Na pomoc dětem putuje vždy 100 % z
darované částky.'"*). A near-duplicate of this same pledge statement also appears as **microcopy
directly under each donation CTA** in the sidebar (*"Na pomoc dětem putuje vždy 100 % z darované
částky"*) and as one bullet in the Story body's trust list (*"100 % daru jde na pomoc dětem"*,
*"peníze neposíláme rodinám..."*) — `WIRE0002` §"Anatomy". Whether the full-width banner and the
CTA-adjacent microcopy are the *same* underlying element/component rendered twice, or two
independent text blocks that happen to repeat the same message, is **not confirmed** from static
evidence — recorded as an open question below rather than merged.

**Evidence count for reuse:** this element is observed on **exactly one** confirmed-built screen
(`WIRE0002`, single instance of the full-width band). Per `rules-COMP.md`'s evidence-gated
convention ("create a COMP only when reuse is observable across two or more WIRE screens"), this
element would **not**, on current-state observation alone, have qualified for promotion out of
`inline` — it is recorded here specifically because the task instructs promoting the *canonical*
`PledgeStrip` (which is evidenced as a first-class target Block), not because the current-state
reconstruction independently found ≥2-screen reuse. This asymmetry is recorded explicitly, not
smoothed over.

### Props / Inputs (as observed)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `text` | `string` | yes | — | Static pledge copy, e.g. "Na pomoc dětem putuje vždy 100 % částky, kterou darujete." Not entity-bound — `WIRE0002` Components-Used table: *"Trust banner \| inline \| full-width text band \| static copy, not entity-bound."* |

No other props observed. In particular — unlike the canonical `vendorName` Hypothesis prop above —
**no vendor/supplier name is present in the observed full-width banner text itself.** The
current-state page does name a supplier elsewhere on the same screen, but as a separate sidebar
element ("Přispět můžete na" + in-kind description, e.g. *"balík školních potřeb; dodává SEVT"* —
`WIRE0002` §"Anatomy" donation sidebar), not inside the trust banner. Whether the target
`PledgeStrip`'s vendor-naming behavior is a genuinely new capability (folding two separate
current-state elements into one target Block) or simply an undocumented detail of the current band
is **Uncertain** — flagged as a current-vs-target divergence below, not resolved.

### Variants (as observed)

None observed. Single static rendering; no variant axis evidenced.

### States

#### idle
Static full-width red band with pledge text, as captured. Confirmed —
`_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`.

#### hover
N/A — not an interactive element (no link/button role observed).

#### focused
N/A — not observed to be a focusable element (no CTA/link inside the band itself was captured).

#### disabled
N/A.

#### loading
N/A — static copy, no async data.

#### error
N/A — no error state applicable to a static text band.

### Events

No events emitted. The band carries no CTA, link, or interactive control in the observed evidence.

### Accessibility

`Uncertain` — no DOM/recording evidence available, consistent with every other reconstructed
current-state COMP in this project (`COMP0008` etc.). No ARIA role, keyboard, or screen-reader
behavior can be confirmed from the static screenshot.

- **ARIA role:** `Uncertain` — likely inherits native semantics of a plain text container (e.g.
  `<div>`/`<p>`); not confirmed.
- **Keyboard navigation:** N/A — no interactive control observed.
- **Focus management:** N/A.
- **Screen reader:** `Uncertain`.

### Usage Constraints (as observed)

- Use when: rendering the Story detail page (`WIRE0002`), between the two-column
  hero/body/sidebar region and the "Related stories" rail.
- Do not use when: `Uncertain` — no other current-state screen was captured showing/omitting this
  band; whether it appears on every Story detail page or only some is not confirmed (only one
  screenshot instance exists).
- Cardinality: one per Story detail page (single instance observed).
- Placement: full-width, standalone, below the two-column layout.

### Dependencies (as observed)

- Other COMPs: none confirmed as composed sub-elements — recorded `inline`, not composed from any
  other reconstructed COMP.
- Data entities: none confirmed bound. `WIRE0002` explicitly marks it *"static copy, not
  entity-bound"* — in contrast to the target `vendorName` Hypothesis prop above, which if real
  would bind to the Story's vendor/supplier field (`EN0004`/possibly `EN0005` context). This is the
  clearest concrete current-vs-target content-model divergence recorded for this element.
- ACL: none evidenced.
- External libraries: none evidenced.

### Composition (as observed)

```
Trust banner (current-state, WIRE0002)
  └─ static text node (no composed sub-elements observed)
```

### Current-state vs. target divergence (record, do not "correct")

- **Naming/identity:** current-state evidence never named or componentized this element at all — it
  surfaces only as an `inline` annotation in `WIRE0002`'s Components-Used table ("Trust banner").
  The canonical library promotes it to a first-class Block (`PledgeStrip`) with its own directory,
  stories, and contract file. This doc is the first place a `doc_id` (`COMP0013`) exists for it on
  the current-state side — assigned here specifically to reconcile against the canonical mapping
  table (`DESIGN-component-index.md` §2), not because current-state reuse evidence independently
  justified promotion (see "Evidence count for reuse" above).
- **Vendor naming:** the canonical contract's Hypothesis `vendorName` prop (nominative-case,
  machine-fillable) has **no confirmed current-state counterpart inside the banner itself** — the
  observed banner is pure pledge-statement text with no vendor/supplier name in it; vendor/supplier
  naming is a separate sidebar element in the current-state page. If the target design intends to
  fold vendor-naming into the pledge strip itself, that is a **content-model expansion**, not
  something the current-state UI does today.
- **Repetition:** current-state repeats the "100% to child" message in at least three places on the
  same page (full-width banner; CTA-adjacent microcopy; Story-body trust-list bullet) — the target
  design's framing (§4.5: *"the guarantee is carried by one strong statement instead"*) suggests
  the redesign **consolidates** this repeated messaging into the single `PledgeStrip` divider,
  dropping the per-CTA microcopy duplication. This is a deliberate simplification called out by the
  design team itself, not an emergent property of the current UI.
- **Color band:** current-state uses a **red** band (`WIRE0002`: "red band"); target explicitly
  reframes this as tenant-token-driven (`var(--color-brand)`/`var(--color-brand-strong)`), stating
  it is *"inspired by today's CZ red band, translated into tenant color"* (§4.5) — i.e. the target
  intentionally generalizes a CZ-specific red into a per-tenant brand color, which for the RO tenant
  will render differently than the observed CZ red.
- **Placement:** current-state places the banner between the two-column region and the "Related
  stories" rail — structurally the same slot the target composition uses (before "Další děti").
  This one placement detail is **consistent** between current-state and target, unlike the content
  and color divergences above.

### Open Questions

- Whether the full-width "Trust banner" and the CTA-adjacent "100%" microcopy under each donation
  CTA are the same underlying current-state element rendered twice, or two independently authored
  text blocks — not confirmed from static evidence (see Purpose above).
- Whether this banner appears on **every** Story detail page/state or only some — only one
  screenshot instance exists; no `funded`/`urgent`-state screenshot of this specific element was
  captured to confirm invariant presence on the current-state side (contrast with the target's
  explicit "present in every state" acceptance criterion).
- Whether a vendor/supplier name is ever rendered inside this specific band on any current-state
  screen not captured in this evidence set — Uncertain, not evidenced either way.

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Full-width red band with static pledge text, single instance | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`; `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` §Anatomy, §Components-Used ("Trust banner"), §Evidence |
| Not entity-bound (static copy) | Confirmed | `WIRE0002` Components-Used table: "static copy, not entity-bound" |
| Repetition of the same message elsewhere on the same screen (CTA microcopy, body trust-list bullet) | Confirmed | `WIRE0002` §Anatomy |
| Reuse across ≥2 confirmed-built screens | Not evidenced (single-screen only) | see "Evidence count for reuse" above |
| Presence in every collection state (live/urgent/funded) on current-state side | Uncertain — not evidenced | only one screenshot/state captured |
| Accessibility | Uncertain | no DOM/recording evidence available |
| Canonical target mapping (`PledgeStrip`, COMP0013 assignment) | Confirmed (as a mapping fact, not as current-state behavior) | `DESIGN-component-index.md` §1 row 16, §2; `_ar/evidence/design-system/components.md` §2 mapping row "PledgeStrip" |
