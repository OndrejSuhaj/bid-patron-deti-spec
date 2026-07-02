---
doc_id: EN0019
title: Supplier
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0002  # ApplicationProfile — gift_supplier references Supplier
---

# EN0019 — Supplier

## Purpose

Gift supplier / vendor registry. Represents a company from which the gift/donation item requested on
an Application is (or would be) purchased. Supplier is back-office reference data with a light
lifecycle, read by the fundraiser profile (EN0002) and by reporting/export flows.

---

## Lifecycle

Published
Unpublished

No further domain status vocabulary exists for Supplier beyond a publish/unpublish state.

---

## State Transitions

Hypothesis — Not evidenced in current sources. No creation, edit, or publish/unpublish flow is
mined for Supplier; only its data shape and its use as a read-side reference (from EN0002, and in
reporting exports) are confirmed. Missing evidence: the use case that creates or maintains Supplier
records.

---

## Attributes

### System-managed attributes

- status (boolean; required; published / unpublished; defaults to published)
- created (timestamp; system-managed)
- changed (timestamp; system-managed)
- owner (reference to EN0008 – User; optional)

### User-provided attributes

- name (text; required; supplier's display name)
- company identifier (text; optional; registered company ID)
- data-box identifier (text; optional; official electronic-delivery box ID)
- street (text; optional)
- city (reference to a city reference-data term; optional)
- postal code (text; optional)

---

## Invariants

- A Supplier without an active domain status enum is governed only by the published/unpublished
  state; no additional lifecycle rule is evidenced.
- Conflict/Uncertain — a related mapping between Supplier and help-area category (with an e-shop URL)
  exists as a separate structure with no confirmed uniqueness constraint per Supplier–category pair;
  whether duplicate mappings are intended is unresolved.

---

## Relationships

- EN0002 – ApplicationProfile (gift_supplier: the fundraiser profile optionally references the
  Supplier expected to fulfil the requested gift)
- EN0008 – User (owner of the Supplier record)

---

## Open Questions

1. Who creates/maintains Supplier records (administrative use case vs. automatic creation)? No
   creation or edit flow is evidenced.
2. Is a duplicate Supplier–category mapping expected, or should the pairing be unique? Not evidenced.
3. The city reference on Supplier is created ad hoc from free text — is uncontrolled growth of the
   city reference-data vocabulary intended? Not evidenced.
