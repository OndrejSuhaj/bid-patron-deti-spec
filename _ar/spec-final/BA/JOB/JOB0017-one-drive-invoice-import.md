---
doc_id: JOB0017
title: OneDrive Invoice Import
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: batch
references:
  - FN0017
  - EN0001
  - EN0004
  - ES0013
---

# JOB0017 – Import faktur z OneDrive

## Účel

Stáhnout PDF faktury ze sdílené složky SharePoint/OneDrive, odvodit z názvu každého souboru cílový
Campaign a přiložit soubor do pole audit-attachment (příloh k auditu) žádosti (Application) daného
Campaignu. Realizuje FN0017 (Document Import — OneDrive).

Klasifikace: **Confirmed** (CLI cesta); mechanismus plánování **Hypothesis**.

## Model spouštění

- Dávkový / CLI příkaz `onedrive:import:invoices [limit] [savefiles] [errorsonly]`. V modulu není
  napojení na cron/hook — spouští se operátorem nebo externě.
- Evidence: `onedrive/src/Command/OnedriveCommand.php` (`configure()` nastavuje název příkazu).
  Dosier: FLW0028. (Korekce: jde o Drupal Console příkaz, nikoli o Drush příkaz.)

## Rozsah vstupu

- Potomci jedné pevně zadané (hardcoded) složky disku, velikost stránky = argument limit; zpracovávají
  se pouze položky `.pdf`. Id Campaignu se odvozuje z názvu souboru. Režim dry-run pouze vypíše seznam
  bez uložení. Viz EN0004.

## Zpracovatelská pravidla

- Získá token Microsoft Graph (ROPC password grant); vypíše obsah složky; pro každé PDF: odvodí id
  Campaignu z názvu souboru, načte Campaign a (pokud je požadováno uložení) stáhne soubor, zapíše ho do
  privátní oblasti audit-attachments a připojí jeho id do pole audit-attachment žádosti (Application)
  daného Campaignu, přičemž žádost uloží bez nové revize.

## Vedlejší efekty

- Nový správcovaný soubor (managed file) v privátní oblasti audit-attachments; žádost (Application)
  Campaignu se znovu uloží s připojenou přílohou. Viz EN0001, EN0004.
- Uložení žádosti znovu vstupuje do fan-outu FN0002 (event aktualizace stavu, zařazení do
  search-indexu → JOB0013, re-sync Campaignu), i když se změnila jen příloha.
- Mezisystémová volání: token endpoint Microsoft identity + Graph list/download (ES0013). Stažený
  temp soubor zůstává neuklizen.

## Idempotence

- **Není idempotentní:** opakovaný běh znovu stáhne soubor a připojí **duplicitní** id přílohy (pole má
  neomezenou kardinalitu bez deduplikace). Zdokumentované riziko současného stavu.

## Zpracování chyb

- Chyby při získání tokenu / výpisu / stažení nejsou zachyceny → celý běh se přeruší. Campaign bez
  žádosti (Application), nebo chybně formátovaný název souboru, není ošetřen / je chybně namapován.
  Neúspěšný zápis souboru je zalogován a přeskočen, bez opakování. Zdokumentovaná rizika současného
  stavu (FLW0028).

## Odkazy

- FN: FN0017, FN0002
- UC: UC0019
- EN: EN0001, EN0004
- ES: ES0013
- Evidence: FLW0028

## Otevřené body

- Uzamčení na ROPC s pevně zadanými (hardcoded) přihlašovacími údaji v čistém textu (`<redacted>`);
  chybí filtr regionu/tenantu (smíšená složka může způsobit chybné přiřazení napříč CZ/RO/MD). Plánování
  není v pramenech doloženo. `Hypothesis`.
