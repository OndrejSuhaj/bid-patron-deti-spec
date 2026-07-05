# ACL Synthesis Report — AR:ACLMatrixSynthesizer

Closure-phase (04) contract layer. Reconstructs the current-state access-control model of the
Patronus platform (Drupal 10 custom code + config) as an actor/role × resource × action × scope
matrix, verified against source ground truth. Prose spec layers (EN/UC/FN/BR/ARCH/ES/MSG) were used
for context and doc_id references; role/permission/route facts come from code and config only.

## Inputs consulted

- BA layers: EN (`_REGISTRY` + EN0001–EN0034), UC (UC0001–UC0025), FN (FN0001–FN0026),
  BR (20 rules), ARCH (ARCH0003–ARCH0012), ES (ES0001–ES0016), DOMAIN-kernel/aggregates, glossary.
- Ground truth (verification): 15 `config/user.role.*.yml`, 29 module `*.permissions.yml`, 28 module
  `*.routing.yml`, `config/rest.resource.*.yml`, `application/application_states.yml`,
  `application/src/Form/ChangeModStateForm.php`, `application/src/Entity/ApplicationEntity.php`,
  `export_csv/src/Controller/ExportCSVController.php`, payment gateway routing (comgate/maib/netopia/
  monetaapi), `account/`, `login_history/`, `patron_base/`, `gdpr/`, `accounting/` routing.

## Deliverables produced

| File | Purpose | Classification |
|---|---|---|
| `_ar/spec-draft/ACL/ACL0001_AccessControlMatrix.md` | Master matrix: role catalog, scope model, cross-cutting grants, all 6 gaps + anomalies | Confirmed |
| `_ar/spec-draft/ACL/ACL0002_ApplicationAndLeadAccess.md` | Application/Lead/Profile, transitions, forced state change, dual transition models | Confirmed |
| `_ar/spec-draft/ACL/ACL0003_RiskAndScoringAccess.md` | Scoring, blacklist, supplier, scoring REST | Confirmed |
| `_ar/spec-draft/ACL/ACL0004_CampaignStoryContentAccess.md` | Campaign/Patron/CMS/blog/voucher/taxonomy/feedback | Confirmed |
| `_ar/spec-draft/ACL/ACL0005_DonationsPaymentsAccess.md` | Transaction/recurring/gateway callbacks | Confirmed |
| `_ar/spec-draft/ACL/ACL0006_FinanceReconciliationReportingAccess.md` | Bank reconciliation, snapshots, reports, CSV export | Confirmed |
| `_ar/spec-draft/ACL/ACL0007_ContractDocumentAccess.md` | Contract/template/routing/donation confirmation | Confirmed |
| `_ar/spec-draft/ACL/ACL0008_PartyContactCrmAccess.md` | Contact/organisation/partner/user note | Confirmed |
| `_ar/spec-draft/ACL/ACL0009_IdentityAccessAndPublicApi.md` | User/Account/TaxPayer/public REST/magic link/login history | Confirmed (role grants); Partial (ownership predicates in code) |
| `_ar/spec-draft/ACL/ACL0010_GdprAndPlatformAdminAccess.md` | GDPR/administer */feature toggles/super-role | Confirmed |
| `_ar/spec-draft/ACL-matrix.md` | Layer map: docs, role→doc index, gap index, evidence base | — |

## Method notes

- **Roles are Drupal config, not invented.** All 15 roles taken verbatim from `user.role.*.yml`.
  `administrator` is `is_admin: true` (bypasses checks) with an empty explicit permission set;
  `anonymous`/`authenticated` are technical session tiers, kept distinct from business positions per
  Hard Rule 2.
- **Two-model transition authorization (G-06) fully traced.** Config `use application_workflow
  transition <X>` grants (per role) are one mechanism; `application_states.yml` `transition_roles` +
  `transitions` from/to (consulted by `ApplicationEntity::getAllowedStates()`) is a second, independent
  mechanism. Roles in the code allow-list: accountant, content_admin, coordinator, front, manager,
  risk_manager, senior_coordinator.
- **Ownership is not stated as a role grant (Hard Rule 7).** End-user positions
  (patron/supporter/fundraiser/organisation_worker) hold almost no config permissions; their authority
  over own records is enforced in REST resource-plugin code. Marked as ownership logic and deferred to
  the API/contract pass, not asserted as confirmed role permissions.
- **Cross-layer discipline:** entity attributes → EN; rule content → BR; capability → FN; use case →
  UC; external system → ES; referenced by doc_id, never restated (>50-char rule respected).

## Findings — current-state access gaps (surfaced, not resolved)

All `Confirmed` against code/config; documented in ACL0001 and cross-linked from the relevant BR.

