# API Synthesis Report — AR:APIContractSynthesizer

Closure-phase (04) contract layer. Reconstructs the current-state system-facing HTTP contract surface
of the Patronus platform (Drupal 10 custom code + config) as per-module REST-resource-plugin
contracts: request/response shape, auth mode, side effects, and hazards — verified against source
ground truth. Prose spec layers (EN/UC/FN/BR/ES/ACL/MSG) were used for context and doc_id references;
endpoint/auth/permission facts come from code and config only.

Dated: 2026-07-04.

## Rules / template used

- Governing rules: `tooling/docs/` cross-layer discipline (single-source facts, doc_id references,
  no restatement) and the closure-phase (04) contract-layer convention already established by the
  ACL layer (`AR:ACLMatrixSynthesizer` → `_ar/spec-draft/ACL/ACL00xx_*.md` + `ACL-matrix.md` +
  `ACL-synthesis-report.md`). The API layer mirrors that two-tier shape: one `API00xx_*.md` per
  logical contract-bearing module/capability, plus this map + report pair.
- Per-document template (applied by each API0001–API0018 sub-task): YAML front-matter
  (`doc_id`, `title`, `canonical_layer: API`, `spec_type: api-contract`, `status: draft`,
  `contract_type`, `references:`), Purpose, Consumers, Authorization/Auth mechanism, Endpoints
  (request/response shape per operation), Side effects, Versioning notes, Hazards, Open Items,
  References (doc_id only).
- Evidence-first / anti-hallucination rule applied throughout: every auth/permission claim is
  cross-checked against literal `config/user.role.*.yml` lines, not inferred from module intent;
  absence of a version variant (e.g. no v3.1 for a given module) is recorded as a stated finding, not
  silently invented to fit the generic v3.1/v3.2/v3.3 pattern assumed by the task brief.

## Contracts produced

18 contracts, `API0001`–`API0018`, covering **73 documented endpoint groups** (REST-resource-plugin
operations folded by business-capability, with version variants merged where behavior is materially
identical and kept distinct where a version delta changes the contract — see each doc's Versioning
Notes). Full per-doc breakdown, contract_type, auth summary, and source module: see
`API-contract-map.md`.

| Contract-type class | Count | doc_ids |
|---|---|---|
| `rest-public` (anonymous/donor-facing) | 10 | API0001–API0009, API0018 |
| `rest-internal` (session/back-office-facing, but several with confirmed anonymous-grant hazards) | 7 | API0010, API0011, API0012, API0013, API0015, API0016, API0017 |
| `webhook` (inbound, third-party-triggered) | 1 | API0014 |

## Source coverage

REST-resource-plugin-bearing custom modules ground-truthed, one API doc each:

`account`, `application`, `campaign`, `transaction`, `transaction_recurring`, `voucher`,
`donation_confirmation`, `feedback`, `blog`, `partner`, `supplier`, `scoring`, `organisation`,
`facebook_leads`, `contract`, `contact`, `email`, `patron_base` — **18 modules**.

**`patron_devel` excluded** — confirmed dev-only tooling module, not part of the production
system-facing contract surface; excluded from ground truth consistent with the project's standing
"ignore during analysis" rule for build/dev tooling (`CLAUDE.md` Ignore-during-analysis section)
applied here at module granularity.

**Not separately ground-truthed in this pass** (see Open Questions and `API-contract-map.md` "Known
gaps" section for the full list): payment-gateway callback modules (`comgate`, `maib`, `netopia`,
`monetaapi`) — their inbound callback routes are already flagged as a hazard at the ACL layer
(`ACL0005` gap G-05: payment-gateway callback routes effectively public, requiring only
`access content`) and referenced from API0004's Open Items, but were not independently contracted as
their own API00xx documents.

Every contract's auth claims were cross-checked against the full set of `config/user.role.*.yml`
(15 roles) and the relevant module's `rest.resource.*.yml` + `*.permissions.yml`, per the same
ground-truth discipline used at the ACL layer — no auth claim in any API doc rests on code reading
alone without a config cross-check, or vice versa.

## Auth / security findings (aggregate)

Findings below are aggregated from the 18 individual contracts; each is `Confirmed` from code/config
unless marked otherwise, and each traces to a specific doc for full evidence citation (file:line).

1. **Anonymous Facebook Lead webhook (API0014).** `anonymous` role holds
   `restful get/post facebook_lead_webhook_resource` and `restful get/post facebook_leads_facebook`;
   both resources declare `authentication: cookie` only — no HMAC/signature verification of the
   inbound Meta/Facebook payload. Consistent with pre-existing `ACL0001` gap G-01. The POST lead-intake
   handler itself is additionally confirmed **non-functional** (unconditional
   `{status:failed,error:"token is invalid"}`, undefined-variable warning, no entity created) — so the
   webhook is open but currently inert, not exploited-but-broken.
