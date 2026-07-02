---
doc_id: EN0018
title: Organisation
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — employer reference
  - EN0006  # Contact — organisation contact details
  - EN0008  # User — key account manager (owner) and workers
  - BR-PartyIdentityAndDeduplication  # merge/dedup legality and reparenting scope
  - BR-SearchIndexingConsistency      # search-index propagation guarantee
  - UC0016  # Maintain Party Records (Dedup / Merge) — merge, worker provisioning triggers
  - UC0018  # Index Entities for Search — indexing queue trigger
---

# EN0018 — Organisation

## Purpose

Represents an employer or partner organisation — a company or institution that employs patrons and
may act as an intermediary for donations. An Organisation carries a registry of workers (staff users
acting on its behalf, one of whom may be flagged as an organisation admin) and may be distinguished
as a professional partner ("Profi") organisation. Organisation records are consolidated by an
administrator when duplicates are identified, and are exposed through an external search index.

## Lifecycle

- Active (published) — the default and normal state; visible in search and selectable as an
  employer/partner.
- Inactive (unpublished) — the record is retained but not published.
- Removed — the record no longer exists, following a merge into a surviving Organisation.

## State Transitions

(created) → Active
trigger: presumed default published state on creation — **Hypothesis, not evidenced**: no mined
Organisation-creation step confirms the creation default (the UC0016.2 worker-save sub-flow does not
evidence it); see Open Questions.

Active ⇄ Inactive
trigger: administrative publish/unpublish action (not evidenced beyond the publish flag; see Open
Questions)

Active → Removed
trigger: UC0016.2 — Maintain Party Records: Organisation de-duplication and worker management (an
Organisation selected as a duplicate is removed once its employer reference has been reassigned to
the surviving Organisation)

(any state) → (re-indexed in external search)
trigger: UC0018 — Index Entities for Search (an Organisation queued on save is periodically pushed to
the search index); independently, UC0016.3 pushes the full Organisation registry to a dedicated
organisation search index on a daily schedule

## Attributes

### System-managed attributes

- Publication state (boolean; required; published by default; governs whether the Organisation is
  Active or Inactive)
- Key account manager (reference to EN0008 – User; optional; the owning/responsible user for this
  Organisation)
- Created / changed timestamps (datetime; required)

### User-provided attributes

- Name (string; required; entity label; identifies the Organisation)
- Workers (reference to EN0008 – User; optional; multiple; each worker entry carries an
  organisation-admin flag indicating elevated standing within the Organisation)
- Contact details (reference to EN0006 – Contact; optional; single)
- Logo (image; optional; single)
- Is Profi Organisation (boolean; optional; marks the Organisation as a professional partner)

## Invariants

- Organisation name uniqueness is not enforced at the data level; see BR-PartyIdentityAndDeduplication.
- An Organisation merge legality, reparenting scope, and non-transactional current-state behaviour
  are governed by BR-PartyIdentityAndDeduplication (see also INV18 in the domain kernel).
- Organisation propagation to the search index and the retry/eventual-consistency guarantee are
  governed by BR-SearchIndexingConsistency.

## Relationships

- EN0001 – Application: an Application references an Organisation as its employer.
- EN0002 – ApplicationProfile: an ApplicationProfile references an Organisation as employer.
- EN0006 – Contact: an Organisation optionally holds one Contact for its contact details.
- EN0008 – User: an Organisation optionally has one key account manager (owner) and any number of
  workers, each with an admin flag.

## Open Questions

1. Name has no enforced uniqueness at the data level, yet organisation lookup by exact name is used
   elsewhere in the system — is Organisation name intended to be unique? Hypothesis — not evidenced.
2. On an Organisation merge, only the Application employer reference is reparented onto the survivor;
   worker links and other references to the removed Organisation are left dangling (see
   BR-PartyIdentityAndDeduplication, domain-kernel INV18) — confirmed current-state behaviour, not
   yet resolved whether this is acceptable for the rebuild target.
3. The external Organisation search index sync is not evidenced as scoped by country (CZ/RO/MD) —
   unclear whether this reflects an intentional single-registry design or a current-state gap.
4. The organisation-admin flag's effect on worker capabilities is not evidenced in the current
   reconstruction pass — Missing evidence.
5. The publish/unpublish transition (Active ⇄ Inactive) has no confirmed triggering use case in the
   current evidence set — Missing evidence.
