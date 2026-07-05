---
doc_id: COMP0010
title: DonationBox
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/DonationBox/
references:
  - WIRE0002
  - EN0004
  - EN0009
  - EN0010
  - EN0013
  - UC0005
  - UC0009
  - UC0011
  - BR-CampaignStoryLifecycle
  - BR-PaymentAndMoneyIntegrity
  - BR-RecurringDonationPolicy
  - BR-VoucherPolicy
  - COMP0001
  - COMP0006
  - COMP0016
  - COMP0017
  - COMP0021
  - COMP0020
  - DESIGN-tokens
  - DESIGN-component-index
---

# COMP0010 – DonationBox

> **Poznámka k disciplíně.** Tento dokument povyšuje **kanonickou komponentu `@patron/ui`**
> `DonationBox` (design systém **rebuildu/cílového stavu** `bid-patron-deti`) na COMP dokument, podle
> `DESIGN-component-index.md` řádek 13 a jeho tabulky přiřazení doc_id (§2). Je rozdělen do dvou
> jasně oddělených částí:
>
> - **"Design-system alignment (target)"** — autoritativní kanonická smlouva (props, varianty,
>   stavy, tokeny, přístupnost, chování napříč tenanty), zdrojovaná z
>   `packages/ui/src/components/DonationBox/{DonationBox.tsx, DonationBox.module.css,
>   DonationBox.contract.md}`. Toto je **CÍLOVÝ stav (TARGET)**, nikoli fakt o současném stavu.
> - **"Current-state (observed)"** — kde se tato schopnost **dnes** objevuje na živém webu Patronus,
>   podle `WIRE0002` (doloženo screenshoty), a jak se odchyluje od cílové smlouvy.
>
> Podle pravidla projektové konstituce pro současný stav vs. cílový stav se tyto dvě části **neslučují**.
> Kanonická smlouva se nepoužívá k "opravě" pozorování současného stavu a pozorování současného stavu
> se nepoužívá k oslabení kanonické smlouvy. Kde se rozcházejí, jsou zaznamenány obě strany (viz
> "Current-vs-target divergence" níže).

---

## Design-system alignment (target)

> Zdroj: `packages/ui/src/components/DonationBox/DonationBox.tsx`,
> `DonationBox.module.css`, `DonationBox.contract.md`; katalogizováno v
> `_ar/evidence/design-system/components.md` ("Blocks → DonationBox") a
> `_ar/spec-draft/DESIGN-component-index.md` řádek 13. Vrstva: **Block**. Storybook příběhy: `Probíhá`,
> `Naléhavé`, `DoplatitZbytek`, `Vybráno`.

### Účel (target)

Primární konverzní blok kompozice stránky detailu příběhu (`StoryDetail`, sticky pravý sloupec).
Ukazuje, kolik chybí a do kdy, a umožňuje dárci přispět jediným rozhodnutím.
Ve stavu `funded` formulář zmizí a blok se změní na poděkování s dalším krokem
(doručení / potvrzení patrona). **Rozsah smlouvy explicitně končí u `onDonate(amount)`** —
donační modal (e-mail, souhlasy, mock platba) je v samotné smlouvě označen jako samostatný budoucí
blok ("Mimo scope"), nikoli součást této komponenty.

### Props / Inputs (cílová smlouva)

Zdroj: exportované `DonationBoxProps` (`DonationBox.tsx`).

