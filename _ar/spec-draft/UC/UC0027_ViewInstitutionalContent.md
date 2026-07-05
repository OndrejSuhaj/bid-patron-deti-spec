# UC0027 — View Institutional & Trust Content

## Header

| Field | Value |
|---|---|
| UC ID | UC0027 |
| Name | View Institutional & Trust Content |
| Bounded Context | None — public static content, outside the C1–C11 domain kernel (`ARCH0001_ApplicationOverview.md` §4) |
| Primary Actor(s) | Anonymous visitor |
| Trigger Type | UI (public page load) |

## Actors & Responsibilities

- **Anonymous visitor** — navigates to the "O nás" page (`/o-nas`) from the global site navigation or
  footer, reads the static institutional/trust content, and optionally downloads one of the published
  documents (ethical code, annual report, public-collection control protocol).
- **System** — serves the requested content as a single, statically-authored public page; no
  parameters, filters, or per-visitor state are applied. There is no orchestration, computation, or
  domain-entity read behind this page beyond ordinary CMS page rendering and static-file delivery.

## Intent

Let an anonymous visitor learn who runs Patron dětí, see the project team, and satisfy themselves the
organisation is legitimate and accountable — mission statement, team roster (coordinator, executive/
operations director, fundraiser, HR, finance, IT), the ethical code ("Desatero"), audited annual reports
(2018–2024), and public-collection control protocols (2018–2024) — and to download any of these
documents. This is a **read-only trust/transparency surface** with a thin but legitimate user goal
(reassurance before donating or applying); it does not feed into, gate, or mutate any other UC in this
system. It realizes screen **S015** and is one of the "blocked-no-uc" content screens already recorded
in `_ar/spec-draft/IA-screen-map.md` and `_ar/spec-draft/WIRE-screen-coverage.md` — it is documented
here as a lightweight UC only to close the UC-coverage gap for S015, not because new domain behavior was
discovered.

**Scope note (current-state only):** per project instructions, the redesign/rebuild treatment of "O
nás" and the sibling Blog surface is out of scope for this reconstruction pass (rebuild epic E0004,
unbuilt). This UC documents **only how the page behaves today**; it makes no claim about, and does not
anticipate, target-state design.

## Preconditions

- None. The page requires no authentication, no prior domain state (no Lead, Application, Campaign, or
  Transaction needs to exist), and no query parameters.

## Main Flow

1. Visitor: selects "O nás" from the global main navigation, or a footer link ("O nás" / "Výroční
   zprávy" pointing to the in-page anchor `/o-nas#vyrocni-zpravy") — both literal menu-link targets are
   set programmatically to `/o-nas` for the `main-navigation-cz` and `footer-cz` menus
   (`_patron_base_update_cz_menu_links()`,
   `web/modules/custom/patron_base/patron_base.module:457-479`).
2. System: resolves `/o-nas` and renders the page content — mission statement, team section (role
   labels: koordinátorka, výkonná/provozní ředitelka, fundraiser, HR, finance, IT), an ethical-code
   ("Desatero") banner, an annual-reports archive (year tiles, 2018–2024), a public-collection
   control-protocols archive (year tiles, 2018–2024), the organisation's correspondence/billing address,
   and a Facebook follow prompt — per observed evidence
   (`_ar/evidence/ui/ui-observed-areas.md` §16).
3. Visitor: reads the content (no interaction required to consume it).
4. Visitor (optional): selects "Stáhnout Desatero", or "Stáhnout" against a specific year's annual
   report or control protocol.
5. System: serves the corresponding static file for direct download (no generation, no access check
   beyond ordinary public-file delivery — consistent with the sibling static PDF links in the same
   footer menu mapping, e.g. `/files/Pravidla_poskytovani_pomoci_projektu_PATRON.pdf`,
   `/files/nase_desetaro.pdf`, `web/modules/custom/patron_base/patron_base.module:459-470`).

## Alternative Flows

### AF1 — Visitor follows the "Výroční zprávy" footer link directly to the archive section

1. Visitor: selects the footer link "Výroční zprávy", whose target is the same `/o-nas` route with an
   in-page anchor (`/o-nas#vyrocni-zpravy`).
2. System: renders the same page as the Main Flow; the anchor scrolls the visitor directly to the
   annual-reports section — Confirmed as a routing target
   (`patron_base.module:469`), Uncertain whether the anchor/scroll behavior itself is evidenced beyond
   the URL fragment (front-end scroll-to-anchor behavior is not inspected in this source pass).

### AF2 — No dedicated backend module or entity behind the page

