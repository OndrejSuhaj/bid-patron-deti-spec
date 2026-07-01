# FLW0014 — API login (session)
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL011 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL011 (dossier FLW0014)
- Flow Name: API login (session)
- Primary SRV: SRV0015
- Trigger Evidence: REST resource `account_login_resource` — `post()` at `intake/current-solution/_source/patronus/web/modules/custom/account/src/Plugin/rest/resource/AccountLoginResource.php:119` (annotation `POST /api/2.3/user/login`, lines 18-25). Sibling variants: `v31/AccountLoginResource.php:120` (`POST /api/3.1/user/login`), `v32/AccountLoginResource.php:127` (`POST /api/3.2/user/login`, supports `hash` branch), `v32/AccountLoginHashResource.php:129` (`POST /api/3.2/user/login/hash` — stub, always 401), `v32/CreateMagicLinkResource.php:90` (`POST /api/3.2/user/create_magic_link`), `v32/AccountLogoutResource.php:106` (`GET /api/3.2/user/logout`).
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Anonymous client POSTs JSON credentials to a versioned login endpoint. Endpoints are cookie-authenticated REST resources (`config/rest.resource.account_login_resource*.yml`: `methods: [POST]`, `formats: [json]`, `authentication: [cookie]`). Session is established via the standard Drupal session cookie.
- Preconditions:
  - Request body carries `email` + `password` (all versions) or, for v32, a base64 `hash` token instead.
  - User account exists and is not blocked (`user_is_blocked($email)`, `AccountLoginResource.php:135`).
  - Flood control not tripped (IP-based `user.failed_login_ip` and per-user `user.http_login`, config `user.flood`).
- Main Steps (v2.3 / v3.1 password login):
  1. Validate presence of `email`/`password`; return `missing_credentials*` 401 on absence (`AccountLoginResource.php:121-131`).
  2. `floodControl($email)` checks IP + per-user limits (`AccountLoginResource.php:206`; note: return value NOT used in v2.3/v3.1 — see Failure Modes).
  3. Reject blocked users → `user_is_not_active` 401 (`:135`).
  4. `user_auth->authenticate($email, $password)` (Drupal `user.auth`) verifies password, returns uid (`:142`).
  5. On success load `User::load($uid)`; set last-login + last-access timestamps and `$user->save()` (`:169-171`).
  6. v2.3 returns `{cookie_name, cookie_value, csrf_token}` from `session` service + `csrfToken` (`:175-181`); v3.1/v3.2 additionally call `userLoginFinalize()` → `user_login_finalize($user)` and return `{status:'success', user_id:uuid, csrf_token}` (`v31:174-182`, `v32:206-214`).
- Main Steps (v3.2 hash / magic-token login, `v32/AccountLoginResource.php:141-166`):
  1. `base64_decode($data['hash'])`; split into `uid/timestamp/salt` (`:143`).
  2. Validate parts and load user; else `invalid` 401 (`:145-150`).
  3. `floodControl`, then `isTokenExpired($timestamp)` — 90-day window (7776000s), also rejects future timestamps (`:155,:300-304`).
  4. `hash_equals($salt, \Drupal::service('account')->user_pass_rehash($user,$timestamp))` (`:159`) — **calls a non-existent AccountService method; see Failure Modes**.
  5. On match → `user_login_finalize($user)`, return `{status:'success', user_id:uuid, csrf_token}` (`:160-165`).
- Postconditions: On success an authenticated Drupal session is created (session cookie), `users_field_data.login`/`.access` updated to `time()`, CSRF token minted for `rest`. Failed attempts register flood events (v3.2 password branch only, `v32:218-222`).
- Side Effects:
  - DB write: `User::save()` updates login/access timestamps (all password branches).
  - Session creation via `user_login_finalize()` (v3.1/v3.2 and magic-link controller).
  - Flood event registration on failure (v3.2 only).
  - `\Drupal::service('logger.slack')->sendMessageToZoneChannel($user, 'uspesne se \`prihlasil\`.')` invoked in v3.1 (`:176`) and v3.2 (`:208`) — **no-op: method body empty** (`slack_integration/src/SlackLogger.php:85-86`). v2.3 has this call commented out (`AccountLoginResource.php:173`).
  - `login_history` table write is NOT performed: the `hook_user_login` implementation that would insert into `login_history` is entirely commented out (`login_history/login_history.module`, whole `login_history_user_login()` body commented). So despite the START-HERE hint, no login_history row is written on login in current code.
