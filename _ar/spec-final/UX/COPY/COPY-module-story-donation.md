---
doc_id: COPY-module-story-donation
title: Story Catalogue, Story Detail & Donation Copy
layer: COPY
spec_type: copy
scope: module-story-donation
modules: []
language: cs
status: imported
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

# COPY-module-story-donation – Katalog příběhů, detail příběhu a texty pro darování

## Účel

Tento dokument přepisuje uživatelsky viditelný český text pro plochy zaměřené na akvizici dárců:
katalog příběhů a hero sekci na hlavní stránce (S001 / `WIRE0001`), detail stránky příběhu a jeho
modální okno pro jednorázový dar (S002 / `WIRE0002`), obecnou stránku poděkování/úspěšné platby
(S003 / `WIRE0003`) a — dosud nezachycenou — obrazovku nákupu dobrošeku (S005 / `WIRE0004`).
Slouží jako i18n zdroj pro těchto čtyři obrazovky při rebuildu `bid-patron-deti` na straně FE. Tón
napříč všemi čtyřmi obrazovkami je neformálně-vřelé oslovení druhou osobou ("Chystáte se přispět",
"Vaše podpora"), věta psaná s malým počátečním písmenem (sentence case), červené/korálové primární
CTA. Text je přepsán **verbatim** ze screenshotů `_ar/prtsc/**` a z
`_ar/evidence/ui/ui-observed-areas.md`; žádné parafrázování ani vymýšlení. Globální chrome (header
nav, footer, cookie-consent banner) patří do `COMP0002`/`COMP0003`/`COMP0004` a do COPY scope
`shared-global`, zde se neopakuje — níže je zachycen pouze text specifický pro tyto obrazovky.

---

## Popisky (Labels)

