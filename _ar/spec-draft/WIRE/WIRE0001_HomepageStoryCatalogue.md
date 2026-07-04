---
doc_id: WIRE0001
title: Homepage Story Catalogue
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S001
realizes_uc: [UC0023, UC0007, UC0009]
status: draft
references:
  - UC0023
  - UC0007
  - UC0009
  - EN0004
  - EN0005
  - EN0010
  - EN0013
  - IA-patronus (S001, IA-Q7)
---

# WIRE0001 – Homepage Story Catalogue

## Purpose

S001 is the public homepage and primary donor-acquisition landing (`_ar/spec-draft/IA-screen-map.md`
row S001; `_ar/spec-draft/IA/IA-patronus.md` §3.1). It lets an anonymous visitor or donor browse and
filter the active Campaign ("Příběh"/Story, `EN0004`) catalogue, primarily realizing **UC0023**
(Browse & Filter Story Catalogue). Two secondary use cases are entered from this screen rather than
completed on it: the hero recurring-donation presets are the UI entry point into a recurring
donation schedule (`EN0010`, **UC0007** governs the periodic cron-side charging that schedule feeds,
not a step performed on this screen) and the "Koupím dobrošek" voucher-purchase CTA is the entry
point toward **UC0009** (Redeem/Validate Voucher — purchase itself is a separate, uncaptured screen,
S005). Actor: anonymous visitor / donor (no authentication required — UC0023 preconditions).

Fully observed from four full-page screenshots capturing the default tab, the "Samoživitelé" tab, the
"Filtrovat podle krajů" tab (region map, unselected), and a full-scroll capture of the "Brzy skončí"
tab (`_ar/evidence/ui/ui-observed-areas.md` §1).

---

## Layout Zones

```
+--------------------------------------------------------------+
| Header — logo "patron dětí" | nav | "Požádat o pomoc" | Můj účet |
+--------------------------------------------------------------+
| Hero — headline strip + illustrated banner + 3 donation-preset|
|   circular CTAs ("Daruj 90 Kč měsíčně" / "290 Kč" / "podle    |
|   sebe") + spokesperson photo                                 |
+--------------------------------------------------------------+
| Stat strip — "323 dětí čeká na pomoc" + 2 category pill CTAs  |
|   ("Zdravotní pomoc" / "Rozvoj a vzdělání")                    |
+--------------------------------------------------------------+
| Filter tabs — Zbývající částka | Samoživitelé |               |
|   Filtrovat podle krajů | Brzy skončí                          |
+--------------------------------------------------------------+
| Catalogue grid — 6 story cards (2 rows x 3 cols) OR region map|
|   (on "Filtrovat podle krajů")                                |
|   + "Další příběhy" link below grid                            |
+--------------------------------------------------------------+
| Testimonial band — "Poděkování od rodin" carousel (1 card,    |
|   prev/next arrows)                                            |
+--------------------------------------------------------------+
| Voucher band — "Dobrošeky pro lepší dětství" — 6 denomination |
|   cards (100/250/500/1000/5000/10000 Kč) + "Koupím dobrošek"  |
+--------------------------------------------------------------+
| "Jak to funguje?" — 3-column explainer (icon+title+text)      |
+--------------------------------------------------------------+
| Patron explainer band — "Kdo je to Patron příběhu?" + photo + |
|   "Chci se stát Patronem" CTA                                  |
+--------------------------------------------------------------+
| Sponsor/partner logos — "Podporují nás" + "Spřátelené          |
|   organizace"                                                  |
+--------------------------------------------------------------+
| Footer — org blurb, link columns (Patron dětí / Kontakt),     |
|   payment-method badges, collection-account number             |
+--------------------------------------------------------------+
| Cookie-consent banner (overlay, bottom-left, persistent chrome)|
+--------------------------------------------------------------+
```

- **Header** — global site nav: logo/home link, "Jak to funguje", "Blog", "O nás", "Požádat o pomoc"
  (button), "Můj účet" (icon+label). Confirmed on all 4 screenshots.
- **Hero** — red headline card "DARUJME DĚTEM ŠANCI / za jedno kafe měsíčně" over an illustrated
  banner, spokesperson photo holding a mug, and three circular preset CTAs. Confirmed.
- **Stat strip** — large numeral "323 dětí" + "čeká na pomoc" caption, and two pill-shaped category
  CTAs ("Zdravotní pomoc" purple, "Rozvoj a vzdělání" green). Confirmed.
