---
doc_id: MSG0030
title: Donor Feedback / Post-Campaign Thank-You
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - FN0006
references:
  - FN0006
  - FN0019
  - EN0021
  - EN0004
  - EN0009
  - EN0022
  - ES0006
---

# MSG0030 – Donor Feedback / Post-Campaign Thank-You

## Purpose

Close the loop with a Story's Donors after a campaign has been funded: deliver the Parent's own
account of how the child's gift was used (or, where the Parent did not cooperate, a generic
thank-you in its place) so that Donors see the outcome of the donation they made. This is the
donor-facing counterpart of the feedback stage of the Campaign/Story lifecycle — distinct from the
in-zone/email prompts that ask the Parent to *submit* feedback (owned elsewhere; see Notes).

---

## Trigger

FN0006 (Campaign / Story Lifecycle Management) — the post-campaign feedback stage of a Campaign's
(EN0004) lifecycle, which maintains the collected Feedback (EN0021), at the point the Content
Coordinator sends that Feedback on to the Story's Donors and the Application/Campaign status is set to
`feedback_sent` ("Poděkování dárcům odesláno" / "Zpětná vazba odeslána").

Two evidenced paths lead to this send:

- **Personal feedback**: the Parent supplied feedback (via the system, by email, or as a video link)
  and the Content Coordinator forwards that specific content to the Story's Donors.
- **Universal feedback**: the Parent did not cooperate within the feedback window (after the
  reminder sequence), and the Content Coordinator sends a universal/generic thank-you to the Story's
  Donors instead of a personal account.

Evidence: `intake/test-scenarios/test-scenarios.md` — SC-9C (steps 5, 6, 9, 14, 15) and SC-9D (steps
4, 5); Notification Matrix rows for status `feedback_sent` (Email→Donor = YES, Notification→Donor =
YES).

---

## Recipients

- **Donors of the Story** — the party who financially supported the specific Campaign (EN0004) this
  feedback concerns. Delivered by email via ES0006 (Mautic).

The `feedback_sent` status change is also reflected to the Parent and Patron, but only as an
in-app/zone signal, not as an email to them (Notification Matrix: Email→Parent = NO, Email→Patron =
NO for `feedback_sent`) — that in-zone reflection is covered by MSG0006, not by this document. This
MSG covers only the outbound send to the Story's Donors, which is the actual transactional message
carrying feedback content.

No CZ/RO/MD content-variant is evidenced for this message beyond the general per-country template
resolution already documented at the capability level (FN0019); the underlying feedback-stage status
flow is shared across markets in the cited sources.

---

## Message Content

Conceptually, each instance of this message carries:

- A thank-you to the Donor for supporting the Story (Campaign, EN0004).
- The substance of the Parent's feedback on how the gift/support was used — in the personal-feedback
  path, this is the Parent's own account (text description, and/or photos, and/or a video reference)
  of the outcome; in the universal-feedback path, this is a generic thank-you/closing message used in
  place of a personal account because no Parent-authored feedback was available in time.
- Identification of which Story (Campaign, EN0004) the feedback/thank-you relates to.

No fixed subject-line text, body markup, or template structure is asserted here — concrete wording is
instance/configuration data and out of scope for the MSG layer. Every dispatch is archived as an
EmailArchive (EN0022) record, per the transactional-messaging capability's general archiving
behavior.

---

## Notes / Uncertainty

- **Distinct from the feedback-request message.** This document covers the outbound message *to
  Donors* carrying the feedback/thank-you. It is not the message that asks the Parent to *submit*
  feedback in the first place, nor either of the two feedback reminders sent to the Parent — those
  are a separate message intent (requesting content from the Parent) and are covered elsewhere, not
  by this document.
- **Personal vs. universal feedback are one message type, not two.** Per the grouping rule for this
  synthesis pass, the personally-authored feedback send and the universal/generic thank-you send (used
  after non-cooperation, per SC-9D) are treated as one canonical message — same trigger point (status
  → `feedback_sent`), same recipient set (the Story's Donors), same structural content (thank-you +
  outcome account), differing only in whether the outcome account is Parent-specific or generic.
- **Underlying Feedback entity's send mechanics are Partial evidence.** EN0021 (Feedback) records a
  `sent` timestamp on a feedback-form path, and the reconstructed dispatch flow is not fully traced
  end-to-end from a Content Coordinator's send action through to the per-Donor email dispatch
  (contrast with MSG0019/UC0006, where the send trigger is fully mined). This document is grounded in
  the Notification Matrix's status/role/channel evidence (SC-9C, SC-9D) and the general transactional-
  messaging/EmailArchive mechanics (FN0019, EN0022), and is anchored on the capability that owns the
  post-campaign feedback stage (FN0006) rather than on a specific numbered use-case step, because **no
  mined UC step names this donor-facing send explicitly.** In particular, UC0011 (Campaign/Story
  lifecycle) contains only publish / deadline-expiry / auto-completion / reindex steps and no feedback
  step, and UC0002 only *creates* the feedback session — neither UC mines the outbound send to Donors,
  so this MSG intentionally does not cite a UC as its trigger.
- **Video-feedback intake (SC-9C options B/C) is an internal content-handling process** (email
  forwarded to an Info Coordinator, then to a Social Media specialist, then a YouTube link inserted by
  the Content Coordinator) that produces the same outbound Donor message once ready; the intake
  mechanics themselves are not part of this message's contract.
- **Recipient set is the Story's Donors as a group**, not a named individual; the exact resolution
  logic for "all Donors of this Story" (e.g. one-time vs. recurring donors, minimum-donation
  thresholds) is not evidenced in the cited sources and is not asserted here.
- Evidence Level: Confirmed for the trigger status (`feedback_sent`), the recipient role (Donor,
  email channel), and the two content variants (personal / universal), per SC-9C and SC-9D. Uncertain
  for the exact internal dispatch step and for any fine-grained content fields beyond thank-you +
  outcome account + Story identification.
