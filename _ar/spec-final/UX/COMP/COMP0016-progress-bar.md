---
doc_id: COMP0016
title: ProgressBar
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0001
  - WIRE0002
  - COMP0008
  - EN0004
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0016 – ProgressBar

*(povýšeno z inline evidence; kanonická @patron/ui komponenta: ProgressBar)*

> **Poznámka k povýšení.** Tato komponenta byla v rekonstrukci **ponechána inline** — ani `WIRE0001`
> (progress bar v katalogové kartě) ani `WIRE0002` (blok progresu na detailu příběhu) ani `COMP0008`
> StoryCard nepovýšily samostatnou COMP `ProgressBar`, protože ze samotné current-state evidence
> nelze potvrdit, že progress bar v katalogové kartě a progress bar na detailní stránce jsou *stejná*
> znovupoužitelná komponenta (viz otevřené otázky `COMP0008` a poznámka u tabulky Components-Used
> navazující na `WIRE0002`). Zde je povýšena **jako kanonický cílový kontrakt**
> (`DESIGN-component-index.md`, řádek 7, `_ar/evidence/design-system/components.md` §1 "ProgressBar"),
> dle instrukce, s current-state observacemi rekonstruovanými níže jako jasně oddělená,
> neautoritativní sekce. Podle pravidla current-vs-target z projektové konstituce nesmí být tyto dvě
> roviny zaměňovány.

---

## Zarovnání s design systémem (cíl)

> **STAV: TARGET — `@patron/ui` `ProgressBar` (Atom).** Tato sekce je **autoritativní kanonický
> kontrakt**, vycházející z `DESIGN-component-index.md` řádku 7 a
> `_ar/evidence/design-system/components.md` §1 "ProgressBar". Stojí na stejné úrovni autority jako
> `it-zadani` (budoucí/cílový designový materiál) — **není** current-state pravdou — a nesmí být
> zpětně promítána do sekce "Current-state (observed)" níže.

### Kanonická identita

- **Název:** `ProgressBar` (komponenta úrovně Atom, `packages/ui/src/components/ProgressBar/`).
- **Exportovaný typ propu:** `ProgressBarProps`.
- **Storybook stories:** `Začátek`, `TéměřVybráno`, `Vybráno`.
- **Účel:** vykresluje průběh sbírky/kampaně. Barevný gradient `brand → accent` se plynule rozprostírá
  přes *celou* dráhu (track); vyplněná část gradient pouze **odhaluje** prostřednictvím `clip-path`,
  takže druhá barva gradientu (`--color-accent`) se plně zobrazí až v blízkosti 100% naplnění.
  Jde o záměrný vizuální mechanismus, ne o jednoduché dvoubarevné vyplnění.

### Props / vstupy (kanonické)

| Název | Typ | Povinný | Výchozí | Popis |
|---|---|---|---|---|
| `value` | `number` (0–100) | ano | — | Procento průběhu; interně omezeno (clamp) na `[0,100]` a zaokrouhleno. |
| `height` | `number` (px) | ne | `10` | Výška dráhy/výplně v pixelech. |
| `ariaLabel` | `string` | ne | `"Průběh sbírky"` | Přístupnostní popisek pro roli `progressbar`. **Výchozí hodnota je specifická pro češtinu** — viz chování podle tenantu níže. |

Exportovaný typ: `ProgressBarProps`.

### Varianty / stavy (kanonické)

- **Varianty:** pouze `height` (žádná osa varianty barva/tvar — barva se vždy odvozuje přes pevnou
  dvojici tokenů gradientu brand→accent).
- **Stavy:** `default` / `0%` / `100%` — tedy stejná vykreslovací logika na obou krajních hodnotách
  `value`, nikoli odlišné vizuální "režimy". Neplatí žádné stavy hover/focus/disabled/loading/error —
  komponenta je neinteraktivní stavový indikátor (viz Přístupnost).

### Token sloty (kanonické)

`var(--radius-pill)`, `var(--color-track)`, `var(--color-brand)`, `var(--color-accent)`.

Podle `DESIGN-tokens.md` §3.1/§10: `--color-track` je barva nevyplněné dráhy (`color.track`,
vázaná na tenant: CZ `#FBECE6` / RO `#E1F3F2`); `--color-brand` a `--color-accent` jsou dva konce
odhalovaného gradientu (CZ brand `#EC4B34` → accent `#6D4AFF`; RO brand `#0FB5AE` → accent `#FF7A2F`);
`--radius-pill` dává dráze/výplni plně zaoblené konce (`999px`, hodnota společná pro tenanty). Všechny
čtyři jsou konzumovány přes `var(--…)` v přidruženém CSS modulu komponenty — žádné literály hex/px
(`DESIGN-tokens.md` §10).

