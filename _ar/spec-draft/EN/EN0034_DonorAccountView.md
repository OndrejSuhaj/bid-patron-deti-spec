---
doc_id: EN0034
title: DonorAccountView
canonical_layer: EN
spec_type: entity
spec_subtype: projection
status: draft
references:
  - EN0008  # User — the current-user scope the projection is filtered by (Supporter role, INV21)
  - EN0009  # Transaction — the projected rows (is_donation=1, ext_status=PAID), grouped by campaign
  - EN0004  # Campaign — the grouping key ("supported story") of the projection
  - EN0014  # DonationConfirmation — mockup-only element, NOT evidenced in this projection (see Evidence Gaps)
  - EN0021  # Feedback — mockup-only element, NOT evidenced in this projection (see Evidence Gaps)
  - BR-PaymentAndMoneyIntegrity
---

# EN0034 — DonorAccountView

## Purpose

DonorAccountView is a **read-model projection** over paid Transactions (EN0009), grouped by
Campaign (EN0004) and summed per Campaign, scoped to the current authenticated User (EN0008) —
i.e. "which stories has this donor supported, and how much per story." It backs a donor-facing
account page ("Moje zóna" / donor zone) and is not itself a persisted aggregate: it has no table of
its own, no lifecycle, and no writer — it is produced entirely by a query over Transaction rows at
read time.

*Confidence: Partial.* The **core projection** (donation history grouped by supported Campaign) is
**Confirmed** in code (see Evidence). The richer dashboard composition suggested by UI evidence —
followed-story countdown/collection state, downloadable confirmations, feedback, and a "Pro vás /
Všechny (N)" tab split — is **Hypothesis**, evidenced only by a mockup embedded in a marketing e-mail,
not by a real screen capture or by code. See Evidence Gaps below; do not treat the mockup composition
as confirmed current-state behaviour.

## Evidence

**Confirmed (code):**

- `sync_config/config_czech/views.view.supporter_zone.yml` — a Drupal View named "Supporter zone"
  (`id: supporter_zone`, page title "Moje zóna"), `base_table: transaction`, published at page path
  `zona/darce`.
  - **Fields:** `campaign` (entity-reference label to Campaign, grouped) and `price` (integer,
    `group_type: sum` — summed per campaign group). Exactly these two columns; no other field is
    projected by this view.
  - **Filters:** `ext_status = PAID` and `is_donation = 1` (boolean true) — only paid donation
    Transactions are included (non-donation Transactions and unpaid/cancelled Transactions are
    excluded).
  - **Argument (scope):** `user_id`, `default_argument_type: current_user` — the view is
    contextually filtered to the currently logged-in user; no explicit-user browsing.
  - **Access:** `type: role`, `role: supporter` — restricted to Users holding the `supporter` role
    (`config/user.role.supporter.yml`).
  - **`group_by: true`** at the view level — confirms the aggregation semantics (one row per
    Campaign the user donated to, with a summed price).
  - This view exists **only in the `config_czech` config split**
    (`config/config_split.config_split.config_czech.yml`, `complete_list` includes
    `views.view.supporter_zone`) — i.e. it is a **CZ-tenant-only** artifact in the evidenced config;
    no equivalent `supporter_zone` view was found outside `sync_config/config_czech/`.
- Sibling role-scoped "zone" views exist in the same CZ config split, confirming this is one of a
  family of per-role read-model dashboards, not a one-off: `views.view.fundraiser_zone.yml`
  (`base_table: application`, path `zona/zadatel`) and `views.view.patron_zone.yml`
  (`base_table: application`, path `zona/patron`). These back the fundraiser/Patron account views
  respectively and are **out of scope** for this donor-facing entity (recorded here only as
  corroborating context for the "account zone" pattern).