1. No custom Drupal route, controller, or REST resource named for "o-nas" (or an equivalent
   `o_nas`/`onas` machine name) was found anywhere in `intake/current-solution/_source/patronus/` — the
   only occurrences of the literal string `o-nas` in custom-module source are the two menu-link URI
   mappings in `patron_base.module` (lines 464, 469, 475) that point the "O nás" navigation and footer
   entries, and the "Výroční zprávy" footer entry, at the path.
2. The `page` / `page_cz` Drupal core content type (a generic basic-page node type, config
   `config/node.type.page.yml`, `config/node.type.page_cz.yml`) is present in the scrubbed config and is
   the only generic content-authoring mechanism evidenced for standalone static pages in this codebase;
   no custom fields, view modes, or business logic are attached to it beyond a `body` field and
   metatags.
3. **Partial / Hypothesis** — it is most plausible that `/o-nas` is a plain content node (of type
   `page` or `page_cz`, or an equivalent CMS page) whose path alias is `/o-nas`, authored and maintained
   editorially with no custom module of its own. This is **not directly confirmed** — no path-alias
   record for `/o-nas` and no node instance are present in the GDPR-scrubbed, code-only source tree (the
   `path_alias` config only carries `language.content_settings.path_alias.path_alias.yml`, a settings
   shim, not actual alias data; content/entity data is not part of the scrubbed intake). Recorded as a
   documented gap, not resolved by invention.

## Postconditions

- No domain aggregate (Lead, Application, Campaign, Transaction, User, etc.) is read, written, or
  otherwise affected by this UC. It is a pure content-serving capability with no side effects.
- The visitor holds informational content and, optionally, a downloaded document; no state change is
  recorded anywhere in the system as a result.

## Traceability

Target SRVs:
- None — this UC does not exercise any of the reconstructed domain services/aggregates (SRV0001–SRV0013
  equivalents under C1–C11); it is CMS-level static content delivery.

EN entities:
- None — no reconstructed domain entity (EN0001–EN0034 range) is read or written by this UC. The
  "team"/"annual report"/"control protocol" content is editorial copy and static files, not a modeled
  domain entity.

Integration boundaries:
- None — no external system call is made to render this page or to serve a linked document (contrast
  with, e.g., ES-layer integrations used elsewhere in the platform).

Screen / UI evidence:
- Screen **S015** — "O nás — about / team / documents" (`_ar/spec-draft/IA-screen-map.md` row S015;
  `_ar/spec-final/UX/IA/IA-patronus.md` — listed as static/institutional, "žádné UC" prior to this pass).
- `_ar/spec-draft/WIRE-screen-coverage.md` — S015 recorded as "blocked-no-uc … static institutional
  page; no orchestrated UC exists; per WIRE hard rule 1, no WIRE file written." This UC does not
  contradict that WIRE decision; it exists only to give S015 a lightweight UC record for
  traceability/registry completeness, consistent with the thin, read-only nature of the screen.
- UI evidence: `_ar/evidence/ui/ui-observed-areas.md` §16 ("O nás — about / team / documents (`/o-nas`)"),
  screenshot `screencapture-patrondeti-cz-o-nas-2026-07-04-13_17_32.png`.
- Source: `web/modules/custom/patron_base/patron_base.module:457-479` (menu-link URI mapping for
  `main-navigation-cz` and `footer-cz`, including the `/o-nas` and `/o-nas#vyrocni-zpravy` targets);
  `config/node.type.page.yml`, `config/node.type.page_cz.yml` (generic basic-page content type,
  Hypothesis for the underlying content mechanism — see AF2).
- Related/adjacent, not merged: screen S016 (`/vysledky`, "Výsledky" — how-it-works/trust/stats page,
  UI evidence §17) is a distinct screen with its own footer link ("Splněné příběhy" → `/vysledky`); it
  is out of scope for this UC.
- Out of scope per project instruction: rebuild epic E0004 (blog + "O nás" redesign) is target-state,
  not evidenced here and not anticipated by this UC.

## Evidence Level

**Confirmed** for the page's observed content and structure (mission statement, team roles, Desatero,
annual-report and control-protocol document archives 2018–2024, correspondence/billing address,
Facebook prompt) and for the navigation/footer routing that points visitors at `/o-nas` — both are
directly evidenced by the UI screenshot (`ui-observed-areas.md` §16) and by the menu-link mapping in
`patron_base.module`. **Partial** for the serving mechanism: no dedicated custom module, controller, or
REST resource for "o-nas" exists in the scrubbed source, and the most plausible explanation — a plain
`page`/`page_cz` basic-page node with a `/o-nas` path alias, maintained purely as editorial content — is
a Hypothesis, not a directly confirmed fact, since node/content and path-alias instance data are not
part of the GDPR-scrubbed, code-only intake. No process-map, test-scenario, or `it-zadani` coverage
exists for this screen (consistent with it being a static/editorial surface rather than a workflow this
pipeline's other evidence sources track).
