---
doc_id: WIRE0001
title: Homepage Story Catalogue
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S001
realizes_uc: [UC0023, UC0007, UC0009]
status: canonical
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

# WIRE0001 – Domovská stránka s katalogem příběhů

## Účel

S001 je veřejná domovská stránka a hlavní vstupní bod pro akvizici dárců (`_ar/spec-draft/IA-screen-map.md`
řádek S001; `_ar/spec-draft/IA/IA-patronus.md` §3.1). Umožňuje anonymnímu návštěvníkovi nebo dárci
procházet a filtrovat katalog aktivních příběhů (Campaign / „Příběh“ / Story, `EN0004`) a primárně
realizuje **UC0023** (Procházení a filtrování katalogu příběhů). Ze stránky se vstupuje ještě do dvou
sekundárních use case, které se na ní ale nedokončují: hero přednastavené částky trvalého daru jsou UI
vstupním bodem do rozvrhu trvalého daru (`EN0010`, **UC0007** řídí periodické strhávání částky přes
cron, které tento rozvrh napájí, nikoli krok prováděný na této obrazovce) a CTA „Koupím dobrošek“ pro
nákup poukazu je vstupním bodem k **UC0009** (Uplatnění / validace dárkového poukazu — samotný nákup je
samostatná, nezachycená obrazovka S005). Aktér: anonymní návštěvník / dárce (autentizace se nevyžaduje
— předpoklady UC0023).

Plně zdokumentováno ze čtyř celostránkových screenshotů zachycujících výchozí záložku, záložku
„Samoživitelé“, záložku „Filtrovat podle krajů“ (mapa krajů, nic nevybráno) a screenshot celého scrollu
záložky „Brzy skončí“ (`_ar/evidence/ui/ui-observed-areas.md` §1).

---

## Zóny rozvržení

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

- **Header** — globální navigace webu: logo/odkaz na domovskou stránku, „Jak to funguje“, „Blog“,
  „O nás“, „Požádat o pomoc“ (tlačítko), „Můj účet“ (ikona+popisek). Potvrzeno na všech 4 screenshotech.
- **Hero** — červená headline karta „DARUJME DĚTEM ŠANCI / za jedno kafe měsíčně“ přes ilustrovaný
  banner, fotka mluvčí s hrnkem a tři kruhová přednastavená CTA. Potvrzeno.
- **Stat strip** — velký číselný údaj „323 dětí“ + popisek „čeká na pomoc“ a dvě pilulkovitá CTA
  kategorií („Zdravotní pomoc“ fialová, „Rozvoj a vzdělání“ zelená). Potvrzeno.
- **Filter tabs** — čtyřzáložkový prvek popsaný níže v části Interakce. Potvrzeno.
- **Catalogue grid** — 6 karet příběhu na záložku (kromě záložky s kraji, kde mřížku nahrazuje mapa),
  každá obsahuje: ikonový odznak kategorie, fotografii, odpočítávající stužku „ZBÝVÁ <n> <jednotka>“
  (nebo fialovou stužku „SBÍRKOVÝ ÚČET“ u karty sbírkového účtu), název, progress bar „Chybí <částka>
  Kč“, řádek „Cílová částka“, řádek vybrané částky, CTA tlačítko („Podpořím `<jméno>`“ nebo „Nechám to
  na vás“). Potvrzeno.
- **Podzóna mapy krajů** (pouze na záložce „Filtrovat podle krajů“) — nadpis „Vyberte kraj na mapě“ +
  interaktivní šedá SVG mapa 14 krajů ČR. Potvrzeno (snímek 13_16_21 ji ukazuje v neutrálním,
  nevybraném stavu — žádný kraj není zvýrazněný, pod mapou v tomto zachyceném stavu není zobrazen
  seznam karet).
- **Testimonial band** — růžové pozadí, nadpis „Poděkování od rodin“, úvodní odstavec, jedna citační
  karta (fotografie, text citace, přisouzení „Maminka Angeliny a Viktora“ + popisek), šipky karuselu
  vzad (‹) / vpřed (›). Potvrzeno; identické napříč všemi 4 snímky (nezávislé na záložce).
- **Voucher band** — nadpis „Dobrošeky pro lepší dětství“ + úvodní text + 6 karet nominálních hodnot
  (100, 250, 500, 1000, 5000, 10000 Kč, každá s titulkem „Pro lepší dětství“ a odlišnou ilustrací) +
  tlačítko „Koupím dobrošek“. Potvrzeno; identické napříč všemi 4 snímky.
