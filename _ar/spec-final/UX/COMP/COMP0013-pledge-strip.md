---
doc_id: COMP0013
title: PledgeStrip
layer: COMP
spec_type: component
modules: []
status: imported
references:
  - WIRE0002
  - EN0004
  - EN0005
  - DESIGN-component-index
  - DESIGN-tokens
  - COMP0010
---

# COMP0013 – PledgeStrip

*(povýšeno z inline: kanonická komponenta `@patron/ui` `PledgeStrip`; pro tento prvek před tímto
dokumentem neexistoval žádný rekonstruovaný current-state COMP — viz "Current-state (observed)"
níže)*

---

## Design-system alignment (target)

> **STAV: TARGET — `@patron/ui` `PledgeStrip` (Block).** Tato sekce je **autoritativní kontrakt**
> pro tento dokument, protože — na rozdíl od `COMP0001/0002/0003/0008` — pro tento prvek před tímto
> povýšením neexistoval žádný rekonstruovaný current-state COMP; prvek byl vždy zaznamenán pouze
> `inline` uvnitř `WIRE0002` ("Trust banner"). Podle pravidla current-vs-target z projektové
> konstituce tato sekce popisuje **design systém rebuildu** (`packages/ui`), stojí na stejné úrovni
> autority jako `it-zadani` (budoucí/cílový stav) a **není** current-state pravdou. Zdroj:
> `DESIGN-component-index.md` řádek 16 / §1 "Note on PledgeStrip"; `_ar/evidence/design-system/
> components.md` §0, §2 (mapovací řádek "PledgeStrip"), §4; `design-canon.md` §4.1, §4.3, §4.4,
> §4.5.

### Canonical identity

- **Název:** `PledgeStrip` (komponenta na úrovni Block, `packages/ui/src/components/PledgeStrip/`
  podle konvence knihovny pro adresáře jednotlivých komponent: `PledgeStrip.tsx`,
  `PledgeStrip.stories.tsx`, `PledgeStrip.module.css`, `PledgeStrip.contract.md`, `index.ts`).
