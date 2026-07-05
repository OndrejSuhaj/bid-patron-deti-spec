---
doc_id: COMP0012
title: PatronCard
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/PatronCard/
references:
  - WIRE0002
  - EN0005
  - COMP0020
---

# COMP0012 – PatronCard

## Účel

Tento dokument povyšuje **PatronCard**, kanonický `@patron/ui` **Block**, podle instrukce zadání
("tato komponenta zůstala v rekonstrukci inline; povyš ji nyní"). Obsahuje **dva jasně oddělené
soubory faktů** podle projektové disciplíny current-vs-target:

- **Design-system alignment (target)** — autoritativní kanonický kontrakt pro PatronCard tak, jak je
  vystavěn v knihovně rebuildu `bid-patron-deti` (`packages/ui/src/components/PatronCard/`):
  samostatný testimonial blok na detailní stránce příběhu, který staví Patrona do role **pilíře
  důvěry** — zakódovává invariant "patron garantuje příběh" prostřednictvím ověřovací pečeti a
  udržuje komentář patrona vždy plně viditelný (bez přepínače "zobrazit více"), jako záměrné
  rozhodnutí ve prospěch transparentnosti.
- **Current-state (observed)** — co rekonstruovaný current-state UX Patronusu
  (`_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md`) skutečně zobrazuje v odpovídající
  zóně obrazovky ("karta komentáře Patrona"), která zůstala `inline` (nebyla povýšena na COMP),
  protože current-state evidence sama o sobě nepodpořila tvrzení o znovupoužitelné komponentě.

Tyto dvě části popisují **odlišné systémy** (target rebuildu vs. rekonstruovaný current-state
Patronus) a nesmí být sloučeny do jednoho faktu. Podle `DESIGN-component-index.md` řádek 10 tento
target kontrakt komponenty slaďuje **pojmenovanou current-vs-target divergenci v chování**
zaznamenanou u `WIRE0002` (přepínač viditelnosti komentáře vs. cílový vždy viditelný komentář — viz
Current-vs-target divergence níže); toto sladění je *poznámka*, nikoli přepis toho, co bylo
pozorováno.

Křížová reference: tento dokument se sladí s `DESIGN-component-index.md` řádek 10 a
`_ar/evidence/design-system/components.md` §1 "PatronCard" / §2 mapovací řádek ("GAP→recon") / §4
"Behavioral divergences worth flagging".

---

## Design-system alignment (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Vše v této části popisuje kanonickou komponentu rebuildu
> (`packages/ui/src/components/PatronCard/`), nikoli current-state chování Patronusu. Autoritativní
> zdroj: `_ar/evidence/design-system/components.md` §1 "PatronCard — `components/PatronCard/`" a
> `DESIGN-component-index.md` řádek 10.

### Účel (target)

Patron jako pilíř důvěry — samostatný testimonial blok na detailní stránce příběhu. Zakódovává
invariant *"patron garantuje příběh"* prostřednictvím ověřovací pečeti (sémanticky čte
`color.success`); komentář patrona je **vždy plně viditelný** — neexistuje žádný přepínač "zobrazit
více"/collapse, což je záměrné rozhodnutí ve prospěch transparentnosti dokumentované v kanonickém
katalogu.

### Props / Vstupy (target)

| Name | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `initial` | `string` | ano (použije se, když chybí `avatarUrl`) | — | Písmeno/písmena monogramu zobrazená ve fallback variantě initial-avatar. |
| `avatarUrl` | `string` (URL) | ne | — | Fotografie patrona. Když chybí, vykreslí se místo ní fallback varianta initial-avatar. |
| `name` | `string` | ano | — | Zobrazované jméno patrona; váže obsah na úrovni atributu entity `EN0005` (current-state entita Patron). |
| `role` | `string` | ano | — | Text role/označení patrona (např. "Patron příběhu"). |
| `sealLabel` | `string` | ano | — | Text doprovázející ikonu ověřovací pečeti (např. označení "ověřeno"/"garantováno"). |
| `commentHtml` | `string` (sanitizované HTML) | ano | — | Tělo komentáře patrona, pocházející z omezeného WYSIWYG editoru a sanitizované na backendu před vykreslením. Vždy vykresleno v plném rozsahu — bez logiky zkracování/přepínače v komponentě. |

