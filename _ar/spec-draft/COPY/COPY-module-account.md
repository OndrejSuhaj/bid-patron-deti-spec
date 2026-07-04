---
doc_id: COPY-module-account
title: Account — Settings, Tax Confirmation, Dashboard & Role Zones
canonical_layer: COPY
spec_type: copy
scope: module-account
modules: []
language: cs
status: draft
references:
  - WIRE0014
  - WIRE0015
  - WIRE0020
  - WIRE0021
  - WIRE0022
  - WIRE0023
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0007
  - UC0024
  - UC0010
  - EN0006
  - EN0008
  - EN0014
  - EN0034
---

# COPY-module-account – Account — Settings, Tax Confirmation, Dashboard & Role Zones

## Purpose

This document transcribes the user-facing text observed on the authenticated "Můj účet" account
surfaces: account settings/profile (`WIRE0014`, S011, `/muj-ucet/nastaveni`), the CZ donation
tax-confirmation request form incl. Fyzická/Právnická osoba tabs (`WIRE0015`, S012,
`/muj-ucet/potvrzeni-o-darech`), and the composed dashboard + role-gated donor/applicant/patron
zones (`WIRE0020`–`WIRE0023`, S017–S020). Text is transcribed **verbatim** from
`_ar/prtsc/po_prihlaseni_do_uctu_nastaveni.png`, `_ar/prtsc/po_prihlaseni_do_uctu.png`,
`_ar/prtsc/po_prihlaseni_do_uctu_potvrzeni_o_darech.png`, and (for the S017 dashboard mockup only)
`_ar/prtsc/screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`. Consuming screens: S011,
S012, S017 (Hypothesis-only mockup), S018/S019/S020 (Evidence-Pending — no screen text observed).
Tone/voice: informal 2nd-person singular ("vy" form used politely — e.g. "Vaše jméno", "Potřebujete"),
consistent with the rest of the public site.

Per COPY scope rules, shared cross-screen chrome (global header/footer nav, cookie consent) is
owned by `COPY-shared-global` (if/when authored) and is **not** restated here beyond the promo-band
string unique to S011's footer variant, which is recorded because it is the only place this exact
string was observed.

---

## Labels

| Key | Text | Usage (WIRE/COMP ref) |
|---|---|---|
| `module-account.settings.heading` | `Nastavení účtu` | `WIRE0014` (page title) |
| `module-account.settings.name-group-label` | `Vaše jméno a příjmení` | `WIRE0014` (name field group) |
| `module-account.settings.email-group-label` | `Váš e-mail` | `WIRE0014` (e-mail field group) |
| `module-account.settings.photo-group-label` | `Změnit profilovou fotku` | `WIRE0014` / `COMP0007` (photo upload) |
| `module-account.tax-confirmation.tab-individual` | `Fyzická osoba` | `WIRE0015` (tab control, active/default) |
| `module-account.tax-confirmation.tab-organization` | `Právnická osoba` | `WIRE0015` (tab control, inactive) |
| `module-account.tax-confirmation.basic-data-heading` | `Základní údaje o vás` | `WIRE0015` (Jméno/Příjmení field group) |
| `module-account.tax-confirmation.address-label` | `Adresa trvalého bydliště` | `WIRE0015` (address field) |
| `module-account.tax-confirmation.birth-number-label` | `Rodné číslo bez lomítka` | `WIRE0015` (birth-number field) |
| `module-account.tax-confirmation.ic-label` | `Fyzická osoba s IČ` | `WIRE0015` (registration-number field) |
| `module-account.dashboard-mockup.tab-for-you` | `Pro vás` | `WIRE0020` (tab bar, Hypothesis — mockup graphic only, not a captured screen) |
| `module-account.dashboard-mockup.tab-all` | `Všechny ({count})` | `WIRE0020` (tab bar, observed value "Všechny (67)"; Hypothesis — mockup graphic only) |
| `module-account.dashboard-mockup.contribution-banner` | `Přispěli jste {amount}` | `WIRE0020` (story-card overlay banner, observed value "Přispěli jste 1 250 Kč"; Hypothesis) |
| `module-account.dashboard-mockup.countdown-badge` | `ZBÝVÁ {n} DNÍ` | `WIRE0020` (story-card countdown pill, observed value "ZBÝVÁ 10 DNÍ"; Hypothesis) |

Note: `module-account.dashboard-mockup.*` keys are transcribed from a marketing-e-mail-embedded
illustration, not a captured application screen — see `WIRE0020` Purpose. They are recorded here
for completeness of the observed strings but are explicitly **not** confirmed current-state UI copy.

