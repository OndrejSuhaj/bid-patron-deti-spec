---
doc_id: WIRE0024
title: Activation Entry Send Link
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S021
realizes_uc: [UC0014]
status: draft
references:
  - UC0014
  - EN0008
  - BR-AccessControlAndRoles
  - MSG0003
  - IA-patronus (S009, S010, S021, S022)
---

# WIRE0024 – Activation Entry Send Link

## Purpose

S021 (`/overit-prihlaseni`) is the entry point for a person who already has an implicit party record
in the platform — a dárce (donor), žadatel (applicant), or Patron whose Contact/User (`EN0006`/
`EN0008`) was provisioned from a prior donation or Application, but who has never activated a login
— to request an account-activation link by e-mail. The Customer supplies the e-mail address they used
when donating or applying, and the system dispatches an activation link to it. This screen realizes
`UC0014` (the activation-link-issuance precursor adjacent to UC0014.1/UC0014.3; not itself a numbered
UC0014 flow step — see Evidence). Actor: Customer (unauthenticated, has an existing but unactivated
party record). Entry context: the "Aktivujte si ho." link on S009 (`/prihlaseni`), or a direct visit
to `/overit-prihlaseni` (`_ar/spec-draft/IA/IA-patronus.md` §4, entry row `/overit-prihlaseni`).

*Evidence note:* the IA Screen Map (`_ar/spec-draft/IA-screen-map.md` row S021) rates this screen
**Confirmed**, and `_ar/evidence/ui/ui-observed-areas.md` §9 describes a form (pre-filled e-mail
field, two CTAs, explanatory copy) as this screen's content. However, the single screenshot cited as
that section's evidence — `screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` —
when directly inspected for this WIRE pass, shows **only the global header, the cookie-consent
banner, and the global footer**; the form body is out of frame, the same capture pattern documented
as an open gap for the sibling screen S022 (`_ar/spec-draft/UI-gap-open-questions.md` OQ-03). This
WIRE reconstructs the form content from the `ui-observed-areas.md` §9 prose (treated as *Probable*,
not independently *Confirmed* by the image itself) and records the discrepancy as an Open Question
rather than silently upgrading or downgrading either source.

---

## Layout Zones

- Header — global site nav: logo "patron dětí", "Jak to funguje", "Blog", "O nás", "Požádat o pomoc"
  CTA, "Můj účet" — same chrome pattern observed site-wide (`_ar/evidence/ui/ui-observed-areas.md`
  §1). *Confirmed* (screenshot).
- Main content — centered single-column panel (pattern inferred from the sibling screens S009/S010;
  not independently visible in this screenshot): heading/intro copy, an e-mail input field, a primary
  CTA, and a secondary link. *Probable* — reconstructed from `ui-observed-areas.md` §9 prose only.
- Sidebar — none observed.
- Footer — global site footer (mission blurb, nav link clusters, payment-provider badges, collection
  account number, legal links, cookie banner) — same chrome pattern observed site-wide. *Confirmed*
  (screenshot).

```
+--------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | Požádat  |
|        o pomoc (CTA) | Můj účet                         |
+--------------------------------------------------------+
| [cookie consent banner]                                 |
+--------------------------------------------------------+
|                                                          |
|   Heading: "Už jsem dárcem, žadatelem nebo Patronem      |
|   a chci aktivovat účet"                    (Probable)  |
|   Body: "Zde vyplňte svůj email, který jste použili      |
|   při přispění na příběh nebo v žádosti o dar. Odešleme  |
|   vám na něj aktivační odkaz."              (Probable)   |
|                                                          |
|   +--------------------------------------------------+ |
|   |  [ email input — pre-filled example value ]        | |
|   |  [ Poslat aktivační odkaz ]  (button)              | |
|   |  Zpět na přihlášení (link)                         | |
|   +--------------------------------------------------+ | (Probable — form
|                                                          |  block not visible
+--------------------------------------------------------+  in the cited
| Footer: mission blurb | nav clusters | contact | badges |  screenshot)
+--------------------------------------------------------+
```

---

## Components Used

