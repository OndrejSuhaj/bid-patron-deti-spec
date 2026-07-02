# UC0008 — Reconcile Bank Transactions

## Header

| Field | Value |
|---|---|
| UC ID | UC0008 |
| Name | Reconcile Bank Transactions |
| Bounded Context | C5 |
| Primary Actor(s) | Scheduler, System, Integration(Moneta), Integration(Bank), Integration(ComGate) |
| Trigger Type | Cron/CLI |

## Actors & Responsibilities

- **Scheduler** — triggers the periodic (daily cron) or on-demand (CLI) reconciliation runs; enforces per-source run guards (e.g. once-per-day) and environment/country gating.
- **Integration(Moneta)** — the CZ transparent-account bank, exposing an account-information (AISP) API that the system polls for new incoming credits.
- **Integration(Bank)** — the CZ current-account bank, whose payment-notification ("aviz") e-mails are read via a mailbox (IMAP) integration.
- **Integration(ComGate)** — the CZ payment gateway, exposing a transfer-list/transfer-detail API used to confirm which gateway payments have actually settled to the bank account.
- **System** — parses each source's data, matches it against existing Transactions (EN0009), creates new Transactions for previously-unseen bank credits, marks matched Transactions as bank-settled, recomputes the affected Campaign (EN0004), and triggers downstream notifications/indexing.

Notified parties (not acting participants in this use case):
- **Support** — CZ-only, receives incoming-payment operational alerts (chat notification) for visibility into the reconciliation runs (side channel, not part of the reconciliation logic itself).

## Intent

Keep the platform's Transaction records (EN0009) aligned with real-world bank/gateway settlement: import bank credits that were not initiated through the online payment flow, and mark gateway-initiated payments as confirmed-settled to the bank account, so that Campaign totals and donor confirmations reflect actual received money.

## Preconditions

- The relevant integration credentials are configured (bank API token, mailbox credentials, gateway secret/merchant id) for the CZ instance; the reconciliation sources are CZ-specific and do not run for RO/MD.
- For the Moneta AISP source: the daily import has not already run today (idempotence guard) and the bank API is reachable.
- For the bank-mail source: the environment is production and the tenant is CZ; the notification mailbox is reachable.
- For the ComGate transfer-sync source: valid gateway credentials are present; existing Transactions carry the gateway transaction identifier needed for matching.

## Main Flow

### UC0008.1 — Moneta AISP daily import
1. Scheduler: trigger the daily bank-reconciliation job once per day, guarded so a same-day re-run is skipped.
2. Integration(Moneta): resolve the single configured bank account for the platform.
3. Integration(Moneta): return the prior day's incoming credit transactions for that account, page by page.
4. System: for each returned credit, check whether a Transaction (EN0009) with the same bank reference already exists; skip if found.
5. System: reject and log any credit not denominated in the expected currency, halting the remainder of that day's batch.
6. System: extract the payment's variable symbol and the payer's source account from the credit data.
7. System: attempt to identify the paying donor by matching the payer's source account against a prior Transaction from the same account, carrying forward the associated owner if found.
8. System: create a new Transaction (EN0009) marked as paid, attributed to the platform's transparent collection Campaign (EN0004), with bank date, bank reference, and (if identified) owner.
9. System: recompute the raised amount and percentage of the transparent Campaign (EN0004) affected by the new Transaction.
10. System: send a payment-thank-you notification to the identified owner, if one was matched and has a valid contact e-mail.
11. System: post an operational payment alert (CZ, production only).
12. System: enqueue the new Transaction (and the recomputed Campaign) for search-index update.
13. System: record the completion of the day's import (count of transactions recorded).

### UC0008.2 — Bank notification e-mail (aviz) import
1. Scheduler: trigger the bank-mail reconciliation job on cron, restricted to production/CZ.
2. Integration(Bank): connect to the payment-notification mailbox and select unread messages from the bank's notification sender.
3. System: consider only unread messages whose subject matches the expected bank-payment-notification subject; leave non-matching unread messages untouched.
4. System: parse the notification's payment details (date, amount, variable symbol, counter-account name and number, sending bank, optional donor e-mail marker, description) from the message body.
5. System: normalize the parsed notification into the platform's internal bank-statement-line format, tagging it with the message's identifier as the import's idempotency key.
6. System: submit the normalized bank-statement line to the same reconciliation logic used for manually-uploaded bank statements.
7. System: determine whether the line's counter-account identifies it as a ComGate settlement transfer or as a new bank-to-bank donation.
8. System: on the ComGate-settlement branch, locate existing Transaction(s) by matching variable symbol; if found, update their bank date and mark them bank-settled; if none found, leave the message unread for retry and record the miss.
9. System: on the new-donation branch, attempt to identify the paying donor by prior Transaction on the same source account, else by the notification's e-mail marker.
10. System: on the new-donation branch, create a new Transaction (EN0009) marked as paid and as a donation, attributed to the transparent collection Campaign (EN0004), carrying bank date, variable symbol, and the message idempotency key; on a duplicate idempotency key, skip creation and log the duplicate instead.
11. System: on the new-donation branch, evaluate whether the new Transaction represents a recurring monthly pattern and flag it accordingly.
12. System: recompute the raised amount of the affected Campaign (EN0004); split off a child Transaction to the transparent Campaign if the recomputed total exceeds the target.
13. System: send a payment-thank-you notification to the identified owner, when applicable.
14. System: post an operational payment alert to the incoming-payments channel (CZ, production only).
15. System: record an audit entry (EN0029, BankTransactionMail) capturing the processed message's subject, sender, and receipt details.
16. System: mark the processed message as read, except when it was an unmatched ComGate-settlement candidate left for retry.

