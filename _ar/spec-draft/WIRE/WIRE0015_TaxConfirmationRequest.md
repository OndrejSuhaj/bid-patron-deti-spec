---
doc_id: WIRE0015
title: Tax Confirmation Request
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S012
realizes_uc: [UC0010]
status: draft
references:
  - UC0010
  - EN0014
  - EN0008
  - EN0009
  - BR-DonationConfirmationAndTax
---

# WIRE0015 – Tax Confirmation Request

## Purpose

S012 ("Potvrzení o darech") is the CZ donation tax-confirmation request form in the account zone:
a logged-in patron/donor requests an official tax-deductible donation certificate for a given year,
choosing between an individual ("Fyzická osoba") or organization ("Právnická osoba") identity, and
either a per-donation certificate or a consolidated per-calendar-year certificate. It realizes the
CZ web-form request path of `UC0010` (Issue Donation Confirmation (Tax)), specifically
`UC0010.1`–`UC0010.2` (Confirmed). **Actor:** logged-in Customer/donor (account holder) — the IA
places S012 in the "Můj účet" account zone reached post-authentication
(`_ar/spec-draft/IA-screen-map.md` row S012; `IA-patronus.md` §12/§4 "Potvrzení o darech" row).
**Entry context:** navigated from the account area at route `/muj-ucet/potvrzeni-o-darech`
(`IA-patronus.md` §4 table, §7.1 flow "S018/S011 account zone → 'Potvrzení o darech'
(`UC0024` → `UC0010`)").

**UC-mapping note (Uncertain):** `UC0010`'s Preconditions and Main Flow describe both a logged-in
path and an anonymous path resolved by submitted email; the observed S012 form does not display an
email field in either screenshot, only name, address, birth number ("Rodné číslo"), and an
IČ-holder field. Whether S012 always requires prior login (so the User is resolved from the
session, per `UC0010` step "System: Resolve the target User ... as the currently logged-in User")
or can also be reached anonymously is not resolved by the screenshots alone — flagged as an open
question below rather than assumed.

---

## Layout Zones

```
+--------------------------------------------------+
| Header — site nav + "Požádat o pomoc" CTA +       |
| "Můj účet" (authenticated)                        |
+--------------------------------------------------+
| Hero — icon, thank-you headline, sub-copy          |
+--------------------------------------------------+
| Form panel (grey background)                       |
|  - Tabs: "Fyzická osoba" | "Právnická osoba"       |
|  - "Základní údaje o vás" (Jméno / Příjmení)       |
|  - "Adresa trvalého bydliště"                      |
|  - "Rodné číslo bez lomítka"                       |
|  - "Fyzická osoba s IČ"                            |
|  - Checkbox: "Chci vykázat všechny dary za rok NNNN"|
|  - CTA: "Ziskat potvrzení"                          |
|  - Legal disclaimer (info icon + italic text)      |
+--------------------------------------------------+
| Cookie consent banner                              |
+--------------------------------------------------+
| Footer                                             |
+--------------------------------------------------+
```

- Header — shared site header: logo, "Jak to funguje" / "Blog" / "O nás" nav, "Požádat o pomoc" CTA,
  "Můj účet" account link (person icon). Confirmed (`po_prihlaseni_do_uctu.png`).
- Hero — celebratory icon (flag/megaphone illustration), headline "Děkujeme, že pomáháte dětem,
  které neměly v životě štěstí.", sub-copy "Toto je stránka, na které vám vystavíme potvrzení o
  darech Patronu dětí." Confirmed (`po_prihlaseni_do_uctu.png`).
- Form panel — grey-background section containing the request form; visible in both screenshots
  (top of form in the first, remainder + submit + disclaimer in the second, per the scroll
  relationship documented in `ui-observed-areas.md` §12). Confirmed.
- Cookie banner + Footer — shared site chrome, not screen-specific. Confirmed
  (`po_prihlaseni_do_uctu_potvrzeni_o_darech.png`).

---

## Components Used

Recurring elements promoted to COMP by **AR:COMPSynthesizer** (see `COMP-inventory-map.md`); all
other entries remain flagged `inline` (no ≥2-screen reuse evidenced).

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | COMP0002 | context=public | Shared chrome, not screen-specific — Confirmed; see `COMP0002` Global Site Header |
| Hero | inline | icon + heading + sub-copy | Confirmed |
| Form panel | inline | tab control (2 tabs) | "Fyzická osoba" (active/default) / "Právnická osoba" (inactive) — Confirmed |
| Form panel | inline | text input × 2 | "Jméno", "Příjmení" — Confirmed |
| Form panel | inline | text input | "Adresa trvalého bydliště" (placeholder "Ulice, číslo, Město, PSČ") — Confirmed |
| Form panel | inline | text input | "Rodné číslo bez lomítka" (placeholder "YYMMDDXXXX") — Confirmed |
| Form panel | inline | text input | "Fyzická osoba s IČ" (placeholder "Pozor na překlepy :)") — Confirmed |
| Form panel | inline | checkbox (radio-styled circular control) | "Chci vykázat všechny dary za rok 2025" — Confirmed; visually distinct from `COMP0006` Consent Checkbox (no embedded legal hyperlink) — not promoted, left inline |
| Form panel | COMP0001 | — | "Ziskat potvrzení" (typo for "Získat", observed verbatim) — Confirmed; see `COMP0001` Primary Button |
| Form panel | inline | info/disclaimer callout | info icon + italic legal disclaimer text — Confirmed |
| Page | COMP0004 | — | shared site component, not form-specific — Confirmed; see `COMP0004` Cookie Consent Banner |
| Footer | COMP0003 | — | shared chrome — Confirmed; see `COMP0003` Global Site Footer |

---

## Interactions

1. **Entry** — navigate from account zone ("Můj účet") to `/muj-ucet/potvrzeni-o-darech` → state:
   `default` (Confirmed route/nav path — `IA-patronus.md` §4, §7.1; `IA-screen-map.md` row S012).
2. **Primary action — tab switch** — click "Právnická osoba" tab → Assumed: swaps the visible field
   set to organization-shaped fields (name/registration number, per `UC0010` step "Validate the
   type-specific identifying fields ... organization: name and registration number"); the
   organization-tab field layout itself is **not captured** in either screenshot (only the
   "Fyzická osoba" tab is shown active) — Uncertain.
3. **Primary action — submit** — click "Ziskat potvrzení" → submits the identifying fields, the
   selected person-type, and (if checked) the "vykázat všechny dary za rok NNNN" flag; realizes
   `UC0010.1`–`UC0010.2` (validate → resolve User → compute total → create `EN0014` snapshot →
   render PDF → dispatch email); next: no confirmation/success screen is captured for S012
   specifically (Uncertain — see States → default/none-observed below).
4. **Secondary action — year checkbox** — toggling "Chci vykázat všechny dary za rok 2025" changes
   the request scope from a single/per-donation certificate to a consolidated per-calendar-year
   certificate. Confirmed control exists; the per-donation vs. per-year distinction is corroborated
   by the disclaimer copy ("...toto potvrzení nebo potvrzení za kalendářní rok pouze jednou...").
5. **Exit** — no explicit cancel/back control observed within the form panel itself; exit is via
   header navigation ("Můj účet", other nav links) — Confirmed (shared chrome only).

---

## States

### default
Form shown with all fields empty/placeholder text, "Fyzická osoba" tab active by default, year
checkbox unchecked. Confirmed (`po_prihlaseni_do_uctu.png`, `po_prihlaseni_do_uctu_potvrzeni_o_darech.png`).

### empty
N/A — Evidence Pending: this screen is a single-purpose request form, not a list/collection view;
no empty-state condition (e.g., "no donations found for this year") is observed in either
screenshot. `UC0010` AF1 ("No donation total for the requested year") describes the system silently
aborting issuance rather than a UI empty-state — whether the user sees any on-screen feedback for
this case is Uncertain, not evidenced.

### loading
Uncertain — Evidence Pending. No loading/spinner indicator is visible in either static screenshot;
submission is presumably synchronous-feeling but no async indicator was captured.

### error
Uncertain — Evidence Pending. Neither screenshot shows a validation-error or submission-failure
state. `UC0010` AF1 (zero donation total) and AF2 (rendering/dispatch failure) are known backend
outcomes, but no corresponding on-screen error treatment for S012 is observed — open question, not
fabricated.

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| "Jméno" / "Příjmení" (individual identity) | none found — `UC0010` step "Validate the type-specific identifying fields (individual: first/last name and birth number)" describes *that* validation occurs, but no BR document specifies the rule content (format, required-ness detail) | Uncertain — validationsWithoutBR; presumed inline (no modal/toast observed) |
| "Rodné číslo bez lomítka" (birth number) | none found — same `UC0010` step as above; placeholder "YYMMDDXXXX" suggests a format expectation but no BR governs the check-digit/format rule | Uncertain — validationsWithoutBR; presumed inline |
| "Adresa trvalého bydliště" | none found | Uncertain — validationsWithoutBR |
| "Fyzická osoba s IČ" | none found | Uncertain — validationsWithoutBR |
| Organization name / registration number (Právnická osoba tab, not captured) | none found — `UC0010` step "organization: name and registration number" | Uncertain — validationsWithoutBR; field layout itself not observed |
| Requested year / year-checkbox scope | none found | Uncertain — validationsWithoutBR |
| Zero donation total for requested year (submit-time, server-side) | none found — governed narratively by `UC0010` AF1 and `BR-DonationConfirmationAndTax` "Confirmation issuance SHALL be aborted ... when the computed total ... is zero", but that BR document defines the abort rule, not a screen-level validation-surface presentation | Uncertain — validationsWithoutBR; no on-screen surface observed for this case |

No BR document defines field-level input validation (format/required-ness) for S012's form fields.
`BR-DonationConfirmationAndTax` governs the server-computed total and the zero-total abort condition
narratively but does not specify how (or whether) that is surfaced to the user on this screen. This
is recorded as an open question, not invented as a new BR.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| "Jméno" / "Příjmení" / "Adresa trvalého bydliště" / "Rodné číslo" / "Fyzická osoba s IČ" | `EN0014` | — | Maps to `EN0014` user-provided attributes `name`, `address`, `rodne_cislo` (Confirmed field names/shapes per EN0014 "User-provided attributes"); the screen splits `name` into separate "Jméno"/"Příjmení" inputs (Probable — EN0014 models a single `name` string, so the two-field UI is a presentation-layer split not itself documented at EN level). The "Fyzická osoba s IČ" field has no direct EN0014 attribute match — Uncertain, possibly a registration-number equivalent for the organization/self-employed case; open question. |
| Tabs "Fyzická osoba" / "Právnická osoba" | `EN0014` (indirectly, via `UC0010`'s "requester type (individual or organization)") | — | `EN0014` itself does not model a person-type attribute explicitly; the type distinction is described only in `UC0010`'s flow steps. Probable. |
| Year checkbox ("Chci vykázat všechny dary za rok NNNN") | `EN0014` | — | Maps to `confirmation_year` (required attribute). Confirmed field exists at EN level; the checkbox's specific semantics (single-donation vs. consolidated-year scope) are Probable, inferred from the disclaimer copy rather than an explicit EN0014 flag. |
| Submit action → computed total | `EN0009` | — | Read-only source of the server-computed `donation_total` per `BR-DonationConfirmationAndTax`; not directly rendered on this screen (no total/preview shown pre-submit) — Confirmed as backend binding, Uncertain whether ever displayed on S012. |
| Requester identity (session) | `EN0008` | — | The resolved donor/User per `UC0010`; whether S012 requires login (User from session) vs. accepts anonymous email-based resolution is the open question noted in Purpose — Uncertain. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | Observed role: authenticated account holder ("Můj účet" is visible/active in header in both screenshots, consistent with the account-zone placement in `IA-screen-map.md` row S012) — no ACL document exists in this pass to formalize the gate | Uncertain — no ACL layer; ie whether an unauthenticated visitor can reach `/muj-ucet/potvrzeni-o-darech` directly is not evidenced by the screenshots (both show "Můj účet" as a nav link, not a logged-in-state indicator per se) |
| "Právnická osoba" tab field set | none evidenced | Not observed — field set for this tab is not captured in either screenshot |

---

## Accessibility Notes

Evidence Pending — no DOM/ARIA capture exists, only static screenshots. The following is what can
be responsibly inferred, not confirmed:

- **Tab order:** Assumed left-to-right, top-to-bottom through header nav, then tab control, then
  form fields (Jméno → Příjmení → Adresa → Rodné číslo → IČ field → year checkbox → submit) — Uncertain, not observed via DOM.
- **Focus on entry:** Uncertain — not evidenced.
- **Focus on state transition:** Uncertain — no state transition captured.
- **Landmarks:** Uncertain — not evidenced from static screenshots.
- **Keyboard shortcuts:** none observed.

---

## Open Questions

1. Does S012 require prior authentication, or can it also be reached via the anonymous
   email-resolution path described in `UC0010`'s Preconditions/Main Flow? The IA places it in the
   account zone, but no login-wall or account-context indicator is visible within the form itself.
   Uncertain — requires clarification.
2. What does the "Právnická osoba" (organization) tab's field set look like? Not captured in either
   screenshot; only the default "Fyzická osoba" tab is shown active. Evidence Pending.
3. What on-screen feedback (if any) does the user receive for `UC0010` AF1 (zero donation total —
   confirmation silently not issued) or AF2 (snapshot persisted but document dispatch fails)?
   No error/empty state was captured for S012. Uncertain — validationsWithoutBR also applies here.
4. Does the "Fyzická osoba s IČ" field correspond to a distinct EN0014 attribute, or is it an
   unmodeled field (e.g., a self-employed registration number) not currently reflected in the EN
   layer? Uncertain.
5. What happens after successful submission — is there a dedicated confirmation/success screen,
   or does the user simply receive the PDF by email with no further on-screen change? Not captured.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen existence, route, header chrome, hero copy | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu.png`; `_ar/evidence/ui/ui-observed-areas.md` §12 |
| Form fields (Jméno, Příjmení, Adresa, Rodné číslo, Fyzická osoba s IČ), tabs, year checkbox, submit CTA, legal disclaimer | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu_potvrzeni_o_darech.png`; `ui-observed-areas.md` §12 |
| Realizing UC (UC0010) and its request/validate/compute/persist/render/dispatch flow | Confirmed | `_ar/spec-draft/UC/UC0010_IssueDonationConfirmation.md` |
| EN0014 field shapes bound to form fields | Confirmed (entity shape) / Probable (field-to-attribute mapping) | `_ar/spec-draft/EN/EN0014_DonationConfirmation.md` |
| Server-computed total & zero-total abort rule | Confirmed (rule exists) / Uncertain (on-screen surfacing) | `_ar/spec-draft/BR/BR-DonationConfirmationAndTax.md` |
| Organization ("Právnická osoba") tab field layout | Evidence Pending — not captured | `ui-observed-areas.md` §12 (tab control observed, contents not) |
| Loading / error / empty states | Uncertain — Evidence Pending | No screenshot shows these states |
| Authentication requirement for reaching S012 | Uncertain | `_ar/spec-draft/IA-screen-map.md` row S012 (placed in account zone); no login-wall visible in captures |
