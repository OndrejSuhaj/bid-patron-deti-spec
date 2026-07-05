---
doc_id: WIRE0001
title: Homepage Story Catalogue
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S001
realizes_uc: [UC0023, UC0007, UC0009]
status: imported
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

## Účel

S001 je veřejná domovská stránka a primární vstupní stránka pro akvizici dárců
(`_ar/spec-draft/IA-screen-map.md` řádek S001; `_ar/spec-draft/IA/IA-patronus.md` §3.1). Umožňuje
anonymnímu návštěvníkovi nebo dárci procházet a filtrovat katalog aktivních Kampaní ("Příběh"/Story,
`EN0004`), přičemž primárně realizuje **UC0023** (Procházení a filtrování katalogu příběhů). Z této
obrazovky se vstupuje do dvou dalších use case, které na ní ale nejsou dokončeny: předvyplněné
částky trvalého daru v hero sekci jsou UI vstupní bod do harmonogramu trvalého daru
(`EN0010`, **UC0007** řídí periodické strhávání plateb na straně cronu, které tento harmonogram
napájí, nikoli krok probíhající na této obrazovce) a CTA pro nákup dárkového poukazu "Koupím
dobrošek" je vstupní bod směrem k **UC0009** (Uplatnění/ověření dárkového poukazu — samotný nákup je
samostatná, nezachycená obrazovka S005). Aktér: anonymní návštěvník / dárce (autentizace není
vyžadována — předpoklady UC0023).

Plně zdokumentováno na základě čtyř snímků celé stránky zachycujících výchozí záložku, záložku
"Samoživitelé", záložku "Filtrovat podle krajů" (mapa krajů, nevybraná) a snímek celého scrollu
záložky "Brzy skončí" (`_ar/evidence/ui/ui-observed-areas.md` §1).

---

## Rozvržení zón (Layout Zones)

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

- **Header** — globální navigace webu: logo/odkaz na domovskou stránku, "Jak to funguje", "Blog",
  "O nás", "Požádat o pomoc" (tlačítko), "Můj účet" (ikona+popisek). Confirmed na všech 4 screenshotech.
- **Hero** — červená titulní karta "DARUJME DĚTEM ŠANCI / za jedno kafe měsíčně" na ilustrovaném
  banneru, fotografie mluvčí s hrnkem a tři kruhová předvolená CTA. Confirmed.
- **Stat strip** — velké číslo "323 dětí" + popisek "čeká na pomoc" a dvě CTA ve tvaru pillu pro
  kategorie ("Zdravotní pomoc" fialová, "Rozvoj a vzdělání" zelená). Confirmed.
- **Filter tabs** — ovládací prvek se čtyřmi záložkami popsaný v sekci Interakce. Confirmed.
- **Catalogue grid** — 6 karet Kampaní na záložku (kromě záložky s kraji, kde je mřížka nahrazena
  mapou), každá obsahuje: ikonový odznak kategorie, fotografii, pásku s odpočítáváním "ZBÝVÁ <n>
  <unit>" (nebo fialovou pásku "SBÍRKOVÝ ÚČET" u karty sběrného účtu), název, progress bar "Chybí
  <amount> Kč", řádek "Cílová částka", řádek s vybranou částkou, CTA tlačítko ("Podpořím `<jméno>`"
  nebo "Nechám to na vás"). Confirmed.
- **Region map sub-zone** (pouze na záložce "Filtrovat podle krajů") — nadpis "Vyberte kraj na mapě"
  + interaktivní šedá SVG mapa 14 krajů ČR. Confirmed (13_16_21 ji zobrazuje v neutrálním,
  nevybraném stavu — na tomto snímku není zvýrazněn žádný kraj ani zobrazen seznam karet pod ní).
- **Testimonial band** — růžové pozadí, nadpis "Poděkování od rodin", úvodní odstavec, jedna
  citační karta (fotografie, text citace, přisouzení "Maminka Angeliny a Viktora" + popisek),
  kolotoč se šipkami prev (‹) / next (›). Confirmed; identické na všech 4 snímcích (nezávisí na
  záložce).
