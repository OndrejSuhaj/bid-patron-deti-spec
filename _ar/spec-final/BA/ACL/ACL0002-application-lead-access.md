---
doc_id: ACL0002
title: Application & Lead Access
canonical_layer: ACL
spec_type: access-control
status: canonical
modules: []
references:
  - EN0001
  - EN0002
  - EN0025
  - UC0001
  - UC0002
  - UC0025
  - FN0001
  - FN0002
  - BR-ApplicationStatusGovernance
  - ARCH0003
---

# ACL0002 – Přístup k žádosti a leadu

## Účel

Přístup k agregátu žádost/lead: Application (EN0001), ApplicationProfile (EN0002),
ApplicationLog / status log (EN0025), leady, sloučení žádostí (pairing), přechody workflow a vynucená
změna moderation-state. Model aktérů vlastní ACL0001.

## Model aktérů

- Back-office role operující nad žádostmi: `coordinator`, `senior_coordinator`, `front`, `manager`,
  `content_admin`, `risk_manager` (podmnožina pro scoring), `accountant` (pouze zobrazení + `gift_paid`).
- Koncoví uživatelé vytvářejí/čtou své vlastní žádosti přes veřejné REST rozhraní (viz ACL0009),
  nikoli přes tato oprávnění.
- Rozsah (scope) všech back-office oprávnění níže je `global` — bez filtru na zemi/tenant
  (ACL0001 gap G-03).

Evidence pro role a oprávnění: `config/user.role.<id>.yml`; definice oprávnění:
`application/application.permissions.yml`, `export_csv/export_csv.permissions.yml`.

## Zdroje (resources)

- Entita Application (EN0001) — vytvoření/úprava/zobrazení/revize/archivace
- Entita ApplicationProfile (EN0002) — vytvoření/úprava/zobrazení (sub-profily patrona/fundraisera)
- Lead — `add leads` (žádost ve fázi leadu)
- Status log žádosti (EN0025) — `view application status log`
- Přechody workflow žádosti — `use application_workflow transition <X>`
- Vynucený moderation state — `change entity moderation state`
- Sloučení žádostí (application pairing) — `application pairing`
- Export leadů — `export leads`

## Matice

| Aktér / role | Zdroj | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `coordinator` | Application (EN0001) | vytvoření, úprava, zobrazení publikovaných/nepublikovaných, zobrazení všech revizí | global | `add application entities`, `edit application entities`, `view (un)published application entities`, `view all application revisions`. |
| `coordinator` | ApplicationProfile (EN0002) | vytvoření, úprava | global | `add/edit application profile entities`. |
| `coordinator` | Lead | vytvoření | global | `add leads`. |
| `coordinator` | Sloučení žádostí | sloučit | global | `application pairing`. |
| `coordinator` | Přechody žádosti | použít (široká sada vč. `gift_paid`,`in_progress`,`scoring`) | global | 40+ oprávnění `use application_workflow transition *`; viz konfigurace rolí. |
| `coordinator` | Export leadů | export | global | `export leads`. |
| `senior_coordinator` | Application / Profile / Lead | vytvoření, úprava, zobrazení, revize, sloučení | global | Stejný základ jako coordinator. |
| `senior_coordinator` | Application moderation_state | **vynucená změna** | global | `change entity moderation state` → `ChangeModStateForm`; obchází legalitu přechodu (ACL0001 G-02, G-04). |
| `senior_coordinator` | moderation state (content_moderation) | change entity moderation state | global | Rovněž `change entity moderation state`. |
| `front` | Application / Profile / Lead | vytvoření, úprava, zobrazení, revize, sloučení | global | Zúžená sada přechodů (bez `scoring`,`gift_*`,`in_progress`); navíc `edit campaign entities`. |
| `front` | Přechody žádosti | použít (zúžená sada) | global | např. `application_processing`, `cancel_lead`, `close`, `duplicate`, `mistake`, urgence, `suspended*`, `uncompleted`, `waiting`. |
| `front` | Export leadů | export | global | `export leads`. |
| `manager` | Application / Profile / Lead | vytvoření, úprava, zobrazení, všechny revize, archivace, sloučení | global | Nejširší sada přechodů vč. `scoring_ok`,`scoring_ko`,`correction`,`gift_paid`; `administer application_statuses`; `view application archive`. |
| `manager` | Application moderation_state | **vynucená změna** | global | `change entity moderation state` (ACL0001 G-02). |
| `content_admin` | Application (EN0001) | úprava, zobrazení publikovaných/nepublikovaných, zobrazení všech revizí | global | `edit application entities`, `edit application profile entities`; téměř úplná sada přechodů (bez `scoring_ok/ko`,`gift_paid`,`in_progress`). |
| `content_admin` | Status log žádosti (EN0025) | zobrazení | global | `view application status log`. |
| `risk_manager` | Application (EN0001) | úprava, zobrazení | global | `edit application entities`, `edit application profile entities`; pouze scoring přechody (viz ACL0003). |
| `accountant` | Application (EN0001) | zobrazení publikovaných/nepublikovaných, zobrazení archivu | global | `view (un)published application entities`, `view application archive`; jediný přechod `gift_paid`. |
| `coordinator`,`senior_coordinator`,`front`,`manager`,`content_admin`,`risk_manager` | Status log žádosti (EN0025) | zobrazení | global | `view application status log` (accountant vyloučen). |
| `administrator` | Přechody žádosti | použít (všechny) | platform | V `getAllowedStates()` (ApplicationEntity.php:1405) považován za bezpodmínečně povoleného. |

