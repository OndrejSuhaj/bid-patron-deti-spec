---
doc_id: JOB0008
title: Voucher Expiry Reminder and Expired-Voucher Sweep
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: scheduler
references:
  - FN0011
  - EN0013
  - MSG0025
---

# JOB0008 – Připomenutí expirace dárkového poukazu a hromadné zpracování expirovaných poukazů

## Účel

Připomenout příjemcům neuplatněné dárkové poukazy (**voucher**, glosář C023 — Dobrošek), jejichž
platnost končí za 7 dní, a vygenerovat provozní upozornění se seznamem již expirovaných neuplatněných
poukazů. Podporuje FN0011 (Vystavení a uplatnění dárkového poukazu).

Klasifikace: **Confirmed**.

## Model spouštění

- Plánované (scheduled). Běží jako cron jednotka `voucher` v rámci platformového cron tiku (hodinově,
  `0 * * * *`). Dva dílčí kroky, každý samostatně omezen na **maximálně jednou denně** pomocí vlastního
  persistovaného stavového klíče (inicializován na 02:00); úplně první běh každého z nich pouze
  inicializuje stav a skončí.
- Poznámka: pojistka omezující běh pouze na produkční prostředí je v kódu přítomna, ale je
  **zakomentovaná**, takže job aktuálně běží ve všech prostředích. `Confirmed`.
- Evidence: `voucher/voucher.module:11` → `voucher/src/VoucherCron.php:13`.

## Rozsah vstupu

- Krok připomenutí: až 10 uhrazených, neuplatněných dárkových poukazů, u nichž ještě nebylo odesláno
  připomenutí, s e-mailem příjemce a platností vypršující do 7 dní.
- Krok expirovaných poukazů: uhrazené, neuplatněné dárkové poukazy, jejichž platnost už vypršela
  (stejný základní predikát, okno 0 dní). Viz EN0013.

## Zpracovatelská pravidla

- Krok připomenutí: pro každý splatný poukaz odešle jeho připomenutí blížící se expirace (tím se
  poukaz zároveň označí jako připomenutý).
- Krok expirovaných poukazů: shromáždí id expirovaných poukazů a odešle jedno souhrnné upozornění na
  Slack se seznamem těchto id (bez úpravy entit).

## Vedlejší efekty

- Odeslání připomínající zprávy pro každý splatný poukaz (transakční zpráva vztahující se k
  dárkovému poukazu přes FN0019 — viz rodina MSG0025) a označení poukazu jako připomenutého.
- Provozní upozornění na Slack se seznamem id expirovaných poukazů (FN0023).
- Zápisy do persistovaných stavových klíčů (kurzory pro omezení frekvence).

## Idempotence

- Krok připomenutí je chráněn predikátem „ještě nepřipomenuto“ (poukaz, který už byl připomenut, se
  znovu nevybere), takže opakované běhy nevedou k duplicitnímu připomenutí. Krok upozornění na
  expirované poukazy je pouze čtení + upozornění (bez deduplikace samotného upozornění — stejná id
  mohou být znovu uvedena i následující dny, dokud nejsou uplatněna nebo vyřešena).

## Zpracování chyb

- V rámci smyčky není žádné try/catch pro jednotlivé položky; ani cron hook nemá obalující try/catch,
  takže výjimka se propaguje a může přerušit platformový cron tik. Dokumentováno jako současné
  chování.

## Odkazy

- FN: FN0011, FN0019, FN0023
- UC: UC0009
- EN: EN0013
- MSG: připomenutí dárkového poukazu (rodina MSG0024 / MSG0025 — viz vrstva MSG)
- Evidence: VoucherCron

## Otevřené body

- Zda existuje samostatný MSG dokument pokrývající **připomenutí expirace** poukazu (odlišné od
  potvrzení nákupu / uplatnění), je téma k dořešení ve vrstvě MSG. `Partial`.
