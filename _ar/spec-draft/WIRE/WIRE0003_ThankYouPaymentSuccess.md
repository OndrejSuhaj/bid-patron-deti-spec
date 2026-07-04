---
doc_id: WIRE0003
title: Thank You Payment Success
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S003
realizes_uc: [UC0006]
status: draft
references:
  - UC0006
  - UC0025
  - EN0009
  - EN0003
  - EN0001
  - BR-PaymentGatewayCallbacks
---

# WIRE0003 – Thank You Payment Success

## Purpose

`/dekujeme` is the generic, story-agnostic landing page a donor's browser is returned to after a
payment attempt completes at a gateway. It realizes **UC0006 — Confirm Payment (Gateway Callback)**:
specifically the read-only browser-return step for Netopia (UC0006.2 step 9–10) and the redirect
step for MAIB (UC0006.3 step 8), where the Customer "receives a visual success/failure result but
does not perform a status-changing action" (UC0006, Actors & Responsibilities). Actor: Customer
(donor), anonymous or authenticated.

A second, independently-triggered overlay on this same route hosts **UC0025 — Resume or Discard
Draft Application** (the "Máte u nás rozpracovanou žádost" modal). Per `ui-observed-areas.md` §13,
this modal's appearance is "triggered by session state, independent of the just-completed donation"
— i.e. it is not part of the payment-confirmation flow and is documented here only as a co-resident
overlay. Its own behavior (resume/keep/delete) is owned by UC0025; this WIRE does not restate it.

Entry context: server-to-server callback confirmation happens off-screen (gateway ↔ System); the
Customer's browser arrives at this screen only via a redirect after leaving a payment gateway
(Comgate/S-EXT2 for CZ is evidenced as reaching a merchant-return route; Netopia/RO and MAIB/MD
browser-returns per UC0006.2/.3). See `IA-patronus.md` Entry Points ("gateway callback → `/dekujeme`").

---

## Layout Zones

- **Header** — global site navigation (logo "patron dětí"; nav: "Jak to funguje", "Blog", "O nás";
  CTA "Požádat o pomoc"; account link "Můj účet"). Confirmed. Navigation itself is IA-owned; listed
  here only to delimit the zone.
- **Hero / main content** — centered, single-column, on a light pink background:
  - success icon (red circle, white check mark)
  - headline: "Platba proběhla úspěšně, děkujeme za pomoc!"
  - two body paragraphs of thank-you copy
  - social-share icon row
  - primary CTA button: "Zpět na hlavní stránku"
- **Cookie banner** — bottom-fixed bar over the footer, dismissible ("Další informace" link); generic
  site-wide element, not screen-specific.
- **Footer** — global site footer (org description, Facebook link, Nadace Sirius attribution,
  registered-collection reference, sitemap-style link columns "Patron dětí"/"Kontakt", payment-partner
  logos, collection account number, legal links, copyright).
- **Modal overlay (conditional)** — centered dialog dimming the page background; hosts the
  resume-draft prompt (UC0025). See States → default (variant) and Conditional Visibility.

Confirmed — both screenshots (`screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png`,
`screencapture-patrondeti-cz-dekujeme-2026-07-04-13_30_32.png`).

```
+--------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | Požádat  |
|              o pomoc (CTA) | Můj účet                  |
+--------------------------------------------------------+
|                                                          |
|                    (✓) success icon                     |
|                                                          |
|      Platba proběhla úspěšně, děkujeme za pomoc!         |
|                                                          |
|   Každý příspěvek pomáhá k lepšímu dětství. Děkujeme,    |
|                  že jste s námi.                         |
|   Platba proběhla úspěšně! Moc děkujeme. Prosíme,        |
|      sdílejte a pomozte příběhu, kterému jste práve      |
|                     přispěli.                            |
|                                                          |
|         [FB] [X] [IG] [in] [WA] [Email] [Messenger]      |
|                                                          |
|              [ Zpět na hlavní stránku ]                  |
|                                                          |
+--------------------------------------------------------+
| Cookie banner: 🍪 ... Další informace .                  |
+--------------------------------------------------------+
| Footer: brand block | link columns | Kontakt |           |
| payment logos | account no. | legal links | © 2026       |
+--------------------------------------------------------+

Modal overlay (conditional — independent trigger, UC0025):
        +---------------------------------------+
        |                                    (x) |
        |              [→] icon                  |
        |     Máte u nás rozpracovanou žádost.    |
        |   Vypadá to, že jste u nás nechali...   |
        |  [ Návrat do žádosti ]  Zůstat na stránce|
        |  ----------------------------------------|
        |  Přejete si žádost o pomoc zcela zrušit? |
        |              Smazat žádost.              |
        +---------------------------------------+
```

