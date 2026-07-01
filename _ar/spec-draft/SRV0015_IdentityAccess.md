# SRV0015 — Identity & Access

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C9 — Identity & Access

## SRV Category
Infrastructure / Security

## Responsibility Type
Infrastructure

## Purpose
Provides authentication, session issuance, login auditing, role/permission enforcement, form-access gating, and GDPR anonymisation. It is the cross-cutting security layer: the JSON login/session API, magic-link auth, per-application form access checks, and the right-to-be-forgotten flow.

## Current Implementation Shape
- **Auth/session API:** `account` module REST — `/api/3.0/session/token`, `/api/user/exists`, `/magic-link/{hash}`, `/login`, `/activation-mail`. `Evidence:` `PSRC/web/modules/custom/account/account.routing.yml`; [entrypoints.md §2](../repo-map/entrypoints.md).
- **Login audit:** `login_history` — one of only two custom `hook_schema()` tables. `Evidence:` `PSRC/web/modules/custom/login_history/login_history.install`; [data-model-signals.md §1](../repo-map/data-model-signals.md).
- **Roles/permissions:** Drupal `user.role.*` config + per-module `*.permissions.yml` (~26 modules). `Evidence:` [entrypoints.md §10](../repo-map/entrypoints.md); [modules.md §5](../repo-map/modules.md).
- **Form access gating:** `patron_form_access` — configurable access checks for application forms; `AccessDeniedSubscriber`; access checks `access_check.application.role|status`. `Evidence:` `PSRC/web/modules/custom/patron_form_access/`; [entrypoints.md §5,§6](../repo-map/entrypoints.md).
- **GDPR:** `gdpr` module (anonymisation). `Evidence:` `PSRC/web/modules/custom/gdpr/`; [modules.md §2](../repo-map/modules.md).
- **No external SSO** — no OAuth/SAML/LDAP in custom code; standard Drupal auth. `Evidence:` [integrations.md §6](../repo-map/integrations.md).

## Structural Issues
- **Access logic spread** — form-access rules live in `patron_form_access` while auth lives in `account`, and permissions are per-module (~26 `*.permissions.yml`) — no single access model. `Evidence:` [entrypoints.md §5,§10](../repo-map/entrypoints.md).
- **Magic-link/session surface** — custom login endpoints (`/magic-link/{hash}`, `/login`) are custom auth code needing security review. `Evidence:` [entrypoints.md §2](../repo-map/entrypoints.md).
- **GDPR anonymisation scope unverified** — which entities/fields are scrubbed is not traced. `Evidence:` [modules.md §2](../repo-map/modules.md).
- **Dev module enabled** — `patron_devel` present in `core.extension.yml` (debug endpoints risk in prod). `Hypothesis` — `Evidence:` [SRV-candidates.md §5](SRV-candidates.md).

## Target Shape (for rewrite)
A dedicated Identity & Access service: single auth provider, centralized RBAC policy, form/route access as declarative policies, and an auditable GDPR anonymisation command. Custom login flows replaced or hardened; dev tooling excluded from prod builds.

## Integration Dependencies
None external (standard Drupal auth; no SSO/OAuth/SAML/LDAP in custom scope). `Confirmed` — [integrations.md §6](../repo-map/integrations.md).

## Boundaries
Does NOT own the person/contact records → SRV0012. Does NOT own login-driven notifications → SRV0013. Does NOT own risk decisions → SRV0003. Does NOT own the platform workflow kernel → SRV0017.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Magic-link token generation/expiry and replay protection. `Missing evidence: magic-link handler code.`
- GDPR anonymisation coverage (which entities/fields). `Missing evidence: gdpr module scrub inventory.`
- Full role model and how ~26 permission sets compose. `Missing evidence: user.role.* + permissions.yml consolidation.`
