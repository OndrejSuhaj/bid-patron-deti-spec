# QUERY synthesis — evidence notes

Verbatim source anchors used to build the QUERY layer. Paths are relative to
`intake/current-solution/_source/patronus/`. No secrets present; nothing to redact.

## Account zones (QUERY0001, QUERY0002)

- `sync_config/config_czech/views.view.supporter_zone.yml` — base `transaction`, `group_by: true`,
  fields `campaign` + `price` (`group_type: sum`), filters `ext_status = PAID`, `is_donation = 1`,
  arg `user_id` default `current_user`, access role `supporter`, path `zona/darce`.
- `sync_config/config_czech/views.view.donations.yml` sibling → `config/views.view.donations.yml`
  (block, access `none`, otherwise identical read-model).
- `sync_config/config_czech/views.view.fundraiser_zone.yml` — base `application`, arg `fundraiser`
  default current_user, validate `entity:user` restrict roles `fundraiser`, row entity view mode
  `fundraiser_s_teaser`, `distinct: true`, `query_tags: fundraiser_applications`, path `zona/zadatel`.
- `sync_config/config_czech/views.view.patron_zone.yml` — base `application`, arg `patron`, restrict
  roles `patron`, path `zona/patron`.
- `config/views.view.fundraisers_applications.yml` — displays: default (arg `fundraiser`
  `query_parameter`), page `account` (current_user), block, patron block (current_user); fields incl.
  `child_first_name`, `child_last_name`, `state`, `application_refill_link`.
- `campaign/src/Plugin/rest/resource/v33/CampaignsResource.php`
  `getTransparentAmountDonated()` L442–448 / `getTransparentAmountAllocated()` L450–456 — country
  branch: CZ `transparent=1`, else `is_recurring=1`; allocated excludes `campaign <> transparent`.

## Public story catalogue + region (QUERY0003, QUERY0004, QUERY0005)

- `campaign/src/Plugin/rest/resource/v33/CampaignsResource.php`:
  - filter map L245–256: `status→c.campaign_status`, `category→c.gift_category`, `region→c.kraj`;
    filters keyset L228–237 (id/status/category/flag/region/user_interacted/user_recommended/org).
  - flag→id via raw SQL on `application__flag` L269; org→ids raw SQL L297; empty forces `c.id=0`.
  - order map L390–404 (latest/finished_recently/ends_soon/least_percentual_support); interacted_at
    join L419–420; default order `c.id DESC` L423.
  - exclude L427–440 (NOT IN + infinite campaign id).
  - injected: infinite L501–510, promo L512–520 (index 3), tmp promo L522–530 (index 5).
  - short-data payload `CampaignEntity::getShortData()` L1255–1272 (`raised_amount` reads persisted
    `campaign_raised`, `_percentual_support` reads `campaign_percentual_raised`).
- `campaign/src/Controller/RenderRegionsController.php` — region slug map L19–34 (1..14);
  count query L120–125 `SELECT kraj, COUNT(*) ... WHERE kraj IS NOT NULL AND campaign_status='active'
  GROUP BY kraj`; label rule L145–147.
- `config/views.view.gift_categories.yml` — base `taxonomy_term_field_data`, filters `vid=category`,
  `parent_target_id > 0`, `status=1`, access `access content`, `entity_reference` display.

## Admin lists (QUERY0006, QUERY0007, QUERY0008, QUERY0013, QUERY0014)

- Lead/application: `config/views.view.leads.yml` (all/my/default), `scoring.yml`,
  `priprava_pribehu.yml` (`moderation_state = application_workflow-in_progress`),
  `leads_init_patron.yml` (`lead_role=patron`, `published` not empty), `contracts.yml`,
  `empty_confirmation_signature.yml` (html not empty, digital_signature empty, file not empty).
- Story: `config/views.view.view_campaign.yml` — `campaign_raised`, `bank_views_field`
  (`CampaignEntity::getCampaignReceivedMoney()` L1230–1242 `is_sent_to_bank=1 AND ext_status=PAID`).
- Transactions: `config/views.view.view_transactions.yml` (default + page_1..page_5:
  payments-by-date `ext_status=PAID`+created range; without_campaign; not_donations; refunded
  `ext_status=REFUNDED`), `recurring.yml`, `vouchers.yml`, `payments_report.yml` (access `none`).
