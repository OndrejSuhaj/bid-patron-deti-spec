---
doc_id: FN0009
title: Contract Generation & E-Signature
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0004
  - EN0011
  - EN0012
  - EN0001
  - EN0002
  - FN0002
  - FN0019
---

# FN0009 – Contract Generation & E-Signature

## Purpose

Generate a legally-binding Contract document for an Application from a reusable template, carry it
through an internal manager check/signature, and obtain the fundraiser's typed-name e-signature —
producing the signed PDF, acceptance protocol, and signature-confirmation document that gate the case
toward its active story. This is the C6 document-and-signature capability exercised by UC0004.

## Responsibilities

- Create a Contract from the chosen contract type, assign a per-country contract number with a
  sequential per-year counter, substitute Application/ApplicationProfile data into the matching
  ContractTemplate, and render it to PDF.
- Route the Contract through the manager-check step (notify the checking recipient) and stamp the
  manager signature image and date into the document when digital signature is enabled.
- Present the fundraiser an in-zone signing session, validate the typed name against the fundraiser's
  registered name, record the e-signature, and generate a signature-confirmation PDF carrying a
  verification code/QR.
- Support a legacy non-digital hand-off (send the rendered PDF by notification instead of stamping)
  and a rental-contract variant with a pre-signed rental agreement.
- Advance the owning Application status in lock-step at each signing milestone via FN0002.

## Related Use Cases

UC0004 – Manage Contract & Signature (primary).

## Related Entities

EN0011 – Contract (the generated, signed document produced by this capability).
EN0012 – ContractTemplate (source template rendered into the Contract content).
EN0001 – Application (aggregate whose status is advanced at each signing milestone).
EN0002 – ApplicationProfile (source of fundraiser/patron/gift data substituted into the Contract).

## Integrations

None — document rendering is an internal system responsibility; outbound notification delivery
(manager-check notice, legacy fundraiser PDF hand-off) is carried by the transactional messaging
capability (FN0019). See ARCH0002_ContextInteractionMap for
the integrations landscape; no external system is invoked directly within this capability per current
evidence.

## Constraints

- The manager-check notification is skipped — while the Application status still advances — when the
  checking recipient or the rendered PDF is unavailable, producing a silent gap requiring manual
  follow-up.
- Contract-creation UI is country-gated: some tenants have no in-zone contract-creation form, and the
  alternative path for those tenants is not mined from evidence (Partial).
- Status transitions across the signing chain (manager stamp, hand-off, fundraiser sign) are not
  wrapped in a single transaction, so partial completion is possible if a step fails mid-sequence.
