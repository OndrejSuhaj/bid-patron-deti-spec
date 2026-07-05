---
doc_id: COMP0014
title: RailCta
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0002
  - EN0010
  - EN0013
  - UC0005
  - UC0009
  - DESIGN-component-index
  - DESIGN-tokens
  - COMP0001
---

# COMP0014 – RailCta

*(povýšeno ze dvou `inline` sekundárních CTA v donation sidebaru na `WIRE0002`; kanonická komponenta
`@patron/ui`: RailCta)*

---

## Design-system alignment (target)

> **STAV: TARGET — `@patron/ui` `RailCta` (Block).** Toto je **autoritativní kontrakt** pro tento
> doc_id. Popisuje **kanonickou komponentu cílového (rebuild) design systému** dle
> `DESIGN-component-index.md` řádek 11 a `_ar/evidence/design-system/components.md` §1 "RailCta".
> Má stejnou úroveň autority jako `it-zadani` (budoucí/cílový stav), **nikoli** current-state pravdu.
> Podle mapování rekonciliace (`components.md` §2, §3 bod 3) se jedná o případ **GAP→recon**: před
> tímto povýšením neexistoval žádný rekonstruovaný COMP — obě CTA, které tato komponenta unifikuje,
> byly na `WIRE0002` zaznamenány jako `inline` (viz "Current-state (observed)" níže, co bylo skutečně
> pozorováno).

### Účel

`RailCta` je lehčí karta umístěná v pravém rail panelu detailu příběhu, přímo pod `DonationBox`
(`COMP0010`), která nabízí sekundární cestu pomoci vedle primárního jednorázového daru: pravidelné
dárcovství, nebo (pouze CZ) uplatnění voucheru ("dobrošek"). Podle `components.md` §1 "RailCta" a §3
bodu 3 se jedná o kanonickou unifikaci dvou vizuálně nekonzistentních sekundárních CTA, které
rekonstrukce pozorovala jako inline na `WIRE0002` a explicitně odmítla povýšit na jednu komponentu.

### Props

| Prop | Type | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `title` | `string` | ano | — | Nadpis karty (např. vysvětlující cestu pravidelného daru nebo voucheru). |
| `text` | `string` | ano | — | Vysvětlující doprovodný text. |
| `href` | `string` | ano | — | Cílový odkaz — externí cíl se otevírá v novém okně s bezpečným `rel` (viz Accessibility). |
| `ctaLabel` | `string` | ne (pouze varianta default) | — | Popisek pro outline CTA tlačítko ve variantě **default**. |
| `promo` | `boolean` | ne | `false` | Vybírá variantu **promo** (celá karta se stává odkazem, akcentované zabarvení). |
| `linkLabel` | `string` | ne (pouze varianta promo) | — | Text odkazu použitý ve variantě **promo** namísto samostatného tlačítka. |

Exportovaný typ: `RailCtaProps` (podle `components.md` §1).

### Variants

- **emphasis:** `default` (`promo=false`) | `promo` (`promo=true`)
  - `default` — vykresluje se jako karta `<div>`: vysvětlující text `title` + `text`, plus ghost/block
    `Button` (`COMP0001`, kanonicky `variant="ghost"`) vykreslený jako odkaz (`href`) s `ctaLabel`.
    Zamýšlené použití: cesta pravidelného daru.
  - `promo` — **celá karta** je jediný `<a href>` s akcentovaným pozadím; `linkLabel` + `Icon`
    (`name="arrow"`) nahrazují samostatné tlačítko. Zamýšlené použití: cesta uplatnění voucheru
    ("dobrošek"), pouze CZ.

### States

- **default (idle):** statické vykreslení podle varianty, jak výše.
- **hover / focus:** focus-visible ring používá `color.accent` (podle `components.md` §1 "States");
  chování hover nad rámec focus ringu není v extrahovaném katalogu dále rozepsáno.
