---
doc_id: EN0002
title: ApplicationProfile
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001 (Application)
  - EN0006 (Contact)
  - EN0008 (User)
  - EN0018 (Organisation)
  - EN0019 (Supplier)
---

# EN0002 — ApplicationProfile

## Description
The ApplicationProfile (`aprofile`) is the richest entity in the domain — a ~100-base-field questionnaire capturing everything about an application from one party's perspective: applicant/fundraiser identity, household income and debts, the child, the patron, the requested gift/donation, the story narrative, consents and attachments. An Application (EN0001) holds two of these via `fundraiser_profile` and `patron_profile`. It carries `profile_type` (fundraiser/patron) as the discriminator and drives the multi-step application form.

## Entity Category
Persisted  ·  Confidence: High

## Origin
- DB artifacts: base_table `aprofile`; not revisionable, not translatable (per annotation); source = base fields only (no attached config fields, no hook_schema). `update_8006` uninstalled a leftover `vid` — entity was likely revisionable historically.
- Code touchpoints: `application/src/Entity/ApplicationProfileEntity.php` (~2390 LOC; `preSave` auto-fills `gift_category` from `gift_subcategory` parent); referenced by `application.fundraiser_profile` / `application.patron_profile`.
Evidence: `ApplicationProfileEntity.php`

## Core Fields
- profile_type (list_string; **required**; fundraiser / patron — discriminator)
- source (list_string; web / zone / corona_cash / corona_rent / corona_basic_box; default web)
- fundraiser, fundraiser_address2, fundraiser_employer (entity_reference → EN0006 Contact; optional; applicant identity)
- fundraiser_first/last_name, fundraiser_email, fundraiser_phone (unique=NO), fundraiser_rc, fundraiser_op_id, fundraiser_address_*, fundraiser_id_series/number (RO id_number 6–7 constraint)
- Household/income cluster: fundraiser_housing_type / fundraiser_income_type (entity_reference → taxonomy_term, unlimited), employed_status, receiving_social_benefits, fundraiser_household_income/expenses, fundraiser_household_execution/insolvency, fundraiser_debts_*
- child (entity_reference → EN0006 Contact; optional), school (entity_reference → EN0006 Contact), child_first/last_name, child_rc (storage-required → NOT NULL), child_date_of_birth, child_unschoold (**required**), child_dont_disclose_name/photo, child_handicapped, child_address_*
- patron (entity_reference → EN0006 Contact; optional), patron_employer_id (entity_reference → EN0018 Organisation), patron_first/last_name, patron_email, patron_phone (unique=NO), patron_occupation_list (list_integer 0–6), patron_photo, patron_approve/source, patron_reject/reason
- Gift/donation cluster: gift_supplier (entity_reference → EN0019 Supplier), gift_category / gift_subcategory / gift_proof (entity_reference → taxonomy_term), gift_payment_type (list_integer 0–2), gift_price (string; **min_price=100** constraint), gift_price_offer/_attachment, gift_author/_ico, gift_item/note
- Story cluster: story_background / story_problems / story_solution (string_long)
- Consents (ReadOnly): agreement_truthfulness (storage-required → NOT NULL), agreement_personal_data, agreement_rules, finished, finished_timestamp

## Technical Fields
- uuid / langcode (framework). Attachment fields (attachement_child_photo, attachement_id_copy, attachement_documents, attachments_residence_permit, attachments_employment_registration, attachment_1..6, custom_attachment) → file (private, unlimited).
- Tracking: traffic_source (list_string), traffic_source_other, ip_address / user_agent (ReadOnly), progress (string_long), progress_steps_completed (int).

## Relations
Soft entity_reference (no DB FK): →EN0006 Contact (fundraiser, fundraiser_address2, fundraiser_employer, child, school, patron), →EN0018 Organisation (patron_employer_id), →EN0019 Supplier (gift_supplier), →EN0008 User (user_id, owner), →taxonomy_term (housing_type, income_type, category, gift_confirmation). Held-by relation: EN0001 Application references this via fundraiser_profile / patron_profile.

## Allowed Statuses
No lifecycle status enum. `status` is a boolean publish flag (default TRUE); `profile_type` (fundraiser/patron) and `source` are the only domain enums.
Evidence: `ApplicationProfileEntity.php` baseFieldDefinitions

## Lifecycle
No entity-owned status workflow. Domain progression is tracked by the scalar `progress` / `progress_steps_completed` / `finished` fields as the multi-step form is filled.

Hypothesis: created empty → filled step-by-step → `finished`=TRUE at completion. Missing evidence: no flow dossier traces the aprofile write path end-to-end; `finished` transition trigger not code-cited (form save assumed). Owner-coupling note (batch-2): scoring reads `gift_payment_type`/`patron_occupation_list` from the *fundraiser* profile — likely unintended coupling [FLW0016].

## Spec Alignment
N/A — No EN spec files found in repository (see EN-candidates.md §Spec Discovery).

## Open Questions
- Is `child_rc` truly always storage-required given profiles created before that flag?
- `fundraiser_income_job_department` is defined twice (later wins) — which definition is live?
- Should patron-cluster fields live here or on the patron ApplicationProfile only?
- Why is translatability contradictory (preSave iterates translations, yet annotation not translatable)?
