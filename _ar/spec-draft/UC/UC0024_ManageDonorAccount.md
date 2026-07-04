# UC0024 — Manage Donor Account (Self-Service)

## Header

| Field | Value |
|---|---|
| UC ID | UC0024 |
| Name | Manage Donor Account (Self-Service) |
| Bounded Context | C7 / C9 |
| Primary Actor(s) | Customer, System |
| Trigger Type | UI/API |

## Actors & Responsibilities

- **Customer** — a logged-in party (donor/supporter, patron, or fundraiser — any authenticated User, EN0008) who views their own account profile and dashboard, and edits their own name, display preference, visibility, and profile photo in the "Můj účet" zone (`/muj-ucet/nastaveni`).
- **System** — authenticates the caller, resolves the User's own profile/dashboard read-model, applies the caller's own edits to their Contact (EN0006) and User (EN0008) records, and generates derived image styles for an uploaded profile photo.

## Intent

Let a logged-in party view a personal dashboard summarizing their own giving activity (total donated, number of campaigns supported, badges) and maintain their own profile — name, name-display format, public visibility, worker availability, and profile photo — without staff involvement.

## Preconditions

- The Customer holds an active, authenticated session against an existing User (EN0008) account (see UC0014).
- For the photo-upload path, the image file has already been uploaded to the platform's file store and a file UUID is available to reference in the profile-update call (upload-then-attach pattern, consistent with the application-form attachment uploader).

## Main Flow

### UC0024.1 — View own account profile (settings screen)
1. Customer: opens the account settings screen (`/muj-ucet/nastaveni`) while authenticated.
2. System: resolves the current session's User (EN0008) and its linked Contact (EN0006).
3. System: returns the caller's own profile fields (first name, last name, name-display format, title prefix/suffix, e-mail, profile photo URL, public-visibility flag, worker-availability flag, slug) together with derived summary figures: total paid-donation amount (SUM of the User's own `is_donation`-flagged, PAID Transactions, EN0009), the count of distinct campaigns the User has a PAID donation against, and any earned badges (seasonal donation badges computed from the User's own PAID Transaction dates).
4. Customer: sees the rendered profile form (pre-fillable) and summary figures.

### UC0024.1b — View own donation history by supported story (account zone)
1. Customer: opens the account/donor zone screen (`zona/darce`, "Moje zóna").
2. System: resolves the current session's User (EN0008) and, restricted to Users holding the `supporter` role, lists each Campaign (EN0004) the User has at least one PAID, donation-flagged Transaction (EN0009) against, together with the User's total contributed amount for that Campaign.
3. Customer: sees one row per supported story with the cumulative amount given to it.

This sub-flow is the **DonorAccountView (EN0034)** read-model — see that entity for the full field/filter/access contract; it is referenced here, not restated, per cross-layer discipline. It is a separate screen/mechanism from UC0024.1's profile settings — both live in the logged-in "Můj účet"/account zone but are backed by different mechanisms (a REST profile resource vs. a role-gated Drupal View), and evidence does not confirm they are composed into a single unified dashboard page (see Evidence Pending).

### UC0024.2 — Edit own profile (name, display, visibility, photo)
1. Customer: submits changed profile fields — any of: first name, last name, title prefix, title suffix, name-display format (full/short/hidden), public-visibility flag, worker-availability flag, and/or a newly uploaded profile-photo file reference.
2. System: loads the current session's own User (EN0008); creates a linked Contact (EN0006) on the fly (seeded with the User's e-mail) if the User unexpectedly has none.
3. System: applies each submitted field that is present in the request to the User (`public`, `worker_available`) or to the Contact (`first_name`→name, `last_name`, `title_prefix`, `title_suffix`, `name_format`); fields absent from the request are left unchanged.
4. System: when a profile-photo file reference is submitted, attaches the file to the User's `user_image` field and generates the three fixed derived image styles (`324x326`, `324x326@2`, `324x326@3`) for it.
5. System: persists the Contact as a new revision (revision log "Uzivatel si sam obnovil profil" / "user restored their own profile") when any Contact field changed, and saves the User when any User-level field or the photo changed.
6. System: returns the same profile read-model as UC0024.1, reflecting the just-applied changes.

## Alternative Flows

