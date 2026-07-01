# FLW0009 — Donation confirmation (tax document)
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL036 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL036 (dossier FLW0009)
- Flow Name: Donation confirmation (tax document)
- Primary SRV: SRV0011 (Document-Generation-&-Fulfilment)
- Trigger Evidence:
  - **CZ web form** — route `donation_confirmation.page` → `/donation-confirmation` (`web/modules/custom/donation_confirmation/donation_confirmation.routing.yml`) rendering `DonationConfirmationController::page` (`.../src/Controller/DonationConfirmationController.php:14`), which builds `DonationConfirmationRequestForm` (`.../src/Form/DonationConfirmationRequestForm.php:97`). Submit = `submitForm` (line 313), AJAX callback `ajaxSubmitCallback` (line 352).
  - **REST (SPA)** — `POST /api/3.2/donation_confirmation` (`@RestResource donation_confirmation_resource_v32`, `.../src/Plugin/rest/resource/v32/DonationConfirmationResource.php:90 post()`) and legacy `POST /api/3.1/donation_confirmation` (`.../resource/v31/DonationConfirmationResource.php:90`).
- Confidence Level: **Confirmed** (web form + both REST resources read end-to-end)

> **Scope note:** The RO "tax redirect / 2%" declaration referenced in the trigger (`account/src/Entity/TaxPayerEntity.php`, form `TaxPayerInformationForm` at route `account.tax_payer_form` → `/tax-payer-information`) is a **separate flow** — it creates `contract` + `tax_payer` entities and appends a CSV, and does **NOT** generate the CZ donation-confirmation PDF nor read the `transaction` table. Documented here only as an adjacent flow (see §B Failure/Notes); it is not part of FL036's PDF path.

## B. Behavior Digest
- **Trigger:** Donor requests a tax-deductible donation confirmation for a past year (default = previous calendar year), either via the public `/donation-confirmation` form or via SPA `POST /api/3.x/donation_confirmation`.
- **Preconditions:**
  - A matching `user` exists — resolved from the entered email (anonymous) or the logged-in user (`DonationConfirmationRequestForm::validateForm:271-294`; REST `getUser()` v32:123 / v31 by `uuid`|`mail`).
  - Email format valid via `patron_base.default::isEmailValid` (`PatronBaseService.php:114`) — web only.
  - REST requires `campaign_id` OR `confirmation_year` present (v32:98, v31:105) else HTTP 401.
  - Aggregate paid-donation total for the user/year must be > 0 (`getUsersDonationsTotal`, form:449 / v32:229) else the flow aborts.
- **Main Steps (ordered, form path):**
  1. Validate type-specific fields (individual: first/last name + `rc`; legal: `name` + `ico`) and year — `validateForm:244-269`.
  2. Resolve `user` by email (anonymous) or current user — `validateForm:274-294`.
  3. Compute donation total + last-transaction timestamp via **raw SQL** over `transaction` — `getUsersDonationsTotal:449-482` (`SUM(price)`, `MAX(created)` WHERE `test='0' AND is_donation='1' AND ext_status LIKE 'PAID'`, optional year window / campaign).
  4. Abort if total == 0 — `validateForm:300-303`.
  5. On submit, build & `save()` a `donation_confirmation` entity snapshot (name, email, address, rodne_cislo/ico, donation_total, `donation_in_words` via `convertNumberToWords` `PatronBaseService.php:317`, ip_address, user_agent, number_of_requests=1, confirmation_year) — `submitForm:330-344`.
  6. Render the confirmation HTML template + generate PDF, then email it — `sendEmail:368` → `getEmailAttachment:381` → `getDonationConfirmationBase64:395`.
- **Postconditions:**
  - One `donation_confirmation` row persisted (published, `status` default TRUE).
  - One `email` archive row persisted (`APIMailingService::sendEmail:217-230`).
  - PDF (`patrondeti.cz-potvrzeni-o-daru.pdf`) dispatched to donor as a base64 attachment.
- **Side Effects:**
  - **Email send** via `patron_base.smartmailing::handleMail(..., 'donation_confirmation', '', $attachments)` (form:372 / v32:173). Despite the "smartmailing" name, the actual transport is **Mautic** (`APIMailingService.php:56` emailApi, `sendToContact` line 251).
  - **`email` entity write** (audit archive of every send) — `APIMailingService::sendEmail:217`.
  - **Mautic contact upsert** — `contactApi->create(['email'=>...])` (`APIMailingService.php:246`).
  - No cache flush, no Slack, no role promotion, no campaign sync in this flow.
