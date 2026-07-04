---
doc_id: FN0001
title: Application Intake & Case Management
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0001
  - UC0016
  - UC0019
  - EN0001
  - EN0002
  - EN0003
  - EN0006
  - EN0008
---

# FN0001 – Příjem žádostí a správa případu

## Účel

Vytvořit a udržovat záznam případu (Application / Žádost, EN0001), který na jednom záznamu pokrývá jak
fázi příjmu leadu, tak celou fázi žádosti, spolu s jeho dotazníkovými profily a přístupovými relacemi
vázanými na roli. Jde o schopnost, díky které případ fundraisera nebo patrona vznikne, je postupně
vyplňován a zůstává jediným kanonickým subjektem, který čtou a mění všechny ostatní schopnosti pracující
s případem (orchestrace stavů, scoring, kampaň, sloučení stran).

## Odpovědnosti

- Vytvořit žádost (EN0001) z veřejného nebo backofficového podání a v rámci příjmu zajistit vlastnící
  stranu (User + Contact).
- Zachytit a postupně vyplňovat dotazníkové profily fundraisera/patrona/dítěte/daru (ApplicationProfile,
  EN0002), vázané maximálně dva na jeden případ.
- Zakládat a rušit přístupové relace vázané na roli (ApplicationSession, EN0003), které řídí, která
  strana může v dané fázi s případem pracovat.
- Přijímat externě importované artefakty (např. faktury), které se připojují k případu a spouštějí jeho
  reakce na stav.
- Sloužit jako záznam případu, který je jediným kanonickým subjektem čteným a měněným stavovou osou,
  scoringem, kampaní a schopností slučování stran.

## Související případy užití

UC0001 – Podání žádosti (Žádost); UC0019 – Import faktur z OneDrive (cesta přiložení); UC0016 – Správa
záznamů stran (Deduplikace / Sloučení) (žádost je předmětem sloučení, nikoli vlastní odpovědností této
schopnosti).

## Související entity

EN0001 – Application; EN0002 – ApplicationProfile; EN0003 – ApplicationSession; EN0006 – Contact;
EN0008 – User.

## Integrace

Žádné. Samotný příjem nevolá žádný externí systém.

## Omezení

- Vazby jsou pouze měkké reference (žádné cizí klíče v databázi, žádná vynucená jedinečnost identity
  strany), což je důvod, proč se hromadí duplicitní případy.
- Stavy z éry leadu a éry žádosti sdílejí jedno stavové pole (~66 stavů na jednom poli); Lead je fází
  téhož případu, nikoli samostatným záznamem.
