---
doc_id: COPY-module-application
title: Application Intake — Role Choice, Contact/Consent Gate & 5-Step Wizard
canonical_layer: COPY
spec_type: copy
scope: module-application
modules: []
language: cs
status: draft
references:
  - WIRE0005
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - UC0001
  - EN0001
  - EN0002
  - EN0033
---

# COPY-module-application – Application Intake — Role Choice, Contact/Consent Gate & 5-Step Wizard

## Purpose

This document transcribes the user-facing Czech text for the Application (Žádost) public intake
surface: the role-choice landing (`S006` / `WIRE0005`), the contact/consent gate "Údaje o žadateli"
(`S007` / `WIRE0006`), and the five-step public wizard at `/zadost-formular` (`S008a`–`S008e` /
`WIRE0007`–`WIRE0011`). All screens realize `UC0001` (Submit Application) for the fundraiser
(applicant) role. Text is transcribed **verbatim** from `_ar/prtsc/**` screenshots and
`_ar/evidence/ui/ui-observed-areas.md`; nothing is paraphrased or invented. Tone throughout is
2nd-person informal-formal Czech ("vy" form), direct address ("vám", "vaše dítě", "váš Patron").

`S006` (`WIRE0005`) has **no captured screenshot** — its card copy is Evidence Pending and is not
transcribed here as confirmed copy (see Open Questions). All other screens in this scope have direct
screenshot evidence.

---

## Labels

