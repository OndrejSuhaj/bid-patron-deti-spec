---
doc_id: MSG0027
title: Contract for Signature & Signature Confirmation
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0004
references:
  - EN0011
  - EN0001
  - EN0022
  - ES0006
---

# MSG0027 – Contract for Signature & Signature Confirmation

## Purpose

Carry the manager-signed donation Contract (EN0011) to the Parent/Žadatel for their signature, keep
escalating with reminders while it remains unsigned, and — once the applicant has signed — confirm to
both the Parent and the Patron that the signed contract was received and the gift purchase can
proceed. This groups the whole signature hand-off/escalation/confirmation lifecycle of one Contract
into a single message-type family, distinct from the earlier manager-review step (UC0004.2, no
Parent-facing dispatch) and from the adjacent handover-protocol request (`waiting_for_protocol` — see
Notes).

---

## Trigger

UC0004 (Manage Contract And Signature) — the Application (EN0001) status-driven dispatch fires on:

- Entry into **`waiting_signature`** ("Nahrajte smlouvu" / Patron-facing "Smlouva k podpisu") when the
  Contract hands off from manager review to the fundraiser for signing (UC0004.2 steps 4–7). On the
  legacy (non-digital-signature) path, this is when the rendered Contract PDF is sent to the fundraiser
  by notification (UC0004 AF1); on the digital-signature path, this is when the in-zone signing session
  is opened for review (UC0004.3 step 1). SC-8A steps 7–9 evidence the same status entry with contract
  and signing instructions delivered to the Parent.
- Escalation into **`waiting_signature_reminder_1`** and **`waiting_signature_reminder_2`** when the
  Parent has not completed the signature within the deadline (SC-8B steps 1–3: reminder after the
  initial signing deadline, a second reminder after a further waiting period).
- Applicant signature completion, entry into **`contract_signed`** ("Podepsaná smlouva" /
  Patron-facing "Dar je na cestě") when the Customer/fundraiser completes the e-signature step
  (UC0004.3 steps 3–7) — confirming the signed Contract was received and the gift purchase proceeds
  (SC-8A steps 10–12).

Evidence Level: Confirmed for the `waiting_signature` → reminder → `contract_signed` progression and
its role/channel mapping (Notification Matrix; SC-8A; SC-8B); Partial for whether the two named
reminder statuses are always reached in sequence versus sometimes skipped (evidence shows the sequence
but not every possible path through it).

---

## Recipients

- **Parent / Žadatel** — email (via ES0006, Mautic) **and** in-zone notification for `waiting_signature`
  (Email = YES, Notification = YES). Email-only (no in-zone notification recorded) for
  `waiting_signature_reminder_1`; both email and in-zone notification for
  `waiting_signature_reminder_2`. On `contract_signed`, both email and in-zone notification (Email =
  YES, Notification = YES) confirm the signed contract was received.
- **Patron** — the Patron's dispatch differs per escalation status, traceable row-by-row to the
  Notification Matrix (see also SC-8B):
  - `waiting_signature`: in-zone notification only, no email (Email = NO, Notification = YES) — a
    passive in-zone status label ("Smlouva k podpisu").
  - `waiting_signature_reminder_1`: neither channel (Email = NO, Notification = NO) — no Patron
    dispatch on the first signing reminder.
  - `waiting_signature_reminder_2`: email only, no in-zone notification (Email = YES, Notification =
    NO) — the second signing reminder does reach the Patron by email (Matrix row
    `waiting_signature_reminder_2 | Patron`; SC-8B step 3).
  On `contract_signed`, the Patron receives an in-zone notification only ("Dar je na cestě"; Email =
  NO, Notification = YES) — no email to the Patron at this step.
- No RO/MD content variance is evidenced for this message beyond the general per-country template
  resolution already recorded at the capability level (FN0019); the cited Notification Matrix and SC-8A/
  SC-8B evidence is CZ-primary.

---

## Message Content

