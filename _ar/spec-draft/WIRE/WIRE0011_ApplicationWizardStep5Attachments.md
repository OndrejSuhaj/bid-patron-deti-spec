---
doc_id: WIRE0011
title: Application Wizard Step5 Attachments
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008e
realizes_uc: [UC0001]
status: draft
references:
  - UC0001
  - EN0001
  - EN0002
  - IA-patronus (S008e, IA-Q5)
---

# WIRE0011 – Application Wizard Step5 Attachments

## Purpose

Step 5 ("Přílohy") — the final step of the 5-step Application (Žádost) wizard at `/zadost-formular`.
The applicant (fundraiser, per `UC0001`) uploads the mandatory image/document attachments needed to
publish the child's story and verify identity: at least one image of the child (photo, child's own
drawing, or a photographed message), a photo of the applicant's identity document, and a photo/copy of
the child's birth certificate (or a custody ruling). The step also collects a "how did you hear about
us" referral field and the three final consent checkboxes, then submits the completed Application.
Entry context: reached from S008d (step 4, "Patron") via "Pokračovat"; this is the last step — its
primary action ("Odeslat") is the terminal submit of the wizard, realizing `UC0001`. This screen was
previously recorded in `IA-patronus.md` (IA-Q5) as evidenced only by its stepper label; the screenshots
used for this WIRE pass are a newer, fuller capture of the step content — see Evidence.

---

## Layout Zones

- Header — global site nav ("Jak to funguje", "Blog", "O nás", "Požádat o pomoc" CTA, "Můj účet").
  Confirmed.
- Stepper — 5-step progress indicator (Příběh ✓ / Dar ✓ / O Vás ✓ / Patron ✓ done — **Přílohy** active,
  shown as numbered circle "5"). Confirmed.
- Page title + intro + back link — "Krok 5: Přílohy a fotografie" heading; one-paragraph instruction
  explaining the two mandatory attachment categories (child photo, ID + birth certificate); "← Krok
  zpět" link above the form card. Confirmed.
- Main content (form card) — three stacked upload sections, each with a heading, instructional text,
  and a dropzone showing labelled "PŘÍKLAD" (example) thumbnail images; below them a referral-source
  dropdown, three consent checkboxes, and the "Odeslat" submit button. Confirmed.
- Exit-confirmation modal (overlay) — triggered independently of this step's own controls (see Open
  Question below); offers "Zpět do žádosti" / "Opustit žádost" / "Smazat žádost". Confirmed as a
  distinct overlay state.
- Footer — cookie-consent bar, site footer link columns (Patron dětí / Kontakt), payment-provider
  badges, collection-account number, copyright. Confirmed.

```
+--------------------------------------------------------------+
| Header (nav, Požádat o pomoc, Můj účet)                       |
+--------------------------------------------------------------+
| Stepper: (1 Příběh done)-(2 Dar done)-(3 O Vás done)-          |
|          (4 Patron done)-(5 Přílohy active)                    |
+--------------------------------------------------------------+
| Krok 5: Přílohy a fotografie                    [← Krok zpět] |
| Pro zveřejnění příběhu... nahrajte fotografii... a dvě povinné |
| přílohy: občanský průkaz a rodný list dítěte.                  |
+--------------------------------------------------------------+
| Povinné obrazové přílohy                                       |
| Každý příběh musí obsahovat alespoň jeden obrázek... (1/2/3)   |
| [ dropzone: "Sem přetáhněte soubory... nebo vyberte v počítači" |
|   PŘÍKLAD  PŘÍKLAD                                    0 / 5 ]  |
|                                                                  |
| Fotka Vašeho dokladu totožnosti s fotkou (občanský průkaz, pas):|
| [ dropzone                                                      |
|   PŘÍKLAD  PŘÍKLAD                                    0 / 2 ]  |
|                                                                  |
| Fotka nebo kopie rodného listu dítěte, případně rozhodnutí      |
| soudu o svěření do péče.                                        |
| [ dropzone                                                      |
|   PŘÍKLAD                                             0 / 2 ]  |
|                                                                  |
| Odkud jste se dozvěděli o projektu Patron dětí?  [dropdown v]  |
| [ ] Prohlašuji, že jsem uvedl/a přesné, pravdivé a úplné údaje. |
| [ ] Prohlašuji, že jsem se seznámil/a s pravidly poskytování... |
| [ ] Souhlasím se zpracováním osobních údajů.                    |
|                                                        [Odeslat]|
+--------------------------------------------------------------+
| Footer (cookie bar, links, payment badges, copyright)           |
+--------------------------------------------------------------+
```

