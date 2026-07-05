---
doc_id: API0009
title: Blog Content API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-public
references:
  - EN0024
  - EN0004
  - EN0008
---

# API0009 – Blog Content API

## Purpose

Let a public web/SPA client read editorial Blog (EN0024) content: category listings with their
posts, a single category by slug, a single post by slug (with recommendations), and the flat list of
all posts. This is a read-only content-delivery surface for the marketing/editorial Blog capability —
there is no create/update/delete REST endpoint for Blog in the current source; authoring happens
through the Drupal admin entity forms (`blog.routing.yml` admin routes, out of scope for this REST
contract).

## Consumers

- **Anonymous or authenticated visitor** — public web/SPA channel. No consumer-specific behavior was
  found: all four endpoints execute the same query regardless of caller identity or role beyond the
  REST-method permission gate described under Authorization.

## Contract type

`rest-public` — four **query-style** GET endpoints, all under a single version, `v3.2`
(`/api/3.2/blog/...`). Unlike sibling REST resource families in this codebase (e.g. campaigns,
applications), no `v3.0`/`v3.1`/`v3.3` variant of any Blog resource exists in the current source —
only one plugin class per resource, all namespaced `Drupal\blog\Plugin\rest\resource\v32`. There is
therefore no cross-version behavioral delta to fold; v3.2 is simply the only and current version.

| Resource | Method | Path | Plugin ID | Source |
|---|---|---|---|---|
| Category dashboard | GET | `/api/3.2/blog/dashboard` | `categories_resource_v32` | `CategoriesResource.php` |
| Single category | GET | `/api/3.2/blog/category/{slug}` | `category_resource_v32` | `CategoryResource.php` |
| Single post | GET | `/api/3.2/blog/post/{slug}` | `post_resource_v32` | `PostResource.php` |
| Post listing | GET | `/api/3.2/blog/posts` | `posts_resource_v32` | `PostsResource.php` |

## Authorization

- **Mechanism:** Drupal core REST. All four `rest.resource.*` configs declare
  `authentication: [cookie]` and `methods: [GET]`, `formats: [json]`
  (`rest.resource.categories_resource_v32.yml`, `rest.resource.category_resource_v32.yml`,
  `rest.resource.post_resource_v32.yml`, `rest.resource.posts_resource_v32.yml`).
- **Role grants (Confirmed):** the permissions `restful get categories_resource_v32`,
  `restful get category_resource_v32`, `restful get post_resource_v32`, and
  `restful get posts_resource_v32` are all granted to **both** the `anonymous` and `authenticated`
  roles (`user.role.anonymous.yml`, `user.role.authenticated.yml`). Effectively the endpoints are
  fully public — declaring `cookie` authentication does not require a session, because the anonymous
  role itself already holds the calling permission.
- **No entity-level access check:** none of the four resource `get()` methods call the Blog entity's
  own access control handler (`BlogEntityAccessControlHandler`, which gates on
  `view published blog entity entities` / `view unpublished blog entity entities`). All four resources
  query the `blog` base table and taxonomy tables directly via `\Drupal::database()`, bypassing entity
  access entirely.
- **Published-only exposure is implicit, not access-checked (Confirmed / hazard-adjacent):**
  - `PostsResource` and `BlogService::getPosts()` (used by `CategoryResource` /
    `CategoriesResource`) filter `blog.status = 1` in the SQL directly — so unpublished posts are
    excluded by query construction, not by an access check. `PostResource`, however, loads a post by
    slug (`select id from blog where slug=:slug`) with **no `status` filter at all**: an unpublished
    Blog post is fully readable by any caller (including anonymous) if its slug is known or guessed.
    This is a current-state hazard: unpublished/draft Blog content is exposed through
    `GET /api/3.2/blog/post/{slug}` to anonymous callers, contradicting the
    `view unpublished blog entity entities` permission gate the entity model otherwise defines
    (EN0024; `BlogEntityAccessControlHandler`).
- **No CSRF requirement** beyond Drupal core defaults for authenticated cookie sessions; not
  applicable in practice since GET requests and anonymous access do not require the CSRF token.
- **No rate limiting or throttling** is present in any of the four resource classes or their configs.

## Request

### `GET /api/3.2/blog/dashboard` — Category dashboard

No path or query parameters. Returns the hero post plus every active blog category with its posts.

### `GET /api/3.2/blog/category/{slug}` — Single category

| Field | Meaning | Required | Notes |
|---|---|---|---|
| `slug` (path) | Category taxonomy term's `field_slug` value | yes | Empty or unresolvable slug returns the `invalid_slug` failure outcome below. |
| `limit` (query) | Page size for the category's post list | no | Read directly from the request query string inside `BlogService::getPosts()`/`hasMoreResults()`; only applied when both `limit` and `offset` are present together with a non-empty value — otherwise the full unpaginated post list is returned. Not documented as an explicit REST parameter in the plugin annotation; classified Partial. |
| `offset` (query) | Pagination offset for the category's post list | no | Same pairing behavior as `limit`; defaults to `0` when absent but a default alone does not trigger pagination — see Open Items. |