### Přístupnost (kanonická)

- **ARIA role:** `role="progressbar"`.
- **ARIA atributy:** `aria-valuemin`, `aria-valuemax`, `aria-valuenow` (odráží omezenou/
  zaokrouhlenou hodnotu `value`).
- **Zaměřitelnost (focus):** explicitně **není zaměřitelná** — jde o roli status/indikátor, nikoli
  o interaktivní ovládací prvek. Žádná klávesová interakce, žádný focus-visible kroužek.
- **Čtečka obrazovky:** ohlašuje se jako indikátor průběhu prostřednictvím ARIA role `progressbar` a
  trojice `aria-value*`; viditelný/přístupnostní popisek pochází z `ariaLabel`.

### Chování podle tenantu (CZ/RO)

- `ProgressBar` sama nepřijímá žádný prop pro volbu tenantu — rozlišení barev je zcela řízeno tokeny
  přes `data-theme="cz"|"ro"`, které přemapují `--color-track`/`--color-brand`/`--color-accent` (bez
  větvení kódu komponenty).
- **Výchozí hodnota `ariaLabel` je specifická pro češtinu** (`"Průběh sbírky"`). Podle poznámek
  A11y/Tenant v `DESIGN-component-index.md` řádku 7: **RO tenant ji musí explicitně přepsat přes
  prop** — komponenta ji **sama automaticky nelokalizuje**. Jakýkoli RO konzument, který `ariaLabel`
  vynechá, zdědí český výchozí text, což je konkrétní lokalizační úskalí, na které je třeba upozornit
  konzumenty v rebuildu (StoryCard, DonationBox) skládající tento atom pod `data-theme="ro"`.

### Kompozice (kanonická)

Listová (leaf) komponenta — nic neskládá. Je sama skládána z:

- `StoryCard` (kanonické zarovnání `COMP0008`) — progress v katalogové/cross-sell kartě.
- `DonationBox` (pouze cílový Block, dosud bez rekonstruované current-state COMP) — progress
  konverzního bloku na detailu příběhu.

```
ProgressBar (canonical, target)
  (leaf — no sub-components)
```

### Zdrojové odkazy

