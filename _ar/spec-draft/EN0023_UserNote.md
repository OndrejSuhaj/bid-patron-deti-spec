---
doc_id: EN0023
title: UserNote
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0006  # Contact — contact.user_note → user_note
  - EN0008  # User — user_note.user_id (owner)
---

# EN0023 — UserNote

## Description
A free-text note/annotation attached to a Contact. Each Contact carries a single `user_note` reference (EN0006 `contact.user_note`), so UserNote acts as the extended-details / annotation record for a party. It is **revisionable** (full revision history with revert/delete revision routes), allowing back-office edits to be tracked over time.

## Entity Category
Content · Confidence: Medium
(Schema confirmed + create/manage usage via UserNote forms + controller linking to contact. Revisionable machinery present.)

## Origin
- DB artifacts: base_table `user_note`; revision tables `user_note_revision` / `user_note_field_revision`. No `.install` / no hook_schema.
- Code touchpoints:
  - `user_note/src/Entity/UserNoteEntity.php` — entity (revisionable; publishedBaseFieldDefinitions).
  - `user_note/src/Form/UserNoteEntityCreateForm.php:78` — `UserNoteEntity::create([...])`.
  - `user_note/src/Controller/UserNoteEntityController.php:118,162,172` — links a saved note to a `contact` (`'user_note' => $user_note->id()`); full-history controller.
  - `user_note/src/UserNoteEntityHtmlRouteProvider.php` — revision overview / revert / delete routes.
  - `contact/src/Entity/ContactEntity.php:747-750` — `contact.user_note` (er → user_note).
Evidence: db-models.md `user_note`; grep (UserNoteEntity::create at CreateForm:78; controller sets contact.user_note; ContactEntity.php:747).

## Core Fields
- `name` (string 50; required; entity label)
- `note` (string_long; required; the note text)
- `status` (boolean; publish flag; via publishedBaseFieldDefinitions())

## Technical Fields
- `user_id` (er → EN0008 User; optional; owner; revisionable)
- `revision_user` (er → EN0008 User; revision author)
- `created` / `changed` (timestamps)
Evidence: db-models.md `user_note` (revision tables; no custom constraints, no TTL/expiry).

## Relations
- `user_id` → EN0008 User (owner). Evidence: db-models.md.
- Inbound: EN0006 Contact `user_note` → user_note (the primary linkage). Evidence: db-models.md `contact`; ContactEntity.php:747-750; UserNoteEntityController.php:118.
- `revision_user` → EN0008 User; `revision_link` → self (revision tables). Evidence: db-models.md.

## Allowed Statuses
`status` boolean only (published / unpublished); no domain status enum. Evidence: db-models.md `user_note`.

## Lifecycle
- (create) → published (via UserNoteEntityCreateForm) → contact linked (`contact.user_note` set to the new note id). Confirmed (UserNoteEntityCreateForm.php:78; UserNoteEntityController.php:118,162,172).
- edit → new revision (revisionable; revert/delete-revision routes exist). Confirmed by revision route provider (UserNoteEntityHtmlRouteProvider.php).
- No expiry/archival transition observed. Hypothesis — no lifecycle beyond create/revise/publish in current sources.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Is UserNote strictly one-per-Contact (single `contact.user_note` ref), or can multiple notes accumulate via revisions only?
2. GDPR: notes may hold PII but are not cascaded in the anonymization flow (FLW0020 gap) — retained indefinitely; intended?
3. Can a note attach to anything other than a Contact (e.g. directly to a User)? Only the Contact linkage is evidenced.
