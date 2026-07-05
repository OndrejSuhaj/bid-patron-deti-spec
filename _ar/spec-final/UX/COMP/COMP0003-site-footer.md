---
doc_id: COMP0003
title: Site Footer
layer: COMP
spec_type: component
modules: []
status: imported
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
  - IA-patronus
  - DESIGN-component-index
---

# COMP0003 – Site Footer

*(rekonstruováno jako "Global Footer" / "GlobalFooter"; kanonická @patron/ui komponenta: SiteFooter)*

## Current-state (observed)

> Vše od tohoto bodu až po "Evidence" popisuje **současné (current-state) chování Patronusu**,
> rekonstruované z WIRE/screenshot evidence. Tato část se nemění vlivem sladění design systému
> — kanonický kontrakt `@patron/ui` `SiteFooter` viz níže v "Design-system alignment (target)".

## Purpose

Trvale zobrazená vícesloupcová patička webu: brand blurb (krátký text o značce), sociální odkaz
"Sledujte nás", atribuce Nadace Sirius, registrační číslo veřejné sbírky, sloupce s odkazy
("Patron dětí": O nás/Blog/Pravidla poskytování pomoci/Naše desatero/Splněné příběhy/Výroční
zprávy/Jak jsme pomáhali...; "Kontakt": e-mail), badge platebních poskytovatelů (Comgate/
Mastercard/Visa), číslo sbírkového účtu a spodní lišta s copyrightem/právními odkazy. Přítomna
identicky jako chrome téměř na každé obrazovce — přímo pozorována na nejméně 19 z 22 zpracovaných
WIRE dokumentů.

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `promoSlot` | `slot / node` | ne | `none` | Volitelný doplňkový promo pás nad standardním obsahem patičky, pozorován jednou jako "Víte o dítěti, které potřebuje pomoci?" na `WIRE0014` — považován za slot specifický pro danou obrazovku, nikoli za součást základního kontraktu. |

## Variants

- **promo:** none (výchozí, Confirmed na většině obrazovek) | with-promo-band (pouze `WIRE0014` — Uncertain,
  zda se jedná o obecnou schopnost nebo o jednorázové doplnění specifické pro obrazovku nastavení účtu)

## States

### idle
Tmavé pozadí, čtyři obsahové oblasti (brand/blurb, sloupce s odkazy, kontakt, platební badge) plus
spodní lišta s právními odkazy a copyrightem. Confirmed na každém citovaném screenshotu, např.
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
`_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`.

### hover
`Uncertain — not observable from static evidence` (hover stavy odkazů nebyly zachyceny).

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — patička nemá stav disabled.

### loading
N/A — statické chrome.

### error
N/A — žádné vykreslení chyby není v odpovědnosti patičky samotné.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onNavigate` | cílová route | kliknutí na kterýkoli odkaz v patičce | Cíle vlastní IA; několik z nich směřuje na blocked-no-uc obsahové obrazovky (S013/S014/S015). |

## Accessibility

- **ARIA role:** `Uncertain` — předpokládána nativní landmark sémantika `<footer>`; nepotvrzeno.
- **Keyboard navigation:** `Uncertain`.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain`.

## Usage Constraints

- Použít když: vykreslování spodní části jakékoli obrazovky postavené v Patronusu.
- Nepoužívat když: vykreslování externích/vendor povrchů (mimo rozsah WIRE/COMP).
- Kardinalita: přesně jedna instance na obrazovku, na nejspodnější pozici.
- Umístění: úroveň stránky, pod všemi ostatními obsahovými zónami; typicky bezprostředně
  předchází `COMP0004` Cookie Consent Banner, pokud není odsouhlasen.

## Dependencies

- Ostatní COMP: žádné nepotvrzené jako složené podelementy; řádek badge platebních poskytovatelů
  je statická grafika, nikoli interaktivní komponenta.
- Datové entity: žádné.
- ACL: žádné evidované.
- Externí knihovny: žádné evidované.

## Composition

Komponenta chrome na úrovni listu; žádná potvrzená sub-COMP kompozice.

## Examples

