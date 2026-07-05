---
doc_id: BR-ScoringAndRiskGating
title: Scoring & Risk Gating
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0017
  - EN0016
  - EN0001
  - EN0006
  - EN0002
  - SYSTEM
references:
  - EN0017
  - EN0016
  - EN0001
  - EN0006
  - EN0002
  - UC0003
  - UC0002
---

# BR – Scoring a Risk Gating

## Účel

Upravuje rizikovou bránu (risk gate), kterou musí případ (EN0001) projít: odvozené low-risk skóre,
práh a stavovou bránu pro manuální schválení scoringu, zakládání blacklistu, degradaci externí
verifikace a výsledný zápis klasifikace strany.

## Odvozené low-risk skóre

- Low-risk skóre případu (EN0001) SE MUSÍ přepočítat jako odvozená hodnota vždy, když případ vstoupí
  do stavu kontroly rizika (risk-review), a MUSÍ být zaznamenáno jako nedostupné, pokud chybí
  požadovaná data o aktérovi nebo profilu (EN0002).
- Current-state: low-risk skóre čte vstupy o zaměstnání a úhradě daru z profilu fundraisera (EN0002)
  bez ohledu na to, které straně vstup logicky náleží — jde o zaznamenanou vadu provázání vlastnictví
  (owner-coupling).

## Schválení scoringu a stavová brána

- Schválení scoringu SMÍ nastavit případ (EN0001) do stavu scoring ok pouze tehdy, když je případ
  aktuálně ve stavu scoring kontrola a odeslaný verdikt je approve.
- Koordinátorské low-risk přebití (override) SMÍ nastavit případ (EN0001) do stavu scoring ok pouze
  tehdy, když low-risk skóre dosahuje nebo přesahuje schvalovací práh a případ je ve způsobilém stavu.
- Verdikt scoringu jiný než approve MUSÍ uložit výsledek scoringu (EN0017) a případnou klasifikaci
  blacklistu (EN0016), aniž by se změnil stav případu (EN0001).

## Blacklist a klasifikace strany

- Každý záznam blacklistu (EN0016) MUSÍ být provázán s případem (EN0001), který jej vyvolal.
- Schválení scoringu MUSÍ propagovat výslednou white/black rizikovou klasifikaci do odpovídajícího
  záznamu strany (EN0006).
- Current-state: zápis klasifikace strany do EN0006 je klíčován e-mailovou adresou bez omezení počtu
  ovlivněných záznamů a MUSÍ být považován za zaznamenané riziko — může přepsat klasifikaci
  nesouvisejících stran, které tuto e-mailovou adresu sdílejí.
- Current-state: rozhodnutí scoringu, změna stavu případu a zápis klasifikace strany probíhají napříč
  agregátem případu (EN0001) a úložištěm stran (EN0006) v jednom netransakčním toku.

## Externí verifikace

- Externí verifikace identifikačního dokladu a obchodního rejstříku SE MUSÍ využívat na podporu
  rizikové brány pouze pro zemi CZ; pro země RO nebo MD není poskytována žádná obdobná verifikace.
- Current-state: nedostupnost kterékoli z externích verifikací MUSÍ rizikovou bránu degradovat, nikoli
  ji zablokovat, a vyhledávání v obchodním rejstříku nemá žádný timeout volání.

## Mimo rozsah (Non-Goals)

- Toto pravidlo nedefinuje slovník stavů případu ani úplný životní cyklus stavů případu (EN0001) —
  viz BR-ApplicationStatusGovernance.
- Toto pravidlo nedefinuje jedinečnost identity strany ani deduplikaci; absence jedinečnosti v
  úložišti stran (EN0006), která činí zápis klasifikace klíčovaný e-mailem rizikovým, spadá pod
  BR-PartyIdentityAndDeduplication a zde je pouze referencována.
- Toto pravidlo nepředepisuje cílová (target-state) řešení (transakční rozsah, ohraničený zápis
  klasifikace, timeouty volání); zaznamenává pouze current-state chování.
