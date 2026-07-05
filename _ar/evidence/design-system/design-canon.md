# Design canon — the `bid-patron-deti` redesign (evidence catalog)

> **Purpose.** Read-only discovery of the rebuild project's **DESIGN CANON**, canonical page
> compositions and design decisions, related back to the reconstructed UX WIRE screens. Lets the
> AR current-state UX documentation respect the new design direction **without conflating** it with
> observed current-state UI.
>
> **Scope note (critical).** Everything here describes the **rebuild / target** design direction,
> **not** reconstructed current-state Patronus behavior. Per `CLAUDE.md` "Current vs. target rule",
> this is analogous to `it-zadani` authority — a **target** artifact. It must **not** be used to
> "correct" reconstructed current-state UI. Where current and redesign diverge, both are recorded.
>
> **Source root.** All `docs/**`, `packages/**`, `playbook.md`, `runbook.md` paths below are under
> `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/` (the rebuild project). WIRE/IA paths
> are under this spec workspace (`/Users/…/bid-patron-deti-spec/`). Evidence classification uses AR
> vocabulary: `Confirmed` (read directly in a canonical artifact / code), `Partial`, `Uncertain`.
>
> Author: AR discovery pass · captured 2026-07-05 · **not committed** (per task instruction).

---

## 0. What the rebuild is, and the state of the redesign

The rebuild repo is **not a production build** — it is a **technical demo / sales pitch** for a
tender to rewrite the Patronus ("Patron Děti") platform (variant A = rewrite; Argo22 offers only
variant A). `docs/product/overview.md` §1, §8. `Confirmed`.

The redesign is organised into **5 epics** (`docs/product/overview.md` §9):

| Epic | Scope | State |
|---|---|---|
| **E0001** Design systém a tokeny | Tokens, Atoms/Blocks, Storybook, CZ↔RO theming; **story detail** as the one exemplary screen promoted to canon | **`Done`** |
| E0002 Technický scaffold | Walking skeleton: monorepo + running shells (Next web, Payload local, Expo phone) | `Active` |
| E0003 Obsah (Payload CMS) | Content model story/blog/pages | `Draft` |
| E0004 Storefront web | Donor journey CZ: list → detail → donate → mock pay → confirm | `Plánováno` |
| E0005 Mobilní aplikace | Recurring one-tap donation + push loop (Expo) | `Plánováno` |

**Redesign maturity = one screen deep.** E0001 is the only completed design epic. The design canon
exists (tokens + component catalog), but **only ONE full page composition is canon**: *Detail
příběhu* (story detail). Everything else (homepage/catalogue, donation modal, application wizard,
account zones, blog, etc.) is **not yet designed** — it lives only in the reconstructed
current-state WIRE, not in the redesign. This is the single most important fact for relating canon
to WIRE (see §7).

**E0001 "design done" milestone.** Closed 2026-07-04 via a feedback session with no blocking
questions (`docs/engineering/E0001-inkrement-2-report.md` §5, changelog). What "done" proved
(§2 of that report): tenant switch CZ↔RO on the screen, the screen built **exclusively from the
catalog**, token-drift check (every slot in `tokens.md` has a code counterpart and vice-versa), and
**contract parity** for all 9 Blocks + 4 non-trivial Atoms. Gate = `pnpm check` (Biome + typecheck)
green. `Confirmed`.

Three artifact forms of the design layer (`docs/design/README.md` §1):
canonical **intent** (docs: `tokens.md`), **live catalog** (Storybook: `packages/ui`), and
**non-binding explorations** (`explorations/*.html`). Explorations are never a source of truth; canon
= **component code + token values + contracts** (fixtures are NOT domain data).

---

## 1. Design principles / canon rules

Sources: `docs/design/README.md`, `docs/design/tokens.md`, `playbook.md` §10.1,
`docs/architecture/adr/ADR0002…0004` (referenced, not read in full). All `Confirmed` unless noted.

