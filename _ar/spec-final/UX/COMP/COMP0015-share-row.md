---
doc_id: COMP0015
title: ShareRow
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0002
  - WIRE0003
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0015 – ShareRow

*(povýšeno ze stavu `inline` — kanonická komponenta @patron/ui: ShareRow)*

---

## Current-state (observed)

> Níže uvedená sekce (až po "Evidence") dokumentuje **současný stav UI Patronusu, jak byl
> zaznamenán na screenshotech živého webu**. Tato komponenta zůstala v původní rekonstrukci WIRE
> ve stavu `inline` (neexistoval pro ni samostatný COMP); zde je povýšena podle
> `DESIGN-component-index.md` řádek 12 / mapování `components.md` §2 ("Share row | inline | icon
> button row ... | **GAP→recon**"). Nic v této sekci nelze číst jako popis cílového design systému
> rebuildu; k tomu viz "Design-system alignment (target)" níže, kde je popsán kontrakt `@patron/ui`
> `ShareRow`.

## Purpose

Kompaktní řádek ikonových odkazů na sociální sítě pro sdílení Příběhu nebo momentu dokončeného
daru. Zaznamenán na dvou nezávisle potvrzených obrazovkách: v postranním panelu detailu Příběhu
(`WIRE0002`, "share row" pod CTA pro trvalý dar / dárkový poukaz) a v hero sekci stránky s úspěšnou
platbou (`WIRE0003`, "social-share icon row"). Obě instance zobrazují tlačítka pouze s ikonami,
bez viditelných textových popisků a bez cílového obsahu chování sdílení (sdílená URL/text)
pozorovatelného ze statické evidence. Opakované použití na ≥2 potvrzeně vybudovaných obrazovkách
je Confirmed, což je základ pro povýšení ze stavu `inline` podle evidenčního pravidla pro COMP
(`tooling/docs/rules-COMP.md`: "Create a COMP only when reuse is observable across two or more
WIRE screens").

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `networks` | `string[]` (identifikátory sítí) | no | Uncertain — není evidováno, zda se používá výchozí/plná sada, nebo sada kurátorovaná pro danou obrazovku | Vykreslovaná sada ikon, v daném pořadí. `WIRE0002` zobrazuje 6: Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger. `WIRE0003` zobrazuje 7: Facebook/X/Instagram/LinkedIn/WhatsApp/**Email**/Messenger. Nesoulad (Email přítomen na `WIRE0003`, chybí na `WIRE0002`) je zaznamenán jako pozorovaný, nikoli sladěný — viz Open Questions. |
| `label` | `string` | Uncertain | — | Žádná z obrazovek nezobrazuje ze statické evidence viditelný popisek typu "Sdílet příběh:"; `WIRE0002`/`WIRE0003` zaznamenávají danou zónu pouze jako "icon button row" / "social-share icon row" s "no visible labels, icon-only buttons" (`WIRE0003` Components Used). Zda existuje mimo obrazovku umístěný / vizuálně skrytý popisek, je Uncertain. |
| `shareTarget` | Uncertain | Uncertain | — | URL/text/identifikátor příběhu skutečně sdílený každým odkazem je v obou zdrojových WIRE explicitně označen jako Uncertain (`WIRE0002` Interactions #: "no share behavior observed beyond icon presence"; `WIRE0003` Data Bindings Open Question: "whether the social-share buttons carry any bound share-target (story slug/URL) is Uncertain"). Zde není nic domýšleno. |

## Variants

- **network-count:** sada 6 ikon (`WIRE0002`, postranní panel detailu Příběhu: Facebook/X/
  Instagram/LinkedIn/WhatsApp/Messenger) | sada 7 ikon (`WIRE0003`, hero úspěšné platby: přidává
  Email). Zda se jedná o jednu komponentu s konfigurovatelnou sadou ikon, nebo o dva nezávisle
  vybudované řádky, které vypadají podobně, je `Uncertain` — přeneseno dál jako Open Question,
  nikoli vyřešeno.

## States

### idle
Statický řádek pouze s ikonami, monochromatické/neutrální vykreslení (žádné potvrzené hover/active
zabarvení nepozorováno). Confirmed — screenshot postranního panelu `WIRE0002`; screenshot hero
sekce `WIRE0003`
(`_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png`).

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — žádné vykreslení stavu disabled nepozorováno; všechny ikony se na obou obrazovkách jeví
jednotně interaktivní.

### loading
N/A — žádné asynchronní chování nepozorováno (ikony odkazují ven na externí cíle sdílení; žádný
stav načítání na stránce nezaznamenán).

### error
N/A — žádný chybový stav nepozorován.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onShareClick` | identifikátor sítě | klik na jeden ikonový odkaz | `WIRE0002`: "no share behavior observed beyond icon presence" (Interactions pro tuto zónu nejsou rozepsány). `WIRE0003` Interactions #3: klik otevře "the respective external share flow (Facebook/X/Instagram/LinkedIn/WhatsApp/Email/Messenger)" — Confirmed jako akce externí navigace, ale sdílený obsah/cíl je Uncertain (viz Props). |

## Accessibility

Obvykle není přímo pozorovatelné ze screenshotů — označeno `Uncertain` podle `rules-COMP.md`.

- **ARIA role:** `Uncertain` — Assumed nativní sémantika odkazu `<a>` pro každou ikonu; nepotvrzeno.
- **Keyboard navigation:** `Uncertain`. `WIRE0003` Accessibility Notes předpokládá (Assumed) pořadí
  tabulátoru "header nav → hero share icons → primary CTA → footer links" podle vizuálního pořadí
  shora dolů, zleva doprava — explicitně označeno jako "Assumed... Not evidenced," nikoli
  pozorovaný fakt.
- **Focus management:** `Uncertain` — v žádném ze zdrojových WIRE není evidence viditelného stylu
  focus-ring na ikonách.
- **Screen reader:** `Uncertain` — zda každá ikona nese přístupný název (např. "Share on Facebook")
  odlišující ji od čistě dekorativní ikony, není ze statického screenshotu v žádném z WIRE
  pozorovatelné.

## Usage Constraints

- Použít když: nabízíme sociální distribuci Příběhu (postranní panel detailu) nebo momentu
  dokončeného daru (stránka úspěšné platby).
- Nepoužívat když: `Uncertain` — ve zdrojových WIRE není zaznamenána žádná evidence záporného
  použití.
- Kardinalita: jedna instance na obrazovku pozorovaná jak v `WIRE0002`, tak v `WIRE0003`
  (neopakuje se v rámci jedné obrazovky).
- Umístění: `WIRE0002` — spodní část přilepeného (sticky) postranního panelu daru, pod CTA pro
  trvalý dar / dárkový poukaz; `WIRE0003` — uvnitř hero sekce úspěšné platby, pod textovými
  odstavci a nad/vedle primárního CTA (přesné pořadí "hero share icons → primary CTA" podle
  předpokladu (Assumption) o pořadí tabulátoru v `WIRE0003` Accessibility Notes).

## Dependencies

- Ostatní COMP: žádné potvrzené jako složené dílčí prvky — glyfy ikon jsou vykreslovány inline
  přímo v rámci layoutu každého zdrojového WIRE; v rekonstrukci současného stavu neexistuje žádný
  samostatný COMP pro glyf ikony.
- Datové entity: žádné potvrzené. Sdílený obsah (slug/URL příběhu, nebo kontext transakce `EN0009`
  daru na `WIRE0003`) není explicitně **potvrzen** jako vázaná data — `WIRE0003` Data Bindings:
  "the generic success page shows no amount/story name" a samotné navázání cíle sdílení označuje
  jako Open Question.
- ACL: nic evidováno.
- Externí knihovny: nic evidováno (externí cíle sdílení — Facebook/X/Instagram/LinkedIn/WhatsApp/
  Email/Messenger — jsou navigační cíle třetích stran, nikoli vestavěné knihovny).

## Composition

```
ShareRow (current-state, both observed instances)
  └─ icon link × N (Facebook / X / Instagram / LinkedIn / WhatsApp / [Email] / Messenger)
       — each icon-only, no visible text label, target/behavior Uncertain beyond
         "opens external share flow" (WIRE0003)
```

## Open Questions

- **Nesoulad sady ikon (6 vs. 7):** instance v postranním panelu `WIRE0002` uvádí 6 sítí (bez
  Email); instance v hero sekci `WIRE0003` uvádí 7 (přidává Email). Zda to odráží jednu
  konfigurovatelnou komponentu, nebo dva odlišné, nezávisle vybudované řádky, je `Uncertain` —
  nevyřešeno pouze evidencí současného stavu.
- **Navázání cíle sdílení:** zda některá instance nese vázanou sdílenou URL/text (např. konkrétní
  `/pribeh/<slug>` daného Příběhu na `WIRE0002`, nebo hodnotu specifickou pro dar na `WIRE0003`),
  je Uncertain v obou zdrojových WIRE — tam je to označeno k dořešení v rámci "UC0006/COPY
  follow-up," zde se to nepředpokládá.
- **Přítomnost viditelného popisku:** zda ikonovému řádku předchází popisek typu "Sdílet příběh:"
  (jak implikuje `label` prop cílového kontraktu), nebo je řádek pouze s ikonami bez přiléhajícího
  textu, je ze samotných statických screenshotů Uncertain (`WIRE0003` explicitně poznamenává "no
  visible labels").
- **Artefakt duplicitního postranního panelu na `WIRE0002`:** `WIRE0002` zaznamenává celý postranní
  panel daru (včetně jeho Share row) jako zdánlivě zdvojený v záznamu celé stránky — nevyřešená
  Open Question (`WIRE0002-Q1`) na úrovni WIRE ohledně toho, zda se jedná o artefakt reflow
  dvousloupcového layoutu, nebo o dva skutečně odlišné bloky. Zde znovu nevyřešeno; přenášeno
  odkazem.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Opakované použití na ≥2 potvrzeně vybudovaných obrazovkách | Confirmed | `WIRE0002` (postranní panel detailu Příběhu) a `WIRE0003` (hero úspěšné platby); oba uvádějí řádek share/social-share ikon v Components Used |
| Sada 6 ikon (detail Příběhu) | Confirmed | `WIRE0002` §Screen Overview / Components Used: "Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger — no share behavior observed beyond icon presence" |
| Sada 7 ikon incl. Email (úspěšná platba) | Confirmed | `WIRE0003` Components Used: "social-share icon row (Facebook, X, Instagram, LinkedIn, WhatsApp, Email, Messenger) ... Confirmed — 7 icons, no visible labels, icon-only buttons"; `_ar/prtsc/screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png` |
| Klik otevře externí flow sdílení | Confirmed | `WIRE0003` Interactions #3 |
| Cíl sdílení / vázaný obsah | Uncertain | `WIRE0003` Data Bindings Open Question; poznámka `WIRE0002` Components Used |
| Přístupnost (role/klávesnice/focus/SR) | Uncertain | v žádném ze zdrojových WIRE není k dispozici evidence z DOM/nahrávky; `WIRE0003` Accessibility Notes označuje pořadí tabulátoru jako "Assumed... Not evidenced" |

---

## Design-system alignment (target)

> **STATE: TARGET — `@patron/ui` `ShareRow` (Block).** Tato sekce popisuje kanonický kontrakt
> komponenty **cílového design systému rebuildu**, podle `DESIGN-component-index.md` řádek 12 a
> `_ar/evidence/design-system/components.md` §1 "ShareRow". Stojí na stejné úrovni autority jako
> `it-zadani` (budoucí/cílový stav), **není** to pravda o současném stavu, a nesmí se zpětně
> promítat do sekce "Current-state (observed)" výše. Podle mapování sladění (`components.md` §2)
> je vztah k tomuto pozorování současného stavu **GAP→recon**: "no reconstructed COMP existed"
> před tímto povýšením — "Canonical `ShareRow` with a `SocialName` set. Reconstruction saw an
> inline icon row (no behavior)."

### Canonical contract summary

Kanonický `ShareRow` je **Block** — kompaktní, monochromatický řádek ikon pro sdílení Příběhu;
glyfy při hoveru přebírají akční barvu aktivního tenanta. Je složen uvnitř přilepeného (sticky)
pravého panelu stránky `StoryDetail` (`SiteHeader` → ... → `DonationBox` → `RailCta` (trvalý dar)
→ `RailCta` (promo, pouze CZ) → **`ShareRow`**), podle `DESIGN-component-index.md` §1 řádek 16
(kompozice StoryDetail). Skládá jeden interní, neexportovaný dílčí prvek:

```
ShareRow (canonical, target)
  └─ SocialGlyph  (internal, _socialIcons.tsx — not independently exported/catalogued)
```

### Props

Všechny props jsou **připravené k zobrazení (display-ready)**; `label` je povinný, `networks` je
volitelný a jako výchozí hodnotu má plnou sadu 7 sítí:

| Prop | Type | Required | Default | Notes |
|---|---|---|---|---|
| `label` | `string` | yes | — | Úvodní popisek (např. "Sdílet příběh:"), podle `ShareRow.contract.md` Anatomy: `Sdílet příběh:  (f) (x) (ig) (in) (wa) (@) (m)`. |
| `networks` | `SocialName[]` | no | plná sada 7 sítí, v pevném pořadí: `facebook, x, instagram, linkedin, whatsapp, email, messenger` | `SocialName` union: `"facebook" \| "x" \| "instagram" \| "linkedin" \| "whatsapp" \| "email" \| "messenger"`. Zadání `networks` vykreslovanou sadu **omezí i přeuspořádá** pouze na zvolené hodnoty. |

Source: `packages/ui/src/components/ShareRow/ShareRow.tsx` (`ShareRowProps` interface,
`DEFAULT_NETWORKS` constant); `ShareRow.contract.md` §Props.

### Variants, sizes, states

- **Variant axis:** výchozí sada (všech 7 sítí, výchozí pořadí) | vlastní sada (prop `networks`
  omezuje/přeuspořádá). Žádná osa velikosti není rozepsána (fixní velikost řádku podle
  `components.md` §1).
- **States:**
  - `default` — monochromatické glyfy, čtou token `color.muted` / textový token (v klidovém stavu
    nejsou zabarveny brandem).
  - `hover` / `focus` — glyf přebírá akční barvu **aktivního tenanta** (`color.action`); focus
    ring čte `color.accent`. Podle `ShareRow.contract.md` §Stavy: "glyf adoptuje barvu tenanta;
    focus ring `color.accent`."

### Token slots

`--space-sm`, `--font-body`, `--color-muted`, `--color-surface`, `--color-border`,
`--color-action`. Podle `DESIGN-tokens.md` §10 jsou všechny spotřebovávány přes `var(--…)` v
kolokovaném `ShareRow.module.css` komponenty — bez hex/px literálů. Source:
`packages/ui/src/components/ShareRow/ShareRow.module.css`;
`_ar/evidence/design-system/components.md` §1 seznam tokenů "ShareRow".

### Accessibility (target)

- Každý odkaz nese **`aria-label` s názvem sítě** (helper `socialLabel(n)` v `_socialIcons.tsx`) —
  např. ekvivalent "Share on Facebook" pro danou síť; samotný glyf je **dekorativní** (bez
  samostatného přístupného názvu na SVG/ikoně).
- Odkazy jsou dostupné z klávesnice (nativní sémantika `<a>`) s **viditelným focus stavem**, který
  čte `color.accent`.
- Kontrast glyfu vůči podkladu je ověřen na **obou tenantech** přes a11y panel Storybooku
  (vynucení `.storybook/preview.tsx` `a11y: { test: "error" }`, podle
  `_ar/evidence/design-system/components.md` §0).
- Source: `ShareRow.contract.md` §Přístupnost ("Každý odkaz má `aria-label` s názvem sítě
  (`socialLabel(n)`); glyf sám je dekorativní... Odkazy klávesnicí dostupné, focus stav viditelný
  (`color.accent`)... Kontrast glyfů... ověřen na obou tématech").

### Tenant (CZ/RO) behaviour

- `ShareRow` je sám o sobě **tématicky neutrální (theme-neutral)** — nepřijímá žádné
  tenant-specifické props; sada sítí je pro jednotlivou instanci upravitelná přes `networks`, nikoli
  podle tenanta.
- Co *je* řízeno tenantem, je **barva glyfu při hover/focus**: přepnutí `data-theme="cz"|"ro"`
  přemapuje `color.action` (a `color.accent` pro focus ring) **beze změny kódu** — podle
  `ShareRow.contract.md` §Acceptance: "Přepnutí tenanta CZ↔RO změní hover barvu glyfů beze změny
  kódu." (CZ `color.action` = `#EC4B34`; RO `color.action` = `#16235A`, podle `DESIGN-tokens.md`
  §3.1.)
- Chování vynechání pro RO (promo `RailCta` na stránce StoryDetail je pouze pro CZ a v RO je
  skryto) se **nevztahuje** na `ShareRow` — je přítomen v kompozici pro oba tenanty; žádný rozdíl
  seznamu sítí podle tenanta není v `components.md` dokumentován.

### Divergences from current-state (flagged, not resolved)

- **Počet a členění sady ikon.** Pozorování současného stavu se na obou obrazovkách, kde se tento
  prvek vyskytuje, rozchází ve dvou neshodných počtech — `WIRE0002` (6, bez Email) vs. `WIRE0003`
  (7, včetně Email). **Výchozí** hodnota kanonického kontraktu je plná sada 7 sítí (přesně odpovídá
  počtu na `WIRE0003`, včetně Email) — to však *není* evidence, že 6-ikonová instance na
  `WIRE0002` je "chybné" nebo částečné vykreslení téže komponenty; může naopak odrážet vlastní
  sadu omezenou přes `networks`, jinou obrazovce-specifickou instanci, nebo prostě nesladěnou
  nekonzistenci současného stavu. Zaznamenáno jako divergence, nikoli tiše vyřešeno v žádném
  směru.
- **Viditelný popisek (`label`).** Kanonický kontrakt dělá z `label` **povinnou** prop s
  viditelným úvodním popiskem (např. "Sdílet příběh:") podle jejího diagramu Anatomy. Oba WIRE
  současného stavu zaznamenávají ikonový řádek jako **pouze ikony, bez viditelného popisku**
  (`WIRE0003`: "no visible labels, icon-only buttons"). Jde o skutečný rozdíl mezi současným a
  cílovým stavem v prezentaci — zda živé vykreslení popisek skutečně vynechává, nebo popisek
  existuje, ale nebyl na zachycených screenshotech evidován/čitelný, je `Uncertain`, nikoli
  tvrzeno jako potvrzený rozpor.
- **Chování barvy podle tenanta při hover/focus.** Kanonický kontrakt specifikuje explicitní,
  testovanou změnu barvy při hover/focus (glyf → `color.action`, focus ring → `color.accent`). Oba
  WIRE současného stavu označují hover/focus jako `Uncertain — not observable from static
  evidence`; neexistuje žádný potvrzený rozpor, pouze evidenční mezera na straně současného stavu.
- **Vázaný obsah cíle sdílení.** Kanonický kontrakt vůbec nerozepisuje prop `shareTarget`/URL (jeho
  `ShareRowProps` obsahuje pouze `label` + `networks`) — což implikuje, že skutečnou sdílenou
  URL/obsah skládá/obsluhuje konzument (např. stránka `StoryDetail`), nikoli samotný `ShareRow`.
  To je v souladu s Open Question současného stavu ohledně toho, co každý ikonový odkaz na
  současném webu skutečně sdílí, ale tuto otázku neřeší.

### Source references

`DESIGN-component-index.md` řádek 12 (Index table) a §2 (přiřazení doc_id: "ShareRow → COMP0015");
plný katalogový záznam `_ar/evidence/design-system/components.md` §1 "ShareRow" a mapovací řádek §2
"ShareRow" ("GAP→recon... Canonical ShareRow with a SocialName set. Reconstruction saw an inline
icon row (no behavior)."); hodnoty/názvy tokenů `DESIGN-tokens.md` §3.1, §5, §10. Package source:
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/ShareRow/`
(`ShareRow.tsx`, `ShareRow.module.css`, `ShareRow.contract.md`, `_socialIcons.tsx`,
`ShareRow.stories.tsx`, `index.ts`).