| Klíč | Text | Použití (odkaz WIRE/COMP) |
|---|---|---|
| `module-story-donation.homepage.hero-headline-line1` | `DARUJME DĚTEM ŠANCI` | `WIRE0001` |
| `module-story-donation.homepage.hero-headline-line2` | `za jedno kafe měsíčně` | `WIRE0001` |
| `module-story-donation.homepage.stat-strip-number` | `323 dětí` | `WIRE0001` |
| `module-story-donation.homepage.stat-strip-caption` | `čeká na pomoc` | `WIRE0001` |
| `module-story-donation.homepage.filter-tab-remaining` | `Zbývající částka` | `WIRE0001` (výchozí aktivní záložka) |
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
| `module-story-donation.homepage.voucher-card-title` | `Pro lepší dětství` | `WIRE0001` (opakuje se na všech 6 kartách nominálních hodnot) |
| `module-story-donation.homepage.how-it-works-heading` | `Jak to funguje?` | `WIRE0001` |
| `module-story-donation.homepage.how-it-works-col1-title` | `Vše začíná příběhem` | `WIRE0001` |
| `module-story-donation.homepage.how-it-works-col2-title` | `Společně zvládneme víc!` | `WIRE0001` |
| `module-story-donation.homepage.how-it-works-col3-title` | `Jen na vás záleží…` | `WIRE0001` |
| `module-story-donation.homepage.patron-explainer-heading` | `Kdo je to Patron příběhu?` | `WIRE0001` |
| `module-story-donation.homepage.patron-explainer-body` | `Každý příběh má svého Patrona. Ten je pro dárce zárukou důvěryhodnosti. Patronem se může stát kdokoli, kdo zná dítě z příběhu – učitel, vedoucí kroužku nebo sociální pracovník. Znáte dítě, které potřebuje naši pomoc? Staňte se Patronem i vy.` | `WIRE0001` |
| `module-story-donation.homepage.sponsors-heading` | `Podporují nás` | `WIRE0001` |
| `module-story-donation.homepage.partners-heading` | `Spřátelené organizace` | `WIRE0001` |
| `module-story-donation.story-detail.category-tag` | `Rozvoj a vzdělání` | `WIRE0002` (hodnota `gift_category` dané Kampaně, `EN0004`; text je datově řízený, jde o pozorovanou instanční hodnotu) |
| `module-story-donation.story-detail.contribute-heading` | `Přispět můžete na` | `WIRE0002` |
| `module-story-donation.story-detail.in-kind-description` | `balík školních potřeb; dodává SEVT` | `WIRE0002` (datově řízená hodnota volného textu instance, `EN0004`) |
| `module-story-donation.story-detail.progress-missing-label` | `Chybí {amount} Kč` | `WIRE0002` (pozorovaná instance: "Chybí 1 600 Kč") |
| `module-story-donation.story-detail.progress-remaining-label` | `Zbývá` | `WIRE0002` |
| `module-story-donation.story-detail.progress-remaining-value` | `měsíc` | `WIRE0002` (pozorovaná instanční hodnota; liší se podle Kampaně, srov. hodnoty deadline badge v `COMP0008`) |
| `module-story-donation.story-detail.progress-target-label` | `Cílová částka` | `WIRE0002` |
| `module-story-donation.story-detail.amount-input-label` | `Chci darovat` | `WIRE0002` (pole částky, výchozí hodnota `50`, přípona `Kč`) |
| `module-story-donation.story-detail.patron-card-label` | `PATRON PŘÍBĚHU` | `WIRE0002` |
| `module-story-donation.story-detail.recurring-heading` | `Přeji si podporovat rozvoj a vzdělání pravidelně` | `WIRE0002` (název kategorie je datově řízený, `EN0004.gift_category`) |
| `module-story-donation.story-detail.voucher-cta-question` | `Chcete věnovat dobrošek?` | `WIRE0002` |
| `module-story-donation.story-detail.share-heading` | `Sdílet příběh:` | `WIRE0002` |
| `module-story-donation.story-detail.related-stories-heading` | `Aktuálně čekají na vaši pomoc` | `WIRE0002` |
| `module-story-donation.story-detail.trust-banner` | `Na pomoc dětem putuje vždy 100 % částky, kterou darujete.` | `WIRE0002` |
| `module-story-donation.donation-modal.title` | `Chystáte se přispět` | `WIRE0002` |
| `module-story-donation.donation-modal.amount-field-label` | `Kč` | `WIRE0002` (přípona jednotky u pole částky v modálním okně; pole samo nemá vlastní viditelný popisek mimo zděděnou hodnotu "Chci darovat") |
| `module-story-donation.donation-modal.email-label` | `E-mail (povinný)` | `WIRE0002` |
| `module-story-donation.donation-modal.phone-prefix-label` | `+420` | `WIRE0002` |
| `module-story-donation.donation-modal.phone-field-placeholder` | `Telefon` | `WIRE0002` |
| `module-story-donation.donation-modal.firstname-field-placeholder` | `Jméno` | `WIRE0002` |
| `module-story-donation.donation-modal.lastname-field-placeholder` | `Příjmení` | `WIRE0002` |
| `module-story-donation.thankyou.headline` | `Platba proběhla úspěšně, děkujeme za pomoc!` | `WIRE0003` |
| `module-story-donation.thankyou.body-1` | `Každý příspěvek pomáhá k lepšímu dětství. Děkujeme, že jste s námi.` | `WIRE0003` |
| `module-story-donation.thankyou.body-2` | `Platba proběhla úspěšně! Moc děkujeme. Prosíme, sdílejte a pomozte příběhu, kterému jste právě přispěli.` | `WIRE0003` |
| `module-story-donation.thankyou.resume-modal-title` | `Máte u nás rozpracovanou žádost.` | `WIRE0003` (souběžný overlay realizující `UC0025`, není součástí flow potvrzení platby) |
| `module-story-donation.thankyou.resume-modal-body` | `Vypadá to, že jste u nás nechali rozpracovanou žádost. Pro návrat do formuláře můžete použít tlačítka níže, případně lze využít odkaz v hlavičce.` | `WIRE0003` |
| `module-story-donation.thankyou.resume-modal-delete-prompt` | `Přejete si žádost o pomoc zcela zrušit?` | `WIRE0003` |

---

## Nápovědné texty (Helper Texts)

| Klíč | Text | Použití |
|---|---|---|
| `module-story-donation.donation-modal.donation-integrity-note` | `Na pomoc dětem putuje vždy 100 % z darované částky.` | `WIRE0002` (zobrazeno pod každou dvojicí "Chci darovat" / "Přispět" v postranním panelu; opakuje se verbatim dle `WIRE0002` Layout Zones) |
| `module-story-donation.donation-modal.consent-manage-note` | `Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz.` | `WIRE0002`, `COMP0006` (patří/je znovu použito propem `helperText` komponenty `COMP0006` — zde citováno jako instance pro tuto obrazovku, neopakuje se jako nový fakt) |
| `module-story-donation.donation-modal.gateway-choice-note` | `Po přesměrování na platební bránu si budete moci vybrat mezi online platbou (kartou) a expresním bankovním převodem.` | `WIRE0002` |
| `module-story-donation.story-detail.trust-list-item-1` | `100 % daru jde na pomoc dětem,` | `WIRE0002` (odrážkový seznam důvěry v těle příběhu) |
| `module-story-donation.story-detail.trust-list-item-2` | `peníze neposíláme rodinám, ale hradíme za ně konkrétní školní potřeby,` | `WIRE0002` |
| `module-story-donation.story-detail.trust-list-item-3` | `všechny žádosti pečlivě posuzuje naše oddělení risku,` | `WIRE0002` |
| `module-story-donation.story-detail.trust-list-item-4` | `každou žádost potvrzuje Patron – například sociální pracovník, učitel nebo vedoucí zájmového kroužku` | `WIRE0002` |

