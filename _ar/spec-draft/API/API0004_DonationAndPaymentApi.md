---
doc_id: API0004
title: Donation And Payment Api
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-public
references:
  - UC0005
  - UC0006
  - EN0009
  - EN0010
  - EN0013
  - FN0007
  - FN0011
  - BR-PaymentAndMoneyIntegrity
  - BR-RecurringDonationPolicy
  - BR-VoucherPolicy
  - ES0001
---

# API0004 – Donation And Payment Api

## Purpose

Public REST surface of the `transaction` custom module. Initiates a donation or a voucher
("Dobrošek") purchase by creating a `Transaction` (`EN0009`) — and, for vouchers, a `Voucher`
(`EN0013`) — then opens a payment-gateway session and returns a redirect URL for the caller to
send the donor to. This is the current-state entry point into the money hub capability
(`FN0007`) and, for the campaign-donation endpoint, into `UC0005` (Make a Donation). It does
**not** confirm payment — payment confirmation is a separate gateway-callback contract (`UC0006`,
owned by the gateway-adapter modules, out of scope of the `transaction` module and of this
document).

Ground truth: REST resource plugins under
`web/modules/custom/transaction/src/Plugin/rest/resource/**` and
`web/modules/custom/transaction/transaction.routing.yml`, cross-checked against
`config/rest.resource.transaction_*.yml` and `config/user.role.{anonymous,authenticated,supporter}.yml`.

## Consumers

- Patronus frontend (SPA) donation and voucher-purchase forms — anonymous or logged-in donor.
- Any HTTP client able to reach the public site (no client-type restriction is enforced — see
  Authorization and Open Items).

## Contract type

`rest-public` (command-style, one-way create + redirect). Every endpoint below is `POST`-only,
JSON in/JSON out (`formats: json`), created via Drupal core `rest` module plugins
(`@RestResource` annotation), not custom routes — `transaction.routing.yml` only carries admin
HTML routes (form/controller endpoints, see Open Items), no REST paths.

## Authorization

Confirmed, per `config/rest.resource.transaction_*.yml` (all `authentication: cookie`, all
`methods: [POST]`) cross-checked against `config/user.role.anonymous.yml` /
`user.role.authenticated.yml`:

| Endpoint | Drupal permission | Granted to |
|---|---|---|
| `POST /api/transaction` | `restful post transaction_rest_resource` | anonymous, authenticated (resource **disabled**, see Open Items) |
| `POST /api/3.2/transaction` | `restful post transaction_rest_resource_32` | anonymous, authenticated |
| `POST /api/2.2/voucher/buy` | `restful post transaction_voucher__rest_resource` | anonymous, authenticated |
| `POST /api/3.2/voucher/buy` | `restful post transaction_voucher__rest_resource_v32` | anonymous, authenticated |
| `POST /api/2.2/vouchers/buy` | `restful post transaction_vouchers__rest_resource` | anonymous, authenticated |

No endpoint in this contract requires the caller to be logged in: **anonymous is a first-class,
fully-permitted caller for every donation/voucher-purchase endpoint** — the "cookie" authentication
plugin only means "authenticate the session if a session cookie is present", it does not force
authentication. Where the caller *is* an authenticated session, `/api/3.2/transaction` uses the
session's own account and email instead of the `user_email` field (see Request). No CSRF token,
API key, or HMAC signature is required or checked by any of these five endpoints — same-origin/CSRF
protection relies solely on Drupal's default `X-CSRF-Token` exemption behavior for `cookie`-auth
REST, which is not itself verified in this module (Open Item).

There is no separate permission gate for the recurring-donation activation implied by the
`recurring` request flag on `/api/3.2/transaction` — activation happens inside the same anonymous/
authenticated-permitted call (see BR-RecurringDonationPolicy for the schedule-activation rule this
triggers).

## Endpoints

### 1. `POST /api/3.2/transaction` — Start a campaign donation (current version)

Plugin: `transaction_rest_resource_32` (`Drupal\transaction\Plugin\rest\resource\v32\TransactionResource`).
Config `status: true` (enabled). This is the **current** version of the donation-start contract.

