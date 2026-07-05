---
doc_id: ACL0009
title: Identity, Access & Public API
canonical_layer: ACL
spec_type: access-control
status: draft
references:
  - EN0007
  - EN0008
  - EN0015
  - UC0014
  - UC0024
  - FN0018
  - BR-AccessControlAndRoles
  - ARCH0011
---

# ACL0009 – Identity, Access & Public API

## Purpose

Access to identity/session resources — User (EN0008), Account (EN0007), TaxPayer (EN0015) — the
end-user REST surface (login/activation/profile/application/children), magic-link, session token, and
own login-history. This is where the **session tier** and **end-user business positions** obtain
their authority. Actor model owned by ACL0001.

## Actor Model

- `anonymous` / `authenticated` carry the public REST allow-list (config `restful get/post <resource>`).
- End-user positions (`patron`, `supporter`, `fundraiser`, `organisation_worker`) hold almost no
  config permissions; their authority over their **own** records comes from **ownership checks inside
  the REST resource plugins**, not from role grants (Hard Rule: UI/ownership visibility is not a role
  grant — recorded explicitly).
- Several identity routes are guarded by `_access: 'TRUE'` (public) or `_user_is_logged_in: 'FALSE'`.

Evidence: `config/user.role.anonymous.yml`, `config/user.role.authenticated.yml`;
`account/account.routing.yml`, `login_history/login_history.routing.yml`,
`patron_base/patron_base.routing.yml`; permission defs `account/account.permissions.yml`,
`login_history/login_history.permissions.yml`.

## Resources

- Session token `/api/3.0/session/token`, user-exists `/api/user/exists`
- Magic-link login `/magic-link/{hash}`, login `/login`, activation-mail `/activation-mail`
- Tax-payer information form `/tax-payer-information` (TaxPayer EN0015)
- Public REST: login/activate/status/logout, profile (get/post), application (create/get/repeat/cancel/progress), user children, user applications, password request/recover, magic-link create
- Own login history `/user/{user}/login-history`
- Magic-link use (back-office) — `use magic link`

## Matrix

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `anonymous` | Session token `/api/3.0/session/token` | GET | public | Route `_access: 'TRUE'`. |
| `anonymous` | User-exists `/api/user/exists` | GET | public | Route `_access: 'TRUE'`. |
| `anonymous` | Magic-link `/magic-link/{hash}` | GET | public | Route `_access: 'TRUE'`; token-based auth (90-day validity — see BR-AccessControlAndRoles). |
| `anonymous` | Login `/login`, activation-mail `/activation-mail` | POST | public | `_access: 'TRUE'` / `_user_is_logged_in: 'FALSE'`. |
| `anonymous` | Tax-payer info `/tax-payer-information` (EN0015) | submit | public | Route `_access: 'TRUE'`. |
| `anonymous` | Account login/activate/status REST | POST/GET | public | `restful post account_login_resource(_v32)`, `account_activate_resource(_v32)`, `account_status_resource`. |
| `anonymous` | Profile REST (EN0007) | GET, POST | public | `restful get/post profile_resource(_v32)`, `profile_slug_v32`. |
| `anonymous` | Application REST (EN0001) | create, get, repeat, cancel, progress | public / own | `restful post application_create_resource_v30/_v32`, `..._repeat`, `cancel_application_*`, `application_progress_*`; ownership enforced in resource code. |
| `anonymous` | User children / user applications | GET | own | `restful get user_children_resource(_v32)`, `user_application_resource_v30/_v32`; ownership in resource code. |
| `anonymous` | Password request/recover | POST | public | `restful post password_request_resource(_v32)`, `password_recover_resource(_v32)`. |
| `authenticated` | Logout | GET | own | `restful get account_logout_resource_v32`. |
| `authenticated` | Own files | delete | own | `delete own files`. |
| `authenticated` | Superset of anonymous REST | GET/POST | public / own | Authenticated role duplicates the anonymous allow-list + logout + contact_form_resource_32 + profile_resource_v31. |
| `patron` | (config permissions) | delete own files; text formats | own | No entity-CRUD role grants; own-record access is ownership-based in REST code. |
| `supporter` | RecurringTransaction | cancel | own | `cancel own recurring transaction` (detail ACL0005). |
| `fundraiser` | Contact (EN0006) | add, edit | global | Detail ACL0008. |
| `organisation_worker` | own files | delete | own | `delete own files` only. |
| `coordinator`,`senior_coordinator`,`risk_manager` | Magic link | use | global | `use magic link`. |
| `front` | User (EN0008) | administer, update | platform | `administer users`, `update user entity`, `update fundraiser email`, `update patron email`. |
| `manager` | User (EN0008) | administer, `manager administer users`, update | platform | `administer users`, `manager administer users`, `update user entity`, access user profiles. |
| `content_admin` | User (EN0008) | administer | platform | `administer users`. |
| `manager`,`risk_manager` | User profiles | access | platform | `access user profiles`. |
| roles with `manager administer users` (`manager`) | Create-user `/admin/create_user` | create | platform | Route `patron_base.manager_create_user_form` requires `manager administer users`. |
| `manager` | All login histories `/admin/reports/login-history` | view | global | `view all login histories`. |
| `manager` | Own login history | view | own | `view own login history`. |
| any user (custom check) | `/user/{user}/login-history` | view | own | `_custom_access: LoginHistoryController::checkUserReportAccess` (ownership/admin check in code). |

## Exceptions

- **Ownership-based authority is not a role grant.** End-user access to own Application/profile/
  children/recurring-transaction is enforced by resource-plugin ownership predicates, not by
  `user.role.*.yml`. Per Hard Rule 7, this is recorded as ownership logic, not as a confirmed role
  permission; predicate details are deferred to the API/contract pass.
- **Multiple `_access: 'TRUE'` identity routes** (`/api/3.0/session/token`, `/api/user/exists`,
  `/magic-link/{hash}`, `/login`, `/tax-payer-information`) are public by route requirement.
- Current-state authentication gaps (magic-link 90-day validity, flood-control discarded on legacy
  login surfaces, login-history write disabled, CSRF-less admin user creation from read-style request)
  are owned by BR-AccessControlAndRoles §Authentication; referenced, not restated.

## References

- UC: UC0014 (authenticate/manage access), UC0024 (manage donor account), UC0001 (submit application)
- FN: FN0018 (identity & access control)
- EN: EN0007 (Account), EN0008 (User), EN0015 (TaxPayer)
- BR: BR-AccessControlAndRoles
- ARCH: ARCH0011 (Identity and Access)

## Open Items

- Full enumeration of per-REST-resource ownership predicates (which fields key ownership for each
  public resource) is deferred to the API/contract pass.
- The magic-link `use magic link` back-office permission vs the public `/magic-link/{hash}` route
  distinction (issue vs consume) is noted; issuance-side authorization detail deferred.
