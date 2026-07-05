# Canonical redesign component library — catalogue & mapping to reconstructed UX (COMP/WIRE)

> **Read-only discovery artifact.** Catalogues the `bid-patron-deti` **rebuild** component library
> (`packages/ui`) and maps it to the reconstructed current-state UX layer (`_ar/spec-draft/COMP`,
> `_ar/spec-draft/WIRE`). Purpose: let the reconstructed UX documentation be **reconciled to respect
> the real (target) components**.
>
> **Authority note (per project constitution):** the redesign library is **TARGET state**, not
> current-state truth. The reconstructed COMP/WIRE layer is the **current-state** reconstruction
> (evidence-gated from static screenshots). Where they diverge, that is expected and recorded here —
> it is **not** a defect to "correct" the current-state toward the target.
>
> Sources:
> - Canonical library root: `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/`
> - Reconstructed COMP: `_ar/spec-draft/COMP/COMP0001..COMP0009` + `_ar/spec-draft/COMP-inventory-map.md`
> - Reconstructed WIRE: `_ar/spec-draft/WIRE/WIRE0001`, `WIRE0002` (+ Components-Used tables)

---

## 0. Design-system model & foundations

The redesign library is a **multi-tenant** design system with an explicit layer taxonomy, discovered
in `src/foundations/Uvod.mdx`, `.storybook/main.ts`, `.storybook/preview.tsx`:

- **Layers (Storybook `storySort`):** `Foundations` → `Atoms` → `Blocks` → `Pages`.
  - **Atoms:** Button, Input, Icon, Brandmark, CategoryChip, TimeLeftPill, ProgressBar.
  - **Blocks:** StoryCard, StoryHero, PledgeStrip, PatronCard, RailCta, ShareRow, DonationBox,
    SiteHeader, SiteFooter.
  - **Pages:** StoryDetail (a *composition story*, not a component).
- **Tenants:** **CZ — Patron Děti** and **RO — KidsHero**, switched via a Storybook toolbar
  (`preview.tsx` `globalTypes.tenant`) realised through `data-theme` on the root. Components never
  write hex — they read semantic `var(--…)` slots, so a tenant re-skin re-maps values with no code
  change. Blocks/Pages additionally switch **content fixtures** (CZ/RO text).
- **Token source of truth:** `@patron/tokens/tokens.css` (`:root` shared scale + `[data-theme]`
  tenant-bound values) — imported by Storybook preview; **not** inside `packages/ui`. Component CSS
  is CSS-modules (`*.module.css`) that consume `var(--…)` slots only.
- **Canonical contracts:** each component ships a colocated `<Name>.contract.md` (Czech) holding
  platform-neutral *anatomy / variants / states*; native app holds parity against the contract, not
  the code (ADR0002). This is the closest analogue to an AR COMP spec.
- **Accessibility is enforced, not "unknown":** `.storybook/main.ts` loads `@storybook/addon-a11y`
  and `preview.tsx` sets `a11y: { test: "error" }`; every contract records concrete a11y decisions
  (roles, `aria-*`, focus ring reads `color.accent`, contrast verified both tenants). This is a
  direct contrast with the reconstruction, whose a11y is uniformly `Uncertain` (no DOM evidence).

**Shared token slots consumed across the library** (union of all `*.module.css`):
- Color: `--color-bg`, `--color-surface`, `--color-surface-tint`, `--color-border`, `--color-track`,
  `--color-text`, `--color-muted`, `--color-brand`, `--color-brand-strong`, `--color-on-brand`,
  `--color-action`, `--color-accent`, `--color-success`, `--color-on-success`, `--color-urgent`,
  `--color-on-urgent`, `--color-category-development`, `--color-category-health`,
  `--color-category-subsistence`.
- Spacing: `--space-xs`, `--space-sm`, `--space-md`, `--space-lg`, `--space-xl`.
- Typography: `--font-body`, `--font-display`, `--font-display-weight`, `--font-display-tracking`,
  `--size-base`, `--size-lg`.
- Radius/shadow/layout: `--radius-control`, `--radius-pill`, `--radius-card`, `--radius-icon`,
  `--shadow-card`, `--layout-container`.

---

## 1. Per-component catalogue (canonical redesign library)

