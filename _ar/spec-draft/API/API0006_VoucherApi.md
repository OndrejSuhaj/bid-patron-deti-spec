---
doc_id: API0006
title: Voucher API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-public
references:
  - UC0009
  - EN0013
  - EN0009
  - EN0004
  - FN0011
  - BR-VoucherPolicy
  - MSG0025
  - ACL0009
---

# API0006 – Voucher API

## Purpose

Public REST surface for validating and redeeming a gift Voucher ("Dobrošek", EN0013): confirming a
Voucher is genuine and usable, then binding it to a chosen Campaign (EN0004) so a prepaid, paid-but-
unused Voucher becomes an applied donation. Business behavior is owned by UC0009 / FN0011 / BR-
VoucherPolicy; this document defines only the wire-level contract.

## Consumers

- Customer — the voucher recipient, typically **anonymous** (no login required); may also be the
  original buyer. Called from the public voucher-redemption web flow.

## Contract type

`callback`-style, request/response REST endpoints (not a webhook from an external system) — grouped
here as `rest-public` because both operations are open to anonymous callers.

Two operations:

- **Validate** — query-style: read-only check of a Voucher's usability; no state change.
- **Apply (Redeem)** — command-style: state-changing; binds the Voucher to a Campaign.

---

## Endpoints

### 1. Validate Voucher

| | |
|---|---|
| Method + path (current, "v2.2" era) | `POST /api/2.2/voucher/validate` |
| Method + path (v3.2) | `POST /api/3.2/voucher/validate` |
| Plugin/config id | `voucher_validation_resource`, `voucher_validation_resource_v32` |
| Maps to | UC0009.1 — Validate a Voucher |

Both versions are **behaviorally identical** — the v3.2 class is a duplicate of the base resource
with no request/response differences found. Confirmed (`VoucherValidationResource.php` vs.
`v32/VoucherValidationResource.php` — identical logic).

### 2. Apply (Redeem) Voucher

| | |
|---|---|
| Method + path (current, "v2.2" era) | `POST /api/2.2/voucher/apply` |
| Method + path (v3.2) | `POST /api/3.2/voucher/apply` |
| Plugin/config id | `voucher_apply_resource`, `voucher_apply_resource_v32` |
| Maps to | UC0009.2 — Apply (Redeem) a Voucher |

**Version difference (Confirmed):** the base (2.2) resource accepts an optional `email` field and, if
it is a syntactically valid e-mail address, records it on the Voucher as `recipient_email` before
redeeming. The v3.2 resource **does not read or set `email`/`recipient_email` at all** — this field
was dropped in v3.2. All other request fields, validation order, and side effects are identical
between the two versions.

No "v3.1" or "v3.3" voucher resource classes exist in the module; only the un-suffixed ("2.2") and
`v32` ("3.2") variants are present. Confirmed — grounded in
`web/modules/custom/voucher/src/Plugin/rest/resource/` and
`web/modules/custom/voucher/src/Plugin/rest/resource/v32/` (no other version subfolders exist).

**Current version in effect:** both the 2.2 and 3.2 paths are simultaneously enabled (both
`rest.resource.*.yml` config entities have `status: true`); there is no evidence in this module of
the older path being retired. Which path the current front-end actually calls is Unknown — not
evidenced within this module's scope.

---

## Authorization

- Both operations are reachable by the **`anonymous`** role. Confirmed —
  `config/user.role.anonymous.yml` grants `restful post voucher_validation_resource`,
  `restful post voucher_validation_resource_v32`, `restful post voucher_apply_resource`, and
  `restful post voucher_apply_resource_v32`.
- The **`authenticated`** role holds the identical four permissions (superset behavior noted at
  ACL0009) — logging in grants no additional capability or restriction on this contract.
- Transport-level authentication method configured on all four REST resources is `cookie`
  (config `authentication: [cookie]`) — i.e. session-cookie based, but since `anonymous` itself holds
  the permission, no authenticated session is actually required to call either endpoint.
- No CSRF token, no rate limiting, and no ownership check are present in the resource classes for
  either operation — see Hazards.
- See ACL0009 for the broader public-REST actor model this contract participates in.

---

## Request

### 1. Validate Voucher — Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `voucher_id` | Voucher identifier to check | yes | Despite the name, this is the Voucher's **UUID**, not its human-readable code — confirmed from `getVoucherByUuid()`. Naming is a source-level inconsistency, not a doc error. |

### 2. Apply (Redeem) Voucher — Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `voucher_id` | Voucher code to redeem | yes | Despite the same field name as Validate, this is the Voucher's **`name`** (human-readable code), not its UUID — confirmed from `getVoucherByName()`. The two endpoints use the same field name for two different identifier types — current-state inconsistency, not a doc error. |
| `campaign_id` | Target Campaign (EN0004) to apply the donation to | yes | Loaded via `CampaignEntity::load()`; request fails if not found. |
| `email` | Recipient e-mail to record on the Voucher | no | **2.2 endpoint only** — silently ignored by the v3.2 endpoint (see version difference above). Ignored (not an error) if not a syntactically valid e-mail per the platform's e-mail-validity helper. |

---

## Response

### Validate Voucher — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"valid"` or `"invalid"` | `"invalid"` is returned (HTTP 200) whenever no Voucher matches the paid-and-not-yet-redeemed lookup — unknown code, unpaid, and already-redeemed Vouchers are not distinguished from each other. |
| `voucher_code` | The Voucher's human-readable code (`name`) | present only when `status = "valid"`. |
| `expiration` | Expiration date, formatted `YYYY-MM-DDT23:59:59` | present only when `status = "valid"`; `null` if the Voucher has no expiration set. |
| `price` | The Voucher's donation value | present only when `status = "valid"`. |

