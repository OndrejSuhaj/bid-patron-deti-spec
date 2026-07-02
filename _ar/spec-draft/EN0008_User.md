---
doc_id: EN0008
title: User
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001 (Application)
  - EN0006 (Contact)
  - EN0007 (Account)
---

# EN0008 — User (Party)

## Description
The User is the first-class Party in the domain: the Drupal core `users` entity, replaced by the custom `PatronUser` class and extended with Patronus-specific base fields (name parts, slug, public flag, worker availability, a link to Contact, and an ML `model`). Every actor — applicant (fundraiser), patron, supporter, plus back-office staff — is a User differentiated by role. It is the ownership/authorship anchor referenced by nearly every domain entity.

## Entity Category
Persisted  ·  Confidence: High

## Origin
- DB artifacts: core `users` / `users_field_data` (Drupal core), extended by config fields (`field.storage.user.*`) and code base fields (`account_entity_base_field_info`). `application_update_8013` ALTERs core `users` (`uid` → serial).
- Code touchpoints: entity class `account/src/PatronUser.php` (extends core `User`; `postSave` enqueues to `es_upload_queue` + `mautic_queue` via `patron_base.default::addToQueue`); added base fields in `account/account.module::account_entity_base_field_info`; registration/role via `AccountService::register` / `updateUserRole`.
Evidence: `PatronUser.php` (`postSave`); `account.module` (`account_entity_base_field_info`); `AccountService.php`

## Core Fields
- roles (core; domain roles: fundraiser / patron / supporter / organisation_worker + back-office accountant / content_admin / coordinator / senior_coordinator / front / manager / marketing / risk_manager / administrator — per `user.role.*` config)
- mail / name (core; anonymized in place by GDPR flow — see Lifecycle)
- first_name / last_name (string; account base fields), title_prefix / title_suffix (string), name_format (list_string; full/short/hidden)
- slug (string; account base field), public (boolean; profile public?), worker_available (boolean)
- contact (entity_reference → EN0006 Contact; the party's Contact record)
- user_name (string; config field), user_bank_account (string; config field), user_image (image → file; config field)

## Technical Fields
- uuid / langcode (framework). model (string_long; serialized PHP-ML classifier — see EN0007 Account / dormant recommendation subsystem, FLW0030). training_queue / scoring_queue / activate_session (queue/session housekeeping flags). `campaign_recommendation` base field is **commented out** in `account.module` — field storage impossible today (`Conflict`/dormant).

## Relations
Soft entity_reference (no DB FK): `contact` → EN0006 Contact. Inbound (heavy): EN0001 Application (fundraiser, patron, lead_user_id, scoring_user, user_id), EN0007 Account (user_id), EN0004 Campaign, EN0002 ApplicationProfile, EN0018 Organisation (worker/manager), and most other entities reference User as owner/author/actor.

## Allowed Statuses
Core Drupal user status: active / blocked (published flag). Domain differentiation is by **role**, not a status enum. `postSave` unconditionally enqueues the user to `es_upload_queue` and `mautic_queue`.
Evidence: `PatronUser::postSave`; `user.role.*.yml`

## Lifecycle
Confirmed transitions (code-path evidenced):
- (anonymous) → registered (active, no password) + role fundraiser|patron|supporter + Contact — `AccountService::register`. [FLW0010, FLW0015]
- (new, from application) → created **blocked/password-less** + role patron|fundraiser + Contact — `CreateUserController`; `AccountService`. [FLW0026]
- blocked → active + password reset (magic-link side effect) — `AccountService::getUserMagicLink`. [FLW0014, FLW0015]
- anonymous → authenticated (login/access ts) — `AccountLoginResource` `user_login_finalize()`. [FLW0014]
- active → **anonymized-in-place** (`mail=''`, random `name`; NOT deleted/cancelled; related PII retained) — `gdpr/src/Form/GDPRMailForm.php`. [FLW0020]
- (owner of duplicate contact) active → **hard-deleted** (bypasses cancel/anonymise) — `ContactRemoveDuplicatesController::User->delete()`. [FLW0023]
- (nonexistent/plain) → `organisation_worker` (role + contact link; blocked→activation email) — `OrganisationWorkerForm`. [FLW0024]

Missing evidence: **login_history writes NO row** (write hook commented out, FLW0014); GDPR anonymization is incomplete (Application/Contact PII not cascaded, FLW0020); Mautic upsert re-adds even anonymized users (anti-erasure, FLW0019/0020).

## Spec Alignment
N/A — No EN spec files found in repository (see EN-candidates.md §Spec Discovery).

## Open Questions
- Given GDPR anonymizes in place but Mautic re-upserts by email, how is true erasure achieved?
- Which single field/marker distinguishes a fundraiser User from a patron User beyond role?
- Is the `model` field on User authoritative vs. the `model` on Account (EN0007)?
- Why is `campaign_recommendation` commented out — planned, removed, or moved?
