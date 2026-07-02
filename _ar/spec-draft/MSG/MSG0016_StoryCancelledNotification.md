---
doc_id: MSG0016
title: Story Cancelled Notification
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0011
references:
  - EN0004
  - EN0001
  - EN0009
  - EN0022
  - EN0026
  - ES0006
---

# MSG0016 – Story Cancelled Notification

## Purpose

Tell the Parent (Žadatel) and the Patron that the child's Story (Campaign, EN0004) has been
cancelled — its public fundraising case is closed with no successful outcome. This is the distinct,
high-salience message tied to the Story's terminal `canceled_campaign` ("Příběh zrušen") state,
broken out from the generic status-driven catch-alls (MSG0005/MSG0006) for the same reason MSG0013
(Story Published Notification) is: cancellation of a Story is a high-salience, dual-party moment in
the case lifecycle, distinct from the routine status-change traffic those two documents cover.

Evidenced current-state causes for reaching this state:

- the Application's contract was never signed by the Parent within the allowed reminder window
  (non-cooperative case) and Operations reallocated the pledged donation to other children's Stories;
- the fundraising collection ended at 0% of the target amount and the supplier reservation was
  cancelled;
- the Parent or Patron requested the Story's removal after publication (a change request escalated to
  cancellation rather than a content correction).

---

## Trigger

UC0011 (Manage Campaign / Story Lifecycle) — the System sets the Campaign's (EN0004) and its linked
Application's (EN0001) status to `canceled_campaign` ("Příběh zrušen"), which raises the
application-status-change notification fan-out described in UC0011.3, the same mechanism that
underlies MSG0005/MSG0006.

Confirmed narratively by three current-state paths in the test-scenario evidence
(`intake/test-scenarios/test-scenarios.md`):

- SC-8B (Parent Does Not Sign Contract – Non-cooperative), steps 7–10: after the Parent fails to sign
  the contract through both reminder windows, Operations reallocates the donation, the status changes
  to `canceled_campaign`, and the System sends a cancellation notification to both Parent and Patron.
- SC-8D (Collection 0% Unfulfilled), steps 7–9: after the Coordinator cancels the supplier reservation
  and cancels the Story in the system (0% raised), status changes to `canceled_campaign` and the
  System sends a final cancellation notification to both parties.
- SC-9B (Parent or Patron Requests Story Changes), steps 5–8: a post-publication change request
  escalates to a cancellation request; the Coordinator removes the Story from the website and the
  status changes accordingly, with a cancellation notification sent to both Parent and Patron.

The Notification Matrix confirms the resolved channel/content for the `canceled_campaign` status
(both roles) and additionally lists a `canceled_by_user` status/message ("Příběh zrušen") on the
Patron row, evidenced as reaching the same "Příběh zrušen" status message as `canceled_campaign` —
recorded here as a related but not fully disambiguated status alias (see Notes).

Evidence Level: Confirmed for the trigger status (`canceled_campaign`), the dual-recipient intent, and
the three current-state causal paths (SC-8B, SC-8D, SC-9B); Partial for the exact status-code mapping
of the `canceled_by_user`/Patron matrix row (see Notes).

---

## Recipients

- **Parent / Žadatel** — notified that the Story/case has been cancelled.
- **Patron** — notified that the Story has been cancelled.

Channel, per the Notification Matrix (`canceled_campaign` rows, both Parent and Patron): Email = YES
and User account notification (in-zone) = YES for both roles — i.e. the current-state contract is
**both** an email (via ES0006, Mautic) and an in-zone notification (Parent Zone / Patron Zone) for
this status, unlike MSG0013 (Story Published) where the matrix resolves to in-zone-only. Each email
dispatch is archived as an EmailArchive (EN0022) record, consistent with the general dispatch
mechanism documented under MSG0005.

No CZ/RO/MD channel variants are evidenced beyond this; the dual email + in-zone delivery is recorded
uniformly across the cited scenarios and the Notification Matrix, without a market-specific channel
distinction in the current sources.

---

## Message Content

Conceptually, each instance of this message carries:

- A status message confirming the Story has been cancelled — Notification Matrix literal: "Příběh
  zrušen" (shown to both the Parent and the Patron for `canceled_campaign`).
- Where applicable (contract non-cooperation and 0%-collection paths per SC-8B/SC-8D), an indication
  that any donation already collected/pledged toward this Story is being redirected/reallocated to
  other children's Stories, rather than being retained against this case — this is the substantive
  fact the recipient needs in order to understand what happens to a pledge or contribution already
  made, distinct from a routine status label.
- Implicit case reference: shown in the context of the recipient's own Parent Zone / Patron Zone view
  of their Application (EN0001) / Story (EN0004), consistent with the "Příběh zrušen" / cancelled state
  now visible in both zones per SC-8B step 9 / SC-8D step 10–11.

Excluded from this contract (delivery/implementation, not message content): exact copy/subject-line
text beyond the matrix literal cited above, HTML/visual presentation, and how the reallocation of a
donation (EN0009 Transaction) to another Story is technically performed.

---

## Notes / Uncertainty

- This message shares its underlying fan-out mechanism with MSG0005 (status-change email) and MSG0006
  (in-zone status notification) — same ApplicationReaction (EN0026) match on the Application's (EN0001)
  `canceled_campaign` status per UC0011.3 — and MSG0005 already lists `canceled_campaign` and
  `canceled_by_user` among the statuses folded into its generic catch-all enumeration. It is documented
  separately here, in the same way MSG0013 (Story Published) was broken out, because Story cancellation
  is a distinct, high-salience, dual-party terminal outcome worth isolating with its own message
  contract (including the donation-reallocation content element, which the generic catch-all does not
  capture) rather than leaving it folded silently into the routine status traffic.
- Distinct from application-level cancellation messages that fire earlier in the case lifecycle before
  a Story/Campaign exists or is published (`canceled_application`, `canceled_lead`, `canceled_timeout`
  — "Žádost zrušena" / "Zrušená žádost") — those are Application/Lead-stage cancellations, out of scope
  for this document, and remain covered by the MSG0005/MSG0006 catch-all.
- The Notification Matrix's `canceled_by_user` row for the Patron role resolves to the same status
  message ("Příběh zrušen") as `canceled_campaign`, with Email = YES / User account notification = NO
  for that specific row — narrower than the full `canceled_campaign` channel pair. Evidence is
  insufficient to state definitively whether `canceled_by_user` is a distinct trigger path or an alias
  surfaced through the same cancellation outcome as SC-9B (Parent/Patron-requested cancellation); left
  as an open alignment question rather than asserted as identical. The Parent-role `canceled_by_user`
  row ("Zrušeno žadatelem") carries a different status message and is not treated as part of this
  Story-cancellation message.
- Evidence Level: Confirmed for the `canceled_campaign` trigger, dual-recipient intent, dual-channel
  delivery, and donation-reallocation content element (SC-8B, SC-8D); Partial for the `canceled_by_user`
  alias relationship noted above; SC-9B confirms the request-driven cancellation path narratively but
  without the same explicit channel detail as SC-8B/SC-8D (its own matrix columns in that sheet show
  NO/NO throughout, in apparent tension with the canonical Notification Matrix's YES/YES for
  `canceled_campaign` — recorded as a Conflict, with the canonical Notification Matrix sheet treated as
  higher authority for current-state channel behavior per project instruction).
