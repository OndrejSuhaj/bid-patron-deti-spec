---
doc_id: FN0001
title: Application Intake & Case Management
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0001
  - UC0016
  - UC0019
  - EN0001
  - EN0002
  - EN0003
  - EN0006
  - EN0008
---

# FN0001 – Application Intake & Case Management

## Purpose

Create and maintain the case record (Application / Žádost, EN0001) that spans the lead-intake phase and
the full application phase on one record, together with its questionnaire profiles and role-scoped
access sessions. This is the capability that lets a fundraiser's or patron's case come into existence,
be progressively filled in, and remain the single canonical subject that every other case-facing
capability (status orchestration, scoring, campaign, party merge) reads and mutates.

## Responsibilities

- Create an Application (EN0001) from a public or back-office submission and provision the owning party
  (User + Contact) as part of intake.
- Capture and progressively fill the fundraiser/patron/child/gift questionnaire profiles
  (ApplicationProfile, EN0002), bound at most two per case.
- Establish and tear down role-scoped access sessions (ApplicationSession, EN0003) that gate which party
  may act on the case at each phase.
- Accept externally-imported artifacts (e.g. invoices) that attach to a case and trigger its status
  reactions.
- Serve the case record as the single canonical subject that the status spine, scoring, campaign, and
  party-merge capabilities all read and mutate.

## Related Use Cases

UC0001 – Submit Application (Žádost); UC0019 – Import Invoices from OneDrive (attach path); UC0016 –
Maintain Party Records (Dedup / Merge) (the Application is the merge subject, not this capability's own
responsibility).

## Related Entities

EN0001 – Application; EN0002 – ApplicationProfile; EN0003 – ApplicationSession; EN0006 – Contact;
EN0008 – User.

## Integrations

None. Intake itself calls no external system.

## Constraints

- Relations are soft references only (no database foreign keys, no enforced party-identity uniqueness),
  which is the reason duplicate cases accumulate.
- Lead-era and application-era statuses share one state field (~66 states on a single field); Lead is a
  phase of the same case, not a separate record.
