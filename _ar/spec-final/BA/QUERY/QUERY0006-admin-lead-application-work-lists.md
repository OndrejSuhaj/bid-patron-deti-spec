---
doc_id: QUERY0006
title: Admin Lead / Application Work Lists
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: list
references:
  - EN0001
  - EN0002
  - EN0006
  - EN0004
  - EN0011
  - EN0017
  - EN0008
  - UC0002
  - UC0003
  - FN0001
  - FN0004
  - FN0018
  - ARCH0003
  - ARCH0004
---

# QUERY0006 – Administrátorské pracovní seznamy leadů / žádostí

## Účel

Back-office pracovní seznamy nad žádostmi (application) v jejich lead / procesním životním cyklu.
Sdruženy zde jako jeden kontrakt, protože sdílejí stejnou základní entitu (`application`), stejnou
projekci sloupců lead/dítě/fundraiser/patron a stejný role-gated back-office záměr; liší se tím,
na jaký výsek životního cyklu filtrují.

Evidence: `config/views.view.leads.yml` (all/my/default), `config/views.view.scoring.yml`,
`config/views.view.priprava_pribehu.yml`, `config/views.view.leads_init_patron.yml`,
`config/views.view.contracts.yml`, `config/views.view.empty_confirmation_signature.yml`.

## Konzumenti

- Koordinátoři, manažeři, content admini, risk manažeři, marketing, front, účetní — dle role gating
  konkrétního view (každý display níže má zaznamenanou vlastní sadu rolí).

## Zdrojové entity

- EN0001 – Application (základní řádek)
- EN0002 – ApplicationProfile (sloupce profilu fundraisera/patrona, cena daru / podkategorie)
- EN0006 – Contact (sloupce dítě / strana)
- EN0004 – Campaign (odkaz na příběh, vybraná částka)
- EN0011 – Contract (seznamy smluv / podpisů)
- EN0017 – ScoringRecord (kontext scoring pracovního seznamu)
- EN0008 – User (koordinátor, vlastník leadu)

## Filtry a seskupení

| View (cesta) | Výsek životního cyklu | Rozsah rolí | Poznámky |
|---|---|---|---|
| `leads` – all (`admin/leads`) | Všechny leady; exponované filtry id, campaign, uid, state, created range, flag, gift_subcategory, mass | content_admin, risk_manager, coordinator, manager, marketing, front, accountant | Plný pager 100/page. Confirmed. |
| `leads` – my (`admin/leads/my/%user_id`) | Leady vlastněné koordinátorem (argument `lead_user_id`) | jako výše | Vymezeno argumentem. Confirmed. |
| `scoring` (`admin/scoring`) | Žádosti ve scoring pracovním seznamu | risk_manager, manager | Pager 100/page. Confirmed. |
| `priprava_pribehu` (`admin/completed_applications`) | `moderation_state = application_workflow-in_progress` (příprava příběhu) | content_admin, manager | Confirmed. |
| `leads_init_patron` (`admin/reports/leads-init-patrons`) | `lead_role = patron` AND `campaign.published` není prázdné | administrator, manager | Řazeno dle published DESC. Confirmed. |
| `contracts` (`admin/contracts`, `/all`) | Žádosti se smlouvou; public_id, state, cena daru, vybraná částka, soubor | administrator, manager, senior_coordinator | Confirmed. |
| `empty_confirmation_signature` (`admin/empty-confirmation-signature`) | Protokoly o převzetí s vygenerovaným HTML, ale bez elektronického podpisu / referencí na potvrzení, se souborem přítomným | oprávnění `add leads` | Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| `state` | Stav žádosti | Slovník vlastní EN/STAT (nerozepisuje se zde). Confirmed. |
| sloupce lead / dítě / fundraiser / patron | Vypočtené projekce "views field" (joiny contact + profile) | např. `child_contact_views_field`, `fundraiser_application_profile_views_field`. Confirmed. |
| `gift_price` (profil) | Požadovaná výše daru | Vypočtené views field. Confirmed. |
| smluvní `public_id`, `file`, `created` | Sloupce pracovního seznamu smluv | view `contracts`. Confirmed. |
| operations / bulk form | Řádkové akce / VBO bulk operace | Confirmed. |

## Tvar výsledku

- Stránkované back-office tabulky; exponované filtrovací formuláře pro každý display; některé
  podporují bulk operace (VBO).

## Reference

- UC: UC0002 (Orchestrace změny stavu žádosti), UC0003 (Posouzení rizika žadatele), UC0004 (Správa smlouvy a podpisu)
- FN: FN0001 (Příjem žádosti), FN0004 (Rizikový scoring), FN0018 (Řízení přístupu)
- EN: EN0001, EN0002, EN0006, EN0004, EN0011, EN0017, EN0008
- ARCH: ARCH0003 (Domain žádosti a leadu), ARCH0004 (Domain rizika a scoringu)

## Otevřené body

- Country/tenant scoping není v těchto views aplikován; na multi-tenant DB by seznamy zobrazovaly
  napříč všemi zeměmi. Ověřit, zda nasazení je single-DB-per-country (což by tuto otázku
  neutralizovalo). `Conflict — requires clarification.`
- Přesná množina stavů patřících do pracovního seznamu `scoring` je definována workflow
  konfigurací, nikoli filtrem uvnitř view; ověřit oproti modelu stavů, místo opakování zde.
