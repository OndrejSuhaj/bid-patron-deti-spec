---
doc_id: COMP0017
title: TimeLeftPill
canonical_layer: COMP
spec_type: component
modules: []
status: draft
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/TimeLeftPill/
references:
  - WIRE0001
  - WIRE0002
  - EN0004
  - COMP0008
  - COMP0010
  - COMP0020
---

# COMP0017 – TimeLeftPill

## Purpose

This document promotes **TimeLeftPill**, a canonical `@patron/ui` **Atom**, per the task
instruction ("this component was left inline in the reconstruction; promote it now"). It holds
**two clearly separated bodies of fact** per the project's current-vs-target discipline:

- **Design-system alignment (target)** — the authoritative canonical contract for TimeLeftPill as
  built in the `bid-patron-deti` rebuild library (`packages/ui/src/components/TimeLeftPill/`): a
  campaign time-remaining pill with two states — calm (neutral tint) and urgent (full alert badge
  with a gentle pulse).
- **Current-state (observed)** — what the reconstructed Patronus current-state UX
  (`WIRE0001_HomepageStoryCatalogue.md`, `WIRE0002_StoryDetailAndDonationModal.md`) actually shows
  as the equivalent free-text "countdown ribbon"/deadline badge, which was left `inline` inside the
  `StoryCard` composition (no dedicated promoted COMP existed in the original UX reconstruction
  pass) because current-state evidence supported it only as a prop of `COMP0008`, not as an
  independently reconstructed reusable atom.

These two parts describe **different systems** (rebuild target vs. reconstructed current Patronus)
and must not be merged into one fact. `COMP0008` (StoryCard) §"Composition (canonical)" already
anticipates this promotion, stating that the current-state "deadline countdown ribbon" corresponds,
in the target model, to the composed sub-component `TimeLeftPill` (`COMP0017`) — this document is
that promoted component.

Cross-reference: this doc reconciles against `DESIGN-component-index.md` row 6 and
`_ar/evidence/design-system/components.md` §1 "TimeLeftPill".

---

## Design-system alignment (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Everything in this part describes the rebuild's canonical component
> (`packages/ui/src/components/TimeLeftPill/`), not Patronus's current behavior. Authoritative
> source: `_ar/evidence/design-system/components.md` §1 "TimeLeftPill — `components/TimeLeftPill/`"
> and `DESIGN-component-index.md` row 6.

### Purpose (target)

Campaign time-remaining pill. Calm state renders as a neutral tint (informational, non-alarming);
urgent state renders as a full alert badge with a gentle pulse animation. The urgent state reads
dedicated state tokens (`color.urgent` / `color.onUrgent`), kept deliberately separate from the
brand palette so urgency reads consistently regardless of tenant brand color
(`_ar/evidence/design-system/components.md` §1, line 129-130).

### Props / Inputs (target)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `label` | `string` | yes | — | Display-ready countdown text (e.g. "Zbývá měsíc", "Zbývá 16 dní"). Not formatted/translated inside the component — the consumer supplies the final string. |
| `urgent` | `boolean` | no | `false` | Selects the urgent (alert-badge, pulsing) rendering instead of the calm (neutral-tint) rendering. |

Exported type: `TimeLeftPillProps` (per `components.md` §1).

### Variants (target)

- **urgency:** calm | urgent — driven solely by the `urgent` boolean prop, not a separate enum.
- **size:** fixed — no size axis is documented (`components.md` §1: "Variants: calm/urgent. Sizes: fixed.").

### States (target)

#### idle
Two idle renderings, selected by the `urgent` prop (this component has no interactive states of its
own — see hover/focused/disabled below):
- **calm:** a tint derived from `color.text` over `color.surface`; label text in `color.muted`.
- **urgent:** `color.urgent` background, `color.onUrgent` text; plays the `urgentpulse` animation.