| Key | Text | Usage (WIRE/COMP ref) |
|---|---|---|
| `module-application.contact-gate.heading` | `Začneme tím, že nám sdělíte váš telefon a e-mail` | `WIRE0006` (H1) |
| `module-application.contact-gate.panel-heading` | `Údaje o Vás` | `WIRE0006` (form panel heading) |
| `module-application.contact-gate.email-placeholder` | `E-mail` | `WIRE0006` (email field placeholder-as-label) |
| `module-application.contact-gate.phone-prefix` | `+420` | `WIRE0006` (phone field fixed prefix) |
| `module-application.contact-gate.phone-placeholder` | `Telefon` | `WIRE0006` (phone field placeholder-as-label) |
| `module-application.contact-gate.faq-heading` | `Často kladené otázky` | `WIRE0006` (FAQ section heading) |
| `module-application.contact-gate.faq-question-1` | `Proč musí mít každé dítě svou vlastní žádost o dar?` | `WIRE0006` (FAQ accordion item, collapsed) |
| `module-application.contact-gate.faq-question-2` | `Proč musí mít každý příběh svého Patrona?` | `WIRE0006` (FAQ accordion item, collapsed) |
| `module-application.step1.stepper-1` | `Příběh` | `WIRE0007`/`WIRE0008`/`WIRE0009`/`WIRE0010`/`WIRE0011` (stepper label, step 1); `COMP0005` |
| `module-application.step1.stepper-2` | `Dar` | `WIRE0007`–`WIRE0011` (stepper label, step 2); `COMP0005` |
| `module-application.step1.stepper-3` | `O Vás` | `WIRE0007`–`WIRE0011` (stepper label, step 3); `COMP0005` |
| `module-application.step1.stepper-4` | `Patron` | `WIRE0007`–`WIRE0011` (stepper label, step 4); `COMP0005` |
| `module-application.step1.stepper-5` | `Přílohy` | `WIRE0007`–`WIRE0011` (stepper label, step 5); `COMP0005` |
| `module-application.step1.heading` | `Krok 1: Váš příběh` | `WIRE0007` (page title) |
| `module-application.step1.child-name-section-heading` | `Dovolte nám vaše dítě lépe poznat` | `WIRE0007` (sub-zone B heading) |
| `module-application.step1.child-firstname-heading` | `Jméno a příjmení dítěte` | `WIRE0007` (label above the Jméno/Příjmení pair; confirmed on-screen) |
| `module-application.step1.child-firstname-placeholder` | `Jméno` | `WIRE0007` (child first-name field) |
| `module-application.step1.child-lastname-placeholder` | `Příjmení` | `WIRE0007` (child last-name field) |
| `module-application.step1.child-rc-heading` | `Rodné číslo dítěte (cizinec: číslo pojištěnce)` | `WIRE0007` (field label, dual meaning) |
| `module-application.step1.child-like-heading` | `Jaké je vaše dítě a co má rádo?` | `WIRE0007` (field label) |
| `module-application.step1.health-checkbox-label` | `Je Vaše dítě zdravotně znevýhodněné?` | `WIRE0007` (checkbox label) |
| `module-application.step1.health-problems-heading` | `S čím se vaše dítě potýká a jakou potřebuje pomoc?` | `WIRE0007` (sub-zone D heading) |
| `module-application.step1.health-problems-subquestion` | `Má vaše dítě specifický zdravotní problém?` | `WIRE0007` (bold lead-in inside sub-zone D) |
| `module-application.step1.prior-collection-heading` | `Mate nebo měli jste sbírku u jiné nadace v posledních 6 měsících?` | `WIRE0007` (radio group label; "Mate" typo preserved verbatim) |
| `module-application.step1.prior-collection-option-yes` | `ANO` | `WIRE0007` (radio option) |
| `module-application.step1.prior-collection-option-no` | `NE` | `WIRE0007` (radio option, default) |
| `module-application.step1.nationality-heading` | `Žádám o pomoc pro dítě, které nemá českou národnost` | `WIRE0007` (radio group label) |
| `module-application.step1.nationality-option-yes` | `ANO` | `WIRE0007` (radio option) |
| `module-application.step1.nationality-option-no` | `NE` | `WIRE0007` (radio option, default) |
| `module-application.step2.heading` | `Krok 2: Dar, kterým vám pomůžeme` | `WIRE0008` (page title) |
| `module-application.step2.category-picker-heading` | `Rychlá volba daru:` | `WIRE0008` (category list heading) |
| `module-application.step2.category-1` | `ŠVP, jazykový kurz, školní výlety` | `WIRE0008` (gift category row) |
| `module-application.step2.category-2` | `Lyžařský kurz` | `WIRE0008` (gift category row) |
| `module-application.step2.category-3` | `Kroužky, soustředění a vybavení pro ně` | `WIRE0008` (gift category row) |
| `module-application.step2.category-4` | `Tábory – pobytové, příměstské` | `WIRE0008` (gift category row) |
| `module-application.step2.category-5` | `Školné a internát` | `WIRE0008` (gift category row) |
| `module-application.step2.category-6` | `Notebook` | `WIRE0008` (gift category row) |
| `module-application.step2.category-7` | `Automobil jako zdravotní pomůcka` | `WIRE0008` (gift category row) |
| `module-application.step2.category-8` | `Pomůcky a služby pro zdravotně znevýhodněné děti` | `WIRE0008` (gift category row) |
| `module-application.step2.category-9` | `Balík školních potřeb` | `WIRE0008` (gift category row) |
| `module-application.step2.org-name-heading-default` | `Název a adresa školy poskytující aktivity` | `WIRE0008` (generic/default category field label) |
| `module-application.step2.org-name-placeholder-default` | `Název a adresa školy` | `WIRE0008` (generic field placeholder) |
| `module-application.step2.org-name-heading-tabory` | `Název a adresa organizátora tábora` | `WIRE0008` (category-dependent relabel, "Tábory" selected; `EN0033` override) |
| `module-application.step2.contact-person-heading` | `Kontaktní osoba` | `WIRE0008` (field label) |
| `module-application.step2.contact-person-placeholder` | `Kontaktní osoba` | `WIRE0008` (field placeholder) |
| `module-application.step2.contact-phone-heading` | `Telefonní číslo na kontaktní osobu` | `WIRE0008` (field label) |
| `module-application.step2.contact-phone-placeholder` | `Telefonní číslo` | `WIRE0008` (field placeholder) |
| `module-application.step2.contact-email-heading` | `E-mail na kontaktní osobu` | `WIRE0008` (field label) |
| `module-application.step2.contact-email-placeholder` | `E-mail` | `WIRE0008` (field placeholder) |
| `module-application.step2.gift-help-heading` | `Jak dar dítěti konkrétně pomůže?` | `WIRE0008` (textarea label) |
| `module-application.step2.attachment-heading-default` | `Zde přiložte přihlášku na školní akci nebo informační leták` | `WIRE0008` (generic attachment dropzone label) |
| `module-application.step2.attachment-heading-tabory` | `Zde přiložte přihlášku na tábor` | `WIRE0008` (category-dependent relabel, "Tábory" selected) |
| `module-application.step2.upload-dropzone-instruction` | `Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači` | `WIRE0008`; `COMP0007` |
| `module-application.step2.tabory-term-heading` | `V jaké termínu se tábor uskuteční` | `WIRE0008` (category-dependent extra field, "Tábory"; "termínu" typo preserved verbatim) |
| `module-application.step2.tabory-term-placeholder` | `Termín` | `WIRE0008` (extra field placeholder) |
| `module-application.step2.total-cost-heading` | `Celková částka na pořízení daru` | `WIRE0008` (currency field label) |
| `module-application.step2.total-cost-suffix` | `Kč` | `WIRE0008` (currency suffix) |
| `module-application.step2.category-expand-cta` | `Více informací` | `WIRE0008` (per-row expand toggle) |
| `module-application.step2.category-collapse-cta` | `Zobrazit méně` | `WIRE0008` (per-row collapse toggle) |
| `module-application.step2.category-select-cta` | `Vybrat` | `WIRE0008` (per-row select action) |
| `module-application.step2.faq-heading` | `Často kladené otázky` | `WIRE0008` (FAQ section heading) |
| `module-application.step2.faq-question-1` | `Proč vyžadujeme po všech obdarovaných důkaz o tom, jak dar využívají?` | `WIRE0008` (FAQ accordion item, collapsed) |
| `module-application.step3.heading` | `Krok 3: Údaje o vás` | `WIRE0009` (page title) |
| `module-application.step3.name-heading` | `Vaše jméno a příjmení` | `WIRE0009` (field-pair label) |
| `module-application.step3.firstname-placeholder` | `Jméno` | `WIRE0009` (field placeholder) |
| `module-application.step3.lastname-placeholder` | `Příjmení` | `WIRE0009` (field placeholder) |
| `module-application.step3.rc-heading` | `Rodné číslo rodiče (cizinec: číslo pojištěnce)` | `WIRE0009` (field label) |
| `module-application.step3.address-heading` | `Adresa vašeho trvalého bydliště` | `WIRE0009` (address block heading) |
| `module-application.step3.street-placeholder` | `Ulice a číslo popisné` | `WIRE0009` (field placeholder) |
| `module-application.step3.city-placeholder` | `Město` | `WIRE0009` (field placeholder) |
| `module-application.step3.zip-placeholder` | `PSČ` | `WIRE0009` (field placeholder) |
| `module-application.step3.mailing-address-checkbox-label` | `Zastihnete mě na jiné než trvalé adrese.` | `WIRE0009` (checkbox label) |
| `module-application.step3.single-parent-checkbox-label` | `Jsem samoživitel` | `WIRE0009` (checkbox label) |
| `module-application.step3.contact-heading` | `Vaše kontaktní údaje` | `WIRE0009` (contact block heading) |
| `module-application.step3.email-placeholder` | `E-mail` | `WIRE0009` (field placeholder; observed filled with `o.suhaj@gmail.com` test data — noise, not copy) |
| `module-application.step3.phone-prefix` | `+420` | `WIRE0009` (fixed phone prefix) |
| `module-application.step3.employed-heading` | `Jste zaměstnán? (pokud nejste zaměstnán, doložte evidenci na ÚP v kroku 5.)` | `WIRE0009` (radio group label with inline cross-step consequence) |
| `module-application.step3.employed-option-yes` | `ANO` | `WIRE0009` (radio option) |
| `module-application.step3.employed-option-no` | `NE` | `WIRE0009` (radio option, default) |
| `module-application.step4.heading` | `Krok 4: Údaje o vašem Patronovi` | `WIRE0010` (page title) |
| `module-application.step4.name-heading` | `Jméno a příjmení vašeho Patrona` | `WIRE0010` (field-pair label) |
| `module-application.step4.firstname-placeholder` | `Jméno` | `WIRE0010` (field placeholder) |
| `module-application.step4.lastname-placeholder` | `Příjmení` | `WIRE0010` (field placeholder) |
| `module-application.step4.relationship-heading` | `V jakém vztahu je k vám nebo k vaší rodině?` | `WIRE0010` (dropdown label) |
| `module-application.step4.relationship-option-familyfriend` | `Rodinný známý` | `WIRE0010` (only observed dropdown option; full option list not evidenced) |
| `module-application.step4.contact-heading` | `Kontaktní údaje na Patrona` | `WIRE0010` (contact block heading) |
| `module-application.step4.email-placeholder` | `E-mail` | `WIRE0010` (field placeholder) |
| `module-application.step4.phone-prefix` | `+420` | `WIRE0010` (fixed phone prefix) |
| `module-application.step4.phone-placeholder` | `Telefon` | `WIRE0010` (field placeholder) |
| `module-application.step5.heading` | `Krok 5: Přílohy a fotografie` | `WIRE0011` (page title) |
| `module-application.step5.images-section-heading` | `Povinné obrazové přílohy` | `WIRE0011` (upload section 1 heading) |
| `module-application.step5.id-section-heading` | `Fotka Vašeho dokladu totožnosti s fotkou (občanský průkaz, pas):` | `WIRE0011` (upload section 2 heading) |
| `module-application.step5.birth-cert-section-heading` | `Fotka nebo kopie rodného listu dítěte, případně rozhodnutí soudu o svěření do péče.` | `WIRE0011` (upload section 3 heading) |
| `module-application.step5.upload-dropzone-instruction` | `Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači.` | `WIRE0011`; `COMP0007` |
| `module-application.step5.upload-example-badge` | `PŘÍKLAD` | `WIRE0011` (example thumbnail overlay, all three dropzones) |
| `module-application.step5.referral-heading` | `Odkud jste se dozvěděli o projektu Patron dětí?` | `WIRE0011` (dropdown label) |
| `module-application.step5.exit-modal-heading` | `Chystáte se opustit žádost.` | `WIRE0011` (exit-confirmation modal heading) |

