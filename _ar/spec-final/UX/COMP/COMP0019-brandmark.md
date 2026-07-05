---
doc_id: COMP0019
title: Brandmark
layer: COMP
spec_type: component
modules: []
status: imported
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Brandmark/
references:
  - COMP0002
  - COMP0003
  - COMP0020
  - COMP0001
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0006
  - WIRE0007
  - WIRE0009
  - WIRE0010
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0019
  - WIRE0020
  - WIRE0021
  - WIRE0024
  - WIRE0025
---

# COMP0019 – Brandmark

> **Poznámka k povýšení.** Tato komponenta zůstala **vložená (inline)** v rekonstrukci současného
> stavu — logo tenanta bylo dokumentováno pouze jako součást chrome `COMP0002_GlobalHeader` /
> `COMP0003_GlobalFooter`, nikdy jako samostatná znovupoužitelná jednotka, protože ve statických
> screenshotech nebylo doloženo žádné druhé, nezávisle se lišící vykreslení (dle reuse-gate v
> `rules-COMP.md`). Nyní je povýšena na samostatnou COMP, protože cílová kanonická knihovna
> `@patron/ui` (`components/Brandmark/`) ji traktuje jako plnohodnotný Atom a
> `DESIGN-component-index.md` řádek 4 jí přiřazuje doc_id `COMP0019`. Podle pravidla current-vs-target
> z projektové konstituce je toto povýšení řízeno **cílovým** kánonem, nikoli novým důkazem o
> současném stavu — část "Current-state (observed)" níže je nezměněná oproti tomu, co již zaznamenaly
> `COMP0002`/`COMP0003`; je nyní pouze vyčleněna do samostatného souboru.

## Účel

Brandmark je logo tenanta/organizace používané v globálním chrome (header, footer) k identifikaci
webu a tam, kde je součástí domovského odkazu, funguje jako kotva pro navigaci "návrat na hlavní
stránku". Jde o sdílený chrome napříč moduly, neomezený na žádný jeden funkční modul — každá
obrazovka v evidenčním souboru současného stavu Patronusu, která zobrazuje header nebo footer,
zobrazuje i logo.

- **Zarovnání s design systémem (cíl):** v `@patron/ui` je `Brandmark` kanonický Atom
  (`packages/ui/src/components/Brandmark/`) explicitně modelovaný jako **řízený tenantem, nikoli
  obsahem** — samotná identita loga je součástí aktivního tématu (`data-theme`), nikoli propem, který
  dodává spotřebitel komponenty. Je komponován do `SiteHeader` (cílové zarovnání COMP0002) a
  `SiteFooter` (cílové zarovnání COMP0003) dle `DESIGN-component-index.md` řádků 4, 14, 15.
- **Current-state (observed):** na živém webu Patronus je logo pozorováno pouze jako
  nestrukturovaný chrome obsah uvnitř headeru a footeru — wordmark s textem "patron dětí" — nikdy
  jako nezávisle znovupoužitá, samostatně se lišící jednotka ve dvou či více odlišných
  kontextech mimo header/footer. Toto povýšení nepřidává žádný nový důkaz o současném stavu nad
  rámec toho, co již zachytily `COMP0002`/`COMP0003`; viz část "Current-state (observed)" níže.

---

## Zarovnání s design systémem (cíl — @patron/ui + @patron/tokens)

> **STATE: TARGET.** Celá tato část popisuje kanonický Atom `@patron/ui` **`Brandmark`**
> (knihovna rebuildu, `packages/ui/src/components/Brandmark/`) dle
> `_ar/spec-draft/DESIGN-component-index.md` řádku 4 a `_ar/evidence/design-system/components.md` §1
> "Brandmark — `components/Brandmark/`". Toto je **autoritativní kontrakt** pro komponentu rebuildu.
> **Není** to důkaz o současném stavu a nesmí být čteno jako tvrzení o tom, jak se pozorované logo
> Patronusu chová dnes — viz "Current-state (observed)" níže. Kde se obě verze liší, je rozdíl
> zaznamenán, nikoli vyřešen.

