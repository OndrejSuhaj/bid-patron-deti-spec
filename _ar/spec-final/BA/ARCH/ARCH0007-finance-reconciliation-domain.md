---
doc_id: ARCH0007
title: Finance & Reconciliation Domain
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - EN0029
  - EN0030
  - EN0031
  - EN0032
  - UC0008
  - UC0017
  - FN0012
  - FN0020
  - ES0004
  - ES0005
  - BR-BankReconciliationAndMatching
  - BR-ReportingAndDataAccess
  - BR-MultiTenantCountryScoping
---

# ARCH0007 – Doména Finance a párování plateb

> Navigační dokument domény pro ohraničený kontext **C5 Finance & Reconciliation** (ARCH0001 §4).
> Pouze navigační vrstva — odkazuje na hlubší artefakty pomocí `doc_id`, neopakuje jejich obsah. Current-state.

## Účel

Vysvětluje architektonický pohled na **back-office párování plateb a reporting**: jak jsou bankovní a
brány kredity párovány s transakcemi a zaúčtovávány, a jak vzniká read-model pro reporting a dávkové
CSV exporty. Jde o dávkový/back-office protějšek request-driven peněžního hubu (C4).

---

## Přehled systému

C5 provozuje cron/CLI řízené párování plateb ze tří CZ zdrojů (dotaz na bankovní AISP, import e-mailů
s bankovním avízem a synchronizace vypořádání platební brány), z nichž kterýkoli může vytvořit nebo
označit transakce jako PAID, které se poté vrací zpět do peněžního hubu C4
([ARCH0001](../ARCH0001_ApplicationOverview.md) §5, §7; ARCH0002 §(b)). Doména dále vlastní read-model
pro reporting a denní dávkový CSV export. Kontext je **pouze pro CZ** (neběží pro RO/MD) a každá větev
párování je křehká jiným způsobem (tichy přeskočený den, drift při parsování fixního HTML formátu,
párování vypořádání omezené počtem řádků — ARCH0001 §5). CSV export zapisuje nešifrovaná osobní data
(PII) do lokálních dočasných souborů bez rozlišení dle země (ARCH0001 §8 Riziko 4).

---

## Strukturální komponenty

- **Bank-Reconciliation + Reconciliation-Processor** (doménová služba + asynchronní procesor) —
  párování a zaúčtování napříč třemi CZ zdroji. Capability:
  [FN0012](../FN/FN0012_BankGatewayReconciliation.md).
- **Reporting-ReadModel + CSV-Export-Processor** (doménová služba + asynchronní procesor) — dashboardy
  a denní CSV dávka. Capability: [FN0020](../FN/FN0020_ReportingCsvExport.md).
- **Adaptéry zdrojů pro párování plateb** (integrační adaptéry) — feed bankovního AISP, inbox
  bankovních avíz a synchronizace vypořádání platební brány (třetí zdroj je režim vypořádání CZ
  platební brány ES).
- **Rezidentní agregáty / read-modely** — AG12 BankTransactionMail
  ([EN0029](../EN/EN0029_BankTransactionMail.md), audit importu avíz), AG13 ComgateBankReconciliation
  ([EN0030](../EN/EN0030_ComgateBankReconciliation.md), záznam vypořádání); read-modely CostsSnapshot
  ([EN0031](../EN/EN0031_CostsSnapshot.md)) a ReportSnapshot ([EN0032](../EN/EN0032_ReportSnapshot.md)).

---

## Interakční model

Dle [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(b):

- Cron/CLI čerpá data z externích CZ zdrojů: bankovní AISP feed ([ES0004](../ES/ES0004_Moneta.md)) a
  inbox bankovních avíz klienta ([ES0005](../ES/ES0005_ImapBankNotificationInbox.md)); třetím zdrojem
  je režim vypořádání CZ platební brány ES (ES0001) — vše se sbíhá do
  [UC0008](../UC/UC0008_ReconcileBankTransactions.md).
- Záznamy vzniklé párováním plateb, označené jako uhrazené, proudí do **C4** (peněžní hub) a tím dále
  do dokončení kampaně v **C3** — stejná kaskáda PAID (ARCH0002 řetězec A).
- Reporting čte napříč entitami mnoha domén (transakce, žádosti, profily, kontakty, kampaně, smlouvy),
  aby sestavil CSV dávku ([UC0017](../UC/UC0017_ExportReportingData.md)); je pouze pro čtení a
  nemění žádný stav domény.
- Cílem CSV exportu je lokální souborový systém, nikoli externí systém.

---

## Cross-links

- **relatedEN:** EN0029, EN0030, EN0031, EN0032
- **relatedUC:** UC0008, UC0017
- **relatedFN:** FN0012, FN0020
- **relatedES:** ES0004 (Moneta), ES0005 (IMAP inbox bankovních avíz); režim vypořádání platební brány je ES0001 (vlastněn C4)
- **relatedMSG:** (žádné — párování plateb produkující stav PAID znovu využívá zprávy o darech z C4)
- **relatedBR:** BR-BankReconciliationAndMatching
  ([../BR/BR-BankReconciliationAndMatching.md](../BR/BR-BankReconciliationAndMatching.md)),
  BR-ReportingAndDataAccess ([../BR/BR-ReportingAndDataAccess.md](../BR/BR-ReportingAndDataAccess.md)),
  BR-MultiTenantCountryScoping ([../BR/BR-MultiTenantCountryScoping.md](../BR/BR-MultiTenantCountryScoping.md))
