---
doc_id: WIRE0010
title: Application Wizard Step4 Patron
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008d
realizes_uc: [UC0001]
status: draft
references:
  - UC0001
  - EN0001
  - EN0002
  - EN0005
  - BR-ApplicationStatusGovernance
  - BR-ScoringAndRiskGating
  - BR-PartyIdentityAndDeduplication
---

# WIRE0010 – Application Wizard Step4 Patron

## Purpose

Step 4 ("Krok 4: Údaje o vašem Patronovi") of the 5-step public Application wizard at
`/zadost-formular`. The applicant (fundraiser role — parent/legal guardian, per IA `S008a`–`S008c`)
declares who will act as the Story's Patron: the Patron's name, their relationship to the applicant's
family, and contact details so the platform can reach the Patron directly. This screen is reached
after step 3 ("Údaje o vás", `S008c`) and continues the same `UC0001` orchestration (Application
created at step-0/contact-gate, profile filled progressively across steps 1–5); no dedicated
"step-4-submit" use case exists in the UC layer — see Open Questions (same caveat as `WIRE0007`).

This screen resolves IA-Q5 (`_ar/spec-draft/IA/IA-patronus.md` §8) for step 4: the IA screen map and
`ui-observed-areas.md` §5 previously recorded step 4 as "stepper label only, not captured." Two direct
captures of this step now exist (empty and filled/validation-error states) — this document supersedes
that "not captured" status for `S008d`; the IA/UOA layers are not edited here (write-scope discipline)
but the gap they flagged is closed by this WIRE. — Confirmed screen identity/URL/fields; Assumed UC
attribution granularity (same caveat as sibling wizard-step WIRE docs).