#### Request

| Field | Meaning | Required | Notes |
|---|---|---|---|
| `campaign_id` | Target Campaign to donate to | yes | Must resolve to an existing Campaign; rejected if the campaign's raised amount already meets/exceeds its goal (see Failure Outcomes). |
| `payment_amount` | Donation amount, in the site's minor-agnostic price unit used by `Transaction.price` | yes | Must be numeric. Coerced to an int; current-state floor is `1` (CZK only, per a hardcoded `country === 'cz'` check) — no evidenced floor for RO/MD in this endpoint. |
| `user_email` | Donor email | conditionally required | Required only when the caller has **no** authenticated session; ignored (session email used instead) when the caller is authenticated. Validated via `patron_base.default` email validation. |
| `first_name` | Donor first name | conditionally required | Used only on anonymous-caller account creation; not validated for presence beyond being passed through. |
| `last_name` | Donor last name | conditionally required | Same as `first_name`. |
| `recurring` | Whether to set up a recurring monthly donation | no | Truthy value activates recurring scheduling (`BR-RecurringDonationPolicy`) alongside the one-off transaction. |

#### Response — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"successful"` | |
| `payment_gateway_redirect_url` | URL the caller must redirect the donor to, to complete payment on the selected country's gateway | Gateway selection (ComGate / MAIB / Netopia) is country-configuration-driven, not caller-selectable; gateway contracts themselves are out of scope of this document (see `ES0001` for ComGate). |
| `user_id` | The donor account's UUID | Only populated when the resolved/created user account is currently blocked; otherwise `null`. Purpose of exposing this to the caller is not evidenced (Open Item). |

Response is explicitly marked non-cacheable (`#cache: false`).

#### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---|---|
| `payment_amount validation error` (HTTP 400) | `payment_amount` missing/non-numeric | yes | |
| `Campaign doesn't exist` (HTTP 400) | `campaign_id` does not resolve to a Campaign | yes, with corrected id | |
| `Campaign is completed` (HTTP 400) | Campaign's raised amount already at/above its goal | no | Business close-out condition, not a data error. |
| `Email validation error` (HTTP 400) | `user_email` missing/invalid on an anonymous call | yes | |
| `Comgate error` (HTTP 500) | Gateway session creation failed (ComGate path only) | yes | **Documented-but-likely-unreachable**: the failure response is built inside a private helper and not propagated to the caller — see Hazards. Treat as intended contract, not confirmed current behavior. The MAIB and Netopia code paths do not return any structured failure response on gateway-call failure either. |

All error bodies use `{"status": "failed", "error": "<message>"}`.

### 2. `POST /api/transaction` — Start a campaign donation (superseded)

Plugin: `transaction_rest_resource` (`Drupal\transaction\Plugin\rest\resource\TransactionResource`,
non-versioned namespace). Config `status: false` — **the REST resource is disabled**; the route
does not currently serve traffic. The implementing `post()` method is a stub that ignores its
input and always returns an empty `ResourceResponse([])`; it performs no persistence and has no
real request/response contract. Recorded for completeness only — do not treat as a working v1
alongside v3.2.

### 3. `POST /api/2.2/voucher/buy` and `POST /api/3.2/voucher/buy` — Buy a single voucher

Plugins: `transaction_voucher__rest_resource` (unversioned/"2.2" path) and
`transaction_voucher__rest_resource_v32` (`v32` namespace, path `/api/3.2/voucher/buy`). Both
config entries are `status: true` (both enabled) and the two implementations are byte-for-byte
equivalent except for one input-sanitization difference noted below — they are folded into one
contract here per the versioning-fold instruction, with the v3.2 path recorded as current.

#### Request

| Field | Meaning | Required | Notes |
|---|---|---|---|
| `user_email` | Purchaser email | yes | Validated via `patron_base.default`; used to find-or-create the purchaser's account (role `supporter`). |
| `first_name` | Purchaser first name | conditionally required | Used only on account creation. |
| `last_name` | Purchaser last name | conditionally required | Used only on account creation. |
| `payment_amount` | Voucher face value | yes | Must be numeric; floored to `100` (minor unit) if lower. |
| `user_phone` | Purchaser phone | no | Passed to the Voucher entity. |
| `recipient_name` | Gift recipient's name | no | |
| `recipient_email` | Gift recipient's email | no | |
| `recipient_message` | Personal message to the recipient | no | |