2. **Payment/gateway-adjacent endpoints open to anonymous (API0004, API0005, API0006).** All live
   `transaction`, `voucher`, and `transaction_recurring`-adjacent POST endpoints grant their
   `restful post <resource>` permission to **both** anonymous and authenticated roles — no CSRF token,
   no HMAC, no API key on any of them. `transaction_recurring_cancel_resource` is the sole exception,
   scoped to `supporter` only. Payment **gateway callback** routes proper (ComGate/MAIB/Netopia/
   MonetaAPI inbound status-update webhooks) are a distinct, not-yet-independently-contracted surface
   already flagged at ACL0005 gap G-05 — recorded here as an open question, not fabricated into an
   API00xx doc without ground truth.
3. **PII in payloads with weak/no ownership checks.**
   - API0001 (Account/Profile): v3.0/v3.1 profile GET/POST resolve target user by an unscoped
     `user_id`/slug parameter with no session binding → cross-user profile read/write (v3.2 closes
     this only for the plain profile call).
   - API0007 (Donation Confirmation Tax): no ownership/ACL check in `post()` → any caller can trigger
     issuance of another donor's tax-confirmation PDF (containing `rodné číslo`) to an arbitrary
     supplied email address.
   - API0012 (Scoring & Risk): `scoring_visualisation_resource` returns a graph of Application
     patron/fundraiser links including names, emails, phones, IP, child name, and `rodné číslo`; no
     field-level redaction; access-gap noted below tempers but does not eliminate the exposure.
   - API0013 (Organisation Dashboard Stats): granted to anonymous+authenticated with no
     tenant/ownership check — any caller supplying a valid Organisation UUID gets that org's
     Application-count breakdown.
   - API0017 (Email): validates domain existence and returns an eligibility flag tied to account role
     lookups; fail-open behavior on upstream (WhoisXML) error/timeout returns `true`.
4. **Unauthenticated gateway-adjacent utility/relay calls.** API0018's `/api/init` blends real DB
   aggregates with hard-coded constants and is anonymous-reachable (low sensitivity, but a rewrite
   trap if mistaken for live computed data); API0014's CAPI relay endpoint disables TLS verification
   (`CURLOPT_SSL_VERIFYHOST`/`VERIFYPEER` false) on its outbound call and contains a hardcoded
   Facebook access token + pixel ID in source (redacted from the doc, presence/location only cited).
5. **Access-gap inversions (permission exists on nobody, only `administrator` bypass reaches it).**
   API0012's `scoring_visualisation_resource` and API0016's `contact_resource` both have **no role**
   in the examined config granting their calling permission — not even the role that owns the
   corresponding back-office screen (`risk_manager` for scoring). Flagged as a hazard/Open Item in
   both docs since this is very likely an unintentional config gap rather than an intended
   admin-only restriction.
6. **In-band-only failure signalling (HTTP 200 for business failure).** A recurring cross-module
   pattern: API0002 (progress/cancel/repeat), API0005, API0006 (voucher validate/apply), API0008
   (feedback/contact-form uses HTTP 401 for validation errors instead), API0009, API0013, API0016 all
   return HTTP 200 with an in-band `status`/`error` field for failure paths — a systemic REST
   anti-pattern the rewrite should not carry forward silently.
7. **Non-functional stubs presented as live endpoints (maintenance/rewrite traps).** API0001
   (register/reset/password-recover v0 stubs; v3.2 hash-login branch calls an absent method), API0002
   (v32 profile POST has an enabled config but no source file), API0004 (root `/api/transaction`
   disabled stub), API0010 (v1 base returns `{error:disabled}`; v3.2 short-circuits to `[]`), API0012
   (`scoring_rest_resource` config-disabled stub), API0015 (contract-status probe ignores its own
   input, always returns `{"status":"success"}`), API0018 (RabbitMQ POST is a confirmed no-op that
   always claims success regardless of payload).

## Versioning (v3.1 / v3.2 / v3.3 pattern)

The task brief assumed a generic v3.1/v3.2/v3.3 REST-resource versioning pattern across all modules.
Ground truth confirms this pattern **only partially holds**, and each doc records the actual finding
rather than forcing modules into a pattern their code doesn't have:

