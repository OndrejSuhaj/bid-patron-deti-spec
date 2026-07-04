# UC0023 — Browse & Filter Story Catalogue

## Header

| Field | Value |
|---|---|
| UC ID | UC0023 |
| Name | Browse & Filter Story Catalogue |
| Bounded Context | C3 |
| Primary Actor(s) | Anonymous visitor, Donor, System |
| Trigger Type | UI (public page load / AJAX) |

## Actors & Responsibilities

- **Anonymous visitor / Donor** — opens the public story catalogue (homepage and equivalent listing
  surfaces), switches between segmentation tabs (remaining amount / single-parent / region / ending
  soon), optionally picks a region on the interactive map, and follows a story card's call to action to
  reach the donation flow (UC0005) for a chosen Campaign (Story/Příběh, EN0004).
- **System** — resolves the current published-and-active Campaign set, applies the requested
  filter/sort/pagination parameters against the `campaign` read side, computes the per-region active
  Campaign counts shown on the region picker, and returns each Campaign's public card projection
  (photo, name, category, target vs. raised amount, remaining-amount visibility flag, deadline/time-left,
  feedback-available flag).

## Intent

Let an anonymous visitor or donor discover active Campaigns (Stories/Příběhy) through a public,
filterable, paginated catalogue — segmented by remaining amount (default), single-parent
("samoživitel") applicants, CZ region, or nearest deadline — so they can choose whom to support and
proceed into the donation flow (UC0005). This is the primary donor-acquisition entry point into the
Campaign/Story-Lifecycle domain (SRV0005) and is a pure read/browse capability: it does not mutate
Campaign or Application state.

## Preconditions

- One or more Campaigns (EN0004) exist with `campaign_status` populated; for an anonymous visitor,
  the query additionally requires the Campaign's Drupal `status` (published) flag to be `1` — see
  `CampaignsResource::addUserData()` (source: `web/modules/custom/campaign/src/Plugin/rest/resource/v33/CampaignsResource.php:217-223`).
- No authentication is required to browse; an authenticated user may pass additional
  interaction-scoped filters (see Alternative Flows AF3).

## Main Flow

1. Visitor: load the public story catalogue (homepage or equivalent listing surface).
2. System: default the view to the **"Zbývající částka" (remaining amount)** segmentation — Confirmed
   default landing tab per UI evidence; the underlying default when no explicit `order` query parameter
   is supplied is `ORDER BY c.id DESC` (`applyOrder()`, no-order branch) — **Partial**: the exact sort
   key wired to this default tab in the front-end client is not evidenced from this repository (the
   consuming SPA is not part of this source tree — see Evidence Level).
3. System: query the `campaign` table for Campaign IDs, applying (in order) user-scoping, then the
   requested filters, then exclusions, then ordering (`getCampaigns()` — `CampaignsResource.php:115-154`).
4. System: page the ID set by `offset`/`limit` query parameters (default `limit` = 10 if unset; `-1`
   requests up to 1000) and report `has_more_results` / `total_count` alongside the page (`loadCampaigns()`,
   `applyRange()`, `getOffset()`, `getLimit()` — `CampaignsResource.php:156-215`).
5. System: for each Campaign ID in the page, load the `CampaignEntity` and return its public card
   projection via `getShortData()` — id, type, slug (`url_hash`), publish-normalized status, category
   label, name, CTA button text, list photo, target amount (`full_amount`), raised amount, a
   `hide_raised_amount` flag, ISO deadline (`campaign_ends`), completion date, feedback-availability
   flag, and raised percentage (`CampaignEntity.php:1247-1272`).
6. Visitor: switch to the **"Samoživitelé" (single-parent)** tab — Uncertain mechanism; see AF1.
7. Visitor: switch to the **"Filtrovat podle krajů" (by-region)** tab.
8. System: render the region picker fragment — a mobile `<select>` and a desktop SVG map — built from
   the 14 CZ regions (`kraj` reference entities) and, for each region, the count of currently `active`
   Campaigns assigned to it; a region with a zero count is rendered as a disabled option
   (`RenderRegionsController::render()` / `getActiveCampaignCountsByRegion()` —
   `web/modules/custom/campaign/src/Controller/RenderRegionsController.php:71-134`), served at the
   public route `/campaign/regions/render` (permission `access content`; `campaign.routing.yml`).
9. Visitor: pick a region on the map (or the mobile select).
10. System: re-run the catalogue query (step 3) with `filter_region` set to the picked region's slug,
    mapped to the corresponding `kraj` entity ID server-side, and constrain the query to
    `c.kraj = <region id>` (`applyFilters()`, `region` branch — `CampaignsResource.php:322-341`).
