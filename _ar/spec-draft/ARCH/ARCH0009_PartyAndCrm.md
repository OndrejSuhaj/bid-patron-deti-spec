---
doc_id: ARCH0009
title: Party / CRM Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
references:
  - ARCH0001
  - ARCH0002
  - EN0006
  - EN0007
  - EN0008
  - EN0018
  - EN0023
  - UC0016
  - FN0014
  - FN0022
  - BR-PartyIdentityAndDeduplication
---

# ARCH0009 – Party / CRM Domain

> Domain navigation document for bounded context **C7 Party / CRM** (ARCH0001 §4).
> Navigation layer only — links deeper artifacts by `doc_id`, does not restate them. Current-state.

## Purpose

Explains the architectural perspective of the **universal party store**: the User (the first-class
actor differentiated by role) and the overloaded Contact record that holds personal/institutional
detail for every kind of party (child, fundraiser, patron, school, employer, lead), plus organisations
and notes. This is the identity and relationship substrate that nearly every other domain references.

---

## System Overview

C7 owns the Party aggregate (User + Contact + notes) and the Organisation/employer registry. Its
defining architectural characteristic is that a single **overloaded Contact store** represents all
party kinds disambiguated only by a role discriminator, with soft references and no identity
uniqueness — the root cause of the destructive manual dedup/merge processes
([ARCH0001](../ARCH0001_ApplicationOverview.md) §2, §8 Risk 2/3;
[EN0006](../EN/EN0006_Contact.md), [EN0008](../EN/EN0008_User.md)). The Contact is **shared mutable
state**: its lifecycle sits in C7 but it is read from C1 and its risk classification is written by C2
(ARCH0002 §(c)). Merges are destructive and non-transactional (hard-delete of the losing Contact and
its owning User). The context also holds the dormant Account satellite (recommendation subsystem, C3).

---

## Structural Components

- **Party-&-Contact-Management** (Domain service) — the party registry plus all three merge sub-flows
  (contact dedup, lead pairing, organisation dedup). Capability:
  [FN0014](../FN/FN0014_PartyContactManagement.md).
- **Resident aggregates** — AG7 Party (root User [EN0008](../EN/EN0008_User.md); members Contact
  [EN0006](../EN/EN0006_Contact.md), Account [EN0007](../EN/EN0007_Account.md) *dormant*, UserNote
  [EN0023](../EN/EN0023_UserNote.md)); AG8 Organisation (root
  [EN0018](../EN/EN0018_Organisation.md), worker links point to Users by reference).
- **Organisation search sync** — the daily push of the organisation index is a C10 concern; C7 is the
  source of the data ([FN0022](../FN/FN0022_SearchIndexing.md)).

Identity, authentication, GDPR erasure and access-control commands on the User are covered by the
sibling **C9 Identity & Access** domain ([ARCH0011](ARCH0011_IdentityAndAccess.md)), which shares this
aggregate (ARCH0001 §4).

---

## Interaction Model

Per [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(c):

- Provisioned **synchronously** from **C1** on application submit and from **C4** for anonymous donors
  (User+Contact creation; ARCH0002 §(a)).
- The Contact risk classification is written **into** C7 by **C2**'s scoring approval (raw email-keyed,
  no LIMIT — ARCH0002 §(c)); the supporter role is granted **into** C7 by **C4**'s first-PAID cascade.
- Dedup/merge ([UC0016](../UC/UC0016_MaintainPartyRecords.md)) reparents references and hard-deletes
  duplicates across C1 (lead pairing) and C7 (contact/org), non-transactional (ARCH0002 §(c)).
- Party and organisation saves enqueue **C10 Search** index updates; the organisation index is a full
  daily re-push (ARCH0002 §(b)).
- CRM contact-upsert to Mautic and GDPR erasure are handled by **C8** / **C9** respectively (this
  domain supplies the party data).

---

## Cross-links

- **relatedEN:** EN0006, EN0007, EN0008, EN0018, EN0023
- **relatedUC:** UC0016 (contributes to UC0001, UC0014, UC0015)
- **relatedFN:** FN0014 (organisation index sync via FN0022)
- **relatedES:** (none directly — organisation → external search index via C10; CRM sync via C8)
- **relatedMSG:** (none owned here — party/auth messages MSG0003/MSG0004 are navigated from C9)
- **relatedBR:** BR-PartyIdentityAndDeduplication
  ([../BR/BR-PartyIdentityAndDeduplication.md](../BR/BR-PartyIdentityAndDeduplication.md))