#### hover
N/A — TimeLeftPill is a non-interactive presentational atom (a status badge, not a control); no
hover state is documented in the canonical catalogue.

#### focused
N/A — not focusable; no `tabindex`/interactive role is documented for TimeLeftPill.

#### disabled
N/A — no disabled rendering is part of the canonical contract; there is nothing to disable on a
non-interactive status pill.

#### loading
`Uncertain — not itemized in the canonical catalogue (components.md / DESIGN-component-index.md do
not document a loading/skeleton state for TimeLeftPill).`

#### error
N/A — no error rendering is documented; the component has exactly the two documented states (calm,
urgent), both of which are valid/normal, not error conditions.

### Events (target)

No events emitted — `TimeLeftPillProps` (per `components.md` §1) lists only `label` and `urgent`;
no callback props are documented.

### Accessibility (target)

- **ARIA role:** not separately documented; the composed `Icon` (name="clock") is decorative by
  default per `Icon`'s own contract (`DESIGN-component-index.md` row 3: "no intrinsic role/label —
  consuming component must supply `aria-label` where meaningful"). Whether TimeLeftPill supplies
  such an `aria-label` for its clock icon is `Uncertain — not itemized beyond the Icon atom's
  general default behavior.`
- **Keyboard navigation:** N/A — not a focusable/interactive element.
- **Focus management:** N/A for the same reason.
- **Motion / reduced-motion:** the `urgentpulse` animation is **explicitly disabled under
  `prefers-reduced-motion`** — a concrete, evidenced a11y decision
  (`_ar/evidence/design-system/components.md` §1, line 134-135: "urgent (`color-urgent` bg,
  `color-on-urgent` text, `urgentpulse` animation, disabled under `prefers-reduced-motion`)"; also
  recorded via `DESIGN-component-index.md` row 6 A11y notes: "`urgentpulse` animation explicitly
  disabled under `prefers-reduced-motion`").
- **Screen reader:** the visible `label` text carries the accessible content (it is plain text
  content, not an image); no additional screen-reader-specific behavior is documented beyond the
  `Icon` note above.

### Tenant behavior (target — CZ/RO via `data-theme`)

Theme-neutral component: no CZ/RO-specific props. Per `DESIGN-component-index.md` row 6 "Tenant
notes": *"Theme-neutral; urgent state uses dedicated `color.urgent`/`color.onUrgent` tokens, distinct
from brand palette per tenant."*

- `var(--color-urgent)` / `var(--color-on-urgent)` — **same value on both tenants**: CZ `#D92D20` /
  RO `#D92D20` (and `#FFFFFF` / `#FFFFFF` for on-urgent), per `DESIGN-tokens.md` §3.2 "Status family
  (4) — own tokens, NOT derived from brand." Urgency therefore reads visually identical across CZ
  and RO, unlike brand-bound slots.
- `var(--color-text)`, `var(--color-surface)`, `var(--color-muted)` — the calm-state tint and
  label color remap per tenant per `DESIGN-tokens.md` §3.1 (CZ `#2A1A15`/`#FFFFFF`/`#7C665E`; RO
  `#132247`/`#FFFFFF`/`#586A8C`).
- The composed `Icon` (name="clock") glyph set switches line (CZ) vs. filled (RO) via `data-theme`,
  per `DESIGN-component-index.md` row 3 — not a TimeLeftPill-level prop.

### Usage Constraints (target)

- Use when: signaling a Campaign's remaining time on a story-summary or story-detail surface (e.g.
  composed into `StoryCard` (`COMP0008`) and `DonationBox` (`COMP0010`)).
- Do not use when: displaying a fixed/absolute date — the contract is countdown-style display text
  (`label`), not a date-formatting component.
- Cardinality: typically one per Campaign-context card/panel (one time-remaining fact per story).
- Placement: inside a composing Block (`StoryCard`, `DonationBox`); not documented as a standalone
  page-level element in the canonical catalogue.

### Dependencies (target)

