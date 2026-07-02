# UC0010 — Issue Donation Confirmation (Tax)

## Header

| Field | Value |
|---|---|
| UC ID | UC0010 |
| Name | Issue Donation Confirmation (Tax) |
| Bounded Context | C6 |
| Primary Actor(s) | Customer, System, Integration(Mautic) |
| Trigger Type | UI/API |

## Actors & Responsibilities

- **Customer** — requests a tax-deductible donation confirmation for a past year, either as a logged-in donor or as an anonymous caller supplying identifying details and an email address.
- **System** — validates the request, computes the donor's paid-donation total for the requested year, persists a DonationConfirmation (EN0014) snapshot, renders it as a PDF, and dispatches it by email while archiving the send.
- **Admin** — not directly involved in the confirmation-issuance path itself; retains back-office visibility into issued confirmations and archived emails (no dedicated admin action observed in this flow's evidence).
- **Integration(Mautic)** — transports the confirmation email and upserts the recipient as a marketing contact as a side effect of sending.

## Intent

Allow a donor (or someone requesting on a donor's behalf by email) to obtain an official tax donation confirmation document for a given year, computed from their actual paid donations, delivered by email as a PDF.

## Preconditions

- A User (EN0008) can be resolved for the request — either the currently logged-in User, or a User matched by the submitted email address (anonymous path).
- The submitted email address is syntactically valid (web form path only).
- For the API path, either a campaign identifier or a confirmation year is present in the request.
- The aggregate total of the resolved User's paid Transactions (EN0009) for the requested year (optionally scoped to a campaign) is greater than zero; otherwise the request is not fulfilled.

## Main Flow

### UC0010.1 — Request and validate a donation confirmation (CZ)
1. Customer: Submit a donation confirmation request via the public web form, providing requester type (individual or organization), identifying details, and the target year.
2. System: Validate the type-specific identifying fields (individual: first/last name and birth number; organization: name and registration number) and the requested year.
3. System: Resolve the target User (EN0008) — by the submitted email for an anonymous request, or as the currently logged-in User.
4. System: Compute the User's total paid donation amount and most recent donation date for the requested year (optionally scoped to a campaign), based on paid Transactions (EN0009).
5. System: Abort the request without issuing a confirmation if the computed donation total is zero.

### UC0010.2 — Generate and issue the confirmation document (CZ)
1. System: Create and persist a DonationConfirmation (EN0014) snapshot capturing the requester's name, address, identifying number, computed donation total, the amount in words, and the confirmation year.
2. System: Render the confirmation snapshot into a PDF tax-confirmation document using the CZ confirmation template.
3. Integration(Mautic): Deliver the rendered confirmation PDF as an email attachment to the requester's address.
4. System: Persist an EmailArchive (EN0022) record of the dispatched email regardless of delivery outcome.

### UC0010.3 — Request via API (SPA channel)
1. Customer: Submit a donation confirmation request through the API channel, providing a campaign identifier or a confirmation year, and identifying details.
2. System: Resolve the target User (EN0008) from the authenticated session, or from an identifier supplied in the request.
3. System: Perform the same total computation, confirmation persistence, PDF generation, and email dispatch as UC0010.1–UC0010.2.

## Alternative Flows

### AF1 — No donation total for the requested year
1. System: Compute a zero total for the resolved User and requested year.
2. System: Do not create a DonationConfirmation (EN0014) record and do not send an email.

Outcome: No confirmation is issued; the Customer receives no document for a year with no qualifying paid donations.

### AF2 — Confirmation persisted but document dispatch fails
1. System: Persist the DonationConfirmation (EN0014) snapshot before attempting document rendering and dispatch.
2. System: Encounter a failure while rendering or transmitting the PDF (for example an unreachable embedded signature image).

Outcome: A DonationConfirmation (EN0014) record exists with no corresponding email having been sent — a partial, silently incomplete outcome from the Customer's perspective.

### AF3 — Repeated requests for the same donor/year
1. Customer: Submit the same donation confirmation request (same donor, same year) more than once.
2. System: Process each request independently, issuing a separate DonationConfirmation (EN0014) and a separate email each time.

Outcome: Multiple confirmation documents and emails are issued for the same donor/year; there is no deduplication or idempotency safeguard.

### AF4 — RO tax-redirect declaration (adjacent country variant) — Partial evidence
1. Customer: Submit a tax-redirect ("2%") declaration through a separate RO-specific form, rather than the CZ confirmation request.
2. System: Create a Contract record and a TaxPayer declaration record from the submitted data.
3. System: Append the submitted declaration data to a consolidated export file used for later filing.

Outcome: A signed tax-redirect declaration and TaxPayer record exist; no DonationConfirmation (EN0014) PDF is generated and no paid-Transaction total is read — this is a distinct mechanism from the CZ confirmation-document path above, not a localized variant of it. Marked **Partial** — this sub-flow is evidenced only as an adjacent flow reference in the FLW0009 dossier and has not been separately mined; entities Contract and TaxPayer are intentionally excluded from this UC's main Traceability and noted here only.

## Postconditions

- A DonationConfirmation (EN0014) record exists as an immutable snapshot of the requester's identifying data and computed donation total for the year, whenever the donation total was greater than zero.
- A PDF tax-confirmation document has been generated from that snapshot, when document rendering succeeded.
- An EmailArchive (EN0022) record exists for the dispatch attempt, independent of whether the underlying transport actually delivered the message.
- No change is made to any Transaction (EN0009) record as part of this use case; Transactions are read-only inputs to the total computation.

## Traceability

Target SRVs:
- Document-Generation-&-Fulfilment
- Payment-Processing
- Transactional-Messaging-Orchestrator

EN entities:
- EN0014 DonationConfirmation — the issued snapshot/document record this UC produces
- EN0008 User — the resolved donor/requester whose donations are confirmed
- EN0009 Transaction — read-only source of the paid-donation total for the year
- EN0022 EmailArchive — archive record of the confirmation email dispatch

Integration boundaries:
- Mautic (email transport and marketing-contact upsert on send)

Flow Evidence:
- FLW0009 (donation confirmation tax document — CZ web form + API/SPA paths; RO tax-redirect adjacency noted as Partial/un-mined within the same dossier)

## Evidence Level

Confirmed — the CZ confirmation-request, total-computation, snapshot-persistence, PDF-generation, and email-archival behavior is traced end-to-end in FLW0009 against SRV Document-Generation-&-Fulfilment, Payment-Processing (donation-total read), and Transactional-Messaging-Orchestrator, and grounded in EN0014/EN0008/EN0009/EN0022, including the AF2 partial-dispatch and AF3 duplicate-issuance modes, both confirmed in FLW0009; the RO tax-redirect sub-flow (AF4) is marked Partial as an adjacent, separately-tracked mechanism per the dossier's own scope note.
