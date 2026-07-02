# EN Canonicalization Report

## 1. Active rules and template used

- `tooling/docs/rules-EN.md`
- `tooling/docs/cross-layer-discipline.md`
- `tooling/templates/template-EN.md`

## 2. EN files refreshed

- `_ar/spec-draft/EN/EN0006_Contact.md` — rewritten in place to the canonical structure (Purpose,
  Lifecycle, State Transitions, Attributes [System-managed / User-provided], Invariants,
  Relationships, Open Questions).
- `_ar/spec-draft/EN/EN0013_Voucher.md` — rewritten in place to the canonical structure (Purpose,
  Lifecycle, State Transitions, Attributes [System-managed / User-provided], Invariants,
  Relationships, Open Questions).
- `_ar/spec-draft/EN/EN0020_Partner.md` — rewritten in place to the canonical structure (Purpose,
  Lifecycle, State Transitions, Attributes [System-managed / User-provided], Invariants,
  Relationships, Open Questions).
- `_ar/spec-draft/EN/EN0017_ScoringRecord.md` — rewritten in place to the canonical structure (Purpose,
  Lifecycle, State Transitions, Attributes [System-managed / User-provided], Invariants,
  Relationships, Open Questions).
- `_ar/spec-draft/EN/EN0024_Blog.md` — rewritten in place to the canonical structure (Purpose,
  Lifecycle, State Transitions, Attributes [System-managed / User-provided], Invariants,
  Relationships, Open Questions).

- `_ar/spec-draft/EN/EN0021_Feedback.md` — rewritten in place to the canonical structure (Purpose,
  Lifecycle, State Transitions, Attributes [System-managed / User-provided], Invariants,
  Relationships, Open Questions).

## 3. Implementation trace categories removed

- File paths and filenames (e.g. `ContactEntity.php`, `ContactEntityStorageSchema.php`).
- Class/method/service names (e.g. `AccountService::register`, `AccountService::ensureUser`,
  `ContactRemoveDuplicatesController::delete()`, `ScoringService::setBlacklistType`).
- Raw DB/schema tokens presented as code (`base_table`, `field_name`, `blacklist_type`,
  `entity_reference`, `list_string`, `phone_number`, composite index notes).
- Framework revision/ORM mechanics (`uuid`/`langcode`/`vid`, revisionable/fieldable flags,
  `contact.install` hook_schema commentary, `baseFieldDefinitions`).
- The `## Origin`, `## Entity Category`, `## Technical Fields`, `## Spec Alignment`, and `Evidence:`
  implementation-scaffolding sections.
- Schema-level relationship phrasing ("soft entity_reference (no DB FK)", "target_id") — relationship
  structure at that level is owned by DOMAIN-aggregates/ARCH, not EN.
- (EN0013) Evidence link/file path (`VoucherEntity.php`), class/method names (`VoucherEntity`,
  `TransactionEntity::updateVoucherStatus`, `generateMultipleVouchers`, `VoucherApplyResource`),
  line-number citations (L371-373, L269-271, L806-819, L116-127), and raw schema tokens
  (`base_table voucher`, `voucher.install`, `hook_schema`, `getOwner()`) — plus the `## Origin`,
  `## Entity Category`, `## Technical Fields`, and `## Spec Alignment` scaffolding sections.
- (EN0020) File path/class name (`partner/src/Entity/PartnerEntity.php`), raw schema tokens
  presented as code (`base_table partner`, `list_string`, `er`), and the `## Entity Category`,
  `## Origin`, `## Technical Fields`, `## Spec Alignment`, `## Allowed Statuses`, and `Evidence:`
  implementation-scaffolding sections.
- (EN0024) File paths and class name (`blog/src/Entity/BlogEntity.php` and its ~600 LOC/18-file
  module-size note, BlogService/ListBuilder/AccessControlHandler/RouteProvider/ThemeNegotiator, Form/
  Controller/REST-resource/Views-field classes), method/line citations (`preSave:76`, the raw
  `update blog set is_hero_post=false` SQL, `getOwner:176`, the `generateSlug` service call), and the
  `## Entity Category`, `## Origin`, `## Technical Fields`, `## Spec Alignment`, `Evidence:`
  implementation-scaffolding sections; schema-level phrasing ("no unique key declared",
  "publishedBaseFieldDefinitions()", "soft ref").

