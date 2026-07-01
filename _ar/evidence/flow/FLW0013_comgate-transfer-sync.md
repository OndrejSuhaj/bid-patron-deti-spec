# FLW0013 — ComGate transfer-list reconciliation sync
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL031 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL031 (dossier FLW0013)
- Flow Name: ComGate transfer-list reconciliation sync
- Primary SRV: SRV0009 (Bank-Reconciliation; ComGate-TransferSync-Adapter subrole per [../../spec-draft/SRV-target-list.md](../../spec-draft/SRV-target-list.md) line 36)
- Trigger Evidence: Drush/Drupal Console command `comgatesync {days}` — `bank_integration/src/Command/ComgateSyncCommand.php:56-65` (`setName('comgatesync')`, optional `days` arg default `1`); `execute()` at `:78`. Wired via `bank_integration/console.services.yml` (`bank_integration.comgatesync`, args `@database`, `@http_client`, tag `drupal.command`).
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Manual/scheduled CLI invocation `comgatesync {days}`. There is **no `hook_cron` wiring for this flow** — `bank_integration_cron` (`bank_integration.module:15`) only runs the IMAP mail import (FLW0012, `getMailFromServerHandle`), and `comgate_cron` (`comgate/comgate.module:15`) runs the **recurring-charge** flow (`ComgateCron::execute()` → `transactionRecurring()`, `comgate/src/ComgateCron.php:15-20`), NOT transferList reconciliation. See Scoping conflict below.
- Preconditions:
  - `Settings::get('comgate')` populated with `secret` + `merchant` (`ComgateSyncCommand.php:49,128-131,145-149`). Redacted secret values are read from site settings (`<redacted>`).
  - Existing `transaction` rows must carry the matching `ext_trans_id` (ComGate id) for the UPDATE to affect any row (`ComgateSyncCommand.php:203-210`).
- Main Steps (ordered, each with evidence):
  1. Parse `days` arg → integer `$period`; loop backward from today one calendar day per iteration (`ComgateSyncCommand.php:79-88`, `date("Y-m-d")` / `strtotime($date." -1 day")`).
  2. For each day, fetch day transfer list: HTTP POST `https://payments.comgate.cz/v1.0/transferList` with `form_params{secret,merchant,date}` (`getComgatePaymentsVS`, `ComgateSyncCommand.php:125-138`); JSON-decoded (`\GuzzleHttp\json_decode`).
  3. Iterate returned transfers; read `variableSymbol` and `transferId` per item (`ComgateSyncCommand.php:94-99`).
  4. For each `transferId`, fetch transfer detail: HTTP POST `https://payments.comgate.cz/v1.0/singleTransfer` with `form_params{secret,merchant,transferId}` (`getComgatePayment`, `ComgateSyncCommand.php:143-156`).
  5. Iterate detail lines; keep only `typ === 1` (payment rows); extract `Variabilní symbol převodu` → `$bank_vs` and `ID ComGate` → `$ext_trans_id` (`processComgatePayment`, `ComgateSyncCommand.php:189-200`).
  6. Persist: raw SQL `UPDATE transaction SET bank_vs=:bank_vs, is_sent_to_bank=1 WHERE ext_trans_id=:ext_trans_id LIMIT 30` (`updateTransaction`, `ComgateSyncCommand.php:203-210`).
  7. Emit CLI success/error line per transaction; on zero affected rows, log error + `sleep(10)` (`ComgateSyncCommand.php:212-217`).
- Postconditions: Matched `transaction` rows have `bank_vs` set to the transfer's variable symbol and `is_sent_to_bank = 1` (marks the payment as reconciled/settled to bank). Unmatched ComGate ids leave DB unchanged.
- Side Effects:
  - DB write to `transaction` table (raw SQL, entity lifecycle **bypassed** — see below).
  - CLI stdout logging via `getIo()->info/successLite/errorLite`.
  - Wall-clock `sleep(10)` per unmatched transaction (`:216`) — throttling / performance side effect.
- Integration Calls:
  - ComGate `POST /v1.0/transferList` (per-day transfer list) — `ComgateSyncCommand.php:134`.
  - ComGate `POST /v1.0/singleTransfer` (per-transfer detail) — `ComgateSyncCommand.php:152`.
  - Both via injected `GuzzleHttp\Client` (`@http_client`); credentials `secret`+`merchant` from `Settings::get('comgate')` (`<redacted>`).
- Failure Modes:
  - **No HTTP error handling**: Guzzle `post()` is not wrapped in try/catch (`:134,:152`); a 4xx/5xx/timeout throws and aborts the whole command run for that day and all remaining days (`Hypothesis` on exact abort scope — no catch exists, so uncaught propagation is expected).
  - **No JSON validation**: `json_decode` result used directly; malformed/empty body → property access on non-object errors (`:135-137,:153-156,:194-196`).
  - `$date` is referenced in `empty($date)` before initialization on first loop iteration (`:83`) — relies on PHP undefined-variable-as-null; benign but fragile (`Hypothesis`).
  - **Silent partial reconciliation**: `LIMIT 30` caps affected rows per ComGate id (`:208`); if a split payment produced >30 `transaction` rows sharing one `ext_trans_id`, the excess are never marked (`Data Loss`/`Idempotence` risk). Comment at `:208` explicitly acknowledges split payments.
  - Unmatched `ext_trans_id` → error log + `sleep(10)`, no retry/queue (`:214-216`).
  - No dedup/idempotency guard beyond the WHERE clause; re-running overwrites `bank_vs` with the same value (idempotent for matched rows, but re-marks `is_sent_to_bank=1` unconditionally).

