---
doc_id: ACL0004
title: Campaign, Story & Content Access
canonical_layer: ACL
spec_type: access-control
status: draft
references:
  - EN0004
  - EN0005
  - EN0013
  - EN0024
  - EN0021
  - UC0011
  - UC0023
  - FN0006
  - FN0011
  - BR-CampaignStoryLifecycle
  - BR-VoucherPolicy
  - ARCH0005
---

# ACL0004 – Campaign, Story & Content Access

## Purpose

Access to campaign/story (EN0004 Campaign, EN0005 Patron/story), CMS content (blog EN0024, pages,
success pages, blocks, taxonomy), Voucher (EN0013), Feedback (EN0021), and public read of published
campaigns/media. Actor model owned by ACL0001.

## Actor Model

- `content_admin` and `marketing` are the primary content/campaign roles. `marketing` owns CMS
  authoring (blog/page/success_page/blocks/gutenberg); `content_admin` owns campaign/patron/taxonomy
  administration. `manager` holds broad campaign/blog CRUD. `anonymous`/`authenticated` read published
  campaigns and media.
- Scope is `global`/`platform` for back-office; `public` for read.

Evidence: `config/user.role.content_admin.yml`, `config/user.role.marketing.yml`,
`config/user.role.manager.yml`, `config/user.role.anonymous.yml`; permission defs
`campaign/campaign.permissions.yml`, `blog/blog.permissions.yml`, `voucher/voucher.permissions.yml`,
`feedback/feedback.permissions.yml`.

## Resources

- Campaign (EN0004) — CRUD, `edit campaign state`, `view campaign content page`
- Patron/story entity (EN0005) — CRUD (`patron entity entities`)
- Voucher (EN0013) — view (back-office); redeem/apply via public REST (ACL0009)
- Blog (EN0024) + node types (page, form_page, success_page) — authoring
- Reusable blocks / block library — CRUD
- Taxonomy (category, city, blog_category, faq_categories, gift_confirmation, etc.) — term CRUD
- Feedback (EN0021) — write/administer
- Published campaigns + media — public read

## Matrix

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `content_admin` | Campaign (EN0004) | add, administer, edit, `edit campaign state`, view content page | global | `add/administer/edit campaign entities`, `edit campaign state`, `view campaign content page`. |
| `content_admin` | Patron/story (EN0005) | add, edit, view published/unpublished | global | `add/edit patron entity entities`, `view (un)published patron entity entities`. |
| `content_admin` | Taxonomy | administer; edit terms (category/city/faq/housing/income/partners/gift_confirmation) | global | `administer taxonomy`, `edit terms in *`, `delete terms in gift_confirmation`. |
| `content_admin` | Nodes / blocks | administer nodes/content types/blocks; `bypass node access` | platform | `administer nodes`, `administer content types`, `administer blocks`, `bypass node access`. |
| `content_admin` | Voucher (EN0013) | view published | global | `view published voucher entity entities`. |
| `marketing` | Blog (EN0024) | add, administer, edit, delete (own+any), revisions | global | `add/administer/edit/delete blog entity entities`, `create/edit/delete any/own blog content`. |
| `marketing` | Node types page/form_page/success_page | create/edit/delete (own+any), revisions | global | Full authoring incl. `bypass node access`. |
| `marketing` | Gutenberg content blocks | create/edit custom blocks; use gutenberg | global | `create and edit custom gutenberg content blocks`, `use gutenberg`. |
| `marketing` | Reusable blocks / block library | create/edit/delete/revert | global | `create/edit/delete any reusable_block block content`, `manage blocks lock`. |
| `marketing` | Campaign (EN0004) | edit | global | `edit campaign entities`. |
| `marketing` | Interface translation | translate | platform | `translate interface`, `use text format gutenberg`. |
| `manager` | Campaign (EN0004) | add, administer, edit, `edit campaign state`, view | global | Full campaign CRUD; `view campaign content page`. |
| `manager` | Patron/story (EN0005) | add, edit, view | global | `add/edit patron entity entities`, `view (un)published patron entity entities`. |
| `manager` | Blog (EN0024) | add, administer, edit, delete, view | global | Full blog CRUD; `edit terms in blog_category`, `create/delete terms in category`. |
| `manager` | Voucher (EN0013) | view published | global | `view published voucher entity entities`. |
| `front` | Campaign (EN0004) | edit | global | `edit campaign entities`; `view published voucher entity entities`. |
| `coordinator` | Campaign transitions | use `canceled_campaign`,`suspended_campaign` | global | Campaign-related workflow transitions in coordinator config. |
| `content_admin`,`manager`,`marketing`,`risk_manager` | Feedback (EN0021) | add | global | `add feedback entities` (content_admin, manager, marketing). |
| `anonymous` | Published Campaign (EN0004) | view | public | `view published campaign entities`. |
| `anonymous` | Media / media gallery | view | public | `view media`, `view published media gallery entities`. |
| `authenticated` | Published Campaign / media | view | public | Same as anonymous + `rotate images`. |

## Exceptions

- `bypass node access` (content_admin, manager, marketing) overrides per-node access control for
  Drupal nodes — a platform-level escalation for content roles.
- Campaign transitions (`canceled_campaign`, `suspended_campaign`) are part of the Application
  workflow permission set and inherit the transition-legality gaps (ACL0001 G-02/G-06).
- Voucher redemption/validation is a public REST action, not a back-office grant — see ACL0009 and
  BR-VoucherPolicy.

## References

- UC: UC0011 (manage campaign/story lifecycle), UC0023 (browse/filter story catalogue), UC0009 (redeem/validate voucher)
- FN: FN0006 (campaign/story lifecycle), FN0011 (voucher redemption), FN0024 (campaign recommendation)
- EN: EN0004 (Campaign), EN0005 (Patron), EN0013 (Voucher), EN0021 (Feedback), EN0024 (Blog)
- BR: BR-CampaignStoryLifecycle, BR-VoucherPolicy
- ARCH: ARCH0005 (Campaign and Story)

## Open Items

- None beyond the shared transition-legality gaps.
