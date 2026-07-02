---
doc_id: FN0015
title: Marketing / CRM Synchronisation
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0012
  - UC0013
  - UC0015
  - EN0006
  - EN0008
---

# FN0015 – Marketing / CRM Synchronisation

## Purpose

Keep the external marketing CRM (Mautic) in sync with platform parties: upsert a contact for each
party on save and on transactional send, and (attempt to) remove a party's CRM contact on GDPR
erasure. Mautic is also the de-facto transport layer that the messaging capability (FN0019) hands
sends to.

## Responsibilities

- Enqueue and drain a CRM-sync queue that upserts a party's contact record into Mautic on User
  (EN0008) save — covering registration, subsequent changes, and GDPR anonymisation.
- Upsert the recipient as a Mautic contact as a side-effect of every transactional send routed
  through FN0019.
- Attempt a Mautic contact deletion on GDPR anonymisation in production — a defined-but-empty
  capability that performs no actual removal.

## Related Use Cases

UC0013 – Sync Marketing & Intake Leads (outbound Contact→Mautic sync sub-flow)

UC0012 – Dispatch Transactional Message (send-side contact upsert)

UC0015 – Anonymize Personal Data (GDPR) (post-anonymisation CRM re-sync and erasure attempt)

## Related Entities

EN0006 – Contact

EN0008 – User

## Integrations

Mautic (marketing CRM), named in ARCH0002 (Context Interaction Map) as the external target of the
CRM-sync queue and of transactional-message delivery.

## Constraints

- GDPR anti-erasure hazard: the CRM-sync queue re-upserts an anonymised User (EN0008) while its
  first/last name fields are still populated, re-creating the marketing contact in Mautic after an
  erasure request rather than removing it.
- The production delete-by-email capability invoked on GDPR anonymisation is a no-op — it performs
  no actual deletion at the CRM.
- The outbound Contact-upsert sub-flow underlying UC0013's marketing sync is evidenced only at
  flow-index level (un-mined), so its triggering conditions beyond "qualifying Contact change" are
  Partial.
