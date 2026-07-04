---
doc_id: WIRE0007
title: Application Wizard Step1 Story
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008a
realizes_uc: [UC0001]
status: draft
references:
  - UC0001
  - EN0001
  - EN0002
  - BR-ApplicationStatusGovernance
  - BR-ScoringAndRiskGating
  - BR-PartyIdentityAndDeduplication
---

# WIRE0007 – Application Wizard Step1 Story

## Purpose

Step 1 ("Krok 1: Váš příběh") of the 5-step public Application wizard at `/zadost-formular`. The
applicant (fundraiser role — parent/legal guardian, per IA `S008a`) captures the family/child
narrative and core child-identity fields that seed the fundraiser `ApplicationProfile` (`EN0002`) on
the just-created `Application` (`EN0001`). This screen is reached after the contact/consent gate
(`S007`, `UC0001` self-registration sub-flow) and is the first of five steps continuing the same
`UC0001` orchestration (Application created, profile filled progressively). No dedicated
"step-1-submit" use case exists in the UC layer; step progression itself is not modeled as a UC step
— see Open Questions. — Confirmed screen identity/URL; Assumed UC attribution granularity.
Evidence: `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` (empty),
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_29.png` (filled).

---

## Layout Zones

- **Global header** — site logo "patron dětí"; primary nav ("Jak to funguje", "Blog", "O nás");
  CTA button "Požádat o pomoc"; account link "Můj účet" — Confirmed. (Nav targets are IA concerns,
  not restated here.)
- **Stepper bar** — 5 numbered steps: "1 Příběh" (active/highlighted), "2 Dar", "3 O Vás",
  "4 Patron", "5 Přílohy" — Confirmed.
- **Page intro** — heading "Krok 1: Váš příběh"; two lines of instructional copy (multi-child
  guidance; "must be filled in Czech") — Confirmed (copy verbatim reproduced only to identify the
  zone; full copy is COPY layer's job).
- **Back link** — "← Krok zpět" above the form card — Confirmed.
- **Form card** (single white card, main content) — Confirmed:
  - Sub-zone A: family/situation narrative textarea (prompt "Řekněte nám více o sobě a o své
    rodině…") with char counter.
  - Sub-zone B: "Dovolte nám vaše dítě lépe poznat" — child identity fields (first name, last name,
    birth-number/insurance-number).
  - Sub-zone C: "Jaké je vaše dítě a co má rádo?" single-line text field.
  - Sub-zone D: health-disadvantage checkbox + conditional "specific health problem" textarea with
    char counter.
  - Sub-zone E: "Mate nebo měli jste sbírku u jiné nadace…" radio (ANO/NE) + a bold warning line
    about duplicate collections.
  - Sub-zone F: "Žádám o pomoc pro dítě, které nemá českou národnost" radio (ANO/NE).
  - Sub-zone G: primary CTA "Pokračovat" (bottom-right of card).
- **Global footer** — cookie banner, "patron dětí" org blurb, link columns ("Patron dětí", social;
  "Kontakt"), payment-provider badges, collection-account number, copyright — Confirmed. (Footer
  content/links are IA/COPY concerns; noted only as a layout zone.)

```
+--------------------------------------------------------------+
| Global header: logo | nav | "Požádat o pomoc" | "Můj účet"   |
+--------------------------------------------------------------+
| Stepper: (1)Příběh  2 Dar  3 O Vás  4 Patron  5 Přílohy       |
+--------------------------------------------------------------+
| "Krok 1: Váš příběh" (title + 2-line intro)                   |
| "← Krok zpět"                                                  |
+--------------------------------------------------------------+
| Form card:                                                     |
|  [A] Family/situation narrative textarea            0/500     |
|  "Dovolte nám vaše dítě lépe poznat"                           |
|  [B] Jméno | Příjmení   (child)                                |
|  [B] Rodné číslo dítěte (cizinec: číslo pojištěnce)            |
|  [C] Jaké je vaše dítě a co má rádo?                           |
|  [D] [ ] Je Vaše dítě zdravotně znevýhodněné?                  |
|      "S čím se vaše dítě potýká..." textarea         0/500     |
|  [E] Mate nebo měli sbírku u jiné nadace...  (o)ANO (o)NE       |
|      warning line (duplicate collection)                       |
|  [F] Žádám o pomoc pro dítě bez české národnosti (o)ANO (o)NE   |
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
| Stepper bar | inline | 5-step, numbered, active-state highlight (red filled circle vs grey outline) | Confirmed visual pattern; step labels "Příběh/Dar/O Vás/Patron/Přílohy" |
| Back link | inline | text link with left-arrow glyph | Confirmed |
| Narrative textarea (A) | inline | multiline textarea, placeholder text, live char counter "`n / 500`" | Confirmed |
| Child name fields (B) | inline | two side-by-side single-line text inputs (Jméno / Příjmení) | Confirmed |
| Child birth-number field (B) | inline | single-line text input, dual-label ("Rodné číslo dítěte (cizinec: číslo pojištěnce)") | Confirmed |
| "What is your child like" field (C) | inline | single-line text input with placeholder | Confirmed |
| Health-disadvantage checkbox (D) | inline | checkbox + label | Confirmed |
| Health-problem textarea (D) | inline | multiline textarea, placeholder, char counter "`n / 500`", sub-label question in bold + helper text | Confirmed |
| Prior-collection radio (E) | inline | 2-option radio group (ANO/NE), default NE pre-selected | Confirmed |
| Nationality radio (F) | inline | 2-option radio group (ANO/NE), default NE pre-selected | Confirmed |
| Primary CTA | inline | filled red button "Pokračovat" | Confirmed |
| Global footer | inline | cookie banner + link columns + payment badges | Confirmed, out of scope for this UC |

