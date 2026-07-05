# UC0026 — Browse & Read Editorial Content (Blog)

## Header

| Field | Value |
|---|---|
| UC ID | UC0026 |
| Name | Browse & Read Editorial Content (Blog) |
| Bounded Context | C3 |
| Primary Actor(s) | Anonymous visitor / reader, System |
| Trigger Type | UI (public page load) |

## Actors & Responsibilities

- **Anonymous visitor / reader** — opens the public blog listing to browse editorial articles grouped
  by thematic category, and opens an individual article to read its full body, campaign-matching copy,
  and donation call-to-actions. Performs no mutation; this is a pure content-consumption capability.
- **System** — resolves the currently featured ("top"/sticky) post and, per thematic category, the most
  recently changed articles for the listing page; renders an individual article's full content
  (including any author-configured call-to-action) on request; enforces published/unpublished visibility
  via node/entity access.

## Intent

Let an anonymous visitor discover and read editorial "blog" content — a listing of articles grouped by
thematic tag with a featured top post, and an article detail view carrying body copy, campaign-matching
promotion, and donation entry points (including the DMS SMS donation channel) — without requiring
authentication and without mutating any domain state. This is current-state, code-grounded browse/read
behavior; it is **not** part of the `bid-patron-deti` redesign canon yet (rebuild epic E0004 is
unbuilt) and no target-state UI/IA is asserted here.

## Preconditions

- One or more blog articles exist and are published (visible to an anonymous visitor); the public
  `/blog` route requires only the `access content` permission (`blog.routing.yml`).
- No authentication is required to browse the listing or open an article.

## Main Flow

### UC0026.1 — Browse the blog listing (screen S013, `/blog`)

1. Visitor: request the public blog listing page (`/blog`).
2. System: resolve the route `blog` to `NodeBlogController::startPage()` (`blog.routing.yml`,
   `permission: access content`).
3. System: load the current featured/"top" post — the `node` entity of bundle `blog` flagged `sticky`
   — and render it with the `top_post` view mode
   (`NodeBlogController::startPage()`; `core.entity_view_display.node.blog.top_post.yml`).
4. System: load the full `blog_category` taxonomy tree (thematic tags, e.g. "#O čem se mluví",
   "#Pomohli jsme", "#Chcete vědět", "#Rozhovory", "#Pomoc pro děti s autismem", "#Děti s Downovým
   syndromem" — UI evidence §14).
5. System: for each category term, query up to 5 `blog`-bundle nodes tagged with that category
   (excluding the top/sticky post), sorted by most recently changed, access-checked
   (`NodeBlogController::startPage()`, `getQuery()->accessCheck(TRUE)`).
6. System: render the first 2 matched articles per category with the `category_post` view mode and any
   remaining (up to 3 more) with the `small_category_post` view mode
   (`core.entity_view_display.node.blog.category_post.yml`,
   `core.entity_view_display.node.blog.small_category_post.yml`).
7. System: assemble the page via the `blogs_page` theme hook (`blog_theme()`) and the
   `blogs-page.html.twig` template — top post first, then one section per category term (heading +
   grid of article teasers), tagged for cache invalidation on the `blog` node list and the
   `blog_category` taxonomy list.
8. Visitor: see, per article teaser, its title, publish/change date, category tag, excerpt, and
   thumbnail image (UI evidence §14: "blog articles (title, date, category tag, excerpt, thumbnail)").
9. Visitor: follow an article's "Číst více →" link or its title to open the article (UC0026.2).

### UC0026.2 — Open and read an article (screen S014, `/blog/<slug>`)

1. Visitor: follow a link to an individual article's canonical page (`/blog/<slug>` — a Drupal node
   canonical/alias route for the `blog`-bundle node; not a route owned by the `blog` module itself).
2. System: resolve node access for the requested article (published nodes are visible to anonymous
   visitors under standard node access; no blog-specific access override applies to `node`-bundle
   articles — contrast with the separate `BlogEntity` access handler in AF1).
3. System: render the article's full view — title, date, category tag, body, and hero image (UI
   evidence §15).