---

## Helper Texts

| Key | Text | Usage |
|---|---|---|
| `module-application.contact-gate.privacy-helper` | `Kontaktní údaje nikde nezveřejňujeme ani je neposkytujeme komukoli dalšímu.` | `WIRE0006` (icon/heading band, line 1) |
| `module-application.contact-gate.documents-helper` | `Pokud žádáte o dar pro své dítě, budete k vyplnění žádosti potřebovat jeho rodný list a svůj občanský průkaz.` | `WIRE0006` (icon/heading band, line 2) |
| `module-application.contact-gate.consent-manage-helper` | `Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz.` | `WIRE0006` (below consent checkbox) |
| `module-application.step1.intro-1` | `Jsme tu pro vás a chceme dopřát vašim dětem to, co skutečně potřebují. Vše začíná touto žádostí, ve které nám dovolte vás lépe poznat.` | `WIRE0007` (page intro, line 1) |
| `module-application.step1.intro-2` | `Pokud žádáte pro více dětí, vyplňte prosím pro každé z nich vlastní žádost. Žádost musí být vyplněna česky.` | `WIRE0007` (page intro, line 2) |
| `module-application.step1.story-textarea-helper` | `Řekněte nám více o sobě a o své rodině, o tom, kde žijete a proč potřebujete pomoci. Jednoduše, pomozte nám více porozumět vaší situaci.` | `WIRE0007` (above narrative textarea) |
| `module-application.step1.story-textarea-placeholder` | `Např.: Jsem rozvedená a žiji s dětmi sama. Kromě Honzíka, kterému zde žádám o dar, mám ještě dceru Natálku. Honzík má vrozenou vadu mozku a trpí epilepsií. Kvůli tomu bohužel nechodí a umí se jen převrátit na bříško a zpátky. Aby se mu ulevilo, potřebuje pravidelné rehabilitace, které si nemůžu dovolit. Rehabilitace nám dávají šanci, že se jednou postaví na vlastní nohy.` | `WIRE0007` (narrative textarea placeholder example) |
| `module-application.step1.child-like-placeholder` | `Např.: Honzík rád kreslí a miluje modrou barvu.` | `WIRE0007` (child-like field placeholder example) |
| `module-application.step1.health-problems-helper` | `Pokud ano, pomozte nám pochopit, co ho trápí a jak se mu může ulevit. Nebojte se rozepsat, informace mohou u příběhu na webu pomoci dárcům v rozhodování, zda na příběh přispějí či ne.` | `WIRE0007` (grey helper text next to bold sub-question) |
| `module-application.step1.health-problems-placeholder` | `Např.: Honzík má vrozenou vadu mozku. To znamená, že je oproti svým vrstevníkům opožděný ve vývoji. Ve svých dvou letech se zvládne pouze přetočit na bříško a zpátky. Jinak vyžaduje celodenní péči. Honzíkovi hodně prospívají speciální neurorehabilitace. Jsou finančně velmi nákladné, ale výsledky se dostavují. Proto bychom je rádi opakovali, co nejvíce to půjde. V dnešní době je bohužel většina terapií a rehabilitací pro takové děti brána jako jakýsi nadstandard, za který si rodiče musí připlatit... atd.` | `WIRE0007` (health-problems textarea placeholder example) |
| `module-application.step1.duplicate-collection-warning` | `Pokud založíte v průběhu sbírky novou, duplicitní sbírku u jiného charitativního subjektu, informujte neprodleně Nadaci Sirius.` | `WIRE0007` (bold warning line below prior-collection radio) |
| `module-application.step2.gift-help-helper` | `Tato informace může pomoci dárcům v rozhodování, zda přispějí či ne, buďte proto konkrétní a nebojte se popsat detaily tak, aby je každý pochopil.` | `WIRE0008` (below "Jak dar dítěti konkrétně pomůže?" heading) |
| `module-application.step2.gift-help-placeholder` | `Např.: Honzík házenou miluje a chodí na ni už několik let; rehabilitace jsou pro Markétku jedinou nadějí, že někdy bude sama chodit…` | `WIRE0008` (gift-help textarea placeholder example) |
| `module-application.step2.total-cost-helper` | `Pokud je součástí daru více předmětů nebo služeb, sečtěte je.` | `WIRE0008` (below "Celková částka na pořízení daru" heading) |
| `module-application.step2.tabory-description` | `Požádat můžete o jakékoli tábory anebo soustředění v kterékoli roční době. Pokud je dodavatel stejný, můžete požádat o více aktivit najednou. Např. sportovní soustředění v červenci a srpnu, nebo příměstský tábor na jaře a pobytový tábor v létě apod. V žádosti je nutné uvést celkovou cenu a kontakt na poskytovatele služby.` | `WIRE0008` (expanded "Tábory" category description) |
| `module-application.step3.intro` | `Abychom vám mohli pomoci, potřebujeme o vás bližší informace.` | `WIRE0009` (page intro, below H1) |
| `module-application.step3.single-parent-definition` | `Samoživitel = Zákonný zástupce dítěte, který vede samostatnou domácnost, ve které je jedinou dospělou osobou, žijící s nezaopatřenými dětmi` | `WIRE0009` (static definition text below "Jsem samoživitel" checkbox) |
| `module-application.step3.contact-helper` | `Na těchto údajích vás musíme zastihnout, zkontrolujte prosím jejich správnost.` | `WIRE0009` (below "Vaše kontaktní údaje" heading) |
| `module-application.step3.info-banner-lead` | `V případě změny údajů` | `WIRE0009` (bold lead-in inside the red info banner) |
| `module-application.step3.info-banner-body` | `nám nezapomeňte dát hned vědět. Ať se k vám pomoc dostane co nejrychleji.` | `WIRE0009` (red info banner, remainder of sentence) |
| `module-application.step4.intro-1` | `Každý dětský příběh u nás na webu potřebuje mít svého Patrona. Pro dárce je Patron zárukou důvěryhodnosti vašeho příběhu.` | `WIRE0010` (page intro, sentence 1) |
| `module-application.step4.intro-2` | `Patronem se může stát kdokoliv, kdo má k dítěti blízký vztah, s jedinou výjimkou a tou je rodinný příslušník. Patronem nesmí být: matka, otec, babička, strýc, teta atd.` | `WIRE0010` (page intro, sentence 2 — family-exclusion rule) |
| `module-application.step4.intro-3` | `Může to být například učitel, vedoucí zájmového kroužku, pracovník OSPOD atd.` | `WIRE0010` (page intro, sentence 3 — example non-family roles) |
| `module-application.step4.contact-helper` | `Informujte svého Patrona o tom, že uvádíte jeho údaje, budeme ho ihned kontaktovat emailem.` | `WIRE0010` (below "Kontaktní údaje na Patrona" heading) |
| `module-application.step5.intro` | `Pro zveřejnění příběhu na našich stránkách potřebujeme, abyste nahráli fotografii vašeho dítěte a dvě povinné přílohy: občanský průkaz a rodný list dítěte.` | `WIRE0011` (page intro, below H1) |
| `module-application.step5.images-instructions-lead` | `Každý příběh musí obsahovat alespoň jeden obrázek, který příběh lépe přiblíží dárcům. Na výběr máte:` | `WIRE0011` (instructional lead-in above the three numbered options) |
| `module-application.step5.images-instructions-option-1` | `Fotografii dítěte – preferovaná varianta. Fotografie může být anonymní (např. dítě zezadu, z dálky apod.), aby byla chráněna identita dítěte.` | `WIRE0011` (numbered option 1) |
| `module-application.step5.images-instructions-option-2` | `Obrázek namalovaný dítětem – například z letního tábora, kroužku, nebo ilustrace předmětu, který souvisí s potřebou (např. hudební nástroj, sportovní vybavení).` | `WIRE0011` (numbered option 2) |
| `module-application.step5.images-instructions-option-3` | `Krátký text „vzkaz/dopis pro dárce", který dítě napíše nebo nadiktuje (ručně psaný nebo vyfocený).` | `WIRE0011` (numbered option 3) |
| `module-application.step5.exit-modal-body` | `Pokud žádost nyní opustíte, můžete se k ní v příštích dnech vrátit a dokončit ji. Vyplněný obsah vám uschováme s výjimkou příloh, které budete muset v případě návratu do žádosti nahrát znovu.` | `WIRE0011` (exit-confirmation modal body) |
| `module-application.step5.exit-modal-delete-prompt` | `Přejete si žádost o pomoc zcela zrušit?` | `WIRE0011` (exit-confirmation modal, secondary destructive prompt) |