1. **One source of truth per fact.** Intent (which semantic slots exist, what they mean) lives in
   `docs/design/tokens.md`; **values** (hex/px/font families) live in `packages/tokens`;
   visualization is generated from code (Storybook Foundations). "When model and code diverge, the
   bug is in the code — the model is the contract." (`tokens.md` §1.)

2. **Components know only slots, never values.** A component reads `var(--color-brand)` etc., never a
   hex. Tenant re-skin = remapping slots, not editing components. (`tokens.md` §2.)
   **No Tailwind / NativeWind** — a deliberate departure from the "Emitee" precedent; the token
   pipeline (CSS custom properties) is the only layer between value and component.
   (`README.md` §2, ADR0003/ADR0004.)

3. **Web-canonical Storybook + native parity via CONTRACT, not shared code** (ADR0002, cross-platform
   strategy "path B"). Web = real React web components; native holds **parity against the component
   contract**, not shared component code. The `.contract.md` files are the parity treaty.

4. **State/semantic colors are their own tokens, decoupled from brand** — they do not mix with, and
   are **not derived from**, brand color. Lesson from exploration: urgency taken from dark brand in RO
   turquoise blended in and disappeared; brand and state semantics are two different axes. Tenants may
   *tune* the shade, but never derive it from brand. (`tokens.md` §5.2.)

5. **A page/screen is a composition, not a component.** Pages live in `packages/ui/src/pages/<Name>/`
   **only as composition stories** — assembled inline from Blocks/Atoms, with no own React component
   and no export. One story = one page state; module-level mock data; `layout: 'fullscreen'`; empty
   controls; no autodocs. Terminology: **web = page, native = screen** — the same contract unit.
   (`README.md` §3.)

6. **Fixtures demonstrate product truth, but are not domain data.** Page fixtures encode domain
   invariants (100 % pledge, vendor, collection states) to prove the design carries them; the binding
   truth is the colocated `.contract.md` + canonical layers, not the fixture strings. (`README.md` §3,
   §5.)

7. **Docs rule — either JSDoc or MDX, never both.** Default is `autodocs` from JSDoc; a richer write-up
   becomes a colocated `<Name>.mdx` and JSDoc degrades to a pointer. No component holds its explanation
   in two places. (`README.md` §5.)

8. **Cross-layer source-of-truth (`playbook.md` §10.1).** Dictionary → domain terms; Spec → behavior/
   model; **Design/IA → screen structure & navigation**; **Prod (components in `packages/`) → visual &
   UI copy**; Architecture → technical decisions; Product → intent/value. The **app page layer is NOT
   its own source of truth** — on `page vs. canon` conflict, canon wins; the page conforms to it.

9. **Explorations are non-binding; tenant colors are only a "brand anchor".** Exploration raises the
   level, does **not** copy today's sites 1:1. Promotion to canon = distil the sketch into
   `tokens.md` (model) → `packages/tokens` (values) → component. (`README.md` §6.)

10. **Language contract** (`playbook.md` §8): user-facing text = **Czech**; technical identifiers =
    English; canonical docs Czech. Components are language-mute — text only via props (display-ready
    strings), domain enums as TS unions. Category slot keys are English (`development`/`health`/
    `subsistence`); Czech domain term held in a table until a spec glossary exists.

---

## 2. Token model (the design canon's spine)

Source: `docs/design/tokens.md` (intent) + `packages/tokens/src/themes.ts` (values). `Confirmed`.

**Two layers:** primitives (raw tenant brand colors + neutral scale — never touched by components) →
**semantic slots** (roles components read).

**Dimensions and tenant-binding:**

| Dimension | Holds | Tenant-bound? |
|---|---|---|
| **color** | base roles, state family, story-category | **yes** (state family tunable, not derived) |
| **typography** | families (`font.display`/`font.body`) + display traits (`displayWeight`/`displayTracking`) + shared `size.*` scale | families/traits **yes**, scale **no** |
| **radius** | `radius.card`/`control`/`icon`/`pill` | **yes** (CZ sharper + circular icons; RO softer + squircle) |
| **shadow** | `shadow.card` (tinted to tenant ink, not generic black) | **yes** |
| **space** | `space.xs…xl` | **no** (shared) |
| **layout** | `layout.container` (content container width) | **no** (shared) |

