---
doc_id: EN0016
title: Blacklist
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application (Žádost) — the linked application (required)
  - EN0006  # Contact — the party a list entry classifies (via blacklist_type)
---

# EN0016 — Blacklist

## Description
Risk black/white-list entry linked to an Application (EN0001). Records a classification (white-list tiers `ZD`/`Z`/`N` or full `Black List`) against a specific person role (fundraiser / patron / gift / spotter), with denormalised identity fields (name, birth number, company/IČO, mail, phone) used for matching. Written by the scoring workflow; the resulting classification is also propagated onto the matching Contact's `blacklist_type` field (EN0006).

## Entity Category
Persisted · Confidence: High

## Origin
- DB artifacts: base_table `blacklist` (content, not revisionable, not translatable; no `hook_schema`).
- Code touchpoints: `BlacklistEntity`; written from scoring — `ScoringForm`, `ScoringService::setBlacklistType` (also raw-UPDATEs `contact.blacklist_type`).
Evidence: [blacklist/src/Entity/BlacklistEntity.php](../../intake/current-solution/_source/patronus/web/modules/custom/blacklist/src/Entity/BlacklistEntity.php); db-models.md `blacklist`.

## Core Fields
- type (list_string; required; values: `wl_zd`=ZD, `wl_z`=Z, `wl_n`=N, `bl`=Black List)
- person (list_string; required; values: fundraiser / patron / gift / spotter)
- application (reference → EN0001; required; links the entry to an Application)
- name / last_name (string 100; Jméno / Příjmení)
- rc (string 20; Rodné číslo) · mail (email) · phone (string 13)
- company_name (string 100) / ico (string 20)
- note (text_long; Poznámka)

## Technical Fields
- user_id (reference → EN0008 User; author)
- created / changed (timestamps)

## Relations
- application → EN0001 (Application; required)
- user_id → EN0008 (User; author)
- Classification propagates to EN0006 (Contact) `blacklist_type` — logical, via `ScoringService::setBlacklistType` (not a stored reference)

## Allowed Statuses
`type` (the classification enum): `wl_zd` (ZD), `wl_z` (Z), `wl_n` (N), `bl` (Black List). No lifecycle status field (`status` publish API is inherited boilerplate with no backing field).
Evidence: db-models.md `blacklist` (`type` allowed_values; `status` has no backing field).

## Lifecycle
No entity-level state machine — a list row is created (immutable classification) by scoring; the enum `type` is a classification, not a transition sequence.
Confirmed side-effect (not a transition of this entity): `contact.blacklist_type` → `wl_n | bl | wl_zd | wl_z` via raw UPDATE keyed by email (no LIMIT) — `ScoringService::setBlacklistType` L29 (FLW0016). Scoring `scoring_ok` maps a party to `wl_z` (FLW0001, Partial).

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Is a Blacklist row ever updated/removed, or is it append-only? (no delist path evidenced). Missing evidence.
2. `ScoringService::setBlacklistType` updates Contact by email with no LIMIT — can it reclassify unrelated contacts sharing an email?
3. Form/view-display configs reference undefined `gift_name`/`list_type` fields (stale) — any live behaviour behind them?
