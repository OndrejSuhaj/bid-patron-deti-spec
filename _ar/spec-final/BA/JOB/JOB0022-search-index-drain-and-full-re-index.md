---
doc_id: JOB0022
title: Search Index Drain and Full Re-index
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: batch
references:
  - FN0022
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
  - ES0014
---

# JOB0022 – Vyprázdnění vyhledávacího indexu a úplné přeindexování

## Účel

CLI operace, které řídí vyhledávací index: (a) vyprázdnění fronty indexování entit na vyžádání a
(b) provedení úplného přeindexování, které projde všechny indexované entity a odešle je přímo do
App Search indexu, mimo frontu. Manuální ovladač pro konzumenta JOB0013 a cestu hromadné rebuild
operace FN0022 (Indexování a synchronizace vyhledávání).

Klasifikace: **Confirmed**.

## Model spouštění

- Dávkové / CLI (Drupal Console) příkazy: `patron_search:process_queue` (vyprázdnění fronty pomocí
  vyprazdňovací smyčky) a `patron_search:upload_to_es` (úplné přeindexování, mimo frontu, udržuje
  persistovaný kurzor last-id). Spouštěno operátorem nebo externě; toto je jediný evidovaný způsob,
  jak lze vyhledávací index vyprázdnit/znovu sestavit (vlastní cron vyprazdňování modulu je
  zakomentováno — viz JOB0013).
- Evidence: `patron_search/src/Command/ProcessQueueCommand.php` (`patron_search:process_queue`) →
  vyprazdňovací smyčka; `patron_search/src/Command/EsUploadCommand.php` (`patron_search:upload_to_es`).
  Dossier: FLW0032.

## Rozsah vstupu

- `process_queue`: čekající položky ve frontě indexování entit (tvar položky viz JOB0013).
- `upload_to_es`: všechny indexované entity (uživatel, žádost, kampaň, organizace, transakce),
  stránkované pomocí persistovaného kurzoru last-id. Viz EN0001, EN0004, EN0009, EN0018, EN0008.

## Pravidla zpracování

- `process_queue`: spustí sdílenou vyprazdňovací smyčku (až 500 položek, 1hodinový claim lease),
  pro každou položku vyvolá search-index worker — shodná smlouva jako u JOB0013.
- `upload_to_es`: iteruje entity po stránkách id, sestavuje stejné dokumenty podle typu jako worker,
  upsertuje každý do App Search indexu a při postupu posouvá stavový kurzor.

## Vedlejší efekty

- Vyhledávací dokumenty jsou upsertovány do App Search indexu (ES0014). **Stejné riziko úniku PII**
  jako u JOB0013 (rodná čísla, jména, e-maily, telefony odesílány nemaskované; jediný sdílený engine
  pro všechny tenanty).
- Telegram ops alert při chybě odeslání (FN0023). `upload_to_es` udržuje persistovaný kurzor;
  `process_queue` maže/uvolňuje položky fronty.

## Idempotence

- Upsert klíčovaný kompozitním id entity (externě idempotentní). `upload_to_es` je obnovitelný
  pomocí kurzoru last-id; opětovné spuštění od resetovaného kurzoru znovu odešle vše.

## Zpracování chyb

- `process_queue` dědí sémantiku selhání vyprazdňovací smyčky (uvolnění/requeue/smazání podle typu
  výjimky; platí rizika tichého výpadku indexu a nekonečného opakování zmíněná u JOB0013).
- `upload_to_es` u chyb jednotlivých dokumentů alertuje a pokračuje podle kurzoru; tvrdé selhání
  přeruší průchod na aktuální pozici kurzoru (obnovitelné při dalším běhu).

## Odkazy

- FN: FN0022, FN0023
- UC: UC0018
- EN: EN0001, EN0004, EN0009, EN0018, EN0008
- ES: ES0014
- Evidence: FLW0032; ProcessQueueCommand, EsUploadCommand

## Otevřené body

- Zda `process_queue` pravidelně vyvolává externí scheduler, **není v source evidováno**
  (`Hypothesis`) — jde o zbytkovou mezeru v plánování pro celou cestu vyhledávacího indexu
  (JOB0013 + tato job). Přístupové údaje k indexu jsou `<redacted>` (dodávané přes env, ve
  scrubbed source chybí).