---

## Interactions

1. **Entry** — redirect from `S007` (`/zadost/zadatel` contact + consent gate) to
   `/zadost-formular` after `UC0001` self-registration sub-flow creates the `Application` (`EN0001`)
   and fundraiser `ApplicationProfile` (`EN0002`) — state: `default` (empty form, per
   `screencapture-…13_18_33.png`). Confirmed via IA §5 "Application intake flow".
2. **Primary action — "Pokračovat"** — trigger: click/tap → effect: submits step-1 field values
   (persisted onto `EN0002` fundraiser profile fields: `story_background`/`story_problems`
   narrative-equivalents, `child_first_name`, `child_last_name`, `child_rc`, `child_handicapped`,
   and the two ANO/NE flags — see Data Bindings) and advances the stepper to step 2 ("Dar",
   `S008b`) — Assumed persistence-on-continue behavior (not evidenced: no dossier confirms
   per-step save vs. single final submit; flagged as Open Question below).
3. **Secondary action — "Krok zpět"** — trigger: click → effect: navigates back one step; target
   screen not observed (step 1 is the first step, so this likely returns to `S007`) — Uncertain.
4. **Secondary interaction — health-disadvantage checkbox** — toggling "Je Vaše dítě zdravotně
   znevýhodněné?" is visually adjacent to the "Má vaše dítě specifický zdravotní problém?" textarea
   sub-label, but both screenshots show the checkbox unchecked while the sub-label/textarea are
   already rendered — Uncertain whether the textarea is conditionally shown/hidden by the checkbox
   or always visible (no unchecked-vs-checked comparison captured).
5. **Exit (success)** — advancing via "Pokračovat" leads to `S008b` (step 2, "Dar") — Confirmed
   sequence per IA §5.
6. **Exit (abandonment)** — closing/navigating away mid-wizard; resumption is handled by a separate
   draft-resume modal flow (`UC0025`, `EN0003` `ApplicationSession`) on a later visit — out of scope
   for this screen, referenced only.

---

## States

### default
Empty form with placeholder text in every free-text field, both radios pre-selected to "NE", char
counters at "0 / 500" — Confirmed
(`screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`).

