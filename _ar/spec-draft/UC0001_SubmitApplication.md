# UC0001 — Submit Application (Žádost)

## Header

| Field | Value |
|---|---|
| UC ID | UC0001 |
| Name | Submit Application (Žádost) |
| Bounded Context | C1 |
| Primary Actor(s) | Customer, Admin |
| Trigger Type | UI/API |

## Actors & Responsibilities

- **Customer** — an anonymous visitor (prospective fundraiser or patron) who initiates self-registration and, once identified, becomes the applicant on the new Application (EN0001).
- **Admin** — back-office staff who, from an already-existing Application (EN0001) and its ApplicationProfile (EN0002), creates or links the User (EN0008)/Contact (EN0006) records for the fundraiser, patron, or child.
- **System** — validates submitted data, resolves reference data (e.g. city lookups), creates/links User, Contact, Application, and ApplicationSession (EN0003) records, and dispatches the activation notification.
- **Integration(Email Validation Service)** — checks that the submitted email address belongs to a valid, existing mail domain before registration proceeds.
- **Integration(Transactional Messaging Service)** — sends the activation/magic-link email to the newly registered Customer.

## Intent

Allow a prospective fundraiser or patron to self-register and start an Application (Žádost), or allow Admin to formalize the fundraiser/patron/child identity on an existing Application — in both cases producing a linked User/Contact and an Application ready to be filled in.

## Preconditions

- The visitor is anonymous (self-registration sub-flow) — an already-authenticated Customer is routed directly into the Application without repeating identity capture.
- For the Admin-initiated sub-flow, an Application (EN0001) and its associated ApplicationProfile (EN0002) already exist and carry the role-specific data (fundraiser/patron/child) to be promoted into a User/Contact.
- Reference data (e.g. city/geo values) is available for lookup or on-demand creation.

## Main Flow

### UC0001.1 — Customer self-registration (fundraiser or patron)

1. Customer: opens the registration entry point, selecting the fundraiser or patron role.
2. System: presents a minimal registration form (email, phone, and country-specific consent/regulatory checkboxes).
3. Customer: submits email, phone, and required consents.
4. System: validates the email format and required consents.
5. Integration(Email Validation Service): confirms the email's mail domain is valid and reachable.
6. System: looks up whether a User (EN0008) already exists for the submitted email.
7. System: creates a new User (EN0008) with the selected role and a linked Contact (EN0006) when no existing User is found.
8. System: creates a new Application (EN0001) in its initial status, recording the lead role, lead source, and the lead Contact (EN0006).
9. System: creates two ApplicationSession (EN0003) records for the new Application — one for the patron role and one for the fundraiser role — each with an access interface appropriate to whether that role is the registering Customer or an invited counterpart.
10. System: records the initial status of the Application (EN0001) in the status history.
11. Integration(Transactional Messaging Service): sends an activation (magic-link) email to the Customer, directing a new Customer to continue the Application form or an existing Customer to their account.
12. System: presents a confirmation/result page to the Customer.

### UC0001.2 — Admin promotes Application profile data to User/Contact

1. Admin: opens the "create user" action on an existing Application (EN0001) for a given role (fundraiser, patron, or child).
2. System: loads the Application (EN0001) and its ApplicationProfile (EN0002) for the requested role.
3. System: verifies the Application, ApplicationProfile, and role are all present and the role is one of the supported values; otherwise the action is rejected with no changes.
4. System: reads the role-specific personal data (name, contact details, address, and — for a child — birth identifier) from the ApplicationProfile (EN0002).
5. System: looks up whether a User (EN0008) (fundraiser/patron) or a Contact (EN0006) (child, matched by birth identifier) already exists.
6. System: creates a new Contact (EN0006) for the role when none exists, using the profile data.
7. System: resolves the submitted city value against reference data, creating a new reference entry when the value is not yet known (Reference-Data lookup).
8. System: creates a new User (EN0008) with the requested role and the linked Contact (EN0006), for the fundraiser/patron branch, when no existing User was found.
9. System: links the resulting User (EN0008) (fundraiser/patron) or Contact (EN0006) (child) back onto the Application (EN0001).
10. Admin: is returned to the Application (EN0001) detail view.

