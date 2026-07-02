---
doc_id: MSG0004
title: Magic-Link Login
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0014
references:
  - EN0008
  - ES0006
---

# MSG0004 – Magic-Link Login

## Purpose

Give an existing account holder a passwordless way back into their zone: on request, the platform
sends a one-time login link to the account's registered email address so the holder can open an
authenticated session without entering a password [UC0014].

---

## Trigger

UC0014 – Authenticate & Manage Access — specifically the on-demand magic-link creation path
(UC0014.1's magic-link branch; the create-magic-link request against an existing User account).
This is **user-initiated**, not fired by an Application/Story/Lead status transition — it has no
corresponding row in the status-driven Notification Matrix, unlike most other MSG documents in this
layer.

Distinct from account activation for a newly created account (a separate message concept, not
covered by this document): MSG0004 concerns repeat sign-in to an **existing** User (EN0008), not
first-time activation of a new one.

---

## Recipients

- The requesting account holder — the person identified by the User (EN0008) account for which the
  magic-link was requested. Any zone role that holds a User account (applicant/patron, fundraiser,
  supporter, admin, etc. per EN0008) may be a recipient; the message is not role-specific.
- Channel: email only, sent via the platform's transactional-messaging capability over Mautic
  (ES0006). No in-zone notification counterpart is evidenced for this message — it cannot be
  delivered in-app because, by definition, the recipient is not yet authenticated.
- No CZ/RO/MD content variance is evidenced beyond the general per-country template resolution that
  applies to all transactional messages [ES0006; FN0019].

---

## Message Content

The conceptual information elements the message must carry:

- A single-use login link that, when opened, authenticates the requesting account holder directly
  into their zone (no password entry required).
- An indication that the link is time-limited and will stop working after its validity window
  elapses, so the recipient knows to request a fresh one if it has expired.
- Enough context for the recipient to recognize the message as a sign-in link they (or someone using
  their email address) requested, distinguishing it from a password-reset or account-activation
  message.

No template markup, subject-line wording, or styling is specified here — those are delivery/template
concerns owned by the outbound transport, not this contract [ES0006].

---

## Uncertainty / Notes

- Not represented as a row in the intake Notification Matrix (`test-scenarios.md`), which is
  status-driven; this message is triggered directly by a login-related API call rather than by an
  Application/Story/Lead status change. Its existence and shape are grounded instead in UC0014 and
  the underlying flow evidence (FLW0014), which is `Confirmed`.
- The evidence trail for magic-link *creation itself* is `Partial`: the flow dossier records a
  latent defect in a related hash-based login branch and inconsistent flood-control enforcement
  across endpoint versions, but the message-dispatch step for magic-link creation (email out via the
  transactional-messaging capability) is itself corroborated and not implicated in that defect.
- Kept broader deliberately: evidence does not establish any role-specific or country-specific
  content variation for this message beyond generic per-country template resolution common to all
  transactional messages [FN0019]; none is asserted here.
