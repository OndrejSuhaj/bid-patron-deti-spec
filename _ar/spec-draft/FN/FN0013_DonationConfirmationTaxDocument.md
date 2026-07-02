---
doc_id: FN0013
title: Donation Confirmation & Tax Document Generation
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0010
  - EN0014
  - EN0008
  - EN0009
  - EN0022
  - EN0015
  - EN0011
---

# FN0013 – Donation Confirmation & Tax Document Generation

## Purpose

Produce official tax documents from a donor's payment history: compute a donor's paid-donation total
for a requested year and render a CZ donation confirmation ("Potvrzení o daru") as a PDF snapshot
delivered by email; and, as an adjacent RO variant, record a 2%/3.5% tax-redirect declaration. This is
the tax-documentation capability exercised by UC0010.

---

## Responsibilities

- Resolve the target donor (logged-in User or matched by email) and compute their total paid-donation
  amount and most recent donation date for the requested year, optionally scoped to a campaign.
- Create and persist an immutable DonationConfirmation snapshot (requester identity, computed total,
  amount-in-words, confirmation year) and render it to a CZ tax-confirmation PDF.
- Dispatch the confirmation PDF by email (via FN0019) and archive every send
  attempt.
- Support the adjacent RO tax-redirect declaration (creates a Contract and a TaxPayer record and
  appends it to a filing export) as a distinct country variant of the tax-documentation capability.

---

## Related Use Cases

UC0010 – Issue Donation Confirmation (Tax) (primary).

---

## Related Entities

EN0014 – DonationConfirmation (the persisted CZ tax-confirmation snapshot this capability produces).
EN0008 – User (the resolved donor/requester whose paid donations are confirmed).
EN0009 – Transaction (read-only source of the paid-donation total for the requested year).
EN0022 – EmailArchive (archive record of the confirmation email dispatch attempt).
EN0015 – TaxPayer (RO tax-redirect payer record — adjacent country-variant entity).
EN0011 – Contract (RO tax-redirect declaration document — adjacent country-variant entity).

---

## Integrations

None directly — document rendering is an internal system responsibility. Dispatch of the confirmation
PDF by email is carried by the transactional messaging capability (FN0019 – Transactional Messaging &
Templating), which archives the send via EmailArchive (EN0022) and transports through Mautic. See
ARCH0002_ContextInteractionMap for the integrations landscape.

---

## Constraints

- The paid-donation total is computed by summing Transaction amounts through a route that bypasses the
  donation payment processing capability (FN0007) — a direct aggregate read rather than a service call,
  coupling this capability's correctness to the Transaction data shape.
- No idempotency safeguard exists: repeated requests for the same donor/year each issue a separate
  DonationConfirmation record and a separate email, with no deduplication.
- The DonationConfirmation snapshot is persisted before document rendering and dispatch are attempted,
  so a rendering or dispatch failure leaves a confirmation record on file with no corresponding email
  ever sent — a silent, partially-completed outcome.
- The RO tax-redirect declaration sub-capability is Partial/un-mined: it is evidenced only as an
  adjacent flow reference and does not read paid-Transaction totals or produce a DonationConfirmation
  PDF, making it a distinct mechanism rather than a localized variant of the CZ confirmation path.

---

## Note

Canonical slot for document generation, referenced by sibling capabilities FN0002 and FN0007. Contract-document
rendering for UC0004 is owned by FN0009 (Contract Generation & E-Signature); this capability owns the
tax/confirmation document family (CZ donation confirmation and the adjacent RO tax-redirect
declaration).
