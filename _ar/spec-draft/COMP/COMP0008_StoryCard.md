---
doc_id: COMP0008
title: StoryCard
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0001
  - WIRE0019
  - WIRE0020
  - EN0004
  - EN0021
  - UC0023
  - DESIGN-component-index
  - DESIGN-tokens
  - COMP0016
  - COMP0017
  - COMP0018
---

# COMP0008 – StoryCard

*(reconstructed as Story Card; canonical @patron/ui component: StoryCard)*

---

## Current-state (observed)

> The section below (through "Evidence") documents Patronus's **current-state UI as observed in
> live-site screenshots**. It is unchanged reconstruction content — only the title/doc heading
> above was renamed to align with the canonical component name. Do not read anything in this
> section as a description of the rebuild design system; see "Design-system alignment (target)"
> further down for the `@patron/ui` `StoryCard` contract.

## Purpose

A card summarizing one Campaign/Story (`EN0004`): child photo, a countdown-to-deadline ribbon,
title, target-vs-collected funding figures, and a primary CTA. This is the catalogue's core
repeating unit and is directly observed with a consistent core shape across the homepage catalogue
grid (`WIRE0001`, ×6 per tab) and the completed-stories grid on the "Výsledky" screen (`WIRE0019`,
×6), with an additional composed variant referenced only by analogy in the Evidence-Pending/
Hypothesis account-dashboard mockup (`WIRE0020`). Two-screen reuse with independent screenshot
evidence is Confirmed for the base card; the completed-state and dashboard variants are recorded as
distinct, less-certain siblings rather than silently merged into one "same component" claim.

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `photo` | `image` | yes | — | Child/story photo. |
| `title` | `string` | yes | — | Story title, e.g. "Balík školních potřeb pro Miriam"; COPY-owned per instance. |
| `targetAmount` | `number (Kč)` | yes | — | "Cílová částka" — target funding amount; binds `EN0004`. |
| `collectedAmount` | `number (Kč)` | conditional | — | "Vybráno" / "Chybí {amount} Kč" — collected-so-far figure; binds `EN0004` (derived field, see WIRE0001/WIRE0002 Data Bindings). |
| `deadlineBadge` | `string` | no | — | Countdown ribbon text; observed values vary: "ZBÝVÁ MĚSÍC" / "ZBÝVÁ DEN" / "ZBÝVÁ 4 DNY" / "ZBÝVÁ 16 DNÍ" / "ZBÝVÁ 24 DNÍ". |
| `isCollectionAccount` | `boolean` | no | `false` | Renders the "SBÍRKOVÝ ÚČET" group/parent-Campaign variant observed once on `WIRE0001` ("Necháte výběr dítěte, kterému chcete pomoct na nás?"), binding `EN0004`'s group/parent mechanism (Partial per `UC0023` Traceability). |
| `ctaLabel` | `string` | yes | — | Primary CTA text, e.g. "Podpořím Miriam", "Nechám to na vás", "Detail příběhu". |
| `completedBadges` | `string[]` | no | `[]` | Completed-state badges observed only on `WIRE0019`'s variant: "SPLNĚNO" status ribbon + "ZPĚTNÁ VAZBA" pill + hand-icon chip. Not present on the base `WIRE0001` card. |

## Variants

- **lifecycle:** active (base catalogue card, `WIRE0001` — countdown ribbon + progress + "Podpořím"
  CTA) | completed (`WIRE0019` — adds "SPLNĚNO" ribbon, "ZPĚTNÁ VAZBA" pill, checkmark icon next to
  the collected total, "Detail příběhu" CTA instead of a donate CTA). The completed variant is a
  distinct visual family confirmed by direct screenshot comparison, not assumed identical to the
  active variant — see `WIRE0019` Components Used note: "same card pattern family... but with the
  completed-state variant... not confirmed to be the identical component."
- **story-type:** individual child (default) | collection-account/group (`isCollectionAccount=true`,
  `EN0004` group/parent mechanism, Partial evidence)

## States

### idle
Static card rendering as described in Props. Confirmed — active variant:
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (catalogue grid);
completed variant: `_ar/prtsc/screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png`.

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — no disabled rendering observed. (Not to be confused with the zero-active-Campaign-region
disabled state on the region-map component elsewhere on `WIRE0001`, which is a different element.)

