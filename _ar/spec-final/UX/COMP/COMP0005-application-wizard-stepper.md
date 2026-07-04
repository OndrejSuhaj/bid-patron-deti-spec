---
doc_id: COMP0005
title: Application Wizard Stepper
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - UC0001
  - EN0001
---

# COMP0005 – Stepper průvodce žádostí

## Účel

5krokový číslovaný indikátor průběhu ("Příběh / Dar / O Vás / Patron / Přílohy") zobrazený v horní
části každého kroku průvodce příjmem žádosti (`UC0001`, nad `EN0001` Žádost). Jde o nejsilnějšího
kandidáta na znovupoužití v rámci sady WIRE: identické 5krokové chrome, lišící se pouze stavy
aktivní/dokončený/nadcházející krok, je přímo pozorováno na všech pěti dokumentech WIRE pro kroky
průvodce (`WIRE0007`–`WIRE0011`, obrazovky S008a–S008e).

## Vstupní vlastnosti (Props / Inputs)

| Název | Typ | Povinný | Výchozí hodnota | Popis |
|---|---|---|---|---|
| `steps` | `string[]` | ne | `["Příběh", "Dar", "O Vás", "Patron", "Přílohy"]` | Fixní sada 5 popisků pozorovaná identicky na všech pěti obrazovkách; konfigurovatelnost nepotvrzena. |
| `activeIndex` | `number (1-5)` | ano | — | Který krok je aktuálně aktivní; určuje zvýraznění příslušného kroku. |
| `completedIndices` | `number[]` | ne | `[]` | Kroky vykreslené se zaškrtávací značkou místo čísla (kroky předcházející `activeIndex`). |

## Varianty

- **počet kroků:** 5 (jediná pozorovaná kardinalita; žádný důkaz o proměnném počtu kroků).

## Stavy

### idle
Horizontální řada 5 číslovaných kruhů propojených čárou; každý kruh vykresluje jeden ze tří
vizuálních podstavů v závislosti na své pozici vůči `activeIndex` (viz níže). Potvrzeno na všech pěti
citovaných screenshotech, např.
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` (krok 1 aktivní,
všechny ostatní nadcházející) a
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png` (krok 1
dokončený/se zaškrtnutím, krok 2 aktivní).

Podstavy jednotlivých kruhů (všechny Confirmed přímým vizuálním srovnáním napříč pěti obrazovkami):
- **upcoming (nadcházející)** — kruh se šedým obrysem, šedé číslo kroku, šedý popisek.
- **active (aktivní)** — vyplněný červený kruh s bílým číslem kroku, tučný červený popisek.
- **completed (dokončený)** — vyplněný červený kruh s bílou zaškrtávací značkou (bez čísla), červený popisek.

### hover
`Uncertain — nelze pozorovat ze statických důkazů; kroky nepůsobí jako klikatelné (žádný důkaz
zpětného přeskoku kliknutím; navigace zpět probíhá přes samostatný odkaz "Krok zpět", nikoli přes
samotný stepper).`

### focused
`Uncertain — nelze pozorovat ze statických důkazů.`

### disabled
N/A — žádné vykreslení stavu disabled nebylo pozorováno; nadcházející kroky jsou vizuálně
potlačeny (šedé), ale jde o standardní idle podstav "ještě nedosaženo", nikoli o disabled interaktivní
stav.

### loading
N/A — stepper samotný nemá žádné asynchronní chování; odráží pozici v průvodci synchronně s
navigací.

### error
N/A — žádné vykreslení chyby není vlastnictvím stepperu; chyby validace jednotlivých kroků se
zobrazují ve vlastních formulářových polích daného kroku (viz např. inline chyba nesouladu
telefonního čísla ve `WIRE0010`), nikoli na stepperu.

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| — | — | — | Nejsou vyvolávány žádné události. Ve všech pěti záznamech nebyl nalezen žádný důkaz, že by samotný stepper byl klikatelný/interaktivní; jde o read-only chrome zobrazující průběh. |

## Přístupnost

- **ARIA role:** `Uncertain` — Předpokládá se role uspořádaného/seznamového indikátoru průběhu; nepotvrzeno.
- **Klávesová navigace:** `Uncertain` — pravděpodobně žádná, vzhledem k absenci důkazů o klikací interaktivitě.
- **Správa fokusu:** N/A — v důkazech není fokusovatelným prvkem.
- **Čtečka obrazovky:** `Uncertain` — zda existuje ohlášení typu "krok 1 z 5, aktivní" nelze ze screenshotů potvrdit.

## Omezení použití

- Použít když: se vykresluje jakýkoli krok průvodce žádostí (`UC0001`).
- Nepoužívat když: mimo tok průvodce — žádný jiný modul v důkazech nepoužívá tento přesný 5krokový
  vzor (modál daru, přihlášení a obrazovky účtu nemají obdobný stepper).
- Kardinalita: přesně jeden na obrazovku kroku průvodce, na horní pozici (pod globálním headerem).
- Umístění: pásmo v plné šířce přímo pod `COMP0002` Globální header, nad vlastním nadpisem kroku
  a odkazem zpět.

## Závislosti

- Ostatní COMP: žádné (koncová komponenta - leaf component).
- Datové entity: `EN0001` Žádost — `activeIndex`/`completedIndices` konceptuálně sledují průběh
  průvodce v rámci relace příjmu žádosti (`EN0003` ApplicationSession dle IA), avšak žádná přímá
  vazba na úrovni pole není doložena; zaznamenáno jako konceptuální, nikoli potvrzená, závislost.
- ACL: žádné doloženo.
- Externí knihovny: žádné doloženo.

## Kompozice

Koncová komponenta (leaf component); žádná kompozice s dílčími COMP nebyla pozorována.

## Příklady

```
WizardStepper activeIndex={1} completedIndices={[]} />        // WIRE0007 (S008a, step 1 active)
WizardStepper activeIndex={2} completedIndices={[1]} />       // WIRE0008 (S008b, step 1 done)
WizardStepper activeIndex={3} completedIndices={[1,2]} />     // WIRE0009 (S008c)
WizardStepper activeIndex={4} completedIndices={[1,2,3]} />   // WIRE0010 (S008d)
WizardStepper activeIndex={5} completedIndices={[1,2,3,4]} /> // WIRE0011 (S008e, all prior checkmarked)
```

## Důkazy

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Znovupoužití na ≥2 obrazovkách | Confirmed | Identický vzor na 5 obrazovkách (S008a–S008e); `WIRE-synthesis-report.md` §6 "Multi-step wizard stepper" |
| Vizuální podstavy (nadcházející/aktivní/dokončený) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_57.png` |
| Neinteraktivita (žádné události) | Probable | v žádném záznamu nebylo pozorováno stylování naznačující klikatelnost; nepotvrzeno přes DOM/záznam interakce |
| Přístupnost | Uncertain | žádný důkaz z DOM/záznamu k dispozici |
