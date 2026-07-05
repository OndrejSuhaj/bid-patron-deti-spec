---
doc_id: ES0016
title: Telegram
layer: ES
spec_type: external-system
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0023
  - FN0006
  - UC0020
---

# ES0016 – Telegram

## Účel

Telegram poskytuje provoznímu týmu druhý, nezávislý kanál pro příjem provozních upozornění se
závažností „error“ vyvolaných loggerem platformy — včetně varování o desynchronizaci mezi žádostí a
kampaní — aby chybový stav, který se má zalogovat, nebyl viditelný pouze přes jeden notifikační
kanál (`ARCH0001` §5 řádek 16; `FN0023`).

---

## Přehled systému

Telegram je komunikační (messagingová) platforma. Pro účely této integrace je hranicí platformy vůči
Telegramu jeho Bot API: odchozí zpráva odeslaná do nakonfigurovaného chatu, která se poté zobrazí
jako notifikace komukoli, kdo daný chat sleduje. Patronus nepoužívá Telegram pro žádnou komunikaci
směrem ke koncovému uživateli — slouží pouze jako příjemce provozních upozornění (`ARCH0001` §5
řádek 16).

---

## Model integrace

Pouze odchozí směr. Logger platformy přeposílá záznamy logu se závažností „error“ do nakonfigurovaného
chatu na Telegramu jako vedlejší efekt typu „best-effort, fire-and-forget“ vyvolaný procesem, který
daný stav ke logování způsobil — není součástí vlastní cesty úspěchu/selhání tohoto procesu (`UC0020`,
hlavní tok UC0020.1; `ARCH0002` — řetězec listenerů pro provozní upozornění/audit). Neexistuje žádný
příchozí směr: Telegram do platformy nic neposílá zpět.

---

## Výměna dat

Pouze odchozí směr: zprávy s provozními upozorněními na chybu/závažnost, koncepčně shodné s tím, co je
zasíláno i do provozního kanálu na Slacku — včetně upozornění na desynchronizaci stavu mezi žádostí a
kampaní (`INV04`, neseno omezením „lock-step“ z `FN0006`). Toto je popsáno pouze na úrovni „existuje
upozorňovací zpráva“; obsah zprávy, žádné pole ani detail formátování zde nejsou tvrzeny (`UC0020`).

---

## Omezení

- **Dopad selhání:** doručení typu best-effort — pokud je kanál na Telegramu nedostupný, jediným
  důsledkem je ztráta upozornění; neovlivňuje to výsledek procesu, který upozornění vyvolal
  (`ARCH0001` §5 řádek 16).
- **Pouze upozornění, ne náprava:** upozornění na desynchronizaci mezi žádostí a kampaní (`INV04`),
  které tento kanál přenáší, je notifikací o nekonzistenci, nikoli automatizovanou nápravou této
  nekonzistence.
- **Úroveň evidence:** tok listeneru/rozeslání (fan-out), který tento kanál zásobuje, je nyní
  zmapován (FLW0034) — Confirmed pro fan-out (`Partial` zbytkový stav pouze na dílčím auditním toku
  ES, `HS16`) — chování nad rámec „upozornění se závažností error je sem přeposláno“ není dále
  doloženo.
- **Samostatná hranice dodavatele:** seskupeno se Slackem pod stejným clusterem provozních upozornění
  (`FN0023`), ale jde o samostatnou hranici externího systému oddělenou od Slacku — oba kanály jsou
  alternativní/paralelní příjemci stejné třídy upozornění, nikoli stejnou integrací.
- **Pouze současný stav:** odráží integraci tak, jak je doložena dnes; žádná změna v cílovém stavu
  zde není tvrzena.
