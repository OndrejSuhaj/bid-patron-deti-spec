---
doc_id: WIRE0003
title: Thank You Payment Success
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S003
realizes_uc: [UC0006]
status: canonical
references:
  - UC0006
  - UC0025
  - EN0009
  - EN0003
  - EN0001
  - BR-PaymentGatewayCallbacks
---

# WIRE0003 – Poděkování po úspěšné platbě

## Účel

`/dekujeme` je obecná, na příběhu nezávislá cílová stránka, na kterou je prohlížeč dárce přesměrován
po dokončení platebního pokusu na platební bráně. Realizuje **UC0006 — Confirm Payment (Gateway Callback)**:
konkrétně čtecí (read-only) krok návratu prohlížeče pro Netopia (UC0006.2 krok 9–10) a krok
přesměrování pro MAIB (UC0006.3 krok 8), kde Customer „receives a visual success/failure result but
does not perform a status-changing action" (UC0006, Actors & Responsibilities). Aktér: Customer
(dárce), anonymní nebo přihlášený.

Druhý, nezávisle spouštěný překryvný panel (overlay) na stejné routě hostí **UC0025 — Resume or
Discard Draft Application** (modální okno „Máte u nás rozpracovanou žádost"). Podle `ui-observed-areas.md`
§13 se zobrazení tohoto modálního okna „triggered by session state, independent of the just-completed
donation" — tj. není součástí toku potvrzení platby a je zde zdokumentováno pouze jako souběžně
přítomný overlay. Jeho vlastní chování (obnovit/zachovat/smazat) je v gesci UC0025; tento WIRE ho
nepopisuje znovu.

Kontext vstupu: server-to-server potvrzení callbacku probíhá mimo obrazovku (platební brána ↔ System);
prohlížeč Customer se na tuto obrazovku dostane pouze přesměrováním po odchodu z platební brány
(u Comgate/S-EXT2 pro CZ je doloženo dosažení route merchant-return; Netopia/RO a MAIB/MD návraty
prohlížeče podle UC0006.2/.3). Viz `IA-patronus.md` Entry Points („gateway callback → `/dekujeme`").

---

## Layout Zones

- **Header** — globální navigace webu (logo "patron dětí"; nav: "Jak to funguje", "Blog", "O nás";
  CTA "Požádat o pomoc"; odkaz na účet "Můj účet"). Confirmed. Navigace samotná je v gesci IA; zde je
  uvedena pouze pro vymezení zóny.
- **Hero / hlavní obsah** — centrované, jednosloupcové, na světle růžovém pozadí:
  - ikona úspěchu (červený kruh, bílá zaškrtávací značka)
  - nadpis: "Platba proběhla úspěšně, děkujeme za pomoc!"
  - dva odstavce poděkovacího textu
  - řádek ikon pro sdílení na sociálních sítích
  - primární CTA tlačítko: "Zpět na hlavní stránku"
- **Cookie lišta** — dole fixovaný pruh přes footer, zavíratelný (odkaz "Další informace"); obecný
  prvek platný pro celý web, nikoli specifický pro tuto obrazovku.
- **Footer** — globální footer webu (popis organizace, odkaz na Facebook, atribuce Nadace Sirius,
  odkaz na registrovanou sbírku, sloupce odkazů ve stylu sitemap "Patron dětí"/"Kontakt", loga
  platebních partnerů, číslo sbírkového účtu, právní odkazy, copyright).
- **Modální overlay (podmíněný)** — centrované dialogové okno ztlumující pozadí stránky; hostí
  výzvu k obnovení rozpracované žádosti (UC0025). Viz States → default (variant) a Conditional
  Visibility.

Confirmed — obě snímky obrazovky (`screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png`,
`screencapture-patrondeti-cz-dekujeme-2026-07-04-13_30_32.png`).

```
+--------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | Požádat  |
|              o pomoc (CTA) | Můj účet                  |
+--------------------------------------------------------+
|                                                          |
|                    (✓) success icon                     |
|                                                          |
|      Platba proběhla úspěšně, děkujeme za pomoc!         |
|                                                          |
|   Každý příspěvek pomáhá k lepšímu dětství. Děkujeme,    |
|                  že jste s námi.                         |
|   Platba proběhla úspěšně! Moc děkujeme. Prosíme,        |
|      sdílejte a pomozte příběhu, kterému jste práve      |
|                     přispěli.                            |
|                                                          |
|         [FB] [X] [IG] [in] [WA] [Email] [Messenger]      |
|                                                          |
|              [ Zpět na hlavní stránku ]                  |
|                                                          |
+--------------------------------------------------------+
| Cookie banner: 🍪 ... Další informace .                  |
+--------------------------------------------------------+
| Footer: brand block | link columns | Kontakt |           |
| payment logos | account no. | legal links | © 2026       |
+--------------------------------------------------------+

Modální overlay (podmíněný — nezávislý spouštěč, UC0025):
        +---------------------------------------+
        |                                    (x) |
        |              [→] icon                  |
        |     Máte u nás rozpracovanou žádost.    |
        |   Vypadá to, že jste u nás nechali...   |
        |  [ Návrat do žádosti ]  Zůstat na stránce|
        |  ----------------------------------------|
        |  Přejete si žádost o pomoc zcela zrušit? |
        |              Smazat žádost.              |
        +---------------------------------------+
```

---

## Components Used

Opakující se prvky povýšené na COMP pomocí **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označeny `inline` (nedoloženo opakované použití na ≥2 obrazovkách).

| Zóna | COMP-id | Varianta/vlastnosti | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Hero | inline | ikona stavu úspěchu (zaškrtávací značka v kruhu, červená/korálová) | Confirmed, oba snímky obrazovky |
| Hero | inline | text nadpisu (styl H1, korálová/červená) | Confirmed |
| Hero | inline | text odstavce (×2) | Confirmed |
| Hero | inline | řádek ikon pro sdílení na sociálních sítích (Facebook, X, Instagram, LinkedIn, WhatsApp, Email, Messenger) | Confirmed — 7 ikon, bez viditelných popisků, tlačítka pouze s ikonou |
| Hero | COMP0001 | — | primární CTA tlačítko ("Zpět na hlavní stránku"); viz `COMP0001` Primary Button |
| Cookie lišta | COMP0004 | — | viz `COMP0004` Cookie Consent Banner |
| Footer | COMP0003 | — | viz `COMP0003` Global Site Footer |
| Modal | inline | kontejner dialogu (ikona, titulek, text, dvě akce vedle sebe, oddělovač, sekundární destruktivní odkaz, zavírací "×") | Confirmed, druhý snímek obrazovky |

---

## Interactions

1. **Vstup** — přesměrování prohlížeče z platební brány (Comgate return route pro CZ podle sdílených
   side effects hlavního toku UC0006; Netopia read-only návrat podle UC0006.2 kroky 9–10; MAIB
   přesměrování podle UC0006.3 krok 8) → stav: `default`. Není doloženo žádné client-side načtení dat;
   stránka vykresluje statickou zprávu o úspěchu bez ohledu na částku/příběh (viz Data Bindings).
2. **Primární akce — "Zpět na hlavní stránku"** — klik → přejde na výchozí cílovou stránku webu (S001,
   podle `IA-patronus.md` Entry Points `/` → S001). Sama o sobě nerealizuje žádný UC (žádná akce
   měnící stav podle popisu aktéra v UC0006); jde o čistě navigační výstup.
3. **Sekundární akce — sdílení na sociální síti** — klik na jednu ze 7 ikon sdílení → otevře příslušný
   externí tok sdílení (Facebook/X/Instagram/LinkedIn/WhatsApp/Email/Messenger). Cílový obsah (jaká
   URL/text se sdílí) je Uncertain — nelze ověřit ze statického snímku obrazovky; text vyzývá ke
   sdílení „příběhu, ke kterému jste právě přispěli", ale obecná stránka nezobrazuje žádný identifikátor
   příběhu (viz Data Bindings, Open Question níže).
4. **Modal — "Návrat do žádosti"** — klik → obnoví rozpracovanou žádost (Application) podle UC0025.1;
   zde nepopsáno podrobně (v gesci UC0025 / WIRE pro obrazovky průvodce, např. S008a–e).
5. **Modal — "Zůstat na stránce"** — klik → zavře modální okno, zůstává na S003 beze změny (UC0025.2).
6. **Modal — "Smazat žádost"** — klik → zahodí rozpracovanou žádost (Application) podle UC0025.3
   (destruktivní akce, stylovaná jako prostý textový odkaz, nikoli tlačítko — Confirmed ze snímku
   obrazovky).
7. **Modal — zavření "×"** — klik → zavře modální okno (chování shodné s "Zůstat na stránce" je
   Assumed, samostatně nedoloženo).
8. **Výstup** — přes primární CTA (→ S001) nebo přes libovolný odkaz v navigaci header (v gesci IA)
   nebo zavřením záložky.

---

## States

### default
Zpráva o úspěchu, řádek sdílení a CTA jsou zobrazeny bez jakéhokoli jiného stavu specifického pro
obrazovku (viz snímek obrazovky `..._13_31_51.png`). Confirmed.

### default (varianta s modálním oknem)
Tatáž stránka ztlumená pod modálním oknem s výzvou k obnovení rozpracované žádosti (viz snímek
obrazovky `..._13_30_32.png`). Confirmed jako skutečně zachycený stav; podmínka jeho spuštění
("má tento klient aktivní ApplicationSession, EN0003, pro ještě neodeslanou Application, EN0001")
je v gesci UC0025 a je tam samotná označena jako Partial — „the exact client-side trigger condition
for showing the ... modal ... is front-end (SPA) logic not present in this repository" (UC0025,
Evidence Level). Zde dále nedomýšleno.

### empty
N/A — tato obrazovka nemá žádný obsah typu seznam/kolekce, který by mohl být prázdný; vždy vykresluje
tutéž statickou šablonu úspěchu bez ohledu na skutečná data podkladové Transaction (nezobrazuje se
žádná částka ani příběh, potvrzeno poznámkou v `ui-observed-areas.md` §13: „the generic success page
shows no amount/story name").

### loading
Evidence Pending — nezachyceno. V žádném ze snímků obrazovky není viditelný žádný indikátor
načítání a pro tuto stránku není doloženo žádné client-side asynchronní načítání (zpráva o úspěchu
se zdá vykreslovat server-side z přesměrování, nikoli z client-side dotazu). Assumed: pro hlavní
obsah zprávy o úspěchu neexistuje žádný stav načítání. Uncertain, zda samotné zobrazení modálního
okna zahrnuje asynchronní kontrolu (např. ověření platnosti session podle UC0025) před vykreslením
— nedoloženo.

### error
Evidence Pending — nezachyceno. Alternativní toky UC0006 dokumentují chybové cesty na hranici
gateway/System (AF1 selhání ověření autenticity callbacku, AF3 MAIB nedostupný → zobrazeno jako
PENDING success), ale žádný snímek obrazovky s chybovou variantou samotné `/dekujeme` neexistuje.
Podle Postconditions UC0006 se u MAIB „any status other than CANCELLED is shown to the Customer as
success, including a still-PENDING outcome" — což naznačuje, že skutečně neúspěšná/CANCELLED platba
může Customer přesměrovat na *jinou* obrazovku nebo na variantu, která zde není zachycena.
Uncertain / Open Question — nepovažováno za chování této obrazovky.

---

## Validation Surfaces

Žádné. Tato obrazovka nemá žádná vstupní pole formuláře (`ui-observed-areas.md` §13:
"Form fields / Tables: none"). Akce modálního okna ("Návrat do žádosti" / "Zůstat na stránce" /
"Smazat žádost") jsou jednokrokové volby bez pozorované validace na úrovni polí.

validationsWithoutBR: (žádné — na této obrazovce nebyly identifikovány žádné validační plochy)

---

## Data Bindings

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Nadpis/text úspěchu | — | — | Confirmed: statický text, žádná navázaná data. Stránka nezobrazuje částku, příběh ani žádnou hodnotu specifickou pro dárce z Transaction (`EN0009`) — potvrzená absence podle poznámky v `ui-observed-areas.md` §13. |
| (nezobrazeno) Výsledek transakce | `EN0009` | — | Podkladový výsledek platby, který určuje, zda je tato stránka vůbec dosažena, je stav `EN0009` (Transaction), nastavený UC0006 — na obrazovce se ale nevykresluje žádné pole Transaction. Uvedeno pouze pro traceability, nikoli jako pozorovaná vazba. |
| Text modálního okna | `EN0001` / `EN0003` | — | Premisa modálního okna ("Máte u nás rozpracovanou žádost") závisí na existenci Application (`EN0001`) s aktivní ApplicationSession (`EN0003`) pro aktuálního klienta, podle Preconditions UC0025. Text modálního okna nezobrazuje žádný počet/identifikátor rozpracované žádosti (Confirmed ze snímku obrazovky — text je obecný, nevykresluje se název/datum žádosti). |

Open Question: zda tlačítka sdílení na sociální síti nesou nějaký navázaný cíl sdílení (slug/URL
příběhu) je Uncertain — nelze ověřit ze statické evidence; označeno k dořešení v UC0006/COPY,
nikoli zde předpokládáno.

---

## Conditional Visibility

| Komponenta/zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Modální okno obnovení rozpracované žádosti | Klient má `Active` ApplicationSession (`EN0003`) pro ještě neodeslanou Application (`EN0001`) — podmínka v gesci Preconditions UC0025; žádný dokument `BRxxxx`/`ACLxxxx` v současnosti tuto spouštěcí podmínku nevlastní (v samotné Evidence Level UC0025 označeno jako Partial) | Modální okno chybí; zobrazí se pouze čistá stránka úspěchu (jako na `..._13_31_51.png`) |
| Odkaz na "Můj účet" v header | Confirmed přítomen bez ohledu na stav autentizace na této obrazovce (popisek "Můj účet" je zobrazen v obou snímcích obrazovky); skutečný cíl po kliknutí je řízen rolí/autentizací podle IA, nikoli v gesci této obrazovky | n/a — v gesci IA |

Vrstva ACL pro tento krok rekonstrukce ještě neexistuje; výše uvedená podmínka pro zobrazení
modálního okna je zaznamenána jako Open Question k UC0025/EN0003, nikoli vymyšlena jako BR.

---

## Accessibility Notes

Uncertain / Evidence Pending pro všechny níže uvedené body — statický snímek obrazovky nemůže
potvrdit pořadí v DOM, správu fokusu ani použití ARIA; zaznamenáno jako Assumed výchozí hodnoty podle
běžného vzoru, nikoli jako pozorovaný fakt.

- **Pořadí tabulátoru:** Assumed — navigace header → ikony sdílení v hero → primární CTA → odkazy
  v footeru, podle vizuálního pořadí shora dolů, zleva doprava. Nedoloženo.
- **Fokus při vstupu:** Uncertain — nedoloženo, zda je fokus programově nastaven (např. na H1) při
  příchodu z přesměrování platební brány.
- **Fokus při přechodu stavu (otevření modálního okna):** Assumed — správně vytvořené modální okno
  by zachytávalo fokus uvnitř dialogu a přesunulo výchozí fokus na jeho titulek nebo první akci
  ("Návrat do žádosti"); pouze ze snímku obrazovky nedoloženo.
- **Landmarky:** Uncertain — ze snímků obrazovky není k dispozici žádná evidence DOM/ARIA.
- **Klávesové zkratky:** Uncertain — není doloženo chování Escape-to-close pro modální okno
  (vizuální zavírací prvek "×" je přítomen; zda je ovladatelný klávesnicí, není doloženo).

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Layout zóny (header/hero/cookie lišta/footer) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png` |
| Nadpis/text úspěchu, ikony sdílení, CTA | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png`; `ui-observed-areas.md` §13 |
| Rozvržení a text modálního okna | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_30_32.png`; `ui-observed-areas.md` §13 |
| Podmínka spouštění modálního okna | Partial (v gesci UC0025) | `_ar/spec-draft/UC/UC0025_ResumeDiscardDraftApplication.md` Evidence Level / Open Questions |
| Nezobrazují se žádná data o částce/příběhu | Confirmed | `ui-observed-areas.md` §13 ("the generic success page shows no amount/story name") |
| stavy loading / error | Uncertain — nezachyceno | (absence evidence; nenalezen žádný snímek obrazovky ani stav FE na úrovni kódu) |
| Realizace UC0006 (sémantika návratu prohlížeče) | Confirmed | `_ar/spec-draft/UC/UC0006_ConfirmPayment.md` (Actors & Responsibilities; UC0006.2 steps 9–10; UC0006.3 step 8) |