- **Blok „Jak to funguje?“** — nadpis + 3 sloupce („Vše začíná příběhem“, „Společně zvládneme víc!“,
  „Jen na vás záleží…“), každý s ikonou a krátkým odstavcem. Potvrzeno.
- **Patron explainer band** — červená/růžová karta, nadpis „Kdo je to Patron příběhu?“, vysvětlující
  odstavec, tlačítko „Chci se stát Patronem“, vedle ní fotografie s popiskem „Iveta N., Patronka
  příběhu Nelinky, Zdeňka a Dominika“. Potvrzeno.
- **Loga sponzorů/partnerů** — „Podporují nás“ (BrowserStack, neoznačené logo, CRIF) a „Spřátelené
  organizace“ (Lidé odvedle, Nadace Sirius, Centrum komplexní péče pro děti, Šance Dětem). Potvrzeno.
- **Footer** — popis organizace, odkaz na sociální síť, registrační číslo, sloupec odkazů „Patron
  dětí“ (O nás, Blog, Pravidla poskytování pomoci, Naše desatero, Splněné příběhy, Výroční zprávy,
  „Jak jsme pomáhali v době koronakrize“), sloupec „Kontakt“ (e-mail info@patrondeti.cz), odznaky
  platebních metod (comgate, Mastercard, VISA), číslo sbírkového účtu „57574646/0600“, řádek copyrightu
  a dvojice odkazů „Souhlas se zpracováním osobních údajů“ / „Chci přihlásit příběh“. Potvrzeno.
  Vlastněno IA jako globální chrome — zde není znovu specifikováno, pouze je zaznamenána jeho
  přítomnost (`IA-patronus.md` §2).
- **Banner cookie souhlasu** — overlay vlevo dole, tlačítka „Přijímám“ / „Odmítnout“ + odkaz „Další
  informace“, viditelný/nezavřený na snímku výchozí záložky (13_15_49); chybí na ostatních třech
  snímcích (v té fázi relace zavřen, nebo prescrollován — Assumed, protože jde o pevný overlay, který
  by jinak přetrvával). Potvrzeno přítomen alespoň jednou; chování přetrvávání/zavření je Assumed.

---

## Použité komponenty

Opakující se prvky povýšené na COMP agentem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označené `inline` (nedoloženo opakované použití na ≥2 obrazovkách).

| Zóna | COMP-id | Varianta/Vlastnosti | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Hero | inline | headline banner + 3x kruhové přednastavené CTA | přednastavená CTA jsou vstupním bodem trvalého daru (rozvrh napájený přes `EN0010`, řízený `UC0007`) |
| Stat strip | inline | číselná statistika + 2x pilulkové CTA kategorie | filtrační efekt pilulek kategorií není potvrzen jako provázaný s mřížkou níže (Uncertain — žádná viditelná změna aktivního stavu nezachycena) |
| Filter tabs | inline | 4záložkový segmentovaný ovládací prvek | viz Interakce #2–#5 |
| Catalogue grid | inline | mřížka karet příběhu 3x2 | jedna varianta karty vykresluje stav sbírkového účtu „SBÍRKOVÝ ÚČET“ (`EN0004` skupinový/rodičovský příběh — mechanismus Partial, viz UC0023 Traceability) |
| Story card | COMP0008 | lifecycle=active | opakuje se 6x na záložku; text odpočítávající stužky se liší („ZBÝVÁ MĚSÍC“ / „ZBÝVÁ DEN“ / „ZBÝVÁ N DNÍ“); viz `COMP0008` Story Card |
| Region map | inline | interaktivní SVG choropleta ČR + fallback mobilní `<select>` (dle `UC0023` kroku 8; `<select>` není na tomto snímku desktopové šířky vidět) | „Vyberte kraj na mapě“; kraje s nula aktivními příběhy jsou vykresleny jako disabled dle `UC0023` AF2 — v zachyceném neutrálním/nevybraném stavu vizuálně nerozlišitelné |
| Testimonial carousel | inline | citační karta + šipky vzad/vpřed | není vázán na příběh; nezávislý na záložce |
| Voucher denomination card | inline | 6x karta s pevnou hodnotou | vede ke vstupnímu bodu nákupu poukazu `UC0009` (S005, nezachyceno) přes „Koupím dobrošek“ |
| Blok „Jak to funguje?“ | inline | 3sloupcový icon+text | statický obsah, bez UC |
| Patron explainer band | inline | text + CTA + fotografie | „Chci se stát Patronem“ — na této obrazovce nedoloženo žádné realizující UC (vede do intake, `UC0001`, dle IA) |
| Pruh log sponzorů/partnerů | inline | mřížka log | statický obsah, bez UC |
| Footer | COMP0003 | promo=none | viz `COMP0003` Global Site Footer |
| Banner cookie souhlasu | COMP0004 | actions=dual-action | viz `COMP0004` Cookie Consent Banner |

