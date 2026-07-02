# UC0014 — Authenticate & Manage Access

## Header

| Field | Value |
|---|---|
| UC ID | UC0014 |
| Name | Authenticate & Manage Access |
| Bounded Context | C9 |
| Primary Actor(s) | Customer, Admin, System |
| Trigger Type | API/UI |

## Actors & Responsibilities

- **Customer** — an applicant, patron, fundraiser, or supporter who authenticates against the platform (password or magic-link) and/or self-registers a User (EN0008) account.
- **Admin** — back-office staff who creates a User account on behalf of a person already captured on an Application (EN0001), assigning the appropriate role.
- **System** — enforces credential checks, session/token issuance, flood control, account-record creation, and linking of a new User to its Contact (EN0006).

## Intent

Give a person identified in the domain (applicant, patron, fundraiser, supporter, or child dependant) a durable, authenticated identity in the platform — either by validating existing credentials to open a session, by self-registering a new User, or by an Admin provisioning a User out of an already-submitted Application — so that subsequent actions can be attributed to and authorized for that identity.

## Preconditions

- For login: a User (EN0008) account already exists and is not blocked.
- For self-registration: the caller supplies at minimum an email address; a Contact (EN0006) may optionally be supplied or is created fresh.
- For creation from an Application: an Application (EN0001) and its associated Application Profile already exist and carry the personal data needed to seed a Contact and/or User; the acting Admin holds the permission to add leads.

## Main Flow

### UC0014.1 — API login (password or magic-link)
1. Customer: submits an email and password (or a magic-link token) to a login endpoint.
2. System: validates that the credential fields are present; rejects the request if missing.
3. System: checks that the User account is not blocked; rejects the request if it is.
4. System: applies login flood control (per-IP and per-user attempt limits) before accepting the credential.
5. System: verifies the submitted password against the User's stored credential (or, for a magic-link token, decodes and validates the token and its expiry window).
6. System: on successful verification, establishes an authenticated session for the User and issues a session token and an access token (CSRF-style) to the Customer.
7. System: records the User's last-login and last-access timestamps.

### UC0014.2 — API self-registration
1. Customer: submits registration data (at minimum an email; optionally name, phone, and a role) to a registration endpoint.
2. System: creates a new User (EN0008) record with the supplied email as both the account identifier and contact address, in an active, password-less state.
3. System: assigns the requested role(s) to the new User (e.g. supporter, patron, fundraiser).
4. System: creates a linked Contact (EN0006) for the new User when one was not already supplied, carrying the person's name, phone, and email.
5. System: links the new User to its Contact record.
6. System: notifies downstream search-index and CRM-sync processes that a new User exists (asynchronous, outside this use case).
7. System: leaves activation/password-setup to a separate, caller-triggered activation step (magic-link issuance), which is not automatically invoked by registration itself.

### UC0014.3 — Create User from an approved Application (shared with UC0001)
1. Admin: opens the "create user" action on an Application (EN0001), specifying the target role (fundraiser, patron, or child) and the source Application Profile.
2. System: confirms the Application, the Application Profile, and the requested role are all present and valid; otherwise the action is aborted with no changes.
3. System: checks whether a User or Contact already exists for the person (by email for fundraiser/patron, by national identifier for a child).
4. System: creates a new Contact (EN0006) from the Application Profile's personal data when no matching Contact/User already exists (fundraiser, patron: person contact with name, phone, address; child: person contact with name and national identifier).
5. System: creates a new User (EN0008), linked to the Contact, with the requested role, for the fundraiser or patron case; a child is represented by a Contact only, with no User created.
6. System: the newly created User is left in a blocked, password-less state; activation is a separate, subsequent step not performed by this flow.
7. System: links the created User (fundraiser/patron) or Contact (child) back onto the Application in the corresponding role field.
8. System: notifies downstream search-index and CRM-sync processes that a new User and/or Application change exists (asynchronous, outside this use case).

## Alternative Flows

### AF1 — Login rejected: invalid or missing credentials
1. Customer: submits a login request with missing or incorrect credentials.
2. System: rejects the request with an authentication error and does not establish a session.