- **Voucher band** — nadpis "Dobrošeky pro lepší dětství" + úvodní text + 6 karet nominálních hodnot
  (100, 250, 500, 1000, 5000, 10000 Kč, každá s titulkem "Pro lepší dětství" a odlišnou ilustrací) +
  tlačítko "Koupím dobrošek". Confirmed; identické na všech 4 snímcích.
- **Pás "Jak to funguje?"** — nadpis + 3 sloupce ("Vše začíná příběhem", "Společně zvládneme víc!",
  "Jen na vás záleží…"), každý s ikonou a krátkým odstavcem. Confirmed.
- **Pás vysvětlující roli Patrona** — červeno-růžová karta, nadpis "Kdo je to Patron příběhu?",
  vysvětlující odstavec, tlačítko "Chci se stát Patronem", vedle fotografie s popiskem "Iveta N.,
  Patronka příběhu Nelinky, Zdeňka a Dominika". Confirmed.
- **Loga sponzorů/partnerů** — "Podporují nás" (BrowserStack, neoznačené logo, CRIF) a "Spřátelené
  organizace" (Lidé odvedle, Nadace Sirius, Centrum komplexní péče pro děti, Šance Dětem). Confirmed.
- **Footer** — popis organizace, odkaz na sociální síť, registrační číslo, sloupec odkazů "Patron
  dětí" (O nás, Blog, Pravidla poskytování pomoci, Naše desatero, Splněné příběhy, Výroční zprávy,
  "Jak jsme pomáhali v době koronakrize"), sloupec "Kontakt" (e-mail info@patrondeti.cz), odznaky
  platebních metod (comgate, Mastercard, VISA), číslo sběrného účtu "57574646/0600", řádek copyrightu
  a dvojice odkazů "Souhlas se zpracováním osobních údajů" / "Chci přihlásit příběh". Confirmed.
  Vlastněno IA jako globální chrome — zde nespecifikováno podrobněji, pouze zaznamenána přítomnost
  (`IA-patronus.md` §2).
- **Cookie-consent banner** — overlay vlevo dole, tlačítka "Přijímám" / "Odmítnout" + odkaz "Další
  informace", viditelný/neuzavřený na snímku výchozí záložky (13_15_49); chybí na ostatních třech
  snímcích (v té chvíli relace již uzavřen, nebo scrollnut mimo pohled — Assumed, protože jde o
  fixní overlay, který by jinak přetrvával). Confirmed přítomnost alespoň jednou; chování při
  přetrvání/uzavření Assumed.

---

## Použité komponenty (Components Used)

Opakující se prvky povýšené na COMP nástrojem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označeny `inline` (nebyla prokázána opětovná použitelnost na ≥2
obrazovkách). Tam, kde již existuje kanonický protějšek `@patron/ui` (`DESIGN-component-index.md`),
je u řádku poznamenáno **Design-system alignment (target)** — jde pouze o TARGET referenci, nikoli
o opakování current-state chování; viz disciplinární poznámka pod tabulkou.

### Current-state (observed)

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Hero | inline | titulní banner + 3x kruhové předvolené CTA | předvolená CTA jsou vstupní bod pro trvalý dar (harmonogram napájený `UC0007` přes `EN0010`) |
| Stat strip | inline | číselná statistika + 2x CTA pill pro kategorii | filtrovací efekt kategoriálních pillů není potvrzen jako propojený s mřížkou níže (Uncertain — nebyla zachycena viditelná změna aktivního stavu) |
| Filter tabs | inline | segmentovaný ovládací prvek se 4 záložkami | viz Interakce #2–#5 |
| Catalogue grid | inline | mřížka karet Kampaní 3x2 | jedna varianta karty zobrazuje stav "SBÍRKOVÝ ÚČET" sběrného účtu (`EN0004` skupinová/nadřazená Kampaň — mechanismus Partial, viz UC0023 Traceability) |
| Story card | COMP0008 | lifecycle=active | opakuje se 6x na záložku; text pásky s odpočítáváním se liší ("ZBÝVÁ MĚSÍC" / "ZBÝVÁ DEN" / "ZBÝVÁ N DNÍ"); viz `COMP0008` Story Card |
| Region map | inline | interaktivní SVG choropletová mapa ČR + záložní `<select>` pro mobil (dle `UC0023` kroku 8; `<select>` není na tomto desktopovém snímku vidět) | "Vyberte kraj na mapě"; kraje bez aktivní Kampaně jsou zobrazeny jako disabled dle `UC0023` AF2 — v zachyceném neutrálním/nevybraném stavu vizuálně nerozlišitelné |
| Testimonial carousel | inline | citační karta + šipky prev/next | není vázán na Kampaň; nezávisí na záložce |
| Voucher denomination card | inline | 6x karta s pevnou hodnotou | přes "Koupím dobrošek" vede ke vstupu do nákupu poukazu `UC0009` (S005, nezachyceno) |
| Vysvětlovač "Jak to funguje?" | inline | 3sloupcový celek ikona+text | statický obsah, bez UC |
| Pás vysvětlující Patrona | inline | text + CTA + fotografie | "Chci se stát Patronem" — na této obrazovce není prokázán realizovaný UC (vede do intake procesu, `UC0001`, dle IA) |
| Pás log sponzorů/partnerů | inline | mřížka log | statický obsah, bez UC |
| Footer | COMP0003 | promo=none | viz `COMP0003` Global Site Footer |
| Cookie-consent banner | COMP0004 | actions=dual-action | viz `COMP0004` Cookie Consent Banner |

