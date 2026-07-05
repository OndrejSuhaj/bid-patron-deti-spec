---
doc_id: JOB0004
title: Daily Report CSV Export Batch
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: batch
references:
  - FN0020
  - EN0009
  - EN0001
---

# JOB0004 – Dávka denního exportu reportů do CSV

## Účel

Vytvořit kompletní sadu denních reportovacích CSV extraktů (platby, leady, dárci, fundraiseři,
patroni, kampaně, dárkové poukazy, účetnictví, smlouvy, úhrady darů, blacklist, low-risk,
scoring-KO, report o patronech) jako cache soubory pro daný den, aby stažení na vyžádání
z administrace obsluhovala předem vytvořené soubory bez opětovného dotazování. Realizuje exportní
větev FN0020 (Reportovací read-model a CSV export).

Klasifikace: **Confirmed**.

## Model spouštění

- Plánovaná dávka. Běží jako cron jednotka `export_csv` na tiku platformového cronu (hodinově,
  `0 * * * *`), samoregulovaná pomocí perzistovaného stavového klíče tak, aby běžela **maximálně
  jednou za kalendářní den**, při první příležitosti po 03:00. Úplně první běh pouze inicializuje
  stavový klíč a skončí.
- Evidence: `export_csv/export_csv.module:5` → `export_csv/src/ExportCsvCron.php:13`. Dossier: FLW0027.

## Rozsah vstupu

- Pevná mapa 16 exportních úloh, každá jako read-only agregace nad reportovacími tabulkami
  (Transaction, Application, profile/party, campaign, voucher, accounting, cost data). Cronová cesta
  nemá žádné parametry volajícího (cesta na vyžádání navíc přijímá filtr na kampaň). Viz EN0009, EN0001.

## Pravidla zpracování

- Pro každou ze 16 úloh: smaže se včerejší a dnešní cílový soubor, pokud existuje, spustí se
  exportní metoda zapisující do datovaného souboru dané route a zaloguje se dokončení.
- Každý export provede jeden raw SQL dump do temp souboru a poté jej načte zpět, aby persistoval
  datovaný cache soubor.
- Read-only: žádná mutace domain entity, žádný přechod stavu.

## Vedlejší efekty

- Až 16 datovaných CSV cache souborů zapsaných do temp adresáře za jeden běh; předchozí den i
  aktuální den se nejprve odstraní a poté znovu vytvoří. Tyto soubory se stávají cache pro daný den,
  kterou obsluhuje cesta stažení na vyžádání.
- **PII v klidu (právní/bezpečnostní riziko):** extrakty obsahují nešifrovaná rodná čísla, jména,
  adresy, e-maily, telefony, čísla smluv zapsané do plaintextových temp souborů, které nejsou nikdy
  uklizeny. Rovněž se hromadí randomizované mezitímní dump soubory. Bez CZ/RO/MD tenant scoping
  (globální).
- Zápisy logů do reportovacích log kanálů. Žádná volání externích systémů (sink pouze na lokální
  souborový systém).

## Idempotence

- **Idempotentní na den** dle návrhu: každý běh smaže a znovu vytvoří soubory daného dne. Protože
  podkladový dump odmítne přepsat existující temp soubor, kolize ve stejné sekundě jsou vzácné, ale
  možné, a způsobily by selhání daného jednoho exportu.

## Zpracování chyb

- Chyby jednotlivých exportů jsou zachyceny a zalogovány; smyčka pokračuje dál, takže dávka může
  některé soubory zanechat neaktuální nebo chybějící, zatímco jiné proběhnou úspěšně.
- Výjimky, které uniknou z dávky, jsou zalogovány a cronový wrapper je **znovu vyhodí** (může
  přerušit tik platformového cronu).
- Rozdělené konfigurace web/DB hostů mohou tiše produkovat prázdná CSV (selhání round-tripu přes
  temp soubor). Zdokumentované riziko současného stavu (FLW0027).

## Reference

- FN: FN0020
- UC: UC0017
- EN: EN0009, EN0001, EN0002, EN0006, EN0004, EN0011
- Evidence: FLW0027 (plánovaná cesta; cesta stažení na vyžádání je FN0020 / nejde o JOB)

## Otevřené body

- Denní export závisí na oprávněních databázového serveru k souborům a na přístupu do temp
  adresáře; přesná konfigurace serveru je specifická pro dané prostředí. `Hypothesis` ohledně
  detailů nasazení.
