# FLW0027 — CSV export (scheduled + on-demand)
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL033 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL033 (dossier FLW0027)
- Flow Name: CSV export (scheduled + on-demand)
- Primary SRV: SRV0010
- Trigger Evidence:
  - Scheduled: `export_csv.module:export_csv_cron()` → `export_csv/src/ExportCsvCron.php:ExportCsvCron::execute()` (repo path `intake/current-solution/_source/patronus/web/modules/custom/export_csv/`)
  - On-demand: 19 routes in `export_csv/export_csv.routing.yml` → `export_csv/src/Controller/ExportCSVController.php` methods; index page `DownloadsController::showPage` (`/admin/downloads`)
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger:
  - **Scheduled** — Drupal `hook_cron` (`export_csv_cron`, `export_csv.module:5`) gated by state key `export_csv_cron_time`; on first run it seeds the state to today 03:00 and returns without exporting; on later runs, when `last_check_time + 1 day <= now` it re-seeds to today 03:00 and calls `ExportCsvCron::execute()` (`export_csv.module:14-17`). Net effect: at most one export batch per calendar day, first opportunity after 03:00.
  - **On-demand** — authenticated admin clicks a "Stáhnout (CSV)" link on `/admin/downloads` (`DownloadsController::showPage`) hitting an `/admin/export_csv/*` route which invokes one `ExportCSVController::export*` method (`export_csv.routing.yml:10-134`).
- Preconditions:
  - On-demand permission gates (`export_csv.routing.yml`): most routes require `access reports`; `export_csv.export_leads` requires `export leads`; `export_csv.export_accounting` requires `access accounting reports`. `/admin/downloads` requires `access reports`. (`export_csv.permissions.yml` declares only `export leads`.)
  - Scheduled path runs as cron (no per-user permission check); constructs controller with `new ExportCSVController(true)` (console mode) (`ExportCsvCron.php:14`).
  - **DB-level precondition (critical):** all dumps use MySQL `SELECT ... INTO OUTFILE` (e.g. `ExportCSVController.php:541,570,615,685`), requiring the MySQL server `FILE` privilege, `secure_file_priv` permitting `/tmp`, and the **mysqld** process being able to write `/tmp` on the DB host. `downloadFile()` then reads it back with `LOAD_FILE()` (`ExportCSVController.php:1526`), requiring mysqld read access to the same path. If the web/PHP host and DB host differ, the file written by mysqld is not visible to PHP `file_exists()` — see Failure Modes.
- Main Steps:
  1. **Scheduled batch orchestration** — `ExportCsvCron::execute()` (`ExportCsvCron.php:13`) builds a fixed `$jobs` map of 16 route-name→method pairs (`ExportCsvCron.php:17-34`), computes `$yesterday` and `$today` date strings, and for each job: deletes `/tmp/{routeName}_{yesterday}.csv` and `/tmp/{routeName}_{today}.csv` if present (`deleteFile`, `ExportCsvCron.php:36-37,50-54`), then calls `$controller->{$function}('/tmp/{routeName}_{today}.csv')` (`ExportCsvCron.php:38`), then logs `"{routeName} finished"` via logger channel `csv_export_cron` (`ExportCsvCron.php:42`).
  2. **Per-export method** (e.g. `exportPayments`, `ExportCSVController.php:62`) — sets `_localFilename` to the passed target path (cron) or null (web), sets `_file` = a randomized temp path `/tmp/{prefix}_{timestamp}_{rand(0,255)}.csv` (`ExportCSVController.php:64`), calls the matching private `dump*()`, then `downloadFile()`, then returns a `RedirectResponse` to a Drupal view/route (web path only; ignored in cron).
  3. **`dump*()`** — runs one raw SQL statement via `\Drupal::database()->query(...)` with a literal header row (SELECT of quoted strings) `UNION [ALL]` the data query, terminated by `INTO OUTFILE :file` with `FIELDS TERMINATED BY ','`, `ENCLOSED BY '"'`, `LINES TERMINATED BY '\n'` (accounting omits the `ENCLOSED BY` clause, `ExportCSVController.php:1452-1454`). `:file` is the only bound parameter; all filtering/columns are hard-coded except `dumpPayments`/`dumpOriginalPayments` which read `?campaign=` from the request (`ExportCSVController.php:632-633,702-703`).
  4. **`downloadFile()`** (`ExportCSVController.php:1524`) — `SET @csvfile = LOAD_FILE(:file)` then `SELECT @csvfile`; if `_localFilename` set and not yet present, writes the bytes to that path with `file_put_contents` (`ExportCSVController.php:1529-1531`); if `_fromConsole` returns early (cron persists the file on disk, no HTTP output); otherwise streams the CSV to the browser with `Content-Disposition: attachment` and `exit` (`ExportCSVController.php:1535-1543`).
  5. **On-demand cache-hit shortcut** — the controller **constructor** (`ExportCSVController.php:41-54`) derives a filename from the current route name (`explode('.', routeName)[1]`), computes `/tmp/{that}_{Y_m_d}.csv`, and if that file already exists+readable calls `downloadFile()` immediately (serving the cron-produced daily file without re-querying). This is why cron writes files named by *route* name (`export_payments_2026_07_01.csv`) — they become the same-day cache for web downloads.
