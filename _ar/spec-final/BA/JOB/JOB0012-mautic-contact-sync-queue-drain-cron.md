---
doc_id: JOB0012
title: Mautic Contact Sync Queue Drain (Cron)
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: scheduler
references:
  - FN0015
  - EN0008
  - ES0006
---

# JOB0012 – Vyprázdnění fronty synchronizace kontaktů Mautic (Cron)

## Účel

Vyprázdnit frontu synchronizace kontaktů Mautic při každém běhu cronu a provést upsert každého
zařazeného uživatele do marketingového/CRM systému Mautic. Toto je plánovaný spouštěč pro
asynchronní worker typu JOB0014, popsaný v sesterském úkolu JOB0013; realizuje větev vyprazdňování
fronty pro FN0015 (Marketing / synchronizace CRM).

Klasifikace: **Confirmed** (spouštěč cronu + smyčka vyprazdňování doloženy).

## Model spouštění

- Plánované. Běží jako druhá jednotka cron hooku `patron_base` při běhu platformového cronu
  (hodinově, `0 * * * *`). Bez interního denního omezení — vyprazdní až 500 položek za jeden běh.
- Evidence: `patron_base/patron_base.module:163,167` → `patron_base/src/PatronBaseMauticCron.php:14`
  → `processQueue('mautic_queue')`. Samotný worker je konzumentská smlouva Mautic z JOB0015.

## Rozsah vstupu

- Položky ve frontě synchronizace Mautic (každá nese id uživatele). Položky jsou zařazeny do fronty
  při uložení uživatele (handler uložení uživatele přidá uživatele do této fronty). Za jeden běh je
  převzato až 500 položek, každá s 1hodinovou lhůtou převzetí (claim lease).

## Pravidla zpracování

- Smyčka až 500 opakování: převzít položku, zavolat na ní Mautic queue worker a při úspěchu smazat.
- Worker provede upsert kontaktních polí uživatele do Mautic **pouze pokud** je zapnutý feature flag
  exportu do Mautic; jinak se vrátí bez odeslání. Viz EN0008.

## Vedlejší efekty

- Odchozí upsert kontaktu do Mautic (ES0006) pro každého zpracovaného uživatele (podmíněno feature
  flagem). Žádná lokální mutace entity. Řádky fronty jsou převzaty/smazány/uvolněny.
- Telegram provozní alert při chybě workeru (FN0023).

## Idempotence

- Upsert kontaktu je klíčován identitou kontaktu na straně Mautic, takže opakované zpracování
  přepíše stejný kontakt (externě idempotentní). Doručení z fronty je typu at-least-once (převzetí →
  smazání při úspěchu).

## Ošetření chyb

- Zpracování výjimek po jednotlivých položkách: opětovné zařazení do fronty při přechodných/serverových
  výjimkách; při obecné výjimce je položka **uvolněna** (retryable), nikoli smazána (řádek se smazáním
  je zakomentovaný) — trvale selhávající položka se tak zkouší znovu neomezeně. `Confirmed`.
- Cron hook tuto jednotku obaluje a při úniku výjimky ji **znovu vyhazuje** (re-throw), což může
  přerušit celý běh platformového cronu.

## Odkazy

- FN: FN0015, FN0023
- UC: UC0012, UC0013, UC0015
- EN: EN0008
- ES: ES0006
- Evidence: PatronBaseMauticCron, MauticQueue worker (viz JOB0015)

## Otevřené body

- **Riziko anti-erasure (Confirmed, FN0015):** synchronizace s Mautic znovu provádí upsert uživatelů
  včetně jména/příjmení, takže může znovu vytvořit kontakt po GDPR anonymizaci. Zaznamenáno jako
  průřezové riziko.
- Základní URL API Mautic je vybírána podle země ve workeru/příkazu; existuje i samostatná CLI cesta
  synchronizace (JOB0020). `Partial` v tom, která cesta je v produkci autoritativní.
