---
doc_id: IA-patronus
title: Information Architecture — Patronus (Patron dětí)
canonical_layer: IA
spec_type: information-architecture
scope: program
modules: []
status: draft
owners: [ux-lead, architect]
language: en
references:
  # referenced canonical doc_ids (each verified to resolve in _ar/spec-draft/ at authoring time):
  - UC0001  # Submit Application (self-registration + 5-step wizard)
  - UC0005  # Make a Donation
  - UC0006  # Confirm Payment (Gateway Callback)
  - UC0007  # Process Recurring Donation
  - UC0009  # Redeem / Validate Voucher
  - UC0010  # Issue Donation Confirmation (Tax)
  - UC0011  # Manage Campaign / Story Lifecycle
  - UC0014  # Authenticate & Manage Access
  - UC0023  # Browse & Filter Story Catalogue
  - UC0024  # Manage Donor Account (Self-Service)
  - UC0025  # Resume or Discard Draft Application
  - EN0001  # Application (Žádost)
  - EN0003  # ApplicationSession
  - EN0004  # Campaign (Story / Příběh)
  - EN0005  # Patron
  - EN0006  # Contact
  - EN0007  # Account
  - EN0008  # User
  - EN0009  # Transaction (Donation / Dar)
  - EN0010  # RecurringTransaction
  - EN0013  # Voucher (Dobrošek)
  - EN0014  # DonationConfirmation (CZ tax certificate)
  - EN0024  # Blog
  - EN0032  # ReportSnapshot
  - EN0033  # GiftCategory
  - EN0034  # DonorAccountView (donor zone read-model)
  - ES0001  # ComGate payment gateway (external boundary; see ES layer)
  - ARCH0001 # Application Overview (program architecture)
---

# IA — Patronus (Patron dětí)

## 1. Sources / Authority

This IA is reconstructed from the observed public + logged-in donor/applicant front-end of
`patrondeti.cz` (CZ tenant) and the reconstructed BA layers. Primary UI evidence:

- `_ar/coverage/ui-screen-index.md`, `_ar/coverage/ui-gap-analysis.md`
- `_ar/evidence/ui/ui-observed-areas.md` (durable per-screen observed detail — the primary evidence)
- `_ar/prtsc/**` (screenshots, glanced to confirm navigation/hierarchy)
- code-verified resolutions in `_ar/evidence/gap-closure-evidence.md`
  (role-choice landing → `/zadost/zadatel` + `/zadost/patron`; SBÍRKOVÝ ÚČET card = `isGeneral()`
  transparent-account campaign, not a story type)
- open IA-relevant items in `_ar/spec-draft/UI-gap-open-questions.md`
- referenced canonical docs (see `references:`)

Suggestive-only (not authoritative): observed UI is evidence of intent; reconstructed canonical
content (`_ar/spec-draft/{UC,EN,ARCH,ES}/`) wins on contradiction. Where a screen or route is visible
but its purpose or role-gating is unconfirmed, it is recorded in §8 Open IA Questions — not asserted
as a capability.

**Evidence scope caveat (carried from the coverage audit):** the captured surface is the anonymous +
donor/applicant public front-end only. **No admin back-office screen (`/admin/**`) was captured**, so
the large administrative navigation behind the reconstructed admin-side UCs (UC0002 status
orchestration, UC0003 risk, UC0004 contracts, UC0008 reconciliation, UC0016 party merge, UC0017
export) is out of this IA's evidence set. Its absence here is **not** evidence it is missing from the
system; this IA documents the observed public/self-service navigation surface only.

**Tenant caveat:** all screenshots are the **CZ tenant** (`patrondeti.cz`). RO/MD navigation is assumed
equivalent per the CZ/RO/MD multi-tenant model but is **not evidenced** (see §8, IA-Q6).

---

## 2. Top-Level Navigation