11. Visitor: switch to the **"Brzy skončí" (ending soon)** tab.
12. System: re-run the catalogue query with `order=ends_soon`, which orders by `campaign_deadline`
    ascending and restricts results to Campaigns whose deadline (end-of-day) is still in the future
    (`applyOrder()`, `ends_soon` branch — `CampaignsResource.php:406-414`).
13. Visitor: select a story card's call-to-action ("Podpořím `<jméno>`" or the collection-account
    variant "Nechám to na vás").
14. System: hand off to the donation flow for the chosen Campaign (see UC0005 — out of scope for this
    UC beyond the handoff).

## Alternative Flows

### AF1 — "Samoživitelé" (single-parent) tab filter mechanism — Uncertain

1. Visitor: select the "Samoživitelé" tab.
2. System: is expected to narrow the catalogue to Campaigns whose linked Application/fundraiser is
   flagged single-parent.

Evidence found: `CampaignEntity` declares a `single_parent` boolean field with getter `isSingleParent()`
(`CampaignEntity.php:267-269,867`), so the underlying data point exists on the Campaign aggregate.
However, the `applyFilters()` filter map in the current (v33) `CampaignsResource` — the REST endpoint
this UC's Main Flow is grounded in — does **not** include a `filter_single_parent` (or equivalent)
parameter; only `id`, `status`, `category`, `flag`, `region`, `user_interacted_campaigns`,
`user_recommended_campaigns`, and `organization_id` are wired (`CampaignsResource.php:228-385`). No
other server-side filter path for `single_parent` was found in `web/modules/custom/campaign/` or
elsewhere in the scanned source.

**Uncertain — the tab is UI-evidenced (`_ar/evidence/ui/ui-observed-areas.md` §1) and the underlying
field is Confirmed on the Campaign entity, but the filter wiring is not evidenced in this backend
source.** Possible explanations not resolvable from this repository: (a) the filter is applied
client-side in the consuming SPA against an already-fetched page (unlikely at scale, but the SPA
itself is not in this source tree), (b) a newer/undiscovered REST resource version or Views-based
endpoint carries this filter, or (c) the tab is currently non-functional/a UI stub. Flagged as an
Evidence Gap — see Evidence Level.

### AF2 — Region has zero active Campaigns

1. Visitor: open the "Filtrovat podle krajů" tab.
2. System: renders the region with a `0` count as a disabled `<option>` in the mobile select
   (`buildRegionLabel()` / `$disabled = $count === 0 ? ' disabled' : ''` —
   `RenderRegionsController.php:88-96`).

Outcome: the visitor cannot select a region with no active Campaigns from the mobile control; desktop
SVG-map behavior for a zero-count region is not further evidenced (map interactivity/disabling on the
SVG itself is delegated to the `map` theme hook / front-end rendering, not inspected here).

### AF3 — Authenticated donor requests interaction-scoped views

1. Donor (authenticated): request the catalogue with `filter_user_interacted_campaigns` or
   `filter_user_recommended_campaigns` set.
2. System: if authenticated, narrows the Campaign ID set to Campaigns the donor has a paid Transaction
   against (via `getInteractedCampaigns()` — `CampaignsResource.php:459-486`) or to the donor's stored
   recommended-Campaigns list (`$currentUser->getRecommendedCampaigns()`); if unauthenticated, the
   filter yields an empty result set (`CampaignsResource.php:351-377`).

Outcome: **Confirmed** as a REST-level capability of the same endpoint; not confirmed as a public
catalogue-tab UI surface — no screenshot evidence shows these as visitor-facing tabs, so they are
recorded here as a code-evidenced capability of the underlying read model, not as part of the anonymous
Main Flow. `user_recommended_campaigns` in particular overlaps with UC0021 (Recommend Campaigns —
DORMANT); this UC does not assert that recommendation data is currently populated.

### AF4 — No results for the applied filter combination

1. System: the filtered/ordered ID query returns zero rows.
2. System: returns an empty `data` array with `total_count = 0` and `has_more_results = false`.

No alternative flows beyond AF1–AF4 are defined; this is a read-only browse/filter capability with no
write-side error paths.

## Postconditions

- No Campaign, Application, or other domain aggregate state is changed by this UC — it is a pure read
  projection over the existing `campaign` data.