---

## Empty States

| Key | Text | Shown when |
|---|---|---|
| — | — | No dedicated empty-state copy is evidenced for any screen in this scope. Each screen's blank/unfilled form rendering (placeholders + default radio selections) is the `default` state, not a distinct empty-collection state — see `WIRE0005`–`WIRE0011` §States. This section is intentionally omitted per template guidance (no placeholder content to record). |

---

## Loading Texts

No loading-state copy is evidenced on any screen in this scope — `WIRE0005`–`WIRE0011` all record
loading as `Evidence Pending — not captured`. Section omitted (no confirmed or assumed text exists to
list).

---

## Error / Validation Messages

Every message references the triggering rule or invariant. Per `WIRE0006`–`WIRE0011`, **no `BRxxxx`
document owns field-level validation for this scope** — all rows below are `validationsWithoutTrigger`
except the one directly observed field-level error.

| Key | Text | Trigger |
|---|---|---|
| `module-application.step4.telefon-mismatch-error` | `Telefonní číslo nemůže být stejné jako to Vaše.` | No `BRxxxx`/`ENxxxx` found — Open Question. Directly observed (`WIRE0010` States → error; screenshot `screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_59.png`) as an inline field-level error on the Patron phone field when it equals the applicant's own phone number. `UC0001` does not enumerate this rule; no BR document in `_ar/spec-draft/BR/` governs it. |

