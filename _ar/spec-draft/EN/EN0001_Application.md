---
doc_id: EN0001
title: Application
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0002 (ApplicationProfile)
  - EN0003 (ApplicationSession)
  - EN0004 (Campaign)
  - EN0006 (Contact)
  - EN0008 (User)
---

# EN0001 — Application

## Description
The Application (Žádost) is the core aggregate root of the Patronus domain — the "Lead → Application" hub that ties together the applicant (fundraiser), patron, child, coordinator, scoring, contracts and the resulting Story (Campaign). Its `state` field drives a large content-moderation workflow (`application_workflow`, ~66 states) that governs every downstream process area (ŽÁDOST FRONT/BACK, RISK, DONATIONS, CONTENT). It is revisionable and translatable.

## Entity Category
Persisted  ·  Confidence: High

## Origin
- DB artifacts: base_table `application`; revisionable (`application_revision` / `application_field_revision`); translatable (per `language.content_settings.application.application.yml`); source *mixed* (base fields + attached config field `status_note`); raw side table `application_states` (status-history audit).
- Code touchpoints: `application/src/Entity/ApplicationEntity.php` (`setState`, `preSave`, `postSave`, `postCreate`, `removePatron`, `updateCampaignStatus/Category`); `ApplicationEntityStorageSchema.php` (indexes); creation via `UserCreateForm::createApplication` / `CreateUserController`.
Evidence: `ApplicationEntity.php`; `ApplicationEntityStorageSchema.php`; `config/field.storage.application.status_note.yml`

## Core Fields
- fundraiser (entity_reference → EN0008 User; optional; applicant/žadatel; revisionable; cleared in `removePatron()`)
- patron (entity_reference → EN0008 User; optional; the patron; revisionable)
- lead_user_id (entity_reference → EN0008 User; optional; coordinator)
- scoring_user (entity_reference → EN0008 User; optional; who scored)
- child (entity_reference → EN0006 Contact; optional; the child)
- lead_contact (entity_reference → EN0006 Contact; optional; lead contact; part of composite index)
- fundraiser_profile / patron_profile (entity_reference → EN0002 ApplicationProfile; optional)
- patron_employer_id (entity_reference → EN0018 Organisation; optional)
- campaign (entity_reference → EN0004 Campaign; optional; Story; status/category synced in postSave)
- category (entity_reference → taxonomy_term `category`; optional; area of assistance)
- state (list_string; optional; primary status; allowed values from `getAllStates()`/`application_states.yml`; kept in lock-step with `moderation_state` in `setState()`)
- lead_role (list_string; optional; patron / fundraiser / organisation_worker)
- lead_source (list_string; web, manual, mail, nadace, zone, zone_repeat, zone_profi, fcb, phone)
- activity / activity_note (list_string / string_long; call, email, sms, others)
- flag (list_string; unlimited; runtime `application_flags` state, e.g. covid19)
- contract_type (list_string; good, service, transfer, nno, amendment, rental_contract, ukraine)
- scoring / scoring_low_risk (string_long; JSON scoring objects), scoring_low_risk_score (integer), scoring_fundraiser/patron/gift (list_string ok/ko), scoring_coord_note/decision
- status_note (string; attached config field; "Poznámka ke změně statusu")

## Technical Fields
- uuid / langcode / vid + `revision_user`/`revision_created`/`revision_log` (framework revision keys).
- ip_address / user_agent / x_tracking_* (request + UTM tracking; x_tracking_* ReadOnly).
- `moderation_state` — referenced in code but NOT declared in `baseFieldDefinitions()` (supplied by content_moderation config); the published `status` key has no backing field. `Conflict — requires clarification`.

## Relations
Contract references (soft entity_reference, no DB FK): contract, delivery_note (Takeover protocol), acceptance_protocol (Guide), appendix (unlimited) → EN0011 Contract. File references: attachements *(sic)*, attachments_audit → file. All 20 relations are Drupal soft references (target_id only; no DB-level FK).

## Allowed Statuses
`state` allowed values are dynamic, sourced from `getAllStates()` / `application_states.yml` and the bound `workflows.workflow.application_workflow` (~66 states). Enum is large and country-specific (CZ/RO/MD); the canonical status vocabulary lives in the status model (`intake/statuses/`), not restated here.
Evidence: `ApplicationEntity.php::getAllStates`; `config/.../application_workflow`

## Lifecycle
Confirmed transitions (code-path evidenced):
- (create) → `new` (+ initial `application_states` audit row) — `UserCreateForm::createApplication`; `ApplicationEntity::postSave`. [FLW0010, FLW0002]
- any → target (`state` + `moderation_state` in lock-step) — `ApplicationEntity::setState()`. [FLW0002]
- → `to_check` ⇒ low-risk score recomputed (raw UPDATE) — scoring `ApplicationStatusUpdateSubscriber`. [FLW0001, FLW0017]
- → `waiting_signature*` ⇒ acceptance-protocol contract + signing session — notification subscriber. [FLW0001, FLW0008]
- → `returned_new_patron` ⇒ `removePatron()` scrubs patron data — `ApplicationEntity::preSave`. [FLW0002]
- `scoring` → `scoring_ok` (only when current==`scoring` AND `approved==yes`) — `scoring/src/Form/ScoringForm.php`. [FLW0016]
- duplicate lead: `<state>` → `duplicate` (profiles/refs nulled) — `PairingForm::updateApplicationDuplicate`. [FLW0025]
- → `active` on campaign set-active — `PublishController`; `setState`. [FLW0021]

Partial: → `complete`/`completed` cascaded when owning campaign auto-completes — `CampaignEntity::setApplicationComplete` → `ApplicationEntity`. [FLW0003, FLW0021]

Missing evidence: no transition-legality guard on `ChangeModStateForm`/`WorkflowStatusForm` (any state reachable); exact source labels for `complete`/`completed_partly` unconfirmed.

## Spec Alignment
N/A — No EN spec files found in repository (see EN-candidates.md §Spec Discovery).

## Open Questions
- Which of the ~66 workflow states are terminal vs. re-enterable, given no legality guard exists?
- What binds `status` (published key) if no backing field is declared?
- Is `moderation_state` authoritative over `state`, or is `state` the domain source of truth?
