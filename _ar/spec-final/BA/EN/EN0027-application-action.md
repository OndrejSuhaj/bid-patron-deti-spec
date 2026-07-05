---
doc_id: EN0027
title: ApplicationAction
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0001  # Application (transitioned by the action)
  - EN0008  # User (owner)
  - BR-ApplicationStatusGovernance  # automatic-transition eligibility, contract, and enforcement scope
  - UC0002  # Orchestrate Application Status Change (UC0002.3 — scheduler-driven automatic transition)
---

# EN0027 — ApplicationAction

## Účel

ApplicationAction je konfigurační záznam, který definuje pravidlo automatického, časově řízeného
přechodu stavu pro žádosti (EN0001). Vyjadřuje: ve kterém výchozím stavu se žádost musí nacházet,
jak dlouho v něm musí setrvávat, do kterého cílového stavu se má přesunout — a volitelně také
doplňkovou pojmenovanou akci, která se má spustit společně s přechodem. Nedrží žádný stav vázaný na
konkrétní žádost; jde o definici pravidla, nikoli o záznam případu. Řídící smlouvu automatických
přechodů viz BR-ApplicationStatusGovernance.

## Životní cyklus

- Active — pravidlo je aktivní a je způsobilé k vyhodnocení.
- Inactive — pravidlo je deaktivované a nevyhodnocuje se.

Samotný záznam ApplicationAction neprochází žádným doménovým životním cyklem nad rámec tohoto
příznaku active/inactive; vytvářejí a upravují jej administrátoři. Tím, co skutečně přechází, je
*žádost*, na kterou pravidlo cílí (viz EN0001) — záznam pravidla není subjektem přechodu, který
definuje.

## Přechody stavů

Active ↔ Inactive
trigger: administrativní změna konfigurace (pro povolení/zakázání pravidla nebyl identifikován
žádný dedikovaný UC; viz Otevřené otázky níže).

N/A — přechod žádosti řízený tímto pravidlem:
trigger: UC0002.3 (Orchestrate Application Status Change — plánovačem řízený automatický přechod
stavu). Pokud je pravidlo Active a jeho iniciátor je typu scheduled a odpovídající žádost (EN0001)
splňuje podmínky (viz Invarianty), UC0002.3 přesune tuto žádost z výchozího stavu pravidla do jeho
cílového stavu, přiřazeno systémovému servisnímu účtu, a znovu vstupuje do sdílené smlouvy o změně
stavu (UC0002.1 a dále).

## Atributy

### Systémově spravované atributy

- Vlastník (odkaz na EN0008 – User; systémově spravovaný; výchozí hodnota je aktuální uživatel
  při vytvoření)
- Název (řetězec; systémově spravovaný popisek pravidla)
- Časová razítka Created / Changed (systémově spravovaná)

### Uživatelem zadávané atributy

- Iniciátor (výčtový typ; povinný; hodnoty: scheduled / patron / fundraiser — procesem
  automatického přechodu je vyhodnocován pouze typ scheduled; ostatní dva viz Otevřené otázky)
- Výchozí stav (výčtový typ, vícehodnotový; povinný; stav žádosti, který pravidlo sleduje)
- Cílový stav (výčtový typ; volitelný; stav, do kterého je způsobilá žádost přesunuta)
- Rozhraní relace (výčtový typ; povinný; hodnoty: any / default / custom / upload_contract /
  upload_gift_proof / upload_feedback / authenticated / new_patron / invited)
- Časový práh (řetězec; volitelný; minimální doba, po kterou musí žádost setrvat ve výchozím
  stavu, než se stane způsobilou)
- Doplňková akce (výčtový typ, vícehodnotový; volitelný; pojmenovává doplňkovou akci, která se má
  spustit vůči způsobilé žádosti; aktuálně je vynucována pouze jedna pojmenovaná akce — odebrání
  dat patrona; viz Otevřené otázky)
- Příznak Active (booleovský; povinný; výchozí hodnota true; povoluje nebo zakazuje pravidlo)

## Invarianty

- Procesem automatického přechodu je vyhodnocováno pouze aktivní pravidlo (Active), jehož
  iniciátor je typu scheduled (viz BR-ApplicationStatusGovernance, „Automatic (scheduled)
  transitions").
- Žádost se stává způsobilou pro přechod definovaný tímto pravidlem až poté, co ve výchozím stavu
  pravidla setrvala déle, než je jeho časový práh (viz BR-ApplicationStatusGovernance).
- Přechod vyvolaný tímto pravidlem se řídí stejnou smlouvou o změně stavu a stejnými vedlejšími
  účinky jako změna iniciovaná člověkem, přiřazená systémovému servisnímu účtu (viz
  BR-ApplicationStatusGovernance; UC0002.1).
- Z konfigurovaných doplňkových akcí je aktuální vynucování omezeno na akci odebrání patrona;
  ostatní konfigurované názvy akcí nejsou v současnosti vynucovány (viz
  BR-ApplicationStatusGovernance).

## Vztahy

- EN0001 – Application (entita, jejíž stav toto pravidlo přechází; pravidlo čte aktuální stav
  žádosti a v případě způsobilosti nastavuje její cílový stav)
- EN0008 – User (vlastník konfiguračního záznamu)

## Otevřené otázky

1. Vynucována je pouze doplňková akce odebrání patrona, přestože atribut doplňkové akce umožňuje
   více hodnot — jsou ostatní konfigurované názvy akcí tiše no-op, nebo je vynucování neúplné?
   (Přenášeno dále — Uncertain.)
2. Hodnoty iniciátora patron a fundraiser jsou konfigurovatelné, ale automaticky je vyhodnocován
   prokazatelně pouze iniciátor scheduled — existuje nějaký aktuální konzument
   non-scheduled iniciátorů, nebo jde o nepoužívané konfigurační možnosti? (Přenášeno dále —
   Uncertain.)
3. Výchozí stav je vícehodnotový, ale u vyhodnocování způsobilosti není potvrzeno, zda podporuje
   shodu proti více než jedné konfigurované hodnotě stavu současně pro jednu žádost — je třeba
   potvrdit sémantiku shody jednoho stavu vs. více stavů. (Přenášeno dále — Uncertain.)
4. Nebyl identifikován žádný UC řídící administrativní vytvoření/úpravu/povolení/zakázání
   samotného pravidla ApplicationAction (na rozdíl od UC0002.3, který řídí přechod žádosti, jenž
   pravidlo vyvolává) — Missing evidence.
