---
doc_id: WIRE0009
title: Application Wizard Step3 Applicant
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008c
realizes_uc: [UC0001]
status: draft
references:
  - UC0001
  - EN0001
  - EN0002
  - EN0006
---

# WIRE0009 – Application Wizard Step3 Applicant

## Purpose

S008c is step 3 ("O Vás" / "Krok 3: Údaje o vás") of the five-step `/zadost-formular` Application
wizard. The applicant (parent / legal guardian acting as fundraiser) enters their own identity,
residence, contact, and employment-status data so the platform can assess and process the
Application (Žádost). It sits between step 2 "Dar" (S008b) and step 4 "Patron" (S008d) in the
wizard sequence documented in `_ar/spec-draft/IA/IA-patronus.md` §3.3/§7. It realizes `UC0001`
(Submit Application) — specifically the data-capture portion of the self-registration/application
sub-flow (UC0001.1); the UC document itself does not enumerate this step's fields, so field-level
detail here is sourced from `EN0002` (ApplicationProfile) and the observed UI, referenced rather
than restated from UC0001.

**Actor:** applicant (fundraiser role) — an unauthenticated or freshly-registered Customer
mid-wizard (Confirmed — `ui-observed-areas.md` §5 "Audience: applicant (parent / legal guardian)").

**Entry context:** arrives from step 2 "Dar" (S008b) via "Pokračovat", or returns from step 4
"Patron" (S008d) via "Krok zpět" — both confirmed by the stepper control and "Krok zpět" link.
Direct-URL entry / resume-from-draft-session behavior is not evidenced for this specific step
(Uncertain).

---

## Layout Zones

Confirmed — both screenshots show an identical single-column layout, differing only in field
fill-state (see States).

- Header — global site header/nav: "patron dětí" logo, "Jak to funguje" / "Blog" / "O nás" links,
  "Požádat o pomoc" CTA, "Můj účet" link. (Shared chrome — not specific to this screen; see IA.)
- Stepper — 5-step horizontal progress indicator: "Příběh" (done, checkmark) / "Dar" (done,
  checkmark) / "3 O Vás" (active, filled red circle) / "4 Patron" (pending, grey) / "5 Přílohy"
  (pending, grey).
- Page title zone — "Krok 3: Údaje o vás" (H1) + subtext "Abychom vám mohli pomoci, potřebujeme o
  vás bližší informace." + "← Krok zpět" link.
- Main form card — single light-grey card containing all form fields (see Components Used).
- Info banner — persistent red/pink banner below the form, above the submit action.
- Primary action — "Pokračovat" button, bottom-right of the card.
- Footer — global site footer (cookie notice, "patron dětí" blurb, nav columns, payment-provider
  badges, collection-account number, copyright). Shared chrome — not specific to this screen.

```
+--------------------------------------------------+
| Header (logo, nav, Požádat o pomoc, Můj účet)     |
+--------------------------------------------------+
| Stepper: (✓)Příběh —(✓)Dar —(3)O Vás —(4)—(5)     |
+--------------------------------------------------+
| Krok 3: Údaje o vás                               |
| Abychom vám mohli pomoci...                       |
| ← Krok zpět                                       |
+--------------------------------------------------+
| [ form card ]                                     |
|  Vaše jméno a příjmení   [Jméno] [Příjmení]       |
|  Rodné číslo rodiče      [___________________]    |
|  Adresa trvalého bydliště                         |
|    [Ulice a číslo popisné______________]          |
|    [Město___________] [PSČ___]                    |
|  [ ] Zastihnete mě na jiné než trvalé adrese.      |
|  [ ] Jsem samoživitel  <definition text>          |
|  Vaše kontaktní údaje                             |
|    [E-mail_______________] [+420][Telefon____]    |
|  Jste zaměstnán? (•)ANO ( )NE                     |
|  [ i  V případě změny údajů... ]  (banner)         |
|                                    [ Pokračovat ]  |
+--------------------------------------------------+
| Footer                                            |
+--------------------------------------------------+
```

---

## Components Used

