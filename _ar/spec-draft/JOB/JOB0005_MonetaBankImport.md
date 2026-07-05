---
doc_id: JOB0005
title: Moneta AISP Daily Bank Import
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: scheduler
references:
  - FN0012
  - EN0009
  - ES0004
  - MSG0019
---

# JOB0005 – Moneta AISP Daily Bank Import

## Purpose

Pull the previous day's CZ bank credits from the Moneta AISP account-information API and record them
as PAID donation Transactions against the transparent-account campaign, enabling **bank
reconciliation** (glossary C033). Realises one reconciliation source of FN0012 (Bank & Gateway
Reconciliation / Matching).

Classification: **Confirmed**.

## Trigger Model

- Scheduled. Runs as the `monetaapi` cron unit on the platform cron tick (hourly, `0 * * * *`),
  self-throttled to **at most once per day** via a persisted last-run key.
- CZ-only integration (Moneta is the CZ bank); the throttle key is set to the request time
  **before** the API work (a mid-run failure still consumes the day's slot).
- Evidence: `monetaapi/monetaapi.module:9` → `monetaapi/src/MonetaAPI.php` (`getID`, `getTransactions`,
  `mapAndSave`). Dossier: FLW0011.

## Input Scope

- Yesterday's transactions for the single Moneta account (the job assumes exactly one account),
  fetched via a paginated pull. Currency guarded to CZK only.

## Processing Rules

- Resolve the account id; fetch yesterday's transactions; for each: dedup by bank reference; parse
  variable symbol and debtor account; build a Transaction with PAID status booked to the fixed
  transparent-account campaign; back-fill the owner user from any prior transaction on the same
  bank account; create and save the Transaction. See EN0009.

## Side Effects

- New PAID Transaction rows for yesterday's un-imported credits (transparent-account campaign).
- Each Transaction save fires the donation PAID cascade (FN0007): thank-you message (MSG0019, only
  when the resolved owner has a valid email — anonymous imports send nothing), campaign raised-money
  recompute, overpayment auto-split, search-index enqueue (→ JOB0013), CZ+prod Slack notification.
- Cross-system call: Moneta AISP (ES0004) outbound pull. Telegram ops alert on error (FN0023).
- Persisted last-run key write.

## Idempotency

- **Application-level dedup only** on the bank reference (select-then-insert; **not** a DB unique
  constraint) — a race or overlap can double-insert.
- **Silent-gap hazard:** the last-run key is set before the work and the fetch always targets
  "yesterday", so a failed day is never re-fetched later → permanent import gap. Documented
  current-state hazard.

## Failure Handling

- API/Guzzle errors are logged and re-thrown, caught by the cron wrapper (run ends, no retry).
- A non-CZK transaction throws and aborts the **remaining batch** for that run (partial import).
- Deep-array parse assumes full response structure; missing keys can notice/throw.

## References

- FN: FN0012, FN0007, FN0019
- UC: UC0008
- EN: EN0009, EN0004
- ES: ES0004
- MSG: MSG0019 (donation thank-you)
- Evidence: FLW0011

## Open Items

- Behaviour on a zero-account or multi-account API response is unguarded (assumes `accounts[0]`).
  `Confirmed` mechanism.