### AF1 — No fields submitted / no-op update
1. Customer: submits a profile-update request with none of the recognized fields present.
2. System: makes no change to the User or Contact and does not persist a new revision.

Outcome: the profile read-model is returned unchanged.

### AF2 — E-mail is not a self-service-editable field (current-state gap)
1. Customer: the `/muj-ucet/nastaveni` screen displays an "E-mail" field alongside name fields (UI evidence, po_prihlaseni_do_uctu_nastaveni.png).
2. System: the profile-update contract does not accept an `email` field for a logged-in self-edit in any observed API version (v3.0, v3.1, v3.2) — `email` appears in code only as the seed value for a Contact created on the fly, and as a commented-out TODO field ("email", alongside "phone", "password_old"/"password_new") in the v3.0/v3.1 resource, absent entirely from v3.2.

Outcome: **Current-state gap, not a designed capability.** The account e-mail address shown in the UI form cannot actually be changed via the self-service profile-update endpoint as coded; whether the front end silently drops the field, sends it and has it ignored, or routes e-mail changes through an undiscovered separate mechanism is **not evidenced**. Flag for rebuild decision — do not assume email-change works today.

### AF3 — Password change (legacy API versions only)
1. Customer: submits `password_old` and `password_new` on the v3.0 or v3.1 profile-update endpoint.
2. System: verifies `password_old` against the stored credential hash; on match, sets the new password and saves.
3. System: on mismatch, rejects the whole request with a `password_old_not_accepted` error and applies no other submitted field from the same request.

Outcome: password self-change exists only on the older (v3.0/v3.1) profile endpoint; the current v3.2 `ProfileResource` carries no password-change branch at all — **Partial / version-inconsistent**, not evidenced as reachable from the current `/muj-ucet/nastaveni` screen (which shows no password field).

### AF4 — Uploaded file cannot be resolved
1. Customer: submits a profile-photo file reference (UUID) that does not resolve to an existing file.
2. System: skips the photo attachment silently (no error surfaced) and continues applying any other submitted fields.

Outcome: the profile is updated for other fields, if any; the photo is silently left unchanged with no user-visible error — a current-state UX gap, not a designed validation response.

## Postconditions

- On a successful edit: the caller's own User (EN0008) and/or Contact (EN0006) record reflects the submitted, recognized fields; a profile photo, if uploaded, is attached to the User with its three derived image styles generated.
- The profile summary figures (total donated, campaign count, badges) and the donor-zone donation-history-by-story figures (EN0034) are always freshly computed at read time from the caller's own Transactions (EN0009) — they are never separately stored, so no dashboard-specific persistence occurs as part of this use case.
- E-mail address is never changed by this use case under any observed code path (see AF2).
- No other party's User or Contact record is ever affected — every operation in this use case is scoped to the caller's own session-resolved User.

## Traceability

Target SRVs:
- Identity-&-Access
- Payment-Processing (read-only, for the summary donation-total/campaign-count/badge computation and the EN0034 donation-history-by-story projection)

EN entities:
- EN0008 User — the profile fields edited (`public`, `worker_available`, `user_image`) and the identity the summary/history read-models are scoped to.
- EN0006 Contact — the linked party record holding the editable name/title/display-format fields.
- EN0009 Transaction — read-only source of both the profile summary's donated-amount/campaign-count/badge computation and, via EN0034, the donor-zone donation-history-by-story projection; no Transaction is created, modified, or referenced for write by this use case.
- EN0034 DonorAccountView — the donation-history-by-supported-story read-model (`zona/darce` / "Moje zóna") exercised by UC0024.1b; this UC references EN0034's field/filter/access contract rather than restating it (cross-layer discipline).

Integration boundaries:
- None synchronous. The `patron_base.default` image-generation service (internal, not an external system) derives the three fixed profile-photo styles synchronously within the save path; a Slack notification ("nahral profilovku." / "`update profilu`.") fires after save as an internal ops-notification side effect, not a domain integration boundary.

Flow Evidence:
- No dedicated FLW dossier exists for this endpoint at the time of writing; behavior in this UC is traced directly to source (see Evidence Level) rather than to a pre-mined FLW artifact — flag for a FLOW-EVIDENCE follow-up if a formal flow dossier is required before rebuild.

