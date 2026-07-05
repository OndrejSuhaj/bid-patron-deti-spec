---
doc_id: JOB0003
title: Campaign Lifecycle Deadline Sweep
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: scheduler
references:
  - FN0006
  - EN0004
  - EN0001
  - MSG0015
---

# JOB0003 – Průchod cyklem životnosti příběhu podle termínu

## Účel

Projít aktivní Příběhy/kampaně po uplynutí jejich termínu, které nedosáhly cílové částky daru, a
automaticky je převést do nesplněného stavu s notifikací patronů. Job dále spouští diagnostiku
integrity peněz a (za feature flagem) rozmazání obrázků kampaní. Realizuje termínovou větev
FN0006 (Řízení životního cyklu kampaně / příběhu).

Klasifikace: **Confirmed** (termínová větev); automatické dokončení při dosažení cíle **není**
součástí tohoto jobu (viz Otevřené body — žije v cestě uložení entity).

## Model spouštění

- Plánovaný. Běží při každém tiku platformního cronu (hodinově, `0 * * * *`) přes cron hook
  `campaign`.
- Diagnostický a rozmazávací dílčí krok mají další podmínky: diagnostika peněz běží pouze v
  produkci a sama se denně omezuje (throttling) (stavové klíče nasazené na 02:00 / 08:00);
  termínový průchod běží v **každém** prostředí při každém tiku (bez omezení).
- Evidence: `campaign/campaign.module:223` → `campaign/src/CampaignCron.php:15`. Dossier: FLW0022.

## Rozsah vstupu

- Termínový průchod: aktivní Kampaně, jejichž termín je před dneškem a jejichž vybraná celková
  částka je pod cílovou částkou daru (vybráno SQL joinem Žádost→Kampaň). Vrací id žádostí.
- Diagnostika peněz (produkce, denně): všechny kampaně (přepočet vybrané částky vs. uložená
  hodnota) a kampaně, kde vybraná částka překračuje cenu daru.
- Rozmazání (pouze feature flag): až 10 kampaní za persistovaným kurzorem dokončených.

## Pravidla zpracování

- Pro každou žádost po termínu s nedostatečným financováním: nastavit stav na nesplněný s
  aktérem CRM-robot a uložit. Náročná práce probíhá v kaskádě uložení entity, nikoli v samotné
  smyčce.
- Diagnostika peněz pouze upozorňuje (Telegram/Slack) při neshodě — **žádné** zápisy do entit.
- Rozmazání přepisuje soubory obrázků kampaně na disku na místě a regeneruje obrazové styly.

## Vedlejší efekty

- Žádost → nesplněný stav (nová revize + auditní řádek historie stavů); její Kampaň →
  nesplněný status s časovým razítkem, obnovena vybraná celková částka (přes kaskádu uložení).
  Viz EN0001, EN0004.
- Zpráva „nesplněná kampaň" / nedokončená sbírka je zařazena do fronty pro patrony a administrátory
  (MSG0015 přes FN0019 → mailová fronta JOB0014).
- Žádost a Kampaň jsou zařazeny do fronty na reindexaci vyhledávání (→ JOB0013); jsou vyslány
  události změny stavu (fan-out FN0002).
- Provozní diagnostika: upozornění Telegram/Slack (FN0023). Rozmazání: destruktivní přepis
  souborů (podmíněno flagem).
- Zápisy persistovaného stavového kurzoru (throttle klíče, kurzor rozmazání).

## Idempotence

- **Termínový přechod je idempotentní** díky SQL predikátu: jednou překlopená kampaň do
  nesplněného stavu už neodpovídá podmínce `status=active`, takže opakované běhy ji přeskočí.
- Výhrada: odeslání zprávy o nesplněné kampani nemá na této cestě žádnou pojistku „již odesláno",
  takže pokud by byl překlopení stavu a odeslání zprávy někdy odděleno, jsou možné duplicitní
  zprávy (Hypothesis; jednorázový běh je bezpečný). Rozmazání posouvá svůj kurzor i u
  nezapisovatelných souborů (tiché permanentní přeskočení).

## Zpracování chyb

- Vložení do historie stavů je obaleno v try/catch, zalogováno (Telegram) a **znovu vyhozeno**;
  protože termínová smyčka není chráněna po jednotlivých položkách, jedna chybná žádost může
  přerušit celý běh cronu.
- Chyby diagnostiky peněz a rozmazání jsou omezeny na své dílčí kroky.

## Odkazy

- FN: FN0006, FN0002, FN0019, FN0023
- UC: UC0011
- EN: EN0004, EN0001
- MSG: MSG0015 (nesplněná sbírka)
- Evidence: FLW0022

## Otevřené body

- **Korekce rozsahu (Confirmed):** automatické dokončení při vybraná částka ≥ cíl NENÍ
  provedeno tímto jobem; žije v cestě uložení entity Kampaň a spouští se při jakémkoli uložení
  kampaně (vyvoláno platbou). Zaznamenáno, aby rebuild neumístil tuto logiku společně s cronem.
- RO kontroly pracovních dnů / svátků a synchronizace Firebase NEJSOU součástí této cesty
  (mrtvý kód / pouze validační čas). Viz FLW0022 Korekce.
