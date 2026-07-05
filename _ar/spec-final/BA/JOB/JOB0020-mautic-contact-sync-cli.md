---
doc_id: JOB0020
title: Mautic Contact Sync (CLI)
layer: JOB
spec_type: job-contract
status: imported
modules: []
job_type: batch
references:
  - FN0015
  - EN0008
  - ES0006
---

# JOB0020 – Synchronizace kontaktů s Mautic (CLI)

## Účel

Hromadné vložení/aktualizace (upsert) uživatelů platformy (s celkovými částkami darů, rolemi, daty
posledního přihlášení/poslední transakce) do marketingového/CRM systému Mautic přes CLI. Jde o
batch/CLI větev FN0015 (Marketing / CRM Synchronisation), která doplňuje cron pro vyprazdňování fronty
(JOB0012).

Klasifikace: **Confirmed**.

## Model spouštění

- Batch / CLI (Drush) příkazy: `mautic:sync:contacts` (podmíněno produkčním prostředím; delta podle
  času transakce podporovatele a podle času změny uživatele pomocí persistovaných stavových klíčů) a
  `patron_base:mautic_sync` (úplný průchod všech uživatelů, podmíněno feature flagem). Spouští operátor
  nebo externí volání; bez napojení na cron.
- Evidence: `mautic/src/Commands/MauticCommands.php` (`mautic:sync:contacts`);
  `patron_base/src/Commands/PatronBaseCommands.php` (`patron_base:mautic_sync`).

## Rozsah vstupu

- `mautic:sync:contacts`: podporovatelé s transakcemi od posledního kurzoru synchronizace
  podporovatelů, plus uživatelé změnění od posledního kurzoru synchronizace uživatelů.
  `patron_base:mautic_sync`: všichni uživatelé. Viz EN0008.

## Pravidla zpracování

- Pro každého uživatele: sestavení polí kontaktu (jméno, e-mail, role, data zóny/poslední transakce, a
  u podporovatelů celková částka/počet/průměr darů) a upsert do Mauticu. Posunutí kurzorů času
  synchronizace po každém průchodu (pouze `mautic:sync:contacts`).

## Vedlejší efekty

- Odchozí upsert kontaktu do Mauticu (ES0006) pro každého uživatele; základní URL adresa API je
  volena podle země. Žádná mutace lokální doménové entity. Persistované zápisy kurzoru synchronizace
  (`mautic:sync:contacts`).

## Idempotence

- Upsert je klíčován identitou kontaktu na straně Mauticu (externě idempotentní). Delta kurzory
  umožňují opětovné spuštění `mautic:sync:contacts` bez opakovaného zpracování nezměněných uživatelů;
  úplný průchod zpracovává znovu všechny.

## Zpracování chyb

- Chyby odeslání jednotlivého uživatele se zaznamenávají (error) a přeskakují; průchod pokračuje.
  Podmínka produkčního prostředí u `mautic:sync:contacts` a feature flag u `patron_base:mautic_sync`
  mohou spuštění tiše proměnit v no-op.

## Odkazy

- FN: FN0015
- UC: UC0012, UC0013
- EN: EN0008
- ES: ES0006
- Evidence: MauticCommands, PatronBaseCommands (`patron_base:mautic_sync`)

## Otevřené body

- **Riziko opětovného vytvoření po výmazu (Confirmed, FN0015):** tyto průchody vkládají/aktualizují
  jméno a příjmení a mohou znovu vytvořit kontakt v Mauticu po GDPR anonymizaci. Překryv s cestou přes
  vyprazdňování fronty (JOB0012); která cesta je v produkci autoritativní, je otevřený bod typu
  `Partial`.
