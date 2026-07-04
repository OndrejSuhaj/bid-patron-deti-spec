---
doc_id: FN0004
title: Risk Scoring & Assessment
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0003
  - UC0002
  - EN0017
  - EN0016
  - EN0001
  - EN0006
---

# FN0004 – Risk scoring a posouzení

## Účel

Posoudit riziko případu žadatele a vytvořit rizikový verdikt — manuální výsledek scoringu a automatický
skór low-risk — který podmiňuje postup případu (např. do stavu `scoring_ok`) a klasifikuje zúčastněné strany.
Jde o C2 rizikovou schopnost využívanou v UC0003 a opakovaně volanou ze stavové osy (UC0002).

## Odpovědnosti

- Ukládat manuální výsledek scoringu (ScoringRecord, EN0017) pro případ, včetně verdiktu ok/ko.
- Přepočítávat odvozený skór low-risk na Žádosti (EN0001), když případ vstoupí do stavu rizikové kontroly
  (`to_check`), a podporovat přepsání low-risk skóre koordinátorem.
- Nastavit Žádost do stavu `scoring_ok` pouze ze stavu scoring kontrola v rámci schválení.
- Klasifikovat zúčastněné strany (Kontakt, EN0006) rizikovou klasifikací bílá/černá a vytvářet
  odpovídající záznamy blacklistu (Blacklist, EN0016) vázané na daný případ.
- Delegovat vyhledávání pro ověření identity/registrů na FN0005.

## Související případy užití

UC0003 (primární), UC0002 (větev přepočtu `to_check`).

## Související entity

EN0017 (výsledek scoringu), EN0016 (záznamy blacklistu), EN0001 (případ + přiřazený skór low-risk), EN0006 (klasifikovaná
strana).

## Integrace

Žádné přímé — externí ověření identity/registrů je izolováno ve FN0005.

## Omezení

- Živá data scoringu jsou fyzicky uložena na záznamu Žádosti jako JSON; samostatná entita nesoucí scoring je
  sice definovaná, ale nevyužívaná / nemá doložený zápis (Hypothesis).
- Zápis klasifikace strany je syrová aktualizace klíčovaná e-mailem bez omezení počtu řádků — může přepsat klasifikaci
  u nesouvisejících Kontaktů sdílejících stejný e-mail (riziko napříč agregáty).
- Zápisy scoringu, stavu případu a klasifikace strany probíhají napříč agregáty v rámci jednoho netransakčního toku.
