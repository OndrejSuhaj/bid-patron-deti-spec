---
doc_id: COPY-shared-global
title: Shared Global Chrome Copy — Header, Footer, Cookie Consent
canonical_layer: COPY
spec_type: copy
scope: shared-global
modules: []
language: cs
status: draft
references:
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0005
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0019
  - WIRE0021
  - WIRE0023
  - WIRE0024
  - WIRE0025
  - COMP0002
  - COMP0003
  - COMP0004
  - UC0023
  - UC0001
  - UC0014
---

# COPY-shared-global – Shared Global Chrome Copy (Header, Footer, Cookie Consent)

## Purpose

Text surface for the cross-screen chrome that recurs on nearly every Patronus screen: the global
top navigation (`COMP0002`), the global site footer (`COMP0003`), and the cookie-consent banner in
both its observed renderings (`COMP0004`). This chrome is described identically across ≥19 of the
22 written WIRE docs (`_ar/spec-draft/WIRE-synthesis-report.md` §6). Screen-specific content (hero
copy, form labels, per-screen CTAs, validation messages) is out of scope here and lives in the
relevant `module-*` COPY document. Text is transcribed **verbatim** from
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (header, footer, dual-action cookie
banner) and `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`
(single-action cookie banner), cross-checked against `_ar/evidence/ui/ui-observed-areas.md` §1, §6,
§16, and `COMP0002`/`COMP0003`/`COMP0004`.

The header renders identically regardless of authentication state observed in evidence: the
`_ar/prtsc/po_prihlaseni_do_uctu.png` capture (post-login) shows the same wordmark, nav links, and
"Můj účet" label as the anonymous homepage capture — only the link's downstream destination differs
(IA-owned, not a COPY concern; `COMP0002` props `isAuthenticated`). No distinct "Přihlásit se" nav
item was observed in the header itself; "Přihlásit se" is the login-form submit CTA on S009 and is
owned by `COPY-module-auth` (`module-auth.login.submit-cta`), not this document.

---

## Labels

| Key | Text | Usage (WIRE/COMP ref) |
|---|---|---|
| `shared-global.header.logo` | `patron dětí` | `COMP0002`; wordmark/home link, all screens |
| `shared-global.header.tagline` | `společně za lepší dětství` | `COMP0002`; small red subtitle under the wordmark |
| `shared-global.footer.brand-heading` | `patron dětí` | `COMP0003` brand block |
| `shared-global.footer.brand-blurb` | `Patron dětí je charitativní projekt, který pomáhá zdravotně a sociálně znevýhodněným dětem a jejich rodinám z celé České republiky.` | `COMP0003` brand block |
| `shared-global.footer.social-label` | `Sledujte nás na` | `COMP0003` brand block, next to the Facebook icon link |
| `shared-global.footer.sirius-attribution` | `Patron dětí je projektem Nadace Sirius` | `COMP0003` brand block; "Nadace Sirius" is a link |
| `shared-global.footer.collection-registration` | `Zaregistrovaná veřejná sbírka: Sp. zn. S-MHMP/836092/2017` | `COMP0003` brand block |
| `shared-global.footer.column-heading.patron-deti` | `Patron dětí` | `COMP0003`; first link-column heading |
| `shared-global.footer.column-heading.kontakt` | `Kontakt` | `COMP0003`; second link-column heading |
| `shared-global.footer.contact-email-label` | `E-mail` | `COMP0003` Kontakt column |
| `shared-global.footer.contact-email-value` | `info@patrondeti.cz` | `COMP0003` Kontakt column; `mailto:` link |
| `shared-global.footer.payments-label` | `Platby zprostředkovává:` | `COMP0003`; precedes the Comgate/Mastercard/Visa badge row |
| `shared-global.footer.collection-account-label` | `Číslo sbírkového účtu: 57574646/0600` | `COMP0003` |
| `shared-global.footer.copyright` | `© 2026 Patron dětí. Všechna práva vyhrazena.` | `COMP0003` bottom bar |

---

## Helper Texts

`(none)` — the footer and header carry no distinct helper-text role beyond the labels/links already
listed above and the CTAs below; no additional inline instructional copy was observed on the chrome
itself.

---

## Empty States

`N/A` — header, footer, and cookie banner are static chrome, not data listings; no empty-state
condition applies (`COMP0002`/`COMP0003`/`COMP0004` States sections all mark this `N/A`).

---

## Loading Texts

`N/A` — no async operation is owned by the header, footer, or cookie banner themselves
(`COMP0002`/`COMP0003`/`COMP0004` States→loading, all `N/A`).

---

## Error / Validation Messages

`N/A` — the global chrome hosts no form fields and triggers no validation. No `BRxxxx`/`ENxxxx`
governs header/footer/cookie-banner content; this section is intentionally empty per
`cross-layer-discipline.md` §5 (skip-empty-sections applies to placeholder-only content, but
Open Questions below record the one related gap: no BR governs the cookie-consent action itself).

