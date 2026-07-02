---
doc_id: EN0006
title: Contact
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001 (Application)
  - EN0002 (ApplicationProfile)
  - EN0008 (User)
  - EN0023 (UserNote)
---

# EN0006 — Contact

## Description
The Contact is the central party store — a single revisionable entity that represents any person or institution in the domain (child, fundraiser, patron, school, employer, lead), disambiguated by the `field_name` discriminator. It holds personal data (name, RC, phone, email, address, city) plus a `blacklist_type` risk classification written by the scoring subsystem. Applications and ApplicationProfiles reference Contacts for their people; a Contact optionally links back to a User (EN0008) and to a UserNote.

## Entity Category
Persisted  ·  Confidence: High

## Origin
- DB artifacts: base_table `contact`; **revisionable** (`contact_revision` / `contact_field_revision`); not translatable; `fieldable=FALSE`. `contact.install` hook_schema is fully commented out (physical DDL Drupal-generated).
- Code touchpoints: `contact/src/Entity/ContactEntity.php` (`create` sets `field_name`=role); `ContactEntityStorageSchema.php` (composite index); created via `AccountService::register`/`ensureUser`; deduped/hard-deleted by `ContactRemoveDuplicatesController`.
Evidence: `ContactEntity.php`; `ContactEntityStorageSchema.php`

## Core Fields
- type (list_string; person / institution; default person)
- field_name (list_string; discriminator: fundraiser / fundraiser_address2 / fundraiser_employer / child / school / patron / lead / undefined)
- name / last_name (string(100); Jméno / Příjmení; revisionable)
- rc / ico (string(20); Rodné číslo / IČO)
- phone (phone_number; unique=**NO**), email (email)
- street (string(100)), zip (string(10)), city (entity_reference → taxonomy_term `city`; auto_create=TRUE)
- blacklist_type (list_string; wl_zd / wl_z / wl_n / bl; written by scoring)
- title_prefix / title_suffix (string(32)), name_format (list_string; full / short / hidden)
- status (boolean; publish flag; default TRUE)

## Technical Fields
- uuid / langcode / vid + revision keys (framework). birthdate (timestamp, ReadOnly; derived from rc via splitRC — currently commented). gender (boolean, ReadOnly; GENDER_M/GENDER_F).

## Relations
Soft entity_reference (no DB FK): user_id → EN0008 User (owner); user_note → EN0023 UserNote; city → taxonomy_term(city); revision_user → EN0008 User. Inbound: EN0001 Application (child, lead_contact) and EN0002 ApplicationProfile (fundraiser, fundraiser_address2, fundraiser_employer, child, school, patron) reference this. A User's `contact` field points back to a Contact.

## Allowed Statuses
No lifecycle-status enum; `blacklist_type` (wl_zd / wl_z / wl_n / bl) is the risk classification. `status` is a boolean publish flag. `field_name` discriminator and `type` are the domain enums.
Evidence: `ContactEntity.php` baseFieldDefinitions (verified `Confirmed`)

## Lifecycle
Confirmed transitions (code-path evidenced):
- (create) → person, `field_name`=role — `AccountService::register`/`ensureUser`; `ContactEntity::create`. [FLW0010]
- `blacklist_type` written by scoring — `wl_z` on `scoring_ok`; set to wl_n/bl/wl_zd/wl_z by `ScoringService::setBlacklistType` via raw UPDATE **by email, no LIMIT**. [FLW0016, FLW0001]
- contact/user refs reassigned to survivor on dedup, then re-saved — `ContactRemoveDuplicatesController`. [FLW0023]
- (duplicate) active → **hard-deleted** (revisions dropped) — `ContactRemoveDuplicatesController::delete()`. [FLW0023]

Missing evidence: full `blacklist_type` transition table is `Partial`; no soft-delete/archive path — dedup is destructive.

## Spec Alignment
N/A — No EN spec files found in repository (see EN-candidates.md §Spec Discovery).

## Open Questions
- `setBlacklistType` updates by email with no LIMIT — can it affect multiple Contacts unintentionally?
- What are the exact rules governing `blacklist_type` transitions among wl_zd/wl_z/wl_n/bl?
- Since GDPR erasure (FLW0020) does not cascade to Contact PII, how is Contact PII retired?
