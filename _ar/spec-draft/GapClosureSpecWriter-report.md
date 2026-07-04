# AR:GapClosureSpecWriter — closure report

> **AR:GapClosureSpecWriter · 2026-07-04**
> Converts UI-gap promotions (`_ar/spec-draft/UI-gap-promotions.md`) and reserved open-question slots
> (`_ar/spec-draft/UI-gap-open-questions.md`) into concrete draft artifacts, verified against **CODE**
> (`intake/current-solution/_source/patronus/`), not screenshots. Screenshots are observational only;
> code + flow evidence outrank them. Write scope for this pass: `_ar/spec-draft/**`, `_ar/evidence/**`
> only — no production code, config, or existing EN/UC files were modified; nothing was committed.
>
> Verified on disk before writing this report: all five candidate files exist under
> `_ar/spec-draft/EN/` and `_ar/spec-draft/UC/` exactly as reported by the writer sub-passes, plus one
> evidence note under `_ar/evidence/`. See §6 for the file-by-file disk check.

---

## 1. Created files (with confidence per artifact)

| doc_id | File | Spec type | Confidence | One-line verdict |
|---|---|---|---|---|
| **EN0033** | `_ar/spec-draft/EN/EN0033_GiftCategory.md` | Entity (reference data) | **Partial** (mechanism: Confirmed; full current catalogue: Evidence Pending) | GiftCategory is a real two-level taxonomy vocabulary (`category`), not a fixed enum or config entity — parent terms = category, child terms (parent_target_id>0) = subcategory. Per-category dynamic field relabelling (e.g. Tábory) is driven by a serialized `parameters` field on the taxonomy term, edited via a custom widget, seeded by `patron_base_update_cz_categories()`. That seed function contains, verbatim, all 9 categories matching the UI evidence exactly, including the Tábory field-label overrides. Linked to EN0001.category ↔ EN0004.gift_category (one-way sync) and EN0019 Supplier via `supplier_to_category`. |
| **EN0034** | `_ar/spec-draft/EN/EN0034_DonorAccountView.md` | Entity — Projection | **Partial** (core donation-history projection: Confirmed; extended dashboard: Hypothesis) | Upgraded from the planner's "mockup-only Hypothesis" framing: a real Drupal View `supporter_zone` (`zona/darce`, base table `transaction`) exists, groups PAID donation Transactions by Campaign, sums price, scopes to current user, gates on the `supporter` role — sibling of `fundraiser_zone` / `patron_zone`, CZ-config-split only. Corroborates DOMAIN-kernel INV21. The richer e-mail-mockup dashboard (per-story countdown, downloadable confirmations, feedback, "Pro vás/Všechny (67)" tabs) has **no** corresponding view/controller/REST resource in the backend source — recorded as an explicit Evidence Gap / Open Question, not asserted as built. |
| **UC0023** | `_ar/spec-draft/UC/UC0023_BrowseFilterStoryCatalogue.md` | Use case | **Partial** (core browse/filter/paginate: Confirmed; 2 sub-mechanisms: Partial/Uncertain) | REST endpoint `/api/3.3/campaigns` (`CampaignsResource` — `getCampaigns`/`applyFilters`/`applyOrder`/`applyRange`) plus `RenderRegionsController` (region picker with live per-region active-story counts) plus `CampaignEntity::getShortData()` (story card) confirm the donor-facing browse/filter/paginate capability end to end, including the "Brzy skončí" / "Zbývající částka" sort-tab mapping. Two points held at Partial and documented as Alternative Flows / Evidence Gaps in the file itself: (1) the "Samoživitelé" tab has a `single_parent` field on Campaign but no wired `filter_single_parent` parameter in the current v3.3 filter map; (2) the "SBÍRKOVÝ ÚČET" group/collection-account card has no confirmed type/parent mapping — cross-referenced to OQ-05 (now resolved, see §3) rather than re-litigated. |
| **UC0024** | `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` | Use case | **Partial** (profile read/edit + donation-history zone: Confirmed; unified "dashboard" composition: Hypothesis) | Two confirmed mechanisms: (1) self profile view/edit at `/muj-ucet/nastaveni` via `ProfileResource` (v3.1/v3.2) — editable fields are `first_name/last_name/title_prefix/title_suffix/name_format/public/worker_available/user_image` only; **e-mail is displayed in UI but not accepted as writable by any API version** (AF2, a confirmed UI/API mismatch) and password change is absent from v3.2 (AF3, available only in older v3.0/v3.1). (2) donation-history zone identical to EN0034's `supporter_zone` view (referenced, not restated, per cross-layer discipline). The richer composed dashboard (tracked stories with countdown, downloadable confirmations, feedback, tabs) remains Hypothesis — mockup-only, explicitly flagged in Evidence Pending. |
| **UC0025** | `_ar/spec-draft/UC/UC0025_ResumeDiscardDraftApplication.md` | Use case (standalone, not an AF of UC0001) | **Partial** | Written as a standalone UC on code grounds: draft resume/keep/delete is served by a distinct resource set (`ApplicationGETResource` resume+profile-read; `ApplicationProgressResource` progressive save; `CancelApplicationResource`/v32 direct status-set to `canceled_by_user` outside the normal role-gated transition mechanism) — separate from UC0001's registration/creation resources. The modal's reappearance on the unrelated `/dekujeme` post-payment page further confirms functional/temporal independence from UC0001's session lifetime. Open Questions retained in-file: the exact client-side (SPA, out of repo) trigger is not evidenced; whether "Zůstat na stránce" calls any backend at all is unconfirmed (no matching REST resource found); whether cancel deactivates `ApplicationSession` rows is unconfirmed (`deactivateSession` is not called from `CancelApplicationResource`). |