---

## Components Used

The COMP layer does not yet exist for this reconstruction pass; every element below is flagged
`inline` pending a future COMPSynthesizer pass.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | inline | global nav bar | Shared across screens (see IA); not screen-specific to S003 |
| Hero | inline | success-status icon (check mark in circle, red/coral) | Confirmed, both screenshots |
| Hero | inline | headline text (H1-style, coral/red) | Confirmed |
| Hero | inline | body paragraph text (×2) | Confirmed |
| Hero | inline | social-share icon row (Facebook, X, Instagram, LinkedIn, WhatsApp, Email, Messenger) | Confirmed — 7 icons, no visible labels, icon-only buttons |
| Hero | inline | primary CTA button ("Zpět na hlavní stránku") | Confirmed |
| Cookie banner | inline | dismissible notice bar with link | Confirmed; generic/site-wide, not S003-specific |
| Footer | inline | global footer block | Shared across screens; not screen-specific to S003 |
| Modal | inline | dialog container (icon, title, body, two side-by-side actions, divider, secondary destructive link, close "×") | Confirmed, second screenshot |

---

## Interactions

1. **Entry** — browser redirect from a payment gateway (Comgate return route for CZ per
   UC0006 Main Flow's shared side effects; Netopia read-only return per UC0006.2 steps 9–10; MAIB
   redirect per UC0006.3 step 8) → state: `default`. No client-side data fetch is evidenced; the page
   renders a static success message regardless of amount/story (see Data Bindings).
2. **Primary action — "Zpět na hlavní stránku"** — click → navigates to the site's default landing
   page (S001, per `IA-patronus.md` Entry Points `/` → S001). Does not realize a UC itself (no
   status-changing action per UC0006's Actor description); it is a plain navigation exit.
3. **Secondary action — social share** — click one of 7 share icons → opens the respective external
   share flow (Facebook/X/Instagram/LinkedIn/WhatsApp/Email/Messenger). Target content (what URL/text
   is shared) is Uncertain — not observable from a static screenshot; the copy invites sharing "the
   story you just contributed to" but the generic page shows no story identifier (see Data Bindings,
   Open Question below).
4. **Modal — "Návrat do žádosti"** — click → resumes the draft Application per UC0025.1; not detailed
   here (owned by UC0025 / WIRE for the wizard screens, e.g. S008a–e).
5. **Modal — "Zůstat na stránce"** — click → dismisses modal, stays on S003 unchanged (UC0025.2).
6. **Modal — "Smazat žádost"** — click → discards the draft Application per UC0025.3 (destructive,
   styled as a plain text link, not a button — Confirmed from screenshot).
7. **Modal — close "×"** — click → dismisses modal (behavior identical to "Zůstat na stránce" is
   Assumed, not separately evidenced).
8. **Exit** — via primary CTA (→ S001) or via any header nav link (IA-owned) or by closing the tab.

---

## States

### default
The success message, share row, and CTA are shown against no other page-specific state (see
screenshot `..._13_31_51.png`). Confirmed.