**Color slots — base roles** (`tokens.md` §5.1): `brand`, `brandStrong`, `action`, `accent`, `bg`,
`surface`, `surfaceTint`, `text`, `muted`, `border`, `onBrand`, `track`. Slots are **roles, not
shades** (`action` may equal `brand` for one tenant, contrast for another). Focus ring has **no own
slot** — outline reads `color.accent`. Washes/tints are computed in CSS via `color-mix()`, not extra
slots.

**State family** (§5.2): `urgent`/`onUrgent`, `success`/`onSuccess`. `warning`/`info` are documented
direction, **not scaffolded**.

**Story-category** (§5.3): `color.category.development` (rozvoj a vzdělání), `.health` (zdraví),
`.subsistence` (existenční potřeby). **Same area = same color everywhere** (chip, card wash/monogram,
detail accents). Per-tenant remappable. `needs: @analyst` — the binding list of categories (and
per-tenant mapping) is to be confirmed by spec; today's three cover the demo. *(This is a redesign
Open Question that AR's own category evidence could inform — see §8.)*

**Concrete values (`packages/tokens/src/themes.ts`, `story-detail.html` mirror):**

- Shared: `space` 4/8/16/24/40 px; `size` 13/16/20/28/36/52; **`layout.container` = 1200 px**
  (raised from an earlier 1040 — "modern storefronts hold a more generous container";
  `tokens.md` changelog 2026-07-04).
- **CZ** (Patron dětí / Nadace Sirius anchor): brand `#EC4B34` (warm red-orange), brandStrong
  `#B3311D`, action = brand, accent `#6D4AFF` (violet), success/cat-health `#149E6E`/violet, bg
  `#FFF6F2` (warm off-white), display font **Bricolage Grotesque** (weight 800, tracking −.02em),
  body **Hanken Grotesk**, `radius.card` 16px, `icon-radius` 50 % (circular).
- **RO** (KidsHero): brand `#0FB5AE` (turquoise), action `#16235A` (navy, contrast — not brand),
  accent `#FF7A2F` (orange), bg `#EFF9F9`, display font **Baloo 2** (weight 700, no tracking),
  body Hanken Grotesk, `radius.card` 26px (softer), `icon-radius` 16px (squircle).
- `urgent` `#D92D20` in **both** tenants (own state token; alert red "pops" on RO turquoise).

**Typography as documented styles, not atoms.** Deliberately no `Heading`/`Text` atoms; typography
is `Foundations/Typografie` + per-block CSS. Display type = tenant display family + `displayWeight`/
`displayTracking`; H1 uses `clamp(2.15rem, 3.9vw, 3.4rem)`. (`README.md` changelog 2026-07-04;
`StoryDetail.module.css`.)

**Theme axes** (§4): **tenant** `cz`×`ro` is the *active* axis (headline of the demo, pillar 2).
**light/dark mode** is a documented-but-not-scaffolded future second axis; storefront is light-only
today.

**Versioning** (§7): value change = patch; add slot = minor (model first); remove/rename = breaking
(model + component migration first). Model and code must never diverge; a consistency audit enforces
1:1 slot↔code parity including the one-sentence role metadata in `packages/tokens/src/docs.ts`
(which Storybook Foundations renders).

---

## 3. Responsive model — web řez + app-shell hint

Sources: `StoryDetail.contract.md` (Responsivita), `StoryDetail.module.css`,
`docs/design/explorations/story-detail.html` (mobile showcase, git `72282b4`
"responzivní web řez + náznak app shellu"), `.storybook/preview.tsx` (viewports). `Confirmed`.

**Web breakpoints (the canonical "web řez"):**

