---
doc_id: DESIGN-component-index
title: Design Component Index — canonical @patron/ui library
layer: DESIGN
state: TARGET
spec_type: index
modules: []
status: imported
references:
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0004
  - COMP0005
  - COMP0006
  - COMP0007
  - COMP0008
  - COMP0009
---

# DESIGN Component Index — canonical `@patron/ui` library

> **STATE: TARGET.** Tento index katalogizuje **design systém rebuildu (`bid-patron-deti`)**
> (`packages/ui`), tj. budoucí knihovnu komponent pro rewrite Patronusu. **Nejde** o current-state
> pravdu. Podle current-vs-target pravidla projektové konstituce se nachází na stejné úrovni
> autority jako `it-zadani` / redesignové podklady: je užitečný pro tvorbu rebuild-ready
> specifikace, nikdy se nepoužívá k "opravě" rekonstruovaného current-state UX
> (`_ar/spec-draft/COMP/**`, `_ar/spec-draft/WIRE/**`).
>
> **Zdroj extrakce:** `_ar/evidence/design-system/components.md` (úplný katalog),
> křížově ověřeno proti `_ar/spec-draft/COMP-inventory-map.md` pro mapování rekonciliace.
> Kořen kanonické knihovny: `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/`.
>
> **Rozsah:** 16 kanonických komponent (7 Atomů + 9 Bloků) + 1 kompozice stránky (StoryDetail) = 17
> katalogizovaných jednotek, dle `components.md` §1 součtu. Každý záznam níže se mapuje na
> rekonstruovaný current-state COMP doc_id, se kterým se rekoncilituje, pokud existuje (COMP0001–COMP0003, COMP0008
> pouze — viz §3 pro 5 rekonstruovaných COMP dokumentů bez kanonického protějšku).

---

## 1. Tabulka indexu

