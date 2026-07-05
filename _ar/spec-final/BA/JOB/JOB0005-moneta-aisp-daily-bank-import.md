---
doc_id: JOB0005
title: Moneta AISP Daily Bank Import
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: scheduler
references:
  - FN0012
  - EN0009
  - ES0004
  - MSG0019
---

# JOB0005 – Denní import bankovních plateb Moneta AISP

## Účel

Stáhnout bankovní kredity za předchozí den z CZ bankovního účtu prostřednictvím AISP API Moneta
(rozhraní pro informace o účtu) a zaznamenat je jako Transakce daru se stavem PAID vůči kampani
transparentního účtu, což umožňuje **párování plateb** (glosář C033). Realizuje jeden ze zdrojů
párování pro FN0012 (Párování bankovních a platebních bran).

Klasifikace: **Confirmed**.

## Model spouštění

- Plánované (Scheduled). Běží jako cron jednotka `monetaapi` v rámci platformního cron ticku
  (hodinově, `0 * * * *`), samočinně omezeno (throttling) na **maximálně jednou denně** pomocí
  persistovaného klíče posledního běhu.
- Integrace pouze pro CZ (Moneta je česká banka); klíč pro omezení frekvence se nastaví na čas
  požadavku **před** provedením práce s API (selhání uprostřed běhu tak i tak spotřebuje slot pro
  daný den).
- Evidence: `monetaapi/monetaapi.module:9` → `monetaapi/src/MonetaAPI.php` (`getID`, `getTransactions`,
  `mapAndSave`). Dossier: FLW0011.

## Rozsah vstupu

- Včerejší transakce pro jediný účet Moneta (úloha předpokládá právě jeden účet), stahované
  po stránkách (paginated pull). Měna omezena pouze na CZK.

## Pravidla zpracování

- Zjistí se ID účtu; stáhnou se včerejší transakce; pro každou z nich: deduplikace podle bankovní
  reference; rozparsování variabilního symbolu a účtu plátce; sestavení Transakce se stavem PAID
  zaúčtované na fixní kampaň transparentního účtu; doplnění vlastníka (owner user) zpětně z libovolné
  předchozí transakce na stejném bankovním účtu; vytvoření a uložení Transakce. Viz EN0009.

## Vedlejší efekty

- Nové řádky Transakcí se stavem PAID pro včerejší dosud neimportované kredity (kampaň
  transparentního účtu).
- Každé uložení Transakce spustí kaskádu PAID daru (FN0007): poděkovací zprávu (MSG0019, pouze
  pokud má rozpoznaný vlastník platnou e-mailovou adresu — anonymní importy nic neodesílají),
  přepočet vybrané částky kampaně, automatické rozdělení přeplatku, zařazení do fronty pro
  vyhledávací index (→ JOB0013), Slack notifikaci pro CZ+prod.
- Mezisystémové volání: odchozí stažení dat z Moneta AISP (ES0004). Telegram ops upozornění při
  chybě (FN0023).
- Zápis persistovaného klíče posledního běhu.

## Idempotence

- **Deduplikace pouze na úrovni aplikace** podle bankovní reference (select-then-insert; **nikoliv**
  unikátní omezení na úrovni DB) — souběh nebo překrytí může vést k duplicitnímu vložení.
- **Riziko tichého výpadku (silent-gap hazard):** klíč posledního běhu se nastavuje před provedením
  práce a stahování se vždy vztahuje na „včerejšek", takže neúspěšný den se později znovu nestáhne
  → trvalá mezera v importu. Zdokumentované riziko současného stavu.

## Zpracování chyb

- Chyby API/Guzzle jsou zalogovány a znovu vyhozeny (re-thrown), zachyceny cron wrapperem (běh skončí,
  bez opakování).
- Transakce v jiné měně než CZK vyhodí výjimku a přeruší **zbytek dávky** pro daný běh (částečný
  import).
- Parsování hluboce vnořeného pole předpokládá úplnou strukturu odpovědi; chybějící klíče mohou
  vyvolat notice/výjimku.

## Reference

- FN: FN0012, FN0007, FN0019
- UC: UC0008
- EN: EN0009, EN0004
- ES: ES0004
- MSG: MSG0019 (poděkování za dar)
- Evidence: FLW0011

## Otevřené body

- Chování při odpovědi API s nulovým nebo více účty není ošetřeno (předpokládá se `accounts[0]`).
  Mechanismus `Confirmed`.
