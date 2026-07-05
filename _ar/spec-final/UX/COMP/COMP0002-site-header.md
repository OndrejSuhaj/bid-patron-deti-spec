---
doc_id: COMP0002
title: SiteHeader
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
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
  - DESIGN-tokens
---

# COMP0002 – SiteHeader

*(rekonstruováno jako Global Site Header / GlobalHeader; kanonická komponenta `@patron/ui`: **SiteHeader**)*

> Tento dokument porovnává rekonstrukci **současného stavu (observed)** s **cílovým** design systémem
> `bid-patron-deti`. Obě roviny jsou striktně oddělené podle pravidla current-vs-target z projektové
> konstituce: sekce observed níže není přepisována směrem k cíli a cílová sekce není považována za
> důkaz o tom, jak se současný Patronus chová.

---

## Current-state (observed)

### Účel

Trvale zobrazená horní navigační lišta přítomná prakticky na každé obrazovce Patronusu: brand lockup,
primární navigační odkazy, CTA "Požádat o pomoc" a vstupní bod autentizace "Můj účet". Jde o sdílené
chrome identicky popsané v nejméně 19 z 22 zpracovaných WIRE dokumentů
(`_ar/spec-draft/WIRE-synthesis-report.md` §6, "Global header nav ... present as chrome on
essentially every screen"). Cíle navigace samotné vlastní IA (`IA-patronus.md`); tato COMP vlastní
pouze vizuální/interakční shell headeru.

### Props / Vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `isAuthenticated` | `boolean` | ne | `false` | Ovlivňuje cílovou destinaci odkazu `Můj účet` (vlastní účet vs. přihlášení), vlastněno IA/UC, zde se neopakuje. |
| `activeNavItem` | `string` | ne | `none` | Který z navigačních odkazů (pokud vůbec) je vizuálně označen jako aktivní; nepotvrzeno jako implementované v žádném zachyceném stavu (Uncertain). |

### Varianty

- **context:** public (nav: "Jak to funguje", "Blog", "O nás", "Požádat o pomoc", "Můj účet" —
  Confirmed na `WIRE0001`, `WIRE0006`–`WIRE0013`, `WIRE0015`, `WIRE0019`, `WIRE0024`, `WIRE0025`) |
  authenticated-account (přidává prvek účtového menu za "Můj účet" — Probable,
  `WIRE0014`, `WIRE0021`, `WIRE0023`; přesný obsah menu není evidován)

### Stavy

#### idle
Bílé pozadí, vlevo zarovnaný wordmark "patron dětí" + slogan, centrované navigační odkazy, vpravo
zarovnané červené tlačítko "Požádat o pomoc" + textový odkaz "Můj účet" s ikonou postavy. Confirmed
na každé obrazovce, která tento stav zmiňuje, např. `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`.

#### hover
`Uncertain — nelze pozorovat ze statických podkladů.`

#### focused
`Uncertain — nelze pozorovat ze statických podkladů.`

#### disabled
N/A — header nemá stav disabled.

#### loading
N/A — statické chrome, není vázáno na žádnou asynchronní operaci v podkladech.

#### error
N/A — header sám o sobě nevlastní žádné zobrazení chyby.

### Události

| Událost | Payload | Trigger | Poznámky |
|---|---|---|---|
| `onNavigate` | cílová route | klik na jakýkoli navigační odkaz/CTA/logo | Cíle jsou vlastněny IA; tato COMP pouze emituje interakci, nikoli destinaci. |

### Přístupnost

- **ARIA role:** `Uncertain` — Assumed nativní landmark sémantika `<header>`/`<nav>`; nepotvrzeno z DOM podkladů.
- **Navigace klávesnicí:** `Uncertain` — nelze pozorovat ze statických screenshotů.
- **Správa fokusu:** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain` — předpokládá se, že ohlášení navigačního odkazu odpovídá viditelnému textu popisku; nepotvrzeno.

### Omezení použití

- Použít když: renderování horní části jakékoli obrazovky postavené na Patronusu (veřejné i autentizované).
- Nepoužívat když: renderování externích/vendor ploch (Comgate, Revolut 3DS — explicitně mimo rozsah
  WIRE/COMP podle `WIRE-screen-coverage.md` "Excluded / platform surfaces").
- Kardinalita: přesně jeden na obrazovku, na nejvyšší pozici.
- Umístění: úroveň stránky, nad všemi ostatními obsahovými zónami.

### Závislosti

- Jiné COMP: žádné (v aktuálních podkladech nekompaduje žádné dílčí COMP — prvek "Požádat o pomoc"
  vizuálně připomíná `COMP0001` Primary Button, je ale menší/navigačně vázaný; není potvrzeno jako
  identický, ponecháno jako otevřená otázka, nikoli tvrzeno jako kompozice).
- Datové entity: žádné přímo; `isAuthenticated` odráží stav session, nikoli atribut entity.
- ACL: žádné evidováno — nebyl pozorován žádný role-gated navigační prvek odlišný od základní sady.
- Externí knihovny: žádné evidováno.

### Kompozice

Leaf-level chrome komponenta; žádná potvrzená kompozice dílčích COMP (viz poznámka u Závislostí
k navigačnímu tlačítku "Požádat o pomoc").

### Příklady

```
GlobalHeader isAuthenticated={false} />   // WIRE0001, WIRE0006–WIRE0013 (public/anonymous)
GlobalHeader isAuthenticated={true} />    // WIRE0014, WIRE0021, WIRE0023 (account screens, Probable)
```

### Otevřené otázky

- Zda je tlačítko "Požádat o pomoc" v headeru totožná znovupoužitelná komponenta jako `COMP0001` Primary
  Button (menší/navigačně stylovaná) nebo samostatné, navigačně vázané tlačítko — nevyřešeno ze
  statických podkladů.
- Zda autentizovaný stav headeru zobrazuje dropdown/menu za "Můj účet" — žádný zachycený stav tuto
  interakci nezobrazuje; `WIRE0014`/`WIRE0021`/`WIRE0023` předpokládají její přítomnost pouze analogicky.

### Evidence

| Oblast tvrzení | Jistota | Podklad |
|---|---|---|
| Znovupoužití napříč ≥2 obrazovkami | Confirmed | 19+ WIRE dokumentů cituje identický vzor headeru; `WIRE-synthesis-report.md` §6 |
| Vizuální stav idle (public context) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`, `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` |
| Varianta autentizovaného kontextu | Probable | odvozeno z jednoho screenshotu `_ar/spec-draft/WIRE/WIRE0014_AccountSettingsProfile.md`; neexistuje dedikovaný zachycený stav autentizovaného headeru |
| Přístupnost | Uncertain | nejsou k dispozici žádné DOM/nahrávkové podklady |

---

## Design-system alignment (target — @patron/ui + @patron/tokens)

> **STATE: TARGET.** Vše níže popisuje kanonickou Block komponentu `@patron/ui` **`SiteHeader`**
> (rebuild knihovna, `packages/ui/src/components/SiteHeader/`) podle
> `_ar/spec-draft/DESIGN-component-index.md` řádek 14 a `_ar/evidence/design-system/components.md`
> §1 "SiteHeader — `components/SiteHeader/`". **Nejde** o důkaz současného stavu a nesmí být čteno
> jako tvrzení o tom, jak se pozorovaný header Patronusu chová dnes — viz sekci "Current-state
> (observed)" výše. Kde se obě roviny liší (a liší se podstatně — viz poznámky ke sladění na konci
> každé podsekce), je rozdíl zaznamenán, nikoli vyřešen.

