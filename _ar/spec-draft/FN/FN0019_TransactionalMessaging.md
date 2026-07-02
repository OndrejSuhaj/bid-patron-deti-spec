---
doc_id: FN0019
title: Transactional Messaging & Templating
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0012
  - UC0002
  - UC0004
  - UC0006
  - UC0010
  - UC0011
  - UC0015
  - EN0022
  - EN0001
---

# FN0019 – Transactional Messaging & Templating

## Purpose

Deliver a single templated transactional message to a recipient on behalf of any calling business
context, resolving the country-specific template, applying an environment send-gate, handing the
message to the outbound transport, and always archiving the send attempt regardless of transmission
outcome.

## Responsibilities

- Normalize and validate recipient input and resolve a template name against the per-country
  template map, stopping dispatch with a logged error when the template name is unknown.
- Build token/placeholder values from the supplied message arguments and create an EmailArchive
  (EN0022) record per recipient — capturing subject, resolved to/from addresses, rendered body,
  template name, serialized arguments, and the linked Application (EN0001) and Campaign — regardless
  of whether the message is actually transmitted.
- Apply an environment send-gate (transmit only in production, or to recipients on an internal
  allow-list) and hand the resolved message, tokens, and any attachments to the outbound transport.
- Reference an optional email-domain validity check at the message-composition level (see
  Constraints — unconfirmed dispatch role).

## Related Use Cases

UC0012 – Dispatch Transactional Message

UC0002 – Orchestrate Application Status Change

UC0004 – Manage Contract And Signature

UC0006 – Confirm Payment

UC0010 – Issue Donation Confirmation

UC0011 – Manage Campaign/Story Lifecycle

UC0015 – Anonymize Personal Data

## Related Entities

EN0022 – EmailArchive

EN0001 – Application

## Integrations

Mautic — the actual outbound transport for every templated transactional message (named in ARCH0002
Context Interaction Map as the external target of transactional send; also the CRM-sync target
described by FN0015). Despite the calling capability being named "SmartMailing", no direct SMTP
transport exists — all sends are handed to Mautic.

WhoisXML — named in ARCH0002 (Context Interaction Map) as an external email-domain validation target
at the messaging-orchestrator composition level; no confirmed dispatch-flow role (see Constraints).

## Constraints

- The mailing queue is dead (queueing is disabled in the current configuration), so every dispatch is
  synchronous within the caller's request/save — a slow or failing transport call can block or abort
  the enclosing persistence operation.
- The archive never records delivered vs. suppressed vs. failed outcomes after creation: the
  send-status fields exist on EmailArchive (EN0022) but are never written, so a suppressed
  (non-production, non-allow-listed) send is indistinguishable from a genuinely delivered one.
- No direct SMTP transport exists despite the capability's "SmartMailing" naming — Mautic is the sole
  transport, reached synchronously per recipient.
- The WhoisXML domain-validity facet is named at the integration-landscape level but has no evidenced
  dispatch step, trigger, or outcome in the mined flow evidence — its role in this capability is
  `Hypothesis — Not evidenced in current sources.`
- An unresolvable template name aborts dispatch before archiving: no EmailArchive (EN0022) record is
  created for that attempt, only a log entry.
