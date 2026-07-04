---
doc_id: ARCH0003
title: Application & Lead Domain
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - EN0001
  - EN0002
  - EN0003
  - EN0025
  - EN0026
  - EN0027
  - UC0001
  - UC0002
  - UC0016
  - UC0019
  - FN0001
  - FN0002
  - FN0003
  - FN0025
  - MSG0001
  - MSG0002
  - MSG0005
  - MSG0006
  - MSG0007
  - MSG0008
  - MSG0009
  - MSG0010
  - MSG0012
  - MSG0017
  - MSG0018
  - MSG0029
  - BR-ApplicationStatusGovernance
---

# ARCH0003 – Doména žádosti a leadu

> Navigační dokument domény pro ohraničený kontext **C1 Application & Lead** (ARCH0001 §4).
> Pouze navigační vrstva — odkazuje na hlubší artefakty pomocí `doc_id` a neopakuje jejich obsah.
> Aktuální stav; celosystémový přehled zůstává v [ARCH0001](../ARCH0001_ApplicationOverview.md) /
> [ARCH0002](../ARCH0002_ContextInteractionMap.md).

## Účel

Vysvětluje architektonický pohled na **záznam případu** — jak požadavek na pomoc dítěti vstupuje do
platformy jako *Lead*, stává se *Žádostí (Application)* a je veden svým vícestavovým workflow. Toto je
páteř celé platformy: téměř každá jiná doména reaguje na změnu stavu žádosti. Viz
[ARCH0001](../ARCH0001_ApplicationOverview.md) §1, proč je záznam případu první ze tří primárních
doménových konceptů.

---

## Přehled systému

C1 vlastní agregát AG1, zakořeněný na žádosti ([EN0001](../EN/EN0001_Application.md) — záznam případu
s jedním stavovým polem zahrnující fázi leadu i žádosti; model s jedním stavovým polem a pojetí leadu
jako fáze příjmu vlastní [EN0001](../EN/EN0001_Application.md) /
[BR-ApplicationStatusGovernance](../BR/BR-ApplicationStatusGovernance.md)). Záznam případu je
těžkotonážním kořenem domény: propojuje profily žadatele/patrona, přístupové relace vázané na roli
a záznam aktivity typu append-only, a je zdrojem stavové události, která se rozšiřuje do rizika,
dokumentů, komunikace a příběhu (ARCH0002 řetězec B).

Charakteristickým architektonickým rysem tohoto kontextu je, že orchestrace stavu je realizována jako
**vedlejší efekt uložení entity**, nikoli jako plnohodnotná služba — hlavní orchestrační bod platformy
([ARCH0001](../ARCH0001_ApplicationOverview.md) §3, §7; ARCH0002 §(c)).

---

## Strukturální komponenty

Konceptuální komponenty rezidentní v tomto kontextu (pouze názvy/role; viz taxonomie SRV v
[ARCH0001](../ARCH0001_ApplicationOverview.md) §3):

- **Application-Lifecycle** (doménová služba) — vytváří a upravuje záznam případu; při odeslání
  zajišťuje vytvoření strany (party). Schopnost: [FN0001](../FN/FN0001_ApplicationIntakeManagement.md).
- **Application-Status-Orchestrator** (orchestrátor) — bod změny stavu, který se rozšiřuje ke třem
  odběratelům (reakce, scoring, notifikace). Schopnost:
  [FN0002](../FN/FN0002_ApplicationStatusOrchestration.md).
- **ApplicationAction-Processor** (asynchronní procesor) — cronem řízené automatické přechody stavu.
  Schopnost: [FN0003](../FN/FN0003_ScheduledStatusTransition.md).
- **Workflow / kontrola legality přechodu** — konfigurace workflow s ~66 stavy a (dnes z velké části
  nevynucovaná) kontrola přechodu/připravenosti. Schopnost:
  [FN0025](../FN/FN0025_WorkflowEngineScheduledPublish.md); sdíleno s C11.