- Integration Calls:
  - CreateMagicLink flow only: `patron_base.smartmailing->handleMail($email, {link}, 'magic_link')` → SmartMailing transactional email (`v32/CreateMagicLinkResource.php:119-120`); link built by `AccountService::getUserMagicLink()` (`AccountService.php:274`). See [../../repo-map/integrations.md](../../repo-map/integrations.md) (SmartMailing/patron_base.smartmailing).
  - Slack integration referenced but effectively absent (empty method).
  - Core password login itself makes NO external call.
- Failure Modes:
  - Missing/invalid credentials → 401 `missing_credentials*` / `invalid_username_or_password` (v2.3/v3.1) / `invalid_credentials` (v3.2).
  - Blocked user → 401 `user_is_not_active`.
  - Flood tripped → 401 IP/user block message. **Bug (Security):** in v2.3 and v3.1, `floodControl()` builds a `ResourceResponse` but the caller ignores the return value (`AccountLoginResource.php:133`, `v31:134`) — the block response is discarded and login proceeds, so IP/user flood limits are NOT actually enforced on those endpoints. Only v3.2 checks `if ($floodFailed = $this->floodControl(...)) return $floodFailed;` (`v32:152,:168`). Additionally v2.3/v3.1 never `register()` failed-login flood events (commented out `:184-190`), so flood counters never increment there.
  - v3.2 hash branch → **latent fatal:** `\Drupal::service('account')->user_pass_rehash(...)` is called (`v32:159`) but `AccountService` defines no `user_pass_rehash()` method (only `userPassRehashMultiuse()` at `AccountService.php:290` and `getUserLoginHash()` at `:266`); this branch would raise an undefined-method error at runtime. `Hypothesis` that the hash branch is therefore non-functional (static evidence: method absent).
  - v3.2 `/api/3.2/user/login/hash` (`AccountLoginHashResource`) is a stub always returning `invalid` 401 (`v32/AccountLoginHashResource.php:130`).
  - Expired/future magic token → 401 `timeout` (`v32:155-157`, 90-day TTL).

## C. Data Footprint
- Entities Written:
  - `user` (Drupal `users_field_data`): `login` + `access` timestamps via `setLastLoginTime`/`setLastAccessTime` + `save()` (`AccountLoginResource.php:169-171`; v31/v32 same). `user_login_finalize()` also touches session state.
  - `session` (Drupal `sessions` table): created/updated by `user_login_finalize()` (v3.1/v3.2) — framework-managed.
  - `login_history` (table `login_history`, schema `login_history/login_history.install`): **NOT written** — insert hook commented out; recorded here as an intended-but-inactive sink.
- Entities Read:
  - `user` — `User::load($uid)`, `loadByProperties(['mail'=>…,'status'=>1])` for flood identifier (`AccountLoginResource.php:238`), `user_is_blocked($email)`.
  - Config `user.flood` (limits/windows) — `\Drupal::config('user.flood')`.
  - `session`/`csrf` services for cookie + token response.
  - CreateMagicLink also reads `user` by `mail` (`CreateMagicLinkResource.php:98-105`).
  - `contact` — not read/written on the login path itself (contact is touched only by register/ensureUser in AccountService, not by login). Flow-index lists `contact` as an associated entity; on the pure login path it is not accessed. `Partial` on contact involvement.
