---
doc_id: BR-ApplicationStatusGovernance
title: Application Status Governance & Transition Legality
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0001
  - EN0002
  - EN0004
  - UC0002
  - SYSTEM
references:
  - EN0001
  - EN0002
  - EN0004
  - EN0003
  - EN0025
  - UC0002
  - UC0011
---

# BR – Application Status Governance & Transition Legality

## Purpose

Governs the single Application status field that spans the lead-era and application-era workflow
(EN0001), and states which transition-legality, side-effect, idempotence, and automatic-transition
guarantees are — and are not — enforced in the current state.

---

## Single status field

- The Application (EN0001) SHALL carry its position in the workflow on one status field; the
  lead-era phase and the application-era phase of the same case SHALL be represented as values of
  that single field, not as separate records.
- A newly created Application SHALL start in the initial intake status.

---

## Profile cardinality

- An Application (EN0001) SHALL hold at most one fundraiser profile and at most one patron profile
  (ApplicationProfile, EN0002), discriminated by profile role.

---

## Transition legality (current-state: largely NOT enforced)

- Current-state: the system SHALL NOT be assumed to enforce transition legality on a status change;
  a status change can currently reach any workflow status from any status, with no server-side
  transition check on the majority of change surfaces.
- Current-state: which statuses are terminal versus re-enterable is undefined, because no legality
  guard is enforced.
- Current-state: role-permitted transition constraints are held only as configuration and SHALL NOT
  be assumed to be enforced server-side at the point of change.

---

## Status-change side effects and idempotence (current-state)

- A status change SHALL apply the new status, record an append-only audit entry (EN0025), and drive
  the configured downstream reactions.
- Current-state: a save SHALL NOT be assumed idempotent — an unchanged re-save currently re-raises
  the reaction fan-out and can re-log and re-notify.
- Current-state: the status-change fan-out SHALL NOT be assumed atomic — a mid-sequence failure can
  leave some reactions run and others not.

---

## Automatic (scheduled) transitions

- An Application that has dwelt in a source status beyond a configured age threshold SHALL be
  eligible for an automatic transition to the configured target status, attributed to the system
  service account.
- An automatic transition SHALL apply the same status-change contract and side effects as a
  human-initiated change.
- Current-state: only the remove-patron automatic action is enforced among the configured automatic
  actions.

---

## Application-Campaign status consistency

- An Application and its linked Campaign (EN0004) SHALL be kept in a mutually consistent status and
  gift-category pairing.
- Current-state: a detected desync between an Application and its linked Campaign SHALL be raised as
  an operational alert only, and SHALL NOT be automatically reconciled or repaired.

---

## Non-Goals

- This rule does not define the full workflow status vocabulary or the meaning of individual
  statuses (owned by the status model and EN0001).
- This rule does not govern Campaign-side funding lifecycle transitions (auto-complete,
  auto-uncomplete, overpayment handling) — see BR-CampaignStoryLifecycle.
- This rule does not govern contract-driven or scoring-driven status transitions in detail — see
  BR-ContractAndESignature and BR-ScoringAndRiskGating, which reference this rule for the underlying
  status-change contract.
- This rule does not define how the Application-Campaign desync alert is delivered or routed — see
  BR-OperationalAlerting.
