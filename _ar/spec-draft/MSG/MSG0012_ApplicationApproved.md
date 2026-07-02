---
doc_id: MSG0012
title: Application Approved
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
  - UC0003
references:
  - EN0001
  - EN0022
  - EN0026
  - ES0006
---

# MSG0012 – Application Approved

## Purpose

Tell the Parent (Žadatel/fundraiser) and the Patron that their Application (EN0001) has cleared risk
assessment and been approved — scoring is OK — and that the case now proceeds toward story
preparation. This is the approval milestone message: distinct from the generic status-driven catch-all
(MSG0005/MSG0006) because reaching "scoring OK" is a key decision point in the case lifecycle (risk
gate passed), even though, per current evidence, it is communicated almost entirely in-zone rather than
by email.

---

## Trigger

- UC0003 (Assess Applicant Risk) — the Application's (EN0001) state advances to "scoring approved"
  (`scoring_ok`), either via the manual approval gate (Admin/Risk reviewer sets an "approved" decision
  while the Application is in "scoring") or via the automatic low-risk recalculation path when the
  qualifying threshold is met and confirmed.
- UC0002 (Orchestrate Application Status Change) — the downstream reaction fan-out (UC0002.2) that
  resolves the ApplicationReaction (EN0026) for the new status and role, which is the mechanism that
  actually surfaces this message to each party.
- Evidenced firing statuses: `scoring_ok` (both Coordinator low-risk approval and Risk Manager full
  review approval reach this status — acceptance scenarios SC-5A and SC-5B) and `in_progress`
  ("Schváleno"), which the Notification Matrix records as a distinct status carrying the same
  "approved" semantic with a different channel mix.
- **Hypothesis — in_progress grouped here by matching Matrix status text; its lifecycle relation to
  `scoring_ok` is not confirmed by EN0001 or a cited UC transition.** `in_progress` is folded into
  this "approved" message family solely because its Notification-Matrix status text ("Schváleno")
  matches the approval semantic; no reconstructed transition from `scoring_ok` to `in_progress` is
  evidenced.

---

## Recipients

**Hypothesis — in_progress grouped here by matching Matrix status text; its lifecycle relation to
`scoring_ok` is not confirmed by EN0001 or a cited UC transition.** The `in_progress` recipient/channel
rows below are attached to this MSG on the strength of the "Schváleno" Matrix text alone.

- **Parent / Žadatel** — in-zone notification in the Parent Zone: "Vaše žádost byla schválena" at
  `scoring_ok`; email at `in_progress` ("Schváleno") per the Notification Matrix (Email = YES for
  Parent at `in_progress`).
- **Patron** — in-zone notification in the Patron Zone: "Žádost byla schválena" at `scoring_ok`; also
  notified in-zone at `in_progress` ("Schváleno"); no email to Patron is evidenced for either status.

At `scoring_ok`, both sources agree there is **no email** to Parent or Patron — the approval is visible
by logging into the zone (SC-5A step 13–14 and SC-5B step 25–27 show the approval surfaced as a zone
message with no accompanying email). **Conflict — requires clarification (in-zone channel):** the
Notification Matrix rows for `scoring_ok` (test-scenarios.md rows 797–798) record "User account
notification = NO" for both Parent and Patron, whereas SC-5A/SC-5B show the zone displaying the approval
message. This MSG follows the acceptance-scenario evidence (a live zone display is stronger than a Matrix
flag whose exact semantics — push/badge vs passive status display — are unconfirmed), but the
discrepancy is recorded, not resolved. Channel for the in-zone variant is internal (zone view); channel
for the `in_progress` email variant is ES0006 (Mautic).

No RO/MD-specific content or channel variance is evidenced for this message beyond the per-country
template resolution already documented at the capability level (FN0019).

---

## Message Content

- A statement that the Application (EN0001) has been approved / scoring is OK — phrased per role (the
  Parent view and the Patron view each carry their own resolved wording per ApplicationReaction,
  EN0026, and the Notification Matrix "Status message" column; exact copy is configuration/status data,
  not restated here as fixed template text).
- Implicit indication that the case now proceeds to the next phase (story/contract preparation) rather
  than requiring further action from the recipient at this step — no explicit "action required" cue is
  evidenced for this message, unlike some other status notifications.
- Identification of the subject Application (EN0001), scoped implicitly by the party's own zone view
  (Parent Zone / Patron Zone).
- Where the `in_progress` email variant fires (Parent only), the message is archived as an EmailArchive
  (EN0022) record per the standard dispatch/archive mechanism (UC0012), regardless of whether the send
  was actually transmitted.

Excluded from this contract: exact subject-line/body copy strings, HTML/visual presentation, and
mail-provider/delivery configuration — see MSG0005 (Application Status-Change Email) and MSG0006
(In-Zone Status Notification) for the shared dispatch mechanism this message rides on.

---

## Notes / Uncertainty

- This document exists to give the approval milestone (`scoring_ok`) its own named message distinct
  from the broad status-driven catch-alls (MSG0005, MSG0006), because it is a key decision gate in the
  Application (EN0001) lifecycle. Mechanically, it is still dispatched through the same
  status/role-driven ApplicationReaction (EN0026) fan-out as MSG0005/MSG0006 — this MSG does not
  introduce a separate delivery mechanism.
- **Ownership:** MSG0012 is the dedicated owner of the `scoring_ok` and `in_progress` ("approved"
  family) statuses, split out of the MSG0005 catch-all; those statuses are pruned from MSG0005 so a
  single owner covers this approval milestone.
- `scoring_ok`: in-zone only for both Parent and Patron; email explicitly NOT sent to either role
  (Notification Matrix; SC-5A steps 11–14; SC-5B steps 23–27, with step 27 stating explicitly "NO
  emails sent to Parent or Patron at approval stage").
- `in_progress` ("Schváleno"): email = YES for Parent, in-zone = YES for both Parent and Patron, per
  the Notification Matrix. Grouped into this MSG as the same "approved" milestone semantic reaching a
  later/parallel status label in the current status vocabulary; the exact relationship between
  `scoring_ok` and `in_progress` as distinct lifecycle states is owned by the status model, not
  restated here.
- Evidence Level: Confirmed that `scoring_ok` sends **no email** to either role (both sources agree —
  SC-5A/SC-5B and the Notification Matrix). **Partial / Conflict** on the `scoring_ok` in-zone channel:
  SC-5A/SC-5B show a zone display while the Matrix records "notification = NO" — recorded as a Conflict
  above, followed toward the acceptance evidence but unresolved. The `in_progress` channel mix is per the
  Notification Matrix. Partial for whether any other status belongs to this "approved" family — kept
  narrow to the two evidenced statuses rather than extrapolated.
