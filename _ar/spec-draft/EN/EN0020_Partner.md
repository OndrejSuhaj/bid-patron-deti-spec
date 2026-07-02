---
doc_id: EN0020
title: Partner
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0008  # User — owner
---

# EN0020 — Partner

## Purpose

The Partner represents a "podporují nás" (they support us) marketing logo entry displayed on the
public site (typically the footer). It is lightweight marketing/display content — a name, an
outbound link, a logo image, a sort position, and a category distinguishing "support us" entries
from "partners" entries — with no domain behaviour beyond display and ordering. It is unrelated to
the taxonomy-based `partners` classification used elsewhere in the system (see Open Questions).

---

## Lifecycle

- Unpublished
- Published

Hypothesis — Not evidenced in current sources. No use case or flow evidence covers Partner
creation, editing, or publishing; only the data model is confirmed. Missing evidence: the
administrative create/edit path and the display consumer that renders published Partner entries.

---

## State Transitions

Unpublished → Published
trigger: Unknown — Not evidenced in current sources.

Published → Unpublished
trigger: Unknown — Not evidenced in current sources.

---

## Attributes

### System-managed attributes

- `owner` (reference to EN0008 – User; optional; author of the entry)
- `created` (timestamp; system-managed; creation time)
- `changed` (timestamp; system-managed; last modification time)

### User-provided attributes

- `category` (enumeration; required; values: `support_us` / `partners`; classification, not a
  lifecycle state)
- `name` (text, max 50 characters; optional; entry label)
- `link` (text, max 200 characters; optional; outbound URL)
- `logo` (image; optional; publicly served)
- `order` (integer; optional; sort position for display ordering)
- `published` (boolean; publish flag — see Lifecycle)

---

## Invariants

- Entity must always have a valid lifecycle state (`published` flag).
- No cross-entity or governance rule is known to constrain Partner; no BR document currently
  references this entity.

---

## Relationships

- EN0008 — User (owner/author of the Partner entry)

---

## Open Questions

1. How is `order` used to render the partner list, and is it globally unique or free-form?
2. Is the `category` split (`support_us` vs `partners`) surfaced in distinct site regions?
3. A separate taxonomy-based `partners` classification exists elsewhere in the system and is
   unrelated to this entity — is there an overlap or naming confusion risk between the two in
   active use?
4. No use case or business rule currently references Partner; state transition triggers are
   unconfirmed.
