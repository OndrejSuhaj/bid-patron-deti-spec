---
doc_id: JOB0007
title: Organisation Elastic Cloud Daily Re-push
layer: JOB
spec_type: job-contract
status: imported
modules: []
job_type: scheduler
references:
  - FN0022
  - EN0018
  - ES0014
---

# JOB0007 – Denní znovu-odeslání organizací do Elastic Cloud

## Účel

Jednou denně odeslat každou organizaci (id + název) do hostovaného indexu `organisations` v Elastic
Cloud. Jde o samostatné aktuální využití FN0022 (Indexace a synchronizace vyhledávání), odlišné od
fronty search-indexu entit (JOB0013).

Klasifikace: **Confirmed**.

## Model spouštění

- Plánované. Běží jako cron jednotka `organisation` na platformním cron ticku (hodinově, `0 * * * *`),
  se samo-omezením na **maximálně jednou denně** pomocí perzistovaného klíče posledního běhu
  (inicializováno na 05:00).
- Evidence: `organisation/organisation.module:31` → `organisation/src/OrganisationCron.php:13`.
  Potvrzeno ve FLW0032 jako samostatné denní odeslání indexu organizací.

## Rozsah vstupu

- **Všechny** řádky organizací (celá tabulka, id + název) při každém běhu — neexistuje kurzor ani
  delta; jde o úplné znovu-odeslání při každém spuštění. Viz EN0018.

## Pravidla zpracování

- Načíst všechny organizace; pro každou vytvořit/aktualizovat (upsert) dokument v indexu organizací
  v Elastic Cloud (dokument klíčovaný podle id organizace).
- Odeslání zcela vynechá, pokud chybí proměnné prostředí s přihlašovacími údaji k Elastic.

## Vedlejší efekty

- Jedno odchozí upsert volání na organizaci za běh do indexu organizací v Elastic Cloud (ES0014).
  Žádná lokální mutace entity.
- Provozní alert v Telegramu za každý neúspěšný dokument (FN0023).

## Idempotence

- **Idempotentní** — indexový dokument je klíčován podle id organizace, takže opětovné odeslání
  přepíše stejný dokument. Daní za to je náklad: úplné znovu-odeslání celé tabulky při každém běhu
  (bez delty).

## Zpracování chyb

- Chybějící přihlašovací údaje k Elastic → tiché vynechání (žádné odeslání, žádná chyba).
- Chyby jednotlivých dokumentů jsou nahlášeny (Telegram) a přeskočeny; cron hook obaluje běh do
  try/catch a pouze loguje (chybu znovu nevyhazuje), takže selhání nezastaví platformní cron tick.

## Odkazy

- FN: FN0022, FN0023
- UC: UC0018
- EN: EN0018
- ES: ES0014
- Evidence: FLW0032 (poznámka k indexu organizací), OrganisationCron

## Otevřené body

- Index organizací v Elastic Cloud je **samostatná** plocha Elastic oddělená od App Search indexu
  entit používaného v JOB0013 a od audit store; endpointy jsou hardcoded. Zaznamenáno, aby rebuild
  udržel obě vyhledávací plochy oddělené.
