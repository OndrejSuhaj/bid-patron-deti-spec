---
doc_id: FN0018
title: Identity, Session & Access Control
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0014
  - UC0001
  - UC0005
  - UC0006
  - UC0016
  - EN0008
  - EN0006
  - EN0007
---

# FN0018 – Identity, Session & Access Control

## Purpose

Give a person identified in the domain a durable, authenticated identity: validate credentials
(password or magic-link) and open a session, self-register a User (EN0008), provision a User out of
an already-submitted Application (EN0001), and hold the role model that authorizes subsequent
actions. This is the canonical identity/session capability referenced across the specification
wherever an actor is authenticated, registered, or granted a role.

## Responsibilities

- Authenticate a User (EN0008) by password or magic-link token, applying flood control and
  blocked-account checks, and issue a session token plus a CSRF-style access token on success.
- Self-register a new User — active, password-less — with the requested role(s) and a linked Contact
  (EN0006), leaving password/activation to a separate, caller-triggered step.
- Provision a User and/or Contact out of an approved Application (EN0001): a fundraiser or patron
  becomes a blocked, password-less User linked to a Contact; a child is represented as a Contact only,
  with no User created.
- Own the role model (fundraiser, patron, supporter, coordinator, accountant, organisation-worker,
  and further back-office roles) that gates who may act, including granting the supporter role the
  first time a Transaction reaches PAID (FN0007).
- Link every new User to its Contact record, and notify downstream search-index and CRM-sync
  processes whenever a party is created or changed.
- Provision or update an organisation-worker User linked to a Contact when an Organisation's worker
  list is maintained (UC0016), including dispatch of an account-activation message for a newly
  created, not-yet-active worker.
- Reassign or remove User/Contact identity records as a consequence of party de-duplication (UC0016):
  redirect an application-level party reference to a surviving Contact and remove the User that owned
  a losing duplicate Contact.

## Related Use Cases

UC0014 (Authenticate & Manage Access — owns login, self-registration, and Admin-driven creation from
an Application), UC0001 (Submit Application — self-registration and existing-user reuse on lead
intake share this capability), UC0005 (Make a Donation — resolves/creates/role-upgrades the donor
User), UC0006 (Confirm Payment — grants the supporter role on first PAID), UC0016 (Maintain Party
Records — organisation-worker provisioning and identity reassignment/removal on merge).

## Related Entities

EN0008 User (the authenticated/created/role-bearing identity at the center of this capability), EN0006
Contact (the linked party record created alongside a new or provisioned User), EN0007 Account
(owner-scoped patron/fundraiser record associated with a User; referenced for completeness, though its
recommendation-related behavior is dormant and outside this capability's active scope).

## Integrations

None directly on the authentication/registration/provisioning path itself. Magic-link email dispatch
is an adjacent path carried by the transactional-messaging capability (FN0019). Downstream
search-index and CRM-sync notification triggered on new/changed parties is likewise handed off
asynchronously outside this capability's boundary. See ARCH0002 for the consolidated integrations
landscape.

## Constraints

- The login-history write path is fully disabled (write hook commented out), so no login attempt
  record is persisted — current-state auditability gap.
- Flood-control enforcement is inconsistent across login endpoint versions: on two of three versions
  the flood-check result is computed but its return value is ignored, so brute-force attempt limits
  are not actually enforced on those endpoints; only the newest version honors it.
- A hash-based login branch on the newest endpoint version calls an account-service method that does
  not exist in the codebase, making that branch non-functional (latent fatal error), not merely
  dormant.
- Magic-link tokens carry a fixed 90-day validity window.
- The public self-registration endpoint is a non-functional stub that always reports success without
  creating anything; the actual registration behavior is carried by a shared registration engine
  invoked by other flows (self-registration UI, donation, application intake), not by that endpoint.
- Admin-driven creation of a User from an Application is triggered by a state-changing read-style
  request with no CSRF protection beyond a permission check — a current-state security weakness.
- A partial failure after Contact creation during Admin-driven user provisioning can leave an orphaned
  Contact with no linked User and no Application reference — a recorded data-integrity risk, not
  designed behavior.
- Newly created Users (whether self-registered or provisioned from an Application) are left
  password-less; activation/password-setup is always a separate, subsequent step, never automatic.
