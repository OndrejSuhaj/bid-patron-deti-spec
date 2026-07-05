---
doc_id: FN0006
title: Campaign / Story Lifecycle Management
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0011
  - UC0005
  - UC0006
  - EN0004
  - EN0005
  - EN0021
  - EN0028
  - EN0001
  - BR-CampaignStoryLifecycle
  - FN0007
---

# FN0006 – Správa životního cyklu kampaně / příběhu

## Účel

Spravovat veřejný fundraisingový příběh (Campaign / Příběh, EN0004) vygenerovaný ze schválené žádosti v průběhu
jeho fundraisingového životního cyklu — publikace/aktivace, sledování vybrané částky vůči cílové částce,
automatické dokončení nebo zrušení dokončení při termínu (deadline) — a udržovat jej v souladu s jeho nadřazeným
případem. Jde o schopnost C3 (příběh) uplatňovanou v UC0011.

## Odpovědnosti

- Generovat a publikovat/aktivovat kampaň (EN0004) ze schválené žádosti, podléhající kontrole připravenosti
  k publikaci (publish-readiness gate).
- Přepočítávat průběžnou vybranou částku a procento naplnění cíle na základě uhrazených darů (přičemž spouštění
  sumarizace deleguje na peněžní vedlejší efekty FN0007), a následně automaticky dokončovat příběh nebo rušit jeho
  dokončení při termínu podle pravidel dokončení/zrušení dokončení kampaně (BR-CampaignStoryLifecycle).
- Udržovat veřejný zobrazovací profil patrona (Patron, EN0005), zpětnou vazbu po ukončení kampaně (Feedback,
  EN0021) a auditní log kampaně (CampaignLog, EN0028).
- Udržovat stav/kategorii příběhu synchronizovanou s nadřazenou žádostí (EN0001), přičemž stranu případu deleguje
  na FN0002.

## Související případy užití

UC0011 (primární); účastní se UC0005 / UC0006 jako cíl daru.

## Související entity

EN0004 (kořenová entita), EN0005 / EN0021 / EN0028 (skládané členy), EN0001 (nadřazený případ, provázaný).

## Integrace

Nager.Date (kalendář státních svátků) — využíváno pro pravidlo pracovního dne u termínu (deadline) kampaně
v RO.

## Omezení

- Publikace mění stav kampaně a její žádosti bez obalení do transakce (riziko částečného selhání).
- Synchronizace mezi žádostí a kampaní je obousměrný vedlejší efekt ukládání; zjištěná desynchronizace je hlášena
  formou alertu (Slack / Telegram), ale není automaticky opravena.
- Kontrola pracovního dne pro RO termín je typu fail-open: pokud je Nager.Date nedostupné, datum je považováno za
  pracovní den a pravidlo je tiše obejito.
- Zapisovatel CampaignLog není doložen (Hypothesis); u několika stavů kampaně chybí doložený spouštěč.
