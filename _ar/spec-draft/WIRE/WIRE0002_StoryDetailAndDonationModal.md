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

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | COMP0002 | context=public | see `COMP0002` Global Site Header |
| Title band | inline | h1 | Story name |
| Media zone | inline | hero image | single photo, no gallery/carousel observed |
| Patron comment card | inline | avatar + name + role + toggle + body | binds `EN0005` |
| Story body | inline | rich text block | long-form narrative + bullet list |
| Progress block | inline | label + progress bar + two-line stat (Zbývá / Cílová částka) | binds derived `EN0004` fields (see Data Bindings); Uncertain whether this shares a component with `COMP0008` Story Card's internal progress figures — not confirmed identical, left inline (see `COMP0008` Open Questions) |
| Amount input | inline | numeric field, Kč suffix, prefilled `50` | two instances stacked in evidence (Open Question) |
| Primary donate CTA ("Přispět 🤝") | COMP0001 | icon=🤝 | see `COMP0001` Primary Button |
| Recurring CTA ("Chci podporovat... pravidelně") | inline | secondary/green button | intent flag into `UC0005` (recurring branch); no separate recurring screen observed here; visual identity Uncertain vs. `COMP0001` — see `COMP0001` Open Questions (secondary-button variant not promoted) |
| Voucher CTA ("Mám dobrošek") | inline | secondary/red button, ticket icon | entry point into `UC0009` — target screen not captured (IA `S005`, Uncertain) |
| Share row | inline | icon button row | Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger — no share behavior observed beyond icon presence |
| Trust banner | inline | full-width text band | static copy, not entity-bound |
| Related story card | inline | photo + countdown badge + progress ribbon + name + target amount + CTA | repeats catalogue card pattern from `S001`; visually close to `COMP0008` Story Card but rendered in a "related" sidebar layout, not confirmed identical — left inline pending clearer evidence |
| Donation modal shell | inline | overlay/dialog, header + close/back | opened by primary CTA |
| Modal amount field | inline | numeric field, Kč suffix, prefilled `50`, editable in modal header | binds donation amount |
| Modal contact fields | inline | E-mail (required), phone (+420 prefix), Jméno, Příjmení | binds `EN0006`/`EN0008` (see Data Bindings) |
| Modal consent checkboxes (×2) | COMP0006 | count-per-form=double | gate `UC0005` submission (Open Question — no BR found, see Validation Surfaces); see `COMP0006` Consent Checkbox |
| Modal primary CTA ("Přejít k platbě") | COMP0001 | — | submits `UC0005`, hands off to `S-EXT1`; see `COMP0001` Primary Button |
| Modal helper text | inline | static microcopy | describes downstream gateway choice; not app-editable content, COPY-owned |

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
