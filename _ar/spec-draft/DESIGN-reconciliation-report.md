# Design-system reconciliation report — COMP/WIRE ↔ canonical redesign library

> **Purpose.** Records what was reconciled between the reconstructed current-state UX component layer
> (`_ar/spec-draft/COMP/`, `_ar/spec-draft/WIRE/`) and the `bid-patron-deti` rebuild's canonical
> design system (`packages/ui`, `docs/design/`), following the discovery in
> `_ar/evidence/design-system/components.md` and `_ar/evidence/design-system/design-canon.md`.
>
> **Discipline (per project constitution).** The canonical redesign library is **target state**,
> analogous in authority to `it-zadani` — it describes what `bid-patron-deti` is building, not what
> Patronus does today. The reconstructed COMP/WIRE layer remains the **current-state** truth, gated on
> static UI evidence (`_ar/evidence/ui/**`). Reconciliation aligns naming, promotes components the
> current-state layer under-modelled, and records divergences — it does **not** rewrite current-state
> facts toward the target, and does **not** import target claims as current-state fact.
>
> Author: AR discovery/reconciliation pass · dated **2026-07-05** · not committed (write scope is
> `_ar/spec-draft/DESIGN-reconciliation-report.md` only; per task instruction, do not commit).

---

## 1. What this reconciliation produced

Two canonical reference artifacts were established as the reconciliation's anchor points:

- **`DESIGN-tokens.md`** — the semantic token model consumed across the canonical component library
  (color/spacing/typography/radius/shadow/layout slots; tenant-bound vs. shared dimensions; CZ/RO
  concrete values). Lets any COMP contract cite a token slot instead of restating a value.
- **`DESIGN-component-index.md`** — the canonical component catalogue (7 Atoms + 9 Blocks + 1 Page =
  17 units), each with purpose, props, variants/states, tokens consumed, and composition — the
  reconciliation's source of truth for "what the target component actually is."

