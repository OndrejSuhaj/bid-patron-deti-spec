---
doc_id: EN0014
title: DonationConfirmation
canonical_layer: EN
spec_type: entity
status: draft
references:
  - BR-DonationConfirmationAndTax
  - BR-MultiTenantCountryScoping
  - EN0004
  - EN0008
  - EN0009
  - EN0015
  - EN0022
  - UC0010
---

# EN0014 — DonationConfirmation

## Purpose

A Czech tax donation certificate ("Potvrzení o daru"): an immutable, write-once snapshot of a
donor's identifying data and confirmed donation total for a given tax year, issued to support a
tax deduction. The snapshot captures donor identity, the confirmed donation total, and GDPR
consent as point-in-time values rather than live references to the donor or to underlying
Transactions (EN0009).

Country availability, the server-computed nature of the confirmed total, and the current-state
absence of an idempotency safeguard are governed by `BR-DonationConfirmationAndTax` and
`BR-MultiTenantCountryScoping`.

---

## Lifecycle

Issued — the only observed state. A DonationConfirmation is created already complete and
published; no further state change is observed after creation (see Invariants).

---

## State Transitions

(none) → Issued
trigger: UC0010 — Issue Donation Confirmation (Tax)

No further transitions are observed; see Invariants (write-once snapshot).

---

## Attributes

### System-managed attributes

- donation_total (integer; required; the confirmed donation amount for the confirmation year; server-computed — see Invariants)
- donation_in_words (string, max 250; required; the confirmed total expressed in words)
- number_of_requests (integer; optional; count of confirmation requests observed for the donor)
- ip_address (string, max 20; system-captured at request time)
- user_agent (string, max 250; system-captured at request time)
- published (boolean; default true; no further status vocabulary is defined for this entity)

### User-provided attributes

- name (string, max 50; required; donor or requester name; serves as the entity's label)
- email (string, max 200; required; requester's email address)
- address (string, max 250; required; donor or requester address)
- rodne_cislo (string, max 20; optional; Czech birth/personal identification number)
- confirmation_year (integer; required; the tax year the confirmation covers)
- campaign (optional; reference to EN0004 — Campaign the confirmed donations are scoped to, when the request is campaign-specific)
- agreement_truthfulness (boolean; required; default true; GDPR/accuracy consent captured at request time)
- agreement_personal_data (boolean; required; default true; GDPR personal-data consent captured at request time)

---

## Invariants

- The confirmed `donation_total` is server-computed, not user-entered — see `BR-DonationConfirmationAndTax`.
- Donor identity fields and the confirmed total are captured as an immutable, write-once snapshot — see `BR-DonationConfirmationAndTax`.
- Available only for the CZ country; no equivalent DonationConfirmation record is produced for RO or MD — see `BR-DonationConfirmationAndTax`, `BR-MultiTenantCountryScoping`.
- Not protected by an idempotency safeguard: repeated requests for the same donor and year each independently produce a separate DonationConfirmation — see `BR-DonationConfirmationAndTax`.

---

## Relationships

- EN0004 — Campaign (optional; donation total may be scoped to a campaign)
- EN0008 — User (the donor/requester whose donations are confirmed)
- EN0009 — Transaction (read-only source of the confirmed total; not referenced live after snapshot creation)
- EN0015 — TaxPayer (RO counterpart entity for the equivalent RO tax-redirect mechanism; not the same lifecycle — see Open Questions)
- EN0022 — EmailArchive (archive record of the dispatched confirmation document/email)

---

## Open Questions

1. Document rendering/dispatch of the confirmation (PDF generation, email delivery) — is this
   part of the entity's own lifecycle or entirely a downstream, non-entity-owned effect of
   UC0010? Current draft treats the DonationConfirmation record itself as complete at creation,
   with rendering/dispatch as a use-case-level side effect (see UC0010 AF2 for the partial-dispatch
   case).
2. Whether the RO TaxPayer (EN0015) mechanism should be modeled as a lifecycle variant of this
   entity or as a fully distinct entity is unresolved — current evidence treats them as parallel,
   country-specific mechanisms rather than shared lifecycle states.