| # | Kanonický název | Vrstva | Účel v jedné větě | Klíčové props/varianty/stavy | Sloty tokenů | Poznámky k přístupnosti (a11y) | Poznámky k tenantům | Mapovaný COMP doc_id |
|---|---|---|---|---|---|---|---|---|
| 1 | **Button** | Atom | Základní akční prvek (CTA/sekundární/link-akce); vykresluje `<button>` nebo `<a>` se stejnou vizuální smlouvou | Props: `label`, `variant` (primary\|secondary\|ghost), `size` (md\|lg), `block`, `iconBefore`/`iconAfter`. Stavy: default, hover, focus-visible, active, disabled (pouze btn) | `--font-body`, `--radius-pill`, `--size-base/lg`, `--space-sm/md/lg/xl`, `--color-action`, `--color-on-brand`, `--color-surface`, `--color-text`, `--color-border`, `--color-accent` | Focus-visible kroužek se řídí `color.accent`; disabled přes nativní `disabled` (pouze button, ne link) | Theme-neutrální — žádné tenant-specifické props; barvy se řeší přes `data-theme` token remap | **COMP0001** |
| 2 | **Input** | Atom | Holé textové/číselné formulářové pole; label je odpovědností konzumujícího komponentu | Props: nativní `InputHTMLAttributes` (`type`, `value`, `placeholder`, `onChange`, `aria-label`, `inputMode`, `disabled`). Bez variant/velikostí. Stavy: default, focus, disabled, error (signalizováno konzumentem přes `aria-invalid`) | `--font-body`, `--radius-control`, `--color-border`, `--color-surface`, `--color-text`, `--color-muted`, `--color-accent` | Nevykresluje žádný vlastní styl chyby — konzument musí párovat s viditelným textem chyby/`aria-invalid`; žádný vestavěný `<label>` | Theme-neutrální | **COMP0021** |
| 3 | **Icon** | Atom | Piktogram s dvojí sadou glyfů (linkový/vyplněný), volen podle tenanta přes CSS, dědí `currentColor` | Props: `name` (`IconName`: development\|health\|subsistence\|clock\|check\|arrow\|heart\|give\|user), `size` (px, výchozí 20). Varianta: LINE (CZ) vs FILLED (RO) přes `data-theme`. Stav: pouze idle | žádné (používá `currentColor`; CSS `display` přepíná sadu glyfů) | Ve výchozím stavu dekorativní (žádná vlastní role/label — konzumující komponenta musí dodat `aria-label`, pokud má smysl) | **Styl** glyfu (linkový vs vyplněný) je řízen tématem, nikoli props — CZ=linkový, RO=vyplněný | **COMP0020** |
| 4 | **Brandmark** | Atom | Logo tenanta pro header/footer; samotná identita loga je řízena tématem, nikoli props | Props: `small` (bool, výchozí false). Varianty: default/small (footer) × CZ/RO (přes `data-theme`). Kompozice: `Icon`(name="give") pro CZ symbol | `--radius-icon`, `--color-brand`, `--color-on-brand`, `--font-display(+weight/tracking)` | Sémantika logo/link je v odpovědnosti konzumenta (SiteHeader jej obaluje v domovském `<a>`) | Obě značky tenantů žijí v DOM současně; CSS vybírá aktivní — CZ = symbol "give" + wordmark, RO = live hotlink obrázku KidsHero (žádný binární soubor v repu) | **COMP0019** |
| 5 | **CategoryChip** | Atom | Indikátor kategorie příběhu; stejná kategorie = stejná barva všude (chip, podklad karty, rohový prvek hero) | Props: `category` (`StoryCategory`: development\|health\|subsistence, povinné), `label` (povinné). Jedna varianta na kategorii řídící `--cat` → `--color-category-*`. Fixní velikost. Stav: pouze idle | `--color-category-development/-health/-subsistence`, `--color-surface`, `--font-body`, `--radius-pill` | Kompozitní `Icon` odpovídá kategorii (velikost 15) — dekorativní, přístupný název nese textový label | Taxonomie kategorií (3 hodnoty) je sdílená mezi tenanty; mapování barvy je na úrovni tokenu, nikoli přepínané podle tenanta | **COMP0018** |
| 6 | **TimeLeftPill** | Atom | Pilulka zbývajícího času kampaně; klidný stav = neutrální, urgentní = alert-badge s mírným pulzováním | Props: `label` (povinné), `urgent` (bool, výchozí false). Varianty: calm/urgent. Stav: idle (vykreslení calm/urgent) | `--font-body`, `--radius-pill`, `--color-text`, `--color-surface`, `--color-muted`, `--color-urgent`, `--color-on-urgent` | Animace `urgentpulse` je explicitně vypnuta při `prefers-reduced-motion` | Theme-neutrální; urgentní stav používá vyhrazené tokeny `color.urgent`/`on-urgent`, odlišné od brand palety podle tenanta | **COMP0017** |
| 7 | **ProgressBar** | Atom | Ukazatel průběhu sbírky; gradient brand→accent odhalovaný přes clip-path (druhá barva se ukáže až blízko 100 %) | Props: `value` (0–100, povinné, ořezáno/zaokrouhleno), `height` (px, výchozí 10), `ariaLabel` (výchozí "Průběh sbírky"). Stavy: default/0 %/100 % | `--radius-pill`, `--color-track`, `--color-brand`, `--color-accent` | `role="progressbar"` + `aria-valuemin/max/now`; explicitně **není zaostřitelný** (statusová role, nikoli ovládací prvek) | Výchozí `ariaLabel` je specificky český text ("Průběh sbírky") — RO tenant musí přepsat přes prop, není automaticky lokalizován | **COMP0016** |
| 8 | **StoryCard** | Blok | Základní opakující se jednotka storefrontu — příběh jednoho dítěte + průběh ve výpisech (katalog, "Další děti") | Props: `title`, `photoUrl?`, `initial`, `category`, `categoryLabel`, `progressPct`, `missingLabel`, `goalLabel` (vše připraveno k zobrazení). Varianta: podle kategorie. Stavy: default; hover/focus (mimo první iteraci); loading/empty/error (mimo rozsah první iterace). Kompozice: `CategoryChip` + `ProgressBar` | `--color-surface`, `--color-border`, `--radius-card`, `--shadow-card`, `--font-body`, `--color-category-*`, `--color-surface-tint`, `--font-display(+weight/tracking)`, `--color-text`, `--color-muted`, `--space-md/sm` | Klikatelná jednotka pro akvizici dárců → detail příběhu; stavy hover/focus vlastníkovaného linku odloženy (nejsou v první iteraci) | Žádné tenant-specifické props; obsah (title/labely) je předáván již lokalizovaný | **COMP0008** |
| 9 | **StoryHero** | Blok | Vizuál příběhu na detailní stránce — velká fotka + rohový category chip; fallback monogramu na podkladu, když chybí fotka | Props: `photoUrl?`, `photoAlt?` (výchozí ""), `initial`, `category`, `categoryLabel`. Varianty: s-fotkou/monogram-fallback/podle-kategorie. Stavy: default; foto↔fallback. Kompozice: `CategoryChip` | `--radius-card`, `--shadow-card`, `--color-brand`, `--color-surface`, `--color-surface-tint`, `--font-display(+weight/tracking)` | Fallback monogramu je záměrné designové rozhodnutí (nikoli obecný gradientový placeholder) — zvyšuje rozpoznatelnost, když je `photoAlt` prázdné | Theme-neutrální; vykreslení fallbacku používá brand tokeny, takže se automaticky přeskinuje podle tenanta | **COMP0011** |
| 10 | **PatronCard** | Blok | Blok patrona jako pilíře důvěry / testimoniál na detailní stránce; zakotvuje invariant "patron garantuje příběh" | Props: `initial`, `avatarUrl?`, `name`, `role`, `sealLabel`, `commentHtml` (sanitizovaný backendový WYSIWYG). Varianty: avatar s fotkou/avatar s iniciálou. Stavy: default; foto↔fallback. Kompozice: `Icon`(name="check", pečeť) | `--color-surface`, `--color-border`, `--radius-card`, `--space-lg/md`, `--font-body`, `--color-brand`, `--color-brand-strong`, `--font-display(+weight)`, `--color-text`, `--color-muted`, `--color-success`, `--radius-pill` | Ověřovací pečeť čte sémanticky `color.success`; komentář je **vždy plně viditelný** — žádné tlačítko "zobrazit více" (invariant transparentnosti) | Theme-neutrální kompozice; obsah (jméno/role/komentář) je specifický pro instanci | **COMP0012** |
| 11 | **RailCta** | Blok | Lehčí karta v pravém postranním panelu pod DonationBox — vedlejší cesty pomoci (trvalý dar, dárkový poukaz) | Props: `title`, `text`, `href`, `ctaLabel?` (výchozí varianta), `promo?` (bool), `linkLabel?` (promo varianta). Varianty: default (vysvětlující text + outline CTA)/promo (celá karta je link, accent podklad). Stavy: default; hover/focus (kroužek `color.accent`). Kompozice: `Button`(ghost, block) + `Icon`(name="arrow") | `--color-surface`, `--color-border`, `--radius-card`, `--space-md/lg`, `--font-body`, `--font-display(+weight/tracking)`, `--color-text`, `--color-muted`, `--color-accent` | Externí link se otevírá v novém okně s bezpečným `rel` | **Promo varianta (dárkový poukaz/"dobrošek") je pouze CZ**, modul specifický pro tenanta, v RO skrytý (řízeno konzumentem, nikoli skryto přes CSS) | **COMP0014** |
| 12 | **ShareRow** | Blok | Kompaktní monochromatický řádek ikon pro sdílení příběhu; glyfy přebírají barvu tenanta při hover | Props: `label` (povinné), `networks?` (`SocialName[]`: facebook\|x\|instagram\|linkedin\|whatsapp\|email\|messenger; výchozí = všech 7). Varianty: výchozí sada/vlastní sada. Stavy: default (`color.muted`); hover/focus (`color.action`, kroužek `color.accent`). Kompozice: interní `SocialGlyph` | `--space-sm`, `--font-body`, `--color-muted`, `--color-surface`, `--color-border`, `--color-action` | Každý link má `aria-label` s názvem sítě; samotný glyf je dekorativní | Theme-neutrální; sada sítí je customizovatelná per instance/tenant přes prop `networks` | **COMP0015** |
| 13 | **DonationBox** | Blok | Primární konverzní blok detailu příběhu — zobrazuje chybějící částku/termín, jednorázové rozhodnutí o příspěvku; ve stavu naplnění nahrazuje formulář poděkováním | Props: `state?` (live\|urgent\|funded, výchozí live), `timeLeftLabel`, `missingAmount`, `missingCaption`, `goalCaption`, `goalAmount`, `progressPct`, `donorsNote?`, `presets` (`DonationPreset[]`), `defaultPresetIndex?`, `customLabel`, `currencyLabel`, `customInputLabel`, `restFill?`, `ctaLabel`, `voucherLabel?` (pouze CZ), `successTitle?`, `successMessage?`, `onDonate?`. Stavy: výběr presetu, otevřené "Jiná" (vlastní částka), hover/focus, reduced-motion (pulz vypnut). Kompozice: `TimeLeftPill` + `ProgressBar` + `Input` + `Button`(primary/block) + `Icon`(check, give) | `--color-surface`, `--color-border`, `--radius-card`, `--shadow-card`, `--space-xs/sm/md/lg`, `--font-body`, `--font-display(+weight/tracking)`, `--color-brand-strong`, `--color-muted`, `--color-text`, `--radius-control`, `--radius-icon`, `--color-action`, `--color-accent`, `--color-success`, `--color-on-success` | Tlačítka presetů používají `aria-pressed` pro stav výběru | Prop `voucherLabel?` je **pouze CZ** (specifický pro tenanta, řízeno konzumentem). **Hranice rozsahu: končí u `onDonate(amount)`** — modál pro dar (e-mail/souhlasy/platba) je explicitně samostatný budoucí blok, ve smlouvě "Mimo scope" | **COMP0010** |
| 14 | **SiteHeader** | Blok | Header storefrontu: brandmark, hlavní navigace, přihlášení, CTA "Ask for help"; skládá se do hamburgeru ≤720px | Props: `navItems` (string[]), `loginLabel`, `applyLabel`. Varianty: desktop/mobile (hamburger). Stavy: default; menu zavřené/otevřené (`aria-expanded`). Kompozice: `Brandmark` (v domovském `<a>`), `Button`(ghost, desktop CTA), `Icon`(user) | `--space-lg/md/sm/xs`, `--color-border`, `--color-muted`, `--color-text`, `--color-action`, `--color-surface`, `--shadow-card`, `--font-body` | Přepínač mobilního menu vystavuje `aria-expanded` | Položky/labely navigace jsou řízeny props podle tenanta/lokalizace | **COMP0002** |
| 15 | **SiteFooter** | Blok | Footer storefrontu: brand + tagline + sociální sítě, navigační sloupce Projekt/Kontakt, legal lišta; obsah per-tenant přes props, layout je fixní | Props: `tagline`, `followLabel`, `projectTitle`, `projectLinks` (string[]), `contactTitle`, `email`, `contactNotes` (node[]), `applyLabel`, `legalNote` (node), `privacyLabel`, `copyright`. Žádné strukturální varianty (pouze obsahově řízené). Stavy: default; hover/focus linku. Kompozice: `Brandmark`(small) + `SocialGlyph`(facebook/instagram/linkedin, natvrdo zadané) | `--layout-container`, `--space-xl/lg/md/sm`, `--color-border`, `--color-surface`, `--color-text`, `--color-muted`, `--color-action`, `--font-body`, `--font-display(+weight/tracking)` | Standardní stavy focus u linků; žádné vlastní ARIA nad rámec nativní sémantiky nav | Veškerý textový obsah je předáván jako props — žádný fixní slot pro "promo pás" (viz poznámka o divergenci v §3) | **COMP0003** |
| — | **StoryDetail** (stránka) | Stránka (kompozice, nikoli komponenta) | Konverzní jádro storefrontu — představuje dítě/příběh/patrona, pohání příspěvek; nese domain pravdy "100 % pro dítě / dodavatel v nominativu / patron garantuje / fixní presety" | Kompoziční oblasti: `SiteHeader` → breadcrumb → H1 → hlavní sloupec (`StoryHero` → úvodní text → `PatronCard` → prostý text) + sticky pravý panel (`DonationBox` → `RailCta`(trvalý dar) → `RailCta`(promo, pouze CZ) → `ShareRow`) → full-width `PledgeStrip` (přítomný v každém stavu) → grid "Další děti" (3× `StoryCard`) → `SiteFooter` → mobilní sticky CTA lišta (skrytá při naplnění). Stavy obrazovky: live/urgent/funded (odráží DonationBox). Responzivní breakpointy: ≤900px jeden sloupec + panel níže + sticky CTA; ≤860px grid→1 sloupec; ≤720px header hamburger | (dědí všechny sloty tokenů komponovaných komponent) | (dědí a11y chování komponovaných komponent) | Per-tenant obsahové fixtures `contentCz`/`contentRo` (`_fixtures.tsx`); RO vynechává promo `RailCta`. **Explicitně mimo rozsah:** modál pro dar (e-mail/souhlasy/mock platba), krokový "gift chain", dostupnost reálných dat o počtu dárců | *(žádný jednotlivý COMP — kompozice řádků 8–15 výše; viz poznámka o PledgeStrip níže)* |