Observed primary navigation (verbatim CZ labels, per `_ar/evidence/ui/ui-observed-areas.md` §1 and the
homepage capture). All public-nav items are anonymous-reachable unless noted.

- **patron dětí** (logo) — return to homepage / story catalogue (S001) (`UC0023`).
- **Jak to funguje** — how-it-works / trust / aggregate stats / completed stories page (S016)
  (`UC0011`; aggregate-figures source unresolved — see §8 IA-Q7).
- **Blog** — editorial article listing (S013) (no owning UC; content — `EN0024`).
- **O nás** — about / team / documents / annual reports (S015) (static/institutional; no UC).
- **Požádat o pomoc** (CTA button) — enters the application intake at the role-choice landing (S006)
  (`UC0001`). Footer carries the equivalent "Chci přihlásit příběh" link.
- **Můj účet** — enters the logged-in account zone; when unauthenticated it routes to login (S009)
  (`UC0014`), when authenticated to the account area (S018–S020 / S011–S012) (`UC0024`).

Persistent chrome present on nearly every screen (not a nav destination): the **cookie-consent banner**
("Přijímám / Odmítnout / Další informace") and the **site footer** (collection-account number
57574646/0600, "Platby zprostředkovává: comgate" → `ES0001`, and the footer link cluster below).

Footer link cluster (observed, `_ar/evidence/ui/ui-observed-areas.md` §6, §16 and homepage capture):
O nás (S015), Blog (S013), **Pravidla poskytování pomoci** (rules PDF — external document, S-EXT4),
**Naše desatero** (Desatero download — on S015), **Splněné příběhy** (completed stories → S016),
**Výroční zprávy** (annual reports — on S015), "Jak jsme pomáhali v době koronakrize" (editorial),
"Souhlas se zpracováním osobních údajů", "Chci přihlásit příběh" (→ S006). The exact routes behind
several footer links are not individually evidenced (see §8 IA-Q8).

**Account menu / logged-in "Můj účet" zone.** Evidence confirms three per-role self-service account
zones and two "Můj účet" sub-pages (see §3.6). The evidence does **not** confirm a single composed
account-menu widget or a unified dashboard page that links them (see §8 IA-Q2, IA-Q3):

- Account settings — "Nastavení účtu" (S011) (`UC0024`).
- Donation tax confirmations — "Potvrzení o darech" (S012) (`UC0010`).
- Donor zone — "Moje zóna" / donation history by supported story (S018) (`UC0024`, read-model `EN0034`).
- Applicant (fundraiser) zone (S019) and Patron zone (S020) (`UC0024`-adjacent; role-gated, see §8 IA-Q4).

---

## 3. Screen Map

Stable `S###` screen-ids (minted once, kept stable across reruns). Each screen carries a one-line
purpose and, where it foregrounds a foundational entity, an `ENxxxx`. Full evidence + certainty per
screen lives in `_ar/spec-draft/IA-screen-map.md`; this section is the navigational grouping.

### 3.1 Public site (anonymous)

- **S001** Homepage — story catalogue with filter tabs — the primary donor-acquisition landing;
  browse/filter active Stories (`EN0004`), hero recurring-donation presets (`EN0010`), voucher block
  (`EN0013`).
- **S013** Blog — article listing (`EN0024`).
- **S014** Blog — article detail (`EN0024`).
- **S015** O nás — about / team / Desatero / annual reports / control protocols (static/institutional).
- **S016** Jak to funguje / Výsledky — how-it-works, trust, aggregate impact stats, completed stories
  (`EN0004`; aggregate figures possibly `EN0032` — unconfirmed, §8 IA-Q7).

### 3.2 Story & donation

- **S002** Story detail + one-off donation modal (`EN0004`, `EN0009`) — also surfaces Patron comment
  (`EN0005`), remaining-amount, voucher-apply entry ("Mám dobrošek", `EN0013`), category-support CTA.
- **S003** Thank-you / payment-success landing ("Platba proběhla úspěšně") (`EN0009`).