```
GlobalFooter />                                   // WIRE0001, WIRE0006–WIRE0013 (standard)
GlobalFooter promoSlot={<CrossSellBanner />} />   // WIRE0014 (with-promo-band, Uncertain generality)
```

## Open Questions

- Zda je promo pás z `WIRE0014` ("Víte o dítěti, které potřebuje pomoci?") obecnou schopností
  slotu patičky, nebo jednorázovým doplněním specifickým pro danou obrazovku — v evidenci nebyl
  nalezen žádný druhý výskyt potvrzující opětovné použití tohoto konkrétního slotu.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Opětovné použití na ≥2 obrazovkách | Confirmed | 19+ WIRE dokumentů cituje identický vzor patičky; `WIRE-synthesis-report.md` §6 |
| Vizuální stav idle | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
| Varianta promo-band | Uncertain | pouze jediný výskyt, `_ar/spec-draft/WIRE/WIRE0014_AccountSettingsProfile.md` |
| Accessibility | Uncertain | žádná DOM/recording evidence k dispozici |

---

## Design-system alignment (target)

> **STATE: TARGET — `@patron/ui` rebuild design system.** Tato část popisuje **kanonický
> kontrakt komponenty `SiteFooter`** z rebuild knihovny `bid-patron-deti`, dle
> `_ar/spec-draft/DESIGN-component-index.md` (řádek 15) a `_ar/evidence/design-system/components.md`
> (`SiteFooter — components/SiteFooter/`). Nejde o current-state chování Patronusu a nesmí být
> zpětně promítáno do sekce "Current-state (observed)" výše. Dle pravidla constitution current-vs-target
> jsou obě verze zaznamenány vedle sebe, nikoli sloučené.
>
> **Reconciliation classification:** `components.md` §2 — **RENAME**. "GlobalFooter" (rekonstruováno)
> ↔ "SiteFooter" (kanonicky): stejný koncept, jiný název a jiný (plně prop-driven, fixní layout)
> kontrakt.

### Canonical identity

- **Name:** `SiteFooter` (komponenta na úrovni bloku, `packages/ui/src/components/SiteFooter/`).
- **Exported prop type:** `SiteFooterProps`.
- **Storybook story:** `Patička`.

### Props / Inputs (canonical)

| Name | Type | Notes |
|---|---|---|
| `tagline` | `string` | Text brand taglinu (nahrazuje pozorovaný statický "brand blurb"). |
| `followLabel` | `string` | Popisek pro social-follow prvek (pozorováno jako "Sledujte nás"). |
| `projectTitle` | `string` | Nadpis sloupce projektových/nav odkazů (pozorováno jako "Patron dětí"). |
| `projectLinks` | `string[]` | Položky sloupce s odkazy (pozorováno: O nás/Blog/Pravidla poskytování pomoci/Naše desatero/Splněné příběhy/Výroční zprávy/Jak jsme pomáhali…). |
| `contactTitle` | `string` | Nadpis kontaktního sloupce (pozorováno jako "Kontakt"). |
| `email` | `string` | Kontaktní e-mail. |
| `contactNotes` | `node[]` | Volný doplňkový obsah kontaktního sloupce. |
| `applyLabel` | `string` | Obsah popisku, per-tenant. |
| `legalNote` | `node` | Právní text spodní lišty (pozorováno: atribuce Nadace Sirius, registrační číslo veřejné sbírky). |
| `privacyLabel` | `string` | Popisek odkazu na zásady ochrany osobních údajů. |
| `copyright` | `string` | Řádek copyrightu. |

Veškerý obsah patičky je předáván jako props, již lokalizovaný — **v kanonickém kontraktu
neexistuje žádný fixní slot "promo pásu"** (viz Divergence níže).

### Variants / states (canonical)

- **Variants:** žádné — kanonická patička je plně obsahem řízená (fixní struktura); neexistuje
  žádná strukturální varianta osy (na rozdíl od pozorované varianty `promoSlot` níže).
- **States:** `default`; hover/focus odkazů.

### Token slots (canonical)

