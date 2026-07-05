---
doc_id: API0005
title: RecurringDonationApi
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-public
references:
  - UC0007
  - EN0010
  - EN0009
  - FN0010
  - BR-RecurringDonationPolicy
---

# API0005 – RecurringDonationApi

## Purpose

Lets an authenticated donor cancel their own active recurring donation schedule(s) (EN0010) from the
web front end. It is the programmatic counterpart of the on-site "cancel recurring payment" flow
(`transaction_recurring.cancel_form` / `CancelForm`) — same effect, exposed as a JSON REST endpoint for
the front-end's AJAX/API call.

Confirmed: exactly one system-facing HTTP endpoint is defined by the `transaction_recurring` module.
No listing, creation, update, or read endpoint for recurring schedules is exposed as a REST resource
in this module — schedule creation/reading happens through other flows (UC0005 Make a Donation,
UC0006 Confirm Payment), not through this API.

## Versioning note (correction against assumed scope)

Confirmed: this module contains **no evidence of version variants** (no `v3.1`/`v3.2`/`v3.3` path
segments, no version-negotiation logic, no multiple resource plugins or routing generations). A
search of `src/Plugin/rest/`, `transaction_recurring.routing.yml`, and the module's REST config export
found a single, unversioned resource plugin (`transaction_recurring_cancel_resource`) at a single path
(`/api/transaction_recurring/cancel`). This contract documents that single current version; the
"v3.1/v3.2/v3.3" framing supplied in scope is **not evidenced** for this module and is not reflected
below — see Open Items.

## Consumers

- Supporter (authenticated donor) — the front-end donor account/overview UI, calling this endpoint via
  AJAX when the donor cancels their recurring payment (mirrors `CancelForm`).

## Contract type

Command (state-changing). Not a query, not a callback, not a partner/webhook utility.

## Authorization

- Confirmed — session-based (Drupal cookie authentication only): `rest.resource.transaction_recurring_cancel_resource.yml`
  declares `authentication: [cookie]`, `methods: [POST]`, `formats: [json]`.
- Confirmed — two permissions gate the call, both granted only to the `supporter` role:
  - `restful post transaction_recurring_cancel_resource` (machine REST-resource permission)
  - `cancel own recurring transaction` (business permission checked by the HTML form counterpart's
    route; the REST resource itself performs no explicit access-control check beyond the
    `restful post ...` permission — see Open Items).
- Confirmed — no request field identifies which schedule to cancel; authorization is scoped implicitly
  to "the caller's own data" by looking up transactions via the session's current user ID
  (`current_user` service), not by an actor/tenant parameter.
- Source: `config/rest.resource.transaction_recurring_cancel_resource.yml`,
  `web/modules/custom/transaction_recurring/transaction_recurring.permissions.yml`,
  `config/user.role.supporter.yml`.

## Request

`POST /api/transaction_recurring/cancel`

Format: `json`.

### Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| *(none)* | — | — | Confirmed: the resource's `post($data)` method accepts a request body parameter but never reads any field from it. The cancellation target is derived entirely server-side from the authenticated session's user ID, not from the request payload. |

## Response

Format: `json`. Confirmed: the resource always returns HTTP 200, regardless of business outcome
(success, no-op, or "nothing to cancel"); business outcome is carried only in the `status` field —
see hazard below.

### Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"success"` | Confirmed. Returned once at least one matching RecurringTransaction (EN0010) was found and updated. |

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---:|---:|---|
| `status: "failed"`, `error: "missing transactions for this user"` | The current user has no Transaction (EN0009) records at all. | no | HTTP 200, not a 4xx/5xx — see hazard below. |
| `status: "failed"`, `error: "missing recurring transactions for this user"` | The current user has Transactions but none of them have a linked RecurringTransaction (EN0010). | no | HTTP 200, not a 4xx/5xx — see hazard below. |
| Unauthenticated / unauthorized request | Caller lacks `restful post transaction_recurring_cancel_resource` (i.e., is not `supporter` or not logged in). | no | Handled by Drupal's REST/permission layer before reaching `post()`; not a business-response body — standard REST access-denied behavior, not confirmed in this module's own code. |

## Side Effects