Delivery type is not caller-controlled: the current code always sets `delivery_type = 'email'`.

**Version-specific difference (v3.2, `/api/3.2/voucher/buy`):** the unversioned resource treats
`user_phone`/`recipient_name`/`recipient_email`/`recipient_message` as optional (`?? null`
fallback); the `v32` implementation reads the same keys without a null-coalescing fallback, so a
request omitting one of those keys triggers a PHP notice/undefined-index warning on that variant
instead of defaulting to `null` (Confirmed from code diff; behavioral impact on the HTTP response
not evidenced — Open Item).

#### Response — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"successful"` | |
| `payment_gateway_redirect_url` | ComGate redirect URL to complete the voucher payment | Voucher purchase is hardcoded to ComGate/CZK regardless of site country configuration (Confirmed from code — no country branch, unlike `/api/3.2/transaction`). |

#### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---|---|
| `Email validation error` (HTTP 200) | `user_email` missing/invalid | yes | Returned with HTTP 200, not 4xx — failure is in-band only (`status: "failed"`). |
| `payment_amount validation error` (HTTP 200) | `payment_amount` non-numeric | yes | Same in-band-only pattern. |
| `Voucher validation` (HTTP 200) | Voucher entity failed field validation (constraint violations) | yes | Violation details are logged to Slack (`logger.slack`), not returned to the caller. |
| `Comgate error` (HTTP 200) | Gateway transaction creation threw | yes | |

Note the whole family of these voucher endpoints returns HTTP 200 for both success and failure,
distinguishing outcomes only via the `status` field in the body — unlike `/api/3.2/transaction`,
which uses 400/500 for failures.

### 4. `POST /api/2.2/vouchers/buy` — Buy a multi-denomination voucher basket

Plugin: `transaction_vouchers__rest_resource`
(`Drupal\transaction\Plugin\rest\resource\TransactionVouchersResource`). Config `status: true`.
No `v32`/versioned counterpart exists in this module for the multi-voucher path (Confirmed — do
not assume one).

#### Request

| Field | Meaning | Required | Notes |
|---|---|---|---|
| `user_email` | Purchaser email | yes | Same validation as the single-voucher endpoints. |
| `first_name` | Purchaser first name | conditionally required | |
| `last_name` | Purchaser last name | conditionally required | |
| `vouchers` | Map of `{denomination: quantity}` | yes | Total price is the sum of `denomination × quantity` over entries with `quantity > 0`; must total ≥ 100 (minor unit). |
| `payment_type` | `"bank"` selects an offline/manual order; any other value (or absent) selects online card payment | no | Branches the whole request into two disjoint flows (see below). |
| `invoice` | Free-form billing/company details for an offline corporate order | no | Only read when composing the offline-order notification email; not validated or persisted as structured data. |

#### Response — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"successful"` | Same value for both the online and offline (`payment_type: bank`) branches. |
| `payment_gateway_redirect_url` | ComGate redirect URL | **Present only on the online branch.** The offline (`bank`) branch returns just `{"status": "successful"}` with no redirect URL — fulfilment is manual (an internal order email is sent; no Transaction/Voucher entity is created for the offline branch, see Side Effects). |

#### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---|---|
| `Email validation error` (HTTP 200) | `user_email` missing/invalid | yes | In-band failure, HTTP 200. |
| `payment_amount validation error` (HTTP 200) | Computed basket total non-numeric or `< 100` | yes | Message name is inherited from the single-voucher endpoints' wording even though this endpoint has no `payment_amount` field — it validates the derived `vouchers` total instead. |
| `Comgate error` (HTTP 200) | Gateway transaction creation threw (online branch only) | yes | |

## Side Effects