## C. Data Footprint
- Entities Written:
  - `transaction` table — columns `bank_vs`, `is_sent_to_bank` (`ComgateSyncCommand.php:204-206`). Written via **raw `Database::query()` UPDATE**, NOT via `TransactionEntity::save()`. Consequences: `TransactionEntity::preSave` (`transaction/src/Entity/TransactionEntity.php:590`), `postSave` (`:633`), and status/update event dispatch (`dispatchStatusChangeEvent`, `:862`, currently commented out anyway) are **all bypassed**; entity cache is not invalidated by this write. Field definitions confirmed: `bank_vs` string(12) `:363`, `is_sent_to_bank` boolean default FALSE `:381`, `ext_trans_id` string(40) `:375`.
- Entities Read:
  - `transaction` table via the UPDATE's `WHERE ext_trans_id = :ext_trans_id` predicate (`:207`); no separate SELECT.
  - No local read of ComGate transfer state — all transfer data comes from the external API responses.
- Constraints involved: Update predicate leans on index `transaction_id_bank_vs_name_method_is_sent_to_bank` (actual columns `id,bank_vs,is_sent_to_bank`) and `transaction_campaign_ext_trans_id_...` (includes `ext_trans_id`) per [../db-models.md](../db-models.md) line 668. No DB uniqueness on `ext_trans_id` (`message_id` uniqueness is app-level only), so multiple rows may match — hence the `LIMIT 30`.
- Multi-tenant scope assumptions: **Implicitly CZ-only.** The command has no country guard, but `Settings::get('comgate')` is per-site config and ComGate is the CZ gateway (`integrations.md` line 15 marks it CZ). Sibling automatic crons (`comgate_cron`, `bank_integration_cron`) both hard-gate on `country === 'cz'` (`comgate.module:16`, `bank_integration.module:18`). This CLI flow relies on being run only against the CZ instance — no in-code enforcement (`Multi-tenant` risk).

## D. Evidence Block
- Controller paths: n/a (CLI command, not HTTP). Trigger class `bank_integration/src/Command/ComgateSyncCommand.php`.
- Service methods:
  - `ComgateSyncCommand::execute()` `:78`, `::getComgatePaymentsVS()` `:125`, `::getComgatePayment()` `:143`, `::processComgatePayment()` `:159`, `::updateTransaction()` `:203`.
  - Injected: `Drupal\Core\Database\Driver\mysql\Connection` (`@database`), `GuzzleHttp\Client` (`@http_client`) — `console.services.yml`.
- Repository usage: Direct `$this->database->query(...)` raw SQL (`:204`) with `Database::RETURN_AFFECTED` (`:210`); no entity storage / repository abstraction used.
- Event listeners: None dispatched by this flow (raw SQL path). `TransactionEntity::dispatchStatusChangeEvent()` is not reached; note it is itself commented out (`transaction/src/Entity/TransactionEntity.php:862-864`).
- Async messages: None. Fully synchronous CLI; per-failure `sleep(10)` (`:216`).
- Config evidence: `Settings::get('comgate')` → keys `secret`, `merchant` used here (`:49,:128-131,:145-149`); same settings array also holds `paymentsUrl`/`paymentsUrl2`/`test` used by the recurring flow (`comgate/src/ComgateCron.php:21-29`). Secret values `<redacted>`. Endpoints hardcoded to `https://payments.comgate.cz/v1.0/{transferList,singleTransfer}` (`:134,:152`).

---

### Scoping conflict (recorded, not resolved silently)
The flow-index and this task list `comgate_cron` as a secondary trigger for FL031. **Code evidence contradicts this:** `comgate_cron` (`comgate/comgate.module:15-37`) invokes `ComgateCron::execute()` → `transactionRecurring()` (`comgate/src/ComgateCron.php:15-20`), which is the **recurring-charge** flow (dossier FLW0007 / FL024), issuing `createTransaction` and writing new `transaction` + `transaction_recurring` rows. It never calls `transferList`/`singleTransfer` and performs no reconciliation UPDATE. The transferList reconciliation exists **only** in the Drush `comgatesync` command. `Conflict — requires clarification`: FL031's automatic scheduling is unconfirmed; the only evidenced trigger is manual CLI. Marked `Confirmed` for the CLI path, `Hypothesis` for any cron scheduling of transferList.

### Not in scope of this flow (cross-reference)
- `transaction_comtobank` / `TransactionComToBankEntity` (accounting module) is **not written by this flow.** It is produced by the manual accounting form `accounting/src/Form/ComgateToBankForm.php` and `TransactionComToBankEntityForm.php` (FL032). This dossier corrects the task's suggestion that `comgatesync` updates `transaction_comtobank` — only the `transaction` table is written here (`ComgateSyncCommand.php:204-206`).
- Sibling SRV0009 reconciliation flows: FLW0011 (Moneta AISP import, FL029), FLW0012 (bank-mail IMAP import, FL030). This flow is the ComGate-specific reconciliation leg.
- Payment-time ComGate integration: FLW0003 (payment callback, FL021), FLW0007 (recurring charge, FL024).
