---
doc_id: EN0027
title: ApplicationAction
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application (transitioned by the action)
  - EN0008  # User (owner)
  - BR-ApplicationStatusGovernance  # automatic-transition eligibility, contract, and enforcement scope
  - UC0002  # Orchestrate Application Status Change (UC0002.3 — scheduler-driven automatic transition)
---

# EN0027 — ApplicationAction

## Purpose

ApplicationAction is a configuration record that defines an automatic, time-based status transition
rule for Applications (EN0001). It expresses: which source status an Application must be sitting in,
how long it must have dwelt there, which target status it should move to, and — optionally — an
additional named action to run alongside the transition. It holds no per-Application state; it is a
rule definition, not a case record. See BR-ApplicationStatusGovernance for the governing contract of
automatic transitions.

## Lifecycle

- Active — the rule is enabled and eligible to be evaluated.
- Inactive — the rule is disabled and not evaluated.

The ApplicationAction record itself does not undergo a domain lifecycle beyond this active/inactive
flag; it is created and edited by administrators. The *Application* it targets is what transitions
(see EN0001) — the rule record is not the subject of the transition it defines.

## State Transitions

Active ↔ Inactive
trigger: administrative configuration change (no dedicated UC identified for enabling/disabling a rule; Open Question below).

N/A — Application transition driven by this rule:
trigger: UC0002.3 (Orchestrate Application Status Change — scheduler-driven automatic status transition). When a rule is Active and its initiator is the scheduled kind, and a matching Application (EN0001) qualifies (see Invariants), UC0002.3 moves that Application from the rule's source status to its target status, attributed to the system service account, and re-enters the shared status-change contract (UC0002.1 onward).

## Attributes

### System-managed attributes

- Owner (reference to EN0008 – User; system-managed; defaults to the current user at creation)
- Name (string; system-managed label for the rule)
- Created / Changed timestamps (system-managed)

### User-provided attributes

- Initiator (enumerated; required; values: scheduled / patron / fundraiser — only the scheduled kind is evaluated by the automatic-transition process; see Open Questions for the other two)
- Source status (enumerated, multi-value; required; the Application status the rule watches for)
- Target status (enumerated; optional; the status an eligible Application is moved to)
- Session interface (enumerated; required; values: any / default / custom / upload_contract / upload_gift_proof / upload_feedback / authenticated / new_patron / invited)
- Age threshold (string; optional; the minimum time an Application must have dwelt in the source status before becoming eligible)
- Additional action (enumerated, multi-value; optional; names a supplementary action to run against the qualifying Application; only one named action — removing patron data — is currently enforced; see Open Questions)
- Active flag (boolean; required; default true; enables or disables the rule)

## Invariants

- Only an Active rule whose initiator is the scheduled kind is evaluated by the automatic-transition process (see BR-ApplicationStatusGovernance, "Automatic (scheduled) transitions").
- An Application becomes eligible for this rule's transition only once it has dwelt in the rule's source status beyond the rule's age threshold (see BR-ApplicationStatusGovernance).
- A transition produced by this rule follows the same status-change contract and side effects as a human-initiated change, attributed to the system service account (see BR-ApplicationStatusGovernance; UC0002.1).
- Among the configured additional actions, current-state enforcement is limited to the remove-patron action; other configured action names are not currently enforced (see BR-ApplicationStatusGovernance).

## Relationships

- EN0001 – Application (the entity whose status this rule transitions; the rule reads the Application's current status and, when eligible, sets its target status)
- EN0008 – User (owner of the configuration record)

## Open Questions

1. Only the remove-patron additional action is enforced even though the additional-action attribute allows multiple values — are other configured action names silently no-op, or is enforcement incomplete? (Carried forward — Uncertain.)
2. The patron and fundraiser initiator values are configurable, but only the scheduled initiator is known to be evaluated automatically — is there any current-state consumer of non-scheduled initiators, or are these unused configuration options? (Carried forward — Uncertain.)
3. Source status is multi-value, but eligibility evaluation is not confirmed to support matching against more than one configured status value at a time for a single Application — confirm single-vs-multi status matching semantics. (Carried forward — Uncertain.)
4. No UC was identified governing the administrative create/edit/enable/disable of an ApplicationAction rule itself (as distinct from UC0002.3, which governs the Application transition the rule produces) — Missing evidence.
