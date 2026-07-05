---
doc_id: QUERY0013
title: Admin Party / CRM & User Lists
canonical_layer: QUERY
spec_type: query-spec
status: draft
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

# QUERY0013 – Admin Party / CRM & User Lists

## Purpose

Back-office directory read-models over parties: user accounts, partner organisations, suppliers,
public "supporting us" partners, and the two people-management lists (Drupal core people +
manager-scoped staff). These are the CRM/identity browse surfaces.

Evidence: `config/views.view.accounts.yml`, `config/views.view.organisations.yml`,
`config/views.view.suppliers.yml`, `config/views.view.admin_partners.yml`,
`config/views.view.manager_users.yml`, `config/views.view.user_admin_people.yml`.

## Consumers

- administrator, manager, risk_manager (accounts, suppliers); administrator, manager, marketing
  (organisations, partners); staff with `administer users` / `manager administer users` (people lists).

## Source Entities

- EN0008 – User (accounts, people lists)
- EN0006 – Contact (contact columns joined to users / organisations)
- EN0018 – Organisation (partner organisations)
- EN0019 – Supplier (suppliers directory)
- EN0020 – Partner (public "supporting us" partners)

## Filters and Grouping

| View (path) | Filter / scope | Role scope | Notes |
|---|---|---|---|
| `accounts` (`admin/accounts`) | User accounts + contact PII columns | administrator, manager, risk_manager | 200/page. Confirmed. |
| `organisations` (`admin/organisations`) | Partner orgs; exposed name, is_profi, uid | administrator, manager, marketing | Confirmed. |
| `suppliers` (`admin/suppliers`) | Supplier→category rows; exposed name/status | administrator, manager, risk_manager | Confirmed. |
| `admin_partners` (`admin/partners`) | "Supporting us" partners by category | manager, marketing | Confirmed. |
| `manager_users` (`admin/manager_users`) | Users whose mail ends `patrondeti.cz` (staff) | perm `manager administer users` | `mail ends 'patrondeti.cz'`. Confirmed. |
| `user_admin_people` (`admin/people/list`) | Core people list; combine search, status, roles, permission | perm `administer users` | Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| account columns | `uid`, `name`, roles, email, first/last name, `rc`, phone | PII. Owned by EN0008/EN0006. Confirmed. |
| organisation columns | name, `ico`, phone, address, `is_profi`, owner | Owned by EN0018/EN0006. Confirmed. |
| supplier columns | name, category, address, url | Owned by EN0019. Confirmed. |
| partner columns | category, name, operations | Owned by EN0020. Confirmed. |
| people columns | name, status, roles, created, last access | Owned by EN0008. Confirmed. |

## Result Shape

- Paginated back-office directory tables; exposed filter forms; row operations.

## References

- UC: UC0016 (Maintain Party Records), UC0014 (Authenticate & Manage Access)
- FN: FN0014 (Party & Contact Management), FN0018 (Identity, Session & Access Control)
- EN: EN0008, EN0006, EN0018, EN0019, EN0020
- ARCH: ARCH0009 (Party / CRM), ARCH0011 (Identity & Access)

## Open Items

- The `accounts` list surfaces `rc` (birth number) to administrator/manager/risk_manager — confirm
  this PII exposure is intended for all three roles or should be narrowed. `Conflict — requires clarification.`
- `manager_users` identifies staff purely by `mail ends 'patrondeti.cz'`; external-domain staff would
  be missed. Observation.