### Design-system alignment (target — @patron/ui + @patron/tokens)

Kanonické protějšky `@patron/ui` dle `DESIGN-component-index.md` (TARGET, sesouladěné s current-state
COMP dokumenty výše přes `COMP-inventory-map.md`). Opakující se prvky na této obrazovce, které již
mají povýšený COMP, se nyní také mapují na kanonický Atom/Block; složené dílčí části jsou uvedeny
tam, kde kanonický kontrakt rozkládá current-state jednotku podrobněji, než rekonstruovaný COMP.

| Zóna (current-state řádek) | Kanonický doc_id | Kanonický název / vrstva | Poznámky ke kompozici |
|---|---|---|---|
| Header | COMP0002 | SiteHeader (Block) | Skládá se z `Brandmark` (COMP0019) + `Button` (COMP0001, ghost, desktopové CTA) + `Icon` (COMP0020, user) |
| Story card | COMP0008 | StoryCard (Block) | Skládá se z `CategoryChip` (COMP0018) + `ProgressBar` (COMP0016); prvek pásky s odpočítáváním pozorovaný na této obrazovce se mapuje na `TimeLeftPill` (COMP0017) — props kanonické StoryCard (`progressPct`, `missingLabel`, `goalLabel`) samostatně nevystavují time-left pill ve svém seznamu props dle `DESIGN-component-index.md` řádku 8, proto je tato kompoziční hrana Probable, nikoli Confirmed, do doby vzniku vlastního souboru kanonického kontraktu |
| Footer | COMP0003 | SiteFooter (Block) | Skládá se z `Brandmark` (COMP0019, malý) + napevno vložených ikon sociálních sítí; kanonický kontrakt nemá slot pro "promo band" (divergence vs. footer této obrazovky — viz poznámka o vlastnictví IA výše) |
| (jakékoli CTA ve tvaru tlačítka, např. hero předvolená CTA, "Koupím dobrošek", "Chci se stát Patronem") | COMP0001 | Button (Atom) | Kanonický `Button` je základní akční prvek, ke kterému by se tato inline CTA měla přiřadit; není tvrzeno, že jde již o sesouladěný stav pro jednotlivá CTA (tyto řádky zůstávají výše `inline` — pro ně jednotlivě neexistuje povýšení na základě opětovného použití na ≥2 obrazovkách) |

**Poznámka — pro tuto stránku ještě neexistuje kanonický redesign:** kanonickou cílovou kompozici má
pouze design systém (Atoms/Blocks, epic **E0001**, `Done`) a stránka detailu příběhu **S002** (epic
**E0002**, `Active`). Domovská stránka/katalog (**S001**, tento WIRE) sama **nemá žádný kanonický
redesign** — patří do epicu **E0003+** (`Draft`/`Plánováno` dle `design-canon.md` §0), takže rozvržení
na úrovni zón (Hero, Stat strip, Filter tabs, Catalogue grid, Region map, Testimonial carousel,
Voucher band, vysvětlovací pásy, Sponsor strip) nemá cílový protějšek, ke kterému by se přiřadilo;
kanonické jsou dnes pouze jednotlivé opakující se Atoms/Blocks v ní znovu použité (Header, Footer,
StoryCard a jejich složené části).

