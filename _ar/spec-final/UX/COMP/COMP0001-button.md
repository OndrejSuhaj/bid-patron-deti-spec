---
doc_id: COMP0001
title: Button
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0001
  - WIRE0002
  - WIRE0003
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
  - WIRE0024
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0001 – Button

*(rekonstruováno jako Primary Button; kanonická @patron/ui komponenta: Button)*

---

## Current-state (observed)

> Níže uvedená sekce (až po "Evidence") dokumentuje **současné UI Patronusu, jak bylo pozorováno
> na screenshotech živého webu**. Jde o nezměněný rekonstrukční obsah — pouze název/nadpis
> dokumentu výše byl přejmenován, aby odpovídal kanonickému názvu komponenty. Nic v této sekci
> nečtěte jako popis cílového design systému pro rebuild; k tomu slouží sekce "Design-system
> alignment (target)" níže.

## Účel

Vyplněné tlačítko s vysokým důrazem (high-emphasis) pro call-to-action, používané pro jedinou
primární akci na obrazovce nebo v kroku formuláře (odeslat krok, potvrdit dar, přihlásit se,
aktivovat účet, vyžádat dokument). Sdíleno napříč moduly — identický červený/vyplněný vizuál a
interakční tvar se opakuje napříč moduly Public site, Application wizard, Authentication a Account.
Opětovné použití je přímo pozorováno na nejméně 14 z 22 zdokumentovaných WIRE obrazovek
(`WIRE0001`, `WIRE0002`, `WIRE0003`, `WIRE0006`–`WIRE0015`, `WIRE0019`, `WIRE0024`), což s velkou
rezervou splňuje pravidlo opětovného použití na ≥2 obrazovkách — jde o nejčastěji opakovaný inline
prvek identifikovaný v `_ar/spec-draft/WIRE-synthesis-report.md` §6.

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `label` | `string` | yes | — | Text tlačítka; vlastníkem je COPY per obrazovka (např. "Pokračovat", "Odeslat", "Přispět 🤝", "Přihlásit se", "Aktivovat účet", "Uložit změny", "Ziskat potvrzení"). Tento COMP text popisku nevlastní ani nevyčísluje. |
| `onClick` | `function` | yes | — | Handler; cíl/odeslání za jednotlivou obrazovku vlastní konzumující UC (viz Composition/Usage). |
| `type` | `"button" \| "submit"` | no | `"submit"` | Nativní sémantika tlačítka; `submit` pozorováno jako dominantní použití uvnitř formulářů/kroků průvodce. |
| `disabled` | `boolean` | no | `false` | Blokuje kliknutí, pokud nejsou splněna povinná pole; konkrétní pravidlo blokace vlastní UC/BR (např. `UC0001` step-submit gates), zde není opakováno. |
| `icon` | `string` | no | `none` | Volitelný koncový/úvodní emoji nebo ikonový glyf pozorovaný jednou (🤝 u CTA pro dar, `WIRE0002`); jinak pouze text. |

## Variants

- **emphasis (důraz):** primary (vyplněné červené) — jediná úroveň důrazu přímo pozorovaná s touto
  přesnou vizuální identitou. Vizuálně odlišné **secondary** (obrysové/zelené) tlačítko se také
  opakuje (např. "Chci podporovat... pravidelně" na `WIRE0002`, akce v řádcích "Vybrat"/"Více
  informací" na `WIRE0008`), ale jeho tvar není konzistentně identický napříč výskyty (barva,
  výplň a styl podtržení-vs-tlačítko se liší) — zůstává jako samostatná sesterská varianta
  `Uncertain`, nezahrnutá do potvrzeného kontraktu tohoto COMP. Viz Open Question níže.
- **width (šířka):** content-width (většina obrazovek) | full-width (Uncertain — na statických
  snímcích v desktopové šířce nelze jednoznačně rozlišit)

## States

### idle
Vyplněné červené pozadí, bílý tučný text popisku, zaoblený obdélník. Confirmed na každém citovaném
screenshotu (např. `screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` "Pokračovat";
`screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` "Přihlásit se").

### hover
`Uncertain — nelze pozorovat ze statických screenshotů.`

### focused
`Uncertain — nelze pozorovat ze statických screenshotů.`

