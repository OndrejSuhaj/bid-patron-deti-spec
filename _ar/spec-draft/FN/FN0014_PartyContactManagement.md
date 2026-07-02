---
doc_id: FN0014
title: Party & Contact Management + Deduplication / Merge
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0016
  - EN0006
  - EN0018
  - EN0001
  - EN0008
  - EN0002
---

# FN0014 – Party & Contact Management + Deduplication / Merge

## Purpose

Maintains the platform's universal party registries — the overloaded Contact store that represents
every kind of person or institution in the domain (child, fundraiser, patron, school, employer, lead)
and the Organisation/employer registry — and lets an administrator consolidate duplicate records
(contact, organisation, or lead) onto one canonical surviving record, so that downstream processes
(applications, scoring, notifications, search) operate on a single party rather than a fragmented set.

---

## Responsibilities

The capability is responsible for:

- Detecting groups of duplicate Contacts by shared national ID, phone, or email, expanding a candidate
  group transitively across any additional overlaps, and letting an administrator merge the group onto
  a chosen surviving Contact — reassigning every dependent Application and ApplicationProfile role
  reference (lead contact, child, fundraiser, patron, school) onto the survivor, then deleting the
  losing Contact records (including their change history) and the User account that owned each of them.
- Letting an administrator exclude a specific duplicate criterion from future detection without
  altering any Contact record.
- Detecting and merging duplicate Organisation records onto a chosen survivor, reassigning the employer
  reference on every affected Application onto the survivor and removing the duplicate Organisation
  records.
- Managing an Organisation's workers: validating submitted worker details, linking or creating the
  worker's User account with the organisation-worker role and an administrative flag, attaching it to
  the Organisation's worker list, and triggering an account-activation message for a newly created,
  not-yet-active worker.
- Pairing a patron-originated duplicate lead onto a surviving main Application by copying the
  duplicate's ApplicationProfile reference (and linked patron reference, if present) onto the survivor,
  then demoting the duplicate lead to a "duplicate" status and clearing its party references.
- Queueing every Application or Organisation record affected by a reassignment for search re-indexing
  as a side effect of being saved.

---

## Related Use Cases

- UC0016 – Maintain Party Records (Dedup / Merge)

---

## Related Entities

- EN0006 – Contact
- EN0018 – Organisation
- EN0001 – Application
- EN0008 – User
- EN0002 – ApplicationProfile

---

## Integrations

No direct external-system integration is performed by this capability itself. Reassigned Application
and Organisation records are queued into the platform's search re-indexing side effect, and the
Organisation registry is additionally synchronized on a schedule to an external search index — see
ARCH0002_ContextInteractionMap for the platform's integration landscape; the queueing/indexing
mechanism is not itself owned by this capability.

---

## Constraints

- Merge operations are destructive and offer no dry-run: contact deduplication permanently deletes the
  losing Contact together with the User account that owned it (a GDPR-relevant deletion occurring as a
  merge side effect, not a dedicated erasure flow).
- Lead pairing overwrites the surviving Application's existing ApplicationProfile reference
  unconditionally when one is already present; the prior reference becomes unreachable — lossy even on
  the successful path, independent of any failure.
- Organisation merge reparents only the employer reference held by Applications; other references to
  the duplicate Organisation (for example, worker links) are not reparented and are left dangling once
  the duplicate is deleted.
- None of the three merge sub-flows (contact, organisation, lead) is transactional: a failure partway
  through a merge can leave some dependent references pointing at the survivor and others still
  pointing at the removed or demoted record, with no rollback of steps already completed.
- The party lists used to select organisation merge candidates are built from unbound, string-built
  queries that interpolate request-supplied identifiers directly into the reparenting update — a
  SQL-injection exposure gated only by the ordinary edit permission for the merge screen, not by
  additional input hardening.
- All three merge actions and worker management are gated solely by ordinary record-edit permissions;
  no confirmation step beyond the single merge/pairing confirmation guards the destructive outcome.
