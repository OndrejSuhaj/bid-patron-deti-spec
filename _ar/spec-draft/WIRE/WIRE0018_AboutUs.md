---
doc_id: WIRE0018
title: About Us
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S015
realizes_uc: [UC0027]
status: draft
references:
  - UC0027
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0020
---

# WIRE0018 – About Us

## Purpose

A public, anonymous-visitor institutional/content page at `/o-nas` ("O nás"), reached from the global
nav item "O nás" (`_ar/spec-draft/IA/IA-patronus.md` line 213, screen `S015`). It presents the
organisation's mission statement, an introductory video, a short "coordinator" contact prompt, the
project-team roster (photos, names, roles, contact details), the ethical code ("Náš etický kodex" /
"Desatero") with a downloadable PDF, the correspondence/billing address, and two document archives —
annual reports ("Výroční zprávy") and public-collection control protocols ("Protokoly o kontrole
veřejné sbírky"), both spanning 2018–2024. It is a **read-only, static/editorial** screen: no forms,
no data tables, no interactive controls beyond navigation and file downloads.

`realizes_uc: [UC0027]` is carried **per this task's assignment**; note that **no `UC0027` exists in
the current UC registry** (`_ar/spec-draft/UC/_REGISTRY.md` lists `UC0001`–`UC0025`; no `UC0026` or
`UC0027` doc was found under `_ar/spec-draft/UC/`). The IA layer independently marks this same screen
`S015` as **"(no UC)"** / "static/institutional; no UC" (`IA-patronus.md` lines 85, 126, 213). This is
recorded as a **dangling reference / Open Question**, not silently resolved — see Open Questions and
Evidence below. Per project policy this page and its sibling `/blog` are **current-state only**; the
rebuild epic **E0004** (not yet built) governs any future target design and is out of scope here.

Actor: anonymous visitor (no authentication observed or implied).

---

## Layout Zones

```
+--------------------------------------------------------+
| Global nav — logo | Jak to funguje | Blog | O nás |     |
|                    Požádat o pomoc (CTA) | Můj účet     |
+--------------------------------------------------------+
| Hero band — "O nás" heading + mission paragraph          |
| (pink background band)                                   |
+--------------------------------------------------------+
| Mission / intro zone                                     |
|   body text with inline link "příběhům dětí"             |
|   embedded YouTube video ("Všechny děti si zaslouží...")  |
|   closing line "Společně dokážeme víc!"                   |
+--------------------------------------------------------+
| Coordinator prompt strip                                  |
|   avatar photo + "Dobrý den, jsem koordinátorka Jana."    |
|   + contact line with mailto: link                        |
+--------------------------------------------------------+
| Team grid — "Lidé v projektu"                             |
|   2 featured cards (ředitelky, pink background, photo +   |
|     name + role + quote)                                  |
|   12 roster tiles in 2 columns (photo, name, role, email, |
|     phone where present)                                  |
+--------------------------------------------------------+
| Ethical-code banner — "Náš etický kodex" / Desatero        |
|   (pink panel: heading + body text + "Stáhnout Desatero"  |
|    button) beside a photo                                 |
+--------------------------------------------------------+
| Correspondence/billing address block                      |
|   "Patron dětí, z.ú." + address + IČO + registration notes|
+--------------------------------------------------------+
| Document archive — "Výroční zprávy"                        |
|   8 year tiles (2018–2024) in 2 columns, each:            |
|   year badge (circle) + "Výroční zpráva za rok NNNN" +     |
|   "Stáhnout" link with download icon                       |
+--------------------------------------------------------+
| Document archive — "Protokoly o kontrole veřejné sbírky"   |
|   8 year tiles (2018–2024) in 2 columns, same tile pattern|
+--------------------------------------------------------+
| Footer — cookie notice, company info, nav link clusters,  |
|          social link, payment-provider logos,             |
|          collection account number                        |
+--------------------------------------------------------+
```

- **Global nav** — logo (→ S001), "Jak to funguje" (→ S016), "Blog" (→ S013), "O nás" (current page),
  "Požádat o pomoc" CTA (→ S006), "Můj účet" (→ auth zone). — Confirmed.
- **Hero band** — pink background, "O nás" heading, one-paragraph mission statement ("Patron dětí je
  charitativní projekt, jehož smyslem je pomáhat zdravotně a sociálně znevýhodněným dětem a jejich
  rodinám z celé České republiky."). — Confirmed.
- **Mission / intro zone** — body copy referencing "příběhům dětí" (inline link), an embedded video
  player (thumbnail "Všechny děti si zaslouží šťastný a plný..." with a YouTube play affordance), and
  a closing call-to-unity line "Společně dokážeme víc!". — Confirmed.
- **Coordinator prompt strip** — small avatar photo with a speech-bubble-style text: "Dobrý den, jsem
  koordinátorka Jana. Pokud máte nějaký dotaz, kontaktujte mě na chatu nebo mi napište na
  info@patrondeti.cz" (mailto link). — Confirmed.
- **Team grid ("Lidé v projektu")** — heading, then two visually distinct pink "featured" cards
  (výkonná ředitelka Edita Mrkousová; provozní ředitelka Svatava Poulson — each with photo, name,
  role, e-mail, and a short pull-quote), followed by 12 plain roster tiles in a 2-column layout, each
  with circular photo, name, role label (e.g. "péče o dobrovolníky, fakturace"; "zástupkyně žadatelů";
  "finance a HR"; "koordinace žádostí"; "risk management"; "koordinace mezi projekty") and contact
  (e-mail always; phone number present on some tiles, absent on others). — Confirmed.
- **Ethical-code banner** — pink panel with heading "Náš etický kodex", body text ("Naše činnost se
  opírá o pevné zásady a principy, jejichž dodržování je pro nás samozřejmostí. Abyste věděli, že nám
  můžete důvěřovat, stáhněte si jedno z deseti Desatera."), a "Stáhnout Desatero" download button, and
  an adjacent photograph (hands close-up). — Confirmed.
- **Correspondence/billing address block** — centered text: entity name "Patron dětí, z.ú.", postal
  address "U Prašné brány 1079/3, 110 00 Praha 1, Staré Město", "IČO: 06826911, neplátci DPH", plus
  smaller registration notes ("Zaregistrována u krajského soudu Sp. zn. U-NKAM/036002/2017", "Číslo
  účtu veřejné sbírky 5757604/0600"). — Confirmed.
- **Document archive — "Výroční zprávy"** — section heading, 8 year tiles (2018, 2019, 2020, 2021,
  2022, 2023, 2024) arranged 2-per-row, each a card with a circular year badge, label "Výroční zpráva
  za rok NNNN", and a "Stáhnout" text link with a download icon. — Confirmed.
- **Document archive — "Protokoly o kontrole veřejné sbírky"** — same tile pattern, same 2018–2024
  year range, label "Protokol o kontrole za rok NNNN". — Confirmed.
- **Footer** — cookie consent bar, company block ("patron dětí" + short description + parent-org note
  + registered-collection notice), three nav link clusters ("Patron dětí", "Kontakt", social —
  "Sledujte nás na Facebooku"), payment logos (Comgate/Mastercard/Visa), collection account number. —
  Confirmed. (Footer is a shared/global region — its internal link targets are owned by IA, not
  restated here.)

---

## Components Used

Per the task assignment, only the four named components are attributed here; all other zones on this
screen remain `inline` (no ≥2-screen reuse evidenced for the team/document tiles as a distinct
reusable pattern in the current `COMP-inventory-map.md`).

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Global nav | COMP0002 | context=public | shared header, same as observed on S001/S013/S016; see `COMP0002` Global Site Header |
| "Stáhnout Desatero" download button | COMP0001 | variant=secondary/outline (pink-on-white, icon+label) | Button component; label "Stáhnout Desatero" + download icon — Confirmed as the same button family used elsewhere (S001/S002 CTAs), distinct visual variant not otherwise cross-checked pixel-for-pixel |
| Download icon (Desatero button + all year-tile "Stáhnout" links) | COMP0020 | icon=download | recurring small glyph preceding every download affordance on this screen — Confirmed presence, `COMP0020` Icon component |
| Mission / intro zone | inline | heading + body copy + embedded video thumbnail | video embed itself is third-party (YouTube) — not a COMP; no dedicated video-embed COMP identified |
| Coordinator prompt strip | inline | avatar + text + mailto link | — |
| Team grid — featured card (×2) | inline | photo + name + role + e-mail + quote, pink background | not evidenced as reused elsewhere (≥2-screen reuse threshold not met) |
| Team grid — roster tile (×12) | inline | circular photo + name + role + e-mail (+ optional phone) | repeated pattern within this screen only; not promoted to COMP absent cross-screen evidence |
| Ethical-code banner | inline | pink panel (heading + body + button) + photo, two-column | contains COMP0001 button, see row above |
| Correspondence/billing address block | inline | plain centered text block | — |
| Document year tile (×16 total, both archives) | inline | year badge (circle) + label + "Stáhnout" link with COMP0020 icon | year badges and tile shells are a repeated in-page pattern; not promoted to COMP absent ≥2-screen reuse evidence — download links themselves are inline text links, not COMP0001 buttons (visually a plain link, not a button) |
| Footer | COMP0003 | — | same as observed on other Public-site screens; see `COMP0003` Global Site Footer |

---

## Interactions

1. **Entry** — direct navigation to `/o-nas` via global nav "O nás" link → state: `default`. —
   Confirmed (route + entry point; `IA-patronus.md` line 213).
2. **Primary action — "Stáhnout Desatero"** — click → downloads/opens the ethical-code PDF document;
   does not realize a UC state change on this screen (static file retrieval, no application logic
   observed). — Confirmed affordance; download target/behavior (new tab vs. direct download) not
   observed in the screenshot. — `Probable`.
3. **Secondary action — "Stáhnout" (per year tile, both archives)** — click a year tile's download
   link → downloads/opens that year's annual-report or control-protocol PDF; same pattern as above,
   ×16 instances (8 annual reports + 8 control protocols). — Confirmed affordance; exact file targets
   not captured. — `Probable`.
3a. **Secondary action — coordinator mailto link** — click `info@patrondeti.cz` → opens the visitor's
   mail client pre-addressed; no in-page contact form observed. — Confirmed.
3b. **Secondary action — mission-zone inline link ("příběhům dětí")** — click → expected to navigate
   to the story catalogue (S001) or a related content screen; exact target not captured on this
   screenshot. — `Uncertain`.
3c. **Secondary action — embedded video** — click video thumbnail → plays the YouTube-hosted video
   (in-page player or external YouTube tab); exact embed behavior not confirmed from the static
   capture. — `Probable`.
3d. **Secondary action — "Sledujte nás na Facebooku" (footer)** — click → external navigation to the
   organisation's Facebook page; shared footer behavior, not specific to this screen. — Confirmed
   (footer pattern), out of scope for WIRE detail (owned by IA/COMP0003).
4. **Exit** — via global nav (to S001/S013/S016/S006) or footer links; no explicit "cancel"/"submit"
   exit exists since this is a read-only content screen. — Confirmed.

---

## States

### default
The fully rendered page as captured: hero mission statement, intro copy + video, coordinator prompt,
two featured team cards + 12 roster tiles, ethical-code banner with download button, correspondence
address block, and two 8-tile document archives (annual reports; control protocols), each spanning
2018–2024. — Confirmed
(`_ar/prtsc/screencapture-patrondeti-cz-o-nas-2026-07-04-13_17_32.png`).

### empty
`N/A — mostly-static institutional page; no list/collection zone on this screen is driven by a
variable dataset that could plausibly be empty in current-state operation (team roster, ethical-code
banner, and both document-year archives are fixed editorial content as observed, not a queried
collection with a zero-result case).` This is an inference from the page's static/editorial nature,
not a confirmed absence-of-empty-state test — `Assumed`.

### loading
`N/A — no async data-fetch behavior was observed or is implied; the page reads as server-rendered
static/editorial content (single full-page screenshot, no skeleton/spinner observed).` — `Assumed`.

### error
`N/A — no error/failure treatment observed. A broken download link (missing/expired PDF) is a
plausible real-world failure mode for the document archives, but no evidence (screenshot or otherwise)
shows what happens on a failed download — not evidenced either way.` — `Uncertain — not captured`.

---

## Validation Surfaces

This is a read-only content screen with no form fields or user-submitted input observed — no
validation surfaces apply.

`N/A — no input controls observed on this screen (Controls / Form fields: none, per
_ar/evidence/ui/ui-observed-areas.md §16).`

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Team grid (featured cards + roster tiles) | — | — | No `EN` doc models "project team member" as a domain entity in the current registry (`_ar/spec-draft/EN/_REGISTRY.md`); treated as static editorial content (names/roles/photos authored directly on the page), not a bound query result — `Uncertain`, not asserted as a confirmed entity binding. |
| Ethical-code banner (Desatero PDF) | — | — | No `EN`/glossary entry for "Desatero" / ethical code as a domain concept; static document link — `Uncertain`. |
| Document archive — Výroční zprávy (×8) | — | — | No `EN` doc models "annual report" as an entity; static document links, one per year 2018–2024 — `Uncertain`. |
| Document archive — Protokoly o kontrole veřejné sbírky (×8) | — | — | No `EN` doc models "public-collection control protocol" as an entity; static document links — `Uncertain`. |
| Correspondence/billing address block | — | — | Static organisational data (legal name, IČO, registration numbers); no corresponding `EN` party/organisation entity doc was found governing this screen's rendering — `Uncertain`. |

No `EN` or `QUERY` doc_id could be confirmed for any zone on this screen; all content here reads as
static/editorial rather than entity-bound, consistent with IA's "static/institutional; no UC"
classification of `S015` (`IA-patronus.md` lines 85, 126). This is recorded as an open gap, not
resolved by invention.

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | none observed | anonymous/public — no role gate observed; ACL layer does not yet exist for this reconstruction pass |
| "Můj účet" nav link | Assumed authenticated-state variant (not evidenced on this capture) | see IA / other screens for the logged-in nav variant; out of scope here |

No `BR` or `ACL` doc was found governing visibility on this screen; it is treated as unconditionally
public content, consistent with other public-site screens (e.g. `WIRE0019`).

---

## Accessibility Notes

Not observed in the static screenshot evidence — no DOM/ARIA inspection was performed as part of this
reconstruction pass. The following are `Uncertain`/`Evidence Pending`:

- **Tab order:** Assumed to follow visual/DOM order (nav → hero → mission/video → coordinator prompt
  → team grid → ethical-code banner → address block → annual-reports archive → control-protocols
  archive → footer) — not verified.
- **Focus on entry:** Not observed.
- **Focus on state transition:** Not observed (no state transition captured — see States; page is
  effectively single-state).
- **Landmarks:** Not observed; presence of semantic `<nav>`/`<main>`/`<footer>` landmarks is
  unconfirmed from a screenshot alone.
- **Download links (Desatero + 16 year-tile "Stáhnout" links):** File type/size is not announced in
  visible copy (no "(PDF, x MB)" suffix observed); whether each download link exposes an accessible
  name distinguishing it from its neighbors (e.g. "Stáhnout Výroční zprávu za rok 2020" vs. a bare
  "Stáhnout" repeated 16 times with only surrounding visual context to disambiguate) is **Uncertain**
  — a screen-reader user relying on a links-list view could encounter 16+ identically-labelled
  "Stáhnout" links with no differentiation unless the accessible name includes the year/document type.
  This is flagged as a likely accessibility gap in the current implementation but is **not confirmed**
  from the screenshot (DOM/ARIA not inspected).
- **Embedded video:** Captioning/transcript availability for the YouTube-embedded video is not
  observed.
- **Keyboard shortcuts:** None observed; none expected for a content browse screen.

---

## Open Questions

- **`realizes_uc: [UC0027]` is a dangling reference.** No `UC0027` document exists in
  `_ar/spec-draft/UC/_REGISTRY.md` (registry currently ends at `UC0025`; no `UC0026` was found
  either). The IA layer independently classifies this same screen (`S015`) as **"(no UC)" /
  "static/institutional; no UC"** (`IA-patronus.md` lines 85, 126, 213). Per `rules-WIRE.md`,
  "Dangling COMP/UC/BR references block completion" — this is recorded here rather than silently
  resolved or invented; downstream `RefIntegrityValidator` should reconcile whether `UC0027` is a
  not-yet-authored UC (e.g. a future "Publish/Maintain Static Institutional Content" use case) or
  whether this screen should in fact carry no `realizes_uc` value, contradicting the frontmatter
  contract's "mandatory" rule for content-only screens.
- Are the 12+2 team roster entries, the ethical-code document, and the 16 archived reports/protocols
  maintained via any CMS/admin capability in current-state Patronus, or are they hand-coded into the
  theme/template? No `EN`/`UC` evidence was found either way (see Data Bindings) — this determines
  whether a "maintain static content" UC (candidate for the dangling `UC0027`) plausibly exists.
- Exact download targets (file URLs, file types/sizes) for the Desatero PDF and all 16 archive links
  were not captured in the screenshot evidence.
- Whether a broken/expired document link has any defined error treatment is unevidenced.
- Accessible-name disambiguation for the repeated "Stáhnout" links (see Accessibility Notes) is
  unresolved.
- This screen and its sibling `/blog` are explicitly **not yet part of the redesign canon** — future
  target design is tracked under rebuild epic **E0004** (unbuilt) and is intentionally out of scope
  for this current-state WIRE document.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Overall layout, zones (mission, video, coordinator prompt, team grid, ethical-code banner, address block, two document archives, footer) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-o-nas-2026-07-04-13_17_32.png`; `_ar/evidence/ui/ui-observed-areas.md` §16 |
| Route, nav entry point | Confirmed | `_ar/spec-draft/IA/IA-patronus.md` lines 85, 126, 213 |
| Verbatim copy (mission statement, address block, section headings) | Confirmed | `ui-observed-areas.md` §16 representative verbatim |
| Components COMP0001 (button), COMP0002 (header), COMP0003 (footer), COMP0020 (icon) | Confirmed (presence on this screen) | `_ar/spec-draft/COMP/COMP0001_PrimaryButton.md`, `COMP0002_GlobalHeader.md`, `COMP0003_GlobalFooter.md`, `COMP0020_Icon.md`; screenshot cross-check |
| Realizing UC = UC0027 | **Uncertain / dangling reference** | task assignment vs. `_ar/spec-draft/UC/_REGISTRY.md` (no UC0027 present); IA classifies S015 "no UC" (`IA-patronus.md` lines 85, 126) |
| Data Bindings (team/Desatero/document archives → EN) | Uncertain — no EN match | `_ar/spec-draft/EN/_REGISTRY.md` (no matching entity found); glossary (`_ar/repo-map/glossary-master.csv`) has no "Desatero"/"výroční zpráva"/"kontrolní protokol" domain term |
| empty / loading / error states | Assumed / Uncertain — not captured | single full-page static screenshot only; no additional evidence found for this screen |
| Accessibility | Evidence Pending | screenshot-only evidence; no DOM/ARIA capture available |
| Current-state-only scope (no E0004 target detail) | Confirmed (task constraint) | task instructions: "blog + o-nás are NOT in the redesign canon yet (rebuild epic E0004, unbuilt)" |
