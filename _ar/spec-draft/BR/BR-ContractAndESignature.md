---
doc_id: BR-ContractAndESignature
title: Contract & E-Signature
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0011
  - EN0001
  - EN0008
  - EN0012
  - EN0004
  - EN0015
  - SYSTEM
references:
  - EN0011
  - EN0012
  - EN0001
  - EN0008
  - EN0004
  - EN0015
  - UC0004
  - UC0010
---

# BR – Contract & E-Signature

## Purpose

Governs contract generation, the two-step signature progression that drives the case status,
typed-name signature validation, per-year contract numbering, and the current-state non-atomic and
race-prone aspects of that progression.

---

## Signature progression drives the case

- Contract signature progression SHALL be expressed through the case status: creating/sending a
  Contract (EN0011) SHALL drive the owning Application (EN0001) to the contract status, the manager
  signature SHALL drive it to the waiting-signature status, and the fundraiser signature SHALL drive
  it to the contract-signed status.
- A Contract SHALL NOT carry its own independent status enum — the signature progression SHALL be
  the only externally observable record of how far the Contract has advanced.
- The fundraiser's typed signature name SHALL equal the fundraiser's registered full name for the
  signature to be accepted; a mismatched typed name SHALL be rejected and SHALL NOT advance the
  Application status.
- Only the actor on record as the fundraiser for an Application SHALL be permitted to perform the
  fundraiser signature step on that Application's Contract.

---

## Numbering

- A Contract human-readable number SHALL be a per-year sequential value; the CZ public number SHALL
  further incorporate the linked Campaign's (EN0004) variable symbol.
- Current-state: Contract number uniqueness SHALL NOT be assumed enforced at the data level —
  concurrent number generation is race-prone (current-state gap).

---

## Current-state gaps

- Current-state: the manager-check notification SHALL NOT be assumed to block progression — if the
  checking recipient or the rendered document is unavailable at send time, the notification is
  skipped while the Application status still advances to the manager-review step (current-state gap).
- Current-state: the signing-chain status transitions (creation → manager signature → fundraiser
  signature) SHALL NOT be assumed transaction-wrapped — a mid-sequence failure can leave the Contract
  and its owning Application's status in a partially-completed, inconsistent combination
  (current-state gap).

---

## RO tax-redirect declaration pairing

- A RO tax-redirect payer record (EN0015) SHALL be paired with exactly one redirect Contract
  (EN0011).
- Current-state: the RO tax-redirect declaration is a distinct mechanism and SHALL NOT be assumed to
  reuse the CZ donation-confirmation path — it neither reads a paid-donation total nor produces a
  donation-confirmation document (Partial evidence).

---

## Non-Goals

This rule does not define the manager-check or for-signature notification contracts themselves (→
BR-TransactionalMessaging). It does not define the Application status vocabulary or general
transition governance (→ BR-ApplicationStatusGovernance) — it references that governance only for
the contract-driven transitions named above. It does not define the RO tax-redirect document's
generation mechanics or CZ tax-confirmation contract, which share the broader tax family with
BR-DonationConfirmationAndTax. It does not restate Contract, ContractTemplate, Application, User, or
TaxPayer attributes (→ EN0011, EN0012, EN0001, EN0008, EN0015) or the step-by-step contract/signing
flow (→ UC0004, UC0010).