- (EN0021) File paths/class names (`feedback/src/Entity/FeedbackEntity.php`,
  `FundraiserFeedbackForm.php`, `CampaignFeedbackForm.php`), method/line-number citations
  (`FeedbackEntity::create(...)`, `:109`, `:182`, `:276`), and raw schema tokens presented as
  code (`base_table feedback`, `string_long`, `er ->`) — plus the `## Entity Category`,
  `## Origin`, `## Technical Fields`, and `## Spec Alignment` scaffolding sections.

## 4. Lifecycle sections rewritten into canonical language

- Creation ("(create) → person, field_name=role") is now modeled as a `(none) → Active` transition
  triggered by **UC0001** (Submit Application), which covers both self-registration and Admin
  promotion of case-profile data into a Contact/User.
- The scoring-driven `blacklist_type` write is now an `Active → Active` transition triggered by
  **UC0003** (Assess Applicant Risk), with the rule content (email-keyed write, no record-count bound)
  cited to **BR-ScoringAndRiskGating** instead of restated.
- Dedup/merge reference-reassignment and the hard-delete of the losing record are now transitions
  triggered by **UC0016** (Maintain Party Records), with the destructive/non-transactional
  current-state behavior cited to **BR-PartyIdentityAndDeduplication** instead of restated.
- The absence of a soft-delete/archive path is preserved as the `Merged-out (terminal)` state note
  rather than as a code-level claim about the deduplication controller.
- (EN0013) The paid promotion ("status 0 → 1 when purchasing Transaction reaches PAID") is now a
  `Unpaid → Paid` transition triggered by **UC0006** (Confirm Payment / Gateway Callback), with the
  owner-derivation and paid-precondition rules cited to **BR-VoucherPolicy** instead of restated.
- (EN0013) The redemption write ("is_applied 0 → 1, campaign set") is now a `Paid & not redeemed →
  Paid & redeemed` transition triggered by **UC0009** (Redeem / Validate Voucher), with the
  single-use/re-attribution rules cited to **BR-VoucherPolicy** instead of restated.
- (EN0013) The unevidenced expiration/reminder behavior is kept out of the confirmed transition list
  and recorded as a Hypothesis note plus an Open Question, rather than modeled as a canonical
  `Paid → Expired` state.
- (EN0020) The `status` publish flag is now modeled as an `Unpublished ↔ Published` lifecycle; since
  no UC or BR document references Partner, both transition triggers are recorded as
  `Unknown — Not evidenced in current sources` rather than inferred from the schema alone.
- (EN0024) The `status` publish flag is modeled as an `Unpublished ↔ Published` lifecycle; the
  procedural single-hero enforcement (raw SQL clearing all other hero flags) is now an entity
  invariant ("at most one hero post at any time") rather than a described code step. No dedicated UC
  or BR covers Blog — the glossary's UC0022 link was checked and rejected as a transition-trigger
  source (UC0022 = generic workflow-engine UC, not Blog-specific), so both transition triggers are
  recorded as `Hypothesis — Not evidenced in current sources` rather than inferred or borrowed from
  an unrelated UC.

- (EN0021) Creation ("(create) -> published, fundraiser/campaign resolved from an Application")
  is now a `(none) -> Created` transition attributed to fundraiser/back-office authoring in the
  context of a Campaign (EN0004); the created -> sent dispatch-timestamp write is now a
  `Created -> Sent` transition. The adjacent Application-side feedback-waiting status entry is
  cited to **UC0002** (Orchestrate Application Status Change, fan-out step 9) as the closest
  confirmed trigger for the related session, rather than restated as this entity's own transition.

## 5. Ambiguities left out of canonical EN text (kept as Open Questions)

- Whether the email-keyed scoring classification write can unintentionally affect unrelated Contacts
  sharing that email (carried forward; now anchored to BR-ScoringAndRiskGating rather than a raw SQL
  description).
- The exact transition rules among the risk-classification values (wl_zd/wl_z/wl_n/bl equivalents) —
  remains Partial evidence, not promoted to a canonical state model.
- The retirement path (if any) for a Contact's personal data given that GDPR erasure does not cascade
  to it (BR-DataProtectionAndErasure covers the erasure gap; the Contact-side retirement path itself is
  unresolved).
- Whether derived birthdate/gender population from the national identification number is active
  current-state behavior or dormant (new — the prior draft flagged the derivation logic as "currently
  commented" in code; without reading source in this pass, it is recorded as Partial rather than
  asserted either way).
- (EN0013) Which write of the `applied` timestamp (at paid-promotion vs at redemption) is authoritative
  for "redeemed on" reporting — carried forward as a Conflict — requires clarification.