---

## Interakce

1. **Vstup** — anonymní návštěva `/` → stav: `default`, filtrovací záložka = „Zbývající částka“
   (Potvrzena výchozí přistávací záložka, `UC0023` hlavní tok krok 2). Realizuje `UC0023`.
2. **Primární akce — přepnutí filtrovací záložky: „Samoživitelé“** — kliknutí na záložku → mřížka se
   znovu vykreslí s jinou sadou příběhů (potvrzeno porovnáním obsahu karet mezi 13_15_49 a 13_16_09:
   žádné překrývající se příběhy); realizuje `UC0023` hlavní tok krok 6 / AF1; další stav: `default`
   (záložka = Samoživitelé). Mechanismus filtrování na straně serveru pro tuto záložku je Uncertain
   (`UC0023` AF1) — viditelné chování (změna sady karet) je Confirmed, mechanismus není.
3. **Primární akce — přepnutí filtrovací záložky: „Filtrovat podle krajů“** — kliknutí na záložku →
   mřížka katalogu je nahrazena podzónou mapy krajů („Vyberte kraj na mapě“); realizuje `UC0023`
   hlavní tok krok 7; další stav: `default` (záložka = kraje, mapa nevybraná — toto je zachycený stav,
   13_16_21).
4. **Sekundární akce — výběr kraje na mapě** — kliknutí na kraj na SVG mapě (nebo na mobilní
   `<select>`, na této šířce viewportu nezachyceno) → znovu spustí dotaz katalogu omezený na daný kraj
   a očekává se opětovné vykreslení mřížky karet pod/místo mapy; realizuje `UC0023` hlavní tok kroky
   9–10. **Nezachyceno** — žádný screenshot neukazuje vybraný kraj ani výsledný seznam karet; Assumed
   chování dle důkazů UC0023, pro tuto obrazovku nepotvrzeno screenshotem.
5. **Primární akce — přepnutí filtrovací záložky: „Brzy skončí“** — kliknutí na záložku → mřížka se
   znovu vykreslí seřazená podle nejbližšího termínu (potvrzeno: všech 6 viditelných karet na 13_16_37
   ukazuje krátké odpočty — „ZBÝVÁ DEN“, „ZBÝVÁ 3 DNY“ x3, „ZBÝVÁ 5 DNY“ — konzistentní se vzestupným
   řazením podle termínu); realizuje `UC0023` hlavní tok kroky 11–12; další stav: `default`
   (záložka = Brzy skončí).
6. **Primární akce — CTA na kartě příběhu („Podpořím `<jméno>`“)** — kliknutí → předává do toku daru
   pro zvolený příběh; realizuje `UC0023` hlavní tok kroky 13–14 (hranice předání; samotný dar je
   `UC0005`, mimo rozsah této obrazovky); další obrazovka: S002 (dle `IA-screen-map.md`
   mezimodulového toku, krok toku daru 1→2).
7. **Primární akce — CTA karty sbírkového účtu („Nechám to na vás“)** — kliknutí → stejný vzor předání
   jako #6, cílí na sbírkový/skupinový příběh; další obrazovka: S002 (mechanismus Partial — viz otevřená
   položka `UC0023` Traceability k mapování skupinového příběhu).
