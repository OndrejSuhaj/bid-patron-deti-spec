---
doc_id: EN0018
title: Organisation
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — application.patron_employer_id → organisation
  - EN0006  # Contact — organisation.contact → contact
  - EN0008  # User — key account manager (owner) + workers
---

# EN0018 — Organisation

## Description
Employer / partner organisation registry. Represents a company or institution that employs patrons (`patron_employer_id`) and can carry a set of **workers** (users with role `organisation_worker`) with a per-worker admin flag. Organisations are managed in the back office (add/edit workers, merge duplicates) and are synced daily to an external Elastic Cloud `organisations` index. Distinct "Profi" organisations are flagged via `is_profi`.

## Entity Category
Persisted · Confidence: High
(Schema confirmed + active usage: worker forms, dedup/reparent, cron sync — FLW0024.)

## Origin
- DB artifacts: base_table `organisation`; field table `organisation__worker` (custom field type adds `is_admin` tinyint NOT NULL default 0, composite index (target_id, is_admin)). No `.install` / no hook_schema.
- Code touchpoints:
  - `organisation/src/Entity/OrganisationEntity.php` — entity; `getWorkers:136`, `getEntityByName:305` (raw SQL `select id from organisation where name=:name`, no unique key), `postSave` enqueues to `es_upload_queue`.
  - `organisation/src/Plugin/Field/FieldType/WorkerEntityReferenceItemFieldType.php` — `worker_entity_reference` field type; `schema:38-47` (is_admin NOT NULL, index (target_id, is_admin)).
  - `organisation/src/Form/OrganisationWorkerForm.php` — worker add/edit (writes a **User**, grants role, links contact).
  - `organisation/src/Form/OrganisationRemoveDuplicatesForm.php` — merge: raw SQL reparent of `application.patron_employer_id`, then delete duplicates.
  - `organisation/src/OrganisationCron.php` — daily Elastic Cloud `organisations/_doc/{id}` upsert.
Evidence: db-models.md `organisation`; FLW0024 (§D); WorkerEntityReferenceItemFieldType.php:38-47 (verified is_admin + index).

## Core Fields
- `name` (string 150; required; entity label; uniqueness app-level only, no DB key)
- `worker` (worker_entity_reference → EN0008 User; optional; cardinality ∞; carries extra `is_admin` boolean per item)
- `contact` (er → EN0006 Contact; optional; card. 1; "Kontaktní údaje")
- `logo` (image, public; optional; card. 1)
- `is_profi` (boolean; optional; "Is Profi Organisation")
- `status` (boolean; publish flag; default TRUE)

## Technical Fields
- `user_id` (er → EN0008 User; optional; "Key account manager" / owner)
- `created` / `changed` (timestamps)
Evidence: db-models.md `organisation`. Verification note: class `implements OrganisationEntityInterface` (owner via uid key, not directly EntityOwnerInterface); worker label "Uzivatele organizace"; the "inline_entity_form" note for `contact` is unverified.

## Relations
- `user_id` → EN0008 User (key account manager / owner). Evidence: db-models.md.
- `worker` → EN0008 User (multi, with `is_admin`). Evidence: FLW0024 §C; WorkerEntityReferenceItemFieldType.php.
- `contact` → EN0006 Contact. Evidence: db-models.md.
- Inbound: EN0001 Application `patron_employer_id` → organisation; EN0002 ApplicationProfile `patron_employer_id` → organisation. Evidence: db-models.md `application`/`aprofile`.
- `logo` → file. Evidence: db-models.md.

## Allowed Statuses
`status` boolean only (published / unpublished); no domain status enum. Evidence: db-models.md `organisation`.

## Lifecycle
- (create) → published (`status` default TRUE); worker attached and `es_upload_queue` enqueued on save. Confirmed (FLW0024 §C, postSave enqueue).
- Worker provisioning: nonexistent/plain user → `organisation_worker` (role + contact link; blocked user → activation email). Confirmed (FLW0024; OrganisationWorkerForm.php:127,160-162).
- Merge (dedup): duplicate organisation active → deleted; `application.patron_employer_id` reparented to survivor via raw SQL (no transaction, no other refs reparented). Confirmed (FLW0024; OrganisationRemoveDuplicatesForm.php:106-112).
- Daily Elastic Cloud `organisations` doc upserted (full re-push each run). Confirmed (FLW0024; OrganisationCron.php:18,24-38).

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. `name` has no DB unique key; `getEntityByName` matches by exact string — is name meant to be unique per tenant?
2. Merge reparents only `application.patron_employer_id`; worker links / other references to a deleted org are left dangling (FLW0024 data-loss risk) — acceptable current behavior?
3. Elastic Cloud sync is global (no CZ/RO/MD scope) — intended for a single-country deployment only?
4. Worker `is_admin` semantics: what capabilities does an org admin gain (not evidenced in this pass)?
