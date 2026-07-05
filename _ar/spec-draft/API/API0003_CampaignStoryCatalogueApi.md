---
doc_id: API0003
title: Campaign / Story Catalogue API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-public
references:
  - UC0023
  - UC0021
  - EN0004
  - EN0005
  - EN0009
  - FN0006
  - FN0024
  - BR-CampaignStoryLifecycle
  - BR-CampaignRecommendationDormant
---

# API0003 – Campaign / Story Catalogue API

## Purpose

Public, read-only HTTP surface that lets a client (the consuming SPA, and — for one endpoint — the
Facebook product-catalog crawler) list, filter, paginate, and fetch the detail of published Campaigns
(Story/Příběh, EN0004), and query a donor's donation-interaction history against Campaigns. This is
the read side of the Campaign/Story-Lifecycle domain (FN0006) that backs the public story catalogue
(UC0023) and, where a `user_id`/`user_uuid` is supplied, surfaces per-donor interaction data used by the
(dormant) recommendation capability (UC0021 / FN0024 / BR-CampaignRecommendationDormant).

This contract folds five REST resource plugin **versions** of the campaign-listing endpoint
(`v3.0`–`v3.3`, plus a `v2.3` sibling pair) that coexist in the current source under
`web/modules/custom/campaign/src/Plugin/rest/resource/`. All versions are simultaneously enabled
(`status: true` in every `rest.resource.*.yml` below) — there is no evidence in this source of the
older versions being retired; they are documented as one contract with per-version differences noted.

## Consumers

- Anonymous website visitor / the public-facing SPA (all list/detail endpoints — Confirmed via
  `authentication: cookie` + `restful get ...` permissions granted to the `anonymous` role, see
  Authorization).
- Authenticated donor session (adds `total_amount_donated` / `feedback` / interaction-scoped filters on
  several endpoints).
- Facebook product-catalog crawler (`GET /api/2.2/campaigns_ads` only — an unauthenticated machine
  consumer of a Google-Shopping-style XML feed, not a browser session).

## Authorization

- **Confirmed, all endpoints in this contract are publicly reachable.** Every underlying
  `rest.resource.*.yml` config declares `authentication: [cookie]` and no `_permission`/`_access` route
  requirement (these are REST-module resources, not `*.routing.yml` routes — Drupal's REST module gates
  access purely through the `restful get <resource_id>` permission).
- `config/user.role.anonymous.yml` grants the anonymous role **all** of: `restful get
  campaign_rest_resource_v30`, `restful get campaign_rest_resource_v32`, `restful get
  campaigns_interacted_resource`, `restful get campaigns_recommended_resource`, `restful get
  campaigns_rest_resource_v30`, `restful get campaigns_rest_resource_v31`, `restful get
  campaigns_rest_resource_v32`, `restful get campaigns_rest_resource_v33`, `restful get
  fbfeed_rest_resource` (source: `config/user.role.anonymous.yml:93,103–110,116`).
- Net effect: **no login/session/token is required for any endpoint in this contract**; the `cookie`
  authentication provider only *personalizes* the response (see per-endpoint auth-dependent fields
  below) when a valid session cookie happens to be present — it does not gate access.
- The one config-only exception is `entity.campaign` (`plugin_id: entity:campaign`,
  `rest.resource.entity.campaign.yml`): `status: false` — **disabled**, not part of this contract's live
  surface. Noted for completeness only.
- **Hazard — current-state, not a target-state recommendation:** the entire Campaign catalogue,
  including per-endpoint donor interaction totals (`CampaignsInteractedResource`,
  `total_amount_donated` fields) and a donor's recommended-Campaigns list
  (`CampaignsRecommendedResource`), is reachable by **any anonymous caller who supplies a valid
  `user_uuid`/`user_id`** — there is no check that the caller *is* that user. This is an
  IDOR-shaped (Insecure Direct Object Reference) exposure of another donor's donation history by UUID
  guess/enumeration. Flagged as a current-state hazard per project instructions, not corrected here.

## Request

### Endpoint inventory