- **Integration Calls:**
  - **Mautic** (marketing/mail API) — `Mautic\MauticApi` `sendToContact`/`contactApi->create` (`patron_base/src/APIMailingService.php:246,251`), base URI from `Settings::get('mailing')['base_uri']` (per integrations.md = `https://m.patrondeti.cz/api`), BasicAuth creds `<redacted>`.
  - **mpdf** (PDF render, local lib not network) — `new \Mpdf\Mpdf(['tempDir'=>'/tmp/mpdf'])`, `WriteHTML`, `Output` (form:429-431 / v32:221-223).
  - **Remote image** referenced inside PDF HTML: `manager_signature` `<img src="https://backend.patrondeti.cz/...svatava_podpis.png">` and template header `nadacesirius.cz` logo (`donation_confirmation.html`) — fetched by mpdf at render time.
- **Failure Modes:**
  - **No idempotence / no rate-limit.** The trigger hint of "rate-limit per IP" is **NOT implemented** — `ip_address`, `user_agent`, `number_of_requests(=hardcoded 1)` are only stored as audit fields on the entity (`DonationConfirmationEntity.php:329-350`); no `flood` service, no dedup, no unique constraint. Re-submitting the same email/year issues another PDF + email every time. `Confirmed`.
  - **Legal/gov correctness:** confirmation identity fields (`name`, `address`, `rodne_cislo`) are **caller-supplied and unverified**, but the monetary `donation_total` is authoritative (server-computed from `transaction`). `rc`/`ico` never validated here. `Confirmed`.
  - **Hardcoded fallback year "2019"** in the confirmation sentence when neither `confirmation_year` nor a transaction date is set (form:421 / v32:210) — stale legal text risk. `Confirmed`.
  - **mpdf failure not guarded** — exceptions from `WriteHTML`/`Output` (e.g. `/tmp/mpdf` unwritable, remote signature image unreachable) are uncaught; on the form path the entity is already saved (line 344) before `sendEmail`, so a PDF failure leaves a saved confirmation with no email sent → silent partial completion. `Confirmed`.
  - **Anonymous data disclosure:** anonymous caller supplies any email; if a matching user with paid donations exists, a confirmation with that user's totals is emailed to the entered address — enumeration/exfiltration risk (email is trusted as-is). `Confirmed`.
  - **REST auth = cookie only** (`config/rest.resource.donation_confirmation_resource_v3x.yml`), but `getUser()` treats an authenticated session as the target user, ignoring the posted email when logged in (v32:124). `Confirmed`.
  - **Email deliverability gate:** in non-production, `sendEmail` only actually transmits for allow-listed address fragments (`isEmailAllowed`: `leerimich`/`test20`/`patrondeti`) — otherwise archived but not sent (`APIMailingService.php:233,261`). `Confirmed`.
  - **`transaction_date` H:m:i bug** — date format string uses `m` (month) instead of `i` for minutes: `date('d.m.Y \v H:m:i', ...)` (form:399 / v32:192) → minutes rendered as month on the PDF when the year-less branch is used. `Confirmed`.
  - *(Adjacent RO tax_payer flow):* `TaxPayerInformationForm::submitForm` appends CNP/personal data to an unencrypted `private://tax-submissions/tax-form-submissions.csv` (`.../account/src/Form/TaxPayerInformationForm.php:465-504`) and creates a signed `contract` — Legal/Gov + Data-Loss concerns, tracked separately.

## C. Data Footprint
- **Entities Written:**
  - `donation_confirmation` (base_table `donation_confirmation`, `DonationConfirmationEntity`) — fields: user_id, name(≤50), email(≤100 stored / field max 200), address(≤200), rodne_cislo(≤20), donation_total(int), donation_in_words, ip_address, user_agent, number_of_requests(=1), confirmation_year, status(=published), created/changed; REST also sets agreement_truthfulness / agreement_personal_data / campaign (v32:150-153, v31:147-150). Created via `DonationConfirmationEntity::create(...)->save()` (form:330-344, v32:139-156, v31:136-153).
  - `email` (base_table `email`, `EmailEntity`) — archive row per send: name/template_name, to, from, body, arguments(json) — `APIMailingService::sendEmail:217-230`.
  - **Mautic contact** (external) — upserted by email.
- **Entities Read:**
  - `user` — loaded by mail / uuid / current user (`entity_type.manager` storage 'user').
  - `transaction` — **raw SQL only** (`\Drupal::database()->query(...)`, no entity load): reads `price`, `created`, filtered by `user_id`, `test`, `is_donation`, `ext_status`, optional `campaign` + year window (`getUsersDonationsTotal`).
  - `campaign` — only as an optional filter id (`campaign_id`) and entity-reference field; not loaded in this flow.