### `GET /api/3.2/blog/post/{slug}` — Single post

| Field | Meaning | Required | Notes |
|---|---|---|---|
| `slug` (path) | Blog post's `slug` field value | yes | Empty or unresolvable slug returns the `invalid_slug` failure outcome below. No `status` filter is applied — see Authorization hazard. |

### `GET /api/3.2/blog/posts` — Post listing

No path or query parameters. Returns every Blog post row (`blog.status` not filtered — see Side
Effects / hazard note), most recently created first, with no pagination.

## Response

### Success — `GET /api/3.2/blog/dashboard`

| Field | Meaning | Notes |
|---|---|---|
| `hero_post` | Short-form data (see below) of the single post flagged `is_hero_post` (EN0024) | Empty object/array if no post is currently flagged hero. |
| `categories[]` | Array of category-full objects | See "Category-full shape" below; one entry per active `blog_category` taxonomy term, ordered by term weight. |

**Category-full shape** (`BlogService::getCategoryFull()`):

| Field | Meaning | Notes |
|---|---|---|
| `id` | Category taxonomy term ID | Integer. |
| `name` | Category display name | |
| `total_posts` | Count of posts referencing this category | Unfiltered by publish status — counts the `blog__category` reference table directly, so unpublished posts are included in the count even though they are excluded from `posts[]`. Classified Confirmed as observed behavior; flagged as an internal inconsistency, not corrected here. |
| `has_more_results` | Whether more posts exist beyond the current page | Only meaningful when `limit`/`offset` were supplied; otherwise always `false` — see Request notes. |
| `slug` | Category's `field_slug` | |
| `color` | Category's `field_color` | |
| `icon` | Short/derived URL of the category's `field_icon` image, via the shared image-URL helper | Implementation detail of URL derivation intentionally not restated here. |
| `posts[]` | Short-form post data (dashboard call) or full-form (single-category call with `withHeroPost=true`) | See Post-short / Post-full shapes below. On the dashboard call, the hero post is excluded from each category's `posts[]` (`is_hero_post=0` filter); on the single-category call it is not excluded. |

### Success — `GET /api/3.2/blog/category/{slug}`

Same "Category-full shape" as above, with `posts[]` including the hero post if present in that
category (see note above).

### Success — `GET /api/3.2/blog/post/{slug}`

**Post-full shape** (`BlogEntity::getFullData()`):

| Field | Meaning | Notes |
|---|---|---|
| `id` | Blog post ID | Integer. |
| `slug` | Post slug | |
| `categories[]` | Short-form category objects (`name`, `slug`, `color`, `icon`) for this post's categories | Filtered to active (`status = 1`) terms, ordered by weight. |
| `name` | Post title | |
| `body` | Post body, converted from stored HTML to plain text/Markdown-stripped text | Server-side conversion via an HTML-to-Markdown converter with tag stripping; not a raw HTML field. |
| `intercept` | Post lead/teaser text (`perex`), same HTML-to-text conversion | Field name in the response is `intercept`, not `perex` — naming is as observed in source. |
| `published` | Post's created date, formatted as `YYYY-MM-DDT23:59:59` | Fixed end-of-day time component; not the actual creation timestamp. |
| `image` | Short/derived URL of the post's main image | |
| `gallery[]` | Short/derived URLs of the post's gallery images | |
| `cta_type` | CTA kind: `button`, `cards`, `application_cta`, or `null` | See EN0024 for the attribute; CTA sub-fields below are conditionally present per type. |
| `cta_button_text` | CTA button label | Present only for `cta_type = button` or `cards`; for `button`, only if a resolvable target (explicit link, or a linked EN0004 Campaign that is `active` and has a slug) exists — otherwise `cta_type` is nulled out and this field is omitted server-side. |
| `cta_button_link` | CTA button target URL | For `button` with a linked Campaign target, derived as `/pribeh/{campaign.slug}` rather than a stored URL. For `cards`, a stored/configured link. |
| `cta_cards_ids[]` | IDs of up to 3 EN0004 Campaigns selected by the CTA's configured filter | Present only for `cta_type = cards`; selection is one of: ending-soonest-active, lowest-percentual-support-active, active-in-region, or active-in-category (see EN0024 `cta_filter`). Queried directly against the `campaign` table by this module — not through a Campaign API/FN capability. |
| `cta_title` | CTA heading text | Present only for `cta_type = application_cta`. |
| `recommendations[]` | Up to 3 short-form Post objects | Most recently created **published** posts excluding the current one (`status=1`, `id <> current`); see Post-short shape below. |