- **Modules that do carry multiple real version variants:** `account` (unversioned/"2.3", v3.0, v3.1,
  v3.2), `application` (root, v2.2, v2.3, v3.0, v3.2), `campaign` (v2.2, v3.0, v3.1, v3.2, v3.3),
  `transaction` (v1, v2.2, v3.2), `voucher` (2.2, v3.2 — only two families, no v3.1/v3.3), `feedback`
  (v3.0, v3.2 — no v3.1/v3.3), `blog` (v3.2 only — no v3.1/v3.3), `organisation` (v3.0, v3.2 — no
  v3.1/v3.3), `donation_confirmation` (v3.1, v3.2 — no v3.3), `partner` (v1, v2.0, v3.2 — no v3.1/v3.3).
- **Modules confirmed to have exactly ONE version (no variants at all) despite the generic
  assumption:** `transaction_recurring`, `contract`, `contact`, `email`, `patron_base`,
  `facebook_leads` (v2.2 webhook + v3.2 CAPI relay are two *different* capabilities in the same
  module, not versions of the same operation), `supplier` (only 2.3 + v3.2, an already-narrow pair).
- **Absence of a version was recorded as a stated finding in the affected doc's Versioning Notes
  section, not silently invented** — per the anti-hallucination rule (`CLAUDE.md` §Evidence-first).
- Where multiple versions exist, the deltas were diffed at the code/config level and material
  behavioral differences (not just cosmetic ones) are called out per-doc, e.g.: API0001's v3.2
  profile closing the cross-user IDOR that v3.0/v3.1 have; API0002's v3.0-vs-v3.2 duplicated-profile
  scope divergence on repeat/duplicate-application; API0006's v3.2 voucher/apply silently dropping the
  optional `email` field that 2.2 accepts; API0011's v3.2 filtering unpublished taxonomy terms where
  2.3 does not.

## Open questions

1. Should payment-gateway **callback** routes (`comgate`, `maib`, `netopia`, `monetaapi` inbound
   status-update webhooks) be contracted as their own `API00xx` docs in a follow-up pass? They are
   currently only flagged as a hazard pointer inside API0004 and at the ACL layer (G-05), not
   independently ground-truthed here.
2. Blog (EN0024) and Feedback (EN0021) authoring/consumption have no owning UC/FN document yet;
   API0008 and API0009 are anchored directly to their EN (and FN0006 for Feedback) pending a future
   UC-layer pass — flagged in both docs' Open Items, not resolved here.
3. Two access-gap inversions (API0012 `scoring_visualisation_resource`, API0016 `contact_resource`)
   have **no role grant at all** in the examined config. Is this an intentional admin-only design, or
   a config regression that should be corrected in the rebuild? Recorded as Open Item, not resolved.
4. API0002's v3.2 profile-step POST has an enabled REST config granting anonymous+authenticated
   permission but **no corresponding PHP resource class was found in source**. Confirmed as a gap by
   direct search: is there a missing file, a build-time code-gen step not captured in this snapshot,
   or is the config itself stale? Not resolvable from static source alone — flagged for the
   Runtime-truth-policy owner (`_ar/tasks/Runtime-truth-policy.md`) if a live instance ever becomes
   available.
5. Supplier/Partner/Contact/Contract CRUD authoring surfaces exist only as Drupal HTML admin forms,
   not REST — confirmed out of scope for this layer, but flagged in each relevant doc's Open Items so
   a future UI/ARCH pass does not lose them.

## Recommended next step

Run **`RefIntegrityValidator`** over the newly-created `_ar/spec-draft/API/API0001`–`API0018` set
together with the existing `_ar/spec-draft/<LAYER>/_REGISTRY.md` files to (a) confirm every `doc_id`
referenced from an API doc (UC/EN/FN/BR/ES/ACL/MSG) resolves to a real, already-registered document,
and (b) register the 18 new `API00xx` doc_ids themselves into the cross-layer reference registry so
downstream layers (ACL, UC, and the eventual `spec-final`) can cite them back. After referential
integrity is confirmed, proceed to **`SpecFinalGenerator`** to fold this API layer into the
`_ar/spec-final/BA/API/**` publication tier per `tooling/docs/rules-spec-final.md`, alongside the
already-published ACL tier. The four open questions above should be either resolved or explicitly
carried into `_ar/spec-draft` as `Open Item` markers before `SpecClosureEvaluator` is run, so closure
scoring is not silently overstated.

## Write scope / compliance note

This report and `API-contract-map.md` were written per the finalize task's explicit write-scope
restriction (`_ar/spec-draft/API-contract-map.md` and `_ar/spec-draft/API-synthesis-report.md` only).
No file under `_ar/spec-draft/API/` was modified by this finalize step — all 18 contracts were
confirmed already present on disk via directory listing before this report was written. No commit was
made, per instructions (commit/push is out of scope for this step).
