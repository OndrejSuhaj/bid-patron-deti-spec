---
doc_id: MSG0023
title: Recurring Donation Charge Failed (Dunning)
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0007
references:
  - EN0009
  - EN0010
  - EN0022
  - ES0006
---

# MSG0023 – Recurring Donation Charge Failed (Dunning)

## Purpose

Notify the Donor that a scheduled recurring donation charge could not be completed — the gateway
declined or errored on the attempted charge, so the new child Transaction (EN0009) created for that
cycle was recorded as canceled instead of paid. This is a dunning-style notice: it tells the Donor
their periodic support did not go through this cycle, distinct from the success path covered by
MSG0019 (Donation Confirmation — Paid) and from a Donor's own voluntary cancellation of their
recurring schedule (MSG0021).

---

## Trigger

UC0007 (Process Recurring Donation), Alternative Flow AF1 (Gateway charge fails or is declined) —
fires only on the RO/Netopia recurring-charge path, when the Netopia gateway call for a due
RecurringTransaction (EN0010) returns a charge error and the System marks the newly created child
Transaction (EN0009) as canceled (UC0007.2 step 4; UC0007 AF1 steps 1–3).

No equivalent message is evidenced on the CZ/ComGate recurring path: a ComGate gateway failure also
results in the child Transaction being marked canceled (UC0007.2 step 4), but AF1 step 5 records no
corresponding donor notification for that path.

Evidence Level: Confirmed for the RO/Netopia leg (UC0007 AF1 step 5; FLW0007 side effects); confirmed
absent for the CZ/ComGate leg (same evidence, explicit non-equivalence).

---

## Recipients

- **Donor** — email, via ES0006 (Mautic). This is the sole party and channel
  addressed by this message; it is not sent to the Parent, Patron, or any operations role, and no
  in-zone notification counterpart is evidenced for it.
- RO-only: this message fires exclusively on the RO (Netopia) recurring-charge path. No CZ variant of
  this message exists (see Trigger); no MD recurring-cron path is evidenced at all for UC0007, so no
  MD variant can be asserted either way.

---

## Message Content

Conceptually, each instance of this message carries:

- Notice addressed to the Donor that their periodic (recurring) donation charge for this cycle could
  not be completed / was canceled.
- Implicit prompt that the Donor's continued recurring support may require attention (e.g. renewing
  or updating how the recurring charge is authorized), without specifying any payment-instrument
  detail.
- No card, bank-account, token, or other payment-instrument detail is included.
- No amount breakdown or campaign/Story attribution is asserted as part of this message's content in
  the evidence.

No fixed subject-line text, body markup, or template structure is asserted in this canonical
document — see UC0007 (AF1) and FLW0007 for the underlying trigger mechanics.

---

## Cross-references

- Trigger: UC0007 (Process Recurring Donation), Alternative Flow AF1.
- Subject entities: EN0010 (RecurringTransaction — the schedule whose charge failed), EN0009
  (Transaction — the new child Transaction recorded as canceled).
- Archive: EN0022 (EmailArchive) — the sent-message record, per the general email-archival pattern
  documented at the entity level; not restated here.
- Channel: ES0006 (Mautic).
- Related messages: MSG0019 (Donation Confirmation — Paid, the success-path counterpart for the same
  UC0007 flow and for donations generally); MSG0021 (donor-initiated voluntary cancellation of a
  recurring schedule — a distinct trigger from this gateway-failure dunning notice).

Evidence Level: Confirmed (RO/Netopia leg) — UC0007 AF1; FLW0007 §B Side Effects (Netopia charge marked
canceled dispatches a dedicated dunning-style email to the Donor via the Mautic transport). Confirmed
absence — CZ/ComGate leg, same sources.
