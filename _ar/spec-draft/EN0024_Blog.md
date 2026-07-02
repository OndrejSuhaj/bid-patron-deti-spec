---
doc_id: EN0024
title: Blog
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004  # Campaign — blog.cta_campaign → campaign
  - EN0008  # User — blog.user_id (author)
---

# EN0024 — Blog

## Description
Custom blog-post content entity — **distinct** from the Drupal core `node.blog` bundle (which is rejected CMS content sharing the name). A full-featured editorial entity with title/perex/body, image + gallery, an auto-generated slug, a configurable call-to-action block (button / cards / application CTA) that can link to a Campaign, and a single "hero post" mechanism. Backed by a substantial custom module (18 PHP files, ~1740 LOC; the entity class alone is ~600 LOC) with its own list builder, access handler, route provider, service, controllers, forms, Views integration, and v32 REST resources.

## Entity Category
Content · Confidence: Medium
(Schema confirmed + non-trivial custom module with REST/Views surfaces; content/marketing rather than core domain, hence Medium not High.)

## Origin
- DB artifacts: base_table `blog`. `blog.install` has only update_8001; no hook_schema.
- Code touchpoints:
  - `blog/src/Entity/BlogEntity.php` (~600 LOC) — entity; uses EntityPublishedTrait; `preSave:76` (single-hero enforcement `update blog set is_hero_post=false` :84; slug via `patron_base.default::generateSlug` :527); `getOwner:176`.
  - `blog/src/BlogService.php`, `BlogEntityListBuilder.php`, `BlogEntityAccessControlHandler.php`, `BlogEntityHtmlRouteProvider.php`, `BlogAdminThemeNegotiator.php`.
  - `blog/src/Form/{BlogEntityForm,BlogEntityDeleteForm,BlogEntitySettingsForm}.php`.
  - `blog/src/Controller/{NodeBlogController,PublishToHomepageController}.php`.
  - `blog/src/Plugin/rest/resource/v32/{Post,Posts,Category,Categories}Resource.php`; `blog/src/Plugin/views/field/LinkToBlogViewsField.php`.
Evidence: db-models.md `blog`; measured 18 PHP files / 1740 LOC (`BlogEntity.php` 600 LOC); grep (EntityPublishedTrait, preSave slug + is_hero_post raw SQL).

## Core Fields
- `name` (string 75; required; "Titulek"; entity label)
- `perex` (string_long) / `body` (text_long) (optional)
- `slug` (string; optional; auto-generated in preSave; no unique key declared)
- `image` (image, public; 1) / `gallery` (image, public; ∞)
- `category` (er → taxonomy_term `blog_category`; ∞)
- `cta_type` (list_string; button / cards / application_cta)
- `cta_title` / `cta_button_text` / `cta_button_link` (string 200)
- `cta_campaign` (er → EN0004 Campaign; builds "/pribeh/{slug}" link)
- `cta_filter` (list_string; ends_soon / least_percentual_support / filter_region / filter_category)
- `cta_filter_region` (er → kraj) / `cta_filter_category` (list_integer; hardcoded tids 71–76, soft ref)
- `is_hero_post` (boolean; single-hero enforced procedurally in preSave, NOT a DB constraint)
- `status` (boolean published; via publishedBaseFieldDefinitions())

## Technical Fields
- `user_id` (er → EN0008 User; optional; author)
- `created` / `changed` (timestamps)
Evidence: db-models.md `blog`.

## Relations
- `user_id` → EN0008 User (author). Evidence: db-models.md; BlogEntity.php:176.
- `cta_campaign` → EN0004 Campaign. Evidence: db-models.md.
- `category` → taxonomy_term (blog_category); `cta_filter_region` → kraj; `image`/`gallery` → file. Evidence: db-models.md.

## Allowed Statuses
`status` boolean only (published / unpublished). `is_hero_post` is a single-hero flag (procedurally exclusive), not a lifecycle state. No domain status enum. Evidence: db-models.md `blog`.

## Lifecycle
- (create/edit) → published; slug auto-generated in preSave; saving a hero post clears all other `is_hero_post` flags via raw SQL. Confirmed at code level (BlogEntity.php:76,83-84,527) — Uncertain as a modelled transition (no flow dossier mines Blog; single-hero and slug uniqueness are application logic only, not DB constraints).
- Hypothesis — no dedicated flow dossier (FLW*) covers Blog; lifecycle beyond create/publish/hero-toggle not traced. Missing evidence: publish-to-homepage controller behavior and REST write paths.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Slug has no unique key — collisions rely on `generateSlug` logic only; is uniqueness guaranteed?
2. Single-hero via `update blog set is_hero_post=false` is a global unconditioned UPDATE (no tenant scope) — intended for single-country deployment?
3. `cta_filter_category` hardcodes taxonomy tids 71–76 — brittle coupling; is this current behavior authoritative?
4. Relationship/overlap with the core `node.blog` bundle — are both in active editorial use, or is one legacy?
