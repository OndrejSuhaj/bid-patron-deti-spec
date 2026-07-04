---
doc_id: WIRE0004
title: Voucher Purchase
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S005
realizes_uc: [UC0009]
status: draft
references:
  - UC0009
  - EN0013
  - EN0009
  - EN0004
  - BR-VoucherPolicy
---

# WIRE0004 – Voucher Purchase

> **Evidence-Pending WIRE.** No screenshot of screen S005 exists in `_ar/prtsc/**` or
> `_ar/evidence/ui/ui-observed-areas.md`. Only the screen's **entry points** were captured (CTA
> labels on S001/S002), not the purchase screen itself. This document records what the IA/UC/EN/BR
> evidence supports and marks everything else `Uncertain` / `Evidence Pending`. See IA-Q10
> (`_ar/spec-draft/IA/IA-patronus.md` §8) for the tracked gap.

---

## Purpose

S005 is intended to be the **voucher (Dobrošek) purchase / checkout screen**: a visitor picks a
Dobrošek denomination/value and buys it as a prepaid gift donation code (`EN0013` Voucher), to be
redeemed later by a recipient against a Campaign (`EN0004`) of their choosing. Entry is via the
"Koupím dobrošek" CTA observed on the homepage (S001) — see `ui-observed-areas.md` §1 — and the
IA entry-points table (`_ar/spec-draft/IA/IA-patronus.md` §4, row "Koupím dobrošek").

**UC mapping caveat (Uncertain — open question, no BR governs this mapping):** the only candidate UC
supplied for S005 is `UC0009` (Redeem / Validate Voucher). Reading `UC0009`
(`_ar/spec-draft/UC/UC0009_RedeemValidateVoucher.md`) and its flow evidence `FLW0018`
(`_ar/evidence/flow/FLW0018_voucher-apply-validate.md`) shows `UC0009` is exclusively an
API-triggered **validate/redeem** operation (`POST /api/2.2/voucher/validate`,
`POST /api/2.2/voucher/apply`) consumed from the donation-modal context on S002 ("Mám dobrošek" /
"Chcete věnovat dobrošek?" — `ui-observed-areas.md` §2), not a purchase/checkout flow. The voucher
**purchase** side (`VoucherTransactionService::createVoucher` / `VoucherCartService`, per FLW0018 §D)
is a distinct, uncaptured backend path with no UC doc of its own in `_ar/spec-draft/UC/` at the time
of this pass. This WIRE follows the assignment's candidate mapping (`realizes_uc: [UC0009]`,
`certainty: Uncertain` per `IA-screen-map.md` row S005) but flags the mismatch rather than silently
asserting S005 realizes redeem/validate: **Conflict — requires clarification** (candidate UC likely
describes the wrong half of the voucher lifecycle for this screen; the purchase-side UC is missing
from the current UC set).

**Actor:** anonymous visitor (buyer), by analogy with the anonymous-donor pattern on S001/S002; no
authentication requirement is evidenced for either buy or apply/validate (`BR-VoucherPolicy`
"Current-state uniqueness and concurrency risks" — validation/redemption are confirmed
unauthenticated; purchase-side authentication is Uncertain, not evidenced either way).

**Entry context:** "Koupím dobrošek" CTA on S001 (homepage) and possibly S002 (story detail) — see
IA entry-points table. No route/URL is evidenced for S005 itself.

---

## Layout Zones

Uncertain — Evidence Pending. No screenshot or DOM capture of S005 exists. The zones below are
**Assumed by analogy** with the sibling donation-modal pattern observed on S002
(`ui-observed-areas.md` §2: "Chystáte se přispět" modal — amount input, e-mail, consent checkboxes,
"Přejít k platbě") and with the Voucher entity's user-provided attributes (`EN0013`
"User-provided attributes"). None of this layout is Confirmed.

- Header — Assumed: shared site header/nav (per S001/S002 pattern). **Uncertain.**
- Main content — Assumed: a denomination/value picker plus recipient details form, given `EN0013`
  attributes `price`, `recipient_name`, `recipient_email`, `user_phone`, `recipient_message`,
  `delivery_type` (email/print). **Uncertain — not observed.**
- Payment step — Assumed: hands off to the external Comgate gateway (S-EXT1/S-EXT2 per
  `IA-patronus.md` §3.7), by analogy with the donation-modal → gateway pattern on S002/UC0005/UC0006.
  **Uncertain — not observed for the voucher-buy path specifically.**
- Footer — Assumed: shared site footer. **Uncertain.**

No ASCII layout sketch is provided — fabricating spatial arrangement without evidence would violate
the WIRE evidence discipline (`rules-WIRE.md` "Observed UI wins... do not fabricate").

---

## Components Used

Evidence Pending — no component-level evidence exists for S005. The COMP layer does not exist yet
in this pass regardless, so any reconstructed element would be flagged `inline`. No elements are
listed here because none are Confirmed or Probable; listing Assumed form fields as components would
overstate certainty.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| — | — | — | Evidence Pending — no capture of S005 exists; see Purpose note. |

