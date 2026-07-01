---
doc_id: ENxxxx
title: <Entity Name>
canonical_layer: EN
spec_type: entity
status: draft | canonical
references:
  # referenced doc_ids (must resolve in their layer registry):
  # - BRxxxx (rules constraining this entity), ENxxxx (related entities)
---

# ENxxxx – <Entity Name>

## Purpose

Detailed explanation of the entity and its role in the domain.

---

## Lifecycle

Draft  
Active  
Archived

---

## State Transitions

Draft → Active  
trigger: UCxxxx – Activate entity

Active → Archived  
trigger: UCxxxx – Archive entity

---

## Attributes

### System-managed attributes

- <Field Name> (<Type>; required|optional|conditional; description)
- <Field Name> (<Type>; required|optional|conditional; values: ...)
- <Field Name> (<Type>; required|optional|conditional; reference to ENxxxx – ...)

---

### User-provided attributes

- <Field Name> (<Type>; required|optional|conditional; description)
- <Field Name> (<Type>; required|optional|conditional; values: ...)
- <Field Name> (<Type>; required|optional|conditional; reference to ENxxxx – ...)

---

## Invariants

- Entity must always have a valid lifecycle state.

---

## Relationships

- ENxxxx – Related Entity