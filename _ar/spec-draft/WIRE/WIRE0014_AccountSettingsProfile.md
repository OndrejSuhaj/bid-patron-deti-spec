---
doc_id: WIRE0014
title: Account Settings Profile
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S011
realizes_uc: [UC0024]
status: draft
references:
  - UC0024
  - EN0006
  - EN0008
  - IA-patronus
---

# WIRE0014 – Account Settings Profile

## Purpose

The authenticated account-settings screen at `/muj-ucet/nastaveni` ("Nastavení účtu"), where a
logged-in party (donor/supporter, patron, or fundraiser — any authenticated User, `EN0008`) views
and edits their own name and profile photo. It realizes `UC0024` sub-flow UC0024.1 (view own
profile) and UC0024.2 (edit own profile: name, photo) — see that UC for the full actor/system
contract; this document covers only the screen surface. Entry context: authenticated navigation via
the "Můj účet" account-zone link (see `IA-patronus.md` §3.6, §5 login/return flows). **Confirmed** —
`_ar/prtsc/po_prihlaseni_do_uctu_nastaveni.png`.

Note: the screen also displays an "E-mail" field, but per `UC0024` AF2 this field is a **current-state
gap** — no observed profile-update contract accepts an e-mail change from this screen. This WIRE
documents the field as rendered; its non-functional write path is UC0024's finding, not restated here
beyond the validation-surface note below.

---

## Layout Zones

**Confirmed** — `po_prihlaseni_do_uctu_nastaveni.png`.

- **Header (global nav)** — logo "patron dětí"; primary nav links "Jak to funguje", "Blog", "O nás";
  CTA button "Požádat o pomoc"; authenticated account-menu link "Můj účet" (person icon).
- **Page title zone** — heading "Nastavení účtu"; sub-heading copy "Potřebujete něco změnit? Udělejte
  to tady."
- **Main content — profile form panel** (single light-grey card, left-aligned, no visible sidebar):
  - Name field group — label "Vaše jméno a příjmení"; two side-by-side text inputs, placeholders
    "Jméno" / "Příjmení".
  - E-mail field group — label "Váš e-mail"; single text input, placeholder "E-mail".
  - Profile-photo field group — label "Změnit profilovou fotku"; drag-and-drop upload zone with
    upload icon, copy "Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v
    počítači." (link-styled "vyberte v počítači"), and a file-count indicator "0 / 1".
  - Primary action button "Uložit změny" below the form.
- **Footer promo band** — cross-sell banner "Víte o dítěti, které potřebuje pomoci?" (not part of the
  settings form; shared site-footer chrome per `IA-patronus.md` §2).

No sidebar is present on this screen (single-column form layout).

```
+--------------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | [Požádat o     |
|         pomoc] | Můj účet                                    |
+--------------------------------------------------------------+
| Nastavení účtu                                                |
| Potřebujete něco změnit? Udělejte to tady.                    |
+--------------------------------------------------------------+
| Main content (card):                                          |
|   Vaše jméno a příjmení                                        |
|   [ Jméno ]        [ Příjmení ]                                |
|                                                                 |
|   Váš e-mail                                                    |
|   [ E-mail                                    ]                |
|                                                                 |
|   Změnit profilovou fotku                                      |
|   +------------------------------------------------+          |
|   |  ⬆  Sem přetáhněte soubory ... vyberte v        |          |
|   |     počítači.                          0 / 1     |          |
|   +------------------------------------------------+          |
|                                                                 |
|   [ Uložit změny ]                                             |
+--------------------------------------------------------------+
| Footer promo band: "Víte o dítěti, které potřebuje pomoci?"    |
+--------------------------------------------------------------+
```

---

## Components Used

