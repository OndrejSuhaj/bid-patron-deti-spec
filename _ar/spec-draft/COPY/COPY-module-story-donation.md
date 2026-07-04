---
doc_id: COPY-module-story-donation
title: Story Catalogue, Story Detail & Donation Copy
canonical_layer: COPY
spec_type: copy
scope: module-story-donation
modules: []
language: cs
status: draft
references:
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0004
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0004
  - COMP0006
  - COMP0008
  - UC0023
  - UC0005
  - UC0009
  - UC0006
  - UC0025
  - UC0007
  - EN0004
  - EN0013
---

# COPY-module-story-donation – Story Catalogue, Story Detail & Donation Copy

## Purpose

This document transcribes the user-facing Czech text for the donor-acquisition surfaces: the
homepage story catalogue and hero (S001 / `WIRE0001`), the Story detail page and its one-off
donation modal (S002 / `WIRE0002`), the generic thank-you/payment-success page (S003 / `WIRE0003`),
and the — currently uncaptured — voucher purchase screen (S005 / `WIRE0004`). Consumed by the
`bid-patron-deti` FE rebuild as the i18n source for these four screens. Tone across all four
screens is informal-warm second-person address ("Chystáte se přispět", "Vaše podpora"), sentence
case, red/coral primary CTAs. Text is transcribed **verbatim** from `_ar/prtsc/**` screenshots and
`_ar/evidence/ui/ui-observed-areas.md`; no paraphrase or invention. Global chrome (header nav,
footer, cookie-consent banner) is owned by `COMP0002`/`COMP0003`/`COMP0004` and a
`shared-global` COPY scope, not restated here — only screen-specific text is captured below.

---

## Labels