## Evidence Pending / Evidence Gaps

- **Whether the profile-settings screen (UC0024.1, `/muj-ucet/nastaveni`) and the donation-history donor zone (UC0024.1b, `zona/darce`, EN0034) are presented as one composed "Můj účet" dashboard page or as two separate account sub-pages is not confirmed.** They are backed by two structurally different mechanisms — a versioned REST resource (`ProfileResource`) vs. a role-gated classic Drupal View — with no code linking them into a single response/page. The richer dashboard implied by UI evidence (per-story countdown/collection state, downloadable confirmations, feedback, a "Pro vás / Všechny (67)" tab split) is evidenced only by a mockup graphic embedded inside the "Dokončete svůj uživatelský účet" e-mail (screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png; see `_ar/spec-draft/UI-gap-promotions.md` G-02 and EN0034 Evidence Gaps 1/3), never by a real dashboard screen. **Do not assume the richer composed dashboard is implemented as shown in the mockup** — the confirmed backend reality is the two narrower, separately-evidenced surfaces this UC documents (profile settings; donation-history-by-story). Resolve by locating the actual donor-facing front-end app's page composition (not present in this Drupal-backend source) or by confirming the mockup is aspirational.
- **"Followed story" is not a modeled relationship in code.** No subscription/follow field or table was found (`campaign_recommendation` on User is the dormant ML-recommendation field per INV27/EN0007, unrelated to a donor explicitly following a story); EN0034's donation-history projection is keyed on the donor's own PAID Transactions against a Campaign, not a stored "follow".
- **Downloadable donation confirmations and feedback, suggested by the dashboard mockup, are not fields of EN0034 and are not a capability of this use case.** Donation confirmations are the separate, code-confirmed `donation_confirmation` module/self-service form (`/donation-confirmation` route; UC0010's projection, see `_ar/spec-draft/UI-gap-promotions.md` G-13); Feedback (EN0021) is authored admin-side per Application with no donor-facing "my feedback" listing route or view located in source (see EN0034 Evidence Gaps 3).
- **RO/MD equivalence of the donor-zone view is unresolved** — `views.view.supporter_zone.yml` is present only under `sync_config/config_czech/`; whether Romania/Moldova tenants expose an equivalent under a different config split is unconfirmed (carried from EN0034 Evidence Gap 2, not re-investigated here).
- **Whether `/muj-ucet/nastaveni`'s displayed "E-mail" field is cosmetic/read-only or a genuine but currently-broken edit path is unresolved** (AF2). No route or resource accepts an e-mail change from a logged-in self-service caller in the evidence gathered.

## Evidence Level

**Partial.** UC0024.1 (view profile) and UC0024.2 (edit name/title/display-format/visibility/photo) are **Confirmed** — directly traced to `web/modules/custom/account/src/Plugin/rest/resource/{v31,v32}/ProfileResource.php` (`GET`/`POST /api/3.{1,2}/user/profile`) and `PatronUser::getUserApiFields()` / `getTotalDonationsAmount()` / `getNumberOfCampaigns()` / `getBadges()` / `getUserImage()` in `web/modules/custom/account/src/PatronUser.php`, cross-checked against the observed `/muj-ucet/nastaveni` screen (po_prihlaseni_do_uctu_nastaveni.png) and its promotion rationale in `_ar/spec-draft/UI-gap-promotions.md` (G-04 → UC0024). UC0024.1b (donation history by story) is **Confirmed** — traced to `sync_config/config_czech/views.view.supporter_zone.yml` (`zona/darce`, "Moje zóna", `supporter`-role-gated, `current_user`-scoped, grouped/summed by Campaign over PAID donation Transactions) per EN0034. AF2 (e-mail not editable) and AF3 (password-change version inconsistency) are **Confirmed** as code-level facts (absence/presence traced across the v3.0/v3.1/v3.2 `ProfileResource` variants) but their front-end-visible consequence is **Uncertain** (not verified whether the actual `/muj-ucet/nastaveni` client silently drops the email field or surfaces an error). Whether UC0024.1 and UC0024.1b are composed into one unified dashboard page as the e-mail mockup implies is **Hypothesis**, explicitly not asserted as confirmed (see Evidence Pending). No FLW dossier exists for this endpoint; traceability is direct-to-source.
