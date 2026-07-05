---
doc_id: ES0015
title: Slack
layer: ES
spec_type: external-system
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0023
  - FN0007
  - UC0020
---

# ES0015 – Slack

## Účel

Slack je externí kanál pro týmovou komunikaci využívaný výhradně pro interní odchozí notifikace: dává
provoznímu týmu téměř real-time přehled o chybových a stavových podmínkách vznikajících jinde v
platformě a — na samostatné platební cestě kódu — přijímá obchodní upozornění (pingy) k daru /
nákupu dárkového poukazu. Jde o jednu ze dvou hranic provozního alertingu v integrační mapě
(ARCH0001 §5, řádek 15).

---

## Přehled systému

Slack je platforma pro týmovou komunikaci. Na této integrační hranici funguje čistě jako příjemce
příchozích webhook požadavků směřovaných do provozních kanálů — není adresován pro žádný účel
zaměřený na uživatele ani pro transakční účely, pouze pro interní provozní alerting.

---

## Integrační model

Pouze odchozí, prostřednictvím příchozích (incoming) webhooků, ve dvou odlišných režimech:

- **Kanál loggeru provozních alertů** (UC0020, FN0023): logovací kanál přeposílá zprávy, jakmile
  logovaná podmínka dosáhne závažnosti ERROR nebo CRITICAL, směrované do samostatných kanálů pro
  chyby a kontroly. Cíle webhooků jsou dodávány konfigurací nasazení (nejsou zabudovány v kódu).
- **Obchodní upozornění (ping)** (FN0007; FLW0003 / FLW0005 / FLW0007): při úspěšné platbě daru nebo
  nákupu dárkového poukazu je odesláno potvrzující upozornění na cíl webhooku zabudovaný v platební
  cestě kódu (natvrdo zakódovaný), omezené pouze na CZ tenanta v produkci.

Obě jsou vedlejší efekty typu „best-effort" zabudované do jiných toků, nejde o vyhrazené
request-response výměny. To odpovídá řetězci posluchačů provozního alertingu / auditu v ARCH0002
(Slack vedle Telegramu).

---

## Výměna dat

- Pouze odchozí. Režim 1: zprávy provozního chybového / stavového alertu (závažnost ERROR/CRITICAL).
  Režim 2: potvrzující upozornění k daru / nákupu dárkového poukazu.
- Pouze koncepční obsah orientovaný na provoz a obchodní události — nejde o zprávy zaměřené na
  uživatele / transakční zprávy ani o doménová data. Detail payloadu ani úrovně polí zde není
  definován.

---

## Omezení

- Doručení je typu „best-effort": neúspěšné odeslání způsobí pouze ztrátu notifikace — neovlivňuje
  výsledek procesu, ze kterého vzniklo.
- Souběžně existují dva konfigurační přístupy: cíle webhooků kanálu loggeru provozních alertů
  pocházejí z konfigurace nasazení, zatímco upozornění k daru / nákupu dárkového poukazu používá cíl
  webhooku natvrdo zakódovaný v platební cestě kódu (FLW0003 / FLW0005 / FLW0007) — riziko
  provázanosti na dodavatele / rotace. Tok posluchače provozních alertů je nyní zmapován (FLW0034) —
  Confirmed pro fan-out; dílčí tok ES auditu zůstává Partial (HS16) (ARCH0001 §5 řádek 15).
- Varování o desynchronizaci Žádost↔Kampaň (INV04) **není** přenášeno přes Slack: DOMAIN-kernel a
  CONSISTENCY-boundaries (vlastníci INV04) je evidují jako výhradně telegramové (viz ES0016). ARCH0001
  §5 řádek 15 a ARCH0002 seskupují Slack + Telegram dohromady pro provozní alerting obecně, avšak
  kanál specifický pro desynchronizaci je Telegram. **Conflict — requires clarification** (ARCH vs.
  DOMAIN/CONSISTENCY), označeno pro cross-layer audit.
- Pouze provozní chybový alerting + upozornění k daru/poukazu — odlišné od transakčních zpráv pro
  uživatele (Mautic / vrstva MSG). Seskupeno s Telegramem do klastru provozního alertingu (FN0023),
  ale jde o samostatnou hranici dodavatele.
- Pouze současný stav; tato omezení odrážejí systém tak, jak je implementován, nikoli cílový návrh.
