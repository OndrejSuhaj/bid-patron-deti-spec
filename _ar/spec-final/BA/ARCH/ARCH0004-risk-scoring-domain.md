---
doc_id: ARCH0004
title: Risk & Scoring Domain
layer: ARCH
spec_type: architecture
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - EN0016
  - EN0017
  - UC0003
  - FN0004
  - FN0005
  - ES0010
  - ES0011
  - MSG0011
  - BR-ScoringAndRiskGating
---

# ARCH0004 – Doména riziko a scoring

> Navigační dokument domény pro ohraničený kontext **C2 Risk & Scoring** (ARCH0001 §4).
> Pouze navigační vrstva — odkazuje na hlubší artefakty pomocí `doc_id`, neopakuje jejich obsah. Current-state.

## Účel

Vysvětluje architektonický pohled na **rizikovou bránu**: jak je žádost posuzována z hlediska rizika,
skórována pro low-risk rychlou cestu, zařazována na blacklist a identitně/registrově ověřována dříve,
než může postoupit ke smlouvě a stát se veřejným příběhem. Jde o bránu, která chrání záznam případu
(C1) mezi příjmem a publikací.

---

## Přehled systému

C2 provádí manuální scoring rizika plus automatický přepočet low-risk, zaznamenává white/black
klasifikace a ověřuje identitu žadatele vůči českým státním registrům. Jeho **živá scoringová data
fyzicky žijí na záznamu žádosti** (jako připojený JSON); samostatná nosná entita scoringu je
definována, ale nepoužívaná ([EN0017](../EN/EN0017_ScoringRecord.md); ARCH0001 §4). Kontext je
modelován jako samostatný agregát, protože scoring má vlastní příkazové rozhraní a vlastní klasifikační
potomka, přestože jeho živý stav sídlí na záznamu C1.

Zásadní architektonické riziko: schválení scoringu propaguje klasifikaci na odpovídající stranu
(party) prostřednictvím zápisu klíčovaného syrovým e-mailem bez omezení — jde o zápis napříč kontexty
do úložiště Contact v C7 (ARCH0002 §(c); zápisové riziko je HS08).

---

## Strukturální komponenty

- **Scoring-&-Risk** (doménová služba) — manuální skóre, přepočet low-risk `to_check`, vytváření
  blacklistu, klasifikace strany (party). Kapacita: [FN0004](../FN/FN0004_RiskScoringAssessment.md).
- **Registrové / identitní ověřovací adaptéry** (integrační adaptéry) — dvě CZ ověřovací hranice
  seskupené jako jedna kapacita. Kapacita:
  [FN0005](../FN/FN0005_ExternalRegistryVerification.md).
- **Rezidentní agregát AG9 Risk** — kořen ScoringRecord ([EN0017](../EN/EN0017_ScoringRecord.md));
  člen Blacklist ([EN0016](../EN/EN0016_Blacklist.md), klasifikační potomek vyžadující žádost
  (Application)).

---

## Interakční model

Podle [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(c):

- Vyvoláno **synchronně** z rozvětvení stavů (status fan-out) **C1** při `to_check` (přepočet
  low-risk) a ze scoringového workflow ([UC0003](../UC/UC0003_AssessApplicantRisk.md);
  [UC0002](../UC/UC0002_OrchestrateApplicationStatusChange.md)).
- Při schválení zapisuje zpět do **C1** (`scoring_ok`) a do **C7 Party / CRM** (klasifikace Contact,
  klíčovaná syrovým e-mailem, bez LIMIT — ARCH0002 §(c)).
- Volá **synchronně** dva externí české systémy: ARES (obchodní rejstřík) a MVČR (kontrola
  neplatných dokladů) — pouze v rozsahu CZ, bez ekvivalentu pro RO/MD; volání ARES nemá timeout
  (ARCH0002 §(a); [ES0010](../ES/ES0010_Ares.md), [ES0011](../ES/ES0011_Mvcr.md)).
- Zamítnutí scoringu vyvolá zprávu „Application Rejected — Scoring KO" přes C8
  ([MSG0011](../MSG/MSG0011_ApplicationRejectedScoringKo.md)); schválení nezasílá žádný e-mail
  (pouze v zóně).

---

## Provazby (cross-links)

- **relatedEN:** EN0016, EN0017
- **relatedUC:** UC0003 (účastní se UC0002)
- **relatedFN:** FN0004, FN0005
- **relatedES:** ES0010 (ARES), ES0011 (MVČR)
- **relatedMSG:** MSG0011 (zamítnutí scoring-KO; transport vlastní C8)
- **relatedBR:** BR-ScoringAndRiskGating
  ([../BR/BR-ScoringAndRiskGating.md](../BR/BR-ScoringAndRiskGating.md)) — absence jedinečnosti
  identity strany (party), která činí zápis klasifikace rizikovým, je ve vlastnictví C7
  [BR-PartyIdentityAndDeduplication](../BR/BR-PartyIdentityAndDeduplication.md).
