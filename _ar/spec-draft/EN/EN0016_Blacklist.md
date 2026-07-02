---
doc_id: EN0016
title: Blacklist
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — the case a blacklist entry is linked to
  - EN0006  # Contact — the party a list entry classifies
  - EN0008  # User — the author of a list entry
  - BR-ScoringAndRiskGating          # blacklist creation, gating, propagation to Contact
  - BR-PartyIdentityAndDeduplication # e-mail-keyed propagation hazard (no party uniqueness)
  - UC0003  # Assess Applicant Risk (Scoring) — creates and reads Blacklist entries
---

# EN0016 — Blacklist

## Purpose

A Blacklist entry records a risk classification decision made against a specific party role
(fundraiser, patron, gift, or spotter) named on an Application (EN0001). It captures the
classification itself (a white-list tier or a full block) together with denormalised identity
details for the classified party, used to match the classification back onto that party's
Contact (EN0006) record. Blacklist entries are the durable record of scoring decisions produced
during risk assessment (see BR-ScoringAndRiskGating).

---

## Lifecycle

- Active — the entry exists as an immutable classification record.

There is no further lifecycle state machine for a Blacklist entry: it is not evidenced to be
updated or removed after creation (Open Question — append-only status is unconfirmed).

---

## State Transitions

(none) → Active
trigger: UC0003 — Assess Applicant Risk (Scoring), manual scoring sub-flow (creation of a
blacklist classification entry)

No further transitions are evidenced.

---

## Attributes

### System-managed attributes

- author (reference to EN0008 – User; required; the user who recorded the classification)
- created (timestamp; system-recorded creation time)
- changed (timestamp; system-recorded last-modification time)

### User-provided attributes

- classification (enumeration; required; values: ZD, Z, N — white-list tiers — or Black List;
  see BR-ScoringAndRiskGating for how a classification is derived and gated)
- party role (enumeration; required; values: fundraiser, patron, gift, spotter — the role being
  classified)
- application (reference to EN0001 – Application; required; the case the classification decision
  belongs to)
- first name / last name (text; optional; identity detail of the classified party)
- national identification number (text; optional; identity detail of the classified party)
- e-mail (text; optional; identity detail used to match the classification onto a Contact)
- phone (text; optional; identity detail of the classified party)
- company name / company identification number (text; optional; identity detail when the
  classified party is an organisation)
- note (text; optional; free-text annotation)

---

## Invariants

- Every Blacklist entry must be linked to an Application (EN0001) — see BR-ScoringAndRiskGating.
- A Blacklist entry's classification is created together with the Application's status change and
  the corresponding Contact (EN0006) classification write, as one recorded scoring outcome — see
  BR-ScoringAndRiskGating.
- The propagation of a Blacklist entry's classification onto a Contact (EN0006) is matched by
  e-mail address and is not scoped to a single, uniquely identified Contact — see
  BR-PartyIdentityAndDeduplication.

---

## Relationships

- EN0001 — Application (required; the case the entry classifies a party against)
- EN0006 — Contact (the party record whose classification is updated from this entry's
  classification value)
- EN0008 — User (the author who recorded the entry)

---

## Open Questions

1. Is a Blacklist entry ever updated or removed after creation, or is the record append-only? No
   delist path is evidenced.
2. Can the e-mail-keyed propagation onto Contact (EN0006) affect Contact records unrelated to the
   party actually being classified? Tracked as a hazard under BR-PartyIdentityAndDeduplication;
   scope of impact is not fully evidenced.
3. Some configuration surfaces reference identity/classification fields not present on this
   entity's confirmed attribute set — whether any live behaviour depends on them is unconfirmed.
