---
doc_id: EN0021
title: Feedback
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — feedback is authored in the context of an Application's fundraiser/campaign
  - EN0004  # Campaign (Story) — feedback.campaign → Campaign
  - EN0008  # User — feedback author/fundraiser → User
  - EN0003  # ApplicationSession — feedback-form session created on entry into a feedback-waiting status
  - UC0002  # Orchestrate Application Status Change — creates the feedback session on entry into a feedback-waiting Application status
---

# EN0021 — Feedback

## Purpose

Post-campaign feedback authored by a fundraiser for the donors who supported their campaign ("feedback for donors who helped you"). It carries a free-text message and optional attached images, and is contextually tied to the fundraiser (EN0008) and the Campaign/Story (EN0004) it concerns.

---

## Lifecycle

- Created
- Sent
- Published / Unpublished (independent publish flag)

---

## State Transitions

(none) → Created
trigger: fundraiser or back-office authoring of feedback in the context of a Campaign (EN0004); populated from the associated Application's (EN0001) fundraiser and campaign context.

Created → Sent
trigger: dispatch of the authored feedback on the campaign feedback path (dispatch timestamp recorded).

Related (adjacent, not a direct state of this entity): entry of the linked Application (EN0001) into a feedback-waiting status creates a corresponding ApplicationSession (EN0003) carrying a feedback form — trigger: UC0002 (Orchestrate Application Status Change), fan-out step for feedback-waiting statuses. See Open Questions for how this ApplicationSession (EN0003) relates to a resulting Feedback record.

---

## Attributes

### System-managed attributes

- `sent` (timestamp; optional; records when the feedback was dispatched)
- `status` (boolean; optional; publish flag; default published)
- author reference (reference to EN0008 – User; optional; the recording/owning user)
- `created` / `changed` (timestamp; system-managed record timestamps)

### User-provided attributes

- `name` (string; required; entity label describing the feedback record)
- `body` (free text; required; the feedback message for donors)
- fundraiser (reference to EN0008 – User; optional; the fundraiser the feedback is authored on behalf of)
- campaign (reference to EN0004 – Campaign; optional; the Campaign/Story the feedback concerns)
- images (file attachments; optional; unbounded; supporting images attached to the feedback)

---

## Invariants

- Feedback must always have a valid lifecycle state (see Lifecycle).
- No dedicated business rule document currently governs Feedback transitions or uniqueness; only the generic Application-status governance (see BR-ApplicationStatusGovernance) applies to the adjacent feedback-waiting Application status, not to this entity's own fields directly.

---

## Relationships

- EN0001 – Application (contextual source of the fundraiser and campaign values captured on creation)
- EN0004 – Campaign (Story) (feedback concerns this Campaign)
- EN0008 – User (feedback author / fundraiser)

---

## Open Questions

1. Is Feedback shown publicly to donors, and does the publish flag gate that visibility? Not evidenced.
2. One authoring path does not record a dispatch timestamp while another does — is dispatch meaningful across all creation paths, or only the one that sets it? Not evidenced.
3. Relationship between this entity and the Application's feedback-waiting status (see UC0002 fan-out, which creates a feedback-form session on entry into that status): is there exactly one Feedback record per Application, or per Campaign, and does the session always result in a Feedback record? Not evidenced — Conflict/Uncertain, not resolved in current sources.
4. No UC in the current draft set directly models fundraiser-authored Feedback creation as its own flow (UC-candidates.md associates this entity with UC0011, but no confirmed step in UC0011 covers Feedback creation); the creation trigger recorded above is inferred from entity evidence, not from a mined use-case flow — treat as Partial evidence.
