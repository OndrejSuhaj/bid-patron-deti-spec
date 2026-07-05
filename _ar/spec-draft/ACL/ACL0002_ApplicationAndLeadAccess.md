---
doc_id: ACL0002
title: Application & Lead Access
canonical_layer: ACL
spec_type: access-control
status: draft
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

# ACL0002 – Application & Lead Access

## Purpose

Access to the Application/Lead aggregate: Application (EN0001), ApplicationProfile (EN0002),
ApplicationLog / status log (EN0025), leads, application pairing, workflow transitions, and forced
moderation-state change. Actor model is owned by ACL0001.

## Actor Model

- Back-office roles operate on Applications: `coordinator`, `senior_coordinator`, `front`, `manager`,
  `content_admin`, `risk_manager` (scoring subset), `accountant` (view + `gift_paid` only).
- End users create/read their own Applications via the public REST surface (see ACL0009), not via
  these permissions.
- Scope for all back-office grants below is `global` — no country/tenant filter (ACL0001 gap G-03).

Evidence for role grants: `config/user.role.<id>.yml`; permission definitions:
`application/application.permissions.yml`, `export_csv/export_csv.permissions.yml`.

## Resources

- Application entity (EN0001) — create/edit/view/revisions/archive
- ApplicationProfile entity (EN0002) — create/edit/view (patron/fundraiser sub-profiles)
- Lead — `add leads` (Application in lead phase)
- Application status log (EN0025) — `view application status log`
- Application workflow transitions — `use application_workflow transition <X>`
- Forced moderation state — `change entity moderation state`
- Application pairing — `application pairing`
- Lead export — `export leads`

## Matrix

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `coordinator` | Application (EN0001) | add, edit, view published/unpublished, view all revisions | global | `add application entities`, `edit application entities`, `view (un)published application entities`, `view all application revisions`. |
| `coordinator` | ApplicationProfile (EN0002) | add, edit | global | `add/edit application profile entities`. |
| `coordinator` | Lead | add | global | `add leads`. |
| `coordinator` | Application pairing | pair | global | `application pairing`. |
| `coordinator` | Application transitions | use (broad set incl. `gift_paid`,`in_progress`,`scoring`) | global | 40+ `use application_workflow transition *` grants; see role config. |
| `coordinator` | Lead export | export | global | `export leads`. |
| `senior_coordinator` | Application / Profile / Lead | add, edit, view, revisions, pair | global | Same base as coordinator. |
| `senior_coordinator` | Application moderation_state | **force change** | global | `change entity moderation state` → `ChangeModStateForm`; bypasses transition legality (ACL0001 G-02, G-04). |
| `senior_coordinator` | moderation state (content_moderation) | change entity moderation state | global | Also `change entity moderation state`. |
| `front` | Application / Profile / Lead | add, edit, view, revisions, pair | global | Reduced transition set (no `scoring`,`gift_*`,`in_progress`); adds `edit campaign entities`. |
| `front` | Application transitions | use (reduced set) | global | e.g. `application_processing`, `cancel_lead`, `close`, `duplicate`, `mistake`, reminders, `suspended*`, `uncompleted`, `waiting`. |
| `front` | Lead export | export | global | `export leads`. |
| `manager` | Application / Profile / Lead | add, edit, view, all revisions, archive, pair | global | Broadest transition set incl. `scoring_ok`,`scoring_ko`,`correction`,`gift_paid`; `administer application_statuses`; `view application archive`. |
| `manager` | Application moderation_state | **force change** | global | `change entity moderation state` (ACL0001 G-02). |
| `content_admin` | Application (EN0001) | edit, view published/unpublished, view all revisions | global | `edit application entities`, `edit application profile entities`; near-full transition set (no `scoring_ok/ko`,`gift_paid`,`in_progress`). |
| `content_admin` | Application status log (EN0025) | view | global | `view application status log`. |
| `risk_manager` | Application (EN0001) | edit, view | global | `edit application entities`, `edit application profile entities`; scoring transitions only (see ACL0003). |
| `accountant` | Application (EN0001) | view published/unpublished, view archive | global | `view (un)published application entities`, `view application archive`; single transition `gift_paid`. |
| `coordinator`,`senior_coordinator`,`front`,`manager`,`content_admin`,`risk_manager` | Application status log (EN0025) | view | global | `view application status log` (accountant excluded). |
| `administrator` | Application transitions | use (all) | platform | Treated as unconditionally allowed in `getAllowedStates()` (ApplicationEntity.php:1405). |

## Transition authorization — two parallel models (ACL0001 G-06)

Two independent mechanisms govern who may move an Application between statuses:

1. **Config permissions** — `use application_workflow transition <key>` per role in
   `config/user.role.*.yml` (Drupal content-moderation transition permission). Used by the standard
   moderation UI.
2. **Code allow-list** — `transition_roles:` in `application/application_states.yml`, consulted by
   `ApplicationEntity::getAllowedStates()` (ApplicationEntity.php:1396–1425), which also honours the
   `transitions` `from`/`to` legality and treats `administrator` as always-allowed. Roles present in
   `transition_roles`: `accountant`, `content_admin`, `coordinator`, `front`, `manager`,
   `risk_manager`, `senior_coordinator`.

These two lists are not guaranteed to agree, and **neither is consulted by `ChangeModStateForm`**,
which offers every state unconditionally and forces the write (ACL0001 G-02). Rule semantics are
owned by BR-ApplicationStatusGovernance; this doc records only the access surface.

## Exceptions

- `ChangeModStateForm` route `application.change_mod_state_form` requires only
  `change entity moderation state`; it does not check the target transition's legality or the acting
  role's transition allow-list. Held by `manager` and `senior_coordinator` (ACL0001 G-02).
- Application state history is persisted by raw SQL INSERT into `application_states`
  (ApplicationEntity.php:312–327), independent of content-moderation validation (ACL0001 G-04).
- No CZ/RO/MD scope on any Application grant (ACL0001 G-03).

## References

- UC: UC0001 (submit application), UC0002 (orchestrate application status change), UC0025 (resume/discard draft)
- FN: FN0001 (application intake), FN0002 (status orchestration), FN0003 (scheduled status transition)
- EN: EN0001 (Application), EN0002 (ApplicationProfile), EN0025 (ApplicationLog)
- BR: BR-ApplicationStatusGovernance
- ARCH: ARCH0003 (Application and Lead)

## Open Items

- Row-by-row divergence between config `use ... transition` grants and code `transition_roles`
  per transition key is not fully enumerated here; deferred to the API/contract pass.
