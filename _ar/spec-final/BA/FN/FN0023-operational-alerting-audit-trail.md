---
doc_id: FN0023
title: Operational Alerting & Audit Trail
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0020
---

# FN0023 – Provozní alerting a auditní stopa

## Účel

Poskytovat provoznímu týmu téměř v reálném čase přehled o chybových stavech a vybraných obchodních
událostech, ke kterým dochází jinde v platformě, a udržovat trvalou, prohledávatelnou auditní/request
stopu — bez jakékoli interakce směrem k uživateli. Tato kapacita je průřezový vedlejší efekt vyvolávaný
jinými procesy, nikoli samostatný doménový workflow.

---

## Odpovědnosti

Tato kapacita odpovídá za:

- Detekci logovatelného provozního stavu (chyba, selhaný krok na pozadí, označená anomálie nebo
  významná obchodní událost) vyvolaného jinde v platformě a jeho zformátování do podoby alertové
  zprávy.
- Rozeslání alertu do nakonfigurovaného kanálu (kanálů) Slack a/nebo Telegram s odpovídající
  závažností.
- Předávání výstupních/auditních záznamů — včetně request/response záznamů — do auditního/
  vyhledávacího úložiště, aby zpracované záznamy zůstaly dohledatelné pro účely auditu a vyhledávání.
- Přenášení průřezových alertů konzistence, jako je varování o rozsynchronizování stavu
  Žádost↔Kampaň, do provozního kanálu (kanálů) jako signál typu pouze-alert (nikoli automatizovaná
  oprava).

---

## Související případy užití

UC0020 – Emit Ops Alerts & Audit

---

## Související entity

Žádné — jde o infrastrukturní kapacitu; nevlastní žádnou vlastní doménovou entitu a funguje pouze
jako vedlejší kanál pro události vzniklé v jiných kapacitách.

---

## Integrace

- Slack — provozní chybový/alertový kanál a notifikace o obchodních událostech (např. upozornění na
  dar a nákup dárkového poukazu).
- Telegram — provozní chybový/alertový kanál.
- Elasticsearch — trvalé auditní/vyhledávací úložiště pro request/response a stopy zpracovaných
  záznamů.

(Pro tyto integrace zatím neexistuje samostatný dokument na vrstvě ES; viz ARCH0002_ContextInteractionMap
pro aktuální přehled integrační krajiny.)

---

## Omezení

- Průřezový vedlejší efekt jiných případů užití: tato kapacita nevlastní žádnou doménovou entitu a
  nemá žádný vlastní nezávislý spouštěč — aktivuje se vždy, když jiný proces vyvolá logovatelný stav
  nebo událost. FLW0034 potvrzuje, že jde jak o pasivní logger-channel sink (záznamy ERROR/CRITICAL
  se rozesílají do obou kanálů), tak o aktivně volanou službu (~48 přímých míst vynuceného volání
  alertu `->log(3,…)` napříč kódem plateb/financí/cronu/front).
- Podkladový ops-logger flow (FLW0034, dříve flow-index FL059) je nyní zaminován (Confirmed). Chování
  při selhání doručení je evidováno: neúspěšný POST se pouze samo-loguje a alert je ztracen — neexistuje
  žádná fronta, opakování, backoff ani dead-letter (`slack_queue` je vytvořena, ale nikdy se nepoužívá).
  Pokud konfigurace Slack/Telegram chybí, `log()` se tiše vrátí bez odeslání.
- Doručení alertu je best-effort A ZÁROVEŇ synchronní na hot path: odchozí POST nemá žádné
  přepsání timeoutu, takže pomalý/nedostupný Slack/Telegram může zablokovat vysílající
  request/cron cestu (FLW0034).
- Směrování podle úrovně (FLW0034): Slack směruje ERROR→errors-webhook a CRITICAL→checks-webhook a
  EMERGENCY/ALERT zcela zahazuje; Telegram posílá každou procházející úroveň do jednoho bot chatu.
  Přímí volající `->log(3,…)` mají natvrdo nastavenu úroveň ERROR pro mnoho rutinních provozních
  hlášení → alert-fatigue / ředění signálu.
- `sendMessageToZoneChannel()` (cesta Slack „activity feed", ~25 volacích míst: přihlášení, změny
  profilu / hesla, vytvoření nového leadu, odeslání kontaktního formuláře) je **prázdný no-op** —
  tyto signály se tiše zahazují a do Slacku se nikdy nedostanou (FLW0034).
- Z hranic platformy mohou unikat PII / citlivá data: přímí volající vkládají do zprávy identifikátory
  uživatelů a obchodní data (včetně těl výjimek) před odesláním POST na Slack/Telegram; strip_tags a
  ořezání na 1800 znaků PII neredigují (FLW0034).
- Žádné rozdělení alertů podle tenanta/země (CZ/RO/MD) — chyby ze všech regionů končí ve stejném
  globálním kanálu (kanálech) (FLW0034).
- Na živé cestě ukládání entity existuje natvrdo zapsaný Slack webhook (evidováno v rekonstrukci
  současného stavu) — jde o provozní/architektonickou slabinu současné implementace, nikoli o
  navržený konfigurační mechanismus.
- Alert o rozsynchronizování Žádost↔Kampaň je typu pouze-alert: upozorní provozní tým na
  nekonzistenci, ale sám o sobě stav nesladí ani neopravuje.
