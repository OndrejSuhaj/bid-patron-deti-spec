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
  - EN0018 (Organisation)
  - EN0023 (UserNote)
  - BR-PartyIdentityAndDeduplication
  - BR-ScoringAndRiskGating
  - BR-DataProtectionAndErasure
  - UC0001
  - UC0003
  - UC0016
---

# EN0006 — Contact

## Purpose

The Contact is the universal party record for the domain: a single store representing any person or
institution that participates in a case — child, fundraiser, patron, school, employer, or a
not-yet-qualified lead — disambiguated by a role discriminator. It carries the party's personal data
(name, national identification number, phone, email, address) and a risk/blacklist classification
maintained by the scoring process. Cases and case profiles reference the Contact for the people and
institutions involved; a Contact may optionally be linked to a User (the account through which the
party accesses the system) and to a free-text annotation record.

---

## Lifecycle

- Active — the normal state of a Contact from creation onward; no separate published/unpublished
  distinction is treated as a domain lifecycle state (see Attributes for the underlying publish flag).
- Merged-out (terminal) — a losing record in a deduplication merge; the record is removed rather than
  retained in an inactive state (see BR-PartyIdentityAndDeduplication).

Open Question: whether a durable "erased" or "archived" state exists for a Contact is unresolved — see
Invariants and Open Questions below.

---

## State Transitions

(none) → Active
trigger: UC0001 — Submit Application (self-registration or Admin promotes case-profile data to a
Contact/User)

Active → Active (risk classification updated)
trigger: UC0003 — Assess Applicant Risk (Scoring); see BR-ScoringAndRiskGating for the classification
write and its cross-party hazard

Active → Active (references reassigned onto a surviving Contact)
trigger: UC0016 — Maintain Party Records (Dedup / Merge)

Active → Merged-out (terminal)
trigger: UC0016 — Maintain Party Records (Dedup / Merge); see BR-PartyIdentityAndDeduplication for the
destructive, non-transactional nature of this transition

---

## Attributes

### System-managed attributes

- Role discriminator (enumerated; required; distinguishes fundraiser, secondary fundraiser address,
  fundraiser's employer contact, child, school, patron, lead, or undefined — determines which case
  role(s) may reference this Contact)
- Party kind (enumerated; required; person or institution; defaults to person)
- Risk classification (enumerated; optional; values corresponding to whitelist/greylist/blacklist
  standing; written by the scoring process — see BR-ScoringAndRiskGating; not a lifecycle state)
- Publish flag (boolean; required; defaults to active/published; not treated as a domain lifecycle
  state)
- Display-name format (enumerated; optional; full / short / hidden)

### User-provided attributes

- First name / last name (text; required for a person Contact)
- National identification number / company identification number (text; optional; used as a
  deduplication-matching criterion — see BR-PartyIdentityAndDeduplication)
- Phone (text; optional; not unique; used as a deduplication-matching criterion)
- Email (text; optional; used as a deduplication-matching criterion and as the key for the scoring
  classification write — see BR-ScoringAndRiskGating)
- Street / postal code (text; optional)
- City (reference to a reference-data location entry; optional)
- Title prefix / title suffix (text; optional)

Open Question: a derived birthdate and a derived gender indicator are present on the record but their
population from the national identification number is not confirmed as active — evidence is Partial.

---

## Invariants

- Party identity is not enforced as unique — see BR-PartyIdentityAndDeduplication.
- References from a case or case profile to a Contact are soft references only — see
  BR-PartyIdentityAndDeduplication.
- The risk-classification write onto a Contact is keyed by email and is not scoped to a single
  matching record — see BR-ScoringAndRiskGating.
- A Contact removed as the losing side of a deduplication merge is deleted directly rather than routed
  through the erasure path — see BR-DataProtectionAndErasure and BR-PartyIdentityAndDeduplication.
- A Contact's personal data is not cascaded by the GDPR erasure use case — see
  BR-DataProtectionAndErasure.

---

## Relationships

- EN0001 (Application) — references this Contact for the case's child and lead-contact roles.
- EN0002 (ApplicationProfile) — references this Contact for the fundraiser, fundraiser's secondary
  address, fundraiser's employer, child, school, and patron roles.
- EN0008 (User) — a Contact may be linked to the User account through which the party accesses the
  system; a User references back to its owning Contact.
- EN0018 (Organisation) — an Organisation holds a reference to a Contact.
- EN0023 (UserNote) — a Contact may hold a single linked free-text annotation record.

---

## Open Questions

- The scoring classification write is keyed by email with no bound on the number of matching records —
  can it unintentionally affect Contacts other than the intended party? (see BR-ScoringAndRiskGating)
- What are the exact rules governing transitions among the risk-classification values? Evidence is
  Partial.
- Since GDPR erasure does not cascade to a Contact's personal data (see BR-DataProtectionAndErasure),
  what is the retirement path, if any, for that data?
- Is the derived birthdate/gender population from the national identification number an active,
  current-state behavior, or dormant? Evidence is Partial.
