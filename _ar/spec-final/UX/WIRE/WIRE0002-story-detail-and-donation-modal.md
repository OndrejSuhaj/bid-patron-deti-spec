---
doc_id: WIRE0002
title: Story Detail And Donation Modal
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S002
realizes_uc: [UC0005, UC0011, UC0009]
status: canonical
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

# WIRE0002 – Detail příběhu a modální okno daru

## Účel

Veřejná detailová stránka Příběhu (Story) pro jeden Campaign (`EN0004`), kterou čte anonymní
návštěvník nebo již přihlášený dárce. Prezentuje případ pomoci (dítě, kategorie, komentář
Patrona, cílová/zbývající částka) a je vstupní plochou pro tři záměry související s darem,
které jsou realizovány jinde ve vrstvě domény: zadání jednorázového nebo trvalého daru
(`UC0005`), zobrazení veřejného stavu životního cyklu Campaign jako vykreslovaného progresu
(`UC0011` — tato obrazovka pouze *zobrazuje* odvozené hodnoty vybrané částky/procenta, které
počítá `UC0011`/`BR-CampaignStoryLifecycle`; neprovádí žádný přechod životního cyklu), a
zahájení uplatnění poukazu ("Mám dobrošek", `UC0009`). Modální okno daru ("Chystáte se
přispět") je sekundární vrstva otevřená nad touto obrazovkou, která sbírá částku, kontakt a
souhlasy před předáním platební bráně (`S-EXT1`, mimo rozsah WIRE).

Aktér: anonymní návštěvník (Customer, dle `UC0005`) nebo přihlášený dárce. Na základní stránce
nebyla pozorována žádná roleová brána.

Kontext vstupu: navigace z katalogu na hlavní stránce (`S001`) nebo přímý/sdílený odkaz na
Příběh (`/pribeh/<slug>`); IA `Cross-Module Flows`, krok 1–2.

Jistota: Confirmed — obsah obrazovky i modálního okna byl přímo zachycen (viz Evidence).

---

## Zóny rozvržení

- **Hlavička** — globální navigace webu (logo "patron dětí", "Jak to funguje", "Blog", "O nás",
  CTA "Požádat o pomoc", "Můj účet") — vlastní IA, zde nerekonstruováno.
- **Pás nadpisu** — název Příběhu ("Balík školních potřeb pro Sofinku").
- **Mediální zóna** — hero fotografie Příběhu (dítě).
- **Karta komentáře Patrona** — štítek "PATRON PŘÍBĚHU", jméno/role Patrona (`EN0005`), avatar,
  přepínač/odkaz "Zobrazit komentář Patrona", text komentáře.
- **Text příběhu** — dlouhý narativní text (nadpis + odstavce + odrážkový seznam důvěry: "100 %
  daru jde na pomoc dětem", "peníze neposíláme rodinám...", "všechny žádosti pečlivě posuzuje naše
  oddělení risku", "každou žádost potvrzuje Patron").
- **Postranní panel daru (sticky-right)** — v zachycené stránce se opakuje dvakrát (jednou vedle
  hero fotografie, jednou níže vedle textu — viz Otevřená otázka níže):
  - kategorijní štítek ("Rozvoj a vzdělání") s ikonou
  - "Přispět můžete na" + popis věcné pomoci ("balík školních potřeb; dodává SEVT")
  - ilustrační ikona (batoh)
  - blok progresu: "Chybí 1 600 Kč" + progress bar + "Zbývá měsíc" / "Cílová částka 1 600 Kč"
  - vstupní pole jednorázové částky ("Chci darovat", Kč, předvyplněno `50`) + CTA "Přispět 🤝"
    (pozorovány × 2 zásobené instance — Otevřená otázka)
  - mikrotext "Na pomoc dětem putuje vždy 100 % z darované částky" pod každým CTA
  - blok trvalého daru: "Přeji si podporovat rozvoj a vzdělání pravidelně" + CTA "Chci podporovat
    rozvoj a vzdělání" (zelené)
  - blok poukazu: CTA "Mám dobrošek" (červené, ikona lístku) + odkaz "Chcete věnovat dobrošek?"
  - řádek sdílení: ikony Facebook / X / Instagram / LinkedIn / WhatsApp / Messenger
- **Banner důvěry (na celou šířku)** — červený pruh, "Na pomoc dětem putuje vždy 100 % částky,
  kterou darujete."
- **Lišta souvisejících příběhů** — "Aktuálně čekají na vaši pomoc" + 3 karty (fotografie, odznak
  odpočtu "ZBÝVÁ MĚSÍC"/"ZBÝVÁ 16 DNÍ", stužka "Chybí N Kč", jméno+přání, "Cílová částka N Kč",
  CTA "Podpořím <jméno>") + odkaz "Další příběhy".
- **Modální okno daru (overlay, po Primární akci)** — zpětný odkaz "Zpět na příběh", titulek
  "Chystáte se přispět" + pole částky (Kč), kontaktní pole (E-mail, telefon +420, Jméno,
  Příjmení), dva zaškrtávací souhlasy, CTA "Přejít k platbě", nápovědný text "Po přesměrování na
  platební bránu...".
- **Patička** — globální patička webu — vlastní IA, zde nerekonstruováno.

```
+--------------------------------------------------------------+
| Hlavička (IA)                                                   |
+--------------------------------------------------------------+
| Název příběhu                                                   |
+---------------------------------+----------------------------+
| Média (hero fotografie)         | kategorijní štítek           |
| Karta komentáře Patrona         | "Přispět můžete na" + ikona |
|                                  | progres + "Chci darovat"    |
|                                  | + CTA "Přispět"              |
|                                  | CTA trvalý dar                |
|                                  | CTA "Mám dobrošek"           |
|                                  | řádek sdílení                 |
+---------------------------------+----------------------------+
| Text příběhu                    | (panel se opakuje — Open Q)|
+---------------------------------+----------------------------+
| Banner důvěry (na celou šířku)                                  |
+--------------------------------------------------------------+
| Lišta souvisejících příběhů (3 karty)                           |
+--------------------------------------------------------------+
| Patička (IA)                                                    |
+--------------------------------------------------------------+

Modální okno daru (overlay):
+----------------------------------------+
| < Zpět na příběh   Chystáte se přispět  [50 Kč] |
+----------------------------------------+
| E-mail (povinný)                        |
| +420 | Telefon                          |
| Jméno            | Příjmení              |
| [ ] Souhlasím s pravidly...              |
| [ ] Souhlasím se zpracováním...          |
|          [ Přejít k platbě ]             |
| nápověda: poznámka o metodě brány        |
+----------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP pomocí **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označeny `inline` (nebylo doloženo opakované použití na ≥2
obrazovkách, nebo je opakované použití Uncertain — viz poznámky).

| Zóna | COMP-id | Varianta/Vlastnosti | Poznámky |
|---|---|---|---|
| Hlavička | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Pás nadpisu | inline | h1 | název Příběhu |
| Mediální zóna | inline | hero obrázek | jediná fotografie, žádná galerie/carousel nepozorováno |
| Karta komentáře Patrona | inline | avatar + jméno + role + přepínač + text | váže `EN0005` |
| Text příběhu | inline | blok formátovaného textu | dlouhý narativní text + odrážkový seznam |
| Blok progresu | inline | popisek + progress bar + dvouřádková statistika (Zbývá / Cílová částka) | váže odvozená pole `EN0004` (viz Datové vazby); Uncertain, zda sdílí komponentu s vnitřními údaji progresu `COMP0008` Story Card — shoda nepotvrzena, ponecháno inline (viz Otevřené otázky `COMP0008`) |
| Vstupní pole částky | inline | číselné pole, přípona Kč, předvyplněno `50` | dvě instance zásobené v evidenci (Otevřená otázka) |
| Primární CTA daru ("Přispět 🤝") | COMP0001 | icon=🤝 | viz `COMP0001` Primary Button |
| CTA trvalého daru ("Chci podporovat... pravidelně") | inline | sekundární/zelené tlačítko | příznak záměru do `UC0005` (větev trvalého daru); samostatná obrazovka trvalého daru zde nebyla pozorována; vizuální identita Uncertain vůči `COMP0001` — viz Otevřené otázky `COMP0001` (sekundární varianta tlačítka nebyla povýšena) |
| CTA poukazu ("Mám dobrošek") | inline | sekundární/červené tlačítko, ikona lístku | vstupní bod do `UC0009` — cílová obrazovka nebyla zachycena (IA `S005`, Uncertain) |
| Řádek sdílení | inline | řádek ikonových tlačítek | Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger — žádné chování sdílení nebylo pozorováno nad rámec přítomnosti ikon |
| Banner důvěry | inline | textový pruh na celou šířku | statický text, nevázaný na entitu |
| Karta souvisejícího příběhu | inline | fotografie + odznak odpočtu + stužka progresu + jméno + cílová částka + CTA | opakuje vzor karty katalogu ze `S001`; vizuálně blízké `COMP0008` Story Card, ale vykreslované v layoutu postranního panelu "související" — shoda nepotvrzena, ponecháno inline do jasnějších důkazů |
| Plášť modálního okna daru | inline | overlay/dialog, hlavička + zavřít/zpět | otevírá se primárním CTA |
| Pole částky v modálním okně | inline | číselné pole, přípona Kč, předvyplněno `50`, editovatelné v hlavičce modálního okna | váže částku daru |
| Kontaktní pole v modálním okně | inline | E-mail (povinný), telefon (předvolba +420), Jméno, Příjmení | váže `EN0006`/`EN0008` (viz Datové vazby) |
| Zaškrtávací souhlasy v modálním okně (×2) | COMP0006 | count-per-form=double | podmiňují odeslání `UC0005` (Otevřená otázka — nenalezeno BR, viz Validační plochy); viz `COMP0006` Consent Checkbox |
| Primární CTA modálního okna ("Přejít k platbě") | COMP0001 | — | odesílá `UC0005`, předává `S-EXT1`; viz `COMP0001` Primary Button |
| Nápovědný text modálního okna | inline | statický mikrotext | popisuje následnou volbu brány; není obsah editovatelný v aplikaci, spravováno vrstvou COPY |

---

## Interakce

1. **Vstup** — navigace z karty katalogu `S001` nebo přímý odkaz `/pribeh/<slug>` → stav:
   `default`.
2. **Primární akce — otevření modálního okna daru** — klik na "Přispět 🤝" (kterákoli instance v
   postranním panelu) → otevře se modální overlay předvyplněný částkou zadanou ve spouštěcím poli
   "Chci darovat" (pozorováno výchozích `50` Kč přenesených do pole v hlavičce modálního okna);
   realizuje vstup do `UC0005`; dále: stav modálního okna `default`.
3. **Primární akce — odeslání daru** — vyplnění/potvrzení polí modálního okna, zaškrtnutí obou
   souhlasů, klik na "Přejít k platbě" → realizuje `UC0005` (hlavní tok UC0005.1–UC0005.3); dále:
   přesměrování na `S-EXT1` (hostovaná brána Comgate, mimo rozsah WIRE) při úspěchu, nebo plocha
   pro validaci inline při neúspěchu (viz Stavy → error, Validační plochy).
4. **Sekundární akce — záměr trvalého daru** — klik na "Chci podporovat rozvoj a vzdělání" →
   Assumed otevření stejného nebo rovnocenného modálního okna daru s nastaveným příznakem trvalého
   daru (`UC0005.2`); prvek modálního okna specifický pro trvalý dar (např. přepínač) **není
   pozorován** na zachycených snímcích modálního okna — Uncertain (Otevřená otázka).
5. **Sekundární akce — vstup do uplatnění poukazu** — klik na "Mám dobrošek" / "Chcete věnovat
   dobrošek?" → Assumed otevření plochy pro zadání kódu poukazu, která zásobuje `UC0009`; **cílová
   plocha nebyla zachycena** na této obrazovce (IA `S005`/zadání poukazu, Uncertain) — Otevřená
   otázka.
6. **Sekundární akce — čtení komentáře Patrona** — klik na "Zobrazit komentář Patrona" → Assumed
   chování rozbalení/scroll-to (přepínací štítek pozorován; rozbalený i sbalený stav nebyly
   zachyceny oba) — Uncertain.
7. **Sekundární akce — CTA podpory kategorie** — "Chci podporovat rozvoj a vzdělání" slouží
   zároveň jako vstup podpory na úrovni kategorie dle řádku účelu IA S002; podle důkazů stejný cíl
   jako CTA trvalého daru (samostatný tok pouze pro kategorii nebyl pozorován) — Assumed.
8. **Sekundární akce — navigace na související příběh** — klik na CTA souvisejícího příběhu
   ("Podpořím Románka"/"Petrušku"/"Miu") → naviguje na vlastní instanci `S002` daného Příběhu
   (jiný `/pribeh/<slug>`); klik na "Další příběhy" → Assumed návrat na katalog `S001`.
9. **Výstup — zrušení modálního okna** — klik na "Zpět na příběh" → zavře modální okno, návrat do
   stavu `default` této obrazovky, bez změny stavu `EN0009`.
10. **Výstup — úspěšné odeslání** — viz interakce 3; přesměrování mimo obrazovku na `S-EXT1` →
    `S-EXT2` → `S003` (dle IA Cross-Module Flow "Donation & payment flow").

---

## Stavy

### default
Detailová stránka Příběhu jak byla zachycena: hero fotografie, karta komentáře Patrona, text
příběhu, postranní panel s progresem/CTA, banner důvěry, lišta souvisejících příběhů. Confirmed —
`screencapture-...-13_25_48.png`.

### empty
Nepozorováno. Nebylo zachyceno žádné zpracování "Příběh odstraněn / naplněn / nenalezen". Vzhledem
k `UC0005` AF2 ("Campaign missing or already fully funded" odmítá dar, ale nepopisuje vykreslení
stránky Příběhu pro již plně naplněný nebo odlistovaný Příběh), je zpracování prázdného/uzavřeného
stavu na úrovni stránky Uncertain — Otevřená otázka, nevymýšleno zde.

### loading
Nepozorováno. Nebyl zachycen žádný stav spinneru/skeletonu ani pro stránku, ani pro modální okno
(např. v okamžiku, kdy "Přejít k platbě" odesílá požadavek na předání brány v `UC0005.3`). Assumed,
že existuje (síťový round-trip je nutný před přesměrováním na bránu), ale jeho vizuální zpracování
je Uncertain — Otevřená otázka.

### error
Nepozorováno jako vykreslený UI stav. `UC0005` AF1 (neplatná/nenumerická částka) a AF2 (Campaign
missing or fully funded) definují *výsledky* odmítnutí, ale žádný snímek neukazuje inline chybovou
zprávu, toast nebo chybové stylování na úrovni pole na této obrazovce nebo v jejím modálním okně.
Deklarováno v souladu s disciplínou WIRE, nikoli vymyšleno — Uncertain — Otevřená otázka (viz
Validační plochy).

---

## Validační plochy

| Pole/Zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| Pole částky v modálním okně | `UC0005` AF1 (částka musí být numerická) — žádné BR tuto pravidlo nevlastní | Uncertain — nepozorována žádná chybová plocha; uvedeno v Otevřených otázkách (BR id není k dispozici, nevymýšleno) |
| Pole částky v modálním okně vůči naplnění Campaign | `UC0005` AF2 / `BR-PaymentAndMoneyIntegrity` ("odmítnout dar odeslaný proti Campaign, jejíž běžící vybraná celková částka již dosahuje nebo přesahuje cílovou částku") | Uncertain — na této obrazovce nepozorována žádná chybová plocha |
| Pole "E-mail (povinný)" v modálním okně | V textu označeno jako povinné ("povinný"); pro tuto obrazovku nebylo nalezeno BR upravující formát/povinnost e-mailu | Uncertain — bez BR id; otevřená otázka |
| Zaškrtávací souhlas 1 v modálním okně ("Souhlasím s pravidly poskytování pomoci") | Nebylo nalezeno BR podmiňující odeslání tímto zaškrtávacím polem | Uncertain — bez BR id; otevřená otázka |
| Zaškrtávací souhlas 2 v modálním okně ("Souhlasím se zpracováním osobních údajů") | Nebylo nalezeno BR podmiňující odeslání tímto zaškrtávacím polem; `BR-DataProtectionAndErasure` upravuje GDPR výmaz/zpracování obecně, ale nespecifikuje tuto podmínku na úrovni UI zaškrtávacího pole | Uncertain — bez BR id; otevřená otázka |

**validationsWithoutBR:** kontrola numerického formátu částky v modálním okně, kontrola
povinnosti e-mailu, oba zaškrtávací souhlasy — žádný z nich nemá ve stávající vrstvě BR
vlastnící `BRxxxx`; jde o viditelné prvky formuláře na snímku, ale vynucující pravidlo (pokud
existuje nad rámec textu `UC0005`) není samostatně kodifikováno. Zaznamenáno jako Otevřené otázky,
nikoli vymyšlená BR id.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Pás nadpisu | `EN0004` | — | veřejný název Campaign |
| Mediální zóna | `EN0004` | — | obrazový materiál Campaign (atribut povinného obrázku dle `BR-CampaignStoryLifecycle`) |
| Kategorijní štítek ("Rozvoj a vzdělání") | `EN0004` | — | atribut `gift_category` |
| Popis věcné pomoci ("balík školních potřeb; dodává SEVT") | `EN0004` | — | volný text popisu případu; přesný vlastnící atribut nepotvrzen — Uncertain |
| Karta komentáře Patrona | `EN0005` | — | jméno/fotografie Patrona (atributy `EN0005`); vlastnictví textu komentáře (Patron vs. narativ Žádosti) nepotvrzeno — Uncertain |
| Blok progresu ("Chybí 1 600 Kč", bar, "Zbývá měsíc", "Cílová částka") | `EN0004` | — | odvozené `campaign_raised` / `campaign_percentual_raised` vůči `gift_price` (cíl) a `campaign_deadline`, dle `BR-CampaignStoryLifecycle`; tato obrazovka pouze vykresluje odvozené hodnoty, nepočítá je |
| Pole částky v modálním okně | `EN0009` | — | při odeslání se stává `Transaction.amount` (`UC0005.1` krok 10) |
| E-mail / Jméno / Příjmení / telefon v modálním okně | `EN0006`, `EN0008` | — | přiřazuje/vytváří dárcovský `User` (`EN0008`) a navázaný `Contact` (`EN0006`) dle `UC0005.1` kroky 4–7 |
| Záměr CTA trvalého daru | `EN0010` | — | pokud je požadován trvalý dar, vytvoří se `RecurringTransaction` dle `UC0005.2` |
| Vstup "Mám dobrošek" | `EN0013` | — | zásobuje uplatnění poukazu `UC0009`; samotná plocha pro uplatnění je mimo zachycený rozsah této obrazovky |
| Karty souvisejících příběhů | `EN0004` | — | každá karta je jiná instance Campaign (vlastní pole progresu/cíle) |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (ACL nebo BR ref) | Chování při skrytí |
|---|---|---|
| CTA trvalého daru ("...pravidelně") | Vrstva ACL ještě neexistuje; nebyla pozorována žádná roleová brána — v evidenci viditelné pro anonymní návštěvníky | n/a — Confirmed vždy viditelné v zachycené evidenci |
| CTA "Mám dobrošek" / poukaz | Vrstva ACL ještě neexistuje; nebyla pozorována žádná roleová brána | n/a — Confirmed vždy viditelné v zachycené evidenci |
| Předvyplnění kontaktních polí modálního okna (E-mail/Jméno/Příjmení/telefon) | V evidenci pozorováno předvyplněné testovacími daty (`screencapture-...-13_26_21.png`), pokud prohlížeč/relace již obsahovala data pro automatické vyplnění; zda **přihlášený** dárce vidí tato pole předvyplněná ze svého záznamu `User`/`Contact` (na rozdíl od automatického vyplnění prohlížečem) nelze z této evidence rozlišit — Uncertain, Otevřená otázka | pole by u prvního anonymního návštěvníka pravděpodobně byla prázdná — Assumed, přímo nepozorováno |
| Duplicitní blok postranního panelu (progres/CTA/sdílení, objevuje se dvakrát v zachycení celé stránky) | Nevyřešeno podmínkou ACL/BR — pravděpodobně artefakt šablony/layoutu dvoukolonového reflow, nikoli funkce podmíněná rolí nebo stavem | Uncertain — Otevřená otázka, nevymýšleno jako záměrné |

---

## Poznámky k přístupnosti

- **Pořadí tabulátoru:** Assumed, že sleduje vizuální pořadí (média → odkaz na kartu Patrona →
  text → vstupní pole částky v postranním panelu → tlačítka CTA → ikony sdílení); nelze ověřit ze
  statických snímků — Uncertain.
- **Fokus při vstupu:** Nepozorováno; Assumed výchozí fokus prohlížeče (vrchol dokumentu) při
  načtení stránky.
- **Fokus při přechodu stavu (otevření modálního okna):** Nepozorováno, zda se fokus přesune do
  modálního okna (např. na pole částky nebo odkaz zavřít/zpět) po kliknutí na "Přispět" —
  Uncertain, Otevřená otázka; chování WCAG dialog-focus-trap nelze ze samotných snímků potvrdit.
- **Landmarks:** Nedoloženo ze snímků (v tomto průchodu nebyla provedena inspekce DOM/ARIA);
  Uncertain.
- **Klávesové zkratky:** Nepozorovány žádné; nebyly doloženy žádné zkratky specifické pro
  obrazovku.

---

## Otevřené otázky

| # | Otázka | Dopad | Stav |
|---|---|---|---|
| WIRE0002-Q1 | Proč se postranní panel daru (progres + CTA + řádek sdílení) v zachycení celé stránky zdá opakovat dvakrát — artefakt dvoukolonového reflow, nebo dva skutečně odlišné bloky (např. sticky vs. statická kopie)? | Ovlivňuje duplicitu Zón rozvržení / Použitých komponent | open |
| WIRE0002-Q2 | Otevírá CTA "Chci podporovat rozvoj a vzdělání" (trvalý dar) stejné modální okno daru s příznakem trvalého daru, nebo odlišné modální okno/obrazovku? | Ovlivňuje Interakci #4, vazbu na `UC0005.2` | open |
| WIRE0002-Q3 | Kam navigují "Mám dobrošek" / "Chcete věnovat dobrošek?" — existuje vyhrazená plocha pro uplatnění poukazu a je to táž plocha jako nezachycená obrazovka nákupu poukazu `S005`? | Ovlivňuje Interakci #5, vazbu na vstup `UC0009` | open (cross-ref IA-Q10) |
| WIRE0002-Q4 | Existuje nějaké UI pro validaci inline u neplatné částky, chybějícího e-mailu, nezaškrtnutých souhlasů nebo plně naplněné Campaign — nebo se stávající implementace spoléhá výhradně na odmítnutí bránou/backendem bez viditelného chybového stavu na straně klienta? | Ovlivňuje Stavy → error, Validační plochy | open |
| WIRE0002-Q5 | Existuje indikátor načítání mezi "Přejít k platbě" a přesměrováním na `S-EXT1`? | Ovlivňuje Stavy → loading | open |
| WIRE0002-Q6 | Přepíná/rozbaluje "Zobrazit komentář Patrona" obsah, nebo odkazuje jinam? | Ovlivňuje Interakci #6 | open |

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Rozvržení celé stránky (nadpis, média, karta Patrona, text, postranní panel, banner důvěry, lišta souvisejících) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`; `ui-observed-areas.md` §2 |
| Modální okno daru — prázdná/výchozí kontaktní pole, částka `50` Kč, nezaškrtnuté souhlasy | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_08.png` |
| Modální okno daru — vyplněná kontaktní pole (automatické vyplnění/testovací data), zaškrtnuté souhlasy | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png`; `ui-observed-areas.md` §2 |
| Vykreslení progresu/cílové částky navazuje na odvozená pole `EN0004`/`BR-CampaignStoryLifecycle` | Probable | `_ar/spec-draft/EN/EN0004_Campaign.md`; `_ar/spec-draft/BR/BR-CampaignStoryLifecycle.md` |
| Pole toku odeslání daru (`UC0005`) se mapují na `EN0009`/`EN0006`/`EN0008` | Confirmed | `_ar/spec-draft/UC/UC0005_MakeADonation.md` |
| Vstup poukazu se mapuje na `UC0009`/`EN0013` | Probable | `_ar/spec-draft/UC/UC0009_RedeemValidateVoucher.md`; CTA vstupu pozorováno, ale cílová obrazovka nebyla zachycena |
| Relevance `UC0011` (zobrazený progres je vypočten v UC0011, nikoli na obrazovce) | Confirmed (jako nevlastnící odkaz) | `_ar/spec-draft/UC/UC0011_ManageCampaignStoryLifecycle.md` |
| stavy empty/loading/error, správa fokusu, duplicitní postranní panel, cílové plochy trvalého daru/poukazu | Uncertain | nezachyceno na žádném snímku — viz Otevřené otázky |
