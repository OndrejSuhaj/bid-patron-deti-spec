---
doc_id: ACL0001
title: Access Control Matrix (Master)
canonical_layer: ACL
spec_type: access-control
status: draft
references:
  - EN0008
  - FN0018
  - UC0014
  - BR-AccessControlAndRoles
  - BR-MultiTenantCountryScoping
  - BR-ReportingAndDataAccess
  - BR-ApplicationStatusGovernance
  - BR-PaymentGatewayCallbacks
  - ARCH0011
---

# ACL0001 – Access Control Matrix (Master)

## Purpose

Master actor/role × resource × action × scope model for the current Patronus platform. This document
is the single owning source for the **role catalog**, the **role-to-scope model**, and the
**current-state access gaps**. Per-domain ACL docs (ACL0002–ACL0010) hold the detailed
resource/action rows for their bounded context and reference this document for the actor model.

Access is expressed as *who* (role) can perform *what* (action) on *which* resource, and under *what*
scope. It does **not** describe Drupal framework guards, route middleware, or UI layout (see
restrictions in `rules-ACL.md`). Entity attributes are owned by `EN*`; rule semantics by `BR-*`;
capability behavior by `FN*`; use-case orchestration by `UC*` — referenced here by `doc_id`, never
restated.

## Actor Model

Patronus authorization is Drupal role-based (config: `user.role.*.yml`). Fifteen roles exist. This
agent distinguishes three actor kinds:

- **Technical session tier** — `anonymous` (no session) and `authenticated` (any logged-in account).
  These carry the public/end-user REST surface.
- **End-user business positions** — `patron`, `supporter`, `fundraiser`, `organisation_worker`.
  Nearly permission-empty in config; their real capability comes through the public REST API keyed on
  ownership, not on role permissions (see ACL0009).
- **Back-office roles** — `coordinator`, `senior_coordinator`, `front`, `manager`,
  `risk_manager`, `accountant`, `content_admin`, `marketing`, plus the super-user `administrator`.

### Role catalog (evidence: `config/user.role.<id>.yml`)

| Role id | Label | Weight | is_admin | Tier | Summary of granted scope |
|---|---|---|---|---|---|
| `administrator` | Administrátor | 2 | **true** | Back-office (super) | Bypasses all permission checks (Drupal `is_admin`); empty explicit permission set. |
| `anonymous` | Anonymous | 0 | false | Session | `access content`; large **public REST** GET/POST allow-list incl. application create, transactions, vouchers, and the Facebook Lead webhook (gap G-01). |
| `authenticated` | Authenticated | 1 | false | Session | Superset of anonymous REST allow-list + logout, ARES search, image rotate, own-file delete. |
| `patron` | Patron | 5 | false | End-user | `delete own files`, basic text formats only. |
| `supporter` | Supporter | 3 | false | End-user | `cancel own recurring transaction` + `restful post transaction_recurring_cancel_resource`; own-file delete. |
| `fundraiser` | Fundraiser | 4 | false | End-user | `add`/`edit contact entities`, own-file delete, text formats. |
| `organisation_worker` | Organisation worker | 14 | false | End-user | `delete own files` only. |
| `coordinator` | Coordinator | 8 | false | Back-office | Lead/Application CRUD, pairing, most workflow transitions, contract-to-manager, magic link, productivity reports, lead export. |
| `senior_coordinator` | Senior Coordinator | 15 | false | Back-office | Coordinator scope + `change entity moderation state` (gap G-02), contract-to-fundraiser, moderation-state change, reports. |
| `front` | Front line | 11 | false | Back-office | Lead/Application CRUD, pairing, `administer users`, `update user entity`, reduced transition set, lead export. |
| `manager` | Manager | 9 | false | Back-office | Broadest business role: near-full entity CRUD across contexts, blacklist, organisations, transactions, contracts, GDPR access, `change entity moderation state` (gap G-02), reports, login-history view-all. |
| `risk_manager` | Risk manager | 7 | false | Back-office | `edit application scoring risks`, scoring transitions (`scoring_ok`/`scoring_ko`/`scoring_k_doplneni`), blacklist/supplier CRUD, scoring pages, scoring REST. |
| `accountant` | Accountant | 12 | false | Back-office | `access accounting reports`, `use ... transition gift_paid`, view Applications + archive. Narrow. |
| `content_admin` | Content Admin | 6 | false | Back-office | Campaign/Patron/Contact/taxonomy admin, `bypass node access`, `administer users`, near-full transition set. |
| `marketing` | Marketing | 10 | false | Back-office | CMS node/blog/block/gutenberg authoring, `bypass node access`, `administer users`, `export leads`, reports. |