Evidence: `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png` (empty),
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_59.png` (filled, with a
field-level validation error shown).

**Terminology note:** this screen's "Patron" is the applicant's *declared* Patron for this
Application — captured as `patron_*` fields on the fundraiser's `ApplicationProfile` (`EN0002`) — and
is distinct from `EN0005` Patron, which is the published public-facing display profile shown on a
Campaign/Story page. The two may be populated from the same real person but are different entities in
the current reconstruction; see Data Bindings and Open Questions.

---

## Layout Zones

- **Global header** — site logo "patron dětí"; primary nav ("Jak to funguje", "Blog", "O nás"); CTA
  button "Požádat o pomoc"; account link "Můj účet" — Confirmed. (Nav targets are IA concerns, not
  restated here.)
- **Stepper bar** — 5 numbered steps: "1 Příběh" (done, checkmark), "2 Dar" (done, checkmark), "3 O
  Vás" (done, checkmark), "4 Patron" (active, filled red circle "4"), "5 Přílohy" (upcoming, grey
  outline circle "5") — Confirmed.
- **Page intro** — heading "Krok 4: Údaje o vašem Patronovi"; three-line instructional copy explaining
  what a Patron is, the family-member exclusion rule, and example non-family patron roles — Confirmed
  (copy verbatim reproduced only to identify the zone; full copy is COPY layer's job).
- **Back link** — "← Krok zpět" above the form card — Confirmed.
- **Form card** (single light-grey card, main content) — Confirmed:
  - Sub-zone A: "Jméno a příjmení vašeho Patrona" — two side-by-side text inputs (Jméno / Příjmení).
  - Sub-zone B: "V jakém vztahu je k vám nebo k vaší rodině?" — single-select dropdown.
  - Sub-zone C: "Kontaktní údaje na Patrona" — sub-heading + one-line helper copy, then two inputs:
    E-mail (full width) and Telefon (with a fixed "+420" prefix segment).
  - Sub-zone D: primary CTA "Pokračovat" (bottom-right of card).
- **Global footer** — cookie banner, "patron dětí" org blurb, link columns ("Patron dětí", social;
  "Kontakt"), payment-provider badges, collection-account number, copyright — Confirmed. (Footer
  content/links are IA/COPY concerns; noted only as a layout zone.)

```
+--------------------------------------------------------------+
| Global header: logo | nav | "Požádat o pomoc" | "Můj účet"   |
+--------------------------------------------------------------+
| Stepper: (✓)Příběh (✓)Dar (✓)O Vás  (4)Patron   5 Přílohy    |
+--------------------------------------------------------------+
| "Krok 4: Údaje o vašem Patronovi" (title + 3-line intro)      |
| "← Krok zpět"                                                  |
+--------------------------------------------------------------+
| Form card:                                                     |
|  "Jméno a příjmení vašeho Patrona"                             |
|  [A] Jméno | Příjmení                                          |
|  "V jakém vztahu je k vám nebo k vaší rodině?"                 |
|  [B] [ dropdown, single-select ]                                |
|  "Kontaktní údaje na Patrona"                                   |
|  "Informujte svého Patrona o tom... budeme ho ihned kontaktovat|
|   emailem."                                                     |
|  [C] E-mail          | [+420] Telefon                          |
|                          (error text if phone == applicant's)   |
|                                            [ Pokračovat ]      |
+--------------------------------------------------------------+
| Global footer                                                  |
+--------------------------------------------------------------+
```

---

## Components Used

The COMP layer does not yet exist in this reconstruction pass — every element is flagged `inline`.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Global header | inline | site nav bar | shared across screens (candidate for future COMP; not asserted here) |
| Stepper bar | inline | 5-step, numbered, done/active/upcoming states (checkmark vs. filled red number vs. grey outline number) | Confirmed visual pattern; step labels "Příběh/Dar/O Vás/Patron/Přílohy" |
| Back link | inline | text link with left-arrow glyph | Confirmed |
| Patron name fields (A) | inline | two side-by-side single-line text inputs (Jméno / Příjmení) | Confirmed |
| Relationship dropdown (B) | inline | single-select `<select>`, placeholder/no default option shown in empty state | Confirmed presence; option list contents not fully enumerated — only "Rodinný známý" is observed (filled-state capture) |
| Patron contact helper text (C) | inline | one-line grey helper copy above the e-mail/phone inputs | Confirmed |
| Patron e-mail field (C) | inline | single-line text input, placeholder "E-mail" | Confirmed |
| Patron phone field (C) | inline | compound input: fixed non-editable "+420" prefix segment + single-line phone text input; validation-error variant shows red border + red helper text below | Confirmed (both variants captured) |
| Primary CTA | inline | filled red button "Pokračovat" | Confirmed |
| Global footer | inline | cookie banner + link columns + payment badges | Confirmed, out of scope for this UC |

---

## Interactions

1. **Entry** — advance from `S008c` (step 3, "Údaje o vás") via its "Pokračovat" action → state:
   `default` (empty form, per `screencapture-…13_22_08.png`). Confirmed sequence per IA §5 wizard step
   order.
2. **Primary action — "Pokračovat"** — trigger: click/tap → effect: submits step-4 field values
   (persisted onto `EN0002` `patron_first_name`, `patron_last_name`, a relationship value, and
   `patron_email`/`patron_phone` — see Data Bindings) and, if the client-side phone-mismatch check
   passes, advances the stepper to step 5 ("Přílohy", `S008e`) — Assumed persistence-on-continue
   behavior (not evidenced: no dossier confirms per-step save vs. single final submit; same open
   question as `WIRE0007`/`WIRE0008`). If the phone-mismatch validation is active, the button's effect
   when clicked while the error is showing is Uncertain — not observed (the filled capture shows the
   error already rendered, not a submit attempt caught mid-click).
3. **Secondary action — "Krok zpět"** — trigger: click → effect: navigates back one step to `S008c`
   (step 3, "Údaje o vás") — Confirmed by wizard step order (IA §5), though the transition itself
   (data preservation on back-navigation) is not observed.
4. **Field interaction — phone-mismatch validation** — trigger: entering a Patron phone number that
   equals the applicant's own phone number (captured on `S008c`) → effect: the phone input renders a
   red-outlined error state with inline text "Telefonní číslo nemůže být stejné jako to Vaše." beneath
   it — Confirmed occurrence, Uncertain trigger timing (on blur / on change / on submit-attempt — not
   determinable from a static capture).
5. **Exit (success)** — advancing via "Pokračovat" leads to `S008e` (step 5, "Přílohy") — Confirmed
   sequence per IA §5.
6. **Exit (abandonment)** — closing/navigating away mid-wizard; resumption is handled by a separate
   draft-resume modal flow (`UC0025`, `EN0003` `ApplicationSession`) on a later visit — out of scope
   for this screen, referenced only.

---

## States

### default
Empty form: both name inputs show placeholder text ("Jméno"/"Příjmení"), the relationship dropdown
shows no selection (blank with a chevron), and the e-mail/phone inputs show placeholder text
("E-mail"/"Telefon") — Confirmed
(`screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png`).

### empty
Not distinguished from `default` in evidence — the "empty" capture *is* the default/unfilled state
described above, matching the pattern already recorded for `WIRE0007`/`WIRE0008`. —
`N/A — the observed "default" state already represents the unfilled/empty form; no distinct
empty-state visual exists in evidence.`

### loading
Not observed in either capture (both are static, fully rendered states; no spinner/skeleton/disabled
-button treatment during submission was captured). — `Evidence Pending — not captured.`

### error
**Partially observed** — a field-level validation error is captured: the Telefon input on this step
shows a red border and inline red helper text "Telefonní číslo nemůže být stejné jako to Vaše." when
the entered Patron phone number matches the applicant's own phone number
(`screencapture-…13_22_59.png`). This is a **field-level inline error**, not a page-level or
toast/modal error. No other error condition (e.g. invalid e-mail format, empty required field on
submit attempt, server-side rejection) is observed on this screen. — Confirmed for the phone-mismatch
case; `Evidence Pending — not captured` for all other error conditions.

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| Telefon (Patron phone) — must not equal applicant's own phone | No BR found — see validationsWithoutBR | inline, field-level (red border + red helper text below the field) — Confirmed |
| Jméno / Příjmení (Patron name) — required? | No BR found — see validationsWithoutBR | not observed (no empty-submit attempt captured) |
| "V jakém vztahu..." dropdown — required? | No BR found — see validationsWithoutBR | not observed |
| E-mail (Patron e-mail) — format validation? | No BR found — see validationsWithoutBR | not observed |
| "Pokračovat" submit gate (which fields block progression) | No BR found — see validationsWithoutBR | not observed |

No `BRxxxx` in the current BR layer (`BR-ApplicationStatusGovernance`, `BR-ScoringAndRiskGating`,
`BR-PartyIdentityAndDeduplication`, and the rest of `_ar/spec-draft/BR/_REGISTRY.md`) covers
field-level validation for this step's inputs, including the observed Patron-phone-must-differ-from-
applicant-phone rule. This is recorded as an open question, not an invented rule — the rule is real
(directly observed) but its owning BR does not yet exist in this reconstruction pass.

**validationsWithoutBR:**
- Patron phone ≠ applicant phone (client-side, field-level; directly observed, no BR owner)
- Required-field gating for Jméno/Příjmení/relationship-dropdown/e-mail (not observed, no BR owner)

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| "Jméno a příjmení vašeho Patrona" (Jméno / Příjmení) | `EN0002` (`patron_first_name`, `patron_last_name`) | — | Confirmed field purpose match |
| "V jakém vztahu je k vám nebo k vaší rodině?" dropdown | `EN0002` — no discrete attribute name matches this field in the current EN0002 attribute list | — | Uncertain — `EN0002` lists `patron_occupation_list` (occupation classification) but no separate "relationship to applicant/family" attribute; the observed option "Rodinný známý" reads as a relationship category, not an occupation. Flagged as an EN/WIRE gap, not resolved here. |
| "Kontaktní údaje na Patrona" — E-mail | `EN0002` (`patron_email`) | — | Confirmed field purpose match |
| "Kontaktní údaje na Patrona" — Telefon (+420) | `EN0002` (`patron_phone`) | — | Confirmed field purpose match |
| Application/session context (which `Application`/`ApplicationProfile` is being edited) | `EN0001`, `EN0002` | — | Confirmed at the entity level per `UC0001` postconditions (Application + fundraiser profile created before this step is reachable) |
| Public-facing Patron display profile (name/photo shown on the eventual Story page) | `EN0005` | — | Not populated by this screen per current evidence — `EN0005` is a separate display entity (publish/unpublish flag, its own first/second-surname/photo attributes) with no confirmed write path from this wizard step. Whether/when `EN0005` is derived from these `patron_*` profile fields is Uncertain; see `EN0005` Open Questions and this doc's Open Questions. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Whole screen (`S008d`) | Reachable only after completing `S008c` (step 3) within the same wizard session; no ACL layer exists yet to cite a role gate | N/A — not observed as gated by an authenticated role; the applicant is the fundraiser-role Customer per `UC0001` |
| "Krok zpět" link | Always visible in both captures | — |
| Phone-mismatch error text | Conditional on phone input value equaling the applicant's own phone (observed, no BR owner — see Validation Surfaces) | Hidden when the entered phone differs from the applicant's; shown otherwise |

No `ACLxxxx` layer exists in this reconstruction pass (per rules-WIRE.md and IA-Q4); no role-gating
beyond wizard-sequence reachability was observed for this screen.

---

## Accessibility Notes

- **Tab order:** Not evidenced from static screenshots — Assumed to follow visual top-to-bottom,
  left-to-right order (Jméno → Příjmení → relationship dropdown → E-mail → Telefon → "Pokračovat"),
  consistent with standard form markup, but not confirmed.
- **Focus on entry:** Uncertain — not observed.
- **Focus on state transition:** Uncertain — whether focus moves to the Telefon field or its error
  text when the phone-mismatch error appears is not observed from a static capture.
- **Landmarks:** Uncertain — semantic structure (headings, fieldsets, ARIA roles for the stepper,
  `aria-invalid`/`aria-describedby` wiring for the error text) not determinable from a rendered
  screenshot.
- **Keyboard shortcuts:** None observed; none expected for a standard form screen.

---

## Open Questions

- Does "Pokračovat" persist step-4 data immediately (per-step save) or only on final wizard
  submission? Not evidenced by any UC/dossier — same open question already recorded for
  `WIRE0007`/`WIRE0008`.
- Is the "V jakém vztahu je k vám nebo k vaší rodině?" dropdown backed by a confirmed `EN0002`
  attribute, or is it an unmodeled field (candidate for an EN0002 follow-up)? The only observed option
  value is "Rodinný známý"; the full option list is not evidenced.
- What triggers the Patron-phone-must-differ-from-applicant-phone validation (on blur / on change / on
  submit attempt), and is it purely client-side or also enforced server-side? Not determinable from a
  static capture. No BR currently owns this rule — recorded as an open question, not invented.
- What is the relationship, if any, between the `patron_*` fields captured here (`EN0002`) and the
  published-display `EN0005` Patron entity shown on a Story page? No confirmed write path links the
  two in current evidence (see `EN0005` Open Questions, which asks the mirror-image question).
- Is "Rodné číslo" or any government-id-equivalent field collected for the Patron on this step, the
  way it is for the child (step 1) and the applicant (step 3)? Neither capture shows such a field —
  Confirmed absent from what is observed, but whether this is a deliberate design choice or a field
  outside the captured viewport is Uncertain (both captures appear to show the full card, footer
  included, so an omitted field below the fold is unlikely but not fully ruled out).
- This document resolves IA-Q5 for step 4 only; step 5 ("Přílohy", `S008e`) remains open per IA-Q5
  until its own WIRE doc is produced from equivalent evidence.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen identity, URL, stepper (steps 1–3 done, step 4 active, step 5 upcoming), page title/intro copy | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png` |
| Field labels, layout order, default state (empty) | Confirmed | same |
| Filled-state visuals, tester identity data, phone-mismatch validation error | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_59.png` |
| Field-to-EN0002-attribute mapping (name, e-mail, phone) | Confirmed | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md` |
| Field-to-EN0002-attribute mapping (relationship dropdown) | Uncertain — no matching attribute found | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md` |
| Relationship of this screen's Patron fields to `EN0005` Patron display entity | Uncertain | `_ar/spec-draft/EN/EN0005_Patron.md` |
| UC attribution (`UC0001`) | Confirmed at IA level, Assumed at step-granularity | `_ar/spec-draft/IA/IA-patronus.md` §3.3, §5; `_ar/spec-draft/UC/UC0001_SubmitApplication.md` |
| Validation rules (phone-mismatch, required fields, dropdown options) | Confirmed occurrence / Uncertain mechanism — no BR found | `_ar/spec-draft/BR/_REGISTRY.md` (no matching BR); screenshots above |
| loading state | Evidence Pending — not captured | — |
| empty state (distinct from default) | N/A — default capture is the unfilled state | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png` |
| This screen was previously recorded "not captured" (IA-Q5, `ui-observed-areas.md` §5) | Superseded by this WIRE's direct evidence | `_ar/spec-draft/IA-screen-map.md` row S008d; `_ar/spec-draft/IA/IA-patronus.md` IA-Q5 (not edited by this WIRE pass — write-scope discipline) |
