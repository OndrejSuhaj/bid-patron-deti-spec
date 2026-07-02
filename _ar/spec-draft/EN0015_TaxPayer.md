---
doc_id: EN0015
title: TaxPayer
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0011  # Contract — the (RO) tax-redirect contract this payer signs
---

# EN0015 — TaxPayer

## Description
Romanian tax-redirection payer record — captures a Romanian donor who elects to redirect a percentage of their income tax (2% / 3.5%) to the organisation. Holds full RO identity and address (CNP, father's initial, county/sector, block/staircase/floor/apt) plus a multi-year consent flag, and links to the redirect Contract (EN0011). RO-specific counterpart to the CZ DonationConfirmation (EN0014).

## Entity Category
Persisted · Confidence: Medium

## Origin
- DB artifacts: base_table `tax_payer` (content, not revisionable, not translatable; installed via `account_update_10001/10002` through the entity-definition manager, no `hook_schema`).
- Code touchpoints: `TaxPayerEntity` (in the `account` module). Adjacent to the CZ confirmation flow FLW0009.
Evidence: [account/src/Entity/TaxPayerEntity.php](../../intake/current-solution/_source/patronus/web/modules/custom/account/src/Entity/TaxPayerEntity.php); db-models.md `tax_payer`.

## Core Fields
- name (string 50; required; entity label)
- first_name / last_name / initial (string 50; required; `initial` = "Father Initial")
- email (eligible_email custom, 200; required)
- numeric_code (rc custom, 20; required; Personal Numeric Code / CNP; `validate_age=0`)
- phone (phone_number; required; country from Settings = `ro`; unique=NO) · fax (phone_number; optional; unique=NO)
- street / number / county / town / postal_code (string 100; required; `county` = "County/Sector")
- two_years_agreed (boolean; optional; 2-year redirect consent)

## Technical Fields
- block / staircase / floor / apt (string 100; optional; RO address detail)
- created / changed (timestamps)

## Relations
- contract → EN0011 (Contract) — the sole outbound relation (the RO redirect contract)

## Allowed Statuses
None. No status enum and no publish field declared (unlike sibling entities, `tax_payer` has no `status` boolean in its field table).
Evidence: db-models.md `tax_payer` field table (no `status` row).

## Lifecycle
No entity-level state machine observed — a captured payer record linked to a redirect Contract. No promote/approve/void transition evidenced in mined flows.
Hypothesis: record is created when a RO donor submits a tax-redirect form and paired with a generated Contract (EN0011). Missing evidence — creation/pairing path not deep-mined (FLW0009 is CZ-adjacent).

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Where is a TaxPayer created and how is the linked Contract (EN0011) generated/signed for RO redirect?
2. `two_years_agreed` — does it drive multi-year re-submission suppression, or is it purely recorded consent?
3. `numeric_code`/`email` use custom field types (`rc`, `eligible_email`) — do their validators enforce CNP checksum / eligibility here?