---

## Interakce

1. **Vstup** — anonymní návštěva `/` → stav: `default`, filtrovací záložka = "Zbývající částka"
   (Confirmed výchozí přistávací záložka, `UC0023` Main Flow krok 2). Realizuje `UC0023`.
2. **Primární akce — přepnutí filtrovací záložky: "Samoživitelé"** — kliknutí na záložku → mřížka se
   překreslí s jinou sadou Kampaní (potvrzeno porovnáním obsahu karet mezi 13_15_49 a 13_16_09: bez
   překrývajících se příběhů); realizuje `UC0023` Main Flow krok 6 / AF1; následující stav: `default`
   (záložka = Samoživitelé). Napojení serverového filtrování pro tuto záložku je Uncertain (`UC0023`
   AF1) — viditelné chování (změna sady karet) je Confirmed, mechanismus nikoli.
3. **Primární akce — přepnutí filtrovací záložky: "Filtrovat podle krajů"** — kliknutí na záložku →
   catalogue grid je nahrazena sub-zónou mapy krajů ("Vyberte kraj na mapě"); realizuje `UC0023` Main
   Flow krok 7; následující stav: `default` (záložka = kraje, mapa nevybraná — jde o zachycený stav,
   13_16_21).
4. **Sekundární akce — výběr kraje na mapě** — kliknutí na kraj na SVG mapě (nebo mobilní `<select>`,
   nezachyceno při této šířce okna) → znovu spustí dotaz do katalogu omezený na daný kraj a
   předpokládá se překreslení mřížky karet pod/na místě mapy; realizuje `UC0023` Main Flow kroky 9–10.
   **Nezachyceno** — žádný screenshot nezobrazuje vybraný kraj ani výsledný seznam karet; Assumed
   chování dle evidence UC0023, pro tuto obrazovku není potvrzeno screenshotem.
5. **Primární akce — přepnutí filtrovací záložky: "Brzy skončí"** — kliknutí na záložku → mřížka se
   překreslí seřazená podle nejbližšího termínu (potvrzeno: všech 6 viditelných karet v 13_16_37
   zobrazuje krátké odpočty — "ZBÝVÁ DEN", "ZBÝVÁ 3 DNY" 3x, "ZBÝVÁ 5 DNY" — v souladu se vzestupným
   řazením podle termínu); realizuje `UC0023` Main Flow kroky 11–12; následující stav: `default`
   (záložka = Brzy skončí).
6. **Primární akce — CTA karty příběhu ("Podpořím `<jméno>`")** — kliknutí → předá tok do dárcovského
   procesu pro vybranou Kampaň; realizuje `UC0023` Main Flow krok 13–14 (hranice předání; samotný dar
   je `UC0005`, mimo rozsah této obrazovky); následující obrazovka: S002 (dle `IA-screen-map.md`
   cross-modulový tok, krok dárcovského procesu 1→2).
7. **Primární akce — CTA karty sběrného účtu ("Nechám to na vás")** — kliknutí → stejný vzorec
   předání jako #6, cílí na Kampaň sběrného účtu/skupinovou Kampaň; následující obrazovka: S002
   (mechanismus Partial — viz otevřená položka `UC0023` Traceability k mapování skupinové Kampaně).
8. **Sekundární akce — předvolené hero CTA ("Daruj 90 Kč měsíčně" / "290 Kč měsíčně" / "podle sebe")**
   — kliknutí → vstup do procesu nastavení trvalého daru s předvyplněnou předvolenou (nebo vlastní)
   částkou; jde o UI vstupní bod napájející `RecurringTransaction` (`EN0010`), kterou `UC0007`
   následně strhává dle harmonogramu; samotný krok vytvoření harmonogramu daru je `UC0005` (Provedení
   daru), přímo neprokázáno, že probíhá na S001 — **Uncertain**, která obrazovka/modální okno se
   otevře dále (žádný screenshot nezachycuje stav po kliknutí z tohoto vstupního bodu).