---

## CTAs

Every CTA references the use case it realizes. Chrome navigation targets (nav links, footer links)
are IA-owned per `cross-layer-discipline.md`; where no `UCxxxx` document owns the destination
behavior, that is recorded as an Open Question rather than invented.

| Key | Text | Action |
|---|---|---|
| `shared-global.nav.how-it-works` | `Jak to funguje` | Navigates to the "How it works" content screen (`S019`/`WIRE0019` per IA); no dedicated UC — static content navigation. **Open Question** — no `UCxxxx` owns this nav target. |
| `shared-global.nav.blog` | `Blog` | Navigates to the Blog listing screen; no dedicated UC — static content navigation. **Open Question** — no `UCxxxx` owns this nav target. |
| `shared-global.nav.o-nas` | `O nás` | Navigates to the "About us" content screen; no dedicated UC — static content navigation. **Open Question** — no `UCxxxx` owns this nav target. |
| `shared-global.nav.pozadat-o-pomoc-cta` | `Požádat o pomoc` | `UC0001` (Submit Application) — enters the role-choice landing (S006) that begins Application intake |
| `shared-global.nav.muj-ucet-cta` | `Můj účet` | `UC0014` (Authenticate & Manage Access) — routes to login (S009) when unauthenticated or to the account area when authenticated; label is identical in both auth states (`COMP0002` props `isAuthenticated`, not restated here) |
| `shared-global.footer.link.o-nas` | `O nás` | Same destination as `shared-global.nav.o-nas`; footer "Patron dětí" column. **Open Question** — no `UCxxxx` owns this nav target. |
| `shared-global.footer.link.blog` | `Blog` | Same destination as `shared-global.nav.blog`; footer "Patron dětí" column. **Open Question** — no `UCxxxx` owns this nav target. |
| `shared-global.footer.link.pravidla` | `Pravidla poskytování pomoci` | Opens the rules PDF (`S-EXT4` per `_ar/spec-draft/IA-screen-map.md`); no `UCxxxx` — document view. **Open Question** per `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.desatero` | `Naše desatero` | Content screen; no `UCxxxx` owns this target. **Open Question** per `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.splnene-pribehy` | `Splněné příběhy` | Navigates to S016 (completed-stories listing); no `UCxxxx` owns this target — content browsing, not `UC0023`. **Open Question** per `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.vyrocni-zpravy` | `Výroční zprávy` | Content screen (renders on S015 per `IA-patronus.md` IA-Q8); no `UCxxxx` owns this target. **Open Question**. |
| `shared-global.footer.link.koronakrize` | `Jak jsme pomáhali v době koronakrize` | Content screen; no `UCxxxx` owns this target. **Open Question** per `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.gdpr-consent` | `Souhlas se zpracováním osobních údajů` | Target unresolved — no `UCxxxx`, no confirmed destination screen. **Open Question** per `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.chci-prihlasit-pribeh` | `Chci přihlásit příběh` | `UC0001` (Submit Application) — footer-equivalent entry point to the same role-choice landing (S006) as the header "Požádat o pomoc" CTA (`IA-patronus.md` §2) |
| `shared-global.cookie-banner.accept-cta` | `Přijímám` | No owning UC — client-side consent-persistence action, mechanism not evidenced (`COMP0004` `onAccept`). **Open Question** — no BR governs cookie consent. |
| `shared-global.cookie-banner.reject-cta` | `Odmítnout` | No owning UC — dual-action variant only (`COMP0004` `onReject`); no confirmed behavioral difference from accept observed. **Open Question** — no BR governs cookie consent. |
| `shared-global.cookie-banner.more-info-cta` | `Další informace` | Target not confirmed in evidence, likely a cookie-policy page (not captured); single-action variant. **Open Question.** |
| `shared-global.cookie-banner.modal-more-info-cta` | `Více zde.` | Same unresolved target as `shared-global.cookie-banner.more-info-cta`, shown inline in the dual-action privacy-modal body text. **Open Question.** |
| `shared-global.cookie-banner.customize-cta` | `Přizpůsobit` | Dual-action privacy modal; opens a cookie-preferences panel, not itself captured (no further screenshot). **Open Question.** |
| `shared-global.cookie-banner.modal-reject-cta` | `Odmítnout` | Dual-action privacy modal secondary button; same key text as `shared-global.cookie-banner.reject-cta`, distinct instance inside the modal card. **Open Question.** |
| `shared-global.cookie-banner.modal-accept-all-cta` | `Přijmout vše` | Dual-action privacy modal primary button. **Open Question** — no BR governs cookie consent. |

---

## Cookie Consent Banner — Text Variants (COMP0004)

Two visually distinct renderings were directly observed (`COMP0004` Variants: `single-action` /
`dual-action`, flagged `Uncertain` whether they are one parameterized component or two independent
mechanisms — not resolved here, restated only as the observed text per variant).