`DESIGN-component-index.md` řádek 7 (indexová tabulka); plný katalogový záznam
`_ar/evidence/design-system/components.md` §1 "ProgressBar" a mapovací řádek §2 "ProgressBar"
(klasifikace `GAP→recon`); hodnoty tokenů `DESIGN-tokens.md` §3.1 (`color.track`, `color.brand`,
`color.accent`), §6 (`radius.pill`), §10 (pojmenování CSS proměnných). Kanonická zdrojová cesta:
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/ProgressBar/`
(`ProgressBar.tsx`, `ProgressBar.stories.tsx`, `ProgressBar.module.css`, `ProgressBar.contract.md`,
`index.ts`).

---

## Current-state (observed)

> Sekce níže dokumentuje **current-state UI Patronusu, jak byl observován na screenshotech živého
> webu**. Jde o evidence-gated rekonstrukční obsah, záměrně oddělený od kanonického cílového
> kontraktu výše. Nic z toho nemá být čteno jako popis design systému rebuildu.

### Účel

Horizontální lišta vykreslující průběh naplnění sbírky u Kampaně/Příběhu (`EN0004`), observovaná ve
dvou odlišných obrazovkových kontextech, které jsou **vizuálně podobné, ale nepotvrzeně stejná
komponenta**:

1. **Progress bar v katalogové kartě** (`WIRE0001`) — uvnitř každé `StoryCard` (`COMP0008`) v mřížce
   katalogu na homepage, vedle řádků "Chybí `<amount>` Kč", "Cílová částka" a vybrané částky.
2. **Blok progresu na detailu příběhu** (`WIRE0002`) — uvnitř dárcovského postranního panelu na
   stránce detailu příběhu, vedle textu "Chybí 1 600 Kč" + "Zbývá měsíc" / "Cílová částka 1 600 Kč".

Obě vykreslení zobrazují horizontální lištu sdělující procento naplnění, current-state evidence však
**nepotvrzuje**, že jde o implementaci sdílené, samostatně znovupoužitelné komponenty — to bylo
explicitně zaznamenáno jako nevyřešená otázka jak v `COMP0008` ("Zda blok progresu na stránce detailu
(`WIRE0002`) sdílí komponentu s progress hodnotami této karty, nebo je implementován samostatně"),
tak v `WIRE0002` ("Nejisté, zda toto sdílí komponentu s vnitřními progress hodnotami Story Card
`COMP0008` — nepotvrzeno jako identické, ponecháno inline"). Toto povýšení tuto current-state
nejistotu **neuzavírá** rozhodnutím shora; je ponechána nevyřešená níže. (Kanonický cílový model tuto
otázku *řeší* — obě komponenty konzumují stejný atom `ProgressBar` — to je ale cílový záměr, nikoli
current-state nález.)

### Props / vstupy (jak observováno)

Není k dispozici žádná DOM/props evidence (pouze statické screenshoty). Data observovaná vedle lišty
v obou kontextech, rekonstruovaná na úrovni `EN0004`/`WIRE`, nikoli potvrzená jako vlastní propy této
komponenty:

| Název (rekonstruovaný) | Typ | Popis |
|---|---|---|
| `percentComplete` | `number` (předpokládaný) | Vizuální podíl vyplnění; na samotné liště nebyl observován žádný číselný popisek — hodnoty nesou okolní texty ("Chybí `<amount>` Kč", "Cílová částka `<amount>` Kč"). |

`Uncertain` — zda samotná lišta vykresluje prop typu `value` odlišný od okolního textu cíl/vybráno,
nebo jde čistě o odvozenou vizuální hodnotu (např. inline šířka přes `style`) bez samostatného API
komponenty, nelze ze screenshotů určit.

### Varianty (jak observováno)

`Uncertain` — mezi vykreslením v katalogové kartě a na detailu příběhu nebyla observována žádná
odlišná vizuální varianta (např. změna barvy/výšky) nad rámec odlišného okolního layoutu; zda existuje
osa výška/velikost, nelze ze statické evidence potvrdit.

### Stavy

#### idle
Statické vykreslení lišty tak, jak bylo zachyceno. Confirmed — kontext katalogové karty:
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`; kontext detailu příběhu:
`_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`.

#### hover
`Uncertain — not observable from static evidence` (neinteraktivní prvek, hover stav se
neočekává, ale ani to nelze potvrdit).

#### focused
`Uncertain — not observable from static evidence.`

#### disabled
`N/A` — nebylo observováno ani nepůsobí jako plausibilní vykreslení disabled stavu u indikátoru
průběhu.

#### loading
`Uncertain — no skeleton/loading-placeholder state was captured for either context; Evidence
Pending per WIRE0001/WIRE0002 States.`

#### error
`N/A` — nebyl observován žádný chybový stav na úrovni jednotlivé lišty; prázdné/chybové stavy na
úrovni stránky/mřížky jsou zaznamenány na úrovni WIRE, nespadají pod tento prvek.

### Events

Neemitovány (ani observovatelné žádné) — v obou zachycených kontextech jde o statický,
neinteraktivní vizuální indikátor.

### Přístupnost (jak observováno)

Obvykle není přímo observovatelná ze screenshotů; podle pravidel COMP zaznamenáno jako `Uncertain`
ve všech bodech.

