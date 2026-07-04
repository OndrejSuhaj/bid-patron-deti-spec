---
doc_id: COPY-key-index
title: COPY Key Index — Consolidated i18n Key Table (all scopes)
canonical_layer: COPY
spec_type: index
scope: all
modules: []
language: cs
status: draft
references:
  - COPY-shared-global
  - COPY-module-story-donation
  - COPY-module-application
  - COPY-module-auth
  - COPY-module-account
---

# COPY Key Index — Consolidated i18n Key Table

## Purpose

Consolidated, cross-scope index of every COPY key produced by AR:COPYSynthesizer, in one flat
table for i18n extraction and rebuild consumption. Source of truth for each key remains its owning
`_ar/spec-draft/COPY/COPY-<scope>.md` file — this index restates key, text, usage and trigger for
lookup convenience and does not introduce new facts. Text is transcribed verbatim from observed UI
per `tooling/docs/rules-COPY.md`; rows with no directly observed text carry `(not observed)` and a
`Certainty` of `Uncertain`/`Evidence Pending` rather than an invented string.

Column legend:

- **Key** — i18n key, `<scope>.<screen-or-component>.<role>`
- **Text (verbatim)** — the observed Czech string, or `(not observed)` if only implied
- **Usage (WIRE/COMP)** — screen/component where the text appears
- **Trigger (BR/EN/UC)** — for validation messages: the governing `BRxxxx`/`ENxxxx`; for CTAs: the
  realized `UCxxxx`; `—` where the row is a label/helper/empty/loading string with no trigger role;
  `Open Question` where a trigger is implied but no owning document was found
- **Certainty** — `Confirmed` / `Assumed` / `Uncertain` / `Hypothesis` / `Evidence Pending`

