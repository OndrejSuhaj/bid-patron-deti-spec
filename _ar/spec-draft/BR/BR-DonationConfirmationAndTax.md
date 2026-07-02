---
doc_id: BR-DonationConfirmationAndTax
title: Donation & Tax Confirmation
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0014
  - EN0009
  - EN0008
  - EN0015
  - SYSTEM
references:
  - EN0014
  - EN0009
  - EN0008
  - EN0015
  - UC0010
---

# BR – Donation & Tax Confirmation

## Purpose

Governs the CZ donation (tax) confirmation: the server-computed confirmed-donation total, its
immutable snapshot, CZ-only availability, and the current-state absence of idempotency.

---

## Server-computed confirmed total

- A donation confirmation's (EN0014) confirmed total SHALL be a server-computed sum over the
  donor's (EN0008) non-test, donation-flagged, paid Transactions (EN0009), optionally scoped by
  confirmation year and Campaign.
- Donor identity fields captured on a donation confirmation SHALL be treated as caller-supplied
  snapshots, not independently verified data; the confirmed total, in contrast, SHALL be
  authoritative and server-derived.
- Confirmation issuance SHALL be aborted, and no DonationConfirmation (EN0014) SHALL be created,
  when the computed total for the requested donor and year is zero.

---

## Immutable snapshot

- A donation confirmation SHALL be persisted as an immutable, write-once snapshot of the donor
  identity, the confirmed total, the amount in words, and the confirmation year (EN0014); once
  created, these captured values SHALL NOT be treated as live references back to the donor or to
  underlying Transactions (EN0009).
- Current-state: the snapshot SHALL be persisted before the corresponding confirmation document is
  rendered and dispatched; a failure during rendering or dispatch can therefore leave a persisted
  confirmation record with no corresponding message having been sent (current-state gap — see
  UC0010).

---

## Availability and idempotency (current-state)

- The donation confirmation (EN0014) SHALL be available only for the CZ country; the RO and MD
  country configurations SHALL NOT produce this confirmation record or document.
- Current-state: donation-confirmation issuance is NOT currently protected by any idempotency
  safeguard — repeated requests for the same donor and confirmation year each independently issue a
  separate DonationConfirmation (EN0014) record and a separate dispatched message, rather than being
  deduplicated or rejected (current-state gap).

---

## Non-Goals

- This rule does not define the CZ confirmation document's rendering, layout, or delivery mechanics
  (owned by UC0010 and the message contract referencing it).
- This rule does not cover the RO tax-redirect ("2%"/"3.5%") declaration and its Contract/TaxPayer
  (EN0015) pairing — that mechanism is a distinct RO counterpart to the CZ confirmation and is
  governed elsewhere.
- This rule does not define the confirmation email's send-gating or recipient contract — owned by
  the transactional-messaging rules referencing MSG0028.

---

*Note: Owns the CZ donation-confirmation rules. The confirmation email dispatch/send-gate is owned
by the transactional-messaging business rules (see MSG0028). The RO tax-redirect declaration pairing
belongs to the contract/e-signature business rules; this document covers only the CZ confirmation
total and snapshot.*
