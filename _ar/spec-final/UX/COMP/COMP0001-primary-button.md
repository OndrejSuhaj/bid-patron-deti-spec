---
doc_id: COMP0001
title: Primary Button
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0019
  - WIRE0024
---

# COMP0001 – Primární tlačítko

## Účel

Vyplněné tlačítko s vysokým vizuálním důrazem (call-to-action) používané pro jedinou primární akci
na obrazovce nebo v kroku formuláře (odeslat krok, potvrdit dar, přihlásit se, aktivovat účet,
vyžádat dokument). Sdílené napříč moduly — identický červený/vyplněný vizuální a interakční tvar se
opakuje na Veřejném webu, v Průvodci žádostí, v Autentizaci a v modulu Účet. Opakované použití je
přímo pozorováno na nejméně 14 z 22 zdokumentovaných WIRE obrazovek (`WIRE0001`, `WIRE0002`,
`WIRE0003`, `WIRE0006`–`WIRE0015`, `WIRE0019`, `WIRE0024`), což s velkou rezervou splňuje pravidlo
opakovaného použití na ≥2 obrazovkách — jde o nejčastěji opakovaný inline element identifikovaný v
`_ar/spec-draft/WIRE-synthesis-report.md` §6.

## Vlastnosti / vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `label` | `string` | ano | — | Text tlačítka; vlastníkem je COPY pro danou obrazovku (např. "Pokračovat", "Odeslat", "Přispět 🤝", "Přihlásit se", "Aktivovat účet", "Uložit změny", "Ziskat potvrzení"). Tento COMP nevlastní ani nevyčerpává text popisku. |
| `onClick` | `function` | ano | — | Handler; cíl/odeslání pro danou obrazovku vlastní spotřebovávající UC (viz Kompozice/Použití). |
| `type` | `"button" \| "submit"` | ne | `"submit"` | Nativní sémantika tlačítka; `submit` je pozorováno jako dominantní použití uvnitř formulářů/kroků průvodce. |
| `disabled` | `boolean` | ne | `false` | Blokuje kliknutí, pokud nejsou splněna povinná pole; konkrétní blokovací pravidlo vlastní UC/BR (např. brány pro odeslání kroku `UC0001`), zde není opakováno. |
| `icon` | `string` | ne | `none` | Volitelný koncový/úvodní emoji nebo ikonový glyf pozorovaný jednou (🤝 na CTA daru, `WIRE0002`); jinak pouze text. |

## Varianty

- **důraz (emphasis):** primární (vyplněné červené) — jediná úroveň důrazu přímo pozorovaná s touto
  přesnou vizuální identitou. Opakuje se i vizuálně odlišné **sekundární** (obrysové/zelené)
  tlačítko (např. "Chci podporovat... pravidelně" na `WIRE0002`, akce v řádku "Vybrat"/"Více
  informací" na `WIRE0008`), ale jeho tvar není konzistentně identický ve všech výskytech (barva,
  výplň a styl podtržení-vs-tlačítko se liší) — je zanechán jako samostatná `Uncertain` sesterská
  varianta, nezahrnutá do potvrzené smlouvy tohoto COMPu. Viz Otevřená otázka níže.
- **šířka (width):** dle obsahu (většina obrazovek) | plná šířka (Uncertain — na statických snímcích
  v desktop šířce nelze jednoznačně rozlišit)

## Stavy

### idle (klidový)
Vyplněné červené pozadí, bílý tučný text popisku, zaoblený obdélník. Potvrzeno na každém citovaném
screenshotu (např. `screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` "Pokračovat";
`screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` "Přihlásit se").

### hover
`Uncertain — nelze pozorovat ze statických screenshot podkladů.`

### focused (zaostřeno)
`Uncertain — nelze pozorovat ze statických screenshot podkladů.`

### disabled (zakázáno)
`Uncertain — stav disabled nebyl zaznamenán nikde v podkladech; zda se tlačítko vizuálně ztlumí do
šedé nebo pouze blokuje odeslání při kliknutí, není podloženo důkazy.`

### loading (načítání)
`Uncertain — stav probíhajícího zpracování/spinner nebyl zaznamenán pro žádnou odesílací akci
(např. předání k platbě daru, odeslání kroku průvodce). Evidence Pending dle poznámek ke stavu
načítání WIRE0002/WIRE0007/WIRE0011.`