### Shrnutí kontraktu

Kanonický `SiteHeader` je storefront Block: brandmark, hlavní navigace, vstupní bod přihlášení a CTA
"Ask for help", který se při šířce viewportu ≤720px sbaluje do hamburger menu
(`_ar/evidence/design-system/components.md` §1; `DESIGN-component-index.md` řádek 14).

### Props

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `navItems` | `string[]` | — | — | Popisky odkazů hlavní navigace; řízeno props podle tenantu/lokalizace (žádný hardcoded text navigace). |
| `loginLabel` | `string` | — | — | Popisek pro vstupní bod přihlášení/účtu. |
| `applyLabel` | `string` | — | — | Popisek pro CTA "Ask for help" (cílová obdoba pozorovaného tlačítka "Požádat o pomoc"). |

Exportovaný typ: `SiteHeaderProps`.

**Poznámka ke sladění:** pozorované props `isAuthenticated` a `activeNavItem` nemají **žádnou**
kanonickou obdobu — `SiteHeaderProps` nenese žádný příznak stavu autentizace ani aktivní položky.
Kanonický kontrakt je pouze prezentační/obsahově řízený; chování závislé na session (vlastní účet vs.
destinace přihlášení) není v cílové ploše props modelováno podle aktuálních podkladů. Označeno jako
otevřená mezera ve sladění, nikoli tiše zmapováno.

### Varianty / velikosti

- **desktop** — plný navigační řádek, všechny `navItems` viditelné v řadě.
- **mobile** (≤720px) — navigace se sbaluje do hamburger menu; přihlášení se stává pouze ikonou.

Neexistuje prop/osa `size` (na rozdíl od `size: md|lg` u `Button`); jedinou variantní osou je
desktop/mobile responzivní sbalení, které je řízeno breakpointem, nikoli prop.

### Stavy

- **default** — desktop, navigace plně viditelná.
- **menu closed** / **menu open** — mobilní přepínač hamburger menu, exponovaný přes `aria-expanded`.