8. **Sekundární akce — hero přednastavené CTA („Daruj 90 Kč měsíčně“ / „290 Kč měsíčně“ / „podle
   sebe“)** — kliknutí → vstup do toku nastavení trvalého daru s předvyplněnou přednastavenou (nebo
   vlastní) částkou; toto je UI vstupní bod napájející `RecurringTransaction` (`EN0010`), který `UC0007`
   později podle rozvrhu strhává; samotný krok vytvoření rozvrhu daru je `UC0005` (Provedení daru),
   přímo nedoloženo jako probíhající na S001 — **Uncertain**, která obrazovka/modál se otevře dále
   (žádný screenshot nezachycuje stav po kliknutí z tohoto vstupního bodu).
9. **Sekundární akce — CTA pilulky kategorie („Zdravotní pomoc“ / „Rozvoj a vzdělání“)** — kliknutí →
   předpokládaný filtr/navigace na pohled omezený na kategorii; **Uncertain** — žádné srovnání
   před/po nezachyceno a u žádné pilulky v žádném snímku není pozorován viditelný stisknutý/aktivní
   stav; efekt nepotvrzen.
10. **Sekundární akce — odkaz „Další příběhy“** — kliknutí → předpokládaná stránkování/„načíst další“
    nebo úplná stránka výpisu katalogu; **Uncertain** — nezachyceno nad rámec přítomnosti odkazu.
11. **Sekundární akce — „Koupím dobrošek“** — kliknutí → předává na obrazovku nákupu poukazu (S005,
    nezachyceno); vstupní bod k cyklu uplatnění `UC0009` (samotný nákup předchází krokům
    validace/uplatnění UC0009). Další obrazovka: S005 (jistota Uncertain dle `IA-screen-map.md`).
12. **Sekundární akce — karusel testimoniálů vzad/vpřed** — kliknutí ‹ / › → cykluje jedinou viditelnou
    citační kartu; **Uncertain**, kolik testimoniálů celkem existuje (v žádném snímku je zobrazen jen
    jeden).
13. **Sekundární akce — „Chci se stát Patronem“** — kliknutí → předpokládaný vstup do cesty intake
    Patrona; pro tento konkrétní cíl kliknutí na S001 nedoloženo žádné realizující UC (`UC0001` obecně
    řídí podání žádosti, dle IA); další obrazovka Uncertain — nezachyceno.
14. **Výstup** — návštěvník odchází přes navigaci v hlavičce („Jak to funguje“, „Blog“, „O nás“,
    „Požádat o pomoc“, „Můj účet“) nebo odkazy v patičce — každý je cíl navigace vlastněný IA, zde
    znovu nepopsáno.
15. **Akce banneru cookie souhlasu** — „Přijímám“ / „Odmítnout“ zavírají banner; „Další informace“
    pravděpodobně otevírá detail cookie zásad (cíl odkazu nezachycen). Potvrzena přítomnost banneru a
    popisky tlačítek; chování při zavření je Assumed (standardní vzor consent banneru, samo o sobě
    nepozorováno v páru před/po).

---

## Stavy

### default
Mřížka katalogu (nebo mapa krajů, na dané záložce) načtená s obsahem, jak je zobrazeno na všech
čtyřech screenshotech. Potvrzeno pro všechny čtyři filtrovací záložky: „Zbývající částka“ (13_15_49),
„Samoživitelé“ (13_16_09), „Filtrovat podle krajů“ — mapa neutrální/nevybraná (13_16_21), „Brzy
skončí“ (13_16_37).

### empty
Zobrazeno, když: kombinace filtru/kraje vrátí nula aktivních příběhů (`UC0023` AF4 — systém vrací
`total_count = 0`). **Evidence Pending — nezachyceno.** Žádný screenshot neukazuje stav nulového
výsledku pro žádnou záložku ani kraj. Vizuální zpracování a cesta obnovy (např. zpráva o prázdném
stavu, akce „vymazat filtr“) jsou Uncertain — nepředpokládejte konkrétní zpracování.

### loading
Zobrazeno, když: přepnutí záložky nebo výběr kraje spustí nový dotaz (`UC0023` hlavní tok kroky 3–4,
10, 12). **Evidence Pending — nezachyceno.** V žádném snímku není vidět stav skeletonu/spinneru/
zablokované interakce (všechny čtyři jsou ustálené, plně vykreslené koncové stavy). Uncertain, zda pro
AJAX přepínání záložek na této obrazovce vůbec existuje indikátor načítání.