### loading
`Uncertain — no skeleton/loading-placeholder state was captured for the catalogue grid; Evidence
Pending per WIRE0001 States.`

### error
N/A — no per-card error state observed; grid-level empty/error states are recorded at the WIRE
level (`WIRE0001` States: "empty/loading/error: Evidence Pending"), not owned by this component.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onCtaClick` | story identifier | click on the primary CTA button | Active variant → donation entry (`UC0005`/`UC0011`, per `WIRE0002`); completed variant → story detail read view (`UC0011`, per `WIRE0019`). |
| `onCardClick` | story identifier | `Uncertain` — whether the card body itself (photo/title) is independently clickable, separate from the CTA, is not confirmed from static evidence. | |

## Accessibility

- **ARIA role:** `Uncertain` — Assumed `<article>`/`<li>` native semantics within a grid/list; not confirmed.
- **Keyboard navigation:** `Uncertain`.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain` — whether progress figures are announced with units/context is not confirmable from screenshots.

## Usage Constraints

- Use when: rendering a Campaign/Story summary inside a browsable grid (catalogue, completed-stories
  list).
- Do not use when: rendering the full Story detail page (→ `WIRE0002`'s own dedicated layout, not
  this card).
- Cardinality: repeated N-up in a grid (observed: 6 per tab on `WIRE0001`, 6 on `WIRE0019`).
- Placement: inside a grid/list zone only; not used standalone.

## Dependencies

- Other COMPs: none confirmed as composed sub-elements (the progress figures and CTA button are
  drawn inline within the card's own layout in evidence, not confirmed as independently reusable
  `COMP0001`-identical buttons — the catalogue CTA is smaller/card-scoped and not asserted as the
  same component).
- Data entities: `EN0004` Campaign (target/collected amounts, deadline, group/parent mechanism);
  `EN0021` Feedback (the completed-variant's "ZPĚTNÁ VAZBA" badge binding is Uncertain per
  `WIRE0019`, not confirmed as a direct `EN0021` join).
- ACL: none evidenced.
- External libraries: none evidenced.

## Composition

```
StoryCard (active variant)
  ├─ photo
  ├─ deadline countdown ribbon
  ├─ title
  ├─ progress block (target/collected figures — Uncertain whether this is COMP0008-internal only,
  │    or shares a component with the story-detail page's own progress block on WIRE0002; not
  │    confirmed identical, left as an open question rather than a second COMP)
  └─ CTA (card-scoped; not confirmed identical to COMP0001)

StoryCard (completed variant, WIRE0019)
  ├─ photo
  ├─ "SPLNĚNO" status ribbon + "ZPĚTNÁ VAZBA" pill + hand-icon chip
  ├─ title
  ├─ "Vybráno celkem" + amount + checkmark icon
  └─ "Detail příběhu" CTA
```

## Open Questions

- Whether the active and completed variants are genuinely the same underlying component
  (parameterized by lifecycle state) or two separately built card templates — `WIRE0019` itself
  flags this as "not confirmed to be the identical component"; carried forward here rather than
  resolved.
- Whether the story-detail page's progress block (`WIRE0002`) shares a component with this card's
  progress figures, or is independently implemented.
- The `WIRE0020` (account-dashboard mockup, Hypothesis/unconfirmed-as-built) shows a further
  "contribution banner overlay" card cousin ("Přispěli jste {amount}") — explicitly NOT folded into
  this COMP given the screen's own unconfirmed-as-built status; left inline in `WIRE0020` per the
  ≥2-screen rule applying only to confirmed-built screens.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 confirmed-built screens | Confirmed | `WIRE0001` (×6 per tab) and `WIRE0019` (×6); `WIRE-synthesis-report.md` §6 "Progress/funding-amount bar" and card pattern note in `WIRE0019` |
| Active-variant visual state | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` |
| Completed-variant visual state | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png` |
| Identity of active vs. completed as "the same" component | Uncertain | flagged verbatim in `_ar/spec-draft/WIRE/WIRE0019_HowItWorksResults.md` Components Used |
| Dashboard-mockup cousin (WIRE0020) | Uncertain/Hypothesis | screen itself unconfirmed as built; excluded from this COMP's confirmed scope |
| Accessibility | Uncertain | no DOM/recording evidence available |