### 3.3 Application flow (intake)

- **S006** Role-choice landing — "Požádat o pomoc" selection of "help my child" (fundraiser) vs "help a
  child I know" (patron) (`EN0001`). URL not code-confirmed (§8 IA-Q1).
- **S007** Application intake — "Údaje o žadateli" contact/consent gate (`/zadost/zadatel`) (`EN0001`,
  `EN0006`) — the fundraiser-role first step; a "Zpět na výběr" link returns to S006.
- **S008a** Application wizard step 1 — "Váš příběh" (child identity + story + flags) (`EN0001`,
  `EN0002`).
- **S008b** Application wizard step 2 — "Dar, kterým vám pomůžeme" — gift-category picker (`EN0033`).
- **S008c** Application wizard step 3 — "Údaje o vás" — applicant data (`EN0006`).
- **S008d** Application wizard step 4 — "Patron" (stepper-only; fields not captured) (`EN0005`).
- **S008e** Application wizard step 5 — "Přílohy" (stepper-only; fields not captured) (`EN0001`).

(Steps 1–5 share the single `/zadost-formular` route/aggregate; the per-step screen-ids let WIRE bind
each step. Steps 4–5 exist as stepper labels only in evidence — see §8 IA-Q5.)

### 3.4 Authentication & account provisioning

- **S009** Login — magic-link e-mail entry + "sent" confirmation (`/prihlaseni`) (`UC0014`, `EN0008`).
- **S010** Account activation — set password + accept terms (`/aktivovat-ucet`) (`UC0014`, `EN0008`).
- **S021** Activation entry — "already donor/applicant/patron, send activation link"
  (`/overit-prihlaseni`) (`UC0014`, `EN0008`).
- **S022** Activation-link-sent confirmation (`/poslat-aktivacni-email`) — content not evidenced
  (footer-only capture); recorded, not asserted (§8 IA-Q9).

### 3.5 Voucher (Dobrošek)

- **S005** Voucher purchase entry — homepage "Dobrošeky" block / "Koupím dobrošek" (`EN0013`); the
  dedicated purchase screen is **not captured** — entry point evidenced, screen not (§8 IA-Q10).

### 3.6 Logged-in "Můj účet" account zone

- **S011** Nastavení účtu — profile settings (name, e-mail display, profile photo)
  (`/muj-ucet/nastaveni`) (`EN0006`, `EN0008`).
- **S012** Potvrzení o darech — tax-confirmation request form (`/muj-ucet/potvrzeni-o-darech`)
  (`EN0014`, `EN0015`).
- **S018** Donor zone — "Moje zóna", donation history grouped by supported story (`zona/darce`)
  (`EN0034`, read-model over `EN0009`/`EN0004`).
- **S019** Applicant (fundraiser) zone (`zona/zadatel`) — applicant's own Applications (`EN0001`).
  Role-gated; screen not captured (§8 IA-Q4).
- **S020** Patron zone (`zona/patron`) — patron's own Applications/Stories (`EN0001`, `EN0005`).
  Role-gated; screen not captured (§8 IA-Q4).
- **S017** Account dashboard (composed "Můj účet") — **Hypothesis only**: implied by a mockup embedded
  in a marketing e-mail, never captured as a real screen; do not treat as built (§8 IA-Q3).

### 3.7 External / shared-platform surfaces (excluded — not Patronus-built)

Recorded so WIRE/COMP do **not** reconstruct them as app UI; Patronus owns only the integration
boundary, not the screen (see `_ar/spec-draft/IA-screen-map.md` for the excluded rows):

- **S-EXT1** Comgate hosted gateway — payment-method selection (`pay1gate.cz/specify/…`) (`ES0001`).
- **S-EXT2** Comgate hosted gateway — paid / redirect-back (`pay1gate.cz/dispatcher/…`) (`ES0001`).
- **S-EXT3** Revolut ACS 3-D Secure card challenge (issuer-side) — part of `UC0005` checkout, not
  Patronus-owned.
