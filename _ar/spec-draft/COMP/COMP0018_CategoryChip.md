---
doc_id: COMP0018
title: CategoryChip
canonical_layer: COMP
spec_type: component
modules: []
status: draft
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/CategoryChip/
references:
  - WIRE0001
  - WIRE0002
  - EN0004
  - COMP0008
  - COMP0011
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0018 – CategoryChip

## Purpose

This document promotes **CategoryChip**, a canonical `@patron/ui` **Atom**, per the task
instruction ("this component was left inline in the reconstruction; promote it now"). It holds
**two clearly separated bodies of fact** per the project's current-vs-target discipline:

- **Design-system alignment (target)** — the authoritative canonical contract for CategoryChip as
  built in the `bid-patron-deti` rebuild library (`packages/ui/src/components/CategoryChip/`): a
  story-category indicator whose color is unified across every place a category surfaces (chip
  itself, card wash, hero corner) — "same category = same color everywhere."
- **Current-state (observed)** — what the reconstructed Patronus current-state UX
  (`WIRE0001_HomepageStoryCatalogue.md`, `WIRE0002_StoryDetailAndDonationModal.md`) actually shows
  as the equivalent category indicator, which was left `inline` (no promoted COMP) because
  current-state evidence did not previously support an isolated reusable-atom claim.

These two parts describe **different systems** (rebuild target vs. reconstructed current
Patronus) and must not be merged into one fact. Per `DESIGN-component-index.md` row 5, the
canonical contract is the authoritative target; the current-state part below records only what was
directly observed on the live site, with divergences flagged rather than silently resolved.

Cross-reference: this doc reconciles against `DESIGN-component-index.md` row 5 and
`_ar/evidence/design-system/components.md` §1 "CategoryChip — `components/CategoryChip/`". It is
also referenced as a composed sub-component by `COMP0008` (StoryCard, target Composition) and
`COMP0011` (StoryHero, target Composition/Dependencies).

---

## Design-system alignment (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Everything in this part describes the rebuild's canonical component
> (`packages/ui/src/components/CategoryChip/`), not Patronus's current behavior. Authoritative
> source: `_ar/evidence/design-system/components.md` §1 "CategoryChip" and
> `DESIGN-component-index.md` row 5. This is the **authoritative contract** for CategoryChip; the
> "Current-state (observed)" part further below is a separate, current-state-only account and does
> not amend this contract.

### Purpose (target)

Story-category indicator, unified across the storefront UI: the same category always renders with
the same color, whether shown as a standalone chip, as a card background wash, or as a corner
overlay on the story hero. Composed by `StoryCard` (`COMP0008`) and `StoryHero` (`COMP0011`) as
their category-color mechanism.

### Props / Inputs (target)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `category` | `StoryCategory` (`"development" \| "health" \| "subsistence"`) | yes | — | Drives which `--color-category-*` token the chip renders with, via an internal `--cat` custom property. Binds `EN0004`'s category attribute. |
| `label` | `string` | yes | — | Display-ready category label text (e.g. "Rozvoj a vzdělání", "Zdraví", "Existenční potřeby"); not translated/formatted inside the component. Also carries the accessible name (see Accessibility). |

Exported types: `CategoryChipProps`, `StoryCategory` (per `components.md` §1).

### Variants (target)

- **category:** `development` | `health` | `subsistence` — one variant per category value, each
  driving a distinct `--color-category-*` token through the `--cat` custom property. There is no
  independent "variant" axis beyond the `category` prop itself — visual variant and data value are
  the same thing.
- **size:** fixed — no size prop/axis is documented (per `components.md` §1: "Sizes: fixed").

### States (target)

#### idle
Only documented state: category-tinted background + text, rendered at all times. Per
`components.md` §1: "States: idle (category-tinted bg + text)."

#### hover
`Uncertain — not itemized in the canonical catalogue; CategoryChip is not documented as an
interactive element (no onClick/href prop in the exported CategoryChipProps).`

#### focused
`Uncertain — not itemized; consistent with hover, the component is presentational, not a control.`

#### disabled
N/A — no disabled rendering is part of the canonical contract; CategoryChip is a display atom, not
a control.

#### loading
N/A — not itemized in the canonical catalogue; category and label are required, synchronously
available props.

#### error
N/A — no error-state rendering is documented (no validation/error prop in `CategoryChipProps`).

### Events (target)

No events emitted — `CategoryChipProps` (per `components.md` §1) lists only display props
(`category`, `label`); the component is a presentational Atom with no documented callback.

### Accessibility (target)

- **ARIA role:** not separately documented; renders as a plain inline element carrying text content
  (the `label`), no interactive/native-control role implied.
