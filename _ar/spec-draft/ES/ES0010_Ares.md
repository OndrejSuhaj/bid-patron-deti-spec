---
doc_id: ES0010
title: ARES
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0005
  - UC0003
---

# ES0010 – ARES

## Purpose

ARES is integrated to look up Czech business-registry data for a given company identifier during
risk scoring, so that the manual scoring flow can corroborate organisation/employer details declared
on an Application. It is one of the outbound service targets named in the Integration Landscape
(`ARCH0001` §5, row 11).

---

## System Overview

ARES is the Czech public business registry — a government-operated lookup service that returns
company registration data for a given business identifier (company number). Patronus consults it as
a registry oracle; it holds no Patronus domain data of its own and plays no role beyond answering
that lookup.

---

## Integration Model

Outbound: the platform calls out to ARES synchronously from the scoring flow, triggered by an
AJAX-initiated lookup on the scoring screen (`FN0005`; `UC0003`), separate from the scoring form's own
submit processing. `ARCH0002` places this call at the Scoring-&-Risk context, synchronous with the
request that triggers it (§(a) Synchronous calls).

This boundary is scoped to CZ only — there is no equivalent RO/MD registry lookup evidenced
(`ARCH0001` §5 row 11).

---

## Data Exchange

- **Outbound:** a business identifier (company number) to look up.
- **Inbound:** a business-registry record for that entity.

Conceptual only — no payload or field-level detail is asserted here; the organisation/applicant data
this enriches or verifies is owned by `EN0006` (Contact) and `EN0018` (Organisation).

---

## Constraints

- **Failure impact:** the call carries no timeout, so a hanging registry response can stall the
  enclosing scoring request (`ARCH0001` §5 row 11).
- **CZ-scoped only:** no RO/MD equivalent exists for this registry lookup.
- **Boundary role only:** this integration performs a business-registry lookup only — it clusters
  with the CZ invalid-document/identity check (MVČR) under the same capability (`FN0005`) but is a
  distinct external boundary from it.
- **Current-state only:** this reflects the integration as evidenced today; no target-state change is
  asserted here.