- **≤ 900 px** — two-column layout collapses to one column; the sticky right rail becomes static;
  the story sits above the rail; a **mobile sticky CTA bar** appears (missing amount + "Přispět").
- **≤ 860 px** — "Další děti" card grid → 1 column.
- **≤ 720 px** — header nav collapses into a hamburger (owned by `SiteHeader`).

Storybook viewport presets (`preview.tsx`): Mobil S 360×740, Mobil 390×844, Mobil L 430×932, Tablet
820×1180, Tablet landscape 1180×820, Notebook 1280×800, Desktop 1440×900. `a11y.test: "error"`.

**App-shell hint (native parity, illustrative only).** The exploration renders the **same inner
content in two shells** (`story-detail.html` "Mobil — jeden obsah, dva shelly", lines ~738–812):

- **Web řez** — browser chrome (URL bar + dots) + brandmark + hamburger + in-frame sticky CTA.
- **Native app shell (illustration)** — system status bar (9:41), a **native header** (back arrow ·
  title "Příběh" · save/heart), and a **bottom tab bar** with 3 tabs: **Domů / Příběhy / Účet**
  (RO: Acasă / Povești / Cont).

This encodes ADR0002: shared tokens + domain + contract, **only the navigation chrome differs**; the
inner content holds the contract. The tab bar (Domů/Příběhy/Účet) is the **only glimpse of a target
app IA** anywhere in the redesign — it is a design *illustration*, not a specified navigation model
(`Partial`; native app screens are E0005, `Plánováno`).

---

## 4. Canonical composition — "Detail příběhu" (story detail)

The **only** page promoted to canon. Two forms: the **canonical page**
(`packages/ui/src/pages/StoryDetail/`) and the **exploration** it was distilled from
(`docs/design/explorations/story-detail.html`). `Confirmed`.

### 4.1 Product truth the page must carry (`StoryDetail.contract.md`)

- **100 % of the donation goes to the child** — money goes directly to the **vendor's invoice, never
  to the family**; the founder covers operations. Carried by **PledgeStrip** as a divider before
  "Další děti".
- **Story vendor** = label + value in nominative case → machine-fillable from backend without
  template declension.
- **Patron guarantees the story** — a standalone testimonial block (**PatronCard**); comment always
  visible.
- **Donation amount follows the donor's capacity, not the goal size** — fixed presets across all
  stories (500/1000/2000 Kč; RO 100/300/500 lei); goal size is carried by the progress bar, not the
  presets.

### 4.2 Anatomy (composition from catalog components)

From `StoryDetail.stories.tsx` — page = inline composition of catalog blocks:

```
SiteHeader                                        (brandmark, nav, login, "Požádat o pomoc")
← Všechny příběhy                                 (breadcrumb, Icon "arrow" mirrored)
H1 — story title (full width, display type)
┌───────────────────────────────┬─────────────────────┐
│ StoryHero  (photo + category chip)   │ DonationBox     │  right rail = sticky (top: space-lg)
│ lede       (plain paragraph)         │ RailCta (recurring)
│ PatronCard (testimonial + seal)      │ RailCta (dobrošek promo, CZ only)
│ prose      (WYSIWYG: paragraphs, links, bullets) │ ShareRow
└───────────────────────────────┴─────────────────────┘
PledgeStrip — 100 % pledge + vendor               (full-width divider)
"Další děti čekají na pomoc" — 3× StoryCard
SiteFooter
[mobile sticky CTA bar — missing amount + Přispět]  (≤900px; hidden when funded)
```

Layout grid: `minmax(0, 1.55fr) minmax(300px, 0.95fr)` (`StoryDetail.module.css`).
Container width = `var(--layout-container)` = 1200 px.

### 4.3 Catalog inventory (E0001 report §1: 7 Atoms + 9 Blocks + 1 Page)

