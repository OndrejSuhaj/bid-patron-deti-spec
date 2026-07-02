---
doc_id: EN0015
title: TaxPayer
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0011  # Contract — the sole outbound relation; the RO redirect contract this payer signs
  - BR-ContractAndESignature  # RO tax-redirect declaration pairing invariant
  - BR-DonationConfirmationAndTax  # confirms TaxPayer/Contract pairing is a distinct RO mechanism, not the CZ confirmation path
  - UC0010  # AF4 — RO tax-redirect declaration (adjacent country variant), Partial evidence
---

# EN0015 – TaxPayer

## Purpose

A Romanian tax-redirection payer record. It captures a Romanian donor who elects to redirect a
percentage of their income tax (2% / 3.5%) to the organisation, holding the donor's identity and
address details needed for the redirect declaration together with a multi-year consent flag. It is
the RO-specific counterpart to the CZ DonationConfirmation (EN0014): both express a tax-related
donor record, but TaxPayer serves the RO income-tax-redirect mechanism rather than a donation
confirmation document.

---

## Lifecycle

No entity-level state machine is evidenced for TaxPayer. It is a captured payer record, created once
and paired with a redirect Contract (EN0011); no further promote/approve/void state is observed.

---

## State Transitions

(none) → captured
trigger: UC0010 AF4 – RO tax-redirect declaration (adjacent country variant) — Partial evidence; the
declaration submission creates the TaxPayer record together with its paired Contract (EN0011).

No further transitions are evidenced.

---

## Attributes

### System-managed attributes

- created (timestamp; system-managed; record creation time)
- changed (timestamp; system-managed; last modification time)

### User-provided attributes

- name (text; required; entity label)
- first_name / last_name (text; required)
- initial (text; required; father's initial, per RO identification convention)
- email (text; required; validated as an eligible email address)
- numeric_code (text; required; Romanian Personal Numeric Code / CNP)
- phone (text; required; RO country context; not required to be unique)
- fax (text; optional; not required to be unique)
- street / number / town / postal_code (text; required)
- county (text; required; county or sector, per RO/MD administrative division)
- block / staircase / floor / apt (text; optional; RO address detail)
- two_years_agreed (boolean; optional; consent to a two-year tax-redirect commitment)

---

## Invariants

- A TaxPayer is paired with exactly one redirect Contract (EN0011) — see
  BR-ContractAndESignature §RO tax-redirect declaration pairing.
- The TaxPayer/Contract pairing is a distinct RO mechanism and is not a localized variant of the CZ
  donation-confirmation path — see BR-DonationConfirmationAndTax §Non-Goals.

---

## Relationships

- EN0011 – Contract (the redirect Contract this TaxPayer is paired with; sole outbound relation)

---

## Open Questions

1. How is the linked Contract (EN0011) generated and signed as part of TaxPayer creation? The
   creation/pairing path is evidenced only as an adjacent, separately-tracked flow (UC0010 AF4) and
   has not been deep-mined.
2. Does `two_years_agreed` drive suppression of repeat multi-year re-submission, or is it recorded
   consent only? Not evidenced.
3. Do the CNP and email fields enforce format/eligibility validation beyond required presence (e.g.
   CNP checksum)? Not evidenced at the canonical level.
4. No status vocabulary or publish flag is evidenced for TaxPayer, unlike sibling entities — this
   appears to be a genuine absence rather than a gap; flagged for confirmation during closure.
