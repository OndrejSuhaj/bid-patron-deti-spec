# UC0012 — Dispatch Transactional Message

## Header

| Field | Value |
|---|---|
| UC ID | UC0012 |
| Name | Dispatch Transactional Message |
| Bounded Context | C8 |
| Primary Actor(s) | System |
| Trigger Type | Internal (called by many) |

## Actors & Responsibilities

- **System** — the messaging orchestrator: validates recipients, resolves the country-specific template, archives every send attempt, applies the environment send-gate, and hands the message to the outbound transport.
- **Integration(Mautic)** — the actual outbound transport for templated transactional messages: upserts a CRM contact for the recipient and delivers the templated message to that contact. (Despite being invoked as a "SmartMailing" capability, no direct SMTP transport is used — Mautic is the transport.)
- **External(WhoisXML)** — optional domain-validity check referenced at the service-composition level; no dispatch-flow evidence found (see Alternative Flows / Evidence Level).

## Intent

Deliver a single templated transactional message to a recipient on behalf of any calling business context (application lifecycle, donations, campaigns, contracts, accounts, GDPR, etc.), while always keeping a durable record of the send attempt regardless of whether the message was actually transmitted.

## Preconditions

- A calling context has decided a transactional message must go out and supplies: recipient address(es), a template name, message parameters/arguments, and optionally a reply-to address and attachments.
- The mailing transport is configured (credentials for the Mautic-backed transport); if not configured, sending later fails but archiving still proceeds.
- The Application (EN0001) this message relates to is expected as part of the call arguments, since the EmailArchive (EN0022) record requires an Application reference.

## Main Flow

### UC0012.1 — Resolve template and validate recipients
1. System: Receive a dispatch request from a calling context with recipient(s), template name, arguments, optional reply-to and attachments.
2. System: Normalize the recipient input into a list of addresses.
3. System: Validate a single-string recipient address for basic email validity; list-form recipients are passed through without this validation.
4. System: Resolve the template name against the template map for the currently configured country (separate maps exist per country).
5. System: If the template name is not found in the resolved country's map, record an error and stop dispatch for that request without sending or archiving.

### UC0012.2 — Archive and send per recipient
1. System: Build the token/placeholder replacement values from the supplied message arguments.
2. System: Split the recipient list into batches for processing.
3. System: For each recipient, create and persist an EmailArchive (EN0022) record capturing subject, resolved to/from addresses, rendered body, template name, serialized arguments, and the linked Application (EN0001) and Campaign, independent of whether the message is actually transmitted.
4. System: Evaluate the send gate — proceed to actual transmission only if the environment is production, or the recipient address matches an internal allow-list; otherwise skip transmission for this recipient while keeping the archive record.
5. Integration(Mautic): Create or update a CRM contact for the recipient's address.
6. Integration(Mautic): Send the resolved template to that contact with the built tokens and any attachments.
7. System: If the CRM contact could not be resolved, record the failure in the messaging log.

## Alternative Flows

### AF1 — Unknown template name
1. System: Look up the template name in the resolved country's template map and find no match.
2. System: Log the failure and stop, without creating an EmailArchive (EN0022) record and without contacting Integration(Mautic).

Outcome: No message sent, no archive written; only a log entry exists for this dispatch attempt.

### AF2 — Non-production / non-allow-listed recipient (suppressed send)
1. System: Complete recipient validation and template resolution as in UC0012.1.
2. System: Archive the EmailArchive (EN0022) record for the recipient as in UC0012.2 step 3.
3. System: Evaluate the send gate and determine the environment is not production and the recipient is not on the allow-list.
4. System: Skip the call to Integration(Mautic) for this recipient.

Outcome: An EmailArchive (EN0022) record exists but no message was actually transmitted; the archive record does not distinguish this suppressed state from a genuinely delivered message.

### AF3 — Domain validity check (unconfirmed)

> Evidence Level for this sub-flow: Hypothesis — Not evidenced in the assigned flow dossier (FLW0019). Named only as a target-service facet (WhoisXML-DomainCheck-Adapter) in the service-composition inventory; no dispatch step, trigger condition, or outcome for a domain-validity check was found in the mined evidence.

1. External(WhoisXML): (Unconfirmed) Validate the domain portion of a recipient or sender address before or during dispatch.

Outcome: Unconfirmed — no evidenced effect on the Main Flow could be established from available dossiers.

## Postconditions

- Exactly one EmailArchive (EN0022) record exists per recipient for each dispatch attempt that passed template resolution, regardless of whether the message was actually transmitted.
- For production or allow-listed recipients, a CRM contact exists (created or updated) at Integration(Mautic) and the templated message has been handed to that transport.
- For suppressed or failed sends, the EmailArchive (EN0022) record persists with no distinguishing marker of delivery outcome — sent/error state is not tracked after creation.
- Dispatch attempts with an unresolvable template name leave no EmailArchive (EN0022) record, only a log entry.

## Traceability

Target SRVs:
- Transactional-Messaging-Orchestrator
- Email-Adapter
- WhoisXML-DomainCheck-Adapter
- Mautic-CRM-Adapter

EN entities:
- EN0022 EmailArchive — the per-recipient, per-dispatch record created in UC0012.2; central data footprint of this UC

Integration boundaries:
- Integration(Mautic) — CRM contact upsert + templated message transmission (transport for all sends in this UC)
- External(WhoisXML) — named at the service-composition level only; no confirmed role in this UC's flow (see AF3)

Flow Evidence:
- FLW0019 (Transactional email dispatch)

## Evidence Level

Confirmed for UC0012.1/.2 and AF1/AF2 — directly grounded in FLW0019 (Confirmed-confidence dossier) and EN0022 (EmailArchive lifecycle and field evidence); SRV mapping matches UC-srv-traceability.md and SRV-target-list.md rows for UC0012. Hypothesis for AF3 (WhoisXML domain check) — the adapter is listed against this UC in SRV-target-list.md but no corresponding step, trigger, or outcome appears in FLW0019 or any other assigned dossier.
