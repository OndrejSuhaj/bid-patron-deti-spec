---
doc_id: EN0011
title: Contract
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application (Žádost) — references contract / delivery_note / acceptance_protocol / appendix
  - EN0012  # ContractTemplate — HTML source for generated contracts
  - EN0008  # User — owner
---

# EN0011 — Contract

## Description
Generated legal document (donation contract, handover/takeover protocol, appendix, etc.) with a rendered PDF and a two-step e-signature (manager, then fundraiser). Revisionable, so every stamping/signature produces a new revision. Carries a per-country human-readable contract number (`public_id`) and a sequential per-year counter (`int_id`).

## Entity Category
Persisted · Confidence: High

## Origin
- DB artifacts: base_table `contract` (content, **revisionable**, not translatable; revision tables `contract_revision`/`contract_field_revision`; no `hook_schema`).
- Code touchpoints: `ContractEntity` — `preSave` (renders `html` → mPDF `file`, assigns `public_id`/`int_id`), `signManager`, `signFundraiser`, `createFundraiserSignatureConfirmation`; used from `ApplicationContractController`, `ContractFundraiserSignForm`.
Evidence: [contract/src/Entity/ContractEntity.php](../../intake/current-solution/_source/patronus/web/modules/custom/contract/src/Entity/ContractEntity.php); db-models.md `contract` (Verification: Confirmed).

## Core Fields
- name (string 50; required; entity label)
- html (text_long; contract body; rendered to PDF in `preSave`)
- public_id (string, ReadOnly; contract number — CZ = `year*10000 + int_id + '/' + campaign VS`; other-country = `int_id + '/' + date`; Evidence: L209-214)
- int_id (integer; sequential per-year counter via `MAX(int_id)+1`; app-level uniqueness only — L205/647-653)
- text_gift_proof (text_long; handover-protocol text)

## Technical Fields
- file (file, public, pdf; generated contract PDF)
- attachment_contract (file, private, **images only** png/jpg/jpeg/gif; ∞; signed contract scans)
- attachment_gift_proof (file, private, images only; ∞; signed handover protocols)
- digital_signature (string_long; JSON e-signature blob incl. `contract_hash` = SHA-512 of the PDF, or of `public_id` when no file — L502)
- digital_signature_confirmation (file, public, pdf; e-signature confirmation PDF, contains QR — `createFundraiserSignatureConfirmation`)
- status (boolean; publish flag; default TRUE)

## Relations
- user_id → EN0008 (User; owner)
- Referenced (inbound) by EN0001 (Application): `contract`, `delivery_note`, `acceptance_protocol`, `appendix` all target this entity
- Generated from EN0012 (ContractTemplate) `html` — logical, not a stored field

## Allowed Statuses
No status enum. `status` is only the Drupal publish boolean. Signature progression is expressed by presence of stamped `html` (manager) and populated `digital_signature` + confirmation PDF (fundraiser), not by a status field.
Evidence: db-models.md `contract`; `ContractEntity::signManager`/`signFundraiser`.

## Lifecycle
Confirmed (FLW0008):
- created (draft) → manager-signed (`html` stamped) — `ContractEntity::signManager` L467.
- manager-signed → fundraiser-signed (`digital_signature` JSON + SHA-512 `contract_hash` + QR confirmation PDF) — `signFundraiser` L490-505 + `createFundraiserSignatureConfirmation` L526-552.
- The signing session drives owning Application EN0001 through `waiting_signature` → `contract_signed` — `ApplicationContractController` L398/448/493 (FLW0008).

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. `public_id`/`int_id` uniqueness is app-level only (MAX+1, no DB unique key) — concurrency race under simultaneous generation.
2. Is there a "voided/cancelled" contract state, or is superseding done purely via Application re-references + new revisions?
3. `contract_hash` falls back to hashing `public_id` when no PDF file exists — is a file-less signed contract a valid business state?