- `web/modules/custom/account/src/Plugin/rest/resource/v32/ProfileResource.php` —
  `GET /api/3.2/user/profile` and `POST /api/3.2/user/profile` confirm a separate, real,
  code-backed profile read/edit contract (name, e-mail, avatar `user_image`) for the logged-in
  user — this is the account **profile** capability (see `UC0024` candidate in
  `_ar/spec-draft/UI-gap-promotions.md`, not modelled here) and is **distinct** from the donation
  read-model documented in this entity. It corroborates that a headless account area exists, but
  it does not itself project donation history.
- `_ar/spec-draft/DOMAIN-kernel.md` (INV21) and `_ar/spec-draft/DOMAIN-ubiquitous-language.md`
  ("Supporter" role) already document that the `supporter` role is auto-granted to a User on their
  first PAID Transaction — consistent with, and the access precondition for, this view.

**Hypothesis (UI mockup only, not in code):**

- `screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png` — the "Dokončete svůj uživatelský
  účet 🎉" e-mail embeds a mobile mockup of an account dashboard showing: tabs "Pro vás" / "Všechny
  (67)"; a story card with "Přispěli jste 1 250 Kč", a countdown ("ZBÝVÁ 10 DNÍ"), and a
  target/collected pair ("83 240 Kč / 101 591 Kč"); body copy promising "příběhy, na které jste
  přispěl/a, částku, kterou jste daroval/a, **potvrzení o darech, zpětné vazby**" all "pod jednou
  střechou". No corresponding real screen of this dashboard was captured (see
  `_ar/evidence/ui/ui-observed-areas.md` §19 and `_ar/coverage/ui-gap-analysis.md` line 231).

## Lifecycle

Not applicable — DonorAccountView is a stateless read-time projection, not a persisted entity with
a record lifecycle. It has no creation, update, or deletion events of its own; its content changes
only as the underlying Transaction (EN0009) and Campaign (EN0004) records it reads change.

## State Transitions

None. There is no state machine: the projection is recomputed on every read from current Transaction
and Campaign data.

## Attributes

### Confirmed (from `supporter_zone` view)

- Supported Campaign (reference to EN0004 – Campaign; grouping key) — one row per distinct Campaign
  the current User has a paid donation Transaction against.
- Contributed amount (integer; derived; `sum(price)` of the current User's paid, is-donation
  Transactions against that Campaign).

### Hypothesis — Not evidenced in current sources (mockup-only; do not treat as confirmed)

- Per-story collection state (target amount, collected amount, days-remaining countdown) — visible
  in the e-mail mockup story card, but not present as a field of the `supporter_zone` view itself
  (that information lives on Campaign, EN0004, and would require the view — or a different
  read-model — to also project it; no such extension is evidenced).
  Campaign target/raised/deadline fields do exist on EN0004 itself; whether the real dashboard joins
  them into this projection is unconfirmed.
- Downloadable donation confirmations (link to EN0014 – DonationConfirmation per donation/story) —
  no field or relationship to DonationConfirmation was found on `supporter_zone` or any sibling
  view; the account's tax-confirmation capability is a **separate, code-confirmed** self-service
  form (`donation_confirmation.page` route, `/donation-confirmation`) that is not joined into this
  projection.
- Feedback from the supported child/family (reference to EN0021 – Feedback) — no field or
  relationship to Feedback was found on `supporter_zone`; Feedback in code is authored
  admin-side per Application (`feedback.campaign_feedback_form`,
  `/admin/application/{application}/feedback`), with no donor-facing "my feedback" listing route
  or view located in source.
  the "Pro vás / Všechny (67)" tab split (a personalised subset vs. a full count of 67 items) —
  no corresponding parameter, filter, or count field was found on `supporter_zone` or any related
  view/resource.

## Invariants

- Only Transactions with `ext_status = PAID` and `is_donation = 1` are included in the projection —
  see BR-PaymentAndMoneyIntegrity for the broader payment/money-state rules this depends on.
- The projection is scoped to the requesting User via `current_user` argument default — a donor can
  only see their own donation history through this view; there is no evidenced cross-user browsing
  path.
