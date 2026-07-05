---
doc_id: BR-ApplicationStatusGovernance
title: Application Status Governance & Transition Legality
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0001
  - EN0002
  - EN0004
  - UC0002
  - SYSTEM
references:
  - EN0001
  - EN0002
  - EN0004
  - EN0003
  - EN0025
  - UC0002
  - UC0011
---

# BR – Správa stavů žádosti a legalita přechodů

## Účel

Upravuje jediné pole stavu žádosti, které pokrývá workflow éry leadu i éry žádosti (EN0001), a
stanovuje, které záruky legality přechodu, vedlejších efektů, idempotence a automatických přechodů
jsou — a které nejsou — v současném stavu vynucovány.

---

## Jediné pole stavu

- Žádost (EN0001) SHALL nést svou pozici ve workflow v jediném poli stavu; fáze éry leadu a fáze éry
  žádosti téhož případu SHALL být reprezentovány jako hodnoty tohoto jediného pole, nikoli jako
  samostatné záznamy.
- Nově vytvořená žádost SHALL začínat v počátečním stavu příjmu (intake).

---

## Kardinalita profilu

- Žádost (EN0001) SHALL mít nejvýše jeden profil žadatele (fundraiser) a nejvýše jeden profil patrona
  (ApplicationProfile, EN0002), rozlišené podle role profilu.

---

## Legalita přechodů (současný stav: převážně NENÍ vynucována)

- Současný stav: nelze předpokládat, že systém vynucuje legalitu přechodu při změně stavu; změna
  stavu může v současnosti dosáhnout jakéhokoli stavu workflow z jakéhokoli stavu, přičemž na většině
  míst změny neprobíhá žádná serverová kontrola přechodu.
- Současný stav: není definováno, které stavy jsou koncové a které lze znovu vstoupit, protože není
  vynucována žádná kontrola legality.
- Současný stav: omezení přechodů podle role jsou uchovávána pouze jako konfigurace a nelze
  předpokládat, že jsou vynucována na straně serveru v okamžiku změny.

---

## Vedlejší efekty změny stavu a idempotence (současný stav)

- Změna stavu SHALL aplikovat nový stav, zaznamenat auditní záznam pouze pro přidávání (append-only,
  EN0025) a spustit nakonfigurované navazující reakce.
- Současný stav: nelze předpokládat, že uložení je idempotentní — opakované uložení beze změny v
  současnosti znovu spouští fan-out reakcí a může znovu zalogovat a znovu odeslat notifikaci.
- Současný stav: nelze předpokládat, že fan-out při změně stavu je atomický — selhání uprostřed
  sekvence může vést k tomu, že některé reakce proběhnou a jiné ne.

---

## Automatické (plánované) přechody

- Žádost, která setrvala ve zdrojovém stavu déle, než je nakonfigurovaný časový práh, SHALL být
  způsobilá pro automatický přechod do nakonfigurovaného cílového stavu, přisouzený systémovému
  servisnímu účtu.
- Automatický přechod SHALL uplatňovat stejnou smlouvu o změně stavu a stejné vedlejší efekty jako
  změna iniciovaná člověkem.
- Současný stav: z nakonfigurovaných automatických akcí je vynucována pouze automatická akce
  odebrání patrona (remove-patron).

---

## Konzistence stavu žádosti a kampaně

- Žádost a její propojená kampaň (EN0004) SHALL být udržovány ve vzájemně konzistentním párování
  stavu a kategorie daru.
- Současný stav: zjištěná desynchronizace mezi žádostí a její propojenou kampaní SHALL být vyvolána
  pouze jako provozní upozornění a SHALL NOT být automaticky sesouhlasena ani opravena.

---

## Mimo rozsah

- Toto pravidlo nedefinuje úplný slovník stavů workflow ani význam jednotlivých stavů (v gesci
  modelu stavů a EN0001).
- Toto pravidlo neupravuje přechody životního cyklu financování na straně kampaně (automatické
  dokončení, automatické zrušení dokončení, řešení přeplatku) — viz BR-CampaignStoryLifecycle.
- Toto pravidlo podrobně neupravuje přechody stavu řízené smlouvou nebo scoringem — viz
  BR-ContractAndESignature a BR-ScoringAndRiskGating, které na toto pravidlo odkazují ohledně
  podkladové smlouvy o změně stavu.
- Toto pravidlo nedefinuje, jak je upozornění na desynchronizaci žádosti a kampaně doručováno nebo
  směrováno — viz BR-OperationalAlerting.
