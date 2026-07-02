---
doc_id: BR-AccessControlAndRoles
title: Access Control & Role Assignment
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0008
  - EN0006
  - SYSTEM
references:
  - EN0008
  - EN0006
  - UC0014
  - UC0001
---

# BR – Access Control & Role Assignment

## Purpose

Governs the role-based access model, how a role is assigned to a User (including the automatic supporter
grant on first paid donation), and the current-state authentication and authorization weaknesses that affect
who can act on the system today.

## Role model

- Every actor SHALL be represented as a User (EN0008), differentiated by role rather than by a separate
  account type per actor kind.
- Authorization for an action SHALL be determined by the acting User's assigned role(s).
- A User SHALL be able to hold more than one role concurrently (e.g. a fundraiser who is also a supporter).

## Supporter role assignment

- A User SHALL be granted the supporter role the first time a donation they own reaches the paid state, and
  the grant SHALL be a no-op when the role is already present.

## Authentication (current-state gaps)

- A magic-link login token SHALL be valid for a fixed 90-day window from issuance and SHALL be rejected once
  expired; a token bearing a future issuance timestamp SHALL also be rejected.
- Current-state: brute-force flood-control on login SHALL NOT be assumed enforced on all login surfaces —
  it is honoured only on the newest login surface; on the other current login surfaces the flood-control
  check is evaluated but its result is discarded, so repeated failed attempts are not actually blocked and
  failure counters are not incremented (current-state gap).
- Current-state: login attempts SHALL NOT be assumed recorded — the login-history write path exists but is
  disabled, so no audit trail of login attempts is produced (current-state gap).
- Current-state: administrative creation of a User (and its linked Contact, EN0006) from an Application case
  is triggered by a state-changing read-style request, authorized only by a single permission check with no
  CSRF protection and no additional confirmation step (current-state gap).

## Non-Goals

- This rule does not define the full role catalog or role-to-permission mapping — see the glossary and EN0008.
- This rule does not define GDPR erasure of a User's personal data — see BR-DataProtectionAndErasure.
- This rule does not define party provisioning (Contact/User creation from a case) or party
  identity/deduplication — see BR-PartyIdentityAndDeduplication.
- This rule does not prescribe target-state remediation (enforced flood control everywhere, login-attempt
  auditing, CSRF-protected administrative actions); it records current-state behaviour only.