- **focused:** viz hover/focus výše — stejný kontrakt ringu při klávesnicovém focusu.
- **disabled:** `N/A` — v kanonickém katalogu nerozepsáno; `RailCta` je komponenta typu odkaz, nikoli
  formulářový prvek.
- **loading:** `N/A` — nerozepsáno.
- **error:** `N/A` — nerozepsáno.

### Events

`RailCta` nevysílá žádné komponentové callback eventy — je to navigační komponenta. Jejím jediným
"eventem" je nativní navigace kotvy (anchor) na `href` (u varianty default vnitřní `Button`-jako-odkaz,
u varianty promo celá karta jako `<a>`).

### Accessibility (target)

- **ARIA role:** dědí nativní sémantiku `<a>` (varianta promo, celá karta) nebo nativní
  `<button>`-jako-`<a>` (kompozovaný `Button` varianty default, podle cílového kontraktu `COMP0001`)
  — žádná vlastní ARIA role navrch, podle `components.md` §1 "A11y notes".
- **Keyboard navigation:** standardní tab-stop pro odkaz/tlačítko a aktivace klávesou Enter; žádné
  vlastní zpracování klávesnice není dokumentováno.
- **Focus management:** focus-visible ring používá `color.accent` (sdílená konvence focus ringu v
  celé kanonické knihovně — stejný token jako `Button`, `ShareRow`, `Input`).
- **Screen reader:** externí cíle se otevírají v novém okně s použitím "bezpečného `rel`" (podle
  `components.md` §1 "RailCta" — tj. atribut třídy `rel="noopener noreferrer"`; přesná hodnota
  atributu není v zdrojovém katalogu rozepsána znak po znaku, `Uncertain` na této úrovni detailu).
  Žádný další `aria-label` není dokumentován nad rámec viditelného textu `title`/`ctaLabel`/`linkLabel`.

### Tenant (CZ/RO) behaviour

- **Varianta `promo` (voucher / "dobrošek") je pouze CZ.** Podle `DESIGN-component-index.md` řádek 11
  a doménového pravidla `components.md` §1 "RailCta": jde o **per-tenant modul, řízený konzumentem**
  — tj. RO tenant instanci `RailCta` ve variantě promo prostě nevykresluje; nejde o skrytí přes CSS
  pomocí `data-theme`. To odpovídá kompozici stránky `StoryDetail`
  (`DESIGN-component-index.md` řádek "StoryDetail"): pořadí v railu je `DonationBox` →
  `RailCta`(recurring) → `RailCta`(promo, **pouze CZ**) → `ShareRow`; RO obsahová fixtura (`contentRo`)
  instanci promo zcela vynechává (podle `components.md` §1 "StoryDetail" a §4 pozn. o divergenci).
- Varianta **default** (recurring) nenese žádné tenant-specifické props a je očekávána na obou
  tenantech.
- Hodnoty tokenů pro surface/border/text/muted/accent se remapují podle `data-theme="cz"|"ro"` v
  souladu se sdíleným multi-tenant modelem (`DESIGN-tokens.md` §11) — kód komponenty se v žádném
  směru nevětví.

### Token slots

Podle `DESIGN-component-index.md` řádek 11 / `components.md` §1 "RailCta":

`--color-surface`, `--color-border`, `--radius-card`, `--space-md`, `--space-lg`, `--font-body`,
`--font-display` (+ `--font-display-weight`, `--font-display-tracking`), `--color-text`,
`--color-muted`, `--color-accent`.

Všechny se používají přes `var(--…)` v colokovaném CSS modulu komponenty — žádné hex/px literály,
podle konvence `DESIGN-tokens.md` §10. Kompozované subkomponenty `Button` (`COMP0001`, ghost/block) a
`Icon` (`name="arrow"`) nesou vlastní další token sloty, zděděné, nikoli zde opakované (`Button`:
`--radius-pill`, `--size-base`/`--size-lg`, `--space-sm`, `--color-action`, `--color-on-brand`;
`Icon`: žádné — používá `currentColor`).

