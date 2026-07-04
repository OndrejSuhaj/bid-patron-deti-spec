---
doc_id: ARCH0012
title: Platform, Search & Operations Domain
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - UC0018
  - UC0020
  - UC0022
  - FN0022
  - FN0023
  - FN0025
  - FN0026
  - ES0014
  - ES0015
  - ES0016
  - BR-SearchIndexingConsistency
  - BR-OperationalAlerting
  - BR-ApplicationStatusGovernance
---

# ARCH0012 – Doména platformy, vyhledávání a provozu

> Navigační dokument domény pokrývající **dva sloučené ohraničené kontexty (bounded contexts)**: **C10
> Vyhledávání a indexace** a **C11 Platforma / integrační vrstva** (ARCH0001 §4). Pouze navigační
> vrstva — odkazuje na hlubší artefakty pomocí `doc_id`, neopakuje jejich obsah. Current-state.

## Účel

Vysvětluje architektonický pohled na **průřezovou platformní vrstvu**: indexaci pro vyhledávání,
workflow engine a jeho (převážně nevynucovanou) bránu legality přechodů, plánované publikování,
referenční / geografická vyhledávací data a provozní alerting + audit. Žádné z toho není samo o sobě
byznysovou doménou — jde o infrastrukturu, na které byznysové domény stojí.

**Zdůvodnění sloučení.** C10 a C11 jsou oba **tenké / částečně zmapované** kontexty (poznámka ARCH0001
§4; HS16): C10 nevlastní žádný rezidentní agregát a indexuje ostatní agregáty jako vedlejší efekt
ukládání, a C11 rovněž nevlastní žádný rezidentní agregát (pouze referenční/konfigurační entity).
Jejich klíčové toky (synchronizace vyhledávacího indexu, plánované publikování, posluchač provozních
alertů) nebyly nikdy zcela zmapovány. V souladu s pokynem úlohy sloučit skutečně tenké/sousedící
kontexty (vyhledávání + provozní infrastruktura) jsou zde dokumentovány společně jako jedna navigační
plocha platformy/provozu, přičemž každý dílčí kontext zůstává níže identifikovatelný.

---

## Přehled systému

Platformní vrstva poskytuje čtyři schopnosti, o které se opírá každá jiná doména:

- **Indexace pro vyhledávání (C10)** — synchronizace entita → externí index, jedna z mála skutečně
  asynchronních cest, plus denní úplné znovu-odeslání indexu organizace; klíčový synchronizační tok je
  nyní zmapován (FLW0032) — Confirmed; zbytkové Partial pouze u plánování vyprazdňování fronty (drain
  scheduling) ([ARCH0001](../ARCH0001_ApplicationOverview.md) §4, §7; FN0022, HS16).
- **Workflow engine a plánované publikování (C11)** — drží konfiguraci workflow s ~66 stavy a bránu
  přechodu/připravenosti, kterou prochází publikování/zneúplnění, plus tik plánovaného publikování.
  **Zásadní je, že legalita přechodu dnes není na živých formulářích pro změnu z velké části vynucována**
  (ARCH0001 §8; FN0025, HS02) — tato brána je spíše rekonstrukcí cílového tvaru než potvrzeným
  současným chováním.
- **Referenční / geografická data (C11)** — geografická hierarchie ČR a sdílené referenční seznamy
  hodnot používané při zachycení a validaci adresy; nevlastní žádný doménový agregát (FN0026).
- **Provozní alerting a audit (C11)** — best-effort alerting chyb/zdraví do Slacku/Telegramu a úložiště
  auditu požadavků/odpovědí; nevlastní žádnou doménovou entitu a nese alert desynchronizace
  Žádost↔Kampaň (pouze upozornění, bez opravy) (FN0023, HS16).

---

## Strukturální komponenty

- **SearchIndex-Processor + adaptér Elasticsearch** (asynchronní procesor + integrační adaptér, C10) —
  schopnost: [FN0022](../FN/FN0022_SearchIndexing.md).
- **Workflow-Engine + ScheduledPublish-Processor** (orchestrátor + asynchronní procesor, C11) —
  schopnost: [FN0025](../FN/FN0025_WorkflowEngineScheduledPublish.md) (sdíleno se správou stavů C1).
