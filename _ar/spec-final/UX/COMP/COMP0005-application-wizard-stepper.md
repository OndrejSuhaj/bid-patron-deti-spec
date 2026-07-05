---
doc_id: COMP0005
title: Application Wizard Stepper
layer: COMP
spec_type: component
modules: []
status: imported
references:
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - UC0001
  - EN0001
---

# COMP0005 – Application Wizard Stepper

## Účel

5krokový číslovaný indikátor postupu ("Příběh / Dar / O Vás / Patron / Přílohy") zobrazený v horní
části každého kroku průvodce podáním žádosti (`UC0001`, nad entitou `EN0001` Application). Jde o
nejsilnějšího kandidáta na znovuužití v rámci sady WIRE: identický 5krokový chrome, lišící se pouze
stavy jednotlivých kroků (active/complete/upcoming), je přímo pozorován na všech pěti WIRE dokumentech
pro kroky průvodce (`WIRE0007`–`WIRE0011`, obrazovky S008a–S008e).

## Props / Vstupy

| Název | Typ | Povinné | Výchozí hodnota | Popis |
|---|---|---|---|---|
| `steps` | `string[]` | ne | `["Příběh", "Dar", "O Vás", "Patron", "Přílohy"]` | Pevná sada 5 popisků pozorovaná identicky na všech pěti obrazovkách; konfigurovatelnost nepotvrzena. |
| `activeIndex` | `number (1-5)` | ano | — | Který krok je aktuálně aktivní; určuje zvýraznění příslušného kroku. |
| `completedIndices` | `number[]` | ne | `[]` | Kroky vykreslené se zaškrtávacím symbolem místo čísla (kroky před `activeIndex`). |

## Varianty

- **počet kroků:** 5 (jediná pozorovaná kardinalita; žádný důkaz o proměnném počtu kroků).

## Stavy