No artifact in this batch was blocked outright — all five had sufficient Confirmed code evidence for at least a Partial-confidence core, with gaps explicitly carved out rather than glossed over.

---

## 2. Blocked / downgraded artifacts — exact missing evidence + next investigation

Nothing was fully blocked (no-write). However, each artifact above carries **downgrades from
"Confirmed" to "Partial"** on specific sub-claims, which should be treated as mini-blocks for a future
pass. Listed here so they are not lost:

| Artifact | Downgraded sub-claim | Exact missing evidence | Recommended next investigation |
|---|---|---|---|
| EN0033 GiftCategory | Full current subcategory catalogue | Subcategory taxonomy terms live in the Drupal DB content, not in the versioned config export in this scrubbed intake — only the seed function's initial 9-category snapshot is visible in code. | If DB/content export or admin UI access becomes available (breaches current static Runtime-truth-policy), pull the live `category` vocabulary tree; otherwise treat the seed-function snapshot as the best-available baseline and mark any drift as Unknown. |
| EN0033 GiftCategory | `scoring` field usage on taxonomy term `category` | Field exists in config (`field.storage.taxonomy_term.parameters.yml` family) but no consuming code path was cited as found. | Grep `field_scoring`/`->get('scoring')` usage across `application`/`campaign` modules; if genuinely unused, mark `Status: Unknown/dead field` rather than modelling behaviour from it. |
| EN0034 DonorAccountView | Extended dashboard (tracked-story countdown, downloadable confirmations, feedback, "Pro vás/Všechny (67)" tabs) | No view, controller, or REST resource in `intake/current-solution/_source/patronus/` composes these; `donation_confirmation` and `feedback` modules exist but are not joined to any donor-facing "my dashboard" read path. | Needs either (a) the front-end SPA/theme repo (not present in this backend-only scrubbed intake) or (b) explicit client confirmation that this e-mail mockup describes a planned/target feature, not current-state — record per `it-zadani` current-vs-target rule if confirmed target-only. |
| UC0023 Browse & Filter Story Catalogue | "Samoživitelé" tab wiring | `single_parent` field exists on `CampaignEntity`, but v3.3 `CampaignsResource` filter map has no `filter_single_parent` (or equivalent) parameter confirmed. | Check REST resource versions v3.0–v3.2 and the front-end SPA API-call site (out of this repo) for whether an older/alternate filter param name is actually used; if truly unwired, flag as a live UI/backend gap, not a modelling gap. |
| UC0023 / OQ-05 | "SBÍRKOVÝ ÚČET" card front-end trigger logic | Backend confirms only `isGeneral()`/`transparent_account` single-instance mechanism (see §3); the actual client-side condition that renders the special card treatment is in a decoupled front-end component not present in this backend-only intake. | Requires the frontend repo or a runtime observation (currently out of scope per static Runtime-truth-policy) — flag as residual, do not model further from backend alone. |
| UC0024 Manage Donor Account | E-mail edit (AF2) | UI displays an "E-mail" field on the settings form; no `ProfileResource` version (v3.0–v3.2 checked) accepts email as writable. | Confirm whether email change is (a) handled by a separate unlisted endpoint, (b) admin-only, or (c) a genuine UI/backend mismatch to flag for the rebuild. Grep wider (`account` module + any `user` core-override) for an email-change resource before concluding it's simply unsupported. |
| UC0024 Manage Donor Account | Password change in current API (AF3) | v3.2 `ProfileResource` has no password field; only v3.0/v3.1 do. | Confirm via routing/config which API version is actually live for the current front-end before treating v3.2 as authoritative; if v3.1 is still active, password-change is not actually missing. |
| UC0025 Resume/Discard Draft | Client-side trigger + "Zůstat na stránce" backend call | The exact SPA-side condition that pops the modal, and whether "stay" performs any backend call, are not in this backend-only repo; no matching REST resource found for a no-op "stay" action. | Needs the front-end SPA source (out of this intake) to confirm; until then this remains a documented Open Question inside UC0025, not asserted either way. |
| UC0025 Resume/Discard Draft | `ApplicationSession` deactivation on cancel | `CancelApplicationResource` sets Application status to `canceled_by_user` but does not appear to call `deactivateSession`. | Trace `ApplicationSession` lifecycle end-to-end (grep all callers of `deactivateSession`/session state transitions) to confirm whether cancelled applications leave orphaned active sessions — potential real defect or intentional design, needs explicit code trace, not inference. |