- **Atoms** (`packages/ui/src/components/`): `Button`, `Input`, `ProgressBar`, `Brandmark`, `Icon`,
  `CategoryChip`, `TimeLeftPill`. (Contracts on the 4 non-trivial; Icon/CategoryChip/TimeLeftPill are
  purely presentational — props + stories only.)
- **Blocks** (all have `.contract.md`): `StoryHero`, `PatronCard`, `DonationBox`, `RailCta`,
  `ShareRow`, `PledgeStrip`, `SiteHeader`, `SiteFooter`, `StoryCard`.
- **Page**: `StoryDetail` (composition story + `StoryDetail.contract.md`).

### 4.4 Screen states (three, per contract + `DonationBox.contract.md`)

| State | Trigger | Difference |
|---|---|---|
| **probíhá / live** | default | full form; neutral time pill |
| **naléhavé / urgent** | deadline near | time pill = full alert-badge (`color.urgent`, gentle pulse); else unchanged |
| **vybráno / funded** | goal met | DonationBox → thank-you (form disappears); progress 100 %; mobile CTA bar hidden |

**PledgeStrip is present in every state** — the guarantee never disappears (acceptance criterion).

### 4.5 Deliberate shifts vs. today (exploration "Rozhodnutí explorace", lines ~815–836)

Recorded so AR can see how the redesign moves away from observed current-state UI:

- **100 % pledge + vendor as a bold full-width strip** (inspired by today's CZ red band, translated
  into tenant color; placed as a closing divider, not a heavy header).
- **Detailed "donation chain" step-by-step dropped** — out of demo scope; the guarantee is carried by
  one strong statement instead. Returns when target behavior is specified.
- **Donation via MODAL, not inline** — today CZ uses inline checkout; the redesign scopes a modal +
  mock payment + push moment. (The modal itself is **out of scope of the canon page** —
  `StoryDetail.contract.md` "Mimo scope": donation modal is a future block.)
- **Patron as a pillar** — standalone testimonial, larger avatar, comment always visible (no toggle).
- **Funded state from RO baseline** — form disappears, success + what-follows.
- **Placeholder = monogram, not mesh** — calm surface + initial, matching `StoryCard.contract`.
- **Category = single unified chip (icon + color)** — same area = same color, carried by card
  wash/monogram too; per-tenant recolored.
- **Lightened header** — just breadcrumb + full-width title; no pills in header.
- **Time-left as a pill inside the box** (was on the photo); calm = neutral grey tint.
- **Urgency has its own token, not brand** (see canon rule §1.4).
- **Right column layered** — DonationBox primary; below it lighter blocks: **recurring** (→ story's
  category collection account, `kategorie=education`) and **dobrošek promo** (CZ only, whole card is a
  link to `/dobroseky`). "Mám dobrošek" (voucher redeem) stays inside the box.
- **Donation presets = clean round amounts**, not "Baťa" 90/290/990 — key insight: **amount follows
  donor capacity, not goal size**; a small remainder offers a "pay the remaining X" quick-fill.
- **Share as icons** — 7 platforms as a compact monochrome icon row (adopts tenant color on hover).
- **Header with login** + "Požádat o pomoc" CTA; footer content from live sites, own layout.

### 4.6 Tenant/content behavior on this page

Texts are per-tenant content fixtures (`StoryDetail/_fixtures.tsx`) — display-ready strings; the
tenant toolbar switches **both theme and content** (CZ `contentCz` / RO `contentRo`). RO has **no
dobrošek promo** (module per tenant — an Open Question of the exploration). Fixture domain content:
CZ = "Fagot pomůže Cilce ke konzervatoři" (vendor Studio Nástroje, goal 439 000 Kč, missing 329 000,
41 donors, category development); RO = "Adela visează la o tabără la mare" (vendor Kids Camp, goal
2 000 RON). Footer carries real domain facts (CZ collection account 57574646/0600, Comgate,
Nadace Sirius, public-collection registration; RO CIF, Netopia, Fundația KidsHero).

---

## 5. Tenant / brand theming direction