| # | Method + Path | Plugin ID | Config file | Query/Path params |
|---|---|---|---|---|
| 1 | `GET /api/3.3/campaigns` | `campaigns_rest_resource_v33` | `rest.resource.campaigns_rest_resource_v33.yml` | see "List filters" below (uses `filter_*` flat params) |
| 2 | `GET /api/3.2/campaigns` | `campaigns_rest_resource_v32` | `rest.resource.campaigns_rest_resource_v32.yml` | see "List filters" below (uses nested `filter[...]` params) |
| 3 | `GET /api/3.1/campaigns` | `campaigns_rest_resource_v31` | `rest.resource.campaigns_rest_resource_v31.yml` | see "List filters" below (nested `filter[...]`) |
| 4 | `GET /api/3.0/campaigns` | `campaigns_rest_resource_v30` | `rest.resource.campaigns_rest_resource_v30.yml` | see "List filters" below (nested `filter[...]`, no user scoping) |
| 5 | `GET /api/3.2/campaign/{slug}` | `campaign_rest_resource_v32` | `rest.resource.campaign_rest_resource_v32.yml` | path: `slug` |
| 6 | `GET /api/3.0/campaign/{hash}` | `campaign_rest_resource_v30` | `rest.resource.campaign_rest_resource_v30.yml` | path: `hash` — **Uncertain/broken**, see Open Items |
| 7 | `GET /api/2.3/campaigns/interacted/{user_uuid}` | `campaigns_interacted_resource` | `rest.resource.campaigns_interacted_resource.yml` | path: `user_uuid`; query: `campaign_id` (optional) |
| 8 | `GET /api/2.3/campaigns/recommended/{user_uuid}` | `campaigns_recommended_resource` | `rest.resource.campaigns_recommended_resource.yml` | path: `user_uuid` |
| 9 | `GET /api/2.2/campaigns_ads` | `fbfeed_rest_resource` | `rest.resource.fbfeed_rest_resource.yml` | query: `image` (`1200x628` or default `800x800`) |

Current version in active client use is inferred to be **v3.3** (highest-numbered, most feature-complete
list endpoint — flag filter, promo/infinite-campaign injection, transparent-account handling); v3.0–v3.2
and the v2.3 pair remain deployed side by side with no deprecation marker in source. **Partial** — which
version(s) the live SPA actually calls is not evidenced in this backend-only source tree.

### List filters — endpoint #1 (v3.3, flat `filter_*` query params)

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `filter_id` | comma-separated Campaign IDs to include | no | numeric only, non-numeric tokens silently dropped |
| `filter_status` | comma-separated `campaign_status` values | no | `=` if one value, `IN` if multiple; if omitted, list is unfiltered by status (all rows with non-null `campaign_status`) |
| `filter_category` | one category slug (`health_care`, `family`, `medical_equipment`, `education`, `sport`, `leisure`) | no | mapped to a hardcoded taxonomy term ID |
| `filter_region` | one CZ region slug (14 values, e.g. `praha`, `stredocesky`) | no | mapped to a hardcoded `kraj` term ID |
| `filter_flag` | comma-separated flag values | no | resolved via a join through `application` → `application__flag`; empty match ⇒ empty result set |
| `filter_user_interacted_campaigns` | `1`/truthy | no | requires an authenticated session; anonymous ⇒ empty result |
| `filter_user_recommended_campaigns` | `1`/truthy | no | requires an authenticated session; anonymous ⇒ empty result; see UC0021 (dormant — currently yields no data even when authenticated) |
| `filter_organization_id` | organisation UUID | no | resolves to the set of Campaigns linked to that organisation's workers' Applications |
| `order` | one of `latest`, `finished_recently`, `ends_soon`, `least_percentual_support`, `interacted_at` | no | default (no `order`) is `id DESC`; `ends_soon` additionally restricts to future deadlines |
| `exclude` | comma-separated Campaign IDs | no | numeric only |
| `offset` | integer | no | default `0` |
| `limit` | integer | no | default `10`; `-1` means "up to 1000" |
| `uid` | integer user ID | no | **only honored when the caller is anonymous** (`current_user->id() === 0`) — lets an anonymous caller impersonate a user ID for interaction/recommendation scoping; see Hazards |
| `tu_index` | integer | no | when present, forces insertion of the platform's single "infinite/transparent account" Campaign at a computed position in the result set (source-code comment: "Univerzální příběh") |