- **ARIA role:** `Uncertain` — bez dostupné DOM evidence.
- **Klávesová navigace:** `Uncertain`.
- **Správa focusu:** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain` — zda current-state implementace ohlašuje procento nebo popisek,
  nelze ze screenshotů potvrdit.

### Omezení použití (jak observováno)

- Použít když: vykreslování průběhu naplnění sbírky u Kampaně/Příběhu (`EN0004`) uvnitř katalogové
  karty (`WIRE0001`) nebo dárcovského postranního panelu na detailu příběhu (`WIRE0002`).
- Nepoužívat když: `Uncertain` — nebyl observován žádný jiný current-state kontext použití.
- Kardinalita: jedna instance na kartu/panel nesoucí progress (observováno ×6 na katalogovou záložku
  přes opakovanou `COMP0008` StoryCard, ×1 v postranním panelu na detailu příběhu — s poznámkou na
  vlastní nevyřešenou otevřenou otázku `WIRE0002` "duplicitní postranní panel", která by tento počet
  zdvojnásobila, pokud by šlo o skutečnou druhou instanci, a ne o artefakt layoutu).
- Umístění: uvnitř `COMP0008` StoryCard a uvnitř řádku "Progress block" dárcovského postranního
  panelu na detailu příběhu (tabulka Components Used v `WIRE0002`).

### Závislosti (jak observováno)

- Ostatní COMP: skládána uvnitř `COMP0008` StoryCard (current-state, ve vlastní sekci Composition
  toho dokumentu označeno "Uncertain whether this is COMP0008-internal only") a uvnitř inline řádku
  "Progress block" v `WIRE0002`. Před tímto povýšením nebyla potvrzena jako samostatně
  znovupoužitelná current-state komponenta.
- Datové entity: `EN0004` Campaign — váže odvozená pole `campaign_raised` /
  `campaign_percentual_raised` vůči `gift_price` (target) podle `BR-CampaignStoryLifecycle`, jak je
  zaznamenáno v tabulce Data Bindings v `WIRE0002`. Lišta tyto odvozené hodnoty pouze *vykresluje*,
  nepočítá je (výpočet lifecycle vlastní `UC0011`, podle Purpose v `WIRE0002`).
- ACL: nedoloženo.
- Externí knihovny: nedoloženo.

### Kompozice (jak observováno)

```
ProgressBar (current-state, as observed — inline, not independently confirmed reusable)
  (no confirmed sub-elements; rendered as internal markup within COMP0008 StoryCard
   and within WIRE0002's "Progress block" row)
```

### Odchylka od kanonického cíle (zaznamenat, ne "opravovat")

- **Stav znovupoužitelnosti.** Current-state evidence ponechává skutečně `Uncertain`, zda jedna
  komponenta vykresluje jak lištu v katalogové kartě, tak lištu na detailu příběhu. Kanonický cíl
  tuto otázku definitivně řeší — jediný Atom `ProgressBar` skládaný jak `StoryCard`, tak
  `DonationBox`. Toto povýšení přejímá kanonické řešení **pouze pro cílovou sekci výše**;
  current-state nejistota je zde zachována, nikoli tiše uzavřena.
- **Nebyl observován žádný číselný prop `value`.** Current-state screenshoty zobrazují okolní
  textové hodnoty ("Chybí `<amount>` Kč", "Cílová částka"), ale žádný samostatně observovatelný
  procentní popisek přímo na liště, na rozdíl od kanonického kontraktu propu `value` (0–100).
- **Nebyl potvrzen žádný přístupnostní kontrakt.** Kanonický model vyžaduje `role="progressbar"` +
  `aria-valuemin/max/now` a explicitní nezaměřitelnost. Current-state přístupnost je jednotně
  `Uncertain` (bez DOM/nahrávkové evidence), podle průřezové sjednocovací poznámky v
  `_ar/evidence/design-system/components.md` §2.
- **Nebyl potvrzen mechanismus odhalování gradientu.** Kanonický `clip-path` gradient reveal
  brand→accent je specifický vizuální mechanismus; current-state screenshoty nebyly analyzovány na
  úrovni pixelů/CSS, aby se podobný efekt potvrdil nebo vyloučil — ponecháno `Uncertain`, ne
  tvrzeno jako neexistující.
- **Nebyla observována žádná tenant dimenze.** Current-state evidence je pouze CZ (jeden tenant);
  kanonické přemapování tenantu (CZ/RO přes `data-theme`) a úskalí českého výchozího `ariaLabel`
  jsou pouze cílové úvahy, bez current-state RO evidence pro srovnání.

### Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Lišta přítomná v kontextu katalogové karty | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`; `WIRE0001` Layout Zones "progress bar" |
| Lišta přítomná v kontextu postranního panelu na detailu příběhu | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`; `WIRE0002` Layout Zones "progress block" |
| Datová vazba na odvozená pole `EN0004` | Probable | `_ar/spec-draft/EN/EN0004_Campaign.md`; `_ar/spec-draft/BR/BR-CampaignStoryLifecycle.md`; řádek Data Bindings v `WIRE0002` |
| Identita sdílené komponenty mezi oběma kontexty | Uncertain | Open Questions `COMP0008`; poznámka Components Used v `WIRE0002` (obě explicitně nevyřešené) |
| Přístupnost | Uncertain | bez dostupné DOM/nahrávkové evidence |
| Propy/varianty/stavy nad rámec vizuálního vyplnění | Uncertain | pouze statické screenshoty, bez interaktivní/DOM evidence |
