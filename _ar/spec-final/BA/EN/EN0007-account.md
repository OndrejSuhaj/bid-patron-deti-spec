---
doc_id: EN0007
title: Account
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0004 (Campaign)
  - EN0008 (User)
  - BR-CampaignRecommendationDormant
---

# EN0007 — Účet

## Účel

Účet je záznam patrona/fundraisera vázaný na vlastníka, rozlišený podle `type` (patron /
fundraiser). Je zamýšlen jako nositel natrénovaného doporučovacího modelu a seřazeného seznamu
predikovaných Kampaní (EN0004) pro svého vlastnícího Uživatele (EN0008), jako součást kapacity
doporučování kampaní. Tato kapacita je v současném stavu potvrzeně neaktivní — viz
`BR-CampaignRecommendationDormant`. Vzhledem k tomu, že doporučovací kapacita je neaktivní, funguje
Účet dnes jako tenký záznam vázaný na vlastníka s minimálním vlastním chováním.

Účet se liší od bankovního účtu i od samotné identity Uživatele/Party (viz
`DOMAIN-ubiquitous-language.md` §Account, kde je popsán třístranný terminologický konflikt).

---

## Životní cyklus

- **Existující** — jediný pozorovaný stav. Účet nemá vlastní výčet stavů/workflow; buď existuje
  (patří Uživateli), nebo neexistuje.

Hypothesis — Not evidenced in current sources: zda je Účet vytvářen pro každého Uživatele, pouze pro
určité role, nebo v současném provozu prakticky nikdy. Žádný potvrzený use case nevyužívá vytvoření
Účtu (viz Přechody stavů a Otevřené otázky).

---

## Přechody stavů

V současném stavu neexistuje žádný potvrzený spouštěč vytvoření nebo aktualizace.

- UC0014 (Autentizace a správa přístupu) odkazuje na Účet pro úplnost jako na záznam vázaný na
  vlastníka, spojený s Uživatelem, ale sám jej nevytváří, neaktualizuje ani jinak nevyužívá.
- UC0021 (Doporučování kampaní) popisuje jediný tok, který by do Účtu zapisoval (uložení
  natrénovaného modelu / seřazených doporučení), ale UC0021 je od začátku do konce neaktivní — viz
  `BR-CampaignRecommendationDormant`. Z tohoto toku nevyplývá žádný přechod v současném stavu.

Hypothesis — Not evidenced in current sources: skutečný spouštěč vytvoření záznamu Účtu.

---

## Atributy

### Atributy spravované systémem

- status (boolean; povinný; příznak publikování; výchozí hodnota true)

### Atributy zadávané uživatelem

- type (výčet hodnot; nepovinný; `patron` / `fundraiser`)
- name / last_name (text, max. 50 znaků; nepovinné; použito jako zobrazovaný název entity; výchozí
  hodnota prázdná)

---

## Invarianty

- Vazba mezi Účtem a doporučováním Kampaní není aktivním invariantem v současném stavu — viz
  `BR-CampaignRecommendationDormant`.

---

## Vztahy

- EN0008 (Uživatel) — vlastnící Party; Účet patří jednomu Uživateli.
- EN0004 (Kampaň) — kandidátní cíl doporučení; vazba je součástí neaktivní doporučovací kapacity
  (viz `BR-CampaignRecommendationDormant`) a neodráží aktivní vztah v současném stavu.

---

## Otevřené otázky

- Je záznam Účtu v současném provozu skutečně někde vytvářen, nebo je zcela neaktivní společně s
  doporučovací kapacitou, pro kterou byl vybudován?
- Jaký je zamýšlený vztah mezi daty doporučovacího modelu asociovanými s Účtem a odpovídajícími daty
  asociovanými s Uživatelem (EN0008) — jde o dvě reprezentace stejného konceptu, a pokud ano, která
  je autoritativní?
- Za jakých podmínek, pokud vůbec, byla doporučovací kapacita v produkci aktivní?