- **Filter tabs** — four-tab control described under Interactions. Confirmed.
- **Catalogue grid** — 6 Campaign cards per tab (except region tab, which replaces the grid with a
  map), each: category icon badge, photo, "ZBÝVÁ <n> <unit>" countdown ribbon (or "SBÍRKOVÝ ÚČET"
  purple ribbon for the collection-account card), title, "Chybí <amount> Kč" progress bar, "Cílová
  částka" row, raised-amount row, CTA button ("Podpořím `<jméno>`" or "Nechám to na vás"). Confirmed.
- **Region map sub-zone** (only on "Filtrovat podle krajů") — heading "Vyberte kraj na mapě" + an
  interactive grey SVG map of the 14 CZ regions. Confirmed (13_16_21 shows it in its neutral,
  unselected state — no region highlighted, no card list shown below it in this capture).
- **Testimonial band** — pink background, "Poděkování od rodin" heading, intro paragraph, one
  quote card (photo, quote text, attribution "Maminka Angeliny a Viktora" + caption), carousel
  prev (‹) / next (›) arrows. Confirmed; identical across all 4 captures (not tab-dependent).
- **Voucher band** — "Dobrošeky pro lepší dětství" heading + intro text + 6 denomination cards (100,
  250, 500, 1000, 5000, 10000 Kč, each titled "Pro lepší dětství" with a distinct illustration) +
  "Koupím dobrošek" button. Confirmed; identical across all 4 captures.
- **"Jak to funguje?" band** — heading + 3 columns ("Vše začíná příběhem", "Společně zvládneme víc!",
  "Jen na vás záleží…"), each with an icon and a short paragraph. Confirmed.
- **Patron explainer band** — red/pink card, "Kdo je to Patron příběhu?" heading, explainer paragraph,
  "Chci se stát Patronem" button, adjacent photo with caption "Iveta N., Patronka příběhu Nelinky,
  Zdeňka a Dominika". Confirmed.
- **Sponsor/partner logos** — "Podporují nás" (BrowserStack, unlabeled logo, CRIF) and "Spřátelené
  organizace" (Lidé odvedle, Nadace Sirius, Centrum komplexní péče pro děti, Šance Dětem). Confirmed.
