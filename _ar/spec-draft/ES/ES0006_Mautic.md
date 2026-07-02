---
doc_id: ES0006
title: Mautic
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0015
  - FN0019
  - UC0012
  - UC0013
  - UC0015
---

# ES0006 – Mautic

## Purpose

Mautic serves as the marketing/CRM contact store that the platform keeps party records synchronised
into, and — despite the platform's outbound-messaging capability being internally named
"SmartMailing" — it also doubles as the sole outbound transport for the platform's transactional
messages [ARCH0001 §5 row 7; FN0015; FN0019].

---

## System Overview

Mautic is a marketing-automation / CRM platform that maintains marketing contacts and sends email.
Within the current Patronus integration landscape it plays two roles at once: it is the CRM of
record that mirrors platform parties as marketing contacts, and it is the actual mail-transport
system through which every templated transactional message is sent — there is no independent SMTP
transport underneath the messaging capability's "SmartMailing" name [ARCH0001 §5 row 7; FN0019].

---

## Integration Model

Outbound only, in two distinct interaction modes [ARCH0001 §5 row 7; ARCH0002]:

- **Asynchronous contact-upsert queue.** Party (Contact/User) records are pushed to Mautic as
  contact upserts on user save, via a CRM-sync queue — the genuinely-eventual path of this
  integration (UC0013; also triggered as a side-effect of anonymisation in UC0015).
- **Synchronous transactional send.** Every transactional message dispatch hands the message to
  Mautic as the outbound transport, made synchronously in-request/in-save because the platform's
  mailing queue is disabled (UC0012).

---

## Data Exchange

Outbound conceptual data flows only, with no payload/field-level detail owned here:

- Party/contact upsert data for CRM synchronisation — attribute ownership sits with the Contact and
  User entities (see EN0006, EN0008).
- Transactional message send requests — content, template, and archival ownership sit with the
  messaging capability and the EmailArchive record (see FN0019; MSG layer).

No inbound data flow from Mautic into the platform is evidenced.

---

## Constraints

- **Synchronous send blocks/aborts on failure, no retry.** Transactional mail is sent synchronously
  through Mautic inside the entity save/request; a slow or failing call blocks or aborts the
  enclosing save, with no retry path [ARCH0001 §5 row 7, HS13; FN0019].
- **Anti-erasure hazard on GDPR anonymisation.** The CRM-sync queue re-upserts the anonymised user to
  Mautic while first/last-name fields are still populated, re-creating the marketing contact with
  names intact after an erasure request; the production delete-by-email path invoked on
  anonymisation is a no-op and performs no actual removal at Mautic [ARCH0001 §5 row 7, HS06;
  FN0015].
- **Naming ambiguity, not a separate system.** The integration inventory also names a
  `patron_base.smartmailing` service alongside Mautic; reconstructed evidence treats Mautic as the
  actual CRM and transport underneath that name. This SmartMailing-vs-Mautic naming question is
  recorded here as an open point rather than split into a separate ES [FN0019].

Current-state only — this describes Mautic's integration boundary as implemented today, not any
target-state redesign.