### disabled
`Uncertain — vykreslení stavu disabled nebylo zachyceno v žádné evidenci; zda se tlačítko
vizuálně zešedne nebo pouze blokuje odeslání při kliknutí, není zdokumentováno.`

### loading
`Uncertain — žádný stav "in-flight"/spinner nebyl zachycen pro žádnou odesílací akci (např.
předání k platbě daru, odeslání kroku průvodce). Evidence Pending dle poznámek k loading-state v
WIRE0002/WIRE0007/WIRE0011.`

### error
N/A — samotné tlačítko nemá žádné vykreslení chyby; chyby validace se zobrazují u souvisejících
polí formuláře (viz např. inline chyba nesouladu telefonu na `WIRE0010`), nikoli na této komponentě.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onClick` | none | kliknutí/dotek uživatele nebo odeslání klávesou Enter na zaostřeném formuláři | Následný efekt (navigace, odeslání UC, otevření modálu) vlastní sekce Interactions konzumujícího WIRE, nikoli tento COMP. |

## Accessibility

Obvykle nelze přímo pozorovat ze screenshotů — označit jako `Uncertain` / Open Question, pokud to
nepodporují záznamy nebo DOM evidence.

- **ARIA role:** `Uncertain` — výchozím (Assumed) předpokladem je zdědění nativní sémantiky z `<button>`; není k dispozici DOM evidence potvrzující, že nedochází k ARIA override.
- **Keyboard navigation:** `Uncertain` — Assumed dosažitelnost standardním pořadím Tab; nepotvrzeno.
- **Focus management:** `Uncertain` — nelze pozorovat ze statické evidence.
- **Screen reader:** `Uncertain` — předpokládá se (Assumed), že oznamovaný popisek je shodný s viditelným textem `label`; nepotvrzeno.

## Usage Constraints

- Použít, když: obrazovka nebo krok formuláře má právě jednu dominantní následující akci (Confirmed
  pattern: jedno primární tlačítko na obrazovku/krok ve veškeré citované evidenci — žádná obrazovka
  nezobrazuje dvě tlačítka s primárním důrazem vedle sebe).
- Nepoužívat, když: akce je sekundární/volitelná (viz Open Question k secondary-button) nebo je
  čistě navigační (→ vzor textového odkazu, nikoli tento COMP).
- Kardinalita: jedno na obrazovku/krok (Confirmed pozorováním; bez protiargumentů).
- Umístění: konec bloku formuláře/obsahu, typicky zarovnané vpravo nebo na celou šířku uvnitř
  obsahového panelu (Confirmed napříč kroky průvodce `WIRE0007`–`WIRE0011`).

## Dependencies

- Ostatní COMP: žádné (leaf komponenta).
- Datové entity: žádné — tlačítko samo o sobě nenese žádný prop typovaný na entitu.
- ACL: nepozorováno — viditelnost/aktivace je vázána na úplnost formuláře (vlastní BR/UC), nikoli
  na roli, ve veškeré citované evidenci.
- Externí knihovny: nezdokumentováno.

## Composition

Leaf komponenta; není složena z jiných COMP. Sama je často koncovým prvkem uvnitř obrazovek se
strukturou formuláře (viz obrazovky `COMP0005` Wizard Stepper, obrazovky `COMP0006` Consent
Checkbox, `COMP0009` Email-Entry Form).

## Examples

```
PrimaryButton label="Pokračovat" type="submit" />          // WIRE0007–WIRE0011 (kroky průvodce)
PrimaryButton label="Přihlásit se" type="submit" />         // WIRE0012 (přihlášení)
PrimaryButton label="Přispět 🤝" type="submit" icon="🤝" /> // WIRE0002 (dar)
PrimaryButton label="Aktivovat účet" type="submit" />       // WIRE0013 (aktivace)
```

## Open Questions

- ~~Zda je vizuálně odlišná varianta **secondary-button** (obrys/zelená, např. "Chci
  podporovat... pravidelně") skutečnou variantou téže komponenty, nebo zcela samostatným
  COMP~~ — **Vyřešeno na cílové vrstvě, nikoli na vrstvě current-state.** Evidence current-state
  zůstává tak, jak je zaznamenána výše (nekonzistentní barva/výplň napříč výskyty; ponecháno
  inline v `WIRE0002`/`WIRE0008`, nezahrnuto do potvrzeného kontraktu current-state tohoto COMP).
  Kanonická komponenta `@patron/ui` **Button** (target) *skutečně* definuje `secondary` jako
  plnohodnotnou hodnotu `variant` vedle `primary`/`ghost` — viz "Design-system alignment (target)"
  níže. To zpětně nepotvrzuje kontrakt secondary-button na úrovni current-state; znamená to, že
  Button v rebuildu tuto problematiku od tohoto okamžiku převezme.
- ~~Zda je **full-width** skutečnou variantou šířky~~ — **Vyřešeno na cílové vrstvě.** Pozorování
  current-state zůstává nezměněno (`Uncertain` — na statických snímcích nelze jednoznačně
  rozlišit). Kanonický Button pro toto definuje explicitní boolean prop `block`. Viz cílová sekce
  níže.
- Stavy disabled/loading/hover/focus jsou v current-state zcela nezdokumentované; pokud bude v
  budoucnu k dispozici runtime záznam (viz `_ar/tasks/Runtime-truth-policy.md`), sekci current-
  state tohoto COMP je třeba revidovat. (Stavy cílového Buttonu pro tyto případy jsou samostatně a
  plně specifikovány — viz níže.)

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Opětovné použití na ≥2 obrazovkách | Confirmed | 14+ WIRE dokumentů cituje identický vzor vyplněného červeného tlačítka; `_ar/spec-draft/WIRE-synthesis-report.md` §6 "Primary/secondary CTA button" |
| Vizuální stav idle | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`, `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`, `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png` |
| Stavy hover/focused/disabled/loading | Uncertain | žádný snímek v `_ar/prtsc/` nezobrazuje žádný z těchto stavů |
| Accessibility | Uncertain | žádná DOM/nahrávková evidence není k dispozici |