Both are **target-state references** (mirroring `it-zadani`'s authority for "what to build"), kept
distinct from the current-state COMP contracts they inform.

---

## 2. COMP renames (naming alignment, current-state contract kept)

Three already-reconstructed COMPs are the **same concept** as a canonical component under a
**different name**. The reconstructed contract's content (current-state observations, Open Questions)
is retained; only the naming/cross-reference is aligned to the canonical name for future readers.

| Reconstructed COMP | Current-state name | Canonical name | Note |
|---|---|---|---|
| COMP0001 | PrimaryButton | **Button** | Canonical `Button` formalizes a `variant` (primary/secondary/ghost) + `size` (md/lg) + `block` axis. This resolves COMP0001's two Open Questions: the un-promoted "secondary/green button" = `variant="secondary"/"ghost"`; the "full-width Uncertain" = `block`. Resolution is recorded as target evidence, not retrofitted onto the current-state observation (only filled-red idle stays `Confirmed` current-state). |
| COMP0002 | GlobalHeader | **SiteHeader** | Canonical adds an explicit mobile hamburger state + resolves the "Požádat o pomoc" button's identity Open Question: it is a ghost `Button`. |
| COMP0003 | GlobalFooter | **SiteFooter** | Canonical footer is fully prop-driven, fixed-structure. COMP0003's `promoSlot` Open Question (WIRE0014 promo band) has **no** canonical counterpart — the target side resolves it as "not a general capability" (see §6 open items). |

## 3. StoryCard alignment (COMP0008)

COMP0008 **StoryCard** is the one **MATCH-by-name** case — same concept, same name, both sides. The
reconciliation aligns its *composition*: the canonical `StoryCard` is explicitly `CategoryChip` +
`ProgressBar`, category-driven color, with a monogram fallback; it has **no** lifecycle
"completed" variant. COMP0008's current-state active/completed split stays as-is — it is a
**current-state observation**, not a canonical axis, and is recorded as such rather than dropped.

## 4. The 12 promoted COMPs (COMP0010–COMP0021)

Twelve canonical components had **no** reconstructed COMP — they existed only as inline rows/text
inside WIRE0002 (or, for chrome atoms, inside COMP0002/COMP0003). Each is now promoted to its own
COMP file, reconciling the current-state documentation to recognize the real component boundary:

| New COMP | Canonical component | Was inline in |
|---|---|---|
| COMP0010 | DonationBox | WIRE0002 sidebar ("Progress block", "Amount input", "Přispět 🤝" CTA, recurring/voucher rows) — **highest-priority gap**; the six scattered rows are one block with `live/urgent/funded` states |
| COMP0011 | StoryHero | WIRE0002 "Media zone" |
| COMP0012 | PatronCard | WIRE0002 "Patron comment card" |
| COMP0013 | PledgeStrip | WIRE0002 "Trust banner" |
| COMP0014 | RailCta | WIRE0002 "Chci podporovat pravidelně" / "Mám dobrošek" CTAs |
| COMP0015 | ShareRow | WIRE0002 social icon row |
| COMP0016 | ProgressBar | inline in COMP0008 + WIRE0002 sidebar |
| COMP0017 | TimeLeftPill | "ZBÝVÁ …" ribbon inline in COMP0008 / WIRE0002 "Zbývá měsíc" |
| COMP0018 | CategoryChip | category/tag pill, previously rejected for promotion (only 1 WIRE-evidenced screen) |
| COMP0019 | Brandmark | folded into COMP0002/COMP0003 chrome |
| COMP0020 | Icon | glyphs treated as inline decoration across all WIREs |
| COMP0021 | Input | "generic text input", deliberately un-promoted primitive (low-priority; both sides treat it as a primitive) |

Each promoted COMP is written against **current-state WIRE evidence** for anatomy/behavior actually
observed, cross-referencing the canonical component only for the naming/boundary it clarifies — not
importing canonical props or states as current-state fact.

## 5. The 5 current-only COMPs (no canonical counterpart)

Five reconstructed COMPs have **no** canonical component — the redesign library either lacks them by
scope or has not yet built them:

| COMP | Why absent from canon | Classification |
|---|---|---|
| COMP0004 CookieConsentBanner | Not in `packages/ui` scope (app-shell/consent-platform concern) | Redesign lacks (out of library scope) |
| COMP0005 WizardStepper | Library covers storefront + story detail only; Application intake wizard unbuilt | Redesign not-yet-built |
| COMP0006 ConsentCheckbox | Donation modal (email + consents) explicitly deferred as a future block in `DonationBox`/`StoryDetail` contracts | Redesign **deferred** (named future scope) |
| COMP0007 FileUploadDropzone | Belongs to unbuilt wizard/account surfaces | Redesign not-yet-built |
| COMP0009 EmailEntryForm | Atoms (`Input`+`Button`) exist; auth composite and auth surface unbuilt | Redesign not-yet-built (atoms present) |

These stay as **current-state-only** COMPs; no canonical reference was added to them beyond the note
above, since there is nothing on the target side to align to yet.

## 6. WIRE0002 canonical composition and divergence

WIRE0002 (Story Detail + donation modal) is the **only** reconstructed screen with a canonical
redesign counterpart — the `StoryDetail` page (E0001, `Done`). The composition reconciliation:

- Canonical anatomy: `SiteHeader` → breadcrumb → H1 → **main column** (`StoryHero` → lede →
  `PatronCard` → prose) + **sticky right rail** (`DonationBox` → `RailCta` recurring → `RailCta`
  promo, CZ-only → `ShareRow`) → full-width `PledgeStrip` divider (present in every state) →
  "Další děti" grid (3× `StoryCard`) → `SiteFooter` → mobile sticky CTA bar (≤900px, hidden when
  funded).
- This composition explains WIRE0002's previously unresolved "duplicate sidebar" Open Question: one
  `DonationBox` block, rendered as one coherent unit rather than six independent inline rows.

**Divergences recorded (current vs. target — kept separate, not resolved):**

| Aspect | Current-state WIRE0002 (observed) | Canonical redesign |
|---|---|---|
| Donation entry | Inline donation modal (amount + contact + consents) on the page | Modal kept, but scoped as a **future** block; canon page ends at `onDonate(amount)` |
| Donation presets | Live CZ uses a fixed 500 regardless of story | Fixed clean presets (500/1000/2000 Kč), explicit "capacity not goal size" rule + remainder quick-fill |
| Category tag | Violet pill in breadcrumb + a different badge on cards (two treatments) | One unified `CategoryChip` (icon+color), same area = same color across chip/card wash/monogram |
| Patron comment | "Zobrazit komentář Patrona" **toggle** | `PatronCard` mandates comment **always visible** — genuine current→target behavior change |
| Voucher (dobrošek) | CZ feature, inline "Mám dobrošek"/"Koupím dobrošek" (S005) | Formalized as a **per-tenant module**: promo `RailCta` (CZ-only) + `DonationBox.voucherLabel`; redeem stays in box; RO has none |
| Urgency | Time shown on photo | Own `color.urgent` token, full alert-badge pill + pulse, decoupled from brand |
| 100%/vendor | Present (CZ red-band ethos) | Promoted to bold full-width `PledgeStrip` divider, vendor in nominative case (machine-fillable) |

## 7. WIRE0001 chrome rewire

WIRE0001 (homepage/story catalogue) chrome (header/footer) is rewired to compose from the promoted
atoms/blocks rather than describe them monolithically: `SiteHeader` now composes `Brandmark` + `Button`
(ghost, "Požádat o pomoc") + `Icon` (user); `SiteFooter` composes `Brandmark` (small) + hardcoded
social glyphs. The `StoryCard` grid inside WIRE0001 is rewired to explicitly compose `CategoryChip` +
`ProgressBar` (previously inline text/pill descriptions) per the COMP0008 alignment (§3). The
catalogue **page itself** (filter tabs, S001 layout) has **no** canonical counterpart — only the
`StoryCard` block is canon, reused; the surrounding page composition remains current-state-only
(target: E0004, `Plánováno`).

---

## 8. Cross-cutting deltas recorded

- **Multi-tenant CZ/RO.** The reconstruction is single-tenant CZ (Patronus as deployed). The canonical
  library is CZ+RO multi-tenant via `data-theme`, with per-tenant token values (color/radius/shadow/
  typography) and content fixtures. Reconciled COMPs note the tenant dimension as **target intent**
  (only CZ is a deployed instance on the redesign side too — RO is a Storybook theming demonstration,
  not a second deployment); current-state COMPs are not rewritten as multi-tenant.
- **Accessibility enforced vs. Uncertain.** The reconstruction marks a11y uniformly `Uncertain` (no
  DOM evidence available). The canonical library enforces a11y (`@storybook/addon-a11y`,
  `test: "error"`) with concrete decisions per contract (roles, `aria-*`, focus ring = `color.accent`,
  contrast verified both tenants). Reconciled COMPs may cite the canonical a11y decision as **target
  intent** alongside the current-state `Uncertain` marker — the two are not merged into one claim.
- **RO omits voucher.** The dobrošek/voucher promo path (`RailCta` promo variant, `DonationBox
  .voucherLabel`) is explicitly **CZ-only** on the target side, hidden in RO. Current-state Patronus
  voucher behavior (S005, WIRE0002 "Mám dobrošek") is CZ-observed only; no RO current-state voucher
  evidence exists either — the absence is consistent on both sides, but for different reasons (target:
  deliberate per-tenant module; current-state: no RO evidence gathered).

---

## 9. Open items

- **Only S002 is canon.** Story detail (WIRE0002) is the sole screen with a canonical redesign (E0001,
  `Done`). The catalogue (S001), the donation modal (S002 modal + S003 thank-you), the Application
  intake wizard (S007–S008e), auth (S009–S010), and account zones (S011–S012, S017–S022) all **await**
  epics **E0003–E0005** (`Draft`/`Plánováno`). No reconciliation can be attempted for these until those
  epics produce canonical pages — any claim that "the redesign does X" on a screen other than S002 is
  currently unsupported.
- **Story-category set needs `@analyst`.** The canonical token model scaffolds three categories
  (development/health/subsistence) but flags the binding per-tenant list as `needs: @analyst`
  (`tokens.md` §5.3). AR's own current-state evidence (application wizard's 9 gift categories in S008b;
  process-maps) could inform this but must **not** silently resolve it — flagged for `@analyst`
  follow-up, not decided here.
