---
doc_id: EN0005
title: Patron
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004 (Campaign)
  - EN0008 (User)
---

# EN0005 — Patron

## Description
The Patron entity is the public-facing patron profile attached to a Campaign (Story) — the display record of the donor/patron as shown on the story page (name, surname, photo). It is distinct from the User (EN0008) that holds the patron *role* and from the Contact (EN0006) that holds patron *contact* details; this entity exists to present the patron publicly on a campaign. A Campaign references it via `patron_profile` (inline entity form).

## Entity Category
Persisted  ·  Confidence: Medium

## Origin
- DB artifacts: base_table `patron`; not revisionable, not translatable; source = base fields (no hook_schema in the campaign module).
- Code touchpoints: `campaign/src/Entity/PatronEntity.php`; created/edited inline from the Campaign form (`CampaignEntity.patron_profile` inline_entity_form).
Evidence: `PatronEntity.php`

## Core Fields
- name (string(50); **required**; labelled "Příjmení"; entity label)
- first_name (string(50); **required**; "Jméno")
- second_name (string(50); **required**; labelled "Příjmení" — duplicate label, hidden; legacy/redundant)
- photo (image → file; optional; public scheme; image_widget_crop)
- status (boolean; publish flag via publishedBaseFieldDefinitions())

## Technical Fields
- uuid / langcode (framework); created / changed.

## Relations
Soft entity_reference (no DB FK): user_id → EN0008 User (author); photo → file. Inbound: EN0004 Campaign references this via `patron_profile`.

## Allowed Statuses
No status enum. `status` is a boolean publish flag.
Evidence: `PatronEntity.php` publishedBaseFieldDefinitions

## Lifecycle
No entity-owned status workflow observed. Read-only usage in the campaign display flow.

Hypothesis: created/edited via the inline entity form when a Campaign is created or edited; no independent lifecycle. Missing evidence: no flow dossier traces a Patron-specific state change (only read in FLW0021); creation trigger inferred from inline_entity_form config, not code-cited save path.

## Spec Alignment
N/A — No EN spec files found in repository (see EN-candidates.md §Spec Discovery).

## Open Questions
- Why do `name` and `second_name` both carry the "Příjmení" label — is `second_name` dead?
- Is a Patron ever reused across multiple Campaigns, or always 1:1 with its Campaign?
- How does this public Patron relate to the patron User and patron Contact — is data duplicated?