- **Composed icon is decorative:** the internally composed `Icon` (category-matched glyph, size
  15px) carries no accessible name of its own — per `DESIGN-component-index.md` row 5 A11y notes:
  "Composed `Icon` is category-matched (size 15) — decorative, label text carries the accessible
  name." The `label` prop's text is therefore the sole source of the chip's accessible name.
- **Keyboard navigation:** N/A — no focusable/interactive element is documented as native to
  CategoryChip.
- **Focus management:** N/A for the same reason.
- **Screen reader:** announces the `label` text; the composed icon is not separately announced
  (decorative, per above).

### Tenant behavior (target — CZ/RO via `data-theme`)

- CategoryChip itself takes **no tenant-specific props** — the 3-value category taxonomy
  (`development`/`health`/`subsistence`) is shared across both tenants; only the *color mapping* is
  tenant-bound, not the taxonomy or the component API. Per `DESIGN-component-index.md` row 5 Tenant
  notes: "Category taxonomy (3 values) is shared across tenants; color mapping is token-level, not
  tenant-switched."
- Re-skinning across `data-theme="cz"|"ro"` happens entirely through token remapping:
  - `var(--color-category-development)` — CZ `#149E6E` / RO `#0FB5AE`, per `DESIGN-tokens.md` §3.3.
  - `var(--color-category-health)` — CZ `#6D4AFF` / RO `#2F7DBF`, per `DESIGN-tokens.md` §3.3.
  - `var(--color-category-subsistence)` — CZ `#C2740A` / RO `#FF7A2F`, per `DESIGN-tokens.md` §3.3.
- The composed `Icon` atom's glyph **style** (line vs. filled) follows the tenant convention — CZ =
  line, RO = filled — switched via `data-theme` on the `Icon` atom itself, not a CategoryChip-level
  prop (per `DESIGN-component-index.md` row 3 "Icon" Tenant notes).

> **Open point (do not treat as closed):** `DESIGN-tokens.md` §9 flags that "the three categories in
> §3.3 (development, health, subsistence) are asserted from the canonical prototype/design-system
> demo only. The binding category list (and per-tenant color mapping) for the rebuild must be
> confirmed by BA/analyst work before the UX layer treats `color.category.*` as a closed set." This
> applies directly to CategoryChip's `category` union type — it is the canonical prototype's current
> shape, not a BA-confirmed final taxonomy.

### Usage Constraints (target)

- Use when: indicating a story's category anywhere in the storefront UI where the category-color
  convention should apply consistently (standalone chip, composed inside `StoryCard`/`StoryHero`).
- Do not use when: a category-colored *surface wash* or *hero corner overlay* is needed without the
  chip's own pill shape — those are separate rendering treatments in the composing Block
  (`StoryCard`/`StoryHero`) that share the same `--color-category-*` token, not this component
  reused verbatim as a wash.
- Cardinality: typically one per story context (one chip per `StoryCard` instance, one per
  `StoryHero` instance); multiple simultaneous instances are expected across a grid/list.
- Placement: inline within a composing Block (`StoryCard`, `StoryHero`) or standalone; not
  documented as an overlay/modal element.

### Dependencies (target)

- Other COMPs (composition): composes `Icon` (`DESIGN-component-index.md` row 3) — category-matched
  glyph, size 15, decorative.
- Data entities: `EN0004` Campaign — category attribute (current-state binding note under
  Current-state part below).
- ACL: none documented.
- External libraries: none documented.

### Composition (target)

```
CategoryChip
  └─ Icon (category-matched glyph, size 15, decorative)
```

Composed **by** (consumers, not sub-components of CategoryChip):

```
StoryCard  (COMP0008, target) ──uses──▶ CategoryChip (COMP0018)
StoryHero  (COMP0011, target) ──uses──▶ CategoryChip (COMP0018)
```

### Token slots (target — canonical CSS vars, see `DESIGN-tokens.md`)

| Token | Role here |
|---|---|
| `var(--color-category-development)` | Chip background/text tint when `category="development"` |
| `var(--color-category-health)` | Chip background/text tint when `category="health"` |
| `var(--color-category-subsistence)` | Chip background/text tint when `category="subsistence"` |
| `var(--color-surface)` | Chip text/foreground surface reference (per `components.md` §1 token list) |
| `var(--font-body)` | Chip label typography |
| `var(--radius-pill)` | Chip shape (fully rounded pill) |