Recurring elements promoted to COMP by **AR:COMPSynthesizer** (see `COMP-inventory-map.md`); all
other entries remain flagged `inline` (no ≥2-screen reuse evidenced).

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | COMP0002 | context=public | see `COMP0002` Global Site Header |
| Stepper | COMP0005 | activeIndex=3, completedIndices=[1,2] | Confirmed — `ui-observed-areas.md` §5 "Controls"; see `COMP0005` Application Wizard Stepper |
| "Krok zpět" link | inline | text link + left-arrow icon | Confirmed. |
| Text input — "Jméno" | inline | single-line text, placeholder "Jméno" | Confirmed. |
| Text input — "Příjmení" | inline | single-line text, placeholder "Příjmení" | Confirmed. |
| Text input — "Rodné číslo rodiče" | inline | single-line text, full width | Confirmed. Label includes inline hint "(cizinec: číslo pojištěnce)". |
| Text input — "Ulice a číslo popisné" | inline | single-line text, full width | Confirmed. |
| Text input — "Město" | inline | single-line text | Confirmed. |
| Text input — "PSČ" | inline | single-line text | Confirmed. |
| Checkbox — "Zastihnete mě na jiné než trvalé adrese." | inline | checkbox + label | Confirmed; unchecked in both captures — effect of checking it (e.g. reveals a mailing-address sub-form) is **not observed** (Uncertain). |
| Checkbox — "Jsem samoživitel" | inline | checkbox + label + static definition text below | Confirmed; unchecked in both captures; definition text is always visible (not a tooltip/popover in evidence). |
| Text input — "E-mail" (contact) | inline | single-line text/email | Confirmed. |
| Phone input — country-code + number | inline | fixed "+420" prefix segment + number field | Confirmed; no evidence of the prefix being changeable (Uncertain — could be a dropdown, appears static in both captures). |
| Radio group — "Jste zaměstnán?" | inline | 2 options: ANO / NE, single-select | Confirmed; defaults to NE in the empty-state capture, shown as ANO in the filled-state capture (tester-toggled). |
| Info banner | inline | red/pink banner, info icon + bold lead-in + body text | Confirmed. |
| Primary button — "Pokračovat" | COMP0001 | — | see `COMP0001` Primary Button |
| Footer | COMP0003 | — | see `COMP0003` Global Site Footer |

---

## Interactions

1. **Entry** — user arrives from S008b "Dar" step via its "Pokračovat" action, or returns from
   S008d "Patron" via this screen's own "Krok zpět" → state: `default` (Confirmed, stepper shows
   steps 1–2 complete, step 3 active).
2. **Primary action — "Pokračovat"** — submits step-3 field values and advances to step 4 "Patron"
   (S008d); realizes `UC0001` (the data-capture continuation of Submit Application). Client-side/
   server-side validation behavior on click is **not observed** — no error state was captured (see
   States → error). Uncertain which fields are required at this step; `agreement_truthfulness` and
   `child_unschoold` are the only `EN0002` attributes marked required overall, neither of which is a
   field visible on this screen (Open Question).
3. **Secondary action — "Krok zpět"** — returns to step 2 "Dar" (S008b), presumably preserving
   already-entered step-3 values; persistence-on-back-navigation is **not observed** (Uncertain).
4. **Secondary action — "Zastihnete mě na jiné než trvalé adrese."** — checkbox toggle; observed
   unchecked only in both captures, so its effect (e.g. revealing a second address block) is
   **not observed** (Uncertain — Open Question).
5. **Secondary action — "Jsem samoživitel"** — checkbox toggle; observed unchecked only; effect
   beyond recording the flag (e.g. triggering a follow-up attachment requirement) is **not observed
   on this screen** — cross-step attachment requirements are asserted for employment (see next) but
   not confirmed for this flag.
6. **Secondary action — "Jste zaměstnán?" radio** — toggling ANO/NE is observed as a working
   control (both values captured), but on-change side effects are **not observed on this screen**
   itself; the visible label text asserts a cross-step consequence: "(pokud nejste zaměstnán,
   doložte evidenci na ÚP v kroku 5.)" — i.e. selecting NE is claimed to require an attachment on
   step 5 "Přílohy" (S008e), which is itself uncaptured (Confirmed claim exists in copy; the
   resulting step-5 behavior is Assumed/Uncertain — see `IA-screen-map.md` row S008e).