**validationsWithoutTrigger** (observed or implied validation surfaces with no owning `BRxxxx`/`ENxxxx`,
per each WIRE's Validation Surfaces section — no error copy exists for any of these, only the
underlying rule/requirement is implied):

- Contact gate (`WIRE0006`): E-mail format/required, Telefon format/required, consent-checkbox required-to-proceed — no on-screen error text captured for any of these.
- Step 1 (`WIRE0007`): narrative/health-problems 0/500 counters (hard vs. soft limit unconfirmed), child Jméno/Příjmení required-ness, Rodné číslo dítěte format, prior-collection and nationality radio required-ness — no error copy captured.
- Step 2 (`WIRE0008`): gift-help 0/500 counter, attachment 0/3 counter, "Celková částka" minimum-price enforcement point (`EN0002` notes a minimum-price floor exists but not where/how it is surfaced), category-must-be-selected gating, contact-field format — no error copy captured.
- Step 3 (`WIRE0009`): all personal-data fields (name, rodné číslo, address, e-mail, telefon, employment flag, samoživitel flag, mailing-address-differs flag) — no error copy captured.
- Step 4 (`WIRE0010`): Patron Jméno/Příjmení/relationship-dropdown/e-mail required-ness — no error copy captured (only the phone-mismatch error above is observed).
- Step 5 (`WIRE0011`): three upload dropzones' mandatory-ness, referral-dropdown required-ness, the three consent checkboxes' individual required-ness — instructional copy states two attachment categories are mandatory ("dvě povinné přílohy"), but no enforcement/error copy is captured.