- **Rezidentní agregát AG1 Application** — kořen [EN0001](../EN/EN0001_Application.md); členové
  ApplicationProfile ([EN0002](../EN/EN0002_ApplicationProfile.md), drženy ≤2),
  ApplicationSession ([EN0003](../EN/EN0003_ApplicationSession.md)),
  ApplicationLog ([EN0025](../EN/EN0025_ApplicationLog.md), append-only audit).
- **Referenční entity konfigurace chování** — ApplicationReaction
  ([EN0026](../EN/EN0026_ApplicationReaction.md), pravidla reakce stav×role) a ApplicationAction
  ([EN0027](../EN/EN0027_ApplicationAction.md), pravidla cronových přechodů), čtené během stavového
  rozšíření.

---

## Interakční model

Jak C1 komunikuje se zbytkem systému (dle [ARCH0002](../ARCH0002_ContextInteractionMap.md) řetězce B
a §(a)/(c) — dnes vše synchronní v rámci requestu, pokud není uvedeno jinak):

- Při odeslání volá Application-Lifecycle **C9 Identity & Access** za účelem vytvoření
  User+Contact ([UC0001](../UC/UC0001_SubmitApplication.md); ARCH0002 §(a)).
- Každé uložení žádosti odesílá stavovou událost třem odběratelům: **C2 Risk & Scoring**
  (přepočet při `to_check`), obslužný handler C1 ApplicationReaction (zpráva v zóně / tlačítka /
  životní cyklus relace) a **C8 Messaging** (notifikace)
  ([UC0002](../UC/UC0002_OrchestrateApplicationStatusChange.md); ARCH0002 §(c)).
- Stavový bod dále vytváří smlouvu v **C6 Documents & Fulfilment** ve stavu podpisu a udržuje stav
  v obousměrné synchronizaci s **C3 Campaign & Story** (desynchronizace se pouze hlásí formou
  upozornění, neopravuje se — ARCH0002 §(c)).
- **C6 import faktur z OneDrive** znovu vstupuje do stavového rozšíření, když se připojí k žádosti
  ([UC0019](../UC/UC0019_ImportInvoicesFromOneDrive.md)).
- Deduplikace strany / sloučení leadů se prolíná s **C7 Party / CRM**
  ([UC0016](../UC/UC0016_MaintainPartyRecords.md)).
- Každé uložení žádosti zařazuje aktualizaci indexu **C10 Search** do fronty (skutečně asynchronní —
  ARCH0002 §(b)).
- Žádný externí systém není volán přímo z C1; externí kontakty probíhají přes sesterské domény.

---

## Související artefakty

- **relatedEN:** EN0001, EN0002, EN0003, EN0025, EN0026, EN0027
- **relatedUC:** UC0001, UC0002, UC0016, UC0019
- **relatedFN:** FN0001, FN0002, FN0003, FN0025
- **relatedES:** (žádné — C1 dosahuje na externí systémy pouze přes sesterské domény)
- **relatedMSG:** MSG0001, MSG0002, MSG0005, MSG0006, MSG0007, MSG0008, MSG0009, MSG0010, MSG0012,
  MSG0017, MSG0018, MSG0029 (zprávy o případu řízené stavem a zprávy o dokončení/žádosti o zpětnou
  vazbu přenášené stavovým rozšířením; *přenos* zprávy vlastní C8 /
  [FN0019](../FN/FN0019_TransactionalMessaging.md))
- **relatedBR:** BR-ApplicationStatusGovernance
  ([../BR/BR-ApplicationStatusGovernance.md](../BR/BR-ApplicationStatusGovernance.md)) — pravidla
  vytváření a deduplikace strany vlastní [BR-PartyIdentityAndDeduplication](../BR/BR-PartyIdentityAndDeduplication.md)
  z C7.

> **Navigační poznámka.** Legalita přechodu je sdílenou záležitostí s C11
> ([ARCH0012](ARCH0012_PlatformSearchAndOperations.md)); je zdokumentována jako dnes z velké části
> **nevynucovaná** (HS02) — viz [BR-ApplicationStatusGovernance](../BR/BR-ApplicationStatusGovernance.md).