---

## Prázdné stavy (Empty States)

| Klíč | Text | Zobrazeno když |
|---|---|---|
| — | — | `Evidence Pending` — nebyl zachycen žádný stav s nulovým výsledkem pro mřížku katalogu / krajový filtr na S001 (`UC0023` AF4), žádné zpracování stavu plně vyfinancovaného/odstraněného Příběhu nebylo zachyceno pro S002 (`UC0005` AF2) a S005 nemá zachyceno nic. Žádný text nelze přepsat; text se nevymýšlí. Viz `WIRE0001` States → empty, `WIRE0002` States → empty, `WIRE0004` v celém rozsahu. |

---

## Texty při načítání (Loading Texts)

| Klíč | Text | Zobrazeno během |
|---|---|---|
| — | — | `Evidence Pending` — nebyl zachycen žádný stav načítání/skeleton/spinner pro znovu-dotaz záložky/kraje na S001, předání na platební bránu z modálního okna S002, příchod na S003 ani pro S005 (nezachyceno vůbec). Žádný text nelze přepsat; text se nevymýšlí. Viz `WIRE0001`/`WIRE0002`/`WIRE0003`/`WIRE0004` States → loading. |

---

## Chybové / validační zprávy (Error / Validation Messages)

Každá zpráva odkazuje na pravidlo nebo invariant, který ji vyvolává. Podle `WIRE0002` Validation
Surfaces a otevřených otázek (`WIRE0002-Q4`) nebyl pro modální okno darování na S002 pozorován
žádný BR-řízený inline validační UI prvek; viditelné prvky formuláře nemají zachycený chybový text.

| Klíč | Text | Spouštěč |
|---|---|---|
| — | *(nepozorováno — pro žádné pole nebyl zachycen chybový text)* | `UC0005` AF1 (neplatná/nečíselná částka) — žádné `BRxxxx` toto pravidlo neřídí dle `WIRE0002` Validation Surfaces; **otevřená otázka**, žádné id nevymyšleno |
| — | *(nepozorováno)* | `UC0005` AF2 (Kampaň plně vyfinancována) / `BR-PaymentAndMoneyIntegrity` — **otevřená otázka**, žádný chybový prvek nezachycen |
| — | *(nepozorováno)* | kontrola povinného pole "E-mail (povinný)" v modálu — nebylo nalezeno žádné BR, které by tuto validaci řídilo dle `WIRE0002`; **otevřená otázka** |
| — | *(nepozorováno)* | podmínka zaškrtávacího pole souhlasu 1 v modálu ("Souhlasím s pravidly poskytování pomoci") — nebylo nalezeno žádné BR dle `WIRE0002`; **otevřená otázka** |
| — | *(nepozorováno)* | podmínka zaškrtávacího pole souhlasu 2 v modálu ("Souhlasím se zpracováním osobních údajů") — `BR-DataProtectionAndErasure` obecně řídí GDPR výmaz/zpracování, ale ne tuto podmínku na úrovni UI checkboxu dle `WIRE0002`; **otevřená otázka** |

**validationsWithoutTrigger:** všech pět řádků výše má viditelný formulářový prvek naznačující
validaci, ale bez zachyceného chybového textu a bez vlastnícího `BRxxxx`/`ENxxxx` nad rámec textu
alternativního flow `UCxxxx` již citovaného ve `WIRE0002`. Zaznamenáno jako otevřené otázky, nikoli
vymyšleno.

---

## CTA

Každé CTA odkazuje na use case, který realizuje.

