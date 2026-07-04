---
doc_id: COMP0008
title: Story Card
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0001
  - WIRE0019
  - WIRE0020
  - EN0004
  - EN0021
  - UC0023
---

# COMP0008 – Karta příběhu

## Účel

Karta shrnující jeden Campaign/Story (příběh) (`EN0004`): fotku dítěte, stuhu s odpočítáváním do
uzávěrky, název, cílovou částku vs. vybranou částku a primární CTA. Jde o základní opakující se
jednotku katalogu, přímo pozorovanou s konzistentním základním tvarem napříč mřížkou katalogu na
homepage (`WIRE0001`, ×6 na záložku) a mřížkou dokončených příběhů na obrazovce "Výsledky"
(`WIRE0019`, ×6), s další složenou variantou zmíněnou pouze analogicky v mockupu dashboardu účtu se
statusem Evidence-Pending/Hypothesis (`WIRE0020`). Opakované použití na ≥2 obrazovkách s nezávislým
screenshotovým důkazem je Confirmed pro základní kartu; varianty pro dokončený stav a dashboard jsou
zaznamenány jako odlišné, méně jisté sesterské varianty, a nejsou bez dalšího sloučeny do jediného
tvrzení "stejná komponenta".

## Vstupy / Props

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `photo` | `image` | ano | — | Fotka dítěte/příběhu. |
| `title` | `string` | ano | — | Název příběhu, např. "Balík školních potřeb pro Miriam"; obsah je vlastněn vrstvou COPY pro danou instanci. |
| `targetAmount` | `number (Kč)` | ano | — | "Cílová částka" — cílová částka pro financování; navázáno na `EN0004`. |
| `collectedAmount` | `number (Kč)` | podmíněné | — | "Vybráno" / "Chybí {amount} Kč" — dosud vybraná částka; navázáno na `EN0004` (odvozené pole, viz WIRE0001/WIRE0002 Data Bindings). |
| `deadlineBadge` | `string` | ne | — | Text stuhy s odpočítáváním; pozorované hodnoty se liší: "ZBÝVÁ MĚSÍC" / "ZBÝVÁ DEN" / "ZBÝVÁ 4 DNY" / "ZBÝVÁ 16 DNÍ" / "ZBÝVÁ 24 DNÍ". |
| `isCollectionAccount` | `boolean` | ne | `false` | Vykresluje variantu "SBÍRKOVÝ ÚČET" pro skupinový/rodičovský Campaign, pozorovanou jednou na `WIRE0001` ("Necháte výběr dítěte, kterému chcete pomoct na nás?"), navázanou na skupinový/rodičovský mechanismus `EN0004` (Partial dle `UC0023` Traceability). |
| `ctaLabel` | `string` | ano | — | Text primárního CTA, např. "Podpořím Miriam", "Nechám to na vás", "Detail příběhu". |
| `completedBadges` | `string[]` | ne | `[]` | Odznaky pro dokončený stav pozorované pouze u varianty na `WIRE0019`: stavová stuha "SPLNĚNO" + pilulka "ZPĚTNÁ VAZBA" + ikonový chip s rukou. Na základní kartě `WIRE0001` nejsou přítomny. |

## Varianty

- **lifecycle:** active (základní karta katalogu, `WIRE0001` — stuha s odpočítáváním + progres +
  CTA "Podpořím") | completed (`WIRE0019` — přidává stuhu "SPLNĚNO", pilulku "ZPĚTNÁ VAZBA", ikonu
  zaškrtnutí u vybrané celkové částky, CTA "Detail příběhu" místo CTA k darování). Varianta completed
  je odlišná vizuální rodina potvrzená přímým porovnáním screenshotů, nikoli předpokládaná jako
  totožná s variantou active — viz `WIRE0019` poznámka Components Used: "same card pattern family...
  but with the completed-state variant... not confirmed to be the identical component."
- **story-type:** individuální dítě (výchozí) | sbírkový účet/skupina (`isCollectionAccount=true`,
  skupinový/rodičovský mechanismus `EN0004`, důkaz Partial)

## Stavy

### idle
Statické vykreslení karty popsané v části Props. Confirmed — varianta active:
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (mřížka katalogu);
varianta completed: `_ar/prtsc/screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png`.

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — nebylo pozorováno žádné vykreslení disabled stavu. (Nezaměňovat se stavem disabled u nulového
počtu aktivních regionů Campaign na komponentě mapy regionů jinde na `WIRE0001`, což je jiný prvek.)

### loading
`Uncertain — no skeleton/loading-placeholder state was captured for the catalogue grid; Evidence
Pending per WIRE0001 States.`

