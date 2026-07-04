---
doc_id: COPY-module-auth
title: Auth Module Copy — Login Magic Link & Account Activation
canonical_layer: COPY
spec_type: copy
scope: module-auth
modules: []
language: cs
status: draft
references:
  - WIRE0012
  - WIRE0013
  - WIRE0024
  - WIRE0025
  - COMP0001
  - COMP0006
  - COMP0009
  - UC0014
  - BR-AccessControlAndRoles
  - BR-PartyIdentityAndDeduplication
---

# COPY-module-auth – Auth Module Copy (Login Magic Link & Account Activation)

## Purpose

Text surface for the four passwordless-authentication screens: login via magic-link and its
sent-confirmation state (S009 / `WIRE0012`), account activation with password-set and terms
acceptance (S010 / `WIRE0013`), the activation-link request entry point (S021 / `WIRE0024`), and the
activation-link-sent landing route (S022 / `WIRE0025`). Consumed by `COMP0009` (Single Email-Entry
Form, purpose=login and purpose=activation-request), `COMP0001` (Primary Button), and `COMP0006`
(Consent Checkbox) as hosted on these four screens. Tone is direct, second-person informal ("vy"
register), sentence case, short imperative CTAs. Text is transcribed **verbatim** from observed UI
(`_ar/prtsc/**`) and from `_ar/evidence/ui/ui-observed-areas.md` §7–§10; nothing here is paraphrased
or invented.

---

## Labels