| Klíč | Text | Akce |
|---|---|---|
| `module-story-donation.homepage.hero-preset-cta-90` | `Daruj 90 Kč měsíčně` | vstupní bod do nastavení pravidelného daru napájejícího `EN0010`; rozvrh účtovaný přes `UC0007` (`WIRE0001` Interactions #8) — na samotném S001 není žádný přímo odesílající UC; **otevřená otázka**, na jaký UC/obrazovku klik předává |
| `module-story-donation.homepage.hero-preset-cta-290` | `Daruj 290 Kč měsíčně` | stejné jako výše |
| `module-story-donation.homepage.hero-preset-cta-custom` | `Daruj měsíčně podle sebe` | stejné jako výše |
| `module-story-donation.homepage.category-cta-health` | `Zdravotní pomoc` | předpokládaný filtr/navigace; efekt nepotvrzen (`WIRE0001` Interactions #9); **otevřená otázka**, žádné id UC k dispozici |
| `module-story-donation.homepage.category-cta-education` | `Rozvoj a vzdělání` | stejné jako výše; **otevřená otázka** |
| `module-story-donation.homepage.story-card-cta-named` | `Podpořím {jméno}` | `UC0023` (hlavní flow, kroky 13–14, hranice předání do `UC0005`) |
| `module-story-donation.homepage.story-card-cta-collection` | `Nechám to na vás` | `UC0023` (předání z karty sbírkového účtu; mechanismus Partial dle `WIRE0001`) |
| `module-story-donation.homepage.more-stories-link` | `Další příběhy` | předpokládané stránkování/plný výpis; **otevřená otázka**, žádné id UC k dispozici (`WIRE0001` Interactions #10) |
| `module-story-donation.homepage.voucher-purchase-cta` | `Koupím dobrošek` | vstupní bod do životního cyklu dobrošeku `UC0009` (strana nákupu; cílová obrazovka S005, `WIRE0004`) |
| `module-story-donation.homepage.patron-cta` | `Chci se stát Patronem` | pro tento konkrétní cíl kliknutí na S001 nebyl doložen žádný realizující UC; **otevřená otázka** (`WIRE0001` Interactions #13) |
| `module-story-donation.story-detail.donate-cta` | `Přispět 🤝` | otevírá modální okno darování; realizuje vstup do `UC0005` (`WIRE0002` Interactions #2) |
| `module-story-donation.story-detail.recurring-cta` | `Chci podporovat rozvoj a vzdělání` | Assumed — otevírá modální okno darování s nastaveným příznakem pravidelnosti, `UC0005.2`; nepozorováno přímo (`WIRE0002` Interactions #4, otevřená otázka `WIRE0002-Q2`) |
| `module-story-donation.story-detail.voucher-cta` | `Mám dobrošek` | Assumed — vstup do uplatnění dobrošeku `UC0009`; cílová plocha nezachycena (`WIRE0002` Interactions #5, otevřená otázka `WIRE0002-Q3`) |
| `module-story-donation.story-detail.patron-comment-toggle` | `Zobrazit komentář Patrona` | Assumed — rozbalení/scroll-to; nepotvrzeno (`WIRE0002` Interactions #6, otevřená otázka `WIRE0002-Q6`) |
| `module-story-donation.story-detail.related-story-cta` | `Podpořím {jméno}` | naviguje na vlastní instanci `S002` daného Příběhu (`WIRE0002` Interactions #8); pozorované instance: `Podpořím Románka`, `Podpořím Petrušku`, `Podpořím Miu` |
| `module-story-donation.story-detail.more-stories-link` | `Další příběhy` | Assumed — návrat do katalogu S001 (`WIRE0002` Interactions #8) |
| `module-story-donation.donation-modal.back-link` | `Zpět na příběh` | zavírá modální okno, beze změny stavu (`WIRE0002` Interactions #9) |
| `module-story-donation.donation-modal.consent-1-label` | `Souhlasím s pravidly poskytování pomoci projektu Patron.` | podmínka souhlasu při odeslání `UC0005`; nenalezeno žádné vlastnící `BRxxxx` — **otevřená otázka** (`WIRE0002` Validation Surfaces); text popisku patří `COMP0006` |
| `module-story-donation.donation-modal.consent-2-label` | `Souhlasím se zpracováním osobních údajů a informováním o projektu` | podmínka souhlasu při odeslání `UC0005`; nenalezeno žádné vlastnící `BRxxxx` — **otevřená otázka** (`WIRE0002` Validation Surfaces); text popisku patří `COMP0006` |
| `module-story-donation.donation-modal.submit-cta` | `Přejít k platbě` | odesílá `UC0005` (hlavní flow UC0005.1–UC0005.3), předává na platební bránu `S-EXT1` |
| `module-story-donation.thankyou.back-home-cta` | `Zpět na hlavní stránku` | prostý navigační výstup na S001; nerealizuje UC měnící stav dle popisu aktéra v `UC0006` (`WIRE0003` Interactions #2) |
| `module-story-donation.thankyou.resume-modal-resume-cta` | `Návrat do žádosti` | obnovuje rozpracovanou Žádost, `UC0025` (hlavní flow, větev obnovení) |
| `module-story-donation.thankyou.resume-modal-stay-cta` | `Zůstat na stránce` | zavírá modální okno, zůstává na S003 beze změny, `UC0025` (větev zavření) |
| `module-story-donation.thankyou.resume-modal-delete-cta` | `Smazat žádost` | zahazuje rozpracovanou Žádost (destruktivní akce, stylovaná jako textový odkaz), `UC0025` (větev zahození) |
| `module-story-donation.voucher-purchase.entry-cta` | `Koupím dobrošek` | duplicita `module-story-donation.homepage.voucher-purchase-cta` — jde o jediný potvrzený text pro S005; vlastní CTA obrazovky nákupu (odeslat/zaplatit) jsou `Evidence Pending` dle `WIRE0004`, nezachyceno, nevymýšleno |

---

## Konvence mikrotextů (Microcopy Conventions)

- Tón: neformálně-vřelý, přímé oslovení dárce ("Chystáte se přispět", "Vaše podpora"); rejstřík charity/NNO.
- Osoba: 2. osoba jednotného/množného čísla smíchaná s 1. osobou u CTA stylizovaných jako vlastní záměr dárce ("Chci darovat", "Chci podporovat", "Koupím dobrošek", "Přeji si podporovat... pravidelně").
- Velká písmena: v celém dokumentu sentence case; popisky filtračních záložek a nadpisů sekcí také sentence case (title case nebyl pozorován).
- Interpunkce: tečky na konci vět v textu/nápovědě; CTA jsou typicky bez interpunkce, s výjimkou vloženého emoji (🤝 u "Přispět 🤝").
- Číselné částky mají vždy příponu `Kč`, tisíce oddělené mezerou (např. "1 600 Kč", "323 dětí").
- Zpráva o důvěře "100 % daru" ("Na pomoc dětem putuje vždy 100 % ...") se verbatim opakuje na plochách navazujících na S001 i na S002 — je to fixní brandová fráze důvěry, nikoli text specifický pro danou obrazovku.

---

## Evidence

Text je přepsán verbatim z pozorovaného UI; nepozorované (odvozené) řetězce se označují jako
`Assumed`/`Uncertain`.

| Oblast | Jistota | Evidence |
|---|---|---|
| Hero na hlavní stránce, statistický pruh, filtrační záložky, nadpis mapy krajů, pás dobrošeků, "Jak to funguje?", vysvětlení role Patrona, nadpisy sponzorů | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `13_16_09.png`, `13_16_21.png`, `13_16_37.png`; `ui-observed-areas.md` §1 |
| Popisky karty příběhu ("Zbývá", "Cílová částka", "SBÍRKOVÝ ÚČET", vzory CTA) | Confirmed | stejné jako výše; `COMP0008` |
| Text detailu stránky příběhu (kategorie, nadpis pro přispění, popisky průběhu, seznam důvěry, CTA, nadpis sdílení, nadpis souvisejících příběhů, banner důvěry) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`; `ui-observed-areas.md` §2 |
| Modální okno darování (nadpis, popisky polí, popisky souhlasů, nápovědné texty, CTA odeslání) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_08.png` (prázdný stav), `..._13_26_21.png` (vyplněný stav, text souhlasu ověřen přiblížením); `ui-observed-areas.md` §2 |
| Přesná e-mailová adresa v nápovědném textu pro správu souhlasů | Confirmed (ověřeno přiblížením `souhlas@patrondeti.cz`, odpovídá `COMP0006`) | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_08.png` (detail výřezu) |
| Nadpis/text/CTA stránky poděkování | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png`; `ui-observed-areas.md` §13 |
| Modální okno obnovení rozpracované žádosti (nadpis, text, CTA, výzva ke smazání) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_30_32.png`; `ui-observed-areas.md` §13 |
| Obrazovka nákupu dobrošeku (S005) — jakýkoli text nad rámec sdíleného vstupního CTA | Evidence Pending — nezachyceno | `WIRE0004` (v `_ar/prtsc/**` neexistuje žádný screenshot S005) |
| Prázdné stavy / stavy načítání (všechny čtyři obrazovky) | Evidence Pending — nezachyceno | sekce States v `WIRE0001`/`WIRE0002`/`WIRE0003`/`WIRE0004` |
| Text chybových / validačních zpráv (modální okno darování) | Evidence Pending — nezachyceno; žádné BR nevlastní odvozená pravidla | `WIRE0002` Validation Surfaces, otevřená otázka `WIRE0002-Q4` |
| Cílová místa hero preset CTA a category-pill CTA | Uncertain | `WIRE0001` Interactions #8–#9 |