Source: `docs/design/explorations/tenant-theming.html`, `tokens.md` §4, `preview.tsx`,
`docs/product/overview.md` §5–§7. `Confirmed`.

- **Pillar 2 of the demo:** one tokenized component system → CZ and RO look completely different
  **without a fork**. This directly targets the client's unresolved internal debate
  (tokenization vs. separate codebase per country). `overview.md` §5.
- **Mechanism:** a single `data-theme="cz|ro"` attribute on the container remaps CSS custom
  properties; Storybook toolbar dropdown (`globalTypes.tenant`) + one decorator flips it
  (`preview.tsx`). Not NativeWind `vars()` — realized via `data-theme`.
- **Tenant switch flips theme AND content fixtures** (CZ/RO text). Components are language-mute.
- **Brand anchors are framework-level, not 1:1 copies** of today's sites (`README.md` §6): CZ ≈
  Nadace Sirius warm red + violet/green categories; RO ≈ KidsHero turquoise + navy action + orange.
- **Deployment reality:** **only CZ runs**; **RO is a Storybook theming demonstration**, not a second
  deployed instance. The "one build, many tenants" claim rests on the token layer, not two
  deployments. `overview.md` §7. MD (Moldova) is out of demo scope.
- **Tenant model direction** (`overview.md` §6): one codebase, separate instances per tenant;
  config-first → module → never fork; large toggleable modules (crowdfunding, risk, in-kind-donation
  management). *Target intent — not current-state.*

---

## 6. Catalogue / "Pages" structure (Storybook)

Source: `docs/design/README.md` §5, `.storybook/main.ts`, `.storybook/preview.tsx`. `Confirmed`.

- **Framework:** web React + Vite (not RN-Web). **Addons:** `docs` (autodocs), `a11y`.
  Viewport is core in SB9 (responsive řezy checked there).
- **Title taxonomy (atomic-design, IA-driven):** `Foundations/`, `Atoms/`, `Blocks/`, `Pages/`.
  `storySort` fixes order Foundations → Atoms → Blocks → Pages; within Foundations:
  Úvod → Tokeny → Typografie. (Renamed **`Screens/` → `Pages/`** on 2026-07-04 to avoid collision
  with "screen" as the mobile navigation unit — web = page, native = screen.)
- **Foundations** = live visualization of values from `packages/tokens` (colors/typo/radius/space),
  role text rendered from `packages/tokens/src/docs.ts` metadata — not hand-copied.
- **Pages** live under `packages/ui/src/pages/<Name>/` as composition stories only (one story per
  page state; `layout: 'fullscreen'`; controls disabled; `tags: ["!autodocs"]`).
  **Today the only Page is "Detail příběhu"** (three stories: Probíhá / Naléhavé / Vybráno).
- **Catalog canonicity** (`README.md` §5): canonical = **component code + token values + contracts**;
  Storybook is a *reading surface*, not the source of truth; content fixtures are **not** domain data.
- **Planned artifact `docs/design/ia/`** (textual DSL — `.ia` screens with states/edges, block
  catalog, `.fl` flows) is documented as **planned**, to arise with the storefront IA in **E0004**.
  Until then, anatomy + states are held by contracts. (`README.md` §1.)

---

## 7. Mapping: canonical redesign screens ↔ reconstructed WIRE screens

Source for WIRE/IA ids: `_ar/spec-draft/IA-screen-map.md` (this workspace).

**Bottom line: exactly ONE reconstructed screen now has a canonical redesign — S002 (story detail).**
The redesign is one screen deep (E0001); the rest of the reconstructed screen map has **no redesign
counterpart yet** (they belong to unbuilt epics E0003–E0005, all `Plánováno`/`Draft`).

