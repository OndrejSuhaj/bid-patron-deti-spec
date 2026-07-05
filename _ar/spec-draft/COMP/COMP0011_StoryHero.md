---
doc_id: COMP0011
title: StoryHero
canonical_layer: COMP
spec_type: component
modules: []
status: draft
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/StoryHero/
references:
  - WIRE0002
  - EN0004
  - COMP0018
---

# COMP0011 – StoryHero

## Purpose

This document promotes **StoryHero**, a canonical `@patron/ui` **Block**, per the task instruction
("this component was left inline in the reconstruction; promote it now"). It holds **two clearly
separated bodies of fact** per the project's current-vs-target discipline:

- **Design-system alignment (target)** — the authoritative canonical contract for StoryHero as
  built in the `bid-patron-deti` rebuild library (`packages/ui/src/components/StoryHero/`): the
  story visual on the detail page — a large photo with a category chip in the corner, falling back
  to a deliberate monogram-on-wash treatment (not a generic placeholder) when no photo is available.
- **Current-state (observed)** — what the reconstructed Patronus current-state UX
  (`_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md`) actually shows in the equivalent
  screen zone ("Media zone"), which was left `inline` (no promoted COMP) because current-state
  evidence did not support a reusable-component claim.

These two parts describe **different systems** (rebuild target vs. reconstructed current Patronus)
and must not be merged into one fact. Per `DESIGN-component-index.md` §2, this component's target
contract reconciles current-state Open Questions recorded on `WIRE0002` (see Current-state part
below), but reconciliation is a *note*, not a rewrite of what was observed.

Cross-reference: this doc reconciles against `DESIGN-component-index.md` row 9 and
`_ar/evidence/design-system/components.md` §1 "StoryHero" / §2 mapping row ("GAP→recon").

---

## Design-system alignment (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Everything in this part describes the rebuild's canonical component
> (`packages/ui/src/components/StoryHero/`), not Patronus's current behavior. Authoritative source:
> `_ar/evidence/design-system/components.md` §1 "StoryHero" and `DESIGN-component-index.md` row 9.

### Purpose (target)

Story visual on the detail page: a large photo with a `CategoryChip` (`COMP0018`) in the corner.
When no photo is supplied, renders a deliberate monogram-on-wash fallback — a considered design
decision to preserve recognizability, not a generic gradient placeholder.

### Props / Inputs (target)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `photoUrl` | `string` (URL) | no | — | Story/child photo. When absent, the monogram-fallback variant renders instead. |
| `photoAlt` | `string` | no | `""` (empty string) | Alt text for the photo `<img>`. Default is deliberately empty — see Accessibility. |
| `initial` | `string` | yes | — | Monogram letter(s) shown in the fallback variant (and used as the visual anchor when `photoUrl` is absent). |
| `category` | `StoryCategory` (`"development" \| "health" \| "subsistence"`) | yes | — | Drives the composed `CategoryChip` (`COMP0018`) color/icon; binds `EN0004`'s category attribute. |
| `categoryLabel` | `string` | yes | — | Display-ready category label text passed through to the composed `CategoryChip`; not translated/formatted inside StoryHero. |

Exported type: `StoryHeroProps` (per `components.md` §1).

### Variants (target)

- **photo state:** with-photo | monogram-fallback — driven purely by presence/absence of `photoUrl`, not a separate prop.
- **category:** by-category — corner `CategoryChip` color/icon follows `category`; category taxonomy shared with `COMP0018`/`COMP0016`/`COMP0008` (canonical target versions).

### States (target)

#### idle
Default rendering: large photo (or monogram fallback) with the `CategoryChip` positioned in the corner.

#### hover
`Uncertain — not itemized as a distinct interactive state in the canonical catalogue; StoryHero is not documented as independently clickable (it is a visual block inside the StoryDetail page composition, not an owning link).`

#### focused
`Uncertain — not itemized; no focusable element is documented as native to StoryHero itself (the composed CategoryChip is presentational, per COMP0018).`

#### disabled
N/A — no disabled rendering is part of the canonical contract; StoryHero is a display block, not a control.

#### loading
`Uncertain — not itemized in the canonical catalogue (components.md / DESIGN-component-index.md do not document a loading/skeleton state for StoryHero).`

