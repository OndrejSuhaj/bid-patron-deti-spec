---
doc_id: QUERY0013
title: Admin Party / CRM & User Lists
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: list
references:
  - EN0008
  - EN0006
  - EN0018
  - EN0019
  - EN0020
  - UC0016
  - UC0014
  - FN0014
  - FN0018
  - ARCH0009
  - ARCH0011
---

# QUERY0013 – Admin Party / CRM a uživatelské seznamy

## Účel

Back-office adresářové read-modely nad subjekty (party): uživatelské účty, partnerské organizace,
dodavatelé, veřejní partneři „podporují nás" a dva seznamy pro správu osob (Drupal core lidé +
seznam zaměstnanců v rozsahu manažera). Jde o CRM/identity procházecí plochy.

Evidence: `config/views.view.accounts.yml`, `config/views.view.organisations.yml`,
`config/views.view.suppliers.yml`, `config/views.view.admin_partners.yml`,
`config/views.view.manager_users.yml`, `config/views.view.user_admin_people.yml`.

## Konzumenti

- administrator, manager, risk_manager (účty, dodavatelé); administrator, manager, marketing
  (organizace, partneři); zaměstnanci s oprávněním `administer users` / `manager administer users`
  (seznamy osob).

## Zdrojové entity

- EN0008 – Uživatel (účty, seznamy osob)
- EN0006 – Kontakt (kontaktní sloupce spojené s uživateli / organizacemi)
- EN0018 – Organizace (partnerské organizace)
- EN0019 – Dodavatel (adresář dodavatelů)
- EN0020 – Partner (veřejní partneři „podporují nás")

## Filtry a seskupení

| View (cesta) | Filtr / rozsah | Rozsah rolí | Poznámky |
|---|---|---|---|
| `accounts` (`admin/accounts`) | Uživatelské účty + sloupce s osobními údaji kontaktu | administrator, manager, risk_manager | 200/stránka. Confirmed. |
| `organisations` (`admin/organisations`) | Partnerské organizace; zobrazené name, is_profi, uid | administrator, manager, marketing | Confirmed. |
| `suppliers` (`admin/suppliers`) | Řádky dodavatel→kategorie; zobrazené name/status | administrator, manager, risk_manager | Confirmed. |
| `admin_partners` (`admin/partners`) | Partneři „podporují nás" podle kategorie | manager, marketing | Confirmed. |
| `manager_users` (`admin/manager_users`) | Uživatelé, jejichž e-mail končí na `patrondeti.cz` (zaměstnanci) | oprávnění `manager administer users` | `mail ends 'patrondeti.cz'`. Confirmed. |
| `user_admin_people` (`admin/people/list`) | Základní seznam osob; kombinuje vyhledávání, status, role, oprávnění | oprávnění `administer users` | Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| sloupce účtu | `uid`, `name`, role, e-mail, jméno/příjmení, `rc`, telefon | Osobní údaje. Vlastní EN0008/EN0006. Confirmed. |
| sloupce organizace | name, `ico`, telefon, adresa, `is_profi`, vlastník | Vlastní EN0018/EN0006. Confirmed. |
| sloupce dodavatele | name, kategorie, adresa, url | Vlastní EN0019. Confirmed. |
| sloupce partnera | kategorie, name, operace | Vlastní EN0020. Confirmed. |
| sloupce osoby | name, status, role, vytvořeno, poslední přístup | Vlastní EN0008. Confirmed. |

## Tvar výsledku

- Stránkované back-office adresářové tabulky; zobrazené filtrovací formuláře; operace nad řádky.

## Reference

- UC: UC0016 (Správa záznamů subjektů), UC0014 (Autentizace a správa přístupu)
- FN: FN0014 (Správa subjektů a kontaktů), FN0018 (Identita, relace a řízení přístupu)
- EN: EN0008, EN0006, EN0018, EN0019, EN0020
- ARCH: ARCH0009 (Party / CRM), ARCH0011 (Identita a přístup)

## Otevřené body

- Seznam `accounts` zobrazuje `rc` (rodné číslo) rolím administrator/manager/risk_manager — je třeba
  potvrdit, zda je toto zpřístupnění osobních údajů zamýšlené pro všechny tři role, nebo zda by mělo
  být zúženo. `Conflict — requires clarification.`
- `manager_users` identifikuje zaměstnance čistě podle `mail ends 'patrondeti.cz'`; zaměstnanci
  s externí doménou by tak byli opomenuti. Observation.
