---
doc_id: COMP0012
title: PatronCard
canonical_layer: COMP
spec_type: component
modules: []
status: draft
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/PatronCard/
references:
  - WIRE0002
  - EN0005
  - COMP0020
---

# COMP0012 – PatronCard

## Purpose

This document promotes **PatronCard**, a canonical `@patron/ui` **Block**, per the task instruction
("this component was left inline in the reconstruction; promote it now"). It holds **two clearly
separated bodies of fact** per the project's current-vs-target discipline:

- **Design-system alignment (target)** — the authoritative canonical contract for PatronCard as
  built in the `bid-patron-deti` rebuild library (`packages/ui/src/components/PatronCard/`): a
  standalone testimonial block on the Story detail page that positions the Patron as a **trust
  pillar** — it encodes the invariant "the patron guarantees the story" via a verification seal, and
  keeps the patron's comment always fully visible (no "show more" toggle), as a deliberate
  transparency decision.
- **Current-state (observed)** — what the reconstructed Patronus current-state UX
  (`_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md`) actually shows in the equivalent
  screen zone ("Patron comment card"), which was left `inline` (no promoted COMP) because
  current-state evidence did not support a reusable-component claim on its own.

These two parts describe **different systems** (rebuild target vs. reconstructed current Patronus)
and must not be merged into one fact. Per `DESIGN-component-index.md` row 10, this component's
target contract reconciles a **named current-vs-target behavior divergence** recorded on `WIRE0002`
(the comment-visibility toggle vs. the target's always-visible comment — see Current-vs-target
divergence below); reconciliation is a *note*, not a rewrite of what was observed.

Cross-reference: this doc reconciles against `DESIGN-component-index.md` row 10 and
`_ar/evidence/design-system/components.md` §1 "PatronCard" / §2 mapping row ("GAP→recon") / §4
"Behavioral divergences worth flagging".

---

## Design-system alignment (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Everything in this part describes the rebuild's canonical component
> (`packages/ui/src/components/PatronCard/`), not Patronus's current behavior. Authoritative source:
> `_ar/evidence/design-system/components.md` §1 "PatronCard — `components/PatronCard/`" and
> `DESIGN-component-index.md` row 10.

### Purpose (target)

Patron as trust pillar — a standalone testimonial block on the Story detail page. Encodes the
invariant *"the patron guarantees the story"* via a verification seal (reads `color.success`
semantically); the patron's comment is **always fully visible** — there is no "show more"/collapse
toggle, a deliberate transparency decision documented in the canonical catalogue.

### Props / Inputs (target)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `initial` | `string` | yes (used when no `avatarUrl`) | — | Monogram letter(s) shown in the initial-avatar fallback variant. |
| `avatarUrl` | `string` (URL) | no | — | Patron photo. When absent, the initial-avatar fallback variant renders instead. |
| `name` | `string` | yes | — | Patron display name; binds `EN0005` (current-state Patron entity) attribute-level content. |
| `role` | `string` | yes | — | Patron role/label text (e.g. "Patron příběhu"). |
| `sealLabel` | `string` | yes | — | Text accompanying the verification-seal icon (e.g. a "verified"/"guaranteed" label). |
| `commentHtml` | `string` (sanitized HTML) | yes | — | Patron's comment body, sourced from a restricted WYSIWYG editor and sanitized on the backend before render. Always rendered in full — no truncation/toggle logic in the component. |

Exported type: `PatronCardProps` (per `components.md` §1).

### Variants (target)