### error
Zobrazeno, když: dotaz katalogu na straně serveru selže, nebo se nepodaří načíst fragment výběru kraje
(`/campaign/regions/render`, dle `UC0023` hlavního toku kroku 8). **Evidence Pending — nezachyceno.**
Žádný chybový stav nebyl pozorován; Uncertain, zda pro tuto obrazovku existuje uživatelsky viditelná
chybová zpráva, nebo jde o tiché selhání (např. prázdná mřížka nerozlišitelná od stavu `empty` výše).

---

## Validační plochy

Na této obrazovce podle aktuálních důkazů neexistuje žádné zadávání dat do formuláře — jde o plochu
pro procházení/filtrování (záložky, mapa výběru kraje a CTA tlačítka), nikoli krok zadávání dat.
`UC0023` je výslovně „čistá schopnost čtení/procházení: nemění stav Campaign ani Application“, takže
zde žádné `BRxxxx` nebrání odeslání formuláře.

| Pole/Zóna | Trigger (BR-id) | Plocha |
|---|---|---|
| — | — | N/A — na S001 nedoloženo žádné pole formuláře |

**validationsWithoutBR:** žádné — na této obrazovce není podle dostupných důkazů co validovat (pro
čistou plochu procházení/filtrování žádné BR neexistuje ani není potřeba; nejde o otevřenou otázku).

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Catalogue grid (všechny záložky) | `EN0004` | — | Projekce karty příběhu: fotografie, kategorie, název, cílová vs. vybraná částka, příznak viditelnosti zbývající částky, termín/zbývající čas, text CTA — dle `UC0023` hlavního toku kroku 5. V této rekonstrukční etapě neexistuje žádné QUERY-id (vrstva QUERY zatím nevytvořena); podkladová čtecí smlouva je `CampaignsResource` dle `UC0023` Traceability, zde znovu nepopsáno. |
| Story card — odznak Patrona (ikona na kartě, pokud je přítomna) | `EN0005` | — | Veřejný profil Patrona zobrazený za kartu; pozorováno jako malá ikona odznaku v rohu každé karty (přítomnost ikony Confirmed dle screenshotů; provázání odznaku s profilem Patrona je Probable, odvozeno z `UC0023` Aktéři — v důkazech nepotvrzeno jako samostatný klikatelný prvek). |
| Region map — počty aktivních příběhů podle kraje | `EN0004` | — | Živé počty řídí zakázání krajů s nulovým počtem (`UC0023` hlavní tok krok 8, AF2); na zachycené mapě nejsou nezávisle vykresleny jako viditelná čísla (13_16_21 ukazuje pouze neutrální šedou mapu, na této úrovni přiblížení/detailu nejsou vidět žádné popisky s počty). |
| Stat strip číselný údaj („323 dětí čeká na pomoc“) | `EN0004` | — | Souhrnný počet příběhů čekajících na pomoc; přesný zdrojový dotaz Uncertain — nepotvrzeno, zda odráží stejnou filtrovanou sadu jako aktivní záložka, nebo globální nefiltrovaný počet (mezi záložkami nebyla pozorována žádná změna číselného údaje — hodnota „323“ je stejná na všech čtyřech snímcích, což naznačuje, že NENÍ vázána na záložku — Probable). |
| Hero přednastavená CTA (90 / 290 / vlastní Kč) | `EN0010` | — | Napájí rozvrh `RecurringTransaction` při vytvoření; S001 samo pouze prezentuje přednastavené částky, nečte ani nezobrazuje data existujícího rozvrhu. |
| Karty nominálních hodnot poukazu | `EN0013` | — | Nabízeny pevné nominální hodnoty (100/250/500/1000/5000/10000 Kč) k nákupu; S001 nečte stav uplatnění poukazu (Voucher redemption) — jde o vstupní plochu nákupu pro cyklus `EN0013`, který `UC0009` později validuje/uplatňuje. |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | nedoloženo | Veřejně/anonymně dostupná; v této rekonstrukci neexistuje vrstva ACL (`IA-patronus.md` §9). Nepozorováno žádné omezení podle role — všechny čtyři snímky byly pořízeny jako anonymní návštěvník. |
| Položka „Můj účet“ v hlavičce | nedoloženo (bez přihlášení směruje na přihlášení S009, dle IA) | Nejde o podmínku viditelnosti na samotném S001 — popisek/ikona je přítomna bez ohledu na stav autentizace; liší se pouze její cíl (`IA-patronus.md` §2). Zde znovu nespecifikováno. |
| Banner cookie souhlasu | stav souhlasové cookie relace (implementační detail, nikoli ACL/BR) | Pokud byl v rámci relace již dříve zavřen, banner se nevykresluje (Assumed z jeho absence ve 3 ze 4 snímků — nejde o podmínku vázanou na roli ani BR). |