7. **Exit** — successful "Pokračovat" → step 4 "Patron" (S008d, uncaptured); "Krok zpět" → step 2
   "Dar" (S008b); no other exit (e.g. save-and-resume) is observed on this screen.

---

## States

### default
The form as shown with all fields empty and placeholder text visible, "Jste zaměstnán?" defaulted
to NE (Confirmed — screencapture …13_21_26.png).

### empty
Same as `default` — this screen has no distinct empty/no-data collection state; it is a single
input form, not a list. N/A — this screen is not a collection view.

### loading
Not observed. No loading indicator, skeleton, or disabled-submit-while-pending treatment was
captured for this screen. **Uncertain — Evidence Pending.**

### error
Not observed. Neither capture shows a validation-error, field-highlight, or submission-failure
state. **Uncertain — Evidence Pending** (Open Question: what happens if "Pokračovat" is clicked
with required fields missing/invalid — no capture exists).

### filled (observed, additional to the four required states)
Confirmed — screencapture …13_21_59.png shows fields populated with tester data ("Ondřej" /
"Šuhaj" / "881206/0290" / "Kaplická 446" / "Velešín" / "38232" / "o.suhaj@gmail.com" /
"+420 723667161") and "Jste zaměstnán?" toggled to ANO. Filled fields render with a light-blue
background versus white/grey for untouched fields — this appears to be a "touched" visual state
rather than a validated/confirmed-valid state (Probable — not confirmed by any success-icon or
inline check-mark).

---

## Validation Surfaces

No BR document in `_ar/spec-draft/BR/` governs field-level validation for this step's fields
(personal name, birth number, address, e-mail, phone, employment flags). The only entity-level
constraint found is on the sibling child-identity field (`child_rc`) in `EN0002`, not on this
step's `fundraiser_rc`. All rows below are therefore listed in `validationsWithoutBR` as open
questions rather than invented BR ids.

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| Jméno / Příjmení (fundraiser_first_name / fundraiser_last_name) | none — no BR found | Uncertain — validationsWithoutBR; format/required-ness not observed |
| Rodné číslo rodiče (fundraiser_rc) | none — no BR found | Uncertain — validationsWithoutBR; no format hint or example shown; contrast with `EN0002.child_rc` which is "conditionally required" per an Open Question in EN0002, but that constraint is documented for the child, not the fundraiser |
| Adresa (ulice/město/PSČ) (fundraiser_address fields) | none — no BR found | Uncertain — validationsWithoutBR |
| E-mail (fundraiser_email) | none — no BR found | Uncertain — validationsWithoutBR; note `UC0001` step 5 evidences an email-domain check via Integration(Email Validation Service) during self-registration, but that is the registration-entry email, not confirmed to be re-validated on this later wizard step — Open Question whether it is the same field/value |
| Telefon (fundraiser_phone) | none — no BR found | Uncertain — validationsWithoutBR |
| Jste zaměstnán? (employed_status) | none — no BR found | Uncertain — validationsWithoutBR; copy asserts a cross-step consequence (step-5 attachment) but no BR formalizes it |
| Jsem samoživitel (single-parent flag; not modeled as a named `EN0002` attribute — see Data Bindings) | none — no BR found | Uncertain — validationsWithoutBR |
| Zastihnete mě na jiné než trvalé adrese (mailing-address-differs flag) | none — no BR found | Uncertain — validationsWithoutBR |

