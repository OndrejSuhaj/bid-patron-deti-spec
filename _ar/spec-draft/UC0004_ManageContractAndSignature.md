# UC0004 — Manage Contract & Signature

## Header

| Field | Value |
|---|---|
| UC ID | UC0004 |
| Name | Manage Contract & Signature |
| Bounded Context | C6 |
| Primary Actor(s) | Admin, Customer, System |
| Trigger Type | UI |

## Actors & Responsibilities

- **Admin** (coordinator / back-office staff): initiates Contract (EN0011) generation on an Application (EN0001), reviews it, and forwards it for manager sign-off.
- **Admin** (acting as manager/checker): reviews the generated Contract and applies the manager signature stamp before hand-off to the fundraiser.
- **Customer** (fundraiser/applicant): performs the final e-signature step on the Contract in the self-service zone, confirming their identity by typed name match.
- **System**: renders the Contract document to PDF, applies token substitution from a ContractTemplate (EN0012), advances the Application status in lock-step with the signing progress, builds/tears down the fundraiser signing session, and triggers outbound notifications.

## Intent

Generate a legally-binding Contract document for an Application from a reusable template, carry it through an internal manager check/signature, and obtain the fundraiser's e-signature — advancing the Application status at each step and notifying the responsible parties.

## Preconditions

- The Application (EN0001) has a fundraiser assigned, an ApplicationProfile (EN0002) with the fundraiser profile completed, a contract type chosen, and (unless the country-specific rule to skip patron assignment applies) a patron and coordinator assigned. Missing child assignment is warned but not blocking.
- A ContractTemplate (EN0012) exists for the selected contract type.
- Admin holds the permissions to create a Contract, to send it to the manager, and to send it to the fundraiser, respectively (distinct permissions per step).
- For the Customer sign step: the Application is in a status that allows fundraiser signing, and the acting Customer is the fundraiser on record for that Application.
- Evidence: FLW0008 (Confirmed).

## Main Flow

### UC0004.1 — Contract creation and PDF rendering

1. Admin: Open the Contract tab on the Application (EN0001) and select the contract type to generate.
2. System: Verify the creation preconditions (fundraiser profile filled, contract type chosen, patron/coordinator assigned per country rule) and warn if the child is not yet linked, without blocking creation.
3. System: Create a new Contract (EN0011), assign it a per-country human-readable contract number and a sequential per-year counter.
4. System: Load the matching ContractTemplate (EN0012) for the chosen contract type and substitute Application/ApplicationProfile data (fundraiser, patron, child, gift details) into the template body to produce the Contract's document content.
5. System: Render the Contract's document content to a PDF file and attach it to the Contract.
6. System: Link the created Contract to the Application's contract reference (or, for certain contract types, to the appendix reference).
7. System: If the contract type is a rental contract, additionally generate a related rental agreement document and pre-apply the manager signature to it.

Evidence: FLW0008 (Confirmed).

### UC0004.2 — Manager check and signature

1. Admin: Trigger "send contract to manager" from the Application's Contract tab.
2. System: Send a notification to the configured contract-checking recipient with a link to review and forward the Contract, and record an activity log entry on the Application.
3. System: Advance the Application status to reflect that the Contract is under manager review.
4. Admin: Trigger "send contract to fundraiser" once the manager check is complete.
5. System: If digital signature is enabled for the tenant, stamp the manager's signature image and the current date into the Contract's document content and re-render it; record an activity log entry.
6. System: Advance the Application status to indicate the Contract is awaiting the fundraiser's signature.
7. System: (Legacy path, when digital signature is not enabled) Send the rendered Contract PDF to the fundraiser by notification instead of stamping a manager signature, then advance the Application status to await the fundraiser's signature.

Evidence: FLW0008 (Confirmed).

### UC0004.3 — Fundraiser e-signature