| Key | Text | Usage (WIRE/COMP ref) |
|---|---|---|
| `module-story-donation.homepage.hero-headline-line1` | `DARUJME DĚTEM ŠANCI` | `WIRE0001` |
| `module-story-donation.homepage.hero-headline-line2` | `za jedno kafe měsíčně` | `WIRE0001` |
| `module-story-donation.homepage.stat-strip-number` | `323 dětí` | `WIRE0001` |
| `module-story-donation.homepage.stat-strip-caption` | `čeká na pomoc` | `WIRE0001` |
| `module-story-donation.homepage.filter-tab-remaining` | `Zbývající částka` | `WIRE0001` (default active tab) |
| `module-story-donation.homepage.filter-tab-single-parents` | `Samoživitelé` | `WIRE0001` |
| `module-story-donation.homepage.filter-tab-regions` | `Filtrovat podle krajů` | `WIRE0001` |
| `module-story-donation.homepage.filter-tab-ending-soon` | `Brzy skončí` | `WIRE0001` |
| `module-story-donation.homepage.region-map-heading` | `Vyberte kraj na mapě` | `WIRE0001` |
| `module-story-donation.homepage.story-card-remaining-label` | `Zbývá` | `WIRE0001`, `COMP0008` |
| `module-story-donation.homepage.story-card-target-label` | `Cílová částka` | `WIRE0001`, `COMP0008` |
| `module-story-donation.homepage.story-card-collection-ribbon` | `SBÍRKOVÝ ÚČET` | `WIRE0001`, `COMP0008` |
| `module-story-donation.homepage.story-card-collection-title` | `Necháte výběr dítěte, kterému chcete pomoct na nás?` | `WIRE0001` |
| `module-story-donation.homepage.testimonial-heading` | `Poděkování od rodin` | `WIRE0001` |
| `module-story-donation.homepage.testimonial-intro` | `Každý příběh je důkazem toho, že společně dokážeme udělat svět lepším místem pro děti, které to nejvíce potřebují. Vaše podpora a laskavost dávají rodinám naději a dětem radost, kterou si zaslouží.` | `WIRE0001` |
| `module-story-donation.homepage.voucher-band-heading` | `Dobrošeky pro lepší dětství` | `WIRE0001` |
| `module-story-donation.homepage.voucher-band-intro` | `Dobrošeky můžete koupit i darovat online, nebo si je poslat do emailu a vytisknout jako dárek. Každý obdarovaný si pak na našem webu vybere dětský příběh, kterému mu bude nejbližší a na který svým dobrošekem přispěje.` | `WIRE0001` |
| `module-story-donation.homepage.voucher-card-title` | `Pro lepší dětství` | `WIRE0001` (repeats on all 6 denomination cards) |
| `module-story-donation.homepage.how-it-works-heading` | `Jak to funguje?` | `WIRE0001` |
| `module-story-donation.homepage.how-it-works-col1-title` | `Vše začíná příběhem` | `WIRE0001` |
| `module-story-donation.homepage.how-it-works-col2-title` | `Společně zvládneme víc!` | `WIRE0001` |
| `module-story-donation.homepage.how-it-works-col3-title` | `Jen na vás záleží…` | `WIRE0001` |
| `module-story-donation.homepage.patron-explainer-heading` | `Kdo je to Patron příběhu?` | `WIRE0001` |
| `module-story-donation.homepage.patron-explainer-body` | `Každý příběh má svého Patrona. Ten je pro dárce zárukou důvěryhodnosti. Patronem se může stát kdokoli, kdo zná dítě z příběhu – učitel, vedoucí kroužku nebo sociální pracovník. Znáte dítě, které potřebuje naši pomoc? Staňte se Patronem i vy.` | `WIRE0001` |
| `module-story-donation.homepage.sponsors-heading` | `Podporují nás` | `WIRE0001` |
| `module-story-donation.homepage.partners-heading` | `Spřátelené organizace` | `WIRE0001` |
| `module-story-donation.story-detail.category-tag` | `Rozvoj a vzdělání` | `WIRE0002` (per-Campaign `gift_category`, `EN0004`; text is data-driven, this is the observed instance value) |
| `module-story-donation.story-detail.contribute-heading` | `Přispět můžete na` | `WIRE0002` |
| `module-story-donation.story-detail.in-kind-description` | `balík školních potřeb; dodává SEVT` | `WIRE0002` (data-driven free-text instance value, `EN0004`) |
| `module-story-donation.story-detail.progress-missing-label` | `Chybí {amount} Kč` | `WIRE0002` (observed instance: "Chybí 1 600 Kč") |
| `module-story-donation.story-detail.progress-remaining-label` | `Zbývá` | `WIRE0002` |
| `module-story-donation.story-detail.progress-remaining-value` | `měsíc` | `WIRE0002` (observed instance value; varies per Campaign, cf. `COMP0008` deadline badge values) |
| `module-story-donation.story-detail.progress-target-label` | `Cílová částka` | `WIRE0002` |
| `module-story-donation.story-detail.amount-input-label` | `Chci darovat` | `WIRE0002` (amount field, default value `50`, suffix `Kč`) |
| `module-story-donation.story-detail.patron-card-label` | `PATRON PŘÍBĚHU` | `WIRE0002` |
| `module-story-donation.story-detail.recurring-heading` | `Přeji si podporovat rozvoj a vzdělání pravidelně` | `WIRE0002` (category name is data-driven, `EN0004.gift_category`) |
| `module-story-donation.story-detail.voucher-cta-question` | `Chcete věnovat dobrošek?` | `WIRE0002` |
| `module-story-donation.story-detail.share-heading` | `Sdílet příběh:` | `WIRE0002` |
| `module-story-donation.story-detail.related-stories-heading` | `Aktuálně čekají na vaši pomoc` | `WIRE0002` |
| `module-story-donation.story-detail.trust-banner` | `Na pomoc dětem putuje vždy 100 % částky, kterou darujete.` | `WIRE0002` |
| `module-story-donation.donation-modal.title` | `Chystáte se přispět` | `WIRE0002` |
| `module-story-donation.donation-modal.amount-field-label` | `Kč` | `WIRE0002` (unit suffix on the modal's amount field; field itself carries no separate visible label besides the inherited "Chci darovat" value) |
| `module-story-donation.donation-modal.email-label` | `E-mail (povinný)` | `WIRE0002` |
| `module-story-donation.donation-modal.phone-prefix-label` | `+420` | `WIRE0002` |
| `module-story-donation.donation-modal.phone-field-placeholder` | `Telefon` | `WIRE0002` |
| `module-story-donation.donation-modal.firstname-field-placeholder` | `Jméno` | `WIRE0002` |
| `module-story-donation.donation-modal.lastname-field-placeholder` | `Příjmení` | `WIRE0002` |
| `module-story-donation.thankyou.headline` | `Platba proběhla úspěšně, děkujeme za pomoc!` | `WIRE0003` |
| `module-story-donation.thankyou.body-1` | `Každý příspěvek pomáhá k lepšímu dětství. Děkujeme, že jste s námi.` | `WIRE0003` |
| `module-story-donation.thankyou.body-2` | `Platba proběhla úspěšně! Moc děkujeme. Prosíme, sdílejte a pomozte příběhu, kterému jste právě přispěli.` | `WIRE0003` |
| `module-story-donation.thankyou.resume-modal-title` | `Máte u nás rozpracovanou žádost.` | `WIRE0003` (co-resident overlay realizing `UC0025`, not part of the payment-confirmation flow) |
| `module-story-donation.thankyou.resume-modal-body` | `Vypadá to, že jste u nás nechali rozpracovanou žádost. Pro návrat do formuláře můžete použít tlačítka níže, případně lze využít odkaz v hlavičce.` | `WIRE0003` |
| `module-story-donation.thankyou.resume-modal-delete-prompt` | `Přejete si žádost o pomoc zcela zrušit?` | `WIRE0003` |

---

## Helper Texts

| Key | Text | Usage |
|---|---|---|
| `module-story-donation.donation-modal.donation-integrity-note` | `Na pomoc dětem putuje vždy 100 % z darované částky.` | `WIRE0002` (shown under each "Chci darovat" / "Přispět" pairing on the sidebar; repeats verbatim per `WIRE0002` Layout Zones) |
| `module-story-donation.donation-modal.consent-manage-note` | `Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz.` | `WIRE0002`, `COMP0006` (owned/reused by `COMP0006`'s `helperText` prop — cited here for this screen's instance, not restated as a new fact) |
| `module-story-donation.donation-modal.gateway-choice-note` | `Po přesměrování na platební bránu si budete moci vybrat mezi online platbou (kartou) a expresním bankovním převodem.` | `WIRE0002` |
| `module-story-donation.story-detail.trust-list-item-1` | `100 % daru jde na pomoc dětem,` | `WIRE0002` (story-body bulleted trust list) |
| `module-story-donation.story-detail.trust-list-item-2` | `peníze neposíláme rodinám, ale hradíme za ně konkrétní školní potřeby,` | `WIRE0002` |
| `module-story-donation.story-detail.trust-list-item-3` | `všechny žádosti pečlivě posuzuje naše oddělení risku,` | `WIRE0002` |
| `module-story-donation.story-detail.trust-list-item-4` | `každou žádost potvrzuje Patron – například sociální pracovník, učitel nebo vedoucí zájmového kroužku` | `WIRE0002` |

---

## Empty States

| Key | Text | Shown when |
|---|---|---|
| — | — | `Evidence Pending` — no zero-result state captured for the S001 catalogue grid/region filter (`UC0023` AF4), no fully-funded/removed-Story treatment captured for S002 (`UC0005` AF2), and S005 has no capture at all. No text can be transcribed; do not invent copy. See `WIRE0001` States → empty, `WIRE0002` States → empty, `WIRE0004` throughout. |

---

## Loading Texts

| Key | Text | Shown during |
|---|---|---|
| — | — | `Evidence Pending` — no loading/skeleton/spinner state was captured for the S001 tab/region re-query, the S002 modal's gateway hand-off, the S003 arrival, or S005 (uncaptured entirely). No text can be transcribed; do not invent copy. See `WIRE0001`/`WIRE0002`/`WIRE0003`/`WIRE0004` States → loading. |

---

## Error / Validation Messages

Every message references the triggering rule or invariant. Per `WIRE0002` Validation Surfaces and
Open Questions (`WIRE0002-Q4`), no BR-governed inline validation-error UI was observed for the
donation modal on S002; the visible form affordances have no captured error text.

| Key | Text | Trigger |
|---|---|---|
| — | *(not observed — no error copy captured for any field)* | `UC0005` AF1 (invalid/non-numeric amount) — no `BRxxxx` owns this rule per `WIRE0002` Validation Surfaces; **Open Question**, no id invented |
| — | *(not observed)* | `UC0005` AF2 (Campaign fully funded) / `BR-PaymentAndMoneyIntegrity` — **Open Question**, no error surface captured |
| — | *(not observed)* | Modal "E-mail (povinný)" required-field check — no BR found governing this validation per `WIRE0002`; **Open Question** |
| — | *(not observed)* | Modal consent checkbox 1 ("Souhlasím s pravidly poskytování pomoci") gate — no BR found per `WIRE0002`; **Open Question** |
| — | *(not observed)* | Modal consent checkbox 2 ("Souhlasím se zpracováním osobních údajů") gate — `BR-DataProtectionAndErasure` governs GDPR erasure/processing generally but not this UI-level checkbox gate per `WIRE0002`; **Open Question** |

**validationsWithoutTrigger:** all five rows above have a visible form affordance implying
validation but no captured error text and no owning `BRxxxx`/`ENxxxx` beyond the `UCxxxx`
alternative-flow prose already cited in `WIRE0002`. Recorded as Open Questions, not invented.

---

## CTAs

Every CTA references the use case it realizes.

| Key | Text | Action |
|---|---|---|
| `module-story-donation.homepage.hero-preset-cta-90` | `Daruj 90 Kč měsíčně` | entry point into recurring-donation setup feeding `EN0010`; `UC0007`-charged schedule (`WIRE0001` Interactions #8) — no direct submitting UC on S001 itself; **Open Question** which UC/screen the click hands off to |
| `module-story-donation.homepage.hero-preset-cta-290` | `Daruj 290 Kč měsíčně` | same as above |
| `module-story-donation.homepage.hero-preset-cta-custom` | `Daruj měsíčně podle sebe` | same as above |
| `module-story-donation.homepage.category-cta-health` | `Zdravotní pomoc` | presumed filter/navigation; effect not confirmed (`WIRE0001` Interactions #9); **Open Question**, no UC id available |
| `module-story-donation.homepage.category-cta-education` | `Rozvoj a vzdělání` | same as above; **Open Question** |
| `module-story-donation.homepage.story-card-cta-named` | `Podpořím {jméno}` | `UC0023` (Main Flow step 13–14, hand-off boundary into `UC0005`) |
| `module-story-donation.homepage.story-card-cta-collection` | `Nechám to na vás` | `UC0023` (collection-account card hand-off; mechanism Partial per `WIRE0001`) |
| `module-story-donation.homepage.more-stories-link` | `Další příběhy` | presumed pagination/full listing; **Open Question**, no UC id available (`WIRE0001` Interactions #10) |
| `module-story-donation.homepage.voucher-purchase-cta` | `Koupím dobrošek` | entry point toward `UC0009` voucher lifecycle (purchase side; target screen S005, `WIRE0004`) |
| `module-story-donation.homepage.patron-cta` | `Chci se stát Patronem` | no realizing UC evidenced for this exact click target on S001; **Open Question** (`WIRE0001` Interactions #13) |
| `module-story-donation.story-detail.donate-cta` | `Přispět 🤝` | opens the donation modal; realizes entry into `UC0005` (`WIRE0002` Interactions #2) |
| `module-story-donation.story-detail.recurring-cta` | `Chci podporovat rozvoj a vzdělání` | Assumed to open donation modal with recurring flag set, `UC0005.2`; not directly observed (`WIRE0002` Interactions #4, Open Question `WIRE0002-Q2`) |
| `module-story-donation.story-detail.voucher-cta` | `Mám dobrošek` | Assumed entry into `UC0009` voucher redemption; target surface not captured (`WIRE0002` Interactions #5, Open Question `WIRE0002-Q3`) |
| `module-story-donation.story-detail.patron-comment-toggle` | `Zobrazit komentář Patrona` | Assumed expand/scroll-to; not confirmed (`WIRE0002` Interactions #6, Open Question `WIRE0002-Q6`) |
| `module-story-donation.story-detail.related-story-cta` | `Podpořím {jméno}` | navigates to that Story's own `S002` instance (`WIRE0002` Interactions #8); observed instances: `Podpořím Románka`, `Podpořím Petrušku`, `Podpořím Miu` |
| `module-story-donation.story-detail.more-stories-link` | `Další příběhy` | Assumed return to S001 catalogue (`WIRE0002` Interactions #8) |
| `module-story-donation.donation-modal.back-link` | `Zpět na příběh` | closes modal, no state change (`WIRE0002` Interactions #9) |
| `module-story-donation.donation-modal.consent-1-label` | `Souhlasím s pravidly poskytování pomoci projektu Patron.` | consent gate on `UC0005` submission; no owning `BRxxxx` found — **Open Question** (`WIRE0002` Validation Surfaces); COMP-owned label text per `COMP0006` |
| `module-story-donation.donation-modal.consent-2-label` | `Souhlasím se zpracováním osobních údajů a informováním o projektu` | consent gate on `UC0005` submission; no owning `BRxxxx` found — **Open Question** (`WIRE0002` Validation Surfaces); COMP-owned label text per `COMP0006` |
| `module-story-donation.donation-modal.submit-cta` | `Přejít k platbě` | submits `UC0005` (Main Flow UC0005.1–UC0005.3), hands off to `S-EXT1` payment gateway |
| `module-story-donation.thankyou.back-home-cta` | `Zpět na hlavní stránku` | plain navigation exit to S001; does not realize a status-changing UC per `UC0006` Actor description (`WIRE0003` Interactions #2) |
| `module-story-donation.thankyou.resume-modal-resume-cta` | `Návrat do žádosti` | resumes the draft Application, `UC0025` (Main Flow, resume branch) |
| `module-story-donation.thankyou.resume-modal-stay-cta` | `Zůstat na stránce` | dismisses modal, stays on S003 unchanged, `UC0025` (dismiss branch) |
| `module-story-donation.thankyou.resume-modal-delete-cta` | `Smazat žádost` | discards the draft Application (destructive, styled as a text link), `UC0025` (discard branch) |
| `module-story-donation.voucher-purchase.entry-cta` | `Koupím dobrošek` | duplicate of `module-story-donation.homepage.voucher-purchase-cta` — this is the only confirmed text for S005; the purchase screen's own CTAs (submit/pay) are `Evidence Pending` per `WIRE0004`, not captured, not invented |

---

## Microcopy Conventions

- Tone: informal-warm, direct address to the donor ("Chystáte se přispět", "Vaše podpora"); charity/NGO register.
- Person: 2nd person singular/plural mixed with 1st person for CTAs styled as the donor's own intent ("Chci darovat", "Chci podporovat", "Koupím dobrošek", "Přeji si podporovat... pravidelně").
- Capitalization: sentence case throughout; filter-tab and section-heading labels also sentence case (no title case observed).
- Punctuation: full stops on body/helper sentences; CTAs typically punctuation-free except embedded emoji (🤝 on "Přispět 🤝").
- Numeric amounts always suffixed `Kč`, thousands-separated with a space (e.g. "1 600 Kč", "323 dětí").
- The 100%-of-donation trust message ("Na pomoc dětem putuje vždy 100 % ...") recurs verbatim across S001-adjacent and S002 surfaces — a fixed brand-trust phrase, not screen-specific copy.

---

## Evidence

Text is transcribed verbatim from observed UI; mark unobserved (implied) strings as
`Assumed`/`Uncertain`.

| Key area | Certainty | Evidence |
|---|---|---|
| Homepage hero, stat strip, filter tabs, region-map heading, voucher band, "Jak to funguje?", Patron explainer, sponsor headings | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `13_16_09.png`, `13_16_21.png`, `13_16_37.png`; `ui-observed-areas.md` §1 |
| Story card labels ("Zbývá", "Cílová částka", "SBÍRKOVÝ ÚČET", CTA patterns) | Confirmed | same as above; `COMP0008` |
| Story detail page copy (category tag, contribute heading, progress labels, trust list, CTAs, share heading, related-stories heading, trust banner) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`; `ui-observed-areas.md` §2 |
| Donation modal (title, field labels, consent labels, helper texts, submit CTA) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_08.png` (empty state), `..._13_26_21.png` (filled state, consent copy zoom-verified); `ui-observed-areas.md` §2 |
| Consent-management helper text exact e-mail address | Confirmed (zoom-verified `souhlas@patrondeti.cz`, matching `COMP0006`) | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_08.png` (cropped detail) |
| Thank-you page headline/body/CTA | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png`; `ui-observed-areas.md` §13 |
| Resume-draft modal (title, body, CTAs, delete prompt) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_30_32.png`; `ui-observed-areas.md` §13 |
| Voucher purchase screen (S005) — any copy beyond the shared entry CTA | Evidence Pending — not captured | `WIRE0004` (no screenshot of S005 exists in `_ar/prtsc/**`) |
| Empty / loading states (all four screens) | Evidence Pending — not captured | `WIRE0001`/`WIRE0002`/`WIRE0003`/`WIRE0004` States sections |
| Error / validation message text (donation modal) | Evidence Pending — not captured; no BR owns the implied rules | `WIRE0002` Validation Surfaces, Open Question `WIRE0002-Q4` |
| Hero preset CTA and category-pill CTA downstream destinations | Uncertain | `WIRE0001` Interactions #8–#9 |
