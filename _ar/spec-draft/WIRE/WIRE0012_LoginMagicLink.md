---
doc_id: WIRE0012
title: Login Magic Link
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S009
realizes_uc: [UC0014]
status: draft
references:
  - UC0014
  - EN0008
  - BR-AccessControlAndRoles
  - MSG0004
  - IA-patronus (S009, S010, S021)
---

# WIRE0012 – Login Magic Link

## Purpose

S009 (`/prihlaseni`) is the passwordless login entry point for an unauthenticated party who already
has a User account (`EN0008`) — applicant (žadatel), donor (dárce), or Patron. The Customer enters
their e-mail and the system sends a magic-link login e-mail (`MSG0004`); this screen realizes
`UC0014` (specifically the login sub-flow, UC0014.1's magic-link branch, and its request-a-link
precursor). Actor: Customer (unauthenticated, has an existing account). Entry context: clicking
"Můj účet" in the global nav while unauthenticated (`_ar/spec-draft/IA/IA-patronus.md` §4, entry
`/prihlaseni`).

The screen has two observed states rendered as full-page content swaps within the same layout
shell: the e-mail entry form (default) and a post-submit "check your inbox" confirmation. Both are
directly evidenced by screenshot.

---

## Layout Zones

- Header — global site nav: logo "patron dětí", "Jak to funguje", "Blog", "O nás", "Požádat o pomoc"
  CTA, "Můj účet" — same chrome pattern observed site-wide (`_ar/evidence/ui/ui-observed-areas.md`
  §1). *Confirmed* (both screenshots).
- Main content — centered single-column panel:
  - Icon (two-person glyph in default state / checkmark-in-circle in confirmation state)
  - Heading
  - Intro/body copy (one or two short paragraphs)
  - A light-grey card containing the form (default) or the secondary links (confirmation)
- Sidebar — none observed.
- Footer — global site footer (mission blurb, nav link clusters, payment-provider badges, collection
  account number, legal links, cookie banner) — same chrome pattern observed site-wide. *Confirmed*
  (both screenshots).

```
+--------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | Požádat  |
|        o pomoc (CTA) | Můj účet                         |
+--------------------------------------------------------+
|                                                          |
|                     [icon]                               |
|                    Heading                                |
|                  Body copy (1-2 lines)                    |
|                                                            |
|   +--------------------------------------------------+   |
|   |     [ E-mail input ]         (default state)      |   |
|   |     [ Přihlásit se ]  (button)                     |   |
|   |     Už máte účet i heslo? Přihlaste se pomocí ...  |   |
|   |     Ještě účet nemáte? Aktivujte si ho.            |   |
|   +--------------------------------------------------+   |
|                                                          |
+--------------------------------------------------------+
| Footer: mission blurb | nav clusters | contact | badges |
+--------------------------------------------------------+
```

---

## Components Used

The COMP layer does not yet exist for this reconstruction pass — every entry is flagged `inline`.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | inline | global site nav | Shared chrome; navigation targets owned by IA, not restated here. *Confirmed.* |
| Main — status icon | inline | two-person glyph (default) / checkmark-circle (confirmation) | Purely decorative state indicator; no interaction. *Confirmed* (both screenshots). |
| Main — heading | inline | H1, "Přihlaste se do účtu" (default) / "Zkontrolujte svou e-mailovou schránku" (confirmation) | Minimal label only — full copy owned by COPY layer. *Confirmed.* |
| Main — body copy | inline | 1–2 paragraph intro text | Minimal excerpt only — full copy owned by COPY layer. *Confirmed.* |
| Form card — e-mail field | inline | single text input, placeholder "E-mail" | No visible label above the field; placeholder doubles as label. *Confirmed* (13_23_29 screenshot). |
| Form card — submit button | inline | primary CTA button, "Přihlásit se" | Red/primary button style consistent with site-wide CTA styling. *Confirmed.* |
| Form card — secondary links (default state) | inline | two text links: "Přihlaste se pomocí svého hesla." (→ password login) and "Aktivujte si ho." (→ S021 `/overit-prihlaseni`) | Secondary-action links inside the muted card, below the primary CTA. *Confirmed* (13_23_29). |
| Form card — secondary links (confirmation state) | inline | two text links: "Přihlaste se pomocí svého hesla." (→ password login) and inline "zkontrolujte složku spam, nebo nám napište na info@patrondeti.cz" (mailto) | *Confirmed* (13_32_31). |
| Footer | inline | global site footer | Shared chrome. *Confirmed.* |