### Shrnutí kontraktu

Logo tenanta pro header/footer. **Samotná identita loga je řízena tématem, nikoli propem**: obě
značky tenantů existují v DOM současně a CSS (`[data-theme]`) vybírá, která se vykreslí.
CZ vykresluje kompozici uvnitř repozitáře — symbol `Icon`(name="give") + wordmark "patron dětí"; RO
vykresluje živé logo KidsHero, hotlinkované z externí URL `<img>` (žádný binární asset v repozitáři).
Sémantiku logo/odkaz (obalení značky do domovského `<a>`) vlastní **spotřebitel** — `Brandmark` samo
o sobě není odkaz (`_ar/evidence/design-system/components.md` §1; `DESIGN-component-index.md`
řádek 4; `DESIGN-tokens.md` §11).

### Propy

| Název | Typ | Povinný | Výchozí | Popis |
|---|---|---|---|---|
| `small` | `boolean` | ne | `false` | Kompaktní varianta pro umístění v footeru (oproti výchozí velikosti v headeru). |

Exportovaný typ: `BrandmarkProps`. V extrahovaném katalogu není u této komponenty uveden žádný prop
`className`/pro přepis stylu — `Uncertain`, zda kromě dokumentovaného propu `small` nějaký existuje.

**Žádné propy typované entitou.** Brandmark nenese žádná data referencovaná pomocí `ENxxxx` — je to
čistě prezentační/tematický atom, nenavázaný na doménovou entitu.

### Varianty

- **velikost:** `default` (header) | `small` (footer, přes prop `small`)
- **značka tenanta:** `CZ` | `RO` — vybírá se dle `[data-theme]`, **nikoli** propem

Jednotlivé hodnoty:
- `small=false` (výchozí) — použito v kompozici `SiteHeader`, plná velikost lockupu.
- `small=true` — použito v kompozici `SiteFooter`, kompaktní lockup.
- CZ značka — kompozice uvnitř repozitáře: symbol `Icon`(name="give") + wordmark "patron dětí",
  vykreslený s brand/typografickými tokeny.
- RO značka — živý obrázek loga KidsHero, hotlinkovaný z externí URL
  (`kidshero.ro/themes/custom/patron_ro/images/logo.svg` dle `DESIGN-tokens.md` §11 Open Question 3);
  žádný lokální binární soubor v repozitáři rebuildu.

### Stavy

#### idle
Výchozí vykreslení — značka aktivního tenanta, ve velikosti implikované propem `small`. Toto je
jediný stav uvedený v extrahovaném katalogu (`_ar/evidence/design-system/components.md` §1:
"**States:** default, tenant-switch.").

#### hover
`Uncertain — v extrahovaném kanonickém katalogu pro samotný Brandmark neuvedeno.` Pokud spotřebitel
obalí `Brandmark` do odkazu (dle kompozice domovského `<a>` v `SiteHeader`), jakékoli hover ošetření
patří tomuto spotřebitelskému odkazu, nikoli `Brandmark`u.

#### focused
`Uncertain — neuvedeno.` Stejná logika jako u hover: focus ring, pokud existuje, by patřil obalujícímu
`<a>` spotřebitele (který dle konvencí `components.md` používá pro focus ringy jinde v knihovně
`color.accent`), nikoli samotnému `Brandmark`u.

#### disabled
`N/A` — Brandmark je neinteraktivní prezentační atom; nemá vlastní stav disabled.

#### loading
`N/A` — neuvedeno; RO varianta je hotlink `<img>`, takže stav síťového načítání/rozbitého obrázku je
myslitelný, ale **není dokumentován** v kanonickém katalogu. Označit jako nevyřešenou mezeru, nikoli
předpokládané chování.

