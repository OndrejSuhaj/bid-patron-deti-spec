# FLW0031 — Admin reports (`/admin/reports/*`) money & productivity read-model
> AR:FlowMiner dossier · 2026-07-03 · source FlowID FL034 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL034 (dossier FLW0031)
- Flow Name: Admin reports (`/admin/reports/*`) money/productivity/campaign read-model (dashboard + tables)
- Primary SRV: SRV0010 (Reporting-ReadModel — the **READ** side of SRV0010; the CSV-Export-Processor write side is FLW0027)
- Trigger Evidence:
  - 11 routes in `reports/reports.routing.yml` → 7 controllers under `reports/src/Controller/` (repo path `intake/current-solution/_source/patronus/web/modules/custom/reports/`)
  - Menu entry `reports.main.menu` → `reports.monthly_report` (`reports/reports.links.menu.yml:1-5`); `reports.productivity.menu` (`:36-40`)
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger:
  - Authenticated admin/back-office user opens a `/admin/reports/*` page. Route→controller map (`reports/reports.routing.yml`):
    1. `reports.transactions` `/admin/reports/payments` → `TransactionsReportsController::showAllTransactions` (`:1-7`)
    2. `reports.campaigns` `/admin/reports/campaigns/{beginMonth}/{endMonth}` → `CampaignsReportsController::showAllCampaigns` (`:9-15`)
    3. `reports.campaigns_by_cord` `/admin/reports/campaigns/{beginMonth}/{endMonth}/{uid}` → `CampaignsReportsController::showCampsByCord` (`:17-23`)
    4. `reports.campaigns_by_days` `/admin/reports/campaigns-by-days/{beginMonth}/{endMonth}/{min}/{max}` → `CampaignsReportsController::showCampsByDays` (`:25-31`)
    5. `reports.cord_applications` `/admin/reports/cord-applications/{beginDate}/{endDate}/{userName}` → `ProductivityReportsController::showCordApps` (`:33-39`)
    6. `reports.accounting` `/admin/reports/accounting` → `AccountingReportsController::showMonthlyPaidCampaigns` (`:41-47`)
    7. `reports.applications` `/admin/reports/leads` → `ApplicationsReportsController::showAllApplications` (`:49-55`)
    8. `reports.monthly_report` `/admin/reports/monthly-report` → `MonthlyReportController::showReports` (`:65-71`)
    9. `reports.productivity` `/admin/reports/productivity` → `ProductivityReportsController::productivityReports` (`:73-79`)
    10. `reports.dashboard_controller_viewDashboard` `/admin/reports/dashboard` → `DashboardController::viewDashboard` (`:81-87`)
  - Note: an 11th route (`reports.application_statuses`) is **commented out** (`reports.routing.yml:57-63`). `CurrentProductivityReportsController::showCurrentProductivity` **has no route in this module** (dead/externally-routed code) — see Failure Modes. Confirmed.
- Preconditions:
  - Permission gate per route: 8 routes require `access reports`; `reports.accounting` requires `access accounting reports`; `reports.productivity` requires `access productivity reports` (`reports.routing.yml` `requirements._permission`).
  - Permission grants (config): `access reports` → roles `senior_coordinator`, `marketing`, `risk_manager`, `manager` (`config/user.role.*.yml`); `access accounting reports` → `manager`; `access productivity reports` → `coordinator`, `senior_coordinator`, `marketing`, `risk_manager`, `manager`. Confirmed.
  - Route args are **positional path params supplied by the caller** (`{beginMonth}`, `{endMonth}`, `{uid}`, `{userName}`, `{min}`, `{max}`, `{beginDate}`, `{endDate}`) — many are interpolated into raw SQL (see Failure Modes / SQLi surface).
  - Read-only: no domain precondition on state; requires the underlying tables to be populated (`transaction`, `campaign`, `application`, `application_states`, `campaign_log`, `costs_entity`).
