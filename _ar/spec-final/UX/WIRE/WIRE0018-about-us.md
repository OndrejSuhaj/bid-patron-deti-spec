---
doc_id: WIRE0018
title: About Us
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S015
realizes_uc: [UC0027]
status: imported
references:
  - UC0027
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0020
---

# WIRE0018 – O nás

## Účel

Veřejná institucionální/obsahová stránka `/o-nas` ("O nás") pro anonymního návštěvníka, dostupná
z položky globální navigace "O nás" (`_ar/spec-draft/IA/IA-patronus.md`, řádek 213, obrazovka `S015`).
Prezentuje misi organizace, úvodní video, krátkou výzvu ke kontaktu s "koordinátorkou", seznam členů
projektového týmu (fotky, jména, role, kontaktní údaje), etický kodex ("Náš etický kodex" / "Desatero")
ke stažení ve formátu PDF, korespondenční/fakturační adresu a dva archivy dokumentů — výroční zprávy
("Výroční zprávy") a protokoly o kontrole veřejné sbírky ("Protokoly o kontrole veřejné sbírky"), oba
za období 2018–2024. Jde o **read-only, statickou/redakční** obrazovku: bez formulářů, bez datových
tabulek, bez interaktivních prvků kromě navigace a stahování souborů.

`realizes_uc: [UC0027]` je uvedeno **podle zadání tohoto úkolu**; je třeba poznamenat, že **v aktuálním
registru UC žádné `UC0027` neexistuje** (`_ar/spec-draft/UC/_REGISTRY.md` uvádí `UC0001`–`UC0025`;
pod `_ar/spec-draft/UC/` nebyl nalezen ani dokument `UC0026`, ani `UC0027`). Vrstva IA nezávisle
označuje tutéž obrazovku `S015` jako **"(no UC)"** / "static/institutional; no UC"
(`IA-patronus.md`, řádky 85, 126, 213). Toto je zaznamenáno jako **dangling reference / Open Question**,
nikoli tiše vyřešeno — viz Open Questions a Evidence níže. Podle projektové politiky jsou tato stránka
a jí příbuzný `/blog` **pouze current-state**; rebuild epic **E0004** (dosud nevytvořený) řídí případný
budoucí cílový návrh a je zde mimo rozsah.

Aktér: anonymní návštěvník (žádná autentizace nebyla pozorována ani předpokládána).

---

## Rozvržení zón (Layout Zones)

```
+--------------------------------------------------------+
| Globální navigace — logo | Jak to funguje | Blog | O nás |
|                    Požádat o pomoc (CTA) | Můj účet     |
+--------------------------------------------------------+
| Hero pás — nadpis "O nás" + odstavec s posláním          |
| (růžový podkladový pás)                                   |
+--------------------------------------------------------+
| Zóna poslání / úvodu                                      |
|   text s inline odkazem "příběhům dětí"                    |
|   vložené YouTube video ("Všechny děti si zaslouží...")   |
|   závěrečná věta "Společně dokážeme víc!"                  |
+--------------------------------------------------------+
| Pruh s výzvou koordinátorky                                |
|   fotka avataru + "Dobrý den, jsem koordinátorka Jana."    |
|   + kontaktní řádek s mailto: odkazem                      |
+--------------------------------------------------------+
| Mřížka týmu — "Lidé v projektu"                            |
|   2 zvýrazněné karty (ředitelky, růžové pozadí, fotka +    |
|     jméno + role + citát)                                  |
|   12 dlaždic seznamu ve 2 sloupcích (fotka, jméno, role,  |
|     e-mail, telefon tam, kde je uveden)                    |
+--------------------------------------------------------+
| Banner etického kodexu — "Náš etický kodex" / Desatero     |
|   (růžový panel: nadpis + text + tlačítko "Stáhnout        |
|    Desatero") vedle fotografie                             |
+--------------------------------------------------------+
| Blok korespondenční/fakturační adresy                      |
|   "Patron dětí, z.ú." + adresa + IČO + registrační údaje   |
+--------------------------------------------------------+
| Archiv dokumentů — "Výroční zprávy"                         |
|   8 dlaždic let (2018–2024) ve 2 sloupcích, každá:         |
|   odznak roku (kruh) + "Výroční zpráva za rok NNNN" +      |
|   odkaz "Stáhnout" s ikonou stažení                         |
+--------------------------------------------------------+
| Archiv dokumentů — "Protokoly o kontrole veřejné sbírky"    |
|   8 dlaždic let (2018–2024) ve 2 sloupcích, stejný vzor    |
|   dlaždice                                                  |
+--------------------------------------------------------+
| Patička — cookie lišta, firemní údaje, skupiny navigačních |
|          odkazů, sociální odkaz, loga platebních            |
|          poskytovatelů, číslo sbírkového účtu               |
+--------------------------------------------------------+
```