- **avatar:** photo avatar | initial avatar — driven purely by presence/absence of `avatarUrl`, not a separate prop (same pattern as `COMP0011` StoryHero's photo/monogram-fallback axis).

### States (target)

#### idle
Default rendering: avatar (photo or initial fallback) + name + role + verification seal (icon +
`sealLabel`) + fully visible `commentHtml` body.

#### hover
`Uncertain — not itemized as a distinct interactive state in the canonical catalogue; PatronCard is not documented as independently clickable (it is a static testimonial block inside the StoryDetail page composition, not an owning link).`

#### focused
`Uncertain — not itemized; no focusable element is documented as native to PatronCard itself (the composed Icon seal is presentational).`

#### disabled
N/A — no disabled rendering is part of the canonical contract; PatronCard is a display block, not a control.

#### loading
`Uncertain — not itemized in the canonical catalogue (components.md / DESIGN-component-index.md do not document a loading/skeleton state for PatronCard).`

#### error
N/A — the canonical contract handles the "no photo" case via the initial-avatar fallback variant (a designed state, not an error state); no distinct image-load-error rendering is documented.

### Events (target)

No events emitted — PatronCard is a presentational Block with no documented callback props
(`PatronCardProps` per `components.md` §1 lists only display props: `initial`, `avatarUrl`, `name`,
`role`, `sealLabel`, `commentHtml`).

### Accessibility (target)

- **ARIA role:** not separately documented for the container; the avatar photo renders as a standard
  `<img>` when `avatarUrl` is present.
- **Verification seal semantics:** the seal icon (`Icon` name="check") reads `color.success`
  semantically per `DESIGN-component-index.md` row 10 A11y notes — i.e. the visual/semantic channel
  for "verified/guaranteed" is the success token, not an ad hoc color. `Icon` itself is decorative by
  default (per `COMP0020` contract); `sealLabel` text is what carries the accessible name for the
  seal, consistent with how `CategoryChip` (`COMP0018`) pairs a decorative icon with label text.
- **Comment always fully visible — no toggle to manage focus/expand-collapse for:** per
  `DESIGN-component-index.md` row 10 A11y notes, "comment is **always fully visible** — no 'show
  more' toggle (transparency invariant)". This removes an entire class of expand/collapse
  keyboard-and-SR-state management that a toggle-based pattern would otherwise require.
- **Keyboard navigation:** N/A beyond native document flow — no focusable/interactive element is
  documented as native to PatronCard.
- **Focus management:** N/A for the same reason.
- **Screen reader:** `sealLabel` provides the seal's accessible name; `commentHtml` is rendered as
  ordinary sanitized markup (backend-sanitized WYSIWYG output) — no additional PatronCard-level
  screen-reader behavior beyond that is documented.

### Tenant behavior (target — CZ/RO via `data-theme`)

Theme-neutral composition: no CZ/RO-specific props (per `DESIGN-component-index.md` row 10 Tenant
notes: "Theme-neutral composition; content (name/role/comment) per-instance"). Visual re-skinning
happens entirely through token remapping under `data-theme="cz"|"ro"`:

- `var(--color-surface)`, `var(--color-border)` — card surface and outline, tenant-bound per
  `DESIGN-tokens.md` §3.1.
- `var(--radius-card)` — card corner radius (CZ `16px` / RO `26px`, sharper vs. squircle), per
  `DESIGN-tokens.md` §6.
- `var(--space-lg)`, `var(--space-md)` — internal spacing (shared, not tenant-bound).
- `var(--font-body)` — comment body typography (shared).
- `var(--color-brand)`, `var(--color-brand-strong)` — accents (e.g. name/role emphasis), tenant-bound
  per `DESIGN-tokens.md` §3.1 (CZ `#EC4B34`/`#B3311D`, RO `#0FB5AE`/`#0A7E79`).
- `var(--font-display)` (+weight) — name/role display typography, tenant-bound per `DESIGN-tokens.md`
  §4.1 (CZ Bricolage Grotesque 800 / RO Baloo 2 700).
- `var(--color-text)`, `var(--color-muted)` — body/secondary text, tenant-bound.
- `var(--color-success)` — verification-seal semantic color; per `DESIGN-tokens.md` line "`color.success`
  | success/trust ('Vybráno' chip, **patron seal**) | CZ `#149E6E` | RO `#0FB5AE`" — this is the
  *exact* documented use-case for this token, confirming the seal's tenant-bound color.
- `var(--radius-pill)` — likely shape token for the seal badge/pill treatment (consistent with other
  pill-shaped status indicators in the library, e.g. `TimeLeftPill`/`CategoryChip`); `Uncertain —
  components.md` lists `--radius-pill` among PatronCard's token slots but does not itemize which
  specific sub-element (seal badge vs. something else) consumes it.

### Usage Constraints (target)

- Use when: rendering the Patron testimonial on the StoryDetail page composition, in the main column
  immediately after the lede text (per `DESIGN-component-index.md` row "StoryDetail (Page)"
  composition order: `SiteHeader → breadcrumb → H1 → StoryHero → lede → PatronCard → prose`).
- Do not use when: rendering a generic user testimonial/review outside the Story-detail
  patron-guarantee context — PatronCard's contract is specifically the "patron guarantees the story"
  invariant, not a general testimonial component.
- Cardinality: one per StoryDetail page (each Campaign has at most one Patron, consistent with
  `EN0005`'s current-state invariant "A Campaign holds at most one Patron").
- Placement: main column, standalone block between the hero/lede and the long-form prose; not a
  sidebar or overlay element.

### Dependencies (target)

- Other COMPs (composition): `COMP0020` Icon (`name="check"`, the verification seal glyph).
- Data entities: `EN0005` Patron (current-state entity — name, role/label, avatar; see Current-state
  part for the reconstruction's own binding note; the canonical catalogue does not itemize a
  target-side entity binding beyond the props themselves).
- ACL: none documented.
- External libraries: none documented (comment HTML is backend-sanitized before reaching the
  component; the component itself does not sanitize).

### Composition (target)

```
PatronCard
  └─ COMP0020 Icon (name="check"; verification seal, paired with sealLabel text)
```

### Token slots (target — canonical CSS vars, see `DESIGN-tokens.md`)

| Token | Role here |
|---|---|
| `var(--color-surface)` | Card background surface |
| `var(--color-border)` | Card outline |
| `var(--radius-card)` | Card corner radius |
| `var(--space-lg)`, `var(--space-md)` | Internal spacing |
| `var(--font-body)` | Comment body typography |
| `var(--color-brand)`, `var(--color-brand-strong)` | Accent color(s) |
| `var(--font-display)` (+weight) | Name/role display typography |
| `var(--color-text)` | Primary text |
| `var(--color-muted)` | Secondary text |
| `var(--color-success)` | Verification-seal semantic color ("patron seal" is the documented use-case, per `DESIGN-tokens.md` §3.1) |
| `var(--radius-pill)` | Seal/pill shape treatment (`Uncertain` — exact sub-element not itemized) |

### Examples (target)

```
<PatronCard initial="J" name="Jana Nováková" role="Patron příběhu"
  sealLabel="Ověřeno patronem" commentHtml="<p>...</p>" />
<PatronCard avatarUrl="/img/patron-organizace.jpg" name="Nadace XY" role="Organizace"
  sealLabel="Ověřeno" commentHtml="<p>...</p>" />  {/* "OrganizaceBezFotky" story variant per components.md */}
```

---

## Current-state (observed — reconstructed Patronus current-state UX)

> **STATE: CURRENT.** Everything in this part describes what was actually observed on the live
> Patronus site, from static screenshot evidence of the Story detail screen
> (`WIRE0002_StoryDetailAndDonationModal.md`, screen `S002`). It does **not** describe the rebuild
> target above. Per `rules-COMP.md`, a COMP is only created "when reuse is observable across two or
> more WIRE screens/screenshots" — this condition is **not met** for the Patron comment card in
> current-state evidence (only one Story detail screen was captured; see Evidence table). This
> current-state part is therefore evidence-thin by design; it is being documented here **because the
> task instructs promoting the canonical component now**, but the underlying current-state reuse
> claim remains `Uncertain`, consistent with how `WIRE0002` itself left it `inline`.

### Where it appears on the live site today

- **`WIRE0002` — Story detail page (`S002`), zone "Patron comment card".** Layout Zones entry:
  *"Patron comment card — 'PATRON PŘÍBĚHU' label, Patron name/role (`EN0005`), avatar, 'Zobrafit
  komentář Patrona' toggle/link, comment body text."* (`WIRE0002` lines 57–58). Positioned directly
  under the "Media zone" (hero photo), above the "Story body" long-form text, in the left/main
  column, beside the donation sidebar (`WIRE0002` ASCII layout, lines 85–106).
- **Components Used table** (`WIRE0002` line 134): `Patron comment card | inline | avatar + name +
  role + toggle + body | binds EN0005`. The current-state reconstruction recorded this explicitly as
  `inline` — i.e. it was **not** promoted to a reusable COMP during the original UX reconstruction
  pass, precisely the gap this document now closes on the *target* side (see
  `_ar/evidence/design-system/components.md` §2 mapping row: "PatronCard — GAP→recon — Canonical
  PatronCard (avatar + verification seal + always-visible comment). Reconstruction had it inline
  (binds EN0005).").
- **Screenshot evidence:** full-page capture of the Story detail screen,
  `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`
  (per `WIRE0002` Evidence table, line 292), showing the Patron comment card alongside title, media
  zone, body, sidebar, and trust banner.

### Current-state props/behavior observed

- **Label, name/role, avatar, comment body all observed.** `WIRE0002` records: "'PATRON PŘÍBĚHU'
  label, Patron name/role (`EN0005`), avatar, ... comment body text" (line 57–58). No verification
  seal / "guaranteed"-style badge is recorded in the current-state capture — `Uncertain` whether one
  exists but was not distinguished from the label text, versus genuinely absent; not assumed present.
- **"Zobrazit komentář Patrona" toggle/link is observed** (`WIRE0002` line 58, and Interactions #6,
  line 172: *"Secondary action — read Patron comment — click 'Zobrazit komentář Patrona' → Assumed
  expand/scroll-to behavior (toggle label observed; expanded/collapsed states not both captured) —
  Uncertain."*). This is the current-state analogue of the target's comment-visibility behavior, and
  it is **structurally different** — see Current-vs-target divergence below.
- **Toggle expand/collapse mechanics: `Uncertain`.** `WIRE0002` explicitly could not confirm whether
  the toggle expands inline, scrolls to content, or links elsewhere — recorded as Open Question
  `WIRE0002-Q6` (line 284): *"Does 'Zobrazit komentář Patrona' toggle/expand content, or link
  elsewhere?"*
- **Avatar fallback (no-photo) rendering: `Uncertain`.** No screenshot evidence shows a Patron
  comment card without an avatar photo; whether current Patronus renders an initial/monogram fallback
  (as the target does) is **not evidenced** in current sources.

### Current-state Variants / States / Events / Accessibility

Per `rules-COMP.md` evidence discipline, unobserved axes are recorded as `Uncertain`, not
fabricated:

- **Variants:** `Uncertain — only one rendering (single capture, one Patron instance with an avatar
  photo) is evidenced; no second Story detail capture with a different Patron or a no-avatar case
  exists to confirm an avatar-driven visual variant in current-state Patronus.`
- **States (hover/focused/disabled/loading):** `Uncertain — not observable from static evidence`,
  except for the toggle's expand/collapse behavior, which is itself `Uncertain` per `WIRE0002-Q6`
  above (interaction is inferred, not both states captured).
- **Error:** N/A / `Uncertain` — no error-state rendering documented for this zone.
- **Events:** `Assumed` — the "Zobrazit komentář Patrona" toggle/link implies at least one
  user-triggered interaction (click → expand or navigate), per `WIRE0002` Interactions #6; the exact
  event/payload shape is not evidenced (no DOM/JS inspection performed).
- **Accessibility:** `Uncertain — no DOM/recording evidence, consistent with WIRE0002`'s overall
  a11y posture (Accessibility Notes, lines 261–271: tab order, focus-on-entry, and landmarks are all
  marked Assumed/Uncertain for this screen as a whole).`

### Current-vs-target divergence (record, do not "correct")

Per `_ar/evidence/design-system/components.md` §4 "Behavioral divergences worth flagging" and
`DESIGN-component-index.md` row 10, this is a recorded reconciliation gap, not a defect:

1. **Comment visibility — toggle vs. always-visible (the headline divergence).** Current-state
   `WIRE0002` shows a **"Zobrazit komentář Patrona" toggle/link** gating the comment body (line 58;
   Interactions #6, line 172; Open Question `WIRE0002-Q6`, line 284). The target `PatronCard`
   contract mandates the comment is **always fully visible** — no "show more" toggle at all — as an
   explicit transparency invariant (`components.md` §1 "PatronCard" Purpose: "comment always fully
   visible (no 'show more' toggle)"; §4: *"Patron comment visibility: reconstruction (WIRE0002) shows
   a 'Zobrazit komentář Patrona' toggle; canonical PatronCard mandates the comment is always fully
   visible (no toggle) as a transparency invariant. Genuine current→target behavior change."*). This
   is recorded as a **genuine current→target behavior change**, not an error in either source — the
   current toggle behavior is not "wrong," and the target's always-visible rule does not retroactively
   describe what Patronus does today.
2. **Verification seal — target-only, unconfirmed in current-state.** No verification-seal /
   "guaranteed" badge is recorded in the current-state capture's Layout Zones or Components Used
   entries (`WIRE0002` lines 57–58, 134) — only label, name/role, avatar, toggle, and comment body.
   Whether current Patronus has any visual equivalent of the target's trust seal is `Uncertain`, not
   confirmed absent (it may exist but not have been distinguished in the reconstruction pass), and
   must not be assumed present just because the target contract has one.
3. **Comment body content ownership is unresolved in current-state.** `WIRE0002` Data Bindings
   (line 240) flags: *"Patron comment card | EN0005 | — | Patron name/photo (EN0005 attributes);
   comment body text ownership (Patron vs. Application narrative) not confirmed — Uncertain."* The
   target contract's `commentHtml` prop (sanitized backend WYSIWYG) does not resolve this
   current-state open question about which entity actually owns the comment text in Patronus today.
4. **Reuse threshold not met in current-state evidence.** Only one Story detail screen capture
   exists (`S002`); `rules-COMP.md` requires reuse across ≥2 WIRE screens/screenshots before
   promoting a current-state COMP. The current-state "Patron comment card" therefore remains, on its
   own evidentiary merits, a single-instance inline element — this document's current-state part
   records that fact rather than overriding it with the target contract's richer shape.

### Dependencies (current-state)

- Other COMPs: none confirmed as composed — current-state "Patron comment card" was recorded as
  `inline` with no sub-component structure (`WIRE0002` Components Used, line 134).
- Data entities: `EN0005` Patron — name/photo attributes, per `WIRE0002` Data Bindings: `"Patron
  comment card | EN0005 | — | Patron name/photo (EN0005 attributes); comment body text ownership
  (Patron vs. Application narrative) not confirmed — Uncertain"` (`WIRE0002` line 240). See also
  `EN0005` itself: the Patron entity is "a display record only, distinct from the patron *role* held
  by a User (`EN0008`) and from the patron's *contact* details held by a Contact (`EN0006`)" and
  carries only `surname`, `first name`, `second surname` (duplicate — open question in `EN0005`), and
  an optional `photo`; `EN0005` does **not** itemize a comment-body attribute of its own, consistent
  with `WIRE0002`'s unresolved comment-ownership question above.
- ACL: none evidenced.
- External libraries: none evidenced.

### Composition (current-state)

```
Patron comment card (WIRE0002, S002) — current-state, inline
  ├─ "PATRON PŘÍBĚHU" label (static text)
  ├─ Patron avatar (photo; no-avatar fallback Uncertain)
  ├─ Patron name/role (binds EN0005)
  ├─ "Zobrazit komentář Patrona" toggle/link (expand/collapse mechanics Uncertain — WIRE0002-Q6)
  └─ comment body text (ownership vs. EN0005 vs. Application narrative Uncertain)
```

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Existence of a Patron comment card zone on Story detail | Confirmed | `WIRE0002` Layout Zones "Patron comment card" (lines 57–58); `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png` |
| Label + name/role + avatar + toggle + body composition | Confirmed | `WIRE0002` Components Used, "Patron comment card" row (line 134) |
| Toggle exists ("Zobrazit komentář Patrona") | Confirmed (label observed) | `WIRE0002` line 58, Interactions #6 (line 172) |
| Toggle expand/collapse mechanics | Uncertain | `WIRE0002-Q6` Open Question (line 284): "toggle label observed; expanded/collapsed states not both captured" |
| Comment body content ownership (Patron vs. Application) | Uncertain | `WIRE0002` Data Bindings, line 240 |
| Reuse across ≥2 current-state screens (COMP-promotion threshold) | Uncertain / not met | only one Story detail screen (`S002`) captured; `rules-COMP.md` ≥2-screen rule |
| Verification seal / trust badge (current-state) | Uncertain | not itemized in Layout Zones or Components Used; may exist but undistinguished, or genuinely absent |
| No-avatar fallback rendering (current-state) | Uncertain | no capture of a Patron comment card lacking an avatar photo |
| Accessibility (current-state) | Uncertain | no DOM evidence, per `WIRE0002` overall a11y posture (lines 261–271) |
| Target canonical contract (props/variants/states/tokens/a11y) | Confirmed (as target fact) | `_ar/evidence/design-system/components.md` §1 "PatronCard"; `DESIGN-component-index.md` row 10; source `packages/ui/src/components/PatronCard/{PatronCard.tsx, PatronCard.contract.md, PatronCard.module.css}` |
| `color.success` token's documented use-case explicitly names "patron seal" | Confirmed (as target fact) | `_ar/spec-draft/DESIGN-tokens.md` §3.1: "`color.success` \| success/trust ('Vybráno' chip, patron seal) \| CZ `#149E6E` \| RO `#0FB5AE`" |

---

## Open Questions

- Whether current-state Patronus has any visual equivalent of the target PatronCard's verification
  seal — not resolvable from existing captures; would require a fresh current-state screenshot pass
  (ideally of the toggle's expanded state) to close.
- What "Zobrazit komentář Patrona" actually does (inline expand, scroll-to, or navigation) —
  unresolved current-state Open Question `WIRE0002-Q6`; the target contract's "always visible" rule
  does not answer this for current-state Patronus.
- Who owns the comment body text in current Patronus — the Patron entity (`EN0005`) itself, or the
  Application/Campaign narrative — flagged Uncertain in `WIRE0002` Data Bindings (line 240) and not
  resolved by this promotion.
- Whether current-state Patronus renders any initial/monogram fallback when a Patron has no photo —
  `Uncertain`, no evidence either way (mirrors the equivalent open question recorded for `COMP0011`
  StoryHero's photo/fallback axis).