- **S-EXT4** Rules PDF in the browser PDF viewer — the document is high-authority EN/glossary source;
  the viewer chrome is platform, not app UI.

Transactional e-mails (MSG layer, not screens): the donation thank-you (`MSG0019`) and the
finish-your-account follow-up (`MSG0003`, disputed) are indexed as MSG-mapped rows in
`_ar/spec-draft/IA-screen-map.md`, not as screens.

---

## 4. Entry Points

Each entry references the `UCxxxx` it triggers. "Auth" = authenticated session required.

| Entry | Trigger | First screen | UC ref | Auth required |
|---|---|---|---|---|
| `/` | anonymous visit | S001 | `UC0023` | no |
| `/pribeh/<slug>` | story link from catalogue / share | S002 | `UC0005` (via `UC0023` handoff) | no |
| donation modal → gateway | "Přejít k platbě" on S002 | S-EXT1 (`ES0001`) | `UC0005` | no |
| gateway callback → `/dekujeme` | payment result redirect | S003 | `UC0006` | no |
| hero preset "Daruj N Kč měsíčně" | recurring-donation CTA on S001 | (donation flow) | `UC0007` | no |
| "Koupím dobrošek" | voucher-purchase CTA on S001/S002 | S005 (screen uncaptured) | `UC0009` | no |
| "Mám dobrošek" / voucher-apply | voucher redemption entry on S002 | S002 (modal) | `UC0009` | no |
| `/blog` | "Blog" nav | S013 | (no UC — `EN0024`) | no |
| `/o-nas` | "O nás" nav | S015 | (no UC) | no |
| `/vysledky` | "Jak to funguje" nav / "Splněné příběhy" | S016 | `UC0011` | no |
| `/pozadat-o-pomoc` (or `/zadost`) | "Požádat o pomoc" nav / footer "Chci přihlásit příběh" | S006 | `UC0001` | no |
| `/zadost/zadatel` | fundraiser role card on S006 | S007 → wizard S008a | `UC0001` | no |
| `/zadost/patron` | patron role card on S006 | (patron intake — uncaptured) | `UC0001` | no |
| `/zadost-formular` | redirect from S007 after contact/consent | S008a | `UC0001` | no |
| `/dekujeme` resume modal | return visit with active draft session (`EN0003`) | S003 (modal) | `UC0025` | no |
| `/prihlaseni` | "Můj účet" while unauthenticated | S009 | `UC0014` | no |
| `/aktivovat-ucet` | activation link from e-mail | S010 | `UC0014` | no |
| `/overit-prihlaseni` | "already donor/applicant/patron, activate" | S021 | `UC0014` | no |
| `/muj-ucet/nastaveni` | "Můj účet" → settings (post-auth) | S011 | `UC0024` | yes |
| `/muj-ucet/potvrzeni-o-darech` | "Můj účet" → tax confirmations (post-auth) | S012 | `UC0010` | yes |
| `zona/darce` | donor account zone (post-auth) | S018 | `UC0024` | yes (`supporter` role) |
| `zona/zadatel` | applicant account zone (post-auth) | S019 | `UC0024` | yes (role-gated, §8 IA-Q4) |
| `zona/patron` | patron account zone (post-auth) | S020 | `UC0024` | yes (role-gated, §8 IA-Q4) |

---

## 5. Cross-Module Flows

Each step references its `UCxxxx`; no inline restatement of UC content.

### Donation flow (anonymous donor → paid)

1. S001 catalogue browse/filter → choose a story (`UC0023`)
2. S002 story detail → open one-off donation modal, enter amount + contact + consents (`UC0005`)
3. S-EXT1 Comgate method selection (`ES0001`, `UC0005`)
4. S-EXT3 Revolut 3-D Secure challenge, when card issuer requires it (`UC0005`)
5. S-EXT2 Comgate paid / redirect back to merchant (`ES0001`, `UC0006`)
6. S003 `/dekujeme` payment-success landing (`UC0006`)
7. (async) donation thank-you e-mail `MSG0019` — promotes account activation

