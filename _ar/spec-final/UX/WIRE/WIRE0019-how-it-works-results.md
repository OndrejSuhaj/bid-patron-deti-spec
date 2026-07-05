---
doc_id: WIRE0019
title: How It Works Results
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S016
realizes_uc: [UC0011]
status: imported
references:
  - UC0011
  - UC0017
  - EN0004
  - EN0021
  - EN0032
---

# WIRE0019 – Výsledky sekce Jak to funguje

## Účel

Veřejná, anonymnímu návštěvníkovi určená obsahová/důvěryhodnostní stránka na `/vysledky` ("Jak to
funguje / Výsledky"), dostupná z položky globální navigace "Jak to funguje" a z odkazu v patičce
"Splněné příběhy" (`_ar/spec-draft/IA/IA-patronus.md`, řádky 82/97/214). Vysvětluje proces darování ve
třech krocích, uvádí osm argumentů pro důvěryhodnost, zobrazuje tři agregované ukazatele dopadu a
prezentuje mřížku splněných Příběhů (Campaigns) s odznaky "SPLNĚNO" (completed) a "ZPĚTNÁ VAZBA"
(feedback), z nichž každý odkazuje na obrazovku detailu Příběhu (S002, `WIRE0002`).

UC, který tuto obrazovku realizuje, je přenesen s jistotou **Probable** z IA Screen Map
(`_ar/spec-draft/IA-screen-map.md`, řádek S016): `UC0011` (Manage Campaign / Story Lifecycle) je
jediný UC, který řídí stav Campaign `completed` zobrazený zde (odznak "SPLNĚNO" — pojem z glosáře
C106 "splněný příběh"), avšak UC0011 sám o sobě nepopisuje veřejnou čtecí obrazovku — popisuje
administrátorské/plánovačem řízené přechody životního cyklu, které produkují stav `completed`
konzumovaný zde. Tato obrazovka je proto **pouze čtecím konzumentem** stavu Campaign (`EN0004`)
nastaveného UC0011, nikoli aktorem řízeným tokem samotného UC0011. Podle IA-Q7 (`IA-patronus.md`
řádek 331) **nelze určit**, zda tři agregované ukazatele ("232,7 mil. Kč" / "70 299 lidí" / "8 000 Kč"
/ "32 977 příběhů") představují vypočítaný read-model (kandidáti: `EN0032` ReportSnapshot / `UC0017`
reportovací read-model) nebo statický redakční obsah — je to zde ponecháno jako otevřená otázka, bez
vyřešení.

Aktor: anonymní návštěvník (žádná autentizace nebyla pozorována ani není předpokládána).

---

## Zóny rozvržení

```
+--------------------------------------------------------+
| Global nav — logo | Jak to funguje | Blog | O nás |     |
|                    Požádat o pomoc (CTA) | Můj účet     |
+--------------------------------------------------------+
| Hero band — "Jak to funguje?" 3-step explainer          |
|   [icon] 1. Rodič a Patron vyplní žádost                |
|   [icon] 2. Společně hledáme dárce                      |
|   [icon] 3. Na pořízení pomoci jde 100 % daru            |
+--------------------------------------------------------+
| Trust section — "Proč nám můžete důvěřovat?"            |
|   8 × (icon, heading, body text) trust arguments        |
+--------------------------------------------------------+
| Aggregate stats band — 3 figure blocks                  |
|   CELKEM VYBRÁNO | CELKEM PŘISPĚLO | PRŮMĚRNÝ PŘÍBĚH    |
+--------------------------------------------------------+
| Impact banner — full-bleed photo + headline figure       |
|   "Společně jsme podpořili 32 977 příběhů"               |
+--------------------------------------------------------+
| Completed-stories grid — "Podívejte se na ně"            |
|   2 rows × 3 cards (image, badges, title, amount, CTA)  |
|   "Další příběhy" (load more / pagination link)          |
+--------------------------------------------------------+
| Footer — cookie notice, company info, nav link clusters, |
|          payment-provider logos, collection account no.  |
+--------------------------------------------------------+
```

- **Globální navigace** — logo (→ S001), "Jak to funguje" (aktuální stránka), "Blog" (→ S013), "O nás"
  (→ S015), CTA "Požádat o pomoc" (→ S006), "Můj účet" (→ přihlašovací zóna). — Confirmed.
- **Hero pásmo / vysvětlení "jak to funguje"** — růžové pásmo na pozadí, tři číslované kroky s ikonou,
  nadpisem a doprovodným textem. — Confirmed.
- **Sekce důvěryhodnosti** — nadpis "Proč nám můžete důvěřovat?" následovaný 8 vertikálně řazenými
  položkami, každá tvořena ikonou + tučným nadpisem + textovým odstavcem (dvě položky obsahují vložené
  textové odkazy: "výročních zprávách", "pravidelně kontrolována"). — Confirmed.
- **Pásmo agregovaných statistik** — tři vedle sebe umístěné popsané ukazatele na světle šedém pozadí.
  — Confirmed rozvržení; **Uncertain**, zda jsou hodnoty dynamické nebo statické (viz Účel, IA-Q7).
- **Banner dopadu** — celoplošná fotografie na pozadí se středovým hlavním ukazatelem. — Confirmed
  rozvržení; stejná nejistota dynamický/statický jako u pásma statistik.
- **Mřížka splněných příběhů** — nadpis "Podívejte se na ně", responzivní mřížka karet Příběhů
  (6 viditelných: 2 řádky × 3 sloupce), každá s náhledovým obrázkem, dvěma odznaky vlevo/vpravo
  nahoře, stavovou stuhou, titulkem, řádkem vybrané částky a CTA tlačítkem; odkaz "Další příběhy"
  pod mřížkou. — Confirmed.
- **Patička** — lišta souhlasu s cookies, blok o společnosti ("patron dětí" + zřizovatel "Nadace
  Sirius" + upozornění na registrovanou sbírku), tři shluky navigačních odkazů ("Patron dětí",
  "Kontakt", sociální sítě), loga platebních poskytovatelů (Comgate/Mastercard/Visa), číslo sbírkového
  účtu. — Confirmed. (Patička je sdílená/globální oblast — cíle jejích vnitřních odkazů náleží vrstvě
  IA a nejsou zde znovu uváděny; viz IA-Q8.)

---

## Použité komponenty

Opakující se prvky povýšené na COMP pomocí **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají oznčeny jako `inline` (nebylo prokázáno opakované použití na ≥2
obrazovkách).

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Globální navigace | COMP0002 | context=public | sdílený header, stejný jako pozorovaný na S001/S013/S015; viz `COMP0002` Global Site Header |
| Krok "jak to funguje" | inline | 3× ikona+nadpis+text, opakováno ×3 | — |
| Položka seznamu důvěryhodnosti | inline | ikona+nadpis+odstavec, opakováno ×8 | dvě položky obsahují vložené textové odkazy |
| Blok statistického ukazatele | inline | popisek+hodnota, opakováno ×3 | — |
| Banner dopadu | inline | celoplošná fotografie + středový hlavní ukazatel | — |
| Karta příběhu (completed) | COMP0008 | lifecycle=completed | stejná rodina vzoru karty jako katalogová karta na S001 (`WIRE0001`), ale s variantou stavu completed (stuha + odznak feedback), která tam jinak nebyla pozorována — považováno za odlišnou, méně jistou sesterskou variantu `COMP0008` Story Card, nikoli potvrzeně identickou s aktivní variantou (viz `COMP0008` Otevřené otázky) |
| Odkaz "Další příběhy" | inline | textový odkaz | prvek pro paginaci/dohledání dalšího obsahu; cílové chování nebylo pozorováno (viz Interakce) |
| Patička | COMP0003 | — | stejná jako pozorovaná na ostatních obrazovkách veřejného webu; viz `COMP0003` Global Site Footer |

---

## Interakce

1. **Vstup** — přímá navigace na `/vysledky` přes globální navigaci "Jak to funguje" nebo odkaz
   v patičce "Splněné příběhy" → stav: `default`. — Confirmed (route + vstupní body;
   `IA-patronus.md` řádek 214).
2. **Primární akce — "Detail příběhu"** — kliknutí na CTA karty splněného příběhu → naviguje na
   obrazovku detailu daného Příběhu (S002, `WIRE0002`); samo o sobě na této obrazovce nerealizuje
   žádný UC (jde pouze o navigaci pro čtení). — Confirmed (cílová obrazovka a vzor), na základě
   identického popisku CTA pozorovaného na kartách rodiny S002.
3. **Sekundární akce — "Další příběhy"** — kliknutí na odkaz "Další příběhy" pod mřížkou → očekává
   se načtení/zobrazení dalších karet splněných příběhů (paginace nebo infinite-scroll); výsledné
   chování (přidání na místě vs. plná navigace vs. znovunačtení stránky) **nebylo pozorováno**
   v zachyceném snímku obrazovky. — Uncertain.
4. **Sekundární akce — vložené odkazy v sekci důvěryhodnosti** ("výročních zprávách", "pravidelně
   kontrolována") — kliknutí → navigace na podpůrné stránky s důkazy (výroční zprávy / záznam
   o dohledu); přesné cíle nebyly na této obrazovce zachyceny (mimo rozsah pro WIRE — viz IA-Q8). —
   Assumed.
5. **Výstup** — přes globální navigaci (na S001/S013/S015/S006) nebo odkazy v patičce; neexistuje
   žádný explicitní výstup typu "zrušit"/"odeslat", protože jde o čistě čtecí obsahovou obrazovku. —
   Confirmed.

---

## Stavy

### default
Plně vykreslená stránka tak, jak byla zachycena: hero vysvětlení, seznam důvěryhodnosti, tři
statistické ukazatele, banner dopadu a naplněná mřížka 6 karet splněných příběhů s odkazem "Další
příběhy". — Confirmed (`screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png`).

### empty
Nebylo pozorováno. Pokud žádný splněný Příběh nesplňuje podmínky pro mřížku (např. nula Campaigns
ve stavu `completed`), zpracování prázdné mřížky je neznámé — neexistuje důkaz o zástupném/nulovém
stavu se zprávou. Předpokládá se, že by se sekce mřížky nevykreslila nebo by se skryla, ale toto je
nepotvrzené. — `Uncertain — not captured`.

### loading
Nebylo pozorováno. Zda se pásmo statistik / mřížka vykresluje synchronně se stránkou
(statický/SSR obsah) nebo asynchronně (skeleton/spinner během vyhodnocování dotazu na read-model),
závisí na nevyřešené otázce IA-Q7 (dynamický vs. statický obsah). — `N/A — dynamism of this
screen's data is itself an open question (IA-Q7); no loading-state evidence exists either way`.

### error
Nebylo pozorováno. Žádné zpracování chyby/selhání (např. neúspěšné načtení statistik nebo mřížky)
nebylo prokázáno. — `Uncertain — not captured`.

---

## Validační plochy

Jde o čistě čtecí obsahovou/prohlížecí obrazovku bez formulářových polí nebo uživatelem
vkládaného vstupu — žádné validační plochy se neuplatňují.

`N/A — no input controls observed on this screen (Controls/Form fields: none, per
_ar/evidence/ui/ui-observed-areas.md §17)`.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Karta v mřížce splněných příběhů | `EN0004` (Campaign, stav `completed` / pojem z glosáře C106 "splněný příběh") | — | odznak "SPLNĚNO" — Confirmed vazba na stav životního cyklu Campaign podle `EN0004` a UC0011; dotaz pro naplnění/filtrování/řazení karet nebyl prokázán (žádný QUERY dokument nebyl identifikován) — Uncertain |
| Karta v mřížce splněných příběhů — odznak "ZPĚTNÁ VAZBA" | `EN0021` (Feedback) | — | pojmy z glosáře C008/C109/C117 spojují "zpětná vazba" s entitou Feedback a se souvisejícími aliasy stavu; přesná vazba (jde o příznak přítomnosti entity Feedback, nebo o alias stavu Campaign/Application jako `feedback_sent`?) je **Uncertain** — samotný snímek obrazovky to neřeší |
| Pásmo agregovaných statistik (CELKEM VYBRÁNO / CELKEM PŘISPĚLO / PRŮMĚRNÝ PŘÍBĚH) | `EN0032` (ReportSnapshot) — kandidát, nepotvrzeno | — | podle IA-Q7: může jít o vypočítaný read-model (`UC0017` dílčí tok UC0017.3) nebo o statický redakční obsah; **Uncertain**, neprohlašováno za potvrzené |
| Hlavní ukazatel v banneru dopadu ("32 977 příběhů") | `EN0032` (ReportSnapshot) — kandidát, nepotvrzeno | — | stejná nejistota IA-Q7 jako u pásma statistik |
| Řádek vybrané částky na kartě příběhu ("Vybráno celkem … Kč") | `EN0004` (`campaign_raised`) | — | Probable — odpovídá systémově řízenému odvozenému celkovému vybranému součtu entity Campaign, v souladu s částkami zobrazenými na jednotlivých kartách příběhů jinde (S001/S002), i když pro tuto obrazovku nebylo nezávisle potvrzeno |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | žádná pozorována | anonymní/veřejná — nebyla pozorována žádná role brány; vrstva ACL pro tuto rekonstrukční fázi ještě neexistuje |
| Navigační odkaz "Můj účet" | Předpokládaná varianta pro přihlášený stav (na tomto snímku neprokázáno) | — viz IA / ostatní obrazovky pro variantu navigace přihlášeného uživatele; mimo rozsah zde |

Žádný dokument BR nebo ACL upravující viditelnost na této obrazovce nebyl nalezen; je považována za
bezpodmínečně veřejný obsah.

---

## Poznámky k přístupnosti

Nebylo pozorováno v podkladech ze statického snímku obrazovky — jako součást této rekonstrukční
fáze nebyla provedena žádná kontrola DOM/ARIA. Následující body jsou `Uncertain`/`Evidence
Pending`:

- **Pořadí tabulátoru:** Předpokládá se, že sleduje vizuální/DOM pořadí (navigace → hero → seznam
  důvěryhodnosti → statistiky → banner → karty mřížky → patička) — nebylo ověřeno.
- **Fokus při vstupu:** Nebylo pozorováno.
- **Fokus při přechodu stavu:** Nebylo pozorováno (žádný přechod stavu nebyl zachycen — viz Stavy).
- **Landmarks:** Nebylo pozorováno; přítomnost sémantických landmarků `<nav>`/`<main>`/`<footer>`
  nelze ze snímku obrazovky samotného potvrdit.
- **Klávesové zkratky:** Žádné nepozorovány; žádné se neočekávají u obsahové prohlížecí obrazovky.

---

## Otevřené otázky

- IA-Q7 (přenesena z vrstvy IA, `IA-patronus.md` řádek 331): jsou tři agregované statistiky a
  ukazatel v banneru dopadu vypočítaný read-model (`EN0032`/`UC0017`) nebo statický redakční obsah?
  Toto určuje, zda tato obrazovka má vůbec stav `loading`/`error`.
- Je "ZPĚTNÁ VAZBA" na kartě příběhu řízena přítomností entity Feedback `EN0021`, nebo aliasem
  stavu Campaign/Application (pojmy z glosáře C109 `feedback_sent` / C117 `feedback_received`)?
  Žádný dokument BR nebo query toto neřeší.
- Co určuje, které splněné Campaigns/Stories jsou vybrány/uspořádány do mřížky 6 karet
  (nejnovější? příznak "featured"? náhodně?) a co dělá odkaz "Další příběhy" (paginace na místě,
  navigace na obrazovku s úplným seznamem, nebo infinite-scroll)? Nebylo pozorováno.
- Vizuální zpracování prázdného/načítacího/chybového stavu pro pásmo statistik a mřížku příběhů
  není vůbec podloženo důkazy.

---

## Evidence

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Celkové rozvržení, zóny, obsah hero/trust/stats/banner/grid/footer | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png`; `ui-observed-areas.md` §17 |
| Route, vstupní body z navigace, vstupní bod z patičky | Confirmed | `_ar/spec-draft/IA/IA-patronus.md` řádky 82, 97, 214 |
| Realizující UC = UC0011 | Probable | `_ar/spec-draft/IA-screen-map.md` řádek S016 |
| Odznak "SPLNĚNO" → stav Campaign `completed` | Probable | `EN0004` lifecycle; glosář C106 |
| Odznak "ZPĚTNÁ VAZBA" → EN0021 Feedback | Uncertain | glosář C008/C109/C117; nebyla nalezena přímá vazba na query/BR |
| Dynamismus agregovaných statistik (EN0032/UC0017 vs. statický obsah) | Uncertain | `IA-patronus.md` IA-Q7; poznámka `ui-observed-areas.md` §17 |
| stavy empty / loading / error | Uncertain / not captured | pro tuto obrazovku nebyly nalezeny žádné další snímky obrazovky ani důkazy |
| Přístupnost | Evidence Pending | pouze podklady ze snímku obrazovky; žádný záznam DOM/ARIA není k dispozici |