No label text is observed for S018 (`WIRE0021`, donor zone / "Moje zóna"), S019 (`WIRE0022`,
applicant zone), or S020 (`WIRE0023`, patron zone) beyond the page-title Hypothesis noted below
under Headings — no screenshot exists for any of the three, per each WIRE's Evidence table.

---

## Headings (page titles, not captured as screenshots)

| Key | Text | Usage | Certainty |
|---|---|---|---|
| `module-account.donor-zone.heading` | `Moje zóna` | `WIRE0021` (S018 page title) | Probable — Confirmed as the Drupal View's config page-title string (`views.view.supporter_zone.yml`, per `EN0034`); its visual rendering as an on-screen heading is Assumed, not screenshotted |

No page-title string is evidenced for S019 (`zona/zadatel`) or S020 (`zona/patron`) — neither
`WIRE0022` nor `WIRE0023` cites a confirmed config-level title string (unlike S018's `EN0034`
evidence); recorded as an Open Question below rather than invented.

---

## Placeholders

| Key | Text | Usage |
|---|---|---|
| `module-account.settings.first-name-placeholder` | `Jméno` | `WIRE0014` (name field) |
| `module-account.settings.last-name-placeholder` | `Příjmení` | `WIRE0014` (name field) |
| `module-account.settings.email-placeholder` | `E-mail` | `WIRE0014` (e-mail field) |
| `module-account.tax-confirmation.first-name-placeholder` | `Jméno` | `WIRE0015` (Fyzická osoba tab) |
| `module-account.tax-confirmation.last-name-placeholder` | `Příjmení` | `WIRE0015` (Fyzická osoba tab) |
| `module-account.tax-confirmation.address-placeholder` | `Ulice, číslo, Město, PSČ` | `WIRE0015` (address field) |
| `module-account.tax-confirmation.birth-number-placeholder` | `YYMMDDXXXX` | `WIRE0015` (birth-number field) |
| `module-account.tax-confirmation.ic-placeholder` | `Pozor na překlepy :)` | `WIRE0015` (IČ field) |

No placeholder text is observed for the "Právnická osoba" (organization) tab's field set — that
tab's contents are not captured in either screenshot (`WIRE0015` Open Questions #2).

---

## Helper Texts

| Key | Text | Usage |
|---|---|---|
| `module-account.settings.sub-heading` | `Potřebujete něco změnit? Udělejte to tady.` | `WIRE0014` (page sub-heading, below "Nastavení účtu") |
| `module-account.settings.photo-upload-helper` | `Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači.` | `WIRE0014` / `COMP0007` — the "vyberte v počítači" portion is a link-styled inline call-to-action within this sentence; reused generic upload-widget copy also observed on the application-form attachment step |
| `module-account.tax-confirmation.hero-heading` | `Děkujeme, že pomáháte dětem, které neměly v životě štěstí.` | `WIRE0015` (hero heading above the form) |
| `module-account.tax-confirmation.hero-subcopy` | `Toto je stránka, na které vám vystavíme potvrzení o darech Patronu dětí.` | `WIRE0015` (hero sub-copy) |
| `module-account.tax-confirmation.year-checkbox-label` | `Chci vykázat všechny dary za rok 2025` | `WIRE0015` (year-scope radio-styled checkbox control; the year value "2025" is rendered inline, not a static string — Confirmed as a template with a dynamic year token, `{year}`, based on the single observed value) |
| `module-account.tax-confirmation.legal-disclaimer` | `Upozorňujeme, že pro účely snížení daňového základu můžete pro každý jednotlivý dar uplatnit toto potvrzení nebo potvrzení za kalendářní rok pouze jednou. Nelze uplatnit jeden dar obsažený ve dvou různých potvrzeních nebo pro dva různé subjekty.` | `WIRE0015` (italic info-icon disclaimer callout below the submit button) |

---

## Empty States

| Key | Text | Shown when | Certainty |
|---|---|---|---|
| `module-account.settings.empty-state` | `Not observed — Evidence Pending` | The "Jméno"/"Příjmení"/"E-mail" fields render with placeholder-only text and no visible value in the single captured state; `WIRE0014` records this as an open question (true first-time-empty profile vs. rendering artifact vs. always-placeholder sample), not a confirmed empty-state copy string | Uncertain |
| `module-account.donor-zone.empty-state` | `Not observed — Evidence Pending` | A `supporter`-role User with zero qualifying Campaigns in the `supporter_zone` projection — an edge case `WIRE0021` flags as unresolved; no copy captured | Uncertain |
| `module-account.applicant-zone.empty-state` | `Not observed — Evidence Pending` | Whether an applicant with no Applications sees any empty-state message at all on `zona/zadatel` is unresolved; `WIRE0022` records the whole screen as not captured | Uncertain |
| `module-account.patron-zone.empty-state` | `Not observed — Evidence Pending` | Whether a patron with no linked Application sees any empty-state message on `zona/patron` is unresolved; `WIRE0023` records the whole screen as not captured | Uncertain |

