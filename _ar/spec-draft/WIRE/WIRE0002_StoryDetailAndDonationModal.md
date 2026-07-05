---
doc_id: WIRE0002
title: Story Detail And Donation Modal
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S002
realizes_uc: [UC0005, UC0011, UC0009]
status: draft
references:
  - UC0005
  - UC0011
  - UC0009
  - EN0004
  - EN0005
  - EN0006
  - EN0009
  - EN0010
  - EN0013
  - BR-PaymentAndMoneyIntegrity
  - BR-VoucherPolicy
  - BR-CampaignStoryLifecycle
  - BR-RecurringDonationPolicy
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0006
  - COMP0008
  - COMP0010
  - COMP0011
  - COMP0012
  - COMP0013
  - COMP0014
  - COMP0015
  - COMP0016
  - COMP0017
  - COMP0018
  - DESIGN-tokens
  - DESIGN-component-index
---

# WIRE0002 – Story Detail And Donation Modal

## Purpose

The public Story (Příběh) detail page for a single Campaign (`EN0004`), read by an anonymous
visitor or an already-authenticated donor. It presents the fundraising case (child, category,
Patron comment, target/remaining amount) and is the entry surface for three donation-adjacent
intents realized elsewhere in the domain layer: making a one-off or recurring donation
(`UC0005`), reading the Campaign's public lifecycle state as rendered progress
(`UC0011` — this screen only *displays* the derived raised/percent values that `UC0011`/
`BR-CampaignStoryLifecycle` compute; it does not perform any lifecycle transition), and
starting a voucher redemption ("Mám dobrošek", `UC0009`). The donation modal ("Chystáte se
přispět") is a secondary layer opened over this screen, collecting amount, contact, and
consent before handing off to the payment gateway (`S-EXT1`, out of WIRE scope).

Actor: anonymous visitor (Customer, per `UC0005`) or authenticated donor. No role gate is
observed on the base page.

Entry context: navigated from the Homepage catalogue (`S001`) or a direct/shared Story link
(`/pribeh/<slug>`); IA `Cross-Module Flows`, step 1–2.

Certainty: Confirmed — screen content and modal both directly captured (see Evidence).

---

## Layout Zones

- **Header** — global site nav (`patron dětí` logo, "Jak to funguje", "Blog", "O nás",
  "Požádat o pomoc" CTA, "Můj účet") — IA-owned, not reconstructed here.
- **Title band** — Story name ("Balík školních potřeb pro Sofinku").
- **Media zone** — Story hero photo (child).
- **Patron comment card** — "PATRON PŘÍBĚHU" label, Patron name/role (`EN0005`), avatar, "Zobrafit
  komentář Patrona" toggle/link, comment body text.
- **Story body** — long-form narrative text (heading + paragraphs + a bulleted trust list: "100 %
  daru jde na pomoc dětem", "peníze neposíláme rodinám...", "všechny žádosti pečlivě posuzuje naše
  oddělení risku", "každou žádost potvrzuje Patron").
- **Donation sidebar (sticky-right)** — repeated twice in the captured page (once beside the hero,
  once lower beside the body — see Open Question below):
  - category tag ("Rozvoj a vzdělání") with icon
  - "Přispět můžete na" + in-kind description ("balík školních potřeb; dodává SEVT")
  - illustrative icon (backpack)
  - progress block: "Chybí 1 600 Kč" + progress bar + "Zbývá měsíc" / "Cílová částka 1 600 Kč"
  - one-off amount input ("Chci darovat", Kč, prefilled `50`) + "Přispět 🤝" CTA (× 2 stacked
    instances observed — Open Question)
  - "Na pomoc dětem putuje vždy 100 % z darované částky" microcopy under each CTA
  - recurring block: "Přeji si podporovat rozvoj a vzdělání pravidelně" + "Chci podporovat rozvoj
    a vzdělání" CTA (green)
  - voucher block: "Mám dobrošek" CTA (red, ticket icon) + "Chcete věnovat dobrošek?" link
  - share row: Facebook / X / Instagram / LinkedIn / WhatsApp / Messenger icons
- **Trust banner (full-width)** — red band, "Na pomoc dětem putuje vždy 100 % částky, kterou
  darujete."
- **Related stories rail** — "Aktuálně čekají na vaši pomoc" + 3 cards (photo, countdown badge
  "ZBÝVÁ MĚSÍC"/"ZBÝVÁ 16 DNÍ", "Chybí N Kč" ribbon, name+wish, "Cílová částka N Kč", "Podpořím
  <jméno>" CTA) + "Další příběhy" link.
- **Donation modal (overlay, on Primary action)** — "Zpět na příběh" back-link, "Chystáte se
  přispět" title + amount field (Kč), contact fields (E-mail, +420 phone, Jméno, Příjmení), two
  consent checkboxes, "Přejít k platbě" CTA, "Po přesměrování na platební bránu..." helper text.
- **Footer** — global site footer — IA-owned, not reconstructed here.

```
+--------------------------------------------------------------+
| Header (IA)                                                    |
+--------------------------------------------------------------+
| Story title                                                    |
+---------------------------------+----------------------------+
| Media (hero photo)              | category tag                |
| Patron comment card             | "Přispět můžete na" + icon  |
|                                  | progress + "Chci darovat"   |
|                                  | + "Přispět" CTA              |
|                                  | recurring CTA                |
|                                  | "Mám dobrošek" CTA           |
|                                  | share row                    |
+---------------------------------+----------------------------+
| Story body text                 | (sidebar repeats — Open Q)  |
+---------------------------------+----------------------------+
| Trust banner (full-width)                                      |
+--------------------------------------------------------------+
| Related stories rail (3 cards)                                  |
+--------------------------------------------------------------+
| Footer (IA)                                                     |
+--------------------------------------------------------------+

Donation modal (overlay):
+----------------------------------------+
| < Zpět na příběh   Chystáte se přispět  [50 Kč] |
+----------------------------------------+
| E-mail (povinný)                        |
| +420 | Telefon                          |
| Jméno            | Příjmení              |
| [ ] Souhlasím s pravidly...              |
| [ ] Souhlasím se zpracováním...          |
|          [ Přejít k platbě ]             |
| helper: gateway method note              |
+----------------------------------------+
```

---

## Components Used

Recurring elements promoted to COMP by **AR:COMPSynthesizer** (see `COMP-inventory-map.md`); all
other entries remain flagged `inline` (no ≥2-screen reuse evidenced, or reuse Uncertain — see notes).

> **Note on COMP0010–COMP0018 references below.** These are the **canonical `@patron/ui` /
> TARGET** doc_ids assigned by `DESIGN-component-index.md` (S002 is the one screen with a canonical
> redesign — see `_ar/evidence/design-system/design-canon.md` §4/§7). Citing them here records
> *which canonical component the observed current-state zone corresponds to for traceability*; it
> does **not** mean the current-state zone actually implements that component's target contract
> (props/variants/states/tokens). Each cited COMP's own "Current-state (observed)" section carries
> the actual current-vs-target divergence — see also the new "Design-system alignment" section below
> for the S002-level composition/divergence summary.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | COMP0002 | context=public | see `COMP0002` Global Site Header (current-state reuse); also target `SiteHeader` per `DESIGN-component-index.md` row 14 |
| Title band | inline | h1 | Story name; target canon composes this as a lightened header — breadcrumb + full-width H1, no pills (see divergence table below) |
| Media zone | COMP0011 | photo (no gallery/carousel observed) | current-state hero photo; target canon = `StoryHero` (`DESIGN-component-index.md` row 9) — photo + corner `CategoryChip`, monogram-on-wash fallback when no photo (not observed current-state) |
| Patron comment card | COMP0012 | avatar + name + role + toggle + body | binds `EN0005`; target canon = `PatronCard` (row 10) — standalone testimonial pillar, comment **always visible** (no toggle) — see divergence table (current-state has a "Zobrazit komentář Patrona" toggle, target does not) |
| Story body | inline | rich text block | long-form narrative + bullet list; target canon renders this as `prose` (WYSIWYG) below `PatronCard`, no dedicated COMP assigned |
| Category tag ("Rozvoj a vzdělání") | COMP0018 | icon + label | current-state violet pill in breadcrumb; target canon = `CategoryChip` (row 5) — one unified chip (icon+color), same area = same color across chip/card-wash/monogram (see divergence table — current-state uses two different badge treatments) |
| Progress block | COMP0016 | label + progress bar + two-line stat (Zbývá / Cílová částka) | binds derived `EN0004` fields (see Data Bindings); Uncertain whether this shares a component with `COMP0008` Story Card's internal progress figures — not confirmed identical, left inline for that cross-reference; target canon `ProgressBar` (row 6) is composed inside `DonationBox` |
| Time-remaining text ("Zbývá měsíc") | COMP0017 | calm/urgent | current-state renders this as plain text near the progress stat, not a pill; target canon = `TimeLeftPill` (row 6) — a pill *inside* the box, urgent = full alert-badge with pulse (see divergence table) |
| Amount input | COMP0010 | numeric field, Kč suffix, prefilled `50` | two instances stacked in evidence (Open Question); target canon = `DonationBox` (row 13, doc `COMP0010_DonationBox.md`) — fixed clean presets (500/1000/2000 Kč) + "Jiná" custom toggle, not a single prefilled input (see divergence table) |
| Primary donate CTA ("Přispět 🤝") | COMP0001 | icon=🤝 | see `COMP0001` Primary Button (current-state reuse); in target canon this CTA is `DonationBox`'s composed `Button` (primary/block, icon `give`) calling `onDonate(amount)` — contract stops there, the modal is a separate future block (see divergence table) |
| Recurring CTA ("Chci podporovat... pravidelně") | COMP0014 | secondary/green button | intent flag into `UC0005` (recurring branch); no separate recurring screen observed here; visual identity Uncertain vs. `COMP0001` (current-state); target canon = `RailCta` (row 11, default variant) — a lighter rail card below `DonationBox`, not a button beside it (see divergence table) |
| Voucher CTA ("Mám dobrošek") | COMP0014 | secondary/red button, ticket icon | entry point into `UC0009` — target screen not captured (IA `S005`, Uncertain); target canon = `RailCta` (row 11, **promo** variant, CZ-only, whole card is a link to `/dobroseky`) — "Mám dobrošek" redeem itself stays inside `DonationBox` in the canon (see divergence table) |
| Share row | COMP0015 | icon button row | Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger — no share behavior observed beyond icon presence; target canon = `ShareRow` (row 12) — compact monochrome icon row, 7 platforms (adds Email to the current-state 6), adopts tenant color on hover |
| Trust banner | COMP0013 | full-width text band | static copy, not entity-bound; target canon = `PledgeStrip` (row 16, `COMP0013_PledgeStrip.md`) — promoted to a bold full-width divider before "Další děti" carrying pledge + vendor (nominative-case, machine-fillable), present in **every** `DonationBox` state (see divergence table) |
| Related story card | COMP0008 | photo + countdown badge + progress ribbon + name + target amount + CTA | repeats catalogue card pattern from `S001`; visually close to `COMP0008` Story Card but rendered in a "related" sidebar layout, not confirmed identical (current-state note retained); target canon composes exactly `StoryCard` (row 8) ×3 under "Další děti čekají na pomoc", with a monogram-on-calm-surface placeholder (not a mesh) when no photo |
| Donation modal shell | inline | overlay/dialog, header + close/back | opened by primary CTA; target canon explicitly scopes the donation modal **out** of the `StoryDetail` page/`DonationBox` contract ("Mimo scope" — a future block); see divergence table |
| Modal amount field | inline | numeric field, Kč suffix, prefilled `50`, editable in modal header | binds donation amount; no canonical counterpart yet (modal is out-of-scope for canon, see above) |
| Modal contact fields | inline | E-mail (required), phone (+420 prefix), Jméno, Příjmení | binds `EN0006`/`EN0008` (see Data Bindings); no canonical counterpart yet |
| Modal consent checkboxes (×2) | COMP0006 | count-per-form=double | gate `UC0005` submission (Open Question — no BR found, see Validation Surfaces); see `COMP0006` Consent Checkbox; `DESIGN-component-index.md` §3 names this component as having **no canonical counterpart yet** — its intended future home is the deferred donation-modal block |
| Modal primary CTA ("Přejít k platbě") | COMP0001 | — | submits `UC0005`, hands off to `S-EXT1`; see `COMP0001` Primary Button |
| Modal helper text | inline | static microcopy | describes downstream gateway choice; not app-editable content, COPY-owned |

---

## Design-system alignment (target — S002 canon)

> **Discipline note.** S002 (this screen) is the **one** reconstructed screen with a canonical
> redesign — per `_ar/evidence/design-system/design-canon.md` §4/§7, the rebuild's E0001 epic
> (`Done`) promoted exactly one page composition, "Detail příběhu" (`packages/ui/src/pages/
> StoryDetail/`), to canon. Everything in this section is **TARGET state** (`@patron/ui` +
> `@patron/tokens`), sourced from `DESIGN-component-index.md` and `design-canon.md` §4. It does
> **not** describe, correct, or replace the current-state reconstruction above (Layout Zones /
> Interactions / States / Data Bindings), which remains the faithful record of the live
> `patrondeti.cz` page. Where the two disagree, both are recorded — see §2 divergence table — per
> the project constitution's current-vs-target rule.

### 1. Canonical composition

Source: `DESIGN-component-index.md` row "StoryDetail (Page)"; `design-canon.md` §4.2.

```
SiteHeader (COMP0002)                          — brandmark, nav, login, "Požádat o pomoc"
← breadcrumb ("Všechny příběhy")
H1 — story title (full width, display type)
┌───────────────────────────────────┬───────────────────────┐
│ StoryHero (COMP0011)              │ DonationBox (COMP0010) │  right rail, sticky
│  photo + corner CategoryChip (COMP0018) │ RailCta (COMP0014, recurring)
│ lede (plain paragraph)            │ RailCta (COMP0014, promo — dobrošek, CZ-only)
│ PatronCard (COMP0012)             │ ShareRow (COMP0015)
│  testimonial + seal, comment always visible │
│ prose (WYSIWYG)                   │
└───────────────────────────────────┴───────────────────────┘
PledgeStrip (COMP0013)                         — 100% pledge + vendor, full-width divider
"Další děti čekají na pomoc" — 3× StoryCard (COMP0008)
SiteFooter (COMP0003)
[mobile sticky CTA bar — missing amount + "Přispět"]   (≤900px; hidden when funded)
```

Layout grid `minmax(0, 1.55fr) minmax(300px, 0.95fr)`; container = `var(--layout-container)`
(1200px). Screen states mirror `DonationBox` (`COMP0010`): **probíhá/live** (default),
**naléhavé/urgent** (`TimeLeftPill`/`COMP0017` → full alert-badge, gentle pulse), **vybráno/funded**
(form replaced by thank-you; mobile CTA bar hidden). `PledgeStrip` (`COMP0013`) is present in
**every** state — the guarantee never disappears (acceptance criterion, `design-canon.md` §4.4).

### 2. Current → target divergence (S002)

| Aspect | Current-state S002 (observed, this doc) | Target canon (`DESIGN-component-index.md` / `design-canon.md` §4.5) | Status |
|---|---|---|---|
| Donation entry | Inline donation modal (amount + contact + consents) opened by "Přispět 🤝", per Interactions #2–#3 | `DonationBox` (`COMP0010`) contract stops at `onDonate(amount)`; the modal is named a **separate future block**, explicitly "Mimo scope" for the canon page | Both defer the modal, for different reasons — current-state modal is already live and captured; target modal is not yet built |
| Donation amount entry | Single numeric input ("Chci darovat"), prefilled `50` Kč, no visible presets; two stacked instances (WIRE0002-Q1) | Fixed **clean** presets (500/1000/2000 Kč; RO 100/300/500 lei) + "Jiná" custom toggle + remainder quick-fill; "amount follows donor capacity, not goal size" made an explicit product truth | Divergence — presets not evidenced as currently live |
| Category tag | Two treatments observed: violet pill in breadcrumb area + a different badge on related-story cards | **One unified `CategoryChip`** (`COMP0018`) — icon + color, same area = same color across chip / card wash / monogram | Divergence — current-state uses inconsistent badge treatments; target unifies |
| 100% pledge / vendor | Present as a full-width red trust banner ("Na pomoc dětem putuje vždy 100 % částky...") | Promoted to `PledgeStrip` (`COMP0013`) — bold full-width divider before "Další děti", carries pledge **+ vendor** (nominative-case, machine-fillable); present in every `DonationBox` state | Elevated/formalized in target — vendor-naming behavior is a target addition not confirmed present in the current banner copy |
| Patron | "PATRON PŘÍBĚHU" card with a "Zobrazit komentář Patrona" toggle/link (expand behavior Uncertain, WIRE0002-Q6) | `PatronCard` (`COMP0012`) — standalone testimonial pillar, larger avatar, **comment always visible, no toggle** | Divergence — target removes the toggle entirely (transparency invariant) |
| Urgency / time-remaining | Plain text near the progress stat ("Zbývá měsíc"); no urgent/alert visual treatment captured | `TimeLeftPill` (`COMP0017`) inside the box; urgent state = full alert-badge, own `color.urgent` token (decoupled from brand), gentle pulse (disabled under reduced-motion) | Gap — current-state urgent rendering existence is Uncertain, not confirmed absent |
| Voucher (dobrošek) | "Mám dobrošek" (red, ticket icon) CTA beside the box; separate "Koupím dobrošek" entry maps to `S005` | Redeem stays **inside** `DonationBox`; a separate **promo `RailCta`** (`COMP0014`, CZ-only, whole card links to `/dobroseky`) sits below the box; RO has **no** dobrošek promo (open question) | Divergence — current-state renders voucher as a standalone red CTA; target splits redeem (in-box) vs. promo (rail card) |
| Recurring donation | "Chci podporovat rozvoj a vzdělání pravidelně" (green button) beside the box | `RailCta` (`COMP0014`, default variant) — a lighter rail card below `DonationBox`, linking to the story's category collection account (`kategorie=education`) | Divergence — current-state is a same-level button; target demotes it to a secondary rail card |
| Header / nav | Current CZ nav ("Jak to funguje", "Blog", "O nás") + login → account, no breadcrumb styling change | Lightened `SiteHeader` (`COMP0002` target contract) — just breadcrumb + full-width H1; no pills in header | Divergence — visual weight/composition differs; component identity (COMP0002) is shared |
| Placeholder image | Real photos observed throughout; no missing-photo case captured | Monogram-on-calm-surface placeholder (not a mesh gradient) when no photo, both `StoryHero` (`COMP0011`) and `StoryCard` (`COMP0008`) | Gap — current-state missing-photo treatment is Uncertain, not evidenced either way |
| Multi-tenant (CZ/RO) | No RO instance evidenced in current-state screenshots; Patronus source covers CZ/RO/MD per project context, but this WIRE's evidence is CZ-only | Canon runs both tenants from **one component set** via `data-theme="cz\|ro"` (`DESIGN-tokens.md` §11); RO = KidsHero anchor, turquoise/navy; **deployment reality: only CZ runs live, RO is a Storybook theming demo, not a second deployed instance** (`design-canon.md` §5) | Not a like-for-like comparison — target RO is a demo, not a live current-state fact; do not treat it as evidence of a live RO site |
| Duplicate sidebar | Sidebar (progress/CTAs/share) appears **twice** in the full-page capture (WIRE0002-Q1) — likely a template/layout artifact | One `DonationBox` instance, positioned once in the sticky rail — no duplicate-rendering concept in the canon composition | Divergence — target's single-block model may explain/resolve the current-state duplication, but this is `Hypothesis — Not evidenced in current sources`, not confirmed |

**Trust default (per `CLAUDE.md`):** for current behavior, this WIRE's own reconstruction (code /
screenshots) wins — the canon above does not override it. For what to build, the canon is the
target, on par with `it-zadani` authority. The two are recorded side by side, never merged.

### 3. Not part of the canon page (explicitly out of scope)

Per `StoryDetail.contract.md` "Mimo scope" (`design-canon.md` §4.5): the donation **modal**
(email/consents/mock payment), the detailed step-by-step "donation chain" explainer, and
donor-count real-data availability are all named as **future** blocks, not part of today's canon
page. The current-state modal described in this WIRE's Interactions #2–#3 and Layout Zones has
**no canonical counterpart yet** — do not read the canon's silence on the modal as evidence that
the current-state modal should be removed or simplified; it is simply not yet designed.

---

## Interactions

1. **Entry** — navigation from `S001` catalogue card or a direct `/pribeh/<slug>` link → state:
   `default`.
2. **Primary action — open donation modal** — click "Přispět 🤝" (either sidebar instance) →
   modal overlay opens pre-filled with the amount typed in the triggering "Chci darovat" field
   (observed default `50` Kč carried into the modal header field); realizes entry into `UC0005`;
   next: modal `default` state.
3. **Primary action — submit donation** — fill/confirm modal fields, check both consent boxes,
   click "Přejít k platbě" → realizes `UC0005` (Main Flow UC0005.1–UC0005.3); next: redirect to
   `S-EXT1` (Comgate hosted gateway, out of WIRE scope) on success, or inline validation surface
   on failure (see States → error, Validation Surfaces).
4. **Secondary action — recurring intent** — click "Chci podporovat rozvoj a vzdělání" → Assumed to
   open the same or an equivalent donation modal with the recurring flag set (`UC0005.2`); the
   modal's recurring-specific affordance (e.g. a toggle) is **not observed** in the captured modal
   screenshots — Uncertain (Open Question).
5. **Secondary action — voucher redemption entry** — click "Mám dobrošek" / "Chcete věnovat
   dobrošek?" → Assumed to open a voucher-code entry surface feeding `UC0009`; **target surface not
   captured** on this screen (IA `S005`/voucher entry, Uncertain) — Open Question.
6. **Secondary action — read Patron comment** — click "Zobrazit komentář Patrona" → Assumed
   expand/scroll-to behavior (toggle label observed; expanded/collapsed states not both captured)
   — Uncertain.
7. **Secondary action — category-support CTA** — "Chci podporovat rozvoj a vzdělání" doubles as a
   category-level support entry per IA S002 purpose row; same target as recurring CTA per evidence
   (no separate category-only flow observed) — Assumed.
8. **Secondary action — related-story navigation** — click a related-story CTA ("Podpořím
   Románka"/"Petrušku"/"Miu") → navigates to that Story's own `S002` instance (different `/pribeh/
  <slug>`); click "Další příběhy" → Assumed return to `S001` catalogue.
9. **Exit — modal cancel** — click "Zpět na příběh" → closes modal, returns to `default` state of
   this screen, no state change to `EN0009`.
10. **Exit — successful submission** — see interaction 3; redirects off-screen to `S-EXT1` →
    `S-EXT2` → `S003` (per IA Cross-Module Flow "Donation & payment flow").

---

## States

### default
The Story detail page as captured: hero photo, Patron comment card, body text, sidebar with
progress/CTAs, trust banner, related-stories rail. Confirmed —
`screencapture-...-13_25_48.png`.

### empty
Not observed. No "Story removed / fully funded / not found" treatment was captured. Given
`UC0005` AF2 ("Campaign missing or already fully funded" rejects the donation but does not
describe the Story-page rendering for an already-fully-funded or delisted Story), the page-level
empty/closed treatment is Uncertain — Open Question, not fabricated here.

### loading
Not observed. No spinner/skeleton state was captured for either the page or the modal (e.g. while
"Přejít k platbě" is dispatching the gateway hand-off request in `UC0005.3`). Assumed to exist
(a network round-trip is required before the gateway redirect) but its visual treatment is
Uncertain — Open Question.

### error
Not observed as a rendered UI state. `UC0005` AF1 (invalid/non-numeric amount) and AF2
(Campaign missing or fully funded) define the rejection *outcomes*, but no screenshot shows an
inline error message, toast, or field-level error styling on this screen or its modal. Declared
per WIRE discipline rather than fabricated — Uncertain — Open Question (see Validation Surfaces).

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| Modal amount field | `UC0005` AF1 (amount must be numeric) — no BR owns this rule | Uncertain — no error surface observed; listed in Open Questions (no BR id available, not invented) |
| Modal amount field vs. Campaign funding | `UC0005` AF2 / `BR-PaymentAndMoneyIntegrity` ("reject a donation submitted against a Campaign whose running raised total already meets or exceeds its target amount") | Uncertain — no error surface observed on this screen |
| Modal "E-mail (povinný)" field | Marked required in copy ("povinný"); no BR found governing e-mail format/required validation at this screen | Uncertain — no BR id; open question |
| Modal consent checkbox 1 ("Souhlasím s pravidly poskytování pomoci") | No BR found gating submission on this checkbox | Uncertain — no BR id; open question |
| Modal consent checkbox 2 ("Souhlasím se zpracováním osobních údajů") | No BR found gating submission on this checkbox; `BR-DataProtectionAndErasure` governs GDPR erasure/processing generally but does not specify this UI-level consent-checkbox gate | Uncertain — no BR id; open question |

**validationsWithoutBR:** modal amount numeric-format check, e-mail-required check, both consent
checkboxes — none of these have a governing `BRxxxx` in the current BR layer; they are visible
form affordances in the screenshot but the enforcing rule (if any beyond `UC0005` prose) is not
separately codified. Recorded as Open Questions rather than invented BR ids.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Title band | `EN0004` | — | Campaign public name |
| Media zone | `EN0004` | — | Campaign imagery (required-imagery attribute, per `BR-CampaignStoryLifecycle`) |
| Category tag ("Rozvoj a vzdělání") | `EN0004` | — | `gift_category` attribute |
| In-kind description ("balík školních potřeb; dodává SEVT") | `EN0004` | — | free-text case description; exact owning attribute not confirmed — Uncertain |
| Patron comment card | `EN0005` | — | Patron name/photo (`EN0005` attributes); comment body text ownership (Patron vs. Application narrative) not confirmed — Uncertain |
| Progress block ("Chybí 1 600 Kč", bar, "Zbývá měsíc", "Cílová částka") | `EN0004` | — | derived `campaign_raised` / `campaign_percentual_raised` vs. `gift_price` (target) and `campaign_deadline`, per `BR-CampaignStoryLifecycle`; this screen only renders the derived values, it does not compute them |
| Modal amount field | `EN0009` | — | becomes `Transaction.amount` on submit (`UC0005.1` step 10) |
| Modal E-mail / Jméno / Příjmení / phone | `EN0006`, `EN0008` | — | resolves/creates the donor `User` (`EN0008`) and linked `Contact` (`EN0006`) per `UC0005.1` steps 4–7 |
| Recurring CTA intent | `EN0010` | — | if recurring is requested, a `RecurringTransaction` is created per `UC0005.2` |
| "Mám dobrošek" entry | `EN0013` | — | feeds `UC0009` voucher redemption; the redemption surface itself is out of this screen's captured scope |
| Related-story cards | `EN0004` | — | each card is a different Campaign instance (own progress/target fields) |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Recurring CTA ("...pravidelně") | No ACL layer exists yet; no role gate observed — visible to anonymous visitors in evidence | n/a — Confirmed always-visible in captured evidence |
| "Mám dobrošek" / voucher CTA | No ACL layer exists yet; no role gate observed | n/a — Confirmed always-visible in captured evidence |
| Modal contact fields (E-mail/Jméno/Příjmení/phone) pre-fill | Observed pre-filled with tester data in evidence (`screencapture-...-13_26_21.png`) when the browser/session already held autofill data; whether an **authenticated** donor sees these fields pre-filled from their `User`/`Contact` record (vs. browser autofill) is not distinguishable from this evidence — Uncertain, Open Question | fields would presumably be blank for a first-time anonymous visitor — Assumed, not directly observed |
| Duplicate sidebar block (progress/CTA/share, appearing twice in the full-page capture) | Not resolved by an ACL/BR condition — likely a template/layout artifact of the two-column reflow rather than a role- or state-gated feature | Uncertain — Open Question, not fabricated as intentional |

---

## Accessibility Notes

- **Tab order:** Assumed to follow visual order (media → Patron card link → body → sidebar
  amount input → CTA buttons → share icons); not verifiable from static screenshots — Uncertain.
- **Focus on entry:** Not observed; Assumed default browser focus (top of document) on page load.
- **Focus on state transition (modal open):** Not observed whether focus moves into the modal
  (e.g. to the amount field or the close/back link) when "Přispět" is clicked — Uncertain, Open
  Question; WCAG dialog-focus-trap behavior cannot be confirmed from screenshots alone.
- **Landmarks:** Not evidenced from screenshots (no DOM/ARIA inspection performed in this pass);
  Uncertain.
- **Keyboard shortcuts:** None observed; no screen-specific shortcuts evidenced.

---

## Open Questions

| # | Question | Impact | Status |
|---|---|---|---|
| WIRE0002-Q1 | Why does the donation sidebar (progress + CTAs + share row) appear to repeat twice in the full-page capture — two-column reflow artifact, or two genuinely distinct blocks (e.g. sticky vs. static copy)? | Affects Layout Zones / Components Used duplication | open |
| WIRE0002-Q2 | Does the "Chci podporovat rozvoj a vzdělání" (recurring) CTA open the same donation modal with a recurring flag, or a distinct modal/screen? | Affects Interactions #4, `UC0005.2` binding | open |
| WIRE0002-Q3 | What does "Mám dobrošek" / "Chcete věnovat dobrošek?" navigate to — is there a dedicated voucher-redemption surface, and is it the same as the uncaptured voucher-purchase screen `S005`? | Affects Interactions #5, `UC0009` entry binding | open (cross-ref IA-Q10) |
| WIRE0002-Q4 | Is there any inline validation UI for invalid amount, missing e-mail, unchecked consents, or a fully-funded Campaign — or does the current implementation rely solely on gateway/back-end rejection with no client-visible error state? | Affects States → error, Validation Surfaces | open |
| WIRE0002-Q5 | Is there a loading indicator between "Přejít k platbě" and the redirect to `S-EXT1`? | Affects States → loading | open |
| WIRE0002-Q6 | Does "Zobrazit komentář Patrona" toggle/expand content, or link elsewhere? | Affects Interactions #6 | open |

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Full-page layout (title, media, Patron card, body, sidebar, trust banner, related rail) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`; `ui-observed-areas.md` §2 |
| Donation modal — empty/default contact fields, amount `50` Kč, unchecked consents | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_08.png` |
| Donation modal — filled contact fields (autofill/tester data), checked consents | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png`; `ui-observed-areas.md` §2 |
| Progress/target amount rendering ties to `EN0004`/`BR-CampaignStoryLifecycle` derived fields | Probable | `_ar/spec-draft/EN/EN0004_Campaign.md`; `_ar/spec-draft/BR/BR-CampaignStoryLifecycle.md` |
| Donation submission flow (`UC0005`) fields map to `EN0009`/`EN0006`/`EN0008` | Confirmed | `_ar/spec-draft/UC/UC0005_MakeADonation.md` |
| Voucher entry maps to `UC0009`/`EN0013` | Probable | `_ar/spec-draft/UC/UC0009_RedeemValidateVoucher.md`; entry CTA observed but target screen not captured |
| `UC0011` relevance (displayed progress is UC0011-computed, not screen-computed) | Confirmed (as a non-owning reference) | `_ar/spec-draft/UC/UC0011_ManageCampaignStoryLifecycle.md` |
| empty/loading/error states, focus management, duplicate sidebar, recurring/voucher target surfaces | Uncertain | not captured in any screenshot — see Open Questions |
