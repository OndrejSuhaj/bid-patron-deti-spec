---
doc_id: COMP0016
title: ProgressBar
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0001
  - WIRE0002
  - COMP0008
  - EN0004
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0016 – ProgressBar

*(promoted from inline evidence; canonical @patron/ui component: ProgressBar)*

> **Promotion note.** This component was **left inline** in the reconstruction — neither `WIRE0001`
> (catalogue card progress bar) nor `WIRE0002` (Story detail progress block) nor `COMP0008`
> StoryCard promoted a standalone `ProgressBar` COMP, because current-state evidence alone could not
> confirm the catalogue-card progress bar and the detail-page progress bar are the *same* reusable
> component (see `COMP0008` Open Questions and `WIRE0002-`-adjacent Components-Used note). It is
> promoted here **as the canonical target contract** (`DESIGN-component-index.md` row 7,
> `_ar/evidence/design-system/components.md` §1 "ProgressBar"), per instruction, with the
> current-state observations reconstructed underneath as a clearly separated, non-authoritative
> section. Per the project constitution's current-vs-target rule, the two must not be conflated.

---

## Design-system alignment (target)

> **STATE: TARGET — `@patron/ui` `ProgressBar` (Atom).** This section is the **authoritative
> canonical contract**, sourced from `DESIGN-component-index.md` row 7 and
> `_ar/evidence/design-system/components.md` §1 "ProgressBar". It sits at the same authority level
> as `it-zadani` (future/target design material) — **not** current-state truth — and must not be
> read back into "Current-state (observed)" below.

### Canonical identity

- **Name:** `ProgressBar` (Atom-level component, `packages/ui/src/components/ProgressBar/`).
- **Exported prop type:** `ProgressBarProps`.
- **Storybook stories:** `Začátek`, `TéměřVybráno`, `Vybráno`.
- **Purpose:** renders collection/campaign progress. A `brand → accent` color gradient spans the
  *whole* track continuously; the filled portion only **reveals** the gradient via `clip-path`, so
  the second gradient color (`--color-accent`) only becomes fully visible near 100% completion.
  This is a deliberate visual mechanic, not a simple two-color fill.

### Props / Inputs (canonical)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `value` | `number` (0–100) | yes | — | Progress percentage; clamped to `[0,100]` and rounded internally. |
| `height` | `number` (px) | no | `10` | Track/fill height in pixels. |
| `ariaLabel` | `string` | no | `"Průběh sbírky"` | Accessible label for the `progressbar` role. **Default is Czech-specific** — see Tenant behaviour below. |

Exported type: `ProgressBarProps`.

### Variants / states (canonical)

- **Variants:** `height` only (no color/shape variant axis — color always resolves through the
  fixed brand→accent gradient token pair).
- **States:** `default` / `0%` / `100%` — i.e., the same rendering logic at the two extremes of
  `value`, not distinct visual "modes." No hover/focus/disabled/loading/error states apply — the
  component is a non-interactive status indicator (see Accessibility).

### Token slots (canonical)

`var(--radius-pill)`, `var(--color-track)`, `var(--color-brand)`, `var(--color-accent)`.

Per `DESIGN-tokens.md` §3.1/§10: `--color-track` is the unfilled-track color (`color.track`,
tenant-bound: CZ `#FBECE6` / RO `#E1F3F2`); `--color-brand` and `--color-accent` are the two ends of
the reveal gradient (CZ brand `#EC4B34` → accent `#6D4AFF`; RO brand `#0FB5AE` → accent `#FF7A2F`);
`--radius-pill` gives the track/fill their fully-rounded ends (`999px`, tenant-shared value). All
four are consumed via `var(--…)` in the component's colocated CSS module — no hex/px literals
(`DESIGN-tokens.md` §10).

### Accessibility (canonical)

- **ARIA role:** `role="progressbar"`.
- **ARIA attributes:** `aria-valuemin`, `aria-valuemax`, `aria-valuenow` (reflects the clamped/
  rounded `value`).
- **Focusability:** explicitly **not focusable** — it is a status/indicator role, not an
  interactive control. No keyboard interaction, no focus-visible ring.
- **Screen reader:** announces as a progress indicator via the ARIA `progressbar` role and its
  `aria-value*` triad; the visible/accessible label comes from `ariaLabel`.

### Tenant (CZ/RO) behaviour

- `ProgressBar` itself takes no tenant-selection prop — color resolution is entirely token-driven
  via `data-theme="cz"|"ro"` remapping `--color-track`/`--color-brand`/`--color-accent` (no
  component code fork).