**Poznámka k PledgeStrip:** `components.md` dokumentuje `PledgeStrip` jako Blok konzumovaný ve
StoryDetail (banner invariantu 100% pledge + dodavatel) a přiděluje mu mapování rekonciliace
**COMP0013** v mapovacím seznamu úkolu, ale **nemá** vlastní vyhrazenou katalogovou podsekci
komponenty v `_ar/evidence/design-system/components.md` §1 (objevuje se pouze v kompozici StoryDetail
a v Mapovací tabulce §2, uveden mezi Bloky "GAP→recon"). Zaznamenáno zde pro úplnost dle přiděleného
kanonického doc_id z úkolu:

| # | Kanonický název | Vrstva | Účel v jedné větě | Klíčové props/varianty/stavy | Sloty tokenů | Poznámky k přístupnosti (a11y) | Poznámky k tenantům | Mapovaný COMP doc_id |
|---|---|---|---|---|---|---|---|---|
| 16 | **PledgeStrip** | Blok | Full-width banner invariantu — "100 % daru dorazí k dítěti, nikdy rodině; dodavatel jmenován" — přítomný v každém stavu DonationBox | `Uncertain — v components.md nevyčleněno jako vlastní katalogová podsekce; props/varianty/stavy nejsou samostatně doloženy nad rámec jeho role v kompozici StoryDetail (§1 "Full-width divider").` | `Uncertain — nevyčleněno samostatně; pravděpodobně sdílí tokeny surface/text se sousedními Bloky.` | `Uncertain — nevyčleněno samostatně.` | Přítomný v **každém** stavu sbírky (live/urgent/funded) dle kompozice StoryDetail; nese hlavní invariant důvěry platformy | **COMP0013** |