The COMP layer does not yet exist for this reconstruction pass; every element is flagged `inline`.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | inline | global site nav + auth account-menu link | Shared chrome across authenticated screens (`IA-patronus.md`); not this screen's concern beyond entry point |
| Page title | inline | H1 + sub-copy | "Nastavení účtu" / "Potřebujete něco změnit? Udělejte to tady." |
| Main — name field group | inline | two-column text-input pair, labeled | "Jméno" / "Příjmení" |
| Main — e-mail field group | inline | single text input, labeled | "E-mail" — see Validation Surfaces re: non-functional write path |
| Main — photo upload | inline | drag-and-drop file dropzone, 0/1 count | Same generic upload-widget pattern as observed on the application-form attachment step (`_ar/evidence/ui/ui-observed-areas.md` §11 evidence note) — reused copy, not confirmed as a shared component |
| Main — submit | inline | primary button | "Uložit změny" |
| Footer | inline | promo/cross-sell band | "Víte o dítěti, které potřebuje pomoci?" — shared footer chrome, not screen-specific |

---

## Interactions

1. **Entry** — authenticated navigation to `/muj-ucet/nastaveni` via the "Můj účet" account-menu link
   (route confirmed in `IA-patronus.md` §4) → state: `default`. **Confirmed** (route + entry link),
   **Assumed** (whether fields arrive pre-filled with the caller's current profile values — the
   captured screenshot shows all fields with placeholder text only, not populated values; `UC0024.1`
   step 4 says "sees the rendered profile form (pre-fillable)" but does not confirm pre-filled vs.
   blank-with-placeholder rendering in this specific capture — see States/empty below).
2. **Primary action — Uložit změny** — Customer clicks "Uložit změny" → submits changed name
   field(s) and/or a newly attached profile-photo file reference; realizes `UC0024` (UC0024.2) →
   next: same screen, `default` state reflecting saved values (no distinct confirmation screen or
   toast observed — **Uncertain**, not captured).
3. **Secondary action — Photo upload** — Customer drags a file onto the dropzone or clicks "vyberte v
   počítači" → opens a file picker / accepts the drop; on success the "0 / 1" counter is expected to
   update to "1 / 1" (**Assumed** — post-upload visual state not captured).
4. **Exit** — Customer navigates away via header nav (e.g. back to "Můj účet", or any global nav
   link) → leaves the screen with no observed unsaved-changes guard (**Uncertain** — not evidenced
   either way).

---

## States

### default
The form renders with the "Vaše jméno a příjmení" (Jméno/Příjmení), "Váš e-mail", and "Změnit
profilovou fotku" (0/1) field groups and the "Uložit změny" button, as captured. **Confirmed** —
`po_prihlaseni_do_uctu_nastaveni.png`.

### empty
All three text-style fields (Jméno, Příjmení, E-mail) show only grey placeholder text with no visible
input value in the capture — this is the only state captured, and it is **Uncertain** whether it
represents (a) a true first-time-empty profile, (b) placeholders rendered as visual mock/never-filled
sample content, or (c) a rendering artifact where actual values did not load at capture time. Per
`UC0024.1`, the profile read-model returns the caller's own first name/last name/e-mail, so a
logged-in party with existing values would be expected to see them pre-filled; this is not confirmed
by the evidence in hand. Flagged as an Open Question below rather than asserted either way.

### loading
Not captured. `N/A — Evidence Pending`: no loading/skeleton state was observed for either the
initial form-fetch or the post-submit save request.

### error
Not captured. `N/A — Evidence Pending`: no field-level or form-level error state (e.g. failed save,
invalid input, upload rejection) was observed in the available screenshots.

---

## Validation Surfaces

No BR document in `_ar/spec-draft/BR/` covers field-level validation for this screen's inputs (name,
e-mail, photo). The following validation-relevant behaviors are recorded as **open questions without
a BR** rather than invented:

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| Jméno / Příjmení | none found | Uncertain — no client-side or server-side validation rule for name fields is evidenced; `UC0024.2` states unrecognized/absent fields are simply left unchanged (AF1), but does not describe format validation |
| E-mail | none found | Uncertain — per `UC0024` AF2, the e-mail field is **not an accepted field on the profile-update contract in any observed API version**; whether the UI performs client-side e-mail-format validation before a no-op submit, silently drops the field, or the field is purely read-only/cosmetic is not evidenced |
| Změnit profilovou fotku (0/1 limit) | none found | Probable — the "0 / 1" counter implies a single-file limit enforced by the widget, consistent with the reused generic upload-widget copy also seen on the application-form attachment step; no BR documents a file-count or file-type/size constraint for this uploader |