- Main Steps (each report is independent; representative traces):
  1. **Payments report** (`TransactionsReportsController::showAllTransactions`, `:31`) — builds 4 tables: monthly donations (`getMonthsTransactionsData`, `:109`, a 3-part `UNION` grouping by month/year/total over `transaction` where `ext_status='PAID' AND test=0 AND is_donation=1`), by-category-and-price (`prepareTransByCategories`→`getTransByCatAndPrice`, `:446`, joins `campaign.gift_category` to `taxonomy_term` category vocabulary via `getCategoryTermsVocabulary`, `:429`), weekly (`getTransDataInWeekInterval`, `:344`, 12 calendar-week buckets using Drupal DBTNG `select()`), and a hard-coded "Transparentní účet" panel (`:49-53`) with **literal SQL constants** incl. `campaign = 3100` balance and an on-screen note that 2 925 984 Kč was "uměle přihozeno" (artificially added). Confirmed.
  2. **Leads report** (`ApplicationsReportsController::showAllApplications`, `:29`) — monthly + weekly counts of `application` rows excluding `state` `mistake`/`duplicate` (`getMonthsApplicationsData` `:67`, `getApplsDataInWeekInterval` `:94`); cells rendered as deep-links to `/admin/leads?created=…` (inline_template, `:157-167`). Confirmed.
  3. **Campaigns report** (`CampaignsReportsController`) — `showAllCampaigns` (`:28`) computes lead-created→story-published lead-time (`DATEDIFF` on `application`⋈`campaign`, `prepareLeadCreatToCampPubl` `:55`); `showCampsByCord` (`:90`) loads a `User` by `{uid}` and joins `application_states` where `state='in_progress'` for hours-to-publish per coordinator; `showCampsByDays` (`:170`) filters that lead-time between `{min}`/`{max}` days. `User::load($uid)->getEmail()` is called **before** the null-guard (`:92`). Confirmed.
  4. **Productivity report** (`ProductivityReportsController::productivityReports`, `:49`) — 6 tables: published-story count per coordinator weekly/monthly, published-story `gift_price` sum monthly (`getCampPriceCount` `:389`), taken-leads weekly/monthly (`application_states.state='application_processing'`), and active-applications monthly. Coordinator lists come from `getCords` (`campaign.processing_user_id`⋈`users_field_data`, `:169`) and `getCampsCords` (`application_states.uid`, `:190`). Cells deep-link to `reports.campaigns_by_cord`/`reports.cord_applications`. `showCordApps` (`:423`) drills into taken leads for a `{userName}`. Confirmed.
  5. **Accounting report** (`AccountingReportsController::showMonthlyPaidCampaigns`, `:19`) — `getPaidCampaignsData` (`:66`, DBTNG `select()`) SUMs `transaction.price` per `campaign` × `bank_month` where `ext_status='PAID'` (no `test`/`is_donation` filter here). Also renders: (a) a "Download" button linking to route `export_csv.export_accounting` (the FLW0027 CSV export), and (b) `getFiles()` (`:92`) which `opendir()`s `sites/default/files/application_attachments_audit-archive/` and lists each file as a **public://** download link ("Stáhnout soubory pro magistrát" — files for the municipal authority). Confirmed.
  6. **Monthly report** (`MonthlyReportController::showReports`, `:28`) — the largest aggregation: leads/month (`getLeadsByMonths` `:167`), published/completed/uncompleted/canceled stories by month & gift_price sum (`getCampaignsByMonth` `:264` → `queryForAllApl`/`queryForAllCmpGiftPriceSum`/`queryForAplCrInMonth`, using `campaign.published` and `campaign_log.field_value` status history), monthly donations (`getTransactionByMonth` `:479`), **costs per month** (`getCostsByMonth` `:570`, SUM `costs_entity.cost` grouped by `year`/`month`), then computed ratios: Dary/Náklady, Zveřejněné/Náklady, Náklady/Zveřejněné, lead→story conversion, cost-per-published-story (`prepareTransCostsRelations` `:621` … `prepareCostToOneActiveCamp` `:705`). A second table breaks applications by moderation-state group using `patron_base.application_statuses.*` config sets (`prepareAppsByModStats` `:970`). Confirmed.
  7. **Dashboard** (`DashboardController::viewDashboard`, `:40`) — one Chart.js dataset: payments per weekday (`getPaymentPerWeekDayData` `:69`, `SUM(price)`/`COUNT` over `transaction` where `ext_status LIKE 'PAID'`, **excluding a hard-coded epoch window** `created<1523577600 OR created>1523664000` = 13 Apr 2018). A second bubble chart (weekday×hour) exists but its generator call is **commented out** (`:43`). Renders theme `dashboard` + library `reports/chartjs`. Confirmed.