### Application intake flow (fundraiser)

1. S006 role-choice landing → pick "help my child" (fundraiser) (`UC0001`)
2. S007 `/zadost/zadatel` contact + consent gate; activation e-mail sent (`UC0001`, `UC0014`)
3. redirect to S008a `/zadost-formular` wizard (`UC0001`)
4. S008a step 1 Váš příběh → S008b step 2 Dar (gift-category, `EN0033`) → S008c step 3 Údaje o vás
   → S008d step 4 Patron → S008e step 5 Přílohy (`UC0001`)
5. (later visit) S003/S-any resume-draft modal → resume / keep / delete (`UC0025`, `EN0003`)

### Account activation / provisioning flow (implicit party → login)

1. anonymous donation (`UC0005`) or application (`UC0001`) provisions a party record (`EN0006`/`EN0008`)
2. S021 `/overit-prihlaseni` — existing party requests an activation link (`UC0014`)
3. S022 `/poslat-aktivacni-email` link-sent confirmation (`UC0014`; content unconfirmed, §8 IA-Q9)
4. activation e-mail `MSG0003` → S010 `/aktivovat-ucet` set password + accept terms (`UC0014`)
5. authenticated → account zone (S011 / S018) (`UC0024`)

### Login flow (returning party)

1. S009 `/prihlaseni` enter e-mail → magic-link e-mail `MSG0004` (`UC0014`)
2. link → authenticated → account zone (S011 / S018) (`UC0024`)
3. fallback: password login for activated accounts (`UC0014`)

### Tax-confirmation self-service (logged-in donor)

1. S018/S011 account zone → "Potvrzení o darech" (`UC0024` → `UC0010`)
2. S012 `/muj-ucet/potvrzeni-o-darech` — person-type tabs, request certificate (`UC0010`, `EN0014`)

---

## 6. Information Hierarchy

Reference `ENxxxx` at each level; do not enumerate entity attributes or configuration values.

- **Account / party level:** the authenticated party identity and its self-service zone — User
  (`EN0008`), Contact (`EN0006`), owner-scoped Account record (`EN0007`), and the donor-zone
  read-model DonorAccountView (`EN0034`).
- **Application (Žádost) level:** the case record an applicant creates and returns to — Application
  (`EN0001`), the role-specific ApplicationProfile behind the wizard steps (`EN0002`), the draft-access
  ApplicationSession (`EN0003`), and the requested-gift classification GiftCategory (`EN0033`).
- **Story (Příběh) / Campaign level:** the public fundraising story browsed and supported — Campaign
  (`EN0004`) and its verifying Patron (`EN0005`).
- **Donation (Dar) level:** the money a donor gives — Transaction (`EN0009`), RecurringTransaction for
  the monthly-preset path (`EN0010`), Voucher for the Dobrošek path (`EN0013`), and the CZ tax
  DonationConfirmation the donor requests (`EN0014`).
- **Content / institutional level:** editorial and trust content — Blog (`EN0024`) and the
  aggregate-impact figures possibly backed by ReportSnapshot (`EN0032` — unconfirmed, §8 IA-Q7).

---

## 7. Module Boundaries (UX layer)

UX-layer grouping of the observed self-service surface. These are navigation clusters, not the
code-level module decomposition (AR reconstruction has no module map; see `ARCH0001`). Cross-module
dependencies are UX hand-offs, not code coupling.