- The visitor holds a page of Campaign card projections (and, on the region tab, a rendered region
  picker with live active-Campaign counts) sufficient to select a Campaign and proceed to UC0005 (Make
  a Donation).

## Traceability

Target SRVs:
- Campaign-&-Story-Lifecycle (SRV0005) — read side of the aggregate this UC projects

EN entities:
- EN0004 Campaign — the Story/Příběh being browsed and filtered; this UC reads `campaign_status`,
  `type`, `gift_category`, `kraj` (region), `single_parent`, `campaign_raised`,
  `campaign_percentual_raised`, `gift_price`, `campaign_deadline`, `hide_campaign_raised`, and the
  self-referencing `parent` (group/promo) relationship
- EN0005 Patron — the public Patron profile surfaced on each Campaign card (read-only in this UC)
- EN0009 Transaction — read (not written) to resolve `user_interacted_campaigns` (AF3) and to derive
  `campaign_raised` upstream (owned by UC0011/SRV0005, not recomputed by this UC)

Open item carried from EN0004 / SRV0005 (not resolved by this UC): the "SBÍRKOVÝ ÚČET" /
collection-account (group) story card observed in UI evidence has no distinct value in the `type`
field (`basic | promo | long_term | short_term` — `CampaignEntity.php:825-838`); it is most plausibly
realized via a `long_term`/`short_term` ("sloučený příběh") parent Campaign with child Campaigns
attached through the self-referencing `parent` field, or via the single fixed "transparent account"
Campaign (`Settings::get('transparent_account')`, used for un-earmarked/general donations — e.g.
`CampaignsResource.php:41-42,80,178-192,434-436`). Neither mapping is confirmed against the specific
"Nechám to na vás" card copy from this source alone — recorded as **Partial**, tracked under
**OQ-05** (`_ar/spec-draft/UI-gap-open-questions.md`) and the matching Open Question already logged
on EN0004 / SRV0005. This UC does not assert which mechanism the group/collection-account card uses.

Integration boundaries:
- None (internal read model; no external system is called during browse/filter itself).

Flow Evidence:
- No FLW dossier exists for this capability (it was not scoped by the original evidence-collection
  pass — it surfaced only through the UI-coverage gap audit). Evidence instead consists of:
  - Code: `web/modules/custom/campaign/src/Plugin/rest/resource/v33/CampaignsResource.php` (REST read
    endpoint `/api/3.3/campaigns`, superseding v30–v32 in the same directory tree)
  - Code: `web/modules/custom/campaign/src/Controller/RenderRegionsController.php` +
    `campaign.routing.yml` (`/campaign/regions/render`)
  - Code: `web/modules/custom/campaign/src/Entity/CampaignEntity.php` (`getShortData()`, `categories`,
    `type` allowed values, `single_parent`, `isPromo()`, `getPromoId()`)
  - Screenshots: `screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
    `screencapture-patrondeti-cz-2026-07-04-13_16_09.png`,
    `screencapture-patrondeti-cz-2026-07-04-13_16_21.png`,
    `screencapture-patrondeti-cz-2026-07-04-13_16_37.png` (per
    `_ar/evidence/ui/ui-observed-areas.md` §1)
  - Promotion record: `_ar/spec-draft/UI-gap-promotions.md` §2, gap G-03

## Evidence Level

**Partial** — the four-tab catalogue's core mechanics (paginated read of active Campaigns; category,
status, and region filters; `ends_soon` and `least_percentual_support` sort orders directly matching
the "Brzy skončí" and "Zbývající částka" tab semantics; the region picker's live active-Campaign counts
and zero-count disabling) are **Confirmed** by direct code evidence in `CampaignsResource` (v33) and
`RenderRegionsController`, cross-checked against the UI screenshots in
`_ar/evidence/ui/ui-observed-areas.md` §1. Two points keep this at Partial rather than Confirmed: (1)
the "Samoživitelé" tab's server-side filter wiring is not evidenced (AF1 — the `single_parent` field
exists on the entity but no REST filter parameter consumes it in the scanned source); (2) the
collection-account/group story-card mechanism is not conclusively mapped to a `type`/`parent` value
combination (tracked as OQ-05, consistent with the pre-existing Open Question already recorded on
EN0004 and SRV0005). No FLW dossier or process-map coverage exists for this capability, and the
consuming front-end client (a separate SPA referenced only in code comments, e.g.
`campaign.module:106`, `patron-spa/src/pages/story/_id.vue`) is outside this source tree, so the exact
tab-to-query-parameter wiring on the client side is inferred from the server's filter/sort contract,
not observed directly.