Scope vocabulary used in the matrices:

- `own` — constrained to records owned by / linked to the acting account (enforced in code, not by a
  role permission — see ACL0009).
- `global` — unconstrained across all records the permission covers; **no country/tenant filter**
  (see gap G-03 and BR-MultiTenantCountryScoping).
- `platform` — administrative/site-wide (`administrator`, `bypass node access`, `administer users`).
- `public` — reachable without a back-office role (session tier / REST allow-list).

## Resources

Top-level resource families (detailed rows live in the referenced per-domain ACL docs):

- Application / Lead / ApplicationProfile / application status log → ACL0002 (EN0001, EN0002, EN0025)
- ScoringRecord / Blacklist / Supplier / scoring pages → ACL0003 (EN0016, EN0017, EN0019)
- Campaign / Patron / Blog / CMS nodes / Voucher / taxonomy / Feedback → ACL0004 (EN0004, EN0005, EN0013, EN0024)
- Transaction / RecurringTransaction / payment-gateway callbacks → ACL0005 (EN0009, EN0010)
- TransactionComgateToBank / TransactionBank / BankTransactionMail / Costs & Report snapshots / CSV exports → ACL0006 (EN0029, EN0030, EN0031, EN0032)
- Contract / ContractTemplate / DonationConfirmation → ACL0007 (EN0011, EN0012, EN0014)
- Contact / Organisation / UserNote / Partner → ACL0008 (EN0006, EN0018, EN0023, EN0020)
- User / Account / TaxPayer / login history / public REST surface / magic link → ACL0009 (EN0007, EN0008, EN0015)
- GDPR access / administer * / platform admin → ACL0010

## Matrix (cross-cutting summary)

Only cross-cutting, role-defining grants are listed here; per-resource CRUD rows are in ACL0002–ACL0010.

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `administrator` | * | * | platform | `is_admin: true`; bypasses permission checks; also treated as super-role in `getAllowedStates()` transition gate. Evidence: `config/user.role.administrator.yml`, `application/src/Entity/ApplicationEntity.php:1405`. |
| `anonymous` | public REST resources | GET/POST (allow-listed) | public | 90+ `restful get/post <resource>` grants. Evidence: `config/user.role.anonymous.yml`. |
| `anonymous` | Facebook Lead webhook | GET, POST | public | `restful get/post facebook_lead_webhook_resource` granted to anonymous; resource auth is `cookie` only. Gap G-01. Evidence: `config/user.role.anonymous.yml:156,199`; `config/rest.resource.facebook_lead_webhook_resource.yml`. |
| `authenticated` | public REST + own files + ARES | GET/POST, delete, search | own / public | `ares search by ico`, `delete own files`, `rotate images`. Evidence: `config/user.role.authenticated.yml`. |
| `supporter` | RecurringTransaction | cancel | own | `cancel own recurring transaction` + `restful post transaction_recurring_cancel_resource`. Detail: ACL0005. Evidence: `config/user.role.supporter.yml`. |
| `manager`,`senior_coordinator` | Application moderation_state | force state change | global | `change entity moderation state` → `ChangeModStateForm` bypasses transition legality (gap G-02). Detail: ACL0002. |
| `manager` | GDPR area | access | global | `access gdpr`. Detail: ACL0010. Evidence: `config/user.role.manager.yml`. |
| `front`,`manager`,`content_admin`,`marketing` | User accounts | administer | platform | `administer users` on non-admin back-office roles. Detail: ACL0009/ACL0010. |
| `content_admin`,`manager`,`marketing` | Nodes | bypass node access | platform | `bypass node access`. Detail: ACL0004. |
| back-office reporting roles | CSV exports | download | global (no country filter) | Export routes gated only by `access reports` / `export leads` / `access accounting reports`; no tenant scoping (gap G-03). Detail: ACL0006. |

## Exceptions

- **Country / tenant scope is not an ACL dimension in the current system.** No role permission,
  route requirement, or export query filters records by CZ/RO/MD. Cross-country reads are therefore
  possible for any role whose permission covers the resource. Owned by BR-MultiTenantCountryScoping;
  surfaced here as gap G-03.
- **`administrator` short-circuits** both Drupal permission checks and the code-level transition
  allow-list (`getAllowedStates()` treats `administrator` as unconditionally allowed).