Total keys indexed: **242** across 5 scopes (see `COPY-synthesis-report.md` §2 for the per-scope
breakdown and reconciliation against each scope's self-reported `keyCount`).

---

## Scope: shared-global

Source: `_ar/spec-draft/COPY/COPY-shared-global.md`

| Key | Text (verbatim) | Usage (WIRE/COMP) | Trigger (BR/EN/UC) | Certainty |
|---|---|---|---|---|
| `shared-global.header.logo` | `patron dětí` | COMP0002 | — | Confirmed |
| `shared-global.header.tagline` | `společně za lepší dětství` | COMP0002 | — | Confirmed |
| `shared-global.footer.brand-heading` | `patron dětí` | COMP0003 | — | Confirmed |
| `shared-global.footer.brand-blurb` | `Patron dětí je charitativní projekt, který pomáhá zdravotně a sociálně znevýhodněným dětem a jejich rodinám z celé České republiky.` | COMP0003 | — | Confirmed |
| `shared-global.footer.social-label` | `Sledujte nás na` | COMP0003 | — | Confirmed |
| `shared-global.footer.sirius-attribution` | `Patron dětí je projektem Nadace Sirius` | COMP0003 | — | Confirmed |
| `shared-global.footer.collection-registration` | `Zaregistrovaná veřejná sbírka: Sp. zn. S-MHMP/836092/2017` | COMP0003 | — | Confirmed |
| `shared-global.footer.column-heading.patron-deti` | `Patron dětí` | COMP0003 | — | Confirmed |
| `shared-global.footer.column-heading.kontakt` | `Kontakt` | COMP0003 | — | Confirmed |
| `shared-global.footer.contact-email-label` | `E-mail` | COMP0003 | — | Confirmed |
| `shared-global.footer.contact-email-value` | `info@patrondeti.cz` | COMP0003 | — | Confirmed |
| `shared-global.footer.payments-label` | `Platby zprostředkovává:` | COMP0003 | — | Confirmed |
| `shared-global.footer.collection-account-label` | `Číslo sbírkového účtu: 57574646/0600` | COMP0003 | — | Confirmed |
| `shared-global.footer.copyright` | `© 2026 Patron dětí. Všechna práva vyhrazena.` | COMP0003 | — | Confirmed |
| `shared-global.nav.how-it-works` | `Jak to funguje` | COMP0002 | Open Question — no UCxxxx owns this nav target | Confirmed text |
| `shared-global.nav.blog` | `Blog` | COMP0002 | Open Question — no UCxxxx owns this nav target | Confirmed text |
| `shared-global.nav.o-nas` | `O nás` | COMP0002 | Open Question — no UCxxxx owns this nav target | Confirmed text |
| `shared-global.nav.pozadat-o-pomoc-cta` | `Požádat o pomoc` | COMP0002 | UC0001 | Confirmed |
| `shared-global.nav.muj-ucet-cta` | `Můj účet` | COMP0002 | UC0014 | Confirmed |
| `shared-global.footer.link.o-nas` | `O nás` | COMP0003 | Open Question — no UCxxxx owns this nav target | Confirmed text |
| `shared-global.footer.link.blog` | `Blog` | COMP0003 | Open Question — no UCxxxx owns this nav target | Confirmed text |
| `shared-global.footer.link.pravidla` | `Pravidla poskytování pomoci` | COMP0003 | Open Question (IA-Q8) | Confirmed text |
| `shared-global.footer.link.desatero` | `Naše desatero` | COMP0003 | Open Question (IA-Q8) | Confirmed text |
| `shared-global.footer.link.splnene-pribehy` | `Splněné příběhy` | COMP0003 | Open Question (IA-Q8) | Confirmed text |
| `shared-global.footer.link.vyrocni-zpravy` | `Výroční zprávy` | COMP0003 | Open Question (IA-Q8) | Confirmed text |
| `shared-global.footer.link.koronakrize` | `Jak jsme pomáhali v době koronakrize` | COMP0003 | Open Question (IA-Q8) | Confirmed text |
| `shared-global.footer.link.gdpr-consent` | `Souhlas se zpracováním osobních údajů` | COMP0003 | Open Question (IA-Q8) | Confirmed text |
| `shared-global.footer.link.chci-prihlasit-pribeh` | `Chci přihlásit příběh` | COMP0003 | UC0001 | Confirmed |
| `shared-global.cookie-banner.accept-cta` | `Přijímám` | COMP0004 | Open Question — no BR governs cookie consent | Confirmed text |
| `shared-global.cookie-banner.reject-cta` | `Odmítnout` | COMP0004 | Open Question — no BR governs cookie consent | Confirmed text |
| `shared-global.cookie-banner.more-info-cta` | `Další informace` | COMP0004 | Open Question | Confirmed text |
| `shared-global.cookie-banner.modal-more-info-cta` | `Více zde.` | COMP0004 | Open Question | Confirmed text |
| `shared-global.cookie-banner.customize-cta` | `Přizpůsobit` | COMP0004 | Open Question | Confirmed text |
| `shared-global.cookie-banner.modal-reject-cta` | `Odmítnout` | COMP0004 | Open Question | Confirmed text |
| `shared-global.cookie-banner.modal-accept-all-cta` | `Přijmout vše` | COMP0004 | Open Question — no BR governs cookie consent | Confirmed text |
| `shared-global.cookie-banner.dual.modal-heading` | `Záleží nám na vašem soukromí` | WIRE0001 (S001, dual-action) | — | Confirmed |
| `shared-global.cookie-banner.dual.modal-body` | `Pomocí cookies vylepšujeme příjemnost prohlížení, nabízíme na míru přizpůsobené reklamy či obsah a analyzujeme návštěvnost stránky. Kliknutím na „Přijmout vše" vyjadřujete souhlas s tím, jak cookies používáme.` | WIRE0001 (S001, dual-action) | — | Confirmed |
| `shared-global.cookie-banner.single.body` | `🍪 Tyto stránky používají k poskytování služeb soubory cookie. Používáním tohoto webu s tím souhlasíte. Další informace.` | WIRE0006/WIRE0007/WIRE0013/WIRE0024 | — | Confirmed |

**Scope subtotal: 38 keys.**

---

## Scope: module-story-donation

Source: `_ar/spec-draft/COPY/COPY-module-story-donation.md`

| Key | Text (verbatim) | Usage (WIRE/COMP) | Trigger (BR/EN/UC) | Certainty |
|---|---|---|---|---|
| `module-story-donation.homepage.hero-headline-line1` | `DARUJME DĚTEM ŠANCI` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.hero-headline-line2` | `za jedno kafe měsíčně` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.stat-strip-number` | `323 dětí` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.stat-strip-caption` | `čeká na pomoc` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.filter-tab-remaining` | `Zbývající částka` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.filter-tab-single-parents` | `Samoživitelé` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.filter-tab-regions` | `Filtrovat podle krajů` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.filter-tab-ending-soon` | `Brzy skončí` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.region-map-heading` | `Vyberte kraj na mapě` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.story-card-remaining-label` | `Zbývá` | WIRE0001, COMP0008 | — | Confirmed |
| `module-story-donation.homepage.story-card-target-label` | `Cílová částka` | WIRE0001, COMP0008 | — | Confirmed |
| `module-story-donation.homepage.story-card-collection-ribbon` | `SBÍRKOVÝ ÚČET` | WIRE0001, COMP0008 | — | Confirmed |
| `module-story-donation.homepage.story-card-collection-title` | `Necháte výběr dítěte, kterému chcete pomoct na nás?` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.testimonial-heading` | `Poděkování od rodin` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.testimonial-intro` | `Každý příběh je důkazem toho, že společně dokážeme udělat svět lepším místem pro děti, které to nejvíce potřebují. Vaše podpora a laskavost dávají rodinám naději a dětem radost, kterou si zaslouží.` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.voucher-band-heading` | `Dobrošeky pro lepší dětství` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.voucher-band-intro` | `Dobrošeky můžete koupit i darovat online, nebo si je poslat do emailu a vytisknout jako dárek. Každý obdarovaný si pak na našem webu vybere dětský příběh, kterému mu bude nejbližší a na který svým dobrošekem přispěje.` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.voucher-card-title` | `Pro lepší dětství` | WIRE0001 (repeats on all 6 denomination cards) | — | Confirmed |
| `module-story-donation.homepage.how-it-works-heading` | `Jak to funguje?` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.how-it-works-col1-title` | `Vše začíná příběhem` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.how-it-works-col2-title` | `Společně zvládneme víc!` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.how-it-works-col3-title` | `Jen na vás záleží…` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.patron-explainer-heading` | `Kdo je to Patron příběhu?` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.patron-explainer-body` | `Každý příběh má svého Patrona. Ten je pro dárce zárukou důvěryhodnosti. Patronem se může stát kdokoli, kdo zná dítě z příběhu – učitel, vedoucí kroužku nebo sociální pracovník. Znáte dítě, které potřebuje naši pomoc? Staňte se Patronem i vy.` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.sponsors-heading` | `Podporují nás` | WIRE0001 | — | Confirmed |
| `module-story-donation.homepage.partners-heading` | `Spřátelené organizace` | WIRE0001 | — | Confirmed |
| `module-story-donation.story-detail.category-tag` | `Rozvoj a vzdělání` | WIRE0002 (data-driven, EN0004) | — | Confirmed (instance value) |
| `module-story-donation.story-detail.contribute-heading` | `Přispět můžete na` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.in-kind-description` | `balík školních potřeb; dodává SEVT` | WIRE0002 (data-driven, EN0004) | — | Confirmed (instance value) |
| `module-story-donation.story-detail.progress-missing-label` | `Chybí {amount} Kč` | WIRE0002 (instance: "Chybí 1 600 Kč") | — | Confirmed |
| `module-story-donation.story-detail.progress-remaining-label` | `Zbývá` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.progress-remaining-value` | `měsíc` | WIRE0002 (instance value) | — | Confirmed |
| `module-story-donation.story-detail.progress-target-label` | `Cílová částka` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.amount-input-label` | `Chci darovat` | WIRE0002 (default value 50, suffix Kč) | — | Confirmed |
| `module-story-donation.story-detail.patron-card-label` | `PATRON PŘÍBĚHU` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.recurring-heading` | `Přeji si podporovat rozvoj a vzdělání pravidelně` | WIRE0002 (category name data-driven, EN0004) | — | Confirmed |
| `module-story-donation.story-detail.voucher-cta-question` | `Chcete věnovat dobrošek?` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.share-heading` | `Sdílet příběh:` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.related-stories-heading` | `Aktuálně čekají na vaši pomoc` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.trust-banner` | `Na pomoc dětem putuje vždy 100 % částky, kterou darujete.` | WIRE0002 | — | Confirmed |
| `module-story-donation.donation-modal.title` | `Chystáte se přispět` | WIRE0002 | — | Confirmed |
| `module-story-donation.donation-modal.amount-field-label` | `Kč` | WIRE0002 (unit suffix) | — | Confirmed |
| `module-story-donation.donation-modal.email-label` | `E-mail (povinný)` | WIRE0002 | — | Confirmed |
| `module-story-donation.donation-modal.phone-prefix-label` | `+420` | WIRE0002 | — | Confirmed |
| `module-story-donation.donation-modal.phone-field-placeholder` | `Telefon` | WIRE0002 | — | Confirmed |
| `module-story-donation.donation-modal.firstname-field-placeholder` | `Jméno` | WIRE0002 | — | Confirmed |
| `module-story-donation.donation-modal.lastname-field-placeholder` | `Příjmení` | WIRE0002 | — | Confirmed |
| `module-story-donation.thankyou.headline` | `Platba proběhla úspěšně, děkujeme za pomoc!` | WIRE0003 | — | Confirmed |
| `module-story-donation.thankyou.body-1` | `Každý příspěvek pomáhá k lepšímu dětství. Děkujeme, že jste s námi.` | WIRE0003 | — | Confirmed |
| `module-story-donation.thankyou.body-2` | `Platba proběhla úspěšně! Moc děkujeme. Prosíme, sdílejte a pomozte příběhu, kterému jste právě přispěli.` | WIRE0003 | — | Confirmed |
| `module-story-donation.thankyou.resume-modal-title` | `Máte u nás rozpracovanou žádost.` | WIRE0003 (co-resident overlay, UC0025) | UC0025 | Confirmed |
| `module-story-donation.thankyou.resume-modal-body` | `Vypadá to, že jste u nás nechali rozpracovanou žádost. Pro návrat do formuláře můžete použít tlačítka níže, případně lze využít odkaz v hlavičce.` | WIRE0003 | UC0025 | Confirmed |
| `module-story-donation.thankyou.resume-modal-delete-prompt` | `Přejete si žádost o pomoc zcela zrušit?` | WIRE0003 | UC0025 | Confirmed |
| `module-story-donation.donation-modal.donation-integrity-note` | `Na pomoc dětem putuje vždy 100 % z darované částky.` | WIRE0002 | — | Confirmed |
| `module-story-donation.donation-modal.consent-manage-note` | `Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz.` | WIRE0002, COMP0006 | — | Confirmed |
| `module-story-donation.donation-modal.gateway-choice-note` | `Po přesměrování na platební bránu si budete moci vybrat mezi online platbou (kartou) a expresním bankovním převodem.` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.trust-list-item-1` | `100 % daru jde na pomoc dětem,` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.trust-list-item-2` | `peníze neposíláme rodinám, ale hradíme za ně konkrétní školní potřeby,` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.trust-list-item-3` | `všechny žádosti pečlivě posuzuje naše oddělení risku,` | WIRE0002 | — | Confirmed |
| `module-story-donation.story-detail.trust-list-item-4` | `každou žádost potvrzuje Patron – například sociální pracovník, učitel nebo vedoucí zájmového kroužku` | WIRE0002 | — | Confirmed |
| (unkeyed) empty-state, S001/S002/S005 | `(not observed)` | WIRE0001 States→empty, WIRE0002 States→empty, WIRE0004 | Open Question | Evidence Pending |
| (unkeyed) loading, S001/S002/S003/S005 | `(not observed)` | WIRE0001/WIRE0002/WIRE0003/WIRE0004 States→loading | Open Question | Evidence Pending |
| (unkeyed) donation-modal amount validation error | `(not observed)` | WIRE0002 Validation Surfaces | Open Question (UC0005 AF1, no BR) | Uncertain |
| (unkeyed) donation-modal fully-funded error | `(not observed)` | WIRE0002 | Open Question (UC0005 AF2 / BR-PaymentAndMoneyIntegrity) | Uncertain |
| (unkeyed) donation-modal email-required error | `(not observed)` | WIRE0002 | Open Question | Uncertain |
| (unkeyed) donation-modal consent-1 gate error | `(not observed)` | WIRE0002 | Open Question | Uncertain |
| (unkeyed) donation-modal consent-2 gate error | `(not observed)` | WIRE0002 | Open Question (BR-DataProtectionAndErasure covers GDPR generally, not this checkbox gate) | Uncertain |
| `module-story-donation.homepage.hero-preset-cta-90` | `Daruj 90 Kč měsíčně` | WIRE0001 (Interactions #8) | Open Question — hand-off target unclear | Confirmed text |
| `module-story-donation.homepage.hero-preset-cta-290` | `Daruj 290 Kč měsíčně` | WIRE0001 | Open Question | Confirmed text |
| `module-story-donation.homepage.hero-preset-cta-custom` | `Daruj měsíčně podle sebe` | WIRE0001 | Open Question | Confirmed text |
| `module-story-donation.homepage.category-cta-health` | `Zdravotní pomoc` | WIRE0001 (Interactions #9) | Open Question — no UC id available | Confirmed text |
| `module-story-donation.homepage.category-cta-education` | `Rozvoj a vzdělání` | WIRE0001 | Open Question | Confirmed text |
| `module-story-donation.homepage.story-card-cta-named` | `Podpořím {jméno}` | WIRE0001 (Main Flow 13–14) | UC0023 → UC0005 | Confirmed |
| `module-story-donation.homepage.story-card-cta-collection` | `Nechám to na vás` | WIRE0001 (mechanism Partial) | UC0023 | Confirmed |
| `module-story-donation.homepage.more-stories-link` | `Další příběhy` | WIRE0001 (Interactions #10) | Open Question — no UC id available | Confirmed text |
| `module-story-donation.homepage.voucher-purchase-cta` | `Koupím dobrošek` | WIRE0001 → S005/WIRE0004 | UC0009 | Confirmed |
| `module-story-donation.homepage.patron-cta` | `Chci se stát Patronem` | WIRE0001 (Interactions #13) | Open Question — no UC evidenced | Confirmed text |
| `module-story-donation.story-detail.donate-cta` | `Přispět 🤝` | WIRE0002 (Interactions #2) | UC0005 | Confirmed |
| `module-story-donation.story-detail.recurring-cta` | `Chci podporovat rozvoj a vzdělání` | WIRE0002 (Interactions #4, Open Question WIRE0002-Q2) | UC0005.2 (Assumed) | Assumed |
| `module-story-donation.story-detail.voucher-cta` | `Mám dobrošek` | WIRE0002 (Interactions #5, Open Question WIRE0002-Q3) | UC0009 (Assumed) | Assumed |
| `module-story-donation.story-detail.patron-comment-toggle` | `Zobrazit komentář Patrona` | WIRE0002 (Interactions #6, Open Question WIRE0002-Q6) | Open Question — no UC | Assumed |
| `module-story-donation.story-detail.related-story-cta` | `Podpořím {jméno}` (observed: Podpořím Románka / Petrušku / Miu) | WIRE0002 (Interactions #8) | — (navigates to that Story's own S002) | Confirmed |
| `module-story-donation.story-detail.more-stories-link` | `Další příběhy` | WIRE0002 (Interactions #8) | Open Question — assumed return to S001 | Assumed |
| `module-story-donation.donation-modal.back-link` | `Zpět na příběh` | WIRE0002 (Interactions #9) | — (closes modal, no state change) | Confirmed |
| `module-story-donation.donation-modal.consent-1-label` | `Souhlasím s pravidly poskytování pomoci projektu Patron.` | WIRE0002 Validation Surfaces, COMP0006 | Open Question — no owning BRxxxx (gates UC0005 submission) | Confirmed text |
| `module-story-donation.donation-modal.consent-2-label` | `Souhlasím se zpracováním osobních údajů a informováním o projektu` | WIRE0002 Validation Surfaces, COMP0006 | Open Question — no owning BRxxxx (gates UC0005 submission) | Confirmed text |
| `module-story-donation.donation-modal.submit-cta` | `Přejít k platbě` | WIRE0002 (Main Flow UC0005.1–.3) | UC0005 | Confirmed |
| `module-story-donation.thankyou.back-home-cta` | `Zpět na hlavní stránku` | WIRE0003 (Interactions #2) | — (plain navigation, not status-changing) | Confirmed |
| `module-story-donation.thankyou.resume-modal-resume-cta` | `Návrat do žádosti` | WIRE0003 | UC0025 (resume branch) | Confirmed |
| `module-story-donation.thankyou.resume-modal-stay-cta` | `Zůstat na stránce` | WIRE0003 | UC0025 (dismiss branch) | Confirmed |
| `module-story-donation.thankyou.resume-modal-delete-cta` | `Smazat žádost` | WIRE0003 | UC0025 (discard branch) | Confirmed |
| `module-story-donation.voucher-purchase.entry-cta` | `Koupím dobrošek` | WIRE0004 (duplicate of homepage CTA) | UC0009 | Confirmed |

**Scope subtotal: 85 keys** (per source-file self-report; 8 rows above are unkeyed validation/empty/loading placeholders carried into this index for completeness — see `COPY-synthesis-report.md` §4 for reconciliation).

---

## Scope: module-application

Source: `_ar/spec-draft/COPY/COPY-module-application.md`

| Key | Text (verbatim) | Usage (WIRE/COMP) | Trigger (BR/EN/UC) | Certainty |
|---|---|---|---|---|
| `module-application.contact-gate.heading` | `Začneme tím, že nám sdělíte váš telefon a e-mail` | WIRE0006 | — | Confirmed |
| `module-application.contact-gate.panel-heading` | `Údaje o Vás` | WIRE0006 | — | Confirmed |
| `module-application.contact-gate.email-placeholder` | `E-mail` | WIRE0006 | — | Confirmed |
| `module-application.contact-gate.phone-prefix` | `+420` | WIRE0006 | — | Confirmed |
| `module-application.contact-gate.phone-placeholder` | `Telefon` | WIRE0006 | — | Confirmed |
| `module-application.contact-gate.faq-heading` | `Často kladené otázky` | WIRE0006 | — | Confirmed |
| `module-application.contact-gate.faq-question-1` | `Proč musí mít každé dítě svou vlastní žádost o dar?` | WIRE0006 | — | Confirmed |
| `module-application.contact-gate.faq-question-2` | `Proč musí mít každý příběh svého Patrona?` | WIRE0006 | — | Confirmed |
| `module-application.step1.stepper-1` | `Příběh` | WIRE0007–WIRE0011, COMP0005 | — | Confirmed |
| `module-application.step1.stepper-2` | `Dar` | WIRE0007–WIRE0011, COMP0005 | — | Confirmed |
| `module-application.step1.stepper-3` | `O Vás` | WIRE0007–WIRE0011, COMP0005 | — | Confirmed |
| `module-application.step1.stepper-4` | `Patron` | WIRE0007–WIRE0011, COMP0005 | — | Confirmed |
| `module-application.step1.stepper-5` | `Přílohy` | WIRE0007–WIRE0011, COMP0005 | — | Confirmed |
| `module-application.step1.heading` | `Krok 1: Váš příběh` | WIRE0007 | — | Confirmed |
| `module-application.step1.child-name-section-heading` | `Dovolte nám vaše dítě lépe poznat` | WIRE0007 | — | Confirmed |
| `module-application.step1.child-firstname-heading` | `Jméno a příjmení dítěte` | WIRE0007 | — | Confirmed |
| `module-application.step1.child-firstname-placeholder` | `Jméno` | WIRE0007 | — | Confirmed |
| `module-application.step1.child-lastname-placeholder` | `Příjmení` | WIRE0007 | — | Confirmed |
| `module-application.step1.child-rc-heading` | `Rodné číslo dítěte (cizinec: číslo pojištěnce)` | WIRE0007 | — | Confirmed |
| `module-application.step1.child-like-heading` | `Jaké je vaše dítě a co má rádo?` | WIRE0007 | — | Confirmed |
| `module-application.step1.health-checkbox-label` | `Je Vaše dítě zdravotně znevýhodněné?` | WIRE0007 | — | Confirmed |
| `module-application.step1.health-problems-heading` | `S čím se vaše dítě potýká a jakou potřebuje pomoc?` | WIRE0007 | — | Confirmed |
| `module-application.step1.health-problems-subquestion` | `Má vaše dítě specifický zdravotní problém?` | WIRE0007 | — | Confirmed |
| `module-application.step1.prior-collection-heading` | `Mate nebo měli jste sbírku u jiné nadace v posledních 6 měsících?` (verbatim typo "Mate") | WIRE0007 | — | Confirmed |
| `module-application.step1.prior-collection-option-yes` | `ANO` | WIRE0007 | — | Confirmed |
| `module-application.step1.prior-collection-option-no` | `NE` | WIRE0007 (default) | — | Confirmed |
| `module-application.step1.nationality-heading` | `Žádám o pomoc pro dítě, které nemá českou národnost` | WIRE0007 | — | Confirmed |
| `module-application.step1.nationality-option-yes` | `ANO` | WIRE0007 | — | Confirmed |
| `module-application.step1.nationality-option-no` | `NE` | WIRE0007 (default) | — | Confirmed |
| `module-application.step2.heading` | `Krok 2: Dar, kterým vám pomůžeme` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-picker-heading` | `Rychlá volba daru:` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-1` | `ŠVP, jazykový kurz, školní výlety` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-2` | `Lyžařský kurz` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-3` | `Kroužky, soustředění a vybavení pro ně` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-4` | `Tábory – pobytové, příměstské` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-5` | `Školné a internát` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-6` | `Notebook` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-7` | `Automobil jako zdravotní pomůcka` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-8` | `Pomůcky a služby pro zdravotně znevýhodněné děti` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-9` | `Balík školních potřeb` | WIRE0008 | — | Confirmed |
| `module-application.step2.org-name-heading-default` | `Název a adresa školy poskytující aktivity` | WIRE0008 | — | Confirmed |
| `module-application.step2.org-name-placeholder-default` | `Název a adresa školy` | WIRE0008 | — | Confirmed |
| `module-application.step2.org-name-heading-tabory` | `Název a adresa organizátora tábora` | WIRE0008 (EN0033 override) | — | Confirmed |
| `module-application.step2.contact-person-heading` | `Kontaktní osoba` | WIRE0008 | — | Confirmed |
| `module-application.step2.contact-person-placeholder` | `Kontaktní osoba` | WIRE0008 | — | Confirmed |
| `module-application.step2.contact-phone-heading` | `Telefonní číslo na kontaktní osobu` | WIRE0008 | — | Confirmed |
| `module-application.step2.contact-phone-placeholder` | `Telefonní číslo` | WIRE0008 | — | Confirmed |
| `module-application.step2.contact-email-heading` | `E-mail na kontaktní osobu` | WIRE0008 | — | Confirmed |
| `module-application.step2.contact-email-placeholder` | `E-mail` | WIRE0008 | — | Confirmed |
| `module-application.step2.gift-help-heading` | `Jak dar dítěti konkrétně pomůže?` | WIRE0008 | — | Confirmed |
| `module-application.step2.attachment-heading-default` | `Zde přiložte přihlášku na školní akci nebo informační leták` | WIRE0008 | — | Confirmed |
| `module-application.step2.attachment-heading-tabory` | `Zde přiložte přihlášku na tábor` | WIRE0008 | — | Confirmed |
| `module-application.step2.upload-dropzone-instruction` | `Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači` | WIRE0008, COMP0007 | — | Confirmed |
| `module-application.step2.tabory-term-heading` | `V jaké termínu se tábor uskuteční` (verbatim typo) | WIRE0008 | — | Confirmed |
| `module-application.step2.tabory-term-placeholder` | `Termín` | WIRE0008 | — | Confirmed |
| `module-application.step2.total-cost-heading` | `Celková částka na pořízení daru` | WIRE0008 | — | Confirmed |
| `module-application.step2.total-cost-suffix` | `Kč` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-expand-cta` | `Více informací` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-collapse-cta` | `Zobrazit méně` | WIRE0008 | — | Confirmed |
| `module-application.step2.category-select-cta` | `Vybrat` | WIRE0008 | — | Confirmed |
| `module-application.step2.faq-heading` | `Často kladené otázky` | WIRE0008 | — | Confirmed |
| `module-application.step2.faq-question-1` | `Proč vyžadujeme po všech obdarovaných důkaz o tom, jak dar využívají?` | WIRE0008 | — | Confirmed |
| `module-application.step3.heading` | `Krok 3: Údaje o vás` | WIRE0009 | — | Confirmed |
| `module-application.step3.name-heading` | `Vaše jméno a příjmení` | WIRE0009 | — | Confirmed |
| `module-application.step3.firstname-placeholder` | `Jméno` | WIRE0009 | — | Confirmed |
| `module-application.step3.lastname-placeholder` | `Příjmení` | WIRE0009 | — | Confirmed |
| `module-application.step3.rc-heading` | `Rodné číslo rodiče (cizinec: číslo pojištěnce)` | WIRE0009 | — | Confirmed |
| `module-application.step3.address-heading` | `Adresa vašeho trvalého bydliště` | WIRE0009 | — | Confirmed |
| `module-application.step3.street-placeholder` | `Ulice a číslo popisné` | WIRE0009 | — | Confirmed |
| `module-application.step3.city-placeholder` | `Město` | WIRE0009 | — | Confirmed |
| `module-application.step3.zip-placeholder` | `PSČ` | WIRE0009 | — | Confirmed |
| `module-application.step3.mailing-address-checkbox-label` | `Zastihnete mě na jiné než trvalé adrese.` | WIRE0009 | — | Confirmed |
| `module-application.step3.single-parent-checkbox-label` | `Jsem samoživitel` | WIRE0009 | — | Confirmed |
| `module-application.step3.contact-heading` | `Vaše kontaktní údaje` | WIRE0009 | — | Confirmed |
| `module-application.step3.email-placeholder` | `E-mail` | WIRE0009 | — | Confirmed |
| `module-application.step3.phone-prefix` | `+420` | WIRE0009 | — | Confirmed |
| `module-application.step3.employed-heading` | `Jste zaměstnán? (pokud nejste zaměstnán, doložte evidenci na ÚP v kroku 5.)` | WIRE0009 | — | Confirmed |
| `module-application.step3.employed-option-yes` | `ANO` | WIRE0009 | — | Confirmed |
| `module-application.step3.employed-option-no` | `NE` | WIRE0009 (default) | — | Confirmed |
| `module-application.step4.heading` | `Krok 4: Údaje o vašem Patronovi` | WIRE0010 | — | Confirmed |
| `module-application.step4.name-heading` | `Jméno a příjmení vašeho Patrona` | WIRE0010 | — | Confirmed |
| `module-application.step4.firstname-placeholder` | `Jméno` | WIRE0010 | — | Confirmed |
| `module-application.step4.lastname-placeholder` | `Příjmení` | WIRE0010 | — | Confirmed |
| `module-application.step4.relationship-heading` | `V jakém vztahu je k vám nebo k vaší rodině?` | WIRE0010 | — | Confirmed |
| `module-application.step4.relationship-option-familyfriend` | `Rodinný známý` | WIRE0010 (only observed option) | — | Confirmed (partial list) |
| `module-application.step4.contact-heading` | `Kontaktní údaje na Patrona` | WIRE0010 | — | Confirmed |
| `module-application.step4.email-placeholder` | `E-mail` | WIRE0010 | — | Confirmed |
| `module-application.step4.phone-prefix` | `+420` | WIRE0010 | — | Confirmed |
| `module-application.step4.phone-placeholder` | `Telefon` | WIRE0010 | — | Confirmed |
| `module-application.step5.heading` | `Krok 5: Přílohy a fotografie` | WIRE0011 | — | Confirmed |
| `module-application.step5.images-section-heading` | `Povinné obrazové přílohy` | WIRE0011 | — | Confirmed |
| `module-application.step5.id-section-heading` | `Fotka Vašeho dokladu totožnosti s fotkou (občanský průkaz, pas):` | WIRE0011 | — | Confirmed |
| `module-application.step5.birth-cert-section-heading` | `Fotka nebo kopie rodného listu dítěte, případně rozhodnutí soudu o svěření do péče.` | WIRE0011 | — | Confirmed |
| `module-application.step5.upload-dropzone-instruction` | `Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači.` | WIRE0011, COMP0007 | — | Confirmed |
| `module-application.step5.upload-example-badge` | `PŘÍKLAD` | WIRE0011 | — | Confirmed |
| `module-application.step5.referral-heading` | `Odkud jste se dozvěděli o projektu Patron dětí?` | WIRE0011 | — | Confirmed |
| `module-application.step5.exit-modal-heading` | `Chystáte se opustit žádost.` | WIRE0011 | — | Confirmed |
| `module-application.contact-gate.privacy-helper` | `Kontaktní údaje nikde nezveřejňujeme ani je neposkytujeme komukoli dalšímu.` | WIRE0006 | — | Confirmed |
| `module-application.contact-gate.documents-helper` | `Pokud žádáte o dar pro své dítě, budete k vyplnění žádosti potřebovat jeho rodný list a svůj občanský průkaz.` | WIRE0006 | — | Confirmed |
| `module-application.contact-gate.consent-manage-helper` | `Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz.` | WIRE0006 | — | Confirmed |
| `module-application.step1.intro-1` | `Jsme tu pro vás a chceme dopřát vašim dětem to, co skutečně potřebují. Vše začíná touto žádostí, ve které nám dovolte vás lépe poznat.` | WIRE0007 | — | Confirmed |
| `module-application.step1.intro-2` | `Pokud žádáte pro více dětí, vyplňte prosím pro každé z nich vlastní žádost. Žádost musí být vyplněna česky.` | WIRE0007 | — | Confirmed |
| `module-application.step1.story-textarea-helper` | `Řekněte nám více o sobě a o své rodině, o tom, kde žijete a proč potřebujete pomoci. Jednoduše, pomozte nám více porozumět vaší situaci.` | WIRE0007 | — | Confirmed |
| `module-application.step1.story-textarea-placeholder` | `Např.: Jsem rozvedená a žiji s dětmi sama. Kromě Honzíka, kterému zde žádám o dar, mám ještě dceru Natálku. Honzík má vrozenou vadu mozku a trpí epilepsií. Kvůli tomu bohužel nechodí a umí se jen převrátit na bříško a zpátky. Aby se mu ulevilo, potřebuje pravidelné rehabilitace, které si nemůžu dovolit. Rehabilitace nám dávají šanci, že se jednou postaví na vlastní nohy.` | WIRE0007 | — | Confirmed |
| `module-application.step1.child-like-placeholder` | `Např.: Honzík rád kreslí a miluje modrou barvu.` | WIRE0007 | — | Confirmed |
| `module-application.step1.health-problems-helper` | `Pokud ano, pomozte nám pochopit, co ho trápí a jak se mu může ulevit. Nebojte se rozepsat, informace mohou u příběhu na webu pomoci dárcům v rozhodování, zda na příběh přispějí či ne.` | WIRE0007 | — | Confirmed |
| `module-application.step1.health-problems-placeholder` | `Např.: Honzík má vrozenou vadu mozku. To znamená, že je oproti svým vrstevníkům opožděný ve vývoji. Ve svých dvou letech se zvládne pouze přetočit na bříško a zpátky. Jinak vyžaduje celodenní péči. Honzíkovi hodně prospívají speciální neurorehabilitace. Jsou finančně velmi nákladné, ale výsledky se dostavují. Proto bychom je rádi opakovali, co nejvíce to půjde. V dnešní době je bohužel většina terapií a rehabilitací pro takové děti brána jako jakýsi nadstandard, za který si rodiče musí připlatit... atd.` | WIRE0007 | — | Confirmed |
| `module-application.step1.duplicate-collection-warning` | `Pokud založíte v průběhu sbírky novou, duplicitní sbírku u jiného charitativního subjektu, informujte neprodleně Nadaci Sirius.` | WIRE0007 | — | Confirmed |
| `module-application.step2.gift-help-helper` | `Tato informace může pomoci dárcům v rozhodování, zda přispějí či ne, buďte proto konkrétní a nebojte se popsat detaily tak, aby je každý pochopil.` | WIRE0008 | — | Confirmed |
| `module-application.step2.gift-help-placeholder` | `Např.: Honzík házenou miluje a chodí na ni už několik let; rehabilitace jsou pro Markétku jedinou nadějí, že někdy bude sama chodit…` | WIRE0008 | — | Confirmed |
| `module-application.step2.total-cost-helper` | `Pokud je součástí daru více předmětů nebo služeb, sečtěte je.` | WIRE0008 | — | Confirmed |
| `module-application.step2.tabory-description` | `Požádat můžete o jakékoli tábory anebo soustředění v kterékoli roční době. Pokud je dodavatel stejný, můžete požádat o více aktivit najednou. Např. sportovní soustředění v červenci a srpnu, nebo příměstský tábor na jaře a pobytový tábor v létě apod. V žádosti je nutné uvést celkovou cenu a kontakt na poskytovatele služby.` | WIRE0008 | — | Confirmed |
| `module-application.step3.intro` | `Abychom vám mohli pomoci, potřebujeme o vás bližší informace.` | WIRE0009 | — | Confirmed |
| `module-application.step3.single-parent-definition` | `Samoživitel = Zákonný zástupce dítěte, který vede samostatnou domácnost, ve které je jedinou dospělou osobou, žijící s nezaopatřenými dětmi` | WIRE0009 | — | Confirmed |
| `module-application.step3.contact-helper` | `Na těchto údajích vás musíme zastihnout, zkontrolujte prosím jejich správnost.` | WIRE0009 | — | Confirmed |
| `module-application.step3.info-banner-lead` | `V případě změny údajů` | WIRE0009 | — | Confirmed |
| `module-application.step3.info-banner-body` | `nám nezapomeňte dát hned vědět. Ať se k vám pomoc dostane co nejrychleji.` | WIRE0009 | — | Confirmed |
| `module-application.step4.intro-1` | `Každý dětský příběh u nás na webu potřebuje mít svého Patrona. Pro dárce je Patron zárukou důvěryhodnosti vašeho příběhu.` | WIRE0010 | — | Confirmed |
| `module-application.step4.intro-2` | `Patronem se může stát kdokoliv, kdo má k dítěti blízký vztah, s jedinou výjimkou a tou je rodinný příslušník. Patronem nesmí být: matka, otec, babička, strýc, teta atd.` | WIRE0010 | — | Confirmed |
| `module-application.step4.intro-3` | `Může to být například učitel, vedoucí zájmového kroužku, pracovník OSPOD atd.` | WIRE0010 | — | Confirmed |
| `module-application.step4.contact-helper` | `Informujte svého Patrona o tom, že uvádíte jeho údaje, budeme ho ihned kontaktovat emailem.` | WIRE0010 | — | Confirmed |
| `module-application.step5.intro` | `Pro zveřejnění příběhu na našich stránkách potřebujeme, abyste nahráli fotografii vašeho dítěte a dvě povinné přílohy: občanský průkaz a rodný list dítěte.` | WIRE0011 | — | Confirmed |
| `module-application.step5.images-instructions-lead` | `Každý příběh musí obsahovat alespoň jeden obrázek, který příběh lépe přiblíží dárcům. Na výběr máte:` | WIRE0011 | — | Confirmed |
| `module-application.step5.images-instructions-option-1` | `Fotografii dítěte – preferovaná varianta. Fotografie může být anonymní (např. dítě zezadu, z dálky apod.), aby byla chráněna identita dítěte.` | WIRE0011 | — | Confirmed |
| `module-application.step5.images-instructions-option-2` | `Obrázek namalovaný dítětem – například z letního tábora, kroužku, nebo ilustrace předmětu, který souvisí s potřebou (např. hudební nástroj, sportovní vybavení).` | WIRE0011 | — | Confirmed |
| `module-application.step5.images-instructions-option-3` | `Krátký text „vzkaz/dopis pro dárce", který dítě napíše nebo nadiktuje (ručně psaný nebo vyfocený).` | WIRE0011 | — | Confirmed |
| `module-application.step5.exit-modal-body` | `Pokud žádost nyní opustíte, můžete se k ní v příštích dnech vrátit a dokončit ji. Vyplněný obsah vám uschováme s výjimkou příloh, které budete muset v případě návratu do žádosti nahrát znovu.` | WIRE0011 | — | Confirmed |
| `module-application.step5.exit-modal-delete-prompt` | `Přejete si žádost o pomoc zcela zrušit?` | WIRE0011 | — | Confirmed |
| `module-application.step4.telefon-mismatch-error` | `Telefonní číslo nemůže být stejné jako to Vaše.` | WIRE0010 States→error | Open Question — no BRxxxx/ENxxxx found | Confirmed text / Uncertain trigger |
| (unkeyed) contact-gate e-mail/telefon format/required, consent-checkbox | `(not observed)` | WIRE0006 | Open Question | Evidence Pending |
| (unkeyed) step1 narrative/health 0/500 counters, child name required, RC format, radio required-ness | `(not observed)` | WIRE0007 | Open Question | Evidence Pending |
| (unkeyed) step2 gift-help counter, attachment counter, min-price enforcement, category-select gating, contact format | `(not observed)` | WIRE0008 (EN0002 notes a min-price floor exists but not surfaced) | Open Question | Evidence Pending |
| (unkeyed) step3 all personal-data fields | `(not observed)` | WIRE0009 | Open Question | Evidence Pending |
| (unkeyed) step4 Patron name/relationship/e-mail required-ness | `(not observed)` | WIRE0010 | Open Question | Evidence Pending |
| (unkeyed) step5 upload mandatory-ness, referral required, 3 consent checkboxes | `(not observed)` | WIRE0011 | Open Question | Evidence Pending |
| `module-application.contact-gate.submit-cta` | `Pokračovat` | WIRE0006 | UC0001 (steps 3–11) | Confirmed |
| `module-application.contact-gate.back-cta` | `← Zpět na výběr` | WIRE0006 | — (navigation only, returns to S006) | Confirmed |
| `module-application.step1.submit-cta` | `Pokračovat` | WIRE0007 | UC0001 (continuation; no per-step id) | Confirmed |
| `module-application.step1.back-cta` | `← Krok zpět` | WIRE0007 | Open Question — target uncertain | Confirmed text |
| `module-application.step2.submit-cta` | `Pokračovat` | WIRE0008 | UC0001 (continuation) | Confirmed |
| `module-application.step2.back-cta` | `← Krok zpět` | WIRE0008 | — (back to S008a) | Confirmed |
| `module-application.step2.file-picker-cta` | `vyberte v počítači` | WIRE0008 | UC0001 (attachment capture) | Confirmed |
| `module-application.step3.submit-cta` | `Pokračovat` | WIRE0009 | UC0001 (continuation) | Confirmed |
| `module-application.step3.back-cta` | `← Krok zpět` | WIRE0009 | — (back to S008b) | Confirmed |
| `module-application.step4.submit-cta` | `Pokračovat` | WIRE0010 | UC0001 (continuation) | Confirmed |
| `module-application.step4.back-cta` | `← Krok zpět` | WIRE0010 | — (back to S008c) | Confirmed |
| `module-application.step5.submit-cta` | `Odeslat` | WIRE0011 | UC0001 (terminal submit) | Confirmed |
| `module-application.step5.back-cta` | `← Krok zpět` | WIRE0011 | — (back to S008d) | Confirmed |
| `module-application.step5.file-picker-cta` | `vyberte v počítači` | WIRE0011 | UC0001 (attachment capture) | Confirmed |
| `module-application.step5.exit-modal-back-cta` | `Zpět do žádosti` | WIRE0011 | Open Question — no dedicated UC id | Confirmed text |
| `module-application.step5.exit-modal-leave-cta` | `Opustit žádost` | WIRE0011 | UC0025 / EN0003 (ApplicationSession, referenced) | Confirmed |
| `module-application.step5.exit-modal-delete-cta` | `Smazat žádost` | WIRE0011 | Open Question — target/confirmation flow not captured | Confirmed text |
| `module-application.step5.exit-modal-close-cta` | `×` | WIRE0011 | — (same as "Zpět do žádosti", Assumed) | Assumed |

**Scope subtotal: 147 keys** (per source-file self-report; includes 7 unkeyed validation-gap
placeholder rows above, restated for completeness).

---

## Scope: module-auth

Source: `_ar/spec-draft/COPY/COPY-module-auth.md`

| Key | Text (verbatim) | Usage (WIRE/COMP) | Trigger (BR/EN/UC) | Certainty |
|---|---|---|---|---|
| `module-auth.login.heading` | `Přihlaste se do účtu` | WIRE0012, COMP0009 | — | Confirmed |
| `module-auth.login.body` | `pro žadatele, dárce a Patrony, kde najdete přehled o svých žádostech a darech. Zadejte svůj e-mail, a my vám místo hesla pošleme odkaz, kterým se přihlásíte.` | WIRE0012, COMP0009 | — | Confirmed |
| `module-auth.login-confirmation.heading` | `Zkontrolujte svou e-mailovou schránku` | WIRE0012, COMP0009 | — | Confirmed |
| `module-auth.login-confirmation.body` | `Na váš e-mail jsme poslali odkaz, pomocí kterého se přihlásíte i bez hesla.` | WIRE0012, COMP0009 | — | Confirmed |
| `module-auth.activate-account.heading` | `Aktivovat účet` | WIRE0013 | — | Confirmed |
| `module-auth.activate-account.body` | `Po aktivování svého uživatelského účtu budete přihlášení a budete moct využívat všech jeho výhod.` | WIRE0013 | — | Confirmed |
| `module-auth.activation-entry.heading` | `Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet` | WIRE0024, COMP0009 | — | Confirmed (upgraded from WIRE0024's own Probable) |
| `module-auth.activation-entry.body` | `Zde vyplňte svůj email, který jste použili při přispění na příběh nebo v žádosti o dar. Odešleme vám na něj aktivační odkaz.` | WIRE0024, COMP0009 | — | Confirmed |
| `module-auth.login-confirmation.resend-hint` | `Pokud stále nedorazil, zkontrolujte složku spam, nebo nám napište na info@patrondeti.cz.` | WIRE0012 | — | Confirmed |
| `module-auth.activate-account.missing-info-helper` | `Bez těchto informací se neobejdeme.` | WIRE0013 | Uncertain role (required-field vs. error) | Confirmed text / Uncertain semantics |
| `module-auth.login.email.validation-error` | `(not observed)` | WIRE0012 Validation Surfaces | Open Question — no BR/EN found | Evidence Pending |
| `module-auth.activate-account.password.validation-error` | `(not observed)` | WIRE0013 validationsWithoutBR | Open Question — no BR specifies password format | Evidence Pending |
| `module-auth.activate-account.terms-checkbox.validation-error` | `(not observed)` | WIRE0013 validationsWithoutBR | Open Question — no BR requires checkbox before submit | Evidence Pending |
| `module-auth.activation-entry.email.validation-error` | `(not observed)` | WIRE0024 Validation Surfaces | Open Question — no BR governs required/format or enumeration-safety | Evidence Pending |
| `module-auth.activation-link-sent.error` | `(not observed)` | WIRE0025 States→error | Open Question — UC0014 AF4/AF5 describe adjacent paths only | Evidence Pending |
| `module-auth.login.submit-cta` | `Přihlásit se` | WIRE0012, COMP0001/COMP0009 | UC0014 (magic-link branch) | Confirmed |
| `module-auth.login.password-fallback-cta` | `Přihlaste se pomocí svého hesla.` | WIRE0012 (interaction 3) | Open Question — no screen-id evidenced | Confirmed text |
| `module-auth.login.activate-account-cta` | `Aktivujte si ho.` | WIRE0012 (interaction 4) | UC0014 (activation-link-issuance precursor, navigates to S021) | Confirmed |
| `module-auth.login-confirmation.password-fallback-cta` | `Přihlaste se pomocí svého hesla.` | WIRE0012 (confirmation state) | Same as `module-auth.login.password-fallback-cta` | Confirmed text |
| `module-auth.login-confirmation.contact-support-cta` | `napište na info@patrondeti.cz` | WIRE0012 (mailto: link) | — (support contact, not a domain UC) | Confirmed |
| `module-auth.activate-account.rules-link-cta` | `pravidly poskytování pomoci` | WIRE0013 | — (document-view action, opens S-EXT4) | Confirmed |
| `module-auth.activate-account.terms-link-cta` | `podmínkami používání uživatelského účtu` | WIRE0013 (interaction 4) | Open Question — target screen not captured | Confirmed text |
| `module-auth.activate-account.submit-cta` | `Aktivovat účet` | WIRE0013, COMP0001 | UC0014 (activation transition) | Confirmed |
| `module-auth.activation-entry.submit-cta` | `Poslat aktivační odkaz` | WIRE0024, COMP0001/COMP0009 | UC0014-adjacent (activation-link issuance) | Confirmed |
| `module-auth.activation-entry.back-to-login-cta` | `Zpět na přihlášení` | WIRE0024 (interaction 3) | — (navigates to S009, UC0014-adjacent) | Confirmed |
| `module-auth.activate-account.consent-rules.label` | `Prohlašuji, že jsem se seznámil/a s pravidly poskytování pomoci.` | WIRE0013, COMP0006 (instance 1) | Open Question — mandatory-before-submit unbacked by BR | Confirmed text |
| `module-auth.activate-account.consent-terms.label` | `Souhlasím s podmínkami používání uživatelského účtu.` | WIRE0013, COMP0006 (instance 2) | Open Question — same as above | Confirmed text |

**Scope subtotal: 23 keys** (per source-file self-report; index restates all 27 rows appearing in
the source table, including 5 `(not observed)` validation placeholders — see
`COPY-synthesis-report.md` §4 for the keyed-vs-placeholder reconciliation).

---

## Scope: module-account

Source: `_ar/spec-draft/COPY/COPY-module-account.md`

| Key | Text (verbatim) | Usage (WIRE/COMP) | Trigger (BR/EN/UC) | Certainty |
|---|---|---|---|---|
| `module-account.settings.heading` | `Nastavení účtu` | WIRE0014 | — | Confirmed |
| `module-account.settings.name-group-label` | `Vaše jméno a příjmení` | WIRE0014 | — | Confirmed |
| `module-account.settings.email-group-label` | `Váš e-mail` | WIRE0014 | — | Confirmed |
| `module-account.settings.photo-group-label` | `Změnit profilovou fotku` | WIRE0014, COMP0007 | — | Confirmed |
| `module-account.tax-confirmation.tab-individual` | `Fyzická osoba` | WIRE0015 (active/default) | — | Confirmed |
| `module-account.tax-confirmation.tab-organization` | `Právnická osoba` | WIRE0015 (inactive) | — | Confirmed |
| `module-account.tax-confirmation.basic-data-heading` | `Základní údaje o vás` | WIRE0015 | — | Confirmed |
| `module-account.tax-confirmation.address-label` | `Adresa trvalého bydliště` | WIRE0015 | — | Confirmed |
| `module-account.tax-confirmation.birth-number-label` | `Rodné číslo bez lomítka` | WIRE0015 | — | Confirmed |
| `module-account.tax-confirmation.ic-label` | `Fyzická osoba s IČ` | WIRE0015 | — | Confirmed |
| `module-account.dashboard-mockup.tab-for-you` | `Pro vás` | WIRE0020 (mockup graphic) | — | Hypothesis |
| `module-account.dashboard-mockup.tab-all` | `Všechny ({count})` (observed: "Všechny (67)") | WIRE0020 (mockup graphic) | — | Hypothesis |
| `module-account.dashboard-mockup.contribution-banner` | `Přispěli jste {amount}` (observed: "Přispěli jste 1 250 Kč") | WIRE0020 (mockup graphic) | — | Hypothesis |
| `module-account.dashboard-mockup.countdown-badge` | `ZBÝVÁ {n} DNÍ` (observed: "ZBÝVÁ 10 DNÍ") | WIRE0020 (mockup graphic) | — | Hypothesis |
| `module-account.donor-zone.heading` | `Moje zóna` | WIRE0021 (S018 page title, config-derived, EN0034) | — | Probable |
| `module-account.settings.first-name-placeholder` | `Jméno` | WIRE0014 | — | Confirmed |
| `module-account.settings.last-name-placeholder` | `Příjmení` | WIRE0014 | — | Confirmed |
| `module-account.settings.email-placeholder` | `E-mail` | WIRE0014 | — | Confirmed |
| `module-account.tax-confirmation.first-name-placeholder` | `Jméno` | WIRE0015 (Fyzická osoba) | — | Confirmed |
| `module-account.tax-confirmation.last-name-placeholder` | `Příjmení` | WIRE0015 (Fyzická osoba) | — | Confirmed |
| `module-account.tax-confirmation.address-placeholder` | `Ulice, číslo, Město, PSČ` | WIRE0015 | — | Confirmed |
| `module-account.tax-confirmation.birth-number-placeholder` | `YYMMDDXXXX` | WIRE0015 | — | Confirmed |
| `module-account.tax-confirmation.ic-placeholder` | `Pozor na překlepy :)` | WIRE0015 | — | Confirmed |
| `module-account.settings.sub-heading` | `Potřebujete něco změnit? Udělejte to tady.` | WIRE0014 | — | Confirmed |
| `module-account.settings.photo-upload-helper` | `Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači.` | WIRE0014, COMP0007 | — | Confirmed |
| `module-account.tax-confirmation.hero-heading` | `Děkujeme, že pomáháte dětem, které neměly v životě štěstí.` | WIRE0015 | — | Confirmed |
| `module-account.tax-confirmation.hero-subcopy` | `Toto je stránka, na které vám vystavíme potvrzení o darech Patronu dětí.` | WIRE0015 | — | Confirmed |
| `module-account.tax-confirmation.year-checkbox-label` | `Chci vykázat všechny dary za rok 2025` (dynamic `{year}` hypothesis) | WIRE0015 | — | Confirmed (template hypothesis) |
| `module-account.tax-confirmation.legal-disclaimer` | `Upozorňujeme, že pro účely snížení daňového základu můžete pro každý jednotlivý dar uplatnit toto potvrzení nebo potvrzení za kalendářní rok pouze jednou. Nelze uplatnit jeden dar obsažený ve dvou různých potvrzeních nebo pro dva různé subjekty.` | WIRE0015 | — | Confirmed |
| `module-account.settings.empty-state` | `(not observed)` | WIRE0014 | Open Question | Uncertain |
| `module-account.donor-zone.empty-state` | `(not observed)` | WIRE0021 | Open Question | Uncertain |
| `module-account.applicant-zone.empty-state` | `(not observed)` | WIRE0022 | Open Question | Uncertain |
| `module-account.patron-zone.empty-state` | `(not observed)` | WIRE0023 | Open Question | Uncertain |
| `module-account.settings.loading` | `(not observed)` | WIRE0014 | Open Question | Uncertain |
| `module-account.tax-confirmation.loading` | `(not observed)` | WIRE0015 | Open Question | Uncertain |
| `module-account.settings.first-name.validation-error` | `(not observed)` | WIRE0014 | Open Question | Uncertain |
| `module-account.settings.last-name.validation-error` | `(not observed)` | WIRE0014 | Open Question | Uncertain |
| `module-account.settings.email.validation-error` | `(not observed)` | WIRE0014 (UC0024 AF2: e-mail not accepted on profile-update contract) | Open Question | Uncertain |
| `module-account.settings.photo-upload.validation-error` | `(not observed)` | WIRE0014 | Open Question — no BR on file-count/type/size | Uncertain |
| `module-account.tax-confirmation.first-name.validation-error` | `(not observed)` | WIRE0015 (UC0010 confirms validation occurs) | Open Question | Uncertain |
| `module-account.tax-confirmation.last-name.validation-error` | `(not observed)` | WIRE0015 | Open Question | Uncertain |
| `module-account.tax-confirmation.birth-number.validation-error` | `(not observed)` | WIRE0015 | Open Question | Uncertain |
| `module-account.tax-confirmation.address.validation-error` | `(not observed)` | WIRE0015 | Open Question | Uncertain |
| `module-account.tax-confirmation.ic.validation-error` | `(not observed)` | WIRE0015 | Open Question | Uncertain |
| `module-account.tax-confirmation.organization-tab.validation-error` | `(not observed)` | WIRE0015 (UC0010) | Open Question | Uncertain |
| `module-account.tax-confirmation.zero-total.error` | `(not observed)` | WIRE0015 | BR-DonationConfirmationAndTax (server-side abort, UC0010 AF1; on-screen surfacing Uncertain) | Uncertain |
| `module-account.settings.save-cta` | `Uložit změny` | WIRE0014 | UC0024 (UC0024.2) | Confirmed |
| `module-account.settings.photo-picker-link` | `vyberte v počítači` | WIRE0014 | UC0024 (UC0024.2 photo-upload) | Confirmed |
| `module-account.tax-confirmation.submit-cta` | `Ziskat potvrzení` (verbatim typo for "Získat") | WIRE0015 | UC0010 (UC0010.1–.2) | Confirmed |

**Scope subtotal: 49 keys** (per source-file self-report).

---

## Reconciliation note

Row counts transcribed above may include placeholder rows for `(not observed)` validation/empty/
loading entries that the owning COPY document lists in prose or a dedicated sub-table without a
dedicated `key` cell (most visible in `COPY-module-story-donation.md`'s Error/Validation table and
`COPY-module-application.md`'s `validationsWithoutTrigger` bullet list). These are carried into this
index as unkeyed rows for completeness of the "what was looked for and not found" record, and are
excluded from the per-scope `keyCount` self-reported by each authoring pass. See
`COPY-synthesis-report.md` §2 for the reconciled totals.