### error (chyba)
N/A — samotné tlačítko nemá žádné vykreslení chyby; chyby validace se zobrazují u přidružených polí
formuláře (viz např. inline chyba nesouladu telefonu na `WIRE0010`), nikoli na této komponentě.

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onClick` | žádný | kliknutí/dotyk uživatele nebo odeslání klávesou Enter na zaostřeném formuláři | Následný efekt (navigace, odeslání UC, otevření modálu) vlastní sekce Interakce spotřebovávajícího WIRE, nikoli tento COMP. |

## Přístupnost

Obvykle nelze přímo pozorovat ze screenshotů — pokud nejsou podložena záznamy nebo DOM podklady,
označit `Uncertain` / Otevřená otázka.

- **ARIA role:** `Uncertain` — dědění nativní sémantiky z `<button>` je Assumed výchozí předpoklad; k dispozici není DOM podklad potvrzující, že není použit žádný ARIA override.
- **Navigace klávesnicí:** `Uncertain` — Assumed dosažitelné standardním pořadím Tab; nepotvrzeno.
- **Správa fokusu:** `Uncertain` — nelze pozorovat ze statických podkladů.
- **Čtečka obrazovky:** `Uncertain` — předpokládá se, že ohlašovaný popisek se rovná viditelnému textu `label`; nepotvrzeno.

## Omezení použití

- Použít když: obrazovka nebo krok formuláře má přesně jednu dominantní následující akci (Confirmed
  vzor: jedno primární tlačítko na obrazovku/krok ve všech citovaných podkladech — žádná obrazovka
  nezobrazuje dvě tlačítka s primárním důrazem vedle sebe).
- Nepoužívat když: akce je sekundární/nepovinná (viz Otevřená otázka k sekundárnímu tlačítku) nebo
  čistě navigační (→ vzor textového odkazu, nikoli tento COMP).
- Kardinalita: jedno na obrazovku/krok (Confirmed pozorováním; žádný protipodklad).
- Umístění: konec bloku formuláře/obsahu, typicky zarovnané vpravo nebo na plnou šířku uvnitř
  obsahového panelu (Confirmed napříč kroky průvodce `WIRE0007`–`WIRE0011`).

## Závislosti

- Ostatní COMP: žádné (listová komponenta).
- Datové entity: žádné — tlačítko samo nenese žádnou vlastnost typovanou entitou.
- ACL: nepozorováno — viditelnost/aktivace je vázána na úplnost formuláře (vlastní BR/UC), nikoli na
  role, ve všech citovaných podkladech.
- Externí knihovny: nepodloženo.

## Kompozice

Listová komponenta; není složena z jiných COMP. Sama je často koncovým prvkem uvnitř obrazovek s
formulářem (viz obrazovky `COMP0005` Krokovač průvodce, `COMP0006` Zaškrtávací pole souhlasu,
`COMP0009` Formulář zadání e-mailu).

## Příklady

```
PrimaryButton label="Pokračovat" type="submit" />          // WIRE0007–WIRE0011 (kroky průvodce)
PrimaryButton label="Přihlásit se" type="submit" />         // WIRE0012 (přihlášení)
PrimaryButton label="Přispět 🤝" type="submit" icon="🤝" /> // WIRE0002 (dar)
PrimaryButton label="Aktivovat účet" type="submit" />       // WIRE0013 (aktivace)
```

## Otevřené otázky

- Zda je vizuálně odlišná varianta **sekundárního tlačítka** (obrysové/zelené, např. "Chci
  podporovat... pravidelně") skutečnou variantou téže komponenty, nebo zcela samostatným COMPem —
  podklady jsou napříč obrazovkami nekonzistentní (barva/výplň se liší) a nebyla zde povýšena, aby
  se nepřeceňovalo opakované použití jako identické. Zanecháno inline ve `WIRE0002`/`WIRE0008` do
  doby jasnějších podkladů.
- Stavy disabled/loading/hover/focus jsou zcela nepodložené; pokud bude v budoucnu k dispozici
  záznam runtime (viz `_ar/tasks/Runtime-truth-policy.md`), tento COMP by měl být přehodnocen.

## Podklady

| Oblast tvrzení | Jistota | Podklad |
|---|---|---|
| Opakované použití na ≥2 obrazovkách | Confirmed | 14+ WIRE dokumentů cituje identický vzor vyplněného červeného tlačítka; `_ar/spec-draft/WIRE-synthesis-report.md` §6 "Primary/secondary CTA button" |
| Vizuální klidový stav | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`, `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`, `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png` |
| stavy hover/focused/disabled/loading | Uncertain | žádný záznam v `_ar/prtsc/` nezobrazuje žádný z těchto stavů |
| Přístupnost | Uncertain | nejsou k dispozici žádné DOM/záznamové podklady |