---

## Interactions

Uncertain — Evidence Pending, reconstructed only from the entry-point CTA and the Voucher entity
shape; no screen-level interaction sequence is observed.

1. **Entry** — click "Koupím dobrošek" on S001 (Confirmed CTA label exists — `ui-observed-areas.md`
   §1) → state: `default` (Uncertain — target screen/route not captured).
2. **Primary action** — Assumed: select a Dobrošek value/denomination and submit recipient details
   → creates a Voucher (`EN0013`) bound to a purchasing Transaction (`EN0009`) in the unpaid state,
   then proceeds to payment. **Uncertain** — no UC document in the current UC set covers this
   purchase step; inferred only from `EN0013` attributes and the "Unpaid → Paid" transition note in
   `EN0013` State Transitions (triggered by `UC0006` Confirm Payment, not `UC0009`).
3. **Secondary action** — none observed.
4. **Exit** — Assumed: redirect to external payment gateway (Comgate, S-EXT1) on submit, returning to
   a thank-you/confirmation screen on payment result, by analogy with `UC0006`'s gateway-callback
   pattern. **Uncertain — not observed for this screen.**

---

## States

### default
Uncertain — Evidence Pending. No capture exists of the screen in its normal usable state.

### empty
N/A — Evidence Pending: no evidence indicates this screen has an empty-state condition (it is
presumed a single-purpose purchase form, not a list/collection view), but this is inferred, not
observed.

### loading
Uncertain — Evidence Pending. No evidence of an async/loading indicator for this screen.

### error
Uncertain — Evidence Pending. No evidence of validation-error or payment-failure display on this
screen specifically. (Contrast: `FLW0018` documents that the *separate* validate/apply API always
returns HTTP 200 with `{status:failed|invalid}` in the body — but that is the redeem-side API, not
this purchase screen; carrying that error contract over to S005 would be a layer violation and is
not done here.)

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| Voucher value/denomination | none — no BR found | Uncertain — validationsWithoutBR |
| Recipient e-mail (if collected at purchase) | none — no BR found | Uncertain — validationsWithoutBR |
| Delivery type (email/print) | none — no BR found | Uncertain — validationsWithoutBR |

No BR document governs purchase-time field validation for the Voucher; `BR-VoucherPolicy` governs
only the paid/redemption lifecycle (Non-Goals: "does not define the Voucher's persisted attributes,
field types, or storage shape"). This is an **open question** — flagged, not fabricated as a new BR.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Main content (Assumed form) | `EN0013` | — | Voucher user-provided attributes: `price`, `recipient_name`, `recipient_email`, `user_phone`, `recipient_message`, `delivery_type`. Uncertain which are collected at purchase-time on this screen vs. elsewhere. |
| Payment hand-off | `EN0009` | — | Purchasing Transaction created in the unpaid state (per `EN0013` "transaction" attribute and State Transitions). Uncertain — not observed on this screen. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | none evidenced — no role gate found | Uncertain — no ACL layer exists in this pass; purchase appears open to anonymous visitors by analogy with S001/S002, but this is Assumed, not Confirmed for S005 specifically. |

---

## Accessibility Notes

Evidence Pending — no screenshot or DOM capture exists to derive tab order, focus behavior,
landmarks, or keyboard shortcuts for S005. Not fabricated.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen existence / entry CTA | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §1 ("Koupím dobrošek" CTA on homepage), §2 ("Mám dobrošek" / "Chcete věnovat dobrošek?" on story detail — note: this is the *apply*-side entry, not purchase) |
| Purchase screen itself not captured | Confirmed (absence) | `_ar/spec-draft/IA/IA-patronus.md` §3.5, §8 IA-Q10; `_ar/spec-draft/IA-screen-map.md` row S005 |
| Layout zones, components, interactions, states, a11y | Uncertain / Evidence Pending | No screenshot exists; reconstructed only by analogy with S002 donation modal and `EN0013` attribute shape — not asserted as observed fact |
| UC0009 as realizing UC for a purchase screen | Uncertain — Conflict, requires clarification | `_ar/spec-draft/UC/UC0009_RedeemValidateVoucher.md` (validate/redeem only, API-triggered); `_ar/evidence/flow/FLW0018_voucher-apply-validate.md` (same); no purchase-side UC exists in `_ar/spec-draft/UC/` at time of this pass |
| Voucher field shape (denomination, recipient, delivery type) | Confirmed (entity shape) / Uncertain (screen mapping) | `_ar/spec-draft/EN/EN0013_Voucher.md` "User-provided attributes" |
| Validation rules for purchase-time fields | Uncertain — no BR found | `_ar/spec-draft/BR/BR-VoucherPolicy.md` (Non-Goals explicitly excludes field-level validation) |