#### error
N/A — the canonical contract handles the "no photo" case via the monogram-fallback variant (a designed state, not an error state); no distinct image-load-error rendering is documented.

### Events (target)

No events emitted — StoryHero is a presentational Block with no documented callback props
(`StoryHeroProps` per `components.md` §1 lists only display props: `photoUrl`, `photoAlt`,
`initial`, `category`, `categoryLabel`).

### Accessibility (target)

- **ARIA role:** not separately documented for the container; the photo renders as a standard
  `<img>` when `photoUrl` is present.
- **`photoAlt` default is `""`:** per the canonical contract, `photoAlt` defaults to an empty
  string. This is a deliberate authored choice in the source catalogue (not a gap the reconstruction
  can silently "fix") — treat the empty default as intentional unless a future contract revision
  says otherwise; `Uncertain — the design rationale for defaulting to an empty alt (e.g. treating the
  hero photo as decorative when caption context already carries the meaning) is not itemized beyond
  the prop default itself.`
- **Keyboard navigation:** N/A — no focusable/interactive element is documented as native to
  StoryHero.
- **Focus management:** N/A for the same reason.
- **Screen reader:** the composed `CategoryChip` carries its own accessible-name behavior via its
  `label` prop (decorative icon + label text, per `COMP0018`/`DESIGN-component-index.md` row 5); no
  additional StoryHero-level screen-reader behavior is documented.

### Tenant behavior (target — CZ/RO via `data-theme`)

