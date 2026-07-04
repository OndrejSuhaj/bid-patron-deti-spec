---
doc_id: WIRE0006
title: Application Contact Consent Gate
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S007
realizes_uc: [UC0001]
status: draft
references:
  - UC0001
  - EN0001
  - EN0006
  - EN0008
  - IA-patronus (S006, S007, S008a)
---

# WIRE0006 – Application Contact Consent Gate

## Purpose

S007 is the fundraiser-role entry step of the Application (Žádost) self-registration flow at
`/zadost/zadatel`. It captures the minimum identifying contact data (e-mail + phone) and the
GDPR/marketing consent required before a Customer can proceed into the multi-step Application
wizard (S008a). It realizes the "Customer self-registration" sub-flow of `UC0001`
(UC0001.1, steps 1–3: opening the registration entry point, presenting the minimal registration
form, and submitting email/phone/consent). Actor: an anonymous visitor acting as prospective
fundraiser (`UC0001` "Customer"). Entry context: reached from the fundraiser-role card on the
role-choice landing screen (S006); a "Zpět na výběr" link returns there. **Confirmed** —
screenshot `screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_12.png`.

Open Question — a second screen was observed at the same route
(`screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_04.png`, "Co budete k vyplnění
žádosti potřebovat?" — a document-checklist interstitial with its own "Pokračovat" CTA) that is
**not** the screen cited by the IA/observed-areas evidence for S007. Whether it is a distinct
screen in the same flow (preceding this gate) or an alternate/AB state of `/zadost/zadatel` is
unresolved — it is not part of the IA Screen Map's S007 evidence and is out of scope for this WIRE;
flagging so it is not silently merged into S007's reconstruction. **Uncertain.**

---

## Layout Zones

- Header — global site navigation (logo "patron dětí", "Jak to funguje", "Blog", "O nás",
  "Požádat o pomoc" CTA, "Můj účet" link) — shared chrome, not reconstructed here (see IA). **Confirmed.**
- Icon / heading band — a people icon, H1 "Začneme tím, že nám sdělíte váš telefon a e-mail", and
  two lines of supporting copy (privacy assurance + document-readiness reminder). **Confirmed.**
- Back-navigation — "← Zpět na výběr" link, above the form panel, returning to S006. **Confirmed.**
- Form panel (card) — light-grey panel containing:
  - Panel heading "Údaje o Vás"
  - Two-field row: "E-mail" input, "+420"-prefixed "Telefon" input
  - Consent checkbox with inline link ("zpracováním osobních údajů") and helper line
    ("Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz.")
  - Primary CTA "Pokračovat"
  **Confirmed.**
- FAQ section — "Často kladené otázky" heading with two collapsed accordion items below the form
  panel. **Confirmed.**
- Footer — cookie banner, site footer columns (O nás/Blog/Pravidla/Naše desatero/Splněné
  příběhy/Výroční zprávy/…), contact e-mail, payment-provider badges, "Souhlas se zpracováním
  osobních údajů" / "Chci přihlásit příběh" footer links, copyright — shared chrome, not
  reconstructed here (see IA). **Confirmed.**

```
+--------------------------------------------------------+
| Header (logo, nav, Požádat o pomoc, Můj účet)           |
+--------------------------------------------------------+
|                    [icon]                               |
|      Začneme tím, že nám sdělíte váš telefon a e-mail    |
|          <privacy + document-readiness copy>            |
|  ← Zpět na výběr                                         |
+----------------------------------------------------------+
| Form panel                                                |
|   Údaje o Vás                                             |
|   [ E-mail            ] [ +420 | Telefon            ]     |
|   [ ] Souhlasím se zpracováním osobních údajů a...        |
|       Souhlasy můžete upravit/zrušit zasláním e-mailu...  |
|          [ Pokračovat ]                                   |
+----------------------------------------------------------+
|                Často kladené otázky                       |
|   > Proč musí mít každé dítě svou vlastní žádost o dar?    |
|   > Proč musí mít každý příběh svého Patrona?              |
+----------------------------------------------------------+
| Footer (cookie banner, link columns, contact, badges)      |
+----------------------------------------------------------+
```

---

## Components Used

Recurring elements promoted to COMP by **AR:COMPSynthesizer** (see `COMP-inventory-map.md`); all
other entries remain flagged `inline` (no ≥2-screen reuse evidenced).

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | COMP0002 | context=public | see `COMP0002` Global Site Header |
| Icon / heading band | inline | icon + H1 + 2 body lines | — |
| Back-navigation | inline | text link with leading arrow glyph | "← Zpět na výběr" |
| Form panel — E-mail field | inline | single-line text input, placeholder "E-mail" | no visible label above the field; placeholder doubles as label |
| Form panel — Phone field | inline | fixed "+420" prefix segment + single-line text input, placeholder "Telefon" | prefix appears non-editable (CZ-only observed); Uncertain whether RO/MD locales show a different prefix (Patronus operates CZ/RO/MD per project context) — Open Question, no evidence captured for non-CZ locale of this screen |
| Form panel — consent checkbox | COMP0006 | count-per-form=single | unchecked by default; see `COMP0006` Consent Checkbox |
| Form panel — CTA | COMP0001 | — | label "Pokračovat"; see `COMP0001` Primary Button |
| FAQ section | inline | accordion, 2 collapsed items | items: "Proč musí mít každé dítě svou vlastní žádost o dar?", "Proč musí mít každý příběh svého Patrona?" — collapsed state only observed, expanded content not captured |
| Cookie banner | COMP0004 | — | see `COMP0004` Cookie Consent Banner |
| Footer | COMP0003 | — | see `COMP0003` Global Site Footer |

---

## Interactions

1. **Entry** — navigation from S006's fundraiser-role card to `/zadost/zadatel` → state: `default`.
   **Confirmed** (IA entry-point table).
2. **Primary action — "Pokračovat"** — Customer fills e-mail + phone, checks the consent box, and
   submits → triggers `UC0001` (UC0001.1 steps 3–11: validation, email-domain check, User/Contact/
   Application creation, activation e-mail dispatch) → next: redirect into the Application wizard
   (S008a) per the IA entry-points table (`/zadost-formular` redirect from S007 after
   contact/consent). **Confirmed** for the redirect target; the intermediate validation/creation
   steps are UC0001-owned, not restated here.
3. **Secondary action — "Zpět na výběr"** — returns to the role-choice screen (S006). **Confirmed.**
4. **Secondary action — inline consent link ("zpracováním osobních údajů")** — opens the personal-data
   processing terms; destination content is COPY/legal-content territory, not reconstructed here.
   **Confirmed** (link present) / **Uncertain** (destination content/screen).
5. **Secondary action — FAQ accordion items** — expand/collapse; expanded content not captured.
   **Assumed** (standard accordion behavior; not observed expanded).
6. **Exit** — successful submission exits this screen via the primary action above; no other
   observed exit path besides "Zpět na výběr". **Confirmed.**

---

## States

### default
Empty form: both fields blank, consent checkbox unchecked, "Pokračovat" enabled/visible (its
disabled-until-valid state was not observed — see Validation Surfaces). **Confirmed** — screenshot
`screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_12.png`; UOA §6 records "initial/empty;
consent checkbox unchecked by default."

### empty
Not distinct from `default` for this screen — the screen has no listing/collection content that
could be empty; the form's blank starting point IS the default state. `N/A — no data-collection
zone with a distinct empty condition; see default state`.

### loading
Not observed. The primary action triggers `UC0001` processing (email validation via Integration,
User/Contact/Application creation) which is plausibly asynchronous, but no loading indicator,
disabled-button, or spinner state was captured. **Uncertain — Evidence Pending** (Open Question,
not fabricated).

### error
Not observed. No screenshot captures a validation-failure or submission-failure rendering (e.g.
invalid e-mail format, unchecked required consent, or the `UC0001` AF3 email-domain-validation
failure). **Uncertain — Evidence Pending** (Open Question, not fabricated). The existence of a
failure mode is corroborated by `UC0001` AF3 ("Email domain validation fails" → registration
blocked), but its on-screen presentation on S007 is not evidenced.

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| E-mail | none identified | Uncertain — no BR owns e-mail format/required validation for this screen; `UC0001` step 4 ("System validates the email format and required consents") confirms validation occurs but is UC-owned procedural behavior, not a BR; the on-screen surface (inline vs. toast vs. blocking) is not evidenced (Open Question, no screenshot of an error state) |
| Telefon | none identified | Uncertain — no BR governs phone format/requiredness on this screen; not evidenced as required vs. optional from the screenshot alone (no asterisk or "required" marker visible); on-screen surface not evidenced |
| Consent checkbox | none identified | Uncertain — `UC0001` step 4 groups "required consents" into the same validation step as the email, implying the checkbox is required to proceed, but no BR document owns a consent-requirement rule and no error-state screenshot confirms the enforcement or its surface |

**validationsWithoutBR:** E-mail (format/required), Telefon (format/required), Consent checkbox
(required-to-proceed) — all three are open questions: `UC0001` establishes that *system-side*
validation of email format and required consents occurs, but no `BRxxxx` document currently owns
the specific validation rule (e.g. permitted phone formats, whether phone is optional, minimum
consent set), and no on-screen error state was captured to evidence how a violation is surfaced.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| E-mail field | `EN0006` (Contact.Email) / `EN0008` (User) | — | on submission, seeds the Contact/User email per `UC0001` step 6–7 (lookup existing User by email, create Contact if none) |
| Telefon field | `EN0006` (Contact.Phone) | — | seeds the Contact's phone attribute (EN0006 "Phone (text; optional; not unique)") |
| Consent checkbox | — | — | no EN attribute identified for a stored consent flag/timestamp on Contact (EN0006) or User (EN0008) in the reviewed entity docs — Open Question: where is consent state persisted? Not evidenced in EN0006/EN0008 attribute lists reviewed for this WIRE |
| Form submission (as a whole) | `EN0001` (Application — created in initial status), `EN0006` (Contact — created/linked), `EN0008` (User — created/linked) | — | per `UC0001` UC0001.1 steps 6–11 |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | anonymous-only per `UC0001` precondition ("The visitor is anonymous... an already-authenticated Customer is routed directly into the Application without repeating identity capture", `UC0001` AF1) | an authenticated Customer bypasses S007 entirely and is routed directly into the Application (S008a) — no ACL doc exists to cite; recorded per `UC0001` precondition/AF1 text only |
| "Jste patron? Vaše žádost je ZDE" link | observed only on the adjacent `13_18_04` screenshot, not on the S007-evidenced (`13_18_12`) screenshot | not applicable to this WIRE's evidenced state — see Open Question in Purpose section about the two screenshots |

No ACL layer exists yet for this reconstruction pass (per cross-layer-discipline, ACL is a distinct
canonical layer not yet produced); role-gating above is recorded from `UC0001` prose only.

---

## Accessibility Notes

- **Tab order:** not evidenced from a static screenshot; presumed left-to-right, top-to-bottom
  (E-mail → Telefon → consent checkbox → Pokračovat) matching visual order. **Assumed.**
- **Focus on entry:** not evidenced. **Uncertain.**
- **Focus on state transition:** not evidenced (no error/loading state captured). **Uncertain.**
- **Landmarks:** not evidenced from the screenshot; standard header/main/footer landmark structure
  is assumed consistent with the rest of the site's shared chrome. **Assumed.**
- **Keyboard shortcuts:** none observed or expected for this screen type.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Layout / heading copy / form fields / consent checkbox / FAQ section | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_12.png`; `_ar/evidence/ui/ui-observed-areas.md` §6 |
| Back-navigation to S006, redirect to S008a wizard | Confirmed | `_ar/spec-draft/IA/IA-patronus.md` §4 Entry Points; `_ar/spec-draft/IA-screen-map.md` row S007 |
| Realizing UC and self-registration flow steps | Confirmed | `_ar/spec-draft/UC/UC0001_SubmitApplication.md` (UC0001.1, AF1, AF3) |
| Data bindings to Contact/User/Application | Probable | `_ar/spec-draft/EN/EN0006_Contact.md`; `_ar/spec-draft/UC/UC0001_SubmitApplication.md` steps 6–11 |
| Consent-state persistence location | Uncertain | not found in EN0006/EN0008 attribute lists reviewed; Open Question |
| loading / error states | Uncertain — Evidence Pending | no corroborating screenshot; `UC0001` AF3 confirms a failure mode exists but not its on-screen presentation |
| Validation rule ownership (BR) | Uncertain | no `BRxxxx` document found governing email/phone/consent validation on this screen; listed in `validationsWithoutBR` |
| Relationship of the `13_18_04` document-checklist screenshot to S007 | Uncertain | `13_18_04` not cited by `_ar/spec-draft/IA-screen-map.md` row S007 or by `ui-observed-areas.md` §6; recorded as an Open Question, not merged into this screen's reconstruction |