- **End-user business positions rely on ownership checks in code, not on role permissions.** A
  `patron`/`supporter`/`fundraiser` acting via the REST API is authorized by the resource plugin's
  ownership logic, not by a role grant. See ACL0009.

## Current-state access gaps (findings)

These are recorded, not resolved. Each is `Confirmed` against code/config.

| ID | Gap | Resource / surface | Evidence | Owning BR |
|---|---|---|---|---|
| **G-01** | Facebook Lead webhook reachable by **anonymous** (GET+POST), authenticated only by `cookie`; a Lead-creating webhook has no role gate. | `facebook_lead_webhook_resource` | `config/user.role.anonymous.yml:156,199`; `config/rest.resource.facebook_lead_webhook_resource.yml`; `facebook_leads/src/Plugin/rest/resource/FacebookLeadWebhookResource.php` | BR-AccessControlAndRoles |
| **G-02** | **Transition legality not enforced** on the live moderation-state change form. `ChangeModStateForm` offers *all* states via `getApplicationModStats()` and calls `setState($value, true, …)` (force) which writes `moderation_state` directly + raw-SQL INSERT into `application_states`, bypassing the `application_states.yml` `transitions`/`transition_roles` gate that `getAllowedStates()` honours. Gated only by the single `change entity moderation state` permission. | Application (EN0001) moderation state | `application/src/Form/ChangeModStateForm.php:48,80`; `application/src/Entity/ApplicationEntity.php:292–327,1396–1425`; `application/application.routing.yml` (`application.change_mod_state_form`) | BR-ApplicationStatusGovernance |
| **G-03** | **No country/tenant scoping on exports** (or on back-office reads generally). CSV export routes require only `access reports`/`export leads`/`access accounting reports`; the export controller applies no CZ/RO/MD filter, so any authorized role can export cross-tenant data. | `export_csv.*` routes | `export_csv/export_csv.routing.yml`; `export_csv/src/Controller/ExportCSVController.php` (no country/langcode/condition on queries) | BR-MultiTenantCountryScoping, BR-ReportingAndDataAccess |
| **G-04** | **Raw-SQL state writes without workflow scoping.** Application state changes are persisted through a hand-written `INSERT` into `application_states` and a direct `set('moderation_state', …)`, outside content-moderation transition validation. Combined with G-02 this means a forced/illegal state can be committed with no legality check. | Application state history | `application/src/Entity/ApplicationEntity.php:312–327` | BR-ApplicationStatusGovernance |
| **G-05** | **Payment gateway callback routes are effectively public.** ComGate `/transaction/status_update`, MAIB `/transaction/status_update`, and Netopia confirm/redirect routes require only `access content` (held by anonymous). Callback authenticity relies on gateway-side signatures, not on Patronus ACL. | payment callback controllers | `comgate/comgate.routing.yml`; `maib/maib.routing.yml`; `netopia/netopia.routing.yml` | BR-PaymentGatewayCallbacks |
| **G-06** | **Two parallel authorization models for Application transitions** that are not kept in sync: (a) config `use application_workflow transition <X>` permissions per role, and (b) code `transition_roles` allow-list in `application_states.yml`. A role can hold one without the other; `ChangeModStateForm` honours neither. | Application transitions | `config/user.role.*.yml` (`use application_workflow transition *`); `application/application_states.yml` (`transition_roles`) | BR-ApplicationStatusGovernance |

## References

- UC: UC0014 (authenticate/manage access), UC0002 (orchestrate application status change), UC0017 (export reporting data), UC0005/UC0006 (donation/confirm payment)
- FN: FN0018 (identity & access control), FN0002 (application status orchestration), FN0020 (reporting CSV export)
- EN: EN0008 (User), EN0007 (Account), EN0001 (Application)
- BR: BR-AccessControlAndRoles, BR-MultiTenantCountryScoping, BR-ReportingAndDataAccess, BR-ApplicationStatusGovernance, BR-PaymentGatewayCallbacks
- ARCH: ARCH0011 (Identity and Access)

## Open Items

- Ownership-based authorization for end-user REST resources (patron/supporter/fundraiser) is enforced
  in resource plugin code, not in config; per-resource ownership predicates are catalogued at the
  API-contract layer (not yet generated) — see ACL0009 open items.
- The precise per-role `transition_roles` allow-list (code) vs `use ... transition` permissions
  (config) divergence per transition key is enumerated in ACL0002; full row-by-row reconciliation is
  deferred to the API/contract pass.
