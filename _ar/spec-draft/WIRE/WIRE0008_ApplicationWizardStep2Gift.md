---
doc_id: WIRE0008
title: Application Wizard Step2 Gift
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008b
realizes_uc: [UC0001]
status: draft
references:
  - UC0001
  - EN0001
  - EN0002
  - EN0033
  - IA-patronus (S008b, IA-Q5)
---

# WIRE0008 – Application Wizard Step2 Gift

## Purpose

Step 2 ("Dar, kterým vám pomůžeme") of the 5-step Application (Žádost) wizard at `/zadost-formular`.
The applicant (fundraiser, per `UC0001`) selects which in-kind gift/help category is being requested
for the child and supplies the category-specific detail needed to describe and cost that gift —
vendor/organiser contact, a free-text justification, a supporting-document upload, and the total
cost. The selected `gift_category`/`gift_subcategory` and the fields captured here are written onto
the fundraiser `ApplicationProfile` (`EN0002`) and classify the `Application` (`EN0001`) via the
`GiftCategory` taxonomy (`EN0033`). Entry context: reached from S008a (step 1, "Váš příběh") via
"Pokračovat"; exits forward to S008c (step 3, "Údaje o vás"). Confirmed — screenshot evidence.

---

## Layout Zones

- Header — global site nav ("Jak to funguje", "Blog", "O nás", "Požádat o pomoc" CTA, "Můj účet"). Confirmed.
- Stepper — 5-step progress indicator (Příběh ✓ done / **Dar** active / O Vás / Patron / Přílohy), each
  step labelled and numbered. Confirmed.
- Page title + back link — "Krok 2: Dar, kterým vám pomůžeme" heading; "← Krok zpět" link above the
  form card. Confirmed.
- Main content (form card) — "Rychlá volba daru:" category picker list, followed by a vertical stack
  of form fields that change per selected category, an attachment upload zone, a total-cost field, and
  the "Pokračovat" submit button. Confirmed.
- FAQ — "Často kladené otázky" accordion section below the form card. Confirmed (one collapsed
  question visible: "Proč vyžadujeme po všech obdarovaných důkaz o tom, jak dar využívají?" — content
  when expanded not captured).
- Footer — cookie-consent bar, site footer link columns (Patron dětí / Kontakt), payment-provider
  badges, collection-account number, copyright. Confirmed.

```
+--------------------------------------------------------------+
| Header (nav, Požádat o pomoc, Můj účet)                       |
+--------------------------------------------------------------+
| Stepper: (1 Příběh done) — (2 Dar active) — 3 — 4 — 5          |
+--------------------------------------------------------------+
| Krok 2: Dar, kterým vám pomůžeme            [← Krok zpět]      |
+----------------------------------------------------------------+
| Rychlá volba daru:                                              |
|  [ ŠVP, jazykový kurz, školní výlety      Více informací  Vybrat] |
|  [ Lyžařský kurz                          Více informací  Vybrat] |
|  [ Kroužky, soustředění a vybavení pro ně Více informací  Vybrat] |
|  [ Tábory – pobytové, příměstské          Více informací  Vybrat] |
|  [ Školné a internát                      Více informací  Vybrat] |
|  [ Notebook                               Více informací  Vybrat] |
|  [ Automobil jako zdravotní pomůcka       Více informací  Vybrat] |
|  [ Pomůcky a služby pro zdravotně znevýh. Více informací  Vybrat] |
|  [ Balík školních potřeb                  Více informací  Vybrat] |
|                                                                  |
|  Název a adresa školy poskytující aktivity  [____________]      |
|  Kontaktní osoba                            [____________]      |
|  Telefonní číslo na kontaktní osobu   [+420][____________]      |
|  E-mail na kontaktní osobu                  [____________]      |
|  Jak dar dítěti konkrétně pomůže?     [textarea........] 0/500  |
|  Zde přiložte přihlášku na školní akci ... [drag/drop 0/3]      |
|  Celková částka na pořízení daru      [______] Kč               |
|                                              [Pokračovat →]      |
+----------------------------------------------------------------+
| Často kladené otázky                                            |
+----------------------------------------------------------------+
| Footer (cookie bar, links, payment badges, copyright)           |
+----------------------------------------------------------------+
```

---

## Components Used

