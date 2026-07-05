---
doc_id: ACL0008
title: Party, Contact & CRM Access
layer: ACL
spec_type: access-control
status: imported
modules: []
references:
  - EN0006
  - EN0018
  - EN0020
  - EN0023
  - UC0016
  - FN0014
  - FN0015
  - BR-PartyIdentityAndDeduplication
  - BR-MarketingAndAnalyticsRelay
  - ARCH0009
---

# ACL0008 – Přístup k subjektům, kontaktům a CRM

## Účel

Přístup k prostředkům subjektů/CRM: kontakt (EN0006), organizace (EN0018), partner (EN0020), poznámka
uživatele (EN0023), vyhledávání kontaktů a formuláře organizace. Model aktérů je ve vlastnictví ACL0001.

## Model aktérů

- CRUD a vyhledávání kontaktů mají většina back-office rolí (coordinator, senior_coordinator, front,
  manager, risk_manager, content_admin, marketing) plus `fundraiser` (pouze přidání/úprava kontaktu).
- Správu organizace má role `manager` (plný přístup) a `marketing` (přidání/úprava); vazba pracovníka
  organizace je řešena přes `add organisation form` / `view created organisation`.
- Poznámku uživatele mají operativní back-office role.
- Rozsah je `global` (bez filtru podle země — ACL0001 G-03).

Evidence: `config/user.role.*.yml`; definice oprávnění `contact/contact.permissions.yml`,
`organisation/organisation.permissions.yml`, `partner/partner.permissions.yml`,
`user_note/user_note.permissions.yml`.

## Prostředky

- Kontakt (EN0006) — CRUD, revize, vyhledávání
- Organizace (EN0018) — CRUD, `add organisation form`, `view created organisation`
- Partner (EN0020) — úprava, zobrazení
- Poznámka uživatele (EN0023) — CRUD, revize

## Matice

| Aktér / role | Prostředek | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `fundraiser` | Kontakt (EN0006) | přidání, úprava | global | `add/edit contact entities` — jediné podstatné oprávnění fundraisera. |
| `coordinator` | Kontakt (EN0006) | přidání, úprava, zobrazení, revize, vyhledávání | global | `add/edit contact entities`, `search contacts`, `view all contact revisions`. |
| `coordinator` | Poznámka uživatele (EN0023) | přidání, úprava, zobrazení revizí | global | `add/edit user note entities`, `view all user note revisions`. |
| `senior_coordinator` | Kontakt / poznámka uživatele | přidání, úprava, zobrazení, revize, vyhledávání | global | Stejný základ jako coordinator. |
| `front` | Kontakt / poznámka uživatele | přidání, úprava, zobrazení, revize, vyhledávání | global | `add/edit contact entities`, `search contacts`, `add/edit user note entities`. |
| `risk_manager` | Kontakt / poznámka uživatele | úprava, zobrazení, revize, vyhledávání | global | `edit contact entities`, `search contacts`, `add/edit user note entities`. |
| `content_admin` | Kontakt (EN0006) | přidání, úprava, zobrazení publikovaných/nepublikovaných, revize, vyhledávání | global | `add/edit contact entities`, `search contacts`, `view all contact revisions`. |
| `content_admin` | Poznámka uživatele (EN0023) | přidání, úprava | global | `add/edit user note entities`, `view all user note revisions`. |
| `marketing` | Kontakt (EN0006) | přidání, úprava, zobrazení, revize, vyhledávání | global | `add/edit contact entities`, `search contacts`. |
| `manager` | Kontakt (EN0006) | přidání, úprava, zobrazení, revize, vyhledávání | global | Plný CRUD kontaktu + `search contacts`. |
| `manager` | Organizace (EN0018) | přidání, úprava, zobrazení publikovaných/nepublikovaných, `add organisation form` | global | `add/edit organisation entity entities`, `add organisation form`. |
| `manager` | Partner (EN0020) | úprava, zobrazení publikovaných/nepublikovaných | global | `edit partner entities`, `view (un)published partner entities`. |
| `manager` | Poznámka uživatele (EN0023) | přidání, úprava, zobrazení revizí | global | Plný CRUD poznámky uživatele. |
| `marketing` | Organizace (EN0018) | přidání, úprava, zobrazení, `add organisation form`, `view created organisation` | global | `add/edit organisation entity entities`. |
| `marketing` | Partner (EN0020) | úprava, zobrazení publikovaných | global | `edit partner entities`. |
| `anonymous` | Organizace (veřejná) | GET | public | `restful get organisation_resource_v30/_v32`, `profile_organisation_resource`, `email_organisation_resource`. |
| `authenticated` | Vyhledávání v registru ARES | vyhledání podle IČO | public | `ares search by ico`. |

## Výjimky

- Entity kontaktu používají vlastní storage třídu a controller pro deduplikaci
  (`contact/src/ContactEntityStorage.php`, `contact/src/Controller/ContactRemoveDuplicatesController.php`)
  s přímým přístupem do DB; ve vlastnictví BR-PartyIdentityAndDeduplication, zde uvedeno pouze jako
  autorizační povrch.
- Žádné oprávnění ke kontaktu/organizaci nemá rozsah podle země/tenanta (ACL0001 G-03).

## Odkazy

- UC: UC0016 (správa záznamů subjektů), UC0013 (synchronizace marketingových leadů)
- FN: FN0014 (správa subjektů/kontaktů), FN0015 (synchronizace marketing/CRM)
- EN: EN0006 (kontakt), EN0018 (organizace), EN0020 (partner), EN0023 (poznámka uživatele)
- ES: ES0010 (ARES), ES0006 (Mautic)
- BR: BR-PartyIdentityAndDeduplication, BR-MarketingAndAnalyticsRelay
- ARCH: ARCH0009 (subjekty a CRM)

## Otevřené body

- Efektivní přístup role `organisation_worker` k vlastní organizaci není vyjádřen jako oprávnění role
  (pouze `delete own files`); jakékoli čtení v rozsahu organizace je v kódu řešeno na základě
  vlastnictví/vazby, odloženo do fáze API/kontraktů.
