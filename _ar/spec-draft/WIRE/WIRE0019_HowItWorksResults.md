---
doc_id: WIRE0019
title: How It Works Results
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S016
realizes_uc: [UC0011]
status: draft
references:
  - UC0011
  - UC0017
  - EN0004
  - EN0021
  - EN0032
---

# WIRE0019 – How It Works Results

## Purpose

A public, anonymous-visitor content/trust page at `/vysledky` ("Jak to funguje / Výsledky"),
reached from the global nav item "Jak to funguje" and from the footer link "Splněné příběhy"
(`_ar/spec-draft/IA/IA-patronus.md`, lines 82/97/214). It explains the donation process in three
steps, lists eight trust arguments, displays three aggregate impact figures, and showcases a grid of
completed Stories (Campaigns) with "SPLNĚNO" (completed) and "ZPĚTNÁ VAZBA" (feedback) badges, each
linking to a Story detail screen (S002, `WIRE0002`).

The screen's realizing UC is carried at **Probable** certainty from the IA Screen Map
(`_ar/spec-draft/IA-screen-map.md`, S016 row): `UC0011` (Manage Campaign / Story Lifecycle) is the
only UC that governs the Campaign `completed` status shown here (badge "SPLNĚNO" — glossary term
C106 "splněný příběh"), but UC0011 does not itself describe a public read screen — it describes the
admin/scheduler-side lifecycle transitions that produce the `completed` state consumed here. This
screen is therefore a **read-only consumer** of Campaign state (`EN0004`) set by UC0011, not an
actor-driven flow of UC0011 itself. Per IA-Q7 (`IA-patronus.md` line 331) it is **not determinable**
whether the three aggregate figures ("232,7 mil. Kč" / "70 299 lidí" / "8 000 Kč" / "32 977 příběhů")
are a computed read-model (candidates: `EN0032` ReportSnapshot / `UC0017` reporting read-model) or
static editorial content — carried here as an open question, not resolved.

Actor: anonymous visitor (no authentication observed or implied).

---

## Layout Zones

```
+--------------------------------------------------------+
| Global nav — logo | Jak to funguje | Blog | O nás |     |
|                    Požádat o pomoc (CTA) | Můj účet     |
+--------------------------------------------------------+
| Hero band — "Jak to funguje?" 3-step explainer          |
|   [icon] 1. Rodič a Patron vyplní žádost                |
|   [icon] 2. Společně hledáme dárce                      |
|   [icon] 3. Na pořízení pomoci jde 100 % daru            |
+--------------------------------------------------------+
| Trust section — "Proč nám můžete důvěřovat?"            |
|   8 × (icon, heading, body text) trust arguments        |
+--------------------------------------------------------+
| Aggregate stats band — 3 figure blocks                  |
|   CELKEM VYBRÁNO | CELKEM PŘISPĚLO | PRŮMĚRNÝ PŘÍBĚH    |
+--------------------------------------------------------+
| Impact banner — full-bleed photo + headline figure       |
|   "Společně jsme podpořili 32 977 příběhů"               |
+--------------------------------------------------------+
| Completed-stories grid — "Podívejte se na ně"            |
|   2 rows × 3 cards (image, badges, title, amount, CTA)  |
|   "Další příběhy" (load more / pagination link)          |
+--------------------------------------------------------+
| Footer — cookie notice, company info, nav link clusters, |
|          payment-provider logos, collection account no.  |
+--------------------------------------------------------+
```

- **Global nav** — logo (→ S001), "Jak to funguje" (current page), "Blog" (→ S013), "O nás" (→ S015),
  "Požádat o pomoc" CTA (→ S006), "Můj účet" (→ auth zone). — Confirmed.
- **Hero / how-it-works band** — pink background band, three numbered steps with icon, heading, and
  supporting copy. — Confirmed.
- **Trust section** — heading "Proč nám můžete důvěřovat?" followed by 8 stacked items, each an icon +
  bold heading + body paragraph (two items contain inline text links: "výročních zprávách",
  "pravidelně kontrolována"). — Confirmed.
- **Aggregate stats band** — three side-by-side labeled figures on a light-grey background. —
  Confirmed layout; **Uncertain** whether values are dynamic or static (see Purpose, IA-Q7).
- **Impact banner** — full-width background photograph with a centered headline stat. — Confirmed
  layout; same dynamic/static uncertainty as the stats band.