- **Every successful `/api/3.2/transaction` call** creates one `Transaction` (`EN0009`) in
  `PENDING` `ext_status`, linked to the resolved donor `User` and the target `Campaign`; may also
  create a `RecurringTransaction` (`EN0010`) schedule row when `recurring` is truthy
  (`BR-RecurringDonationPolicy`). May find-or-create a `User`/donor account and grant it the
  `supporter` role (`FN0007`, `FN0011` money-hub / role-grant pattern).
- **Every successful single-voucher call** (`/api/2.2/voucher/buy`, `/api/3.2/voucher/buy`)
  creates one `Transaction` (`is_voucher = 1`, `PENDING`) and one `Voucher` (`EN0013`,
  `BR-VoucherPolicy`), and may find-or-create the purchaser's `User` account.
- **`/api/2.2/vouchers/buy` online branch** creates one `Transaction` (`is_voucher = 1`,
  `PENDING`, `vouchers_data` populated with the raw request payload) but — unlike the
  single-voucher endpoints — creates **no** `Voucher` entity at request time (Confirmed from
  code: no `VoucherEntity::create` call on this path; voucher issuance for a multi-denomination
  basket is not evidenced in this module).
- **`/api/2.2/vouchers/buy` offline (`payment_type: bank`) branch** creates **no** `Transaction`
  and **no** `Voucher`; its only effect is an outbound order-notification email
  (`patron_base.smartmailing`) to an internal address. This branch is a request-for-manual-order,
  not a payment.
- All online branches open a session with an external payment gateway (ComGate for vouchers and
  CZ donations; MAIB/Netopia for MD/RO donations via `/api/3.2/transaction`) and write the
  gateway's transaction id back onto the `Transaction` (`ext_trans_id`). Gateway-side confirmation
  of the payment (moving `ext_status` to `PAID`/`CANCELLED`) is a separate contract (`UC0006`),
  not part of this document.
- The internal order-notification email (`sendOrderEmail`, via `patron_base.smartmailing`) is
  sent **only** by `/api/2.2/vouchers/buy` (both its online and offline branches). The
  single-voucher endpoints (`/api/2.2/voucher/buy`, `/api/3.2/voucher/buy`) do **not** send this
  email (Confirmed: no such call in `TransactionVoucherResource::post()`); their only outbound
  effect is the gateway session creation itself.

## Hazards (current-state, documented)

- **No signature/HMAC/CSRF verification on any of these five create-transaction endpoints.**
  Authorization is "anonymous or authenticated, cookie session optional" — there is no proof of
  possession, API key, or request-signing scheme distinguishing a genuine frontend call from any
  scripted POST. Combined with account auto-creation (`account.register`) on unrecognized emails,
  this allows unauthenticated, high-volume account and pending-Transaction creation.
- **In-band-only failure signalling with HTTP 200** on all voucher endpoints (single and basket)
  masks failures from generic HTTP-level monitoring/retries — only a body-level `status` field
  distinguishes success from failure.
- **Voucher basket endpoint's offline (`bank`) branch persists nothing**: an attacker or malformed
  client can trigger unlimited internal order-notification emails with attacker-supplied
  `invoice`/`vouchers` content (rendered into an HTML table with `Html::escape`, so not itself an
  XSS vector, but is an unauthenticated email-flooding surface) with no corresponding entity to
  audit or rate-limit against.
- **Country-based minimum-amount floor is inconsistent and partially hardcoded:**
  `/api/3.2/transaction` floors to `1` only when `Settings::get('country') === 'cz'` (a literal
  string check), with no evidenced floor for `ro`/`md`; the voucher endpoints instead hardcode a
  flat `100`-unit floor regardless of country. No shared minimum-amount policy across these
  endpoints (Open Item — see `BR-PaymentAndMoneyIntegrity` for the broader money-integrity rule
  this sits under).
- **Gateway failure handling is inconsistent across endpoints:** `/api/3.2/transaction`'s ComGate
  branch returns a structured `Comgate error` failure, but its MAIB branch only proceeds if
  `$maib_response` looks well-formed (silently leaves the Transaction in `PENDING` with no
  `ext_trans_id` otherwise) and its Netopia branch never checks a response before writing
  `PENDING` and building a redirect URL — no negative-path evidence for MAIB/Netopia gateway
  failures on this endpoint (Open Item / Hypothesis).
