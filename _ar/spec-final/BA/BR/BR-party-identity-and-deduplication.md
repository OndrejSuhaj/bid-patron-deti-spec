---
doc_id: BR-PartyIdentityAndDeduplication
title: Party Identity, Uniqueness & Deduplication / Merge
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0006
  - EN0008
  - EN0018
  - EN0001
  - EN0002
  - UC0016
  - SYSTEM
references:
  - EN0006
  - EN0008
  - EN0018
  - EN0001
  - EN0002
  - UC0016
  - UC0001
---

# BR – Identita subjektu, jedinečnost a deduplikace / sloučení

## Účel

Upravuje identitu subjektu (party) napříč univerzálním úložištěm kontaktů a registrem organizací: jak je (ne)
vynucována identita, jak jsou detekováni duplicitní subjekty, a jaké je current-state chování při slučování,
které je konsoliduje — včetně jeho destruktivních a netransakčních vlastností.

## Jedinečnost identity subjektu (current-state: NENÍ vynucováno)

- Current-state: identita subjektu NESMÍ být považována za jedinečnou na úrovni dat — jedinečnost není
  vynucována u rodného čísla, telefonu ani e-mailu napříč úložištěm subjektů (EN0006).
- Current-state: reference na subjekty mezi agregátem případu (EN0001) a úložištěm subjektů (EN0006) jsou pouze
  měkké reference (soft references) a NESMÍ být považovány za vynucující referenční integritu.

## Provisioning subjektu z případu

- Když je případ (EN0001) provisioningován do subjektů, fundraiser nebo patron SE STANE uživatelem (EN0008)
  propojeným se záznamem subjektu (EN0006), a obdarované dítě BUDE reprezentováno pouze záznamem subjektu
  (EN0006), bez uživatele.
- Záznam subjektu dítěte BUDE deduplikován podle rodného čísla a znovu použit, pokud již existuje odpovídající
  záznam.
- Nově provisioningovaný uživatel BUDE vytvořen bez použitelného hesla, dokud nebude dokončen samostatný krok
  aktivace.

## Detekce duplicit

- Duplicitní záznamy subjektů BUDOU detekovány seskupením podle shodujícího se rodného čísla, telefonu nebo
  e-mailu, přičemž kandidátní skupina se tranzitivně rozšiřuje napříč překrývajícími se shodami (UC0016).
- Administrátor BUDE moci vyloučit konkrétní kritérium duplicity z budoucí detekce, aniž by upravil jakýkoli
  záznam subjektu.

## Deduplikace / sloučení kontaktů (current-state chování)

- Sloučení kontaktů PŘEŘADÍ každou závislou referenci na případ (EN0001) a profil (EN0002) z každého duplikátu
  na zvolený přežívající záznam subjektu.
- Current-state: sloučení kontaktů natvrdo smaže (hard-delete) každý poražený záznam subjektu společně s jeho
  vlastnícím uživatelským účtem, čímž obchází vyhrazenou cestu výmazu.
- Current-state: sloučení NESMÍ být považováno za transakční a nenabízí žádný dry-run — selhání v průběhu
  slučování může zanechat částečně přeřazený graf.

## Sloučení leadů (current-state chování)

- Sloučení leadů PŘEVEDE profil žádosti patrona duplicitního leadu (a jeho propojený subjekt patrona, pokud
  existuje) na přežívající hlavní případ, poté nastaví duplicitní lead do stavu duplikát a vymaže jeho reference
  na subjekty.
- Current-state: sloučení leadů bezpodmínečně přepíše jakýkoli již existující profil žádosti patrona na
  přežívajícím případu, čímž osiří předchozí referenci i na úspěšné cestě.

## Deduplikace / sloučení organizací (current-state chování)

- Sloučení organizací PŘEŘADÍ referenci na zaměstnavatele držené každým dotčeným případem (EN0001) na zvolenou
  přežívající organizaci (EN0018), a poté odstraní duplicitní organizace.
- Current-state: sloučení organizací přeřadí pouze referenci na zaměstnavatele; jakákoli jiná reference na
  odstraněnou organizaci zůstane nevyřešená (dangling).

## Rozsah autorizace (current-state)

- Current-state: u všech akcí slučování a párování NESMÍ být předpokládáno, že jsou omezeny podle země nebo
  role — jsou chráněny pouze běžným oprávněním k editaci záznamu.

## Non-Goals (mimo rozsah)

- Toto pravidlo nedefinuje GDPR výmaz osobních údajů (PII) subjektu — viz BR-DataProtectionAndErasure.
- Toto pravidlo nedefinuje zápis klasifikace rizika/blacklistu kontaktu prováděný scoringem — viz
  BR-ScoringAndRiskGating.
- Toto pravidlo nedefinuje přiznání role podporovatele při první uhrazené transakci — viz
  BR-AccessControlAndRoles.
- Toto pravidlo nepředepisuje target-state opravy (transakční sloučení, dry-run, omezení jedinečnosti);
  zaznamenává pouze current-state chování.