- Postconditions:
  - **No writes.** Every path is a read-only SELECT rendered into a Drupal render array (`#theme => 'table'` / `'dashboard'`), each with `#cache => ['disabled' => TRUE]` (no page cache; every hit re-queries). Confirmed.
  - No entity mutation, no status transition, no queue/event dispatch.
- Side Effects:
  - Filesystem **read** only in the accounting report: `opendir('sites/default/files/application_attachments_audit-archive/')` + `file_url_generator` links to `public://application_attachments_audit-archive/*` (`AccountingReportsController::getFiles` `:92-104`) — exposes municipal/audit attachment files as public download URLs.
  - Log writes: none from the report controllers themselves; `SnapshotEntity` has a `snapshot_entity` logger channel but is not invoked by this flow (see below).
  - `reports/reports.libraries.yml` attaches `chartjs` to the dashboard.
- Integration Calls:
  - **None.** No external HTTP/API. All data from the primary DB (`\Drupal::database()`) plus one `\Drupal::entityQuery('taxonomy_term')` (category vocabulary) and one local-filesystem directory read. Matches [../../repo-map/integrations.md](../../repo-map/integrations.md) (reports not listed as an external boundary). Confirmed.
- Failure Modes:
  - **SQL injection via route path params (Security — high).** Multiple queries **string-interpolate** caller-supplied path args into raw SQL instead of binding them:
    - `ProductivityReportsController::getCampsCords($mode)` (`:190-199`) interpolates `$mode` (default `'WEEK'`/`'MONTH'`) directly into the SQL function name — internal callers only, but the pattern is unsafe. `Confirmed` (no external `$mode` route today; Hypothesis on exploitability).
    - `MonthlyReportController` interpolates `$monthStart`/`$monthEnd` (derived from `date()`, safe) **and** `$ids` (from a prior `fetchCol`, `queryForAllCmpGiftPriceSum` `:417-427`) and `$year` into literal SQL. Values are DB-sourced/date-formatted so not directly user-controlled today, but the queries are unparameterised. `Confirmed` (unparameterised), `Hypothesis` (current exploitability low).
    - `CurrentProductivityReportsController::getProgressApps/getActiveApps/getCompleteApps` (`:91-156`) `implode` a config-sourced `$statuses` array into an `IN (...)` clause without binding — config-controlled, not request-controlled. `Confirmed`.
    - The genuinely user-facing path params (`{beginMonth}`, `{endMonth}`, `{uid}`, `{userName}`, `{beginDate}`, `{endDate}`, `{min}`, `{max}`) are passed as **bound `:params`** in `CampaignsReportsController` and `ProductivityReportsController::prepareCordAppsByDate` (`:454-466`) → those are safe. `{userName}` is bound (`:cordName`). Net: the request-reachable args are parameterised; the interpolation risk is in DB-/date-/config-derived values. `Confirmed`.
  - **Unbounded / full-table scans (Performance — Money/VAT report latency).** Reports iterate 12 months × 12 weeks with **one query per bucket** (e.g. `getCordAppsWeekly` runs 12 queries per coordinator × N coordinators; `getCostsByMonth`/`getTransactionByMonth`/`getCampaignsByMonth` loop months). `MonthlyReportController::showReports` fans out to dozens of aggregate queries per page load with page cache disabled. On large data this is slow and can time out. `Confirmed` (query fan-out), `Hypothesis` (timeout at scale).
  - **`User::load($uid)->getEmail()` NPE (Data/UX).** `CampaignsReportsController::showCampsByCord` (`:92`) dereferences `User::load($uid)` before checking the table result; an invalid/deleted `{uid}` → fatal `null->getEmail()`. `Confirmed`.
  - **Hard-coded magic constants embedded in reports (Correctness/Money).** `campaign = 3100` (transparent-account balance) and `campaign <> 2200` (`Settings::get('country')=='cz'` special-case, `MonthlyReportController` `:371,396,416,439,460`), start-year literals `2018-01-01`/`2023-01-01`, and the dashboard's `1523577600/1523664000` epoch exclusion are all baked into SQL. A visible on-screen disclaimer states 2 925 984 Kč was **artificially added** to the transparent-account donation total (`TransactionsReportsController` `:62`). These make the money figures environment- and history-specific and non-portable. `Confirmed` (Money accuracy / Boundary).
  - **Dead / unrouted code.** `CurrentProductivityReportsController::showCurrentProductivity` has **no route** in `reports.routing.yml`; `getActiveApps` etc. reference `patron_base.application_statuses.monthly_*` config and a `view.leads.all` route. Also `reports.application_statuses` route and the weekday×hour chart are commented out. `Confirmed` (maintenance risk; do not carry forward blindly).
  - **`snapshot_entity` is unused by this flow.** Despite the flow-index listing `snapshot_entity` as an entity for FL034, **no report controller reads or writes `snapshot_entity`**; it is an independent CRUD entity (`SnapshotEntity`, own routes/forms) with a static `getEntityBetwCreated` helper that has **no caller in custom code** (grep-confirmed). `Costs` come from `costs_entity` (Monthly report). Recorded as a flow-index correction, not a conflict. `Confirmed`.
  - **Public exposure of municipal/audit files (Security/Legal).** `getFiles()` lists everything in `public://application_attachments_audit-archive/` as anonymous-downloadable `public://` URLs; only the *listing page* is permission-gated (`access accounting reports`), the file URLs themselves are public once known. `Confirmed` (Security/Legal — attachments may contain PII).
  - **Multi-tenant leakage (Multi-tenant).** Only `MonthlyReportController` applies a country guard (`campaign <> 2200` when `country=='cz'`); the payments/leads/campaigns/productivity/dashboard reports apply **no country/tenant (CZ/RO/MD) predicate**, so on a shared instance figures are global. Consistent with FLW0027's finding. `Confirmed`.

