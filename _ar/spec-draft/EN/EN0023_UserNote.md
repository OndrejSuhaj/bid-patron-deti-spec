---
doc_id: EN0023
title: UserNote
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0006 (Contact)
  - EN0008 (User)
  - UC0016
  - BR-DataProtectionAndErasure
---

# EN0023 — UserNote

## Purpose

UserNote is a free-text annotation record attached to a party. It carries the extended back-office
commentary that staff keep on a Contact (EN0006), which holds a single linked UserNote. Each edit to
a UserNote is preserved as a distinct, retrievable revision, so back-office annotation history is
auditable over time.

---

## Lifecycle

- Active — the note exists, is linked to its owning Contact, and is either published or unpublished
  (see Attributes).
- Revised — an edit to an existing note is preserved as a prior revision, retrievable and revertible
  independently of the current content.

Open Question: no expiry, archival, or deletion transition is evidenced beyond create and revise — see
Open Questions.

---

## State Transitions

(none) → Active
trigger: UC0016 — Maintain Party Records (creation of the annotation and its link to the owning
Contact)

Active → Revised
trigger: UC0016 — Maintain Party Records (edit to note content, preserved as a new revision; prior
revisions remain revertible)

Open Question: UC0016 as reconstructed describes contact/organisation/lead deduplication and merge; it
is the only use case identified as touching party records and is cited here as the best-available
trigger for note creation/edit, but no flow step naming UserNote specifically has been confirmed —
evidence is Partial.

---

## Attributes

### System-managed attributes

- Publish flag (boolean; required; publish/unpublish state of the note; no domain status vocabulary
  beyond this flag)
- Created / changed timestamps (date-time; required)
- Revision author (reference to EN0008 – User; required per revision; identifies who authored a given
  revision)

### User-provided attributes

- Name (text; required; short label/title for the note)
- Note text (text; required; the free-text annotation content)
- Owner (reference to EN0008 – User; optional; the User associated with the note)

---

## Invariants

- A UserNote's personal-data content is not cascaded by the GDPR erasure use case — see
  BR-DataProtectionAndErasure.

Open Question: whether a Contact may hold at most one UserNote (single current link) or whether
multiple notes can accumulate is unresolved — see Open Questions. No BR governing UserNote uniqueness,
retention, or attachment scope has been identified in the current source set.

---

## Relationships

- EN0006 (Contact) — a Contact holds a single linked UserNote as its annotation record.
- EN0008 (User) — a UserNote may reference an owning User; each revision records its authoring User.

---

## Open Questions

1. Is UserNote strictly one-per-Contact, or can multiple notes accumulate over time (with only the
   latest linked from the Contact)?
2. Can a UserNote attach to a party other than a Contact (e.g. directly to a User)? Only the Contact
   linkage is evidenced.
3. GDPR: UserNote content may hold personal data but is not cascaded by the erasure use case (see
   BR-DataProtectionAndErasure) — is indefinite retention intended, current-state incompleteness, or a
   gap?
4. No expiry/archival lifecycle transition beyond create/revise/publish is evidenced — is this a
   deliberate design choice or an unreconstructed gap?