- Postconditions:
  - Up to ~16 CSV files present under `/tmp/{routeName}_{today}.csv` after a cron run; previous-day and same-day files removed then re-created.
  - Randomized intermediate files `/tmp/{prefix}_{timestamp}_{rand}.csv` created by mysqld via OUTFILE and **never deleted** (no unlink of `_file`) — accumulate on the DB host `/tmp`.
  - No domain-entity mutations; this is read-only reporting. No status transitions.
- Side Effects:
  - Filesystem writes on DB host (`INTO OUTFILE`) and on PHP host (`file_put_contents`), both under `/tmp` — unencrypted PII at rest (RČ/birth numbers, names, addresses, emails, phones, contract numbers).
  - HTTP response: raw file streamed with `echo ... exit` bypassing the Drupal render/response pipeline (`ExportCSVController.php:1542-1543`).
  - Log writes: channels `csv_export_cron`, `csv_export`, `patroni_export`, `blacklist_export`, `lowrisk_export`, `transaction_export`, `scoringko_export`, `lead_export`, and `reports` (cron wrapper) (`ExportCsvCron.php:42`, `export_csv.module:20`, various `dump*` catch blocks).
  - User-facing messenger error on failure (`\Drupal::messenger()->addMessage(...,'error')`).
- Integration Calls:
  - No external HTTP/API integrations. The only "integration" is the **local filesystem `/tmp`** as a data sink (matches [../../repo-map/integrations.md](../../repo-map/integrations.md):87) plus the MySQL server filesystem features (`INTO OUTFILE` / `LOAD_FILE`).
- Failure Modes:
  - **OUTFILE target already exists** — MySQL `INTO OUTFILE` refuses to overwrite; the randomized `_file` (timestamp+rand 0–255) makes same-second collisions rare but possible → export throws, caught, logged, empty/failed download.
  - **Missing FILE privilege / `secure_file_priv` / mysqld cannot write `/tmp`** — `INTO OUTFILE` throws; caught per-`dump*`, logged, user sees generic error; `downloadFile()` then finds no file, `LOAD_FILE` returns NULL → error message. `Confirmed` (behavior), `Hypothesis` on exact server config.
  - **Split web/DB hosts** — mysqld writes OUTFILE and reads via LOAD_FILE on the DB host; the cron `file_put_contents` writes on the PHP host from the LOAD_FILE bytes, so cross-host works *only* via LOAD_FILE round-trip. If `LOAD_FILE` returns NULL (perms/path), the cron-produced `_localFilename` is written empty (`?? ''`, `ExportCSVController.php:1530`) → silent empty CSV. `Confirmed` in code.
  - **`/tmp` disk exhaustion / leftover randomized files** — `_file` is never unlinked → unbounded growth. `Confirmed` (Data Loss / operational).
  - **Cron first-run no-op** — first cron after empty state seeds `export_csv_cron_time` and returns; no export until the next day (`export_csv.module:9-12`). `Confirmed`.
  - **Cron partial failure** — a `dump*` catch only logs; loop continues, so a batch may leave some files stale/missing. Cron wrapper re-throws only for exceptions escaping `execute()` (`export_csv.module:19-22`). `Confirmed`.
  - **`?campaign=` injection surface** — `dumpPayments`/`dumpOriginalPayments` cast to `(int)` before concatenation (`ExportCSVController.php:632,702`), so SQLi is mitigated; all other queries are static string literals. `Confirmed` (no user-controlled string reaches SQL).
  - **Auth granularity** — `export_csv.export_leads` needs `export leads`; accounting needs `access accounting reports`; but blacklist/scoring-KO/lowrisk (containing RČ + risk verdicts) require only `access reports` — broad exposure of sensitive PII. `Confirmed` (Security/Legal).

## C. Data Footprint
- Entities Written:
  - No AR domain entities written. Physical writes are CSV files on `/tmp` (DB host via OUTFILE; PHP host via `file_put_contents`). Reported as boundary/cross-context side effects, not entity mutations.
