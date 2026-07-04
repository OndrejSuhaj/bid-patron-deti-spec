---
doc_id: COMP0007
title: File Upload Dropzone
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0008
  - WIRE0011
  - WIRE0014
  - EN0001
---

# COMP0007 – Dropzone pro nahrávání souborů

## Účel

Plocha pro nahrávání souborů metodou drag-and-drop s náhradním odkazem "vyberte v počítači" (choose
on your computer) a živým čítačem počtu souborů `n/max`. Používá se všude, kde průvodce žádostí
(Application) nebo modul Account potřebuje, aby uživatel přiložil podpůrné dokumenty/obrázky. Shodný
textový vzor ("Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači.")
a tvar dropzone/čítače se opakuje na nejméně 3 zdokumentovaných WIRE obrazovkách.

## Vlastnosti / vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `label` | `string` | ano | — | Nadpis/instrukce nad dropzone; vlastněno vrstvou COPY per obrazovka (např. "Zde přiložte přihlášku na školní akci nebo informační leták"). |
| `maxCount` | `number` | ano | — | Maximální počet souborů; pozorované hodnoty: `3` (`WIRE0008` krok daru – příloha), `5`/`2`/`2` (tři dropzony na `WIRE0011`), `1` (`WIRE0014` profilová fotka). |
| `currentCount` | `number` | ne | `0` | Aktuální počet nahraných souborů, který určuje zobrazení `n/max`; všechny zachycené snímky ukazují `0/max` (pouze prázdný stav – vyplněná dropzone nebyla nikdy pozorována). |
| `exampleThumbnails` | `node[]` | ne | `none` | Statické ukázkové obrázky "PŘÍKLAD" zobrazené uvnitř dropzone, pozorováno pouze u tří dropzon na `WIRE0011`; na `WIRE0008`/`WIRE0014` nepřítomné. |

## Varianty

- **kardinalita:** jedna dropzone (`WIRE0008` — jedna dropzone, 0/3) | více dropzon
  (`WIRE0011` — tři samostatné instance dropzone poskládané pod sebou, kardinality 0/5, 0/2, 0/2)
- **ukázkové náhledy:** s ukázkovými náhledy (`WIRE0011`) | bez ukázkových náhledů (`WIRE0008`, `WIRE0014`)

## Stavy

### idle / prázdný
Obdélník s čárkovaným okrajem, vystředěná ikona (šipka nahoru směřující do symbolu přihrádky),
instrukční text + podtržený odkaz "vyberte v počítači", čítač `0/max` v pravém dolním rohu.
Confirmed — `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png` (0/3, bez
ukázkových náhledů) a dle `ui-observed-areas.md` §4/§11.

### hover (přetažení nad plochou)
`Uncertain — nelze ověřit ze statických podkladů; stav se zvýrazněním při aktivním přetahování je
standardní konvence dropzone, ale žádným snímkem nepotvrzen.`

### focused (zaměřeno)
`Uncertain — nelze ověřit ze statických podkladů.`

### disabled (zakázáno)
N/A — nebylo pozorováno žádné vykreslení v zakázaném stavu; předpokládá se, že komponenta je při
vykreslení vždy interaktivní.

### loading (nahrávání)
`Uncertain — žádný snímek nezobrazuje soubor uprostřed nahrávání (např. progress bar pro jednotlivý
soubor); Evidence Pending.`

### error (chyba)
`Uncertain — žádný snímek nezobrazuje stav odmítnutého souboru (nesprávný typ, příliš velký, překročen
počet); Evidence Pending. Toto je odlišné od samotné kardinality počtu, která je Confirmed jako
statické maximum, nikoli jako pozorovaná cesta vynucení/chyby.`

### filled (vyplněno) (další stav nad rámec šablony šesti stavů, relevantní pro životní cyklus této komponenty)
`Uncertain — žádný snímek nezobrazuje dropzone s již přiloženým souborem; všechny pozorované instance
jsou v počtu 0. Zda se přiložené soubory vykreslují jako seznam náhledů, seznam názvů souborů nebo
jinak, není potvrzeno.`

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onFilesAdded` | `File[]` | přetažení do plochy (drag-and-drop), nebo výběr souboru/souborů přes výběr "vyberte v počítači" | Vynucení `maxCount` (blokování vs. zkrácení vs. nahrazení) není podloženo. |
| `onFileRemoved` | reference na `File` | (Assumed — nepozorováno) | V žádném snímku při počtu 0 není viditelný prvek pro odstranění; nepotvrzeno, zda existuje po přiložení souborů. |

## Přístupnost

- **ARIA role:** `Uncertain` — Assumed nativní `<input type="file">` obalený stylovaným cílem pro
  přetažení; nepotvrzeno.
- **Navigace klávesnicí:** `Uncertain` — Assumed, že odkaz/tlačítko "vyberte v počítači" je dosažitelné
  klávesnicí a otevírá nativní výběr souborů; nepotvrzeno.
- **Správa fokusu:** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain` — oznámení aktuálního počtu `n/max` nelze ze screenshotů potvrdit.

