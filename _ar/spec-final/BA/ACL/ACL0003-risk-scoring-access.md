---
doc_id: ACL0003
title: Risk & Scoring Access
canonical_layer: ACL
spec_type: access-control
status: canonical
modules: []
references:
  - EN0016
  - EN0017
  - EN0019
  - UC0003
  - FN0004
  - BR-ScoringAndRiskGating
  - ARCH0004
---

# ACL0003 – Přístup k risku a scoringu

## Účel

Přístup ke kontextu risku/scoringu: ScoringRecord (EN0017), scoringové stránky, přechody scoringu,
Blacklist (EN0016), Supplier (EN0019) a REST resource pro scoring. Model aktérů je vlastněn ACL0001.

## Model aktérů

- `risk_manager` je primární role. `manager` má přechody scoringu (`scoring_ok`/`scoring_ko`)
  a CRUD blacklistu/dodavatelů jako součást svého širokého oprávnění. `coordinator`/`senior_coordinator`
  může pouze zobrazit low-risk scoringovou stránku.
- Rozsah je `global` (bez filtru země/tenantu — ACL0001 G-03).

Evidence: `config/user.role.risk_manager.yml`, `config/user.role.manager.yml`,
`config/user.role.coordinator.yml`; definice oprávnění `scoring/scoring.permissions.yml`,
`blacklist/blacklist.permissions.yml`, `supplier/supplier.permissions.yml`;
`config/rest.resource.scoring_rest_resource.yml`.

## Zdroje (resources)

- ScoringRecord (EN0017) — úprava rizika scoringu
- Scoringová stránka / low-risk scoringová stránka
- REST resource pro scoring (GET/POST)
- Přechody scoringu — `scoring_ok`, `scoring_ko`, `scoring_k_doplneni`
- Blacklist (EN0016) — CRUD
- Supplier (EN0019) + supplier-to-category — CRUD

## Matice

| Aktér / Role | Zdroj | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `risk_manager` | Scoring risks (EN0017) | úprava / nastavení | global | `edit application scoring risks` (oprávnění má `restrict access: true`). |
| `risk_manager` | Scoringová stránka | zobrazení | global | `view scoring page` + `view low risk scoring page`. |
| `risk_manager` | REST resource pro scoring | GET, POST | global | `restful get/post scoring_rest_resource`. |
| `risk_manager` | Přechody scoringu | použití `scoring_ok`,`scoring_ko`,`scoring_k_doplneni` | global | prostřednictvím `use application_workflow transition *`. |
| `risk_manager` | Blacklist (EN0016) | vytvoření, úprava, smazání, zobrazení publikovaných/nepublikovaných | global | `add/edit/delete blacklist entities`, `view (un)published blacklist entities`. |
| `risk_manager` | Supplier (EN0019) + supplier-to-category | vytvoření, úprava, smazání, zobrazení | global | `add/edit/delete supplier entities`, `... supplier to category entities`. |
| `manager` | Přechody scoringu | použití `scoring`,`scoring_ok`,`scoring_ko` | global | Součást širší sady přechodů role manager. |
| `manager` | Blacklist (EN0016) | vytvoření, úprava, smazání, zobrazení | global | `add/edit/delete blacklist entities`. |
| `manager` | Supplier (EN0019) | vytvoření, úprava, smazání, zobrazení | global | CRUD pro Supplier + supplier-to-category. |
| `coordinator` | Low-risk scoringová stránka | zobrazení | global | pouze `view low risk scoring page` (bez úpravy scoringu). |
| `senior_coordinator` | Low-risk scoringová stránka | zobrazení | global | pouze `view low risk scoring page`. |
| `manager` | Kategorie dodavatelů (taxonomie) | vytvoření/úprava/smazání termů v `category` | global | `create/edit/delete terms in category`. |
| `risk_manager` | Taxonomie kategorií | vytvoření/úprava/smazání termů | global | `create/edit/delete terms in category`, `administer taxonomy`. |

## Výjimky

- `edit application scoring risks` je oprávnění s `restrict access: true` (v modulu označené jako
  administrativně citlivé), přesto je v konfiguraci přiděleno roli `risk_manager`.
- Legalita přechodu scoringu podléhá stejným mezerám dvou modelů / force-bypass jako všechny přechody
  Application — viz ACL0002 a ACL0001 G-02/G-06.

## Reference

- UC: UC0003 (posouzení rizika žadatele)
- FN: FN0004 (posouzení rizika scoringem), FN0005 (verifikace přes externí registry)
- EN: EN0016 (Blacklist), EN0017 (ScoringRecord), EN0019 (Supplier)
- BR: BR-ScoringAndRiskGating
- ARCH: ARCH0004 (Risk and Scoring)

## Otevřené body

- Vlastní autorizace REST resource pro scoring na úrovni požadavku (nad rámec role-based oprávnění)
  je detail resource pluginu, jehož řešení je odloženo na API/contract fázi.
