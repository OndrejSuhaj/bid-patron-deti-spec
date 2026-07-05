---
doc_id: JOB0006
title: Bank Notification E-mail IMAP Import
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: poller
references:
  - FN0012
  - EN0009
  - ES0005
  - MSG0019
---

# JOB0006 – IMAP import bankovních avíz z e-mailu

## Účel

Pravidelně kontrolovat (poll) e-mailovou schránku s bankovními avízy CZ klienta na nové
notifikační e-maily o platbě, každý z nich rozparsovat do řádku bankovního výpisu a buď vytvořit
novou uhrazenou (PAID) Transakci daru, nebo párovat existující Transakce vypořádání ComGate. Jde o
druhý zdroj párování pro FN0012 (Párování plateb / Bank & Gateway Reconciliation).

Klasifikace: **Confirmed**.

## Model spouštění

- Poller. Běží jako cron jednotka `bank_integration` na platformovém cron ticku (hodinově,
  `0 * * * *`). Bez interního denního omezení — schránku kontroluje při každém ticku.
- Napevno omezeno na `environment=production AND country=cz`; RO/MD tento job nikdy nespouští.
- Evidence: `bank_integration/bank_integration.module:15` →
  `bank_integration/src/Controller/BankIntegrationPageController.php` (`getMailFromServerHandle`).
  Dossier: FLW0012.

## Rozsah vstupu

- Nepřečtené (unseen) zprávy ve schránce od nakonfigurovaného bankovního odesílatele s přesně
  odpovídajícím předmětem. Neshodující se nepřečtené e-maily zůstávají nedotčeny.

## Pravidla zpracování

- Připojení přes IMAP; pro každou shodující se zprávu: rozparsování HTML těla pomocí pevného XPath
  do syntetizovaného řádku bankovního výpisu (vlastní účet / IBAN / měna napevno v kódu); připojení
  idempotenčního klíče odvozeného ze zprávy; opětovné využití manuální cesty bankovního importu pro
  vytvoření nebo párování Transakce.
- Protiúčty vypořádání ComGate se směrují na **párování existujících** Transakcí (označení data
  banky + sent-to-bank); jinak se zpráva zpracuje jako **nový dar banka-banka** zaúčtovaný na
  transparentní účet. Heuristika opakované platby může transakci označit jako opakovaný dar. Viz
  EN0009.

## Vedlejší efekty

- Nová uhrazená (PAID) Transakce (banka-banka) nebo párování existující Transakce/Transakcí; jeden
  auditní řádek e-mailu na každou zpracovanou zprávu; zpráva je označena jako přečtená (Seen) pouze
  v produkci a pouze pokud nezůstává ponechána k opakovanému pokusu.
- Uložení Transakce spustí kaskádu PAID daru (FN0007): děkovná zpráva (MSG0019 přes FN0019),
  zařazení do fronty pro vyhledávací index (→ JOB0013), přepočet příběhu (campaign recompute),
  rozdělení přeplatku.
- Napříč systémy: čtení/označování IMAP schránky (ES0005); napevno zakódované Slack webhooky pro
  platby/dary; provozní Telegram alerty (FN0023).

## Idempotence

- **Deduplikace podle message-id** (předběžná kontrola + vyhození výjimky při unikátnosti při
  ukládání entity). Idempotenční klíč je odvozen z IMAP message-id, jehož stabilita je nejistá
  (`Partial` — slabší deduplikace).
- Zprávy nepřiřazené k ComGate jsou záměrně ponechány jako nepřečtené (Unseen) pro opakovaný pokus
  při dalším pollu.

## Ošetření chyb

- Chyba autentizace IMAP nevede k předčasnému přerušení; následné volání schránky na falsy
  spojení může skončit fatální chybou (tiché zaseknutí importu).
- Jakákoli výjimka na úrovni zprávy je zalogována a **znovu vyhozena (re-thrown)**, což přeruší
  celou dávku pollu; zprávy, které v rámci téhož běhu už byly označeny jako přečtené nebo uložené,
  se nevrací zpět (částečná dávka).
- Nestabilní parsování pevným XPath: změna bankovní šablony vede k prázdným polím, ale Transakce
  může být přesto vytvořena. Zdokumentované current-state riziko (FLW0012).

## Odkazy

- FN: FN0012, FN0007, FN0019
- UC: UC0008
- EN: EN0009, EN0004
- ES: ES0005
- MSG: MSG0019 (poděkování za dar)
- Evidence: FLW0012

## Otevřené body

- Přesný IMAP hostitel a sémantika message-id použitého jako idempotenční klíč nejsou ve
  scrubbed zdroji obsaženy. `Hypothesis` / `Partial`.