No empty-state copy is invented for any of the above; each is recorded as an absence per the
evidence-first discipline, not a guessed string.

---

## Loading Texts

| Key | Text | Shown during | Certainty |
|---|---|---|---|
| `module-account.settings.loading` | `Not observed — Evidence Pending` | Initial form fetch or post-submit save on `/muj-ucet/nastaveni`; `WIRE0014` records no loading/skeleton state was captured | Uncertain |
| `module-account.tax-confirmation.loading` | `Not observed — Evidence Pending` | Form submission on `/muj-ucet/potvrzeni-o-darech`; `WIRE0015` records no async indicator was captured | Uncertain |

No loading-state copy is evidenced for S017–S020 either; `WIRE0020`–`WIRE0023` record these as
`N/A — Evidence Pending`.

---

## Error / Validation Messages

Every message references the triggering rule or invariant. **No `BRxxxx` document in
`_ar/spec-draft/BR/` covers field-level validation for any screen in this scope** — this is recorded
verbatim from each WIRE's Validation Surfaces section as an evidence gap, not filled with invented
copy.

| Key | Text | Trigger |
|---|---|---|
| `module-account.settings.first-name.validation-error` | `Not observed — no validation copy captured` | none found — `WIRE0014` records no BR/EN document specifies a name-format rule for this screen; Open Question |
| `module-account.settings.last-name.validation-error` | `Not observed — no validation copy captured` | none found — same gap as first-name |
| `module-account.settings.email.validation-error` | `Not observed — no validation copy captured` | none found — per `UC0024` AF2, e-mail is not an accepted field on the profile-update contract; whether the UI surfaces any client-side validation before a no-op submit is unevidenced |
| `module-account.settings.photo-upload.validation-error` | `Not observed — no validation copy captured` | none found — the "0 / 1" counter implies a single-file limit, but no `BRxxxx` documents file-count/type/size constraints |
| `module-account.tax-confirmation.first-name.validation-error` | `Not observed — no validation copy captured` | none found — `UC0010` step "Validate the type-specific identifying fields" confirms validation occurs, but no BR specifies the rule content or its on-screen surface |
| `module-account.tax-confirmation.last-name.validation-error` | `Not observed — no validation copy captured` | none found — same gap as first-name |
| `module-account.tax-confirmation.birth-number.validation-error` | `Not observed — no validation copy captured` | none found — placeholder format "YYMMDDXXXX" implies an expectation but no BR governs the check-digit/format rule |
| `module-account.tax-confirmation.address.validation-error` | `Not observed — no validation copy captured` | none found |
| `module-account.tax-confirmation.ic.validation-error` | `Not observed — no validation copy captured` | none found |
| `module-account.tax-confirmation.organization-tab.validation-error` | `Not observed — no validation copy captured` | none found — `UC0010` step "organization: name and registration number"; the "Právnická osoba" tab's field set itself is not captured |
| `module-account.tax-confirmation.zero-total.error` | `Not observed — no on-screen surface captured` | `BR-DonationConfirmationAndTax` (server-side abort rule: confirmation issuance is aborted when the computed year total is zero, per `UC0010` AF1) — the BR/UC govern the abort narratively; whether/how this is surfaced to the user on S012 is Uncertain, no copy observed |

`validationsWithoutTrigger`: none of the rows above have a resolvable `BRxxxx`/`ENxxxx` beyond the
one exception (`zero-total.error` → `BR-DonationConfirmationAndTax`, though its on-screen surfacing
is itself unconfirmed). All name/address/birth-number/IČ/photo field-level format-validation rules
are open questions without an owning BR — flagged for BR-layer follow-up, not invented here.

---

## CTAs

Every CTA references the use case it realizes.

| Key | Text | Action |
|---|---|---|
| `module-account.settings.save-cta` | `Uložit změny` | `UC0024` (UC0024.2 — edit own profile: name, photo) |
| `module-account.settings.photo-picker-link` | `vyberte v počítači` | `UC0024` (UC0024.2 — photo-upload sub-action; link-styled inline CTA within the upload-helper sentence, opens a file picker) |
| `module-account.tax-confirmation.submit-cta` | `Ziskat potvrzení` | `UC0010` (UC0010.1–UC0010.2 — validate, resolve User, compute total, persist confirmation, render PDF, dispatch email); verbatim typo for "Získat" — observed exactly as rendered, not corrected |