`var(--layout-container)`, `var(--space-xl)`, `var(--space-lg)`, `var(--space-md)`,
`var(--space-sm)`, `var(--color-border)`, `var(--color-surface)`, `var(--color-text)`,
`var(--color-muted)`, `var(--color-action)`, `var(--font-body)`, `var(--font-display)` (+ tučnost/
tracking via `var(--font-display-weight)` / `var(--font-display-tracking)`).

### Composition (canonical)

```
SiteFooter
  ├─ Brandmark (small)              — COMP0019 (canonical; not a reconstructed COMP)
  └─ SocialGlyph (facebook/instagram/linkedin, hardcoded — internal, uncataloged as its own COMP)
```

### Accessibility (canonical)

- Standardní focus stavy odkazů; žádné vlastní ARIA nad rámec nativní landmark sémantiky
  `<footer>`/nav dle `components.md`. Tím se řeší poznámka `Uncertain` u ARIA role z pozorovaného
  dokumentu směrem k "nativní sémantice", i když kanonický zdroj landmark roli explicitně také
  nevyjmenovává — považovat za `Probable`, nikoli `Confirmed`.

### Tenant (CZ/RO) behaviour

- **Theme-neutral kontrakt komponenty** — žádné vlastní tenant-specifické props; veškeré vizuální
  přeskinování probíhá přes token remap pod `data-theme="cz"` / `data-theme="ro"` (barvy, fonty,
  radius, stín), nikoli přes footer-specifické větvení.
- Složený `Brandmark` (varianta small) je sám theme-driven: CZ vykresluje in-repo kompozici
  icon-tile + wordmark; RO vykresluje živé logo KidsHero (hotlinkované, žádný lokální binární
  soubor) — viz `DESIGN-tokens.md` §11 a `DESIGN-component-index.md` řádek 4.
- Veškerý obsah těla patičky (`projectLinks`, `contactNotes`, `legalNote`, `copyright` atd.) je
  dodáván per-tenant/per-locale konzumentem přes props — kanonická komponenta text sama
  nelokalizuje.

### Divergence from observed current-state (record, do not "correct")

- **`promoSlot` nemá kanonický protějšek.** Prop `promoSlot` a varianta `with-promo-band`
  z rekonstruovaného COMP0003 (pozorováno jednou, `WIRE0014` — "Víte o dítěti, které potřebuje
  pomoci?") v kanonickém kontraktu `SiteFooter` **neexistují** — ten má fixní strukturu bez
  rozšiřovacího slotu. Dle `components.md` §4 to řeší otevřenou otázku tohoto dokumentu: na
  straně **target** promo pás "není obecnou schopností" — to však **nemění zpětně** to, co bylo
  **pozorováno** v current-state Patronusu; sekce current-state výše zůstává v platnosti,
  neurčitost (`Uncertain`) obecnosti trvá.
- **Získaný detail kompozice:** kanonický kontrakt povyšuje `Brandmark` a `SocialGlyph` na
  plnohodnotné složené podelementy; rekonstruovaný COMP0003 považuje ekvivalentní chrome
  (brand blurb, sociální odkaz "Sledujte nás") za nestrukturovaný obsah, protože v current-state
  screenshotech nebylo prokázáno jejich opětovné použití odděleně od samotné patičky.
- **Badge platebních poskytovatelů / číslo sbírkového účtu** (pozorováno: badge Comgate/
  Mastercard/Visa, číslo sbírkového účtu) nemají **žádný** odpovídající kanonický prop nebo slot —
  seznam props `SiteFooter` (`tagline`…`copyright`) řádek s badgemi nevyjmenovává. Označit jako
  otevřenou mezeru ke sladění pro rebuild, nikoli jako chybu v žádném ze zdrojů.

### Source references

- `_ar/spec-draft/DESIGN-component-index.md` — row 15 (`SiteFooter`), §2 doc_id assignment, §3.
- `_ar/evidence/design-system/components.md` — `SiteFooter — components/SiteFooter/` section; §2
  mapping table row; §4 divergence note ("Footer promo slot").
- `_ar/spec-draft/DESIGN-tokens.md` — §3 (color slots), §10 (CSS custom-property naming), §11
  (multi-tenant theming model).
