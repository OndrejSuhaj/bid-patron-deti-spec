---
doc_id: WIRE0025
title: Activation Link Sent
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S022
realizes_uc: [UC0014]
status: draft
references:
  - UC0014
  - EN0008
  - EN0006
  - BR-AccessControlAndRoles
---

# WIRE0025 – Activation Link Sent

## Purpose

`/poslat-aktivacni-email` is the IA-mapped landing surface a Customer reaches after submitting the
activation-request form on S021 (`/overit-prihlaseni`), as part of the passwordless
activation/self-service login path of `UC0014` (Authenticate & Manage Access — magic-link issuance
branch). Per the IA Screen Map, its intended purpose is a **"link sent" confirmation**: acknowledging
that an activation link was emailed to the address the Customer supplied. **This purpose is stated by
the IA layer, not confirmed by screen content** — see Evidence and Open Question below.

Actor: an unauthenticated existing party (dárce / žadatel / Patron per S021 copy) who has just
requested an activation link.

## Open Question — screen content not evidenced

Both available captures for the `/poslat-aktivacni-email` route show **only the site chrome (header
nav, cookie-consent banner, full footer)** around a body that is, pixel-for-pixel, the **S021 form**
("Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet" — e-mail field + "Poslat aktivační
odkaz" button + "Zpět na přihlášení" link), not a distinct "link sent" confirmation message. This
matches the existing IA finding (`IA-patronus.md` §8 IA-Q9; `UI-gap-open-questions.md` OQ-03):
"the confirmation body is out of frame — do not treat as content evidence." **Classification:
Uncertain / evidence-blocked.** No confirmation-specific layout, copy, or component is asserted below
without this caveat. This does not block the WIRE document because `screen_id` (`S022`) and
`realizes_uc` (`UC0014`) are established by the IA layer; only the screen's *own* body content is
pending re-capture or source/template evidence.

---

## Layout Zones

Confirmed zones (shared global chrome, identical across both S022 captures and consistent with other
Patronus screens, e.g. S021):

- **Header** — global site nav: "patron dětí" logo, "Jak to funguje", "Blog", "O nás", "Požádat o
  pomoc" (primary CTA), "Můj účet" (account entry, unauthenticated state). — *Confirmed*
- **Main content** — **not evidenced for this screen's actual confirmation state**; both captures
  render the S021 request-form body instead of a "link sent" acknowledgment. — *Uncertain*
- **Cookie-consent banner** — bottom-fixed strip: cookie icon + "Tyto stránky používají k poskytování
  služeb soubory cookie. Používáním tohoto webu s tím souhlasíte." + "Další informace" link. —
  *Confirmed (site-wide, not screen-specific)*
- **Footer** — "patron dětí" brand block + mission blurb + Facebook link + "Nadace Sirius" +
  registered-collection number; "Patron dětí" link column (O nás / Blog / Pravidla poskytování
  pomoci / Naše desatero / Splněné příběhy / Výroční zprávy / Jak jsme pomáhali v době koronakrize);
  "Kontakt" column (e-mail info@patrondeti.cz); payment-provider strip (Comgate, Mastercard, Visa) +
  "Číslo sbírkového účtu: 57574646/0600"; bottom bar (GDPR consent link, "Chci přihlásit příběh",
  copyright). — *Confirmed (site-wide, not screen-specific)*

```
+--------------------------------------------------+
| Header (global nav)                               |
+--------------------------------------------------+
| Main content — NOT EVIDENCED for this screen      |
| (captures show S021 form instead; see Open        |
| Question above)                                   |
+--------------------------------------------------+
| Cookie-consent banner (global)                    |
+--------------------------------------------------+
| Footer (global)                                   |
+--------------------------------------------------+
```

---

## Components Used

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | inline | global site nav | Confirmed present; not a screen-specific component. COMP layer not yet populated — flagged `inline` per current pipeline state. |
| Main content | inline | — | **Uncertain** — no confirmed component for the actual confirmation body; not asserted. |
| Cookie banner | inline | consent notice + link | Confirmed present; site-wide, not screen-specific. |
| Footer | inline | global footer | Confirmed present; site-wide, not screen-specific. |

All entries flagged `inline` — the COMP layer does not exist yet in this pipeline pass (per task
instruction), independent of the evidence gap above.

---

## Interactions

1. **Entry** — Customer submits the activation-request form on S021 (`/overit-prihlaseni`) →
   redirected/rendered at `/poslat-aktivacni-email` → state: `default` (intended: confirmation
   message). *Entry route confirmed by URL/IA mapping; the resulting rendered state is Uncertain
   (see Open Question).*
2. **Primary action** — none confirmed. If the screen is a pure confirmation (per its IA-declared
   purpose), it may have no primary action beyond acknowledgment — **Uncertain, not evidenced**.
3. **Secondary action** — none confirmed in the captured chrome specific to this screen's main
   content.
4. **Exit** — global nav ("Můj účet", "Požádat o pomoc", logo) remains available as escape routes,
   consistent with header being confirmed present; no screen-specific exit control is evidenced.

Realizes `UC0014` (magic-link/activation-request sub-flow) at the IA-mapping level; no UC step can be
attributed to a specific on-screen control here because the control-bearing content is not evidenced.

---

## States

### default
**Uncertain — not evidenced.** IA declares this screen's purpose as an activation-link-sent
confirmation, but no capture shows that confirmation body; both available screenshots render the
S021 form instead. Do not treat as content evidence (see Open Question).

### empty
`N/A — no confirmed content to have an empty variant of; not evidenced.`

### loading
`N/A — not evidenced; no async indicator observed in either capture.`

### error
`N/A — not evidenced; no error-display evidence for this screen (e.g. invalid-email / send-failure
messaging is not visible in the captured chrome). Note: UC0014 AF4/AF5 describe adjacent
token/registration failure paths at the UC level, but no on-screen error surface for this specific
screen is confirmed.`

---

## Validation Surfaces

None confirmed on this screen. The e-mail-format/required-field validation implied by the *preceding*
S021 form is out of scope for this WIRE (belongs to S021's own wireframe, not S022). No validation
surface specific to the S022 confirmation body is evidenced.

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| — | — | none evidenced for this screen |

**validationsWithoutBR:** none raised — no validation surface is asserted for this screen at all,
so there is nothing to leave without a BR reference.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Main content (intended) | `EN0008` | — | *Assumed* — if the intended confirmation displays or references the submitted e-mail address, that value would originate from the User (`EN0008`) / Contact (`EN0006`) lookup performed by `UC0014`'s magic-link issuance step; not confirmed on screen because the content is not evidenced. |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| "Můj účet" header link | unauthenticated-vs-authenticated header state (`BR-AccessControlAndRoles`) | Confirmed: shown as "Můj účet" for the unauthenticated Customer on this screen, consistent with other pre-login screens (S009, S021); ACL layer not yet populated so no `ACLxxxx` id exists to cite. |
| Main content (confirmation body) | n/a | **Uncertain** — no conditional-visibility logic can be asserted for unevidenced content. |

---

## Accessibility Notes

- **Tab order:** Not evidenced for the screen-specific content; global header/footer tab order is
  consistent with other Patronus screens (logo → nav links → "Požádat o pomoc" → "Můj účet").
- **Focus on entry:** Uncertain — not evidenced.
- **Focus on state transition:** Uncertain — not evidenced (no state transition observed).
- **Landmarks:** Header/footer use standard site-wide landmark structure (confirmed by consistent
  chrome across captured screens); main-content landmark role for this screen specifically is
  Uncertain.
- **Keyboard shortcuts:** None observed; none expected for a confirmation-style screen.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Header / cookie-banner / footer chrome | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-poslat-aktivacni-email-2026-07-04-13_23_37.png`, `_ar/prtsc/screencapture-patrondeti-cz-poslat-aktivacni-email-2026-07-04-13_31_22.png` |
| Main content = "link sent" confirmation (IA-declared purpose) | Uncertain | `_ar/evidence/ui/ui-observed-areas.md` §10; `_ar/spec-draft/IA/IA-patronus.md` §8 IA-Q9; `_ar/spec-draft/UI-gap-open-questions.md` OQ-03; `_ar/spec-draft/IA-screen-map.md` row S022 (certainty: Uncertain) |
| Screen realizes `UC0014` | Probable | `_ar/spec-draft/IA-screen-map.md` row S022; `_ar/spec-draft/IA/IA-patronus.md` line 258 |
| Captured body is actually the S021 form, not a distinct confirmation | Confirmed (visual, this pass) | both screenshots above — body content, field placeholder ("E-mail" / pre-filled "o.suhaj@gmail.com"), heading, and CTA are identical to S021's captured form |

**Open Question carried forward (not resolved by this WIRE):** IA-Q9 / OQ-03 — re-capture the actual
post-submit confirmation render of `/poslat-aktivacni-email`, or inspect the route's
template/controller in source, to determine the real confirmation content before this WIRE can move
past Evidence-Pending for its main-content zone.