### Dependencies / Composition

```
RailCta (canonical, target)
  ├─ default variant:
  │    └─ Button (COMP0001, variant="ghost", block=true) — rendered as a link via href
  └─ promo variant:
       └─ Icon (name="arrow") — composed inside the whole-card <a>
```

- Ostatní COMP: `COMP0001` Button (ghost, block — pouze varianta default).
- Datové entity: žádná přímo typovaná — `title`/`text`/`ctaLabel`/`linkLabel` jsou zobrazovací
  (display-ready) řetězce pro danou instanci; navazující záměr CTA (pravidelný dar vs. uplatnění
  voucheru) je nesen volbou routingu konzumenta v `href`, nikoli entitní prop vlastněnou `RailCta`.
- ACL: v kanonickém katalogu neevidováno.
- Externí knihovny: neevidováno.

### Source references

`DESIGN-component-index.md` řádek 11 (Index table) a §2 (přiřazení doc_id: RailCta → COMP0014);
plný záznam katalogu `_ar/evidence/design-system/components.md` §1 "RailCta" (Blocks) a mapovací
řádek §2 "RailCta" (GAP→recon) a §3 bod 3 (priorita rekonciliace); kompozice stránky `StoryDetail`
a pozn. o per-tenant fixturách `contentCz`/`contentRo` v `components.md` §1 "StoryDetail" a §4.
Kořen zdroje kanonické knihovny (nenačten do tohoto repozitáře, odkazován pouze cestou):
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/RailCta/`.

---

## Current-state (observed)

> Níže uvedená sekce dokumentuje **current-state UI Patronusu tak, jak bylo pozorováno na
> screenshotech živého webu** (`WIRE0002`). Nic v této sekci není cílový design; nesmí se promítat
> zpět do sekce "Design-system alignment (target)" výše. Podle mapování rekonciliace
> (`components.md` §2) **pro tento koncept neexistoval žádný rekonstruovaný COMP před tímto
> povýšením** — oba unifikované elementy byly v donation sidebaru `WIRE0002` označeny jako `inline`
> a rekonstrukce explicitně odmítla je povýšit na jednu komponentu z důvodu nevyřešené nekonzistence
> vizuální identity (viz `WIRE0002` Components Used, `COMP0001` Open Questions).

### Co bylo pozorováno

Na obrazovce detailu příběhu (`WIRE0002`, obrazovka `S002`) obsahuje sticky pravý donation sidebar,
pod primárním blokem progress/částka/CTA, dva sekundární elementy cesty pomoci — zaznamenané v
`WIRE0002` Layout Zones ("Donation sidebar") a Components Used jako samostatné řádky `inline`, nikdy
jako jedna komponenta:

| Pozorovaný element | Popis v `WIRE0002` | Vizuální identita (jak zachyceno) |
|---|---|---|
| **Recurring blok** | "Přeji si podporovat rozvoj a vzdělání pravidelně" + CTA "Chci podporovat rozvoj a vzdělání" | Sekundární/**zelené** tlačítko — vizuálně odlišné od primárního plného červeného CTA "Přispět 🤝" (`COMP0001`). |
| **Voucher blok** | CTA "Mám dobrošek" + odkaz "Chcete věnovat dobrošek?" | Sekundární/**červené** tlačítko s ikonou lístku, plus samostatný textový odkaz. |

Oba bloky se nachází ve stejném sloupci sidebaru jako blok progress/částka/donate a řádek ikon pro
sdílení, podle ASCII diagramu Layout Zones v `WIRE0002` (řádky "recurring CTA" / "\"Mám dobrošek\"
CTA" přímo pod primárním CTA "Přispět" a nad řádkem sdílení).

### Proč to bylo v rekonstrukci ponecháno jako inline

`WIRE0002` Components Used explicitně zaznamenal oba prvky jako `inline`, nikoli jako sdílenou
komponentu, protože:

- **Vizuální identita obou prvků je nekonzistentní.** Jeden se vykresluje zeleně, druhý červeně s
  ikonou — evidence-gated disciplína rekonstrukce (podle `rules-COMP.md`: "Vytvořte COMP pouze
  tehdy, kdy je reuse pozorovatelný... nevymýšlejte znovupoužitelnou komponentu") by nesloučila dva
  vizuálně rozdílné elementy do jednoho tvaru na základě evidence z jediné obrazovky.
- **Pouze jedna obrazovka (`WIRE0002`/`S002`) dokládá evidenci pro kterýkoli z prvků** — laťka ≥2
  obrazovek pro reuse potřebná pro povýšení na COMP (podle `rules-COMP.md`) nebyla samotnou
  current-state evidencí splněna ani pro recurring blok, ani pro voucher blok jednotlivě.
- Vlastní Open Questions `COMP0001` (PrimaryButton) zaznamenávají identitu recurring CTA jako
  "sekundární/zelené tlačítko" jako nevyřešenou vůči kontraktu primárního tlačítka — tj. bylo
  zváženo jako možná varianta `COMP0001`, nikoli jako samostatná komponenta, a zůstalo nevyřešeno v
  obou směrech.

**Existence tohoto COMP je tedy zcela vedena rekonciliací na straně cíle** (podle `components.md`
§3 bodu 3: "RailCta konkrétně rekoncilizuje dvě sekundární CTA, které rekonstrukce odmítla povýšit
pro nekonzistenci vizuální identity — redesign je unifikuje"), nikoli current-state evidencí reuse
samostatně překračující laťku ≥2 obrazovek.

### Interactions (as observed, per `WIRE0002`)

- **Klik na recurring CTA** ("Chci podporovat rozvoj a vzdělání") — `WIRE0002` Interaction #4:
  Předpokládá se otevření stejného nebo rovnocenného modálu daru s nastaveným příznakem recurring
  (napájí `UC0005.2`); afordance modálu specifická pro recurring (např. přepínač) **nebyla
  pozorována** v zachycených screenshotech modálu — zaznamenáno jako otevřená otázka ve `WIRE0002`
  (`WIRE0002-Q2`), zde nevyřešeno.
- **Klik na voucher CTA / odkaz** ("Mám dobrošek" / "Chcete věnovat dobrošek?") — `WIRE0002`
  Interaction #5: Předpokládá se otevření plochy pro zadání kódu voucheru napájející `UC0009`;
  **samotná cílová plocha nebyla zachycena** na této obrazovce (IA `S005`/zadání voucheru,
  Uncertain) — zaznamenáno jako otevřená otázka ve `WIRE0002` (`WIRE0002-Q3`), zde nevyřešeno.
- Obě vazby jsou Assumed/Probable, nikoli Confirmed navigační cíle, podle `WIRE0002` Data Bindings
  (`EN0010` RecurringTransaction pro recurring záměr; `EN0013` pro zadání voucheru napájející
  `UC0009`).

### Current-vs-target divergences (flagged, not resolved)

- **Dva vizuálně nekonzistentní elementy vs. jedna komponenta se dvěma variantami.** Current-state
  ukazuje zelené sekundární tlačítko (recurring) a červené tlačítko s ikonou lístku + samostatný
  odkaz (voucher) jako odlišná, neunifikovaná vizuální zpracování. Kanonický kontrakt `RailCta`
  vykresluje obě přes jeden sdílený tvar karty (varianta `default` vs `promo`, lišící se pouze v
  důrazu/zabarvení, nikoli v zásadně odlišných barvách/ikonách). Toto je skutečný current→target
  vizuální redesign, nikoli current-state fakt — nepředpokládejte, že živý web tyto prvky již
  vykresluje konzistentně.
- **Ikona lístku u voucher CTA nemá potvrzený kanonický protějšek.** Kanonická varianta `promo`
  kompozuje obecný `Icon`(`name="arrow"`), nikoli glyf lístku. Zda/jak se styl ikony lístku promítne
  do cílové varianty `promo`, není v `components.md` doloženo — `Uncertain`. Kanonická unie
  `IconName` (`components.md` §0) neuvádí ikonu lístku.
  `Hypothesis — Not evidenced in current sources`, že cíl ikonu lístku prostě vypouští ve prospěch
  afordance se šipkou; nepotvrzeno v žádném směru.
  `Uncertain — živé vykreslení současné cesty promo/voucher nad rámec screenshotu WIRE0002 není
  známo; pro cestu voucheru nebyly zachyceny žádné další obrazovky (WIRE0002-Q3).`
- **Samostatný odkaz "Chcete věnovat dobrošek?" vs. jediný odkaz na celou kartu.** Current-state
  ukazuje voucher blok jako tlačítko *plus* samostatný textový odkaz ("Chcete věnovat dobrošek?").
  Kanonická varianta `promo` toto sjednocuje na jediný odkaz `<a>` na celé kartě s jedním
  `linkLabel`. Zda obě current-state afordance (tlačítko + odkaz) směřují na stejný cíl, nebo na dva
  různé, **není z evidence `WIRE0002` potvrzeno** — `Uncertain`, přeneseno z vlastní nevyřešené
  otázky `WIRE0002-Q3` ve `WIRE0002`.
- **Status "pouze CZ" je tvrzen jen na straně cíle.** `WIRE0002` byl zachycen pouze proti
  `patrondeti.cz` (single-tenant rekonstrukce, podle rozsahu projektu) — rekonstrukce nemá žádnou
  screenshotovou evidenci pro RO tenant, která by potvrzovala nebo vyvracela, že cesta voucheru je
  v *aktuálním* živém systému specifická pro CZ. Pravidlo "pouze CZ, v RO skryto" zaznamenané výše
  v sekci Design-system alignment je **doménové pravidlo na straně cíle** (`components.md`), nikoli
  current-state zjištění; považujte je za `Hypothesis`, pokud je posuzováno konkrétně vůči
  current-state chování v RO.
- **Žádný potvrzený vizuál hover/focus na úrovni `RailCta`.** Ve screenshotech `WIRE0002` nebyl pro
  žádný z bloků zachycen stav hover/focus — current-state hover/focus zůstává `Uncertain`, na
  rozdíl od výše dokumentovaného chování focus ringu (akcentovaný ring) v cílovém kontraktu.

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Recurring blok existuje, zelené sekundární CTA | Confirmed | `WIRE0002` Layout Zones ("Donation sidebar" → recurring blok); Components Used řádek "Recurring CTA" |
| Voucher blok existuje, červené CTA + ikona lístku + samostatný odkaz | Confirmed | `WIRE0002` Layout Zones ("Donation sidebar" → voucher blok); Components Used řádek "Voucher CTA" |
| Oba ponechány jako `inline`, nesloučeny do jednoho current-state COMP | Confirmed | tabulka `WIRE0002` Components Used; `COMP0001` Open Questions (varianta sekundárního tlačítka nepovýšena) |
| Recurring CTA → příznak recurring `UC0005.2` | Probable/Assumed | `WIRE0002` Interaction #4; řádek Data Binding "Recurring CTA intent" → `EN0010` |
| Voucher CTA → vstup `UC0009` | Probable/Assumed | `WIRE0002` Interaction #5; řádek Data Binding "\"Mám dobrošek\" entry" → `EN0013`; samotná cílová plocha voucheru nezachycena |
| Current-state vizuál hover/focus | Uncertain | nezachyceno na žádném screenshotu |
| "Pouze CZ" jako *current-state* fakt (vs. cílové pravidlo) | Uncertain | žádná screenshotová evidence pro RO tenant v tomto průchodu rekonstrukce |