#### error
`N/A` v kanonickém katalogu. Viz poznámka o fragilitě RO hotlinku níže (Open Question, nikoli
dokumentovaný stav chyby).

### Události

Nevydává žádné události. Brandmark je listový, neinteraktivní prezentační atom; chování
kliknutí/navigace (např. "přejít na hlavní stránku") zcela vlastní spotřebitel, který jej obalí do
`<a>` (domovský odkaz `SiteHeader` dle vlastního kontraktu), nikoli samotný Brandmark.

### Přístupnost (cíl)

- **ARIA role:** pro samotný Brandmark nespecifikována — dědí nativní sémantiku z toho, jaký markup
  vykresluje (kompozice obrázek/SVG plus text). V extrahovaném katalogu není u komponenty samostatně
  uveden `role="img"` ani `aria-label`.
- **Sémantika logo/odkaz vlastní spotřebitel:** dle `DESIGN-component-index.md` řádku 4, "Logo/link
  semantics owned by consumer (SiteHeader wraps it in the home `<a>`)" — Brandmark sám o sobě
  neposkytuje přístupný název pro "přejít domů"; to je odpovědnost obalujícího `<a>` (např.
  `aria-label` na odkazu, nikoli na značce).
- **Navigace klávesnicí:** `N/A` pro samotný Brandmark (neinteraktivní); při obalení spotřebitelským
  odkazem platí standardní tab/Enter sémantika odkazu pro tento wrapper, zde nedokumentováno.
- **Správa fokusu:** `N/A` pro samotný Brandmark; viz poznámka o spotřebitelském odkazu výše.
- **Čtečka obrazovky:** `Uncertain — neuvedeno.` Zda je CZ komponovaný glyf `Icon`(give) vystaven s
  přístupným názvem, nebo je čistě dekorativní a přístupný název nese text wordmarku, není v
  extrahovaném katalogu specifikováno. Označit jako otevřenou otázku k dořešení pro implementaci,
  nepředpokládat žádnou variantu.
- Přístupnost je **vynucována nástroji** napříč celou knihovnou (`.storybook/main.ts` načítá
  `@storybook/addon-a11y`, `preview.tsx` nastavuje `a11y: { test: "error" }`), ale vlastní kontrakt
  této komponenty neuvádí komponentně-specifická ARIA rozhodnutí nad rámec výše uvedené poznámky
  "spotřebitel vlastní sémantiku odkazu".

### Omezení použití

- Použít když: vykreslujeme identitu webu/tenanta v globálním chrome (header, footer).
- Nepoužívat když: je potřeba čistě dekorativní ikona nesouvisející s identitou brandu/tenanta — použít
  přímo `Icon` (COMP0020).
- Kardinalita: jeden na chrome region (jeden v headeru, jeden ve footeru na obrazovku); není navržen
  pro opakované použití/seznamy.
- Umístění: samostatný atom, typicky první potomek uvnitř domovského `<a>` v `SiteHeader` nebo
  brandového bloku v `SiteFooter` — nikdy uvnitř formuláře nebo overlay kontextu dle aktuálního
  katalogového důkazu.

### Závislosti

- **Ostatní COMP (kompozice):** `Icon` (`COMP0020`) — komponován pro CZ symbol,
  `Icon`(name="give").
- **Datové entity:** žádné — žádné propy typované `ENxxxx`.
- **ACL:** žádné — nedokumentována žádná viditelnost řízená rolí; Brandmark se v chrome vykresluje
  nepodmíněně.
- **Externí knihovny:** žádné uvedené kromě živého externího hotlinku obrázku RO tenanta
  (`kidshero.ro/.../logo.svg`) — nejde o závislost na knihovně, ale o runtime síťovou závislost
  specifickou pro značku RO tenanta.
- **Spotřebitelé (kompozice-do, dle `DESIGN-component-index.md`):** `SiteHeader` (cílové zarovnání
  `COMP0002`, výchozí velikost, obalený v domovském `<a>`), `SiteFooter` (cílové zarovnání `COMP0003`,
  varianta `small`).

