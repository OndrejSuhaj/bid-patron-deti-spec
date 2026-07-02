---
doc_id: EN0007
title: Account
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004 (Campaign)
  - EN0008 (User)
---

# EN0007 — Account

## Description
The Account is a patron/fundraiser record owned by a User, whose distinguishing feature is a `model` field holding a serialized PHP-ML classifier used by the (dormant) campaign-recommendation subsystem. It also carries a conditional weighted `campaign_recommendation` reference list of predicted campaigns. In practice the ML/recommendation machinery is dormant, so the entity today functions as a thin owner-scoped record with a `type` (patron/fundraiser) label.

## Entity Category
Persisted  ·  Confidence: Medium

## Origin
- DB artifacts: base_table `account`; not revisionable, not translatable; `account.install` has no hook_schema for `account`.
- Code touchpoints: `account/src/Entity/AccountEntity.php` (owner default via `preCreate`). Note the ML serialize/train logic lives on `PatronUser` (EN0008), which also owns a `model` field — the recommendation subsystem is confirmed **dormant** (FLW0030).
Evidence: `AccountEntity.php`; `account/account.install`

## Core Fields
- type (list_string; optional; `patron` / `fundraiser` (Žadatel))
- name / last_name (string(50); optional; entity label = name; default `''`)
- status (boolean; publish flag; default TRUE)
- campaign_recommendation (custom campaign_entity_reference → EN0004 Campaign; unlimited; **conditional** — only if module `campaign_recommendation` enabled; stores target_id + per-item `weight` ML prediction)

## Technical Fields
- uuid / langcode (framework); created / changed.
- model (string_long; serialized PHP ML classifier `Phpml\Classification\Classifier`) — infrastructure/ML detail; see SRV / dormant-path notes, not domain narrative.

## Relations
Soft entity_reference (no DB FK): user_id → EN0008 User (owner; default current user via preCreate); campaign_recommendation → EN0004 Campaign (conditional, unlimited, weighted; custom field type living in the `campaign_recommendation` module).

## Allowed Statuses
No lifecycle status enum. `type` = patron / fundraiser; `status` is a boolean publish flag.
Evidence: `AccountEntity.php` baseFieldDefinitions

## Lifecycle
No entity-owned status workflow observed.

Hypothesis: created 1:1 (or per-type) for a User, then largely inert; the `model`/`campaign_recommendation` write path is the recommendation subsystem which is **dormant, never executes** (confirmed on multiple grounds, FLW0030). Missing evidence: no live write path exercises Account in the mined flows (FLW0030 is dormant); creation trigger not code-cited.

## Spec Alignment
N/A — No EN spec files found in repository (see EN-candidates.md §Spec Discovery).

## Open Questions
- Is the `Account` entity actually created anywhere today, or is it fully dormant like the recommendation subsystem?
- How does `Account.model` relate to the `PatronUser.model` field — duplicate ML storage?
- Under what conditions was `campaign_recommendation` (the module) ever enabled in production?
