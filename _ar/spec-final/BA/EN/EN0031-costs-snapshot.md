---
doc_id: EN0031
title: CostsSnapshot
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0008
  - BR-ReportingAndDataAccess
  - UC0017
---

# EN0031 — CostsSnapshot

## Účel

CostsSnapshot představuje měsíční hodnoty nákladů a cílů zadávané pro účely reportingu:
počty publikovaných kampaní a jejich náklady, peněžní náklady a cílovou hodnotu nákladů, cíle
kampaní a darů a cílovou hodnotu počtu žáků a částky pro "obědy školákům". Jde o reportingovou
projekci konzumovanou reportingovými dashboardy (viz `UC0017`, dílčí tok UC0017.3), nikoli o
transakční případ, subjekt (party) nebo peněžní záznam.

## Životní cyklus

Existující — jediný, neworkflow stav. CostsSnapshot nemá žádný doménový životní cyklus: je pouze
vytvořen (zadán) a volitelně editován; neprochází žádnými business stavy a nemá pozorovaný
koncový ani zamítnutý stav.

*Confidence: Low — nebyl vytěžen žádný zapisovací tok (writer flow); viz Open Questions.*

## Přechody stavů

(žádné) — CostsSnapshot nemá stavový automat ani pozorované přechody řízené stavem.

- Vytvoření / editace jako reportingový vstup: konzumováno pouze pro čtení reportingovou
  dashboardovou funkcí (capability), trigger: UC0017 (dílčí tok UC0017.3). Důkaz pro tuto cestu
  konzumace je Partial — viz `BR-ReportingAndDataAccess`.

## Atributy

### Systémem spravované atributy

- Author (reference na EN0008 – User; povinné) — uživatel zaznamenaný jako autor záznamu.
- Created timestamp (datetime; povinné)
- Changed timestamp (datetime; povinné)

### Uživatelem zadávané atributy

- Year (integer, 4místné; povinné)
- Month (integer, 1–12; povinné) — *Conflict: pozorovaná výchozí hodnota tohoto atributu je
  řetězcový literál, nikoli integer; zda je month v praxi zpracováván jako číselná nebo textová
  hodnota, je nevyjasněné. Viz Open Questions.*
- Published campaign count (integer; volitelné)
- Published campaign cost (integer; volitelné)
- Cost (integer; volitelné)
- Cost target (integer; volitelné)
- Campaigns target (integer; volitelné)
- Campaigns target value (integer; volitelné)
- Donations target value (integer; volitelné)
- School-lunches ("obědy školákům") student target (integer; volitelné)
- School-lunches ("obědy školákům") amount target (integer; volitelné)
- Published flag (boolean; volitelné) — označuje, zda je záznam publikován pro reportingové
  zobrazení; žádné jiné hodnoty stavu pro tento atribut neexistují.

## Invarianty

- Reportingové hodnoty držené entitou CostsSnapshot jsou z pohledu case, party, money, campaign a
  contract záznamů pouze pro čtení — viz `BR-ReportingAndDataAccess`.
- Vytvoření/editace CostsSnapshot není podmíněno case-style workflow; jediným zaznamenaným stavem
  je příznak Published flag (žádné pravidlo neřídí přechody mezi published/unpublished nad rámec
  tohoto příznaku samotného).

## Vztahy

- EN0008 – User (autor záznamu)

## Otevřené otázky

1. Month je deklarován s povolenými integer hodnotami (1–12), ale pozorovaná výchozí hodnota je
   řetězcový literál — je month v praxi ukládán/porovnáván jako integer, nebo jako řetězec?
   Nevyjasněno.
2. Další, nedeklarované pole podobné dimenzi je referencováno konfigurací zobrazení, ale nemá
   žádný podkladový atribut (`Hypothesis` — případně jde o mrtvý artefakt, nebo o chybějící
   dimenzi kategorie nákladů). Nevyjasněno.
3. Zda jsou záznamy zadávány ručně pracovníky finančního oddělení, nebo jsou generovány
   automatizovanou úlohou, je nevyjasněné — pro tuto entitu nebyl vytěžen žádný zapisovací tok.