Recurring elements promoted to COMP by **AR:COMPSynthesizer** (see `COMP-inventory-map.md`); all
other entries remain flagged `inline` (no ≥2-screen reuse evidenced).

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | COMP0002 | context=public | see `COMP0002` Global Site Header |
| Stepper | COMP0005 | activeIndex=2, completedIndices=[1] | Step labels: Příběh / Dar / O Vás / Patron / Přílohy. See `COMP0005` Application Wizard Stepper. |
| Back link | inline | text link + arrow icon | "← Krok zpět". Confirmed. |
| Category picker row | inline | collapsed / expanded | 9 rows; expanded row shows description text + "Zobrazit méně". Confirmed. |
| Text input | inline | single-line | Used for org name, contact person, e-mail. Confirmed. |
| Phone input | inline | prefix "+420" + number field | Confirmed. |
| Textarea with counter | inline | `n/500` live counter | "Jak dar dítěti konkrétně pomůže?". Confirmed. |
| File-upload dropzone | COMP0007 | maxCount=3, currentCount=0 | see `COMP0007` File Upload Dropzone |
| Currency input | inline | numeric + "Kč" suffix | "Celková částka na pořízení daru". Confirmed. |
| Primary button | COMP0001 | — | label "Pokračovat"; see `COMP0001` Primary Button |
| FAQ accordion | inline | collapsed by default | Only one question visible; expand behaviour Assumed (not captured expanded). |
| Footer | COMP0003 | — | see `COMP0003` Global Site Footer |

---

## Interactions

1. **Entry** — arrives via "Pokračovat" from S008a (step 1) or "Krok zpět" from S008c (step 3); also
   directly navigable via the stepper once step 1 is complete → state: `default`. Confirmed (stepper
   shows step 1 as done-checkmark on arrival).
2. **Primary action — select a gift category** — click "Více informací" on a category row → row
   expands in place showing description text and re-labels the toggle to "Zobrapit méně"/"Zobrazit
   méně"; click "Vybrat" → selects that category (subcategory) as the active `gift_category`/
   `gift_subcategory` (`EN0033`) and reflows the field block below the picker according to that
   category's `parameters` override (field titles/placeholders/attachment cardinality/extra field) —
   realizes `UC0001`; next: fields below re-render, still on `default` state of this screen. Confirmed
   (Tábory example: org field retitles to "Název a adresa organizátora tábora", attachment retitles to
   "Zde přiložte přihlášku na tábor", and an added field "V jaké termínu se tábor uskuteční" appears).
3. **Secondary action — collapse category detail** — click "Zobrazit méně" on an expanded row →
   collapses back to the single-line row. Confirmed (label change only; visual result of collapse not
   separately captured, Assumed to mirror the pre-expansion row).
4. **Secondary action — attach files** — drag files onto the dropzone, or click "vyberte v počítači" →
   opens a native file picker; uploaded count increments the `n/3` counter. Probable (upload-success/
   thumbnail treatment not captured — only the empty `0/3` state is evidenced).
5. **Secondary action — navigate back** — click "← Krok zpět" (top) or "Krok zpět" is also reachable via
   the same label under the stepper per S008a; returns to S008a step 1, preserving entered data
   (persistence Assumed — not confirmed by evidence). 
6. **Exit / primary submit** — click "Pokračovat" → validates the visible field set for the selected
   category, then advances to S008c (step 3, "Údaje o vás"); realizes `UC0001`; next: S008c. Confirmed
   for the navigation target (stepper order); validation behavior on submit is Assumed (see States →
   error).

---

## States

### default
Category picker shows all 9 categories collapsed, "Rychlá volba daru:" heading, and — per the two
captures — the field block is already rendered below the picker even before a category is explicitly
"Vybrat"-confirmed, pre-populated with the first/default category's generic field set (org name,
contact person, phone, e-mail, "Jak dar dítěti konkrétně pomůže?", attachment, total cost). Confirmed
— screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png.