---

## 2. Referenční přehled přidělení doc_id (dle instrukce úkolu)

| Kanonická komponenta | Mapovaný COMP doc_id |
|---|---|
| Button | COMP0001 |
| SiteHeader | COMP0002 |
| SiteFooter | COMP0003 |
| StoryCard | COMP0008 |
| DonationBox | COMP0010 |
| StoryHero | COMP0011 |
| PatronCard | COMP0012 |
| PledgeStrip | COMP0013 |
| RailCta | COMP0014 |
| ShareRow | COMP0015 |
| ProgressBar | COMP0016 |
| TimeLeftPill | COMP0017 |
| CategoryChip | COMP0018 |
| Brandmark | COMP0019 |
| Icon | COMP0020 |
| Input | COMP0021 |

COMP0001–COMP0003 a COMP0008 jsou **již existující rekonstruované current-state COMP dokumenty**
(`_ar/spec-draft/COMP/COMP0001_PrimaryButton.md`, `COMP0002_GlobalHeader.md`,
`COMP0003_GlobalFooter.md`, `COMP0008_StoryCard.md`), se kterými tento index rekoncilituje kanonickou
komponentu (RENAME/MATCH dle `components.md` §2). **COMP0010–COMP0021 jsou nově přidělené doc_id
pro tento TARGET index** — pro tato čísla dosud neexistuje žádný rekonstruovaný current-state COMP
soubor; jsou zde vyhrazena, aby zůstalo číslování kanonické knihovny stabilní pro navazující
generování `spec-final`. Vytvoření odpovídajících COMP souborů (pokud by bylo žádoucí) je mimo
rozsah tohoto indexu.