Recurring elements promoted to COMP by **AR:COMPSynthesizer** (see `COMP-inventory-map.md`), limited
to rows whose own presence on this screen is *Confirmed* by screenshot; the form-body rows below
remain `inline` at *Probable* certainty (prose-only evidence — see Purpose/Evidence). The overall
Main + Form zones conceptually compose an instance of `COMP0009` Single Email-Entry Form
(purpose=activation-request), inheriting that COMP's own Probable-certainty ceiling for this screen.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | COMP0002 | context=public | Shared chrome; navigation targets owned by IA. *Confirmed* (screenshot). See `COMP0002` Global Site Header. |
| Cookie consent banner | COMP0004 | — | Shared site-wide chrome, not screen-specific. *Confirmed* (screenshot). See `COMP0004` Cookie Consent Banner. |
| Main — heading | inline | heading text, "Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet" | Minimal label only — full copy owned by COPY layer. Part of `COMP0009` (purpose=activation-request). *Probable* — `ui-observed-areas.md` §9 verbatim; not visible in the cited screenshot frame. |
| Main — body copy | inline | explanatory paragraph, "Zde vyplňte svůj email, který jste použili při přispění na příběh nebo v žádosti o dar. Odešleme vám na něj aktivační odkaz." | Minimal excerpt only — full copy owned by COPY layer. Part of `COMP0009`. *Probable* — same caveat as above. |
| Form — e-mail field | inline | single text input labeled "email", observed pre-filled with an example address in the source note | No visible label styling confirmed (pattern only, per §9 prose). Part of `COMP0009`. *Probable* — not visible in the cited screenshot frame. |
| Form — primary CTA | inline | primary button, "Poslat aktivační odkaz" | Red/primary button style consistent with site-wide CTA styling (per sibling screens S009/S010); resembles `COMP0001` Primary Button but not promoted at the row level since the row's own screen-presence is only *Probable*, not Confirmed. |
| Form — secondary link | inline | text link, "Zpět na přihlášení" (→ S009) | Part of `COMP0009`. *Probable* — not visible in the cited screenshot frame. |
| Footer | COMP0003 | — | Shared chrome. *Confirmed* (screenshot). See `COMP0003` Global Site Footer. |

---

## Interactions

1. **Entry** — Customer clicks "Aktivujte si ho." on S009 (`/prihlaseni`), or navigates directly to
   `/overit-prihlaseni` → state: `default`. (`_ar/spec-draft/WIRE/WIRE0012_LoginMagicLink.md`
   interaction 4; `_ar/spec-draft/IA/IA-patronus.md` §4, entry row `/overit-prihlaseni`.) *Confirmed*
   (IA/WIRE0012 cross-reference).
2. **Primary action — request activation link** — Customer enters an e-mail address into the "email"
   field and clicks "Poslat aktivační odkaz" → triggers the activation-link dispatch adjacent to
   `UC0014` (see Purpose evidence note) → expected next screen: S022 (`/poslat-aktivacni-email`,
   link-sent confirmation), per `_ar/spec-draft/IA/IA-patronus.md` §5 "Account activation /
   provisioning flow". *Probable* — the transition target is IA-documented, but neither S021's
   post-submit behavior nor S022's actual content is directly evidenced (S022 itself is an open gap,
   OQ-03).
3. **Secondary action — back to login** — click "Zpět na přihlášení" → navigates to S009
   (`/prihlaseni`). *Probable* — inferred from §9's representative verbatim CTA list; exact target
   screen inferred from naming, not independently confirmed by a captured link/href.
4. **Exit** — Customer leaves via header/footer nav (each an IA-owned navigation target, not restated
   here). *Confirmed* (screenshot, chrome only).

---

## States

### default
E-mail entry form: "email" input pre-filled with an example address per `ui-observed-areas.md` §9
("pre-filled o.suhaj@gmail.com" in the underlying evidence capture note), "Poslat aktivační odkaz"
button, "Zpět na přihlášení" secondary link. No validation message documented. *Probable* — this
state's content is not visible in the screenshot frame actually inspected for this WIRE pass; see
Purpose evidence note.

### empty
`N/A — no distinct empty-state applies`. This is a single-field entry form, not a listing; there is
no "no items" condition to render.

### loading
`Evidence Pending — not captured`. No in-flight/spinner state is documented for this screen. Whether
the button shows a spinner, disables itself, or the transition to S022 is instantaneous is Uncertain.

### error
`Evidence Pending — not captured`. No source (screenshot or `ui-observed-areas.md`) documents a
validation or submission error on this screen (e.g. malformed e-mail, unknown e-mail with no matching
party record). Recorded as an open question rather than asserted; see Validation Surfaces below.

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| "email" input — required/format validation | *(none identified)* | Evidence Pending — `ui-observed-areas.md` §9 explicitly notes "form ready / pre-filled, no validation shown"; whether client-side format checking or server-side rejection occurs is Uncertain. |
| Submission with an e-mail that matches no existing Contact/User | *(none identified)* | Evidence Pending — not documented in any source; Uncertain whether the system reveals account existence (security-relevant behavior) or always shows a generic "link sent" confirmation regardless of match. |