### UC0008.3 — ComGate transfer-list settlement sync
1. Scheduler: invoke the ComGate settlement-sync job on demand or on a scheduled run, for a given number of trailing days.
2. Integration(ComGate): for each day in the requested window, return the list of transfers settled to the bank account on that day.
3. Integration(ComGate): for each listed transfer, return the transfer's detail lines.
4. System: keep only the payment-type detail lines and extract the transfer's variable symbol and the gateway's transaction identifier.
5. System: locate existing Transaction(s) by matching the gateway transaction identifier and set their variable symbol and bank-settled flag; a hard cap limits how many matching rows are updated per run.
6. System: report, per processed transfer, whether a matching Transaction was updated; log an error and pause briefly when no match is found.

## Alternative Flows

### AF1 — Moneta import failure aborts the batch
1. Integration(Moneta): the account-lookup or transaction-fetch call fails (network/authentication error).
2. System: log the error and end the day's import without importing any further transactions in that run.

Outcome: today's import slot is still considered consumed; because the source always queries "yesterday", the missed day is not automatically retried on a later run — a silent import gap (Partial evidence: recorded failure mode, not a corrected behavior).

### AF2 — Non-domestic-currency credit halts the remaining batch
1. Integration(Moneta): returns a credit denominated in a currency other than the expected one.
2. System: reject the credit and raise an error, which aborts processing of the remaining credits in that day's batch.

Outcome: transactions after the rejected one in the same batch are not imported in this run (Confirmed failure mode).

### AF3 — Bank-mail parsing fails on template drift
1. Integration(Bank): delivers a notification whose layout no longer matches the expected structure.
2. System: extracts blank/partial fields from the message body.
3. System: still creates a Transaction (or audit record) from the incomplete data rather than rejecting it.

Outcome: a Transaction or audit entry may be created with missing payment details (Confirmed fragile-parsing risk).

### AF4 — ComGate settlement match not found
1. System: no existing Transaction matches the ComGate settlement's variable symbol.
2. Integration(Bank): the corresponding notification message is left unread in the mailbox for retry on a later run.

Outcome: the settlement is not reconciled in this run; retried automatically only via the bank-mail source's next unread pass, not via the ComGate transfer-sync source.

### AF5 — Split settlement exceeds per-run match limit
1. System: a single gateway transaction identifier corresponds to more transactions than the per-run update cap allows (e.g. a payment split across many Transaction rows).
2. System: updates only up to the cap; the remaining matching Transactions are not marked bank-settled in this run.

Outcome: partial reconciliation — some Transactions tied to a split settlement remain unmarked until a subsequent run (Confirmed data-loss/idempotence risk).

## Postconditions

- New Transactions (EN0009) exist for previously-unseen bank credits and bank-to-bank donations, marked paid and attributed to the transparent collection Campaign (EN0004).
- Previously-created Transactions that correspond to confirmed ComGate settlements are marked bank-settled (bank date set, settlement flag on) without altering their payment status history.
- The affected Campaign(s) (EN0004) have their raised-amount totals recomputed to reflect newly imported or reconciled Transactions.
- One audit record (EN0029, BankTransactionMail) exists per handled bank-notification e-mail, successful or not.
- Newly created or updated Transactions and Campaigns are queued for search-index update.
- Donor thank-you notifications and operational payment alerts have been dispatched where applicable.

## Traceability

Target SRVs:
- Bank-Reconciliation
- Moneta-AISP-Adapter
- BankMail-IMAP-Adapter
- ComGate-TransferSync-Adapter
- Reconciliation-Processor

EN entities:
- EN0009 Transaction — the record created (new bank/donation credit) or updated (bank-settlement match) by every sub-flow
- EN0029 BankTransactionMail — audit trail of processed bank-notification e-mails (UC0008.2)
- EN0030 ComgateBankReconciliation — related manual accounting settlement record; not written by the automated sync sub-flow (UC0008.3), noted for context/boundary only
- EN0004 Campaign — the transparent collection Campaign (and any campaign a matched donor's Transaction targets) whose raised amount is recomputed as a side effect

Integration boundaries:
- Integration(Moneta) — account-information (AISP) API, daily credit import (UC0008.1)
- Integration(Bank) — payment-notification mailbox (IMAP), aviz e-mail import (UC0008.2)
- Integration(ComGate) — transfer-list/transfer-detail settlement API (UC0008.3)

Flow Evidence:
- FLW0011 (Moneta AISP daily transaction import)
- FLW0012 (Bank notification e-mail IMAP import)
- FLW0013 (ComGate transfer-list reconciliation sync)

## Evidence Level

Confirmed — all three sub-flows are Flow-evidenced (FLW0011, FLW0012, FLW0013) cron/CLI triggers with concrete Transaction (EN0009) side effects mapped to the target SRVs Bank-Reconciliation, Moneta-AISP-Adapter, BankMail-IMAP-Adapter, and ComGate-TransferSync-Adapter; the automatic scheduling of the ComGate transfer-sync sub-flow (UC0008.3) is a recorded scoping conflict in FLW0013 — its manual/CLI trigger is Confirmed, any cron scheduling of it is Hypothesis — and is flagged accordingly rather than asserted.
