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
  - BR-ApplicationStatusGovernance
  - BR-ScoringAndRiskGating
  - BR-PartyIdentityAndDeduplication
  - UC0001 (Submit Application)
  - UC0003 (Assess Applicant Risk)
---

# EN0002 — ApplicationProfile

## Purpose

The ApplicationProfile is the richest entity in the domain — a large questionnaire capturing everything
known about an Application (EN0001) from one party's perspective: applicant/fundraiser identity, household
income and debts, the child, the patron, the requested gift/donation, the story narrative, and consents. An
Application holds at most two ApplicationProfiles — one fundraiser profile and one patron profile — carrying
a profile-role discriminator, and the profile is filled progressively as the applicant proceeds through the
multi-step Application form.

---

## Lifecycle

- Open (in progress) — created for an Application and filled step by step; no domain status vocabulary of
  its own.
- Finished — the applicant has completed and confirmed the profile.

Hypothesis — Not evidenced in current sources: no dossier traces the profile's write path end-to-end, so the
exact point at which a profile is considered complete (versus still editable) is not confirmed.

---

## State Transitions

(none) → Open  
trigger: UC0001 (Submit Application) — a fundraiser or patron profile is created for a newly started
Application.

Open → Finished  
trigger: Hypothesis — Not evidenced in current sources: the transition to Finished is inferred from progress
tracking on the profile; no use case dossier confirms the save path that sets it.

---

## Attributes

### System-managed attributes

- profile_type (enum; required; fundraiser / patron — discriminates which party's perspective the profile
  represents)
- source (enum; optional; the intake channel through which the profile was created; default web)
- traffic_source, traffic_source_other (enum / text; optional; marketing-attribution data captured at intake)
- ip_address, user_agent (text; system-recorded; not user-editable)
- progress, progress_steps_completed (text / number; optional; tracks how far the multi-step form has been
  completed)
- finished, finished_timestamp (boolean / timestamp; optional; marks and timestamps profile completion)

### User-provided attributes

- fundraiser, fundraiser_address2, fundraiser_employer (reference to EN0006 Contact; optional; the
  applicant's identity and related address/employer parties)
- fundraiser_first_name, fundraiser_last_name, fundraiser_email, fundraiser_phone, fundraiser_rc,
  fundraiser_op_id, fundraiser_address (fields), fundraiser_id_series, fundraiser_id_number (text; optional;
  applicant identity and address/ID details; fundraiser_id_number carries a country-specific length
  constraint)
- fundraiser_housing_type, fundraiser_income_type (reference to reference-data terms; optional, multiple;
  household housing and income classification)
- employed_status, receiving_social_benefits (enum / boolean; optional; applicant employment/benefit status)
- fundraiser_household_income, fundraiser_household_expenses (number; optional; household income/expense
  declaration)
- fundraiser_household_execution, fundraiser_household_insolvency, fundraiser_debts (fields) (boolean / text;
  optional; household debt/insolvency declaration)
- child (reference to EN0006 Contact; optional; the beneficiary child)
- school (reference to EN0006 Contact; optional; the child's school)
- child_first_name, child_last_name, child_rc, child_date_of_birth (text / date; child_rc conditionally
  required — see Open Questions; identity of the child)
- child_unschoold (boolean; required; whether the child is out of school)
- child_dont_disclose_name, child_dont_disclose_photo, child_handicapped (boolean; optional; child
  disclosure/consent preferences and disability flag)
- child_address (fields) (text; optional; the child's address)
- patron (reference to EN0006 Contact; optional; the patron party)
- patron_employer_id (reference to EN0018 Organisation; optional; the patron's employer)
- patron_first_name, patron_last_name, patron_email, patron_phone (text; optional; patron identity)
- patron_occupation_list (enum; optional; the patron's occupation classification)
- patron_photo (file; optional)
- patron_approve, patron_source, patron_reject, patron_reject_reason (boolean / enum / text; optional;
  patron acceptance decision and rejection reason)
- gift_supplier (reference to EN0019 Supplier; optional; the supplier fulfilling the requested gift)
- gift_category, gift_subcategory, gift_proof (reference to reference-data terms; optional; classification
  and required proof for the requested gift; gift_category is derived from gift_subcategory when not set
  explicitly)
- gift_payment_type (enum; optional; how the gift/donation is to be paid)
- gift_price (text; optional; the requested amount, subject to a minimum-price constraint — see Invariants)
- gift_price_offer, gift_price_attachment (file / text; optional; supporting price offer and attachment)
- gift_author, gift_author_ico (text; optional; identity of the party issuing the gift offer)
- gift_item, gift_note (text; optional; free-text description of the requested gift)
- story_background, story_problems, story_solution (long text; optional; narrative describing the family's
  situation, problem, and the requested solution)
- agreement_truthfulness (boolean; required; declaration that the submitted information is truthful)
- agreement_personal_data, agreement_rules (boolean; optional; consent to personal-data processing and to
  the platform's rules)
- attachement_child_photo, attachement_id_copy, attachement_documents, attachments_residence_permit,
  attachments_employment_registration, attachment_1..attachment_6, custom_attachment (file; optional,
  multiple; supporting documents and photos uploaded during the application)

---

## Invariants

- An Application (EN0001) holds at most one fundraiser profile and at most one patron profile — see
  BR-ApplicationStatusGovernance.
- The requested gift amount (gift_price) is subject to a minimum-price floor — see
  BR-ScoringAndRiskGating for how the requested gift feeds the risk gate.
- Risk scoring reads occupation and gift-payment inputs from the fundraiser profile regardless of which
  party the input logically belongs to — a recorded owner-coupling defect; see BR-ScoringAndRiskGating.
- On a Contact (EN0006) deduplication merge, every dependent profile reference is reassigned to the
  surviving Contact — see BR-PartyIdentityAndDeduplication.
- On a Lead pairing/merge, only the duplicate's patron profile is transferred onto the surviving
  Application; a pre-existing patron profile already held by the surviving Application is silently
  overwritten (orphaned) rather than reconciled — see BR-PartyIdentityAndDeduplication.

---

## Relationships

- EN0001 — Application (held by; an Application references its fundraiser and patron ApplicationProfile)
- EN0006 — Contact (fundraiser, fundraiser_address2, fundraiser_employer, child, school, patron)
- EN0008 — User (owning User of the profile)
- EN0018 — Organisation (patron_employer_id)
- EN0019 — Supplier (gift_supplier)

---

## Open Questions

- Is child_rc truly always required, given profiles created before that constraint existed may lack it?
- A duplicated field definition exists for the applicant's income/job-department attribute — which
  definition is authoritative is unconfirmed.
- Should patron-cluster attributes live on both the fundraiser and patron ApplicationProfile, or only on
  the patron one? Current sources show them present regardless of profile_type.
- Translatability of the profile is inconsistent across evidence sources — Conflict, requires
  clarification; not resolved here.
- The exact trigger that sets Finished (profile completion) is not confirmed by any use-case dossier —
  Missing evidence.