---

## 3. Rekonstruované COMP dokumenty bez kanonického protějšku

Následujících 5 rekonstruovaných current-state COMP dokumentů (`_ar/spec-draft/COMP/**`) **nemá**
odpovídající komponentu v kanonické knihovně `@patron/ui`. Vystavují funkčnost, která patří ještě
nepostaveným epikám **E0003 (Obsah/CMS)**, **E0004 (Storefront web — cesta dárce vč. modálu daru)**
a **E0005 (Mobilní aplikace)** dle `_ar/evidence/design-system/design-canon.md` §0 tabulky epik
(pouze **E0001 Design systém a tokeny** má stav `Done`; E0002 je `Active`; E0003–E0005 jsou
`Draft`/`Plánováno`):

| Rekonstruovaný COMP | Název | Proč chybí v kanonické knihovně |
|---|---|---|
| **COMP0004** | Cookie Consent Banner | Vůbec není v rozsahu `packages/ui` — consent banner je záležitost app-shellu/consent platformy, nikoli komponenty UI storefrontu. |
| **COMP0005** | Application Wizard Stepper | Kanonická knihovna zatím pokrývá pouze storefront + detail příběhu; intake wizard žádosti (5 kroků, území epiky E0004) dosud nemá postavené komponenty. |
| **COMP0006** | Consent Checkbox | **Zatím** žádná kanonická komponenta — smlouvy DonationBox/StoryDetail explicitně jmenují modál daru (e-mail + souhlasy + platba) jako odložený "samostatný budoucí blok" ("Mimo scope"). Toto je zamýšlený budoucí domov ConsentCheckbox. |
| **COMP0007** | File Upload Dropzone | Patří k dosud nepostavenému wizardu žádosti / plochám účtu (území E0004/E0005). |
| **COMP0009** | Email-Entry Form | Jeho atomy (`Input`, `Button`) v kanonické knihovně existují, ale samotný autentizační composite pro zadání e-mailu není postaven (autentizační plocha zatím není v rozsahu). |