**validationsWithoutBR:**
- Whether the "email" field enforces a required/format rule before submission is not observed. No BR
  was found governing client-visible validation feedback on this specific form —
  `BR-AccessControlAndRoles` covers flood-control and magic-link token-expiry policy, not form-level
  input validation on the activation-request screen. **Open Question.**
- Whether repeated activation-link requests for the same e-mail are throttled is Uncertain.
  `BR-AccessControlAndRoles`'s current-state flood-control note is scoped to login-attempt brute-force
  protection, not to activation-link request rate-limiting — no BR covers this surface.
  **Open Question.**
- Whether the response differs (or is deliberately identical, for enumeration-safety) between a
  matching and a non-matching e-mail is not covered by any BR found in this reconstruction pass.
  **Open Question.**

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Form submission → activation-link dispatch | `EN0008` | — | Submitting the e-mail is expected to look up a matching `EN0008` User (login email attribute) or its linked `EN0006` Contact and trigger dispatch of the activation e-mail (`MSG0003`, per `_ar/spec-draft/IA-screen-map.md` "Transactional-email surfaces" row). No data is displayed back on this screen. *Probable* — the lookup/dispatch mechanics are not directly evidenced by UC0014's modeled flows (see Evidence). |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Whole screen | none evidenced | No role-gating found — S021 is an unauthenticated entry point by design (`_ar/spec-draft/IA/IA-patronus.md` §4: reached from S009 "Aktivujte si ho." or direct visit, no auth required). The ACL layer does not exist in this reconstruction. Whether an already-authenticated Customer visiting `/overit-prihlaseni` directly is redirected away is Uncertain — not observed; **Open Question.** |

---

## Accessibility Notes

Evidence Pending — the screenshot frame actually available for this screen shows only chrome (header,
cookie banner, footer), so no DOM structure, ARIA roles, or keyboard behavior for the form itself can
be inspected. The following are Uncertain and not fabricated:

- **Tab order:** Uncertain — by the §9 prose ordering, plausibly e-mail input → submit button →
  "Zpět na přihlášení" link, but not confirmed from any capture.
- **Focus on entry:** Uncertain — whether the e-mail input receives autofocus, or retains the
  pre-filled example value requiring the user to clear it, is not observable.
- **Focus on state transition:** Uncertain — whether focus moves on transition to S022 is not
  evidenced.
- **Landmarks:** Uncertain — no DOM/ARIA evidence available.
- **Keyboard shortcuts:** none evidenced.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Global header/footer/cookie-banner chrome present on this screen | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` (directly inspected: shows nav, cookie banner, footer only) |
| Screen realizes UC0014 (activation-link-issuance precursor) | Confirmed | `_ar/spec-draft/UC/UC0014_AuthenticateManageAccess.md`; `_ar/spec-draft/IA-screen-map.md` row S021 |
| Form content: heading, body copy, "email" field (pre-filled), CTAs "Poslat aktivační odkaz" / "Zpět na přihlášení" | Probable | `_ar/evidence/ui/ui-observed-areas.md` §9 (prose description); **not independently visible** in the screenshot file cited as that section's evidence — see Purpose evidence note and Open Questions |
| Post-submit transition target is S022 | Probable | `_ar/spec-draft/IA/IA-patronus.md` §5 "Account activation / provisioning flow" step 2→3 |
| Loading state, error state, form-field validation feedback | Evidence Pending / Uncertain | Not captured in any source; no BR found governing form-level validation display — flagged as Open Question above |
| Activation e-mail sent is MSG0003 | Probable | `_ar/spec-draft/IA-screen-map.md` "Transactional-email surfaces" row |

---

## Open Questions

- **OQ-WIRE0024-1** — The screenshot cited by `_ar/evidence/ui/ui-observed-areas.md` §9
  (`screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`) shows, on direct
  inspection, only the global header, cookie-consent banner, and footer — the same
  chrome-only/body-out-of-frame pattern already flagged for sibling screen S022 (OQ-03 in
  `_ar/spec-draft/UI-gap-open-questions.md`). The form content in this WIRE is reconstructed from the
  §9 prose alone and is therefore *Probable*, not *Confirmed*, despite the IA Screen Map rating S021
  "Confirmed". **Resolution needed:** re-capture `/overit-prihlaseni` with the form in frame, or
  confirm the §9 prose's original evidence source (may be a different, unindexed capture or direct
  source/template read). Recommend reconciling the IA Screen Map's "Confirmed" rating for S021 against
  this finding.
- **OQ-WIRE0024-2** — Loading and error states are entirely unevidenced (see States section above).
- **OQ-WIRE0024-3** — No BR governs form-level validation, duplicate-request throttling, or
  enumeration-safety behavior on this screen (see validationsWithoutBR above).