## Omezení použití

- Použít když: krok průvodce žádostí nebo formulář účtu vyžaduje přiložení dokumentu/obrázku.
- Nepoužívat když: postačuje jednoduchý textový odkaz na soubor bez drag-and-drop afordance
  (taková jednodušší varianta nebyla pozorována, jde tedy o výhledové omezení, nikoli o podložené).
- Kardinalita: jedna až tři na obrazovku (pozorovaný rozsah: `WIRE0008`=1, `WIRE0011`=3, `WIRE0014`=1).
- Umístění: uvnitř formuláře, typicky za polem/poli, ke kterým se obsahově vztahuje (např. za textovým
  polem s popisem daru na `WIRE0008`).

## Závislosti

- Ostatní COMP: žádné jako subkomponenty.
- Datové entity: počet a účel příloh se koncepčně vztahují k entitě `EN0001` Application (Žádost)
  (jejím přílohám podpůrných dokumentů), ale na žádné citující obrazovce WIRE není potvrzena vazba na
  úrovni atributu — každá obrazovka WIRE označuje přesné mapování na název pole jako Uncertain
  (např. mapování pole pro přílohu rodného listu na `WIRE0011`).
- ACL: nic podloženo.
- Externí knihovny: nic podloženo (nepozorováno žádné brandování dodavatelského uploadovacího widgetu).

## Kompozice

Listová komponenta; bez kompozice subkomponent COMP. Opakuje se identicky (s odlišným `maxCount`/
ukázkovými náhledy) až třikrát na jedné obrazovce (`WIRE0011`).

## Příklady

```
FileUploadDropzone label="Zde přiložte přihlášku na školní akci nebo informační leták"
                   maxCount={3} currentCount={0} />
  // WIRE0008 — gift step, single dropzone, no example thumbnails

FileUploadDropzone label="Fotografie dítěte" maxCount={5} currentCount={0} exampleThumbnails={[...]} />
FileUploadDropzone label="Fotografie OP žadatele" maxCount={2} currentCount={0} exampleThumbnails={[...]} />
FileUploadDropzone label="Rodný list dítěte" maxCount={2} currentCount={0} exampleThumbnails={[...]} />
  // WIRE0011 — three stacked mandatory dropzones

FileUploadDropzone label="Změnit profilovou fotku" maxCount={1} currentCount={0} />
  // WIRE0014 — account profile photo
```

## Otevřené otázky

- Nebyl nikdy zaznamenán vyplněný/chybový/nahrávající stav — všechny pozorované instance jsou v počtu 0.
- Přesné mapování na atributy přílohy `EN0001` je Uncertain pro každou obrazovku samostatně (každá
  spotřebovávající obrazovka WIRE to zaznamenává nezávisle; zde neřešeno).
- Zda existují omezení typu/velikosti souboru a jak jsou komunikována, je zcela nepodloženo.

## Podklady

| Oblast tvrzení | Jistota | Podklad |
|---|---|---|
| Opakované použití na ≥2 obrazovkách | Confirmed | `WIRE0008`, `WIRE0011`, `WIRE0014` všechny zobrazují tento tvar dropzone; `WIRE-synthesis-report.md` §6 "File/image upload dropzone with count cardinality" |
| Prázdný/idle vizuální stav | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`; `ui-observed-areas.md` §4, §11 |
| Varianta s ukázkovými náhledy | Confirmed (pouze WIRE0011) | `_ar/spec-draft/WIRE/WIRE0011_ApplicationWizardStep5Attachments.md`, tabulka Components Used |
| Vyplněné/nahrávající/chybové stavy | Uncertain | žádný snímek nezobrazuje žádný z těchto stavů |
| Přístupnost | Uncertain | nejsou dostupné žádné podklady z DOM/nahrávek |
