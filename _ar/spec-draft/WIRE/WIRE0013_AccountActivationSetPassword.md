---
doc_id: WIRE0013
title: Account Activation Set Password
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S010
realizes_uc: [UC0014]
status: draft
references:
  - UC0014
  - EN0008
  - BR-PartyIdentityAndDeduplication
  - MSG0003
  - IA-patronus (S010)
---

# WIRE0013 – Account Activation Set Password

## Purpose

S010 is the destination of the activation link e-mailed to an invited/newly-provisioned User
(`EN0008`, states "Registered — blocked, password-less" or "Registered — active, password-less") —
reached from the account-activation e-mail (`MSG0003`) per the activation flow in
`_ar/spec-draft/IA/IA-patronus.md` §5. Its job is to let that person set a password and accept two
consent/terms checkboxes so the platform can transition their User record toward "Active" and start
an authenticated session, realizing `UC0014` (activation sub-flow of UC0014.1/UC0014.3 — "Registered
(blocked or password-less) → Active", `_ar/spec-draft/EN/EN0008_User.md` State Transitions). Actor:
invited/newly-provisioned Customer (applicant, patron, or supporter), not yet authenticated.

**Route:** `/aktivovat-ucet` (Confirmed — `_ar/spec-draft/IA/IA-patronus.md` §3.4, §4).

**Open question carried from evidence:** `MSG0003` describes the activation link as a magic-link
flow that never shows or asks for a password ("without ever being shown or asked to enter a
password"). This screenshot shows an explicit password-creation field on the activation screen,
contradicting that framing. Per cross-layer discipline this is recorded, not silently resolved —
see Evidence table and Open Question below.

---

## Layout Zones

- Header — global site nav: logo "patron dětí", "Jak to funguje", "Blog", "O nás", CTA "Požádat o
  pomoc", "Můj účet" (icon + link) — Confirmed, matches site-wide chrome pattern
  (`_ar/evidence/ui/ui-observed-areas.md` §1).
- Main content — centered single-column activation panel:
  - icon (two-person glyph)
  - heading "Aktivovat účet"
  - intro copy: "Po aktivování svého uživatelského účtu budete přihlášení a budete moct využívat
    všech jeho výhod."
  - light-grey card containing: e-mail field + password field (side by side), inline message "Bez
    těchto informací se neobejdeme.", two checkboxes, submit button "Aktivovat účet"
- Sidebar — none observed.
- Footer — global site footer: cookie-consent banner, brand block, link columns ("Patron dětí",
  "Kontakt"), payment-provider/collection-account strip, legal links — Confirmed, matches site-wide
  chrome pattern (`_ar/evidence/ui/ui-observed-areas.md` §1).

```
+--------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | Požádat  |
|              o pomoc (CTA) | Můj účet                  |
+--------------------------------------------------------+
|                     [icon]                              |
|                 Aktivovat účet                          |
|   Po aktivování svého uživatelského účtu budete ...      |
|  +----------------------------------------------------+ |
|  | [ e-mail (read-only style) ] [ password (red border)]| |
|  |         Bez těchto informací se neobejdeme.          | |
|  |  [ ] Prohlašuji, že jsem se seznámil/a s pravidly...  | |
|  |  [ ] Souhlasím s podmínkami používání uživ. účtu.     | |
|  |            [ Aktivovat účet ]                         | |
|  +----------------------------------------------------+ |
+--------------------------------------------------------+
| Cookie banner: "Tyto stránky používají k poskytování..." |
+--------------------------------------------------------+
| Footer: brand | Patron dětí links | Kontakt              |
| Platby zprostředkovává: comgate | Číslo sbírkového účtu   |
+--------------------------------------------------------+
```

---

## Components Used

All entries flagged `inline` — the COMP layer does not yet exist for this reconstruction pass.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | inline | global site nav | Confirmed — same pattern as other public screens |
| Main — icon | inline | two-person glyph, decorative | Confirmed (screenshot) |
| Main — heading + intro copy | inline | page title + one-line description | Confirmed (screenshot); verbatim text is COPY-owned, quoted here only to identify the zone |
| Main — activation card | inline | light-grey panel container | Confirmed (screenshot) |
| Main — e-mail field | inline | text input, prefilled, read-only-styled (grey background, no red outline) | Confirmed (screenshot); value shown `o.suhaj@gmail.com` — test/evidence data, not a UI label |
| Main — password field | inline | text input, placeholder "Vytvořte si vlastní heslo", red outline | Confirmed (screenshot) |
| Main — inline message | inline | red helper/status text below the field pair | Confirmed text, Uncertain semantics (see States) |
| Main — checkbox 1 | inline | checkbox + label with embedded link "pravidly poskytování pomoci" | Confirmed (screenshot) |
| Main — checkbox 2 | inline | checkbox + label with embedded link "podmínkami používání uživatelského účtu" | Confirmed (screenshot) |
| Main — submit button | inline | primary CTA button, "Aktivovat účet" | Confirmed (screenshot) |
| Footer | inline | global site footer + cookie banner | Confirmed — same pattern as other public screens |

---

## Interactions

1. **Entry** — Customer clicks the activation link in the account-activation e-mail (`MSG0003`) →
   lands on `/aktivovat-ucet` → state: `default`. Whether the link carries a token that must be
   validated before the form renders (vs. after submit) is Uncertain — not observable from a static
   screenshot; see Open Question.
2. **Primary action — activate account** — Customer fills password, checks both checkboxes, clicks
   "Aktivovat účet" → submits the form; realizes `UC0014` (activation transition,
   `_ar/spec-draft/EN/EN0008_User.md` "Registered (blocked or password-less) → Active"); next: an
   authenticated session per UC0014, then navigation into the account zone (S011/S018 per
   `_ar/spec-draft/IA/IA-patronus.md` §5 "activation flow", step 5). Exact next screen after success
   is Assumed (IA flow), not itself captured for S010.
3. **Secondary action — read rules** — click "pravidly poskytování pomoci" link → opens the rules
   document (external/document surface, `S-EXT4` per `_ar/spec-draft/IA-screen-map.md`); does not
   submit the form.
4. **Secondary action — read account-usage terms** — click "podmínkami používání uživatelského účtu"
   link → opens terms content; target screen not captured (Uncertain — no dedicated screen-id
   evidenced for this link's destination).
5. **Exit** — no cancel/back action is evidenced on this screen (global header nav is the only other
   way to leave). Whether an incomplete activation can be resumed later via the same link is
   Uncertain.

---

## States

### default
Form as shown in the screenshot: e-mail prefilled and styled read-only, password field empty with a
red outline, both checkboxes unchecked, submit button enabled (no observed disabled-until-valid
behavior). Confirmed — screenshot.

### empty
`N/A — not applicable`. This is a single fixed form, not a list/collection view; there is no
"no items" condition to render.

### loading
`Evidence Pending — not captured`. No loading indicator is visible in the static capture. Whether
the "Aktivovat účet" submit shows a spinner/disabled-button state while the activation request is
in flight is Uncertain — not evidenced either way; do not assume none exists.

### error
`Evidence Pending — not captured` for a true error state (e.g. expired/invalid token, password
rejected, checkboxes unchecked). The screenshot shows the password field with a **red outline** and
the message "Bez těchto informací se neobejdeme." beneath the field pair, but no explicit inline
error copy is attached to either field, and no screenshot exists showing this pane after a failed
submit attempt. Two readings are both plausible from the single static capture:
- (a) this is a **default/required-field styling convention** shown even before any submit attempt
  (i.e. always rendered this way until the password is filled), or
- (b) this is an **already-triggered validation error** (e.g. a prior failed submit, or an expired
  activation token surfacing a generic "we're missing information" message).
Classified **Uncertain** — recorded as Open Question, not resolved by assumption
(`_ar/evidence/ui/ui-observed-areas.md` §8 flags the same ambiguity independently).

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| Password field | none identified — no BR in `_ar/spec-draft/BR/` specifies a password-strength/format rule | inline (red field outline + "Bez těchto informací se neobejdeme." message below the field pair) |
| Checkbox — rules acknowledgement | none identified — no BR requires this checkbox be checked before submit | inline (checkbox itself; no separate error copy observed) |
| Checkbox — account-usage terms consent | none identified — no BR requires this checkbox be checked before submit | inline (checkbox itself; no separate error copy observed) |

**validationsWithoutBR:**
- Password field required/format validation — `BR-PartyIdentityAndDeduplication` only states that a
  newly provisioned User "SHALL be created without a usable password until a separate activation step
  is completed" (activation must set *some* password) but specifies no format/strength rule; the
  actual minimum-length/complexity constraint enforced by this screen, if any, is un-evidenced from
  UI alone. Open question.
- Both terms checkboxes being mandatory-before-submit — plausible from the checkbox/label pairing and
  the linked legal documents, but no BR states this constraint and no screenshot shows an unchecked
  submit being rejected. Open question.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| E-mail field (prefilled, read-only style) | `EN0008` | — | Displays the User's existing e-mail/identifier (or the Contact's, `EN0006`, per the linked-Contact relationship on `EN0008`); the field is styled read-only in the screenshot, consistent with the e-mail being fixed identity rather than user-editable at this step. |
| Password field | `EN0008` | — | Writes the credential that transitions the User from a password-less state to "Active" (`_ar/spec-draft/EN/EN0008_User.md` State Transitions, trigger UC0014). |
| Checkboxes (rules / account-usage terms) | — | — | No EN/consent-record entity is evidenced as backing these checkboxes; whether acceptance is persisted anywhere (e.g. a consent timestamp on `EN0008`/`EN0006`) is Uncertain — not confirmed in the EN layer as read. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Whole screen | none evidenced — no ACL layer exists in this reconstruction (`_ar/spec-draft/IA/IA-patronus.md` §9) | Screen is intended for an unauthenticated Customer holding a valid activation link; whether an already-authenticated session redirects away from `/aktivovat-ucet` is Uncertain, not observed. |
| "Můj účet" header link | none evidenced | Present regardless of the pre-activation state in the capture (points to login/account per global nav pattern); no role-gating difference observed on this screen specifically. |

---

## Accessibility Notes

Evidence Pending beyond what a static screenshot can show. Recorded as an open question; do not
fabricate.

- **Tab order:** Uncertain — visually e-mail field, then password field, then two checkboxes, then
  submit button, consistent with reading order; not confirmed via interaction.
- **Focus on entry:** Uncertain — no evidence of autofocus on the password field.
- **Focus on state transition:** Uncertain — no error/loading state captured to confirm focus
  management.
- **Landmarks:** Uncertain — not confirmed from a visual capture alone.
- **Keyboard shortcuts:** none evidenced.
- **Color-only signal risk:** the password field's red outline is the only visual differentiator
  observed for its (Uncertain) required/error state; whether an equivalent non-color signal (icon,
  text) accompanies it is not resolved by the "Bez těchto informací se neobejdeme." text sitting
  below rather than directly associated with the field — flagged as an accessibility open question,
  not asserted as a defect without confirming actual markup.

---

## Open Questions

- **OQ-WIRE0013-1 (state ambiguity):** Is the red-outlined password field + "Bez těchto informací se
  neobejdeme." message a default required-field convention or an already-triggered validation error?
  Affects whether `error` state is distinct from `default` on this screen. See States → error.
- **OQ-WIRE0013-2 (password vs. magic-link conflict):** `MSG0003` frames account activation as a
  magic-link flow with no password ever shown/requested, but S010 shows an explicit password-creation
  field. Both are evidenced (MSG0003 text vs. this screenshot) and are not reconciled here — recorded
  as a conflict per cross-layer discipline, not resolved by preferring one source silently.
- **OQ-WIRE0013-3 (validation rules):** No BR specifies password format/strength or mandatory
  checkbox-before-submit for this screen; see `validationsWithoutBR` above.
- **OQ-WIRE0013-4 (post-success destination):** The exact next screen after successful activation is
  Assumed from the IA-level flow narrative (`_ar/spec-draft/IA/IA-patronus.md` §5), not itself
  captured leaving S010.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen exists at `/aktivovat-ucet`, realizes `UC0014` | Confirmed | `_ar/spec-draft/IA-screen-map.md` row S010; `_ar/spec-draft/IA/IA-patronus.md` §3.4, §4, §5 |
| Layout zones, header/footer chrome, activation card contents | Confirmed | `screencapture-patrondeti-cz-aktivovat-ucet-2026-07-04-13_33_10.png`; `_ar/evidence/ui/ui-observed-areas.md` §8 |
| E-mail field prefilled + read-only styling | Confirmed | same screenshot |
| Password field with red outline | Confirmed (visual) / Uncertain (semantics: required vs. error) | same screenshot; `_ar/evidence/ui/ui-observed-areas.md` §8 notes the same ambiguity |
| Two checkboxes (rules / account-usage terms) and their linked documents | Confirmed | same screenshot |
| Submit CTA "Aktivovat účet" | Confirmed | same screenshot |
| Activation transitions `EN0008` "Registered (blocked/password-less) → Active" | Confirmed | `_ar/spec-draft/EN/EN0008_User.md` State Transitions; `UC0014` |
| Password-format / checkbox-mandatory validation rule | Uncertain — no BR found | `_ar/spec-draft/BR/BR-PartyIdentityAndDeduplication.md` (only covers password-less provisioning, not format) |
| Empty / loading / error states beyond the single captured default | Evidence Pending — not captured | no additional screenshots for this screen |
| Conflict: magic-link-only activation (MSG0003) vs. observed password field (S010) | Confirmed conflict, unresolved | `_ar/spec-draft/MSG/MSG0003_AccountActivation.md` Purpose; this screenshot |