- Access requires the `supporter` role, which (per DOMAIN-kernel INV21) is only granted after a
  first PAID Transaction — a donor with no paid donations does not have a populated (or accessible)
  DonorAccountView.
- CZ-only in evidenced config: the `supporter_zone` view is present exclusively in the
  `config_czech` config split; no equivalent was found in the base/shared config or other observed
  config splits. Whether RO/MD tenants have an equivalent donor-zone view under a different
  config-split path is **Unknown** — not searched/found in this pass; flagged as an Evidence Gap.

## Relationships

- EN0009 – Transaction (source rows: paid, is-donation Transactions owned by the current User)
- EN0004 – Campaign (grouping key; the "supported story")
- EN0008 – User (the scoping/owning party; must hold the `supporter` role)
- EN0014 – DonationConfirmation — **not** a confirmed relationship of this projection; recorded only
  because the UI mockup suggests one (see Evidence Gaps)
- EN0021 – Feedback — **not** a confirmed relationship of this projection; recorded only because the
  UI mockup suggests one (see Evidence Gaps)

## Evidence Gaps

1. **Composition beyond donation-history-by-campaign is unconfirmed.** The `supporter_zone` view
   projects exactly two columns (Campaign, summed price). The richer dashboard implied by the e-mail
   mockup (per-story countdown/collection state, downloadable confirmations, feedback, "Pro vás /
   Všechny (67)" tabs) has **no corresponding view, controller, or REST resource** located in
   `web/modules/custom/` for this pass. Either (a) this richer composition is rendered client-side by
   composing multiple existing endpoints (this `supporter_zone`-equivalent data + DonationConfirmation
   + Feedback, fetched separately and merged in the frontend, which this repo does not contain), or
   (b) the mockup overstates/anticipates functionality not yet built. Not resolvable from this
   backend source alone — **recommend a targeted follow-up**: locate/inspect the separate donor-facing
   frontend application (not present in `intake/current-solution/_source/patronus`, which is
   Drupal-backend-only) if it is in scope for this reconstruction.
2. **RO/MD equivalence unknown.** `views.view.supporter_zone.yml` exists only under
   `sync_config/config_czech/`. Whether Romania/Moldova tenants expose an equivalent donor-zone view
   (under a different config split, or a shared one this search did not surface) is unresolved.
3. **"Pro vás / Všechny (67)" tab semantics unknown.** No filter/argument on `supporter_zone` (or any
   sibling view) corresponds to a personalised-subset-vs-full-count split. Whether "Všechny (67)"
   refers to all active platform stories (unrelated to the donor's own contributions) rather than a
   donor-account concept at all is unresolved.
4. **Relationship to `ProfileResource` / account profile area is a documentation boundary, not a
   data relationship.** The profile edit capability (`/api/3.2/user/profile`) and this donation-history
   projection are two separate, currently-uncombined backend surfaces; whether the real frontend
   presents them as one composite "Můj účet" page (per the `/muj-ucet/nastaveni` and mockup dashboard
   screenshots) is a frontend-composition question outside this Drupal-backend evidence.

## Open Questions

1. Is there a single "dashboard" backend endpoint (REST resource) that aggregates donation history +
   confirmations + feedback for the account frontend, distinct from the classic Drupal View
   `supporter_zone`? Not found in this pass — the View may be legacy/back-office-adjacent while a
   newer REST-based dashboard exists elsewhere, or the View may be the actual mechanism behind
   `zona/darce` with the richer mockup being aspirational/future-facing content in the drip e-mail.
2. Does an RO/MD equivalent of `zona/darce` / `supporter_zone` exist under a different config split
   name, and if so, is its field composition identical?
3. Should the "downloadable confirmations" and "feedback" elements of the mockup, if confirmed real,
   be added as new fields/relationships on this projection, or are they better modelled as separate
   read-models composed client-side rather than folded into `DonorAccountView`? Left open pending
   resolution of Evidence Gap 1.
