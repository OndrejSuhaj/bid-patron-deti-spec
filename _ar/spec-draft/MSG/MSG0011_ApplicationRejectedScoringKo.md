---
doc_id: MSG0011
title: Application Rejected — Scoring KO
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
  - UC0003
references:
  - EN0001
  - EN0017
  - EN0022
  - ES0006
---

# MSG0011 – Application Rejected — Scoring KO

## Purpose

Inform both parties on an Application (EN0001) — the Parent/Žadatel and the Patron — that Risk
Management has reviewed the case, found disqualifying information, and rejected it at the scoring
stage. The message closes the case for both parties courteously; it does **not** disclose the
disqualifying detail that led to the rejection (that detail stays internal to the Scoring Record,
EN0017, and the Risk Manager's review notes).

---

## Trigger

UC0003 (Assess Applicant Risk / Scoring) — the Risk Manager's manual scoring decision, where the
Admin submits the scoring form with an approval outcome other than "approved" while disqualifying
information has been identified (Notification Matrix / SC-5C steps 1–5: Risk Manager reviews,
documents disqualifying information, rejects, and the Application's status becomes `scoring_ko`;
SC-5D step 13: the same rejection outcome reached after an additional-information request found the
supplied information insufficient) — followed by UC0002 (Orchestrate Application Status Change),
whose downstream reaction fan-out (UC0002.2) dispatches this message once the Application (EN0001)
is saved into the `scoring_ko` status, for every role whose matching ApplicationReaction (EN0026) has
the email channel enabled.

Evidence Level: Confirmed for the `scoring_ko` status, its firing role set, and its email dispatch,
via the Notification Matrix (`intake/test-scenarios/test-scenarios.md`) rows `scoring_ko` / Parent and
`scoring_ko` / Patron (both Email = YES) and via SC-5C steps 3–5 ("System: Changes status to 'Scoring
KO'" → "System: Sends rejection email to Parent" → "System: Sends rejection email to Patron"). Partial
for the exact UC0003 step that names the `scoring_ko` transition itself: UC0003's cited Main
Flow/Alternative Flows document the approval path to `scoring_ok` (Main Flow step 10; AF3) and an
"approval gate not met" path (AF2) that leaves the Application's state unchanged, without naming
`scoring_ko` as its target state in the UC0003 dossier text; the `scoring_ko` transition and its
disqualifying-information precondition are evidenced directly by the Notification Matrix and the
SC-5C/SC-5D acceptance scenarios rather than restated verbatim in UC0003 — recorded here as a
cross-source gap, not resolved by inference.

---

## Recipients

- **Parent / Žadatel** — email via ES0006 (Mautic) + in-zone notification ("Neschváleno" — Parent
  Zone), per the Notification Matrix row `scoring_ko` / Parent (Email = YES, User account notification
  = YES).
- **Patron** — email via ES0006 (Mautic) + in-zone notification ("Neschváleno" — Patron Zone), per the
  Notification Matrix row `scoring_ko` / Patron (Email = YES, User account notification = YES).

Both parties receive both channels for this status — unlike many other status-driven messages in the
Notification Matrix that fire only one channel or only one role. CZ is the evidenced market for this
message (SC-5C/SC-5D); no RO/MD content variance is asserted here beyond the standard per-country
template resolution already recorded at the capability level (FN0019) — the RO/MD equivalent status
labels are recorded in the status model, not restated here.

---

## Message Content

Conceptually, each dispatch of this message carries:

- **Rejection notice** — a plain statement that the Application (EN0001) was reviewed by Risk
  Management and was **not approved**; the case is closed at this step.
- **Case reference** — identification of the subject Application (EN0001) and its associated
  child/Story so the recipient recognises which case the message concerns, consistent with the
  paired in-zone "Neschváleno" notification.
- **Courteous close** — an acknowledging/closing tone appropriate to a rejection, without assigning
  blame or inviting resubmission (no evidence of a resubmission path being offered from `scoring_ko`
  in the cited sources).

Explicitly excluded from the message content (kept internal, not disclosed to Parent or Patron):

- The disqualifying information itself (blacklist match, fraud indicator, or other Risk
  Manager-documented reason) — this remains in the internal Scoring Record (EN0017) and Risk Manager
  notes; the SC-5C evidence keeps this documentation-only ("Issue documented in Scoring Card notes"),
  never surfaced in the outbound message.
- Any scoring score, breakdown, or blacklist classification detail (owned by EN0017 / EN0016 — not a
  message-layer concern).

No fixed subject-line text, body markup, or template structure is asserted in this canonical document
(see rules-MSG.md restrictions); the concrete wording is instance data resolved per the
`scoring_ko` × role ApplicationReaction (EN0026), consistent with the mechanism documented in MSG0005.

Every dispatch is archived as an EmailArchive (EN0022) record regardless of whether the send is
actually transmitted, per the same archiving behaviour documented for MSG0005.

---

## Notes

- **Distinct from MSG0010** (out-of-scope rejection — a different disqualifying status/intent, not
  covered by this document) and from **MSG0012** (the `scoring_ok` approval counterpart). Although
  `scoring_ko` would otherwise fall inside the broad status catch-all of MSG0005 (which lists
  `scoring_ko` among its folded-in statuses), this rejection is broken out into its own MSG document
  here because of its distinct, higher-salience intent (a definitive negative risk decision reaching
  both parties on both channels) — MSG0005's enumeration should be read as superseded for `scoring_ko`
  by this dedicated document.
- The approval counterpart (`scoring_ok`) sends **no email** to either party — confirmed by the
  Notification Matrix rows `scoring_ok` / Parent and `scoring_ok` / Patron (Email = NO for both) and by
  SC-5A step 27 / SC-5B step 26, which show only the in-zone "approved" message; see MSG0012 for that
  message's contract.
- Evidence Level for the overall mechanism (status, roles, channels, in-zone label "Neschváleno"):
  Confirmed (Notification Matrix + SC-5C/SC-5D). Evidence Level for the precise transition mechanics
  inside UC0003 that produce `scoring_ko`: Partial (see Trigger section) — flagged as a cross-source
  gap between the UC0003 dossier and the Notification Matrix/SC-5C evidence, not silently resolved.
