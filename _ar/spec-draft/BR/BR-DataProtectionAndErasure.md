---
doc_id: BR-DataProtectionAndErasure
title: Data Protection & GDPR Erasure
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0008
  - EN0006
  - EN0001
  - SYSTEM
references:
  - EN0008
  - EN0006
  - EN0001
  - UC0015
---

# BR – Data Protection & GDPR Erasure

## Purpose

Governs personal-data erasure for a party under a right-to-erasure request, and records the
current-state incompleteness of that erasure — including the anti-erasure re-synchronisation effect
and the destructive-delete-as-side-effect concern arising elsewhere in the domain.

## Erasure scope (current-state: incomplete)

- Current-state: personal-data erasure SHALL NOT be assumed complete — only the login email and
  display name held on the party's User record (`EN0008`) are cleared, while its first/last name
  fields and all related case (`EN0001`) and party (`EN0006`) personal data are left intact, with no
  cascade to those records.
- Current-state: the marketing-CRM contact-deletion request invoked as part of the erasure request
  performs no actual removal against the marketing CRM.
- Current-state: the erasure re-synchronisation queued by the same request re-creates or updates the
  party's marketing-CRM contact record with the party's names still populated, working against the
  erasure intent rather than completing it (anti-erasure hazard).

## Erasure controls (current-state)

- Current-state: the erasure action SHALL NOT be assumed to require a confirmation, re-authentication,
  or second-approval step — it is gated by permission only.
- Current-state: once a party's login email has been cleared by a successful erasure request, a repeat
  erasure request against the original email address can no longer locate or re-target that party.

## Destructive deletion as a side effect

- Current-state: a party record (`EN0006`) and its owning User (`EN0008`) SHALL NOT be assumed to be
  routed through the erasure path when removed as part of a deduplication merge — the merge deletes
  them directly and irreversibly, which is a GDPR-relevant deletion occurring as a side effect outside
  the erasure request path.

## Non-Goals

- This rule does not define the deduplication-merge mechanics that cause the destructive deletion
  referenced above — see `BR-PartyIdentityAndDeduplication` (governs the merge itself).
- This rule does not define the marketing-CRM re-synchronisation mechanism itself (queueing, payload
  construction, delivery) — that is owned by the marketing/analytics relay rule, when established.
- This rule does not prescribe target-state fixes (cascading erasure, confirmation step, functioning
  CRM deletion); it records current-state behaviour only.