---

## CTAs

Every CTA references the use case it realizes.

| Key | Text | Action |
|---|---|---|
| `module-application.contact-gate.submit-cta` | `Pokračovat` | `UC0001` (UC0001.1 steps 3–11: contact/consent submission → Application/Contact/User creation) |
| `module-application.contact-gate.back-cta` | `← Zpět na výběr` | Returns to role-choice landing (`S006`); no dedicated UC step — navigation only, not an application-state transition |
| `module-application.step1.submit-cta` | `Pokračovat` | `UC0001` (continuation of Application/profile data capture; no dedicated per-step UC id — see Open Questions) |
| `module-application.step1.back-cta` | `← Krok zpět` | Navigates back one step (target Uncertain — see `WIRE0007` Open Questions); no dedicated UC id |
| `module-application.step2.submit-cta` | `Pokračovat` | `UC0001` (continuation; no dedicated per-step UC id) |
| `module-application.step2.back-cta` | `← Krok zpět` | Navigates back to step 1 (`S008a`); no dedicated UC id |
| `module-application.step2.file-picker-cta` | `vyberte v počítači` | `UC0001` (attachment capture, no dedicated UC id); inline link inside the dropzone instruction text |
| `module-application.step3.submit-cta` | `Pokračovat` | `UC0001` (continuation; no dedicated per-step UC id) |
| `module-application.step3.back-cta` | `← Krok zpět` | Navigates back to step 2 (`S008b`); no dedicated UC id |
| `module-application.step4.submit-cta` | `Pokračovat` | `UC0001` (continuation; no dedicated per-step UC id) |
| `module-application.step4.back-cta` | `← Krok zpět` | Navigates back to step 3 (`S008c`); no dedicated UC id |
| `module-application.step5.submit-cta` | `Odeslat` | `UC0001` (terminal submit of the wizard — Application reaches its submitted/complete status; exact status value is `UC0001`/`EN0001`-owned) |
| `module-application.step5.back-cta` | `← Krok zpět` | Navigates back to step 4 (`S008d`); no dedicated UC id |
| `module-application.step5.file-picker-cta` | `vyberte v počítači` | `UC0001` (attachment capture, no dedicated UC id); inline link, repeated in all three dropzones |
| `module-application.step5.exit-modal-back-cta` | `Zpět do žádosti` | Dismisses the exit-confirmation modal, returns to step 5 `default` state; no dedicated UC id — Open Question on what triggers the modal (`WIRE0011` Interactions §7) |
| `module-application.step5.exit-modal-leave-cta` | `Opustit žádost` | Leaves the wizard; draft preserved "s výjimkou příloh" per modal copy; no dedicated UC id — `UC0025`/`EN0003` `ApplicationSession` referenced by `WIRE0011`, not restated here |
| `module-application.step5.exit-modal-delete-cta` | `Smazat žádost` | Destructive secondary path (deletes the application); target/confirmation flow not captured — Open Question, no UC id found |
| `module-application.step5.exit-modal-close-cta` | `×` | Closes the modal (same effect as "Zpět do žádosti", Assumed per `WIRE0011`) |