Na S001 není v žádném snímku vidět žádná interakce ve stylu AF3 vázaná na přihlášeného dárce (`UC0023`
AF3: `filter_user_interacted_campaigns` / `filter_user_recommended_campaigns`) jako záložka ani
ovládací prvek — konzistentní s vlastní poznámkou `UC0023`, že tyto „nejsou potvrzeny jako UI plocha
záložky veřejného katalogu“.

---

## Poznámky k přístupnosti

Evidence Pending — nezachyceno. Statické screenshoty nepotvrzují pořadí procházení tabulátorem,
chování fokusu, role landmarků ani ovládání klávesnicí pro tuto obrazovku.

- **Pořadí procházení tabulátorem:** Uncertain — ze statických snímků nedoloženo.
- **Fokus při vstupu:** Uncertain.
- **Fokus při přechodu stavu (přepnutí filtrovací záložky):** Uncertain — zda se při přepnutí záložky
  fokus přesune na nově vykreslenou mřížku/mapu (osvědčený postup přístupnosti pro AJAX výměnu obsahu)
  není doloženo ani jedním směrem.
- **Landmarky:** Uncertain — čtyři segmentované filtrovací záložky vizuálně připomínají vzor
  tab-panelu (`role="tablist"`/`tab`/`tabpanel`), ale v této pouze screenshotové etapě neexistuje
  žádný DOM/ARIA důkaz potvrzující, že jsou takto implementovány, versus obyčejná tlačítka nebo
  odkazy.
- **Klávesové zkratky:** žádné nedoloženy.

---

## Důkazy

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Header nav, hero, stat strip, filter tabs, catalogue grid, testimonial band, voucher band, „Jak to funguje?“, Patron explainer band, sponsor logos, footer, cookie banner — přítomnost a obsah | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `13_16_09.png`, `13_16_21.png`, `13_16_37.png`; `_ar/evidence/ui/ui-observed-areas.md` §1 |
| Výchozí přistávací záložka = „Zbývající částka“ | Confirmed | 13_15_49.png; `UC0023` hlavní tok krok 2 |
| Přepnutí záložky mění sadu karet (Samoživitelé, Brzy skončí) | Confirmed (viditelný efekt) / Uncertain (mechanismus pro Samoživitelé) | 13_15_49.png vs 13_16_09.png vs 13_16_37.png; `UC0023` AF1 |
| Záložka s mapou krajů nahrazuje mřížku mapou „Vyberte kraj na mapě“, neutrální/nevybraný stav | Confirmed | 13_16_21.png |
| Výsledek výběru kraje (seznam karet po kliknutí) | Evidence Pending — nezachyceno | žádný screenshot neukazuje vybraný kraj |
| Mechanismus karty sbírkového účtu / „SBÍRKOVÝ ÚČET“ (typ/mapování na rodiče) | Partial | `UC0023` Traceability otevřená položka; `_ar/spec-draft/EN/EN0004_Campaign.md` |
| Hero přednastavené CTA → vstupní bod trvalého daru | Probable | `_ar/spec-draft/EN/EN0010_RecurringTransaction.md`; `UC0007` Předpoklady (rozvrh vzniká z daru, nikoli z tohoto cron UC samotného); žádný screenshot po kliknutí |
| „Koupím dobrošek“ → vstupní bod nákupu poukazu | Probable | `_ar/spec-draft/EN/EN0013_Voucher.md`; `UC0009` Předpoklady; cílová obrazovka S005 nezachycena dle `IA-screen-map.md` |
| Stavy empty / loading / error | Evidence Pending — nezachyceno | žádný screenshot tyto stavy pro S001 neukazuje |
| Přístupnost (pořadí tabulátoru, fokus, landmarky) | Uncertain | ze statických screenshotů nedoloženo |
| Efekt CTA pilulky kategorie, cíl odkazu „Další příběhy“, počet testimoniálů, cíl „Chci se stát Patronem“ | Uncertain | přítomnost potvrzena ve screenshotech; chování/cíl nezachyceno |
</content>
