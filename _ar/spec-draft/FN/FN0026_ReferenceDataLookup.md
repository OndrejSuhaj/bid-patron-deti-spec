---
doc_id: FN0026
title: Reference Data & Geographic Lookup
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0001
  - UC0022
---

# FN0026 – Reference Data & Geographic Lookup

## Purpose

Provide shared reference/lookup data — chiefly the CZ geographic hierarchy (region/district/
municipality/postal code) — consulted incidentally during address capture and publish logic
(UC0001, UC0022). This is a supporting lookup capability with no domain lifecycle of its own.

---

## Responsibilities

The capability is responsible for:

- Resolving geographic reference values (kraj / okres / obec / PSČ) for address capture on an
  Application (UC0001).
- Serving shared reference value-lists consumed incidentally by publish and validation logic
  (UC0022).

---

## Related Use Cases

- UC0001 – Submit Application (Žádost) (address capture, reference-data lookup/creation)
- UC0022 – Run Platform Workflow Engine & Scheduled Publish (incidental reference-data lookup by
  publish logic)

---

## Related Entities

None. The underlying geo tables are treated as reference/config data, not promoted domain entities
(see EN-candidates rejected list, glossary).

---

## Integrations

None. No external system is called by this capability (see ARCH0002_ContextInteractionMap.md).

---

## Constraints

- Supporting lookup only — this capability appears in no standalone flow and owns no domain
  aggregate; the underlying geo tables are treated as reference/config data, not domain entities.
- Kept minimal by design: Reference-Data has no standalone use case of its own; it is documented
  here only so its touches within UC0001 and UC0022 are covered without inventing behavior beyond
  what those use cases evidence.
