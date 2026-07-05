---
doc_id: ES0014
title: Elasticsearch
layer: ES
spec_type: external-system
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0022
  - FN0023
  - UC0016
  - UC0018
  - UC0020
---

# ES0014 – Elasticsearch

## Účel

Elasticsearch je integrován jako vyhledávací/indexovací engine platformy a v současné architektuře
plní tři odlišné účely: fulltextový vyhledávací index pro doménové entity, samostatné úložiště
audit-logu požadavků/odpovědí a samostatný Elastic Cloud index organizací. Jde o jeden z výstupních
cílových systémů uvedených v Integration Landscape (`ARCH0001` §5, řádek 14).

---

## Přehled systému

Elasticsearch je vyhledávací/indexovací engine třetí strany. Patronus jej využívá ve třech aktuálních,
odlišných rolích, nikoli v jedné:

- jako **fulltextový vyhledávací index** nad doménovými entitami, díky němuž mohou být vyhledávací
  dotazy obsluhovány z indexu, a ne z primárního datového úložiště;
- jako **úložiště audit-logu požadavků/odpovědí**, které zaznamenává log požadavků platformy a jejich
  odpovědí pro pozdější kontrolu;
- jako **hostovaný Elastic Cloud index organizací**, samostatné nasazení uchovávající identifikační
  záznamy organizací pro vyhledávání.

Tato tři použití jsou zde zdokumentována jako jeden ES, protože sdílejí stejný externí dodavatelský
systém, i když představují tři oddělené integrační hranice a aktuální způsoby využití (`ARCH0001` §5
řádek 14, poznámka; integrations.md §4).

---

## Integrační model

Ve všech třech rolích jde o odchozí (zápis/indexace) směr — platforma odesílá data do Elasticsearch;
Elasticsearch není popsán jako systém, který by se dotazoval zpět do platformy:

- **Vyhledávací index:** uložení entity zařadí dokumenty do fronty k indexaci; worker/cron frontu
  vyprazdňuje a hromadně je indexuje do vyhledávacího indexu. Tato cesta je skutečně asynchronní
  (`UC0018`; `ARCH0002` (b) fronta vyhledávacího indexu).
- **Úložiště audit-logu:** záznam auditu požadavku/odpovědi se zapisuje pro každý požadavek na cestě
  audit-listeneru (`UC0020`; `ARCH0002` (c) audit listener). Tato role pouze zapisuje — neobsluhuje
  dotazy zpět do platformy.
- **Index organizací (Elastic Cloud):** denní naplánovaná úloha znovu odesílá všechny organizace do
  Elastic Cloud indexu organizací formou úplného přepisu, bez inkrementálního kurzoru (`UC0016`;
  `UC0018`; `ARCH0002` (b) denní index organizací).

**Úroveň evidence:** hranice role vyhledávacího indexu je potvrzena na úrovni architektury, avšak
samotný tok synchronizace indexu je doložen jen slabě (`Partial`, HS16). Role audit-logu a indexu
organizací jsou `Confirmed` (`ARCH0001` §5 řádek 14).

---

## Výměna dat

- **Odchozí (vyhledávací index):** indexovatelné reprezentace doménových entit odesílané k fulltextové
  indexaci (pouze koncepčně; příslušné entity viz `EN0001`, `EN0004`, `EN0009`, `EN0018` — zde
  neopakováno).
- **Odchozí (úložiště audit-logu):** záznamy auditu požadavků/odpovědí popisující požadavky platformy
  a jejich výsledky (pouze koncepčně; viz entita `EN0008`/audit-record, zde neopakováno).
- **Odchozí (index organizací):** identifikační záznamy organizací, opakovaně odesílané v plném
  rozsahu při každém naplánovaném běhu (pouze koncepčně; viz `EN0018`, zde neopakováno).
- **Příchozí:** u žádné z těchto tří rolí není zdokumentováno, že by vracela data použitá v rámci
  rekonstruovaného případu užití; vyhledávací index a index organizací slouží k dotazování jinými
  prostředky mimo rozsah zdrojované evidence.

Zde není uváděn žádný detail o payloadu ani na úrovni jednotlivých polí.

---

## Omezení

- **Dopad výpadku — vyhledávací index:** při nedostupnosti se nově uložené/změněné entity nedostanou
  do vyhledávacího indexu; samotná cesta zápisu je skutečně asynchronní prostřednictvím fronty, takže
  požadavek na platformě není blokován, ale výsledky vyhledávání mohou zaostávat (`ARCH0001` §5
  řádek 14).
- **Dopad výpadku — úložiště audit-logu:** při nedostupnosti nejsou zachyceny záznamy auditu
  požadavků/odpovědí; jde o integraci pouze pro zápis, která neovlivňuje výsledky zpracování požadavků
  (`ARCH0001` §5 řádek 14; integrations.md §4).
- **Dopad výpadku — index organizací:** při nedostupnosti se denní úplný přepis pro daný běh nezdaří;
  vzhledem k tomu, že neexistuje inkrementální kurzor, může index zůstat neaktuální až do příštího
  úspěšného úplného běhu (`ARCH0001` §5 řádek 14; `ARCH0002` (b)).
- **Žádná inkrementální synchronizace pro index organizací:** každý naplánovaný běh znovu odesílá
  všechny organizace v plném rozsahu, nikoli jen změny od posledního běhu (`ARCH0001` §5 řádek 14;
  `ARCH0002` (b)).
- **Oddělené koncové body pro jednotlivé role:** vyhledávací index, úložiště audit-logu a index
  organizací jsou dosahovány jako samostatné, napevno nastavené cíle, nikoli jako jeden sjednocený
  koncový bod (`ARCH0001` §5 řádek 14).
- **Role auditu pouze pro zápis:** role úložiště audit-logu pouze zapisuje záznamy; není používána
  k obsluze dotazů zpět do platformy.
- **Pouze role hranice:** tento ES popisuje pouze externí hranici Elasticsearch/Elastic Cloud.
  Interní komponenta, která připravuje a zařazuje dokumenty do fronty k indexaci, není sama o sobě
  externím systémem a je mimo rozsah tohoto ES (`FN0022`).
- **Pouze současný stav:** toto odráží integraci tak, jak je doložena dnes; není zde uváděna žádná
  změna cílového stavu.
- **Úroveň evidence:** `Partial` pro tok synchronizace vyhledávacího indexu (HS16); `Confirmed` pro
  role úložiště audit-logu a indexu organizací na úrovni architektury/integrační mapy (`ARCH0001` §5
  řádek 14).
