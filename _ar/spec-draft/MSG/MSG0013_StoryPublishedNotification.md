---
doc_id: MSG0013
title: Story Published Notification
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0011
references:
  - EN0004
  - EN0001
  - EN0022
---

# MSG0013 – Story Published Notification

## Purpose

Tell the Parent (Žadatel) and the Patron that the child's Story (Campaign, EN0004) has been
published and is now live on the website, and give each of them a link to view it. This is the
distinct, high-salience message tied to the Campaign's activation moment — the point at which the
case becomes publicly visible and fundraising formally begins — and is broken out from the generic
status-driven catch-all (MSG0005/MSG0006) for that reason, consistent with how other high-salience
status transitions (submission, scoring decision, contract, gift confirmation) already have their own
dedicated MSG documents.

---

## Trigger

UC0011 (Manage Campaign / Story Lifecycle), sub-flow UC0011.1 (Admin publishes / sets a Campaign
active) — the System sets the linked Application's (EN0001) status to `active` (step 10) and saves
it, which raises the application-status-change notification fan-out described in UC0011.3. The
underlying "Story published" moment is the Admin's publish action in UC0011.1 step 1 onward; the
notification fires once the Campaign is active and the Application status has been updated in lock-step.

Confirmed narratively by SC-9A ("Story Published Successfully"), steps 6–9: the Content Coordinator
publishes the story on the website, status changes to Active Story, and the System sends the
publication message to both Parent and Patron with a link to the story.

Evidence Level: Confirmed for the trigger moment and dual-party intent (UC0011, SC-9A); see
Recipients below for a recorded conflict on the exact channel.

---

## Recipients

- **Parent / Žadatel** — notified that the Story is now published, with a link to view it.
- **Patron** — notified that the Story is now published, with a link to view it.

Channel — Conflict, recorded per project instruction (code/config wins for current state): the
Notification Matrix (`intake/test-scenarios/test-scenarios.md`, "Notification Matrix" sheet, status
`active`) marks, for both the Parent and Patron rows, Email = NO and User account notification = YES
— i.e. the current-state configuration (ApplicationReaction, EN0026) delivers this message only as an
in-zone notification (Parent Zone / Patron Zone), not by email. SC-9A's narrative steps 8–9 instead
describe the System "sending email" to each party. Because the Notification Matrix is sourced from
the live `application_reaction` configuration and is the higher-authority evidence for current-state
channel behavior, the current-state contract is treated as **in-zone notification only** for both
roles; SC-9A's "email" wording is not asserted as the current channel. No email dispatch (and
therefore no ES0006/Mautic delivery or EN0022 EmailArchive record) is asserted for this message in the
current state.

No CZ/RO/MD channel variants are evidenced beyond this; the in-zone delivery mechanism is uniform
across markets in the current sources.

---

## Message Content

Conceptually, each instance of this message carries:

- A status message confirming the Story is now published/active — Notification Matrix literal:
  "Příběh je zveřejněn" (shown to both the Parent and the Patron).
- A link to the live, published Story (Campaign, EN0004) page, so the recipient can view it directly.
- Implicit case reference: shown in the context of the recipient's own Parent Zone / Patron Zone view
  of their Application (EN0001) / Story, consistent with the "Active Story" state now visible in both
  zones per SC-9A steps 10–11.

Excluded from this contract (delivery/implementation, not message content): exact copy/subject-line
text beyond the matrix literal cited above, HTML/visual presentation, and how the zone view is
refreshed.

---

## Notes / Uncertainty

- Story-change requests raised after publication (SC-9B — Parent or Patron requests story changes)
  are handled by operations staff directly and are not evidenced as producing a distinct transactional
  message of their own; not covered by this document.
- This message shares its underlying fan-out mechanism with MSG0005 (status-change email) and MSG0006
  (in-zone status notification) — same ApplicationReaction (EN0026) match on the Application's (EN0001)
  `active` status per UC0011.1 step 10–11 / UC0011.3 — but is documented separately here because the
  Campaign-publication intent is distinct and high-salience enough to warrant its own message contract,
  and because of the recorded channel conflict above, which is specific to this status and worth
  isolating rather than folding silently into the generic catch-all.
- Evidence Level: Confirmed for trigger and dual-recipient intent; Partial/Conflict for channel, as
  recorded above.