- **`ariaLabel`'s default value is Czech-specific** (`"Průběh sbírky"`). Per
  `DESIGN-component-index.md` row 7 A11y/Tenant notes: the **RO tenant must override this via the
  prop explicitly** — it is **not auto-localized** by the component itself. Any RO consumer that
  omits `ariaLabel` inherits the Czech default text, which is a concrete localization pitfall to
  flag for rebuild consumers (StoryCard, DonationBox) composing this atom under `data-theme="ro"`.

### Composition (canonical)

Leaf component — composes nothing. It is itself composed by:

- `StoryCard` (`COMP0008`'s canonical alignment) — catalogue/cross-sell card progress.
- `DonationBox` (target-only Block, no reconstructed current-state COMP yet) — story-detail
  conversion block progress.

```
ProgressBar (canonical, target)
  (leaf — no sub-components)
```

### Source references

`DESIGN-component-index.md` row 7 (Index table); full catalogue entry
`_ar/evidence/design-system/components.md` §1 "ProgressBar" and mapping row §2 "ProgressBar"
(`GAP→recon` classification); token values `DESIGN-tokens.md` §3.1 (`color.track`, `color.brand`,
`color.accent`), §6 (`radius.pill`), §10 (CSS-var naming). Canonical source path:
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/ProgressBar/`
(`ProgressBar.tsx`, `ProgressBar.stories.tsx`, `ProgressBar.module.css`, `ProgressBar.contract.md`,
`index.ts`).

---

## Current-state (observed)

> The section below documents Patronus's **current-state UI as observed in live-site
> screenshots**. It is evidence-gated reconstruction content, kept deliberately separate from the
> canonical target contract above. Nothing here should be read as a description of the rebuild
> design system.

### Purpose

A horizontal bar rendering a Campaign/Story's (`EN0004`) funding progress, observed in two distinct
screen contexts that are **visually similar but not confirmed to be the same underlying
component**:

1. **Catalogue card progress bar** (`WIRE0001`) — inside each `StoryCard` (`COMP0008`) in the
   homepage catalogue grid, alongside "Chybí `<amount>` Kč", "Cílová částka" and raised-amount rows.
2. **Story-detail progress block** (`WIRE0002`) — inside the story-detail page's donation sidebar,
   alongside "Chybí 1 600 Kč" + "Zbývá měsíc" / "Cílová částka 1 600 Kč" text.

Both renderings show a horizontal bar communicating funding percentage, but current-state evidence
does **not** confirm they are implemented as a shared, independently reusable component — this was
recorded explicitly as an unresolved question in both `COMP0008` ("Whether the story-detail page's
progress block (`WIRE0002`) shares a component with this card's progress figures, or is
independently implemented") and `WIRE0002` ("Uncertain whether this shares a component with
`COMP0008` Story Card's internal progress figures — not confirmed identical, left inline"). This
promotion does **not** resolve that current-state uncertainty by fiat; it is carried forward
unresolved below. (The canonical target model *does* resolve it — both consume the same
`ProgressBar` atom — but that is target intent, not a current-state finding.)

### Props / Inputs (as observed)

No DOM/props evidence is available (static screenshots only). Observed data bound alongside the bar
in both contexts, reconstructed at the `EN0004`/`WIRE` level, not confirmed as this component's own
props:

| Name (reconstructed) | Type | Description |
|---|---|---|
| `percentComplete` | `number` (implied) | Visual fill proportion; no numeric label observed directly on the bar itself — surrounding text ("Chybí `<amount>` Kč", "Cílová částka `<amount>` Kč") carries the figures. |

`Uncertain` — whether the bar itself renders a `value`-like prop distinct from the surrounding
target/collected text, or is purely a derived visual (e.g. inline `style` width) with no discrete
component API, cannot be determined from screenshots.

### Variants (as observed)

`Uncertain` — no distinct visual variant (e.g. color/height change) was observed between the
catalogue-card and story-detail renderings beyond their different surrounding layouts; whether a
height/size axis exists cannot be confirmed from static evidence.

### States

#### idle
Static bar rendering as captured. Confirmed — catalogue-card context:
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`; story-detail context:
`_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`.

#### hover
`Uncertain — not observable from static evidence` (non-interactive element, no hover state
expected, but not confirmed either way).

#### focused
`Uncertain — not observable from static evidence.`

#### disabled
`N/A` — no disabled rendering observed or plausible for a progress indicator.

#### loading
`Uncertain — no skeleton/loading-placeholder state was captured for either context; Evidence
Pending per WIRE0001/WIRE0002 States.`

#### error
`N/A` — no per-bar error state observed; page/grid-level empty/error states are recorded at the
WIRE level, not owned by this element.

### Events

No events emitted (or observable) — a static, non-interactive visual indicator in both captured
contexts.

### Accessibility (as observed)

Usually not directly observable from screenshots; recorded as `Uncertain` throughout per COMP rules.

- **ARIA role:** `Uncertain` — no DOM evidence available.
- **Keyboard navigation:** `Uncertain`.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain` — whether the current-state implementation announces a percentage
  or label is not confirmable from screenshots.

### Usage Constraints (as observed)

- Use when: rendering a Campaign/Story's (`EN0004`) funding progress inside a catalogue card
  (`WIRE0001`) or the story-detail donation sidebar (`WIRE0002`).
- Do not use when: `Uncertain` — no other current-state usage context observed.
- Cardinality: one per progress-bearing card/sidebar instance (observed ×6 per catalogue tab via
  `COMP0008`'s repeated StoryCard, ×1 in the story-detail sidebar — noting `WIRE0002`'s own
  unresolved "duplicate sidebar" Open Question, which would double this if the duplication is a
  genuine second instance rather than a layout artifact).
- Placement: inside `COMP0008` StoryCard, and inside the story-detail donation sidebar's "Progress
  block" row (`WIRE0002` Components Used table).

### Dependencies (as observed)

- Other COMPs: composed within `COMP0008` StoryCard (current-state, marked "Uncertain whether this
  is COMP0008-internal only" in that doc's own Composition section) and within `WIRE0002`'s inline
  "Progress block" row. Not confirmed as an independently reusable current-state component prior to
  this promotion.
- Data entities: `EN0004` Campaign — binds the derived `campaign_raised` / `campaign_percentual_raised`
  vs. `gift_price` (target) fields per `BR-CampaignStoryLifecycle`, as recorded in `WIRE0002`'s Data
  Bindings table. The bar only *renders* these derived values; it does not compute them (`UC0011`
  owns the lifecycle computation, per `WIRE0002` Purpose).
- ACL: none evidenced.
- External libraries: none evidenced.

### Composition (as observed)

```
ProgressBar (current-state, as observed — inline, not independently confirmed reusable)
  (no confirmed sub-elements; rendered as internal markup within COMP0008 StoryCard
   and within WIRE0002's "Progress block" row)
```

### Divergence from canonical target (record, do not "correct")

- **Reusability status.** Current-state evidence leaves it genuinely `Uncertain` whether one
  component renders both the catalogue-card bar and the story-detail bar. The canonical target
  resolves this definitively — a single `ProgressBar` Atom composed by both `StoryCard` and
  `DonationBox`. This promotion adopts the canonical resolution **only for the target section
  above**; the current-state uncertainty is preserved here, not silently closed.
- **No numeric `value` prop observed.** Current-state screenshots show surrounding text figures
  ("Chybí `<amount>` Kč", "Cílová částka") but no separately observable percentage label on the bar
  itself, unlike the canonical `value` (0–100) prop contract.
- **No accessibility contract observed.** Canonical mandates `role="progressbar"` +
  `aria-valuemin/max/now` and explicit non-focusability. Current-state accessibility is uniformly
  `Uncertain` (no DOM/recording evidence), per the cross-cutting reconciliation note in
  `_ar/evidence/design-system/components.md` §2.
- **No gradient-reveal mechanic confirmed.** The canonical `clip-path` brand→accent gradient
  reveal is a specific visual mechanic; current-state screenshots were not analyzed at
  pixel/CSS level to confirm or rule out a similar effect — left `Uncertain`, not asserted absent.
- **No tenant dimension observed.** Current-state evidence is CZ-only (single tenant); the
  canonical tenant remapping (CZ/RO via `data-theme`) and the `ariaLabel` Czech-default pitfall are
  target-only considerations with no current-state RO evidence to compare against.

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Bar present in catalogue-card context | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`; `WIRE0001` Layout Zones "progress bar" |
| Bar present in story-detail sidebar context | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`; `WIRE0002` Layout Zones "progress block" |
| Data binding to `EN0004` derived fields | Probable | `_ar/spec-draft/EN/EN0004_Campaign.md`; `_ar/spec-draft/BR/BR-CampaignStoryLifecycle.md`; `WIRE0002` Data Bindings row |
| Shared-component identity across the two contexts | Uncertain | `COMP0008` Open Questions; `WIRE0002` Components Used note (both explicitly unresolved) |
| Accessibility | Uncertain | no DOM/recording evidence available |
| Props/variants/states beyond visual fill | Uncertain | static screenshots only, no interactive/DOM evidence |