| Název | Typ | Povinný | Výchozí | Popis |
|---|---|---|---|---|
| `state` | `CollectionState` (`"live" \| "urgent" \| "funded"`) | ne | `"live"` | Určuje režim `TimeLeftPill` a nahrazuje celý formulář poděkováním ve stavu funded. |
| `timeLeftLabel` | `string` | ano | — | Zobrazitelný text zbývajícího času ("Zbývá měsíc" / "Zbývají 3 dny"); předáván přímo do `TimeLeftPill` (`COMP0017`). |
| `missingAmount` | `string` | ano | — | Zobrazitelný nadpis chybějící částky (např. "329 000 Kč"). Komponenta neformátuje měnu. |
| `missingCaption` | `string` | ano | — | Popisek pod `missingAmount` (např. "ještě chybí"). |
| `goalCaption` | `string` | ano | — | Popisek před hodnotou cíle (např. "cíl"). |
| `goalAmount` | `string` | ano | — | Zobrazitelná cílová částka (např. "439 000 Kč"). |
| `progressPct` | `number` (0–100) | ano | — | Předáváno do `ProgressBar` (`COMP0016`); ořezání/zaokrouhlení je odpovědností `ProgressBar`, nikoli této komponenty. |
| `donorsNote` | `string` | ne | — | Volitelná poznámka pod ukazatelem (např. "přispělo 41 dárců"). |
| `presets` | `DonationPreset[]` (`{label: string, amount: number}`) | ano | — | Pevné přednastavené "kulaté" částky (smlouva: např. 500/1000/2000), zobrazené jako mřížka 2×2 volitelných tlačítek. |
| `defaultPresetIndex` | `number` | ne | `1` | Index do `presets` vybraný při vykreslení (určuje počáteční `aria-pressed`). |
| `customLabel` | `string` | ano | — | Popisek tlačítka přepínače "Jiná" (vlastní částka). |
| `currencyLabel` | `string` | ano | — | Přípona měny zobrazená vedle pole pro vlastní částku (např. "Kč"). |
| `customInputLabel` | `string` | ano | — | `aria-label` pro skupinu tlačítek s přednastavenými částkami (`role="group"`) i pro pole vlastní číselné částky. |
| `restFill` | `{label: string, amount: number}` | ne | — | Rychlé doplnění ("Doplatit zbývajících 900") zobrazené pouze pod panelem vlastní částky; kliknutí vyplní pole vlastní částky hodnotou `restFill.amount` a **nepřesouvá** fokus. |
| `ctaLabel` | `string` | ano | — | Popisek primárního CTA (např. "Přispět"). |
| `voucherLabel` | `string` | ne | — | Popisek odkazu na uplatnění poukazu pod CTA. **Pouze CZ na úrovni tenanta** — řízeno konzumentem (pro RO se prop vynechá), nikoli skryto přes CSS. |
| `successTitle` | `string` | ne | — | Nadpis zobrazený ve stavu `funded`. |
| `successMessage` | `ReactNode` | ne | — | Text zobrazený ve stavu `funded`; přijímá formátovaný obsah (např. tučně zvýrazněný název dodavatele). |
| `onDonate` | `(amount: number) => void` | ne | — | Vyvoláno kliknutím na primární CTA s **aktuálně vybranou** částkou (hodnota přednastavené částky, nebo zpracovaná hodnota vlastního pole, je-li otevřeno "Jiná"). Hranice smlouvy — cokoli za tímto voláním již není záležitostí této komponenty. |

Exportované typy: `DonationBoxProps`, `DonationPreset`, `CollectionState`.

### Varianty (target)

- **state = live** — plný formulář, klidný/neutrální `TimeLeftPill`.
- **state = urgent** — `TimeLeftPill` se přepne na plný výstražný odznak (`color.urgent` / `color.onUrgent`) s mírným pulzováním; formulář je jinak identický jako u `live`.
- **state = funded** — celý formulář (hodnoty, přednastavené částky, pole vlastní částky, CTA, odkaz na poukaz) je nahrazen blokem úspěchu: ikona zaškrtnutí na dlaždici `color.success`, `successTitle`, `successMessage`.

Žádná osa `size`; komponenta má jednu velikost (vyplňuje šířku svého sloupce v rail).

### Stavy (cílová smlouva)

#### idle / výchozí
Vykresluje se s přednastavenou částkou na `defaultPresetIndex` označenou `aria-pressed="true"`
(zvýrazněnou obrysem + jemným tónováním v `color.action`).

#### výběr přednastavené částky
Kliknutí na tlačítko přednastavené částky (nebo přepínač "Jiná") aktualizuje `aria-pressed` ve skupině
tlačítek; v jednu chvíli je stisknuté pouze jedno z `presets.length + 1` tlačítek ("Jiná" se počítá
jako jedno). Toto je lokální stav komponenty (`useState`), který se nepropaguje ven jinak než přes
výslednou částku v `onDonate`.

#### otevřené "Jiná" (vlastní částka)
Výběr přepínače vlastní částky odhalí číselné pole `Input` (`COMP0021`, `type="number"`, `min={1}`) s
příponou měny, a — pouze pokud je zadán `restFill` — tlačítko rychlého doplnění textu pod ním.