- **Footer** — org description, social link, registration number, "Patron dětí" link column (O nás,
  Blog, Pravidla poskytování pomoci, Naše desatero, Splněné příběhy, Výroční zprávy, "Jak jsme
  pomáhali v době koronakrize"), "Kontakt" column (e-mail info@patrondeti.cz), payment badges
  (comgate, Mastercard, VISA), collection-account number "57574646/0600", copyright line, and a
  "Souhlas se zpracováním osobních údajů" / "Chci přihlásit příběh" link pair. Confirmed. Owned by IA
  as global chrome — not re-specified here beyond noting its presence (`IA-patronus.md` §2).
- **Cookie-consent banner** — bottom-left overlay, "Přijímám" / "Odmítnout" buttons + "Další
  informace" link, visible/undismissed in the default-tab capture (13_15_49); absent in the other
  three captures (dismissed by that point in the session, or scrolled past — Assumed, since it is a
  fixed overlay that would otherwise persist). Confirmed present at least once; persistence/dismissal
  behavior Assumed.

---

## Components Used

Recurring elements promoted to COMP by **AR:COMPSynthesizer** (see `COMP-inventory-map.md`); all
other entries remain flagged `inline` (no ≥2-screen reuse evidenced).

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | COMP0002 | context=public | see `COMP0002` Global Site Header |
| Hero | inline | headline banner + 3x circular preset CTA | preset CTAs are the recurring-donation entry point (`UC0007`-fed schedule via `EN0010`) |
| Stat strip | inline | numeral stat + 2x category pill CTA | category pills' filter effect not confirmed as wired to the grid below (Uncertain — no visible active-state change captured) |
| Filter tabs | inline | 4-tab segmented control | see Interactions #2–#5 |
| Catalogue grid | inline | 3x2 Campaign card grid | one card variant renders a "SBÍRKOVÝ ÚČET" collection-account state (`EN0004` group/parent Campaign — mechanism Partial, see UC0023 Traceability) |
| Story card | COMP0008 | lifecycle=active | repeated 6x per tab; countdown ribbon text varies ("ZBÝVÁ MĚSÍC" / "ZBÝVÁ DEN" / "ZBÝVÁ N DNÍ"); see `COMP0008` Story Card |
| Region map | inline | interactive CZ SVG choropleth + mobile `<select>` fallback (per `UC0023` step 8; `<select>` not visible in this desktop-width capture) | "Vyberte kraj na mapě"; zero-active-Campaign regions rendered disabled per `UC0023` AF2 — not visually distinguishable in the captured neutral/unselected state |
| Testimonial carousel | inline | quote card + prev/next arrows | not Campaign-scoped; tab-independent |
| Voucher denomination card | inline | 6x fixed-value card | leads to `UC0009` voucher-purchase entry (S005, uncaptured) via "Koupím dobrošek" |
| "Jak to funguje?" explainer | inline | 3-column icon+text | static content, no UC |
| Patron explainer band | inline | text + CTA + photo | "Chci se stát Patronem" — no realizing UC evidenced on this screen (leads into intake, `UC0001`, per IA) |
| Sponsor/partner logo strip | inline | logo grid | static content, no UC |
| Footer | COMP0003 | promo=none | see `COMP0003` Global Site Footer |
| Cookie-consent banner | COMP0004 | actions=dual-action | see `COMP0004` Cookie Consent Banner |

---

## Interactions

1. **Entry** — anonymous visit to `/` → state: `default`, filter tab = "Zbývající částka" (Confirmed
   default landing tab, `UC0023` Main Flow step 2). Realizes `UC0023`.
2. **Primary action — switch filter tab: "Samoživitelé"** — click tab → grid re-renders with a
   different Campaign set (confirmed by comparing card contents between 13_15_49 and 13_16_09: no
   overlapping stories); realizes `UC0023` Main Flow step 6 / AF1; next state: `default` (tab =
   Samoživitelé). Server-side filter wiring for this tab is Uncertain (`UC0023` AF1) — the visible
   behavior (card set changes) is Confirmed, the mechanism is not.
3. **Primary action — switch filter tab: "Filtrovat podle krajů"** — click tab → catalogue grid is
   replaced by the region-map sub-zone ("Vyberte kraj na mapě"); realizes `UC0023` Main Flow step 7;
   next state: `default` (tab = region, map unselected — this is the captured state, 13_16_21).
4. **Secondary action — pick a region on the map** — click a region on the SVG map (or the mobile
   `<select>`, uncaptured at this viewport) → re-runs the catalogue query scoped to that region and
   is expected to re-render a card grid below/in place of the map; realizes `UC0023` Main Flow steps
   9–10. **Not captured** — no screenshot shows a region selected or the resulting card list; Assumed
   behavior per UC0023 evidence, not screenshot-confirmed for this screen.
5. **Primary action — switch filter tab: "Brzy skončí"** — click tab → grid re-renders ordered by
   nearest deadline (confirmed: all 6 visible cards in 13_16_37 show short countdowns — "ZBÝVÁ DEN",
   "ZBÝVÁ 3 DNY" x3, "ZBÝVÁ 5 DNY" — consistent with an ascending-deadline sort); realizes `UC0023`
   Main Flow steps 11–12; next state: `default` (tab = Brzy skončí).
6. **Primary action — story card CTA ("Podpořím `<jméno>`")** — click → hands off to the donation flow
   for the chosen Campaign; realizes `UC0023` Main Flow step 13–14 (handoff boundary; donation itself
   is `UC0005`, out of this screen's scope); next screen: S002 (per `IA-screen-map.md` cross-module
   flow, donation flow step 1→2).
7. **Primary action — collection-account card CTA ("Nechám to na vás")** — click → same handoff
   pattern as #6, targeting the collection-account/group Campaign; next screen: S002 (mechanism
   Partial — see `UC0023` Traceability open item on the group-Campaign mapping).
8. **Secondary action — hero preset CTA ("Daruj 90 Kč měsíčně" / "290 Kč měsíčně" / "podle sebe")** —
   click → enters the recurring-donation setup flow with the preset (or custom) amount pre-filled;
   this is the UI entry point feeding a `RecurringTransaction` (`EN0010`) that `UC0007` later charges
   on schedule; the donation-schedule creation step itself is `UC0005` (Make a Donation), not directly
   evidenced as happening on S001 — **Uncertain** which screen/modal opens next (no screenshot
   captures the post-click state from this entry point).
9. **Secondary action — category pill CTA ("Zdravotní pomoc" / "Rozvoj a vzdělání")** — click →
   presumed filter/navigation to a category-scoped view; **Uncertain** — no before/after comparison
   captured, and no visible pressed/active state is observed on either pill in any capture; effect not
   confirmed.
