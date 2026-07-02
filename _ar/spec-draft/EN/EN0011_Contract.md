---
doc_id: EN0011
title: Contract
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — owns the contract/delivery_note/acceptance_protocol/appendix references
  - EN0012  # ContractTemplate — source of generated content
  - EN0008  # User — owner
  - EN0015  # TaxPayer — RO tax-redirect pairing
  - BR-ContractAndESignature
---

# EN0011 — Contract

## Purpose

A generated legal document (donation contract, handover/takeover protocol, appendix, rental
agreement, etc.) belonging to an Application (EN0001). Each Contract carries a rendered document
body, a per-country human-readable contract number, and progresses through a two-step e-signature
(manager, then fundraiser). Every signing stamp produces a new revision of the document.

---

## Lifecycle

- Created (unsigned)
- Manager-signed
- Fundraiser-signed

A Contract has no independent status field of its own — see Invariants (BR-ContractAndESignature).
The states above are expressed by the presence of a manager signature stamp in the document content
and, subsequently, by a populated e-signature record and confirmation document.

---

## State Transitions

Created (unsigned) → Manager-signed
trigger: UC0004.2 (Manage Contract & Signature — manager check and signature)

Manager-signed → Fundraiser-signed
trigger: UC0004.3 (Manage Contract & Signature — fundraiser e-signature)

The same transitions drive the owning Application's (EN0001) status in lock-step (see
BR-ContractAndESignature; UC0004 main flow, FLW0008).

---

## Attributes

### System-managed attributes

- public_id (string; read-only; per-country human-readable contract number; see Invariants)
- int_id (integer; read-only; sequential per-year counter underlying `public_id`; see Invariants)
- document content (generated body produced from a ContractTemplate — EN0012 — with Application/
  ApplicationProfile data substituted in; not a user-authored field)
- rendered document (generated PDF file produced from the document content)
- digital_signature (e-signature record; captures the fundraiser's signature data and a content
  integrity hash; populated once the fundraiser-signed state is reached)
- digital_signature_confirmation (generated confirmation document, containing a verification code,
  produced once the fundraiser-signed state is reached)
- publish flag (boolean; default published; unrelated to signature progression — see Invariants)

### User-provided attributes

- name (short text; required; entity label)
- attachment_contract (image attachment(s); optional; signed contract scan uploads)
- attachment_gift_proof (image attachment(s); optional; signed handover-protocol scan uploads)
- fundraiser typed signature name (submitted at the fundraiser e-signature step; validated, not
  persisted as a standalone field — see Invariants)

---

## Invariants

- A Contract has no independent status/state field beyond the publish flag; signature progression is
  observable only through the presence/content of the fields above — see BR-ContractAndESignature.
- Signature progression drives the owning Application's (EN0001) status — see
  BR-ContractAndESignature.
- The fundraiser's typed signature name must match the fundraiser's registered identity for the
  fundraiser-signed state to be reached — see BR-ContractAndESignature.
- Only the Application's fundraiser of record may perform the fundraiser signature step — see
  BR-ContractAndESignature.
- `public_id`/`int_id` numbering is per-year sequential and current-state uniqueness is not
  guaranteed under concurrent generation — see BR-ContractAndESignature.
- The signing progression (creation → manager signature → fundraiser signature) is current-state not
  guaranteed atomic — see BR-ContractAndESignature.

---

## Relationships

- EN0001 (Application) — owning aggregate; referenced as the Application's `contract`,
  `delivery_note`, `acceptance_protocol`, or `appendix`
- EN0012 (ContractTemplate) — source template for the generated document content
- EN0008 (User) — owner
- EN0015 (TaxPayer) — RO tax-redirect variant pairs a TaxPayer record with exactly one redirect
  Contract — see BR-ContractAndESignature

---

## Open Questions

1. `public_id`/`int_id` numbering has no confirmed data-level uniqueness constraint — concurrency
   behavior under simultaneous generation is unresolved (current-state gap; see
   BR-ContractAndESignature).
2. Is there a "voided/cancelled" Contract state, or is superseding done purely via the Application
   re-pointing its reference plus new Contract revisions? Not evidenced.
3. Whether a Contract can validly reach the fundraiser-signed state without a rendered document
   present (affecting what the signature record's integrity hash covers) is not resolved in current
   evidence.
