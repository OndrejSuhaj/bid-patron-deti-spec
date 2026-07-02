---
doc_id: EN0014
title: DonationConfirmation
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004  # Campaign (Story) — optional linked story
  - EN0008  # User — author
---

# EN0014 — DonationConfirmation

## Description
Czech tax donation certificate ("Potvrzení o daru") — an immutable snapshot of a donor's identifying and donation-total data captured at request time, used to issue a tax-deductible donation confirmation for a given year. Stores the donor's name/address/birth number, the confirmed donation total, and GDPR consent flags as a point-in-time record rather than live references.

## Entity Category
Persisted · Confidence: High

## Origin
- DB artifacts: base_table `donation_confirmation` (content, not revisionable, not translatable; no `hook_schema`).
- Code touchpoints: `DonationConfirmationEntity`; created + saved from the confirmation form and `v32` endpoint.
Evidence: [donation_confirmation/src/Entity/DonationConfirmationEntity.php](../../intake/current-solution/_source/patronus/web/modules/custom/donation_confirmation/src/Entity/DonationConfirmationEntity.php); db-models.md `donation_confirmation`.

## Core Fields
- name (string 50; required; donor name; entity label)
- email (string 200; required; plain string — no format validation at data layer)
- address (string 250; required)
- rodne_cislo (string 20; optional; Czech birth/personal number)
- donation_total (integer; confirmed donation amount "Částka")
- donation_in_words (string 250; amount in words)
- confirmation_year (integer; the tax year the confirmation covers)
- number_of_requests (integer; count of confirmation requests)

## Technical Fields
- campaign (reference → EN0004; optional linked Story; no explicit handler)
- agreement_truthfulness / agreement_personal_data (boolean, ReadOnly; required; GDPR consent; default TRUE)
- ip_address (20, ReadOnly) / user_agent (250, ReadOnly)
- status (boolean; publish flag; default TRUE)

## Relations
- campaign → EN0004 (Campaign; optional)
- user_id → EN0008 (User; author)

## Allowed Statuses
No status enum. `status` is only the Drupal publish boolean, default TRUE (published on create).
Evidence: db-models.md `donation_confirmation`; EN-lifecycle-evidence `status` default TRUE.

## Lifecycle
Confirmed:
- (none) → created / published (`status` default TRUE) — `DonationConfirmationEntity::create()->save()` from the form (L330-344) and `v32` endpoint (L139-156) (FLW0009).
Snapshot semantics: donor identity fields (name/email/rodne_cislo/address) and `donation_total` are captured values, not live entity references — no subsequent state change observed. Treated as write-once.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. PDF issuance/e-mailing of the certificate — is generation part of this entity's flow or a downstream job? (not evidenced here).
2. `donation_total` — is it computed from EN0009 transactions at creation, or user-entered? (snapshot value; source not traced).
3. CZ-only? No country field present — is scope enforced elsewhere (RO uses EN0015 TaxPayer instead)?
