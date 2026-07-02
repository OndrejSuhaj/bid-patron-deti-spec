---
doc_id: BR-PartyIdentityAndDeduplication
title: Party Identity, Uniqueness & Deduplication / Merge
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0006
  - EN0008
  - EN0018
  - EN0001
  - EN0002
  - UC0016
  - SYSTEM
references:
  - EN0006
  - EN0008
  - EN0018
  - EN0001
  - EN0002
  - UC0016
  - UC0001
---

# BR – Party Identity, Uniqueness & Deduplication / Merge

## Purpose

Governs party identity across the universal Contact store and the Organisation registry: how identity is
(not) enforced, how duplicate parties are detected, and the current-state merge behaviour that consolidates
them — including its destructive and non-transactional characteristics.

## Party identity uniqueness (current-state: NOT enforced)

- Current-state: party identity SHALL NOT be assumed unique at the data level — no uniqueness is enforced on
  national identification number, phone, or email across the party store (EN0006).
- Current-state: party references between the case aggregate (EN0001) and the party store (EN0006) are soft
  references only and SHALL NOT be assumed to enforce referential integrity.

## Party provisioning from a case

- When a case (EN0001) is provisioned into parties, a fundraiser or a patron SHALL become a User (EN0008)
  linked to a party record (EN0006), and a child SHALL be represented as a party record (EN0006) only, with
  no User.
- A child party record SHALL be deduplicated on national identification number and reused when a matching
  record already exists.
- A newly provisioned User SHALL be created without a usable password until a separate activation step is
  completed.

## Duplicate detection

- Duplicate party records SHALL be detected by grouping on matching national identification number, phone, or
  email, expanding a candidate group transitively across overlapping matches (UC0016).
- An administrator SHALL be able to exclude a specific duplicate criterion from future detection without
  altering any party record.

## Contact deduplication / merge (current-state behaviour)

- A contact merge SHALL reassign every dependent case (EN0001) and profile (EN0002) reference from each
  duplicate onto the chosen surviving party record.
- Current-state: a contact merge hard-deletes each losing party record together with its owning User account,
  bypassing the dedicated erasure path.
- Current-state: a merge SHALL NOT be assumed transactional and offers no dry-run — a mid-merge failure can
  leave a partially reparented graph.

## Lead pairing / merge (current-state behaviour)

- A lead pairing SHALL transfer the duplicate lead's patron profile (and its linked patron party, when
  present) onto the surviving main case, then set the duplicate lead to the duplicate status and clear its
  party references.
- Current-state: a lead pairing overwrites any pre-existing patron profile on the surviving case
  unconditionally, orphaning the prior reference even on the successful path.

## Organisation deduplication / merge (current-state behaviour)

- An organisation merge SHALL reassign the employer reference held by every affected case (EN0001) onto the
  chosen surviving organisation (EN0018), then remove the duplicate organisations.
- Current-state: an organisation merge reparents only the employer reference; any other reference to a
  removed organisation is left dangling.

## Authorization scope (current-state)

- Current-state: all merge and pairing actions SHALL NOT be assumed to be country- or role-scoped and are
  gated only by ordinary record-edit permission.

## Non-Goals

- This rule does not define GDPR erasure of party PII — see BR-DataProtectionAndErasure.
- This rule does not define the Contact risk/blacklist classification write performed by scoring — see
  BR-ScoringAndRiskGating.
- This rule does not define the supporter role grant on first paid transaction — see
  BR-AccessControlAndRoles.
- This rule does not prescribe target-state fixes (transactional merge, dry-run, uniqueness constraints); it
  records current-state behaviour only.