- **Donation modal not yet canon.** The current-state modal (inline amount + contact + consents on the
  page, per WIRE0002) is distinct from the target's inline `DonationBox` (ends at `onDonate(amount)`,
  modal explicitly deferred as a future block per `StoryDetail.contract.md` "Mimo scope"). Do not treat
  the redesign's non-binding modal exploration as canon, and do not treat the current-state modal as
  superseded — both stand, recorded separately (see §6 divergence table).

---

## 10. Recommended next step

Publish the aligned COMP set and the two canonical DESIGN references to `_ar/spec-final/UX/**`
(component index + tokens as a dedicated **DESIGN** area, mirrored or cross-linked from
`_ar/spec-final/BA/**` where a business-facing pointer is useful), translated to Czech per the
publication-tier rule (`tooling/docs/rules-spec-final.md`). Concretely:

1. Promote `DESIGN-tokens.md` and `DESIGN-component-index.md` into a `_ar/spec-final/UX/DESIGN/`
   (or equivalent tiered) area with a `_REGISTRY.md`, clearly labelled **target-state reference**.
2. Carry the renamed/promoted COMP0001–COMP0021 (current-state contracts, canonical cross-references
   intact) into `_ar/spec-final/UX/COMP/` under the same tiering rule.
3. Keep the five current-only COMPs (COMP0004–0007, COMP0009) and the divergence tables (§6, §8) in the
   hand-off unchanged, so the rebuild team sees both current-state truth and target direction without
   conflation, per the constitution's current-vs-target rule.

---

## 11. Source paths

- `_ar/evidence/design-system/components.md` — canonical catalogue + mapping table (source of §2–§7).
- `_ar/evidence/design-system/design-canon.md` — design canon, token model, WIRE↔redesign screen
  mapping (source of §6–§9).
- `_ar/spec-draft/COMP/COMP0001..COMP0021*.md` — reconstructed + promoted component contracts.
- `_ar/spec-draft/WIRE/WIRE0001_HomepageStoryCatalogue.md`,
  `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` — rewired Components-Used tables.
- Canonical library (rebuild project, target-state):
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/`,
  `docs/design/{README.md,tokens.md,explorations/*.html}`.