9. **Sekundární akce — CTA kategoriálního pillu ("Zdravotní pomoc" / "Rozvoj a vzdělání")** —
   kliknutí → předpokládaný filtr/navigace na pohled omezený na kategorii; **Uncertain** — nezachyceno
   porovnání před/po a na žádném z pillů nebyl v žádném snímku zaznamenán viditelný stisknutý/aktivní
   stav; efekt nepotvrzen.
10. **Sekundární akce — odkaz "Další příběhy"** — kliknutí → předpokládaná paginace/"load more" nebo
    stránka s úplným výpisem katalogu; **Uncertain** — nezachyceno nad rámec přítomnosti odkazu.
11. **Sekundární akce — "Koupím dobrošek"** — kliknutí → předá tok na obrazovku nákupu poukazu (S005,
    nezachyceno); vstupní bod směrem k životnímu cyklu uplatnění dle `UC0009` (samotný nákup
    předchází krokům ověření/uplatnění dle UC0009). Následující obrazovka: S005 (Uncertain jistota
    dle `IA-screen-map.md`).
12. **Sekundární akce — kolotoč referencí prev/next** — kliknutí ‹ / › → cykluje jedinou viditelnou
    citační kartu; **Uncertain**, kolik celkem referencí existuje (na žádném snímku je zobrazena jen
    jedna).
13. **Sekundární akce — "Chci se stát Patronem"** — kliknutí → předpokládaný vstup do intake procesu
    Patrona; pro tento konkrétní klikací cíl na S001 není prokázán realizovaný UC (`UC0001` obecně
    řídí podání Žádosti, dle IA); následující obrazovka Uncertain — nezachyceno.