- **Účel:** invariantní pás v plné šířce nesoucí základní důvěryhodný závazek platformy —
  **"100 % daru se dostane k dítěti; peníze nejsou nikdy zaslány rodině; dodavatel je jmenován"**
  (`design-canon.md` §4.1: *"100 % daru jde k dítěti — peníze jdou přímo na faktury dodavatele,
  nikdy rodině; provoz hradí zakladatel. Neseno komponentou PledgeStrip jako oddělovač před
  'Další děti'."*).
- **Umístění v kompozici stránky `StoryDetail`:** vykresluje se jako **oddělovač v plné šířce**
  bezprostředně po dvoukolonové oblasti (hlavní sloupec + přilepený pravý panel) a bezprostředně
  před mřížkou cross-sellu "Další děti čekají na pomoc" (`design-canon.md` §4.2 diagram anatomie;
  `DESIGN-component-index.md` řádek StoryDetail, "Composition regions").
- **Garance přítomnosti:** `PledgeStrip` je přítomen ve **všech** stavech obrazovky
  `StoryDetail`/`DonationBox` (`live` / `urgent` / `funded`) — zaznamenáno jako explicitní
  akceptační kritérium: *"PledgeStrip je přítomen ve všech stavech — záruka nikdy nezmizí"*
  (`design-canon.md` §4.4). To odráží osu `CollectionState` komponenty `DonationBox` (`COMP0010`),
  ale `PledgeStrip` sám **nemá žádný vlastní stav** — neliší se podle `live`/`urgent`/`funded`.

### Props / Inputs (canonical)

`Uncertain — not itemized as its own catalogue subsection with a props table in
_ar/evidence/design-system/components.md §1.` `PledgeStrip` je tam dokumentován pouze prostřednictvím
své role v kompozici `StoryDetail` (§4.2 "Full-width divider") a svého záznamu v mapovací tabulce
(§2), nikoli rozpisem jednotlivých props, jaký dostávají Atoms/ostatní Blocks. Analogicky k sourozeneckým
Blocks se stejným tvarem "statický invariantní text + jmenovaná entita" (`RailCta`, `PatronCard`) je
níže uvedena nejvíce obhajitelná **Hypothesis** — nepotvrzeno proti zdroji:

| Name | Type | Notes |
|---|---|---|
| `vendorLabel` | `string` (Hypothesis) | Zobrazitelný popisek pro pole dodavatele, např. "Dodavatel". Nepotvrzeno v `components.md`. |
| `vendorName` | `string` (Hypothesis) | Jméno dodavatele v **1. pádu, strojově doplnitelné z backendu** — `design-canon.md` §4.1: *"Story vendor = popisek + hodnota v 1. pádu → strojově doplnitelné z backendu bez šablonového skloňování."* Toto omezení na 1. pád je jediný konkrétní evidovaný detail tvaru props, i když název/tabulka samotné props nikoli. |
| `pledgeText` | `string` (Hypothesis) | Zobrazitelný text pledge sdělení (text "100 % dítěti, nikdy rodině"). Nepotvrzeno, zda jde o prop, nebo o pevně zakódovaný text v komponentě. |

Berte tuto tabulku jako lešení typu `Uncertain`, nikoli jako potvrzený kanonický kontrakt — před
generation-grade použitím ověřte přímo proti `packages/ui/src/components/PledgeStrip/PledgeStrip.tsx`
/ `PledgeStrip.contract.md`.

### Variants / states (canonical)

`Uncertain — not itemized separately in components.md.` Pro `PledgeStrip` není zaznamenána žádná
osa variant ani seznam stavů nad rámec jeho konstantní přítomnosti ve stavech `live | urgent | funded`
`DonationBox`/`StoryDetail` (viz "Garance přítomnosti" výše). Na rozdíl od `TimeLeftPill`
(`COMP0017`) nebo `DonationBox` (`COMP0010`) nic v evidenci nenaznačuje, že by se `PledgeStrip` sám
vykresloval odlišně podle stavu sbírky — je pojímán jako statický, na stavu nezávislý oddělovač.

### Token slots (canonical)

`Uncertain — not itemized separately in components.md §1` (`PledgeStrip` nemá vyhrazený seznam
tokenů pro danou komponentu, jak jej mají `Button`/`DonationBox`/atd.). Je však součástí sdíleného
seznamu "UI component inventory consuming these tokens" (`_ar/evidence/design-system/tokens.md`
§11: *"Brandmark, Button, CategoryChip, DonationBox, Icon, Input, PatronCard, PledgeStrip,
ProgressBar, RailCta, ShareRow, SiteFooter, SiteHeader, StoryCard, StoryHero, TimeLeftPill"*), takže
je Confirmed, že spotřebovává **nějakou** podmnožinu sdíleného povrchu tokenů přes `var(--…)` ve
vlastním umístěném CSS modulu (per-component, žádné hex/px literály — `docs/design/README.md` §2–3,
ADR0003). Analogicky ke sdílenému povrchu tokenů a jeho roli jako textového pásu v plné šířce se
zvýrazněním brandu (nejbližší sourozenec: povrchová úprava `PatronCard`/`RailCta` a popis "bold
full-width strip" v §4.5) je nejvíce obhajitelná **Hypothesis** ohledně slotů skutečně ve hře:

- `var(--color-brand)` / `var(--color-brand-strong)` — barva pozadí/zvýraznění pásu (pás v plné
  šířce "translated into tenant color" podle §4.5).
- `var(--color-on-brand)` — barva textu na pozadí barvy brandu.
- `var(--font-body)` — typ písma pro tělo textu pledge sdělení.
- `var(--font-display)` (+ `var(--font-display-weight)`, `var(--font-display-tracking)`) — pokud
  jméno dodavatele nebo nadpisová část používá display typografii.
- `var(--space-lg)` / `var(--space-md)` — vnitřní odsazení pásu v plné šířce.
- `var(--layout-container)` — omezení šířky vnitřního obsahu (kontejner 1200px), v souladu se
  zbytkem mřížky stránky `StoryDetail` (`design-canon.md` §4.2).

Tyto názvy slotů **nejsou potvrzeny** proti `PledgeStrip.module.css`; zaznamenáno pouze jako
Hypothesis.

### Accessibility (canonical)

`Uncertain — not itemized separately in components.md.` Pro `PledgeStrip` konkrétně nejsou
zaznamenány žádné ARIA role, chování klávesnice, fokusu ani čtečky obrazovky. Vzhledem k jeho účelu
(statický, neinteraktivní důvěryhodný výrok bez CTA, vstupu či odkazu v evidenci) je nejvíce
obhajitelným výchozím stavem, že nevyžaduje žádnou interaktivní ARIA roli nad rámec nativní sémantiky
textového obsahu — to však **není potvrzeno** a mělo by se ověřit přímo proti
`PledgeStrip.contract.md`. Pro srovnání: design systém jako celek vynucuje přístupnost přes
`@storybook/addon-a11y` (`a11y: { test: "error" }`, `components.md` §0) — takže ve zdrojovém
`.contract.md` téměř jistě existuje Storybookem ověřený a11y základ, i když nebyl zachycen v extrakci
`components.md` použité zde.

### Tenant (CZ/RO) behaviour

- **Přebarvení podle brandu:** barva zvýraznění brandu v pásu je řízena tokenem
  (`var(--color-brand)` / `var(--color-brand-strong)`), takže se přebarvuje podle
  `data-theme="cz"|"ro"` bez forku kódu komponenty, v souladu s tenant modelem každé jiné kanonické
  komponenty (`_ar/evidence/design-system/components.md` §0).
- **Omezení na 1. pád jména dodavatele platí pro oba tenanty** — návrhový záměr "strojově
  doplnitelné z backendu bez šablonového skloňování" (§4.1) je pravidlem modelování obsahu napříč
  tenanty, nikoli specifickým pro CZ.
- **Žádná tenant-podmíněná viditelnost.** Na rozdíl od promo/voucher varianty `RailCta` (pouze CZ,
  skryto v RO) nebo obsahu `SiteFooter` odlišného podle tenanta nic v evidenci nenaznačuje, že by
  `PledgeStrip` byl skrytý, měněný nebo obsahově forkovaný mezi CZ a RO — je zaznamenán jako
  přítomný ve **všech** stavech pro **oba** tenanty (`design-canon.md` §4.4 "acceptance criterion").
- **Vědomý posun oproti dnešnímu stavu, explicitně uvedený ve zdroji** (`design-canon.md` §4.5):
  *"100% pledge + dodavatel jako výrazný pás v plné šířce (inspirováno dnešním CZ červeným pásem,
  přeloženo do barvy tenanta; umístěno jako závěrečný oddělovač, nikoli jako těžká hlavička)."* Jde
  o vlastní rámování current→target designového týmu — zaznamenáno zde jako záměr cílového stavu,
  nikoli jako fakt current-state (viz "Current-state (observed)" níže pro to, co bylo skutečně
  pozorováno).
- **Detailní "donation chain" krok za krokem v cílovém designu explicitně vypuštěn** (§4.5):
  *"záruka je namísto toho nesena jedním silným výrokem. Vrátí se, jakmile bude specifikováno cílové
  chování."* — tj. `PledgeStrip` záměrně zjednodušuje, místo aby mechanismus pledge rozepisoval po
  bodech.

### Composition (canonical)

`PledgeStrip` je dokumentován jako **Block** bez jakýchkoli skládaných sub-Atoms/Blocks
zaznamenaných v `components.md` — ve zdroji je pojímán jako listový element textu/layoutu v plné
šířce, na rozdíl od skládaných Blocks jako `StoryCard` (→ `CategoryChip` + `ProgressBar`) nebo
`DonationBox` (→ `TimeLeftPill` + `ProgressBar` + `Input` + `Button` + `Icon`). `Uncertain`, zda
skládá `Icon` (např. glyf "fajfka"/"srdce") pro vizuální zdůraznění — neevidováno ani jedním směrem.

```
PledgeStrip (canonical, target)
  └─ (no composed sub-components evidenced — leaf Block; static text/layout only)
```

### Source references

`DESIGN-component-index.md` §1 řádek 16 / "Note on PledgeStrip"; `_ar/evidence/design-system/
components.md` §0 (taxonomie vrstev: PledgeStrip uveden mezi 9 Blocks), §2 (mapovací tabulka, řádek
"PledgeStrip": *"Canonical PledgeStrip carries the '100% / never to the family / supplier name'
invariant. Reconstruction saw a static 'Trust banner'."*), §3 bod priority sladění 3, §4 (behaviorální
divergence); `_ar/evidence/design-system/design-canon.md` §4.1, §4.2, §4.3, §4.4, §4.5;
`_ar/evidence/design-system/tokens.md` §11 (seznam inventáře komponent). Kořen kanonické knihovny
(v tomto průchodu přímo nečten): `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/
packages/ui/src/components/PledgeStrip/`.

---

## Current-state (observed)

> Sekce níže dokumentuje **current-state UI Patronusu tak, jak bylo pozorováno na screenshotech
> živého webu**. Jde o rekonstruovanou evidenci pro prvek, který kanonická knihovna nazývá
> `PledgeStrip`; current-state UI samo tento prvek nikdy nenazvalo ani nekomponentizovalo — byl
> zaznamenán čistě `inline` uvnitř `WIRE0002` pod označením **"Trust banner"**. Nic v této sekci by
> nemělo být čteno jako popis design systému rebuildu — viz "Design-system alignment (target)" výše
> pro kontrakt `@patron/ui` `PledgeStrip`.

### Purpose

Statický textový pás v plné šířce na stránce detailu příběhu (`WIRE0002`) deklarující platformní
pledge 100 % dítěti. Pozorovaný text: **"Na pomoc dětem putuje vždy 100 % částky, kterou darujete."**
— vykresleno jako červený pás (`WIRE0002` §"Anatomy": *"Trust banner (full-width) — red band, 'Na
pomoc dětem putuje vždy 100 % z darované částky.'"*). Téměř identický pledge výrok se objevuje také
jako **microcopy přímo pod každou donation CTA** v sidebaru (*"Na pomoc dětem putuje vždy 100 % z
darované částky"*) a jako jedna z odrážek trust listu v těle příběhu (*"100 % daru jde na pomoc
dětem"*, *"peníze neposíláme rodinám..."*) — `WIRE0002` §"Anatomy". Zda jsou pás v plné šířce a
microcopy vedle CTA *stejným* podkladovým elementem/komponentou vykreslenou dvakrát, nebo dvěma
nezávislými textovými bloky, které se náhodou opakují se stejným sdělením, **není potvrzeno** ze
statické evidence — zaznamenáno níže jako otevřená otázka, nikoli slučováno.

**Počet evidencí pro reuse:** tento prvek je pozorován na **přesně jedné** potvrzeně vybudované
obrazovce (`WIRE0002`, jediná instance pásu v plné šířce). Podle evidence-gated konvence
`rules-COMP.md` ("vytvořit COMP pouze tehdy, je-li reuse pozorovatelný napříč dvěma nebo více WIRE
obrazovkami") by tento prvek na základě samotného current-state pozorování **nekvalifikoval** pro
povýšení z `inline` — je zde zaznamenán konkrétně proto, že úkol instruuje povýšit *kanonický*
`PledgeStrip` (který je evidován jako first-class target Block), nikoli proto, že by current-state
rekonstrukce samostatně nalezla reuse na ≥2 obrazovkách. Tato asymetrie je zaznamenána explicitně,
nikoli zahlazena.

### Props / Inputs (as observed)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `text` | `string` | yes | — | Statický pledge text, např. "Na pomoc dětem putuje vždy 100 % částky, kterou darujete." Není vázán na entitu — tabulka Components-Used `WIRE0002`: *"Trust banner \| inline \| full-width text band \| static copy, not entity-bound."* |

Žádné další props nebyly pozorovány. Zejména — na rozdíl od kanonického Hypothesis props
`vendorName` výše — **v pozorovaném textu pásu v plné šířce samotném není přítomno žádné jméno
dodavatele.** Current-state stránka jmenuje dodavatele jinde na téže obrazovce, ale jako samostatný
element sidebaru ("Přispět můžete na" + popis věcného daru, např. *"balík školních potřeb; dodává
SEVT"* — `WIRE0002` §"Anatomy" sidebar daru), nikoli uvnitř trust banneru. Zda je chování cílového
`PledgeStrip` ohledně jmenování dodavatele skutečně novou schopností (slučující dva samostatné
current-state elementy do jednoho cílového Block), nebo pouze nedokumentovaným detailem
dnešního pásu, je **Uncertain** — označeno jako divergence current-vs-target níže, nikoli vyřešeno.

### Variants (as observed)

Nepozorováno. Jediné statické vykreslení; žádná osa variant neevidována.

### States

#### idle
Statický červený pás v plné šířce s pledge textem, tak jak byl zachycen. Confirmed —
`_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`.

#### hover
N/A — nejde o interaktivní element (nepozorována role odkazu/tlačítka).

#### focused
N/A — nepozorováno jako zaostřitelný element (žádná CTA/odkaz uvnitř samotného pásu nebyl
zachycen).

#### disabled
N/A.

#### loading
N/A — statický text, žádná asynchronní data.

#### error
N/A — stav chyby se na statický textový pás nevztahuje.

### Events

Žádné události nejsou emitovány. Pás v pozorované evidenci nenese žádnou CTA, odkaz ani
interaktivní prvek.

### Accessibility

`Uncertain` — nejsou k dispozici žádné DOM/nahrávkové důkazy, v souladu s každým jiným
rekonstruovaným current-state COMP v tomto projektu (`COMP0008` atd.). Ze statického screenshotu
nelze potvrdit žádnou ARIA roli, chování klávesnice ani čtečky obrazovky.

- **ARIA role:** `Uncertain` — pravděpodobně dědí nativní sémantiku prostého textového kontejneru
  (např. `<div>`/`<p>`); nepotvrzeno.
- **Keyboard navigation:** N/A — nepozorován žádný interaktivní prvek.
- **Focus management:** N/A.
- **Screen reader:** `Uncertain`.

### Usage Constraints (as observed)

- Použít když: vykreslování stránky detailu příběhu (`WIRE0002`), mezi dvoukolonovou oblastí
  hero/tělo/sidebar a panelem "Related stories".
- Nepoužívat když: `Uncertain` — žádná jiná current-state obrazovka nebyla zachycena s
  přítomností/absencí tohoto pásu; zda se objevuje na každé stránce detailu příběhu nebo jen na
  některých není potvrzeno (existuje pouze jedna instance screenshotu).
- Kardinalita: jeden pás na stránku detailu příběhu (pozorována jediná instance).
- Umístění: plná šířka, samostatně, pod dvoukolonovým layoutem.

### Dependencies (as observed)

- Ostatní COMPs: žádné potvrzené jako skládané sub-elementy — zaznamenáno `inline`, neskládá se z
  žádného jiného rekonstruovaného COMP.
- Data entities: žádné potvrzeně navázané. `WIRE0002` explicitně označuje *"static copy, not
  entity-bound"* — v protikladu k cílovému Hypothesis props `vendorName` výše, který by v případě
  reálné existence byl navázán na pole dodavatele příběhu (`EN0004`/případně kontext `EN0005`). Toto
  je nejjasnější konkrétní divergence datového modelu current-vs-target zaznamenaná pro tento
  element.
- ACL: neevidováno.
- External libraries: neevidováno.

### Composition (as observed)

```
Trust banner (current-state, WIRE0002)
  └─ static text node (no composed sub-elements observed)
```

### Current-state vs. target divergence (record, do not "correct")

- **Naming/identity:** current-state evidence tento element vůbec nikdy nenazvala ani
  nekomponentizovala — objevuje se pouze jako `inline` anotace v tabulce Components-Used
  `WIRE0002` ("Trust banner"). Kanonická knihovna jej povyšuje na first-class Block (`PledgeStrip`)
  s vlastním adresářem, stories a contract souborem. Tento dokument je prvním místem, kde pro něj na
  current-state straně existuje `doc_id` (`COMP0013`) — přiřazen zde konkrétně za účelem sladění
  proti kanonické mapovací tabulce (`DESIGN-component-index.md` §2), nikoli proto, že by evidence
  current-state reuse samostatně povýšení ospravedlnila (viz "Počet evidencí pro reuse" výše).
- **Jmenování dodavatele:** Hypothesis prop `vendorName` (1. pád, strojově doplnitelný) kanonického
  kontraktu **nemá potvrzený current-state protějšek uvnitř samotného banneru** — pozorovaný banner
  je čistě pledge text bez jména dodavatele; jmenování dodavatele je samostatný element sidebaru na
  current-state stránce. Pokud cílový design zamýšlí sloučit jmenování dodavatele do samotného
  pledge pásu, jde o **rozšíření datového modelu**, nikoli o něco, co current-state UI dělá dnes.
- **Opakování:** current-state opakuje sdělení "100 % dítěti" na nejméně třech místech téže stránky
  (pás v plné šířce; microcopy vedle CTA; odrážka trust listu v těle příběhu) — rámování cílového
  designu (§4.5: *"záruka je namísto toho nesena jedním silným výrokem"*) naznačuje, že redesign
  **konsoliduje** toto opakované sdělení do jediného oddělovače `PledgeStrip` a ruší duplicitu
  microcopy u každé CTA. Jde o vědomé zjednodušení, na které upozorňuje sám designový tým, nikoli o
  emergentní vlastnost dnešního UI.
- **Barevný pás:** current-state používá **červený** pás (`WIRE0002`: "red band"); target jej
  explicitně přerámuje jako řízený tokenem tenanta (`var(--color-brand)`/`var(--color-brand-strong)`),
  s tím, že je *"inspirováno dnešním CZ červeným pásem, přeloženo do barvy tenanta"* (§4.5) — tj.
  target záměrně generalizuje CZ-specifickou červenou na per-tenant barvu brandu, která se pro RO
  tenanta vykreslí odlišně od pozorované CZ červené.
- **Umístění:** current-state umísťuje banner mezi dvoukolonovou oblast a panel "Related stories" —
  strukturálně stejný slot, jaký používá cílová kompozice (před "Další děti"). Tento jeden detail
  umístění je **konzistentní** mezi current-state a target, na rozdíl od výše uvedených divergencí
  obsahu a barvy.

### Open Questions

- Zda jsou pás v plné šířce "Trust banner" a microcopy "100%" vedle CTA pod každou donation CTA
  stejným podkladovým current-state elementem vykresleným dvakrát, nebo dvěma nezávisle vytvořenými
  textovými bloky — nepotvrzeno ze statické evidence (viz Purpose výše).
- Zda se tento banner objevuje na **každé** stránce/stavu detailu příběhu, nebo jen na některých —
  existuje pouze jedna instance screenshotu; žádný screenshot stavu `funded`/`urgent` tohoto
  konkrétního elementu nebyl zachycen pro potvrzení invariantní přítomnosti na current-state straně
  (v protikladu k explicitnímu akceptačnímu kritériu cíle "přítomen ve všech stavech").
- Zda je jméno dodavatele někdy vykreslováno uvnitř tohoto konkrétního pásu na jakékoli
  current-state obrazovce nezachycené v této sadě evidencí — Uncertain, neevidováno ani jedním
  směrem.

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Pás v plné šířce, červený, se statickým pledge textem, jediná instance | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`; `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` §Anatomy, §Components-Used ("Trust banner"), §Evidence |
| Nenavázán na entitu (statický text) | Confirmed | `WIRE0002` tabulka Components-Used: "static copy, not entity-bound" |
| Opakování stejného sdělení jinde na téže obrazovce (microcopy u CTA, odrážka trust listu v těle) | Confirmed | `WIRE0002` §Anatomy |
| Reuse napříč ≥2 potvrzeně vybudovanými obrazovkami | Neevidováno (pouze jedna obrazovka) | viz "Počet evidencí pro reuse" výše |
| Přítomnost ve všech stavech sbírky (live/urgent/funded) na current-state straně | Uncertain — neevidováno | zachycen pouze jeden screenshot/stav |
| Accessibility | Uncertain | nejsou k dispozici žádné DOM/nahrávkové důkazy |
| Kanonické mapování na target (`PledgeStrip`, přiřazení COMP0013) | Confirmed (jako fakt mapování, nikoli jako current-state chování) | `DESIGN-component-index.md` §1 řádek 16, §2; `_ar/evidence/design-system/components.md` §2 mapovací řádek "PledgeStrip" |