#### hover / focus
Tlačítka přednastavených částek/přepínače a CTA používají sdílený viditelný focus ring
(`color.accent`); všechny akce jsou ovladatelné klávesnicí (nativní elementy `<button>`).

#### omezený pohyb (reduced motion)
Animace pulzování urgentního `TimeLeftPill` je vypnuta při `prefers-reduced-motion` (zděděno
z `TimeLeftPill`, `COMP0017`).

#### disabled / loading / error
`N/A` v kanonické smlouvě — nemodelováno. V `DonationBox.tsx` neexistuje žádné vykreslení pro disabled,
loading ani error; neúspěšné/probíhající volání `onDonate` je zcela záležitostí volajícího, mimo
rozsah této komponenty.

### Události (target)

| Event | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onDonate` | `amount: number` | kliknutí na primární CTA (`Button`, primary/block, ikona `give`) | Amount = `amount` vybrané přednastavené částky, nebo `Number(customValue) \|\| 0`, je-li otevřeno "Jiná". Uvnitř komponenty se neprovádí žádná validace nad rámec konverze `Number()`. |

Žádné jiné události nejsou vyvolávány; výběr přednastavené částky a přepínání "Jiná" je pouze
interní stav, není vystaven jako callback.

### Přístupnost (cílová smlouva)

- **Role ARIA:** skupina tlačítek přednastavených částek/"Jiná" je obalena `role="group"` s `aria-label={customInputLabel}` (smlouva explicitně preferuje toto řešení před `<fieldset>` "bez jeho stylové zátěže" — lehčí než fieldset, bez jeho stylové zátěže).
- **Stav výběru:** každé tlačítko přednastavené částky/přepínače nese `aria-pressed` odrážející výběr.
- **Vlastní pole:** nese `aria-label={customInputLabel}`; viditelný focus je zachován.
- **Ukazatel průběhu:** `role="progressbar"` + `aria-valuenow/min/max`, delegováno na a vlastněno komponentou `ProgressBar` (`COMP0016`), zde znovu nedeklarováno.
- **Klávesnice:** všechny akce (výběr přednastavené částky, přepínač "Jiná", rychlé doplnění, CTA) jsou nativní elementy `<button>` — plně ovladatelné klávesnicí bez vlastního zpracování kláves.
- **Akceptační kritéria (z `DonationBox.contract.md`):** přepnutí tenanta CZ↔RO přeskinuje bez zásahu do kódu (včetně barev stavů urgent/success); `state="urgent"` přepne časový odznak na výstražný odznak a `prefers-reduced-motion` vypne jeho pulzování; `state="funded"` skryje celý formulář a zobrazí poděkování; rychlé doplnění předvyplní pole "Jiná" a fokus zůstává v poli; `onDonate` obdrží přesně vybranou částku (přednastavenou nebo vlastní).

### Sloty tokenů (target)

Podle `DonationBox.module.css`, ověřeno proti `_ar/spec-draft/DESIGN-tokens.md` §10 pojmenování
vlastních CSS proměnných:

- **Plocha / struktura:** `var(--color-surface)`, `var(--color-border)`, `var(--radius-card)`, `var(--shadow-card)`.
- **Rozestupy:** `var(--space-xs)`, `var(--space-sm)`, `var(--space-md)`, `var(--space-lg)`.
- **Typografie:** `var(--font-body)`, `var(--font-display)`, `var(--font-display-weight)`, `var(--font-display-tracking)`.
- **Barva — hodnoty/text:** `var(--color-brand-strong)` (nadpis chybějící částky), `var(--color-muted)`, `var(--color-text)`.
- **Barva — tlačítka přednastavených částek:** `var(--color-text)`, `var(--color-border)` (idle); `var(--color-action)` + `color-mix(in srgb, var(--color-action) 8%, var(--color-surface))` (stisknuté); `var(--color-accent)` (obrys viditelného focusu).
- **Barva — vlastní částka/rychlé doplnění:** `var(--color-muted)` (přípona měny), `var(--color-action)` (odkaz rychlého doplnění).
- **Barva — blok funded/success:** `var(--color-success)` (pozadí dlaždice ikony), `var(--color-on-success)` (ikona), `var(--radius-icon)` (tvar dlaždice ikony — kruh CZ / squircle RO), `var(--color-text)` / `var(--color-muted)` (text úspěchu).
- **Tvar prvků:** `var(--radius-control)` (poloměr přednastavené částky/vlastního pole, zděděný komponentami `Input`/tlačítky přednastavených částek).

Všechny hodnoty se rozlišují podle tenanta přes `[data-theme="cz"|"ro"]` — komponenta samotná nikdy
nečte hexadecimální nebo px literál pro hodnotu vlastněnou tokenem (podle
`_ar/evidence/design-system/design-canon.md` principu 2, "komponenty znají pouze sloty, nikdy
hodnoty").

### Chování napříč tenanty (target)

- **Strukturálně neutrální vůči tématu** — v samotném `DonationBox.tsx` není žádné větvení CZ/RO;
  všechny rozdíly v barvě/poloměru/stínu/písmu se řeší přes hodnoty tokenů se scope `[data-theme]`
  (`DESIGN-tokens.md` §3, §6, §7), v souladu s jednoosým modelem theming přes sloty používaným
  knihovnou.
- **`voucherLabel` je pouze CZ** — podle `DESIGN-component-index.md` řádek 13 a "Domain rules" v
  `components.md`: prop je řízen konzumentem (RO fixture ji jednoduše vynechává), **nikoli** skryt
  přes CSS/`data-theme`. Toto odpovídá sesterské promo variantě `RailCta` (`COMP0014`), která je
  rovněž pouze CZ / řízená konzumentem.
- Podle `_fixtures.tsx` (kompozice stránky `StoryDetail`) RO donační rail zcela vynechává cestu s
  poukazem; žádný tenant MD (Moldova) v kanonické knihovně dnes neexistuje (`DESIGN-tokens.md` §11 —
  MD je pouze budoucí, neimplementováno).

### Kompozice (target)

```
DonationBox
  ├─ TimeLeftPill (COMP0017)          — timeLeftLabel, urgent = state==="urgent"
  ├─ blok hodnot (missingAmount / missingCaption / goalCaption / goalAmount) — inline, ne sub-COMP
  ├─ ProgressBar (COMP0016)           — progressPct
  ├─ donorsNote (volitelné)           — inline text
  ├─ skupina tlačítek přednastavených částek (role="group") — presets[] + přepínač "Jiná" — inline tlačítka, ne COMP0001 Button
  ├─ Input (COMP0021)                 — pouze pokud je otevřeno "Jiná"; type="number", min=1
  ├─ tlačítko rychlého doplnění restFill — inline, podmíněno prop restFill
  ├─ Button (COMP0001), variant=primary, block — iconBefore = Icon(name="give") (COMP0020)
  └─ odkaz voucherLabel (volitelný, pouze CZ) — inline <a>, ne sub-COMP

