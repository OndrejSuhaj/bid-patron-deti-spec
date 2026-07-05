---
doc_id: JOB0019
title: Netopia Transaction Status Reconciliation
layer: JOB
spec_type: job-contract
status: imported
modules: []
job_type: batch
references:
  - FN0008
  - FN0012
  - EN0009
  - ES0002
---

# JOB0019 – Párování stavů transakcí Netopia

## Účel

Sesouhlasit lokální stavy Transakce vůči RO bráně (Netopia/MobilPay): dotázat bránu na autoritativní
stav každé Transakce a reportovat (a případně opravit) neshody. Podporuje FN0008 / FN0012 pro region
RO.

Klasifikace: **Confirmed**.

## Model spouštění

- Dávkové / CLI (Drush) příkazy: `netopia:sync` (kompletní report do CSV) a `netopia:sync:20 {period}
  --update` (kontrola stavu za posledních N dní, s možností zápisu opravených stavů). Spouští operátor;
  ve zdrojovém kódu není napojeno na cron.
- Evidence: `netopia/src/Commands/NetopiaCommands.php` (`@command netopia:sync`, `netopia:sync:20`).

## Rozsah vstupu

- `netopia:sync`: všechny rodičovské Transakce. `netopia:sync:20`: Transakce vytvořené v daném časovém
  okně (počet dní), propojené se svým uživatelem. Pouze RO. Viz EN0009.

## Pravidla zpracování

- Pro každou Transakci: sestavit požadavek na stav MobilPay (hash účtu prodejce) a zavolat bránu;
  namapovat vrácený externí kód stavu na interní stav; vytvořit řádek reportu.
- V režimu `--update`, pokud je namapovaný stav platný a liší se od uloženého stavu, načíst Transakci a
  uložit opravený externí stav.

## Vedlejší efekty

- Režim `--update`: zápis externího stavu Transakce **přes uložení entity** (takže se spustí save
  hooky — na rozdíl od párování plateb ComGate přes raw SQL v JOB0016). Report mode zapisuje CSV do
  temp cesty. Viz EN0009.
- Mezisystémové volání: SOAP stavu Netopia/MobilPay (ES0002). Telegram alert pro provoz při chybě brány
  (FN0023).

## Idempotence

- **Idempotentní** — opakovaný běh znovu dotazuje bránu a zapisuje pouze při změně stavu; konvergovaná
  Transakce zůstává nezměněna.

## Zpracování chyb

- SOAP chyby na úrovni jednotlivé Transakce jsou zachyceny (přeskočení / bez update) nebo nahlášeny
  přes Telegram; běh pokračuje. Chyba jedné položky nezpůsobí přerušení celé dávky.

## Reference

- FN: FN0008, FN0012, FN0023
- UC: UC0005, UC0006, UC0008
- EN: EN0009
- ES: ES0002
- Evidence: NetopiaCommands (`netopia:sync`, `netopia:sync:20`)

## Otevřené body

- Id účtu prodejce MobilPay a heslo hashe jsou v příkazu hardcoded (`<redacted>`). Je přítomno
  hardcoded přeskočení `parent == 30` a pevný přepínač sandbox/produkční WSDL. `Confirmed` mechanismus;
  plánování (scheduling) není evidováno.