- Updates every RecurringTransaction (EN0010) linked — via its `transaction_id` reference — to any
  Transaction (EN0009) owned by the calling user: sets `canceled` to the current time and `status`
  (published/active flag) to `0`. See EN0010, BR-RecurringDonationPolicy.
- Confirmed: this cancels **all** of the caller's recurring schedules in one call — there is no
  per-schedule targeting. A donor with multiple active recurring schedules cannot cancel just one via
  this endpoint.
- Confirmed: unlike the HTML form counterpart (`CancelForm::submitForm`), this REST resource does
  **not** invalidate the `fundraisers_applications` / `donations` Views caches after cancellation. A
  donor who cancels via this API path may still see a stale "active recurring donation" state in
  UI elements backed by those cached Views until they are otherwise invalidated.
- No message/notification side effect is evidenced in this endpoint's code path (compare UC0007's
  post-charge notifications, which are unrelated to cancellation).

## Hazards — current-state (do not fix; record for rebuild awareness)

- **Business failure signaled as HTTP 200.** Both failure branches return HTTP 200 with
  `status: "failed"` in the body instead of a 4xx status code. A caller that checks only the HTTP
  status (a common REST client default) will treat "nothing to cancel" as success.
- **Unparameterized SQL string interpolation.** `post()` builds a second query by
  `implode("','", $transactionIds)` directly into the SQL string
  (`select id from transaction_recurring where transaction_id in ('...')`) rather than using bound
  placeholders, even though the first query (fetching `$transactionIds`) is itself properly
  parameterized. The interpolated values originate from the database (a prior `SELECT id`), not
  directly from client input, so this is not a directly attacker-controlled injection point today —
  but it is a code-pattern hazard (any future change that lets `$transactionIds` include
  client-influenced values would become exploitable). Source:
  `TransactionRecurringCancelResource::post()`, line with `$transactionIds` interpolation.
- **All-or-nothing cancellation with no target selector.** See Side Effects — a donor cannot cancel one
  of several recurring schedules independently through this endpoint; only through the identical
  all-or-nothing behavior of the HTML `CancelForm`.
- **No CSRF/anti-forgery mechanism declared in this module's own config.** The REST config restricts
  authentication to `cookie` but declares no explicit CSRF requirement in
  `rest.resource.transaction_recurring_cancel_resource.yml` itself; whether Drupal's core REST cookie-auth
  CSRF enforcement is active for this route is a platform-level (not module-level) behavior — not
  confirmed from this module's evidence alone. See Open Items.
- **No dedicated access-control check inside `post()`.** Authorization relies entirely on the
  `restful post transaction_recurring_cancel_resource` permission being supporter-only; the resource
  method itself contains no further ownership/role check (it doesn't need one, since it only ever acts
  on `$this->currentUser->id()`'s own data — but this also means there is no defense-in-depth if the
  permission were ever misconfigured onto another role).

## References

- UC: UC0007 (Process Recurring Donation — the schedule lifecycle this endpoint terminates)
- EN: EN0010 (RecurringTransaction — entity mutated), EN0009 (Transaction — used only to find the
  caller's own recurring schedules)
- FN: FN0010 (Recurring Donation Scheduling & Charging — owning capability)
- BR: BR-RecurringDonationPolicy (cancellation semantics; notes the same "cancellation effect on
  Activation state" uncertainty raised below)

## Open Items

- The task-level assumption of `v3.1`/`v3.2`/`v3.3` version variants is **not evidenced** in the
  `transaction_recurring` module's REST plugin, routing, or config. If such versioning exists, it must
  live in a different module/route not covered by this module's own source — flagging for
  clarification rather than fabricating version differences here.
- Whether cancellation (`canceled` timestamp + `status = 0`) also transitions the schedule's
  Activation state per EN0010's own Open Question #1 is unresolved at the entity layer; this contract
  only confirms the two field writes performed by `post()`, not their full lifecycle meaning.
- Whether Drupal core's REST/cookie-auth CSRF token requirement (`X-CSRF-Token`) applies to this route
  at runtime is not confirmed from this module's own config — it depends on core/contrib REST module
  behavior outside `transaction_recurring`'s custom code, which is out of this module's evidence scope.
- The REST resource accepts a `$data` request-body parameter that is never used. Whether this is dead
  parameter surface (safe to drop) or a placeholder for a not-yet-implemented targeted-cancellation
  feature is not evidenced — Hypothesis only.
