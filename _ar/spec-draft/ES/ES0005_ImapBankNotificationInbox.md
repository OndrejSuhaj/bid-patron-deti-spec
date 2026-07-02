---
doc_id: ES0005
title: Client IMAP bank-notification inbox
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0012
  - UC0008
---

# ES0005 – Client IMAP bank-notification inbox

## Purpose

Supplies the Czech bank's payment-notification ("aviz") messages that the platform polls to
recognize incoming bank credits when the AISP feed (ES for the Moneta bank API is documented
separately) is not the source. It is one of three reconciliation sources clustered under the
Bank & Gateway Reconciliation / Matching capability (FN0012), alongside the Moneta AISP feed and
the payment gateway's transfer/settlement sync.

---

## System Overview

A client-operated e-mail mailbox, reachable over the IMAP protocol, into which the Czech bank
delivers transaction-notification ("aviz") messages as HTML e-mails whenever money is credited to
the platform's account. The mailbox itself is client-operated infrastructure (not part of the
platform); the bank is the ultimate originator of the notification content, with the mailbox as
the delivery boundary the platform integrates against.

---

## Integration Model

Inbound, poll-based. A scheduled reconciliation job (UC0008) makes an outbound connection to the
mailbox over IMAP, selects unread notification messages from the bank's sender, and parses matching
messages into normalized bank-transaction lines for the platform's reconciliation logic (UC0008.2).
This is a distinct external boundary from the Moneta AISP feed even though both feed the same
reconciliation capability (FN0012).

---

## Data Exchange

- **Inbound:** bank payment-notification ("aviz") e-mail messages, each carrying the conceptual
  payment details (date, amount, payment reference, counter-account identification, sending bank,
  an optional donor identification marker, and a free-text description). These are parsed into
  incoming-credit records consumed by reconciliation matching (conceptual only — the resulting
  audit record is owned by EN0029, BankTransactionMail).
- **Outbound:** none — the platform only reads from the mailbox; it does not send messages back
  through this boundary.

---

## Constraints

- The platform parses the notification's HTML body by a fixed structural pattern, so any change to
  the bank's e-mail template can blank out parsed fields or break parsing outright.
- The idempotency key used to avoid re-processing a message is not fully stable, which can cause a
  notification to be missed or, on drift, imported more than once.
- Incomplete or malformed parsing can still produce a transaction record from partial data rather
  than failing safely (ARCH0001 §5 row 5, HS05).
- Country-scoped to CZ only; not used for RO/MD.
- Current-state only — describes the integration as implemented today, not target-state intent.