- **`transaction_rest_resource_32`'s ComGate branch (`paymentComgateTransaction`) reads
  `$price`, `$campaign_name`, `$user_email`, `$embedded`, `$initRecurring`, and `$data`**, none of
  which are parameters or class properties of that private method — they exist only as local
  variables inside the calling `post()` method. This is Confirmed from code (not a payload field
  this contract can promise). At minimum this yields undefined-variable warnings; on the failure
  path it also means the `Comgate error` `ResourceResponse(..., 500)` built inside the method's
  `catch` block is `return`ed from `paymentComgateTransaction()` (a `void`-typed call site) and
  discarded — `post()` never sees it and always falls through to building its own `'successful'`
  response. **Net effect: a ComGate transaction-creation failure on `/api/3.2/transaction` is not
  evidenced to produce the documented `Comgate error` failure response at all** — the endpoint
  most likely still returns `status: "successful"` with a stale/empty
  `payment_gateway_redirect_url`. Flagged as a current-state hazard, not corrected here (runtime
  confirmation is out of scope under this pass's static Runtime-truth-policy).

## References

- UC: UC0005 (Make a Donation), UC0006 (Confirm Payment — Gateway Callback; owns the confirmation
  side of the lifecycle this contract only starts)
- EN: EN0009 (Transaction), EN0010 (RecurringTransaction), EN0013 (Voucher)
- FN: FN0007 (Donation & Payment Processing — Money Hub), FN0011 (Voucher Issuance & Redemption)
- BR: BR-PaymentAndMoneyIntegrity, BR-RecurringDonationPolicy, BR-VoucherPolicy
- ES: ES0001 (ComGate) — gateway-side contract for the redirect target; MAIB/Netopia gateway
  contracts are not yet present under `_ar/spec-draft/ES/` for those two adapters specifically
  under this name (only ComGate, Netopia/MobilPay and Maib are listed as ES0001–ES0003 — Netopia
  is `ES0002`, Maib is `ES0003`; both are referenced only for gateway-side context, not restated).

## Open Items

- `transaction.routing.yml` defines only admin/back-office HTML routes
  (`transaction/result`, `transaction/remove-transparent/{id}`,
  `transaction/{id}/update-type/{type}`, the divide-transaction admin form) gated by
  `access content` / `edit transaction entities` — these are internal back-office/redirect
  utility routes, not part of this public API contract, and are not documented here. The
  `transaction/result` route in particular is the donor's browser-return landing page (reads
  `refId`/`id` query params, no mutation, no signature check) — flagged for completeness but out
  of scope of a "donation and payment" command contract; would belong in a separate
  callback/utility contract if closure work extends to it.
- `POST /api/transaction` (disabled, stub `post()`) is recorded above for traceability only; it
  should not be counted as a live endpoint in any endpoint inventory derived from this document.
- Whether `user_id` (UUID, blocked-user-only) in the `/api/3.2/transaction` success response is
  consumed by the frontend for a specific purpose (e.g. triggering an activation-email resend
  flow) is not evidenced in this module.
- The actual payment-gateway callback/IPN contracts (ComGate/MAIB/Netopia server-to-server
  payment confirmation, and any HMAC/signature scheme they use or lack) live in the `comgate`,
  `maib`, and `netopia` modules, not in `transaction` — out of ground-truth scope for this
  document. `FLOW-candidates.md` (FL021–FL023) already flags missing callback idempotency as an
  open concern at the flow level; a dedicated API contract for those callback endpoints, if
  synthesized, should own that hazard rather than this document.
- The `facebook_leads`-module anonymous-webhook-with-hardcoded-verify-token hazard named in this
  task's brief belongs to a different module
  (`rest.resource.facebook_lead_webhook_resource*` / `facebook_leads_facebook`) and is not part of
  the `transaction` module's ground truth — not documented in this contract; flagged here only so
  it is not silently dropped from the closure-phase backlog.