### idle
Horizontální řada 5 číslovaných kruhů propojených čárou; každý kruh vykresluje jeden ze tří
vizuálních podstavů podle své pozice vzhledem k `activeIndex` (viz níže). Potvrzeno na všech pěti
citovaných screenshotech, např.
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` (krok 1 aktivní,
všechny ostatní upcoming) a `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`
(krok 1 dokončen/se zaškrtnutím, krok 2 aktivní).

Podstavy jednotlivých kruhů (všechny Confirmed přímým vizuálním porovnáním napříč pěti obrazovkami):
- **upcoming** — šedě orámovaný kruh se šedým číslem kroku, šedý popisek.
- **active** — vyplněný červený kruh s bílým číslem kroku, červený tučný popisek.
- **completed** — vyplněný červený kruh s bílým symbolem zaškrtnutí (bez čísla), červený popisek.

### hover
`Uncertain — nelze pozorovat ze statických důkazů; kroky nevypadají jako klikatelné (žádný důkaz
zpětného přeskoku kliknutím; zpětná navigace probíhá přes samostatný odkaz "Krok zpět", nikoli
přes samotný stepper).`

### focused
`Uncertain — nelze pozorovat ze statických důkazů.`

### disabled
N/A — nepozorováno žádné vykreslení disabled stavu; nadcházející (upcoming) kroky jsou vizuálně
utlumené (šedé), ale jde o standardní podstav idle "ještě nedosaženo", nikoli o disabled interaktivní
stav.

### loading
N/A — samotný stepper nemá žádné asynchronní chování; odráží pozici v průvodci synchronně s
navigací.

### error
N/A — žádné vykreslení chyby stepper nevlastní; validační chyby jednotlivých kroků se zobrazují na
vlastních polích formuláře daného kroku (viz např. vloženou chybovou hlášku o nesouladu telefonu ve
`WIRE0010`), nikoli na stepperu.

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| — | — | — | Neemituje žádné události. V žádném z pěti záznamů není důkaz, že by samotný stepper byl klikatelný/interaktivní; jde o čistě read-only chrome indikátoru postupu. |

## Přístupnost

- **ARIA role:** `Uncertain` — Předpokládá se role podobná ordered/list progress-indikátoru; nepotvrzeno.
- **Klávesová navigace:** `Uncertain` — pravděpodobně žádná, vzhledem k absenci důkazu o klikací interaktivitě.
- **Správa fokusu:** N/A — v důkazech není fokusovatelným prvkem.
- **Čtečka obrazovky:** `Uncertain` — zda existuje oznámení typu "krok 1 z 5, aktivní", nelze ze screenshotů potvrdit.

## Omezení použití

- Použít když: vykreslování jakéhokoli kroku průvodce žádostí (`UC0001`).
- Nepoužívat když: mimo flow průvodce — žádný jiný modul v důkazech nepoužívá tento přesný 5krokový
  vzor (modál daru, přihlášení a obrazovky účtu neobsahují ekvivalentní stepper).
- Kardinalita: přesně jeden na obrazovku kroku průvodce, horní pozice (pod globální hlavičkou).
- Umístění: pás v plné šířce přímo pod `COMP0002` Global Header, nad vlastním nadpisem kroku a
  odkazem zpět.

## Závislosti

- Ostatní COMPs: žádné (leaf komponenta).
- Datové entity: `EN0001` Application — `activeIndex`/`completedIndices` koncepčně sledují postup
  průvodce v rámci relace podání žádosti (`EN0003` ApplicationSession dle IA), ale žádná přímá vazba
  na úrovni pole není doložena; zaznamenáno jako koncepční, nikoli potvrzená, závislost.
- ACL: žádné doloženo.
- Externí knihovny: žádné doloženo.

## Kompozice

Leaf komponenta; žádná kompozice pod-COMP nebyla pozorována.

## Příklady

```
WizardStepper activeIndex={1} completedIndices={[]} />        // WIRE0007 (S008a, step 1 active)
WizardStepper activeIndex={2} completedIndices={[1]} />       // WIRE0008 (S008b, step 1 done)
WizardStepper activeIndex={3} completedIndices={[1,2]} />     // WIRE0009 (S008c)
WizardStepper activeIndex={4} completedIndices={[1,2,3]} />   // WIRE0010 (S008d)
WizardStepper activeIndex={5} completedIndices={[1,2,3,4]} /> // WIRE0011 (S008e, all prior checkmarked)
```

## Evidence

| Oblast tvrzení | Míra jistoty | Důkaz |
|---|---|---|
| Znovuužití na ≥2 obrazovkách | Confirmed | Identický vzor na 5 obrazovkách (S008a–S008e); `WIRE-synthesis-report.md` §6 "Multi-step wizard stepper" |
| Vizuální podstavy (upcoming/active/completed) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_57.png` |
| Neinteraktivita (žádné události) | Probable | v žádném záznamu nebyl pozorován styling naznačující klikatelnost; nepotvrzeno pomocí DOM/záznamu interakcí |
| Přístupnost | Uncertain | žádné DOM/záznamové důkazy nejsou k dispozici |

## Design-system alignment (target)

**Zatím žádný kanonický protějšek.** Kanonická knihovna komponent `@patron/ui`
(`_ar/spec-draft/DESIGN-component-index.md` §3 "Reconstructed COMPs with no canonical counterpart")
v současnosti pokrývá pouze plochy storefrontu a detailu příběhu vybudované pod epikem **E0002**.
Průvodce podáním žádosti — plocha, ke které tento stepper patří — nebyl navržen v cílovém design
systému: spadá pod epiky **E0003 (Obsah/CMS)**, **E0004 (Storefront web — donor journey)** a
**E0005 (Mobilní aplikace)**, které jsou všechny `Draft`/`Plánováno` (nikoli `Done`) dle
`_ar/evidence/design-system/design-canon.md` §0 tabulky epiků. Pro step-progress indikátor
neexistuje žádný atom ani blok `@patron/ui` a v tuto chvíli nelze tvrdit žádné mapování na
tokeny/komponenty.

Tato rekonstrukce současného stavu proto stojí samostatně (řízena výhradně tímto souborem), dokud
nebude plocha průvodce žádostí navržena a vybudována v `@patron/ui`; v tu chvíli by kanonický
protějšek `WizardStepper`/`Stepper` obdržel vlastní doc_id a tato sekce by byla aktualizována
mapováním na tokeny `var(--color-*)`/`var(--space-*)` a odkazem na kontrakt komponenty.
