---
doc_id: BR-CampaignRecommendationDormant
title: Campaign Recommendation (Dormant)
canonical_layer: BR
spec_type: business-rule
status: canonical
modules: []
affects:
  - EN0007
  - EN0008
  - EN0004
  - EN0009
  - SYSTEM
references:
  - EN0007
  - EN0008
  - EN0004
  - EN0009
  - UC0021
---

# BR – Doporučování příběhů (neaktivní)

## Účel

Zaznamenává, že subsystém doporučování příběhů je v současném stavu neaktivní, aby ho navazující
vrstvy nepovažovaly za živé chování.

## Neaktivita

- Current-state: subsystém doporučování příběhů SHALL být považován za neaktivní a SHALL NOT
  být brán jako spoléhatelné živé current-state chování.
- Current-state: žádná aktivní cesta neodvozuje, neukládá ani neposkytuje doporučení příběhů
  pro konkrétního uživatele a jakákoli vazba mezi účtem a doporučeným příběhem SHALL NOT být
  považována za aktivní invariant.
- Popis chování doporučování SHALL být čten pouze jako kontrakt typu „would-fire" (viz UC0021),
  nikoli jako pozorovatelné current-state chování.

## Non-Goals

Toto pravidlo nedefinuje, neomezuje ani neschvaluje budoucí algoritmus doporučování, scoringovou
metodu ani cestu k reaktivaci — pouze stanovuje současný neaktivní stav.
