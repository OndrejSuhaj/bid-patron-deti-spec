---
doc_id: DESIGN-component-index
title: Design Component Index — canonical @patron/ui library
canonical_layer: DESIGN
state: TARGET
spec_type: index
status: draft
references:
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0004
  - COMP0005
  - COMP0006
  - COMP0007
  - COMP0008
  - COMP0009
---

# DESIGN Component Index — canonical `@patron/ui` library

> **STATE: TARGET.** This index catalogues the **rebuild (`bid-patron-deti`) design system**
> (`packages/ui`), i.e. the future component library for the Patronus rewrite. It is **not**
> current-state truth. Per the project constitution's current-vs-target rule, this sits at the same
> authority level as `it-zadani` / redesign material: useful to shape the rebuild-ready spec, never
> used to "correct" reconstructed current-state UX (`_ar/spec-draft/COMP/**`,
> `_ar/spec-draft/WIRE/**`).
>
> **Source of extraction:** `_ar/evidence/design-system/components.md` (full catalogue),
> cross-checked against `_ar/spec-draft/COMP-inventory-map.md` for the reconciliation mapping.
> Canonical library root: `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/`.
>
> **Scope:** 16 canonical components (7 Atoms + 9 Blocks) + 1 Page composition (StoryDetail) = 17
> catalogued units, per `components.md` §1 tally. Each entry below maps to the reconstructed
> current-state COMP doc_id it reconciles against, where one exists (COMP0001–COMP0003, COMP0008
> only — see §3 for the 5 reconstructed COMPs with no canonical counterpart).

---

## 1. Index table

