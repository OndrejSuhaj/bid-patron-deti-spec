---
doc_id: JOB0010
title: Application Auto Status Transition
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: scheduler
references:
  - FN0003
  - EN0001
  - EN0027
---

# JOB0010 – Automatický přechod stavu žádosti

## Účel

Posunout žádosti ze zdrojového stavu do cílového stavu poté, co ve zdrojovém stavu setrvaly déle než
nakonfigurovaný interval, a spustit akci přiřazenou k dané pravidlu. Realizuje FN0003
(Naplánované / automatické přechody stavů) — **automatická změna statusu** / cron akce
(glossary C044).

Klasifikace: **Confirmed** (doloženo cron triggerem + smyčkou přechodů řízenou konfigurací).

## Model spouštění

- Naplánované. Běží jako cron jednotka `application_action` v rámci platformového cron ticku
  (hodinově, `0 * * * *`). Bez interního denního omezení frekvence.
- Evidence: `application_action/application_action.module:34` →
  `application_action/src/ApplicationActionCron.php:13`. (Starší blok pro snapshot stavů / denní
  mailer v 13:00 ve stejném hooku je zcela zakomentovaný.)

## Rozsah vstupu

- Aktivní pravidla application-action, jejichž iniciátorem je `cron` (konfigurační entity nesoucí
  zdrojový stav, cílový stav, interval setrvání a název akce).
- Pro každé pravidlo: žádosti aktuálně ve zdrojovém stavu daného pravidla, jejichž časové razítko
  poslední změny je starší než interval pravidla. Viz EN0001, EN0027.

## Zpracování

- Pro každou nalezenou žádost (s opětovným ověřením, že je stále ve zdrojovém stavu): nastavit ji do
  cílového stavu s aktérem CRM-robot a uložit, poté spustit akci nakonfigurovanou v pravidle.

## Vedlejší efekty

- Přechod stavu žádosti (nová revize + auditní řádek historie stavů) pro každý nalezený záznam,
  provedený stejným nechráněným přechodovým rozhraním, jaké používá FN0002 (dědí tak jeho navazující
  efekty: zařazení do fronty pro vyhledávací index → JOB0013, události změny stavu, jakoukoli
  transakční zprávu, kterou cílový stav spouští).
- Vedlejší efekty specifické pro danou akci (jedinou akcí doloženou v aktuálních zdrojích je
  remove-patron; viz FN0003).
- Žádná vlastní volání externích systémů.

## Idempotence

- Chráněno opětovným ověřením, že žádost je stále ve zdrojovém stavu před přechodem; jakmile je
  přesunuta, již neodpovídá podmínce, takže opakované běhy jsou pro samotný přechod bezpečné.
  Jakákoli neidempotentní akce pravidla je záležitostí dané konkrétní akce.

## Zpracování chyb

- Cron hook obaluje běh do try/catch a chybu pouze **zaznamenává do logu** (nevyhazuje ji dál),
  takže selhání nepřeruší platformový cron tick. Uvnitř smyčky není žádná ochrana na úrovni
  jednotlivé položky.

## Odkazy

- FN: FN0003, FN0002
- UC: UC0002 (dílčí flow UC0002.3)
- EN: EN0001, EN0027
- Evidence: ApplicationActionCron

## Otevřené body

- Přechodové rozhraní neprovádí žádnou kontrolu legality přechodu / role na straně serveru
  (viz FN0025); množina živých cron pravidel závisí na runtime konfiguraci, která není přítomna
  v očištěných zdrojích. `Partial`.