---

## Design-system alignment (target — @patron/ui + @patron/tokens)

> **STATE: TARGET.** Vše níže popisuje **kanonickou komponentu `@patron/ui` `Button` z rebuildu**
> — budoucí kontrakt design systému pro `bid-patron-deti`. Toto **není** current-state pravda o
> Patronusu a nesmí se to číst jako popis toho, jak se tlačítko chová na patrondeti.cz/kidshero.ro
> dnes (k tomu viz "Current-state (observed)" výše). Zdroj:
> `_ar/spec-draft/DESIGN-component-index.md` řádek 1, ověřeno křížově proti
> `_ar/evidence/design-system/components.md` ("Button — `components/Button/`") a
> `_ar/spec-draft/DESIGN-tokens.md`. Cesta v kanonické knihovně:
> `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Button/`.

### Vztah k current-state kontraktu

Kanonický Button je **nadmnožinou** výše rekonstruovaného kontraktu Primary Button: sjednocuje osu
důrazu (potvrzené `primary` tohoto COMP + dvě Open Questions z current-state k obrysové sesterské
variantě secondary a k full-width šířce) do jedné komponenty s explicitními props `variant` a
`block`, plus úroveň důrazu `ghost` a osu `size`, které nebyly v current-state evidenci pozorovány
vůbec. Přejmenování `PrimaryButton` → **`Button`**; doc_id zůstává `COMP0001`.

### Účel (target)

Základní akční prvek pro CTA/secondary/link-style akce. Vykresluje nativní `<button>`, nebo `<a>`
při dodání `href`, se *stejným* vizuálním kontraktem — v current-state evidenci nebyl nikdy
pozorován případ odkazu stylizovaného jako tlačítko, jde tedy o schopnost výhradně cílové vrstvy.

### Props (target)

| Name | Type | Required | Default | Notes vs. current-state |
|---|---|---|---|---|
| `label` | `string` | yes | — | Shoduje se 1:1 s current-state prop `label`. |
| `variant` | `"primary" \| "secondary" \| "ghost"` | no | `"primary"` | Řeší Open Question k secondary-button z current-state: target ji formalizuje jako jednu ze tří hodnot `variant` na téže komponentě, nikoli jako samostatný COMP. `ghost` (obrys, bez výplně) nemá v evidenci tohoto COMP žádný current-state protějšek. |
| `size` | `"md" \| "lg"` | no | `"md"` | V current-state evidenci nepozorováno (na statických snímcích nebyla rozlišitelná žádná osa velikosti). |
| `block` | `boolean` | no | `false` | Řeší Open Question k full-width z current-state: explicitní boolean prop namísto odvozeného layoutu. |
| `iconBefore` / `iconAfter` | `node` | no | — | Generalizuje current-state prop `icon` (jediný emoji glyf, např. 🤝) do dvou pojmenovaných slotů. |
| nativní atributy `<button>`/`<a>` | `onClick`, `type`, `href`, `disabled`, `target`, `rel`, `className` | — | — | `onClick`, `type`, `disabled` se mapují přímo na stejnojmenné current-state props; `href`/`target`/`rel` jsou pouze cílové (režim vykreslení jako odkaz). |