- **Globální navigace** — logo (→ S001), "Jak to funguje" (→ S016), "Blog" (→ S013), "O nás" (aktuální
  stránka), CTA "Požádat o pomoc" (→ S006), "Můj účet" (→ autentizovaná zóna). — Confirmed.
- **Hero pás** — růžové pozadí, nadpis "O nás", jednoodstavcové prohlášení o poslání ("Patron dětí je
  charitativní projekt, jehož smyslem je pomáhat zdravotně a sociálně znevýhodněným dětem a jejich
  rodinám z celé České republiky."). — Confirmed.
- **Zóna poslání / úvodu** — textový obsah odkazující na "příběhům dětí" (inline odkaz), vložený
  video přehrávač (náhled "Všechny děti si zaslouží šťastný a plný..." s afordancí přehrání videa
  na YouTube) a závěrečná sjednocující věta "Společně dokážeme víc!". — Confirmed.
- **Pruh s výzvou koordinátorky** — malá fotka avataru s textem ve stylu bubliny: "Dobrý den, jsem
  koordinátorka Jana. Pokud máte nějaký dotaz, kontaktujte mě na chatu nebo mi napište na
  info@patrondeti.cz" (mailto odkaz). — Confirmed.
- **Mřížka týmu ("Lidé v projektu")** — nadpis, poté dvě vizuálně odlišené růžové "zvýrazněné" karty
  (výkonná ředitelka Edita Mrkousová; provozní ředitelka Svatava Poulson — každá s fotkou, jménem,
  rolí, e-mailem a krátkým citátem), následované 12 běžnými dlaždicemi seznamu ve 2sloupcovém
  rozvržení, každá s kruhovou fotkou, jménem, popiskem role (např. "péče o dobrovolníky, fakturace";
  "zástupkyně žadatelů"; "finance a HR"; "koordinace žádostí"; "risk management"; "koordinace mezi
  projekty") a kontaktem (e-mail vždy; telefonní číslo uvedeno na některých dlaždicích, na jiných
  chybí). — Confirmed.
- **Banner etického kodexu** — růžový panel s nadpisem "Náš etický kodex", textem ("Naše činnost se
  opírá o pevné zásady a principy, jejichž dodržování je pro nás samozřejmostí. Abyste věděli, že nám
  můžete důvěřovat, stáhněte si jedno z deseti Desatera."), tlačítkem ke stažení "Stáhnout Desatero" a
  přilehlou fotografií (detail rukou). — Confirmed.
- **Blok korespondenční/fakturační adresy** — vystředěný text: název subjektu "Patron dětí, z.ú.",
  poštovní adresa "U Prašné brány 1079/3, 110 00 Praha 1, Staré Město", "IČO: 06826911, neplátci DPH",
  plus menší registrační poznámky ("Zaregistrována u krajského soudu Sp. zn. U-NKAM/036002/2017",
  "Číslo účtu veřejné sbírky 5757604/0600"). — Confirmed.
- **Archiv dokumentů — "Výroční zprávy"** — nadpis sekce, 8 dlaždic let (2018, 2019, 2020, 2021,
  2022, 2023, 2024) uspořádaných po 2 na řádek, každá jako karta s kruhovým odznakem roku, popiskem
  "Výroční zpráva za rok NNNN" a textovým odkazem "Stáhnout" s ikonou stažení. — Confirmed.
- **Archiv dokumentů — "Protokoly o kontrole veřejné sbírky"** — stejný vzor dlaždice, stejné
  období 2018–2024, popisek "Protokol o kontrole za rok NNNN". — Confirmed.
- **Patička** — lišta souhlasu s cookies, firemní blok ("patron dětí" + krátký popis + poznámka o
  zastřešující organizaci + oznámení o registrované sbírce), tři skupiny navigačních odkazů
  ("Patron dětí", "Kontakt", sociální síť — "Sledujte nás na Facebooku"), platební loga
  (Comgate/Mastercard/Visa), číslo sbírkového účtu. — Confirmed. (Patička je sdílená/globální oblast —
  cíle jejích vnitřních odkazů vlastní IA, zde se neopakují.)

---

## Použité komponenty (Components Used)

Podle zadání úkolu jsou zde přiřazeny pouze čtyři pojmenované komponenty; všechny ostatní zóny na
této obrazovce zůstávají `inline` (pro dlaždice týmu/dokumentů nebyl v současném
`COMP-inventory-map.md` doložen ≥2-obrazovkový reuse jako samostatný znovupoužitelný vzor).

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Globální navigace | COMP0002 | context=public | sdílená hlavička, stejná jako na S001/S013/S016; viz `COMP0002` Global Site Header |
| Tlačítko ke stažení "Stáhnout Desatero" | COMP0001 | variant=secondary/outline (růžová na bílé, ikona+popisek) | komponenta Button; popisek "Stáhnout Desatero" + ikona stažení — Confirmed jako stejná rodina tlačítek použitá jinde (CTA na S001/S002), odlišná vizuální varianta jinak nebyla porovnána pixel po pixelu |
| Ikona stažení (tlačítko Desatero + všechny odkazy "Stáhnout" na dlaždicích roku) | COMP0020 | icon=download | opakující se malý glyf předcházející každé afordanci stažení na této obrazovce — Confirmed přítomnost, komponenta `COMP0020` Icon |
| Zóna poslání / úvodu | inline | nadpis + textový obsah + náhled vloženého videa | samotné vložení videa je third-party (YouTube) — není COMP; nebyla identifikována žádná dedikovaná COMP pro video embed |
| Pruh s výzvou koordinátorky | inline | avatar + text + mailto odkaz | — |
| Mřížka týmu — zvýrazněná karta (×2) | inline | fotka + jméno + role + e-mail + citát, růžové pozadí | nedoloženo jako znovupoužité jinde (práh ≥2-obrazovkového reuse nebyl splněn) |
| Mřížka týmu — dlaždice seznamu (×12) | inline | kruhová fotka + jméno + role + e-mail (+ volitelně telefon) | opakující se vzor pouze v rámci této obrazovky; nepovýšeno na COMP bez cross-screen evidence |
| Banner etického kodexu | inline | růžový panel (nadpis + text + tlačítko) + fotka, dvousloupcové | obsahuje tlačítko COMP0001, viz řádek výše |
| Blok korespondenční/fakturační adresy | inline | prostý vystředěný textový blok | — |
| Dlaždice roku dokumentu (×16 celkem, oba archivy) | inline | odznak roku (kruh) + popisek + odkaz "Stáhnout" s ikonou COMP0020 | odznaky roku a rámce dlaždic jsou opakující se vzor v rámci stránky; nepovýšeno na COMP bez ≥2-obrazovkové evidence reuse — samotné odkazy ke stažení jsou inline textové odkazy, nikoli tlačítka COMP0001 (vizuálně prostý odkaz, nikoli tlačítko) |
| Patička | COMP0003 | — | stejná jako pozorovaná na ostatních veřejných obrazovkách; viz `COMP0003` Global Site Footer |

---

## Interakce (Interactions)

1. **Vstup** — přímá navigace na `/o-nas` přes odkaz "O nás" v globální navigaci → stav: `default`. —
   Confirmed (route + vstupní bod; `IA-patronus.md`, řádek 213).
2. **Primární akce — "Stáhnout Desatero"** — klik → stáhne/otevře PDF dokument etického kodexu;
   nerealizuje na této obrazovce žádnou změnu stavu UC (statické stažení souboru, žádná pozorovaná
   aplikační logika). — Confirmed afordance; cíl/chování stažení (nová záložka vs. přímé stažení)
   nebylo ve screenshotu pozorováno. — `Probable`.
3. **Sekundární akce — "Stáhnout" (u každé dlaždice roku, oba archivy)** — klik na odkaz ke stažení
   dlaždice roku → stáhne/otevře PDF dané výroční zprávy nebo kontrolního protokolu za daný rok;
   stejný vzor jako výše, ×16 instancí (8 výročních zpráv + 8 kontrolních protokolů). — Confirmed
   afordance; přesné cíle souborů nebyly zachyceny. — `Probable`.
3a. **Sekundární akce — mailto odkaz koordinátorky** — klik na `info@patrondeti.cz` → otevře
   návštěvníkova e-mailového klienta s předvyplněnou adresou; žádný kontaktní formulář na stránce
   nebyl pozorován. — Confirmed.
3b. **Sekundární akce — inline odkaz v zóně poslání ("příběhům dětí")** — klik → očekává se navigace
   na katalog příběhů (S001) nebo související obsahovou obrazovku; přesný cíl nebyl na tomto
   screenshotu zachycen. — `Uncertain`.
3c. **Sekundární akce — vložené video** — klik na náhled videa → přehraje video hostované na
   YouTube (přehrávač na stránce nebo externí YouTube záložka); přesné chování embedu nebylo ze
   statického záznamu potvrzeno. — `Probable`.
3d. **Sekundární akce — "Sledujte nás na Facebooku" (patička)** — klik → externí navigace na
   Facebookovou stránku organizace; sdílené chování patičky, nespecifické pro tuto obrazovku. —
   Confirmed (vzor patičky), mimo rozsah detailu WIRE (vlastní IA/COMP0003).
4. **Výstup** — přes globální navigaci (na S001/S013/S016/S006) nebo odkazy v patičce; neexistuje
   žádný explicitní výstup typu "storno"/"odeslat", jelikož jde o read-only obsahovou obrazovku. —
   Confirmed.

---

## Stavy (States)

### default
Plně vykreslená stránka tak, jak byla zachycena: hero prohlášení o poslání, úvodní text + video,
výzva koordinátorky, dvě zvýrazněné karty týmu + 12 dlaždic seznamu, banner etického kodexu s
tlačítkem ke stažení, blok korespondenční adresy a dva 8dlaždicové archivy dokumentů (výroční zprávy;
kontrolní protokoly), oba za období 2018–2024. — Confirmed
(`_ar/prtsc/screencapture-patrondeti-cz-o-nas-2026-07-04-13_17_32.png`).

### empty
`N/A — převážně statická institucionální stránka; žádná zóna seznamu/kolekce na této obrazovce není
řízena proměnnou datovou sadou, která by v current-state provozu mohla být pravděpodobně prázdná
(tým, banner etického kodexu a oba archivy dokumentů podle roku jsou pozorovány jako pevný redakční
obsah, nikoli dotazovaná kolekce s případem nulového výsledku).` Toto je odvození z statické/redakční
povahy stránky, nikoli potvrzený test absence prázdného stavu — `Assumed`.

### loading
`N/A — nebylo pozorováno ani předpokládáno žádné asynchronní chování při načítání dat; stránka
působí jako server-rendered statický/redakční obsah (jediný celostránkový screenshot, žádný
skeleton/spinner nebyl pozorován).` — `Assumed`.

### error
`N/A — nebylo pozorováno žádné ošetření chyby/selhání. Nefunkční odkaz ke stažení (chybějící/expirované
PDF) je pravděpodobný reálný scénář selhání pro archivy dokumentů, ale žádný důkaz (screenshot ani
jiný) neukazuje, co se stane při neúspěšném stažení — nedoloženo žádným směrem.` —
`Uncertain — not captured`.

---

## Validační plochy (Validation Surfaces)

Jde o read-only obsahovou obrazovku bez formulářových polí nebo pozorovaného uživatelského vstupu —
žádné validační plochy se neuplatňují.

`N/A — na této obrazovce nebyly pozorovány žádné vstupní prvky (Controls / Form fields: none, podle
_ar/evidence/ui/ui-observed-areas.md §16).`

---

## Datové vazby (Data Bindings)

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Mřížka týmu (zvýrazněné karty + dlaždice seznamu) | — | — | Žádný `EN` v aktuálním registru nemodeluje "člena projektového týmu" jako doménovou entitu (`_ar/spec-draft/EN/_REGISTRY.md`); zpracováno jako statický redakční obsah (jména/role/fotky vytvořené přímo na stránce), nikoli výsledek vázaného dotazu — `Uncertain`, není tvrzeno jako potvrzená vazba na entitu. |
| Banner etického kodexu (PDF Desatero) | — | — | Žádný `EN`/glosářová položka pro "Desatero" / etický kodex jako doménový koncept; statický odkaz na dokument — `Uncertain`. |
| Archiv dokumentů — Výroční zprávy (×8) | — | — | Žádný `EN` nemodeluje "výroční zprávu" jako entitu; statické odkazy na dokumenty, jeden za rok 2018–2024 — `Uncertain`. |
| Archiv dokumentů — Protokoly o kontrole veřejné sbírky (×8) | — | — | Žádný `EN` nemodeluje "protokol o kontrole veřejné sbírky" jako entitu; statické odkazy na dokumenty — `Uncertain`. |
| Blok korespondenční/fakturační adresy | — | — | Statická organizační data (právní název, IČO, registrační čísla); nebyl nalezen odpovídající dokument entity `EN` party/organizace, který by řídil vykreslení této obrazovky — `Uncertain`. |

Pro žádnou zónu na této obrazovce nebylo možné potvrdit `EN` ani `QUERY` doc_id; veškerý obsah zde
působí jako statický/redakční spíše než vázaný na entitu, v souladu s klasifikací `S015` vrstvou IA
jako "static/institutional; no UC" (`IA-patronus.md`, řádky 85, 126). Toto je zaznamenáno jako otevřená
mezera, nikoli vyřešeno vymýšlením.

---

## Podmíněná viditelnost (Conditional Visibility)

| Komponenta/Zóna | Podmínka (ref ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | žádná pozorována | anonymní/veřejné — nebyla pozorována žádná role gate; vrstva ACL pro tento rekonstrukční průchod ještě neexistuje |
| Navigační odkaz "Můj účet" | Předpokládaná varianta pro autentizovaný stav (na tomto záznamu nedoloženo) | viz IA / ostatní obrazovky pro variantu navigace přihlášeného uživatele; zde mimo rozsah |

Pro tuto obrazovku nebyl nalezen žádný dokument `BR` ani `ACL` řídící viditelnost; je zpracována jako
bezpodmínečně veřejný obsah, v souladu s ostatními veřejnými obrazovkami (např. `WIRE0019`).

---

## Poznámky k přístupnosti (Accessibility Notes)

Nebylo pozorováno ve statickém screenshotovém důkazu — v rámci tohoto rekonstrukčního průchodu
neproběhla žádná inspekce DOM/ARIA. Následující body jsou `Uncertain`/`Evidence Pending`:

- **Pořadí tabulátoru:** Předpokládá se, že sleduje vizuální/DOM pořadí (navigace → hero → poslání/
  video → výzva koordinátorky → mřížka týmu → banner etického kodexu → blok adresy → archiv
  výročních zpráv → archiv kontrolních protokolů → patička) — neověřeno.
- **Fokus při vstupu:** Nebylo pozorováno.
- **Fokus při přechodu stavu:** Nebylo pozorováno (žádný přechod stavu nebyl zachycen — viz Stavy;
  stránka je fakticky jednostavová).
- **Landmarks:** Nebylo pozorováno; přítomnost sémantických landmarks `<nav>`/`<main>`/`<footer>`
  nelze ze samotného screenshotu potvrdit.
- **Odkazy ke stažení (Desatero + 16 odkazů "Stáhnout" na dlaždicích roku):** Typ/velikost souboru
  není oznámena ve viditelném textu (žádná přípona typu "(PDF, x MB)" nebyla pozorována); zda každý
  odkaz ke stažení vystavuje přístupný název odlišující jej od sousedních odkazů (např. "Stáhnout
  Výroční zprávu za rok 2020" vs. holé "Stáhnout" opakované 16×, kde jen okolní vizuální kontext
  umožňuje rozlišení) je **Uncertain** — uživatel čtečky obrazovky spoléhající na zobrazení seznamu
  odkazů by mohl narazit na 16+ identicky pojmenovaných odkazů "Stáhnout" bez rozlišení, pokud
  přístupný název neobsahuje rok/typ dokumentu. Toto je označeno jako pravděpodobná mezera v
  přístupnosti aktuální implementace, ale **není potvrzeno** ze screenshotu (DOM/ARIA nebylo
  inspektováno).
- **Vložené video:** Dostupnost titulků/přepisu pro video vložené z YouTube nebyla pozorována.
- **Klávesové zkratky:** Žádné nebyly pozorovány; žádné se ani neočekávají pro obrazovku procházení
  obsahu.

---

## Otevřené otázky (Open Questions)

- **`realizes_uc: [UC0027]` je dangling reference.** V `_ar/spec-draft/UC/_REGISTRY.md` neexistuje
  žádný dokument `UC0027` (registr aktuálně končí na `UC0025`; nebylo nalezeno ani `UC0026`). Vrstva
  IA nezávisle klasifikuje tutéž obrazovku (`S015`) jako **"(no UC)" / "static/institutional; no UC"**
  (`IA-patronus.md`, řádky 85, 126, 213). Podle `rules-WIRE.md` platí, že "Dangling COMP/UC/BR
  references block completion" — toto je zde zaznamenáno, nikoli tiše vyřešeno nebo vymyšleno;
  navazující `RefIntegrityValidator` by měl vyjasnit, zda `UC0027` je dosud nenapsaný UC (např.
  budoucí use case "Publikovat/spravovat statický institucionální obsah") nebo zda by tato obrazovka
  ve skutečnosti neměla nést žádnou hodnotu `realizes_uc`, což by odporovalo "povinnému" pravidlu
  frontmatter kontraktu pro čistě obsahové obrazovky.
- Jsou 12+2 položky seznamu členů týmu, dokument etického kodexu a 16 archivovaných zpráv/protokolů
  spravovány prostřednictvím nějaké CMS/administrátorské funkce v current-state Patronusu, nebo jsou
  napevno zakódovány do šablony motivu? Žádný důkaz `EN`/`UC` nebyl nalezen ani v jednom směru (viz
  Datové vazby) — to určuje, zda pravděpodobně existuje UC "spravovat statický obsah" (kandidát pro
  chybějící `UC0027`).
- Přesné cíle stažení (URL souborů, typy/velikosti souborů) pro PDF Desatera a všech 16 archivních
  odkazů nebyly ve screenshotovém důkazu zachyceny.
- Zda má nefunkční/expirovaný odkaz na dokument definované ošetření chyby, není doloženo.
- Rozlišení přístupného názvu pro opakující se odkazy "Stáhnout" (viz Poznámky k přístupnosti) zůstává
  nevyřešeno.
- Tato obrazovka a jí příbuzný `/blog` explicitně **zatím nejsou součástí redesign kánonu** — budoucí
  cílový návrh je sledován pod rebuild epicem **E0004** (dosud nevytvořený) a je záměrně mimo rozsah
  tohoto current-state dokumentu WIRE.

---

## Evidence (Evidence)

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Celkové rozvržení, zóny (poslání, video, výzva koordinátorky, mřížka týmu, banner etického kodexu, blok adresy, dva archivy dokumentů, patička) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-o-nas-2026-07-04-13_17_32.png`; `_ar/evidence/ui/ui-observed-areas.md` §16 |
| Route, vstupní bod navigace | Confirmed | `_ar/spec-draft/IA/IA-patronus.md`, řádky 85, 126, 213 |
| Doslovný text (prohlášení o poslání, blok adresy, nadpisy sekcí) | Confirmed | `ui-observed-areas.md` §16, reprezentativní doslovný přepis |
| Komponenty COMP0001 (tlačítko), COMP0002 (hlavička), COMP0003 (patička), COMP0020 (ikona) | Confirmed (přítomnost na této obrazovce) | `_ar/spec-draft/COMP/COMP0001_PrimaryButton.md`, `COMP0002_GlobalHeader.md`, `COMP0003_GlobalFooter.md`, `COMP0020_Icon.md`; křížová kontrola se screenshotem |
| Realizující UC = UC0027 | **Uncertain / dangling reference** | zadání úkolu vs. `_ar/spec-draft/UC/_REGISTRY.md` (UC0027 chybí); IA klasifikuje S015 jako "no UC" (`IA-patronus.md`, řádky 85, 126) |
| Datové vazby (tým/Desatero/archivy dokumentů → EN) | Uncertain — bez shody EN | `_ar/spec-draft/EN/_REGISTRY.md` (nebyla nalezena odpovídající entita); glosář (`_ar/repo-map/glossary-master.csv`) neobsahuje doménový termín "Desatero"/"výroční zpráva"/"kontrolní protokol" |
| Stavy empty / loading / error | Assumed / Uncertain — nezachyceno | pouze jediný celostránkový statický screenshot; pro tuto obrazovku nebyl nalezen žádný další důkaz |
| Přístupnost | Evidence Pending | pouze screenshotová evidence; žádný záznam DOM/ARIA není k dispozici |
| Rozsah pouze current-state (bez detailu cíle E0004) | Confirmed (omezení úkolu) | instrukce úkolu: "blog + o-nás zatím nejsou součástí redesign kánonu (rebuild epic E0004, nevytvořený)" |