### empty
Not distinguished from `default` in evidence — the "empty" capture *is* the default/unfilled state
described above. No separate zero-data empty-state treatment (e.g. no prior draft) was observed. —
`N/A — the observed "default" state already represents the unfilled/empty form; no distinct
empty-state visual exists in evidence.`

### loading
Not observed in either capture (both are static, fully rendered states; no spinner/skeleton/disabled
-button treatment during submission was captured). — `Evidence Pending — not captured.`

### error
Not observed. Neither screenshot shows a validation error, inline error message, or field-level error
styling (e.g. for an invalid `Rodné číslo dítěte`, or a story field exceeding 500 characters — the
second capture shows the top narrative textarea at exactly "500 / 500" with no error/blocking
styling, suggesting the counter may be a soft/informational limit rather than a hard cap, but this is
not confirmed either way). — `Evidence Pending — not captured.` — Uncertain whether 500 is a hard
max-length (input blocked) or a soft counter (submission-time validation only).

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| Narrative textarea (0/500) | No BR found — see validationsWithoutBR | inline char counter only; no error style observed |
| "S čím se vaše dítě potýká…" textarea (0/500) | No BR found — see validationsWithoutBR | inline char counter only; no error style observed |
| Child "Jméno"/"Příjmení" (required?) | No BR found — see validationsWithoutBR | not observed (no empty-submit attempt captured) |
| "Rodné číslo dítěte" (format / conditional requirement) | No BR found — see validationsWithoutBR; EN0002 Open Questions flags `child_rc` as "conditionally required" with the condition itself unconfirmed | not observed |
| Prior-collection radio (ANO/NE) | No BR found — see validationsWithoutBR | pre-selected default (NE); no validation state observed |
| Nationality radio (ANO/NE) | No BR found — see validationsWithoutBR | pre-selected default (NE); no validation state observed |
| "Pokračovat" submit gate (which fields block progression) | No BR found — see validationsWithoutBR | not observed |

No `BRxxxx` in the current BR layer (`BR-ApplicationStatusGovernance`, `BR-ScoringAndRiskGating`,
`BR-PartyIdentityAndDeduplication`, and the rest of `_ar/spec-draft/BR/_REGISTRY.md`) covers
field-level validation for this step's inputs (char limits, required-field gating, birth-number
format). This is recorded as an open question, not an invented rule.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Family/situation narrative textarea | `EN0002` (`story_background` / `story_problems` — narrative attributes) | — | exact attribute-to-field mapping is Assumed by name/purpose match, not code-line-confirmed for this specific textarea vs. the second one |
| Child "Jméno" / "Příjmení" | `EN0002` (`child_first_name`, `child_last_name`) | — | Confirmed field purpose match |
| "Rodné číslo dítěte (cizinec: číslo pojištěnce)" | `EN0002` (`child_rc`) | — | Confirmed field purpose match; conditional-requirement caveat per EN0002 Open Questions |
| "Jaké je vaše dítě a co má rádo?" | `EN0002` — no discrete attribute name matches this field in the current EN0002 attribute list | — | Uncertain — likely folded into a narrative/story attribute not individually named, or a field not yet modeled in EN0002; flagged as gap |
| "Je Vaše dítě zdravotně znevýhodněné?" checkbox | `EN0002` (`child_handicapped`) | — | Confirmed field purpose match |
| "S čím se vaše dítě potýká a jakou potřebuje pomoc?" textarea | `EN0002` (`story_problems` or `story_solution`) | — | Assumed — ambiguous which of the two narrative attributes this maps to |
| "Mate nebo měli jste sbírku u jiné nadace…" radio | `EN0002` — no matching attribute found | — | Uncertain — this flag is not present in the current EN0002 attribute inventory; gap between observed UI and reconstructed entity, recorded as Open Question |
| "Žádám o pomoc pro dítě, které nemá českou národnost" radio | `EN0002` — no matching attribute found | — | Uncertain — same gap as above |
| Application/session context (which `Application`/`ApplicationProfile` is being edited) | `EN0001`, `EN0002` | — | Confirmed at the entity level per `UC0001` postconditions (Application + fundraiser profile created before this step is reachable) |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Whole screen (`S008a`) | Reachable only after `S007` contact/consent gate completes and creates the Application; no ACL layer exists yet to cite a role gate | N/A — not observed as gated by an authenticated role; the applicant is the anonymous-turned-registering Customer per `UC0001` |
| "Krok zpět" link | Always visible in both captures | — |
| Health-problem textarea vs. checkbox state | Possibly checkbox-conditional (see Interactions §4) | Uncertain — not confirmed either way; no BR/ACL exists to cite |