DonationBox (state="funded")
  ├─ Icon (COMP0020), name="check", na dlaždici color.success
  ├─ successTitle
  └─ successMessage
```

Poznámka: samotná tlačítka přednastavených částek jsou **jednoduché elementy `<button>` stylované
lokálně** (třída `.amt` v `DonationBox.module.css`), nikoli instance `Button`/`COMP0001` — pouze
primární CTA komponuje `Button`. Toto je záměrné rozlišení v zdrojovém kódu, nikoli opomenutí.

### Závislosti (target)

- **Ostatní COMP (kompozice):** `COMP0017` TimeLeftPill, `COMP0016` ProgressBar, `COMP0021` Input,
  `COMP0001` Button (varianta primary/block), `COMP0020` Icon (`check`, `give`).
- **Sesterské cílové Blocks (stejný rail, nekomponované samotným DonationBox):** `COMP0014` RailCta
  (karty pravidelného dárcovství / promo pod boxem), `COMP0015` ShareRow, `COMP0013` PledgeStrip
  (plná šířka, objevuje se v každém stavu `DonationBox` podle kompozice stránky `StoryDetail`).
- **Datové entity (současné-stavové doménové ekvivalenty, pro traceabilitu — nikoli závislost cílové
  vrstvy):** `EN0004` Campaign (hodnoty průběhu/cíle/termínu), `EN0009` Transaction (částka předaná do
  `onDonate` se nakonec dále stává `Transaction.amount`, podle `UC0005` kroku
  10 — vazba na současný stav, viz níže), `EN0010` RecurringTransaction, `EN0013` Voucher.
- **ACL:** v kanonické smlouvě nedoloženo.
- **Externí knihovny:** nedoloženo (pouze `useId`, `useState` z React).

---

## Current-state (observed)

> Zdroj: `WIRE0002_StoryDetailAndDonationModal.md` (rekonstrukce současného stavu doložená
> screenshoty živé stránky detailu příběhu `patrondeti.cz`). **Toto je rekonstrukce SOUČASNÉHO
> STAVU — nikoli cílová smlouva výše.** Podle poznámky `DESIGN-component-index.md` §3/řádek 13 a
> tabulky mapování `_ar/evidence/design-system/components.md` §2 je toto klasifikováno jako
> **GAP→recon (major)** — "jedna z největších mezer" mezi kanonickou knihovnou a rekonstruovaným UX.

### Kde se dnes objevuje

Na živé stránce detailu příběhu **neexistuje jedna rekonstruovaná komponenta**, která by odpovídala
této schopnosti. Tabulka "Components Used" v `WIRE0002` zaznamenává plochu donačního postranního
panelu jako sadu **samostatných inline řádků**, nikoli jeden blok:

- **Blok průběhu** — "Chybí 1 600 Kč" + progress bar + "Zbývá měsíc" / "Cílová částka 1 600 Kč"
  (`inline`, `WIRE0002` Components Used — označeno jako Uncertain, zda sdílí komponentu s vlastními
  hodnotami průběhu `COMP0008` StoryCard; nepotvrzeno jako identické).
- **Pole částky** ("Chci darovat", Kč, předvyplněno `50`) — `inline`, číselné pole.
- **Primární donační CTA** ("Přispět 🤝") — mapováno na **`COMP0001`** (Primary Button), ikona=🤝.
  Toto je jediný podelement současného donačního postranního panelu, který *byl* povýšen na COMP.
- **CTA pro pravidelné dárcovství** ("Chci podporovat rozvoj a vzdělání pravidelně") — `inline`,
  "sekundární/zelené tlačítko"; vizuální identita vs. `COMP0001` zůstává v `WIRE0002` Uncertain.
- **CTA pro poukaz** ("Mám dobrošek") — `inline`, "sekundární/červené tlačítko, ikona lístku"; vstupní
  bod do `UC0009`, cílová obrazovka nezachycena (Uncertain).
- **Řádek sdílení** — `inline`, řádek ikon (Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger).

**Současný stav = donační modal, nikoli tento box.** Klíčové je, že na živém webu primární CTA
("Přispět 🤝") **nevolá** handler `onDonate(amount)` přímo tak, jak to dělá cílová smlouva
`DonationBox`. **Otevírá samostatný overlay** — donační modal "Chystáte se přispět" — který navíc
sbírá e-mail, telefon, jméno/příjmení a dvě zaškrtávací pole souhlasu před předáním platební bráně
(`S-EXT1`, Comgate). Podle `WIRE0002` Interactions #2: "kliknutí na 'Přispět 🤝' (kterákoli instance
v postranním panelu) → otevře se overlay modalu předvyplněný částkou zadanou ve spouštěcím poli
'Chci darovat' ... další: stav modalu `default`." Modal samotný je rekonstruován samostatně (jeho
zaškrtávací pole souhlasu se mapují na `COMP0006`); je **explicitně mimo rozsah** tohoto COMP
dokumentu, přesně zrcadlí vlastní hranici "Mimo scope" cílové smlouvy — ale z jiného důvodu: cíl
odkládá modal jako *nevybudovanou budoucí práci*, zatímco současný stav modalu je *již živý a
zachycený*, jen není součástí plochy pro výběr částky, kterou tento COMP popisuje.

### Pozorované chování v současném stavu (doloženo screenshoty)

- **Duplicitní postranní panel.** Donační postranní panel (průběh + CTA + řádek sdílení) je zachycen
  na celostránkovém screenshotu **dvakrát** — jednou vedle hero fotky, jednou níže vedle textu
  (`WIRE0002` Layout Zones, Open Question WIRE0002-Q1). `WIRE0002` toto zaznamenává jako "neřešeno
  podmínkou ACL/BR — pravděpodobně artefakt šablony/layoutu při přeuspořádání dvou sloupců," nikoli
  jako záměrnou funkci dvou bloků. Cílová smlouva `DonationBox` **nemá koncept duplicitního
  vykreslování** vůbec — tato odchylka může být vysvětlena cílovým modelem jednoho bloku (jeden
  `DonationBox`, umístěný jednou ve sticky rail) namísto zjevného zdvojeného vykreslení v současné
  šabloně, ale toto je `Hypothesis — Not evidenced in current sources`, nikoli potvrzeno.
- **Zadávání částky.** Současný stav zobrazuje číselné pole předvyplněné `50` (Kč) přímo v
  postranním panelu ("Chci darovat"), s **žádnými pozorovanými pevnými tlačítky přednastavených
  částek** — žádná mřížka 2×2 kulatých částek srovnatelná s cílovým prop `presets`. Zda živá
  implementace nabízí přednastavené částky někde jinde, je `Uncertain` — v zachycených screenshotech
  není vidět.
- **Hodnoty průběhu.** "Chybí 1 600 Kč" + progress bar + "Zbývá měsíc" / "Cílová částka 1 600 Kč" je
  vizuálně blízké cílové kompozici blok hodnot + `TimeLeftPill` + `ProgressBar`, ale `WIRE0002`
  explicitně ponechává otázku znovupoužití otevřenou (sdíleno s vnitřním průběhem karty
  `COMP0008`, nebo nezávislé), místo aby tvrdilo identitu.
- **Stav urgent.** Pro tuto obrazovku nebyl zachycen žádný screenshotový důkaz vykreslení
  urgentního/výstražného odznaku textu zbývajícího času; `WIRE0002` zaznamenává jako Confirmed pouze
  stav `default`. Zda živý web má vizuální ošetření urgentního stavu analogické cílovému
  `state="urgent"`, je `Uncertain — not evidenced`.
- **Stav funded.** Nebyl zachycen žádný screenshotový důkaz vykreslení "plně vybráno" / poděkování
  nahrazujícího formulář v postranním panelu. `WIRE0002` States → `empty` tuto mezeru explicitně
  zaznamenává s odkazem na `UC0005` AF2 ("chybějící nebo již plně vybraný Campaign") jako obchodní
  pravidlo, které existuje, bez odpovídajícího zachyceného UI ošetření. `Uncertain — not evidenced`.
- **Zadávání pravidelného dárcovství / poukazu.** Obojí dnes existuje jako **samostatné inline CTA**
  vedle donačního postranního panelu (nikoli podstavy jednoho boxu) — "Chci podporovat ... pravidelně"
  (zelené) a "Mám dobrošek" (červené, ikona lístku). Cílová smlouva nemá podobnou podobu prvku
  `voucherLabel` vykresleného inline stejným způsobem (cíl: jednoduchý textový odkaz pod CTA, nikoli
  červené tlačítko s ikonou lístku) — toto je odchylka vizuální identity, nejen odchylka v
  pojmenování.
- **Přístupnost.** Jednotně `Uncertain` pro současný stav — poznámky k přístupnosti ve `WIRE0002`
  zaznamenávají pořadí tabulace, chování focus-trapu modalu a landmarks jako nepozorované/
  neověřitelné ze statických screenshotů. To je v kontrastu s explicitními rozhodnutími cílové
  smlouvy o `role="group"` / `aria-pressed` / focus ringu (viz "Přístupnost (cílová smlouva)" výše)
  — bohatost přístupnosti v cílové sekci výše se **nesmí** zpětně promítat do implementace
  současného stavu.

### Current-vs-target divergence (zaznamenáno, nevyřešeno)

| Aspekt | Současný stav (pozorovaný, `WIRE0002`) | Cílová smlouva (`DonationBox`, kanonická) | Status |
|---|---|---|---|
| Strukturální model | ~6 samostatných inline řádků/CTA, zdánlivě duplikovaných v layoutu | Jeden blok, 3 stavy (`live`/`urgent`/`funded`) | Odchylka — cíl pravděpodobně vysvětluje/řeší duplikaci současného stavu, ale toto je `Hypothesis`, nepotvrzeno |
| Výběr částky | Jediné číselné pole, předvyplněno `50`, žádné viditelné přednastavené částky | Pevné přednastavené kulaté částky (mřížka 2×2) + přepínač "Jiná" pro vlastní částku | Odchylka — přednastavené částky nejsou doloženy jako aktuálně živé |
| Akce darování | Otevírá samostatný donační modal (e-mail/souhlas/platba) před jakýmkoli odesláním | `onDonate(amount)` — smlouva zde explicitně končí; modal je budoucí/mimo rozsah této komponenty | Obě strany se shodují, že modal je samostatná záležitost, ale z různých důvodů (již živé vs. ještě nevybudované) |
| Pravidelné dárcovství / poukaz | Dvě samostatná, vizuálně nekonzistentní tlačítka CTA (zelené / červené s lístkem) vedle boxu | `voucherLabel` je jednoduchý odkaz pod CTA (prop pouze pro CZ); pravidelné dárcovství žije v sesterském `RailCta` (`COMP0014`), nikoli uvnitř `DonationBox` | Odchylka — vizuální identita těchto dvou cest v současném stavu je Uncertain vs. `COMP0001`; cíl je unifikuje/přemísťuje |
| Vizuální stavy funded / urgent | Nezachyceno na žádném screenshotu | Explicitní prop `state` s vyhrazenými vykresleními | Mezera — existence těchto vykreslení v současném stavu je `Uncertain`, nepotvrzena jako chybějící |
| Přístupnost | `Uncertain` v celém rozsahu (žádný DOM/nahrávkový důkaz) | Explicitní smlouva ARIA group/pressed/focus-ring | Nesrovnatelné — tvrzení o přístupnosti současného stavu se nesmí povyšovat na základě cílové smlouvy |

Tato tabulka divergence zaznamenává fakta již stanovená ve `WIRE0002` a
`_ar/evidence/design-system/components.md` §2/§4 (mapování "DonationBox ... GAP→recon (major)" a
poznámka o prioritě sjednocení); nezavádí nová tvrzení.

---

## Usage Constraints

- **Target:** použít při vykreslování primární plochy pro příspěvek uvnitř sticky pravého sloupce
  stránky `StoryDetail`; nepoužívat pro donační modal (e-mail/souhlas/platba) ani pro mobilní sticky
  lištu CTA (samostatná kompozice na úrovni stránky podle poznámek ke kompozici `StoryDetail` v
  `DESIGN-component-index.md` řádek 15). Kardinalita: jedna na stránku detailu příběhu. Umístění:
  pouze sloupec rail, nikoli samostatně/vloženo v seznamech.
- **Current-state:** není doložena žádná jednotná hranice komponenty; ekvivalentní plocha dnes je
  sada inline řádků v postranní zóně `WIRE0002`, vyskytujících se dvakrát na stránce (viz tabulka
  divergence). Jakýkoli rebuild vycházející z tohoto COMP dokumentu by měl "duplicitní postranní
  panel" v současném stavu považovat za otevřenou otázku (`WIRE0002-Q1`), nikoli za požadavek na
  replikaci.

---

## Evidence

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Cílová smlouva props/varianty/stavy/tokeny/a11y | Confirmed | `packages/ui/src/components/DonationBox/{DonationBox.tsx, DonationBox.module.css, DonationBox.contract.md}`; `_ar/evidence/design-system/components.md` (Blocks → DonationBox); `_ar/spec-draft/DESIGN-component-index.md` řádek 13 |
| Názvy slotů cílových tokenů ověřeny proti kanonickému pojmenování CSS proměnných | Confirmed | `_ar/spec-draft/DESIGN-tokens.md` §10 |
| Současný donační postranní panel jako ~6 samostatných inline řádků, žádný jeden blok | Confirmed | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` Layout Zones, Components Used |
| Akce darování v současném stavu otevírá samostatný donační modal | Confirmed | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` Interactions #2–#3 |
| Duplicitní postranní panel jako artefakt layoutu, nikoli záměrná funkce | Uncertain (zaznamenáno jako otevřená otázka, nevyřešeno) | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` Open Questions WIRE0002-Q1; Conditional Visibility |
| Klasifikace jako "GAP→recon (major)" / největší mezera mezi kanonickým a rekonstruovaným UX | Confirmed | `_ar/evidence/design-system/components.md` §2 tabulka mapování, §3 poznámka o prioritě sjednocení |
| Existence vizuálních stavů urgent/funded v současném stavu | Uncertain — not evidenced | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` States (empty/loading/error), Open Questions |
| Přístupnost v současném stavu | Uncertain — no DOM/recording evidence | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` Accessibility Notes |
