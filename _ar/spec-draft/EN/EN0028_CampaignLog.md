---
doc_id: EN0028
title: CampaignLog
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004  # Campaign (logged Story/Příběh)
  - EN0008  # User (author)
  - UC0011  # Manage Campaign / Story Lifecycle (candidate writer context; Hypothesis)
---

# EN0028 — CampaignLog

## Purpose

A per-Campaign (Story/Příběh, EN0004) audit record intended to capture how a field's value changed
over an interval — pairing a start and finish point in time with the changed field and its value.
Structurally comparable to ApplicationLog (EN0025), but for the Campaign aggregate rather than the
Application aggregate.

---

## Lifecycle

Recorded — the only state. A CampaignLog entry is an append-only audit row: created once, never
transitioned or removed. No status vocabulary is defined for this entity.

---

## State Transitions

(none) → Recorded
trigger: Hypothesis — no confirmed use case writes CampaignLog. UC0011 (Manage Campaign / Story
Lifecycle) governs the Campaign field changes (activation, deadline expiry, completion) that would
plausibly be the source of these entries, but UC0011 explicitly does not assert CampaignLog as part
of its confirmed behavior — the link is Hypothesis only. **Missing evidence** for the actual writer.

No transition out of Recorded is evidenced — entries would be append-only, consistent with the
ApplicationLog pattern (EN0025).

---

## Attributes

### System-managed attributes

- Campaign (reference to EN0004; required) — the Campaign this entry is recorded against.
- Author (reference to EN0008; required) — the user attributed as author of the entry.
- Start (timestamp; required) — when the recorded interval begins.
- Finish (timestamp; required) — when the recorded interval ends.

### User-provided attributes

- Field name (text, up to 50 characters; optional, defaults to empty) — label identifying the
  changed field.
- Field value (text, up to 255 characters; optional, defaults to empty) — value associated with the
  changed field.

---

## Invariants

- No lifecycle-state attribute is defined on this entity — Recorded is the entity's only state, not
  a status value chosen from a vocabulary (structurally consistent with ApplicationLog, EN0025).
- Conflict — requires clarification: prior evidence noted scaffolding-level label/status attribute
  mappings on this entity without any corresponding backing field — the same dangling-mapping pattern
  observed on ApplicationLog (EN0025). Not resolved as a canonical fact.

---

## Relationships

- EN0004 — Campaign (the logged aggregate; required, one Campaign per entry)
- EN0008 — User (the author of the entry)

---

## Open Questions

1. Which use case or system process writes a CampaignLog entry? No use case asserts it as confirmed
   behavior (UC0011 references EN0028 only as Hypothesis). **Missing evidence** for the writer.
2. Are Start/Finish meant to bracket the duration a specific field value was held (an interval audit),
   or do they simply mark created/changed points in time? Not evidenced.
3. Uncertain: is the dangling label/status attribute mapping shared, copy-pasted scaffolding with
   ApplicationLog (EN0025), or two independently dead configurations? Not resolved.
