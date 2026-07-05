---
doc_id: JOB0006
title: Bank Notification E-mail IMAP Import
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: poller
references:
  - FN0012
  - EN0009
  - ES0005
  - MSG0019
---

# JOB0006 – Bank Notification E-mail IMAP Import

## Purpose

Poll the CZ client bank-notification (aviz) mailbox for new payment-notification e-mails, parse each
into a bank-statement row, and either create a new PAID donation Transaction or reconcile existing
ComGate settlement Transactions. A second reconciliation source of FN0012 (Bank & Gateway
Reconciliation / Matching).

Classification: **Confirmed**.

## Trigger Model

- Poller. Runs as the `bank_integration` cron unit on the platform cron tick (hourly, `0 * * * *`).
  No internal daily throttle — it polls the mailbox on every tick.
- Hard-gated to `environment=production AND country=cz`; RO/MD never execute this job.
- Evidence: `bank_integration/bank_integration.module:15` →
  `bank_integration/src/Controller/BankIntegrationPageController.php` (`getMailFromServerHandle`).
  Dossier: FLW0012.

## Input Scope

- Unseen inbox messages from the configured bank sender with the exact expected subject. Non-matching
  unseen mails are left untouched.

## Processing Rules

- Connect over IMAP; per matching message: parse the HTML body via fixed XPath into a synthesized
  bank-statement row (own account / IBAN / currency hardcoded); append an idempotency key derived
  from the message; reuse the manual bank-import path to create or reconcile a Transaction.
- ComGate-settlement counter-accounts route to **reconcile existing** Transactions (mark bank date +
  sent-to-bank); otherwise treat as a **new bank-to-bank donation** booked to the transparent
  account. A recurring-payment heuristic may flag repeat donations. See EN0009.

## Side Effects

- New PAID Transaction (bank-to-bank) or reconciled existing Transaction(s); one mail-audit row per
  handled message; the message is flagged Seen only in production and only when not left for retry.
- Transaction save fires the donation PAID cascade (FN0007): thank-you message (MSG0019 via FN0019),
  search-index enqueue (→ JOB0013), campaign recompute, overpayment split.
- Cross-system: IMAP mailbox (ES0005) read/flag; hardcoded Slack payment/donation webhooks; Telegram
  ops alerts (FN0023).

## Idempotency

- **Message-id de-duplication** (pre-check + entity-save uniqueness throw). The idempotency key is
  derived from the IMAP message id, whose stability is uncertain (`Partial` — weakens dedup).
- ComGate-unmatched messages are intentionally left Unseen for retry next poll.

## Failure Handling

- IMAP auth failure does not abort early; a subsequent mailbox call on a falsy connection can fatal
  (silent-ish import stall).
- Any per-message exception is logged and **re-thrown**, aborting the whole poll batch; already-Seen
  or already-saved messages in the same run are not rolled back (partial batch).
- Fragile fixed-XPath parse: a bank-template change yields blank fields but may still create a
  Transaction. Documented current-state hazards (FLW0012).

## References

- FN: FN0012, FN0007, FN0019
- UC: UC0008
- EN: EN0009, EN0004
- ES: ES0005
- MSG: MSG0019 (donation thank-you)
- Evidence: FLW0012

## Open Items

- Exact IMAP host and the semantics of the message-id used as idempotency key are not in scrubbed
  source. `Hypothesis` / `Partial`.