| Redesign artifact (rebuild) | Maturity | Reconstructed WIRE screen(s) | Relationship |
|---|---|---|---|
| **Page "Detail příběhu"** (`packages/ui/src/pages/StoryDetail/`, canon) | **Canon (E0001 Done)** | **S002** Story detail + one-off donation modal | **Direct canonical redesign.** See divergence below. |
| story-detail exploration — donation **modal** (`story-detail.html` .modal, ~399–420, 700–735) | **Exploration only** (explicitly out of the canon page's scope) | S002 (modal half) + **S003** thank-you/success | Redesign *intends* a modal + mock-pay + success "Děkujeme!" moment; not yet a canon block. |
| story-detail exploration — **"Další děti" 3× StoryCard** grid | Canon block (`StoryCard`) inside the canon page | **S001** homepage / story catalogue | The `StoryCard` **block** is canon and reused, but a full **catalogue page** is **not designed** (→ E0004). Only the card, not the S001 filter-tabs page. |
| story-detail exploration — **SiteHeader** (brandmark, nav Jak to funguje/Příběhy/Blog/O nás, login, "Požádat o pomoc") | Canon block (`SiteHeader`) | Global chrome for S001, S013–S016; entry to S006 ("Požádat o pomoc"), S009 ("Přihlásit se") | Header/footer chrome is canon; the pages they frame are not designed. |
| story-detail exploration — **SiteFooter** (Projekt/Kontakt, legal) | Canon block (`SiteFooter`) | Global chrome; links echo S015 (O nás), S013 (Blog) | Footer content mirrors live sites; pages not designed. |
| story-detail exploration — **app shell** tab bar (Domů/Příběhy/Účet) | Exploration illustration only | (no WIRE equivalent — Patronus has **no mobile app**; S017–S020 are web account zones) | Target-only IA glimpse; E0005 not started. |

**Reconstructed screens with NO redesign counterpart** (gap — designed only as current-state, not yet
redesigned): S001 catalogue page, S003 thank-you page, S005 voucher purchase, S006 role-choice,
S007–S008e application intake wizard, S009–S010 auth, S011–S012 account settings/tax, S013–S016
public content, S017–S022 account/donor/applicant/patron zones. These are **out of the demo's design
scope so far**; the redesign explicitly scopes out (`overview.md` §8) the application & risk flow,
logged-in accounts, real payments.

### 7.1 Divergence: observed current-state (S002) vs. canonical redesign

Recorded so AR does **not** "correct" the current-state toward the redesign, and vice-versa. Left =
reconstructed current Patronus (WIRE/IA + `_ar/evidence/ui`); right = redesign canon/exploration.

| Aspect | Current-state S002 (observed) | Redesign canon / exploration |
|---|---|---|
| Donation entry | Inline donation modal (amount + contact + consents) on the page | **Modal** kept, but as a *future* block; canon page scopes out the modal, keeps only the box + presets |
| Donation presets | Live CZ uses a fixed 500 regardless of story | Fixed **clean** presets (500/1000/2000 Kč) across stories; "amount follows donor capacity, not goal" made explicit; remainder quick-fill |
| Category tag | Violet pill in breadcrumb + different badge on cards (two treatments) | **One unified category chip** (icon + color), same area = same color across chip / card wash / monogram |
| 100 % / vendor | Present (CZ red band ethos) | Promoted to a bold full-width **PledgeStrip** divider carrying pledge + vendor (nominative-case, machine-fillable) |
| Patron | Patron comment present | Elevated to a standalone **PatronCard** testimonial pillar (seal "ručí za příběh"), always visible |
| Urgency | (time on photo) | Own `color.urgent` state token; full alert-badge pill with pulse |
| Voucher (dobrošek) | "Mám dobrošek" apply + "Koupím dobrošek" entry (S005) | Redeem stays in box; **promo RailCta** (CZ only) as a rail card; RO has no dobrošek (open question) |
| Header/nav | Current CZ nav + login → account | Lightened header, breadcrumb + full-width title, canon `SiteHeader` |
| Placeholder image | (real photos) | Monogram-on-calm-surface placeholder when no photo (canon `StoryCard` line) |
| Recurring donation | (present as separate flows) | Rail card → **story's category collection account** (`kategorie=education`) |

**Trust default (per `CLAUDE.md`):** for **current behavior**, code/process-maps win — the redesign
does not override the reconstructed S002. For **what to build**, the redesign canon (like `it-zadani`)
is the target. Keep them separate.

---

## 8. Gaps / Open Questions

- **Redesign is one screen deep.** Only S002 (story detail) has a canonical redesign. Mapping the
  rest is impossible until E0003–E0005 produce more Pages. Any AR UX statement "the redesign does X on
  screen Y" is unsupported for Y ≠ story detail. `Confirmed` gap.
- **Donation modal not canon.** The hero donor flow's modal (S002 modal + S003 success) exists only as
  a non-binding exploration; `StoryDetail.contract.md` "Mimo scope" defers it. Do not treat the
  exploration modal as canon. `Confirmed`.
- **App/native IA is illustrative only.** The tab bar Domů/Příběhy/Účet is a design illustration, not
  a specified navigation model; E0005 `Plánováno`. Patronus itself has no mobile app, so there is no
  current-state counterpart. `Partial`.
- **Story-category list is unconfirmed** (`tokens.md` §5.3 `needs: @analyst`). The redesign scaffolds
  three (development/health/subsistence); the binding list per tenant is deferred to spec. **AR's own
  current-state category evidence** (application wizard's 9 gift categories in S008b; process-maps)
  could inform this — flagged as a place where current-state reconstruction feeds the redesign
  question, but must not silently resolve it. `Uncertain`.
- **RO tenant differences beyond color** are partly open (dobrošek module per tenant; RO tax
  redirection ANAF 230 is target-model, `overview.md` §6). Redesign RO = theming demo only, not a
  deployed instance. `Partial`.
- **`docs/design/ia/` (screen/flow DSL) does not exist yet** — planned for E0004. So there is no formal
  redesign IA/flow map to align with `_ar/spec-draft/IA-*` beyond the single canon page + the app-shell
  illustration. `Confirmed`.
- **Explorations are not authoritative.** `story-detail.html` and `tenant-theming.html` are
  non-binding; only what was distilled into `tokens.md` + `packages/tokens` + component/contract code
  is canon. Cite them as *direction*, not truth.

---

## 9. Source paths (all under the rebuild project unless noted)

Rebuild root: `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/`

- `docs/design/README.md` — design layer methodology, canon rules, catalog taxonomy.
- `docs/design/tokens.md` — token model (intent), dimensions, slots, versioning.
- `docs/design/explorations/story-detail.html` — story-detail exploration (layout, 3 states, CZ↔RO,
  web/app shells, "Rozhodnutí explorace" decision log).
- `docs/design/explorations/tenant-theming.html` — pillar-2 tenant theming exploration (CZ↔RO over one
  component set).
- `packages/ui/src/pages/StoryDetail/{StoryDetail.contract.md, StoryDetail.stories.tsx,
  StoryDetail.module.css, _fixtures.tsx}` — the canonical story-detail page.
- `packages/ui/src/components/*` — 7 Atoms + 9 Blocks (each Block + 4 Atoms have `.contract.md`).
- `packages/tokens/src/{themes.ts, css.ts, docs.ts, index.ts}` — token values + CSS-var mapping +
  Foundations role metadata.
- `packages/ui/.storybook/{main.ts, preview.tsx}` — catalog config, tenant decorator, viewports.
- `playbook.md` (§8 language, §10.1 cross-layer source-of-truth), `runbook.md` (§3 Storybook =
  state truth), `docs/product/overview.md` (§5–§9 pillars, tenant model, epics),
  `docs/engineering/E0001-inkrement-2-report.md` (E0001 "design done" milestone),
  `docs/product/epics/E0001-design-system-a-tokeny/` (epic brief).

Spec workspace: `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti-spec/`

- `_ar/spec-draft/IA-screen-map.md` — reconstructed screen ids S001–S022 (+ S-EXT).
