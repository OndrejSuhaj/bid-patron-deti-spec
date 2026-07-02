---
doc_id: MSG0028
title: Donation Tax Confirmation (Certificate) Email
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0010
references:
  - EN0014
  - EN0009
  - EN0008
  - EN0022
  - ES0006
---

# MSG0028 – Donation Tax Confirmation (Certificate) Email

## Purpose

Deliver a Donor their official CZ donation confirmation ("Potvrzení o daru") as a PDF certificate,
summing their paid donations for a requested year, for tax-deduction purposes. This is a
Customer-initiated document request, not a status-driven notification — it is issued on demand,
either self-service or via manual back-office fulfilment, rather than fired by an Application/Story
status transition.

---

## Trigger

UC0010 (Issue Donation Confirmation (Tax)) — fired when:

- the Customer submits a donation confirmation request via the public web form or the SPA/API
  channel (UC0010.1 / UC0010.3), and the computed paid-donation total for the requested User/year is
  greater than zero; or
- the Customer cannot self-serve (e.g. an anonymous donation with no zone access) and instead emails a
  request to the INFO Coordinator, who verifies the donor's identity and donation and issues the
  confirmation manually (Notification Matrix SC-10G, steps 3–5).

Not sent when the computed donation total for the requested User/year is zero (UC0010 AF1 — request
aborted, no confirmation created, no email sent).

Evidence: UC0010 Main Flow and AF1; Notification Matrix sheet SC-10G ("Donation Confirmation
Certificate"), rows 1–5, in `intake/test-scenarios/test-scenarios.md`.

---

## Recipients

- **Donor** — email, via ES0006 (Mautic). Sole recipient of this message; not sent to the Parent,
  Patron, or any operations role.
- Self-service confirmations (SC-10G step 1) are also generated as a document directly downloadable
  from the Donor Zone (SC-10G step 2) — an in-application document-availability outcome distinct from,
  and in addition to, this transactional email.
- **CZ-only.** The underlying confirmation template is defined only for the CZ tenant; a request
  processed under the RO/MD country configuration does not carry this message — no email is sent for
  it (UC0010 Evidence Level; FLW0009).
- No RO/MD content variant of this message exists: the RO tax-redirect ("2%"/3.5%) declaration
  mechanism (UC0010 AF4) is a distinct, separately-evidenced flow producing a signed declaration
  record, not a DonationConfirmation (EN0014) PDF, and is out of scope for this message.

---

## Message Content

Conceptually, each instance of this message carries:

- A statement that the attached document is the Donor's official donation confirmation
  ("Potvrzení o daru") for the requested confirmation year.
- The requester's identifying details as supplied with the request (name/organization name and
  address) — caller-supplied, not independently verified as part of issuing the message.
- The confirmed total paid-donation amount for the requested year, computed server-side from paid
  Transactions (EN0009) — this monetary figure is authoritative, unlike the requester identity fields.
- The same confirmed amount expressed in words, alongside the numeric total.
- The confirmation year the document covers.
- The rendered PDF tax-confirmation certificate as an email attachment.

No fixed subject-line text, body markup, or template structure is asserted in this canonical
document — the concrete wording and the PDF layout are instance/configuration data and out of scope
for the MSG layer (see rules-MSG.md restrictions). Every dispatch is archived as an EmailArchive
(EN0022) record, independent of whether the underlying transport actually delivered the message.

---

## Notes

- Evidence Level: Confirmed for the trigger mechanism (Customer-initiated request with a
  greater-than-zero computed donation total → confirmation snapshot → PDF → email), the
  Donor-as-sole-recipient contract, the CZ-only scope, and the archival postcondition, per UC0010 and
  Notification Matrix SC-10G. Partial for the exact content framing (identity fields vs. amount vs.
  amount-in-words presentation split), since precise wording is configuration/template data not fully
  visible from the cited sources.
- No idempotency safeguard: repeated requests for the same donor/year each independently produce a
  separate DonationConfirmation (EN0014) snapshot and a separate email — duplicate confirmations and
  duplicate emails are a current-state possibility, not an error condition (UC0010 AF3).
- Partial-completion mode: the DonationConfirmation (EN0014) snapshot is persisted before document
  rendering and dispatch are attempted; if rendering or transmission fails, a confirmation record
  exists with no corresponding email having been sent — a silent, partial outcome from the Donor's
  perspective (UC0010 AF2).
- Distinct from the RO tax-redirect ("2%"/3.5%) declaration mechanism (UC0010 AF4) — that path produces
  a signed declaration and a TaxPayer record, not this PDF-attachment email, and is not covered by this
  document.