Endpoints #2–#4 (`v3.2`/`v3.1`/`v3.0`) accept the same filter *semantics* through a **nested**
`filter[key]=value` query structure (e.g. `filter[status]=active`) instead of flat `filter_status=...`
params — this is the material breaking difference between the v3.0–v3.2 family and v3.3. v3.0 additionally
has no `user_id`/session-based interaction scoping at all (no `addUserData()` user branch beyond the
published-status default). v3.1 introduces `user_id` (query param, by UUID) plus
`user_interacted_campaigns`/`user_recommended_campaigns`/`organisation_id` filters. v3.2 replaces the
`user_id` query param with implicit current-session scoping and adds the "infinite/transparent account"
promotional-row injection (offset-3 heuristic, non-production environments only). v3.3 replaces the
flat-vs-nested filter shape, adds `filter_flag`, generalizes the infinite-campaign injection via
`tu_index`, and adds the anonymous `uid` override described above.

### Detail request — endpoints #5/#6

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `slug` (v3.2, path) | Campaign's public slug | yes | resolved against the live `campaign.slug` column first, then `campaign_slug_archive` for a historical slug (redirect case, see Response) |
| `hash` (v3.0, path) | intended to be a "unique hash" | yes | **Uncertain/broken** — see Open Items; the v3.0 handler does not actually resolve this parameter to a Campaign |