---

## 3. Resolved Open Questions (with evidence)

Per the OQ-resolution pass (scope: OQ-01, OQ-02, OQ-05 only — OQ-03/OQ-04 were out of scope for this
task, see §4). Full detail recorded in `_ar/evidence/gap-closure-evidence.md`.

### OQ-01 — `/zadost/zadatel` vs `/zadost-formular` — **Confirmed: not a conflict**

**Verdict:** Single sequential flow (role-choice → contact/consent gate → 5-step wizard), **not** two
competing/legacy entry points. Matches the existing UC0001.1 as already drafted — no new UC, no
duplicate flow, no change to UC0001 needed.

Evidence:
- `web/modules/custom/application/application.routing.yml:227-236` (`application.user.create`,
  `/application/start/{role<fill|apply>}`)
- `web/modules/custom/application/application.routing.yml:196-210`
  (`application.application.fundraiser`, `/application/{application}/form/fundraiser`)
- `web/modules/custom/application/src/Form/UserCreateForm.php` (`buildForm` 91-176, `submitForm`
  197-215, `getRole` 226-234)
- `web/modules/custom/application/src/Controller/ApplicationHelperController.php`
  (`redirectToForm` 59-108)
- `web/modules/custom/application/src/Form/ApplicationProfileFundraiserEntityForm.php` (step 1-5
  branches, 52-208)
- `web/modules/custom/application/src/Form/ApplicationProfileBaseEntityForm.php`
  (`stepFields`/`next`/`previous`, 267-311)
- `web/themes/custom/patron_cz/templates/views/views-view--supporter-zone.html.twig:162-179`
  (role-choice cards linking to `/zadost/zadatel` and `/zadost/patron`)
- `web/themes/custom/patron_cz/templates/form/form--application-user-create.html.twig:9-12`
  ("Zpět na výběr" back link)
