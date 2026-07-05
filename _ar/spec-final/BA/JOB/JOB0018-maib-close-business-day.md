---
doc_id: JOB0018
title: MAIB Close Business Day
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: batch
references:
  - FN0008
  - ES0003
---

# JOB0018 – Uzávěrka obchodního dne MAIB

## Účel

Uzavřít obchodní den platební brány MAIB pro region MD a vypořádat autorizované transakce daného dne.
Podporuje FN0008 (Integrace platební brány) pro region MD.

Klasifikace: **Confirmed**.

## Model spouštění

- Dávkový / CLI (Drush) příkaz `maib:close`. **Externě plánováno** — zdrojový kód obsahuje přesný
  zamýšlený řádek crontabu v komentáři kódu:
  `59 21 * * * docker exec patronus sh -c "cd /var/www/patronus && vendor/bin/drush @self.md-stag maib:close"`
  (tj. denně v 21:59, instance MD). Jde o cron záznam na úrovni OS, odlišný od platformového cronu
  Drupalu.
- Evidence: `maib/src/Commands/MaibCommands.php:66` (`@command maib:close`, komentář s crontabem na
  řádku :62).

## Rozsah vstupu

- Žádný lokální rozsah vstupu — vydává jediný příkaz „uzavřít obchodní den" bráně MAIB pro aktuální
  den. Pouze MD.

## Pravidla zpracování

- POST příkazu uzávěrky obchodního dne bráně MAIB; interpretace výsledku (OK vs. selhání).

## Vedlejší efekty

- Odchozí volání uzávěrky dne na MAIB (ES0003). Žádná mutace lokální doménové entity.
- Při výsledku selhání: provozní alert na Telegram (FN0023). Výsledek se loguje.

## Idempotence

- Uzávěrka obchodního dne je operace na straně brány; opětovné vydání příkazu ve stejný den je věcí
  brány (typicky bez efektu nebo neškodné po prvním úspěchu). Samotný job neudržuje žádný lokální
  stav pro deduplikaci.

## Řešení chyb

- Výsledek jiný než OK vyvolá provozní alert na Telegram a je zalogován; automatický retry neexistuje.
- Protože se jedná o jednorázové spuštění přes OS cron, zmeškaný běh znamená zmeškanou uzávěrku pro
  daný den (provozní záležitost).

## Reference

- FN: FN0008, FN0023
- UC: UC0005, UC0006
- ES: ES0003
- Evidence: MaibCommands (`maib:close`)

## Otevřené body

- Řádek crontabu ve zdrojovém kódu cílí na alias `md-stag`; produkční alias/host není ve
  scrubbovaném zdrojovém kódu doložen. Tajné údaje (autentizace příkazu MAIB) jsou `<redacted>`.
  `Partial`.