Exportovaný typ: `PatronCardProps` (podle `components.md` §1).

### Varianty (target)

- **avatar:** foto avatar | initial avatar — řízeno čistě přítomností/absencí `avatarUrl`, nikoli samostatným propem (stejný vzor jako osa foto/monogram-fallback u `COMP0011` StoryHero).

### Stavy (target)

#### idle
Výchozí vykreslení: avatar (foto nebo initial fallback) + jméno + role + ověřovací pečeť (ikona +
`sealLabel`) + plně viditelné tělo `commentHtml`.

#### hover
`Uncertain — v kanonickém katalogu není samostatně vyjmenován jako odlišný interaktivní stav; PatronCard není dokumentován jako samostatně klikatelný (jde o statický testimonial blok uvnitř kompozice stránky StoryDetail, nikoli o vlastnící odkaz).`

#### focused
`Uncertain — není vyjmenován; žádný focusovatelný element není dokumentován jako přirozeně náležející k PatronCard (vložená ikona pečeti je prezentační).`

#### disabled
N/A — vykreslení disabled není součástí kanonického kontraktu; PatronCard je zobrazovací blok, nikoli ovládací prvek.

#### loading
`Uncertain — nevyjmenováno v kanonickém katalogu (components.md / DESIGN-component-index.md nedokumentují loading/skeleton stav pro PatronCard).`

#### error
N/A — kanonický kontrakt řeší případ "bez fotky" prostřednictvím fallback varianty initial-avatar (jde o navržený stav, nikoli chybový stav); žádné odlišné vykreslení chyby při načtení obrázku není dokumentováno.

### Události (target)

Nejsou emitovány žádné události — PatronCard je prezentační Block bez dokumentovaných callback propů
(`PatronCardProps` podle `components.md` §1 uvádí pouze zobrazovací propy: `initial`, `avatarUrl`, `name`,
`role`, `sealLabel`, `commentHtml`).

### Přístupnost (target)

- **ARIA role:** pro kontejner samostatně nedokumentována; fotografie avataru se vykresluje jako
  standardní `<img>`, pokud je přítomen `avatarUrl`.
- **Sémantika ověřovací pečeti:** ikona pečeti (`Icon` name="check") sémanticky čte `color.success`
  podle `DESIGN-component-index.md` řádek 10 poznámky A11y — tj. vizuální/sémantický kanál pro
  "ověřeno/garantováno" je token success, nikoli ad hoc barva. `Icon` samotná je ve výchozím stavu
  dekorativní (podle kontraktu `COMP0020`); text `sealLabel` je to, co nese accessible name pečeti,
  konzistentně s tím, jak `CategoryChip` (`COMP0018`) páruje dekorativní ikonu s textem označení.
- **Komentář vždy plně viditelný — žádný přepínač, u kterého by bylo třeba řešit focus/expand-collapse:**
  podle `DESIGN-component-index.md` řádek 10 poznámky A11y, "komentář je **vždy plně viditelný** —
  žádný přepínač 'zobrazit více' (transparentnostní invariant)". Tím se odstraňuje celá třída správy
  expand/collapse stavů z hlediska klávesnice a čtečky obrazovky, kterou by jinak vzor s přepínačem
  vyžadoval.
- **Navigace klávesnicí:** N/A nad rámec přirozeného toku dokumentu — žádný focusovatelný/interaktivní
  element není dokumentován jako přirozeně náležející k PatronCard.
- **Správa focusu:** N/A ze stejného důvodu.
- **Čtečka obrazovky:** `sealLabel` poskytuje accessible name pečeti; `commentHtml` se vykresluje jako
  běžný sanitizovaný markup (backend-sanitizovaný výstup WYSIWYG) — žádné další chování PatronCard
  vůči čtečce obrazovky nad tento rámec není dokumentováno.

### Chování podle tenanta (target — CZ/RO přes `data-theme`)

