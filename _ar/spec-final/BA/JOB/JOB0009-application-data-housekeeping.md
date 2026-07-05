---
doc_id: JOB0009
title: Application Data Housekeeping
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: repair
references:
  - FN0001
  - EN0001
  - EN0006
---

# JOB0009 – Údržba dat žádosti (Application Data Housekeeping)

## Účel

Periodická údržba dat žádosti (Application): mazání starých záznamů relace žádosti (application-session),
odstraňování přílohových souborů ze žádostí po uplynutí pevného časového okna od dosažení konfigurovaných
stavů a spuštění diagnostiky konzistence stavu. Podporuje FN0001 (Application Intake & Case Management).

Klasifikace: **Confirmed** (kroky údržby); krok oprav stavu je **pouze diagnostický** — jeho skutečné
zápisy stavu jsou zakomentované (viz Pravidla zpracování).

## Model spouštění

- Plánovaný. Běží jako cron jednotka `application` v rámci platformového cron ticku (hodinově,
  `0 * * * *`). Bez interního denního omezení (throttlingu) — spouští se při každém ticku.
- Evidence: `application/application.module:935` → `application/src/ApplicationCron.php:15`.

## Rozsah vstupu

- Záznamy relace žádosti (application-session) starší než ~6 měsíců.
- Žádosti, které dosáhly konfigurovaných stavů pro odstranění přílohy v rámci okna ~30–32 dní
  (vybírané z tabulky historie stavů).
- Nejnovějších 5 000 žádostí pro diagnostiku konzistence stavu. Viz EN0001, EN0006.

## Pravidla zpracování

- Smazání zastaralých záznamů relace žádosti (application-session).
- U žádostí v okně pro odstranění: vyčištění konfigurovaných polí přílohových souborů na profilu
  žadatele (fundraiser profile) a uložení (pouze pokud je aktuální stav žádosti v konfigurované
  množině stavů).
- Diagnostika oprav stavu: u nedávných žádostí se vypočítá stav, ve kterém by měly být, oproti
  jejich aktuálnímu stavu, a nesoulady se zalogují. **Opravné zápisy stavu jsou zakomentované** —
  tento krok v současnosti pouze reportuje, stavy nemění. `Confirmed`.
- Na konci běhu vyprázdní všechny cache.

## Vedlejší efekty

- Smazané entity relace žádosti (application-session); vyčištěné odkazy na přílohové soubory na
  odpovídajících profilech (odstranění přílohy je jediná mutace entity, kterou job provádí). Viz EN0006.
- Diagnostické logové řádky (a Telegram pro označené nesoulady). Úplné vyprázdnění cache.
- Žádná volání externích systémů.

## Idempotence

- **Idempotentní** — mazání relací a čištění příloh jsou přirozeně opakovatelné (již vyčištěné pole /
  již smazaná relace se přeskočí nebo se jedná o no-op). Diagnostika je pouze pro čtení (read-only).

## Zpracování chyb

- Cron hook obaluje běh, při chybě loguje a **znovu vyhazuje výjimku** (může přerušit platformový
  cron tick). Uvnitř jednotlivých kroků nejsou žádné ochrany na úrovni jednotlivých položek.

## Odkazy

- FN: FN0001
- UC: UC0001, UC0019
- EN: EN0001, EN0006
- Evidence: ApplicationCron

## Otevřené body

- Úplné vyprázdnění cache na konci běhu v rámci hodinového cronu je provozní záležitost (zdokumentováno,
  ale zde neřešeno redesignem). Okno pro odstranění přílohy se opírá o dvoudenní pásmo v tabulce historie
  stavů; zmeškaný běh může žádost trvale vynechat. `Confirmed` mechanismus.