**Post-short shape** (`BlogEntity::getShortData()`; used for `hero_post`, listing/recommendation
entries, and dashboard `posts[]`):

| Field | Meaning | Notes |
|---|---|---|
| `slug` | Post slug | |
| `link_text` | Localized call-to-action label ("Číst více") | Server-rendered UI copy embedded in the API payload, not user data. |
| `categories[]` | Short-form category objects | Same shape as in Post-full. |
| `name` | Post title | |
| `intercept` | Lead/teaser text, HTML-to-text converted (no bold/italic markers) | Empty string if `perex` is empty (not omitted). |
| `published` | Same fixed end-of-day date format as Post-full | |
| `image` | Short/derived main image URL | |

### Success — `GET /api/3.2/blog/posts`

A bare JSON array of Post-full objects (same shape as the single-post `getFullData()` above,
including `recommendations`... — **Partial/uncertain**: `PostsResource::get()` calls
`getFullData()` per post but does not additionally call `getRecommendations()` the way `PostResource`
does; each post object in this listing therefore has the Post-full shape **without** a
`recommendations` field). Ordered by `created DESC`, unfiltered by publish status (see hazard note
under Side Effects), and not paginated.

### Failure Outcomes

| Outcome | Applies to | Meaning | HTTP status | Retryable | Notes |
|---|---|---|---|---:|---|
| `invalid_slug` | Category, Post | Supplied `{slug}` is empty or does not resolve to any term/post | 400 | yes | Response body: `{"status":"invalid","error":"invalid_slug"}`. |
| *(none modeled)* | Dashboard, Posts listing | No failure branch exists in either resource; both always return 200 with a (possibly empty) result | — | — | If no categories or posts exist, the arrays are simply empty — not an error condition. |

## Side Effects

- **None** — all four endpoints are pure reads; no entity is created, updated, or deleted, and no
  message/notification is emitted (FN/MSG not applicable to this contract).
- **Caching is explicitly disabled** on every response (`addCacheableDependency(false)` /
  `addCacheableDependency(['#cache' => false])`) across all four resources — each request re-executes
  its SQL queries; there is no evidence of an internal cache layer for this content.
- **Hazard — unpublished content exposure (Confirmed):** `GET /api/3.2/blog/post/{slug}` returns a
  Blog post regardless of its `status` (published/unpublished) field, to any caller including
  anonymous — there is no `status = 1` filter in `PostResource::get()`'s lookup query and no entity
  access check. Contrast with `PostsResource` and `BlogService::getPosts()`, which do filter
  `status = 1` in SQL. This is a direct current-state confidentiality gap for draft/unpublished
  editorial content whenever its slug becomes known (e.g. via preview links, search-engine crawl of a
  stale link, or slug guessing since slugs are generated deterministically from the title — see
  EN0024).
- **Hazard-adjacent — direct cross-module SQL against the `campaign` table:** the CTA "cards" and
  "button" resolution logic in `BlogEntity::getCtaInfo()` queries the `campaign` table directly
  (`campaign_status`, `campaign_deadline`, `campaign_percentual_raised`, `kraj`, `gift_category`
  columns) rather than through any Campaign (EN0004) service/API boundary. This is an implementation
  coupling, not an authorization hazard, but is recorded because it means Blog API responses can
  reflect Campaign lifecycle data (EN0004) that this contract does not otherwise own or validate.

## References

- EN: EN0024, EN0004, EN0008
- UC: none — no UC document in the current reconstruction models Blog content delivery as a use case
  (see EN0024 Open Questions; Blog appears to be administered/consumed outside the modelled
  Application/Story/Lead flows).
- FN: none — no FN capability document currently owns Blog content delivery.
- BR: none — no BR document currently constrains Blog (see EN0024).

## Open Items

- **Pagination contract is undeclared:** `limit`/`offset` query parameters are read ad hoc from the
  request inside `BlogService::getPosts()`/`hasMoreResults()` for the category endpoints, with a
  "both present or neither applies" activation rule that is easy to misuse from a client's
  perspective (supplying only `offset` silently returns the full unpaginated list). Not corrected
  here; recorded as observed current behavior.
- **Unpublished-post exposure via `PostResource`** (see Side Effects hazard) is recorded as current
  behavior, not resolved — whether this is an intentional preview mechanism or an oversight is not
  evidenced in current sources.
- **`total_posts` vs `posts[]` inconsistency** (unfiltered count vs. published-only listing) is
  recorded as observed, not reconciled.
- **No UC/FN/BR ownership exists for Blog** in the current spec-draft layers; this API document is
  anchored to EN0024 alone. If a UC/FN pass later covers editorial content delivery, this contract's
  `references` should be updated accordingly.
- Whether the platform's core "blog" content bundle (referenced as a naming collision in EN0024) has
  any REST exposure of its own is out of scope for this document — this contract covers only the
  custom `blog` module's `BlogEntity` and its four REST resources.