| Key | Text | Usage (WIRE/COMP ref) |
|---|---|---|
| `module-auth.login.heading` | `Přihlaste se do účtu` | `WIRE0012` (default state) / `COMP0009` |
| `module-auth.login.body` | `pro žadatele, dárce a Patrony, kde najdete přehled o svých žádostech a darech. Zadejte svůj e-mail, a my vám místo hesla pošleme odkaz, kterým se přihlásíte.` | `WIRE0012` (default state) / `COMP0009` |
| `module-auth.login-confirmation.heading` | `Zkontrolujte svou e-mailovou schránku` | `WIRE0012` (confirmation state) / `COMP0009` |
| `module-auth.login-confirmation.body` | `Na váš e-mail jsme poslali odkaz, pomocí kterého se přihlásíte i bez hesla.` | `WIRE0012` (confirmation state) / `COMP0009` |
| `module-auth.activate-account.heading` | `Aktivovat účet` | `WIRE0013` (default state) |
| `module-auth.activate-account.body` | `Po aktivování svého uživatelského účtu budete přihlášení a budete moct využívat všech jeho výhod.` | `WIRE0013` (default state) |
| `module-auth.activation-entry.heading` | `Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet` | `WIRE0024` (default state) / `COMP0009`; **Confirmed** directly by screenshot in this pass — see Evidence note below (upgrades `WIRE0024`'s own *Probable* rating, not overridden here) |
| `module-auth.activation-entry.body` | `Zde vyplňte svůj email, který jste použili při přispění na příběh nebo v žádosti o dar. Odešleme vám na něj aktivační odkaz.` | `WIRE0024` (default state) / `COMP0009`; **Confirmed** — see Evidence note |

---

## Helper Texts

| Key | Text | Usage |
|---|---|---|
| `module-auth.login-confirmation.resend-hint` | `Pokud stále nedorazil, zkontrolujte složku spam, nebo nám napište na info@patrondeti.cz.` | `WIRE0012` (confirmation state); contains a `mailto:info@patrondeti.cz` link |
| `module-auth.activate-account.missing-info-helper` | `Bez těchto informací se neobejdeme.` | `WIRE0013`; red helper text below the e-mail/password field pair. **Certainty of role:** Uncertain — required-field convention vs. already-triggered validation error not resolved (see `WIRE0013` OQ-WIRE0013-1); listed here as observed text only, not asserted as either. |

---

## Empty States

`N/A — no distinct empty-state applies.` All four screens are single fixed forms or a confirmation
panel, not listings; there is no "no items" condition to render on any of them (`WIRE0012`, `WIRE0013`,
`WIRE0024` States→empty; `WIRE0025` States→empty).

---

## Loading Texts

`Evidence Pending — not captured` on any of the four screens. No spinner/disabled-button/in-flight
copy is observed in any screenshot for S009, S010, S021, or S022 (`WIRE0012`/`WIRE0013`/`WIRE0024`
States→loading). **Open Question** — not invented here.

---

## Error / Validation Messages

| Key | Text | Trigger |
|---|---|---|
| `module-auth.login.email.validation-error` | *(none observed)* | **Open Question** — no BR/EN found governing e-mail required/format feedback on S009; `WIRE0012` Validation Surfaces flags this unresolved (`BR-AccessControlAndRoles` covers flood-control/token-expiry, not form-level input validation). Do not invent copy. |
| `module-auth.activate-account.password.validation-error` | *(none observed — see `module-auth.activate-account.missing-info-helper` above, role Uncertain)* | **Open Question** — no BR specifies password format/strength for S010; `BR-PartyIdentityAndDeduplication` only requires that a newly provisioned User is created without a usable password until activation, not a format rule (`WIRE0013` validationsWithoutBR). |
| `module-auth.activate-account.terms-checkbox.validation-error` | *(none observed)* | **Open Question** — no BR requires either activation checkbox be checked before submit; not evidenced (`WIRE0013` validationsWithoutBR). |
| `module-auth.activation-entry.email.validation-error` | *(none observed)* | **Open Question** — no BR governs e-mail required/format feedback on S021, nor whether a non-matching e-mail is handled differently (enumeration-safety); `WIRE0024` Validation Surfaces / validationsWithoutBR. |
| `module-auth.activation-link-sent.error` | *(none observed)* | **Open Question** — no error surface evidenced for S022 at all; `WIRE0025` States→error notes UC0014 AF4/AF5 describe adjacent failure paths at the UC level only, with no confirmed on-screen rendering here. |

---

## CTAs

| Key | Text | Action |
|---|---|---|
| `module-auth.login.submit-cta` | `Přihlásit se` | `UC0014` (UC0014.1 magic-link branch — request-a-link submission); `COMP0001` within `COMP0009` |
| `module-auth.login.password-fallback-cta` | `Přihlaste se pomocí svého hesla.` | Navigates to the password-based login variant of `UC0014`; target screen not separately captured — **Open Question** (no screen-id evidenced, per `WIRE0012` interaction 3) |
| `module-auth.login.activate-account-cta` | `Aktivujte si ho.` | Navigates to S021 (`UC0014` activation-link-issuance precursor); `WIRE0012` interaction 4 |
| `module-auth.login-confirmation.password-fallback-cta` | `Přihlaste se pomocí svého hesla.` | Same target/action as `module-auth.login.password-fallback-cta`, shown in the confirmation state; `UC0014` |
| `module-auth.login-confirmation.contact-support-cta` | `napište na info@patrondeti.cz` | `mailto:` link, not a `UC0014` action — opens the Customer's mail client; inline within the resend-hint helper text; no owning UC (support contact, not a domain use case) |
| `module-auth.activate-account.rules-link-cta` | `pravidly poskytování pomoci` | Opens the rules document (`S-EXT4` per `_ar/spec-draft/IA-screen-map.md`); does not submit the form; no `UC0014` step attributed (document-view action) |
| `module-auth.activate-account.terms-link-cta` | `podmínkami používání uživatelského účtu` | Opens account-usage terms content; target screen not captured — **Open Question** (`WIRE0013` interaction 4) |
| `module-auth.activate-account.submit-cta` | `Aktivovat účet` | `UC0014` (activation transition, "Registered (blocked or password-less) → Active"); `COMP0001` |
| `module-auth.activation-entry.submit-cta` | `Poslat aktivační odkaz` | `UC0014` (activation-link-issuance precursor adjacent to UC0014.1/UC0014.3 — not itself a numbered UC0014 flow step, per `WIRE0024` Purpose); `COMP0001` within `COMP0009` |
| `module-auth.activation-entry.back-to-login-cta` | `Zpět na přihlášení` | Navigates to S009 (`/prihlaseni`); `UC0014`-adjacent navigation, not itself a UC0014 step; `WIRE0024` interaction 3 |

---

## Consent Checkbox Labels (COMP0006 instances on S010)

| Key | Text | Trigger/Action |
|---|---|---|
| `module-auth.activate-account.consent-rules.label` | `Prohlašuji, že jsem se seznámil/a s pravidly poskytování pomoci.` | `COMP0006` instance 1 on `WIRE0013`; whether checking is mandatory-before-submit is unbacked by any BR — **Open Question** (`WIRE0013` validationsWithoutBR; `COMP0006` Open Questions) |
| `module-auth.activate-account.consent-terms.label` | `Souhlasím s podmínkami používání uživatelského účtu.` | `COMP0006` instance 2 on `WIRE0013`; same mandatory-checkbox open question as above |

Note: the embedded hyperlinks inside these two labels ("pravidly poskytování pomoci" /
"podmínkami používání uživatelského účtu") are the same CTA text rows listed above
(`module-auth.activate-account.rules-link-cta`, `module-auth.activate-account.terms-link-cta`); not
duplicated as separate label text per component composition (`COMP0006` label prop embeds the link).

---

## Microcopy Conventions

- Tone: direct, friendly, informal-formal hybrid consistent with the rest of the public site
  (imperative CTAs, second-person plural "vy" verb forms — "Zadejte", "Zkontrolujte", "Vyplňte").
- Person: 2nd person plural (formal "vy"), e.g. "Zadejte svůj e-mail…", "Zkontrolujte svou
  e-mailovou schránku".
- Capitalization: sentence case throughout (headings, CTAs, helper text); no title case observed.
- Punctuation: full stops on body/helper sentences and on complete-sentence secondary links
  ("Aktivujte si ho.", "Přihlaste se pomocí svého hesla."); CTAs on buttons carry no trailing
  punctuation ("Přihlásit se", "Aktivovat účet", "Poslat aktivační odkaz").
- Placeholder-as-label pattern: the "E-mail" field placeholder on S009/S021 doubles as the field's
  only visible label (no separate `<label>` text observed) — flagged as an accessibility open
  question in `WIRE0012`/`WIRE0024`/`COMP0009`, not a COPY defect.

---

## Open Questions

- **OQ-COPY-auth-1:** No validation/error copy is observed on any of the four screens (S009, S010,
  S021, S022) for e-mail format, password format, mandatory-checkbox, or expired/invalid-token
  cases. No BR or EN owns these triggers per `WIRE0012`/`WIRE0013`/`WIRE0024`/`WIRE0025`
  `validationsWithoutBR` sections — recorded, not invented.
- **OQ-COPY-auth-2:** S022's actual "link sent" confirmation copy is unevidenced. Both captured
  screenshots for `/poslat-aktivacni-email`
  (`screencapture-patrondeti-cz-poslat-aktivacni-email-2026-07-04-13_23_37.png` and
  `…-13_31_22.png`) render the identical S021 activation-request form
  ("Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet" / "Poslat aktivační odkaz" /
  "Zpět na přihlášení"), not a distinct confirmation message — confirmed independently in this COPY
  pass by direct pixel inspection of both files, matching `WIRE0025`'s own finding (carried from
  `UI-gap-open-questions.md` OQ-03). No `module-auth.activation-link-sent.*` confirmation-body keys
  are asserted; only the shared chrome and the (identical, already-keyed) S021 form text apply to
  whatever S022 actually renders once re-captured.