Pro samotný shell headeru nejsou katalogizovány samostatné stavy hover/focus/disabled/loading/error
(jednotlivé komponaované dílčí prvky — `Button`, navigační odkazy — nesou vlastní interakční stavy
podle svých vlastních kontraktů, zde se neopakují podle cross-layer discipline).

### Token sloty

Podle `components.md` §1 a `DESIGN-component-index.md` řádek 14:

`var(--space-lg)`, `var(--space-md)`, `var(--space-sm)`, `var(--space-xs)`, `var(--color-border)`,
`var(--color-muted)`, `var(--color-text)`, `var(--color-action)`, `var(--color-surface)`,
`var(--shadow-card)`, `var(--font-body)`.

Všechny hodnoty se rozřeší tenant-bound tam, kde je podkladový slot tenant-bound (`color.*`, `shadow.*`
podle `DESIGN-tokens.md` §2) a shared tam, kde je slot shared (`space.*`); samotný header nepřijímá
žádný prop pro tenant — re-skinning probíhá čistě přes remap tokenů `data-theme`, podle modelu
multi-tenant theming (`DESIGN-tokens.md` §11).

### Kompozice

```
SiteHeader
  ├─ Brandmark        (uvnitř domovského `<a>`)
  ├─ Button (ghost)   (desktop CTA — obdoba "Ask for help" / "Požádat o pomoc")
  └─ Icon (name="user")
```

Kanonické doc_ids: `Brandmark` = COMP0019, `Button` = COMP0001, `Icon` = COMP0020 (podle
`DESIGN-component-index.md` §2). Storybook stories: `Hlavička`, `Mobil`.

**Poznámka ke sladění:** současný stav (observed) COMP explicitně ponechal kompozici jako "Otevřenou
otázku" — zda je tlačítko "Požádat o pomoc" znovupoužitým `COMP0001` Primary Button, nebo samostatným,
navigačně vázaným tlačítkem, nebylo vyřešeno ze statických podkladů. Cílový kanonický stav *skutečně*
komponuje `Button` (varianta ghost) pro toto CTA. Tím se otevřená otázka řeší pouze pro **cíl**;
nejde o důkaz, že současný header Patronusu komponuje `COMP0001` dnes.

### Přístupnost (target)

- **Přepínač mobilního menu** exponuje `aria-expanded` (stav otevření/zavření hamburger menu).
- Přístupnost je **vynucována nástroji**, nikoli pouze dokumentována: `.storybook/main.ts` načítá
  `@storybook/addon-a11y` a `preview.tsx` nastavuje `a11y: { test: "error" }` napříč celou knihovnou
  (`_ar/evidence/design-system/components.md`, úvodní poznámky).
- Toto je přímý kontrast se sekcí current-state (observed) výše, kde je ARIA role, navigace
  klávesnicí, správa fokusu i chování čtečky obrazovky `Uncertain` (pro živý header Patronusu nejsou
  k dispozici žádné DOM/nahrávkové podklady).

### Chování podle tenantu (CZ/RO)

- Na samotném `SiteHeader` neexistují žádné tenant-specifické **props** — položky/popisky navigace
  jsou řízeny props podle tenantu/lokalizace ze strany konzumenta, nikoli přepínány interně.
- Komponovaný `Brandmark` (COMP0019) *je* tenant-driven: CZ renderuje kompozici in-repo ikonové
  dlaždice + wordmarku; RO renderuje živé logo KidsHero (hotlinkované, žádný binární soubor v repu).
  Obě tenant značky koexistují v DOM; CSS `data-theme` vybírá, která je viditelná
  (`DESIGN-tokens.md` §11, `DESIGN-component-index.md` řádek 4).
- Token sloty barva/stín/rozestup se rozřeší podle sad hodnot `data-theme="cz"` vs. `data-theme="ro"`
  v `DESIGN-tokens.md` §3–§7; kód komponenty headeru se podle tenantu nevětví.
- **MD (Moldavsko)**, přítomné v podkladech current-state jako obsluhovaná lokalizace, **nemá**
  v cílovém design systému žádné implementované tenant téma — dnes existují pouze `cz`/`ro`
  (`DESIGN-tokens.md` §11). Toto je mezera cílového systému vůči rozsahu current-state, zde
  zaznamenaná, nikoli vyřešená.

### Klasifikace sladění

Podle mapovací tabulky `_ar/evidence/design-system/components.md` §2 a `DESIGN-component-index.md`
§2: **RENAME** — stejný koncept (trvalé navigační chrome v horní části stránky), jiný název
(pozorovaný `GlobalHeader`/"Global Site Header" → kanonický `SiteHeader`), s podstatně rozšířeným
cílovým kontraktem (explicitní responzivní hamburger varianta, stav `aria-expanded`, vynucené a11y
testování) vůči tomu, co bylo možné stanovit ze statických screenshotových podkladů pro současný
systém.