Per `DESIGN-tokens.md` §10, all are consumed via `var(--…)` in the component's colocated CSS module
— no hex/px literals in component code; the category→color mapping resolves through a `--cat`
custom property indirection (per `components.md` §1: "drives `--cat` custom prop →
`--color-category-*`").

### Examples (target)

```
<CategoryChip category="development" label="Rozvoj a vzdělání" />
<CategoryChip category="health" label="Zdraví" />
<CategoryChip category="subsistence" label="Existenční potřeby" />
```

Storybook stories (per `components.md` §1): `Rozvoj`, `Zdraví`, `Existenční`.

---

## Current-state (observed — reconstructed Patronus current-state UX)

> **STATE: CURRENT.** Everything in this part describes what was actually observed on the live
> Patronus site, from static screenshot evidence of the homepage catalogue
> (`WIRE0001_HomepageStoryCatalogue.md`, screen `S001`) and the Story detail screen
> (`WIRE0002_StoryDetailAndDonationModal.md`, screen `S002`). It does **not** describe the rebuild
> target above. Per `rules-COMP.md`, a COMP is only created "when reuse is observable across two or
> more WIRE screens/screenshots" — for the category indicator specifically, reuse across ≥2
> confirmed-built screens (`WIRE0001`, `WIRE0002`) **is** evidenced (see Evidence table), which is
> exactly why this element is being promoted now rather than left `inline`. However, the *component
> boundary itself* (is it an isolated reusable chip, or is it always rendered as part of a larger
> composite like the stat-strip pill or the card badge?) remains less certain than the target
> contract's clean Atom boundary — this current-state part records that residual uncertainty rather
> than resolving it by borrowing the target's shape.

### Where it appears on the live site today

- **`WIRE0001` — Homepage story catalogue (`S001`), "Stat strip" zone.** Two **category pill
  CTAs** appear next to the "323 dětí čeká na pomoc" numeral stat: `WIRE0001` line 51 "Stat strip —
  '323 dětí čeká na pomoc' + 2 category pill CTAs"; line 86 describes them as "two pill-shaped
  category ... map [links]". `WIRE0001` line 132 (Components Used) explicitly flags these as
  `inline` with an open question: "category pills' filter effect not confirmed as wired to the grid
  below (Uncertain — no visible active-state change captured)."
- **`WIRE0001` — catalogue grid card badge.** Each catalogue card carries a "category icon badge"
  per `WIRE0001` line 90 (card anatomy: "category icon badge, photo, 'ZBÝVÁ <n> <unit>' countdown
  ribbon..."). This is the closest current-state analogue to the target `CategoryChip` composed
  inside `StoryCard` (`COMP0008`), but `COMP0008`'s own current-state Composition section does
  **not** itemize a category badge as a confirmed sub-element of the card (see Divergence below) —
  it was captured only at the WIRE layer, not folded into `COMP0008`'s current-state Composition.
- **`WIRE0002` — Story detail page (`S002`), donation sidebar.** A **category tag** ("Rozvoj a
  vzdělání") with icon appears inside the donation sidebar: `WIRE0002` line 64 "Donation sidebar...
  category tag ('Rozvoj a vzdělání') with icon"; also summarized in the Media zone description,
  line 31: "the fundraising case (child, category, ...)". `COMP0011` (StoryHero)'s own Divergence
  section records that this sidebar tag is **not** confirmed to be composed onto the hero photo
  corner in current-state — it sits in the sidebar, not overlaid on the media zone.
- **Screenshot evidence:**
  `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (homepage catalogue, stat-strip
  pills + card badges) and
  `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`
  (Story detail sidebar category tag).

### Current-state props/behavior observed

- **Label text observed:** "Rozvoj a vzdělání" (`WIRE0002` line 64) and "Zdravotní pomoc" /
  "Rozvoj a vzdělání" as the two stat-strip pill labels (`WIRE0001` line 181: "Secondary action —
  category pill CTA ('Zdravotní pomoc' / 'Rozvoj a vzdělání')"). Two of the target's three category
  values (`development`, and a health-labeled pill) have direct current-state label evidence; a
  current-state rendering explicitly labeled for the target's `subsistence` category is **not**
  confirmed in these two screens — `Uncertain` whether current Patronus exposes a third
  visually-distinct category tint on the live catalogue/detail screens, or only two.
- **Icon presence:** the catalogue card's "category icon badge" (`WIRE0001` line 90) and the
  sidebar's category tag "with icon" (`WIRE0002` line 64) both confirm an icon accompanies the
  label in current-state, consistent with the target's composed `Icon`. The specific glyph-per-
  category mapping is **not** confirmed from static screenshots — `Uncertain`.
- **Color-per-category consistency: `Uncertain`.** The target contract's central claim ("same
  category = same color everywhere — chip, card wash, hero corner") is a *target-side* design
  principle (`components.md` §1: "unified across UI"). Whether current-state Patronus actually
  applies one consistent color per category across the stat-strip pill, the card badge, and the
  sidebar tag is **not verifiable** from the available screenshots (colors were not systematically
  compared across all three placements in the WIRE captures) — record as `Uncertain`, do not assume
  the target's unification principle already holds true in current-state.
- **Interactivity — stat-strip pills only.** Unlike the target contract (presentational, no
  events), the current-state stat-strip category pills are explicitly **CTAs** — `WIRE0001` line
  181–182: "click → presumed filter/navigation to a category-scoped view; **Uncertain** — no
  before/after comparison [captured]." This is a current-state-only interactive behavior with no
  counterpart in the target `CategoryChip` contract (see Divergence below).
- **Category-support CTA on detail page.** `WIRE0002` line 175–177 records a related but distinct
  element: "Secondary action — category-support CTA — 'Chci podporovat rozvoj a vzdělání' doubles
  as a category-level support entry... same target as recurring CTA per evidence (no separate
  category-only flow observed) — Assumed." This is a CTA button that *references* the category by
  name in its label, not the category tag/chip itself — kept distinct here, not folded into this
  COMP's current-state account.

### Current-state Variants / States / Events / Accessibility

Per `rules-COMP.md` evidence discipline, unobserved axes are recorded as `Uncertain`, not
fabricated:

- **Variants:** Two placements are evidenced with distinct current-state behavior — (a) stat-strip
  pill CTA (`WIRE0001`, clickable) and (b) sidebar/card informational tag (`WIRE0002`, catalogue
  card badge — no click behavior confirmed). Whether these are the *same* underlying current-state
  component rendered with an optional CTA affordance, or two separately built elements that merely
  look similar, is `Uncertain` — not resolved by this reconstruction pass.
- **Category-value variants:** `development`- and health-labeled instances are directly evidenced;
  a `subsistence`-equivalent labeled instance is `Uncertain — not captured in WIRE0001/WIRE0002`.
- **States (hover/focused/disabled/loading/error):** `Uncertain — not observable from static
  evidence` for all placements, consistent with the overall a11y/interaction posture recorded across
  `WIRE0001`/`WIRE0002`.
- **Events:** the stat-strip pill CTA (`WIRE0001`) has a presumed but unconfirmed click→navigation
  effect (Uncertain, see above); the sidebar tag (`WIRE0002`) and catalogue card badge (`WIRE0001`)
  have **no** event observed — recorded as static/informational.
- **Accessibility:** `Uncertain — no DOM/recording evidence for any placement, consistent with
  WIRE0001`'s and `WIRE0002`'s overall a11y posture.`

### Current-vs-target divergence (record, do not "correct")

1. **Current-state has an interactive CTA variant; target has none.** The stat-strip category pills
   on `WIRE0001` behave as clickable CTAs (presumed filter/navigation). The target `CategoryChip`
   contract documents no events/callback props at all (presentational Atom only). This is a genuine
   current-vs-target behavioral gap, not a naming difference — the rebuild's canonical Atom, as
   currently specified, would need a different composing element (or a prop addition not yet
   documented) to reproduce the current-state pill-CTA behavior.
2. **Target unifies color across three placements; current-state unification is unconfirmed.** The
   target's defining principle — "same category = same color everywhere (chip, card wash, hero
   corner)" — is not verified against current-state evidence (see above, "Color-per-category
   consistency: Uncertain"). Do not read the target's unification claim as already true of
   Patronus today.
3. **Third category value unconfirmed in current-state.** The target taxonomy has three values
   (`development`/`health`/`subsistence`); current-state evidence directly confirms only two
   distinct labels (health-related, development-related) across the two captured screens. Whether
   current Patronus has a third, `subsistence`-equivalent category tint/label is `Uncertain`.
4. **Component boundary is less clean in current-state.** The target `CategoryChip` is a
   free-standing Atom composed by name into `StoryCard`/`StoryHero`. In current-state evidence, the
   category indicator was captured as part of larger composite descriptions ("category icon badge"
   inside the catalogue card anatomy list, `WIRE0001` line 90; "category tag... with icon" inside
   the donation-sidebar anatomy list, `WIRE0002` line 64) rather than as an independently identified
   element in either WIRE doc's own Components Used table. Promoting it here to COMP0018 follows the
   task instruction and the ≥2-screen reuse threshold, but the underlying current-state element
   boundary (chip vs. badge vs. tag — same thing or three similar-looking things) remains `Uncertain`.
5. **No current-state "card wash" or "hero corner" analogue confirmed.** The target's other two
   unified placements (category-tinted card background wash; hero-corner chip overlay) have no
   direct current-state evidence: `COMP0008`'s current-state Composition section does not record a
   category-tinted wash on the catalogue card, and `COMP0011`'s current-state part explicitly records
   the sidebar tag as *not* confirmed to be composed onto the hero photo corner. Both remain
   target-only facts.

### Dependencies (current-state)

- Other COMPs: none confirmed as an independently reusable current-state sub-element — the category
  indicator was recorded `inline` within `WIRE0001`'s and `WIRE0002`'s own layout-zone anatomy, not
  as a distinct entry in either screen's Components Used table.
- Data entities: `EN0004` Campaign — category attribute, per `WIRE0002` Data Bindings: `"Category
  tag ('Rozvoj a vzdělání') | EN0004 | — | gift_category attribute"` (`WIRE0002` line 238).
- ACL: none evidenced.
- External libraries: none evidenced.

### Composition (current-state)

```
Stat strip (WIRE0001, S001) — current-state, inline
  └─ category pill CTA ×2 ("Zdravotní pomoc", "Rozvoj a vzdělání"; click behavior Uncertain)

Catalogue card (WIRE0001, S001) — current-state, inline within COMP0008's card anatomy
  └─ category icon badge (icon + implied category; not itemized as its own Components-Used row)

Donation sidebar (WIRE0002, S002) — current-state, inline
  └─ category tag ("Rozvoj a vzdělání" + icon; static, no confirmed click behavior)
```

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 confirmed-built screens (COMP-promotion threshold) | Confirmed | `WIRE0001` (stat-strip pills + card badge) and `WIRE0002` (sidebar tag) both show a category indicator |
| Stat-strip pill CTA presence | Confirmed | `WIRE0001` lines 51, 86, 181–182 |
| Stat-strip pill click/filter behavior | Uncertain | `WIRE0001` line 132: "not confirmed as wired to the grid below"; line 182: "no before/after comparison" |
| Catalogue card category icon badge | Confirmed | `WIRE0001` line 90 (card anatomy) |
| Donation-sidebar category tag ("Rozvoj a vzdělání" + icon) | Confirmed | `WIRE0002` line 64; screenshot `screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png` |
| `gift_category` / `EN0004` data binding | Confirmed | `WIRE0002` line 238 (Data Bindings) |
| Color-per-category consistency across placements | Uncertain | not systematically compared across WIRE captures |
| Third (`subsistence`-equivalent) category value in current-state | Uncertain | only two distinct labels captured across `WIRE0001`/`WIRE0002` |
| Component boundary (single chip vs. distinct badge/tag/pill elements) | Uncertain | not itemized as its own entry in either screen's Components Used table |
| Accessibility (all placements) | Uncertain | no DOM/recording evidence available |
| Target canonical contract (props/variants/states/tokens/a11y) | Confirmed (as target fact) | `_ar/evidence/design-system/components.md` §1 "CategoryChip"; `DESIGN-component-index.md` row 5; source `packages/ui/src/components/CategoryChip/{CategoryChip.tsx, CategoryChip.contract.md, CategoryChip.module.css}` |

---

## Open Questions

- Whether current-state Patronus applies one consistent color per category across all three
  observed placements (stat-strip pill, catalogue card badge, sidebar tag) — not resolvable from
  existing captures without a dedicated color-comparison pass across screenshots.
- Whether current-state Patronus has a third category value equivalent to the target's
  `subsistence` — `Uncertain`, no evidence either way in `WIRE0001`/`WIRE0002`.
- Whether the stat-strip pill CTA (`WIRE0001`), the catalogue card badge, and the sidebar tag
  (`WIRE0002`) are rendered by the *same* current-state template/partial, or are three independently
  built elements that happen to look similar — not resolvable from static screenshots; would require
  DOM/source inspection of `intake/current-solution/_source/patronus/` (out of this doc's evidence
  base) to close definitively.
- Whether current-state Patronus's stat-strip category pill click actually filters/navigates the
  catalogue grid — flagged Uncertain at the WIRE layer (`WIRE0001` line 132, 182) and carried forward
  here unresolved.
- Whether the rebuild's target `CategoryChip` (presentational-only, per its canonical contract) is
  intended to fully replace the current-state's interactive stat-strip filter pill, or whether that
  filter behavior is expected to live in a different future component/composition — not decided by
  `components.md`/`DESIGN-component-index.md`; a rebuild-scope question, not a reconciliation this
  doc can resolve.