## C. Data Footprint
- Entities Written:
  - **None** — read-only reporting flow (no INSERT/UPDATE/DELETE anywhere in the 7 controllers).
- Entities Read (raw DB tables — read-only SELECTs unless noted):
  - `transaction` — payments/dashboard/monthly/accounting aggregates (price, created, ext_status, test, is_donation, transparent, campaign, user_id, bank_month) — `TransactionsReportsController.php:49-53,110,165,196,240,451`; `AccountingReportsController.php:66-77`; `MonthlyReportController.php:479-535`; `DashboardController.php:70,110,126`
  - `campaign` — published, gift_price, gift_category, processing_user_id, id (2200/3100 specials) — `TransactionsReportsController.php:455`; `CampaignsReportsController.php:57,127,203`; `ProductivityReportsController.php:112,172,364,392`; `MonthlyReportController.php:397,421,461`
  - `application` — created, state, campaign, lead_user_id — `ApplicationsReportsController.php:67,117`; `CampaignsReportsController.php:57,127,203`; `ProductivityReportsController.php:454,652`; `MonthlyReportController.php:170,378,445,729-923`; `CurrentProductivityReportsController.php:95-151`
  - `application_states` — audit/history table (uid, state, changed, application_id) for coordinator productivity & lead-time — `CampaignsReportsController.php:136`; `ProductivityReportsController.php:191,455,607,652,709`
  - `campaign_log` — campaign_id, field_value (status), start — status-history for monthly published/completed/… counts — `MonthlyReportController.php:383,450`
  - `costs_entity` — cost, year, month (custom content entity, `base_table costs_entity`) — `MonthlyReportController.php:586-603` (also surfaced via `views.view.naklady` link, `:126`)
  - `users_field_data` — uid, name, status (coordinator lookup) — `ProductivityReportsController.php:175,192,460`
  - `taxonomy_term` (via `entityQuery`, vocabulary `category`) — `TransactionsReportsController.php:429-443`
  - user entity via `User::load()` — `CampaignsReportsController.php:92,124`
  - Filesystem: `sites/default/files/application_attachments_audit-archive/` directory listing — `AccountingReportsController.php:93`
  - Config read (not a table): `patron_base.application_statuses.monthly_*` and `Settings::get('country')` — `MonthlyReportController.php`, `CurrentProductivityReportsController.php`
  - **NOT read:** `snapshot_entity` (flow-index listed it, but no report controller touches it — correction).
- Constraints involved:
  - None enforced by this flow (pure read + render). Correctness depends on upstream integrity of `transaction.ext_status/test/is_donation/bank_month`, `campaign.published/gift_price`, `campaign_log.field_value`, and `costs_entity` being maintained by hand (Costs entity CRUD forms).
  - **No VAT/DPH computation exists** anywhere in the reports module (grep-confirmed: no `vat`/`dph`/`tax_rate`/`21 %`). The "money/VAT reporting" label in the task refers to money figures + the municipal accounting export; VAT is not modeled here. `Confirmed`.