- **Completed-stories grid** — heading "Podívejte se na ně", a responsive grid of Story cards (6
  visible: 2 rows × 3 columns), each with a thumbnail image, two top-left/top-right badges, a
  status ribbon, title, raised-amount line, and a CTA button; a "Další příběhy" link below the grid.
  — Confirmed.
- **Footer** — cookie consent bar, company block ("patron dětí" + parent org "Nadace Sirius" +
  registered-collection notice), three nav link clusters ("Patron dětí", "Kontakt", social), payment
  logos (Comgate/Mastercard/Visa), collection account number. — Confirmed. (Footer is a shared/global
  region — its internal link targets are owned by IA, not restated here; see IA-Q8.)

---

## Components Used

The COMP layer does not yet exist for this reconstruction pass; every element below is flagged
`inline` pending COMPSynthesizer.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Global nav | inline | — | shared header, same as observed on S001/S013/S015 |
| How-it-works step | inline | 3-up icon+heading+text, repeated ×3 | — |
| Trust list item | inline | icon+heading+paragraph, repeated ×8 | two items carry inline text links |
| Stat figure block | inline | label+value, repeated ×3 | — |
| Impact banner | inline | full-bleed photo + centered headline stat | — |
| Story card (completed) | inline | thumbnail, badge×2 ("ZPĚTNÁ VAZBA" pill top-right, hand-icon chip top-left), status ribbon "SPLNĚNO", title, "Vybráno celkem" + amount + checkmark icon, CTA button "Detail příběhu" | same card pattern family as the catalogue card on S001 (`WIRE0001`) but with the completed-state variant (ribbon + feedback badge) not otherwise observed there — treat as a distinct visual variant, not confirmed to be the identical component |
| "Další příběhy" link | inline | text link | pagination/load-more affordance; target behavior not observed (see Interactions) |
| Footer | inline | shared global footer | same as observed on other Public-site screens |

---

## Interactions

1. **Entry** — direct navigation to `/vysledky` via global nav "Jak to funguje" or footer "Splněné
   příběhy" link → state: `default`. — Confirmed (route + entry points; `IA-patronus.md` line 214).
2. **Primary action — "Detail příběhu"** — click a completed-story card's CTA → navigates to that
   Story's detail screen (S002, `WIRE0002`); does not itself realize a UC on this screen (read
   navigation only). — Confirmed (target screen and pattern), based on the identical CTA label
   observed on S002-family cards.
3. **Secondary action — "Další příběhu"** — click the "Další příběhy" link below the grid → expected
   to load/reveal more completed-story cards (pagination or infinite-scroll); the resulting behavior
   (in-place append vs. full navigation vs. page reload) is **not observed** in the captured
   screenshot. — Uncertain.
4. **Secondary action — inline trust-section links** ("výročních zprávách", "pravidelně
   kontrolována") — click → navigate to supporting evidence pages (annual reports / oversight
   record); exact targets not captured on this screen (out of scope for WIRE — see IA-Q8). —
   Assumed.
5. **Exit** — via global nav (to S001/S013/S015/S006) or footer links; no explicit "cancel"/"submit"
   exit exists since this is a read-only content screen. — Confirmed.

---

## States

### default
The fully rendered page as captured: hero explainer, trust list, three stat figures, impact banner,
and a populated 6-card completed-stories grid with a "Další příběhy" link. — Confirmed
(`screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png`).

### empty
Not observed. If no completed Story qualifies for the grid (e.g., zero Campaigns in `completed`
status), the grid's empty treatment is unknown — no evidence of a placeholder/zero-state message.
Assumed the grid section would not render or would collapse, but this is unconfirmed. —
`Uncertain — not captured`.

### loading
Not observed. Whether the stats band / grid render synchronously with the page (static/SSR) or
asynchronously (skeleton/spinner while a read-model query resolves) depends on the unresolved
IA-Q7 question (dynamic vs. static content). — `N/A — dynamism of this screen's data is itself an
open question (IA-Q7); no loading-state evidence exists either way`.

### error
Not observed. No error/failure treatment (e.g., stats or grid failing to load) is evidenced. —
`Uncertain — not captured`.

---

## Validation Surfaces

This is a read-only content/browse screen with no form fields or user-submitted input observed —
no validation surfaces apply.

