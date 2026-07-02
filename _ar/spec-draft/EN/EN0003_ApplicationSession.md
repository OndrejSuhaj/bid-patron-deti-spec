---
doc_id: EN0003
title: ApplicationSession
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001 (Application)
---

# EN0003 — ApplicationSession

## Description
An ApplicationSession governs *how* and *by whom* a given Application form can be accessed during the multi-step intake. Each session pairs a role (fundraiser/patron) with an interface variant and a JSON form schema, and can be active or deactivated. Sessions are created when an Application is created (one per relevant role) and are bulk-deactivated when the Application enters a state configured to invalidate sessions. It is the access/interface control record for front-end application editing.

## Entity Category
Persisted  ·  Confidence: High

## Origin
- DB artifacts: base_table `application_session`; not revisionable, not translatable; source = base fields (no hook_schema).
- Code touchpoints: `application/src/Entity/ApplicationSessionEntity.php` (`deactivate()`); `ApplicationSessionEntityStorageSchema.php` (composite index); created by `ApplicationEntity::postCreate` (`createPatronSession`/`createFundraiserSession`); deactivated via application_reaction `cancelSessions` → `ApplicationService::deactivateSessions`.
Evidence: `ApplicationSessionEntity.php`; `ApplicationSessionEntityStorageSchema.php`; `ApplicationEntity::postCreate`

## Core Fields
- application_uuid (string(128); optional; holds an Application UUID **by naming convention** — plain string, no entity_reference/FK — logical link to EN0001 Application)
- interface (string(30); optional; runtime values: invited, authenticated_invited, custom)
- role (list_string; optional; fundraiser / patron)
- schema (string_long; optional; JSON form definition `{"sections":…}`)
- status (boolean; default TRUE; `deactivate()` sets FALSE)
- readonly (boolean; default FALSE)

## Technical Fields
- session_id (uuid; **required**; entity_keys.uuid = session_id — this uuid IS the session identifier).
- langcode; created / changed.

## Relations
Logical (not declared) link: `application_uuid` → EN0001 Application, matched by UUID string, NOT a Drupal entity_reference and NOT a DB FK. No hard relations declared.

## Allowed Statuses
`status` boolean: TRUE (active) / FALSE (deactivated). `role` enum: fundraiser / patron. `interface` is an open string with observed runtime values (invited, authenticated_invited, custom).
Evidence: `ApplicationSessionEntity.php` baseFieldDefinitions

## Lifecycle
Confirmed transitions (code-path evidenced):
- (create) → status=TRUE, interface per role — `ApplicationEntity::postCreate createPatron/FundraiserSession`. [FLW0010]
- active → deactivated (all sessions of an Application) when new Application state ∈ `invalidate_sessions` config — application_reaction `cancelSessions` → `ApplicationService::deactivateSessions`. [FLW0001]

Missing evidence: no re-activation path observed; `readonly` toggle trigger not traced to a specific flow.

## Spec Alignment
N/A — No EN spec files found in repository (see EN-candidates.md §Spec Discovery).

## Open Questions
- What determines `interface` = invited vs. authenticated_invited vs. custom at creation?
- Since `application_uuid` is a plain string, how are orphaned sessions (deleted Application) handled?
- Can a deactivated session be re-activated, or is a new one always created?
