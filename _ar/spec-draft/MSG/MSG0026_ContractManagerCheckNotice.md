---
doc_id: MSG0026
title: Contract Manager-Check Notice
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0004
references:
  - EN0011
  - EN0012
  - EN0001
  - EN0022
  - ES0006
---

# MSG0026 – Contract Manager-Check Notice

## Purpose

Tell the internal contract-checking recipient that a Contract (EN0011) has just been generated for an
Application (EN0001) and is ready for their review, giving them what they need to open the document
and, once satisfied, forward it onward to the fundraiser for signature. Unlike the other messages in
this layer, the recipient is not a Parent/Patron/Donor party but an internal operational role — this
is nonetheless a genuine user-facing transactional email (distinct from the ops Slack/Telegram
channel pings), addressed to a named checking function rather than a case party.

---

## Trigger

UC0004 (Manage Contract & Signature) — UC0004.2 step 2 ("send contract to manager"): once Admin
triggers the manager-check step for a newly created Contract, the System dispatches this notice to the
configured contract-checking recipient and advances the Application status to reflect that the
Contract is under manager review (Notification Matrix sheet SC-8A, step 5: "Ops Mgr creates donation
contract in the system for the fulfilled story" → status `contract` / "Contract for Approval").

Evidence Level: Confirmed — the trigger step, its position in the contract sub-flow, and the status
transition are evidenced in UC0004.2 and the underlying flow dossier FLW0008.

---

## Recipients

- **Contract-checking recipient** — a single configured internal address representing the
  manager/checking function for contract review (not a case-specific Parent, Patron, or Donor role) —
  email only, via ES0006 (Mautic).
- No in-zone notification variant is evidenced for this recipient — the checking function operates
  outside the Parent/Patron self-service zones, so this message is email-only.
- No RO/MD content variance is evidenced beyond the general per-country template resolution recorded
  at the capability level (FN0019); the recipient itself is a single configured address regardless of
  country/tenant.

---

## Message Content

Conceptually, each dispatch of this message carries:

- A statement that a Contract (EN0011) has been generated for a specific Application (EN0001) and is
  ready for the recipient's check.
- Identifying information for the Contract/Application/underlying Story so the recipient can locate
  the correct case.
- A link to download/view the rendered Contract document for review.
- A link or action allowing the recipient to send the Contract onward to the fundraiser once the check
  is complete (the counterpart action documented as UC0004.2 step 4).

No fixed subject-line text, body markup, or template structure is asserted here — the concrete wording
is instance data (see rules-MSG.md restrictions).

Every dispatch is archived as an EmailArchive (EN0022) record regardless of whether the underlying
send was actually transmitted, per the platform's general email-archiving behavior (see MSG0005 for
the shared archiving caveat).

---

## Notes

- Delivery is best-effort: if the checking recipient address or the rendered Contract PDF is
  unavailable at send time, the Application status still advances to the manager-check state with no
  notification sent — a silent gap (UC0004 AF2; FN0009). This message document describes the intended
  contract when both are available; the failure path is a UC/FN-owned behavior, cited here rather than
  restated.
- Distinct from the legacy fundraiser-notice branch of the same sub-flow (UC0004.2 step 7 / UC0004 AF1),
  where — on tenants without digital signature enabled — the rendered Contract is instead sent directly
  to the fundraiser rather than routed through this manager-check step first; that is a separate
  message concern not covered by this document.
- Evidence Level: Confirmed for trigger, recipient role, and content elements (UC0004, FLW0008,
  Notification Matrix SC-8A). Partial for whether any secondary/backup checking recipients exist beyond
  the single configured address — not evidenced.
