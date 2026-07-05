---
doc_id: JOB0011
title: Payment Settlement Health Diagnostics
layer: JOB
spec_type: job-contract
status: imported
modules: []
job_type: scheduler
references:
  - FN0012
  - FN0018
  - EN0009
---

# JOB0011 – Diagnostika stavu vypořádání plateb

## Účel

Odesílat denní provozní zdravotní upozornění týkající se vypořádání plateb a integrity rolí: (1)
brány PAID Transakce starší než 7 dní, které ještě nebyly párovány s bankou, a (2) uživatelé, kteří
mají Transakce, ale nemají roli supporter. Pouze diagnostika; podporuje FN0012 (dohled nad
párováním plateb) a FN0018 (integrita rolí).

Klasifikace: **Confirmed**.

## Model spouštění

- Plánované. Běží jako cron jednotka `transaction` při tiku platformového cronu (hodinově,
  `0 * * * *`).
- Kontrola nepárovaných plateb je podmíněna `environment=production` a je samočinně omezena na
  **jednou denně** (state klíč nastaven na 02:00). Kontrola chybějící role běží při každém tiku bez
  omezení.
- Evidence: `transaction/transaction.module:100` (`transaction_cron` →
  `is_comgate_money_in_bank`, `check_users_without_role`).

## Rozsah vstupu

- Kontrola nepárovaných plateb: PAID, netestovací Transakce s id brány, bez data z banky, vytvořené
  před více než 7 dny.
- Kontrola chybějící role: uživatelé, kteří vlastní Transakce, ale nemají roli supporter. Viz
  EN0009.

## Zpracovatelská pravidla

- Spočítat nepárované Transakce a v případě nenulového počtu vyvolat provozní upozornění s tímto
  počtem.
- Shromáždit id uživatelů, kterým chybí role supporter, a v případě nenulového počtu vyvolat
  provozní upozornění s jejich výpisem.
- **Pouze pro čtení** — žádná mutace entity, žádný přechod stavu.

## Vedlejší efekty

- Pouze provozní upozornění na Telegram (FN0023). Žádné zápisy do domény, žádná volání externích
  systémů nad rámec přenosu upozornění. Perzistentní zápis state klíče pro denní omezení.

## Idempotence

- **Idempotentní** (čtení + upozornění). Stejné podmínky vyvolají opakované upozornění při
  následujících běhech/dnech, dokud nejsou vyřešeny na vyšší úrovni; neexistuje stav pro deduplikaci
  upozornění.

## Ošetření chyb

- V hooku není žádné vyhrazené try/catch; výjimka by se propagovala do platformového cron
  runneru. Kontroly jsou nenáročné dotazy.

## Odkazy

- FN: FN0012, FN0018, FN0023
- UC: UC0008, UC0020
- EN: EN0009, EN0008
- Evidence: transaction_cron (`transaction/transaction.module:100-144`)

## Otevřené body

- Jde o zdravotní signály, nikoli o opravy; nic se automaticky nepáruje ani se automaticky
  neuděluje chybějící role. Zaznamenáno, aby rebuild tyto joby nezaměnil za nápravné joby.