Theme-neutrální kompozice: žádné CZ/RO-specifické propy (podle `DESIGN-component-index.md` řádek 10
poznámky Tenant: "Theme-neutral composition; content (name/role/comment) per-instance"). Vizuální
přeskinování probíhá výhradně přemapováním tokenů pod `data-theme="cz"|"ro"`:

- `var(--color-surface)`, `var(--color-border)` — povrch karty a obrys, vázané na tenanta podle
  `DESIGN-tokens.md` §3.1.
- `var(--radius-card)` — zaoblení rohů karty (CZ `16px` / RO `26px`, ostřejší vs. squircle), podle
  `DESIGN-tokens.md` §6.
- `var(--space-lg)`, `var(--space-md)` — vnitřní rozestupy (společné, nevázané na tenanta).
- `var(--font-body)` — typografie těla komentáře (společná).
- `var(--color-brand)`, `var(--color-brand-strong)` — akcenty (např. zvýraznění jména/role), vázané na
  tenanta podle `DESIGN-tokens.md` §3.1 (CZ `#EC4B34`/`#B3311D`, RO `#0FB5AE`/`#0A7E79`).
- `var(--font-display)` (+weight) — display typografie jména/role, vázaná na tenanta podle
  `DESIGN-tokens.md` §4.1 (CZ Bricolage Grotesque 800 / RO Baloo 2 700).
- `var(--color-text)`, `var(--color-muted)` — hlavní/sekundární text, vázané na tenanta.
- `var(--color-success)` — sémantická barva ověřovací pečeti; podle řádku `DESIGN-tokens.md`
  "`color.success` | success/trust ('Vybráno' chip, **patron seal**) | CZ `#149E6E` | RO `#0FB5AE`" —
  toto je *přesný* dokumentovaný use-case tohoto tokenu, potvrzující barvu pečeti vázanou na tenanta.
- `var(--radius-pill)` — pravděpodobně tvarový token pro provedení badge/pill pečeti (konzistentní s
  dalšími pill-shaped stavovými indikátory v knihovně, např. `TimeLeftPill`/`CategoryChip`);
  `Uncertain — components.md` uvádí `--radius-pill` mezi token slots PatronCard, ale nevyjmenovává,
  který konkrétní subelement (badge pečeti vs. něco jiného) jej využívá.

### Omezení použití (target)

- Použít když: vykreslování testimonialu patrona v kompozici stránky StoryDetail, v hlavním sloupci
  bezprostředně po lede textu (podle řádku `DESIGN-component-index.md` "StoryDetail (Page)" pořadí
  kompozice: `SiteHeader → breadcrumb → H1 → StoryHero → lede → PatronCard → prose`).
- Nepoužívat když: vykreslování obecného uživatelského testimonialu/recenze mimo kontext garance
  patrona na detailu příběhu — kontrakt PatronCard je specificky invariant "patron garantuje příběh",
  nikoli obecná testimonial komponenta.
- Kardinalita: jedna na stránku StoryDetail (každá kampaň má nejvýše jednoho patrona, konzistentně s
  current-state invariantem `EN0005` "Kampaň má nejvýše jednoho patrona").
- Umístění: hlavní sloupec, samostatný blok mezi hero/lede a dlouhým textem prózy; nikoli sidebar
  nebo overlay element.

### Závislosti (target)

- Ostatní COMPy (kompozice): `COMP0020` Icon (`name="check"`, glyf ověřovací pečeti).
- Datové entity: `EN0005` Patron (current-state entita — jméno, role/label, avatar; viz část
  Current-state pro poznámku o vazbě samotné rekonstrukce; kanonický katalog nevyjmenovává vazbu na
  entitu na cílové straně nad rámec samotných propů).
- ACL: nic nedokumentováno.
- Externí knihovny: nic nedokumentováno (HTML komentáře je backend-sanitizováno před tím, než dorazí
  do komponenty; komponenta samotná nesanitizuje).

### Kompozice (target)

```
PatronCard
  └─ COMP0020 Icon (name="check"; verification seal, paired with sealLabel text)
```

### Token slots (target — kanonické CSS proměnné, viz `DESIGN-tokens.md`)