### empty
Same as `default` for a first-time visit to this step: all text/phone/e-mail fields show placeholder
text only (no values), textarea counter at `0/500`, upload counter at `0/3`, no category expanded.
Confirmed — screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png (this capture IS the
empty state; `default` and `empty` are the same visual state here — no separate "returning with
saved data" capture exists to show a pre-filled variant).

### loading
Not observed. No spinner/skeleton/disabled-button treatment was captured for category-selection,
file-upload, or step-submit transitions. `N/A — Evidence Pending: no loading-state screenshot exists
for this screen; both captures show a fully rendered, idle UI.`

### error
Not observed. No validation-error banner, inline field error, or red-outline state was captured on
this screen (contrast with S010's red-bordered password field, which IS observed elsewhere). Whether
"Pokračovat" is blocked client-side when required fields/consents are missing, and how an error is
surfaced, is `N/A — Evidence Pending: no error/invalid submission was captured for step 2`. Uncertain.

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| "Jak dar dítěti konkrétně pomůže?" textarea | no BR — see validationsWithoutBR | inline (live `n/500` character counter) |
| Attachment dropzone | no BR — see validationsWithoutBR | inline (live `n/3` file counter) |
| "Celková částka na pořízení daru" (gift_price) | no BR — see validationsWithoutBR | Uncertain — no error/minimum-amount enforcement observed on this screen (EN0002 notes a minimum-price floor exists but does not cite where it is enforced) |
| Category selection (must pick one to proceed) | no BR — see validationsWithoutBR | Uncertain — not observed whether "Pokračovat" is blocked without an explicit "Vybrat" click |
| Phone / e-mail contact fields (format) | no BR — see validationsWithoutBR | Uncertain — no format-validation feedback captured |

No `BRxxxx` document in `_ar/spec-draft/BR/` currently governs application-wizard field-level input
validation (character/file-count limits, gift-price minimum enforcement point, or required-field
gating on step submit). `EN0002` (ApplicationProfile) notes `gift_price` "is subject to a
minimum-price constraint" and `EN0033` (GiftCategory) documents the per-category field-override
mechanism, but neither is a BR-owned validation rule.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Category picker (9 rows + expand/description) | EN0033 | — | GiftCategory taxonomy: top-level `category` terms rendered as rows; `body` field is the expandable description text. |
| Category-dependent field relabelling (e.g. Tábory) | EN0033 | — | Driven by the selected subcategory's `parameters` override (title/placeholder/cardinality/validate keys per EN0033). |
| Org name / contact person / phone / e-mail fields | EN0002 | — | `ApplicationProfile.gift_supplier`-adjacent free-text vendor/contact fields (field-name-level mapping not confirmed by evidence; Assumed correspondence to the "requested gift" attribute cluster). |
| "Jak dar dítěti konkrétně pomůže?" textarea | EN0002 | — | `gift_note` (per EN0033 override-key list: `gift_note` is a documented overridable key). |
| Attachment dropzone | EN0002 | — | one of `gift_price_attachment` / `attachment_1..6` (exact field-to-slot mapping not confirmed by evidence). |
| "Celková částka na pořízení daru" | EN0002 | — | `gift_price`. |
| Selected category/subcategory (persisted) | EN0002 | — | `gift_category`, `gift_subcategory`. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Category-specific extra field (e.g. "V jaké termínu se tábor uskuteční") | no ACL/BR — driven by `EN0033` `parameters.validate`/field-override contract, not a role or business rule | field absent from the block until that subcategory is selected |
| Field relabelling (org/attachment titles) | no ACL/BR — `EN0033` `parameters` override, per selected subcategory | falls back to the ApplicationProfile default label when no override entry exists |

No role-gating is observed on this screen (it is part of the anonymous/self-registering fundraiser
flow per `UC0001`); the ACL layer does not exist in this reconstruction. The conditional behavior
here is content-driven (taxonomy configuration), not access-driven.

---

## Accessibility Notes

- **Tab order:** Uncertain — not confirmable from static screenshots; visually implies header nav →
  back link → category rows (Více informací / Vybrat per row) → form fields top-to-bottom → upload
  control → cost field → Pokračovat button, but actual DOM/tab order is unverified.
- **Focus on entry:** Uncertain — not evidenced.
- **Focus on state transition:** Uncertain — no re-render/expand-collapse focus behavior captured.
- **Landmarks:** Uncertain — not evidenced from screenshots (would require DOM/code inspection, out of
  scope for this WIRE pass per screenshot-only evidence convention).
- **Keyboard shortcuts:** None observed; no evidence either way.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Layout zones, stepper, category picker structure | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png` |
| Category expand/collapse + per-category field relabelling (Tábory) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_57.png` |
| Field labels, placeholders, counters (0/500, 0/3) | Confirmed | both screenshots above; `ui-observed-areas.md` §4 |
| GiftCategory taxonomy / parameters-override mechanism | Confirmed (code-level, per EN0033) | `_ar/spec-draft/EN/EN0033_GiftCategory.md` |
| loading state | N/A — Evidence Pending | no capture exists |
| error / validation-failure state | Uncertain | no capture exists |
| Data-field-to-EN0002-attribute exact mapping (contact/attachment fields) | Assumed | inferred from EN0002 attribute list + EN0033 override-key names; not a confirmed 1:1 code mapping |
| Accessibility (tab order, focus, landmarks) | Uncertain | not evidenced by screenshots |