- Other COMPs (composition): `COMP0020` Icon (`name="clock"`, size 15).
- Data entities: `EN0004` Campaign — deadline/time-remaining attribute (current-state binding; see
  Current-state part below for the reconstruction's own binding note).
- ACL: none documented.
- External libraries: none documented.

### Composition (target)

```
TimeLeftPill
  └─ COMP0020 Icon (name="clock", size=15) — decorative countdown glyph
```

Consumed by (composition direction, per `DESIGN-component-index.md` rows 8 and 13):

```
StoryCard      (COMP0008)  ├─ TimeLeftPill (COMP0017)
DonationBox    (COMP0010)  ├─ TimeLeftPill (COMP0017)
```

### Token slots (target — canonical CSS vars, see `DESIGN-tokens.md`)

| Token | Role here |
|---|---|
| `var(--font-body)` | Label typography |
| `var(--radius-pill)` | Pill shape (fully rounded) |
| `var(--color-text)` | Calm-state base tint source |
| `var(--color-surface)` | Calm-state background base |
| `var(--color-muted)` | Calm-state label text color |
| `var(--color-urgent)` | Urgent-state background |
| `var(--color-on-urgent)` | Urgent-state text/icon color |

### Examples (target)

```
<TimeLeftPill label="Zbývá měsíc" />
<TimeLeftPill label="Zbývá 3 dny" urgent />
```

Storybook stories: `Klid` (calm), `Naléhavé` (urgent) — per
`_ar/evidence/design-system/components.md` §1 "TimeLeftPill" story list.

---

## Current-state (observed — reconstructed Patronus current-state UX)

> **STATE: CURRENT.** Everything in this part describes what was actually observed on the live
> Patronus site, from static screenshot evidence of the homepage catalogue (`WIRE0001`, screen
> `S001`) and the Story detail screen's related-stories rail (`WIRE0002`, screen `S002`). It does
> **not** describe the rebuild target above. Per `rules-COMP.md`, a COMP is only created "when reuse
> is observable across two or more WIRE screens/screenshots" — this condition **is met** here: the
> deadline-countdown pill/badge is observed repeatedly across both `WIRE0001` (catalogue grid, 6
> cards × 4 screenshots) and `WIRE0002` (related-stories rail, 3 cards). However, in the *original*
> current-state reconstruction pass it was recorded as a **prop of `COMP0008` StoryCard**
> (`deadlineBadge: string`), not itemized as its own independently reconstructed COMP — this
> document now promotes that free-text badge concept to sit alongside the target `TimeLeftPill`
> contract above, per the task instruction. The current-state part below is therefore a
> **reconciliation view onto existing `COMP0008`/`WIRE0001`/`WIRE0002` evidence**, not a fresh
> reconstruction pass.

### Where it appears on the live site today

- **`WIRE0001` — Homepage/Story Catalogue (`S001`), catalogue grid.** Layout description: *"category
  icon badge, photo, 'ZBÝVÁ \<n\> \<unit\>' countdown ribbon (or 'SBÍRKOVÝ ÚČET' \[...\])"*
  (`WIRE0001` line 90). Components Used table (`WIRE0001` line 135): `Story card | COMP0008 |
  lifecycle=active | repeated 6x per tab; countdown ribbon text varies ("ZBÝVÁ MĚSÍC" / "ZBÝVÁ DEN" /
  "ZBÝVÁ N DNÍ")`.
  - Observed concrete text values across captures: "ZBÝVÁ MĚSÍC", "ZBÝVÁ DEN", "ZBÝVÁ 3 DNY" (×3),
    "ZBÝVÁ 5 DNY", "ZBÝVÁ 4 DNY", "ZBÝVÁ 16 DNÍ", "ZBÝVÁ 24 DNÍ" (per `WIRE0001` line 165-166 and
    `COMP0008` `deadlineBadge` prop description).
  - `WIRE0001` line 165-166 notes the grid appears **sorted by ascending deadline** ("confirmed: all
    6 visible cards in `13_16_37` show short countdowns — 'ZBÝVÁ DEN', 'ZBÝVÁ 3 DNY' x3, 'ZBÝVÁ 5
    DNY' — consistent with an ascending-deadline sort"), which is a page/list-level behavior, not a
    property of the pill component itself.
- **`WIRE0002` — Story detail page (`S002`), "Related stories rail".** *"3 cards (photo, countdown
  badge 'ZBÝVÁ MĚSÍC'/'ZBÝVÁ 16 DNÍ', 'Chybí N Kč' ribbon, name+wish, 'Cílová částka N Kč',
  'Podpořím \<jméno\>' CTA)"* (`WIRE0002` line 78-79) — the same badge concept reused in a
  cross-sell rail context, confirming reuse across ≥2 distinct screens.
  - `WIRE0002`'s own primary donation-sidebar progress block additionally shows a **prose-style**
    time-remaining phrase, "Zbývá měsíc" (`WIRE0002` line 67), inline within the sidebar's progress
    block text — not rendered as a standalone pill/badge shape in that particular zone. Whether this
    prose instance and the catalogue-card badge instance are the *same* underlying data/text source
    rendered in two different visual treatments, or two independently-authored strings, is
    `Uncertain — not confirmed by any capture; WIRE0002 itself flags the progress block as
    Uncertain whether it shares a component with COMP0008's internal progress figures.`
- **Screenshot evidence:** `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
  `13_16_09.png`, `13_16_21.png`, `13_16_37.png` (catalogue grid, per `WIRE0001` Evidence table,
  line 296); Story detail full-page capture referenced by `WIRE0002` (per `WIRE0002` Evidence table)
  for the related-stories rail.

### Current-state props/behavior observed

- **Free-text badge, not a structured `{label, urgent}` contract.** Current-state records the
  countdown text as a single opaque string (`COMP0008`'s `deadlineBadge: string` prop) — there is no
  observed/confirmed boolean urgency flag distinct from the text content itself. Whether "ZBÝVÁ DEN"
  (1 day) renders with any *visually distinct* alert styling compared to "ZBÝVÁ MĚSÍC" (1 month) is
  `Uncertain — no side-by-side capture confirms a color/style change tied to urgency; the only
  observed variation is the text string itself.` This is the central current-vs-target divergence —
  see below.
- **"SBÍRKOVÝ ÚČET" alternate text.** `WIRE0001` line 90 notes the badge slot can alternatively show
  "SBÍRKOVÝ ÚČET" (collection-account) instead of a countdown, for the group/collection-account story
  type — i.e. in current-state this badge slot is overloaded to carry more than a pure
  time-remaining fact. This alternate value has **no counterpart** in the target `TimeLeftPill`
  contract (which only documents `label`/`urgent`, both time-oriented) — `Uncertain` whether the
  target model handles the collection-account case via a different `label` string passed into the
  same component, or via an entirely different mechanism; not evidenced either way.
- **No icon confirmed.** No screenshot detail confirms whether the current-state badge/ribbon
  includes a clock icon glyph (as the target `Icon`(name="clock") composition does) or is text-only.
  `Uncertain — not itemized in WIRE0001/WIRE0002/COMP0008 beyond the text content itself.`
- **Visual shape ("ribbon" vs "pill" vs "badge") is itself imprecise in the reconstruction.**
  `WIRE0001` and `WIRE0002` use the words "ribbon"/"badge"/"countdown badge" interchangeably for
  this element; none of the current-state docs commit to a specific pill/rounded shape. Whether the
  live rendering is visually a rounded pill (matching the target `radius.pill`) or a different shape
  (banner/ribbon corner treatment) is `Uncertain — not confirmed by the wording used in the
  reconstruction, which predates this component's promotion.`

### Current-state Variants / States / Events / Accessibility

Per `rules-COMP.md` evidence discipline, unobserved axes are recorded as `Uncertain`, not
fabricated:

- **Variants:** text-value variation only ("ZBÝVÁ MĚSÍC" / "ZBÝVÁ DEN" / "ZBÝVÁ N DNY" / "ZBÝVÁ N
  DNÍ" / "SBÍRKOVÝ ÚČET") — `Confirmed` as free-text variation; whether this maps to a discrete
  calm/urgent visual variant (as in the target) is `Uncertain` (see above).
- **States (hover/focused/disabled/loading):** `Uncertain — not observable from static evidence;`
  the element is not confirmed interactive in either WIRE doc.
- **Error:** N/A — no error rendering evidenced or plausible for a display-only badge.
- **Events:** No events observed — the badge is recorded as a passive display element within
  `StoryCard`'s current-state composition (`COMP0008` current-state Composition section), not as an
  independently interactive element.
- **Accessibility:** `Uncertain — no DOM/recording evidence, consistent with WIRE0001`'s and
  `WIRE0002`'s overall a11y posture (both docs record accessibility as unobserved throughout).

### Current-vs-target divergence (record, do not "correct")

Per `COMP0008`'s own "Divergence from observed current-state" section (line 296-298) and
`_ar/evidence/design-system/components.md` §1 "TimeLeftPill", this is a recorded reconciliation
gap, not a defect:

1. **Free text vs. structured contract.** Current-state carries the whole countdown fact as one
   opaque string (`deadlineBadge`); the target `TimeLeftPill` restructures this into two props
   (`label` display text + `urgent` boolean driving a distinct visual treatment). `COMP0008` line
   296-298 records this explicitly: *"`completedBadges`, `deadlineBadge` as free text. Current-state
   records these as ad hoc string props; canonical replaces the deadline concept with the structured
   `TimeLeftPill` (`label` + `urgent` boolean) rather than a free-text badge."*
2. **Urgency as a visual state is target-only, unconfirmed in current-state.** The target contract's
   defining feature — a distinct urgent alert-badge rendering with a pulse animation — has **no
   confirmed current-state visual counterpart**. Current-state evidence shows only that the *text*
   changes ("ZBÝVÁ DEN" vs "ZBÝVÁ MĚSÍC"); whether the live site also changes color/style/animation
   for short deadlines is `Uncertain`, not evidenced, and must not be assumed present just because
   the target system has it.
3. **"SBÍRKOVÝ ÚČET" alternate value has no target counterpart.** See above — an unresolved gap
   between current-state's overloaded badge slot and the target's time-only `TimeLeftPill` contract.
4. **Icon presence unconfirmed in current-state.** The target composes a `clock` icon
   (`COMP0020`); current-state evidence does not confirm or deny an icon glyph in the observed
   badge.
5. **Reuse threshold: met, but via a different current-state artifact.** Unlike `COMP0011`
   StoryHero (where current-state reuse was *not* met), this component's underlying free-text badge
   *is* observed across ≥2 WIRE screens (`WIRE0001` catalogue grid, `WIRE0002` related-stories
   rail) — satisfying `rules-COMP.md`'s reuse threshold. However, the *original* reconstruction
   pass folded this reuse into `COMP0008`'s `deadlineBadge` prop rather than spinning out a
   dedicated current-state COMP; this document does not retroactively rewrite that decision, it
   only adds the target-side promoted contract alongside it.

### Dependencies (current-state)

- Other COMPs: composed within `COMP0008` StoryCard's current-state composition (as the "deadline
  countdown ribbon" element); also appears within `WIRE0002`'s "Related stories rail" zone,
  recorded there as part of the repeated card pattern, not independently componentized.
- Data entities: `EN0004` Campaign — deadline/time-remaining derived value, per `WIRE0002` Data
  Bindings note: *"derived `campaign_raised` / `campaign_percentual_raised` vs. `gift_price`
  (target) and `campaign_deadline`, per `BR-CampaignStoryLifecycle`"* (`WIRE0002` line 241) — the
  countdown badge/ribbon text is a display rendering of the `campaign_deadline` fact, per the same
  business rule.
- ACL: none evidenced.
- External libraries: none evidenced.

### Composition (current-state)

```
Story card (WIRE0001, S001) — current-state, deadlineBadge prop of COMP0008
  └─ countdown ribbon (free text: "ZBÝVÁ MĚSÍC" | "ZBÝVÁ DEN" | "ZBÝVÁ N DNY/DNÍ" | "SBÍRKOVÝ ÚČET")

Related stories rail card (WIRE0002, S002) — current-state, same badge concept reused
  └─ countdown badge (free text: "ZBÝVÁ MĚSÍC" | "ZBÝVÁ 16 DNÍ")
```

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Existence of a deadline-countdown badge/ribbon on catalogue cards | Confirmed | `WIRE0001` line 90, line 135, line 165-166; `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` + 3 more captures |
| Reuse across ≥2 current-state screens (COMP-promotion threshold) | Confirmed | `WIRE0001` catalogue grid (S001) + `WIRE0002` related-stories rail (S002) both show the badge pattern |
| Free-text-only contract, no confirmed urgency-driven visual variant | Uncertain (absence of confirming evidence) | no capture shows a side-by-side style/color difference tied to deadline proximity; only text differs |
| "SBÍRKOVÝ ÚČET" alternate value with no target counterpart | Confirmed (current-state fact) / Uncertain (target mapping) | `WIRE0001` line 90 |
| Icon/glyph presence in current-state rendering | Uncertain | not itemized in `WIRE0001`/`WIRE0002`/`COMP0008` beyond text content |
| Accessibility (current-state) | Uncertain | no DOM evidence, per `WIRE0001`/`WIRE0002` overall a11y posture |
| Target canonical contract (props/variants/states/tokens/a11y) | Confirmed (as target fact) | `_ar/evidence/design-system/components.md` §1 "TimeLeftPill"; `DESIGN-component-index.md` row 6; source `packages/ui/src/components/TimeLeftPill/{TimeLeftPill.tsx, TimeLeftPill.contract.md, TimeLeftPill.module.css}` |
| `COMP0008`'s prior anticipation of this promotion | Confirmed | `COMP0008` §"Composition (canonical)" line 205: "TimeLeftPill (COMP0017) — countdown/urgency pill (calm \| urgent)"; §"Divergence" line 296-298 |

---

## Open Questions

- Whether the live Patronus site visually distinguishes near-deadline ("ZBÝVÁ DEN") badges from
  far-deadline ("ZBÝVÁ MĚSÍC") badges by anything other than text (color, icon, animation) —
  `Uncertain`, would require a fresh close-up/DOM inspection pass to resolve, not inferable from the
  existing full-page catalogue captures.
- Whether the "SBÍRKOVÝ ÚČET" (collection-account) badge value is rendered by the *same* underlying
  component/slot as the countdown text, or a structurally different element that happens to occupy
  the same visual position — `Uncertain`, not resolved by current sources.
- Whether the current-state badge includes a clock (or any) icon glyph — `Uncertain`, no capture
  detail confirms or denies this.
- Whether `WIRE0002`'s inline sidebar phrase "Zbývá měsíc" (prose, not badge-shaped) is generated
  from the same data/text source as the catalogue-card badge, or authored independently — flagged
  `Uncertain` both here and in `WIRE0002` itself.
- Whether the rebuild's `TimeLeftPill.urgent` boolean will, in practice, be driven by the same
  `campaign_deadline` proximity logic that (per current-state observation) appears to drive the
  catalogue's ascending-deadline sort — this is a target-implementation question outside this
  reconstruction's authority (current-state docs do not specify current sort/urgency-derivation
  logic beyond the "ascending-deadline" observation itself).
