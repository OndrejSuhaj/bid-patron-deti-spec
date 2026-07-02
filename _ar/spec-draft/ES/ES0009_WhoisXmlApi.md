---
doc_id: ES0009
title: WhoisXML API
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0019
  - UC0012
---

# ES0009 – WhoisXML API

## Purpose

WhoisXML API is integrated to check the validity/availability of a domain name encountered on the
messaging path, giving the platform a way to flag a suspect or non-existent recipient domain before
or during transactional-message dispatch. It is one of the outbound service targets named in the
Integration Landscape (`ARCH0001` §5, row 10).

---

## System Overview

WhoisXML API is a third-party domain-intelligence service: given a domain name, it reports on that
domain's validity/availability. Patronus consults it as a domain-checking oracle; it holds no
Patronus domain data of its own and plays no role beyond answering that lookup.

---

## Integration Model

Outbound: the platform calls out to WhoisXML API during the messaging/domain-check path associated
with transactional-message dispatch (`FN0019`; `UC0012`), with results cached to reduce repeat calls
for the same domain (`ARCH0001` §5 row 10). `ARCH0002` places this call at the messaging-orchestrator
composition level, synchronous with the request that triggers it.

**Evidence level:** the existence of this outbound boundary is confirmed at the architecture/service-
composition level (`ARCH0001` §5 row 10; `ARCH0002`), but its concrete trigger, step sequence, and
outcome within message dispatch are `Hypothesis — Not evidenced in current sources` — `UC0012`
records no dispatch-flow evidence of a domain-validity check actually firing (see `UC0012` Alternative
Flows / Evidence Level). This ES describes the integration boundary as named; it does not assert the
check is confirmed to execute.

---

## Data Exchange

- **Outbound:** a domain name to be validated.
- **Inbound:** a domain-validity/availability result for that domain.

Conceptual only — no payload or field-level detail is asserted here. Successful lookups are cached on
the Patronus side to avoid repeating the same check (`ARCH0001` §5 row 10); the caching mechanism
itself is not an ES-layer concern.

---

## Constraints

- **Failure impact:** if WhoisXML API is unavailable, the domain-validity check cannot run, leaving a
  validation gap on the messaging/domain-check path; cached results from prior lookups mitigate this
  for previously-seen domains (`ARCH0001` §5 row 10).
- **Boundary role only:** this integration performs a domain-validity lookup only — it does not
  participate in message content, recipient resolution, or delivery, which remain internal to the
  messaging capability (`FN0019`) and its transport integration.
- **Current-state only:** this reflects the integration as evidenced today; no target-state change is
  asserted here.
- **Evidence level:** `Partial` — the boundary is confirmed at the architecture/service-composition
  level, but its role within the messaging use case is unconfirmed (`Hypothesis`) per `UC0012`.