- Constraints involved: `users_field_data` uniqueness on mail/name (framework); flood limits from `user.flood` config; magic-token TTL 7776000s (90 days) + no-future-timestamp check (`v32:300-304`).
- Multi-tenant scope assumptions: No explicit tenant/zone scoping on login; authentication is global per Drupal user store. The magic-link controller (`AccountController::oneTimeLogin`, `Controller/AccountController.php:139`) branches redirect target on `Settings::get('country','ro')` (cz→role-specific zone views), i.e. country is a deploy-level setting, not a per-request tenant. `Hypothesis`: single-country-per-deployment model (CZ/RO/MD as separate installs).

## D. Evidence Block
- Controller paths:
  - `web/modules/custom/account/src/Plugin/rest/resource/AccountLoginResource.php` (v2.3, `POST /api/2.3/user/login`).
  - `web/modules/custom/account/src/Plugin/rest/resource/v31/AccountLoginResource.php` (`/api/3.1/user/login`).
  - `web/modules/custom/account/src/Plugin/rest/resource/v32/AccountLoginResource.php` (`/api/3.2/user/login`, password + hash branches).
  - `web/modules/custom/account/src/Plugin/rest/resource/v32/AccountLoginHashResource.php` (`/api/3.2/user/login/hash`, stub 401).
  - `web/modules/custom/account/src/Plugin/rest/resource/v32/CreateMagicLinkResource.php` (`/api/3.2/user/create_magic_link`).
  - `web/modules/custom/account/src/Plugin/rest/resource/v32/AccountLogoutResource.php` (`/api/3.2/user/logout`, session destroy).
  - `web/modules/custom/account/src/Controller/AccountController.php:139` `oneTimeLogin()` — route `account.login` `/magic-link/{base64hash}` (`account.routing.yml:13-22`), the browser-side session-finalize counterpart (FL012).
- Service methods:
  - `Drupal\user\UserAuthInterface::authenticate()` (`user.auth`) — password verification.
  - `user_login_finalize($user)` (Drupal core) — session establishment.
  - `AccountService::getUserMagicLink()` (`AccountService.php:274`), `getUserLoginHash()` (`:266`), `userPassRehashMultiuse()` (`:290`) — magic-link/hash token minting.
  - `AccountService::user_pass_rehash()` — **referenced at `v32/AccountLoginResource.php:159` but undefined** (defect).
  - `\Drupal::service('session')->getName()/getId()`, `\Drupal::csrfToken()->get('rest')` — response payload.
  - `patron_base.smartmailing->handleMail(...)` (`patron_base/src/APIMailingService.php:67`) — magic-link email dispatch.
  - `patron_base.default->isEmailValid()` (`patron_base/src/PatronBaseService.php:114`) — CreateMagicLink email validation.
- Repository usage: `entityTypeManager()->getStorage('user')->loadByProperties(...)` (flood identifier + magic-link lookup); `User::load()`. No custom repository layer — direct entity storage.
- Event listeners: `user_login_finalize()` triggers core `hook_user_login`. Custom `login_history_user_login()` exists but its body is fully commented (`login_history/login_history.module`) → no active custom login listener. `account_user_insert/update` hooks (`account.module:38,:51`) fire on user save (login updates timestamps via `$user->save()`), but they are registration/profile hooks, not login-specific.
- Async messages: none on the login path. (Magic-link email uses SmartMailing via `patron_base.smartmailing`, which may enqueue; not on the interactive login response path.)
- Config evidence:
  - `config/rest.resource.account_login_resource.yml`, `…_v31.yml`, `…_v32.yml`, `…_account_login_hash_resource_v32.yml`, `…_create_magic_link_resource_v32.yml` — all `POST`, `json`, `authentication: [cookie]`, `status: true`.
  - `user.flood` config drives flood limits/windows (`ip_limit`, `ip_window`, `user_limit`, `user_window`, `uid_only`).
  - `login_history/login_history.install` — `login_history` table schema (uid, login, hostname, one_time, user_agent; + `admin_id` via update 8001) — inactive sink.
  - `account.routing.yml:13` `account.login` route (magic-link).