### Apply (Redeem) Voucher — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"successful"` | Returned only after the Voucher is saved, the Transaction (if present) is re-pointed, and the confirmation e-mail dispatch has been invoked (see Side Effects / UC0009.2). |

### Failure Outcomes

All failure outcomes for both operations are returned as **HTTP 200** with an in-band status field —
this contract does not use HTTP error status codes to signal business failure. Confirmed from the
resource code (every failure branch constructs `ResourceResponse([...], 200)`).

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `{"status":"invalid"}` (Validate) | No Voucher found in paid + not-yet-redeemed state for the given UUID | no (unless the underlying Voucher state changes) | Covers unknown UUID, unpaid Voucher, and already-redeemed Voucher alike — not distinguished. |
| `{"status":"failed","error":"voucher_id is required"}` | Missing `voucher_id` on either endpoint | yes, after supplying the field | |
| `{"status":"failed","error":"campaign_id is required"}` (Apply) | Missing `campaign_id` | yes, after supplying the field | |
| `{"status":"failed","error":"campaign is invalid"}` (Apply) | `campaign_id` does not resolve to a loadable Campaign | yes, with a valid id | |
| `{"status":"failed","error":"Vámi zadaný kód nepoznáváme. Zkuste to prosím znovu."}` (Apply) | No Voucher matches the submitted code | conditionally | User-facing Czech copy embedded directly in the resource class, not sourced from MSG/COPY layers — current-state coupling, flagged as a hazard. |
| `{"status":"failed","error":"Vámi zadaný kód byl již uplatněn."}` (Apply) | Voucher already redeemed (`is_applied = 1`) | no | Same embedded-copy note applies. |
| `{"status":"failed","error":"voucher is invalid"}` (Apply) | Voucher not in paid state (`status = 0`) | no, until paid | |

No documented outcome exists for a malformed/non-JSON request body or unsupported HTTP method beyond
Drupal REST's default framework-level behavior — Open Item.

---

## Side Effects

On successful Apply (Redeem) only (UC0009.2, steps 5–8; owned by UC0009/FN0011 — referenced, not
restated):

- Voucher (EN0013) is updated: bound to the target Campaign, marked redeemed (`is_applied = 1`),
  redemption timestamp set (`applied`), and — 2.2 endpoint only — `recipient_email` set if a valid
  `email` was supplied.
- The Voucher's originating purchase Transaction (EN0009), if one is linked, is re-pointed to the
  same target Campaign.
- A redemption-confirmation e-mail is dispatched to the purchase Transaction's e-mail address — see
  MSG0025 for content/recipient detail and the current-state recipient-identity conflict recorded
  there. Not sent on Validate, and not sent on a failed Apply.

Validate has no side effects (read-only), per UC0009.1.

---

## Hazards (current-state)

Documented current-state risks — carried from UC0009/FN0011/BR-VoucherPolicy; referenced here for
API-contract visibility, not re-derived:

- **Open to anonymous callers, no rate limiting, no CSRF token.** Both operations are callable by
  unauthenticated clients with no throttling mechanism found in the reviewed evidence — brute-force
  guessing of Voucher UUIDs/codes is not mitigated at this layer. Hypothesis — not evidenced as
  actively exploited, but no control is present in the code reviewed. (See BR-VoucherPolicy,
  "Current-state uniqueness and concurrency risks.")
- **No enforced uniqueness on the Voucher code (`name`).** The Apply endpoint's `getVoucherByName()`
  lookup can resolve to an arbitrary matching record when codes collide (UC0009 AF3 / BR-
  VoucherPolicy). Partial / Hypothesis — data-quality risk, not a designed behavior.
- **Check-then-update race on redemption.** The not-yet-redeemed check and the save are not guarded by
  any lock/transaction found in the resource code; two near-simultaneous Apply requests for the same
  Voucher can both pass the check before either update persists (UC0009 AF4 / BR-VoucherPolicy).
  Partial / Hypothesis — concurrency risk, not a confirmed guarded behavior.
- **Two different identifier types share the same field name (`voucher_id`)** across the two
  endpoints (UUID for Validate, code/`name` for Apply) — a current-state naming inconsistency that is
  a real integration hazard for any new client built against this contract without reading both
  resource classes.
- **User-facing error copy is hardcoded in the resource class** (Czech strings for two of the Apply
  failure branches), bypassing the platform's MSG/COPY layers — current-state coupling between the
  API layer and presentation text.
- **No HMAC/signature check on either endpoint** — consistent with these being direct customer-facing
  REST calls rather than a partner/payment callback; noted for completeness since payment-callback
  contracts elsewhere in the platform carry the same no-HMAC gap.

---

## References

- UC: UC0009 (Redeem / Validate Voucher)
- EN: EN0013 (Voucher), EN0009 (Transaction), EN0004 (Campaign)
- FN: FN0011 (Voucher Issuance & Redemption)
- BR: BR-VoucherPolicy
- MSG: MSG0025 (Voucher Redemption Confirmation)
- ACL: ACL0009 (Identity, Access & Public API)

---

## Open Items

- Whether the "2.2" (un-suffixed) or the "3.2" (`v32`) path is the one actually called by the current
  front-end (or whether both are live simultaneously in production traffic) is Unknown — not evidenced
  within this module's scope; both are configured `status: true`.
- No "v3.1" or "v3.3" voucher resource variant exists in source, despite the task framing expecting
  three versions — recorded as a factual finding, not filled in.
- Failure behavior for malformed request bodies / wrong HTTP method is governed by the underlying
  Drupal REST framework and was not traced beyond the resource `post()` methods — Open Item.
- Whether any WAF/rate-limiting exists at an infrastructure layer outside this module's code is
  Unknown — out of scope for a source-code-only review.