- Multi-tenant scope assumptions:
  - Global (no tenant predicate) for payments/leads/campaigns/productivity/dashboard; partial `country=='cz'` special-casing (`campaign 2200`) only in `MonthlyReportController`. Same multi-tenant concern as FLW0027. `Confirmed`.

## D. Evidence Block
- Controller paths (all under `intake/current-solution/_source/patronus/web/modules/custom/reports/src/Controller/`):
  - `TransactionsReportsController.php` (`showAllTransactions` `:31`; monthly/weekly/category aggregates `:109-493`; hard-coded transparent-account panel `:49-68`)
  - `ApplicationsReportsController.php` (`showAllApplications` `:29`; `:67-213`)
  - `CampaignsReportsController.php` (`showAllCampaigns` `:28`, `showCampsByCord` `:90`, `showCampsByDays` `:170`)
  - `ProductivityReportsController.php` (`productivityReports` `:49`, `showCordApps` `:423`, `getCords` `:169`, `getCampsCords` `:190`)
  - `AccountingReportsController.php` (`showMonthlyPaidCampaigns` `:19`, `getPaidCampaignsData` `:66`, `getFiles` `:92`)
  - `MonthlyReportController.php` (`showReports` `:28`, `getCampaignsByMonth` `:264`, `getCostsByMonth` `:570`, ratio builders `:621-715`, `prepareAppsByModStats` `:970`)
  - `DashboardController.php` (`viewDashboard` `:40`, `getPaymentPerWeekDayData` `:69`)
  - `CurrentProductivityReportsController.php` (`showCurrentProductivity` `:31` — **unrouted**, dead)
- Service methods: none (no injected services; all controllers `new` a `\Drupal::database()` in their constructor — no DI, `ControllerBase`). Read helpers are private/protected methods on each controller (enumerated above).
- Repository usage: direct DB access only via `\Drupal::database()->query(...)` (raw SQL) and `->select(...)` (DBTNG) — no entity storage/repository for the read side. `costs_entity`/`snapshot_entity` are Drupal content entities (`ContentEntityBase`, `base_table` `costs_entity`/`snapshot_entity`, `reports/src/Entity/`) but the reports read `costs_entity` via raw `select()`, not via entity storage.
- Event listeners: none (no dispatched/subscribed events).
- Async messages: none (no Drupal queue). No `reports.module` file exists → **no `hook_cron`** in this module; reports are computed **on page request**, not pre-materialised. `Confirmed`.
- Config evidence:
  - `reports/reports.routing.yml` — 10 active routes (+1 commented) with permission requirements (`access reports` / `access accounting reports` / `access productivity reports`).
  - `reports/reports.permissions.yml` — declares the 3 report permissions + costs/snapshot entity CRUD permissions.
  - `reports/reports.links.menu.yml` — `reports.main.menu` (→ monthly), `reports.productivity.menu`, plus costs/snapshot structure links.
  - `reports/reports.libraries.yml` — `chartjs` library (dashboard).
  - `reports/templates/{dashboard,reports,snapshot_entity}.html.twig` — render templates.
  - `config/user.role.{coordinator,senior_coordinator,marketing,risk_manager,manager}.yml` — grant `access reports` / `access accounting reports` / `access productivity reports`.
  - `config/views.view.naklady.yml` — Views listing over `costs_entity` (linked from Monthly report "Costs" button).
  - Cross-ref: [../../repo-map/integrations.md](../../repo-map/integrations.md) (reports has no external boundary); [../../evidence/db-inventory.md](../db-inventory.md):45,55,56 (`campaign_log`, `costs_entity`, `snapshot_entity` content entities); [FLW0027_csv-export.md](FLW0027_csv-export.md) (the SRV0010 **export** side; `export_csv.export_accounting` button links here).

> Note on flow-index reconciliation (FL034): the index lists "10 routes" and entities "costs_entity, snapshot_entity, transaction". Actual: **10 active routes** (11th commented) → 7 controllers. `transaction` + `costs_entity` are read; **`snapshot_entity` is NOT read by any report** (independent CRUD entity, `getEntityBetwCreated` has no caller). `campaign`, `application`, `application_states`, `campaign_log`, `users_field_data`, `taxonomy_term` are the additional read tables. Recorded as index correction, not a conflict.
