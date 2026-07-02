---
doc_id: MSG0014
title: Collection Successful Notification
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0011
  - UC0006
references:
  - EN0004
  - EN0001
  - EN0022
  - ES0006
  - FN0019
---

# MSG0014 – Collection Successful Notification

## Purpose

Tell the Parent (Žadatel) and the Patron that the Story's (Campaign, EN0004) fundraising target has
been reached — the collection is successful — and that the back-office next steps (contract
preparation, gift purchase) will follow. This is the high-salience completion message for the
Campaign lifecycle, distinct from the generic status-driven catch-all (MSG0005/MSG0006): it marks the
moment the fundraising goal is met, not an arbitrary status transition.

---

## Trigger

- UC0006 (Confirm Payment — Gateway Callback), shared step UC0006.4.9: on any confirmed payment that
  brings the Campaign's (EN0004) recomputed raised amount to or above its target amount, the System
  marks the Campaign and its owning Application (EN0001) complete and — in production — sends the
  campaign-success confirmation.
- UC0011 (Manage Campaign/Story Lifecycle), UC0011.1 step 7: the same completion transition is also
  evaluated as a side effect of any Campaign save (e.g. publication), not only from a payment
  callback, though a PAID contribution is the most common trigger in practice.
- Firing status: the Application (EN0001) / Campaign (EN0004) reach the `completed` status ("Vybráno"),
  per the Notification Matrix (`intake/test-scenarios/test-scenarios.md`, Notification Matrix sheet,
  row `completed`) and SC-8A steps 1–4 (collection reaches 100% of target → status changes to
  "successful story" → success emails sent to Parent and Patron).

---

## Recipients

- **Parent / Žadatel** — email (Notification Matrix: `completed` / Parent → Email = YES) via ES0006
  (Mautic), plus in-zone notification (Parent Zone) (Notification Matrix: `completed` / Parent →
  in-zone = YES; SC-8A step 3 in-zone = YES — the two sources agree for the Parent).
- **Patron** — email (Notification Matrix: `completed` / Patron → Email = YES) via ES0006 (Mautic).
  Both sources agree the Patron is emailed. **The Patron in-zone channel is a Conflict — requires
  clarification:** SC-8A step 4 marks the Patron in-zone Notification column YES, while the
  Notification Matrix row `completed` / Patron marks in-zone (User account notification) = NO. Not
  resolved silently here, per anti-hallucination policy; the Matrix is the authoritative
  recipient/channel source but the disagreement is recorded rather than overridden.

Both parties are notified by email on the same event. No RO/MD content variant is evidenced beyond
the general per-country template resolution already documented at the capability level (FN0019); this
document does not assert RO/MD-specific wording.

**Evidence conflict on the CZ delivery path (Partial):** per FLW0019 (failure-mode findings), the
completion event also fires two additional templates on the CZ path (identifiers evidenced in the
underlying flow dossier as commented out of the current CZ template map), which resolve to unknown
template names and hit the drop path rather than being transmitted in CZ. The status-driven
completed-status fan-out email (the general status-change mechanism, MSG0005) still fires
independently for the `completed` status/role. Net effect: it is Confirmed that the Parent and Patron
are notified of the `completed` status by email (via the status-fan-out mechanism), and the Parent
also in-zone; the Patron in-zone channel remains the source Conflict recorded under Recipients above.
It is Conflict / Uncertain whether the intended dedicated "collection successful" template content (as
opposed to the generic status message) actually reaches the recipient in the CZ deployment. Recorded
here rather than resolved silently, per anti-hallucination policy.

The completion-triggered send additionally sits behind the same production/allow-list send-gate as
all transactional email (FN0019 Constraints) — a non-production, non-allow-listed environment archives
but does not transmit either message.

---

## Message Content

Conceptually, the message carries:

- Confirmation that the Story's (Campaign, EN0004) fundraising collection has reached 100% of its
  target amount — the collection is successful.
- An indication that back-office next steps are coming: contract preparation and purchase of the
  gift, so the recipient knows the process continues rather than having ended.
- Implicit identification of the subject Story/Application (EN0004 / EN0001) so the recipient
  recognises which case reached its goal, consistent with the corresponding in-zone status view
  showing the "Vybráno" (completed) state in both the Parent Zone and the Patron Zone.

No fixed subject-line text, template identifier, or body markup is asserted in this canonical
document (see rules-MSG restrictions); the two candidate dedicated-template identifiers observed in
the flow evidence are recorded only as an implementation-conflict note above, not as message content.

Whether an EmailArchive (EN0022) record exists for a given dispatch attempt — and whether its presence
indicates delivery versus send-gate suppression — is governed by the archiving and send-gate mechanics
owned by FN0019 (see FN0019 Constraints), not restated here. Consequently the two candidate
dedicated-success templates recorded (in the flow evidence) as commented out of the CZ map (see
Recipients) may leave no archive trace on the CZ path — an FN0019 / FLW0019 evidence limitation, not
part of this message's intended contract.

---

## Notes / Uncertainty

- Evidence Level: Confirmed for the trigger condition (raised amount ≥ target → `completed` status)
  and for the existence of a dedicated success-notification intent (SC-8A steps 3–4; UC0006.4.9;
  UC0011.1 step 7). Partial / Conflict for which concrete template content actually reaches CZ
  recipients, given the commented-out dedicated success templates recorded in FLW0019 — see
  Recipients section above.
- This MSG is intentionally scoped to the `completed` ("Vybráno") milestone only; the subsequent
  back-office steps referenced in its content (contract, payment, feedback) are each covered by their
  own dedicated messages (contract/signature, donation confirmation, feedback) and are not restated
  here.