No CTA text is observed for S017 (dashboard mockup — the mockup graphic shows no visible CTA button
within the cropped story-card view; the e-mail's own "Dokončit účet" CTA belongs to the surrounding
marketing e-mail chrome/MSG layer, not this dashboard screen), nor for S018/S019/S020 (no capture
exists for any of the three; `WIRE0021`/`WIRE0022`/`WIRE0023` record their primary/secondary actions
as Uncertain or Not evidenced).

---

## Microcopy Conventions

- Tone: informal-polite, direct address ("Vaše", "Potřebujete", "vám vystavíme").
- Person: 2nd person singular/polite form ("vy" register, e.g. "Váš e-mail", "Chci vykázat").
- Capitalization: sentence case throughout observed labels and headings (e.g. "Nastavení účtu",
  "Adresa trvalého bydliště"); button labels also sentence case ("Uložit změny", "Ziskat potvrzení").
- Punctuation: full sentences in helper/disclaimer copy end with a period; field labels and CTA
  button text carry no terminal punctuation.
- Observed typo preserved verbatim: "Ziskat potvrzení" (missing diacritic on "Získat") — per the
  evidence-first rule, this is transcribed exactly as rendered, not silently corrected.

---

## Open Questions

1. No screenshot exists for S018 (`zona/darce`, beyond the `EN0034` config page-title), S019
   (`zona/zadatel`), or S020 (`zona/patron`) — no field labels, headings (other than the S018 Probable
   "Moje zóna"), helper text, empty/loading/error copy, or CTA text can be transcribed for these three
   screens. Recommend a targeted re-capture before this scope's copy inventory can be completed for
   S018–S020.
2. Whether `module-account.tax-confirmation.year-checkbox-label`'s year value is a live dynamic token
   (current/previous calendar year) or a static string frozen at "2025" in the observed build is
   Uncertain — recorded as a `{year}`-token hypothesis, not confirmed against source.
3. The "Právnická osoba" (organization) tab's field set, including its labels and placeholders, is
   not captured in either S012 screenshot — no copy can be transcribed for it (see `WIRE0015` Open
   Question #2).
4. Whether the S017 dashboard mockup's "Pro vás" / "Všechny (N)" tab strings and story-card copy
   (`module-account.dashboard-mockup.*`) reflect any real built screen at all is unresolved — carried
   from `WIRE0020`'s Hypothesis-only status; do not treat these as confirmed current-state copy.

---

## Evidence

| Key area | Certainty | Evidence |
|---|---|---|
| S011 labels, placeholders, helper text, CTA ("Nastavení účtu", "Vaše jméno a příjmení", "Váš e-mail", "Změnit profilovou fotku", upload helper, "Uložit změny") | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu_nastaveni.png`; `_ar/evidence/ui/ui-observed-areas.md` §11 |
| S012 hero copy, tabs, field labels/placeholders, year checkbox, submit CTA, legal disclaimer | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu.png`; `_ar/prtsc/po_prihlaseni_do_uctu_potvrzeni_o_darech.png`; `_ar/evidence/ui/ui-observed-areas.md` §12 |
| S012 "Právnická osoba" tab field set | Evidence Pending — not captured | `ui-observed-areas.md` §12 (tab control observed, contents not) |
| S017 dashboard-mockup copy (tabs, banner, badge) | Confirmed (as depicted in a marketing-e-mail graphic); Hypothesis (as real screen copy) | `_ar/prtsc/screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png` |
| S018 page title "Moje zóna" | Probable | `_ar/spec-draft/EN/EN0034_DonorAccountView.md` (`views.view.supporter_zone.yml` config page-title) |
| S018 field/row copy, S019, S020 (all copy) | Evidence Pending — not captured | No entry in `ui-observed-areas.md`; no screenshot filename in `_ar/prtsc/` matches any of these three routes |
| Validation/error copy (all fields, all screens) | Uncertain — no BR owns field-level validation content | `_ar/spec-draft/WIRE/WIRE0014_AccountSettingsProfile.md` Validation Surfaces; `_ar/spec-draft/WIRE/WIRE0015_TaxConfirmationRequest.md` Validation Surfaces |
| CTA-to-UC mapping (`Uložit změny`→UC0024, `Ziskat potvrzení`→UC0010) | Confirmed | `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md`; `_ar/spec-draft/UC/UC0010_IssueDonationConfirmation.md` |