## Autorizace přechodů — dva paralelní modely (ACL0001 G-06)

O tom, kdo může přesouvat žádost mezi stavy, rozhodují dva nezávislé mechanismy:

1. **Konfigurační oprávnění** — `use application_workflow transition <key>` per role v
   `config/user.role.*.yml` (oprávnění pro přechod v Drupal content-moderation). Používá standardní
   moderation UI.
2. **Allow-list v kódu** — `transition_roles:` v `application/application_states.yml`, se kterou
   pracuje `ApplicationEntity::getAllowedStates()` (ApplicationEntity.php:1396–1425); ta zároveň
   respektuje legalitu `from`/`to` v `transitions` a roli `administrator` považuje za vždy povolenou.
   Role přítomné v `transition_roles`: `accountant`, `content_admin`, `coordinator`, `front`,
   `manager`, `risk_manager`, `senior_coordinator`.

Tyto dva seznamy se nemusí shodovat a **žádný z nich nekontroluje `ChangeModStateForm`**, který
nabízí každý stav bez omezení a zápis vynutí (ACL0001 G-02). Sémantiku pravidel vlastní
BR-ApplicationStatusGovernance; tento dokument zaznamenává pouze přístupový povrch.

## Výjimky

- Route `application.change_mod_state_form` formuláře `ChangeModStateForm` požaduje pouze
  `change entity moderation state`; nekontroluje legalitu cílového přechodu ani allow-list přechodů
  pro danou roli. Držena rolemi `manager` a `senior_coordinator` (ACL0001 G-02).
- Historie stavů žádosti se ukládá pomocí přímého SQL INSERT do `application_states`
  (ApplicationEntity.php:312–327), nezávisle na validaci content-moderation (ACL0001 G-04).
- Žádné oprávnění k žádosti nemá rozsah na CZ/RO/MD (ACL0001 G-03).

## Odkazy

- UC: UC0001 (podání žádosti), UC0002 (orchestrace změny stavu žádosti), UC0025 (obnovení/zahození konceptu)
- FN: FN0001 (příjem žádosti), FN0002 (orchestrace stavu), FN0003 (naplánovaný přechod stavu)
- EN: EN0001 (Application), EN0002 (ApplicationProfile), EN0025 (ApplicationLog)
- BR: BR-ApplicationStatusGovernance
- ARCH: ARCH0003 (Žádost a lead)

## Otevřené body

- Rozdíly mezi konfiguračními oprávněními `use ... transition` a `transition_roles` v kódu na úrovni
  jednotlivých přechodů zde nejsou plně vyčísleny; odloženo na fázi API/kontraktů.