`validationsWithoutBR`: Jméno/Příjmení format validation; E-mail field behavior (edit vs. cosmetic,
per UC0024 AF2); profile-photo file-count/type/size limits. None of these have a corresponding
`BRxxxx` in `_ar/spec-draft/BR/` at this time — flag for BR-layer follow-up or confirm as
out-of-scope current-state gaps.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Vaše jméno a příjmení | `EN0006` (Contact) | none | `first_name` / `last_name` fields on the Contact linked to the caller's User, per `UC0024.2` step 3 |
| Váš e-mail | `EN0006` (Contact) | none | Displayed field; per `UC0024` AF2 this is **not** a write-path field on the profile-update contract — display-only binding is Probable, not Confirmed as a live read binding to a specific Contact/User e-mail attribute |
| Změnit profilovou fotku | `EN0008` (User) | none | `user_image` field on the User, per `UC0024.2` step 4 (three derived image styles generated on upload: `324x326`, `324x326@2`, `324x326@3`) |

No profile-summary figures (total donated, campaign count, badges — per `UC0024.1` step 3) are
visible in this screen's capture; those belong to a dashboard surface not confirmed as composed with
this settings form (see `UC0024` Evidence Pending, IA-Q2/IA-Q3). Not bound here.

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | Requires an authenticated session (observed role: any authenticated party — donor/supporter, patron, or fundraiser; no more granular role-gate evidenced for this specific screen, unlike the role-gated `zona/*` sibling screens S018–S020) | No ACL layer exists in this reconstruction (per `IA-patronus.md` §9); unauthenticated access behavior (redirect to login vs. 403) is not evidenced — **Uncertain** |
| "Můj účet" header link | Same authenticated-session condition | Not evidenced whether the link itself is hidden or the destination screen gates access — **Uncertain** |

---

## Accessibility Notes

Not evidenced from a static screenshot; the following are `Assumed` best-practice expectations, not
confirmed observations:

- **Tab order:** Assumed left-to-right, top-to-bottom — Jméno → Příjmení → E-mail → upload
  control/"vyberte v počítači" link → "Uložit změny" button. Not confirmed.
- **Focus on entry:** Uncertain — not evidenced whether focus lands on the first field or the page
  heading on navigation.
- **Focus on state transition:** Uncertain — no post-submit state was captured, so focus behavior on
  save (success or error) is not evidenced.
- **Landmarks:** Uncertain — semantic structure (e.g. `<form>`, `<main>`, heading hierarchy) not
  determinable from a visual screenshot alone.
- **Keyboard shortcuts:** None observed or expected beyond standard form-field tabbing and the
  drag-and-drop upload zone's file-picker link activation.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Layout zones, field labels, button copy | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu_nastaveni.png` |
| Layout duplicate (mis-named file) | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §11 notes `po_prihlaseni_do_uctu_potvrzeni_o_darech2.png` is a pixel-duplicate of this same screen |
| UC realization (UC0024.1 view, UC0024.2 edit) | Confirmed | `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` |
| E-mail field non-functional write path | Confirmed (as a code fact); Uncertain (front-end visible consequence) | `UC0024` AF2 |
| Empty vs. pre-filled field state | Uncertain | Screenshot shows placeholder-only text; no second capture with populated values exists |
| Loading / error states | Evidence Pending — not captured | No screenshot evidence for either state |
| Data bindings (EN0006, EN0008) | Probable | Inferred from `UC0024.2` field-level mapping, not independently re-verified against this screen's DOM/API payload |
| Validation rules | Uncertain — no BR | No `BRxxxx` document covers name/e-mail/photo validation for this screen |
| Role-gating scope | Uncertain | No ACL layer; broader authenticated-only access inferred from IA account-zone grouping (`IA-patronus.md` §3.6, §7) |
