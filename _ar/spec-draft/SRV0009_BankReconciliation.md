# SRV0009 — Bank Reconciliation

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C5 — Finance & Reconciliation

## SRV Category
Integration Adapter

## Responsibility Type
Adapter

## Purpose
Reconciles incoming bank movements against platform transactions — pulling data from IMAP bank-mail, the Moneta AISP account API, and ComGate transfer lists, then matching them to `transaction` records for accounting. This is the inbound money-settlement boundary, distinct from payment initiation (SRV0008).

## Current Implementation Shape
- **IMAP bank mail:** `bank_integration` module — parses inbound bank e-mails into `transaction_mails` records; `hook_cron`. `Evidence:` `PSRC/web/modules/custom/bank_integration/`; `PSRC/web/modules/custom/bank_integration/src/Entity/TransactionMailsEntity.php`; [entrypoints.md §8](../repo-map/entrypoints.md).
- **Moneta AISP:** `MonetaAPI` (Guzzle) — `https://api.moneta.cz/api/v1/vip/aisp/my/accounts[/{id}/transactions]`, `Bearer <redacted>`; `hook_cron`. `Evidence:` `PSRC/web/modules/custom/monetaapi/src/MonetaAPI.php`; [integrations.md §1](../repo-map/integrations.md).
- **ComGate transfer sync:** `ComgateSyncCommand` (CLI, Guzzle) — `https://payments.comgate.cz/v1.0/transferList` + `/singleTransfer`. `Evidence:` `PSRC/web/modules/custom/bank_integration/src/Command/ComgateSyncCommand.php`; [integrations.md §1](../repo-map/integrations.md).
- **Reconciliation entity/form:** `TransactionComToBankEntity` + `accounting` module (`ComgateToBankForm`, `/admin/accounting/*`). `Evidence:` `PSRC/web/modules/custom/accounting/src/Entity/TransactionComToBankEntity.php`; [entrypoints.md §2](../repo-map/entrypoints.md).
- **Match target:** `transaction` bank fields (`bank_date`, `bank_vs`, `bank_account`, `is_sent_to_bank`) + index `transaction_campaign_is_sent_to_bank`. `Evidence:` [db-models.md `transaction`](../evidence/db-models.md).

## Structural Issues
- **Three heterogeneous inbound sources** merged into one reconciliation boundary (IMAP scraping, REST AISP, CLI transfer list) with different failure modes. `Evidence:` [SRV-candidates.md §4 Merges](SRV-candidates.md).
- **IMAP fragility** — reconciliation depends on parsing bank e-mails / attachments (`transaction_mails`), brittle to format changes. `Evidence:` [db-models.md `transaction_mails`](../evidence/db-models.md).
- **CLI-only ComGate sync** — transfer reconciliation runs from a console command, not a managed job. `Evidence:` [entrypoints.md §8](../repo-map/entrypoints.md).
- **Matching is app-level** — VS/amount matching to transactions has no DB-enforced linkage. `Evidence:` [data-model-signals.md §3](../repo-map/data-model-signals.md).

## Target Shape (for rewrite)
A `BankFeed` port with adapters (IMAP, Moneta AISP, ComGate transfers) producing normalized settlement records, and a reconciliation domain service matching them to transactions with an audit of matched/unmatched. Scheduled jobs, not CLI. Secrets from vault.

## Integration Dependencies
- Moneta AISP — `https://api.moneta.cz/api/v1/vip/aisp/my/accounts[/{id}/transactions]` (Bearer). `Confirmed`.
- ComGate transfers — `https://payments.comgate.cz/v1.0/transferList` + `/singleTransfer`. `Confirmed`.
- IMAP bank mailbox (host from config). `Confirmed` (module present) — [integrations.md §1,§8](../repo-map/integrations.md).

## Boundaries
Does NOT initiate payments → SRV0008. Does NOT own transaction domain rules → SRV0007. Does NOT produce reports/CSV → SRV0010. Does NOT import invoice documents → SRV0019.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Matching algorithm (VS/amount/date) and unmatched-record handling. `Missing evidence: ComgateToBankForm + reconciliation logic trace.`
- Which bank feeds are active per country (Moneta CZ only?). `Missing evidence: per-country feed enablement.`
- Cron cadence + environment gating for IMAP/Moneta pulls. `Missing evidence: bank_integration/monetaapi hook_cron guard trace.`