- (EN0013) Whether the Voucher code (`name`) is guaranteed unique by any mechanism beyond app-level
  best effort — carried forward per BR-VoucherPolicy's recorded current-state gap.
- (EN0013) Whether the `expiration`/`reminded` attributes back an actual expiry/reminder process —
  carried forward as Missing evidence / Unknown.
- (EN0020) How `order` governs display ordering and whether it must be unique — carried forward.
- (EN0020) Whether the `category` split (`support_us`/`partners`) maps to distinct site regions —
  carried forward.
- (EN0020) Overlap/naming-confusion risk between this entity and the unrelated taxonomy-based
  `partners` classification — carried forward.
- (EN0020) No use case or business rule references Partner at all — the administrative create/edit
  path and the publish/unpublish triggers remain entirely unconfirmed.
- (EN0024) Slug-uniqueness guarantee unconfirmed (no declared constraint) — carried forward.
- (EN0024) Whether global (non-tenant-scoped) single-hero enforcement across CZ/RO/MD is intended
  current behavior — carried forward, cross-referenced against BR-MultiTenantCountryScoping's general
  policy (which does not explicitly cover Blog).
- (EN0024) Whether the hardcoded category-id set behind `cta_filter_category` is authoritative current
  behavior or brittle/incidental coupling — carried forward.
- (EN0024) Relationship/overlap between this entity and the unrelated core "blog" content bundle
  (legacy vs. both active) — carried forward.
- (EN0024) No use case in the current reconstruction models Blog creation/publishing/hero-selection as
  a flow — left open whether this reflects plain content-admin editing outside modelled workflows, or
  a genuine evidence gap.

- (EN0021) Whether Feedback is shown publicly to donors and whether the publish flag gates that
  visibility — carried forward as Not evidenced.
- (EN0021) Whether the dispatch timestamp is meaningful across both authoring entry points, given
  only one of them was confirmed to write it — carried forward as a Conflict.
- (EN0021) The relationship between the Application's feedback-waiting status/session (UC0002) and
  an actual Feedback record (one per Application vs. per Campaign; whether the session always
  yields a Feedback record) — carried forward as Uncertain, not resolved by invention.

## 6. Missing artifacts that prevent stronger canonicalization

- No BR document defines a full state/value model for the risk classification beyond the
  scoring-write hazard in BR-ScoringAndRiskGating — a dedicated classification-lifecycle rule (if one
  exists in the domain) is not yet drafted.
- No EN-lifecycle-evidence.md or DOMAIN-kernel.md was present in `_ar/spec-draft/` to cross-check
  invariants against; invariants were sourced from the affected BR files' `affects`/`references`
  frontmatter and prose only.
- (EN0013) No dedicated job/scheduler artifact (JOB layer) exists to confirm or deny the
  expiration/reminder behavior implied by the `expiration`/`reminded` attributes.
- (EN0020) No BR, UC, or FLW evidence artifact references Partner at all (confirmed by search across
  `_ar/spec-draft/BR/`, `UC-candidates.md`, `_ar/spec-draft/UC/`, and `_ar/repo-map/glossary.md`) —
  state-transition triggers cannot be resolved beyond "Unknown" without new evidence collection
  (e.g. an admin-UI flow scout or a BR pass covering marketing/CMS content).
- (EN0024) No BR document exists for Blog, and no UC document models Blog-specific flows (confirmed by
  search across `_ar/spec-draft/BR/`, `UC-candidates.md`, and `_ar/spec-draft/UC/`); the only flow hit
  is a Partial scheduler row (FL057) in `_ar/evidence/flow-index.md`, insufficient to anchor a
  transition trigger. A dedicated content/marketing UC and BR pass would be needed for stronger
  canonicalization.

- (EN0021) No BR document exists for Feedback; no confirmed UC step in the current draft set
  directly models fundraiser-authored Feedback creation (UC-candidates.md associates the entity
  with UC0011, but UC0011's body does not cover Feedback creation) — the creation trigger is
  recorded as Partial evidence rather than invented as a full UC step.

## 7. Recommended next step

Canonicalize the remaining EN files in `_ar/spec-draft/EN/` (EN0001–EN0005, EN0007–EN0012, EN0014–EN0016,
EN0018–EN0019, EN0021–EN0023, EN0025–EN0032) using the same procedure, then re-run CrossLayerAuditor to
confirm no restatement violations were introduced across the refreshed set.