### dual-action variant (floating bottom-left card, observed on homepage default-tab capture)

| Key | Text | Usage |
|---|---|---|
| `shared-global.cookie-banner.dual.modal-heading` | `Záleží nám na vašem soukromí` | `WIRE0001` (S001, dual-action card) |
| `shared-global.cookie-banner.dual.modal-body` | `Pomocí cookies vylepšujeme příjemnost prohlížení, nabízíme na míru přizpůsobené reklamy či obsah a analyzujeme návštěvnost stránky. Kliknutím na „Přijmout vše" vyjadřujete souhlas s tím, jak cookies používáme.` | `WIRE0001` (S001, dual-action card); contains the inline `Více zde.` link |

### single-action variant (full-width dark bottom bar, observed on multiple other screens)

| Key | Text | Usage |
|---|---|---|
| `shared-global.cookie-banner.single.body` | `🍪 Tyto stránky používají k poskytování služeb soubory cookie. Používáním tohoto webu s tím souhlasíte. Další informace.` | Confirmed on `WIRE0006`, `WIRE0007`, `WIRE0013`, `WIRE0024`, and directly re-verified on `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` in this pass; the leading cookie emoji glyph is part of the observed rendering |

---

## Microcopy Conventions

- Tone: neutral-to-warm, direct; nav/footer/CTA labels use short noun phrases or imperative verbs
  ("Požádat o pomoc", "Přijímám", "Odmítnout"); no distinct persona voice beyond the rest of the
  public site.
- Person: 2nd person plural implied in cookie-consent body copy ("Používáním tohoto webu s tím
  souhlasíte", "vyjadřujete souhlas"); nav/footer labels are impersonal noun phrases.
- Capitalization: sentence case throughout; nav items are short lowercase-continuation phrases after
  the initial capital ("Jak to funguje", "O nás"); footer column headings are title-like single/two
  words ("Patron dětí", "Kontakt").
- Punctuation: footer legal/copyright lines end with a full stop; nav links and most CTA button
  labels carry no trailing punctuation; the cookie-banner single-action body is a run of complete
  sentences ending in full stops, with the trailing link "Další informace" itself followed by a
  standalone full stop in the observed rendering.
- Currency/number formatting (footer collection-account number, registration reference) is
  transcribed verbatim and not treated as COPY-owned formatting logic.

---

## Open Questions

- **OQ-COPY-shared-global-1:** No `BRxxxx` or `UCxxxx` document governs the cookie-consent banner's
  accept/reject/customize actions or their persistence mechanism (`COMP0004` Open Questions;
  `cross-layer-discipline.md` gap). Recorded as an open question on every cookie-banner CTA row
  above rather than invented.
- **OQ-COPY-shared-global-2:** Whether `single-action` and `dual-action` cookie-banner renderings are
  the same parameterized component or two independently built mechanisms is unresolved
  (`COMP0004` Open Questions) — both text variants are transcribed here without asserting which
  screens get which variant beyond direct observation.
- **OQ-COPY-shared-global-3:** Footer link destinations for "Pravidla poskytování pomoci" (partially
  resolved to a PDF), "Naše desatero", "Výroční zprávy", "Jak jsme pomáhali v době koronakrize", and
  "Souhlas se zpracováním osobních údajů" are only partially evidenced (`IA-patronus.md` IA-Q8); no
  `UCxxxx` is asserted for these beyond what is stated above.
- **OQ-COPY-shared-global-4:** "Jak to funguje", "Blog", and "O nás" primary-nav items have no
  identified owning `UCxxxx` — they are static content navigation, out of the numbered use-case set
  reconstructed for Patronus. Not treated as a gap requiring invented copy, only recorded.

---

## Evidence

| Key area | Certainty | Evidence |
|---|---|---|
| Header wordmark, tagline, nav links, "Požádat o pomoc" CTA, "Můj účet" link (anonymous) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`; `_ar/evidence/ui/ui-observed-areas.md` §1; `COMP0002` |
| Header identical rendering post-authentication | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu.png` (direct inspection, this pass) |
| Footer brand blurb, social label, Sirius attribution, collection registration, link columns, contact e-mail, payment badges, collection-account number, copyright | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (direct crop inspection, this pass); `_ar/evidence/ui/ui-observed-areas.md` §1; `COMP0003` |
| Cookie banner — dual-action variant (modal heading/body, Přizpůsobit/Odmítnout/Přijmout vše) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (direct crop inspection, this pass); `COMP0004` |
| Cookie banner — single-action variant (full body text) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` (direct inspection, this pass); `_ar/evidence/ui/ui-observed-areas.md` §6, §16; `COMP0004` |
| Footer link-target ownership (UC/content-screen mapping) | Partial / Uncertain | `_ar/spec-draft/IA/IA-patronus.md` IA-Q8; see Open Questions |
| Cookie-consent action ownership (BR/UC) | Uncertain — no owning document found | `COMP0004` Open Questions; see Open Questions |
