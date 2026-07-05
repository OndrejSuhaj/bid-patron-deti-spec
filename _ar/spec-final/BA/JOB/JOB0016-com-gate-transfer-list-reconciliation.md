---
doc_id: JOB0016
title: ComGate Transfer-List Reconciliation
layer: JOB
spec_type: job-contract
status: imported
modules: []
job_type: batch
references:
  - FN0012
  - EN0009
  - ES0001
---

# JOB0016 – Párování transfer-listu ComGate

## Účel

Párovat lokální transakce (Transaction) s denním transfer/settlement listem ComGate: pro každý
vypořádaný transfer označit odpovídající transakci jejím variabilním symbolem a příznakem
sent-to-bank (odesláno do banky). ComGate větev FN0012 (Bank & Gateway Reconciliation / Matching) —
glosář C051 (vypořádání ComGate -> banka).

Klasifikace: **Confirmed** (CLI cesta); **Hypothesis** u jakéhokoli automatického plánování.

## Model spouštění

- Dávkový / CLI příkaz `comgatesync {days}` (nepovinný argument s počtem dní, výchozí hodnota 1).
  **Neexistuje žádný cron hook**, který by tento flow napojoval — je spouštěn operátorem nebo
  externím schedulerem.
- Evidence: `bank_integration/src/Command/ComgateSyncCommand.php` (`setName('comgatesync')`).
  Dossier: FLW0013.
- **Korekce rozsahu (zaznamenáno):** ComGate cron (`comgate_cron`) spouští job pro opakované platby
  (JOB0001), NIKOLI toto párování. Párování transferList existuje pouze v tomto CLI příkazu.

## Rozsah vstupu

- Pro každý z posledních N dní: denní transfer list ComGate, následně detailní řádky každého
  transferu (pouze platební řádky), ze kterých se extrahuje variabilní symbol a ComGate id. Viz
  EN0009.

## Pravidla zpracování

- Na každý platební řádek: raw-SQL UPDATE transakce nalezené podle ComGate id, nastavující
  variabilní symbol a příznak sent-to-bank, **s limitem 30 řádků na jedno ComGate id** (dělené
  platby nad tímto limitem se neoznačí).

## Vedlejší efekty

- Přímý raw-SQL zápis do tabulky Transaction (variabilní symbol + sent-to-bank). **Lifecycle entity
  je obcházen** — žádné save hooky, žádná PAID kaskáda, žádná re-indexace vyhledávání, žádná
  invalidace cache. Viz EN0009.
- Cross-systémová volání: ComGate transferList + singleTransfer (ES0001). Per-nepárovaný-řádek CLI
  error log a 10sekundová prodleva (sleep).

## Idempotence

- **Idempotentní pro napárované řádky** — opakovaný běh přepíše stejný variabilní symbol a znovu
  nastaví příznak sent-to-bank; nevznikají žádné nové řádky. Limit 30 řádků je jediné omezení
  částečného párování (dokumentované riziko ztráty dat).

## Zpracování chyb

- **Žádné ošetření HTTP/JSON chyb:** 4xx/5xx odpověď brány nebo timeout vyvolá výjimku a přeruší celý
  běh pro daný den i pro zbývající dny. Nepárované ComGate id se pouze zaloguje + následuje sleep,
  bez retry/fronty. Dokumentovaná rizika current-state (FLW0013).

## Reference

- FN: FN0012
- UC: UC0008
- EN: EN0009
- ES: ES0001
- Evidence: FLW0013

## Otevřené body

- Automatické plánování tohoto příkazu je **nepotvrzené** (žádné napojení na cron; evidovaná je
  pouze manuální CLI cesta). `Conflict/Hypothesis` zaznamenáno ve FLW0013.