| Token | Role zde |
|---|---|
| `var(--color-surface)` | Povrchové pozadí karty |
| `var(--color-border)` | Obrys karty |
| `var(--radius-card)` | Zaoblení rohů karty |
| `var(--space-lg)`, `var(--space-md)` | Vnitřní rozestupy |
| `var(--font-body)` | Typografie těla komentáře |
| `var(--color-brand)`, `var(--color-brand-strong)` | Barva/barvy akcentu |
| `var(--font-display)` (+weight) | Display typografie jména/role |
| `var(--color-text)` | Primární text |
| `var(--color-muted)` | Sekundární text |
| `var(--color-success)` | Sémantická barva ověřovací pečeti (dokumentovaný use-case je "patron seal", podle `DESIGN-tokens.md` §3.1) |
| `var(--radius-pill)` | Provedení tvaru pečeti/pill (`Uncertain` — přesný subelement nevyjmenován) |

### Příklady (target)

```
<PatronCard initial="J" name="Jana Nováková" role="Patron příběhu"
  sealLabel="Ověřeno patronem" commentHtml="<p>...</p>" />
<PatronCard avatarUrl="/img/patron-organizace.jpg" name="Nadace XY" role="Organizace"
  sealLabel="Ověřeno" commentHtml="<p>...</p>" />  {/* "OrganizaceBezFotky" story variant per components.md */}
```

---

## Current-state (observed — rekonstruovaný current-state UX Patronusu)

> **STATE: CURRENT.** Vše v této části popisuje to, co bylo skutečně pozorováno na živém webu
> Patronusu, ze statické screenshotové evidence obrazovky detailu příběhu
> (`WIRE0002_StoryDetailAndDonationModal.md`, obrazovka `S002`). **Nepopisuje** cíl rebuildu výše.
> Podle `rules-COMP.md` se COMP vytváří pouze "když je znovupoužití pozorovatelné napříč dvěma nebo
> více WIRE obrazovkami/screenshoty" — tato podmínka **není splněna** pro kartu komentáře patrona v
> current-state evidenci (zachycena byla pouze jedna obrazovka detailu příběhu; viz tabulka Evidence).
> Tato current-state část je proto záměrně evidenčně slabá; je zde dokumentována **protože zadání
> instruuje povýšit kanonickou komponentu nyní**, ale samotný current-state nárok na znovupoužití
> zůstává `Uncertain`, konzistentně s tím, jak jej sám `WIRE0002` ponechal `inline`.

### Kde se to na živém webu dnes zobrazuje

- **`WIRE0002` — stránka detailu příběhu (`S002`), zóna "karta komentáře Patrona".** Záznam Layout
  Zones: *"Patron comment card — label 'PATRON PŘÍBĚHU', jméno/role Patrona (`EN0005`), avatar,
  přepínač/odkaz 'Zobrafit komentář Patrona', text těla komentáře."* (`WIRE0002` řádky 57–58).
  Umístěno přímo pod "Media zone" (foto hero), nad dlouhým textem "Story body", v levém/hlavním
  sloupci, vedle sidebaru s darem (`WIRE0002` ASCII layout, řádky 85–106).
