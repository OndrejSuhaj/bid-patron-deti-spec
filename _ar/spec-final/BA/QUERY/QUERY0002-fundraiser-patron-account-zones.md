---
doc_id: QUERY0002
title: Fundraiser & Patron Account Zones
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: list
references:
  - EN0001
  - EN0002
  - EN0008
  - EN0005
  - UC0024
  - FN0001
  - FN0018
  - ARCH0003
---

# QUERY0002 – Zóny účtu žadatele a patrona

## Účel

Read-model stojící za dvěma zónami účtu na straně žadatele: účtem žadatele ("Účet žadatele",
`zona/zadatel`) a účtem patrona ("Účet patrona", `zona/patron`). Každá zóna zobrazuje seznam
žádostí, které aktuální uživatel vlastní ve své příslušné roli, vykreslených jako teaser žádosti.
Třetí, téměř identický read-model (`fundraisers_applications`, cesta `account`) vykresluje
stejný seznam se jménem dítěte a odkazem na doplnění a slouží také jako blok pro patrona.

Evidence: `sync_config/config_czech/views.view.fundraiser_zone.yml`,
`sync_config/config_czech/views.view.patron_zone.yml`,
`config/views.view.fundraisers_applications.yml`.

## Konzumenti

- Žadatel (role `fundraiser`) — `zona/zadatel`.
- Patron (role `patron`) — `zona/patron`.
- Přihlášený uživatel na `account` (kontext žadatele) + blok patrona (`fundraisers_applications`).

## Zdrojové entity

- EN0001 – Application (základní řádek; žádost)
- EN0002 – ApplicationProfile (vazba fundraiser_profile / patron_profile; pole jména dítěte)
- EN0008 – User (aktuální žadatel/patron; rozsah argumentu)
- EN0005 – Patron (strana v roli patrona, patron_zone)

## Filtry a seskupení

| Filtr / seskupení | Význam | Poznámky |
|---|---|---|
| `fundraiser = current_user` | fundraiser_zone: pouze vlastní žádosti žadatele | Argument `fundraiser`, `default: current_user`, `validate entity:user restrict_roles fundraiser`. Confirmed. |
| `patron = current_user` | patron_zone: pouze vlastní žádosti patrona | Argument `patron`, `default: current_user`, `restrict_roles patron`. Confirmed. |
| access: role `fundraiser` / `patron` | Každá zóna je omezena na svou roli | View access `type: role`. Confirmed. |
| distinct rows | fundraiser_zone odstraňuje duplicity žádostí | `query_tags: fundraiser_applications`, `distinct: true`. Confirmed. |
| `fundraiser` (query param → current_user) | Výchozí zobrazení `fundraisers_applications` vs. zobrazení `account`/patron | Výchozí hodnota argumentu se liší podle zobrazení (query_parameter, current_user, patron current_user). Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| teaser žádosti | Vykreslený řádek žádosti (view mode `fundraiser_s_teaser`) | Zóny žadatele/patrona vykreslují entitu, nikoli skalární pole. Confirmed. |
| `name` | Název žádosti | Výchozí pole fundraiser_zone. Confirmed. |
| `child_first_name` / `child_last_name` | Dítě, k němuž se žádost vztahuje (z profilu) | Pouze `fundraisers_applications`, přes vazbu na profil. Confirmed. |
| `state` | Stav žádosti | `fundraisers_applications`. Vokabulář stavů je vlastněn EN/STAT, zde se neopakuje. |
| odkaz na doplnění žádosti | Přímý odkaz na pokračování/úpravu žádosti | Computed pole `application_refill_link`. Confirmed. |

## Tvar výsledku

- Stránky zón: nestránkovaný seznam žádostí aktuálního uživatele vykreslený jako teasery.
- `fundraisers_applications`: stránka (`account`) + bloky (fundraiser / patron), nestránkované.

## Odkazy

- UC: UC0024 (Manage Donor Account — plochy účtu na straně žadatele), UC0025 (Resume/Discard Draft)
- FN: FN0001 (Application Intake Management), FN0018 (Identity, Session & Access Control — omezení podle role)
- EN: EN0001, EN0002, EN0008, EN0005
- ARCH: ARCH0003 (Application & Lead Domain)

## Otevřené body

- Přístup je vynucen čistě rolí v Drupalu + argumentem `current_user`; uvnitř view není žádné
  další ověření shody vlastníka nad rámec tohoto argumentu. Je třeba ověřit, zda manipulace s URL
  u výchozí hodnoty `query_parameter` v `fundraisers_applications` (výchozí zobrazení) může
  odhalit seznam jiného uživatele — zobrazení `account`/patron přepisují hodnotu na `current_user`,
  ale výchozí zobrazení používá query parametr. `Conflict — requires clarification.`
