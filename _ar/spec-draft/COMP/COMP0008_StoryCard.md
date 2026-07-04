---
doc_id: COMP0008
title: Story Card
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
---

# COMP0008 – Story Card

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