| UX cluster | Owns screens | Cross-cluster dependencies |
|---|---|---|
| Public site & content | S001, S013, S014, S015, S016 | hands off to Story & donation (S002) and Application intake (S006) |
| Story & donation | S002, S003, S005 | uses External gateway (S-EXT1/2/3) for `UC0005`/`UC0006`; entered from S001 |
| Application intake | S006, S007, S008a–S008e | after contact gate redirects into itself (wizard); shares Auth (activation e-mail) |
| Authentication & provisioning | S009, S010, S021, S022 | gates the Account zone; entered from "Můj účet" and from post-donation/application prompts |
| Account zone ("Můj účet") | S011, S012, S018, S019, S020, (S017 hypothesis) | requires Auth cluster; S012 realizes `UC0010`; role-split S018/S019/S020 |
| External / platform (excluded) | S-EXT1, S-EXT2, S-EXT3, S-EXT4 | not Patronus-built; integration boundary only (`ES0001`) |

**Boundary note:** AR reconstruction produced **no** `_ar/repo-map/modules.md`-style UX module map to
override, so no module-boundary conflict can be asserted here; the clusters above are IA-authored
groupings. The one boundary tension worth flagging is the **three-way account-zone split**
(`zona/darce` vs `zona/zadatel` vs `zona/patron`) versus the **two `/muj-ucet/*` sub-pages** — whether
these compose into one "Můj účet" area or are separate role-gated areas is unresolved (§8 IA-Q2, IA-Q3).

---

## 8. Open IA Questions

Mandatory. Every unresolved navigation/role/route decision, with a named decider and status. None may
be silently assumed.