Těchto 5 dokumentů zůstává řízeno výhradně svými existujícími rekonstruovanými current-state COMP
soubory; tento TARGET index jim nepřiděluje kanonický protějšek doc_id.

---

## 4. Zdrojové cesty

- **Komponenty kanonické knihovny** (Atomy/Bloky):
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/<Name>/`
  — každá s `<Name>.tsx`, `<Name>.stories.tsx`, `<Name>.module.css`, `<Name>.contract.md`,
  `index.ts`.
- **Kompozice stránky StoryDetail:**
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/pages/StoryDetail/`
  (vč. `_fixtures.tsx` pro obsah per-tenant).
- **Základy / tokeny:**
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/foundations/{Uvod,Tokeny,Typografie}.mdx`,
  `TokenGallery.tsx`; zdroj pravdy tokenů `@patron/tokens/tokens.css` (externí balíček, mimo
  `packages/ui`).
- **Konfigurace Storybooku:**
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/.storybook/{main.ts,preview.tsx}`
  — taxonomie vrstev (`storySort`: Foundations → Atoms → Blocks → Pages), přepínač tenanta
  (`globalTypes.tenant` → `data-theme`), vynucení a11y (`@storybook/addon-a11y`, `a11y: {test:
  "error"}`).
- **Veřejné exportní rozhraní:**
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/index.ts`.
- **Úplný extrahovaný katalog (přímý zdroj tohoto indexu):**
  `_ar/evidence/design-system/components.md`.
- **Mapování rekonciliace (kanonický ↔ rekonstruovaný COMP/WIRE, klasifikace MATCH/RENAME/GAP):**
  `_ar/evidence/design-system/components.md` §2–§4.
- **Rekonstruované current-state COMP soubory, se kterými se rekoncilituje:**
  `_ar/spec-draft/COMP/COMP0001_PrimaryButton.md`, `COMP0002_GlobalHeader.md`,
  `COMP0003_GlobalFooter.md`, `COMP0008_StoryCard.md`; úplný inventář
  `_ar/spec-draft/COMP-inventory-map.md`.
- **Design canon / kontext zralosti epik:** `_ar/evidence/design-system/design-canon.md`.
- **Katalog tokenů (definice sémantických slotů):** `_ar/evidence/design-system/tokens.md`.