### Interaction/recommendation requests — endpoints #7/#8

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `user_uuid` (path) | target donor's account UUID | yes | resolved via the `account` service; unknown UUID ⇒ 404 (see Failure Outcomes) |
| `campaign_id` (query, endpoint #7 only) | restrict the interaction sum to one Campaign | no | if omitted, returns per-Campaign totals for all Campaigns the donor has a PAID Transaction against |

### Feed request — endpoint #9

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `image` (query) | image-style selector | no | `1200x628` if exactly that value, otherwise `800x800` |

## Response

### Success — endpoints #1–#4 (list)

| Field | Meaning | Notes |
|---|---|---|
| `data` | array of Campaign card projections | see "Campaign card projection" below; each item merges in `total_amount_donated`/`interacted_at` when the request is interaction-scoped |
| `total_count` | integer | count of matching Campaign IDs before pagination |
| `has_more_results` | boolean | `true` if `offset + limit < total_count` |
| `__limit` (v3.2/v3.3 only) | integer | echoes the effective `limit` used |
| `__query` (non-production environments only) | string | raw SQL debug string — see Hazards |
| `__user_id`, `__user_load`, `__displayInfiniteCampaign` (v3.3, non-production only) | debug fields | see Hazards |

**Campaign card projection** (`CampaignEntity::getShortData()`, `CampaignEntity.php:1247-1272`):

| Field | Meaning | Notes |
|---|---|---|
| `id` | Campaign ID (integer) | |
| `type` | Campaign type | `basic`, `promo`, `long_term`, `short_term` (EN0004) |
| `url_hash` | public slug | field name is historical; holds the current slug, not a hash |
| `status` | publish-normalized status label | derived, not the raw `campaign_status` |
| `category` | category label | looked up from a fixed category map |
| `name` | Campaign name | |
| `button_text` | CTA button label | |
| `photo` | image URL (short form) | list-page photo if set, else main photo |
| `full_amount` | target amount (integer) | |
| `raised_amount` | raised-to-date amount (integer) | |
| `hide_raised_amount` | boolean | display flag — see BR-CampaignStoryLifecycle |
| `campaign_ends` | ISO deadline | |
| `campaign_finished` | completion date or null | |
| `has_feedback` | boolean | `false` unconditionally for an anonymous caller |
| `_percentual_support` | raised percentage | |
| `total_amount_donated`, `interacted_at` | merged in when interaction-scoped | not present otherwise |
| `user_allocated`, `recurring_amount`, `recurring_day`, `infinite_campaign` (v3.3, transparent-account row only) | transparent-account-specific fields | see BR-CampaignStoryLifecycle open item on the collection-account mechanism |

### Success — endpoints #5/#6 (detail)

Base payload is `CampaignEntity::getFullData()` (`CampaignEntity.php:1344-1398`):

| Field | Meaning | Notes |
|---|---|---|
| `id`, `url_hash`, `status`, `category`, `name`, `button_text`, `full_amount`, `raised_amount`, `hide_raised_amount`, `campaign_ends`, `type`, `campaign_finished` | same semantics as the card projection | |
| `gift` | object: `title`, `description`, `photo` | the fundraising "gift" being funded |
| `description_full`, `description_short` | long/short Campaign narrative | HTML converted to plain/markdown-ish text for `description_full` |
| `photo` | main image URL | |
| `patron` | object: `name`, `photo`, `about`, `position`, `public_email` (always `null`) | present only if a public Patron profile (EN0005) is linked |
| `kids_count`, `slider` | present only when the Campaign `isPromo()` | |
| `og` | object: `type`, `title`, `description`, `image` | Open Graph metadata for social sharing |
| `feedback` (v3.2 only, authenticated caller only) | object: `intercept_title`, `intercept`, `content`, `featured_image` | one fundraiser thank-you note, if any (EN0021) |
| `total_amount_donated` (v3.2 only, authenticated caller only) | integer | this caller's paid-Transaction sum against this Campaign (EN0009) |
| `redirect_301` (v3.2 only) | new slug string | returned instead of the full payload when the requested slug is found only in the historical-slug archive |

### Success — endpoint #7 (interacted)

Response is a map keyed by Campaign ID:

| Field | Meaning | Notes |
|---|---|---|
| `<campaign_id>.total_amount_donated` | sum of that donor's PAID Transactions against that Campaign | |
| `<campaign_id>.interacted_at` | timestamp of the most recent such Transaction | |

### Success — endpoint #8 (recommended)

Response body is whatever `$user->getRecommendedCampaigns()` returns — **Partial**: the shape returned
by this method is not re-documented here (owned by EN0008/User); per UC0021 (dormant), this currently
returns no populated recommendation data in the live system.

### Success — endpoint #9 (Facebook feed)

`application/xml` body, Google-Shopping-style RSS 2.0 with a `g:` namespace; one `<item>` per active,
published Campaign, fields: `g:id`, `g:title`, `g:description`, `g:link`, `g:brand` (constant
`patrondeti`), `g:condition` (constant `new`), `g:image_link`, `g:availability` (`in stock`/`out of
stock` heuristic on raised-percentage), `g:price`, `g:expiration_date`, `g:custom_label_0..3`
(target amount, days remaining, remaining-to-target amount, raised amount).

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `200` with `{"status":"failed","error":"Not Found"}` | detail endpoint (#5/#6), no matching Campaign / slug | yes | **Hazard** — a not-found condition is signaled with HTTP 200, not 404; callers must inspect the body |
| `404` with `{"error":"user_not_found"}` | endpoints #7/#8, `user_uuid` does not resolve via the `account` service | yes | proper HTTP status used here, inconsistent with #5/#6 |
| `EntityMalformedException` (uncaught) | endpoint #9, no active+published Campaigns exist at all | no | thrown, not caught into a structured error response — surfaces as a generic 5xx to the Facebook crawler |
| empty `data: []`, `total_count: 0` | endpoints #1–#4, no Campaigns match the filter combination | yes | not an error; documented as the AF4 empty-result case (UC0023) |

## Side Effects

None. Every endpoint in this contract is a pure read — no Campaign, Application, Transaction, or other
aggregate state is created, updated, or deleted (Confirmed — no `->save()`/write call appears in any of
the nine resource classes; consistent with UC0023 Postconditions). Endpoint #1's list handler does write
to Drupal's page cache under specific config (v3.0 only, permanent cache tag `api_campaigns`) — this is
an infrastructure caching side effect, not a domain-state side effect, and is not otherwise inlined here.

## Hazards (current-state)

- **Interaction/recommendation data is reachable by UUID alone, with no ownership check** (endpoints #7,
  #8, and the `user_id`/`filter_user_interacted_campaigns`/`filter_user_recommended_campaigns` scoping on
  #1–#4): any caller who obtains or guesses a donor's `user_uuid` can read that donor's total-donated
  amounts, per-Campaign interaction timestamps, and (would-be) recommended-Campaigns list, fully
  unauthenticated. This is a donor-privacy exposure in the current system.
- **Anonymous `uid` override on v3.3** (`campaigns_rest_resource_v33`): when the request is unauthenticated,
  the endpoint honors a client-supplied `uid` query parameter as if it were the caller's own session user
  for all interaction/recurring-donation scoping — compounding the point above by removing even the UUID
  lookup step (`uid` is a guessable sequential integer, not a UUID).
- **Debug/introspection fields leak outside strict production gating**: `__query` (raw SQL, with bound
  parameters interpolated back in for readability) and, on v3.3, `__user_id`/`__user_load`/
  `__displayInfiniteCampaign` are included in the JSON response whenever
  `Settings::get('environment') !== 'production'` — this is an environment-config-driven, not
  request-driven, gate; any misconfigured non-production-flagged environment (e.g. a staging environment
  reachable from the internet) exposes internal SQL structure to any anonymous caller of endpoints #1–#4.
- **Inconsistent not-found signaling**: detail endpoints #5/#6 return HTTP `200` with an
  `{"status":"failed"}` body for a not-found Campaign, while #7/#8 correctly use HTTP `404` — a rewrite
  should not assume uniform HTTP semantics across this endpoint family without re-verifying each one.
- **No rate limiting, HMAC, or request-signing evidenced on any endpoint in this contract** — consistent
  with the project-wide current-state pattern of public/anonymous endpoints having no additional
  transport-level integrity or throttling control in the scanned source.
- **Endpoint #6 (`v3.0` detail) is evidenced as broken, not merely legacy**: see Open Items.

## References

- UC: UC0023 (Browse & Filter Story Catalogue — primary behavioral grounding for endpoints #1–#4),
  UC0021 (Recommend Campaigns, DORMANT — grounds endpoint #8 and the `user_recommended_campaigns`
  filter path)
- EN: EN0004 (Campaign — the aggregate being projected), EN0005 (Patron — surfaced on detail),
  EN0009 (Transaction — source of interaction totals), EN0021 (Feedback — surfaced on v3.2 detail)
- FN: FN0006 (CampaignStoryLifecycle), FN0024 (CampaignRecommendation)
- BR: BR-CampaignStoryLifecycle (derived raised/percent fields, transparent-account handling,
  hide-raised-amount flag), BR-CampaignRecommendationDormant (endpoint #8's actual current behavior)

## Open Items

- **Endpoint #6 (`GET /api/3.0/campaign/{hash}`) does not use its own path parameter.** The handler
  (`v30\CampaignResource::get($hash = NULL)`, `CampaignResource.php:84-113`) ignores `$hash` entirely and
  instead tries to regex-match a numeric Campaign ID out of `$this->campaign->getSlug()` — but
  `$this->campaign` is never assigned before this line (no constructor/property default), so this call
  will fault on a null-object method call in normal PHP behavior. Recorded as
  **Uncertain — evidenced as broken in the read source, not confirmed against a live instance** (no
  runtime instance is available per `_ar/tasks/Runtime-truth-policy.md`). Not corrected here; flagged for
  the rebuild team to decide whether v3.0 detail is still reachable/needed at all.
- **Which endpoint version(s) the current production SPA actually calls** is not evidenced in this
  backend-only source tree (Partial, carried over from UC0023).
- **The exact response shape of `$user->getRecommendedCampaigns()`** (endpoint #8) is not re-documented
  here — belongs to the User aggregate (EN0008), not this API contract; flagged so a future EN0008 pass
  can supply it if this contract needs to be sharpened.
- **The collection-account / "sloučený příběh" (merged story) card mechanism** referenced by the
  transparent-account fields (`user_allocated`, `recurring_amount`, `recurring_day`,
  `infinite_campaign`) is not conclusively mapped to a single `type`/`parent` combination — same open
  item already tracked on EN0004/UC0023 (OQ-05); not re-litigated here.
- **`/campaign/regions/render`** (`campaign.routing.yml`, controller `RenderRegionsController::render`)
  is a Drupal HTML route, not a REST resource — it renders a region-picker fragment consumed by the
  catalogue UI (UC0023 step 8) but returns markup, not a JSON/XML data contract, so it is intentionally
  **excluded** from this API contract. Likewise `/fundraising/campaign/{campaign}/content`,
  `/fundraising/campaign/{campaign}/slug_history`, `/admin/campaign/{id}/set-active`, and
  `/admin/campaign/{campaign}/pay-remaining-amount` from the same routing file are internal
  admin/back-office HTML routes, not public REST contracts, and are excluded here — they belong to a
  future back-office API contract if one is ever synthesized for this module.