### Kompozice

Brandmark komponuje `Icon` (COMP0020) pouze pro svůj CZ symbol; žádnou jinou sub-komponentovou
kompozici nemá:

```
Brandmark
  └─ Icon (name="give")   — pouze symbol CZ značky tenanta; RO značka tenanta je čistý <img>
                             hotlink, bez kompozice Icon
```

Spotřebitelé komponující Brandmark (opačný směr, pouze pro orientaci — vlastněno kontrakty těchto
COMP, zde neopakováno):

```
SiteHeader                          SiteFooter
  └─ Brandmark (default, v <a>)       └─ Brandmark (small)
```

### Token sloty

Dle `_ar/evidence/design-system/components.md` §1 a `DESIGN-component-index.md` řádku 4:

`var(--radius-icon)`, `var(--color-brand)`, `var(--color-on-brand)`, `var(--font-display)`
(+ tloušťka/rozpal písma přes `var(--font-display-weight)` / `var(--font-display-tracking)`).

Všechny sloty pro barvu/font/radius jsou vázané na tenanta pod `[data-theme="cz"]` /
`[data-theme="ro"]` dle `DESIGN-tokens.md` §11 — Brandmark nepřijímá žádný prop pro tenanta; výběr
CZ vs. RO značky probíhá čistě mechanismem tokenů/CSS-display popsaným v "Chování tenanta (CZ/RO)"
níže, nikoli logikou komponenty.

### Chování tenanta (CZ/RO)

- **Brandmark je součástí tématu, nikoli obsahovým propem.** Dle `DESIGN-tokens.md` §11: "CZ
  vykresluje kompozici uvnitř repozitáře (ikonová dlaždice + wordmark, s využitím
  `--radius-icon`/`--color-brand`/`--font-display*`); RO vykresluje živé logo KidsHero, hotlinkované
  z externí URL (žádné binární assety v repozitáři). CSS přepíná, které je viditelné, dle
  `data-theme`."
- **Obě značky tenantů existují v DOM současně** — CSS `data-theme` vybírá tu aktivní (přepínač
  `display`), což zrcadlí mechanismus použitý u přepínání sady glyfů line/filled u `Icon`
  (`DESIGN-component-index.md` řádek 3).
- **CZ značka:** symbol "give" (přes komponovaný `Icon`) + wordmark "patron dětí".
- **RO značka:** živý obrázek loga KidsHero (`kidshero.ro/themes/custom/patron_ro/images/logo.svg`),
  hotlinkovaný — záměrné demo rozhodnutí (žádné binární soubory nejsou uloženy v repozitáři
  rebuildu), označené jako **Open Question / fragilita** v `DESIGN-tokens.md` §12 bod 3: "RO logo
  hotlink fragility... if that host changes, RO loses its logo with no local fallback." Zde
  přeneseno nevyřešené, nikoli tiše uzavřené.
- **MD (Moldavsko):** v modelu tenantů vůbec neimplementováno (`DESIGN-tokens.md` §11) — žádná třetí
  značka tenanta pro Brandmark neexistuje; považovat za nepřítomné/budoucí, nikoli za součást
  aktuálního cílového rozsahu.

---

## Current-state (observed)

> **STATE: CURRENT.** Tato část pouze opakuje to, co již zaznamenala předchozí rekonstrukce
> současného stavu (`COMP0002_GlobalHeader.md`, `COMP0003_GlobalFooter.md` a WIRE obrazovky, z nichž
> byly odvozeny) o logu, nyní vyčleněno do samostatného souboru v rámci povýšení. **Pro toto povýšení
> nebyl sesbírán žádný nový důkaz o současném stavu** — jde o přeuspořádání již zachycených
> pozorování, nikoli o novou rekonstrukční fázi. Kde cílový kontrakt výše řeší otevřenou otázku,
> platí toto řešení pouze pro **cíl** a retroaktivně nemění, co bylo pozorováno.

