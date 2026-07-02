---
doc_id: EN0026
title: ApplicationReaction
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application (matched by status)
  - EN0003  # ApplicationSession (created by a matching reaction)
  - EN0008  # User (owner)
  - EN0025  # ApplicationLog (log entry appended by a matching reaction)
  - BR-ApplicationStatusGovernance  # reaction fan-out / matching is part of status-change governance
  - UC0002  # Orchestrate Application Status Change (fan-out that reads and executes reactions)
---

# EN0026 — ApplicationReaction

## Purpose

An ApplicationReaction is a configuration record describing what the platform should do when an
Application (EN0001) reaches a given status, for a given recipient role. Administrators author
ApplicationReaction records ahead of time; each one is matched at runtime against an Application's
current status and role, and — when matched and enabled — can produce a zone status message, expose
a user-action button, create an ApplicationSession (EN0003), and send a status-driven notification.
ApplicationReaction is config-driving-behavior: it is not created per Application, and no individual
Application instance owns or mutates a reaction record.

---

## Lifecycle

- Disabled (default)
- Enabled

The lifecycle reflects only whether the reaction is published/active for matching; it carries no
domain workflow of its own. A reaction's own record is otherwise only authored and edited, not
transitioned through business states — see State Transitions.

---

## State Transitions

(create) → Disabled
trigger: administrative authoring (created by an administrator; no confirmed UC drives creation)

Disabled → Enabled / Enabled → Disabled
trigger: administrative authoring (administrator toggles the publish flag; no confirmed UC covers this edit)

Note: ApplicationReaction is *read*, not transitioned, during UC0002.2 — Downstream reaction fan-out
on status change. Matching a reaction to an Application's new status and role is an evidenced,
confirmed behavior (see BR-ApplicationStatusGovernance), but the creation/editing of reaction records
themselves is administrative configuration outside any reconstructed use case.

---

## Attributes

### System-managed attributes

- owner (reference to EN0008 – User; the user who owns/authored this reaction record)
- created (timestamp; required; record creation time)
- changed (timestamp; required; record last-modification time)

### User-provided attributes

- role (enumerated; required; the recipient/target role this reaction applies to — e.g. patron,
  fundraiser, supporter, organisation worker, anonymous)
- application status (enumerated; required; the Application (EN0001) status this reaction is matched
  against; allowed values are the current Application status vocabulary)
- initiator (enumerated; optional; restricts matching to reactions triggered by a specific role — e.g.
  patron, fundraiser, organisation worker; unset means any initiator matches)
- status message / status message detail (text; optional; zone status text shown when the reaction is
  matched)
- action button configuration (structured; optional; whether a user-action button is shown, its
  action, its label, and any confirmation prompt)
- session interface (enumerated; optional; the interface variant used when this reaction creates an
  ApplicationSession, EN0003)
- display styling (structured; optional; color/icon used when the reaction is shown in a zone)
- notification email content (text; optional; subject and body of the e-mail sent when this reaction's
  e-mail notification is enabled)
- notification zone content (text; optional; text and icon of the in-app zone notification produced
  when this reaction's zone notification is enabled)
- visibility toggles (boolean-valued; optional; control whether related Application/Campaign
  information is shown to the fundraiser or patron as part of this reaction)
- enabled (boolean-valued; required; default Disabled; publish/enable flag — see Lifecycle)

---

## Invariants

- A reaction is only executed for an Application (EN0001) when its configured status and role (and,
  if set, initiator) match the Application's current status-change context, and only while enabled —
  see BR-ApplicationStatusGovernance for the governing status-change/reaction-fan-out rule.
- Every entity must always have a valid lifecycle state (Disabled or Enabled).

Open — no dedicated business rule document currently states a uniqueness constraint on the
status/role/initiator combination (i.e. whether more than one enabled reaction may match the same
Application status change); see Open Questions.

---

## Relationships

- EN0008 – User (owner of the reaction record)
- EN0001 – Application (matched by status during the status-change fan-out)
- EN0003 – ApplicationSession (created when a matching reaction specifies a session interface)
- EN0025 – ApplicationLog (a matching reaction produces a log entry during the fan-out)

---

## Open Questions

1. Is the status match single-valued per reaction (one status per record), so multi-status coverage
   requires one reaction row per status? Not confirmed.
2. A legacy/alternate action-configuration field was observed alongside the currently used action
   button configuration; which one governs button behavior is not fully confirmed — treat the legacy
   field as dead/unused pending confirmation.
3. Some notification-related fields behave differently from the rest of the record with respect to
   revision history; whether this is intentional is not confirmed.
4. Whether more than one enabled reaction may legally match the same Application status/role/initiator
   combination at once is not covered by an evidenced business rule.
