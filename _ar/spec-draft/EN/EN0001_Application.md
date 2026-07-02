---
doc_id: EN0001
title: Application
canonical_layer: EN
spec_type: entity
status: draft
references:
  - BR-ApplicationStatusGovernance
  - BR-ScoringAndRiskGating
  - BR-PartyIdentityAndDeduplication
  - BR-ContractAndESignature
  - BR-CampaignStoryLifecycle
  - EN0002 (ApplicationProfile)
  - EN0003 (ApplicationSession)
  - EN0004 (Campaign)
  - EN0006 (Contact)
  - EN0008 (User)
  - EN0011 (Contract)
  - EN0016 (Blacklist)
  - EN0017 (ScoringRecord)
  - EN0018 (Organisation)
  - EN0025 (ApplicationLog)
  - EN0026 (ApplicationReaction)
  - EN0027 (ApplicationAction)
---

# EN0001 — Application

## Purpose

The Application (Žádost) is the core aggregate root of the Patronus domain — the hub that ties
together the applicant (fundraiser), the patron, the child, the coordinator, the risk assessment,
the contract, and the resulting Story (Campaign). "Lead" is not a separate entity: it is the early
intake/coordination phase of the same Application record, so one status field spans both the
lead-era and the application-era of a case. The Application's status governs every downstream
process area (application intake, risk, donations, content) and is kept consistent with its linked
Campaign (EN0004) status.

---

## Lifecycle

Confirmed status values (non-exhaustive; the full, country-specific vocabulary is canonical in the
status model, not restated here): `new` · `to_check` · `scoring` · `scoring_ok` ·
`application_processing` · `waiting` · `suspended` · `contract` · `waiting_signature` ·
`contract_signed` · `waiting_for_feetback` · `returned_new_patron` · `active` ·
`campaign_uncompleted` · `complete` / `completed` · `duplicate`.

The status enum is large (~66 labels) and country-specific (CZ/RO/MD); see the status model
(`intake/statuses/`) for the canonical vocabulary. See BR-ApplicationStatusGovernance for which
transition-legality, side-effect, idempotence, and automatic-transition guarantees are — and are
not — enforced on this lifecycle in the current state.

---

## State Transitions

- (create) → `new`
  trigger: UC0001 (Submit Application — self-registration and Admin-initiated creation)

- any → target status
  trigger: UC0002 (Orchestrate Application Status Change — Admin-driven status change, UC0002.1)

- any → `to_check`
  trigger: UC0002 (status-fan-out step that recomputes the risk score) / UC0003 (Assess Applicant
  Risk — automatic low-risk scoring sub-flow, UC0003.2)

- `scoring` → `scoring_ok`
  trigger: UC0003 (Assess Applicant Risk — manual scoring approval, UC0003.1); see
  BR-ScoringAndRiskGating for the approval gate condition

- eligible intermediate status → `scoring_ok`
  trigger: UC0003 (Assess Applicant Risk — coordinator low-risk override, AF3); see
  BR-ScoringAndRiskGating for the qualifying-threshold condition

- any → `waiting_signature`
  trigger: UC0002 (status fan-out entering a signature-waiting status) / UC0004 (Manage Contract
  and Signature)

- `waiting_signature` → `contract_signed`
  trigger: UC0004 (Manage Contract and Signature — fundraiser completes e-signature)

- any → `waiting_for_feetback` *(sic: source status label)*
  trigger: UC0002 (status fan-out entering a feedback-waiting status)

- any → `returned_new_patron`
  trigger: UC0002 (Orchestrate Application Status Change, AF3 — returned-to-new-patron); patron
  profile and scoring data are cleared as part of this transition

- (candidate/prior) → `active`
  trigger: UC0011 (Manage Campaign/Story Lifecycle — Admin publishes the linked Campaign, UC0011.1)

- `active` → `complete` / `completed`
  trigger: UC0011 (Manage Campaign/Story Lifecycle — Campaign funding completion cascades to the
  Application); exact source status label unconfirmed — **Partial**

- `active` → `campaign_uncompleted`
  trigger: UC0011 (Manage Campaign/Story Lifecycle — scheduled deadline-expiry check, UC0011.2)

- (any, duplicate lead) → `duplicate`
  trigger: UC0016 (Maintain Party Records — lead pairing/merge, UC0016.4); profile and party
  references on the duplicate are cleared as part of this transition; see
  BR-PartyIdentityAndDeduplication

**Open transition-legality note:** whether a given status is terminal or re-enterable is currently
undefined in this system — see BR-ApplicationStatusGovernance (transition legality is largely not
enforced).

---

## Attributes

### System-managed attributes

- status (string; required; the Application's current position in the workflow; see Lifecycle;
  governed by BR-ApplicationStatusGovernance)
- status_note (string; optional; note recorded alongside a status change)
- lead_role (string; optional; role at intake — patron / fundraiser / organisation_worker)
- lead_source (string; optional; origin of the lead — e.g. web, manual, phone, referral)
- activity / activity_note (string; optional; logged coordinator activity — e.g. call, email, sms)
- flag (list of strings; optional, multi-valued; runtime situational flags, e.g. a pandemic-relief
  flag)