- **Tabulka Components Used** (`WIRE0002` řádek 134): `Patron comment card | inline | avatar + name +
  role + toggle + body | binds EN0005`. Current-state rekonstrukce toto explicitně zaznamenala jako
  `inline` — tj. **nebylo** povýšeno na znovupoužitelný COMP během původního průchodu UX
  rekonstrukce, přesně to je mezera, kterou tento dokument nyní uzavírá na *cílové* straně (viz
  `_ar/evidence/design-system/components.md` §2 mapovací řádek: "PatronCard — GAP→recon — Kanonický
  PatronCard (avatar + verification seal + always-visible comment). Rekonstrukce ho měla jako inline
  (binds EN0005).").
- **Screenshotová evidence:** celostránkové zachycení obrazovky detailu příběhu,
  `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`
  (podle tabulky Evidence `WIRE0002`, řádek 292), zobrazující kartu komentáře patrona vedle titulku,
  media zóny, těla, sidebaru a důvěryhodnostního banneru.

### Pozorované current-state propy/chování

- **Label, jméno/role, avatar, tělo komentáře — vše pozorováno.** `WIRE0002` zaznamenává: "label
  'PATRON PŘÍBĚHU', jméno/role Patrona (`EN0005`), avatar, ... text těla komentáře" (řádek 57–58).
  Žádná ověřovací pečeť / badge typu "garantováno" není v current-state záznamu zachycena —
  `Uncertain`, zda existuje, ale nebyla odlišena od textu labelu, oproti tomu, že by skutečně chyběla;
  nepředpokládá se přítomnost.
- **Přepínač/odkaz "Zobrazit komentář Patrona" je pozorován** (`WIRE0002` řádek 58, a Interactions #6,
  řádek 172: *"Secondary action — přečtení komentáře patrona — kliknutí na 'Zobrazit komentář
  Patrona' → Assumed chování expand/scroll-to (label přepínače pozorován; expandovaný/collapsed stavy
  nebyly zachyceny oba) — Uncertain."*). Toto je current-state analogie cílového chování viditelnosti
  komentáře a je **strukturálně odlišné** — viz Current-vs-target divergence níže.
- **Mechanika expand/collapse přepínače: `Uncertain`.** `WIRE0002` explicitně nemohl potvrdit, zda se
  přepínač rozbaluje inline, scrolluje na obsah, nebo odkazuje jinam — zaznamenáno jako Open Question
  `WIRE0002-Q6` (řádek 284): *"Rozbaluje přepínač 'Zobrazit komentář Patrona' obsah, nebo odkazuje
  jinam?"*
- **Fallback avataru (bez fotky) vykreslení: `Uncertain`.** Žádná screenshotová evidence nezobrazuje
  kartu komentáře patrona bez fotky avataru; zda current Patronus vykresluje initial/monogram fallback
  (jako cílový stav) **není evidováno** v current sources.

### Current-state Varianty / Stavy / Události / Přístupnost

Podle evidenční disciplíny `rules-COMP.md` jsou nepozorované osy zaznamenány jako `Uncertain`, nikoli
vymyšlené:

- **Varianty:** `Uncertain — evidováno je pouze jedno vykreslení (jediné zachycení, jedna instance
  Patrona s fotografií avataru); neexistuje druhé zachycení detailu příběhu s jiným patronem nebo
  případem bez avataru, které by potvrdilo avatar-driven vizuální variantu v current-state Patronusu.`
- **Stavy (hover/focused/disabled/loading):** `Uncertain — nepozorovatelné ze statické evidence`,
  s výjimkou chování expand/collapse přepínače, které je samo `Uncertain` podle `WIRE0002-Q6` výše
  (interakce je odvozena, nikoli oba stavy zachyceny).
- **Error:** N/A / `Uncertain` — pro tuto zónu není dokumentováno žádné vykreslení chybového stavu.
- **Události:** `Assumed` — přepínač/odkaz "Zobrazit komentář Patrona" implikuje alespoň jednu
  uživatelem spouštěnou interakci (kliknutí → expandovat nebo navigovat), podle `WIRE0002` Interactions
  #6; přesný tvar události/payloadu není evidován (neproběhla žádná DOM/JS inspekce).
- **Přístupnost:** `Uncertain — žádná DOM/recording evidence, konzistentně s celkovým a11y postojem
  WIRE0002` (Accessibility Notes, řádky 261–271: pořadí tabulace, focus-on-entry a landmarky jsou pro
  tuto obrazovku jako celek všechny označeny Assumed/Uncertain).`

### Current-vs-target divergence (zaznamenat, nikoli "opravit")

Podle `_ar/evidence/design-system/components.md` §4 "Behavioral divergences worth flagging" a
`DESIGN-component-index.md` řádek 10 jde o zaznamenanou mezeru ke sladění, nikoli o defekt:

1. **Viditelnost komentáře — přepínač vs. vždy viditelné (hlavní divergence).** Current-state
   `WIRE0002` zobrazuje **přepínač/odkaz "Zobrazit komentář Patrona"**, který podmiňuje tělo komentáře
   (řádek 58; Interactions #6, řádek 172; Open Question `WIRE0002-Q6`, řádek 284). Cílový kontrakt
   `PatronCard` vyžaduje, aby byl komentář **vždy plně viditelný** — bez přepínače "zobrazit více"
   vůbec — jako explicitní transparentnostní invariant (`components.md` §1 "PatronCard" Účel:
   "comment always fully visible (no 'show more' toggle)"; §4: *"Patron comment visibility:
   reconstruction (WIRE0002) shows a 'Zobrazit komentář Patrona' toggle; canonical PatronCard mandates
   the comment is always fully visible (no toggle) as a transparency invariant. Genuine
   current→target behavior change."*). Toto je zaznamenáno jako **skutečná změna chování
   current→target**, nikoli chyba na kterékoli straně — současné chování přepínače není "chybné" a
   cílové pravidlo vždy viditelného komentáře zpětně nepopisuje, co Patronus dělá dnes.
2. **Ověřovací pečeť — pouze cíl, v current-state nepotvrzeno.** Žádný badge ověřovací pečeti /
   "garantováno" není zaznamenán v Layout Zones ani Components Used záznamech current-state zachycení
   (`WIRE0002` řádky 57–58, 134) — pouze label, jméno/role, avatar, přepínač a tělo komentáře. Zda má
   current Patronus jakýkoli vizuální ekvivalent cílové pečeti důvěry, je `Uncertain`, nikoli potvrzeno
   jako chybějící (může existovat, ale nebyl odlišen v průchodu rekonstrukce), a nesmí se předpokládat
   přítomnost jen proto, že ji má cílový kontrakt.
3. **Vlastnictví obsahu těla komentáře je v current-state nevyřešeno.** `WIRE0002` Data Bindings
   (řádek 240) uvádí: *"Patron comment card | EN0005 | — | Patron name/photo (EN0005 attributes);
   comment body text ownership (Patron vs. Application narrative) not confirmed — Uncertain."* Prop
   cílového kontraktu `commentHtml` (sanitizovaný backend WYSIWYG) neřeší tuto current-state otevřenou
   otázku, která entita ve skutečnosti vlastní text komentáře v dnešním Patronusu.
4. **Prahová hodnota znovupoužití není v current-state evidenci splněna.** Existuje pouze jedno
   zachycení obrazovky detailu příběhu (`S002`); `rules-COMP.md` vyžaduje znovupoužití napříč ≥2 WIRE
   obrazovkami/screenshoty před povýšením current-state COMP. Current-state "karta komentáře Patrona"
   proto na základě svých vlastních evidenčních zásluh zůstává jednoinstančním inline elementem — tato
   current-state část dokumentu tento fakt zaznamenává, místo aby jej přepisovala bohatším tvarem
   cílového kontraktu.

### Závislosti (current-state)

- Ostatní COMPy: žádné potvrzené jako komponované — current-state "karta komentáře Patrona" byla
  zaznamenána jako `inline` bez struktury podkomponent (`WIRE0002` Components Used, řádek 134).
- Datové entity: `EN0005` Patron — atributy jméno/fotka, podle `WIRE0002` Data Bindings: `"Patron
  comment card | EN0005 | — | Patron name/photo (EN0005 attributes); comment body text ownership
  (Patron vs. Application narrative) not confirmed — Uncertain"` (`WIRE0002` řádek 240). Viz také
  samotné `EN0005`: entita Patron je "pouze zobrazovací záznam, odlišný od *role* patrona, kterou nese
  User (`EN0008`), a od *kontaktních* údajů patrona nesených Contact (`EN0006`)" a obsahuje pouze
  `surname`, `first name`, `second surname` (duplikát — otevřená otázka v `EN0005`) a volitelnou
  `photo`; `EN0005` **nevyjmenovává** vlastní atribut těla komentáře, konzistentně s výše uvedenou
  nevyřešenou otázkou vlastnictví komentáře u `WIRE0002`.
- ACL: nic evidováno.
- Externí knihovny: nic evidováno.

### Kompozice (current-state)

```
Patron comment card (WIRE0002, S002) — current-state, inline
  ├─ "PATRON PŘÍBĚHU" label (static text)
  ├─ Patron avatar (photo; no-avatar fallback Uncertain)
  ├─ Patron name/role (binds EN0005)
  ├─ "Zobrazit komentář Patrona" toggle/link (expand/collapse mechanics Uncertain — WIRE0002-Q6)
  └─ comment body text (ownership vs. EN0005 vs. Application narrative Uncertain)
```

### Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Existence zóny karty komentáře Patrona na detailu příběhu | Confirmed | `WIRE0002` Layout Zones "Patron comment card" (řádky 57–58); `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png` |
| Kompozice label + jméno/role + avatar + přepínač + tělo | Confirmed | `WIRE0002` Components Used, řádek "Patron comment card" (řádek 134) |
| Přepínač existuje ("Zobrazit komentář Patrona") | Confirmed (label pozorován) | `WIRE0002` řádek 58, Interactions #6 (řádek 172) |
| Mechanika expand/collapse přepínače | Uncertain | `WIRE0002-Q6` Open Question (řádek 284): "toggle label observed; expanded/collapsed states not both captured" |
| Vlastnictví obsahu těla komentáře (Patron vs. Žádost) | Uncertain | `WIRE0002` Data Bindings, řádek 240 |
| Znovupoužití napříč ≥2 current-state obrazovkami (prahová hodnota pro povýšení na COMP) | Uncertain / nesplněno | zachycena pouze jedna obrazovka detailu příběhu (`S002`); pravidlo ≥2 obrazovek podle `rules-COMP.md` |
| Ověřovací pečeť / důvěryhodnostní badge (current-state) | Uncertain | nevyjmenováno v Layout Zones ani Components Used; může existovat, ale nebylo odlišeno, nebo skutečně chybí |
| Vykreslení fallbacku bez avataru (current-state) | Uncertain | žádné zachycení karty komentáře Patrona bez fotky avataru |
| Přístupnost (current-state) | Uncertain | žádná DOM evidence, konzistentně s celkovým a11y postojem `WIRE0002` (řádky 261–271) |
| Cílový kanonický kontrakt (propy/varianty/stavy/tokeny/a11y) | Confirmed (as target fact) | `_ar/evidence/design-system/components.md` §1 "PatronCard"; `DESIGN-component-index.md` řádek 10; zdroj `packages/ui/src/components/PatronCard/{PatronCard.tsx, PatronCard.contract.md, PatronCard.module.css}` |
| Dokumentovaný use-case tokenu `color.success` explicitně jmenuje "patron seal" | Confirmed (as target fact) | `_ar/spec-draft/DESIGN-tokens.md` §3.1: "`color.success` \| success/trust ('Vybráno' chip, patron seal) \| CZ `#149E6E` \| RO `#0FB5AE`" |

---

## Otevřené otázky

- Zda má current-state Patronus jakýkoli vizuální ekvivalent ověřovací pečeti cílového PatronCard —
  neřešitelné z existujících zachycení; k uzavření by bylo potřeba nového průchodu current-state
  screenshotů (ideálně expandovaného stavu přepínače).
- Co přepínač "Zobrazit komentář Patrona" skutečně dělá (inline rozbalení, scroll-to, nebo navigace)
  — nevyřešená current-state Open Question `WIRE0002-Q6`; pravidlo cílového kontraktu "vždy
  viditelné" na tuto otázku pro current-state Patronus neodpovídá.
- Kdo vlastní text těla komentáře v current Patronusu — samotná entita Patron (`EN0005`), nebo
  narativ Žádosti/Kampaně — označeno Uncertain ve `WIRE0002` Data Bindings (řádek 240) a nevyřešeno
  tímto povýšením.
- Zda current-state Patronus vykresluje jakýkoli initial/monogram fallback, když Patron nemá fotku —
  `Uncertain`, žádná evidence v obou směrech (zrcadlí ekvivalentní otevřenou otázku zaznamenanou pro
  osu foto/fallback `COMP0011` StoryHero).
