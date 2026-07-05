---
doc_id: ACL0010
title: GDPR & Platform Administration Access
canonical_layer: ACL
spec_type: access-control
status: draft
references:
  - EN0008
  - UC0015
  - UC0020
  - UC0022
  - FN0021
  - FN0023
  - FN0025
  - BR-DataProtectionAndErasure
  - BR-OperationalAlerting
  - ARCH0011
  - ARCH0012
---

# ACL0010 – GDPR & Platform Administration Access

## Purpose

Access to cross-cutting administrative surfaces: GDPR area (data protection / erasure), `administer *`
entity-administration permissions, feature toggles, application-status administration, taxonomy/site
configuration, and the super-role. Actor model owned by ACL0001.

## Actor Model

- `administrator` is the platform super-role (`is_admin: true`); it bypasses all permission checks.
- `manager` holds the widest set of `administer *` grants among non-super roles and is the only role
  with `access gdpr`, `administer application_statuses`, and `enable and disable features`-adjacent
  authority (feature toggle is a separate `enable and disable features` permission, not granted to any
  configured role — see Exceptions).
- Scope is `platform`.

Evidence: `config/user.role.administrator.yml`, `config/user.role.manager.yml`;
`gdpr/gdpr.routing.yml`, `patron_base/patron_base.routing.yml`; permission defs
`gdpr/gdpr.permissions.yml`, `patron_base/patron_base.permissions.yml`.

## Resources

- GDPR mail/erasure area `/admin/gdpr/*` — `access gdpr`
- Application-status administration — `administer application_statuses`
- Feature toggles `/admin/features` — `enable and disable features`
- Create-user `/admin/create_user` — `manager administer users`
- Entity administration (`administer <entity> entities`) — restricted permissions
- Site/taxonomy/config administration — `administer taxonomy`, `administer content types`, `administer site configuration`

## Matrix

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `administrator` | * | * | platform | `is_admin: true`; bypasses permission checks; empty explicit permission set. |
| `manager` | GDPR area `/admin/gdpr/*` | access | platform | `access gdpr`. Only role with this grant. |
| `manager` | Application statuses | administer | platform | `administer application_statuses`. |
| `manager` | Create-user `/admin/create_user` | create | platform | `manager administer users`. |
| `manager` | Content types / nodes | administer | platform | `administer content types`, `administer nodes`, `bypass node access`. |
| `manager` | TaxPayer (EN0015) | administer | platform | `administer tax_payer entities`. |
| `content_admin` | Content types / nodes / taxonomy | administer | platform | `administer content types`, `administer nodes`, `administer taxonomy`, `bypass node access`. |
| `content_admin` | TaxPayer (EN0015) | administer | platform | `administer tax_payer entities`. |
| `content_admin` | Block content / block types | administer | platform | `administer block content`, `administer block types`, `administer blocks`. |
| `content_admin` | Campaign (EN0004) | administer | platform | `administer campaign entities`. |
| `marketing` | Content types / nodes / image styles / blocks | administer | platform | `administer content types`, `administer nodes`, `administer image styles`, `administer blocks`, `bypass node access`. |
| `marketing` | Blog (EN0024) | administer | platform | `administer blog entity entities`. |
| `risk_manager` | Taxonomy | administer | platform | `administer taxonomy`. |
| roles with `administer site configuration` (`administrator` only) | Bank integration config | set | platform | `/admin/config/bank-integration/*`. |
| (no configured role) | Feature toggles `/admin/features` | enable/disable | platform | `enable and disable features` — permission defined but granted to no role in config (only reachable by `administrator` via is_admin bypass). See Exceptions. |

## Exceptions

- **`enable and disable features`** is defined in `patron_base.permissions.yml` and gates
  `/admin/features`, but is not assigned to any of the 15 configured roles — reachable only through
  `administrator`'s `is_admin` bypass. Recorded as current-state (`Confirmed`).
- Many `administer <entity> entities` permissions are `restrict access: true` (flagged sensitive) yet
  assigned to non-super roles (e.g. `administer campaign entities` → content_admin, manager;
  `administer tax_payer entities` → content_admin, manager). Recorded as observed grant, not endorsed.
- GDPR erasure semantics (what data is anonymised, retention) are owned by
  BR-DataProtectionAndErasure; only the access gate (`access gdpr`) is recorded here.
- Operational alerting / audit channels (Slack ES0015, Telegram ES0016) and the platform workflow
  engine (FN0025) run as system/cron actors, not role-gated user actions — no user-facing ACL rows.

## References

- UC: UC0015 (anonymize personal data), UC0020 (emit ops alerts/audit), UC0022 (run platform workflow engine)
- FN: FN0021 (personal data anonymisation), FN0023 (operational alerting/audit), FN0025 (workflow engine / scheduled publish)
- EN: EN0008 (User)
- BR: BR-DataProtectionAndErasure, BR-OperationalAlerting
- ARCH: ARCH0011 (Identity and Access), ARCH0012 (Platform, Search and Operations)

## Open Items

- Whether `enable and disable features` being unassigned is intentional (admin-only) or a config
  oversight cannot be resolved from source; recorded for rebuild review.