| # | Canonical name | Layer | One-line purpose | Key props/variants/states | Token slots | A11y notes | Tenant notes | Mapped COMP doc_id |
|---|---|---|---|---|---|---|---|---|
| 1 | **Button** | Atom | Base action element (CTA/secondary/link-action); renders `<button>` or `<a>` on same visual contract | Props: `label`, `variant` (primary\|secondary\|ghost), `size` (md\|lg), `block`, `iconBefore`/`iconAfter`. States: default, hover, focus-visible, active, disabled (btn only) | `--font-body`, `--radius-pill`, `--size-base/lg`, `--space-sm/md/lg/xl`, `--color-action`, `--color-on-brand`, `--color-surface`, `--color-text`, `--color-border`, `--color-accent` | Focus-visible ring reads `color.accent`; disabled via native `disabled` (button only, not link) | Theme-neutral — no tenant-specific props; colors resolve via `data-theme` token remap | **COMP0001** |
| 2 | **Input** | Atom | Bare text/numeric form field; label is consumer's responsibility | Props: native `InputHTMLAttributes` (`type`, `value`, `placeholder`, `onChange`, `aria-label`, `inputMode`, `disabled`). No variants/sizes. States: default, focus, disabled, error (consumer-signalled via `aria-invalid`) | `--font-body`, `--radius-control`, `--color-border`, `--color-surface`, `--color-text`, `--color-muted`, `--color-accent` | Renders no error style itself — consumer must pair with visible error text/`aria-invalid`; no built-in `<label>` | Theme-neutral | **COMP0021** |
| 3 | **Icon** | Atom | Pictogram with dual glyph set (line/filled), tenant-selected via CSS, inherits `currentColor` | Props: `name` (`IconName`: development\|health\|subsistence\|clock\|check\|arrow\|heart\|give\|user), `size` (px, default 20). Variant: LINE (CZ) vs FILLED (RO) via `data-theme`. State: idle only | none (uses `currentColor`; CSS `display` toggles glyph set) | Decorative by default (no intrinsic role/label — consuming component must supply `aria-label` where meaningful) | Glyph **style** (line vs filled) is theme-driven, not a prop — CZ=line, RO=filled | **COMP0020** |
| 4 | **Brandmark** | Atom | Tenant logo for header/footer; logo identity itself is theme-driven, not a prop | Props: `small` (bool, default false). Variants: default/small (footer) × CZ/RO (via `data-theme`). Composition: `Icon`(name="give") for CZ symbol | `--radius-icon`, `--color-brand`, `--color-on-brand`, `--font-display(+weight/tracking)` | Logo/link semantics owned by consumer (SiteHeader wraps it in the home `<a>`) | Both tenant marks live in the DOM simultaneously; CSS picks the active one — CZ = "give" symbol + wordmark, RO = live KidsHero img hotlink (no binary in repo) | **COMP0019** |
| 5 | **CategoryChip** | Atom | Story-category indicator; same category = same color everywhere (chip, card wash, hero corner) | Props: `category` (`StoryCategory`: development\|health\|subsistence, req), `label` (req). One variant per category driving `--cat` → `--color-category-*`. Fixed size. State: idle only | `--color-category-development/-health/-subsistence`, `--color-surface`, `--font-body`, `--radius-pill` | Composed `Icon` is category-matched (size 15) — decorative, label text carries the accessible name | Category taxonomy (3 values) is shared across tenants; color mapping is token-level, not tenant-switched | **COMP0018** |
| 6 | **TimeLeftPill** | Atom | Campaign time-remaining pill; calm = neutral, urgent = alert-badge with gentle pulse | Props: `label` (req), `urgent` (bool, default false). Variants: calm/urgent. State: idle (calm/urgent render) | `--font-body`, `--radius-pill`, `--color-text`, `--color-surface`, `--color-muted`, `--color-urgent`, `--color-on-urgent` | `urgentpulse` animation explicitly disabled under `prefers-reduced-motion` | Theme-neutral; urgent state uses dedicated `color.urgent`/`on-urgent` tokens, distinct from brand palette per tenant | **COMP0017** |
| 7 | **ProgressBar** | Atom | Collection-progress bar; brand→accent gradient revealed via clip-path (2nd color shows only near 100%) | Props: `value` (0–100, req, clamped/rounded), `height` (px, default 10), `ariaLabel` (default "Průběh sbírky"). States: default/0%/100% | `--radius-pill`, `--color-track`, `--color-brand`, `--color-accent` | `role="progressbar"` + `aria-valuemin/max/now`; explicitly **not focusable** (status role, not control) | `ariaLabel` default is Czech-specific ("Průběh sbírky") — RO tenant must override via prop, not auto-localized | **COMP0016** |
| 8 | **StoryCard** | Block | Storefront's core repeating unit — one child's story + progress in lists (catalogue, "Další děti") | Props: `title`, `photoUrl?`, `initial`, `category`, `categoryLabel`, `progressPct`, `missingLabel`, `goalLabel` (all display-ready). Variant: by category. States: default; hover/focus (out of first cut); loading/empty/error (out of first-cut scope). Composition: `CategoryChip` + `ProgressBar` | `--color-surface`, `--color-border`, `--radius-card`, `--shadow-card`, `--font-body`, `--color-category-*`, `--color-surface-tint`, `--font-display(+weight/tracking)`, `--color-text`, `--color-muted`, `--space-md/sm` | Clickable donor-acquisition unit → story detail; owning-link hover/focus states deferred (not first-cut) | No tenant-specific props; content (title/labels) passed in already localized | **COMP0008** |
| 9 | **StoryHero** | Block | Story visual on detail page — large photo + corner category chip; monogram-on-wash fallback when no photo | Props: `photoUrl?`, `photoAlt?` (default ""), `initial`, `category`, `categoryLabel`. Variants: with-photo/monogram-fallback/by-category. States: default; photo↔fallback. Composition: `CategoryChip` | `--radius-card`, `--shadow-card`, `--color-brand`, `--color-surface`, `--color-surface-tint`, `--font-display(+weight/tracking)` | Monogram fallback is a deliberate design decision (not a generic gradient placeholder) — improves recognizability when `photoAlt` is empty | Theme-neutral; fallback rendering uses brand tokens so it re-skins per tenant automatically | **COMP0011** |
| 10 | **PatronCard** | Block | Patron-as-trust-pillar testimonial block on detail page; encodes "patron guarantees the story" invariant | Props: `initial`, `avatarUrl?`, `name`, `role`, `sealLabel`, `commentHtml` (sanitized backend WYSIWYG). Variants: photo avatar/initial avatar. States: default; photo↔fallback. Composition: `Icon`(name="check", seal) | `--color-surface`, `--color-border`, `--radius-card`, `--space-lg/md`, `--font-body`, `--color-brand`, `--color-brand-strong`, `--font-display(+weight)`, `--color-text`, `--color-muted`, `--color-success`, `--radius-pill` | Verification seal reads `color.success` semantically; comment is **always fully visible** — no "show more" toggle (transparency invariant) | Theme-neutral composition; content (name/role/comment) per-instance | **COMP0012** |
| 11 | **RailCta** | Block | Lighter right-rail card under DonationBox — secondary help paths (recurring gift, voucher) | Props: `title`, `text`, `href`, `ctaLabel?` (default variant), `promo?` (bool), `linkLabel?` (promo variant). Variants: default (explainer + outline CTA)/promo (whole card is a link, accent tint). States: default; hover/focus (ring `color.accent`). Composition: `Button`(ghost, block) + `Icon`(name="arrow") | `--color-surface`, `--color-border`, `--radius-card`, `--space-md/lg`, `--font-body`, `--font-display(+weight/tracking)`, `--color-text`, `--color-muted`, `--color-accent` | External link opens in new window with safe `rel` | **Promo variant (voucher/"dobrošek") is CZ-only**, per-tenant module, hidden in RO (consumer-controlled, not CSS-hidden) | **COMP0014** |
| 12 | **ShareRow** | Block | Compact monochrome icon row for sharing a story; glyphs adopt tenant color on hover | Props: `label` (req), `networks?` (`SocialName[]`: facebook\|x\|instagram\|linkedin\|whatsapp\|email\|messenger; default = all 7). Variants: default set/custom set. States: default (`color.muted`); hover/focus (`color.action`, ring `color.accent`). Composition: internal `SocialGlyph` | `--space-sm`, `--font-body`, `--color-muted`, `--color-surface`, `--color-border`, `--color-action` | Each link has an `aria-label` naming the network; glyph itself is decorative | Theme-neutral; network set is customizable per instance/tenant via `networks` prop | **COMP0015** |
| 13 | **DonationBox** | Block | Primary conversion block of story detail — shows missing amount/deadline, single-decision contribution; funded state swaps form for thank-you | Props: `state?` (live\|urgent\|funded, default live), `timeLeftLabel`, `missingAmount`, `missingCaption`, `goalCaption`, `goalAmount`, `progressPct`, `donorsNote?`, `presets` (`DonationPreset[]`), `defaultPresetIndex?`, `customLabel`, `currencyLabel`, `customInputLabel`, `restFill?`, `ctaLabel`, `voucherLabel?` (CZ-only), `successTitle?`, `successMessage?`, `onDonate?`. States: preset select, "Jiná" (custom) open, hover/focus, reduced-motion (pulse off). Composition: `TimeLeftPill` + `ProgressBar` + `Input` + `Button`(primary/block) + `Icon`(check, give) | `--color-surface`, `--color-border`, `--radius-card`, `--shadow-card`, `--space-xs/sm/md/lg`, `--font-body`, `--font-display(+weight/tracking)`, `--color-brand-strong`, `--color-muted`, `--color-text`, `--radius-control`, `--radius-icon`, `--color-action`, `--color-accent`, `--color-success`, `--color-on-success` | Preset buttons use `aria-pressed` for selection state | `voucherLabel?` prop is **CZ-only** (per-tenant, consumer-controlled). **Scope boundary: ends at `onDonate(amount)`** — donation modal (email/consents/payment) is an explicitly separate future block, contract "Mimo scope" | **COMP0010** |
| 14 | **SiteHeader** | Block | Storefront header: brandmark, main nav, login, "Ask for help" CTA; collapses to hamburger ≤720px | Props: `navItems` (string[]), `loginLabel`, `applyLabel`. Variants: desktop/mobile (hamburger). States: default; menu closed/open (`aria-expanded`). Composition: `Brandmark` (in home `<a>`), `Button`(ghost, desktop CTA), `Icon`(user) | `--space-lg/md/sm/xs`, `--color-border`, `--color-muted`, `--color-text`, `--color-action`, `--color-surface`, `--shadow-card`, `--font-body` | Mobile menu toggle exposes `aria-expanded` | Nav items/labels are prop-driven per tenant/locale | **COMP0002** |
| 15 | **SiteFooter** | Block | Storefront footer: brand + tagline + social, Project/Contact nav columns, legal bar; content per-tenant via props, layout is fixed | Props: `tagline`, `followLabel`, `projectTitle`, `projectLinks` (string[]), `contactTitle`, `email`, `contactNotes` (node[]), `applyLabel`, `legalNote` (node), `privacyLabel`, `copyright`. No structural variants (content-driven only). States: default; link hover/focus. Composition: `Brandmark`(small) + `SocialGlyph`(facebook/instagram/linkedin, hardcoded) | `--layout-container`, `--space-xl/lg/md/sm`, `--color-border`, `--color-surface`, `--color-text`, `--color-muted`, `--color-action`, `--font-body`, `--font-display(+weight/tracking)` | Standard link focus states; no custom ARIA beyond native nav semantics | All content strings passed as props — no fixed "promo band" slot (see §3 divergence note) | **COMP0003** |
| — | **StoryDetail** (Page) | Page (composition, not a component) | Conversion core of the storefront — introduces child/story/patron, drives contribution; carries the "100% to child / supplier in nominative / patron guarantees / fixed presets" domain truths | Composition regions: `SiteHeader` → breadcrumb → H1 → main column (`StoryHero` → lede → `PatronCard` → prose) + sticky right rail (`DonationBox` → `RailCta`(recurring) → `RailCta`(promo, CZ-only) → `ShareRow`) → full-width `PledgeStrip` (present in every state) → "Další děti" grid (3× `StoryCard`) → `SiteFooter` → mobile sticky CTA bar (hidden when funded). Screen states: live/urgent/funded (mirrors DonationBox). Responsive breakpoints: ≤900px single column+rail below+sticky CTA; ≤860px grid→1 col; ≤720px header hamburger | (inherits all token slots of composed components) | (inherits a11y behavior of composed components) | Per-tenant content fixtures `contentCz`/`contentRo` (`_fixtures.tsx`); RO omits the promo `RailCta`. **Explicitly out of scope:** donation modal (email/consents/mock payment), step-by-step "gift chain", donor-count real-data availability | *(no single COMP — composition of rows 8–15 above; see PledgeStrip note below)* |

