# EN Canonicalization Report

Records how the 32 EN entity documents were transformed from evidence-first, implementation-heavy
drafts into canonical, rewrite-ready entity specifications, in place. Companion to
`EN-canonicalization-map.md` (per-entity transformation table). Idempotent: refreshed in place on
each `ENCanonicalizer` run — not appended.

---

## 1. Active rules and template

Applied in the precedence order defined by `cross-layer-discipline.md` §8
(glossary → cross-layer discipline → per-layer rules → template; rules win over template; task wins
only for its own run):

- `_ar/repo-map/glossary.md` — canonical terminology (English-primary, CZ/RO/MD synonyms).
- `tooling/docs/cross-layer-discipline.md` — ownership table and the >50-char restatement rule.
- `tooling/docs/rules-EN.md` — EN layer rules (structure, restrictions: no implementation logic,
  no API design, no DB schema).
- `tooling/templates/template-EN.md` — canonical section skeleton.
- Task overrides for this run: canonical section set fixed to frontmatter + Purpose + Lifecycle +
  State Transitions + Attributes (System-managed / User-provided) + Invariants + Relationships +
  (optional) Open Questions; light `FLWxxxx` provenance tags permitted; transition triggers cited by
  UC `doc_id`; invariant rule content cited by BR `doc_id` (never restated).

Reference-resolution inputs read (read-only, not modified): `_ar/spec-draft/BR/` (19 BR files),
`_ar/spec-draft/UC-candidates.md` + `_ar/spec-draft/UC/`, `_ar/spec-draft/DOMAIN-kernel.md`,
`_ar/repo-map/glossary.md`, and sibling EN docs for relationship cross-check. Patronus source under
`intake/current-solution/_source/` was NOT read in this pass (canonicalization operates on AR
artifacts only).

---

## 2. EN files refreshed (32)

All 32 target EN files were rewritten in place to the canonical structure (Purpose, Lifecycle, State
Transitions, Attributes [System-managed / User-provided], Invariants, Relationships, Open Questions).
No new entities were discovered; no duplicate variants were created.

- `_ar/spec-draft/EN/EN0001_Application.md`
- `_ar/spec-draft/EN/EN0002_ApplicationProfile.md`
- `_ar/spec-draft/EN/EN0003_ApplicationSession.md`
- `_ar/spec-draft/EN/EN0004_Campaign.md`
- `_ar/spec-draft/EN/EN0005_Patron.md`
- `_ar/spec-draft/EN/EN0006_Contact.md`
- `_ar/spec-draft/EN/EN0007_Account.md`
- `_ar/spec-draft/EN/EN0008_User.md`
- `_ar/spec-draft/EN/EN0009_Transaction.md`
- `_ar/spec-draft/EN/EN0010_RecurringTransaction.md`
- `_ar/spec-draft/EN/EN0011_Contract.md`
- `_ar/spec-draft/EN/EN0012_ContractTemplate.md`
- `_ar/spec-draft/EN/EN0013_Voucher.md`
- `_ar/spec-draft/EN/EN0014_DonationConfirmation.md`
- `_ar/spec-draft/EN/EN0015_TaxPayer.md`
- `_ar/spec-draft/EN/EN0016_Blacklist.md`
- `_ar/spec-draft/EN/EN0017_ScoringRecord.md`
- `_ar/spec-draft/EN/EN0018_Organisation.md`
- `_ar/spec-draft/EN/EN0019_Supplier.md`
- `_ar/spec-draft/EN/EN0020_Partner.md`
- `_ar/spec-draft/EN/EN0021_Feedback.md`
- `_ar/spec-draft/EN/EN0022_EmailArchive.md`
- `_ar/spec-draft/EN/EN0023_UserNote.md`
- `_ar/spec-draft/EN/EN0024_Blog.md`
- `_ar/spec-draft/EN/EN0025_ApplicationLog.md`
- `_ar/spec-draft/EN/EN0026_ApplicationReaction.md`
- `_ar/spec-draft/EN/EN0027_ApplicationAction.md`
- `_ar/spec-draft/EN/EN0028_CampaignLog.md`
- `_ar/spec-draft/EN/EN0029_BankTransactionMail.md`
- `_ar/spec-draft/EN/EN0030_ComgateBankReconciliation.md`
- `_ar/spec-draft/EN/EN0031_CostsSnapshot.md`
- `_ar/spec-draft/EN/EN0032_ReportSnapshot.md`

Per-file source-artifact and removed/preserved detail: see `EN-canonicalization-map.md`.

---

## 3. Implementation-trace categories removed

Every category below was stripped from the canonical EN body across the 32 files (a post-write scan
confirms no residual `.php`, `::`, `->`, `base_table`, `content_moderation`,
`baseFieldDefinitions`, `target_id`, `langcode`, `/src/`, or `web/modules` tokens in the EN bodies):