- **OQ-COPY-auth-3:** `WIRE0024` rates its own form-body content (heading, body, CTAs) as *Probable*
  because its cited screenshot was reported as chrome-only. Direct inspection of
  `screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` in this COPY pass shows
  the full form body (heading, intro copy, pre-filled "email" field, both CTAs) clearly in frame —
  this is recorded here as a discrepancy against `WIRE0024`'s certainty rating, not silently
  resolved by upgrading the WIRE document (out of this document's write scope). The `module-auth.
  activation-entry.*` label rows above are marked Confirmed against this direct screenshot
  observation; the WIRE-level certainty conflict remains open for the WIRE owner to reconcile.
- **OQ-COPY-auth-4:** `MSG0003` (account-activation e-mail) frames activation as a magic-link flow
  with no password ever shown/requested, while S010 (`WIRE0013`) shows an explicit password-creation
  field. This is a `WIRE0013`-recorded conflict (OQ-WIRE0013-2); COPY does not resolve it and does
  not invent copy to reconcile the two sources — the password field's placeholder text ("Vytvořte si
  vlastní heslo") is transcribed as observed regardless of the conflict.

---

## Evidence

| Key area | Certainty | Evidence |
|---|---|---|
| Login default-state heading/body/CTA/secondary links (S009) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`; `ui-observed-areas.md` §7 |
| Login confirmation-state heading/body/helper/CTAs (S009) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png`; `ui-observed-areas.md` §7 |
| Account-activation heading/body/fields/checkboxes/CTA (S010) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-aktivovat-ucet-2026-07-04-13_33_10.png`; `ui-observed-areas.md` §8 |
| "Bez těchto informací se neobejdeme." role (required-field vs. error) | Confirmed text / Uncertain semantics | same screenshot; `ui-observed-areas.md` §8; `WIRE0013` OQ-WIRE0013-1 |
| Activation-entry heading/body/field/CTAs (S021) | Confirmed (direct screenshot inspection, this pass) | `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`; `ui-observed-areas.md` §9 — see OQ-COPY-auth-3 re: discrepancy against `WIRE0024`'s own *Probable* rating |
| Activation-link-sent screen (S022) actual body content | Uncertain / evidence-blocked | `_ar/prtsc/screencapture-patrondeti-cz-poslat-aktivacni-email-2026-07-04-13_23_37.png`, `…-13_31_22.png` (both show the S021 form, not a distinct confirmation); `ui-observed-areas.md` §10; `WIRE0025`; see OQ-COPY-auth-2 |
| Validation/error copy (all four screens) | Evidence Pending | no screenshot shows any triggered validation/error message; see Open Questions |
| CTA→UC0014 traceability | Confirmed | `_ar/spec-draft/UC/UC0014_AuthenticateManageAccess.md`; `WIRE0012`/`WIRE0013`/`WIRE0024` Interactions sections |
