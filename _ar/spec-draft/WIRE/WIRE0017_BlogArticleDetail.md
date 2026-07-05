---
doc_id: WIRE0017
title: Blog Article Detail
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S014
realizes_uc: [UC0026]
status: draft
references:
  - UC0026
  - EN0024
  - COMP0002
  - COMP0003
  - COMP0001
  - COMP0015
  - COMP0018
  - COMP0019
  - COMP0004
---

# WIRE0017 – Blog Article Detail

## Purpose

A public, anonymous-visitor editorial content page at `/blog/<slug>` — the detail view of a single
Patronus Blog article (`EN0024`), reached from the Blog listing (`WIRE0016`, S013) via a hero
"Číst více →" link or an article title/card click. It is a pure browse/read screen: the visitor reads
the article's title, meta (date + category tag), hero campaign image, and prose body, then may follow
one of the article's donation call-to-actions (fixed monthly presets, custom amount, or the **DMS SMS
donation channel** copy — handoff to the donation flow `UC0005`), share the article, or open a related
article. It realizes `UC0026` sub-flow **UC0026.2 — Open and read an article (screen S014)**.

Actor: anonymous visitor / reader (no authentication observed or implied; no distinct logged-in
variant observed on this capture beyond the shared header's "Můj účet" affordance).

**Current-vs-target note:** this document reconstructs **current-state** Patronus (`/blog/<slug>` as it
exists on the live site today). Blog/O nás are **not** part of the `bid-patron-deti` rebuild canon yet
— the rebuild treats them under a separate, unbuilt epic (E0004). Nothing here is target-design intent;
it is a faithful current-state account only.

---

## Layout Zones

```
+--------------------------------------------------------------+
| Global nav — logo | Jak to funguje | Blog | O nás |          |
|                    Požádat o pomoc (CTA) | Můj účet           |
+--------------------------------------------------------------+
| "← Zpět na všechny články" back-link                         |
+--------------------------------------------------------------+
| Article header                                               |
|   H1 title ("Patron dětí, Nova pomáhá a Ondřej Sokol …")     |
|   DATE ("19. 05. 2026") | #TAG-CHIP ("#O čem se mluví")       |
+--------------------------------------------------------------+
| Hero image (full-width campaign banner —                     |
|   "DARUJME PRÁZDNINY / Nova pomáhá / a každý dar zdvojnásobí")|
+--------------------------------------------------------------+
| Article body (prose)                                         |
|   lead paragraph                                             |
|   pull-quotes / cited speakers (Ondřej Sokol, Edita          |
|     Mrkousová, Anna Ševerová)                                 |
|   campaign-matching copy ("televize Nova navýší až do        |
|     celkové výše 750 000 Kč")                                 |
|   DMS-SMS donation copy block ("… zvolit trvalou dárcovskou  |
|     SMS na číslo 87 777: DMS TRV PATRONDETI 90 nebo 290")     |
|   inline links ("na svém webu", "hlavní stránku našeho webu")|
+--------------------------------------------------------------+
| Share row — "SDÍLEJTE ČLÁNEK S PŘÁTELI"                      |
|   [Sdílet] [Tweetnout] [LinkedIn] [Zkopírovat odkaz]          |
+--------------------------------------------------------------+
| "Nepřehlédněte" — related articles                          |
|   [card] [card] [card w/ campaign CTA "Pomůžu"]              |
+--------------------------------------------------------------+
| Footer — cookie notice, company info, nav link clusters,     |
|          payment-provider logos, collection account no.      |
+--------------------------------------------------------------+
```

- **Global nav** — logo (→ S001), "Jak to funguje" (→ S016), "Blog" (→ S013 listing), "O nás"
  (→ S015), "Požádat o pomoc" CTA (→ S006), "Můj účet" (→ auth zone). — Confirmed
  (`_ar/prtsc/screencapture-…darujme-prazdniny-2026-07-04-13_17_24.png`; shared header pattern per
  `COMP0002`).
- **Back-link** — "← Zpět na všechny články" above the title, returning to the Blog listing (S013). —
  Confirmed (screenshot; `ui-observed-areas.md` §15 CTAs: "Zpět na všechny články").
- **Article header** — H1 title, then a meta row combining the publish/change date and one category
  tag chip ("19. 05. 2026 | #O čem se mluví"). — Confirmed. Binds `EN0024` `name` + `created`/date +
  `category`.
- **Hero image** — full-width campaign banner image directly under the header (the "Darujme prázdniny
  / Nova pomáhá" visual with Ondřej Sokol). — Confirmed. Binds `EN0024` `image`.
- **Article body** — long-form prose: a bolded lead paragraph, several body paragraphs interleaved
  with italicised pull-quotes attributed to named speakers, a campaign-matching passage, a
  DMS-SMS donation-copy block, and inline text links. This is authored article content (`EN0024`
  `body`), not a system-computed projection. — Confirmed as observed copy (see Interactions §DMS and
  Open Questions on the nature of the matching claim).
- **DMS-SMS donation copy block** — a closing call-to-action paragraph inviting the reader to set up a
  recurring donation via the site ("kliknout na vybrané kolečko v banneru") or via a **trvalá
  dárcovská SMS** ("na číslo 87 777: DMS TRV PATRONDETI 90 nebo 290"). Rendered as body prose with
  inline emphasis and links — no distinct donation widget/form is present on this screen. — Confirmed
  (screenshot; `ui-observed-areas.md` §15; `UC0026.2` step 5).
- **Share row** — a labelled "SDÍLEJTE ČLÁNEK S PŘÁTELI" row with four buttons: "Sdílet" (Facebook),
  "Tweetnout" (X/Twitter), "LinkedIn", and "Zkopírovat odkaz" (copy-link). — Confirmed (screenshot;
  `ui-observed-areas.md` §15). Note: labelled buttons here differ from the icon-only ShareRow observed
  on `WIRE0002`/`WIRE0003` — see Components Used.
- **"Nepřehlédněte" related articles** — a heading followed by three related-article teaser cards
  (thumbnail + date + category chip + title + excerpt); the third card is a campaign-styled promo card
  ("Podpořme děti s Downovým syndromem") carrying a "Pomůžu" button rather than a plain teaser. —
  Confirmed layout (screenshot); the query behind "related" selection is not evidenced (see Data
  Bindings / Open Questions).
- **Footer** — shared global footer (cookie consent bar, company block, nav link clusters, payment
  logos, collection account number "57574646/0600"). — Confirmed; see `COMP0003`.

---

## Components Used

Every visual element traces to a `COMPxxxx` doc_id or is flagged `inline`. No dedicated WIRE-layer
promotion pass for this screen's own article-body or related-card patterns has occurred yet — see
notes below.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Global nav | `COMP0002` | context=public | Shared header chrome, identical pattern to S001/S013/S016/etc. — see `COMP0002` SiteHeader. |
| Nav brand logo | `COMP0019` | — | Composed inside `COMP0002`; "patron dětí" wordmark + "společně za lepší dětství" tagline. |
| "Požádat o pomoc" CTA (nav) | `COMP0001` | primary, small | Header-scoped CTA button; same label/target pattern as observed elsewhere (`COMP0001` Button). |
| "← Zpět na všechny články" back-link | inline | text link with back-arrow glyph | Not confirmed as a `COMP0001` Button instance (plain text + leading arrow, no button chrome). |
| Article header (title + date + tag) | inline | — | Editorial article header; not observed as an independently reusable component elsewhere — `inline`. |
| Article category tag chip ("#O čem se mluví") | `COMP0018` | label=blog-tag text | **Probable** reuse of the pill-shaped tag-chip visual documented as `COMP0018` CategoryChip's current-state shape (colored pill + "#"-prefixed text). `COMP0018`'s own current-state scope is Story/Campaign category tags; blog article tags are a **visually similar but not confirmed-identical** usage — flagged probable, not asserted. Same caveat as `WIRE0016`. See Open Questions. |
| Hero image | inline | full-width banner image | Rendered as the article's lead image (`EN0024` `image`); not a reusable component. |
| Article body prose | inline | rich-text body | Long-form authored content (paragraphs, italic pull-quotes, bold emphasis, inline links). Not a component — `inline`. |
| Related-article card (large, in "Nepřehlédněte") | inline | thumbnail + date + tag chip + title + excerpt | Visually the same teaser pattern as the section cards on `WIRE0016`; kept `inline` there and here (not promoted — serves editorial content, no funding/progress elements, so **not** a `COMP0008` StoryCard reuse). |
| Related-article promo card ("Podpořme děti…" + "Pomůžu") | inline (card) + `COMP0001` (button) | primary "Pomůžu" | A campaign-styled variant of the related card carrying a `COMP0001` CTA button; the surrounding promo-card container is `inline`. — Probable (button is a clear `COMP0001` instance; the promo-card frame is not separately modelled). |
| Share row ("Sdílet"/"Tweetnout"/"LinkedIn"/"Zkopírovat odkaz") | `COMP0015` | variant=labelled buttons; networks=[Facebook, X, LinkedIn] + copy-link | **Probable** reuse of `COMP0015` ShareRow. Divergence: this instance renders **labelled** buttons plus a "Zkopírovat odkaz" (copy-link) action, whereas `COMP0015`'s two Confirmed instances (`WIRE0002`/`WIRE0003`) render **icon-only** networks (FB/X/IG/LinkedIn/WhatsApp/Messenger[/Email]). Recorded as a labelled/blog variant of the same share-row concept, not asserted identical. See Open Questions. |
| Cookie consent bar (footer) | `COMP0004` | — | Shared cookie-notice bar; "Tyto stránky používají … soubory cookie … Další informace." — see `COMP0004`. |
| Footer | `COMP0003` | — | Shared global footer, identical pattern to other Public-site screens; see `COMP0003` SiteFooter. |

---

## Interactions

1. **Entry** — navigation to `/blog/<slug>` from the Blog listing (`WIRE0016`, S013) via the hero
   "Číst více →" link, an article title/card click, or a "Nepřehlédněte" related-card click on another
   article; also directly addressable by URL → state: `default`. — Confirmed route pattern
   (`ui-observed-areas.md` §15 `urlPath`; `UC0026.2` step 1: node canonical/alias route, not a
   `blog`-module-owned route).
2. **Back-link — "← Zpět na všechny článek"** — click "← Zpět na všechny články" → navigates back to
   the Blog listing (S013, `/blog`). Read/navigation only; no mutation. — Confirmed (screenshot).
3. **Body inline links — "na svém webu" / "hlavní stránku našeho webu"** — click → navigates to the
   site's story catalogue / homepage donation surface (S001). — Confirmed as present links
   (screenshot); exact targets inferred from link copy, not click-through-confirmed. — Probable target.
4. **DMS-SMS donation copy** — the closing paragraph instructs the reader to set up a recurring
   donation on the site or via a trvalá dárcovská SMS to 87 777 (`DMS TRV PATRONDETI 90 / 290`). This
   is **informational copy**, not an interactive widget — no on-screen donation form/field is rendered
   here; following the site route hands off to the donation flow (`UC0005`, out of scope beyond
   handoff, per `UC0026.2` step 5). — Confirmed (screenshot; `ui-observed-areas.md` §15).
5. **Share row actions** — "Sdílet" / "Tweetnout" / "LinkedIn" open the respective network's share
   intent for this article's URL; "Zkopírovat odkaz" copies the article URL to clipboard. — Confirmed
   as present actions (screenshot); the actual share/copy behaviors and target URL are not observable
   from static evidence (see `COMP0015` — "share-behavior target content … not observable"). — Probable
   behavior.
6. **Related-article click ("Nepřehlédněte")** — clicking a related-article card → navigates to that
   article's own detail (S014, recursively `UC0026.2`); the promo card's "Pomůžu" button → donation
   entry for that campaign (`UC0005`). — Probable (whole-card click affordance not click-through
   confirmed; "Pomůžu" is a clear CTA button).
7. **Exit** — via the back-link (to S013), global nav (to S001/S015/S016/S006), footer links, or a
   share/donation handoff; no "cancel"/"submit" exit exists since this is a read-only content screen. —
   Confirmed.

---

## States

### default
The fully rendered article page as captured: back-link, article header (title + date + tag), hero
campaign image, prose body (lead paragraph, pull-quotes, campaign-matching copy, DMS-SMS donation
block), labelled share row, "Nepřehlédněte" related articles, ending in the shared footer. — Confirmed
(`_ar/prtsc/screencapture-patrondeti-cz-blog-patron-deti-nova-pomaha-a-ondrej-sokol-zvou-do-kampane-darujme-prazdniny-2026-07-04-13_17_24.png`; `ui-observed-areas.md` §15).

### empty
`N/A — a rendered article detail is never "empty"` in the sense of the browse/read screen: an article
is either published-and-rendered (default) or not reachable at all. A published article with no
related-article matches would render the "Nepřehlédněte" block empty/absent, but no
zero-related-articles capture exists to confirm the treatment. — `Uncertain — not captured` for the
related-articles-absent sub-case; otherwise N/A.

### loading
Not observed. Whether the article renders synchronously (static/SSR node page — consistent with
`UC0026.2` describing a standard Drupal node canonical render) or with any async body/related-content
loading is not evidenced from a single static screenshot; no loading indicator is visible in the
capture. — `Uncertain — not captured` (Assumed synchronous SSR render, per `UC0026.2` code grounding,
but not verified on this screen).

### error
Not observed. An unpublished or non-existent `/blog/<slug>` would be governed by Drupal node access /
404 handling (`UC0026.2` step 2: published nodes visible to anonymous under standard node access) — no
error/404/access-denied treatment for the blog detail is captured in evidence. — `Uncertain — not
captured`.

---

## Validation Surfaces

This is a read-only content/browse screen with no form fields or user-submitted input observed — no
validation surfaces apply.

`N/A — no input controls observed on this screen (Controls / Form fields / Tables: none, per
_ar/evidence/ui/ui-observed-areas.md §15)`.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Article header — title | `EN0024` | — | Binds the article's `name` (H1 title). — Confirmed mapping to `EN0024`. |
| Article header — date + tag | `EN0024` | — | Binds `created`/change date ("19. 05. 2026") and `category` (tag chip "#O čem se mluví"). — Confirmed. No QUERY doc identified for "fetch article by slug"; `UC0026.2` grounds this in a standard Drupal node canonical render, not a `blog`-module query. |
| Hero image | `EN0024` | — | Binds the article's lead `image` (campaign banner). — Confirmed mapping. |
| Article body (prose, pull-quotes, campaign-matching copy, DMS-SMS block) | `EN0024` | — | Binds `body` (rich-text authored content). The campaign-matching claim ("Nova navýší až do celkové výše 750 000 Kč") and the DMS-SMS instructions are **authored article copy**, not a system-computed projection — see `UC0026.2` step 4 note. — Confirmed as `body` binding; Uncertain whether any `cta_*` structured field (per `EN0024`) drives part of this vs. all being free-text body. |
| "Nepřehlédněte" related cards | `EN0024` | — | Each related card binds a published Blog post's `name`, `perex` (excerpt), `image`, `created` date, and `category`. The selection/ordering logic behind "related" (same-category? recency? manual?) is **not evidenced** — no QUERY doc identified; note the three observed related cards all carry the "#Děti s Downovým syndromem" tag, differing from the current article's "#O čem se mluví" tag, so "related" is **not** simply same-category. — Probable (binding); Uncertain (selection rule). |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | none observed | Anonymous/public — governed by standard Drupal node access; published `blog` nodes visible to anonymous (`UC0026.2` step 2). No AR ACL layer exists for this reconstruction pass. |
| "Můj účet" nav link | Assumed authenticated-state variant (not evidenced on this capture) | See IA / other screens for the logged-in nav variant; out of scope here. |
| Unpublished article (`EN0024` status = Unpublished) | Drupal node access / `EN0024` lifecycle (Published/Unpublished) | Presumed not reachable by anonymous visitors (access-denied / 404) — not independently confirmed on this screen, consistent with the publish/unpublish lifecycle recorded in `EN0024` and `UC0026.2`. — Probable. |
| "Nepřehlédněte" related block | related-article availability (query not evidenced) | Presumed omitted/empty when no related articles exist (see States §empty) — not captured. — Uncertain. |

No BR or ACL doc was found governing visibility on this screen; it is treated as unconditionally public
content, consistent with `WIRE0016`'s equivalent finding for the sibling Blog listing screen.

---

## Accessibility Notes

Not observed in the static screenshot evidence — no DOM/ARIA inspection was performed as part of this
reconstruction pass. The following are `Uncertain`/`Evidence Pending`:

- **Tab order:** Assumed to follow visual/DOM order (nav → back-link → article header → body links →
  share row → related cards → footer) — not verified.
- **Focus on entry:** Not observed (Assumed top-of-document / skip-to-content per standard page load —
  not verified).
- **Focus on state transition:** Not observed (no state transition captured — see States).
- **Landmarks:** Not observed; presence of semantic `<nav>`/`<main>`/`<article>`/`<footer>` landmarks
  and an accessible article heading hierarchy is unconfirmed from a screenshot alone.
- **Keyboard shortcuts:** None observed; none expected for a content read screen.

`Evidence Pending — static screenshot only; no DOM/ARIA capture available.`

---

## Open Questions

- `UC0026` (sub-flow `UC0026.2`) is the realizing UC for this screen; `UC0026` now exists on disk
  (`_ar/spec-draft/UC/UC0026_BrowseReadBlog.md`) and explicitly names S014 as its article-detail
  screen, so the realizing-UC link is verifiable (unlike the sibling `WIRE0016`, which was written
  before `UC0026` landed). No open blocker remains on the UC link itself.
- Whether the article category tag chip (`COMP0018` candidate reuse) is genuinely the same
  visual/component pattern as the Story/Campaign category chip documented under `COMP0018`, or a
  separately-styled blog-only tag, is **Uncertain** — carried forward from `WIRE0016`.
- Whether the labelled share row on this screen is the same `COMP0015` ShareRow component (rendered in
  a labelled/blog variant with an added "Zkopírovat odkaz" copy-link action) or a distinct blog-only
  share component is **Uncertain** — `COMP0015`'s two Confirmed instances are icon-only; the label +
  copy-link divergence is recorded, not reconciled. If confirmed distinct, a separate blog-share COMP
  (or a `COMP0015` labelled variant) may be warranted.
- The "Nepřehlédněte" related-article selection rule is **not evidenced** — the three observed related
  cards share a tag ("#Děti s Downovým syndromem") different from the current article's tag, so
  same-category selection is ruled out, but the actual rule (manual curation, recency, taxonomy
  relation, etc.) is unknown; no QUERY doc identified.
- Whether the campaign-matching figure ("750 000 Kč") and DMS-SMS details are free-text `body` copy or
  are partly driven by structured `EN0024` `cta_*` fields is **Uncertain** — `UC0026.2` step 4 treats
  this as authored copy, not a system projection.
- `loading` and `error`/404 states are **Uncertain — not captured**; the synchronous-SSR assumption is
  grounded in `UC0026.2`'s node-canonical-render description but not verified on this screen.
- Per the project constitution, Blog/O nás are explicitly outside the `bid-patron-deti` rebuild canon
  for now (rebuild epic **E0004**, unbuilt) — this document is current-state reconstruction only and
  carries no implication about target/rebuild design for this screen.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Overall layout, zones, back-link, header, hero image, body, share row, related block, footer | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-blog-patron-deti-nova-pomaha-a-ondrej-sokol-zvou-do-kampane-darujme-prazdniny-2026-07-04-13_17_24.png`; `_ar/evidence/ui/ui-observed-areas.md` §15 |
| Route (`/blog/<slug>`), entry from listing, realizing `UC0026.2` (S014) | Confirmed | `ui-observed-areas.md` §15 `urlPath`; `UC0026` Main Flow UC0026.2; `_ar/spec-draft/WIRE/WIRE0016_BlogArticleListing.md` (sibling listing, S013 → S014) |
| Header/date/tag/hero/body → `EN0024` attribute bindings | Confirmed (title/date/tag/image/body) / Uncertain (`cta_*` vs. free-text) | `EN0024` Attributes; `UC0026` UC0026.2 steps 3–5 |
| Campaign-matching copy + DMS-SMS donation channel = authored article copy (not a system projection) | Confirmed (copy present) / Uncertain (structured vs. free-text source) | screenshot; `ui-observed-areas.md` §15 ("Nova navýší až do celkové výše 750 000 Kč", "DMS TRV PATRONDETI 90 nebo 290"); `UC0026` UC0026.2 step 4 note |
| Global nav / brandmark / footer / cookie-bar chrome | Confirmed | `COMP0002`, `COMP0019`, `COMP0003`, `COMP0004` (shared chrome on essentially every public screen) |
| Category tag chip ≈ `COMP0018` CategoryChip reuse | Probable / Uncertain | `COMP0018` current-state scope limited to Story/Campaign tags; blog usage visually similar, not confirmed identical (same caveat as `WIRE0016`) |
| Share row ≈ `COMP0015` ShareRow reuse (labelled variant + copy-link) | Probable / Uncertain | `COMP0015` Confirmed instances are icon-only (`WIRE0002`/`WIRE0003`); this instance is labelled + adds "Zkopírovat odkaz" |
| "Nepřehlédněte" related-article selection rule | Uncertain | screenshot shows related cards with a different tag than the article — rule not evidenced; no QUERY doc |
| empty / loading / error(404) states | Uncertain / not captured | no additional screenshots or evidence found for this screen; SSR-render assumption grounded in `UC0026` UC0026.2 |
| Accessibility | Evidence Pending | screenshot-only evidence; no DOM/ARIA capture available |
| Blog outside rebuild canon (E0004, unbuilt) | Confirmed | Project constitution / task instruction — current-state only, no target-design detail invented |
