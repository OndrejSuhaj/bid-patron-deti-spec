---
doc_id: ARCH0005
title: Campaign & Story Domain
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - EN0004
  - EN0005
  - EN0021
  - EN0028
  - UC0011
  - UC0021
  - FN0006
  - FN0024
  - ES0012
  - MSG0013
  - MSG0014
  - MSG0015
  - MSG0016
  - MSG0030
  - BR-CampaignStoryLifecycle
  - BR-CampaignRecommendationDormant
---

# ARCH0005 – Doména kampaně a příběhu

> Navigační dokument domény pro ohraničený kontext **C3 Kampaň a příběh** (ARCH0001 §4).
> Pouze navigační vrstva — odkazuje na hlubší artefakty pomocí `doc_id`, neopakuje jejich obsah. Current-state.

## Účel

Vysvětluje architektonický pohled na **veřejný fundraisingový příběh (Příběh)**: jak se ze schválené
žádosti stane veřejná kampaň, která nese cílovou částku, průběžně vybranou celkovou sumu, termín
a fundraisingový životní cyklus — a jak se naplní, přestane být naplněná nebo je zrušena. Dále pokrývá
**dormantní** (neaktivní) subsystém doporučování kampaní, který je v kódu přítomen, ale dnes je nečinný.

---

## Přehled systému

C3 vlastní životní cyklus kampaně/příběhu (stavy a přechody vlastní [EN0004](../EN/EN0004_Campaign.md)).
Kampaň je v poměru 1:1 se svou vlastnící žádostí (C1) a je s ní udržována ve stavové synchronizaci;
vybraná celková částka je odvozená suma uhrazených darů, která žije v C4 ([EN0004](../EN/EN0004_Campaign.md);
ARCH0001 §4). Kontext dále hostuje veřejný zobrazovací profil patrona, zpětnou vazbu po skončení
kampaně a audit log kampaně.

Vystupují dva architektonické rysy: publikace přechází stavem u Kampaně **i** u její Žádosti bez
transakce (riziko částečného selhání) a kontrola pracovního dne u RO termínu je **fail-open**
vůči externímu kalendáři svátků ([ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)). Subsystém
doporučování je dormantní z pěti nezávislých důvodů — jde o rozhodnutí zrušit/přebudovat, nikoli
o živé chování (ARCH0001 §8 Risk 5).

---

## Strukturální komponenty

- **Campaign-&-Story-Lifecycle** (doménová služba) — generování/publikace/dokončení/zrušení dokončení
  příběhu, úprava veřejného profilu patrona, tvorba zpětné vazby. Kapacita:
  [FN0006](../FN/FN0006_CampaignStoryLifecycle.md).
- **CampaignRecommendation-Processor** (asynchronní procesor, **dormantní**) — měl by hodnotit/doporučovat
  kampaně; dnes nečinný. Kapacita: [FN0024](../FN/FN0024_CampaignRecommendation.md).
- **Rezidentní agregát AG2 Campaign** — kořen [EN0004](../EN/EN0004_Campaign.md); členy jsou veřejný
  profil Patrona ([EN0005](../EN/EN0005_Patron.md), ≤1), Feedback
  ([EN0021](../EN/EN0021_Feedback.md)), CampaignLog ([EN0028](../EN/EN0028_CampaignLog.md), auditní
  potomek; zapisovatel nedoložen).

---

## Model interakcí

Podle [ARCH0002](../ARCH0002_ContextInteractionMap.md):

- Publikace přechází stavem Kampaně **a** zapisuje zpět do **C1** (Žádost → `active`); dokončení
  a zrušení dokončení stejně tak společně mění stav Žádosti, vše bez obalení transakcí
  ([UC0011](../UC/UC0011_ManageCampaignStoryLifecycle.md); ARCH0002 §(a)/(c)).
- Slouží jako **cíl daru** pro **C4 Dary a platby**: peněžní centrum přepočítává vybranou celkovou
  částku na Kampani a automaticky ji dokončí, jakmile vybraná částka ≥ cíl (ARCH0002 řetězec A).
- Synchronně volá **Nager.Date** kvůli pravidlu pracovního dne pro RO termín — fail-open
  ([ES0012](../ES/ES0012_NagerDate.md); ARCH0002 §(a)).
- Vysílá zprávy o životním cyklu příběhu přes **C8** (publikováno / sbírka úspěšná / nenaplněno /
  zrušeno / poděkování dárci) a alert o desynchronizaci přes **C11** provozní alerting.
- **Dormantní** cesta doporučování by konzumovala C4 PAID event a zapisovala do Účtu v C7 —
  dnes nečinná (ARCH0002 §(c); [UC0021](../UC/UC0021_RecommendCampaigns.md)).

---

## Provázání (cross-links)

- **relatedEN:** EN0004, EN0005, EN0021, EN0028
- **relatedUC:** UC0011, UC0021 (dormantní)
- **relatedFN:** FN0006, FN0024 (dormantní)
- **relatedES:** ES0012 (Nager.Date)
- **relatedMSG:** MSG0013, MSG0014, MSG0015, MSG0016, MSG0030 (životní cyklus příběhu a stav po skončení kampaně; přenos vlastní C8)
- **relatedBR:** BR-CampaignStoryLifecycle
  ([../BR/BR-CampaignStoryLifecycle.md](../BR/BR-CampaignStoryLifecycle.md)),
  BR-CampaignRecommendationDormant
  ([../BR/BR-CampaignRecommendationDormant.md](../BR/BR-CampaignRecommendationDormant.md))

---

## Otevřené otázky

- Zapisovatel CampaignLogu není doložen — `Hypothesis`
  ([DOMAIN-aggregates](../DOMAIN-aggregates.md) AG2 / §5).
- Subsystém doporučování je zde navigovatelný, ale je všude označen jako dormantní; přepis vyžaduje
  explicitní rozhodnutí zrušit/přebudovat dříve, než bude považován za současné chování (ARCH0001 §8 Risk 5).
