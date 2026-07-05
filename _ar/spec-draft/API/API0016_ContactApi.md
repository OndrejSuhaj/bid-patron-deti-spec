---
doc_id: API0016
title: Contact API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-internal
references:
  - UC0003
  - EN0001
  - EN0002
  - EN0006
  - FN0004
  - FN0014
  - BR-ScoringAndRiskGating
---

# API0016 – Contact API

## Purpose

Single REST resource exposed by the `contact` custom module: a read-only, ad-hoc risk pre-check that,
given an ApplicationProfile identifier, looks up the owning Application and returns a heuristic
"repeat applicant" risk note and numeric score computed from a handful of fundraiser/patron fields.
This is not a CRUD contract over the Contact entity (`EN0006`) itself — the `contact` module's Contact
entity CRUD is exposed only through internal HTML admin routes/forms (`contact.routing.yml`:
`/admin/contact/{contact}/fundraiser/edit`, `/admin/contact/{contact}/patron/edit`,
`/admin/contact/{contact}/versions`, `/admin/contact/remove_duplicates`, `/admin/contact/search`),
which are Drupal form/controller routes, not REST contracts, and are out of scope here (see Open
Items; the destructive dedup/merge behavior reachable from `/admin/contact/remove_duplicates` is
modeled at `FN0014`, not restated in this document).

Ground truth: the single REST resource plugin under
`web/modules/custom/contact/src/Plugin/rest/resource/ContactResource.php` (plugin id
`contact_resource`, `@RestResource` `uri_paths.canonical = "/api/contact"`), cross-checked against
`config/rest.resource.contact_resource.yml`, `contact.routing.yml`, `contact.permissions.yml`, and all
`config/user.role.*.yml` files. No `contact.routing.yml` entry defines `/api/contact` — the path comes
solely from the `@RestResource` annotation (Drupal core `rest` module mechanism, not documented
further here per API restrictions).

## Consumers

- Back-office staff with an authenticated Drupal session, reachable only through Drupal's generic
  `restful get contact_resource` permission — see Authorization. No caller is confirmed to actually
  hold this permission in the examined role configuration (see Hazards).
- No anonymous/public consumer is evidenced.

## Contract type

`query` (single `GET` endpoint; no `POST`/`PATCH`/`DELETE` method is implemented on this resource).

## Versioning Notes

No `v3.1`/`v3.2`/`v3.3` (or any other version-suffixed) REST plugin, route, or config entry exists for
`contact_resource` — only the single unversioned variant is present in `config/` and in
`ContactResource.php`. The task framing's expectation of folding v3.1/v3.2/v3.3 variants into one
contract **does not apply to this module**; recorded here as an evidence gap rather than invented.