---

## Components Used

Recurring elements promoted to COMP by **AR:COMPSynthesizer** (see `COMP-inventory-map.md`); all
other entries remain flagged `inline` (no ≥2-screen reuse evidenced).

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | COMP0002 | context=public | see `COMP0002` Global Site Header |
| Stepper | COMP0005 | activeIndex=5, completedIndices=[1,2,3,4] | see `COMP0005` Application Wizard Stepper |
| Back link | inline | text link + arrow icon | "← Krok zpět". Confirmed. |
| Instructional heading + body text | inline | static copy block | Explains the mandatory-image rule (3 numbered options) above the first dropzone. Confirmed. |
| File-upload dropzone | COMP0007 | maxCount=5/2/2, currentCount=0, exampleThumbnails=yes | Three instances with cardinalities `0/5`, `0/2`, `0/2`. See `COMP0007` File Upload Dropzone. |
| Referral-source select | inline | native `<select>` dropdown, no default option selected | "Odkud jste se dozvěděli o projektu Patron dětí?". Confirmed. |
| Consent checkbox (×3) | COMP0006 | count-per-form=triple | Links: "přesné, pravdivé a úplné údaje", "pravidly poskytování pomoci", "zpracováním osobních údajů" — link targets not evidenced on this screen (Uncertain). See `COMP0006` Consent Checkbox. |
| Primary button | COMP0001 | — | "Odeslat" — terminal submit of the wizard. See `COMP0001` Primary Button. |
| Exit-confirmation modal | inline | overlay dialog: icon, heading "Chystáte se opustit žádost.", body text, "Zpět do žádosti" (primary) / "Opustit žádost" (text link) actions, secondary "Smazat žádost" link, close (×) control | Confirmed as an overlay state captured on this same route; the in-page trigger control for this modal is not visible in either capture (Open Question — see Interactions). |
| Footer | COMP0003 | — | see `COMP0003` Global Site Footer |

---

## Interactions

1. **Entry** — arrives via "Pokračovat" from S008d (step 4, "Patron"); also directly navigable via the
   stepper once prior steps are complete → state: `default`. Confirmed (stepper shows steps 1–4 as
   done-checkmarks, step 5 as the active numbered circle, on arrival).
2. **Primary action — upload attachment** — drag files onto a dropzone, or click "vyberte v počítači" →
   opens a native file picker; uploaded count increments the zone's `n/N` counter (5 for the image
   zone, 2 for the ID zone, 2 for the birth-certificate zone). Probable (upload-success/thumbnail
   treatment not captured — only the empty `0/N` state with static "PŘÍKLAD" example images is
   evidenced).
3. **Secondary action — select referral source** — open the "Odkud jste se dozvěděli..." dropdown and
   choose a value. Probable (dropdown options not captured — closed/unselected state only).
4. **Secondary action — toggle consent checkbox** — click one of the three checkboxes to accept its
   statement (truthful data / platform rules / personal-data processing); the embedded links open the
   referenced document/policy in a new context (not evidenced — target unconfirmed). Confirmed
   (checkbox presence and unchecked state); link-open behavior Uncertain.
5. **Secondary action — navigate back** — click "← Krok zpět" → returns to S008d step 4, preserving
   entered data (persistence Assumed — not confirmed by evidence).
6. **Exit / terminal submit** — click "Odeslat" → validates the visible required attachments/
   checkboxes, then submits the completed Application; realizes `UC0001`; next: post-submission
   confirmation screen — **not evidenced by this capture set** (Open Question: no confirmation/thank-you
   screen for the application wizard has been captured; contrast with `WIRE0003` which covers the
   donation, not application, thank-you page).
7. **Independent modal interaction — leave-application prompt** — the exit-confirmation modal
   ("Chystáte se opustit žádost.") is captured as an overlay on top of this exact step-5 page state,
   but no in-page trigger (e.g. a browser back/close button, a nav-away click) is visible in either
   screenshot. **Open Question:** which action triggers this modal on this screen (browser
   back-navigation, an unseen "×" affordance, clicking the header logo/nav) is Uncertain. Once shown:
   "Zpět do žádosti" dismisses the modal back to `default`; "Opustit žádost" leaves the wizard
   (application draft preserved per the modal's own copy, "s výjimkou příloh", i.e. attachments
   uploaded so far are explicitly stated as NOT preserved); "Smazat žádost" is a distinct destructive
   secondary path (deletes the application entirely — target/confirmation flow not captured); "×"
   closes the modal (same effect as "Zpět do žádosti", Assumed).

