---
doc_id: UC0020
title: Emit Ops Alerts & Audit
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0020 — Odesílání provozních upozornění a auditu

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0020 |
| Název | Emit Ops Alerts & Audit |
| Bounded Context | C11 |
| Primární aktér(i) | Systém |
| Typ spouštění | Listener |

## Aktéři a odpovědnosti

- **Systém** — detekuje provozní stav, který stojí za upozornění pro provozní tým (chybu, anomálii v konzistenci dat nebo pozoruhodnou obchodní událost), a směruje jej do nakonfigurovaného alertovacího kanálu (kanálů); odděleně předává záznamy o výsledku/auditu do vyhledávacího indexu / auditního úložiště.
- **Integration(Slack)** — přijímá provozní a obchodně-událostní alertovací zprávy zveřejňované do kanálu.
- **Integration(Telegram)** — přijímá provozní chybové/alertovací zprávy zveřejňované do kanálu.
- **Integration(Elasticsearch)** — přijímá indexované záznamy, které tvoří trvalou auditní/vyhledávací stopu.

## Záměr

Poskytnout provoznímu týmu téměř real-time viditelnost chybových stavů a vybraných obchodních událostí probíhajících jinde na platformě a uchovávat trvalou, prohledávatelnou auditní stopu zpracovaných záznamů, bez nutnosti jakékoli interakce s uživatelským rozhraním.

## Předpoklady

- Je nakonfigurován a dostupný logovací/alertovací kanál (Slack kanál a/nebo Telegram kanál).
- Je nakonfigurován a dostupný indexovací/auditní sink (Elasticsearch).
- Nějaký jiný use case na platformě vyprodukoval logovatelnou událost (chybu, anomálii nebo pozoruhodnou změnu stavu), kterou tento listener kanál zachytí.

## Hlavní tok

### UC0020.1 — Rozeslání provozních upozornění (Slack / Telegram)
1. Systém: detekuje logovatelný provozní stav (např. chybu, selhaný dávkový krok nebo označenou anomálii) vyvolaný jiným procesem.
2. Systém: naformátuje daný stav do alertovací zprávy.
3. Integration(Slack): přijme alertovací zprávu na nakonfigurovaném kanálu.
4. Integration(Telegram): přijme alertovací zprávu na nakonfigurovaném kanálu.

### UC0020.2 — Indexování auditní stopy
1. Systém: přijme záznam (změnu entity nebo zpracovanou položku) určený pro auditní/vyhledávací stopu.
2. Integration(Elasticsearch): uloží záznam tak, aby byl dohledatelný pro účely auditu a vyhledávání.

## Alternativní toky

### AF1 — Alertovací kanál nedostupný
1. Systém: pokusí se doručit alert do Slacku nebo Telegramu a doručení selže nebo kanál není nakonfigurován.

Výsledek: doručení je best-effort (FLW0034) — neúspěšný POST je pouze zalogován sám o sobě a alert je ztracen; neexistuje žádná fronta, opakování, backoff ani dead-letter. Pokud konfigurace Slacku/Telegramu chybí, `log()` se vrátí bez odeslání a bez jakékoli chyby (alertování tak může být tiše vypnuté). Synchronní odchozí POST nemá žádné přepsání timeoutu, takže pomalý/nedostupný kanál může zablokovat vysílající request/cron cestu.

## Postpodmínky

- Provozní upozornění bylo odesláno do nakonfigurovaného kanálu (kanálů) (Slack a/nebo Telegram), pokud doručení uspělo.
- V auditním/vyhledávacím úložišti (Elasticsearch) existuje odpovídající záznam, pokud indexování uspělo.
- Tímto use case není vytvořena, přecházena ani vlastněna žádná doménová entita — jde o průřezový vedlejší efekt jiných use case.

## Sledovatelnost (Traceability)

Cílové SRV:
- Ops-Logging-Adapters
- Elasticsearch-Adapter

EN entity:
- (žádná — infrastrukturní UC; nevlastní žádnou doménovou entitu)

Integrační hranice:
- Slack
- Telegram
- Elasticsearch

Evidence toků (Flow Evidence):
- FLW0034 (vytěženo; dříve flow-index FL059) — kanály provozního loggeru (`logger.slack` / `logger.telegram`): pasivní sink log-pipeline pro záznamy ERROR/CRITICAL plus ~48 přímých míst vynuceného volání alertu; pokrývá UC0020.1 (rozeslání provozních upozornění) a AF1 (selhání doručení = best-effort, alert ztracen).
- FLW0032 / ES-audit (+ES audit) — dílčí tok indexování auditní stopy (UC0020.2) jede po ploše vyhledávacího indexu / Elasticsearch; FLW0034 samo o sobě indexování ES auditu nepokrývá.

## Úroveň evidence

Confirmed pro rozeslání provozních upozornění (UC0020.1) a jeho chování při selhání doručení (AF1), nyní když je vytěžen tok provozního loggeru (FLW0034): Slack směruje ERROR→errors-webhook / CRITICAL→checks-webhook (EMERGENCY/ALERT se zahazují), Telegram odesílá všechny propuštěné úrovně do jednoho bot chatu; doručení je synchronní, best-effort, bez opakování/fronty (`slack_queue` je vytvořena, ale nikdy se nepoužije). Vytěžená current-state fakta přenesená dále: `sendMessageToZoneChannel()` je prázdný no-op, který tiše zahazuje ~25 signálů z activity feedu; PII mohou být interpolována do odchozích alertů; přímé `->log(3,…)` natvrdo nastavuje úroveň ERROR pro rutinní oznámení (alert fatigue). Dílčí tok indexování auditní stopy (UC0020.2) zůstává Partial — není pokryt FLW0034 a závisí na auditní ploše Elasticsearch.
