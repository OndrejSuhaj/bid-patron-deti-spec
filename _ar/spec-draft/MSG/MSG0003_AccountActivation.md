---
doc_id: MSG0003
title: Account Activation (Magic-Link)
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0014
  - UC0001
references:
  - EN0008
  - EN0006
  - EN0001
  - ES0006
---

# MSG0003 – Account Activation (Magic-Link)

## Purpose

Let a first-time Patron, or a self-registering Parent/Žadatel (fundraiser) or Supporter/Donor, activate
their zone account by following a magic-link, so they can log in and act on their Application or
donation without ever being shown or asked to enter a password [UC0014; UC0001].

---

## Trigger

UC0014 – Authenticate & Manage Access (self-registration sub-flow, UC0014.2) and UC0001 – Submit
Application (Customer self-registration, UC0001.1) — the caller-triggered activation step that follows
creation of a new User (EN0008). The two triggering paths create the account in different states: the
self-registration path yields an active, password-less User; the Application-created (blocked-user)
path yields a blocked User whose activation resets a password as an internal side effect (EN0008
lifecycle). See Message Content for the recipient-facing consequences of that difference.

Fires:

- On a first-time Patron's own submission of their part of the application form (Notification Matrix
  status `waiting_for_fundraiser`, corresponding to SC-1B step 9 / SC-11B step 2 — "If it is the
  Patron's FIRST application: sends account activation email").
- On self-registration that auto-creates a Parent/fundraiser or Supporter/Donor account (Notification
  Matrix status `new`; SC-11A step 3 — "Sends account activation / welcome email to Parent").

Does **not** fire again for a party that already holds an activated account: an existing User
re-submitting is routed to their account instead of receiving a new activation message (SC-11B step 7
— "Does NOT send another activation email to already-registered Patron"; AF2 of UC0001 re-sends only a
general activation/account email, not a duplicate first-activation message, to an existing User).

---

## Recipients

- The newly (or not-yet-)activated party, by role — Patron, Parent/Žadatel (fundraiser), or
  Supporter/Donor — identified by the User (EN0008) account just created or reused, and its linked
  Contact (EN0006).
- Channel: email only, via the platform's transactional-messaging capability over Mautic (ES0006). No
  in-zone notification counterpart is possible — the recipient does not yet have an authenticated
  session to display one in.
- No confirmed CZ/RO/MD content variance beyond the general per-country template resolution applied to
  all transactional messages [ES0006]. MD's per-country template mapping may not define this message
  for every role — recorded as an open evidence gap below, not asserted as fact.

---

## Message Content

The conceptual information elements the message must carry:

- A welcome / account-activation prompt addressed to the recipient's role (Patron, Parent/fundraiser,
  or Supporter/Donor).
- An activation (magic-link) link that, when opened, activates the account and logs the recipient
  directly into their zone — no separate password entry.
- Enough context for the recipient to know where the link takes them: a new recipient continues to
  their in-progress Application form; an already-registered recipient lands in their existing account/
  zone.
- No credentials (password) are ever shown or carried in cleartext on either trigger path. The
  self-registration path leaves the account password-less; the Application-created (blocked-user) path
  performs an internal password reset as a side effect of activation (EN0008 lifecycle), but that
  password is never surfaced to the recipient — the link is the recipient-facing activation mechanism
  in both cases.

No template markup, subject-line wording, or styling is specified here — those are delivery/template
concerns owned by the outbound transport, not this contract [ES0006].

---

## Uncertainty / Notes

- Distinct from MSG0004 (Magic-Link Login): this message fires on first-time account creation/
  activation as a side effect of registration or first Patron submission (UC0014, UC0001); MSG0004
  covers an on-demand sign-in link requested against an **already-activated** existing account. Both
  share the same magic-link delivery mechanism but are triggered by different events for different
  account states.
- The activation link's validity window is long-lived (documented at the identity/access-control
  capability level, not restated here) and sending it re-activates a previously blocked account as a
  side effect — a current-state behavioural characteristic of the shared activation mechanism, not a
  property of this message's content.
- `Uncertain`: whether the activation link is single-use or remains reusable within its validity
  window is not confirmed. The link is described here neutrally (an activation magic-link) and not as
  "single-use"; the underlying mechanism appears to rely on a multi-use rehash token rather than a
  one-shot token, but this has not been confirmed in the evidence reviewed for this document — flagged
  as an open gap rather than asserted either way.
- `Uncertain`: whether the per-country template set used for this message is fully defined for the MD
  deployment for every recipient role (Patron/fundraiser/supporter) is not confirmed in the evidence
  reviewed for this document — flagged here as an open gap rather than asserted either way.
- Kept broader deliberately: the Notification Matrix and SC-1B/SC-11A/SC-11B scenarios evidence the
  trigger, recipient roles, and non-duplication behavior, but do not specify message wording or
  subject-line text, which is intentionally excluded from this contract.