Conceptually, each dispatch in this family carries:

- **`waiting_signature` dispatch to the Parent**: a statement that the donation Contract (EN0011) is
  ready and requires the applicant's signature; the Contract itself — either as an attached/linked
  document for review and signature, or as an instruction to open the in-zone signing session,
  depending on which signing path applies to the tenant (UC0004 AF1 vs. UC0004.3); signing
  instructions describing how and where to complete the signature and by what deadline.
- **Signing reminder dispatches (`waiting_signature_reminder_1`, `waiting_signature_reminder_2`)**: a
  restatement that the Contract is still awaiting the Parent's signature; an escalating urgency framed
  around the approaching or missed deadline; a repeated pointer to where/how to sign.
- **`waiting_signature_reminder_2` notice to the Patron** (email only): an indication that the
  applicant has still not signed the Contract by the second reminder — keeping the Patron informed of
  the stalled signature, without contract document or signing-action detail, since the Patron is not a
  party to the Contract (Matrix row `waiting_signature_reminder_2 | Patron`, Email = YES; SC-8B step 3).
- **`contract_signed` confirmation to the Parent**: confirmation that the applicant's signature was
  received and the signed Contract is on file; that the case now proceeds to the next step (order/
  payment of the gift).
- **`contract_signed` notice to the Patron**: a simpler indication that the donation is moving forward
  ("the gift is on its way") following the applicant's signature — no document or signing detail, since
  the Patron is not a party to the Contract.

Every dispatch is archived as an EmailArchive (EN0022) record regardless of whether the underlying
send was actually transmitted, per the platform's general email-archiving behavior (see MSG0005 for the
shared archiving caveat).

No fixed subject-line text, body markup, or template structure is asserted here — concrete wording,
attachment mechanics, and signing-session presentation are implementation/instance detail out of scope
for this message contract (see rules-MSG.md restrictions).

---

## Notes

- This message groups three status points in one signature lifecycle — the initial `waiting_signature`
  delivery, its two signing reminders, and the `contract_signed` confirmation — because they are the
  same conceptual message (deliver contract → escalate → confirm signature) recurring across the
  Application's signature sub-flow (UC0004.3; SC-8A; SC-8B), not four unrelated message types.
- The mechanism by which the Contract reaches the Parent/fundraiser differs by tenant configuration:
  a digital-signature path opens an in-zone signing session for review and signing, while a legacy path
  instead sends the rendered Contract by notification with no in-zone session (UC0004 AF1). This
  message contract covers both; the delivery mechanism distinction is UC/ES-owned, not restated here.
- **`waiting_signature_uncooperative`** ("Potvrďte smlouvu pro {application:child:name}", Parent
  in-zone only per the Notification Matrix) is the terminal non-response state reached after the second
  signing reminder goes unanswered (SC-8B step 4) and is treated as a distinct escalation-closure
  notice, not part of this message's dispatch set, since it carries a different addressed-to-child
  framing and no longer requests a routine signature action; it precedes case-level resolution (contact
  attempt, then reallocation/cancellation — SC-8B steps 5–10, out of scope for this document).
- **`waiting_for_protocol`** ("Doplňte Protokol o daru", Parent email+in-zone; Patron in-zone only) is
  the adjacent handover/takeover-protocol request that concerns confirming the gift's physical
  handover, not the donation Contract's signature — a related but distinct Contract-family document
  (see glossary C039/C118) and out of scope for this message.
- Evidence Level for the overall trigger/recipient/content mechanism: Confirmed (Notification Matrix
  rows for `waiting_signature`, `waiting_signature_reminder_1`, `waiting_signature_reminder_2`,
  `contract_signed`; SC-8A steps 7–12; SC-8B steps 1–3; UC0004). Evidence Level for exact reminder
  deadline framing per dispatch: Partial — the SC-8B narrative describes deadlines (e.g., days between
  reminders) but this message contract does not restate BR/FN-owned timing rules, only that escalation
  occurs.
