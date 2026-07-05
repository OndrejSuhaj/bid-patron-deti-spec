# QUERY Layer Map — Patronus read-models & reports

> Canonical read-side contracts for Patronus current state. One QUERY doc per stable read-model /
> report. Source of truth for payloads, filters, and role scope is the Patronus source
> (Drupal 10 custom modules + Views config); the BA prose layers are context. SQL is intentionally
> **not** reproduced — read-side intent only.

## Index

| doc_id | Title | query_type | Primary source (code/config) | Status |
|---|---|---|---|---|
| QUERY0001 | Donor / Supporter Zone Contributions | summary | `views.view.supporter_zone.yml`, `views.view.donations.yml`, `CampaignsResource` donor sums | Partial |
| QUERY0002 | Fundraiser & Patron Account Zones | list | `views.view.fundraiser_zone.yml`, `views.view.patron_zone.yml`, `views.view.fundraisers_applications.yml` | Confirmed |
| QUERY0003 | Public Story Catalogue | search | `campaign/.../rest/resource/v33/CampaignsResource.php` | Confirmed |
| QUERY0004 | Story Region Counts (CZ Map) | summary | `campaign/.../Controller/RenderRegionsController.php` | Partial |
| QUERY0005 | Gift Categories Reference List | list | `views.view.gift_categories.yml` | Confirmed |
| QUERY0006 | Admin Lead / Application Work Lists | list | `views.view.leads.yml`, `scoring`, `priprava_pribehu`, `leads_init_patron`, `contracts`, `empty_confirmation_signature` | Confirmed |
| QUERY0007 | Admin Story List | list | `views.view.view_campaign.yml` (+ `CampaignEntity` raised/received) | Confirmed |
| QUERY0008 | Admin Transaction / Payment & Voucher Lists | list | `views.view.view_transactions.yml`, `recurring`, `vouchers`, `payments_report` | Confirmed |
| QUERY0009 | On-Screen Reporting Dashboards & Reports | dashboard | `reports/src/Controller/*` | Confirmed |
| QUERY0010 | Costs / Targets & Report Snapshot | summary | `views.view.naklady.yml`, `reports/.../Entity/CostsEntity.php`, `SnapshotEntity.php` | Partial |
| QUERY0011 | Reporting CSV Export Bundle | export | `export_csv/src/Controller/ExportCSVController.php` | Confirmed |
| QUERY0012 | Story / Entity Full-Text Search | search | `patron_search/.../Block/SearchBlock.php` (+ ES upload cmd/queue/cron) | Partial |
| QUERY0013 | Admin Party / CRM & User Lists | list | `views.view.accounts.yml`, `organisations`, `suppliers`, `admin_partners`, `manager_users`, `user_admin_people` | Confirmed |
| QUERY0014 | Communication, Activity & Audit Lists | list | `views.view.emails*.yml`, `application_activity`, `campaign_log`, `application_reactions`, `application_actions`, `feedbacks`, `transaction_mails`, `watchdog` | Confirmed |

## Coverage by domain (ARCH cross-reference)

| Domain | QUERY docs |
|---|---|
| Application & Lead (ARCH0003) | QUERY0002, QUERY0006 |
| Risk & Scoring (ARCH0004) | QUERY0006, QUERY0011 (blacklist/low-risk/scoring-KO exports) |
| Campaign & Story (ARCH0005) | QUERY0003, QUERY0004, QUERY0005, QUERY0007 |
| Donations & Payments (ARCH0006) | QUERY0001, QUERY0008, QUERY0009, QUERY0011 |
| Finance & Reconciliation (ARCH0007) | QUERY0008, QUERY0009, QUERY0010, QUERY0011 |
| Party / CRM (ARCH0009) | QUERY0013 |
| Messaging & Marketing (ARCH0010) | QUERY0014 |
| Identity & Access (ARCH0011) | QUERY0013 |
| Platform, Search & Operations (ARCH0012) | QUERY0009, QUERY0010, QUERY0012, QUERY0014 |

## Views inventory disposition (48 views total)

**Covered as domain read-models** (in a QUERY doc): supporter_zone, donations, fundraiser_zone,
patron_zone, fundraisers_applications, gift_categories, leads, scoring, priprava_pribehu,
leads_init_patron, contracts, empty_confirmation_signature, view_campaign, view_transactions,
recurring, vouchers, payments_report, naklady, accounts, organisations, suppliers, admin_partners,
manager_users, user_admin_people, emails, emails_per_user, application_activity, campaign_log,
application_reactions, application_actions, feedbacks, transaction_mails, watchdog.

**Non-domain / CMS & platform plumbing** (intentionally NOT given a QUERY doc — generic Drupal
content/media/redirect/user-widget surfaces with no Patronus read-side business logic):
`archive`, `block_content`, `blog`, `content`, `content_recent`, `files`, `frontpage`, `glossary`,
`media_galleries`, `media_library`, `redirect`, `reusable_blocks`, `same_category_blog_posts`,
`who_s_new`, `who_s_online`. (`blog` is domain-adjacent editorial; recorded here, not modelled as a
read contract.) The Elasticsearch-backed search read surface is covered separately as QUERY0012.

## Systemic read-side hazards (see per-doc Open Items)

- **PII at rest in shared `/tmp`** via `INTO OUTFILE` / `LOAD_FILE`, incl. same-day cached files —
  QUERY0011.
- **Raw SQL with magic campaign-id constants** (`3100`, `2200`) and `Settings::get('country')`
  branches — QUERY0009, QUERY0001, QUERY0003.
- **`LIKE`/`NOT LIKE` substring matching on status/state strings** — QUERY0009.
- **Dual/di­vergent "raised" definition** (persisted `campaign_raised` vs on-demand `SUM(price)`) —
  QUERY0001, QUERY0003, QUERY0007.
- **No country/tenant filter** on back-office lists and exports (single-DB-per-country assumption
  pending) — QUERY0006, QUERY0008, QUERY0011.
- **Unguarded view access (`type: none`)** relying on route wrappers — `payments_report` (QUERY0008),
  `application_activity` (QUERY0014).