Exportované typy: `ButtonProps`, `ButtonVariant`, `ButtonSize`.

### Sizes (target)

- `md` (výchozí), `lg` — liší se výška/padding; žádná osa velikosti z current-state, se kterou by
  se dalo sesouladit (`Uncertain` v current-state, v target tichá/neřešená — target jednoduše
  definuje dvě velikosti bez nároku na shodu s pozorovaným rozlišením velikostí v current-state).

### States (target)

| State | Target definition | vs. current-state |
|---|---|---|
| default | Základní vykreslení dle `variant`/`size`. | Odpovídá current-state `idle`. |
| hover | Posun jasu na výplni/okraji. | Current-state: `Uncertain — nelze pozorovat ze statické evidence`. Target toto řeší konkrétním pravidlem; zpětně nepotvrzuje current-state stylizaci hover. |
| focus-visible | Focus ring má hodnotu `var(--color-accent)`. | Current-state: `Uncertain`. Target definuje konkrétní, na tokenech založený ring. |
| active | Stav stisknutí (vizuální odezva při pointer-down). | V current-state nebyl vyčíslen žádný ekvivalentní stav (current-state COMP nemá řádek stavu `active`). |
| disabled | Opacity `0.5`; **pouze `<button>`** — režim vykreslení `<a>` nemá nativní `disabled`, takže Button v režimu odkazu tento stav nemůže vyjádřit. | Current-state: `Uncertain — vykreslení stavu disabled nebylo zachyceno v žádné evidenci`. Target definuje pravidlo; mezera v current-state evidenci zůstává nezměněna. |
| loading | `Není součástí kanonického kontraktu Button` — `components.md`/`DESIGN-component-index.md` neuvádí pro Button stav loading/spinner. | Current-state: `Uncertain — žádný stav "in-flight"/spinner nebyl zachycen`. Oběma vrstvám chybí definovaný stav loading; nejde o konflikt target/current-state, jen o nespecifikovaný stav na obou stranách. |
| error | N/A — stejně jako current-state; sám cílový Button nemá žádné vykreslení chyby (chyby validace jsou záležitostí konzumenta/formuláře, např. párování `aria-invalid` u `Input`). | Odpovídá zdůvodnění N/A z current-state. |

### Token slots (target)

Dle kanonického pojmenování CSS proměnných v `DESIGN-tokens.md` §10; komponenty čtou tokeny pouze
přes `var(--…)`, nikdy ne hex/px literály:

- Typografie: `var(--font-body)`.
- Tvar: `var(--radius-pill)` (tvar tlačítka — plně zaoblený, dle `radius.pill` = `999px` v obou
  tenantech).
- Velikost: `var(--size-base)`, `var(--size-lg)` (párováno s prop `size`).
- Spacing: `var(--space-sm)`, `var(--space-md)`, `var(--space-lg)`, `var(--space-xl)` (osy
  paddingu).
- Barva: `var(--color-action)` (primární výplň — CZ `#EC4B34` / RO `#16235A`, dle
  `DESIGN-tokens.md` §3.1 — pozn.: jde o slot `color.action`, nikoli `color.brand`, ačkoli popis
  "filled red" v current-state dokumentu je specifický pro tenant CZ), `var(--color-on-brand)`
  (text popisku na vyplněných variantách), `var(--color-surface)`, `var(--color-text)`,
  `var(--color-border)` (varianty secondary/ghost), `var(--color-accent)` (focus ring, oba tenanty
  — `#6D4AFF` CZ / `#FF7A2F` RO).
- Ukázková reference konzumenta (`Button.module.css`, dle `DESIGN-tokens.md` §10): `background:
  var(--color-action); color: var(--color-on-brand); border-radius: var(--radius-pill); font-
  family: var(--font-body); padding: var(--space-sm) var(--space-lg); outline: 2px solid
  var(--color-accent)` (focus).