## Alternative Flows

### AF1 — Returning Customer completes registration while already authenticated

1. Customer: opens the registration entry point while already authenticated.
2. System: detects the Customer is already authenticated and creates the Application (EN0001) directly for that Customer's role, bypassing the identity-capture steps.

Outcome: An Application (EN0001) is created for the already-known Customer without a new User/Contact being created.

### AF2 — Existing email re-submits self-registration

1. Customer: submits the self-registration form using an email already associated with a User (EN0008).
2. System: adds the requested role and/or a missing Contact (EN0006) to the existing User (EN0008) instead of creating a new one.
3. System: does not create a new Application (EN0001) for this submission.
4. Integration(Transactional Messaging Service): re-sends an activation/account email to the Customer.

Outcome: No duplicate Application (EN0001) is created; the existing User (EN0008) is topped up with role/Contact as needed, and a notification is still sent on every submission.

### AF3 — Email domain validation fails

1. Integration(Email Validation Service): reports that the submitted email's domain cannot be validated or the check fails.
2. System: does not proceed with registration.

Outcome: Registration is blocked. Evidence Level: Partial — the dossier notes this dependency can block a legitimate signup and is not confirmed to degrade gracefully.

### AF4 — Admin action fails partway (Admin-initiated sub-flow)

1. System: fails to create or validate the User (EN0008) during the Admin-initiated sub-flow (e.g. validation violation).
2. System: does not link the partially-created Contact (EN0006) back onto the Application (EN0001).

Outcome: A Contact (EN0006) may exist without being linked to the Application (EN0001) or to a User (EN0008) — an orphaned-record state. Evidence Level: Partial — recorded in the dossier as a data-integrity risk, not a designed compensating flow.

## Postconditions

- A User (EN0008) with the fundraiser or patron role exists, linked to a Contact (EN0006) (self-registration sub-flow), or is reused if already present.
- For a brand-new self-registering Customer, an Application (EN0001) exists in its initial status with two ApplicationSession (EN0003) records (patron and fundraiser) and one status-history entry.
- In the Admin-initiated sub-flow, the Application (EN0001) has its fundraiser/patron (User, EN0008) or child (Contact, EN0006) reference set; a new reference-data (city) entry may have been created.
- An activation notification has been dispatched to the Customer in the self-registration sub-flow.

## Traceability

Target SRVs:
- Application-Lifecycle
- Identity-&-Access
- Reference-Data

EN entities:
- EN0001 Application — the Application (Žádost) created or updated by this UC.
- EN0002 ApplicationProfile — source of role-specific data read by the Admin-initiated sub-flow (UC0001.2).
- EN0003 ApplicationSession — access/interface control records created for a new Application in the self-registration sub-flow.
- EN0006 Contact — the party record created/linked for fundraiser, patron, or child.
- EN0008 User — the account created/linked for fundraiser or patron.

Integration boundaries:
- Email Validation Service (domain/mail-exchange check during self-registration)
- Transactional Messaging Service (activation/magic-link email)

Flow Evidence:
- FLW0010 (Fundraiser/Patron self-registration)
- FLW0026 (Create user from application — Admin-initiated)

## Evidence Level

Confirmed — grounded in FLW0010 and FLW0026 (both Confirmed-confidence dossiers) and EN0001/EN0002/EN0003/EN0006/EN0008, with Partial evidence called out inline for the email-validation failure mode (AF3) and the Admin-initiated partial-write risk (AF4); traced to Application-Lifecycle, Identity-&-Access, and Reference-Data per UC-candidates.md and UC-srv-traceability.md.