### error
N/A — nebyl pozorován žádný chybový stav na úrovni karty; chybové/prázdné stavy na úrovni mřížky jsou
zaznamenány na úrovni WIRE (`WIRE0001` States: "empty/loading/error: Evidence Pending"), a nejsou
vlastněny touto komponentou.

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onCtaClick` | identifikátor příběhu | klik na primární CTA tlačítko | Varianta active → vstup do darování (`UC0005`/`UC0011`, dle `WIRE0002`); varianta completed → čtecí zobrazení detailu příběhu (`UC0011`, dle `WIRE0019`). |
| `onCardClick` | identifikátor příběhu | `Uncertain` — zda je samotné tělo karty (fotka/název) samostatně klikatelné, odděleně od CTA, není ze statických důkazů potvrzeno. | |

## Přístupnost

- **ARIA role:** `Uncertain` — Předpokládá se nativní sémantika `<article>`/`<li>` v rámci mřížky/seznamu; nepotvrzeno.
- **Klávesová navigace:** `Uncertain`.
- **Správa fokusu:** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain` — zda jsou hodnoty progresu ohlašovány s jednotkami/kontextem nelze ze screenshotů potvrdit.

## Omezení použití

- Použít, když: se vykresluje shrnutí Campaign/Story uvnitř procházitelné mřížky (katalog, seznam
  dokončených příběhů).
- Nepoužívat, když: se vykresluje celá stránka detailu příběhu (→ vlastní dedikovaný layout
  `WIRE0002`, nikoli tato karta).
- Kardinalita: opakovaně N-krát v mřížce (pozorováno: 6 na záložku na `WIRE0001`, 6 na `WIRE0019`).
- Umístění: pouze uvnitř zóny mřížky/seznamu; nepoužívá se samostatně.

## Závislosti

- Ostatní COMP: žádné potvrzené jako složené podelementy (hodnoty progresu a CTA tlačítko jsou v
  důkazech vykresleny inline uvnitř vlastního layoutu karty, nejsou potvrzeny jako samostatně
  znovupoužitelná tlačítka totožná s `COMP0001` — CTA v katalogu je menší/rozsahem omezené na kartu a
  není tvrzeno, že jde o stejnou komponentu).
- Datové entity: `EN0004` Campaign (cílová/vybraná částka, uzávěrka, skupinový/rodičovský
  mechanismus); `EN0021` Feedback (vazba odznaku "ZPĚTNÁ VAZBA" u varianty completed je Uncertain dle
  `WIRE0019`, nepotvrzeno jako přímé spojení s `EN0021`).
- ACL: žádné doloženo.
- Externí knihovny: žádné doloženo.

## Kompozice

```
StoryCard (active variant)
  ├─ photo
  ├─ deadline countdown ribbon
  ├─ title
  ├─ progress block (target/collected figures — Uncertain whether this is COMP0008-internal only,
  │    or shares a component with the story-detail page's own progress block on WIRE0002; not
  │    confirmed identical, left as an open question rather than a second COMP)
  └─ CTA (card-scoped; not confirmed identical to COMP0001)

StoryCard (completed variant, WIRE0019)
  ├─ photo
  ├─ "SPLNĚNO" status ribbon + "ZPĚTNÁ VAZBA" pill + hand-icon chip
  ├─ title
  ├─ "Vybráno celkem" + amount + checkmark icon
  └─ "Detail příběhu" CTA
```

## Otevřené otázky

- Zda jsou varianty active a completed skutečně stejnou podkladovou komponentou (parametrizovanou
  stavem lifecycle) nebo dvěma samostatně vytvořenými šablonami karet — `WIRE0019` sám tuto
  skutečnost označuje jako "not confirmed to be the identical component"; zde je otázka přenesena
  dál, nikoli vyřešena.
- Zda progress block na stránce detailu příběhu (`WIRE0002`) sdílí komponentu s hodnotami progresu
  této karty, nebo je implementován nezávisle.
- `WIRE0020` (mockup dashboardu účtu, Hypothesis/nepotvrzeno jako implementováno) ukazuje další
  sesterskou kartu "contribution banner overlay" ("Přispěli jste {amount}") — explicitně NEsloučeno
  do tohoto COMP vzhledem k tomu, že samotná obrazovka má status nepotvrzeno-jako-implementováno;
  ponecháno inline ve `WIRE0020` dle pravidla ≥2 obrazovek, které se vztahuje pouze na potvrzeně
  implementované obrazovky.

## Evidence

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Opakované použití na ≥2 potvrzeně implementovaných obrazovkách | Confirmed | `WIRE0001` (×6 na záložku) a `WIRE0019` (×6); `WIRE-synthesis-report.md` §6 "Progress/funding-amount bar" a poznámka o vzoru karty ve `WIRE0019` |
| Vizuální stav varianty active | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` |
| Vizuální stav varianty completed | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png` |
| Totožnost variant active a completed jako "stejné" komponenty | Uncertain | zaznamenáno verbatim v `_ar/spec-draft/WIRE/WIRE0019_HowItWorksResults.md` Components Used |
| Sesterská karta z mockupu dashboardu (WIRE0020) | Uncertain/Hypothesis | samotná obrazovka nepotvrzena jako implementovaná; vyloučena z potvrzeného rozsahu tohoto COMP |
| Přístupnost | Uncertain | není dostupný žádný DOM/nahrávkový důkaz |