- contract_type (string; optional; selects which kind of contract applies — e.g. goods, services,
  transfer, rental, amendment)
- scoring / scoring outcome fields (structured; optional; the current scoring snapshot — see
  EN0017 ScoringRecord and BR-ScoringAndRiskGating)
- low-risk score (number; optional, derived; recomputed risk score; unavailable when required
  actor/profile data is missing; see BR-ScoringAndRiskGating)
- scoring_coord_note / scoring decision fields (string; optional; coordinator scoring notes and
  decision)
- fundraiser (reference to EN0008 User; optional; the applicant)
- patron (reference to EN0008 User; optional; the patron)
- coordinator (reference to EN0008 User; optional; assigned coordinator)
- scoring reviewer (reference to EN0008 User; optional; who performed scoring)
- child (reference to EN0006 Contact; optional)
- lead contact (reference to EN0006 Contact; optional; the party associated with the lead)
- fundraiser profile / patron profile (reference to EN0002 ApplicationProfile; optional; cardinality
  governed by BR-ApplicationStatusGovernance)
- employer (reference to EN0018 Organisation; optional; the patron's employer)
- campaign (reference to EN0004 Campaign; optional; the resulting public Story)
- category (reference to a category classification; optional; area of assistance)
- contract / delivery note / acceptance protocol / appendix (reference to EN0011 Contract;
  optional, appendix multi-valued)
- attachments / attachments audit (reference to a file; optional, multi-valued)

### User-provided attributes

- status_note (string; optional; "note on status change" — entered by the acting user; see also
  System-managed, as this field is both user-entered and status-change metadata)
- category (see System-managed; selected by the applicant/coordinator)
- contract_type (see System-managed; selected during contract preparation)
- scoring fields entered on the scoring form (see EN0017 ScoringRecord for the scoring entity
  detail; the fields captured on the Application are the persisted snapshot)

---

## Invariants

- The Application status field is the single source of truth for a case's position across the
  lead-era and application-era workflow; see BR-ApplicationStatusGovernance.
- Fundraiser/patron profile cardinality on the Application is governed by
  BR-ApplicationStatusGovernance (Profile cardinality).
- Transition legality (which status can follow which) is not reliably enforced in the current
  state; see BR-ApplicationStatusGovernance.
- A status change is not guaranteed idempotent and its downstream reactions are not guaranteed
  atomic; see BR-ApplicationStatusGovernance.
- An Application and its linked Campaign (EN0004) are kept in a mutually consistent status and
  gift-category pairing, with desync surfaced only as an operational alert, not auto-repaired; see
  BR-ApplicationStatusGovernance and BR-CampaignStoryLifecycle.
- The low-risk score is a derived value recomputed when the Application enters risk-review, sourced
  from profile data that does not always match the party it is attributed to; see
  BR-ScoringAndRiskGating.
- A scoring approval to `scoring_ok` is gated by the Application's current status and the submitted
  verdict; see BR-ScoringAndRiskGating.
- Party references from the Application to Contact (EN0006) are not enforced for referential
  integrity; see BR-PartyIdentityAndDeduplication.
- A contact merge and a lead pairing/merge each reparent or overwrite Application-held party/profile
  references, with no transactional guarantee; see BR-PartyIdentityAndDeduplication.
- Contract signature progression drives the Application's status (contract-preparation,
  signature-waiting, signed); see BR-ContractAndESignature.

---

## Relationships

- EN0002 — ApplicationProfile (fundraiser and patron profiles)
- EN0003 — ApplicationSession (access/interface sessions scoped to this Application)
- EN0004 — Campaign (the resulting public Story)
- EN0006 — Contact (child, lead contact, and — via User — fundraiser/patron party records)
- EN0008 — User (fundraiser, patron, coordinator, scoring reviewer)
- EN0011 — Contract (contract, delivery note, acceptance protocol, appendices)
- EN0016 — Blacklist (risk classification entries produced against this Application)
- EN0017 — ScoringRecord (scoring outcome)
- EN0018 — Organisation (patron's employer)
- EN0025 — ApplicationLog (status-history / activity audit trail)
- EN0026 — ApplicationReaction (status-driven reaction configuration)
- EN0027 — ApplicationAction (automatic status-transition configuration)

---

## Open Questions

- Which statuses are terminal versus re-enterable, given no transition-legality guard is enforced
  (see BR-ApplicationStatusGovernance)?
- Source-of-truth (Partial — resolved with residual risk): the Application's own status field is the
  de-facto domain source of truth — the workflow and the status derivation read it, and a status
  change writes it. The parallel framework-supplied moderation state is kept in lock-step by the
  status-change path rather than by a single owning mechanism, so the two can diverge if the
  moderation state is changed outside that path. The divergence risk — not the source-of-truth
  question — is the residual open item.
- What is the exact source status label for `complete` versus `completed` on Campaign-driven
  completion (see State Transitions, `active → complete/completed`)?
