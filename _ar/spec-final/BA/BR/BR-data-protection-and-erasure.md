---
doc_id: BR-DataProtectionAndErasure
title: Data Protection & GDPR Erasure
canonical_layer: BR
spec_type: business-rule
status: canonical
modules: []
affects:
  - EN0008
  - EN0006
  - EN0001
  - SYSTEM
references:
  - EN0008
  - EN0006
  - EN0001
  - UC0015
---

# BR – Ochrana osobních údajů a výmaz (GDPR)

## Účel

Upravuje výmaz osobních údajů uživatele (party) na základě žádosti o výkon práva na výmaz a
zaznamenává současnou neúplnost tohoto výmazu — včetně efektu anti-erasure re-synchronizace a
problému destruktivního smazání jako vedlejšího efektu, vznikajícího jinde v doméně.

## Rozsah výmazu (současný stav: neúplný)

- Současný stav: u výmazu osobních údajů NELZE předpokládat úplnost — vymazán je pouze přihlašovací
  e-mail a zobrazované jméno uložené na záznamu User daného uživatele (`EN0008`), zatímco pole
  jméno/příjmení a veškeré související osobní údaje případu (`EN0001`) a uživatele (`EN0006`) zůstávají
  nedotčené, bez jakékoli kaskády do těchto záznamů.
- Současný stav: požadavek na smazání kontaktu v marketingovém CRM, vyvolaný jako součást žádosti o
  výmaz, neprovádí vůči marketingovému CRM žádné skutečné odstranění.
- Současný stav: re-synchronizace výmazu zařazená do fronty stejným požadavkem znovu vytvoří nebo
  aktualizuje kontaktní záznam uživatele v marketingovém CRM, přičemž jméno uživatele v něm zůstává
  vyplněné — tím jde proti záměru výmazu, místo aby jej dokončila (anti-erasure riziko).

## Kontrolní mechanismy výmazu (současný stav)

- Současný stav: u akce výmazu NELZE předpokládat, že vyžaduje potvrzení, opětovnou autentizaci nebo
  krok druhého schválení — je řízena pouze oprávněním.
- Současný stav: jakmile je přihlašovací e-mail uživatele úspěšnou žádostí o výmaz vymazán, opakovaná
  žádost o výmaz vůči původní e-mailové adrese již daného uživatele nedokáže dohledat ani znovu
  zacílit.

## Destruktivní smazání jako vedlejší efekt

- Současný stav: u záznamu uživatele (`EN0006`) a jeho vlastnícího User záznamu (`EN0008`) NELZE
  předpokládat, že jsou při odstranění v rámci sloučení duplicit (deduplication merge) vedeny přes
  cestu výmazu — sloučení je maže přímo a nevratně, což představuje GDPR-relevantní smazání probíhající
  jako vedlejší efekt mimo cestu žádosti o výmaz.

## Co není cílem (Non-Goals)

- Toto pravidlo nedefinuje mechaniku sloučení duplicit (deduplication merge), která způsobuje výše
  uvedené destruktivní smazání — viz `BR-PartyIdentityAndDeduplication` (upravuje samotné sloučení).
- Toto pravidlo nedefinuje samotný mechanismus re-synchronizace s marketingovým CRM (zařazování do
  fronty, sestavení payloadu, doručení) — ten spadá pod pravidlo marketingového/analytického relay,
  jakmile bude ustanoveno.
- Toto pravidlo nepředepisuje cílové opravy (kaskádový výmaz, krok potvrzení, funkční mazání v CRM);
  zaznamenává pouze současné chování.