10. **Secondary action — "Další příběhy" link** — click → presumed pagination/"load more" or a full
    catalogue listing page; **Uncertain** — not captured beyond the link's presence.
11. **Secondary action — "Koupím dobrošek"** — click → hands off to the voucher-purchase screen (S005,
    uncaptured); entry point toward `UC0009`'s redemption lifecycle (purchase itself precedes
    UC0009's validate/apply steps). Next screen: S005 (Uncertain certainty per `IA-screen-map.md`).
12. **Secondary action — testimonial carousel prev/next** — click ‹ / › → cycles the single visible
    quote card; **Uncertain** how many total testimonials exist (only one is shown in any capture).
13. **Secondary action — "Chci se stát Patronem"** — click → presumed entry into the Patron intake
    path; no realizing UC evidenced for this exact click target on S001 (`UC0001` governs Application
    submission generally, per IA); next screen Uncertain — not captured.
14. **Exit** — visitor navigates away via header nav ("Jak to funguje", "Blog", "O nás", "Požádat o
    pomoc", "Můj účet") or footer links — each an IA-owned navigation target, not restated here.
15. **Cookie-consent banner actions** — "Přijímám" / "Odmítnout" dismiss the banner; "Další informace"
    presumably opens a cookie-policy detail (link target not captured). Confirmed banner presence and
    button labels; dismissal behavior Assumed (standard consent-banner pattern, not itself observed
    across a before/after pair).

---

## States

### default
The catalogue grid (or region map, on that tab) loaded with content, as shown in all four
screenshots. Confirmed for all four filter tabs: "Zbývající částka" (13_15_49), "Samoživitelé"
(13_16_09), "Filtrovat podle krajů" — map neutral/unselected (13_16_21), "Brzy skončí" (13_16_37).

### empty
Shown when: a filter/region combination yields zero active Campaigns (`UC0023` AF4 — system returns
`total_count = 0`). **Evidence Pending — not captured.** No screenshot shows a zero-result state for
any tab or region. Visual treatment and recovery path (e.g. an empty-state message, a "clear filter"
action) are Uncertain — do not assume a specific treatment.

### loading
Shown when: a tab switch or region pick triggers the re-query (`UC0023` Main Flow steps 3–4, 10, 12).
**Evidence Pending — not captured.** No skeleton/spinner/disabled-interaction state is visible in any
capture (all four are settled, fully-rendered end-states). Uncertain whether a loading indicator
exists at all for this screen's AJAX-driven tab switches.

### error
Shown when: the catalogue query fails server-side, or the region-picker fragment
(`/campaign/regions/render`, per `UC0023` Main Flow step 8) fails to load. **Evidence Pending — not
captured.** No error state observed; Uncertain whether any user-facing error message exists for this
screen versus a silent failure (e.g. an empty grid indistinguishable from the `empty` state above).

---

## Validation Surfaces

No form-field data entry exists on this screen per current evidence — it is a browse/filter surface
(tabs, a region-picker map, and CTA buttons), not a data-entry step. `UC0023` is explicitly a
"pure read/browse capability: it does not mutate Campaign or Application state," so no `BRxxxx` gates
a form submission here.

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| — | — | N/A — no form fields evidenced on S001 |

**validationsWithoutBR:** none — there is nothing to validate on this screen per available evidence
(no BR exists or is needed for a pure browse/filter surface; not an open question).

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Catalogue grid (all tabs) | `EN0004` | — | Campaign card projection: photo, category, title, target vs. raised amount, remaining-amount visibility flag, deadline/time-left, CTA text — per `UC0023` Main Flow step 5. No QUERY-id exists in this reconstruction pass (no QUERY layer drafted yet); the underlying read contract is `CampaignsResource` per `UC0023` Traceability, not restated here. |
| Story card — Patron badge (icon on card, if present) | `EN0005` | — | Public Patron profile surfaced per-card; observed as a small badge icon on each card corner (Confirmed icon presence per screenshots; badge-to-Patron-profile linkage is Probable, inferred from `UC0023` Actors — not a distinct clickable element confirmed in evidence). |
| Region map — per-region active-Campaign counts | `EN0004` | — | Live counts drive zero-count disabling (`UC0023` Main Flow step 8, AF2); not independently rendered as visible numerals on the captured map (13_16_21 shows only the neutral grey map, no count labels visible at this zoom/detail level). |
| Stat strip numeral ("323 dětí čeká na pomoc") | `EN0004` | — | Aggregate count of Campaigns awaiting help; exact source query Uncertain — not confirmed whether this reflects the same filtered set as the active tab or a global unfiltered count (no cross-tab numeral change observed — the "323" figure is identical across all four captures, suggesting it is NOT tab-scoped — Probable). |
| Hero preset CTAs (90 / 290 / custom Kč) | `EN0010` | — | Feeds a `RecurringTransaction` schedule at creation; S001 itself only presents the preset amounts, it does not read or display existing schedule data. |
| Voucher denomination cards | `EN0013` | — | Fixed denominations (100/250/500/1000/5000/10000 Kč) offered for purchase; S001 does not read Voucher redemption state — this is the purchase-entry surface for the `EN0013` lifecycle that `UC0009` later validates/redeems. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Whole screen | none evidenced | Public/anonymous-reachable; no ACL layer exists in this reconstruction (`IA-patronus.md` §9). No role-gating observed — all four captures were taken as an anonymous visitor. |
| "Můj účet" header entry | none evidenced (routes to S009 login when unauthenticated, per IA) | Not a visibility condition on S001 itself — the label/icon is present regardless of auth state; only its destination differs (`IA-patronus.md` §2). Not re-specified here. |
| Cookie-consent banner | session/consent-cookie state (implementation detail, not ACL/BR) | When previously dismissed in-session, banner does not render (Assumed from its absence in 3 of 4 captures — not a role or BR-gated condition). |

No AF3-style authenticated-donor interaction-scoped filters (`UC0023` AF3:
`filter_user_interacted_campaigns` / `filter_user_recommended_campaigns`) are visible as tabs or
controls on S001 in any capture — consistent with `UC0023`'s own note that these are "not confirmed
as a public catalogue-tab UI surface."

---

## Accessibility Notes

Evidence Pending — not captured. Static screenshots do not confirm tab order, focus behavior,
landmark roles, or keyboard interaction for this screen.

- **Tab order:** Uncertain — not evidenced from static captures.
- **Focus on entry:** Uncertain.
- **Focus on state transition (filter-tab switch):** Uncertain — whether focus moves to the
  re-rendered grid/map region on tab switch (an accessibility best practice for AJAX content swaps)
  is not evidenced either way.
- **Landmarks:** Uncertain — the four segmented filter tabs visually resemble a tab-panel pattern
  (`role="tablist"`/`tab`/`tabpanel`), but no DOM/ARIA evidence exists in this screenshot-only pass to
  confirm they are implemented as such versus plain buttons or links.
- **Keyboard shortcuts:** none evidenced.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Header nav, hero, stat strip, filter tabs, catalogue grid, testimonial band, voucher band, "Jak to funguje?", Patron explainer band, sponsor logos, footer, cookie banner — presence and content | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `13_16_09.png`, `13_16_21.png`, `13_16_37.png`; `_ar/evidence/ui/ui-observed-areas.md` §1 |
| Default landing tab = "Zbývající částka" | Confirmed | 13_15_49.png; `UC0023` Main Flow step 2 |
| Tab switch changes the card set (Samoživitelé, Brzy skončí) | Confirmed (visible effect) / Uncertain (mechanism for Samoživitelé) | 13_15_49.png vs 13_16_09.png vs 13_16_37.png; `UC0023` AF1 |
| Region-map tab replaces grid with "Vyberte kraj na mapě" map, neutral/unselected state | Confirmed | 13_16_21.png |
| Region selection result (post-click card list) | Evidence Pending — not captured | no screenshot shows a selected region |
| Collection-account / "SBÍRKOVÝ ÚČET" card mechanism (type/parent mapping) | Partial | `UC0023` Traceability open item; `_ar/spec-draft/EN/EN0004_Campaign.md` |
| Hero preset CTA → recurring-donation entry point | Probable | `_ar/spec-draft/EN/EN0010_RecurringTransaction.md`; `UC0007` Preconditions (schedule originates from a donation, not from this cron UC itself); no post-click screenshot |
| "Koupím dobrošek" → voucher purchase entry point | Probable | `_ar/spec-draft/EN/EN0013_Voucher.md`; `UC0009` Preconditions; target screen S005 uncaptured per `IA-screen-map.md` |
| empty / loading / error states | Evidence Pending — not captured | no screenshot shows these states for S001 |
| Accessibility (tab order, focus, landmarks) | Uncertain | not evidenced from static screenshots |
| Category pill CTA effect, "Další příběhy" link target, testimonial count, "Chci se stát Patronem" destination | Uncertain | presence confirmed in screenshots; behavior/destination not captured |