---

## Design-system alignment (target)

> **STATE: TARGET — `@patron/ui` `StoryCard` (Block).** This section describes the **rebuild
> design system's** canonical component contract, per `DESIGN-component-index.md` row 8 and
> `_ar/evidence/design-system/components.md` §1 "StoryCard". It sits at the same authority level as
> `it-zadani` (future/target), **not** current-state truth, and must not be read back into the
> "Current-state (observed)" section above. Per the reconciliation mapping
> (`components.md` §2), the relationship to this COMP is **MATCH (name), contract differs** — see
> divergences below.

### Canonical identity

- **Name:** `StoryCard` (Block-level component, `packages/ui/src/components/StoryCard/`).
- **Exported prop type:** `StoryCardProps`.
- **Storybook stories:** `Zdraví`, `Rozvoj`, `TéměřVybráno`, `BezFotky`.
- **Purpose:** the storefront's core repeating unit — one child's story + collection progress
  inside list contexts (catalogue grid, "Další děti" cross-sell rail on the StoryDetail page).
  Clickable donor-acquisition unit → story detail.

### Composition (canonical)

It is a **Block** that composes three canonical **Atoms**, rather than rendering its countdown
ribbon, category indicator, and progress bar as internal markup:

```
StoryCard (canonical, target)
  ├─ CategoryChip   (COMP0018) — story-category indicator (development | health | subsistence)
  ├─ ProgressBar    (COMP0016) — collection-progress bar (brand→accent gradient reveal)
  └─ TimeLeftPill   (COMP0017) — countdown/urgency pill (calm | urgent)
```

This composition **rewires** the current-state Composition diagram above: what this COMP recorded
as an internal "deadline countdown ribbon" and an internal "progress block" are, in the canonical
model, the composed sub-components `TimeLeftPill` (`COMP0017`) and `ProgressBar` (`COMP0016`)
respectively — resolving this doc's own Open Question ("whether the detail progress block shares a
component with the card's" → in the target system, yes: both consume the same `ProgressBar` atom).
The category-color mechanism (`CategoryChip`, `COMP0018`) has **no current-state analogue** in this
COMP at all — it is a target-only addition, not observed in any current-state screenshot.

### Props / Inputs (canonical)

All props are **display-ready** (pre-formatted/pre-translated strings and numbers; no
in-component formatting or i18n):

| Name | Type | Notes |
|---|---|---|
| `title` | `string` | Story title. |
| `photoUrl` | `string` (optional) | Child/story photo URL. |
| `initial` | `string` | Monogram-fallback initial, used when `photoUrl` is absent. |
| `category` | `StoryCategory` (`development \| health \| subsistence`) | Drives `CategoryChip` color + card wash via `color.category.*`. |
| `categoryLabel` | `string` | Display label for the category chip. |
| `progressPct` | `number` | Feeds the composed `ProgressBar`. |
| `missingLabel` | `string` | Display-ready "missing amount" text. |
| `goalLabel` | `string` | Display-ready goal/target text. |

### Variants / states (canonical)

- **Variants:** by `category` only (chip/wash/monogram share `color.category.*`). There is
  **no canonical lifecycle axis** — the current-state active/completed split recorded above in
  Variants is a current-state-only observation with no target-system equivalent (see Divergence
  below). No size axis is itemized (fixed card size per `components.md`).
- **States:** `default` (first-cut, shipped); `hover`/`focus` on the owning link (explicitly **out
  of first cut**, deferred); `loading`/`empty`/`error` (explicitly **out of first-cut scope**).

### Token slots (canonical)