`N/A — no input controls observed on this screen (Controls/Form fields: none, per
_ar/evidence/ui/ui-observed-areas.md §17)`.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Completed-story grid card | `EN0004` (Campaign, `completed` status / glossary C106 "splněný příběh") | — | badge "SPLNĚNO" — Confirmed mapping to Campaign lifecycle state per `EN0004` and UC0011; card population/filter/sort query not evidenced (no QUERY doc identified) — Uncertain |
| Completed-story grid card — "ZPĚTNÁ VAZBA" badge | `EN0021` (Feedback) | — | glossary terms C008/C109/C117 associate "zpětná vazba" with the Feedback entity and feedback-related status aliases; the precise binding (is this a Feedback-entity presence flag, or a Campaign/Application status alias like `feedback_sent`?) is **Uncertain** — not resolved by the screenshot alone |
| Aggregate stats band (CELKEM VYBRÁNO / CELKEM PŘISPĚLO / PRŮMĚRNÝ PŘÍBĚH) | `EN0032` (ReportSnapshot) — candidate, unconfirmed | — | per IA-Q7: could be a computed read-model (`UC0017` sub-flow UC0017.3) or static editorial content; **Uncertain**, not asserted as confirmed |
| Impact banner headline ("32 977 příběhů") | `EN0032` (ReportSnapshot) — candidate, unconfirmed | — | same IA-Q7 uncertainty as the stats band |
| Story card raised-amount line ("Vybráno celkem … Kč") | `EN0004` (`campaign_raised`) | — | Probable — matches the Campaign entity's system-managed derived raised total, consistent with the amounts shown on individual story cards elsewhere (S001/S002), though not independently confirmed for this screen |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | none observed | anonymous/public — no role gate observed; ACL layer does not yet exist for this reconstruction pass |
| "Můj účet" nav link | Assumed authenticated-state variant (not evidenced on this capture) | — see IA / other screens for the logged-in nav variant; out of scope here |

No BR or ACL doc was found governing visibility on this screen; it is treated as unconditionally
public content.

---

## Accessibility Notes

Not observed in the static screenshot evidence — no DOM/ARIA inspection was performed as part of
this reconstruction pass. The following are `Uncertain`/`Evidence Pending`:

- **Tab order:** Assumed to follow visual/DOM order (nav → hero → trust list → stats → banner → grid
  cards → footer) — not verified.
- **Focus on entry:** Not observed.
- **Focus on state transition:** Not observed (no state transition captured — see States).
- **Landmarks:** Not observed; presence of semantic `<nav>`/`<main>`/`<footer>` landmarks is
  unconfirmed from a screenshot alone.
- **Keyboard shortcuts:** None observed; none expected for a content browse screen.

---

## Open Questions

- IA-Q7 (carried from IA layer, `IA-patronus.md` line 331): are the three aggregate stats and the
  impact-banner figure a computed read-model (`EN0032`/`UC0017`) or static editorial content? This
  determines whether this screen has a `loading`/`error` state at all.
- Is "ZPĚTNÁ VAZBA" on a story card driven by the `EN0021` Feedback entity's presence, or by a
  Campaign/Application status alias (glossary C109 `feedback_sent` / C117 `feedback_received`)? No
  BR or query doc resolves this.
- What determines which completed Campaigns/Stories are selected/ordered into the 6-card grid (most
  recent? featured flag? random?) and what does "Další příběhy" do (paginate in-place, navigate to a
  full list screen, or infinite-scroll)? Not observed.
- Empty/loading/error visual treatments for the stats band and the story grid are entirely
  unevidenced.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Overall layout, zones, hero/trust/stats/banner/grid/footer content | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png`; `ui-observed-areas.md` §17 |
| Route, nav entry points, footer entry point | Confirmed | `_ar/spec-draft/IA/IA-patronus.md` lines 82, 97, 214 |
| Realizing UC = UC0011 | Probable | `_ar/spec-draft/IA-screen-map.md` S016 row |
| "SPLNĚNO" badge → Campaign `completed` status | Probable | `EN0004` lifecycle; glossary C106 |
| "ZPĚTNÁ VAZBA" badge → EN0021 Feedback | Uncertain | glossary C008/C109/C117; no direct query/BR binding found |
| Aggregate stats dynamism (EN0032/UC0017 vs. static) | Uncertain | `IA-patronus.md` IA-Q7; `ui-observed-areas.md` §17 note |
| empty / loading / error states | Uncertain / not captured | no additional screenshots or evidence found for this screen |
| Accessibility | Evidence Pending | screenshot-only evidence; no DOM/ARIA capture available |