---

## Interactions

1. **Entry** — Customer clicks "Můj účet" in the global nav while unauthenticated → routes to
   `/prihlaseni` → state: `default`. (`_ar/spec-draft/IA/IA-patronus.md` §4, entry row `/prihlaseni`.)
   *Confirmed* (IA cross-reference; entry mechanism itself not re-captured in this screenshot pair).
2. **Primary action — submit e-mail** — Customer types an e-mail into the "E-mail" field and clicks
   "Přihlásit se" → triggers `UC0014` (magic-link issuance branch; sends `MSG0004`) → screen
   transitions from `default` to the confirmation state (13_32_31), still on `/prihlaseni`. No visible
   full-page navigation between the two captures; the same route renders the post-submit content.
   *Confirmed* (both screenshots show the same header/footer chrome, only the main-content block
   changes).
3. **Secondary action — password login** — click "Přihlaste se pomocí svého hesla." (present in both
   states) → navigates to the password-based login variant of `UC0014`; target screen not separately
   captured (IA does not enumerate a distinct screen-id for password login — Open Question).
4. **Secondary action — activate account** — click "Aktivujte si ho." (default state only) →
   navigates to S021 `/overit-prihlaseni` (Activation entry — send activation link).
   *Confirmed* (`_ar/spec-draft/IA-screen-map.md` row S021; link text visible in 13_23_29).
5. **Secondary action — contact support** — click "napište na info@patrondeti.cz" (confirmation state
   only) → opens mail client (`mailto:` link), inline within the "check spam" guidance text.
   *Confirmed* (13_32_31).
6. **Exit** — Customer leaves via header/footer nav (each an IA-owned navigation target, not restated
   here), or by opening the magic-link e-mail (`MSG0004`) in a separate context, which authenticates
   them and routes to the account zone (S011 / S018) per `_ar/spec-draft/IA/IA-patronus.md` §5 "Login
   flow". *Confirmed* (IA cross-reference).

---

## States

### default
E-mail entry form: empty "E-mail" input (placeholder text, no pre-fill), "Přihlásit se" button, two
secondary links ("Přihlaste se pomocí svého hesla." / "Aktivujte si ho."). No validation message
visible. *Confirmed* — `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`.

### empty
`N/A — no distinct empty-state applies`. This is a single-field entry form, not a listing; there is
no "no items" condition to render.

### loading
`Evidence Pending — not captured`. No in-flight/spinner state was captured between submitting the
e-mail and the confirmation screen appearing. Whether the button shows a spinner, disables itself, or
the transition is instantaneous is Uncertain — not observed in either screenshot.

### error
`Evidence Pending — not captured`. No screenshot shows a validation or submission error on this
screen (e.g. malformed e-mail, unknown e-mail, rate-limited request). Recorded as an open question
rather than asserted; see Validation Surfaces below for the related BR-backed and un-backed triggers.