**Note on PledgeStrip:** `components.md` documents `PledgeStrip` as a Block consumed by StoryDetail
(100% pledge + supplier invariant banner) and gives it reconciliation mapping **COMP0013** in the
task's mapping list, but does **not** carry a dedicated per-component catalogue subsection of its
own in `_ar/evidence/design-system/components.md` §1 (it appears only in the StoryDetail composition
and in the Mapping Table of §2, listed among the "GAP→recon" Blocks). Recorded here for completeness
per the task's canonical doc_id assignment:

| # | Canonical name | Layer | One-line purpose | Key props/variants/states | Token slots | A11y notes | Tenant notes | Mapped COMP doc_id |
|---|---|---|---|---|---|---|---|---|
| 16 | **PledgeStrip** | Block | Full-width invariant banner — "100% of the gift reaches the child, never the family; supplier named" — present in every DonationBox state | `Uncertain — not itemized as its own catalogue subsection in components.md; props/variants/states not separately evidenced beyond its role in the StoryDetail composition (§1 "Full-width divider").` | `Uncertain — not itemized separately; likely shares surface/text tokens with adjacent Blocks.` | `Uncertain — not itemized separately.` | Present in **every** collection state (live/urgent/funded) per StoryDetail composition; carries the platform's core trust invariant | **COMP0013** |