- Entities Read (raw DB tables — read-only SELECTs):
  - `transaction` (payments, original payments, supporters, vouchers, accounting, fundraisers) — `ExportCSVController.php:678,746,1254,1308,1447`
  - `application` (leads, campaigns, patrons, fundraisers-full, gift payments, ready gift payments, contracts, scoring KO, blacklist, report-patroni) — `:534,864,924,1022,1126,1187,1394,1497,567`
  - `application_states` (audit table; gift payments, lowrisk) — `:603,793`
  - `aprofile` (gift/patron/fundraiser profile fields) — `:535,796,881,883,927,1040,1127,1188,1412`
  - `contact` (child, fundraiser, patron PII incl. `rc`, phone, email, address) — `:866,873,879,1032,1038,1129,1190,1501`
  - `campaign` — `:536,681,870,1026,1222,1398,1448`
  - `contract` (public_id / contract numbers) — `:795,926,1502`
  - `voucher` — `:1307`
  - `supplier` — `:798,928`
  - `patron` (unique patrons dump) — `:1223`
  - `kraj` (region) — `:886,1045,1417`
  - `users_field_data`, `user__user_name`, `taxonomy_term_field_data`, `application__flag` (join/lookup tables) — throughout
- Constraints involved:
  - None enforced by this flow (pure read + file emit). Relies on DB schema/FKs of the read tables (see [../db-models.md](../db-models.md) for application/aprofile/contact/transaction/contract/voucher).
- Multi-tenant scope assumptions:
  - **No country/tenant (CZ/RO/MD) filter is applied** in any dump query — exports are global across all tenants. `Confirmed` (grep of queries shows no country/domain predicate). This is a multi-tenant boundary concern for a CZ/RO/MD platform.
  - `dumpSupporters` filters `test = 0` and `ext_status='PAID'` (`:1257-1258`); most other dumps have no test/status filter.

## D. Evidence Block
- Controller paths:
  - `intake/current-solution/_source/patronus/web/modules/custom/export_csv/src/Controller/ExportCSVController.php` (constructor cache-hit `:41-54`; export methods `:62-318`; dump methods `:320-1518`; `downloadFile` `:1524-1551`)
  - `intake/current-solution/_source/patronus/web/modules/custom/export_csv/src/Controller/DownloadsController.php` (`showPage` `:21-49` — 18 download links)
- Service methods:
  - `intake/current-solution/_source/patronus/web/modules/custom/export_csv/src/ExportCsvCron.php` (`execute` `:13-44`, `$jobs` map `:17-34`, `getFilepath` `:46-48`, `deleteFile` `:50-54`)
- Repository usage:
  - Direct DB access only via `\Drupal::database()->query(...)` (no entity storage / repository). OUTFILE writes and `LOAD_FILE`/`SET @csvfile` reads (`ExportCSVController.php:1526-1527`). `:file` bound param; `?campaign=` int-cast concatenation (`:632-633,702-703`).
- Event listeners: none (no dispatched/subscribed events).
- Async messages: none (Drupal queue not used). "Async" only in the sense of the daily `hook_cron` batch.
- Config evidence:
  - `export_csv/export_csv.routing.yml` — 19 routes (`/admin/downloads` + 18 `/admin/export_csv/*`) with permission requirements (`access reports` / `export leads` / `access accounting reports`).
  - `export_csv/export_csv.module` — `export_csv_cron()` state-gated daily scheduler (state key `export_csv_cron_time`, 03:00 window).
  - `export_csv/export_csv.permissions.yml` — declares `export leads`.
  - `export_csv/export_csv.links.menu.yml` — `/admin/downloads` under `management.main.menu`.
  - `export_csv/export_csv.info.yml` — module manifest.
  - Cross-ref: [../../repo-map/integrations.md](../../repo-map/integrations.md):87 (Scheduled CSV export → `/tmp`, `Confirmed`); [../../spec-draft/SRV-target-list.md](../../spec-draft/SRV-target-list.md):53 (CSV-Export-Processor, cron, filesystem `/tmp`, SRV0010 export part) and :17 (Reporting-ReadModel, SRV0010 read part).

> Note on START-hint reconciliation: the hint's `$jobs` map is confirmed but the actual cron map is **16** entries (no `export_original_payments`, `export_ready_gift_payments`, `export_gift_payments` is present; `report_patroni`/`export_blacklist`/`export_lowrisk`/`export_scoring_ko` included). The routing exposes **18** export routes + the downloads page (19 total), so 2 exports (`export_original_payments`, `export_ready_gift_payments`) are **on-demand only, never scheduled**. Recorded as detail, not a conflict.