---

## Microcopy Conventions

- **Tone:** neutral-to-warm, direct, empathetic (e.g. "Jsme tu pro vás a chceme dopřát vašim dětem
  to, co skutečně potřebují.", "Řekněte nám více o sobě a o své rodině…").
- **Person:** 2nd person plural/formal ("vy" form) throughout — "vám", "vaše dítě", "vašeho Patrona",
  "sdělíte", "žádáte".
- **Capitalization:** sentence case for body copy and most field labels; "Vy"/"Vás"/"Váš" capitalized
  mid-sentence in several places as a formal-address convention (e.g. "Začneme tím, že nám sdělíte
  váš telefon a e-mail" — lowercase "váš" — vs. "Údaje o Vás", "Krok 4: Údaje o vašem Patronovi" —
  capitalized "Vás"/mixed on "vašem"); capitalization of the formal pronoun is **inconsistent in the
  observed source** (both forms occur) — transcribed verbatim per screen, not normalized.
- **Punctuation:** step headings use a colon pattern ("Krok N: <title>"); field labels are typically
  unpunctuated noun phrases; helper/instructional sentences end with a period; radio options are
  bare "ANO"/"NE" in all-caps.
- **Known verbatim quirks (preserved, not corrected):** "Mate nebo měli jste sbírku…" (missing
  diacritic on "Máte"); "V jaké termínu se tábor uskuteční" (grammatically non-standard "jaké
  termínu"); both reproduced exactly as observed per the evidence-first convention.

---

## Open Questions

- `S006` (role-choice landing, `WIRE0005`) has no screenshot evidence — its two role-card labels are
  not transcribable as confirmed copy. `WIRE0005` records only an English gloss inferred from a twig
  template ("I want to help my child" / "I want to help a child I know"); the actual on-screen Czech
  strings are `Evidence Pending`. No key is minted here to avoid inventing copy.
- The second screen observed at `/zadost/zadatel` (`screencapture-…13_18_04.png`, "Co budete k
  vyplnění žádosti potřebovat?" checklist interstitial with its own "Pokračovat" CTA) is flagged by
  `WIRE0006` as an unresolved alternate/preceding screen, not part of `S007`'s evidenced state. Its
  copy is not transcribed in this document — out of scope pending WIRE-layer resolution.
  `WIRE0006` also notes a "Jste patron? Vaše žádost je ZDE" link observed only on that same
  `13_18_04` capture, not on the confirmed `S007` state — likewise not transcribed here.
  Note (BA closure, not COPY-owned): the same `13_18_04` screen may correspond to `S007`'s own
  "Kontaktní údaje nikde nezveřejňujeme…" / "Pokud žádáte o dar pro své dítě…" heading band recorded
  above under `module-application.contact-gate.*`, which appears immediately above the "Údaje o Vás"
  form panel on the confirmed `13_18_12` capture — the two captures may be scroll-states of one screen
  rather than two distinct screens; this WIRE-layer ambiguity is not resolved by COPY.
- Full option list for the step-4 "V jakém vztahu je k vám nebo k vaší rodině?" relationship dropdown
  is not evidenced — only "Rodinný známý" was captured (tester-selected value). Other option strings
  are Uncertain and not listed.
- Full option list for the step-5 "Odkud jste se dozvěděli o projektu Patron dětí?" referral dropdown
  is not evidenced — captured only in its closed/unselected state. No option strings are listed.
- The consent-checkbox link targets on `S007` ("zpracováním osobních údajů") and `S008e`
  ("přesné, pravdivé a úplné údaje", "pravidly poskytování pomoci", "zpracováním osobních údajů") are
  confirmed as link text but their destination content is not evidenced — out of COPY scope (legal
  content, not this screen's copy).
- Whether the 0/500 character counters on steps 1 and 2 represent a hard `maxlength` or a soft/
  informational limit is Uncertain per `WIRE0007`/`WIRE0008` — no corresponding error copy exists
  either way, so none is recorded.
- The exact trigger for the step-5 exit-confirmation modal ("Chystáte se opustit žádost.") is not
  evidenced (`WIRE0011` Interactions §7) — the modal's own copy is transcribed above regardless, since
  the modal's rendered state itself is directly screenshot-confirmed.

---

## Evidence

| Key area | Certainty | Evidence |
|---|---|---|
| Contact/consent gate labels, helpers, FAQ, CTAs (`S007`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_12.png`; `_ar/evidence/ui/ui-observed-areas.md` §6 |
| Step 1 "Váš příběh" labels, helpers, placeholders, CTAs (`S008a`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`, `…13_20_29.png`; `ui-observed-areas.md` §3 |
| Step 2 "Dar" category list, field labels, category-dependent relabelling, CTAs (`S008b`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`, `…13_20_57.png`; `ui-observed-areas.md` §4 |
| Step 3 "O Vás" labels, helpers, info banner, CTAs (`S008c`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_21_26.png`, `…13_21_59.png`; `ui-observed-areas.md` §5 |
| Step 4 "Patron" labels, helpers, phone-mismatch error, CTAs (`S008d`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png`, `…13_22_59.png` |
| Step 5 "Přílohy" section headings, instructions, exit modal, CTAs (`S008e`) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_23_13.png`, `…13_23_21.png` |
| Stepper labels (Příběh/Dar/O Vás/Patron/Přílohy) | Confirmed | all step screenshots above; `COMP0005_WizardStepper.md` |
| `S006` role-choice landing card copy | Uncertain — Evidence Pending | `_ar/spec-draft/WIRE/WIRE0005_RoleChoiceLanding.md` Purpose/Layout Zones; no screenshot exists |
| Relationship-dropdown / referral-dropdown full option lists | Uncertain — not fully observed | `WIRE0010`, `WIRE0011` Open Questions |
| Phone-mismatch validation error text and trigger mechanism | Confirmed text / Uncertain mechanism | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_59.png`; `WIRE0010` Validation Surfaces (no BR owner) |