### Accessibility (target)

Na rozdíl od výše uvedené current-state sekce (jednotně `Uncertain` — bez DOM/nahrávkové evidence)
má cílový kontrakt vynucená, konkrétní rozhodnutí a11y dle `components.md` a konfigurace Storybooku
(`@storybook/addon-a11y`, `a11y: { test: "error" }`):

- **ARIA role:** nativní sémantika `<button>` při vykreslení jako tlačítko; nativní sémantika
  `<a>` (role odkazu) při zadaném `href` — bez override ARIA role.
- **Focus-visible:** ring má hodnotu `var(--color-accent)` — řízeno tokenem, nikoli natvrdo, takže
  se automaticky přeskinuje podle tenanta.
- **Disabled:** vyjádřeno nativním atributem `disabled`, **pouze v režimu vykreslení jako tlačítko**
  — režim odkazu nemá sémantiku disabled (omezení výhradně na cílové vrstvě, chybějící v
  current-state, kde nebyl stav disabled zdokumentován vůbec).
- **Keyboard navigation:** standardní pořadí Tab (nativní sémantika elementu); žádné vlastní
  ošetření klávesnice není zdokumentováno.
- Kontrast je ověřen pro oba tenanty jako součást vynucení a11y v kanonické knihovně
  (`components.md`) — záruka, kterou current-state evidence nemůže poskytnout (pouze screenshoty).

### Tenant (CZ/RO) behaviour (target)

Theme-neutrální komponenta: žádné tenant-specifické **props**. Veškerá variabilita je řešena
přemapováním tokenů přes `data-theme="cz"|"ro"` — kód komponenty a DOM se dle tenanta nikdy
nevětví:

- `variant="primary"` se rozřeší na `var(--color-action)`, která je sama vázaná na tenanta: CZ =
  `#EC4B34` (brandová červená — jde o hodnotu, která odpovídá popisu idle-state "filled red" z
  current-state), RO = `#16235A` (námořnická modř). Vizuální barva se podle tenanta mění; kontrakt
  komponenty se nemění.
- Focus ring (`var(--color-accent)`) je také vázán na tenanta: CZ `#6D4AFF`, RO `#FF7A2F` — obě
  hodnoty se liší od primární akční barvy ve svém vlastním tenantovi.
- Pro RO tenanta neexistuje k tomuto tlačítku žádná current-state evidence vykreslení (sada
  current-state snímků je pouze CZ, dle výše rekonstruované tabulky Evidence), takže pro RO nelze
  provést srovnání current/target tenanta — zde je to vyznačeno, nikoli vymyšleno.

### Composition (target)

Leaf/atom — shoduje se s current-state (`Leaf komponenta; není složena z jiných COMP`).
Konzumována několika kanonickými Blocks dle `DESIGN-component-index.md`: `RailCta` (ghost, block),
`SiteHeader` (ghost, desktop CTA), `DonationBox` (primary, block).

### Open-question resolution summary

| Current-state Open Question | Target resolution |
|---|---|
| Varianta secondary-button: stejná komponenta, nebo samostatný COMP? | Target: stejná komponenta, `variant="secondary"` (plus třetí úroveň `ghost`, dříve neuvažovaná). Current-state evidence zůstává nezměněná — jde o rozhodnutí cílového designu, nikoli o zjištění v current-state. |
| Full-width: skutečná varianta, nebo nelze pozorovat? | Target: explicitní boolean prop `block`. Current-state zůstává `Uncertain`. |
| Nezdokumentované stavy disabled/loading/hover/focus | Target konkrétně definuje hover/focus-visible/disabled/active; loading zůstává nedefinovaný na **obou** vrstvách (nejde o mezeru mezi target a current-state, jen o nespecifikovaný stav všude). |

### Source references

- `_ar/spec-draft/DESIGN-component-index.md` (řádek 1, "Button")
- `_ar/evidence/design-system/components.md` ("Button — `components/Button/`")
- `_ar/spec-draft/DESIGN-tokens.md` (§3, §6, §10, §11)
- Kanonický zdroj: `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Button/` (`Button.tsx`, `Button.module.css`, `Button.contract.md`, `Button.stories.tsx`)
