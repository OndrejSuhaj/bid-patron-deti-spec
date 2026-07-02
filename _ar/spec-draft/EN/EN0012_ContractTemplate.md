---
doc_id: EN0012
title: ContractTemplate
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0011  # Contract — instances generated from this template
  - BR-ContractAndESignature  # governs Contract generation from a ContractTemplate
  - UC0004  # Manage Contract & Signature — consumes the template at Contract creation
---

# EN0012 — ContractTemplate

## Purpose

A reusable, editable document template used to generate a Contract (EN0011) of a given contract
type. The template body is the wording source that, with data substitution, becomes a generated
Contract's document content.

---

## Lifecycle

Editable content — no entity-level state machine is evidenced. Each edit produces a new revision of
the same template; content stays translatable across languages.

No publish/retire state is confirmed — see Open Questions.

---

## State Transitions

None evidenced. The template is maintained as standing content and consumed, not advanced through
states, at Contract creation.

- Consumption trigger: UC0004 (Manage Contract & Signature) — the template for the selected contract
  type is applied at Contract creation; see UC0004 for the substitution flow.

---

## Attributes

### System-managed attributes

- owner (reference to EN0008 – User; the template's owning/maintaining user)

### User-provided attributes

- name (string; required; template label)
- html (text; required; template body — wording substituted with Application/ApplicationProfile data
  at Contract generation)
- contract_type (enumerated; required; values: good / service / transfer / nno / appendix /
  delivery_note / acceptance_protocol / rental_contract / rental_agreement / ukraine)

---

## Invariants

- A ContractTemplate for the selected contract type must exist as a precondition for Contract
  creation; ContractTemplate consumption at Contract generation is governed by
  BR-ContractAndESignature (see UC0004).
- No confirmed uniqueness or single-active-template constraint per contract_type — see Open
  Questions.

---

## Relationships

- EN0011 – Contract: a ContractTemplate is the wording source for Contracts generated from it (a
  Contract does not retain a persistent reference back to the template it was generated from).
- EN0008 – User: owning/maintaining user.

---

## Open Questions

1. Is there a confirmed publish/active state for a ContractTemplate, or is a template always usable
   once created? (Uncertain — no confirmed status vocabulary observed.)
2. How is a single ContractTemplate selected when more than one row exists for the same
   contract_type (single active row? most recent? by language)? Missing evidence.
3. contract_type values include appendix / delivery_note / acceptance_protocol, which correspond to
   distinct reference slots on EN0001 (Application) — whether this mapping is strictly 1:1 is
   unconfirmed.