Outcome: no session is created; the Customer remains unauthenticated.

### AF2 — Login rejected: blocked account
1. Customer: submits valid-looking credentials for an account that is administratively blocked.
2. System: rejects the request with an "account not active" error.

Outcome: no session is created for the blocked account.

### AF3 — Login throttled by flood control
1. Customer: repeatedly submits failed login attempts from the same IP address or against the same account.
2. System: once the configured attempt threshold is reached, rejects further login attempts with a flood-control error until the throttling window elapses.

Outcome: further login attempts are blocked for a cooldown period. (Evidence notes this enforcement is inconsistent across endpoint versions — see Evidence Level.)

### AF4 — Magic-link login expired or invalid
1. Customer: opens a magic-link containing an expired or malformed token.
2. System: rejects the token as expired/invalid and does not establish a session.

Outcome: no session is created; the Customer must request a new magic-link or use password login.

### AF5 — Registration data fails validation
1. Customer: submits registration data that collides with an existing account (duplicate email) or fails account validation rules.
2. System: aborts the registration without creating a User or Contact, and no account is returned to the caller.

Outcome: no new User/Contact is created; the caller must resolve the conflict (e.g. use login or password-recovery instead).

### AF6 — Create-User-from-Application aborted for missing prerequisites
1. Admin: triggers the create-user action without a valid Application, Application Profile, or role selection.
2. System: aborts with no User, Contact, or Application changes made.

Outcome: the Application is left unchanged; the Admin must supply valid prerequisites and retry.

### AF7 — Create-User-from-Application partially fails after Contact creation
1. Admin: triggers the create-user action for a fundraiser or patron whose data fails User validation or raises an error during creation.
2. System: the Contact created earlier in the same flow is not rolled back, but the User is not created and the Application is not updated with the new reference.

Outcome: an orphaned Contact may remain with no linked User and no Application reference — flagged as a current-state data-integrity risk, not a designed outcome.

## Postconditions

- On successful login: an authenticated session exists for the Customer's User; last-login/last-access timestamps are updated.
- On successful self-registration: a new User exists, linked to a Contact, in an active but password-less state, awaiting a separate activation step.
- On successful creation from an Application: a new (or reused) User exists for fundraiser/patron in a blocked, password-less state, linked to a Contact; or a Contact-only record exists for a child; the Application carries the corresponding fundraiser/patron/child reference.
- On any rejected/aborted path: no session is created and no new User/Contact/Application reference is persisted (except the acknowledged partial-write risk in AF7).

## Traceability

Target SRVs:
- Identity-&-Access

EN entities:
- EN0008 User — the authenticated/created identity at the center of every sub-flow.
- EN0006 Contact — the linked party record created alongside a new User (or standalone for a child).
- EN0007 Account — the owner-scoped patron/fundraiser record associated with a User; referenced for completeness though its ML-recommendation behavior is dormant and not exercised by this use case.

Integration boundaries:
- None synchronous within this use case. Asynchronous downstream notifications to search-indexing and CRM-sync processes occur after User/Application saves in UC0014.2 and UC0014.3 but are outside this use case's boundary. A transactional-email dispatch (magic-link) exists on an adjacent path referenced by FLW0014/FLW0015 but is not itself part of the login/registration steps modeled here.

Flow Evidence:
- FLW0014 (API login — password and magic-link branches)
- FLW0015 (API register — registration engine; the versioned public registration endpoint itself is a non-functional stub per evidence, so behavior is drawn from the underlying registration engine it wraps)
- FLW0026 (Create user from application — shared with UC0001)

## Evidence Level

Confirmed — grounded in SRV0015/Identity-&-Access (UC-srv-traceability.md row 21/71), EN0008/EN0006/EN0007 entity lifecycles, and flow dossiers FLW0014, FLW0015, and FLW0026, all rated Confirmed or Partial-with-explicit-caveats in their own headers; version-specific flood-control and magic-link-hash defects are carried into AF3/AF4 rather than smoothed over.