---

## 2. Doc_id assignment reference (per task instruction)

| Canonical component | Mapped COMP doc_id |
|---|---|
| Button | COMP0001 |
| SiteHeader | COMP0002 |
| SiteFooter | COMP0003 |
| StoryCard | COMP0008 |
| DonationBox | COMP0010 |
| StoryHero | COMP0011 |
| PatronCard | COMP0012 |
| PledgeStrip | COMP0013 |
| RailCta | COMP0014 |
| ShareRow | COMP0015 |
| ProgressBar | COMP0016 |
| TimeLeftPill | COMP0017 |
| CategoryChip | COMP0018 |
| Brandmark | COMP0019 |
| Icon | COMP0020 |
| Input | COMP0021 |

COMP0001–COMP0003 and COMP0008 are the **pre-existing reconstructed current-state COMP docs**
(`_ar/spec-draft/COMP/COMP0001_PrimaryButton.md`, `COMP0002_GlobalHeader.md`,
`COMP0003_GlobalFooter.md`, `COMP0008_StoryCard.md`) that this index reconciles the canonical
component against (RENAME/MATCH per `components.md` §2). **COMP0010–COMP0021 are newly assigned
doc_ids for this TARGET index** — no reconstructed current-state COMP file exists yet at these
numbers; they are reserved here to keep the canonical library's numbering stable for downstream
`spec-final` generation. Creating the corresponding COMP files (if desired) is out of scope for this
index.