- Party/CRM: `accounts.yml` (exposes `rc`), `organisations.yml`, `suppliers.yml`,
  `admin_partners.yml`, `manager_users.yml` (`mail ends 'patrondeti.cz'`), `user_admin_people.yml`.
- Comms/audit: `emails.yml`, `emails_per_user.yml`, `application_activity.yml` (access `none`,
  `field_name='activity'`), `campaign_log.yml` (`field_name='campaign_status'`),
  `application_reactions.yml`, `application_actions.yml`, `feedbacks.yml`, `transaction_mails.yml`,
  `watchdog.yml`.

## Reporting + costs/snapshot (QUERY0009, QUERY0010)

- `reports/reports.routing.yml` — routes + permissions (`access reports`, `access accounting reports`,
  `access productivity reports`).
- `reports/src/Controller/DashboardController.php` L70–131 (weekday sum/count, weekday×hour heatmap,
  `ext_status LIKE 'PAID'`).
- `TransactionsReportsController.php` L49–53 headline scalars (`transparent=1 AND test=0 AND
  ext_status='PAID'`; balance hard-codes `campaign = 3100`); L110–147 paid donation sum/count/avg by
  year(/month) `is_donation=1`.
- `CampaignsReportsController.php` L57–68 published BETWEEN range; by-cord L127–137; by-days L203+.
- `ApplicationsReportsController.php` L68–81 counts by year/month `state NOT LIKE mistake/duplicate`.
- `MonthlyReportController.php` L372/396 `Settings::get('country')=='cz'` → `campaign <> 2200`/`id<>2200`;
  L378–398 active applications by `log.field_value LIKE :campaign_status`.
- `ProductivityReportsController.php` L112–199, L364–399, L454–463 (per-coordinator throughput, gift
  price sums, cord-apps by date range).
- `AccountingReportsController.php` L66–89 (`SUM(tr.price)` per campaign per bank_month,
  `ext_status=PAID`, GROUP BY cmp_id, months); files from `application_attachments_audit-archive/`.
- `config/views.view.naklady.yml` — base `costs_entity`, roles administrator/manager, path
  `admin/naklady`; fields year/month/cost/costs_target/campaigns_target(_value)/donations_target_value.
- `reports/src/Entity/CostsEntity.php` L205–403 base fields (incl. `obedyskolakum_students`,
  `obedyskolakum_amount`, `published_campaign_count`, `published_campaign_price`).
- `reports/src/Entity/SnapshotEntity.php` — fields `report_id`, `field_name`, `field_value`, `created`,
  `user_id`; lookup entity query L197–205 (`created BETWEEN`, `report_id`).

## CSV export (QUERY0011)

- `export_csv/export_csv.routing.yml` — 20 routes; perms `access reports` / `access accounting reports`
  / `export leads`.
- `export_csv/src/Controller/ExportCSVController.php`:
  - constructor L41–54: `/tmp/<routeSuffix>_YYYY_MM_DD.csv` cached-file serve.
  - `dumpLeads()` L946–1059: full PII (`zz_rc`, `zz_phone`, `zz_email`, address, `child_handicapped`,
    patron fields), `INTO OUTFILE :file`.
  - `dumpPatrons()` L1151+ PII columns rc/phone/email/street/city/psc/employer/position.
  - `dumpUniquePatrons()`/`dumpSupporters()` L1210/1243: `SUM(price), COUNT(*)`, `ext_status='PAID'
    AND test=0`, GROUP BY mail.
  - `dumpAccounting()` L1436: `SUM(tr.price)` per campaign per bank_month, `ext_status='PAID'`.
  - `dumpBlacklist()` L556: `JSON_EXTRACT(a.scoring,'$.fundraiser_blacklist')='bl' OR ...patron...`.
  - `dumpPatroni()` L320: per-year/per-month `COUNT(IF(YEAR(...)=2017..2022 ...))` hard-coded windows.
  - `downloadFile()` L1524–1541: `LOAD_FILE(:file)`, CSV headers/`Content-Disposition`.

## Search (QUERY0012)

- `patron_search/src/Plugin/Block/SearchBlock.php` — mounts external app from `els1.patrondeti.cz`
  (prod) / staging / localhost; renders only when `isAdmin()`.
- `patron_search/src/Command/EsUploadCommand.php`, `.../QueueWorker/EsUploadQueue.php`,
  `.../PatronSearchCron.php` — index write side (FN0022).
- External query semantics (fields/ranking/result shape) are NOT in the analysed Patronus source →
  Hypothesis / Uncertain.
