---
doc_id: WIRE0016
title: Blog Article Listing
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S013
realizes_uc: [UC0026]
status: draft
references:
  - UC0026
  - EN0024
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0018
  - COMP0019
  - COMP0020
---

# WIRE0016 – Blog Article Listing

## Purpose

A public, anonymous-visitor editorial/content page at `/blog` ("Blog" in the global nav), listing
Patronus's marketing/editorial Blog posts (`EN0024`) grouped under a featured/hero article followed
by several thematically-tagged sections. It is a pure browse/read screen: the visitor scans a hero
story, then scrolls through topic-grouped article teasers, following "Číst více →" or an article
title to reach an article-detail screen (S014, currently unreconstructed — see Open Questions).

Per `_ar/spec-draft/WIRE-synthesis-report.md` §2/§4, this screen was previously **skipped as
blocked-no-uc** in the prior WIRESynthesizer pass ("Pure editorial/content aggregator; no user goal
beyond browsing tagged articles"), pending exactly the "lightweight browse/read content" UC the
report recommended. This document assumes that gap has since been closed by `UC0026` per this job's
task directive; at the time of writing, no `UC0026` file exists under `_ar/spec-draft/UC/` (the UC
layer directory is currently empty) — the realizing-UC link is carried here as directed, not
independently verified against a UC document. See Open Questions.

Actor: anonymous visitor (no authentication observed or implied; no distinct logged-in variant
observed).

**Current-vs-target note:** this document reconstructs **current-state** Patronus (`/blog` as it
exists on the live site today). Blog/O nás are **not** part of the `bid-patron-deti` rebuild canon
yet — the rebuild treats them under a separate, unbuilt epic (E0004). Nothing here should be read as
target-design intent; it is a faithful current-state account only.

---

## Layout Zones

```
+--------------------------------------------------------------+
| Global nav — logo | Jak to funguje | Blog (current) | O nás | |
|                    Požádat o pomoc (CTA) | Můj účet           |
+--------------------------------------------------------------+
| Hero article band                                             |
|   [large photo]  DATE | #TAG-CHIP                              |
|                  Headline                                     |
|                  Excerpt paragraph                             |
|                  "Číst více →"                                 |
+--------------------------------------------------------------+
| Section — "#O čem se mluví"                                   |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Section — "#Pomohli jsme"                                     |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Section — "#Chcete vědět"                                     |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Section — "#Rozhovory"                                        |
|   [big card] [big card]                                       |
+--------------------------------------------------------------+
| Section — "#Pomoc pro děti s autismem"                        |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Section — "#Děti s Downovým syndromem"                        |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Footer — cookie notice, company info, nav link clusters,      |
|          payment-provider logos, collection account no.       |
+--------------------------------------------------------------+
```

- **Global nav** — logo (→ S001), "Jak to funguje" (→ S016), "Blog" (current page), "O nás" (→
  S015), "Požádat o pomoc" CTA (→ S006), "Můj účet" (→ auth zone). — Confirmed.
- **Hero article band** — one large featured post: photo, date, single tag chip ("#O čem se mluví"),
  headline ("Patron dětí, Nova pomáhá a Ondřej Sokol zvou do kampaně Darujme prázdniny"), excerpt
  paragraph, "Číst více →" link. — Confirmed. Binds `EN0024`'s `is_hero_post` flag.
- **Thematic sections** — six repeating sections, each headed by a colored tag-style heading
  ("#O čem se mluví", "#Pomohli jsme", "#Chcete vědět", "#Rozhovory", "#Pomoc pro děti s autismem",
  "#Děti s Downovým syndromem"). Each section is a mixed grid: two larger article cards (photo,
  date, tag chip, title, short excerpt) on the left, plus up to three smaller list-style rows
  (thumbnail + date + tag chip + title, no excerpt) stacked to the right. The "#Rozhovory" section
  is observed with only the two larger cards and no smaller list rows. — Confirmed layout pattern;
  **Uncertain** whether the two-large + N-small composition is a fixed template or varies by
  available article count per tag (only 6 section instances observed, one of which — #Rozhovory —
  already differs from the others).
- **Footer** — shared global footer (cookie consent bar, company block, nav link clusters, payment
  logos, collection account number). — Confirmed; see `COMP0003`.

---

## Components Used

Every visual element traces to a `COMPxxxx` doc_id or is flagged `inline`. No dedicated WIRE-layer
promotion pass for this screen's own repeating card has occurred yet — see notes below.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Global nav | `COMP0002` | context=public | Shared header chrome, identical pattern to S001/S016/etc. — see `COMP0002` SiteHeader. |
| Nav brand logo | `COMP0019` | — | Composed inside `COMP0002`; "patron dětí" wordmark + heart/ribbon mark. |
| "Požádat o pomoc" CTA (nav) | `COMP0001` | primary, small | Header-scoped CTA button; same label/target pattern as observed elsewhere (`COMP0001` Button). |
| Hero article card | inline | large/featured variant | Not confirmed as the same underlying component as the section article cards below — distinct visual proportions (full-width photo + larger type). Treated as `inline`, not promoted, pending ≥2-screen evidence (this is the only screen where a hero-article layout is observed). |
| Section heading (tag label, e.g. "#O čem se mluví") | inline | — | Colored heading text per section, doubles as the grouping tag; not confirmed identical to `COMP0018` CategoryChip (that COMP's current-state account is scoped to the Story/Campaign category indicator on `WIRE0001`/`WIRE0002`, not blog tags — see Divergence note below). |
| Article tag chip (on individual cards, e.g. "#O čem se mluví" pill on a card) | `COMP0018` | label=blog-tag text | **Probable** reuse of the pill-shaped tag-chip visual pattern documented as `COMP0018` CategoryChip's current-state observed shape (colored pill + text). `COMP0018`'s own current-state scope is Story/Campaign category tags (stat-strip pill, card badge, sidebar tag) — blog article tags are a **visually similar but not confirmed-identical** usage; flagged here as a probable/candidate reuse, not asserted as confirmed. See Open Questions. |
| Article card (large, 2-up per section) | inline | photo + date + tag chip + title + excerpt | Repeats across all 6 sections; visually similar to `COMP0008` StoryCard's photo-title-CTA anatomy but serves editorial content, not a Campaign/Story, and carries no funding/progress/CTA-button elements — **not** treated as a `COMP0008` reuse; kept `inline`. |
| Article list row (small, up to 3 per section) | inline | thumbnail + date + tag chip + title | Compact secondary card variant; not observed as an independently reusable component elsewhere in evidence — `inline`. |
| "Číst více →" link (hero only) | inline | text link with arrow glyph | Not confirmed as a `COMP0001` Button instance (no button chrome observed — plain text + arrow icon). |
| Arrow glyph on "Číst více →" | `COMP0020` | decorative | Consistent with `COMP0020` Icon's general inline-glyph usage elsewhere; specific icon identity not confirmed. |
| Footer | `COMP0003` | — | Shared global footer, identical pattern to other Public-site screens; see `COMP0003` SiteFooter. |

---

## Interactions

1. **Entry** — direct navigation to `/blog` via global nav "Blog" link → state: `default`. —
   Confirmed (route + nav entry point; `_ar/spec-draft/IA/IA-patronus.md` lines 84, 212).
2. **Primary action — "Číst více →"** — click on the hero article's read-more link → navigates to
   that article's detail screen (S014, `/blog/<slug>`). This screen does not itself realize a
   mutation-oriented UC step; it is a read/browse navigation only. — Confirmed target pattern
   (route shape observed on the S014 evidence capture), though S014 itself remains
   unreconstructed as its own WIRE doc (see Open Questions).
3. **Secondary action — article title / card click** — clicking any section article card's photo
   or title → presumed navigation to that article's own detail screen, analogous to the hero's
   "Číst více →". No distinct visual affordance (no separate "read more" link) is shown on the
   smaller cards/rows — the whole card is presumed clickable. — **Probable**, not independently
   confirmed by a captured click-through.
4. **Secondary action — section tag heading / article tag chip** — whether clicking a section
   heading (e.g. "#O čem se mluví") or an individual article's tag chip filters the listing to
   that tag, or is purely a static label, is **not observed** (no active/hover state, no
   filtered-view screenshot captured). — Uncertain, consistent with the general "controls:
   category tag chips per article (grouping; interactivity not confirmed)" note in
   `ui-observed-areas.md` §14.
5. **Exit** — via global nav (to S001/S015/S016/S006) or footer links; no explicit "cancel"/"submit"
   exit exists since this is a read-only content screen. — Confirmed.

---

## States

### default
The fully rendered page as captured: hero article band followed by six thematic sections, each
populated with article cards, ending in the shared footer. — Confirmed
(`_ar/prtsc/screencapture-patrondeti-cz-blog-2026-07-04-13_16_59.png`).

### empty
Not observed. Whether a thematic section with zero tagged articles is hidden entirely, rendered
with a placeholder, or simply never occurs (fixed editorial curation) is unknown — no
zero-article-section evidence exists in the capture (all six observed sections are populated). —
`Uncertain — not captured`.

### loading
Not observed. Whether the listing renders synchronously (static/SSR editorial page) or
asynchronously (e.g., a "load more" mechanism appending further sections/articles) is not evidenced
from a single static screenshot; no pagination or "load more" control is visible below the last
section in the capture. — `Uncertain — not captured`.

### error
Not observed. No error/failure treatment (e.g., articles failing to load) is evidenced for this
screen. — `Uncertain — not captured`.

---

## Validation Surfaces

This is a read-only content/browse screen with no form fields or user-submitted input observed — no
validation surfaces apply.

`N/A — no input controls observed on this screen (Controls / Form fields: none, per
_ar/evidence/ui/ui-observed-areas.md §14: "Form fields / Tables: none")`.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Hero article band | `EN0024` | — | Binds the single Blog post flagged `is_hero_post = true`; fields shown: `name` (headline), `perex` (excerpt), `image`, `created`/publish date, `category`. — Confirmed mapping to `EN0024` attributes; no QUERY doc identified for "fetch current hero post." |
| Section article card / list row | `EN0024` | — | Each card/row binds one published Blog post's `name`, `perex` (large cards only), `image`, `created` date, and `category` (drives the tag chip/section grouping). — Confirmed mapping; the query/filter that groups posts into a named section by tag (and orders/limits them to 2 large + up to 3 small) is not evidenced — no QUERY doc identified. |
| Section heading (tag label) | `EN0024` (`category` taxonomy reference) | — | Section groupings ("#O čem se mluví" etc.) correspond to `EN0024`'s `category` attribute (blog-category classification term); the underlying taxonomy term list is not separately modelled as an AR entity (per `EN0024` Relationships). — Probable. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | none observed | Anonymous/public — no role gate observed; ACL layer does not yet exist for this reconstruction pass. |
| "Můj účet" nav link | Assumed authenticated-state variant (not evidenced on this capture) | See IA / other screens for the logged-in nav variant; out of scope here. |
| Unpublished Blog posts (`EN0024` status = Unpublished) | `EN0024` lifecycle (Published/Unpublished) | Presumed excluded from the listing entirely (only `Published` posts shown) — not independently confirmed on this screen, consistent with the general publish/unpublish lifecycle recorded in `EN0024`. — Probable. |

No BR or ACL doc was found governing visibility on this screen; it is treated as unconditionally
public content, consistent with `WIRE0019`'s equivalent finding for the other content/browse screen.

---

## Accessibility Notes

Not observed in the static screenshot evidence — no DOM/ARIA inspection was performed as part of
this reconstruction pass. The following are `Uncertain`/`Evidence Pending`:

- **Tab order:** Assumed to follow visual/DOM order (nav → hero article → section 1 cards → section
  2 cards → … → section 6 cards → footer) — not verified.
- **Focus on entry:** Not observed.
- **Focus on state transition:** Not observed (no state transition captured — see States).
- **Landmarks:** Not observed; presence of semantic `<nav>`/`<main>`/`<article>`/`<footer>`
  landmarks is unconfirmed from a screenshot alone.
- **Keyboard shortcuts:** None observed; none expected for a content browse screen.

---

## Open Questions

- `UC0026` is asserted by this job's task directive as the realizing UC (closing the "blocked-no-uc"
  gap flagged in `_ar/spec-draft/WIRE-synthesis-report.md` §2/§4 for S013). At the time of writing,
  no `UC0026` file exists under `_ar/spec-draft/UC/` (the UC layer directory is currently empty in
  this workspace) — this WIRE doc carries the reference as directed but the link is **not**
  independently verifiable against a UC document yet. Flag for reconciliation once `UC0026` is
  drafted.
- Whether the article tag chip (`COMP0018` candidate reuse) is genuinely the same visual/component
  pattern as the Story/Campaign category chip documented under `COMP0018`'s current-state scope
  (stat-strip pill, catalogue card badge, story-detail sidebar tag), or a separately-styled blog-only
  tag element that merely looks similar, is **Uncertain** — not resolved by this reconstruction pass.
  If confirmed distinct, a separate blog-tag COMP may be warranted rather than folding it into
  `COMP0018`.
- Whether the section tag headings / article tag chips are interactive (filter the listing) is
  Uncertain — no active/filtered-state screenshot was captured; see `ui-observed-areas.md` §14: "category
  tag chips per article (grouping; interactivity not confirmed)."
- Whether clicking a section article card/row (not just the hero's "Číst více →") actually navigates
  to that article's detail screen is Probable but not independently click-through-confirmed.
- Whether additional articles/sections exist below the fold beyond the single captured screenshot
  (pagination, "load more," or infinite scroll) is unconfirmed — no such control is visible in the
  capture.
- S014 (Blog — article detail, `/blog/<slug>`) remains unreconstructed as its own WIRE document at
  the time of writing (also blocked-no-uc per the same prior synthesis pass); this screen's
  "Číst více →" / card-click navigation target is therefore Confirmed only as a route pattern
  (per `ui-observed-areas.md` §15), not as a cross-referenced WIRE doc_id.
- Per the project constitution, Blog/O nás are explicitly outside the `bid-patron-deti` rebuild
  canon for now (rebuild epic **E0004**, unbuilt) — this document is current-state reconstruction
  only and carries no implication about target/rebuild design for this screen.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Overall layout, zones, hero band, six thematic sections | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-blog-2026-07-04-13_16_59.png`; `_ar/evidence/ui/ui-observed-areas.md` §14 |
| Route, nav entry point | Confirmed | `_ar/spec-draft/IA/IA-patronus.md` lines 84, 212 |
| Screen previously blocked-no-uc; UC0026 closes that gap per task directive | Confirmed (blocker history) / Uncertain (UC0026 file existence) | `_ar/spec-draft/WIRE-synthesis-report.md` §2, §4; `_ar/spec-draft/UC/` directory currently empty |
| Hero article → `EN0024` `is_hero_post` binding | Confirmed | `EN0024` Attributes/Invariants ("At most one Blog post is the current hero post at any time") |
| Section grouping → `EN0024` `category` attribute | Probable | `EN0024` Attributes (`category` reference) and Relationships note (taxonomy not separately modelled) |
| Article tag chip ≈ `COMP0018` CategoryChip reuse | Uncertain | `COMP0018`'s own current-state scope is limited to `WIRE0001`/`WIRE0002` Story/Campaign category indicators; blog usage not previously itemized there |
| Global nav / footer chrome | Confirmed | `COMP0002`, `COMP0003` (shared chrome, "present as chrome on essentially every screen") |
| Interactivity of tag chips/headings (filter vs. static) | Uncertain | `ui-observed-areas.md` §14: "interactivity not confirmed" |
| empty / loading / error states | Uncertain / not captured | no additional screenshots or evidence found for this screen |
| Accessibility | Evidence Pending | screenshot-only evidence; no DOM/ARIA capture available |
| Blog outside rebuild canon (E0004, unbuilt) | Confirmed | Project constitution / task instruction — current-state only, no target-design detail invented |
