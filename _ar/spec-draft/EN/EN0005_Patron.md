---
doc_id: EN0005
title: Patron
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004 (Campaign)
  - EN0008 (User)
  - EN0006 (Contact)
  - BR-CampaignStoryLifecycle
  - UC0011
---

# EN0005 — Patron

## Purpose

The Patron is the public-facing patron profile shown on a Campaign (Story) page — the name, surname,
and photo presented to the public as "the patron of this child." It is a display record only, distinct
from the patron *role* held by a User (`EN0008`) and from the patron's *contact* details held by a
Contact (`EN0006`); the Patron entity exists solely to carry the public-facing presentation attached
to a Campaign (`EN0004`).

---

## Lifecycle

Published  
Unpublished

No further entity-owned lifecycle states are observed; the Patron carries only a publish/unpublish
flag and no status workflow of its own.

---

## State Transitions

(none) → Published / Unpublished  
trigger: UC0011 — created or edited as part of authoring a Campaign; no independent transition is
evidenced (Hypothesis; see Open Questions).

---

## Attributes

### System-managed attributes

- publish flag (boolean; required; controls whether the profile is publicly visible)

### User-provided attributes

- surname (string; required; entity label)
- first name (string; required)
- second surname (string; required; duplicate of surname — see Open Questions)
- photo (image; optional; reference to a media/file asset)

---

## Invariants

- A Campaign holds at most one Patron — see `BR-CampaignStoryLifecycle`.
- A Campaign's readiness to publish requires a Patron to be set — see `BR-CampaignStoryLifecycle`.

---

## Relationships

- EN0004 — Campaign (a Campaign references its one public Patron profile)
- EN0008 — User (the patron role, held separately from this public display profile)
- EN0006 — Contact (the patron's contact details, held separately from this public display profile)

---

## Open Questions

- Why do the surname and second-surname attributes carry the same public label — is the second
  surname attribute dead / unused?
- Is a Patron ever reused across multiple Campaigns, or is it always one-to-one with its Campaign?
- How does this public Patron profile relate in practice to the patron User role and the patron
  Contact — is presentation data duplicated across the three, and if so, how is consistency kept?
- No confirmed use case traces a Patron-specific creation or edit path independently of Campaign
  authoring; the transition trigger above is a Hypothesis, not a Confirmed flow.