14. **Odchod** — návštěvník opouští stránku přes navigaci v headeru ("Jak to funguje", "Blog", "O
    nás", "Požádat o pomoc", "Můj účet") nebo přes odkazy v footeru — každý je navigační cíl vlastněný
    IA, zde neopakován.
15. **Akce cookie-consent banneru** — "Přijímám" / "Odmítnout" uzavřou banner; "Další informace"
    pravděpodobně otevírá detail zásad cookies (cíl odkazu nezachycen). Confirmed přítomnost banneru
    a popisky tlačítek; chování při uzavření Assumed (standardní vzorec consent banneru, nezachyceno
    přímo formou páru před/po).

---

## Stavy

### default
Catalogue grid (nebo mapa krajů, na příslušné záložce) načtená s obsahem, jak je zobrazeno na všech
čtyřech screenshotech. Confirmed pro všechny čtyři filtrovací záložky: "Zbývající částka" (13_15_49),
"Samoživitelé" (13_16_09), "Filtrovat podle krajů" — mapa neutrální/nevybraná (13_16_21), "Brzy
skončí" (13_16_37).

### empty
Zobrazuje se, když: kombinace filtru/kraje vrátí nulový počet aktivních Kampaní (`UC0023` AF4 —
systém vrací `total_count = 0`). **Evidence Pending — nezachyceno.** Žádný screenshot nezobrazuje
stav s nulovým výsledkem pro žádnou záložku ani kraj. Vizuální zpracování a cesta k nápravě (např.
zpráva o prázdném stavu, akce "vymazat filtr") jsou Uncertain — nepředpokládejte konkrétní zpracování.

### loading
Zobrazuje se, když: přepnutí záložky nebo výběr kraje spustí opětovný dotaz (`UC0023` Main Flow kroky
3–4, 10, 12). **Evidence Pending — nezachyceno.** Na žádném snímku není viditelný skeleton/spinner/
stav znepřístupněné interakce (všechny čtyři jsou ustálené, plně vykreslené koncové stavy). Uncertain,
zda pro AJAX řízené přepínání záložek na této obrazovce vůbec existuje indikátor načítání.

### error
Zobrazuje se, když: dotaz do katalogu selže na serveru, nebo se nepodaří načíst fragment výběru kraje
(`/campaign/regions/render`, dle `UC0023` Main Flow kroku 8). **Evidence Pending — nezachyceno.**
Žádný chybový stav nebyl zaznamenán; Uncertain, zda pro tuto obrazovku existuje nějaká uživatelsky
viditelná chybová zpráva, nebo jde o tichý neúspěch (např. prázdná mřížka nerozlišitelná od stavu
`empty` výše).

---

## Validace vstupů (Validation Surfaces)

Na této obrazovce dle aktuální evidence neexistuje žádné zadávání dat do formulářového pole — jde o
plochu pro procházení/filtrování (záložky, mapa pro výběr kraje a CTA tlačítka), nikoli o krok
zadávání dat. `UC0023` je explicitně "čistá schopnost čtení/procházení: nemění stav Kampaně ani
Žádosti," takže zde žádné `BRxxxx` nepodmiňuje odeslání formuláře.

| Pole/Zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| — | — | N/A — na S001 nejsou doložena žádná pole formuláře |

**validationsWithoutBR:** žádné — na této obrazovce podle dostupné evidence není co validovat
(pro čistou plochu procházení/filtrování žádné BR neexistuje ani není potřeba; nejde o otevřenou
otázku).

---

## Datové vazby (Data Bindings)

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Catalogue grid (všechny záložky) | `EN0004` | — | Projekce karty Kampaně: fotografie, kategorie, název, cílová vs. vybraná částka, příznak viditelnosti zbývající částky, termín/zbývající čas, text CTA — dle `UC0023` Main Flow kroku 5. V této rekonstrukční fázi neexistuje žádné QUERY-id (vrstva QUERY zatím není navržena); podkladový kontrakt pro čtení je `CampaignsResource` dle `UC0023` Traceability, zde neopakováno. |
| Story card — odznak Patrona (ikona na kartě, pokud je přítomna) | `EN0005` | — | Veřejný profil Patrona zobrazený u jednotlivé karty; pozorováno jako malá ikona odznaku v rohu každé karty (přítomnost ikony Confirmed dle screenshotů; propojení odznaku s profilem Patrona je Probable, odvozeno z `UC0023` Actors — v evidenci není potvrzeno jako samostatný klikatelný prvek). |
| Mapa krajů — počty aktivních Kampaní za jednotlivý kraj | `EN0004` | — | Aktuální počty řídí znepřístupnění krajů s nulovým počtem (`UC0023` Main Flow krok 8, AF2); na zachycené mapě nejsou samostatně vykresleny jako viditelné číselné údaje (13_16_21 zobrazuje pouze neutrální šedou mapu, bez viditelných popisků počtu na této úrovni přiblížení/detailu). |
| Číselný údaj stat stripu ("323 dětí čeká na pomoc") | `EN0004` | — | Souhrnný počet Kampaní čekajících na pomoc; přesný zdrojový dotaz Uncertain — nepotvrzeno, zda odráží stejnou filtrovanou množinu jako aktivní záložka, nebo globální nefiltrovaný počet (napříč záložkami nebyla zaznamenána žádná změna číselného údaje — hodnota "323" je identická na všech čtyřech snímcích, což naznačuje, že NENÍ vázána na záložku — Probable). |
| Předvolená hero CTA (90 / 290 / vlastní Kč) | `EN0010` | — | Napájí harmonogram `RecurringTransaction` při jeho vytvoření; samotné S001 pouze prezentuje předvolené částky, nečte ani nezobrazuje data existujícího harmonogramu. |
| Karty nominálních hodnot poukazu | `EN0013` | — | Pevné nominální hodnoty (100/250/500/1000/5000/10000 Kč) nabízené k nákupu; S001 nečte stav uplatnění poukazu — jde o vstupní plochu nákupu pro životní cyklus `EN0013`, který následně validuje/uplatňuje `UC0009`. |

---

## Podmíněná viditelnost (Conditional Visibility)

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | nedoloženo | Veřejně/anonymně dostupná; v této rekonstrukci neexistuje žádná vrstva ACL (`IA-patronus.md` §9). Nebylo pozorováno žádné podmínění rolí — všechny čtyři snímky byly pořízeny jako anonymní návštěvník. |
| Položka headeru "Můj účet" | nedoloženo (při neautentizovaném stavu směruje na přihlášení S009, dle IA) | Nejde o podmínku viditelnosti na samotném S001 — popisek/ikona je přítomna bez ohledu na stav autentizace; liší se pouze cíl (`IA-patronus.md` §2). Zde znovu nespecifikováno. |
| Cookie-consent banner | stav relace/consent cookie (implementační detail, nikoli ACL/BR) | Pokud byl dříve v rámci relace zavřen, banner se nevykreslí (Assumed z jeho nepřítomnosti ve 3 ze 4 snímků — nejde o podmínku vázanou na roli nebo BR). |

Na S001 nejsou na žádném snímku viditelné jako záložky ani ovládací prvky žádné filtry ve stylu AF3
vázané na interakci autentizovaného dárce (`UC0023` AF3: `filter_user_interacted_campaigns` /
`filter_user_recommended_campaigns`) — v souladu s vlastní poznámkou `UC0023`, že tyto "nejsou
potvrzeny jako veřejná plocha UI záložky katalogu."

---

## Poznámky k přístupnosti (Accessibility Notes)

Evidence Pending — nezachyceno. Statické screenshoty nepotvrzují pořadí tabulátoru, chování fokusu,
role landmarků ani ovládání klávesnicí pro tuto obrazovku.

- **Pořadí tabulátoru:** Uncertain — nedoloženo ze statických snímků.
- **Fokus při vstupu:** Uncertain.
- **Fokus při přechodu stavu (přepnutí filtrovací záložky):** Uncertain — zda se fokus přesune na
  překreslenou oblast mřížky/mapy při přepnutí záložky (osvědčený postup přístupnosti pro AJAX výměnu
  obsahu) není doloženo ani jedním směrem.
- **Landmarky:** Uncertain — čtyři segmentované filtrovací záložky vizuálně připomínají vzor
  tab-panelu (`role="tablist"`/`tab`/`tabpanel`), ale v této fázi založené pouze na screenshotech
  neexistuje žádná evidence DOM/ARIA, která by potvrdila, že jsou takto implementovány, oproti
  obyčejným tlačítkům nebo odkazům.
- **Klávesové zkratky:** nedoloženo.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Navigace headeru, hero, stat strip, filtrovací záložky, catalogue grid, testimonial band, voucher band, "Jak to funguje?", pás vysvětlující Patrona, loga sponzorů, footer, cookie banner — přítomnost a obsah | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `13_16_09.png`, `13_16_21.png`, `13_16_37.png`; `_ar/evidence/ui/ui-observed-areas.md` §1 |
| Výchozí přistávací záložka = "Zbývající částka" | Confirmed | 13_15_49.png; `UC0023` Main Flow krok 2 |
| Přepnutí záložky mění sadu karet (Samoživitelé, Brzy skončí) | Confirmed (viditelný efekt) / Uncertain (mechanismus u Samoživitelů) | 13_15_49.png vs 13_16_09.png vs 13_16_37.png; `UC0023` AF1 |
| Záložka s mapou krajů nahrazuje mřížku mapou "Vyberte kraj na mapě", neutrální/nevybraný stav | Confirmed | 13_16_21.png |
| Výsledek výběru kraje (seznam karet po kliknutí) | Evidence Pending — nezachyceno | žádný screenshot nezobrazuje vybraný kraj |
| Mechanismus karty sběrného účtu / "SBÍRKOVÝ ÚČET" (mapování typu/nadřazené entity) | Partial | otevřená položka `UC0023` Traceability; `_ar/spec-draft/EN/EN0004_Campaign.md` |
| Předvolené hero CTA → vstupní bod trvalého daru | Probable | `_ar/spec-draft/EN/EN0010_RecurringTransaction.md`; `UC0007` Preconditions (harmonogram vzniká z daru, nikoli ze samotného tohoto cron UC); žádný screenshot po kliknutí |
| "Koupím dobrošek" → vstupní bod nákupu poukazu | Probable | `_ar/spec-draft/EN/EN0013_Voucher.md`; `UC0009` Preconditions; cílová obrazovka S005 nezachycena dle `IA-screen-map.md` |
| Stavy empty / loading / error | Evidence Pending — nezachyceno | žádný screenshot nezobrazuje tyto stavy pro S001 |
| Přístupnost (pořadí tabulátoru, fokus, landmarky) | Uncertain | nedoloženo ze statických screenshotů |
| Efekt CTA kategoriálního pillu, cíl odkazu "Další příběhy", počet referencí, cíl "Chci se stát Patronem" | Uncertain | přítomnost potvrzena na screenshotech; chování/cíl nezachyceno |