1. System: On the Application entering the "awaiting fundraiser signature" status, and if digital signature is enabled, deactivate any prior fundraiser signing sessions, create an acceptance-protocol Contract, and open a new signing session carrying the Contract content and PDF for in-zone review.
2. Customer: Open the Contract signing screen in the self-service zone and review the Contract content.
3. Customer: Type their full name to confirm identity and submit the signature.
4. System: Validate that the typed name matches the fundraiser's registered full name.
5. System: Advance the Application status to signed and record the e-signature data on the Contract.
6. System: Generate a signature-confirmation PDF (containing a verification code/QR) for the signed Contract.
7. System: Present the fundraiser with the signature confirmation and return them to their applications overview.

Evidence: FLW0008 (Confirmed).

## Alternative Flows

### AF1 — Legacy (non-digital) signature hand-off

1. System: With digital signature disabled for the tenant, skip the in-zone manager stamp and signing-session build.
2. System: Send the rendered Contract PDF to the fundraiser by notification, outside the self-service zone.
3. System: Advance the Application status to await the fundraiser's signature, without an in-zone review session.

Outcome: The fundraiser receives the Contract only by notification; the in-zone signing-session sub-flow (UC0004.3 step 1) does not run for this Application.

### AF2 — Notification recipient missing

1. System: Attempt to send the manager-check notification but find the checking recipient or the rendered PDF unavailable.
2. System: Skip sending the notification while still advancing the Application status to the manager-check step.

Outcome: The Application shows the Contract as under manager review with no notification having been sent — a silent gap requiring manual follow-up.

### AF3 — Signature name mismatch

1. Customer: Submit the signing form with a typed name that does not match the fundraiser's registered full name.
2. System: Reject the submission and keep the Application in the awaiting-signature status.

Outcome: No signature is recorded; the Customer must resubmit with the correct name.

### AF4 — Country without in-zone contract creation

1. Admin: Attempt to open the Contract creation screen for an Application in a tenant/country where in-zone contract creation is not offered.
2. System: Do not present a Contract creation form for that country.

Outcome: Contract creation for this tenant proceeds outside this UI path (evidence does not confirm an alternative). Partial evidence — country-gating is confirmed, the alternative path is not mined.

## Postconditions

- A Contract (EN0011) exists, linked to the Application (EN0001), carrying a rendered PDF, a contract number, and (once fully signed) an e-signature record and a signature-confirmation PDF.
- The Application's status reflects the furthest signing step reached: contract created → under manager review → awaiting fundraiser signature → signed.
- Activity-log and status-history entries are recorded on the Application for each transition.
- For digitally-signed contracts, an acceptance-protocol Contract and the fundraiser signing session exist as supporting records.
- Notifications have been sent to the manager (and, on the legacy path, to the fundraiser) where a valid recipient and document were available.

## Traceability

Target SRVs:
- Document-Generation-&-Fulfilment
- Application-Status-Orchestrator
- Transactional-Messaging-Orchestrator

EN entities:
- EN0011 Contract — the generated, signed document at the center of this UC
- EN0012 ContractTemplate — source template rendered into the Contract's content
- EN0001 Application — aggregate whose status is advanced at each contract/signature milestone
- EN0002 ApplicationProfile — source of fundraiser/patron/gift data substituted into the Contract

Integration boundaries:
- None (document rendering and notification dispatch are internal system responsibilities; no external system is invoked in this UC per current evidence).

Flow Evidence:
- FLW0008 (Contract create → manager check → fundraiser sign)

## Evidence Level

Confirmed — grounded in flow dossier FLW0008 (Confirmed confidence) mapping directly to SRV0011 (Document-Generation-&-Fulfilment), the Application-Status-Orchestrator status transitions, and Transactional-Messaging-Orchestrator notifications; entities EN0011 (Contract), EN0012 (ContractTemplate), EN0001 (Application), and EN0002 (ApplicationProfile) corroborate the fields and lifecycle described. AF4 (country gating) is evidenced only for the exclusion, not for an alternative path, and is marked Partial within an otherwise Confirmed UC.