- **Reference-Data** (doménová služba, C11) — schopnost:
  [FN0026](../FN/FN0026_ReferenceDataLookup.md).
- **Ops-Logging-Adapters + úložiště auditu** (integrační adaptéry, C11) — schopnost:
  [FN0023](../FN/FN0023_OperationalAlertingAudit.md).
- **Žádný rezidentní agregát** v žádném z kontextů — C10 indexuje AG1/AG2/AG3/AG8 jako vedlejší efekt;
  C11 drží pouze referenční/konfigurační entity (ApplicationReaction/ApplicationAction jsou navigovány
  z C1; geo/PSČ referenční data nevlastní žádný agregát).

---

## Interakční model

Podle [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(b)/(c):

- **Vyhledávání (C10):** uložení případu/kampaně/transakce/strany v C1/C3/C4/C7 zařadí do fronty
  aktualizaci indexu, kterou worker vyprázdní do Elasticsearch — skutečně asynchronní
  ([UC0018](../UC/UC0018_IndexEntitiesForSearch.md); [ES0014](../ES/ES0014_Elasticsearch.md);
  ARCH0002 §(b)).
- **Workflow / plánované publikování (C11):** cron plánovaného publikování přepíná entity C1/C3 do
  stavu publikováno ([UC0022](../UC/UC0022_RunPlatformWorkflowEngine.md); ARCH0002 §(b)); bránu
  legality/připravenosti využívá publikování/zneúplnění v C3 a změny stavů v C1.
- **Referenční data (C11):** konzultována synchronně při zachycení adresy během podání v C1 a okrajově
  během publikování/validace (FN0026).
- **Provozní alerting (C11):** libovolná chybová/závažná událost z jakékoli domény je best-effort
  přeposlána do Slacku/Telegramu a požadavky jsou zapisovány do úložiště auditu
  ([UC0020](../UC/UC0020_EmitOpsAlertsAudit.md); [ES0015](../ES/ES0015_Slack.md),
  [ES0016](../ES/ES0016_Telegram.md), [ES0014](../ES/ES0014_Elasticsearch.md); ARCH0002 §(c)).

---

## Provazby (cross-links)

- **relatedEN:** (žádná rezidentní — C10/C11 nevlastní žádný agregát; referenční/konfigurační entity
  EN0026/EN0027 jsou navigovány z C1, geo/PSČ referenční data nevlastní žádnou povýšenou EN)
- **relatedUC:** UC0018 (Partial), UC0020 (Partial), UC0022 (Partial)
- **relatedFN:** FN0022, FN0023, FN0025, FN0026
- **relatedES:** ES0014 (Elasticsearch — index + audit + index organizace), ES0015 (Slack),
  ES0016 (Telegram)
- **relatedMSG:** (žádné — provozní alerting výslovně **není** uživatelsky viditelná transakční
  komunikace, MSG-message-map)
- **relatedBR:** BR-SearchIndexingConsistency
  ([../BR/BR-SearchIndexingConsistency.md](../BR/BR-SearchIndexingConsistency.md)),
  BR-OperationalAlerting ([../BR/BR-OperationalAlerting.md](../BR/BR-OperationalAlerting.md)),
  BR-ApplicationStatusGovernance ([../BR/BR-ApplicationStatusGovernance.md](../BR/BR-ApplicationStatusGovernance.md))
  (sdílená problematika legality přechodů, vlastněná C1)

> **Poznámka k pokrytí.** Toto je sloučený domov pro dva nejtenčí kontexty; několik jeho toků
> (FLW0032 synchronizace vyhledávání, FLW0033 plánované publikování, FLW0034 posluchač provozních
> událostí; dříve FL055/FL057/FL059) je nyní zmapováno; mapování je potvrdilo, ale odkrylo zbytkové
> mezery v současném stavu (plánování vyprazdňování fronty, legalita přechodů, audit ES) (zbytkové
> Partial, HS16). Rewrite je musí vyřešit, než bude chování platformní vrstvy možné považovat za
> úplné (ARCH0001 §8 Riziko 5).