4. System: render any campaign-matching promotional copy embedded in the article body (e.g. a
   matched-donation campaign description and its match ceiling, observed as "televize Nova navýří až
   do celkové výše 750 000 Kč" — UI evidence §15); this copy is authored content, not a system-computed
   projection asserted by this UC.
5. System: render donation entry points alongside the article — fixed monthly-amount presets, a custom
   amount option, and the **DMS SMS donation channel** copy (observed: "trvalou dárcovskou SMS na číslo
   87 777: DMS TRV PATRONDETI 90 nebo 290" — UI evidence §15); following any of these hands off to the
   donation flow (UC0005 — out of scope for this UC beyond the handoff).
6. System: render supporting UI — "Zpět na všechny články" back-link, social-sharing actions
   ("Sdílet" / "Tweetnout" / "LinkedIn" / "Zkopírovat odkaz"), and related-article links.
7. Visitor: read the article and, optionally, follow a donation CTA (→ UC0005) or a related-article
   link (→ UC0026.2, recursively).

## Alternative Flows

### AF1 — Distinct "BlogEntity" content bundle exists but is not the browsed content

1. System: the codebase additionally defines a custom, config-entity-backed `blog` entity type
   (`BlogEntity`, `blog.permissions.yml`: `view published/unpublished blog entity entities`, `edit`,
   `delete`, `add`) with its own access handler (`BlogEntityAccessControlHandler`) and admin-only
   "publish to homepage" / "set active" operations (`PublishToHomepageController`), gated by the `edit
   blog entity entities` permission.
2. System: this `BlogEntity` type is distinct from the `node` bundle named `blog` that
   `NodeBlogController::startPage()` actually queries for the public listing (UC0026.1 steps 3–5).

Outcome: Confirmed as two separate code paths sharing the "blog" name (see EN0024 Open Question 4).
This UC documents the reader-facing `node`-bundle listing/detail path only, since that is what the UI
evidence (§14–§15) and the public routing (`blog.routing.yml`) demonstrate as the browsed content;
whether the `BlogEntity` bundle is separately surfaced to readers anywhere is **not evidenced** in the
scanned source and is not asserted here.

### AF2 — No sticky/top post exists

1. System: query for a `node`-bundle `blog` entity flagged `sticky`; the query returns no result.
2. System: `reset($sticky)` on an empty array yields `false`/`null`; the subsequent call to `$top_post->id()`
   would fail on a null object.

Outcome: **Hypothesis — Not evidenced in current sources.** No defensive null-check is present in
`NodeBlogController::startPage()` around `$top_post`; whether at least one sticky post is guaranteed to
exist by editorial process (so this path never executes in practice) or this is a latent defect is not
resolved from code alone.

### AF3 — Category with no matching articles

1. System: a `blog_category` term has zero `blog`-bundle nodes tagged with it (excluding the top post).
2. System: the category section still renders (heading from the term), but with an empty teaser grid.

Outcome: Confirmed by the query/render structure (`startPage()` always emits a `$rendered_blogs[$term->id()]`
entry per term regardless of match count); the resulting empty-section visual is not separately
evidenced in the UI screenshots.

## Postconditions

- No domain aggregate (Application, Campaign, Transaction, etc.) is created, changed, or read-modified
  by this UC — it is a pure read/render capability.
- The visitor holds a rendered listing (top post + per-category teaser grid) or a rendered article
  detail (body, campaign-matching copy, donation CTAs including DMS SMS) sufficient to either continue
  reading (related articles, back-link) or proceed into the donation flow (UC0005).
- Page-level render cache is tagged to the `blog` node list and `blog_category` taxonomy term list, so a
  new/changed/re-tagged article invalidates the listing's cached render.

## Traceability

Target SRVs:
- None dedicated — this UC is grounded directly in the `blog` custom module's routing/controller/theme
  layer; no SRV/target-service candidate for editorial content browsing has been defined in this
  reconstruction pass (Blog is out of the redesign canon per rebuild epic E0004, unbuilt).

EN entities:
- EN0024 Blog — the editorial content entity whose `name`, `perex`, `body`, `image`/`gallery`,
  `category`, `is_hero_post`, and `cta_*` attributes describe the intended domain shape; note this UC's
  Main Flow evidence (`NodeBlogController`) actually operates on a `node`-bundle `blog` (with Drupal-core
  `sticky`/taxonomy `category` fields), not the `BlogEntity` config-entity type EN0024 documents in
  full — see AF1 and EN0024 Open Question 4 for the unresolved dual-bundle relationship
- EN0004 Campaign — referenced only as promotional/CTA-linked content within an article's authored body
  copy (UC0026.2 step 4); not read or written by this UC's own logic
- EN0008 User — the article's author (`user_id` on `BlogEntity`); not surfaced to the reader in the
  evidenced UI

Integration boundaries:
- None (internal read/render; no external system is called during blog browse/read itself). The DMS
  SMS donation channel referenced in article copy (UC0026.2 step 5) is an external donation channel,
  but its processing is out of scope for this UC (handoff only).

Flow Evidence:
- No FLW dossier exists for this capability (not scoped by the original evidence-collection pass; it
  surfaced through the UI-coverage gap audit, consistent with UC0023's precedent for uncharted public
  browse surfaces). Evidence instead consists of:
  - Code: `web/modules/custom/blog/blog.routing.yml` (route `blog`, `/blog`, permission `access
    content`)
  - Code: `web/modules/custom/blog/blog.module` (`blog_theme()` — `blogs_page` theme hook)
  - Code: `web/modules/custom/blog/src/Controller/NodeBlogController.php` (`startPage()` — top-post +
    per-category query/render logic)
  - Code: `web/modules/custom/blog/templates/blogs-page.html.twig` (listing template structure)
  - Code: `web/modules/custom/blog/blog.permissions.yml`,
    `web/modules/custom/blog/src/BlogEntityAccessControlHandler.php` (the separate `BlogEntity`
    access model — see AF1)
  - Code: `web/modules/custom/blog/src/Controller/PublishToHomepageController.php` (admin-only
    `is_hero_post`/`status` mutation on `BlogEntity` — out of scope for this reader-facing UC, recorded
    only to support AF1)
  - Config: `core.entity_view_display.node.blog.top_post.yml`,
    `core.entity_view_display.node.blog.category_post.yml`,
    `core.entity_view_display.node.blog.small_category_post.yml`, `node.type.blog.yml`
  - Screens: S013 (Blog — article listing, `/blog`), S014 (Blog — article detail, `/blog/<slug>`) per
    `_ar/spec-draft/IA-screen-map.md`
  - Screenshots: `screencapture-patrondeti-cz-blog-2026-07-04-13_16_59.png` (§14),
    `screencapture-patrondeti-cz-blog-patron-deti-nova-pomaha-a-ondrej-sokol-zvou-do-kampane-darujme-prazdniny-2026-07-04-13_17_24.png`
    (§15), per `_ar/evidence/ui/ui-observed-areas.md` §14–§15
  - EN0024 (Blog entity), for the attribute/domain-shape cross-reference noted in AF1

## Evidence Level

Confirmed — the listing route, controller logic, theme hook, and template (`blog.routing.yml`,
`NodeBlogController::startPage()`, `blog_theme()`, `blogs-page.html.twig`) exist in code and directly
match the UI evidence in `_ar/evidence/ui/ui-observed-areas.md` §14 (title/date/category-tag/excerpt/
thumbnail teasers grouped by thematic tag, with a featured top post) and §15 (article body,
campaign-matching copy, DMS SMS donation channel, donation CTAs). The dual "blog" bundle/entity-type
ambiguity (AF1) and the unguarded-empty-sticky-query path (AF2) are recorded as Hypothesis/Uncertain
sub-points rather than downgrading the overall Confirmed status of the browse/read capability itself.
This is current-state documentation only; blog is unbuilt in the `bid-patron-deti` redesign canon
(rebuild epic E0004) and no target-state design is asserted.