- **`## Origin` / `## Entity Category` / `## Technical Fields` / `## Spec Alignment` /
  `Evidence:` / `## Allowed Statuses` scaffolding** — removed as whole sections; their surviving
  domain content was folded into Purpose / Lifecycle / Attributes / Invariants.
- **Code-touchpoints** — entity, service, subscriber, listener, controller, form, list-builder,
  access-handler, route-provider, theme-negotiator, REST-resource, and Views-field class names and
  their method names (e.g. `AccountService::register`, `TransactionEntity::updateVoucherStatus`,
  `ScoringService::setBlacklistType`, `preSave`, `getOwner`, `generateSlug`).
- **`.php` file paths and `/src/`, `web/modules`, `*.install` locations**, plus `~LOC` size notes
  and line-number citations (e.g. `:88`, `L371-373`, `submitForm:180`).
- **`::` static/method call syntax and `->` accessor / relationship shorthand** (incl. the `er ->`
  entity-reference shorthand).
- **Route strings and REST resource identifiers** (e.g. `/api/scoring/{entity_name}/{entity_id}`,
  `scoring_rest_resource`, apply-resource endpoints).
- **Config / YAML paths and raw DB / schema tokens presented as code** — `base_table`, `hook_schema`,
  `entity_keys`, `list_string`, `string_long`, `string 50`/`string 255`, `phone_number`,
  `entity_reference`, and raw SQL fragments (e.g. the hero-post update statement).
- **Framework revision / ORM keys** — `uuid`, `langcode`, `vid`, `revisionable`/`translatable`/
  `fieldable` flags, `baseFieldDefinitions()` / `publishedBaseFieldDefinitions()`,
  `content_moderation` mechanics restated as fact.
- **Schema-level relationship phrasing** — "soft entity_reference", "no DB FK", "target_id",
  "no unique key declared", "soft ref"; relationship structure at that level is owned by
  DOMAIN-aggregates / ARCH, so EN now lists related `ENxxxx` by doc_id only.

---

## 4. Lifecycle / transition sections rewritten to UC-triggered canonical form

Prior drafts expressed transitions as method calls, subscriber fan-outs, form submits, and cron
hooks. These were rewritten so each transition names the driving use case by `doc_id` (`FLWxxxx`
tags retained only as light provenance where present), not a code artifact. Representative
re-homings:

- **EN0001 Application** — `(create)→new` = UC0001; `any→target` = UC0002; `scoring→scoring_ok` =
  UC0003; signature/contract statuses = UC0004; publish/complete/`campaign_uncompleted` = UC0011;
  `duplicate` = UC0016. Terminal-vs-re-enterable status left explicitly undefined (no
  transition-legality guard), pointing to BR-ApplicationStatusGovernance.
- **EN0009 Transaction** — `→PENDING` = UC0005; `PENDING|AUTHORIZED→PAID|CANCELLED|REFUNDED` =
  UC0006; bank-import `→PAID` and reconciliation stamping = UC0008; overpayment child-split and
  recurring/voucher promotion cited to the relevant BR + UC.
- **EN0013 Voucher** — two independent dimensions (paid / redemption): `unpaid→paid` = UC0006,
  `paid-not-redeemed→redeemed` = UC0009.
- **EN0017 ScoringRecord** — manual assessment = UC0003.1; low-risk recompute = UC0003.2.
- **EN0022 EmailArchive** = UC0012; **EN0014 DonationConfirmation** = UC0010; **EN0018/EN0016**
  scoring/merge/index = UC0003/UC0016/UC0018; **EN0025/EN0026/EN0027** status audit / reaction /
  automatic transition = UC0002 (incl. UC0002.3); **EN0029/EN0030** bank reconciliation = UC0008
  (UC0008.2 / UC0008.3); **EN0031/EN0032** reporting projections = UC0017 (UC0017.3).
- Publish-flag-only entities (**EN0019 Supplier, EN0020 Partner, EN0024 Blog**) were modeled as an
  Unpublished/Published visibility lifecycle; where no UC/BR covers the writer, the transition
  trigger is marked Unknown / Hypothesis / Not-evidenced rather than invented (see §6).

---

## 5. Rule-like statements re-homed to BR citations

Statements that expressed domain policy or cross-entity constraints (BR-owned per the ownership
table) were removed from EN bodies and replaced with `doc_id` citations, never restated >50 chars.
The BR references used across the set (all resolve in `_ar/spec-draft/BR/`):