`var(--color-surface)`, `var(--color-border)`, `var(--radius-card)`, `var(--shadow-card)`,
`var(--font-body)`, `var(--color-category-development)`, `var(--color-category-health)`,
`var(--color-category-subsistence)`, `var(--color-surface-tint)`, `var(--font-display)` (+
`var(--font-display-weight)`, `var(--font-display-tracking)`), `var(--color-text)`,
`var(--color-muted)`, `var(--space-md)`, `var(--space-sm)`. Per `DESIGN-tokens.md` §10, all are
consumed via `var(--…)` in the component's colocated CSS module — no hex/px literals. Composed
sub-components carry their own additional slots (`ProgressBar`: `--radius-pill`, `--color-track`,
`--color-brand`, `--color-accent`; `TimeLeftPill`: `--color-urgent`, `--color-on-urgent`;
`CategoryChip`: `--radius-pill`).

### Accessibility (canonical)

- The whole card is a **clickable donor-acquisition unit** routing to the story detail page — an
  owning-link pattern, not a button-triggered pattern (contrast with this COMP's current-state
  `onCtaClick`/`onCardClick` Uncertain split above).
- Hover/focus states on the owning link are explicitly deferred (not first-cut) — no focus-ring
  contract is defined yet for the card itself.
- Composed `ProgressBar` carries its own `role="progressbar"` + `aria-valuemin/max/now`, explicitly
  **not focusable** (status role, not control) — inherited, not restated, by `StoryCard`.
- Composed `TimeLeftPill`'s `urgent` pulse animation is disabled under `prefers-reduced-motion` —
  inherited by any `StoryCard` rendering an urgent pill.
- No ARIA role is defined for the card container itself beyond native semantics; not itemized
  separately in `components.md`.

### Tenant (CZ/RO) behaviour

- `StoryCard` itself takes **no tenant-specific props** — content (title, labels) is passed in
  already localized by the consumer, matching this COMP's current-state observation that
  title/CTA text is COPY-owned per instance.
- Re-skinning across `data-theme="cz"|"ro"` is entirely token-driven (colors, radius, shadow,
  fonts remap under `[data-theme]`) — no component code forks.
- The composed `CategoryChip`'s icon glyph style (line vs filled) follows the tenant's `Icon`
  atom convention (CZ = line, RO = filled) via `data-theme`, not a `StoryCard`-level prop.
- The composed `TimeLeftPill` urgency coloring uses tenant-neutral `color.urgent`/`color.onUrgent`
  status tokens (same value on both tenants), distinct from the brand palette.

### Divergence from observed current-state (record, do not "correct")

- **No lifecycle/"completed" variant.** This COMP's current-state Variants section records a
  distinct `completed` lifecycle (`WIRE0019`: "SPLNĚNO" ribbon, "ZPĚTNÁ VAZBA" pill, checkmark,
  "Detail příběhu" CTA instead of a donate CTA). The canonical `StoryCard` contract has **no**
  lifecycle axis — per `components.md` §2 mapping note, "COMP0008's active/completed split is a
  current-state observation, not a canonical axis." This divergence is recorded, not silently
  closed; whether/how the rebuild will represent the completed-story catalogue view is an open
  rebuild-scope question, not decided by this reconciliation.
- **No `isCollectionAccount` / group-Campaign prop.** The current-state `isCollectionAccount`
  prop (`EN0004` group/parent mechanism, Partial evidence) has no counterpart in the canonical
  prop list above — not evidenced as carried into the target contract by `components.md`.
- **No `ctaLabel`/explicit CTA button.** Current-state records a card-scoped CTA button
  (`ctaLabel`, `onCtaClick`) not confirmed identical to `COMP0001`/canonical `Button`. The
  canonical contract instead models the whole card as a link (see Accessibility above) with no
  separate CTA-label prop — the current-state per-card CTA text ("Podpořím Miriam", "Nechám to na
  vás") has no direct canonical prop mapping.
- **`completedBadges`, `deadlineBadge` as free text.** Current-state records these as ad hoc
  string props; canonical replaces the deadline concept with the structured `TimeLeftPill`
  (`label` + `urgent` boolean) rather than a free-text badge.

### Source references

`DESIGN-component-index.md` row 8 (Index table) and §2 (doc_id assignment); full catalogue entry
`_ar/evidence/design-system/components.md` §1 "StoryCard" and mapping row §2 "StoryCard"; composed
atoms per `_ar/evidence/design-system/components.md` §1 "ProgressBar", "TimeLeftPill",
"CategoryChip" and `DESIGN-tokens.md` §3, §6, §10 for token values/naming.
