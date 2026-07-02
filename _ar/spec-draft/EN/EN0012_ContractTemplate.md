---
doc_id: EN0012
title: ContractTemplate
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0011  # Contract — instances generated from this template
---

# EN0012 — ContractTemplate

## Description
Reusable HTML template used to generate a `contract` (EN0011) of a given contract type. Editable, revisionable, and translatable so template wording can be maintained and localised. The template `html` is the source rendered (with substitutions) into each generated Contract's body.

## Entity Category
Content · Confidence: Medium

## Origin
- DB artifacts: base_table `contract_template` (content, **revisionable**, **translatable**; revision tables `contract_template_revision`/`_field_revision`; no `hook_schema`).
- Code touchpoints: `ContractTemplateEntity`; consumed during Contract generation (FLW0008, read).
Evidence: [contract/src/Entity/ContractTemplateEntity.php](../../intake/current-solution/_source/patronus/web/modules/custom/contract/src/Entity/ContractTemplateEntity.php); db-models.md `contract_template`.

## Core Fields
- name (string 50; required; entity label)
- html (text_long; template body)
- contract_type (list_string; required; values: good / service / transfer / nno / appendix / delivery_note / acceptance_protocol / rental_contract / rental_agreement / ukraine)

## Technical Fields
- user_id (reference → EN0008 User; owner)
- (revision fields per revisionable convention; no publish field — see Open Questions)

## Relations
- Source for EN0011 (Contract) — logical generation link (Contract does not store a template reference)
- user_id → EN0008 (User; owner)

## Allowed Statuses
None. No status enum and no confirmed publish field.
Evidence: db-models.md `contract_template` — `isPublished()/setPublished()` use a `status` entity_key with **no backing field / no published key declared** (`Uncertain`).

## Lifecycle
No entity-level state machine observed — it is editable/revisionable configuration content. Each edit creates a new revision (revisionable). No promote/publish/retire transition evidenced in mined flows.
Hypothesis: template selection by `contract_type` occurs at Contract creation. Missing evidence — the exact resolution (which template row is picked per type/country/language) was not deep-mined.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Does the declared-but-unbacked `status` publish key actually exist at storage, or is publishing dead code? (db-models `Uncertain`).
2. How is one template chosen per `contract_type` (single active row? most recent? by langcode)?
3. `contract_type` here lists `appendix`/`delivery_note`/`acceptance_protocol` that map to distinct Application reference slots on EN0001 — is the mapping 1:1?