1. **G-01 — Anonymous Facebook Lead webhook.** `anonymous` role holds
   `restful get/post facebook_lead_webhook_resource`; resource config uses `cookie` auth only. A
   Lead-creating inbound webhook has no role gate.
   Evidence: `config/user.role.anonymous.yml:156,199`;
   `config/rest.resource.facebook_lead_webhook_resource.yml`;
   `facebook_leads/src/Plugin/rest/resource/FacebookLeadWebhookResource.php`.
2. **G-02 — Transition legality not enforced on live change form.** `ChangeModStateForm` builds a
   plain select of *all* states (`getApplicationModStats()` → `getStates()`) and calls
   `setState($value, true, 'Změna statusu')` — the `true` forces the write. Neither the workflow
   `transitions` from/to nor the `transition_roles` allow-list is consulted. Gated only by the single
   `change entity moderation state` permission (manager, senior_coordinator).
   Evidence: `application/src/Form/ChangeModStateForm.php:48,80`;
   `application/src/Entity/ApplicationEntity.php:292–310,1396–1425`;
   `application/application.routing.yml` (`application.change_mod_state_form`).
3. **G-03 — No country/tenant scoping on exports/reads.** CSV export routes require only
   `access reports` / `export leads` / `access accounting reports`; the export controller applies no
   CZ/RO/MD filter (no `country`/`langcode`/`condition` in `ExportCSVController.php`, 1552 lines). Any
   authorized role can export cross-tenant data.
   Evidence: `export_csv/export_csv.routing.yml`; `export_csv/src/Controller/ExportCSVController.php`.
4. **G-04 — Raw-SQL state writes without workflow scoping.** Application state is persisted by a
   hand-written `INSERT INTO application_states (...)` plus `set('moderation_state', …)`, outside
   content-moderation validation. Combined with G-02 an illegal state can be committed.
   Evidence: `application/src/Entity/ApplicationEntity.php:312–327`.
5. **G-05 — Payment-gateway callback routes effectively public.** ComGate `/transaction/status_update`
   and MAIB `/transaction/status_update` require only `access content`; all three Netopia routes
   likewise. Authenticity depends on gateway signatures, not Patronus ACL. (Moneta `/monetaapiid` is
   `_access: 'FALSE'`, disabled.)
   Evidence: `comgate/comgate.routing.yml`; `maib/maib.routing.yml`; `netopia/netopia.routing.yml`;
   `monetaapi/monetaapi.routing.yml`.
6. **G-06 — Two unsynchronised transition-authorization models.** Config permissions vs code
   `transition_roles`; neither consulted by the force path (G-02).
   Evidence: `config/user.role.*.yml`; `application/application_states.yml`.

Additional anomalies (Confirmed, recorded for rebuild review):

- Bank reconciliation forms (`comgate_to_bank_form`, `bank_form`, `bank_synchronization_form`) gated
  by `edit campaign entities` rather than a finance permission — any campaign-editing role can run
  bank sync. Evidence: `accounting/accounting.routing.yml:7,16,24`. (ACL0006)
- `enable and disable features` permission is defined but assigned to no configured role; reachable
  only via `administrator` is_admin bypass. Evidence: `patron_base/patron_base.permissions.yml`,
  `patron_base/patron_base.routing.yml`. (ACL0010)
- Several `restrict access: true` `administer <entity> entities` permissions are assigned to non-super
  roles (content_admin, manager). Recorded as observed, not endorsed. (ACL0010)
- Several identity routes are `_access: 'TRUE'` (public): `/api/3.0/session/token`,
  `/api/user/exists`, `/magic-link/{hash}`, `/login`, `/tax-payer-information`. (ACL0009)

## Cross-layer / referential integrity

- Every ACL doc references EN/UC/FN/BR/ARCH by existing doc_id (verified against
  `_ar/spec-draft/*/_REGISTRY.md` listings). No new entities/roles/permissions invented.
- Gaps are cross-referenced to owning BR docs (BR-AccessControlAndRoles,
  BR-ApplicationStatusGovernance, BR-MultiTenantCountryScoping, BR-ReportingAndDataAccess,
  BR-PaymentGatewayCallbacks, BR-BankReconciliationAndMatching) — rule semantics stay in BR; ACL owns
  only the access surface.

## Open items (deferred to API/contract pass)

- Per-REST-resource ownership predicates (which field keys ownership) for public end-user resources.
- Full row-by-row reconciliation of config `use ... transition` grants vs code `transition_roles`
  per transition key.
- Whether the `edit campaign entities` gate on bank forms and the unassigned
  `enable and disable features` permission are intentional or legacy (not resolvable from source).

## Completion

- Stable ACL matrix exists (ACL0001 master + ACL0002–ACL0010 per-context). ✔
- Actor/resource/action/scope relationships explicit. ✔
- Unresolved access gaps visible (G-01…G-06 + anomalies), not silently collapsed. ✔
- No unsupported grants introduced; ownership visibility not asserted as role grant. ✔
- Idempotent: re-run overwrites the same doc_ids/paths.
