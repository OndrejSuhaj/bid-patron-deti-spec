---
doc_id: EN0017
title: ScoringRecord
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — scoring JSON is stored on application.scoring
  - EN0006  # Contact — blacklist_type written by scoring
  - EN0016  # Blacklist — risk-list entries created alongside scoring
---

# EN0017 — ScoringRecord

## Description
Risk-scoring result for an Application (Žádost). Two distinct representations exist: (a) the **primary, live** representation is JSON persisted on the Application itself — `application.scoring` (manual scoring snapshot) and `application.scoring_low_risk` / `scoring_low_risk_score` (auto low-risk recalc); (b) a **separate `scoring_entity`** (fields `entity_name`/`entity_id`/`json_package`) is defined for a REST/low-risk read path but is **not written by any custom code** in the current source. ScoringRecord is therefore reconstructed primarily as Application-attached scoring state, with `scoring_entity` documented as a defined-but-dormant carrier.

## Entity Category
Persisted · Confidence: Medium
(High-confidence for the `application.scoring*` JSON path via FLW0016/FLW0017; `scoring_entity` table itself has no observed writer.)

## Origin
- DB artifacts: base_table `scoring_entity` (`entity_name`, `entity_id` plain int — NOT an entity_reference, `json_package`); plus `application.scoring`, `application.scoring_low_risk`, `application.scoring_low_risk_score` fields on EN0001.
- Code touchpoints:
  - `scoring/src/Form/ScoringForm.php` — manual scoring; writes `application.scoring` JSON (`submitForm:180`) and `contact.blacklist_type` (raw SQL).
  - `scoring/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php` — low-risk auto-recalc; raw UPDATE of `application.scoring_low_risk*` on `to_check`.
  - `scoring/src/Form/ScoringLowRiskForm.php` — coordinator manual low-risk decision (threshold ≥ 30).
  - `scoring/src/Entity/ScoringEntity.php` — the `scoring_entity` class.
  - `scoring/src/Plugin/rest/resource/ScoringResource.php` — REST resource `scoring_rest_resource` at `/api/scoring/{entity_name}/{entity_id}`; POST/GET are **stubs** returning canned status, no persistence.
Evidence: db-models.md `scoring_entity` / `application`; FLW0016 (§C, ScoringForm writes `application.scoring`, NOT `scoring_entity`); FLW0017; `ScoringResource.php:88,105` (stub methods, Confirmed no write).

## Core Fields
- `application.scoring` (string_long JSON; optional; manual scoring snapshot — ~90 fundraiser/patron/gift/child fields incl. `approved`, ranks, blacklist selections) — owned by EN0001.
- `application.scoring_low_risk` (string_long JSON; optional; per-component low-risk breakdown) — owned by EN0001.
- `application.scoring_low_risk_score` (integer; optional; total low-risk score, NULL when actor/profile data missing) — owned by EN0001.
- `application.scoring_fundraiser` / `scoring_patron` / `scoring_gift` (list_string ok/ko), `scoring_coord_note` (string_long), `scoring_coord_decision` (boolean), `scoring_user` (er→user), `scoring_created` / `scoring_assigned` (timestamp) — owned by EN0001.

## Technical Fields
On `scoring_entity` (dormant carrier): `user_id` (er→user, author), `entity_name` (string 50; entity_keys.label points at nonexistent `name` — mismatch), `entity_id` (integer unsigned; ID of scored entity as plain int, NO FK), `json_package` (string_long, scoring JSON), `created`/`changed`.
Evidence: db-models.md `scoring_entity` (Conflict: entity_keys `status`/`label` reference undefined fields).

## Relations
- Scored entity → EN0001 Application (via `scoring_user` er→user and the host `application.scoring*` fields).
- Blacklist side-effect → EN0006 Contact (`contact.blacklist_type` set by email, raw SQL, no LIMIT). Evidence: FLW0016 §C; `ScoringService::setBlacklistType:29`.
- Risk list → EN0016 Blacklist (blacklist entries created for fundraiser/patron in the same scoring flow). Evidence: FLW0016.
- `scoring_entity.entity_id` is a bare integer, not a modelled reference. Evidence: db-models.md `scoring_entity`.

## Allowed Statuses
No lifecycle enum of its own. Scoring outcome influences Application state (`scoring_ok`) and `contact.blacklist_type` enum (`wl_zd`/`wl_z`/`wl_n`/`bl`). Evidence: FLW0016 §C constraints.

## Lifecycle
- Manual: on `ScoringForm` submit, `application.scoring` JSON is (re)written on every save; Application state → `scoring_ok` **only** when current state is `scoring` AND submitted `approved === 'yes'`. Confirmed (FLW0016).
- Auto (low-risk): on Application `postSave` with new state `to_check`, `scoring_low_risk*` recomputed via raw UPDATE (no revision, no validation). Confirmed (FLW0017).
- Coordinator low-risk: score ≥ 30 in {to_check, application_processing, waiting, suspended} → coordinator may `setState('scoring_ok')`. Confirmed (FLW0017).
- `scoring_entity`: no create/save observed → Status: Planned/dormant. Hypothesis — no writer in current sources; REST resource methods are stubs.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Is `scoring_entity` legacy/abandoned, or fed by an out-of-scope/external client? No writer found in custom code.
2. Confidence of `contact.blacklist_type` overwrite scope: raw UPDATE by email with no LIMIT can hit multiple contacts (FLW0016 failure mode) — intended?
3. Low-risk score reads `patron_occupation_list`/`gift_payment_type` from **fundraiser_profile** (FLW0017) — likely-unintended owner coupling; is this current behavior authoritative?
4. Relationship between `application.scoring` (manual) and `scoring_low_risk` (auto) — are both consumed downstream, or does one supersede?
