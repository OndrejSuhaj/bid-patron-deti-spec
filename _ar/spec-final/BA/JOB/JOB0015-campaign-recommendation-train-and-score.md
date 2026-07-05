---
doc_id: JOB0015
title: Campaign Recommendation Train and Score Consumers
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: async-consumer
references:
  - FN0024
  - EN0008
  - EN0009
---

# JOB0015 – Trénování a scoring doporučování kampaní (konzumenti)

## Účel

Přetrénovat a přepočítat skóre modelu doporučování kampaní pro daného uživatele („per-user campaign-
recommendation model“) při zaplaceném daru uživatele. Dva zřetězené worker procesy fronty: trénovací
konzument, který natrénuje model uživatele a následně zařadí scoringovou položku, a scoringový
konzument, který vytvoří skóre pro jednotlivé kampaně daného uživatele. Realizuje FN0024 (Doporučování
kampaní).

Klasifikace: **Dormant (neaktivní)** — jde o kontrakt typu „would-fire“ (spustil by se, kdyby byl
aktivní), nikoliv o živé current-state chování (viz Model spouštění).

## Model spouštění

- Asynchronní konzumenti: trénovací fronta (`id="campaign_training_queue"`) a scoringová fronta
  (`id="campaign_scoring_queue"`). Subscriber na aktualizaci transakce zařadí trénovací položku, když
  se Transakce dostane do stavu PAID; trénovací worker následně zařadí scoringovou položku.

- **Neaktivní z několika samostatných důvodů (Confirmed):** vyvolávající dispatch události o
  aktualizaci transakce je zakomentovaný; cronový drain modulu doporučování je zakomentovaný;
  konfigurace modulu / klasifikátoru není aktivní; a úložné pole pro doporučování neexistuje. Žádná
  z obou front není v current state naplňována ani konzumována.

- Evidence: `campaign_recommendation/src/EventSubscriber/CampaignRecommendationSubscriber.php`
  (zařazení do fronty při PAID); `campaign_recommendation/src/Plugin/QueueWorker/CampaignTrainingQueue.php`,
  `CampaignScoringQueue.php`; zakomentovaný `campaign_recommendation_cron`. Dossier: FLW0030; FN0024.

## Rozsah vstupu

- Trénovací položka: id uživatele. Scoringová položka: id uživatele. Viz EN0008, EN0009.

## Pravidla zpracování

- Trénovací konzument: načte uživatele, natrénuje model, uloží, poté zařadí scoringovou položku pro
  téhož uživatele.
- Scoringový konzument: načte uživatele, sestaví predikovaná skóre napříč kandidátní sadou kampaní,
  uloží.

## Vedlejší efekty

- Zápisy do úložiště modelu/skóre uživatele (pokud by byla cesta živá). Žádná externí síťová
  integrace — klasifikace probíhá in-process. Zřetězené zařazení do fronty z trénování → scoring.

## Idempotence

- Opětovné trénování/přepočet skóre uživatele přepíše předchozí model/skóre (idempotentní na úrovni
  uživatele). Doručení je at-least-once přes standardní smyčku claim/delete (pokud by byl drain
  zapojen).

## Ošetření chyb

- Dnes není zapojena žádná drain smyčka, takže runtime chybová semantika není v provozu ověřována.
  Při obnovení platí riziko object-injection deserializace a absence tenant scoping (FN0024).

## Odkazy

- FN: FN0024
- UC: UC0021
- EN: EN0008, EN0009, EN0007, EN0004
- Evidence: FLW0030; recommendation queue workers + subscriber

## Otevřené body

- **Status: Dormant / pouze kontrakt typu „would-fire“.** Dokumentováno pro úplnost a pro plánování
  rebuildu; není součástí potvrzeného current-state chování. Viz také manuální CLI ekvivalenty
  v rodině JOB0022 (train:all / campaign:scoring), které jsou dnes jediným způsobem, jak je model
  v provozu procvičován.
