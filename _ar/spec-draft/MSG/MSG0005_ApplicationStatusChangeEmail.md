---
doc_id: MSG0005
title: Application Status-Change Email
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
references:
  - EN0001
  - EN0026
  - EN0004
  - EN0022
  - ES0006
---

# MSG0005 – Application Status-Change Email

## Purpose

Notify the Parent (Žadatel/fundraiser) and/or the Patron by email whenever the Application (Žádost),
EN0001, is saved into a status whose configured reaction has the email channel enabled for that
role. This is the single, status-and-role-parameterised transactional email that sits behind the
majority of rows in the Notification Matrix (`intake/test-scenarios/test-scenarios.md`, "Notification
Matrix" sheet): one generic message contract, instantiated differently per status × role, rather than
a dedicated message per status.

---

## Trigger

UC0002 (Orchestrate Application Status Change) — specifically the downstream reaction fan-out
(UC0002.2): on every save of the Application (EN0001) into a new status, the System looks up the
matching ApplicationReaction (EN0026) configuration for that status and role, and — where that
reaction has its email flag enabled — dispatches this status-driven email.

This MSG covers every status listed in the Notification Matrix whose Email column is `YES` for the
Parent and/or Patron role and which does **not** have its own dedicated MSG document for a
higher-salience intent (application submission, scoring decision, contract, gift/donation
confirmation, etc. — see those specific MSGs). After the higher-salience statuses were broken out
into dedicated MSGs, the **residual** set genuinely owned by this catch-all — statuses that NO
dedicated MSG claims as a trigger (per the Notification Matrix) — is: `canceled_application`,
`canceled_lead`, `duplicate`, `feedback_received`, `gift_confirmation_approved`, `refiled`,
`waiting_for_protocol`. The exact status set is config-driven (ApplicationReaction, EN0026) and may
extend beyond this evidenced residual list; this MSG is deliberately kept broad rather than exploded
into one document per status.

Statuses previously folded into this catch-all that now carry a distinct, high-salience intent have
been **superseded and removed** from here and are owned by their dedicated MSGs: `to_check` /
`waiting_for_patron` / `waiting_for_fundraiser` (MSG0001); `reminder_*` / `waiting_reminder_*`
(MSG0007); `returned_new_patron*` (MSG0008); `waiting` (MSG0009); `out_of_scope` (MSG0010);
`scoring_ko` (MSG0011); `in_progress` (MSG0012); `completed` (MSG0014); `campaign_uncompleted`
(MSG0015); `canceled_campaign` (MSG0016); `canceled_timeout` / `canceled_fundraiser` (MSG0017);
`canceled_by_user` (MSG0018); `waiting_signature*` / `contract_signed` (MSG0027);
`waiting_feedback_reminder_*` (MSG0029). Refer to those doc_ids for the message contract of each.

Evidence Level: Confirmed for the existence and status/role-gated shape of the mechanism (UC0002,
EN0026, Notification Matrix cross-checked); Partial for the complete enumeration of which statuses
currently have the email flag on, since that is live configuration data, not fixed code — the list
above is Notification-Matrix-evidenced, not exhaustive by construction.

---

## Recipients

Per the status × role combination configured on the matching ApplicationReaction (EN0026):

- **Parent (Žadatel/fundraiser)** — email via ES0006 (Mautic), where the Notification Matrix marks
  Email = YES for that status under the Parent column.
- **Patron** — email via ES0006 (Mautic), where the Notification Matrix marks Email = YES for that
  status under the Patron column.

A given status may enable email for one role only, both roles, or neither (in which case only the
in-zone/in-app notification fires — out of scope for this MSG). Recipient address is resolved from
the recipient's User/Contact account or the application-profile email held on the Application
(EN0001). CZ is the evidenced primary market; RO/MD variants are not separately evidenced for this
message beyond the per-country template resolution already documented at the capability level
(FN0019) — no RO/MD-specific content differences are asserted here.

---

## Message Content

The message is data-driven per status × role reaction (ApplicationReaction, EN0026) rather than
carrying one fixed body. Conceptually, each instance of this message carries:

- A status/subject message identifying the new state of the Parent's or Patron's case (e.g. "Žádost
  zpracováváme", "Duplikát", "Zrušená žádost", "Schváleno", "Potvrzené převzetí daru", "Vyplňte
  žádost", "Nahrajte smlouvu" — exact literal text is configuration data per status/role, not asserted
  as fixed template copy here).
- Identification of the subject Application (EN0001) and, where relevant, its associated child/Story
  (Campaign, EN0004) so the recipient can recognise which case the message concerns.
- A pointer directing the recipient back to their zone (Parent zone / Patron zone) to see the full
  detail and any required next action, consistent with the paired in-zone notification that
  frequently accompanies the email for the same status/role.

No fixed subject-line text, body markup, or template structure is asserted in this canonical
document — the concrete wording is instance data per ApplicationReaction (EN0026) and is out of scope
for the MSG layer (see rules-MSG.md restrictions).

Every dispatch of this message is archived as an EmailArchive (EN0022) record regardless of whether
the send is actually transmitted; the archive cannot distinguish a delivered send from one suppressed
by the environment send-gate (see FN0019 Constraints) — this is a known evidence limitation, not part
of the message's intended contract.

---

## Notes

- This is the grouped/catch-all status email: deliberately not exploded into a separate MSG per
  status row of the Notification Matrix (~117 rows collapse into role×status configuration on a
  single message mechanism). Statuses judged to carry a distinct, high-salience intent are broken out
  into their own MSG documents (application submission/received, scoring decision, contract/signature,
  donation/gift confirmation, GDPR, etc.) and have been **superseded and removed** from this catch-all
  — see MSG0001, MSG0007, MSG0008, MSG0009, MSG0010, MSG0011, MSG0012, MSG0014, MSG0015, MSG0016,
  MSG0017, MSG0018, MSG0027, MSG0029 (per the Trigger section). This MSG owns only the residual set
  (`canceled_application`, `canceled_lead`, `duplicate`, `feedback_received`,
  `gift_confirmation_approved`, `refiled`, `waiting_for_protocol`).
- Dispatch is synchronous within the Application (EN0001) save request (UC0002 fan-out); a failure in
  a later reaction in the same fan-out pass does not retroactively un-send an email already dispatched
  earlier in the sequence (see UC0002 AF2).
- Evidence Level for the overall mechanism: Confirmed. Evidence Level for the complete status
  enumeration and for any RO/MD content variance: Partial — configuration-dependent and not fully
  visible from the cited sources.