- BR-ApplicationStatusGovernance — EN0001, EN0002, EN0025, EN0026, EN0027
- BR-ScoringAndRiskGating — EN0001, EN0002, EN0006, EN0016, EN0017
- BR-PartyIdentityAndDeduplication — EN0001, EN0002, EN0006, EN0008, EN0016, EN0018
- BR-ContractAndESignature — EN0001, EN0011, EN0015
- BR-CampaignStoryLifecycle — EN0001, EN0004, EN0005
- BR-PaymentAndMoneyIntegrity — EN0004, EN0009
- BR-PaymentGatewayCallbacks — EN0009, EN0010
- BR-BankReconciliationAndMatching — EN0009, EN0029, EN0030
- BR-RecurringDonationPolicy — EN0009, EN0010
- BR-VoucherPolicy — EN0009, EN0013
- BR-DonationConfirmationAndTax — EN0014, EN0015
- BR-MultiTenantCountryScoping — EN0014
- BR-DataProtectionAndErasure — EN0006, EN0008, EN0023
- BR-AccessControlAndRoles — EN0008
- BR-CampaignRecommendationDormant — EN0004, EN0007, EN0008
- BR-SearchIndexingConsistency — EN0018
- BR-ReportingAndDataAccess — EN0031, EN0032

Invariant-ownership guidance from `cross-layer-discipline.md` §4 was applied: entity-lifecycle
statements (e.g. Transaction's PENDING→PAID states, Voucher's dual paid/redemption dimensions)
stayed EN-owned; domain-policy statements (e.g. "raised may not exceed target", scoring approval
gate, e-signature progression) were re-homed to BR by citation. Entities with no governing BR
(EN0021 Feedback, EN0028 CampaignLog, and the publish-flag/reference-data entities) carry no BR
citation and say so.

---

## 6. Ambiguities left out of canonical EN text (carried as Open Questions)

Per Hard Rule 8 and `cross-layer-discipline.md` §6, unresolved evidence was kept out of canonical
entity assertions and recorded as Open Questions, preserving prior Conflict / Hypothesis /
Partial / Missing-evidence classifications. Notable carried-forward items:

- **EN0001** — terminal-vs-re-enterable statuses undefined; Conflict: Application status field vs
  parallel Drupal moderation state as source of truth; `complete` vs `completed` exact label (Partial).
- **EN0009** — REFUNDED reachability and the AUTHORIZED→PAID capture path outside the recurring cron
  (Partial); payment-identity key has no DB-level uniqueness (concurrency/duplicate hazard) — flagged
  as a money-integrity gap under BR, not a confirmed invariant.
- **EN0013** — expiration/reminder job existence (Missing-evidence, Hypothesis); dual-write of the
  `applied` timestamp (paid-promotion vs redemption) — Conflict.
- **EN0017** — dormant `scoring_entity`-style carrier with no current writer (Status: Planned/dormant);
  manual-vs-low-risk supersedence — Conflict.
- **EN0028** — writer use case unresolved (UC0011 lists it only as Hypothesis); `(none)→Recorded`
  trigger recorded as Hypothesis; start/finish interval semantics; shared dangling-scaffolding
  pattern with EN0025.
- **EN0030** — entity carries no settlement payload and no link to the reconciled Transactions in
  evidence; audit-stub-vs-richer-storage — Conflict/Uncertain.
- **EN0019 Supplier, EN0020 Partner, EN0024 Blog** — no BR/UC coverage found by search; transition
  triggers recorded as Unknown / Not-evidenced / Hypothesis; the glossary's UC0022→Blog link was
  checked and rejected (UC0022 is the generic workflow-engine UC, not Blog-specific).
- **EN0031 / EN0032** — writer/cadence unresolved (job vs manual, Hypothesis); dangling status-key
  scaffolding and metric-value numeric-handling.

Empty Open Questions were retained as `(none)` only where absence is itself informative (per
`cross-layer-discipline.md` §5); genuinely trivial entities carry a short honest Open Questions list.

### Missing artifacts that would strengthen canonicalization

- No dedicated BR governs EN0021 Feedback, EN0028 CampaignLog, EN0019 Supplier, EN0020 Partner, or
  EN0024 Blog — several invariants/transitions therefore remain Hypothesis/Unknown rather than
  BR-cited.
- The canonical country-specific status vocabulary (~66 labels, CZ/RO/MD) lives in the status model
  (`intake/statuses/`); EN0001/EN0004 reference it rather than restating it, so cross-checking every
  literal against a machine-readable status registry is still pending.
- Some referenced UC sub-flows (e.g. UC0011→EN0028 writer, UC0008.3→EN0030 creation boundary) are
  themselves Partial/Hypothesis in the UC layer; strengthening those UC docs would let the
  corresponding EN transitions graduate from Hypothesis to Confirmed.

---

## 7. Recommended next step

1. **CrossLayerAuditor** — sweep the refreshed EN set for any residual >50-char restatement of
   BR/UC-owned content and confirm every inline mention is a `doc_id` reference.
2. **RefIntegrityValidator** — build `_ar/spec-draft/EN/_REGISTRY.md` and resolve all `references:`
   frontmatter and inline `doc_id`s (BR, UC, sibling EN) against their layer registries; any
   unresolved reference becomes a recorded Open Question, not a silent drop.
3. Feed the Open Questions in §6 (especially the missing-BR entities and the Partial/Hypothesis UC
   sub-flows) back to BR/UC authoring so a subsequent ENCanonicalizer pass can graduate them.