### Co bylo pozorováno

V rámci důkazů ze screenshotů živého CZ webu (`_ar/prtsc/screencapture-patrondeti-cz-*.png`,
křížově odkazovaných přes `_ar/evidence/ui/ui-observed-areas.md` a tabulky Components-Used ve
WIRE), se logo/wordmark objevuje jako vedoucí prvek globálního headeru na v podstatě každé
obrazovce a jako součást brandového bloku footeru:

- **Umístění v headeru:** vedoucí prvek globálního navigačního řádku, vykreslený jako text
  "patron dětí" (dle popisů headeru ve WIRE: WIRE0001 "Header — logo 'patron dětí'",
  WIRE0002/0003/0006/0007/0009/0010/0012/0013/0014/0015/0019/0024/0025 — konzistentní formulace
  "logo 'patron dětí'" napříč všemi doloženými obrazovkami). Žádný odlišný prvek
  ikonové dlaždice/symbolu oddělený od wordmarku nebyl v rekonstrukci nezávisle potvrzen jako
  samostatná položka; `COMP0002` traktoval celý lockup jako chrome headeru, nikoli jako samostatně
  rekonstruovanou sub-komponentu.
- **Umístění ve footeru:** součást brandového/tagline bloku v globálním footeru (`COMP0003`), vedle
  odkazů na sociální sítě — opět traktováno jako nestrukturovaný obsah footeru, nikoli jako
  samostatně rekonstruovaná komponenta, v původní fázi.
- **Chování domovského odkazu:** na více WIRE obrazovkách je logo implicitně klikatelné/funguje jako
  afordance "návrat na hlavní stránku" (např. WIRE0019 "logo (→ S001)"; poznámka o úniku ve WIRE0011
  "kliknutí na logo/navigaci headeru"; únik "logo → nav links" ve WIRE0025), ale podkladová
  struktura DOM (zda je logo samo `<a>`, nebo je jím obaleno) **nebyla** nezávisle potvrzena ze
  statických screenshotů — `Uncertain`.

### Rozsah tenantů v pozorování

Všechny důkazy o současném stavu ze screenshotů v této rekonstrukci jsou **pouze CZ**
(živý web `patrondeti.cz`). Značka RO tenanta (logo KidsHero) popsaná v cílovém kontraktu výše
**není** v souboru screenshotů současného stavu doložena vůbec — její existence, vzhled a chování
na živém RO nasazení jsou `Uncertain — not evidenced` z pramenů této rekonstrukce. Rozlišení
"CZ = wordmark, RO = KidsHero hotlink" je fakt pouze na **straně cíle**
(`DESIGN-tokens.md` §11), nikoli něco, co pozorování současného stavu pro RO nezávisle potvrzuje
nebo vyvrací.

### Rozdíly oproti cíli / otevřené body k dořešení (zaznamenat, ne "opravit")

- **Práh znovupoužitelnosti.** Původní rekonstrukce nepovýšila logo na samostatnou COMP, protože
  nebyl doložen žádný druhý, nezávisle se lišící kontext vykreslení (dle reuse-gate ve
  `rules-COMP.md` pro dvě a více obrazovek) — bylo vidět pouze uvnitř chrome headeru a footeru, oba
  již zachycené celé jako `COMP0002`/`COMP0003`. Toto povýšení nastává nyní **protože to vyžaduje
  cílový kánon**, nikoli protože by vznikl nový důkaz o znovupoužití v současném stavu. Samotný gate
  byl tehdy správně aplikován; tento soubor retroaktivně nenárokuje silnější důkaz o současném stavu,
  než existoval.