---

## 3. Reconstructed COMPs with no canonical counterpart

The following 5 reconstructed current-state COMPs (`_ar/spec-draft/COMP/**`) have **no** matching
component in the canonical `@patron/ui` library. They surface capability that belongs to
not-yet-built epics **E0003 (Obsah/CMS)**, **E0004 (Storefront web — donor journey incl. donation
modal)**, and **E0005 (Mobilní aplikace)** per `_ar/evidence/design-system/design-canon.md` §0 epic
table (only **E0001 Design systém a tokeny** is `Done`; E0002 is `Active`; E0003–E0005 are
`Draft`/`Plánováno`):

| Reconstructed COMP | Title | Why absent from canonical library |
|---|---|---|
| **COMP0004** | Cookie Consent Banner | Not in `packages/ui` scope at all — a consent-banner is an app-shell/consent-platform concern, not a storefront UI component. |
| **COMP0005** | Application Wizard Stepper | Canonical library covers storefront + story detail only; the Application intake wizard (5 steps, epic E0004 territory) has no built components yet. |
| **COMP0006** | Consent Checkbox | No canonical component **yet** — DonationBox/StoryDetail contracts explicitly name the donation modal (email + consents + payment) as a deferred "separate future block" ("Mimo scope"). This is ConsentCheckbox's intended future home. |
| **COMP0007** | File Upload Dropzone | Belongs to the not-yet-built Application wizard / account surfaces (E0004/E0005 territory). |
| **COMP0009** | Email-Entry Form | Its atoms (`Input`, `Button`) exist in the canonical library, but the auth email-entry composite itself is not built (auth surface not yet in scope). |

These 5 remain governed solely by their existing reconstructed current-state COMP files; this TARGET
index does not assign them a canonical counterpart doc_id.

---

## 4. Source paths

- **Canonical library components** (Atoms/Blocks):
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/<Name>/`
  — each with `<Name>.tsx`, `<Name>.stories.tsx`, `<Name>.module.css`, `<Name>.contract.md`,
  `index.ts`.
- **StoryDetail page composition:**
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/pages/StoryDetail/`
  (incl. `_fixtures.tsx` for per-tenant content).
- **Foundations / tokens:**
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/foundations/{Uvod,Tokeny,Typografie}.mdx`,
  `TokenGallery.tsx`; token source of truth `@patron/tokens/tokens.css` (external package, not
  inside `packages/ui`).
- **Storybook config:**
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/.storybook/{main.ts,preview.tsx}`
  — layer taxonomy (`storySort`: Foundations → Atoms → Blocks → Pages), tenant toggle
  (`globalTypes.tenant` → `data-theme`), a11y enforcement (`@storybook/addon-a11y`, `a11y: {test:
  "error"}`).
- **Public export surface:**
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/index.ts`.
- **Full extracted catalogue (this index's direct source):**
  `_ar/evidence/design-system/components.md`.
- **Reconciliation mapping (canonical ↔ reconstructed COMP/WIRE, MATCH/RENAME/GAP classification):**
  `_ar/evidence/design-system/components.md` §2–§4.
- **Reconstructed current-state COMP files reconciled against:**
  `_ar/spec-draft/COMP/COMP0001_PrimaryButton.md`, `COMP0002_GlobalHeader.md`,
  `COMP0003_GlobalFooter.md`, `COMP0008_StoryCard.md`; full inventory
  `_ar/spec-draft/COMP-inventory-map.md`.
- **Design canon / epic maturity context:** `_ar/evidence/design-system/design-canon.md`.
- **Token catalogue (semantic slot definitions):** `_ar/evidence/design-system/tokens.md`.
