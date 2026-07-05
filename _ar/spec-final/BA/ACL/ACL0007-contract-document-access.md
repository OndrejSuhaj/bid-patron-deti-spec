---
doc_id: ACL0007
title: Contract & Document Access
layer: ACL
spec_type: access-control
status: imported
modules: []
references:
  - EN0011
  - EN0012
  - EN0014
  - UC0004
  - UC0010
  - FN0009
  - FN0013
  - BR-ContractAndESignature
  - BR-DonationConfirmationAndTax
  - ARCH0008
---

# ACL0007 – Přístup ke smlouvám a dokumentům

## Účel

Přístup ke smlouvě (Contract, EN0011), šabloně smlouvy (ContractTemplate, EN0012), směrování smlouvy
mezi rolemi a k potvrzení o daru / daňovému dokumentu (DonationConfirmation, EN0014). Model aktérů je
vlastněn ACL0001.

## Model aktérů

- `coordinator`, `senior_coordinator`, `manager` pracují se smlouvami. Směrování smlouvy mezi rolemi
  je řízeno oprávněními `send contract to fundraiser` a `send contract to manager`. `manager`
  administruje šablony smluv. DonationConfirmation je primárně veřejně/systémově generovaný artefakt
  (veřejný POST přes REST — ACL0009).
- Rozsah je `global` (bez filtrování podle země — ACL0001 G-03).

Evidence: `config/user.role.coordinator.yml`, `config/user.role.senior_coordinator.yml`,
`config/user.role.manager.yml`; definice oprávnění `contract/contract.permissions.yml`,
`donation_confirmation/donation_confirmation.permissions.yml`.

## Zdroje

- Contract (EN0011) — CRUD, revize
- Směrování smlouvy — `send contract to fundraiser`, `send contract to manager`
- ContractTemplate (EN0012) — CRUD (`administer contract template entities`)
- DonationConfirmation (EN0014) — vytvoření (veřejné REST), zobrazení

## Matice

| Aktér / Role | Zdroj | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `coordinator` | Contract (EN0011) | vytvoření, úprava, zobrazení publikovaných/nepublikovaných | global | `add/edit contract entities`, `view (un)published contract entities`. |
| `coordinator` | Směrování smlouvy | odeslání na manažera | global | `send contract to manager`. |
| `senior_coordinator` | Contract (EN0011) | vytvoření, úprava, zobrazení | global | Stejně jako coordinator. |
| `senior_coordinator` | Směrování smlouvy | odeslání na fundraisera, odeslání na manažera | global | `send contract to fundraiser` + `send contract to manager`. |
| `manager` | Contract (EN0011) | vytvoření, úprava, zobrazení | global | `add/edit contract entities`, `view (un)published contract entities`. |
| `manager` | Směrování smlouvy | odeslání na fundraisera, odeslání na manažera | global | Obě oprávnění k odeslání. |
| `manager` | ContractTemplate (EN0012) | administrace, úprava, zobrazení | global | `administer/edit contract template entities`, `view (un)published contract template entities`. |
| `content_admin`/`manager` (přechody smlouvy) | Přechody žádosti `ceka_na_podpis`,`smlouva_podepsana_zadatelem` | použití | global | Přechody workflow podpisu smlouvy v konfiguraci rolí. |
| `anonymous` | Získání smlouvy | GET | public | `restful get application_contract_resource`. |
| `anonymous`/`authenticated` | DonationConfirmation (EN0014) | vytvoření | public | `restful post donation_confirmation_resource_v31/_v32`. |

## Výjimky

- Entity Contract používají vlastní storage třídu (`contract/src/ContractEntityStorage.php`) s přímým
  přístupem do DB; jde o problematiku datové vrstvy vlastněnou BR-ContractAndESignature, zde uvedenou
  pouze jako autorizační povrch.
- Přechody workflow podpisu smlouvy dědí mezery v legalitě přechodů (ACL0001 G-02/G-06).
- Vytvoření DonationConfirmation je veřejná REST akce; autorizace daňového dokumentu je založena na
  vlastnictví/tokenu v kódu resource, nikoli na přiřazení role.

## Odkazy

- UC: UC0004 (správa smlouvy a podpisu), UC0010 (vystavení potvrzení o daru)
- FN: FN0009 (generování/podpis smlouvy), FN0013 (potvrzení o daru / daňový dokument)
- EN: EN0011 (Contract), EN0012 (ContractTemplate), EN0014 (DonationConfirmation)
- BR: BR-ContractAndESignature, BR-DonationConfirmationAndTax
- ARCH: ARCH0008 (Dokumenty a plnění)

## Otevřené body

- Přístup fundraisera/patrona ke čtení jejich vlastní smlouvy/potvrzení přes REST je založen na
  vlastnictví (kód resource); odloženo do fáze API/contract.
