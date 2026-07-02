---
doc_id: EN0008
title: User
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001
  - EN0006
  - EN0007
  - EN0018
  - BR-AccessControlAndRoles
  - BR-DataProtectionAndErasure
  - BR-PartyIdentityAndDeduplication
  - BR-CampaignRecommendationDormant
  - UC0001
  - UC0014
  - UC0015
  - UC0016
---

# EN0008 — User (Party)

## Purpose

The User is the first-class Party in the domain: every actor who can authenticate or act on the
platform — applicant (fundraiser), patron, supporter, organisation worker, and back-office staff
(accountant, content admin, coordinator, senior coordinator, front-office, manager, marketing,
risk manager, administrator) — is represented as a single User type, differentiated by role rather
than by a separate account type per actor kind (see BR-AccessControlAndRoles). The User is the
ownership/authorship anchor referenced by nearly every other domain entity; it also carries a link
to a Contact (EN0006), the party's underlying personal-data record.

---

## Lifecycle

- Unregistered (no User exists for the person)
- Registered — active, password-less
- Registered — blocked, password-less (provisioned on the person's behalf, not yet activated)
- Active (authenticated / usable)
- Anonymized (login identity cleared, account otherwise retained)
- Removed (account no longer exists)

---

## State Transitions

Unregistered → Registered (active, password-less)
trigger: UC0014 (self-registration) / UC0001 (fundraiser/patron self-registration during Application submission)

Unregistered → Registered (blocked, password-less)
trigger: UC0001 / UC0014 (User provisioned from an Application on the person's behalf, fundraiser or patron role)

Unregistered → Registered (organisation-worker role)
trigger: UC0016 (organisation worker created or linked from the worker-management flow)

Registered (blocked or password-less) → Active
trigger: UC0014 (activation / magic-link login establishes credentials and an authenticated session)

Active → Anonymized
trigger: UC0015 (GDPR anonymization request clears login email and display name; account is retained, not deleted or blocked)

Active → Removed
trigger: UC0016 (contact deduplication merge deletes the User owning a losing duplicate Contact, EN0006)

---

## Attributes

### System-managed attributes

- roles (list of values; required; the User's assigned domain role(s) — fundraiser, patron,
  supporter, organisation worker, or a back-office role; a User may hold more than one role
  concurrently — see BR-AccessControlAndRoles)
- account status (value; required; active or blocked)
- last-login / last-access timestamps (datetime; optional; recorded on successful authentication)
- contact (reference to EN0006 — Contact; the party's linked Contact record)

### User-provided attributes

- login email (string; required while the account is not anonymized; also serves as the contact
  address and login identifier)
- display name (string; required)
- first name / last name (string; optional)
- name prefix / name suffix (string; optional)
- name display preference (value; optional; full / short / hidden)
- public profile flag (boolean; optional; whether the User's profile is visible publicly)
- worker availability flag (boolean; optional; applicable to organisation-worker role)
- profile image (optional)
- bank account identifier (string; optional)

---

## Invariants

- A User is differentiated by assigned role rather than by a distinct account type — see
  BR-AccessControlAndRoles.
- A User SHALL be able to hold more than one role concurrently — see BR-AccessControlAndRoles.
- A User SHALL be granted the supporter role on the first paid donation it owns, idempotently —
  see BR-AccessControlAndRoles.
- A User provisioned from an Application (EN0001) on a person's behalf SHALL be created without a
  usable password until a separate activation step is completed — see BR-PartyIdentityAndDeduplication.
- A magic-link authentication token SHALL only be honoured within its validity window — see
  BR-AccessControlAndRoles.
- GDPR anonymization of a User SHALL NOT be assumed to erase all related personal data held by the
  same party — see BR-DataProtectionAndErasure.
- A User that owns a losing duplicate Contact (EN0006) in a deduplication merge SHALL be deleted as
  a direct side effect of the merge, outside the anonymization/erasure path — see
  BR-DataProtectionAndErasure and BR-PartyIdentityAndDeduplication.
- Any coupling between a User and campaign recommendations SHALL NOT be treated as an active
  invariant — see BR-CampaignRecommendationDormant.

---

## Relationships

- EN0006 — Contact (the User's linked party/personal-data record)
- EN0001 — Application (a User acts as fundraiser, patron, or other case-linked role)
- EN0007 — Account (Account references its owning User)
- EN0018 — Organisation (a User may be an organisation worker or manager)

---

## Open Questions

- Given GDPR anonymization clears the User's login identity in place but downstream marketing-CRM
  synchronization re-populates the party's name, how is true erasure achieved for an anonymized
  User? (see BR-DataProtectionAndErasure)
- Which attribute distinguishes a fundraiser User from a patron User beyond assigned role?
- Is a recommendation-related attribute observed on User authoritative relative to the equivalent
  attribute on Account (EN0007)? Current-state: the coupling is dormant — see
  BR-CampaignRecommendationDormant.