**validationsWithoutBR:** fundraiser_first_name, fundraiser_last_name, fundraiser_rc,
fundraiser_address (street/city/zip), fundraiser_email, fundraiser_phone, employed_status,
single-parent flag, mailing-address-differs flag — none of these have a governing BR document;
required/format constraints are not evidenced on this screen (no inline error was ever captured).

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| "Vaše jméno a příjmení" | `EN0002` | — | `fundraiser_first_name`, `fundraiser_last_name` attributes. |
| "Rodné číslo rodiče" | `EN0002` | — | `fundraiser_rc` attribute (labelled for parent/guardian; foreigner variant asks for insurance number instead — same field, alternate meaning per label text, not modeled as a separate attribute in EN0002). |
| "Adresa vašeho trvalého bydliště" | `EN0002` | — | `fundraiser_address` (fields) attribute — street, city, ZIP. |
| "Zastihnete mě na jiné než trvalé adrese" | `EN0002` | — | Probable mapping to `fundraiser_address2` (Contact reference for a second address) — not explicitly confirmed as the checkbox's backing field; Open Question. |
| "Jsem samoživitel" | — | — | **No corresponding attribute found** in `EN0002`'s documented attribute list (Open Question — Missing evidence: single-parent/"samoživitel" status is shown in the UI with a full legal definition but is not traceable to a named EN0002 field in the current EN reconstruction). |
| "Vaše kontaktní údaje" (e-mail, telefon) | `EN0002` | — | `fundraiser_email`, `fundraiser_phone` attributes. |
| "Jste zaměstnán?" | `EN0002` | — | `employed_status` attribute (enum). |
| Screen/step container | `EN0001` | — | The step belongs to the overall Application (Žádost) being filled — per IA S008c mapping and UC0001 postconditions. |
| Applicant identity (party-level, per IA) | `EN0006` | — | IA-screen-map.md binds S008c to `EN0006` (Contact) at the party level; this WIRE's field-level detail is sourced from `EN0002` (ApplicationProfile) instead, since EN0002 documents the actual form fields observed (`fundraiser_*` attributes) — both references kept per cross-layer discipline. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | none evidenced — no ACL layer exists in this pass | N/A — screen is part of the applicant-role wizard entered via S008b; no role gate observed beyond being mid-wizard as an applicant (Confirmed audience per `ui-observed-areas.md` §5). |
| "Jsem samoživitel" definition text | none evidenced | Always visible when the checkbox is present (static helper text, not conditionally shown/hidden in either capture). |
| Step 4/5 stepper labels | none evidenced | Always visible (greyed, pending) — not gated, just not-yet-active. |

No `ACLxxxx` layer exists yet in this pass; no BR was found governing role-based visibility for
this screen specifically.

---

## Accessibility Notes

Evidence Pending for most items — screenshots do not reveal DOM structure, so tab order, ARIA
landmarks, and keyboard behavior are not directly observable.

- **Tab order:** Assumed top-to-bottom, left-to-right through visible fields (Jméno → Příjmení →
  Rodné číslo → Ulice → Město → PSČ → checkboxes → E-mail → Telefon → radio ANO/NE → Pokračovat) —
  **Uncertain**, inferred from visual layout only, not confirmed via DOM/keyboard capture.
- **Focus on entry:** Uncertain — Evidence Pending, not observed.
- **Focus on state transition:** Uncertain — Evidence Pending, not observed (no error state was
  captured to determine focus-to-error behavior).
- **Landmarks:** Uncertain — Evidence Pending; screenshots do not expose ARIA roles.
- **Keyboard shortcuts:** None observed; no screen-specific shortcuts evidenced.
- **Colour-only state signal (flag):** the "filled" vs. "untouched" field distinction relies on a
  light-blue vs. white/grey background colour difference (see States → filled) — no additional
  non-colour indicator (icon, text) was observed accompanying it; a potential accessibility gap,
  flagged as an **Open Question**, not asserted as a defect without further evidence.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Layout zones, stepper, form fields (empty state) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_21_26.png` |
| Filled-state field values, "touched" background styling, employment radio toggled ANO | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_21_59.png` |
| Screen purpose, audience, controls, field list (textual) | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §5 |
| Screen-id, stepper position, module clustering | Confirmed | `_ar/spec-draft/IA-screen-map.md` row S008c; `_ar/spec-draft/IA/IA-patronus.md` §3.3/§7 |
| Realizing UC (UC0001) — field-level detail not itself in UC0001 | Probable | `_ar/spec-draft/UC/UC0001_SubmitApplication.md` (registration/self-registration flow; step-3 fields not enumerated there) |
| Field → EN0002 attribute bindings | Probable | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md` "User-provided attributes" (`fundraiser_*`, `employed_status`) |
| "Jsem samoživitel" → no EN0002 attribute found | Uncertain (absence) | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md` full attribute list — no matching field name |
| Validation rules for this step's fields | Uncertain — no BR found | `_ar/spec-draft/BR/` directory listing (21 BR docs, none governing name/address/rc/email/phone/employment field validation for the applicant) |
| loading / error states | Uncertain — Evidence Pending | Not present in either capture |