---

## States

### default
All three dropzones empty (`0/5`, `0/2`, `0/2`), showing only their static "PŘÍKLAD" example
thumbnails (not real uploaded files), the referral dropdown unselected, and all three consent
checkboxes unchecked. Confirmed —
`screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_23_13.png`.

### empty
Same as `default` for a first-time visit to this step (no separate "returning with saved data" capture
exists to show a pre-filled variant with previously uploaded attachments or a previously chosen
referral value). Confirmed — same screenshot as `default`; this capture IS the empty state.

### loading
Not observed. No spinner/skeleton/disabled-button treatment was captured for file-upload-in-progress
or the "Odeslat" submit transition. `N/A — Evidence Pending: no loading-state screenshot exists for
this screen; both captures show a fully rendered, idle UI (one plain, one with the exit modal
overlaid).`

### error
Not observed. No validation-error banner, inline field error, or red-outline state was captured on
this screen (contrast with S010's red-bordered password field, evidenced elsewhere). Whether "Odeslat"
is blocked client-side when required attachments/checkboxes are missing, and how an error is surfaced,
is `N/A — Evidence Pending: no error/invalid submission was captured for step 5`. Uncertain.

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| Povinné obrazové přílohy dropzone (child image, 0/5) | no BR — see validationsWithoutBR | Uncertain — instructional copy states "every story must contain at least one image," but no inline/error enforcement was observed |
| Fotka dokladu totožnosti dropzone (ID photo, 0/2) | no BR — see validationsWithoutBR | Uncertain — instructional copy states this attachment is mandatory ("dvě povinné přílohy"), but no inline/error enforcement was observed |
| Fotka/kopie rodného listu dropzone (0/2) | no BR — see validationsWithoutBR | Uncertain — same as above; mandatory per instructional copy, enforcement not observed |
| "Odkud jste se dozvěděli..." referral dropdown | no BR — see validationsWithoutBR | Uncertain — required/optional status not observed |
| "Prohlašuji, že jsem uvedl/a přesné, pravdivé a úplné údaje" checkbox | no BR — see validationsWithoutBR | Uncertain — corresponds to `EN0002` `agreement_truthfulness`, which EN0002 documents as entity-required, but no BR governs the screen-level enforcement/error surface, and no inline error was observed |
| "Prohlašuji, že jsem se seznámil/a s pravidly poskytování pomoci" checkbox | no BR — see validationsWithoutBR | Uncertain — corresponds to `EN0002` `agreement_rules` (documented as optional at the entity level); required/optional status on this screen is not observed |
| "Souhlasím se zpracováním osobních údajů" checkbox | no BR — see validationsWithoutBR | Uncertain — corresponds to `EN0002` `agreement_personal_data` (documented as optional at the entity level); required/optional status on this screen is not observed |

No `BRxxxx` document in `_ar/spec-draft/BR/` currently governs application-wizard field-level input
validation (required-attachment gating, consent-checkbox enforcement, or referral-field requirement on
step submit). `EN0002` (ApplicationProfile) documents `agreement_truthfulness` as entity-required and
the various `attachement_*`/`attachments_*` fields as entity-optional, but neither is a BR-owned
validation rule, and none of it confirms the screen-level (client-side) enforcement behavior.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Povinné obrazové přílohy dropzone (child image/drawing/message) | EN0002 | — | `attachement_child_photo` (per EN0002 attribute list); exact field-to-slot mapping among the sibling `attachment_1..attachment_6`/`custom_attachment` fields is not confirmed by evidence — Assumed correspondence. |
| Fotka dokladu totožnosti dropzone (applicant ID) | EN0002 | — | `attachement_id_copy` (per EN0002 attribute list); Assumed correspondence. |
| Fotka/kopie rodného listu dítěte dropzone | EN0001 / EN0002 | — | Code confirms this step corresponds to "attachments/employment registration" per `IA-patronus.md` IA-Q5 (`attachments_employment_registration` on EN0002, or the general `attachments` field on EN0001); the birth-certificate-specific slot is not confirmed by a distinct field name — Uncertain field-to-attribute mapping. |
| "Odkud jste se dozvěděli o projektu Patron dětí?" dropdown | EN0002 | — | No matching attribute name is documented on EN0002's attribute list; this field is Uncertain — possibly `EN0001`-level lead-source data (UC0001 step 8 records "lead source" on Application) or an unmodelled attribute. Open Question. |
| "Prohlašuji... přesné, pravdivé a úplné údaje" checkbox | EN0002 | — | `agreement_truthfulness`. |
| "Prohlašuji... pravidly poskytování pomoci" checkbox | EN0002 | — | `agreement_rules`. |
| "Souhlasím se zpracováním osobních údajů" checkbox | EN0002 | — | `agreement_personal_data`. |
| "Odeslat" submit → Application creation/completion | EN0001 | — | Final step of the wizard; realizes `UC0001` (Application (EN0001) reaches a submitted/complete status — the exact status-transition value is UC0001/EN0001-owned, not restated here). |

---

## Conditional Visibility

No role-gating or conditional field visibility was observed on this screen (it is part of the
anonymous/self-registering fundraiser flow per `UC0001`, same as S008a–S008d); the ACL layer does not
exist in this reconstruction. All three upload sections, the referral dropdown, and all three consent
checkboxes are shown unconditionally in both captures.

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| (none observed) | — | — |

---

## Accessibility Notes

- **Tab order:** Uncertain — not confirmable from static screenshots; visually implies header nav →
  back link → dropzone 1 (upload trigger link) → dropzone 2 → dropzone 3 → referral dropdown → consent
  checkboxes top-to-bottom → Odeslat button, but actual DOM/tab order is unverified.
- **Focus on entry:** Uncertain — not evidenced.
- **Focus on state transition:** Uncertain — no upload-success or checkbox-toggle focus behavior
  captured. For the exit-confirmation modal, focus presumably moves into the dialog on open (has a
  visible close "×" and two primary actions) but this is Assumed, not confirmed by evidence.
- **Landmarks:** Uncertain — not evidenced from screenshots (would require DOM/code inspection, out of
  scope for this WIRE pass per screenshot-only evidence convention).
- **Keyboard shortcuts:** None observed; no evidence either way. The exit-confirmation modal's dismiss
  behavior on Escape is Assumed (standard modal pattern), not confirmed.

---

## Open Questions

- What actually triggers the "Chystáte se opustit žádost." exit-confirmation modal on this screen? No
  in-page control that opens it is visible in either capture (see Interactions §7).
- Does "Odkud jste se dozvěděli o projektu Patron dětí?" bind to a documented `EN0002`/`EN0001`
  attribute, or is it an unmodelled field? No matching attribute name was found in the EN layer.
- Are the three upload dropzones and the three consent checkboxes actually required to submit, and how
  is a missing-required-attachment/consent error surfaced? Not observed (see Validation Surfaces).
- What does the post-"Odeslat" confirmation/thank-you screen for the Application wizard look like? Not
  captured in this evidence set (distinct from the donation thank-you page, `WIRE0003`).
- Does the birth-certificate dropzone map to `attachments_employment_registration` (the field name
  IA-Q5 associates with step 5) or a different EN0002 attachment field? The label on screen ("rodný
  list dítěte" / child's birth certificate) does not obviously correspond to an "employment
  registration" field name — Conflict between the field name inferred from code (IA-Q5) and the
  observed on-screen label; requires clarification.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Layout zones, stepper (step 5 active, steps 1–4 done), page title, intro copy | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_23_13.png` |
| Three upload dropzones, labels, cardinalities (0/5, 0/2, 0/2), "PŘÍKLAD" example thumbnails | Confirmed | same screenshot |
| Referral dropdown, three consent checkboxes, "Odeslat" button | Confirmed | same screenshot |
| Exit-confirmation modal (overlay on the same step-5 page) | Confirmed (as an overlay state) | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_23_21.png` |
| In-page trigger for the exit-confirmation modal | Uncertain | not visible in either screenshot |
| Upload-success/thumbnail treatment after a real file is added | Probable | not captured — only the empty `0/N` state is evidenced |
| Field-to-EN0002-attribute exact mapping (attachments, referral field) | Assumed / Uncertain | inferred from `EN0002` attribute list and `IA-patronus.md` IA-Q5; not a confirmed 1:1 code mapping |
| loading state | N/A — Evidence Pending | no capture exists |
| error / validation-failure state | Uncertain | no capture exists |
| Accessibility (tab order, focus, landmarks) | Uncertain | not evidenced by screenshots |
| Prior IA record of this screen as "stepper-only, fields not captured" | superseded by this pass | `_ar/spec-draft/IA/IA-patronus.md` §3.3/§8 IA-Q5, `_ar/evidence/ui/ui-observed-areas.md` line 151 — both predate the two screenshots used here, which show the full step-5 content |