Source dir prefix (omitted below for brevity):
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/`

### Atoms

#### Button — `components/Button/`
- **Purpose:** Base action element (CTA, secondary, link-action). Renders `<button>`, or `<a>` when
  `href` is present, with the same visual contract.
- **Props:** `label` (req, string), `variant` (`"primary" | "secondary" | "ghost"`, default
  `primary`), `size` (`"md" | "lg"`, default `md`), `block` (bool), `iconBefore` (node),
  `iconAfter` (node), `className`, + native `<button>`/`<a>` attrs (`onClick`, `type`, `href`,
  `disabled`, `target`/`rel`). Exported types: `ButtonProps`, `ButtonVariant`, `ButtonSize`.
- **Variants:** primary (`color.action` + `on-brand`) / secondary (quieter surface) / ghost (outline).
- **Sizes:** md / lg (height + padding).
- **States:** default, hover (brightness), focus-visible (ring `color.accent`), active (press),
  disabled (opacity 0.5, `<button>` only).
- **Tokens:** `--font-body`, `--radius-pill`, `--size-base`, `--size-lg`, `--space-sm/md/lg/xl`,
  `--color-action`, `--color-on-brand`, `--color-surface`, `--color-text`, `--color-border`,
  `--color-accent`.
- **Composition:** leaf (renders `iconBefore`/`iconAfter` nodes only).
- **Stories:** `Primary`, `Secondary`, `Ghost`, `SIkonou`, `Dárcovské`, `Large`, `Disabled`.

#### Input — `components/Input/`
- **Purpose:** Text/numeric form field atom (custom amount in DonationBox, future donation modal).
  Intentionally bare; **label is the consumer's responsibility** (`aria-label`/`<label>`).
- **Props:** `InputHTMLAttributes<HTMLInputElement>` (`type`, `value`, `placeholder`, `onChange`,
  `aria-label`, `inputMode`, `disabled`, …) + `className`. Exported type: `InputProps`.
- **Variants:** none (only native `type`). **Sizes:** none.
- **States:** default (border `color.border`, surface `color.surface`), focus (ring `color.accent`),
  disabled, error (consumer signals `aria-invalid`; field renders no error style itself).
- **Tokens:** `--font-body`, `--radius-control`, `--color-border`, `--color-surface`, `--color-text`,
  `--color-muted`, `--color-accent`.
- **Composition:** leaf. **Stories:** `Text`, `Číslo`, `Vypnuté`.

#### Icon — `components/Icon/`
- **Purpose:** Pictogram with a **dual glyph set** (line vs. filled) chosen by `data-theme` in CSS
  (icon style is part of the tenant theme, not a prop). Inherits `currentColor`.
- **Props:** `name` (req, `IconName`), `size` (px, default 20). Exported: `IconProps`, `IconName`.
- **`IconName` union:** `"development" | "health" | "subsistence" | "clock" | "check" | "arrow" |
  "heart" | "give" | "user"`.
- **Variants:** LINE (CZ default) / FILLED (RO), toggled by `[data-theme]`. **Sizes:** `size` px.
- **States:** idle. **Tokens:** none (uses `currentColor`; CSS `display` toggles LINE/FILLED).
- **Composition:** pure SVG. **Stories:** `Ikona`, `Sada`.

#### Brandmark — `components/Brandmark/`
- **Purpose:** Tenant logo for header/footer. **Logo is theme-driven, not a prop** — both tenants
  are in the DOM, CSS picks the active one by `data-theme`. CZ = "give" symbol + "patron dětí"
  wordmark; RO = live KidsHero logo (img hotlink, no binaries in repo).
- **Props:** `small` (bool, default false). Exported: `BrandmarkProps`.
- **Variants:** default / `small` (footer); CZ / RO (via `data-theme`). **States:** default,
  tenant-switch.
- **Tokens:** `--radius-icon`, `--color-brand`, `--color-on-brand`, `--font-display`,
  `--font-display-weight`, `--font-display-tracking`.
- **Composition:** `Icon` (name="give", CZ symbol). **Stories:** `Logo`, `Kompaktní`.

#### CategoryChip — `components/CategoryChip/`
- **Purpose:** Story-category indicator, unified across UI (same category = same color, in chip,
  card wash, hero corner).
- **Props:** `category` (req, `StoryCategory`), `label` (req, string). Exported: `CategoryChipProps`,
  `StoryCategory`.
- **`StoryCategory` union:** `"development" | "health" | "subsistence"`.
- **Variants:** one per category (drives `--cat` custom prop → `--color-category-*`). **Sizes:** fixed.
- **States:** idle (category-tinted bg + text).
- **Tokens:** `--color-category-development/-health/-subsistence`, `--color-surface`, `--font-body`,
  `--radius-pill`.
- **Composition:** `Icon` (category-matched, size 15). **Stories:** `Rozvoj`, `Zdraví`, `Existenční`.

#### TimeLeftPill — `components/TimeLeftPill/`
- **Purpose:** Campaign time-remaining pill. Calm = neutral tint; urgent = full alert-badge with a
  gentle pulse (reads state tokens `color.urgent`/`on-urgent`, separate from brand).
- **Props:** `label` (req, string), `urgent` (bool, default false). Exported: `TimeLeftPillProps`.
- **Variants:** calm / urgent. **Sizes:** fixed.
- **States:** idle (calm: tint of `color-text` over `color-surface`, text `color-muted`); urgent
  (`color-urgent` bg, `color-on-urgent` text, `urgentpulse` animation, disabled under
  `prefers-reduced-motion`).
- **Tokens:** `--font-body`, `--radius-pill`, `--color-text`, `--color-surface`, `--color-muted`,
  `--color-urgent`, `--color-on-urgent`.
- **Composition:** `Icon` (name="clock", size 15). **Stories:** `Klid`, `Naléhavé`.

#### ProgressBar — `components/ProgressBar/`
- **Purpose:** Collection progress. A `brand → accent` gradient spans the whole track; the fill only
  *reveals* it via clip-path, so the second color shows fully only near 100%.
- **Props:** `value` (req, 0–100, clamped/rounded), `height` (px, default 10), `ariaLabel`
  (default "Průběh sbírky"). Exported: `ProgressBarProps`.
- **Variants:** height. **States:** default / 0% / 100%.
- **A11y:** `role="progressbar"` + `aria-valuemin/max/now`; **not focusable** (status role).
- **Tokens:** `--radius-pill`, `--color-track`, `--color-brand`, `--color-accent`.
- **Composition:** leaf. **Stories:** `Začátek`, `TéměřVybráno`, `Vybráno`.

### Blocks

#### StoryCard — `components/StoryCard/`
- **Purpose:** Storefront's core repeating unit — one child's story + collection progress in lists
  (catalogue, "Další děti"). Clickable donor-acquisition unit → story detail.
- **Props:** `title`, `photoUrl?`, `initial`, `category` (`StoryCategory`), `categoryLabel`,
  `progressPct`, `missingLabel`, `goalLabel` — all display-ready (no formatting/translation in-comp).
  Exported: `StoryCardProps`.
- **Variants:** by category (chip/wash/monogram share `color.category.*`). **States:** default;
  hover/focus (owning link, out of first cut); loading/empty/error (out of first-cut scope).
- **Tokens:** `--color-surface`, `--color-border`, `--radius-card`, `--shadow-card`, `--font-body`,
  `--color-category-*`, `--color-surface-tint`, `--font-display(+weight/tracking)`, `--color-text`,
  `--color-muted`, `--space-md`, `--space-sm`.
- **Composition:** `CategoryChip` + `ProgressBar`. **Stories:** `Zdraví`, `Rozvoj`, `TéměřVybráno`,
  `BezFotky`.

#### StoryHero — `components/StoryHero/`
- **Purpose:** Story visual on detail — large photo + category chip in corner; monogram-on-wash
  fallback when no photo (deliberate, not a generic gradient).
- **Props:** `photoUrl?`, `photoAlt?` (default ""), `initial`, `category`, `categoryLabel`.
  Exported: `StoryHeroProps`.
- **Variants:** with-photo / monogram-fallback / by-category. **States:** default; photo↔fallback.
- **Tokens:** `--radius-card`, `--shadow-card`, `--color-brand`, `--color-surface`,
  `--color-surface-tint`, `--font-display(+weight/tracking)`.
- **Composition:** `CategoryChip`. **Stories:** `Fotka`, `MonogramFallback`.

#### PatronCard — `components/PatronCard/`
- **Purpose:** Patron as trust pillar — standalone testimonial block on the detail page. Encodes the
  invariant *patron guarantees the story* (verification seal reads `color.success`); comment always
  fully visible (no "show more" toggle).
- **Props:** `initial`, `avatarUrl?`, `name`, `role`, `sealLabel`, `commentHtml` (from a restricted
  WYSIWYG, sanitized on backend). Exported: `PatronCardProps`.
- **Variants:** photo avatar / initial avatar. **States:** default; photo↔fallback.
- **Tokens:** `--color-surface`, `--color-border`, `--radius-card`, `--space-lg/md`, `--font-body`,
  `--color-brand`, `--color-brand-strong`, `--font-display(+weight)`, `--color-text`,
  `--color-muted`, `--color-success`, `--radius-pill`.
- **Composition:** `Icon` (name="check", seal). **Stories:** `Patronka`, `OrganizaceBezFotky`.

#### RailCta — `components/RailCta/`
- **Purpose:** Lighter right-rail card under the DonationBox — secondary help paths (recurring gift,
  voucher). Default = explainer + outline CTA; promo = whole card is a link with accent tint.
- **Props:** `title`, `text`, `href`, `ctaLabel?` (default variant), `promo?` (bool),
  `linkLabel?` (promo variant). Exported: `RailCtaProps`.
- **Variants:** default (`<div>` + ghost/block Button-as-link) / promo (whole card `<a>` + arrow).
  **States:** default; hover/focus (ring `color.accent`).
- **Domain rule:** promo (voucher/"dobrošek") is **CZ-only** — per-tenant module, hidden in RO
  (consumer-controlled). External link opens in a new window with safe `rel`.
- **Tokens:** `--color-surface`, `--color-border`, `--radius-card`, `--space-md/lg`, `--font-body`,
  `--font-display(+weight/tracking)`, `--color-text`, `--color-muted`, `--color-accent`.
- **Composition:** `Button` (ghost, block) + `Icon` (name="arrow"). **Stories:** `PravidelnýDar`,
  `Promo`.

#### ShareRow — `components/ShareRow/`
- **Purpose:** Compact monochrome icon row for sharing a story; glyphs adopt tenant color on hover.
- **Props:** `label` (req), `networks?` (`SocialName[]`). Exported: `ShareRowProps` (+ internal
  `SocialName`).
- **`SocialName` union:** `"facebook" | "x" | "instagram" | "linkedin" | "whatsapp" | "email" |
  "messenger"` (default order = all seven).
- **Variants:** default set / custom set. **States:** default (`color.muted`); hover/focus
  (`color.action`, ring `color.accent`).
- **A11y:** each link has an `aria-label` with the network name; glyph is decorative.
- **Tokens:** `--space-sm`, `--font-body`, `--color-muted`, `--color-surface`, `--color-border`,
  `--color-action`.
- **Composition:** `SocialGlyph` (internal `_socialIcons.tsx`). **Stories:** `Sdílení`.

#### DonationBox — `components/DonationBox/`
- **Purpose:** Primary conversion block of the story detail — shows how much is missing and by when,
  and lets the donor contribute in one decision. In the funded state the form disappears and it
  becomes a thank-you with the next step. **Scope ends at `onDonate(amount)`; the donation modal
  (email + consents + payment) is explicitly a separate future block** (contract "Mimo scope").
- **Exported types:** `DonationBoxProps`, `DonationPreset` (`{label, amount}`), `CollectionState`
  (`"live" | "urgent" | "funded"`).
- **Props:** `state?` (default "live"), `timeLeftLabel`, `missingAmount`, `missingCaption`,
  `goalCaption`, `goalAmount`, `progressPct`, `donorsNote?`, `presets` (`DonationPreset[]`),
  `defaultPresetIndex?` (default 1), `customLabel`, `currencyLabel`, `customInputLabel`, `restFill?`
  (`{label, amount}` quick-fill "pay the rest"), `ctaLabel`, `voucherLabel?` (CZ-only),
  `successTitle?`, `successMessage?` (node), `onDonate?` (`(amount:number)=>void`).
- **Variants:** live / urgent (time pill → alert-badge + pulse) / funded (form hidden, success shown).
- **States:** default preset (aria-pressed); preset select; "Jiná" open (custom Input + optional
  quick-fill); hover/focus; reduced-motion (pulse off).
- **Domain rules:** presets are **fixed across stories** (donor capacity, not goal size); quick-fill
  only offered on a small remainder; all money strings are display-ready.
- **Tokens:** `--color-surface`, `--color-border`, `--radius-card`, `--shadow-card`,
  `--space-xs/sm/md/lg`, `--font-body`, `--font-display(+weight/tracking)`, `--color-brand-strong`,
  `--color-muted`, `--color-text`, `--radius-control`, `--radius-icon`, `--color-action`,
  `--color-accent`, `--color-success`, `--color-on-success`.
- **Composition:** `TimeLeftPill` + `ProgressBar` + `Input` + `Button` (primary/block) + `Icon`
  (check, give). **Stories:** `Probíhá`, `Naléhavé`, `DoplatitZbytek`, `Vybráno`.

#### SiteHeader — `components/SiteHeader/`
- **Purpose:** Storefront header: brandmark, main nav, login, "Ask for help" CTA. ≤720px → nav
  collapses to hamburger; login becomes icon-only.
- **Props:** `navItems` (string[]), `loginLabel`, `applyLabel`. Exported: `SiteHeaderProps`.
- **Variants:** desktop / mobile (hamburger). **States:** default; menu closed/open
  (`aria-expanded`).
- **Tokens:** `--space-lg/md/sm/xs`, `--color-border`, `--color-muted`, `--color-text`,
  `--color-action`, `--color-surface`, `--shadow-card`, `--font-body`.
- **Composition:** `Brandmark` (in home `<a>`), `Button` (ghost, desktop CTA), `Icon` (user).
  **Stories:** `Hlavička`, `Mobil`.

#### SiteFooter — `components/SiteFooter/`
- **Purpose:** Storefront footer: brand + tagline + social, Project/Contact nav columns, legal bar.
  Content is per-tenant via props; layout is its own.
- **Props:** `tagline`, `followLabel`, `projectTitle`, `projectLinks` (string[]), `contactTitle`,
  `email`, `contactNotes` (node[]), `applyLabel`, `legalNote` (node), `privacyLabel`, `copyright`.
  Exported: `SiteFooterProps`.
- **Variants:** none (content-driven). **States:** default; link hover/focus.
- **Tokens:** `--layout-container`, `--space-xl/lg/md/sm`, `--color-border`, `--color-surface`,
  `--color-text`, `--color-muted`, `--color-action`, `--font-body`,
  `--font-display(+weight/tracking)`.
- **Composition:** `Brandmark` (small) + `SocialGlyph` (facebook/instagram/linkedin, hardcoded).
  **Stories:** `Patička`.

### Pages

#### StoryDetail — `pages/StoryDetail/` (composition story, not a component)
- **Purpose:** Conversion core of the storefront — introduces the child, story and patron, and drives
  the donor to contribute. Carries the platform's main domain truths (100% to the child; supplier in
  nominative; patron guarantees; fixed presets by donor capacity).
- **Composition (layout regions):**
  - `SiteHeader` → breadcrumb ("← Všechny příběhy") → H1 (story title).
  - **Main column:** `StoryHero` → lede → `PatronCard` → prose.
  - **Right rail (sticky):** `DonationBox` → `RailCta` (recurring) → `RailCta` (promo, CZ-only) →
    `ShareRow`.
  - **Full-width divider:** `PledgeStrip` (100% pledge + supplier) — present in **every** state.
  - "Další děti" grid: **3× `StoryCard`** → `SiteFooter`.
  - **Mobile sticky CTA bar** (missing amount + Přispět), hidden when `state="funded"`.
- **Screen states:** live / urgent / funded (mirrors DonationBox `CollectionState`).
- **Responsive:** ≤900px single column + rail below + sticky CTA appears; ≤860px "Další děti" → 1 col;
  ≤720px header hamburger.
- **Content model (`_fixtures.tsx`):** per-tenant `contentCz` / `contentRo` (RO omits promo).
- **Stories:** `Probíhá`, `Naléhavé`, `Vybráno`.
- **Explicitly out of scope (contract):** donation modal (email/consents/mock payment), step-by-step
  "gift chain", donor count real-data availability.

**Component count:** 16 components (7 Atoms + 9 Blocks — SiteHeader/SiteFooter are Blocks-level) +
1 Page = **17 catalogued units.**

---

## 2. Mapping table — canonical component ↔ reconstructed COMP/WIRE

Legend: **MATCH** = same concept, name aligns; **RENAME** = same concept, different name/contract;
**GAP→recon** = canonical component has **no** reconstructed COMP (reconciliation target — the
current-state doc under-modelled it, usually because it lived `inline` in a WIRE); **GAP→redesign**
= reconstructed COMP has **no** canonical counterpart (redesign lacks or defers it).

| Canonical (redesign) | Layer | Reconstructed COMP | Reconstructed WIRE trace | Status | Note |
|---|---|---|---|---|---|
| **Button** | Atom | COMP0001 PrimaryButton | WIRE0001/0002 (+14 WIREs) | **RENAME + superset** | Canonical `Button` has a formal `variant` (primary/secondary/ghost) + `size` (md/lg) + `block` axis. This **resolves COMP0001's two Open Questions**: the "secondary/green button" it left un-promoted = `variant="secondary"/"ghost"`; the "full-width Uncertain" = `block`. |
| **SiteHeader** | Block | COMP0002 GlobalHeader | WIRE0001/0002 headers | **RENAME** | "GlobalHeader" ↔ "SiteHeader". Canonical adds explicit mobile hamburger state + `Button(ghost)` for "Požádat o pomoc" (COMP0002 flagged that button's identity as an Open Question → resolved: it is a ghost `Button`). |
| **SiteFooter** | Block | COMP0003 GlobalFooter | WIRE0001 footer | **RENAME** | "GlobalFooter" ↔ "SiteFooter". Canonical footer is fully prop-driven; the reconstruction's `promoSlot` Open Question (WIRE0014 promo band) has **no** canonical slot — see §4. |
| **StoryCard** | Block | COMP0008 StoryCard | WIRE0001 grid (×6/tab) | **MATCH (name)** | Same name. Contract differs: canonical StoryCard = `CategoryChip` + `ProgressBar` composition, category-driven color, monogram fallback; no lifecycle "completed" variant (COMP0008's active/completed split is a current-state observation, not a canonical axis). |
| **ProgressBar** | Atom | *(none)* — inline in COMP0008 + WIRE0002 "Progress block" | WIRE0001 card / WIRE0002 sidebar | **GAP→recon** | Canonical first-class atom (`role="progressbar"`, gradient reveal). Reconstruction left it inline (COMP0008 Open Q: "does the detail progress block share a component with the card's?" → **yes, it's ProgressBar**). |
| **CategoryChip** | Atom | *(none)* — "category/tag pill" left inline | WIRE0001 filter/stat pills | **GAP→recon** | COMP-inventory-map explicitly rejected the "category pill" (only 1 WIRE-evidenced screen). Canonical promotes it. |
| **TimeLeftPill** | Atom | *(none)* — countdown ribbon inline in COMP0008 | WIRE0001 "ZBÝVÁ …" ribbon / WIRE0002 "Zbývá měsíc" | **GAP→recon** | Canonical atom with a calm/urgent axis + reduced-motion. Reconstruction saw the ribbon only as StoryCard-internal text. |
| **DonationBox** | Block | *(none)* — WIRE0002 sidebar is all `inline` | WIRE0002 donation sidebar | **GAP→recon (major)** | The single biggest gap. WIRE0002's "Progress block", "Amount input", "Přispět 🤝" CTA, recurring/voucher blocks are all separate inline rows; canonical folds them into one `DonationBox` block with live/urgent/funded states. |
| **StoryHero** | Block | *(none)* — WIRE0002 "Media zone" inline | WIRE0002 hero photo | **GAP→recon** | Canonical hero = photo + corner CategoryChip + monogram fallback. Reconstruction saw a bare "hero image". |
| **PatronCard** | Block | *(none)* — WIRE0002 "Patron comment card" inline | WIRE0002 Patron comment | **GAP→recon** | Canonical PatronCard (avatar + verification seal + always-visible comment). Reconstruction had it inline (binds EN0005). Note: canonical comment is **always visible** vs. reconstruction's "Zobrazit komentář Patrona" **toggle** — a genuine current-vs-target behavior difference (§4). |
| **PledgeStrip** | Block | *(none)* — WIRE0002 "Trust banner" inline | WIRE0002 100% banner | **GAP→recon** | Canonical PledgeStrip carries the "100% / never to the family / supplier name" invariant. Reconstruction saw a static "Trust banner". |
| **RailCta** | Block | *(none)* — WIRE0002 recurring + voucher CTAs inline | WIRE0002 "Chci podporovat pravidelně" / "Mám dobrošek" | **GAP→recon** | Canonical RailCta (default + promo). Directly reconciles the two inline secondary CTAs the reconstruction refused to promote (visual-identity-inconsistent). |
| **ShareRow** | Block | *(none)* — WIRE0002 "Share row" inline | WIRE0002 social icon row | **GAP→recon** | Canonical ShareRow with a `SocialName` set. Reconstruction saw an inline icon row (no behavior). |
| **Brandmark** | Atom | *(none)* — part of COMP0002/COMP0003 chrome | header/footer logo | **GAP→recon** | Canonical extracts the tenant logo as its own theme-driven atom; reconstruction folded it into header/footer chrome. |
| **Icon** | Atom | *(none)* — never promoted | glyphs across all WIREs | **GAP→recon** | Canonical shared `IconName` set (9 icons, line/filled by tenant). Reconstruction treated glyphs as inline decoration. |
| **Input** | Atom | *(none)* — "generic text input" deliberately not promoted | form fields across WIREs | **GAP→recon (by design both sides)** | Both sides consciously treat the bare field as a primitive; canonical still ships a themed `Input` atom. Low-priority reconciliation. |
| — | — | **COMP0004 CookieConsentBanner** | WIRE0001 etc. | **GAP→redesign** | No canonical component. Redesign library **does not include** a cookie-consent banner (likely app-shell/consent-platform concern, out of `packages/ui` scope). |
| — | — | **COMP0005 WizardStepper** | WIRE0007–0011 | **GAP→redesign** | No canonical component. The redesign library currently covers **storefront/detail** only; the Application intake wizard is not yet built in `packages/ui`. |
| — | — | **COMP0006 ConsentCheckbox** | WIRE0002/0006/0011/0013 | **GAP→redesign (deferred)** | No canonical component **yet**. DonationBox/StoryDetail contracts explicitly defer the donation modal (email + consents) as a "separate future block" — this is where ConsentCheckbox will live. |
| — | — | **COMP0007 FileUploadDropzone** | WIRE0008/0011/0014 | **GAP→redesign** | No canonical component. Belongs to the (not-yet-built) Application wizard / account surfaces. |
| — | — | **COMP0009 EmailEntryForm** | WIRE0012/0024 | **GAP→redesign (partial)** | No canonical composite. Its atoms exist (`Input` + `Button`), but the auth email-entry form composite is not in `packages/ui` (auth surface not yet built). |

**Tally:** 16 canonical components → 4 map to a reconstructed COMP (1 MATCH-by-name + 3 RENAME),
**12 are GAP→recon** (reconciliation targets), and **5 reconstructed COMPs are GAP→redesign**
(COMP0004–COMP0007, COMP0009).

---

## 3. Reconciliation targets (canonical components with no reconstructed COMP)

These are the actions to make the reconstructed UX documentation respect the real components. Priority
reflects domain weight and how much current-state documentation is affected.

1. **DonationBox (Block) — HIGHEST.** Introduce a reconstructed component (or annotate WIRE0002) that
   recognises the donation sidebar as ONE block with `live/urgent/funded` states, composing
   ProgressBar + TimeLeftPill + Input + Button. Today WIRE0002 scatters it across ~6 inline rows and
   an unresolved "duplicate sidebar" Open Question — the canonical single-block model likely explains
   the duplication (one block, rendered twice in layout). Record the **modal boundary**: canonical
   DonationBox ends at `onDonate(amount)`; the email/consent/payment modal (WIRE0002 modal, COMP0006)
   is a deliberately deferred separate block.
2. **ProgressBar + TimeLeftPill + CategoryChip (Atoms).** Promote these three atoms; they resolve
   concrete reconstruction Open Questions (COMP0008 "shared progress block?", the rejected
   "category pill", the StoryCard-internal countdown ribbon). Rewire COMP0008 StoryCard to
   *compose* CategoryChip + ProgressBar rather than describe them inline.
3. **StoryHero, PatronCard, PledgeStrip, RailCta, ShareRow (Blocks).** Promote the WIRE0002 detail
   blocks currently held inline (Media zone, Patron comment card, Trust banner, recurring/voucher
   CTAs, Share row). RailCta specifically reconciles the two secondary CTAs the reconstruction
   refused to promote for visual-identity inconsistency — the redesign unifies them.
4. **Button variant/size reconciliation.** Update COMP0001 to fold in the canonical
   `variant` (primary/secondary/ghost) + `size` (md/lg) + `block` axes — closing its two Open
   Questions (secondary button; full-width) with target evidence, while keeping the current-state
   observation (only filled-red idle confirmed) intact.
5. **SiteHeader/SiteFooter rename + Brandmark extraction.** Note the "GlobalHeader→SiteHeader",
   "GlobalFooter→SiteFooter" naming; extract Brandmark as its own atom in the reconciled view.
   SiteHeader's ghost "Požádat o pomoc" `Button` closes COMP0002's Open Question.
6. **Icon, Input (Atoms) — LOW.** Note the shared `IconName` set and themed `Input` atom for
   completeness; both sides already treat these as primitives.

**Cross-cutting reconciliation note (multi-tenant + a11y):** the reconstruction is single-tenant CZ
and marks a11y uniformly `Uncertain`. The redesign is **CZ + RO multi-tenant** (every component
theme-switchable via `data-theme`, RO omits the voucher/promo path) and **a11y-enforced** (addon-a11y
`test: "error"`, explicit `aria-*`/focus decisions in every contract). Any reconciled UX doc should
add a tenant dimension and can upgrade a11y claims from `Uncertain` to the canonical contract's
documented behavior — **as target intent**, not as reconstructed current-state fact.

---

## 4. Reconstructed COMPs with no canonical counterpart (redesign lacks or defers them)

| Reconstructed COMP | Why absent from canonical library | Classification |
|---|---|---|
| COMP0004 Cookie Consent Banner | Not in `packages/ui` at all. Consent banners are typically app-shell / consent-platform concerns; the library scope is storefront UI. | Redesign lacks (out of library scope). |
| COMP0005 Application Wizard Stepper | The canonical library currently covers **storefront + story detail** only. The whole Application intake wizard (5 steps) has no built components yet. | Redesign not-yet-built. |
| COMP0006 Consent Checkbox | No canonical component **yet** — but StoryDetail/DonationBox contracts explicitly list the donation modal (email + consents + payment) as a "separate future block ('Mimo scope')". This is the intended home. | Redesign **deferred** (named as future scope). |
| COMP0007 File Upload Dropzone | Belongs to the not-yet-built wizard/account surfaces. | Redesign not-yet-built. |
| COMP0009 Email-Entry Form | Its atoms (`Input`, `Button`) exist, but the auth email-entry composite is not in the library (auth surfaces not yet built). | Redesign not-yet-built (atoms present). |

**Behavioral divergences worth flagging (current vs. target — record, do not "correct"):**
- **Patron comment visibility:** reconstruction (WIRE0002) shows a "Zobrazit komentář Patrona"
  **toggle**; canonical PatronCard mandates the comment is **always fully visible** (no toggle) as a
  transparency invariant. Genuine current→target behavior change.
- **Voucher ("dobrošek"):** reconstruction treats it as a CZ feature inline; canonical formalises it
  as a **per-tenant module** (RailCta promo + DonationBox `voucherLabel`), **CZ-only, hidden in RO**.
- **Footer promo slot:** COMP0003's `promoSlot` (WIRE0014 one-off promo band) has **no** canonical
  SiteFooter counterpart — the canonical footer is fixed-structure. The reconstruction's Open
  Question resolves as "not a general capability" on the target side.
- **Cookie banner dual/single-action ambiguity (COMP0004 Open Q):** moot on the target side — no
  canonical cookie banner exists to reconcile against.

---

## 5. Source paths (for traceability)

- Canonical library: `.../bid-patron-deti/packages/ui/src/components/<Name>/{<Name>.tsx,
  .stories.tsx, .module.css, .contract.md, index.ts}`; page at `.../src/pages/StoryDetail/`;
  foundations at `.../src/foundations/{Uvod,Tokeny,Typografie}.mdx`, `TokenGallery.tsx`; Storybook
  config `.../packages/ui/.storybook/{main.ts, preview.tsx}`; public export surface
  `.../src/index.ts`; token values (external) `@patron/tokens/tokens.css`.
- Reconstructed COMP: `_ar/spec-draft/COMP/COMP0001..COMP0009*.md`,
  `_ar/spec-draft/COMP-inventory-map.md`, `_ar/spec-draft/COMP-synthesis-report.md`.
- Reconstructed WIRE: `_ar/spec-draft/WIRE/WIRE0001_HomepageStoryCatalogue.md`,
  `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` (Components-Used tables).
