---
doc_id: ACL0003
title: Risk & Scoring Access
canonical_layer: ACL
spec_type: access-control
status: draft
references:
  - EN0016
  - EN0017
  - EN0019
  - UC0003
  - FN0004
  - BR-ScoringAndRiskGating
  - ARCH0004
---

# ACL0003 – Risk & Scoring Access

## Purpose

Access to the risk/scoring context: ScoringRecord (EN0017), scoring pages, scoring transitions,
Blacklist (EN0016), Supplier (EN0019), and the scoring REST resource. Actor model owned by ACL0001.

## Actor Model

- `risk_manager` is the primary role. `manager` holds scoring transitions (`scoring_ok`/`scoring_ko`)
  and blacklist/supplier CRUD as part of its broad grant. `coordinator`/`senior_coordinator` may view
  the low-risk scoring page only.
- Scope is `global` (no country/tenant filter — ACL0001 G-03).

Evidence: `config/user.role.risk_manager.yml`, `config/user.role.manager.yml`,
`config/user.role.coordinator.yml`; permission defs `scoring/scoring.permissions.yml`,
`blacklist/blacklist.permissions.yml`, `supplier/supplier.permissions.yml`;
`config/rest.resource.scoring_rest_resource.yml`.

## Resources

- ScoringRecord (EN0017) — scoring risk edit
- Scoring page / low-risk scoring page
- Scoring REST resource (GET/POST)
- Scoring transitions — `scoring_ok`, `scoring_ko`, `scoring_k_doplneni`
- Blacklist (EN0016) — CRUD
- Supplier (EN0019) + supplier-to-category — CRUD

## Matrix

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `risk_manager` | Scoring risks (EN0017) | edit / set | global | `edit application scoring risks` (permission is `restrict access: true`). |
| `risk_manager` | Scoring page | view | global | `view scoring page` + `view low risk scoring page`. |
| `risk_manager` | Scoring REST resource | GET, POST | global | `restful get/post scoring_rest_resource`. |
| `risk_manager` | Scoring transitions | use `scoring_ok`,`scoring_ko`,`scoring_k_doplneni` | global | via `use application_workflow transition *`. |
| `risk_manager` | Blacklist (EN0016) | add, edit, delete, view published/unpublished | global | `add/edit/delete blacklist entities`, `view (un)published blacklist entities`. |
| `risk_manager` | Supplier (EN0019) + supplier-to-category | add, edit, delete, view | global | `add/edit/delete supplier entities`, `... supplier to category entities`. |
| `manager` | Scoring transitions | use `scoring`,`scoring_ok`,`scoring_ko` | global | Part of manager broad transition set. |
| `manager` | Blacklist (EN0016) | add, edit, delete, view | global | `add/edit/delete blacklist entities`. |
| `manager` | Supplier (EN0019) | add, edit, delete, view | global | Supplier + supplier-to-category CRUD. |
| `coordinator` | Low-risk scoring page | view | global | `view low risk scoring page` only (no scoring edit). |
| `senior_coordinator` | Low-risk scoring page | view | global | `view low risk scoring page` only. |
| `manager` | Supplier categories (taxonomy) | create/edit/delete terms in `category` | global | `create/edit/delete terms in category`. |
| `risk_manager` | Category taxonomy | create/edit/delete terms | global | `create/edit/delete terms in category`, `administer taxonomy`. |

## Exceptions

- `edit application scoring risks` is a `restrict access: true` permission (marked administratively
  sensitive in the module) but is still granted to `risk_manager` in config.
- Scoring transition legality is subject to the same two-model / force-bypass gaps as all Application
  transitions — see ACL0002 and ACL0001 G-02/G-06.

## References

- UC: UC0003 (assess applicant risk)
- FN: FN0004 (risk scoring assessment), FN0005 (external registry verification)
- EN: EN0016 (Blacklist), EN0017 (ScoringRecord), EN0019 (Supplier)
- BR: BR-ScoringAndRiskGating
- ARCH: ARCH0004 (Risk and Scoring)

## Open Items

- The scoring REST resource's own request-level authorization (beyond the role permission) is a
  resource-plugin detail deferred to the API/contract pass.