- **Constraints involved:**
  - No unique/idempotency constraint on `donation_confirmation` (nothing prevents duplicate confirmations). `donation_confirmation.campaign` is a **soft entity_reference** to `campaign` (no DB FK). `donation_confirmation.user_id` references `user`.
  - Raw `transaction` query relies on string columns `test`, `is_donation` (`'0'`/`'1'`) and `ext_status LIKE 'PAID'` — a `LIKE` without wildcard (effectively `=`), coupling correctness to exact `ext_status` value casing.
  - Field length truncation via `mb_substr`/`substr` on save (name 50, email 100, address 200, rodne_cislo 20, user_agent 250).
- **Multi-tenant scope assumptions:**
  - The PDF template (`donation_confirmation.html`) and confirmation sentence are **CZ-specific** (Czech legal text, "Kč", "Nadace Sirius", `patrondeti.cz` signature) — effectively a **CZ-only** document flow. `Confirmed`.
  - `APIMailingService::doHandleMail` gates the `donation_confirmation` Mautic template by `Settings::get('country')`: template id 12 exists **only in the CZ (`else`) branch** — RO/MD template maps do **not** define `donation_confirmation`, so a call under RO/MD logs "Wrong template name" and sends nothing (`APIMailingService.php:106-176,185`). Confirms CZ-only viability. `Confirmed`.
  - The RO `tax_payer` declaration flow uses `Settings::get('country','ro')` and `transparent_account` — a distinct RO-tenant mechanism.

## D. Evidence Block
- **Controller paths:**
  - `web/modules/custom/donation_confirmation/src/Controller/DonationConfirmationController.php` (`::page`)
  - `web/modules/custom/donation_confirmation/src/Form/DonationConfirmationRequestForm.php` (`buildForm/validateForm/submitForm/sendEmail/getDonationConfirmationBase64/getUsersDonationsTotal`)
  - `web/modules/custom/donation_confirmation/src/Plugin/rest/resource/v32/DonationConfirmationResource.php` (`post/createDonationConfirmation/sendEmail/getDonationConfirmationBase64/getUsersDonationsTotal`)
  - `web/modules/custom/donation_confirmation/src/Plugin/rest/resource/v31/DonationConfirmationResource.php` (legacy, resolves user by uuid|mail)
  - Adjacent: `web/modules/custom/account/src/Form/TaxPayerInformationForm.php`, `web/modules/custom/account/src/Entity/TaxPayerEntity.php`
- **Service methods:**
  - `patron_base.smartmailing` = `Drupal\patron_base\APIMailingService` (`patron_base/patron_base.services.yml:8`, arg `@queue`) — `handleMail:67`, `doHandleMail:89`, `sendEmail:199`, `isEmailAllowed:261`.
  - `patron_base.default` = `PatronBaseService` — `isEmailValid:114`, `convertNumberToWords:317`.
- **Repository usage:**
  - Entity storage via `entity_type.manager` for `user`; `DonationConfirmationEntity::create()->save()` and `EmailEntity::create()->save()`.
  - **Raw SQL** via `$this->database->query()` / `\Drupal::database()->query()` against `transaction` (parameterized) — no entity abstraction for the monetary read.
- **Event listeners:** none dispatched or subscribed by this flow (no status-update event; unlike FL005). `Confirmed absence`.
- **Async messages:**
  - `APIMailingService::USE_QUEUE = FALSE` (`APIMailingService.php:16`) → mail is sent **synchronously** in-request; the `mailing_queue` QueueWorker path is dead code here. REST `sendEmail` docblock notes `// ToDo: move to Rabbit MQ` (v32:167) — **not** implemented.
- **Config evidence:**
  - `web/modules/custom/donation_confirmation/donation_confirmation.routing.yml` (`donation_confirmation.page`, `_access: 'TRUE'`).
  - `config/rest.resource.donation_confirmation_resource_v31.yml` + `_v32.yml` (POST, json, `authentication: cookie`).
  - `donation_confirmation.html` (PDF template, CZ legal text + `{confirmation_line}`/`{donation_total}`/… placeholders).
  - `account/account.routing.yml:41` `account.tax_payer_form` → `/tax-payer-information` (`no_cache: TRUE`) — adjacent RO flow.
  - Country/template map + Mautic auth in `Settings::get('mailing')` / `Settings::get('country')` (`APIMailingService.php:43,99`).