### confirmation (post-submit — additional state beyond the template's default/empty/loading/error set)
"Zkontrolujte svou e-mailovou schránku" panel: checkmark icon, confirmation heading and body text,
password-login fallback link, and "check spam / contact us" guidance line (with a `mailto:` link).
The e-mail entry form itself is no longer shown. *Confirmed* —
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png`. This state is additional
to the template's mandated four; it is recorded because it is the screen's dominant observed
post-submit behavior and is load-bearing for the login flow.

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| "E-mail" input — required/format validation | *(none identified)* | Evidence Pending — no validation message observed in either capture; whether client-side format checking (e.g. `type="email"` browser validation) or server-side rejection occurs is Uncertain. |
| Magic-link token expiry (consumed on a separate screen when the e-mailed link is opened, not on S009 itself) | `BR-AccessControlAndRoles` (90-day validity window; UC0014 AF4 "expired or invalid" rejection) | Not a surface on S009 — the rejection, if any, would render on whatever screen handles the link click, which is outside this screen's evidence. Noted here only for traceability. |

**validationsWithoutBR:**
- Whether the "E-mail" field enforces a required/format rule before submission, and what happens on
  submission with an unknown e-mail (no matching User) or a blocked account (`UC0014` AF1/AF2), is
  not observed on this screen. No BR was found that specifically governs client-visible validation
  feedback on the login form itself — `BR-AccessControlAndRoles` covers flood-control and
  token-expiry policy, not form-level input validation. **Open Question.**
- Whether resubmitting the form while a prior magic-link is still valid/pending is blocked, throttled,
  or silently allowed is Uncertain — related to `BR-AccessControlAndRoles`'s current-state note that
  flood-control is inconsistently enforced across login surfaces, but that note is scoped to
  password-login attempts, not e-mail-submission flood control on this specific form. **Open Question.**

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Form submission → magic-link issuance | `EN0008` | — | Submitting the e-mail triggers `UC0014`'s magic-link branch against the matching `EN0008` User record (login email attribute); no data is displayed back on this screen beyond the static confirmation copy. No QUERY-id evidenced — the screen does not read/display User data. |
| Confirmation state | — | — | No entity-backed content; the confirmation panel is static copy, not a rendering of stored data. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Whole screen | none evidenced | No role-gating found — S009 is the unauthenticated entry point by design (`_ar/spec-draft/IA/IA-patronus.md` §4: reached from "Můj účet" *while unauthenticated*). The ACL layer does not exist in this reconstruction. Whether an already-authenticated Customer visiting `/prihlaseni` directly is redirected away is Uncertain — not observed; **Open Question.** |
| "Aktivujte si ho." link | none evidenced | Always visible in the default state per screenshot; no condition observed that would hide it. |

---

## Accessibility Notes

Evidence Pending — neither screenshot permits inspection of DOM structure, ARIA roles, or keyboard
behavior; the following are Uncertain and not fabricated:

- **Tab order:** Uncertain — visually the order would be e-mail input → submit button → secondary
  links, but not confirmed from static screenshots.
- **Focus on entry:** Uncertain — whether the e-mail input receives autofocus on page load is not
  observable from a static capture.
- **Focus on state transition:** Uncertain — whether focus moves to the confirmation heading after
  submission (relevant for screen-reader announcement of the state change) is not evidenced.
- **Landmarks:** Uncertain — no DOM/ARIA evidence available.
- **Keyboard shortcuts:** none evidenced.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Default (e-mail entry) state — icon, heading, body copy, form field, submit button, secondary links | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` |
| Confirmation ("check your inbox") state — icon, heading, body copy, fallback links, mailto | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png` |
| Global header/footer chrome present on this screen | Confirmed | both screenshots above; pattern cross-checked against `_ar/evidence/ui/ui-observed-areas.md` §1 |
| Screen realizes UC0014 (magic-link login branch) | Confirmed | `_ar/spec-draft/UC/UC0014_AuthenticateManageAccess.md` UC0014.1; `_ar/spec-draft/IA-screen-map.md` row S009 |
| "Aktivujte si ho." links to S021 | Confirmed | `_ar/spec-draft/IA-screen-map.md` rows S009/S021; `_ar/spec-draft/IA/IA-patronus.md` §3.4 |
| Magic-link e-mail is MSG0004 | Probable | `_ar/spec-draft/IA-screen-map.md` "Transactional-email surfaces" row; e-mail body not separately captured |
| Loading state, error state, form-field validation feedback | Evidence Pending / Uncertain | Not captured in either screenshot; no BR found governing form-level validation display — flagged as Open Question above |
| Magic-link token expiry policy (90-day window, AF4 rejection) | Confirmed (as a BR/UC fact, not a rendered S009 state) | `_ar/spec-draft/BR/BR-AccessControlAndRoles.md`; `_ar/spec-draft/UC/UC0014_AuthenticateManageAccess.md` AF4 |