No `ACLxxxx` layer exists in this reconstruction pass (per rules-WIRE.md and IA-Q4); no role-gating
beyond wizard-sequence reachability was observed for this screen.

---

## Accessibility Notes

- **Tab order:** Not evidenced from static screenshots — Assumed to follow visual top-to-bottom,
  left-to-right order (narrative textarea → child first/last name → birth number → "what is your
  child like" → health checkbox → health-problem textarea → prior-collection radio →
  nationality radio → "Pokračovat"), consistent with standard form markup, but not confirmed.
- **Focus on entry:** Uncertain — not observed.
- **Focus on state transition:** Uncertain — no state-transition (loading/error) was captured.
- **Landmarks:** Uncertain — semantic structure (headings, fieldsets, ARIA roles for the stepper)
  not determinable from a rendered screenshot.
- **Keyboard shortcuts:** None observed; none expected for a standard form screen.

---

## Open Questions

- Does "Pokračovat" persist step-1 data immediately (per-step save) or only on final wizard
  submission? Not evidenced by any UC/dossier — affects whether draft-resume (`UC0025`) can recover
  mid-step-1 data. (Also see IA-Q5 for the unresolved steps 4–5 content, and IA §5 for the wizard
  step sequence, which does not resolve this either.)
- Is the checkbox "Je Vaše dítě zdravotně znevýhodněné?" wired to conditionally show/hide the
  "S čím se vaše dítě potýká…" textarea, or is the textarea always rendered? Both captures show it
  unchecked with the textarea already visible.
- The "Mate nebo měli jste sbírku u jiné nadace v posledních 6 měsících?" and "Žádám o pomoc pro
  dítě, které nemá českou národnost" flags observed on screen have **no corresponding attribute** in
  the reconstructed `EN0002` ApplicationProfile attribute list — recorded as an EN/WIRE cross-layer
  gap, not resolved here (candidate for EN0002 follow-up, not invented in this WIRE doc).
  Similarly, "Jaké je vaše dítě a co má rádo?" has no confirmed 1:1 attribute match.
  See `validationsWithoutBR` below — no BR exists for any field-level validation on this screen.
- Whether the "0/500" counters are hard `maxlength` limits or soft/informational (submission-time)
  limits is unconfirmed; the second capture shows the top textarea at exactly 500/500 with no error
  styling, which is consistent with either interpretation.
- "Krok zpět" target from step 1 (back to `S007`, or elsewhere) is not confirmed by evidence.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen identity, URL, stepper, page title/intro copy | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
| Field labels, layout order, default state (empty) | Confirmed | same, §3 of `_ar/evidence/ui/ui-observed-areas.md` |
| Filled-state visuals, char counters near/at limit, tester identity data | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_29.png` (Kafka placeholder text = QA noise, not domain content) |
| Field-to-EN0002-attribute mapping | Assumed / Uncertain (mixed, see Data Bindings) | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md` |
| UC attribution (`UC0001`) | Confirmed at IA level, Assumed at step-granularity | `_ar/spec-draft/IA/IA-patronus.md` §3.3, §5; `_ar/spec-draft/UC/UC0001_SubmitApplication.md` |
| Validation rules (char limits, required fields, radio semantics) | Uncertain — no BR found | `_ar/spec-draft/BR/_REGISTRY.md` (no matching BR) |
| loading / error states | Evidence Pending — not captured | — |
| empty state (distinct from default) | N/A — default capture is the unfilled state | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