- `web/modules/custom/patron_gutenberg_cz/blocks/application_header/block.json:43-50` (reusable "Zpět
  na výběr" header block)

Residual (non-blocking, low priority): the literal path hosting the role-choice landing cards
themselves is not pinned to an exported code/config artifact (Drupal path aliases are content, not
exported config, in this scrubbed intake); two menu-link candidates exist
(`patron_base.module:461` → `/zadost`, `patron_base.module:476` → `/pozadat-o-pomoc`) but neither is
confirmed as *the* landing view. Does not affect the OQ-01 conflict resolution itself.

### OQ-02 — DMS SMS donation channel — **Confirmed absence**

**Verdict:** No DMS/SMS donation aggregator, short-code handler, or SMS payment path exists anywhere
in Patronus custom code. All "sms" hits are either a staff activity-log channel enum value or an
unused constant/class in the vendored Netopia (RO) payment-gateway SDK.

Evidence:
- `web/modules/custom/application_log/src/Form/ApplicationActivityForm.php:31` (`sms` as
  activity-log channel option)
- `web/modules/custom/application/src/Entity/ApplicationEntity.php:797-801` (same activity enum)
- `web/modules/custom/netopia/src/Mobilpay/Payment/Request/Sms.php` (vendored SDK class, never
  instantiated)
- `web/modules/custom/netopia/src/Mobilpay/Payment/Request.php:15,35,112`
  (`PAYMENT_TYPE_SMS` constant/default, unused; `PAYMENT_TYPE_CARD` is what's actually used)
- Grep across `web/modules/custom` for DMS / `87777` / short code / SMS gateway: zero hits.

Closed as: an externally-operated, non-Patronus channel (if it exists at all commercially, it is
outside this system's integration boundary) — no ES/UC promotion warranted.

### OQ-05 — Group / collection-account story type — **Confirmed: no distinct type**

**Verdict:** No distinct "group"/"collection-account" Campaign type value or bundle exists in code.
Campaign has a single bundle and a `type` field with exactly 4 allowed values
(`basic`/`promo`/`long_term`/`short_term`). The "SBÍRKOVÝ ÚČET" card is best explained by the existing
`isGeneral()` / transparent-account mechanism (a single hardcoded Campaign identified by ID / a
`transparent` flag, not by `type`) receiving special front-end presentation — **not** a new
entity-model type. No change to EN0004 or glossary C004 is warranted.

Evidence:
- `web/modules/custom/campaign/src/Entity/CampaignEntity.php:825-838` (`type` field, 4
  `allowed_values` only)
- `web/modules/custom/campaign/src/Entity/CampaignEntity.php:1550-1552`
  (`isGeneral(): id() == Settings::get('transparent_account', 1)`)
- `web/modules/custom/campaign/src/Entity/CampaignEntity.php:1193`
  (`->condition('transparent', 0)` — separate flag from `type`)
- `web/modules/custom/netopia/src/Controller/NetopiaPaymentResultController.php:36`
  (`#is_general` usage)
- `config/core.entity_form_display.campaign.campaign.default.yml` (only one Campaign bundle)
- Grep across `web/` for "SBÍRKOV"/"sbirkov"/"Nechám to na vás": zero hits in backend
  code/theme (front-end card copy is not present in this scrubbed backend-only intake).

Residual (non-blocking): the actual front-end condition that renders a Campaign with this special
card treatment (every `isGeneral()` campaign, or a separately curated set) lives in a decoupled
front-end component not present in this backend-only, GDPR-scrubbed intake — would require the
frontend repo or a runtime observation (out of scope per the static Runtime-truth-policy) to close
fully.

---

## 4. Unresolved Open Questions carried forward

| OQ | Topic | Status | Reason |
|---|---|---|---|
| **OQ-03** | `/poslat-aktivacni-email` confirmation content not evidenced (screenshot showed only nav/cookie-banner/footer) | **Untouched — out of scope for this pass** | This task's assigned OQ list was explicitly OQ-01, OQ-02, OQ-05 only. OQ-03 remains recorded in `_ar/spec-draft/UI-gap-open-questions.md` exactly as the planner left it (Blocked/evidence — needs re-capture of the screen's main content or the route's template/controller). |
| **OQ-04** | Legal-entity naming: "Patron dětí, z.ú." (IČO 06826911) vs "Nadace Sirius" (IČ 28418808) | **Untouched — out of scope for this pass** | Same as above; remains Partial/provenance in `UI-gap-open-questions.md`, needing full Pravidla PDF ingestion + `intake/` legal/finance evidence to resolve. Not attempted here. |
| **UC0023 residual** | "SBÍRKOVÝ ÚČET" front-end card-trigger logic | Unresolved | See §2/§3 — needs frontend repo or runtime access, both currently out of scope. |
| **UC0023 residual** | "Samoživitelé" filter wiring | Unresolved | See §2 — v3.3 filter map has no confirmed `single_parent` parameter; needs a check of other API versions / frontend call sites. |
| **UC0024 residual** | E-mail / password edit mismatches (AF2/AF3) | Unresolved | See §2 — needs confirmation of which `ProfileResource` API version is actually live in production. |
| **UC0025 residual** | Client-side trigger + "Zůstat na stránce" backend call; session deactivation on cancel | Unresolved | See §2 — needs the front-end SPA source, not present in this backend-only intake. |
| **EN0033 residual** | Full live subcategory catalogue beyond the code-seed snapshot; `scoring` field usage | Unresolved | See §2 — DB/content-level data not present in this scrubbed static intake. |
| **EN0034 residual** | Extended dashboard composition (tracked stories, confirmations, feedback, tabs) — current vs. target | Unresolved | See §2 — no backend read path found; needs client confirmation of current-vs-`it-zadani`-target status. |

None of these unresolved items required blocking any of the five artifacts in §1 — each is recorded
as an explicit Evidence Gap / Open Question **inside** the relevant artifact (per the "no silent
completeness" rule) rather than causing a block.

---

## 5. Recommended next step

1. **Re-run `RefIntegrityValidator`** to register the five new docs and rebuild
   `_ar/spec-draft/<LAYER>/_REGISTRY.md` + `REFERENCE-INTEGRITY.md`. **Action needed before that pass
   will be clean:**
   - `_ar/spec-draft/EN/_REGISTRY.md` currently lists **EN0034 only** — **EN0033 (GiftCategory) is
     missing from the EN registry** even though the file exists on disk. This must be added (see §6).
   - `_ar/spec-draft/UC/_REGISTRY.md` has **not been updated at all** — **UC0023, UC0024, UC0025 are
     all missing** from the UC registry even though all three files exist on disk. This must be
     added (see §6).
   - RefIntegrityValidator should also verify the new inbound/outbound references cited by these five
     docs (EN0001, EN0002, EN0004, EN0008, EN0009, EN0014, EN0019, EN0021, UC0001, UC0005, UC0010,
     UC0014, EN0003, SRV0005, BR-PaymentAndMoneyIntegrity) resolve cleanly and, where EN0033/34/UC0023-25
     are referenced *back* from existing docs, that those backlinks get added.
2. **CrossLayerAuditor** — check UC0024 vs EN0034 (donation-history projection referenced, not
   restated — verify no restatement crept in) and UC0023 vs EN0004/SRV0005 (Open Question
   cross-references, not duplicated content).
2. **→ IASynthesizer / WIRESynthesizer** (90-optional-bonus, UX reconstruction) — now that UC0023
   (public story catalogue browse/filter) and UC0024 (donor self-service account) exist as behaviour
   docs, the corresponding IA/WIRE artifacts for these two donor-facing areas can be reconstructed
   from the same UI evidence (`_ar/evidence/ui/ui-observed-areas.md`) with a confirmed behavioural
   backing instead of screenshot-only inference.
3. Route the 8 residual sub-gaps in §2/§4 that need the **front-end SPA/theme repo** (not present in
   this backend-only scrubbed intake) or **client/product confirmation** (current-vs-target framing
   for the extended donor dashboard, `it-zadani` cross-check) to the client-liaison track — do not
   attempt to close them from backend code alone.
4. Consider a small follow-up FLOW-EVIDENCE pass specifically for: (a) which `ProfileResource` API
   version (v3.0/v3.1/v3.2) is actually live in production (resolves the UC0024 AF2/AF3 ambiguity),
   and (b) `ApplicationSession` deactivation tracing on cancel (resolves a UC0025 residual that may be
   a real defect worth flagging for the rebuild, not just a documentation gap).

---

## 6. Disk verification (files vs. candidate report)

Checked directly against `_ar/spec-draft/EN/` and `_ar/spec-draft/UC/` before writing this report:

| Expected file | On disk? | Size | Notes |
|---|---|---|---|
| `_ar/spec-draft/EN/EN0033_GiftCategory.md` | ✅ Yes | 14,002 B | Present; **not yet listed in `EN/_REGISTRY.md`** (gap — flagged in §5). |
| `_ar/spec-draft/EN/EN0034_DonorAccountView.md` | ✅ Yes | 12,551 B | Present; **is** listed in `EN/_REGISTRY.md` (added 2026-07-04). |
| `_ar/spec-draft/UC/UC0023_BrowseFilterStoryCatalogue.md` | ✅ Yes | 13,831 B | Present; **not yet listed in `UC/_REGISTRY.md`** (gap — flagged in §5). |
| `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` | ✅ Yes | 14,060 B | Present; **not yet listed in `UC/_REGISTRY.md`** (gap — flagged in §5). |
| `_ar/spec-draft/UC/UC0025_ResumeDiscardDraftApplication.md` | ✅ Yes | 12,564 B | Present; **not yet listed in `UC/_REGISTRY.md`** (gap — flagged in §5). |
| `_ar/evidence/gap-closure-evidence.md` | ✅ Yes | 20,912 B | OQ-01/02/05 resolution detail; the only file touched under `_ar/evidence/**` by this pass. |

No doc_id was renumbered or overwritten; no existing EN/UC/MSG/ES file was modified by the five
writer sub-passes. `_ar/spec-draft/EN/_REGISTRY.md` is the one pre-existing file with a working-tree
diff (one line added for EN0034) — this is within the writer's declared scope (registry maintenance),
though incomplete as noted above (EN0033 missing).

Other untracked artifacts observed in git status (screenshots under `_ar/prtsc/`, `.claude/settings.json`)
predate or are outside this pass and were **not** created or modified by GapClosureSpecWriter.

**No commit was made** — per write-scope instructions, this agent does not commit; that remains a
separate, later step for the orchestrator/user once RefIntegrityValidator has run.