Theme-neutral component: no CZ/RO-specific props. Visual re-skinning happens entirely through
token remapping under `data-theme="cz"|"ro"` — the monogram fallback specifically is built to read
brand tokens so it re-skins automatically per tenant (per `DESIGN-component-index.md` row 9 "Tenant
notes"):

- `var(--radius-card)` — CZ `16px` / RO `26px` (sharper vs. squircle), per `DESIGN-tokens.md` §6.
- `var(--shadow-card)` — tenant-tinted elevation (CZ ink-red-tinted / RO ink-navy-tinted), per
  `DESIGN-tokens.md` §7.
- `var(--color-brand)` — CZ `#EC4B34` / RO `#0FB5AE`, used in the monogram-fallback wash, per
  `DESIGN-tokens.md` §3.1.
- `var(--color-surface)`, `var(--color-surface-tint)` — fallback wash surfaces, tenant-bound per
  `DESIGN-tokens.md` §3.1.
- `var(--font-display)` + `var(--font-display-weight)` + `var(--font-display-tracking)` — monogram
  glyph typography, tenant-bound per `DESIGN-tokens.md` §4.1 (CZ Bricolage Grotesque 800 / RO Baloo 2
  700).
- The composed `CategoryChip` additionally reads `var(--color-category-development|health|subsistence)`,
  which are tenant-remappable per `DESIGN-tokens.md` §3.3, and its `Icon` glyph set switches
  line (CZ) vs. filled (RO) via `data-theme`, per `DESIGN-component-index.md` row 3.

### Usage Constraints (target)

- Use when: rendering the primary story visual on the StoryDetail page composition, immediately
  under the H1/breadcrumb in the main column (per `DESIGN-component-index.md` row "StoryDetail
  (Page)" composition order: `SiteHeader → breadcrumb → H1 → StoryHero → lede → PatronCard → prose`).
- Do not use when: rendering a story summary inside a browsable list/grid — that is `StoryCard`
  (`COMP0008` target contract), a different Block.
- Cardinality: one per StoryDetail page.
- Placement: main column, top of the page body; not a standalone/overlay element.

### Dependencies (target)

- Other COMPs (composition): `COMP0018` CategoryChip (corner chip).
- Data entities: `EN0004` Campaign (category, category label, imagery — current-state attribute
  binding; see Current-state part for the reconstruction's own binding note).
- ACL: none documented.
- External libraries: none documented.

### Composition (target)

```
StoryHero
  └─ COMP0018 CategoryChip (corner; category + categoryLabel)
```

### Token slots (target — canonical CSS vars, see `DESIGN-tokens.md`)

| Token | Role here |
|---|---|
| `var(--radius-card)` | Hero container corner radius |
| `var(--shadow-card)` | Hero container elevation |
| `var(--color-brand)` | Monogram-fallback wash accent |
| `var(--color-surface)` | Fallback background surface |
| `var(--color-surface-tint)` | Fallback tinted wash |
| `var(--font-display)`, `var(--font-display-weight)`, `var(--font-display-tracking)` | Monogram glyph typography |
| *(via composed CategoryChip)* `var(--color-category-development\|health\|subsistence)` | Corner chip category tint |

### Examples (target)

```
<StoryHero photoUrl="/img/sofinka.jpg" photoAlt="" initial="S" category="development" categoryLabel="Rozvoj a vzdělání" />
<StoryHero initial="M" category="health" categoryLabel="Zdraví" />  {/* no photoUrl → monogram fallback */}
```

---

## Current-state (observed — reconstructed Patronus current-state UX)

> **STATE: CURRENT.** Everything in this part describes what was actually observed on the live
> Patronus site, from static screenshot evidence of the Story detail screen
> (`WIRE0002_StoryDetailAndDonationModal.md`, screen `S002`). It does **not** describe the rebuild
> target above. Per `rules-COMP.md`, a COMP is only created "when reuse is observable across two or
> more WIRE screens/screenshots" — this condition is **not met** for the hero photo in current-state
> evidence (see Evidence table). This current-state part is therefore evidence-thin by design; it is
> being documented here **because the task instructs promoting the canonical component now**, but
> the underlying current-state reuse claim remains `Uncertain`, consistent with how `WIRE0002` itself
> left it `inline`.

### Where it appears on the live site today

- **`WIRE0002` — Story detail page (`S002`), zone "Media zone".** Layout Zones entry: *"Media
  zone — Story hero photo (child)."* (`WIRE0002` line 56). Positioned directly under the "Title
  band" (story name) and above the "Patron comment card", in the left/main column, beside the
  donation sidebar (`WIRE0002` ASCII layout, lines 85–106).
- **Components Used table** (`WIRE0002` line 133): `Media zone | inline | hero image | single
  photo, no gallery/carousel observed`. The current-state reconstruction recorded this explicitly as
  `inline` — i.e. it was **not** promoted to a reusable COMP during the original UX reconstruction
  pass, precisely the gap this document now closes on the *target* side (see
  `DESIGN-component-index.md` §2 mapping row: "StoryHero — GAP→recon — Canonical hero = photo +
  corner CategoryChip + monogram fallback. Reconstruction saw a bare 'hero image'.").
- **Screenshot evidence:** full-page capture of the Story detail screen,
  `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`
  (per `WIRE0002` Evidence table, line 292), showing the child photo in the media zone alongside
  title, Patron card, body, sidebar, and trust banner.

### Current-state props/behavior observed

- **Single static photo only.** `WIRE0002` explicitly notes "single photo, no gallery/carousel
  observed" — no evidence of a multi-image carousel, thumbnails, or lightbox on the live screen.
- **No corner category chip on the hero itself observed.** In the current-state capture, the
  category tag ("Rozvoj a vzdělání" + icon) is rendered **inside the donation sidebar**, not as an
  overlay on the hero photo (`WIRE0002` Layout Zones: "Donation sidebar... category tag ('Rozvoj a
  vzdělání') with icon", line 64) — a structural difference from the target StoryHero contract,
  where the `CategoryChip` is composed directly onto the hero corner. This is a genuine
  current-vs-target divergence in *where* the category indicator lives, not merely a naming
  difference — see Divergence note below.
- **No-photo / fallback rendering: `Uncertain`.** No screenshot evidence shows a Story detail page
  without a hero photo; whether current Patronus renders any fallback (monogram, placeholder image,
  or blank space) when a Campaign lacks imagery is **not evidenced** in current sources. Do not
  assume the monogram-fallback behavior documented on the target side exists in current-state
  Patronus.
- **Alt text: `Uncertain`.** No DOM/accessibility evidence is available for the current-state hero
  image; whether it carries meaningful `alt` text is unknown.

### Current-state Variants / States / Events / Accessibility

Per `rules-COMP.md` evidence discipline, unobserved axes are recorded as `Uncertain`, not
fabricated:

- **Variants:** `Uncertain — only one rendering (single static photo, category=development context)
  is evidenced; no second Story detail capture with a different category or a no-photo case exists
  to confirm a category-driven visual variant in current-state Patronus.`
- **States (hover/focused/disabled/loading):** `Uncertain — not observable from static evidence.`
- **Error (no-photo fallback):** `Uncertain — see above; no evidence of what current Patronus renders when Campaign imagery is absent.`
- **Events:** No events observed — the current-state "Media zone" is recorded as a static image, not an interactive element (`WIRE0002` line 133: "single photo, no gallery/carousel observed").
- **Accessibility:** `Uncertain — no DOM/recording evidence, consistent with WIRE0002`'s overall a11y posture.`

### Current-vs-target divergence (record, do not "correct")

Per `_ar/evidence/design-system/components.md` §4 and `DESIGN-component-index.md` §3, this is a
recorded reconciliation gap, not a defect:

1. **Category-indicator placement.** Current-state places the category tag in the donation
   sidebar (`WIRE0002` line 64); target StoryHero composes `CategoryChip` directly onto the hero's
   corner. Whether current-state Patronus *also* has a category indicator on the hero itself
   (undetected because it wasn't distinguished from the sidebar tag in the capture) is `Uncertain`
   — do not assume the sidebar tag is a StoryHero-corner chip observed in current state.
2. **Fallback behavior unconfirmed.** Target StoryHero's monogram-on-wash fallback is a target-only
   fact; current-state Patronus's no-photo behavior is unevidenced (see above).
3. **Reuse threshold not met in current-state evidence.** Only one Story detail screen capture
   exists (`S002`); `rules-COMP.md` requires reuse across ≥2 WIRE screens/screenshots before
   promoting a current-state COMP. The current-state "Media zone" therefore remains, on its own
   evidentiary merits, a single-instance inline element — this document's current-state part records
   that fact rather than overriding it with the target contract's richer shape.

### Dependencies (current-state)

- Other COMPs: none confirmed as composed — current-state "Media zone" was recorded as `inline`
  with no sub-component structure (`WIRE0002` Components Used, line 133).
- Data entities: `EN0004` Campaign — imagery attribute, per `WIRE0002` Data Bindings: `"Media zone |
  EN0004 | — | Campaign imagery (required-imagery attribute, per BR-CampaignStoryLifecycle)"`
  (`WIRE0002` line 237).
- ACL: none evidenced.
- External libraries: none evidenced.

### Composition (current-state)

```
Media zone (WIRE0002, S002) — current-state, inline
  └─ hero photo (single static image; no sub-components confirmed)
```

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Existence of a hero-photo zone on Story detail | Confirmed | `WIRE0002` Layout Zones "Media zone" (line 56); `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png` |
| Single static photo, no carousel | Confirmed | `WIRE0002` Components Used, "Media zone" row (line 133) |
| Reuse across ≥2 current-state screens (COMP-promotion threshold) | Uncertain / not met | only one Story detail screen (`S002`) captured; `rules-COMP.md` ≥2-screen rule |
| Category chip composed onto hero corner (current-state) | Uncertain | category tag observed only in the donation sidebar (`WIRE0002` line 64), not confirmed on the hero itself |
| No-photo / fallback rendering (current-state) | Uncertain | no capture of a Story detail page lacking a photo |
| Alt text / accessibility (current-state) | Uncertain | no DOM evidence, per `WIRE0002` overall a11y posture |
| Target canonical contract (props/variants/states/tokens/a11y) | Confirmed (as target fact) | `_ar/evidence/design-system/components.md` §1 "StoryHero"; `DESIGN-component-index.md` row 9; source `packages/ui/src/components/StoryHero/{StoryHero.tsx, StoryHero.contract.md, StoryHero.module.css}` |

---

## Open Questions

- Whether current-state Patronus renders any category indicator on the hero photo itself (as
  distinct from the sidebar category tag) — not resolvable from existing captures; would require a
  fresh current-state screenshot pass, not the target contract, to close.
- Whether current-state Patronus has any no-photo fallback for Campaigns lacking imagery, and if so
  what it looks like — `Uncertain`, no evidence either way.
- Whether the current-state "Media zone" ever supports multiple photos (gallery) on screens not yet
  captured — `WIRE0002` only confirms "no gallery/carousel observed" on the one captured instance,
  which is evidence of absence on *that* screen, not proof of absence across all current-state Story
  detail renderings.
