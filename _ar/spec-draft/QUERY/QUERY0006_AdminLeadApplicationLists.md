---
doc_id: QUERY0006
title: Admin Lead / Application Work Lists
canonical_layer: QUERY
spec_type: query-spec
status: draft
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

# QUERY0006 – Admin Lead / Application Work Lists

## Purpose

Back-office worklists over applications (žádosti) in their lead / processing lifecycle. Grouped
here as one contract because they share the same base entity (`application`), the same
lead/child/fundraiser/patron column projection, and the same role-gated back-office intent; they
differ by which lifecycle slice they filter to.

Evidence: `config/views.view.leads.yml` (all/my/default), `config/views.view.scoring.yml`,
`config/views.view.priprava_pribehu.yml`, `config/views.view.leads_init_patron.yml`,
`config/views.view.contracts.yml`, `config/views.view.empty_confirmation_signature.yml`.

## Consumers

- Coordinators, managers, content admins, risk managers, marketing, front, accountants — per view
  role gating (each display below records its own role set).

## Source Entities

- EN0001 – Application (base row)
- EN0002 – ApplicationProfile (fundraiser/patron profile columns, gift price/subcategory)
- EN0006 – Contact (child / party columns)
- EN0004 – Campaign (story link, raised amount)
- EN0011 – Contract (contracts / signature lists)
- EN0017 – ScoringRecord (scoring worklist context)
- EN0008 – User (coordinator, lead owner)

## Filters and Grouping

| View (path) | Lifecycle slice | Role scope | Notes |
|---|---|---|---|
| `leads` – all (`admin/leads`) | All leads; exposed filters id, campaign, uid, state, created range, flag, gift_subcategory, mass | content_admin, risk_manager, coordinator, manager, marketing, front, accountant | Full pager 100/page. Confirmed. |
| `leads` – my (`admin/leads/my/%user_id`) | Leads owned by a coordinator (arg `lead_user_id`) | as above | Argument-scoped. Confirmed. |
| `scoring` (`admin/scoring`) | Applications in scoring worklist | risk_manager, manager | Pager 100/page. Confirmed. |
| `priprava_pribehu` (`admin/completed_applications`) | `moderation_state = application_workflow-in_progress` (story processing) | content_admin, manager | Confirmed. |
| `leads_init_patron` (`admin/reports/leads-init-patrons`) | `lead_role = patron` AND `campaign.published` not empty | administrator, manager | Sorted by published DESC. Confirmed. |
| `contracts` (`admin/contracts`, `/all`) | Applications with contract; public_id, state, gift price, raised, file | administrator, manager, senior_coordinator | Confirmed. |
| `empty_confirmation_signature` (`admin/empty-confirmation-signature`) | Acceptance protocols with generated HTML but missing digital signature / confirmation ref, with file present | perm `add leads` | Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| `state` | Application status | Vocabulary owned by EN/STAT (not restated). Confirmed. |
| lead / child / fundraiser / patron columns | Computed "views field" projections (contact + profile joins) | e.g. `child_contact_views_field`, `fundraiser_application_profile_views_field`. Confirmed. |
| `gift_price` (profile) | Requested gift amount | Computed views field. Confirmed. |
| contract `public_id`, `file`, `created` | Contract worklist columns | `contracts` view. Confirmed. |
| operations / bulk form | Row actions / VBO bulk operations | Confirmed. |

## Result Shape

- Paginated back-office tables; exposed filter forms per display; some support bulk operations (VBO).

## References

- UC: UC0002 (Orchestrate Application Status Change), UC0003 (Assess Applicant Risk), UC0004 (Manage Contract & Signature)
- FN: FN0001 (Application Intake), FN0004 (Risk Scoring), FN0018 (Access Control)
- EN: EN0001, EN0002, EN0006, EN0004, EN0011, EN0017, EN0008
- ARCH: ARCH0003 (Application & Lead Domain), ARCH0004 (Risk & Scoring Domain)

## Open Items

- Country/tenant scoping is not applied by these views; on a multi-tenant DB they would list across
  all countries. Confirm whether deployment is single-DB-per-country (which would neutralise this).
  `Conflict — requires clarification.`
- The exact status membership of the `scoring` worklist is defined by workflow config, not by an
  in-view filter; verify against the status model rather than restating here.