Two other REST resources with adjacent names — `contact_form_resource_30` and
`contact_form_resource_32` (`config/rest.resource.contact_form_resource_30.yml`,
`config/rest.resource.contact_form_resource_32.yml`) — do carry version suffixes and do superficially
resemble a "Contact" API, but their `dependencies.module` is `feedback`, not `contact` (Confirmed from
each file's `dependencies:` block). They belong to the `feedback` module's own REST surface, not to
this module's ground truth, and are out of scope for this document — flagged here only so the
version-folding instruction is not silently misapplied to the wrong module.

## Authorization

Confirmed, per `config/rest.resource.contact_resource.yml` (`authentication: cookie`, `methods:
[GET]`, `formats: [json]`), cross-checked against all `config/user.role.*.yml` files and
`contact.permissions.yml`:

| Endpoint | Drupal permission | Granted to |
|---|---|---|
| `GET /api/contact` | `restful get contact_resource` | **No role** in the examined config (`content_admin`, `coordinator`, `front`, `fundraiser`, `manager`, `marketing`, `risk_manager`, `senior_coordinator`, `accountant`, `organisation_worker`, `patron`, `supporter`, `authenticated`, `anonymous`) explicitly grants this string — see Hazards. |

Authentication mode is `cookie` (an active Drupal back-office session), not a bearer/API token. The
`ContactResource` constructor injects `current_user` but the `get()` method body never reads
`$this->currentUser` — no additional in-code role/permission check is layered on top of the generic
REST permission gate (Confirmed from code).

`contact.permissions.yml`'s own permissions (`search contacts`, `edit contact entities`, `add contact
entities`, `delete contact entities`, `view published/unpublished contact entities`, `administer
contact entities`) govern the module's HTML admin routes (see Purpose) and the Contact entity's own
`ContactEntityAccessControlHandler` — none of them govern `/api/contact`, which is gated solely by the
separate, auto-generated `restful get contact_resource` permission (Confirmed: `ContactResource.php`
performs no `\Drupal::currentUser()->hasPermission('search contacts')`-style check, and none of the
`contact.permissions.yml` strings appear anywhere in the resource class).

Also relevant: the config resource's `status` flag is `true` in `rest.resource.contact_resource.yml`
(the resource is config-enabled), in contrast to several sibling REST resources in this codebase that
are `status: false`. The endpoint is therefore routable, but — per the role-grant gap above — not
confirmed callable by any documented role.

## Endpoint

### `GET /api/contact` — Repeat-applicant risk pre-check note

Plugin: `contact_resource` (`Drupal\contact\Plugin\rest\resource\ContactResource::get()`).

#### Request

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `aprofile` (query param) | ApplicationProfile (`EN0002`) identifier to resolve to its owning Application | yes (functionally) | Cast to integer; if `<= 0` or if no Application row references it, the endpoint falls through to the generic error response (see Failure Outcomes). The parameter name (`aprofile`) is an ApplicationProfile id, not a Contact id, despite the endpoint living in the `contact` module. |

No request body; `GET` only. A second, unrelated, dead code path (`getContacts()` — a raw `LIKE`
search over a `{contact}` table keyed on `name`/`last_name`/`phone`/`email`) exists in the class but is
never invoked by `get()` (its call site is commented out) — **Confirmed** dead code, not part of the
live contract; not modeled further as an endpoint.

#### Response — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | Literal `"successful"` | Returned only when `aprofile` resolves to an Application (`EN0001`) that has at least one `ApplicationProfile` role attached. |
| `score` | Signed integer heuristic score | Starts at 0; accumulates `+10` if the patron's `patron_occupation_list` value equals `0` ("State administration employee" per `ApplicationProfileEntity`'s field definition — the resource's own inline Czech comment mislabels this option as "sociální pracovník" / social worker; **Confirmed** discrepancy between code comment and the actual field's allowed-value label, not corrected here), forced to `-1` if `gift_payment_type` equals `1` ("Payment to the applicant's BÚ \[bank account\]"), and further adjusted by the case's gift-risk band (`+10` for low risk via `checkGiftRisk()` on `EN0001`, forced to `-1` for high risk, unchanged for medium). A `-1` from either the payment-type or the gift-risk check is **not additive with a prior positive contribution** — the code overwrites `$score` to `-1` rather than subtracting, so a later positive contribution can still raise it back above `-1` if evaluated afterward (Confirmed from the literal `if ($score >= 0) $score = -1;` / `+= 10` sequencing in source; recorded as observed behavior, not as an intended scoring formula). |
| `note` | Human-readable, Czech-language multi-line explanation string | Concatenates fixed placeholder lines (`"Žadatel: Nový - není v databázi ani BL (0)"`, `"Patron: Nový - není v databázi ani BL (0)"` — **Confirmed** these two lines are hardcoded literals, not derived from any actual applicant/patron lookup, despite reading like data-driven output) with the per-factor lines described under `score`, and a leading routing recommendation line (`"V kompetenci koordinátora"` if `score >= 20`, else `"V kompetenci risku"`). This is a free-text diagnostic string, not a structured field set — no sub-field breakdown is returned. |

This is a narrower, ad-hoc sibling of the structured scoring breakdown produced by UC0003's automatic
low-risk sub-flow (`FN0004`) — it does not read or write the Application's persisted scoring/low-risk
fields, and its `note`/`score` are computed fresh on each call, not stored.

#### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `{"status": "error"}` (HTTP 200) | `aprofile` is missing, `<= 0`, or does not resolve to an Application via the `application` table lookup | yes, with a valid `aprofile` | **Confirmed**: HTTP status is always 200 even on this in-band failure path — there is no 4xx/5xx response anywhere in `get()`. |

No other failure path is evidenced (e.g. no explicit handling if the resolved Application has no
fundraiser or patron `ApplicationProfile` at all — see Hazards).

## Side Effects

- **None.** Read-only: one raw SQL `SELECT id FROM {application} WHERE fundraiser_profile = :aprofile_id
  OR patron_profile = :aprofile_id LIMIT 1`, followed by `ApplicationEntity::load()` and
  `getApplicationProfile()` reads. No entity is created, updated, or deleted; no Blacklist (`EN0016`)
  or Contact (`EN0006`) record is written. Response is explicitly marked non-cacheable
  (`addCacheableDependency(['#cache' => ['disable' => true]])` on both the success and error paths).

## Hazards (current-state, documented)

- **No role is confirmed to hold the calling permission.** `restful get contact_resource` is not
  granted to any role in the examined `config/user.role.*.yml` set, including the roles that own the
  module's other admin surfaces (`coordinator`, `senior_coordinator`, `risk_manager`, `manager`,
  `content_admin`, `marketing`, `front`). Only the `administrator` role's blanket `is_admin: true`
  bypass can reach the endpoint as configured. This mirrors the same class of gap documented for the
  `scoring_visualisation_resource` endpoint in `API0012` — **Confirmed** absence of the grant in
  config; **Uncertain** whether this reflects a true production access gap or an incomplete config
  export, flagged for clarification rather than resolved.
- **Diagnostic text contains hardcoded, non-computed lines presented as findings.** The `note` field's
  "Žadatel: Nový..." and "Patron: Nový..." lines are fixed literals returned unconditionally,
  regardless of whether the fundraiser or patron actually is new / not on a blacklist — a caller
  reading the response as a genuine per-request lookup result would be misled about what was actually
  checked. **Confirmed** from code: the corresponding real lookups (`$fundraiser_email`,
  `$patron_email`) are present in source only as commented-out lines, never executed.
- **Score comment mislabels the underlying field option.** The `patron_occupation_list == 0` branch's
  inline Czech comment/output text reads "Patron sociální pracovník" (patron is a social worker), but
  option `0` on the `ApplicationProfileEntity::patron_occupation_list` field is actually labeled "State
  administration employee" in the field definition — a different occupation category. **Confirmed**
  mismatch between the endpoint's user-facing text and the entity's own field semantics; not corrected
  here per the evidence-first / no-invention rule.
- **No authorization or business check beyond the generic REST permission gate.** `ContactResource`
  injects `current_user` but never calls it — there is no per-Application access check (e.g. whether
  the caller is entitled to view the specific resolved Application/ApplicationProfile), no rate
  limiting, and no audit logging of who queried which `aprofile`. Any caller who does hold (or bypasses
  via `is_admin`) the generic permission can probe risk data for an arbitrary `aprofile` id by
  iterating the query parameter.
- **In-band error signaling with HTTP 200 throughout.** Both the "no data" and (implicitly) any
  unhandled-input path return HTTP 200 with a `status` field distinguishing success/error — there is no
  4xx/5xx status use anywhere in this resource, consistent with the pattern seen in sibling REST
  resources in this codebase (e.g. `API0012`'s `scoring_rest_resource`).

No anonymous-webhook or payment-callback-style hazards (e.g. hardcoded verify tokens, missing HMAC
signature checks) apply to this module — the single resource requires `cookie` (session)
authentication and is not a public inbound webhook or payment callback.

## References

- UC: UC0003 (Assess Applicant Risk / Scoring) — the canonical risk-assessment use case this
  endpoint's ad-hoc pre-check is adjacent to but does not invoke or persist into; not restated here.
- EN: EN0001 (Application — resolved from `aprofile` and the source of `checkGiftRisk()`), EN0002
  (ApplicationProfile — the fundraiser/patron records whose `patron_occupation_list` and
  `gift_payment_type` fields feed the score), EN0006 (Contact — the entity this module otherwise
  manages via HTML admin routes, not touched by this endpoint)
- FN: FN0004 (Risk Scoring & Assessment — the structured scoring capability this endpoint is a
  narrower, non-persisting sibling of), FN0014 (Party & Contact Management + Deduplication / Merge —
  owns the module's HTML admin routes referenced under Purpose, not restated here)
- BR: BR-ScoringAndRiskGating

## Open Items

- The module's HTML admin routes (`contact.search_contact_form`, `entity.contact.fundraiser`,
  `entity.contact.patron`, `contact.contact_entity_revisions_controller`,
  `contact.contact_remove_duplicates`, all in `contact.routing.yml`) are Drupal form/controller routes
  gated by `contact.permissions.yml` strings (`search contacts`, `edit contact entities`), not REST
  contracts, so they are out of scope for this API document — flagged here so a future UI/ARCH-facing
  pass does not lose them. The destructive dedup/merge behavior behind
  `contact.contact_remove_duplicates` is modeled at `FN0014`, not here.
- Whether the absent `restful get contact_resource` role grant (see Hazards) reflects the true
  production permission set or an incomplete config export is not resolvable from the sources examined
  for this contract. Conflict/gap — requires clarification.
- Whether this endpoint is legacy/abandoned scaffolding (given the commented-out real lookups and the
  unreachable dead `getContacts()` search path in the same class) or an active, if minimal, back-office
  tool is not evidenced. Hypothesis — not evidenced in current sources.
- Exact intended semantics of the `score` field's non-additive `-1` overwrite behavior (see Response —
  Success) are not evidenced beyond the literal code path; whether this is a deliberate "any single
  negative factor floors the score" rule or an implementation oversight is unresolved.
