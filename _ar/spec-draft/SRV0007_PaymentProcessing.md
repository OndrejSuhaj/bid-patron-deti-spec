# SRV0007 — Payment Processing

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C4 — Donations & Payments

## SRV Category
Domain Service

## Responsibility Type
Core Domain

## Purpose
Owns the `transaction` (donation/payment) aggregate and the recurring-donation schedule — the money domain. It tracks payment state (PENDING/PAID/CANCELLED/AUTHORIZED/REFUNDED), split/divided transactions, recurring tokens, and the flags that drive downstream fulfilment (voucherization, confirmation e-mail, bank-send). Gateway-specific mechanics are delegated to SRV0008.

## Current Implementation Shape
- **Aggregate root:** `TransactionEntity` (866 LOC) — base_table `transaction`, self-referencing `parent` (splits), `ext_status` enum, bank-reconciliation fields, many `is_*` flags. `Evidence:` `PSRC/web/modules/custom/transaction/src/Entity/TransactionEntity.php`; [db-models.md `transaction`](../evidence/db-models.md).
- **Recurring:** `TransactionRecurringEntity` (token_id, period, day, token_expiration_date) + `CancelForm`. `Evidence:` `PSRC/web/modules/custom/transaction_recurring/src/Entity/TransactionRecurringEntity.php`; [integrations.md §1](../repo-map/integrations.md).
- **Triggers:** transaction routes, gateway callback controllers (SRV0008), `hook_cron` in `transaction` (recurring charge / status polling). `Evidence:` [entrypoints.md §2,§8](../repo-map/entrypoints.md); `PSRC/web/modules/custom/transaction/transaction.routing.yml`.
- **Uniqueness:** `message_id` uniqueness enforced in `preSave` (PHP throw), not a DB unique key. `Evidence:` [db-models.md `transaction` Verification](../evidence/db-models.md).

## Structural Issues
- **God Entity with side-effects** — `TransactionEntity` (866 LOC) initiates gateway calls and, in lifecycle hooks, performs voucherization + role promotion + Slack/email side-effects. `Evidence:` [SRV-candidates.md §5](SRV-candidates.md).
- **Domain/adapter mix** — the entity both models the transaction and reaches into vendor gateways (split needed vs SRV0008). `Evidence:` [SRV-candidates.md §4 Splits](SRV-candidates.md).
- **App-level uniqueness race** — `message_id`/`ext_trans_id` uniqueness is PHP-only, race-prone under concurrency; no DB unique key. `Evidence:` [db-models.md `transaction`](../evidence/db-models.md).
- **Implicit fulfilment coupling** — `is_voucher`/`is_email_sent`/`is_sent_to_bank` flags drive C6/C5/C8 work from within the money aggregate.

## Target Shape (for rewrite)
Transaction as a pure aggregate with a `PaymentGateway` port (SRV0008 adapters behind it). Emit domain events on PAID/REFUNDED that SRV0011 (documents/vouchers), SRV0013 (confirmation mail), and SRV0009 (bank send) subscribe to — instead of `postSave` side-effects. DB-enforced idempotency on `message_id`.

## Integration Dependencies
No external endpoint owned directly — all gateway I/O is via SRV0008 (ComGate/Netopia/MAIB). Bank reconciliation is SRV0009.

## Boundaries
Does NOT own gateway protocol/HTTP → SRV0008. Does NOT own bank-statement reconciliation → SRV0009. Does NOT generate vouchers/confirmations → SRV0011. Does NOT send mail → SRV0013. Does NOT own campaigns (only references them for rollup) → SRV0005.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Full `ext_status` transition rules and who sets each. `Missing evidence: transaction status transition inventory.`
- Recurring charge trigger — which cron, environment-gated? `Missing evidence: transaction/transaction_recurring hook_cron trace.`
- Split-transaction (`parent`) semantics and when created. `Missing evidence: divided-transaction flow trace.`
