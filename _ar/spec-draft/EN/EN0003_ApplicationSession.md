---
doc_id: EN0003
title: ApplicationSession
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001 (Application)
  - EN0026 (ApplicationReaction)
  - UC0001 (Submit Application)
  - UC0002 (Orchestrate Application Status Change)
---

# EN0003 — ApplicationSession

## Purpose

An ApplicationSession governs *how* and *by whom* a given Application (EN0001) form can be accessed
during the multi-step intake and its subsequent status-driven interactions (e.g. signing, feedback).
Each session pairs a role (fundraiser or patron) with an access interface variant and a form
definition, and is either active or deactivated. It is the access/interface control record for
front-end Application editing.

---

## Lifecycle

- Active
- Deactivated

---

## State Transitions

(create) → Active
trigger: UC0001 — Submit Application (two sessions created at Application creation, one per role — patron and fundraiser)

(create) → Active
trigger: UC0002.2 — Downstream reaction fan-out on status change (a matching ApplicationReaction, EN0026, specifies a session interface for the new status/role)

(create) → Active
trigger: UC0002.2 — Downstream reaction fan-out on status change (entry into a signature-waiting or feedback-waiting status creates a session carrying a signing or feedback form)

Active → Deactivated (all sessions of the Application)
trigger: UC0002.2 — Downstream reaction fan-out on status change (new status is configured to invalidate sessions)

Open — no re-activation transition (Deactivated → Active) is evidenced; no trigger confirmed for a `readonly` state change.

---

## Attributes

### System-managed attributes

- session identifier (identifier; required; uniquely identifies the session)
- status (boolean-valued; required; default Active; set to Deactivated by the session-cancellation reaction — see State Transitions)
- readonly (boolean-valued; optional; default not-readonly; trigger for change not evidenced)
- application reference (reference to EN0001 – Application; optional; identifies the owning Application)

### User-provided attributes

- interface (enumerated; optional; observed values: invited, authenticated_invited, custom — no canonical definition of the selection rule is evidenced; see Open Questions)
- role (enumerated; optional; values: fundraiser, patron)
- schema (structured form definition; optional; the form content the session grants access to, e.g. sections of the intake/signing/feedback form)

---

## Invariants

- A deactivated session SHALL NOT grant Application-editing access (role/authority content owned by BR-AccessControlAndRoles).

(An at-most-one-active-session-per-role constraint is NOT asserted as an invariant — it is not evidenced; it is tracked under Open Questions.)

---

## Relationships

- EN0001 – Application (the session's owning Application)
- EN0026 – ApplicationReaction (configuration that determines when a session with a given interface/role is created)

---

## Open Questions

- What determines `interface` = invited vs. authenticated_invited vs. custom at creation? (No canonical rule evidenced.)
- Since the Application reference is not evidenced as an enforced relational link, how are orphaned sessions (deleted Application) handled?
- Can a deactivated session be re-activated, or is a new one always created instead?
- Is the one-active-session-per-role constraint a hard invariant or an emergent effect of the reaction configuration? No owning BR doc_id currently states it explicitly.