- **Struktura symbol vs. wordmark.** Cílová CZ značka je explicitně kompozicí symbolu `Icon`
  (name="give") *plus* wordmarku. Důkazy WIRE o současném stavu popisují pozorovaný prvek
  headeru/footeru pouze jako "logo 'patron dětí'" (popis na úrovni textu) — zda je značka živého
  webu (a) pouze wordmark, (b) symbol+wordmark, jak ji modeluje cíl, nebo (c) rastrový/SVG obrázek
  loga bez interního rozdělení ikona/text, je **`Uncertain`** pouze ze statických screenshotů.
  Nepředpokládat, že cílová kompozice symbol+wordmark popisuje současné živé vykreslení.
- **Vlastnictví domovského odkazu.** Cílový kontrakt je explicitní, že sémantika odkazu je
  odpovědností *spotřebitele* (Brandmark sám o sobě není odkaz; obaluje ho `SiteHeader`). Důkazy o
  současném stavu jsou konzistentní s tím, že logo je klikatelné směrem domů, ale nepotvrzují, zda
  toto chování žije na samotné značce nebo na obalujícím elementu — `Uncertain`, a cílový návrh
  "spotřebitel vlastní odkaz" není důkazem ani v jednom směru pro současnou implementaci.
- **Velikost `small` ve footeru.** Explicitní prop/varianta `small` cíle pro umístění ve footeru
  nemá nezávisle potvrzený protějšek v současném stavu — logo ve footeru v současném stavu se může
  i nemusí vykreslovat menší než logo v headeru; toto nebylo v původní rekonstrukci
  změřeno/potvrzeno (`COMP0003` to traktoval jako součást nestrukturovaného obsahu footeru).
  `Uncertain`.
- **Existence RO tenanta.** Jak uvedeno výše, pro nasazení Patronusu s RO tenantem neexistuje v
  pramenech této rekonstrukce vůbec žádný důkaz o současném stavu; rozdělení tenantů CZ/RO je z
  pohledu tohoto souboru koncept pouze na straně cíle.

---

## Evidence

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Cílový kontrakt — propy, varianty, stavy, tokeny, mechanismus tenanta | Confirmed (for TARGET, not current-state) | `_ar/evidence/design-system/components.md` §1 "Brandmark — `components/Brandmark/`"; `_ar/spec-draft/DESIGN-component-index.md` row 4; `_ar/spec-draft/DESIGN-tokens.md` §11, §12 item 3, §13 |
| Umístění wordmarku loga v headeru/footeru v současném stavu | Confirmed (presence, wording) | `_ar/spec-draft/WIRE/WIRE0001_HomepageStoryCatalogue.md` L45, L82; `WIRE0002_StoryDetailAndDonationModal.md` L53; `WIRE0003_ThankYouPaymentSuccess.md` L45, L67; `WIRE0006`–`WIRE0025` header/footer rows (logo "patron dětí" wording repeated across all evidenced screens); `_ar/spec-draft/COMP/COMP0002_GlobalHeader.md`; `_ar/spec-draft/COMP/COMP0003_GlobalFooter.md` |
| Vnitřní struktura v současném stavu (symbol+wordmark vs. pouze wordmark) | Uncertain — not evidenced | Bez DOM/zvětšeného důkazu; pouze úroveň popisu ze statického screenshotu |
| Existence/vzhled značky RO tenanta v současném stavu | Uncertain — not evidenced | Soubor důkazů o současném stavu je pouze CZ (`patrondeti.cz`); žádné RO screenshoty v této rekonstrukci |
| Vlastnictví domovského odkazu (samotná značka vs. obalující element) | Uncertain — not evidenced | Zmínky o úniku ve WIRE (`WIRE0011`, `WIRE0019`, `WIRE0025`) popisují chování, nikoli strukturu DOM |
| Přístupný název / chování čtečky obrazovky (cíl nebo současný stav) | Uncertain | V `components.md` neuvedeno specificky pro Brandmark; a11y současného stavu jednotně `Uncertain` dle konvence rekonstrukce |