| # | Question | Context / Impact | Decided by | Status |
|---|---|---|---|---|
| IA-Q1 | What is the **URL of the role-choice landing page** (S006) itself? | Code hard-codes the *outgoing* links `/zadost/zadatel` + `/zadost/patron` (`_ar/evidence/gap-closure-evidence.md` OQ-01); two menu links point at candidates — `'Chci přihlásit příběh' → /zadost` and `'Požádat o pomoc' → /pozadat-o-pomoc` — but which (or whether both alias one view) is Uncertain. Affects the canonical application entry-point URL for the rebuild. | Architect + client (routes/process-maps) | open |
| IA-Q2 | Is the **"Můj účet" area one composed page or several separate role-gated pages**? | Two `/muj-ucet/*` sub-pages (S011, S012) plus three `zona/*` per-role zones (S018–S020) are code-confirmed as separate mechanisms (REST resource vs Drupal Views); no code links them into one menu/dashboard (`UC0024` Evidence Pending). Affects the whole account IA and the account-menu design. | UX-lead + architect | open |
| IA-Q3 | Does the **richer composed account dashboard (S017)** — "Pro vás / Všechny (N)" tabs, per-story countdown, downloadable confirmations, feedback — actually exist? | Evidenced **only** by a mockup inside the "Dokončete svůj uživatelský účet" e-mail (`_ar/evidence/ui/ui-observed-areas.md` §19); no real screen, view, or controller in backend source (`EN0034` Evidence Gaps). Treated as Hypothesis; must not be reconstructed as built. | Product + UX-lead | open |
| IA-Q4 | What are the **role-gates and actual screens** for `zona/zadatel` (S019) and `zona/patron` (S020)? | `zona/darce` is `supporter`-role-gated and code-confirmed (`EN0034`); the sibling `fundraiser_zone` / `patron_zone` views exist (base_table `application`) but their screens were **not captured** and no ACL layer exists to cite. Role labels recorded; gating unconfirmed. Affects applicant/patron self-service IA. | Architect (ACL follow-up) | open |
| IA-Q5 | What do **application wizard steps 4 "Patron" (S008d) and 5 "Přílohy" (S008e)** contain? | Present only as stepper labels in evidence; fields/behaviour never captured (`_ar/coverage/ui-gap-analysis.md` §b C1). Code confirms step 4 = `patron_*` fields, step 5 = attachments/employment (`_ar/evidence/gap-closure-evidence.md` OQ-01), but no screen evidence for WIRE. | UX-lead (re-capture / code) | open |
| IA-Q6 | Is the **RO/MD navigation equivalent** to the observed CZ navigation? | All evidence is CZ tenant. `zona/darce` (`supporter_zone` view) is present only under `config_czech`; RO/MD equivalence is unconfirmed (`EN0034` Evidence Gap 2, `UC0024`). Affects whether one IA covers all three tenants or per-tenant IAs are needed. | Architect + client | open |
| IA-Q7 | Are the **"Výsledky" aggregate impact figures** (S016) a computed read-model or static editorial content? | Not determinable from the screenshot (`_ar/evidence/ui/ui-observed-areas.md` §17); may be `EN0032` ReportSnapshot / `UC0017` or hardcoded copy. Affects whether S016 is a dynamic screen or a content page. | Architect (code) | open |
| IA-Q8 | Which **routes back the footer link cluster** (Pravidla poskytování pomoci, Naše desatero, Splněné příběhy, Výroční zprávy, "koronakrize", "Souhlas se zpracováním")? | Footer links observed verbatim (`_ar/evidence/ui/ui-observed-areas.md` §6, §16) but their targets are only partially evidenced — Pravidla resolves to the rules PDF (S-EXT4), Splněné příběhy to S016; others (Desatero, annual reports) render on S015; the rest are unmapped. Low rebuild risk; recorded for completeness. | Content owner | open |
| IA-Q9 | What is the actual **content of `/poslat-aktivacni-email` (S022)**? | Capture shows only nav + cookie banner + footer; the confirmation body is out of frame (`_ar/spec-draft/UI-gap-open-questions.md` OQ-03). Behaviour inferred, not evidenced. Low priority — likely a trivial confirmation of `UC0014`. | UX-lead (re-capture / code) | open |
| IA-Q10 | Where is the **voucher (Dobrošek) purchase screen (S005)**, and what is its route/flow? | Only the purchase *entry points* ("Koupím dobrošek" on S001, "Mám dobrošek" on S002) are captured; no purchase screen exists in evidence. `UC0009` covers redeem/validate; the purchase-checkout screen is a gap. | UX-lead (re-capture / code) | open |
| IA-Q11 | What is the **SBÍRKOVÝ ÚČET / "Nechám to na vás" card's trigger condition** on the catalogue (S001)? | Code confirms this is **not** a story type: it is the single `isGeneral()` transparent-account campaign (`Settings::get('transparent_account')`), given special card treatment by a decoupled front-end component not in this source (`_ar/evidence/gap-closure-evidence.md` OQ-05). Whether every `isGeneral()` campaign or only a specific one gets the "Nechám to na vás" card is not evidenced. Affects catalogue card IA. | Architect (front-end repo / runtime) | open |
| IA-Q12 | Is the **`/zadost/patron` patron-intake path** structured like the fundraiser wizard? | Role-choice S006 offers a patron card → `/zadost/patron`; only the fundraiser path (S007→S008) was captured. The patron intake screens are unobserved. Affects the patron-side application IA. | UX-lead (re-capture / code) | open |

---

## 9. What this IA does NOT cover

This IA does not decide (reference the doc_id, never restate):

- detailed use-case flows → `_ar/spec-draft/UC/`
- entity attributes / lifecycle → `_ar/spec-draft/EN/`
- business rules / configuration values → `_ar/spec-draft/BR/`
- access-control rules → **no ACL layer exists in this reconstruction**; role-gated nav items note the
  observed role and raise an Open IA Question (IA-Q4) instead of citing a non-existent `ACLxxxx`
- external-system integration detail / provider internals → `_ar/spec-draft/ES/` (`ES0001` ComGate etc.)
- technology stack / UI kit → `_ar/spec-draft/ARCH/` (`ARCH0001`)
- transactional message content → `_ar/spec-draft/MSG/`
- per-screen layout, zones, components, copy → `WIRE` / `COMP` / `COPY` (next: WIRESynthesizer)
- the admin back-office navigation (`/admin/**`) — out of the captured evidence set entirely