### default (modal variant)
The same page dimmed underneath the resume-draft modal (see screenshot `..._13_30_32.png`).
Confirmed as a real, captured state; its trigger condition ("does this client hold an active
ApplicationSession, EN0003, for a not-yet-submitted Application, EN0001") is owned by UC0025 and is
itself marked Partial there — "the exact client-side trigger condition for showing the ... modal ...
is front-end (SPA) logic not present in this repository" (UC0025, Evidence Level). Not fabricated
further here.

### empty
N/A — this screen has no list/collection content that could be empty; it always renders the same
static success template regardless of the underlying Transaction's actual data (no amount/story
shown at all, confirmed by `ui-observed-areas.md` §13 note: "the generic success page shows no
amount/story name").

### loading
Evidence Pending — not captured. No loading indicator is visible in either screenshot, and no
client-side async fetch is evidenced for this page (the success message appears to render
server-side from the redirect, not from a client poll). Assumed: no loading state exists for the
core success content. Uncertain whether the modal's own appearance involves an async check
(e.g. a session-validity call per UC0025) before rendering — not evidenced.

### error
Evidence Pending — not captured. UC0006's Alternative Flows document failure paths at the
gateway/System boundary (AF1 callback-authenticity failure, AF3 MAIB-unreachable → shown as PENDING
success), but no failure-variant screenshot of `/dekujeme` itself exists. Per UC0006 Postconditions,
MAIB "any status other than CANCELLED is shown to the Customer as success, including a still-PENDING
outcome" — implying a genuinely failed/CANCELLED payment may route the Customer to a *different*
screen or a variant not captured here. Uncertain / Open Question — not asserted as this screen's
behavior.

---

## Validation Surfaces

None. This screen has no input form fields (`ui-observed-areas.md` §13: "Form fields / Tables: none").
The modal's actions ("Návrat do žádosti" / "Zůstat na stránce" / "Smazat žádost") are one-click
choices with no field-level validation observed.

validationsWithoutBR: (none — no validation surfaces identified on this screen)

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Success headline/body | — | — | Confirmed: static copy, no bound data. The page does not display the Transaction's (`EN0009`) amount, story, or any donor-specific value — confirmed absence per `ui-observed-areas.md` §13 note. |
| (not shown) Transaction outcome | `EN0009` | — | The underlying payment outcome that determines whether this page is reached at all is `EN0009` (Transaction) state, set by UC0006 — but no Transaction field is rendered on-screen. Listed for traceability only, not as an observed binding. |
| Modal body | `EN0001` / `EN0003` | — | The modal's premise ("Máte u nás rozpracovanou žádost") depends on an Application (`EN0001`) with an Active ApplicationSession (`EN0003`) existing for the current client, per UC0025 Preconditions. No count/identifier of the draft is shown in the modal copy (Confirmed from screenshot — text is generic, no application name/date rendered). |

Open Question: whether the social-share buttons carry any bound share-target (story slug/URL) is
Uncertain — not observable from static evidence; flagged for UC0006/COPY follow-up rather than
assumed here.

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Resume-draft modal | Client holds an `Active` ApplicationSession (`EN0003`) for a not-yet-submitted Application (`EN0001`) — condition owned by UC0025 Preconditions; no `BRxxxx`/`ACLxxxx` doc currently owns this trigger rule (flagged Partial in UC0025's own Evidence Level) | Modal absent; plain success page only (as in `..._13_31_51.png`) |
| "Můj účet" header link | Confirmed present regardless of auth state on this screen (shows "Můj účet" label in both screenshots); actual post-click destination is role/auth-gated per IA, not this screen's concern | n/a — IA-owned |

The ACL layer does not yet exist for this reconstruction pass; the modal's gating condition above is
recorded as an Open Question against UC0025/EN0003 rather than invented as a BR.

---

## Accessibility Notes

Uncertain / Evidence Pending for all items below — a static screenshot cannot confirm DOM order,
focus management, or ARIA usage; recorded as Assumed defaults per common pattern, not observed fact.

- **Tab order:** Assumed — header nav → hero share icons → primary CTA → footer links, following
  visual top-to-bottom, left-to-right order. Not evidenced.
- **Focus on entry:** Uncertain — not evidenced whether focus is programmatically set (e.g. to the
  H1) on arrival from the gateway redirect.
- **Focus on state transition (modal open):** Assumed — a well-formed modal would trap focus inside
  the dialog and move initial focus to its heading or first action ("Návrat do žádosti"); not
  evidenced from the screenshot alone.
- **Landmarks:** Uncertain — no DOM/ARIA evidence available from screenshots.
- **Keyboard shortcuts:** Uncertain — no evidence of an Escape-to-close behavior for the modal (visual
  "×" close control is present; whether it is keyboard-operable is not evidenced).

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Layout zones (header/hero/cookie banner/footer) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png` |
| Success headline/body copy, share icons, CTA | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png`; `ui-observed-areas.md` §13 |
| Modal layout and copy | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_30_32.png`; `ui-observed-areas.md` §13 |
| Modal trigger condition | Partial (owned by UC0025) | `_ar/spec-draft/UC/UC0025_ResumeDiscardDraftApplication.md` Evidence Level / Open Questions |
| No amount/story data shown | Confirmed | `ui-observed-areas.md` §13 ("the generic success page shows no amount/story name") |
| loading / error states | Uncertain — not captured | (absence of evidence; no screenshot or code-level FE state found) |
| UC0006 realization (browser-return semantics) | Confirmed | `_ar/spec-draft/UC/UC0006_ConfirmPayment.md` (Actors & Responsibilities; UC0006.2 steps 9–10; UC0006.3 step 8) |
