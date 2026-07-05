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

# COMP0007 – File Upload Dropzone

## Účel

Plocha pro nahrávání souborů přetažením (drag-and-drop) s náhradním odkazem "vyberte v počítači"
a živým počítadlem souborů ve tvaru `n/max`. Používá se všude, kde formulářový průvodce žádostí
(Application wizard) nebo modul Account potřebuje, aby uživatel přiložil podpůrné dokumenty/obrázky.
Identický vzor textu ("Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v
počítači.") a tvar dropzone/počítadla se opakuje na nejméně 3 zpracovaných WIRE obrazovkách.

## Props / Vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `label` | `string` | ano | — | Nadpis/instrukce nad dropzone; COPY-owned pro každou obrazovku (např. "Zde přiložte přihlášku na školní akci nebo informační leták"). |
| `maxCount` | `number` | ano | — | Maximální počet souborů; pozorované hodnoty: `3` (`WIRE0008` příloha v kroku daru), `5`/`2`/`2` (tři dropzony na `WIRE0011`), `1` (profilová fotka na `WIRE0014`). |
| `currentCount` | `number` | ne | `0` | Aktuální počet přiložených souborů určující zobrazení `n/max`; všechny zachycené snímky ukazují `0/max` (pouze prázdný stav — vyplněná dropzone nebyla nikdy pozorována). |
| `exampleThumbnails` | `node[]` | ne | `none` | Statické ukázkové obrázky "PŘÍKLAD" zobrazené uvnitř dropzone, pozorováno pouze u tří dropzon pro přílohy na `WIRE0011`; na `WIRE0008`/`WIRE0014` chybí. |

## Varianty

- **kardinalita:** jednotlivá dropzone (`WIRE0008` — jedna dropzone, 0/3) | vícenásobné dropzony
  (`WIRE0011` — tři samostatné instance dropzone pod sebou, kardinality 0/5, 0/2, 0/2)
- **ukázkové náhledy (example-thumbnails):** s (`WIRE0011`) | bez (`WIRE0008`, `WIRE0014`)

## Stavy

### idle / prázdný
Obdélník s čárkovaným okrajem, centrovaná ikona (šipka nahoru do symbolu tácu), instrukční text +
podtržený odkaz "vyberte v počítači", počítadlo `0/max` v pravém dolním rohu. Confirmed —
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png` (0/3, bez ukázkových
náhledů) a dle `ui-observed-areas.md` §4/§11.

### hover (přetažení nad plochou)
`Uncertain — nelze ověřit ze statických podkladů; zvýrazněný stav při aktivním přetažení je běžná
konvence dropzone, není však potvrzen žádným snímkem.`

### focused
`Uncertain — nelze ověřit ze statických podkladů.`

### disabled
N/A — nebylo pozorováno vykreslení v neaktivním stavu; komponenta je předpokládána jako vždy
interaktivní, pokud je vykreslena.

### loading
`Uncertain — žádný snímek nezobrazuje soubor uprostřed nahrávání (např. progress bar u souboru); Evidence Pending.`

### error
`Uncertain — žádný snímek nezobrazuje stav odmítnutého souboru (nesprávný typ, příliš velký,
překročený počet); Evidence Pending. Toto je odlišné od samotné kardinality počtu, která je Confirmed
jako statické maximum, nikoli pozorovaná cesta vynucení/chyby.`

### filled (doplňkový stav nad rámec šestistavové šablony, relevantní pro životní cyklus této komponenty)
`Uncertain — žádný snímek nezobrazuje dropzone s již přiloženým souborem; všechny pozorované instance
jsou na počtu 0. Zda se přiložené soubory vykreslují jako seznam náhledů, seznam názvů souborů nebo
jinak, není potvrzeno.`

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onFilesAdded` | `File[]` | přetažení do plochy nebo výběr souboru(ů) přes dialog "vyberte v počítači" | Vynucení `maxCount` (blokování vs. zkrácení vs. nahrazení) není podloženo důkazy. |
| `onFileRemoved` | reference na `File` | (Assumed — nepozorováno) | Žádná možnost odstranění nebyla viditelná v žádném snímku při počtu 0; není potvrzeno, zda existuje po přiložení souborů. |

## Přístupnost

- **ARIA role:** `Uncertain` — Předpokládá se nativní `<input type="file">` obalený stylovaným drop targetem; nepotvrzeno.
- **Klávesová navigace:** `Uncertain` — Předpokládá se, že odkaz/tlačítko "vyberte v počítači" je dosažitelné klávesnicí a otevírá nativní výběr souborů; nepotvrzeno.
- **Správa fokusu:** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain` — oznámení aktuálního počtu `n/max` nelze ověřit ze screenshotů.

## Omezení použití

- Použít když: krok formulářového průvodce žádostí nebo formulář v účtu vyžaduje přiložení dokumentu/obrázku.
- Nepoužívat když: postačuje jednoduchý textový/souborový odkaz bez drag-and-drop afordance
  (žádná taková jednodušší varianta nebyla pozorována, jde tedy o do budoucna orientované omezení,
  nikoli podložené důkazy).
- Kardinalita: jedna až tři na obrazovku (pozorovaný rozsah: `WIRE0008`=1, `WIRE0011`=3, `WIRE0014`=1).
- Umístění: uvnitř formuláře, typicky následuje po poli/polích, ke kterým se obsahově vztahuje
  (např. po textovém poli s popisem daru na `WIRE0008`).

## Závislosti

- Ostatní COMP: žádné jako subkomponenty.
- Datové entity: počet a účel přílohy koncepčně souvisí s `EN0001` Žádost (její podpůrné dokumentové
  přílohy), avšak žádná vazba na úrovni atributu není potvrzena na žádném citujícím WIRE —
  každý WIRE označuje přesné mapování na název pole jako Uncertain (např. mapování pole pro
  přílohu rodného listu na `WIRE0011`).
- ACL: nic podloženo důkazy.
- Externí knihovny: nic podloženo důkazy (nebylo pozorováno žádné brandování vendorského upload widgetu).

## Kompozice

Listová komponenta; žádná subkompozice COMP. Opakuje se v identické podobě (s různým `maxCount`/
ukázkovými náhledy) až třikrát na jedné obrazovce (`WIRE0011`).

## Příklady

```
FileUploadDropzone label="Zde přiložte přihlášku na školní akci nebo informační leták"
                   maxCount={3} currentCount={0} />
  // WIRE0008 — krok daru, jednotlivá dropzone, bez ukázkových náhledů

FileUploadDropzone label="Fotografie dítěte" maxCount={5} currentCount={0} exampleThumbnails={[...]} />
FileUploadDropzone label="Fotografie OP žadatele" maxCount={2} currentCount={0} exampleThumbnails={[...]} />
FileUploadDropzone label="Rodný list dítěte" maxCount={2} currentCount={0} exampleThumbnails={[...]} />
  // WIRE0011 — tři povinné dropzony pod sebou

FileUploadDropzone label="Změnit profilovou fotku" maxCount={1} currentCount={0} />
  // WIRE0014 — profilová fotka v účtu
```

## Otevřené otázky

- Nikdy nebyl zachycen vyplněný/chybový/nahrávající stav — všechny pozorované instance jsou na počtu 0.
- Přesné mapování na názvy polí u atributů přílohy `EN0001` je Uncertain pro každou obrazovku (každý
  odkazující WIRE to zaznamenává samostatně; zde není vyřešeno).
- Zda existují omezení typu/velikosti souboru a jak jsou komunikována, není vůbec podloženo důkazy.

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Znovupoužití na ≥2 obrazovkách | Confirmed | `WIRE0008`, `WIRE0011`, `WIRE0014` všechny ukazují tento tvar dropzone; `WIRE-synthesis-report.md` §6 "File/image upload dropzone with count cardinality" |
| Prázdný/idle vizuální stav | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`; `ui-observed-areas.md` §4, §11 |
| Varianta ukázkových náhledů | Confirmed (pouze WIRE0011) | `_ar/spec-draft/WIRE/WIRE0011_ApplicationWizardStep5Attachments.md` tabulka Components Used |
| Vyplněný/nahrávající/chybový stav | Uncertain | žádný snímek nezobrazuje nic z toho |
| Přístupnost | Uncertain | nejsou k dispozici žádné DOM/nahrávkové podklady |

## Design-system alignment (target)

Zatím žádný kanonický protějšek v `@patron/ui` / `@patron/tokens`. Plocha pro přílohy žádosti/nahrávání
souborů nebyla v cílovém design systému v rámci tohoto průchodu navržena — `_ar/evidence/design-system/components.md`
a `_ar/spec-draft/DESIGN-component-index.md` neobsahují žádný primitiv typu dropzone, file-upload ani
attachment-list. Tento COMP proto nemá žádné cílové mapování k zaznamenání; výše uvedená rekonstrukce
současného stavu zůstává v platnosti, dokud nebude zaveden kanonický komponent design systému. Vlajka
pro tým design systému jako gap: rebuild bude potřebovat primitiv file-upload/dropzone s podporou
kardinality počtu a ukázkových náhledů pro pokrytí pozorovaných použití na `WIRE0008`/`WIRE0011`/`WIRE0014`.
