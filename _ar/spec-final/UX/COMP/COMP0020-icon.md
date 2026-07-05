---
doc_id: COMP0020
title: Icon
layer: COMP
spec_type: component
modules: []
status: imported
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Icon/
references:
  - WIRE0001
  - WIRE0002
  - COMP0018
  - COMP0016
  - COMP0017
  - COMP0019
  - EN0004
  - EN0005
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0020 – Icon

*(povýšeno z inline evidence; kanonická komponenta @patron/ui: Icon)*

## Účel

Tento dokument povyšuje **Icon**, kanonický `@patron/ui` **Atom**, podle instrukce v zadání ("tato
komponenta zůstala v rekonstrukci uvedena jen inline; povýšit ji nyní"). Obsahuje **dvě jasně
oddělené množiny faktů** dle projektové disciplíny current-vs-target:

- **Zarovnání s design systémem (target)** — autoritativní kanonický kontrakt pro `Icon`, jak je
  postavena v knihovně rebuildu `bid-patron-deti` (`packages/ui/src/components/Icon/`): piktogramový
  atom s dvojicí sad glyfů (line/filled), volenou podle tenantu přes CSS, dědící `currentColor`,
  skládaný do několika dalších kanonických Atomů/Blocků (`CategoryChip`, `TimeLeftPill`, `Brandmark`,
  `PatronCard`, `RailCta`, `SiteHeader`, `DonationBox`).
- **Current-state (observed)** — mnohá místa, kde byly piktogramy/ikony pozorovány inline na živém
  webu Patronus během current-state UX rekonstrukce (`WIRE0001`, `WIRE0002`); žádné z nich nebylo
  v té době povýšeno na samostatnou znovupoužitelnou COMP, protože current-state evidence
  neumožňovala stanovit jednu sdílenou ikonovou komponentu oproti per-kontextovým inline
  glyfům/emoji.

Tyto dvě části popisují **odlišné systémy** (target rebuildu vs. rekonstruovaný current Patronus)
a nesmí se slučovat do jednoho faktu. Podle `DESIGN-component-index.md` §2 target kontrakt této
komponenty neřeší ani "neopravuje" current-state nejednoznačnost — je zde zaznamenán samostatně,
podle řádku 3 indexu a `_ar/evidence/design-system/components.md` §1 "Icon".

Křížová reference: tento dokument se sesouhlasuje s `DESIGN-component-index.md` řádkem 3 a
`_ar/evidence/design-system/components.md` §1 "Icon". `Icon` **nemá** rekonstruovaný current-state
protějšek COMP dle `DESIGN-component-index.md` §2/§3 — ikony zůstaly v current-state WIRE
rekonstrukci uvedeny jen `inline`.

---

## Zarovnání s design systémem (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Vše v této části popisuje kanonickou komponentu rebuildu
> (`packages/ui/src/components/Icon/`), nikoli current-state chování Patronus. Autoritativní zdroj:
> `_ar/evidence/design-system/components.md` §1 "Icon" a `DESIGN-component-index.md` řádek 3.

### Účel (target)

Piktogramový atom vykreslující jeden z pevné množiny pojmenovaných glyfů. Komponenta dodává
**dvojici sad glyfů** — grafiku ve stylu line a stylu filled pro každé `name` — a aktivní sada je
volena zcela přes CSS (přepínání `display` pod `[data-theme]`), nikoli propem. Vykreslený glyf dědí
`currentColor`, takže jeho viditelná barva je plně řízena konzumující komponentou/kontextem (žádný
color prop, žádný barevný token spotřebovaný interně).

### Props / vstupy (target)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `name` | `IconName` (`"development" \| "health" \| "subsistence" \| "clock" \| "check" \| "arrow" \| "heart" \| "give" \| "user"`) | yes | — | Volí, který glyf se vykreslí. Pevný enum — žádné libovolné/vlastní názvy ikon. |
| `size` | `number` (px) | no | `20` | Velikost vykresleného glyfu v pixelech. |

Exportované typy: `IconProps`, `IconName` (dle `components.md` §1 "Icon").

### Varianty (target)

- **styl glyfu:** LINE (CZ výchozí) | FILLED (RO) — volen pomocí `[data-theme]` v CSS, **nikoli**
  propem na `IconProps`. *Styl* glyfu je záležitostí tématu, shodně jako u `Brandmark`
  (`COMP0019`) a tvaru `radius.icon` (kruh CZ / squircle RO), které jsou řízeny tématem, nikoli
  propem.
- **velikost:** libovolná hodnota `size` v px; žádný diskrétní enum velikostních variant (volná
  hodnota v pixelech, výchozí `20`).

### Stavy (target)

#### idle
Výchozí a jediný stav — statické vykreslení glyfu. Součástí kontraktu není žádná interakční
afordance.

#### hover
N/A — `Icon` sám nedefinuje žádné ošetření hoveru; podle `components.md` §1 je barva ikony
reagující na hover (např. glyfy `ShareRow` přebírající při hoveru `color.action`) implementována
CSS **skládající** komponenty, nikoli komponentou `Icon`.

#### focused
N/A — `Icon` není samostatně zaměřitelný (focusable); nenese žádnou vlastní ARIA roli ani tabindex
(viz Přístupnost níže).

#### disabled
N/A — vykreslení ve stavu disabled není součástí kanonického kontraktu; `Icon` je čistě
prezentační leaf, nikoli ovládací prvek.

#### loading
N/A — v kanonickém katalogu není uveden; žádný skeleton/loading stav.

#### error
N/A — unie `name` je uzavřený enum; žádné dokumentované záložní vykreslení pro "neznámou ikonu"
neexistuje.

### Události (target)

Žádné vysílané události — `Icon` je čistě prezentační Atom bez dokumentovaných callback propů
(`IconProps` dle `components.md` §1 uvádí pouze `name` a `size`).

### Přístupnost (target)

- **ARIA role:** žádná vlastní — komponenta je **ve výchozím stavu dekorativní**: nenese žádnou
  vestavěnou `role` ani vlastní accessible name/label.
- **Odpovědnost konzumující komponenty:** dle poznámek k A11y v `DESIGN-component-index.md` řádku 3,
  "konzumující komponenta musí dodat `aria-label`, pokud je to smysluplné" — tj. pokud je instance
  `Icon` *jediným* nositelem významu (bez doprovodného viditelného textu), za doplnění accessible
  name odpovídá skládající komponenta (např. prop `label` u `CategoryChip` nese accessible name pro
  jí složenou instanci `Icon`, dle `DESIGN-component-index.md` řádku 5).
- **Klávesová navigace:** N/A — nezaměřitelný (not focusable).
- **Správa focusu:** N/A — žádné vlastní ošetření focus-visible.
- **Čtečka obrazovky:** ve výchozím stavu je instance `Icon` pro čtečky obrazovky nevi­ditelná
  (dekorativní); zda je oznámena, závisí zcela na vlastním kontraktu přístupnosti skládající
  komponenty, nikoli na samotné komponentě `Icon`.

### Chování dle tenantu (target — CZ/RO přes `data-theme`)

- **Styl glyfu (line vs. filled) je řízen tématem, nikoli propem:** CZ (`data-theme="cz"`)
  vykresluje grafiku LINE; RO (`data-theme="ro"`) vykresluje grafiku FILLED, přepínáno čistě CSS
  pravidly `display` — obě sady glyfů existují v DOM/markupu současně a CSS vybírá tu aktivní
  (stejný vzor "obě současně v DOM" jako u `Brandmark`, `COMP0019`).
- **Interně nespotřebovává žádné barevné tokeny:** `Icon` sám nečte žádný slot `var(--color-…)` —
  dědí `currentColor` od svého kontejneru, takže barvu vykreslení pro daný tenant určuje vlastní
  použití tokenů *skládající* komponenty (např. `--color-category-*` u `CategoryChip`,
  `--color-muted`/`--color-action` u `SiteHeader`). Pro `Icon` samotný tedy neexistuje žádná
  tabulka tokenů vázaných na tenanta (viz Sloty tokenů níže — "žádné").
- **Velikost je tématu neutrální:** prop `size` a jeho výchozí hodnota `20`px platí shodně jak pod
  `data-theme="cz"`, tak pod `data-theme="ro"`.

### Omezení použití (target)

- Použít, když: komponenta potřebuje jeden z devíti pevných piktogramů (`development`, `health`,
  `subsistence`, `clock`, `check`, `arrow`, `heart`, `give`, `user`) v řízené velikosti, dědící
  textovou barvu volajícího.
- Nepoužívat, když: je potřeba vlastní/libovolný glyf mimo uzavřený enum `IconName` — kanonický
  katalog nedokumentuje žádný únikový mechanismus (např. libovolné SVG passthrough) pro `Icon`.
- Kardinalita: mnoho instancí na obrazovku; opakovaně skládán napříč knihovnou (viz Kompozice).
- Umístění: vždy jako leaf uvnitř skládající komponenty (`CategoryChip`, `TimeLeftPill`,
  `Brandmark`, `PatronCard`, `RailCta`, `SiteHeader`, `DonationBox`) — nikdy sám jako nejvzdálenější
  element obrazovkové oblasti dle katalogizovaných kompozic.

### Závislosti (target)

- Jiné COMP (kompozice): žádné — `Icon` je čistý leaf; nic nekombinuje.
- Datové entity: žádné — čistě prezentační, žádné entitně typované propy.
- ACL: žádné dokumentované.
- Externí knihovny: žádné dokumentované (čistě inline/vložené SVG dle `components.md` §1 "pure SVG").

### Kompozice (target)

`Icon` je komponenta typu **leaf**. Je sama skládána do, dle `_ar/evidence/design-system/components.md`
§1 a `DESIGN-component-index.md`:

| Skládající komponenta | použité `name` | Doc_id |
|---|---|---|
| `CategoryChip` | odpovídající kategorii (`development`\|`health`\|`subsistence`), size 15 | `COMP0018` |
| `TimeLeftPill` | `clock`, size 15 | `COMP0017` |
| `Brandmark` | `give` (CZ symbol) | `COMP0019` |
| `PatronCard` | `check` (verifikační pečeť) | *(pouze target Block, dosud bez rekonstruované COMP — `COMP0012` dle indexu)* |
| `RailCta` | `arrow` | *(pouze target Block, dosud bez rekonstruované COMP — `COMP0014` dle indexu)* |
| `SiteHeader` | `user` | `COMP0002` |
| `DonationBox` | `check`, `give` | *(pouze target Block, dosud bez rekonstruované COMP — `COMP0010` dle indexu)* |

```
Icon (canonical, target)
  (leaf — no sub-components; consumed by CategoryChip, TimeLeftPill, Brandmark,
   PatronCard, RailCta, SiteHeader, DonationBox)
```

### Sloty tokenů (target — kanonické CSS proměnné, viz `DESIGN-tokens.md`)

| Token | Role zde |
|---|---|
| *(žádný)* | `Icon` **nespotřebovává** žádný vlastní slot `var(--color-…)`/`var(--space-…)`/`var(--radius-…)` — dle `DESIGN-component-index.md` řádku 3 "Sloty tokenů: žádné (používá `currentColor`; CSS `display` přepíná sadu glyfů)". Barva a jakékoli okolní rozměry/odsazení jsou zcela v odpovědnosti skládající komponenty. |

Poznámka: *dlaždice* (tile), která ikonu někdy vizuálně obklopuje (např. `radius.icon`, tenantem
vázaný kruh CZ / squircle RO, dle `DESIGN-tokens.md` §6/§7), je token vlastněný **skládající**
komponentou (např. `Brandmark`), nikoli samotnou komponentou `Icon` — `Icon` vykresluje jen glyf.

### Příklady (target)

```
<Icon name="clock" size={15} />          {/* composed inside TimeLeftPill */}
<Icon name="check" />                     {/* composed inside PatronCard verification seal */}
<Icon name="give" />                      {/* composed inside Brandmark, CZ symbol */}
<Icon name="development" size={15} />    {/* composed inside CategoryChip */}
```

---

## Current-state (observed — rekonstruovaný current-state UX Patronus)

> **STATE: CURRENT.** Vše v této části popisuje to, co bylo skutečně pozorováno na živém webu
> Patronus, z evidence statických snímků zachycených během current-state UX rekonstrukce
> (`WIRE0001_HomepageStoryCatalogue.md`, `WIRE0002_StoryDetailAndDonationModal.md`). **Nepopisuje**
> target rebuildu uvedený výše. Podle `rules-COMP.md` se COMP vytváří pouze "když je opakované
> použití pozorovatelné napříč dvěma nebo více WIRE obrazovkami/snímky" — piktogramy/ikony byly
> opakovaně pozorovány napříč **oběma** zachycenými WIRE obrazovkami, ale current-state evidence
> nikdy nestanovuje, že jde o jednu sdílenou, samostatně znovupoužitelnou komponentu oproti
> množině nesouvisejících per-kontextových inline glyfů (nativní emoji, badge ikony, kategoriové
> ikony, ikony sociálních sítí). Tato current-state část je proto záměrně evidenčně tenká: inventarizuje
> *kde* byly ikonám podobné elementy pozorovány, aniž by tvrdila, že sdílejí jednu podkladovou
> implementaci.

### Kde se dnes objevuje na živém webu

Piktogramům podobné prvky byly zaznamenány, vždy `inline`, na následujících current-state
místech:

- **`WIRE0001` — Domovská stránka/Katalog (`S001`):**
  - Karta příběhu — badge s ikonou kategorie na každé kartě v katalogu (`WIRE0001` řádek 90: "každá:
    badge s ikonou kategorie, fotka, …").
  - Navigace v hlavičce — položka "Můj účet" vykreslená jako ikona+label (`WIRE0001` řádek 83:
    `"Můj účet" (icon+label)`).
  - Vysvětlující blok "Jak to funguje?" o 3 sloupcích — jedna ikona na sloupec vedle titulku a textu
    (`WIRE0001` řádky 67, 103).
  - Karta příběhu — malá ikona badge patrona v rohu karty, "pokud je přítomna" (`WIRE0001` řádek
    252) — přítomnost ikony Confirmed dle snímků; samotná vazba badge → profil patrona je pouze
    Probable (odvozeno z Actors v `UC0023`, nikoli potvrzený samostatný klikatelný element v
    evidenci).
- **`WIRE0002` — Detail příběhu (`S002`):**
  - Kategoriový štítek ("Rozvoj a vzdělání") vykreslený **s ikonou**, uvnitř postranního panelu
    daru (`WIRE0002` řádek 64).
  - Ilustrativní ikona (batoh) jinde na stránce (`WIRE0002` řádek 66).
  - CTA voucheru "Mám dobrošek" — červené tlačítko nesoucí ikonu lístku (`WIRE0002` řádek 73, řádek
    140).
  - Řádek se sdílením — ikony Facebook / X / Instagram / LinkedIn / WhatsApp / Messenger, jedna na
    síť (`WIRE0002` řádek 74, řádek 141: "řádek ikonových tlačítek… žádné sdílecí chování nebylo
    pozorováno nad přítomnost ikony").
  - Karta komentáře patrona — text "Přispět můžete na" doprovázený ikonou (`WIRE0002` řádek 92).
  - Primární CTA k darování — vykresleno s piktogramem podání rukou ("Přispět 🤝"), zaznamenáno
    v rekonstruované evidenci doslova jako znak emoji, nikoli potvrzeno jako komponenta SVG ikony
    (`WIRE0002` řádek 138).
- **Evidence snímků:** `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`
  (katalog); `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`
  (detail příběhu), dle příslušných tabulek Evidence ve WIRE dokumentech.

### Pozorované current-state props/chování

- **Nepotvrzena žádná jednotná implementace.** Rekonstruovaná evidence zaznamenává ikony jako
  opakující se *vizuální vzor* (kategoriové badge, ikona+label v navigaci, vysvětlující ikony,
  ikona lístku, ikony sociálních sítí, verifikační/pozdravné glyfy) napříč mnoha nesouvisejícími
  oblastmi obrazovky, ale ani `WIRE0001`, ani `WIRE0002` netvrdí, že sdílejí jednu podkladovou
  znovupoužitelnou komponentu — každá byla zaznamenána `inline` v místě svého použití.
- **Alespoň jedna instance je doslovné emoji, nikoli nutně glyf typu icon-font/SVG.** Primární CTA
  k darování je zaznamenáno jako `"Přispět 🤝"` (`WIRE0002` řádek 138) — znak Unicode emoji vložený
  do textu tlačítka, druhově odlišný od piktogramu typu SVG/icon-font. Toto je konkrétní signál, že
  current-state "ikony" **nejsou jednotné svou implementací** — některé pozorované glyfy mohou být
  prostý text/emoji, nikoli vůbec vyhrazená ikonová komponenta. Nepředpokládat, že všechny výše
  inventarizované instance jsou stejným druhem artefaktu.
- **Pevná sada glyfů: `Uncertain`.** Zda current-state Patronus čerpá z pevné, uzavřené sady glyfů
  (jako target enum `IconName`) nebo vykresluje libovolné/ad hoc ikony podle kontextu (podmnožina
  icon fontu, inline SVG podle modulu, tématem dodávaný sprite atd.) není podloženo evidencí —
  v rámci této rekonstrukce ze statických snímků neproběhla žádná inspekce zdrojového DOM/CSS.
- **Styl line vs. filled / variace dle tenantu: `Uncertain`.** Current-state evidence je pouze
  pro CZ (`patrondeti.cz`); neexistuje žádný snímek RO (`kidshero.ro` nebo rovnocenné current-state
  RO rozhraní), který by umožnil srovnat styl ikon mezi tenanty.

### Current-state varianty / stavy / události / přístupnost

Podle evidenční disciplíny `rules-COMP.md` jsou nepozorované osy zaznamenány jako `Uncertain`,
nikoli vymyšlené:

- **Varianty:** `Uncertain — v current-state Patronus není evidence žádné osy stylu line/filled ani jiné stylistické varianty; každá inventarizovaná instance byla zachycena jednou, v jednom vizuálním provedení.`
- **Stavy (hover/focused/disabled/loading/error):** `Uncertain — nelze pozorovat ze statické evidence`, s výjimkou míst, kde ikona sedí uvnitř jinak interaktivního elementu (např. ikonová tlačítka v řádku sdílení, CTA "Mám dobrošek", primární CTA k darování) — v těchto případech je jakékoli hover/focus chování přisouzeno *skládajícímu ovládacímu prvku*, nikoli potvrzeně samotnému glyfu ikony.
- **Události:** Žádné události nejsou vysílány samotnými ikonami v žádné inventarizované instanci; kde ikony sedí uvnitř klikatelných elementů (tlačítka v řádku sdílení, CTA), chování kliknutí/navigace je zaznamenáno na úrovni WIRE/UC vůči skládajícímu elementu, nikoli vůči ikoně.
- **Přístupnost:** `Uncertain — pro žádnou inventarizovanou instanci není evidence z DOM/záznamu`, v souladu s celkovým postojem k a11y v obou WIRE dokumentech (`WIRE0002` řádek 141 explicitně uvádí "žádné sdílecí chování nebylo pozorováno nad přítomnost ikony" — tj. chybí i funkční potvrzení, nemluvě o potvrzení accessible name, pro řádek sdílení).

### Rozdíl current vs. target (zaznamenat, nikoli "opravovat")

Podle `_ar/evidence/design-system/components.md` §2 a `DESIGN-component-index.md` §3 nemá `Icon`
žádnou mapovanou rekonstruovanou current-state COMP — nebyla nikdy povýšena během původního
průchodu UX rekonstrukce. To je samo o sobě hlavní rozdíl, který je třeba zaznamenat:

1. **Nepotvrzena žádná sdílená current-state komponenta.** Target kontrakt je jediný Atom
   s uzavřeným enumem (`IconName`, 9 hodnot) znovupoužívaný 7 dalšími kanonickými komponentami.
   Current-state evidence ukazuje *vizuální vzor* ikon opakující se napříč mnoha oblastmi
   obrazovky, ale nikdy nepotvrzuje jednu podkladovou implementaci — může se stejně dobře jednat
   o několik nesouvisejících per-modulových icon fontů, inline SVG nebo prostých emoji/textových
   glyfů (instance "🤝" je přímým důkazem alespoň jednoho případu, který není SVG ikonou). Berte
   target koncept "jeden atom Icon, dvojice sad glyfů" pouze jako target záměr.
2. **Nepozorován žádný uzavřený enum glyfů.** Target uzavřená sada 9 názvů (`development`,
   `health`, `subsistence`, `clock`, `check`, `arrow`, `heart`, `give`, `user`) nemá potvrzený
   current-state protějšek; pozorované current-state ikonové subjekty (kategoriový badge,
   navigace/účet, témata vysvětlovače, lístek, 6 sociálních sítí, podání rukou, badge patrona) se
   s target názvy překrývají pouze částečně (kategorie a možná "check"/blízko verifikaci) a jinak
   se rozcházejí (lístek, sociální sítě, emoji podání rukou nemají target `IconName` protějšek,
   a naopak — `arrow`/`heart`/`user` nebyly pozorovány jako samostatné current-state ikonové
   subjekty).
3. **Nepozorována žádná osa stylu line/filled dle tenantu.** Current-state evidence je pouze pro
   jeden tenant (CZ) bez srovnávacího rozhraní; target přepínač LINE(CZ)/FILLED(RO) přes
   `data-theme` nelze proti current Patronus potvrdit.
4. **Práh opakovaného použití není jednoznačně splněn.** `rules-COMP.md` požaduje "opakované
   použití pozorovatelné napříč dvěma nebo více WIRE obrazovkami" před povýšením current-state
   COMP. Elementy *podobné ikonám* se skutečně opakují napříč `WIRE0001` a `WIRE0002` (≥2
   obrazovky), ale dle bodu 1 výše není opakování *vizuálního vzoru* "zde se objevuje ikona"
   stejným evidenčním tvrzením jako opakování *jedné znovupoužitelné komponenty* — to druhé, na
   čem `rules-COMP.md` skutečně staví podmínku, zůstává `Uncertain`. To je důvod, proč nebyla
   žádná current-state COMP Icon povýšena během původní rekonstrukce, a proč je toto povýšení
   explicitně povýšením na **straně targetu**, nikoli retroaktivním current-state povýšením.

### Závislosti (current-state)

- Jiné COMP: žádné potvrzené — každá inventarizovaná instance byla zaznamenána `inline` uvnitř
  vlastní WIRE oblasti obrazovky (badge kategorie na `COMP0008` StoryCard dle `WIRE0001`; různé
  inline elementy dle `WIRE0002`), nikdy jako křížově odkazovaná sdílená COMP.
- Datové entity: `EN0004` Campaign (kategorie, dle instancí badge s ikonou kategorie) a `EN0005`
  Patron (dle instance badge patrona, `WIRE0001` řádek 252 — pouze Probable vazba, dle vlastního
  označení jistoty toho řádku).
- ACL: žádné podložené.
- Externí knihovny: žádné podložené (neproběhla žádná inspekce DOM/zdroje; původ icon font vs. SVG
  vs. emoji je pro každou instanci nepotvrzen, viz výše).

### Kompozice (current-state)

```
(no confirmed shared current-state Icon component)
  ├─ Story card category icon badge (WIRE0001, inline within COMP0008 StoryCard)
  ├─ Header "Můj účet" icon+label (WIRE0001, inline within COMP0002 GlobalHeader)
  ├─ "Jak to funguje?" explainer icons ×3 (WIRE0001, inline)
  ├─ Story card Patron badge icon (WIRE0001, inline; Probable EN0005 linkage)
  ├─ Category tag icon in donation sidebar (WIRE0002, inline)
  ├─ Illustrative "backpack" icon (WIRE0002, inline)
  ├─ Voucher CTA ticket icon (WIRE0002, inline)
  ├─ Share row network icons ×6 (WIRE0002, inline)
  ├─ Patron comment card icon (WIRE0002, inline)
  └─ Primary donate CTA "🤝" emoji glyph (WIRE0002, inline — confirmed non-SVG instance)
```

### Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Piktogramům podobné ikony se opakují napříč ≥2 current-state obrazovkami | Confirmed | `WIRE0001` řádky 67, 83, 90, 103, 252; `WIRE0002` řádky 64, 66, 73–74, 92, 138, 140–141 |
| Badge s ikonou kategorie na kartách katalogu | Confirmed | `WIRE0001` řádek 90; `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` |
| Ikona+label "Můj účet" v hlavičce | Confirmed | `WIRE0001` řádek 83 |
| Ikona badge patrona na kartě (vazba na EN0005) | Confirmed (ikona) / Probable (vazba) | `WIRE0001` řádek 252 |
| Ikona kategoriového štítku v postranním panelu daru | Confirmed | `WIRE0002` řádek 64; `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png` |
| Ikony ×6 sítí v řádku sdílení | Confirmed (pouze přítomnost, žádné chování) | `WIRE0002` řádek 74, 141 |
| Primární CTA vykresleno jako doslovné emoji, nepotvrzena SVG ikona | Confirmed | `WIRE0002` řádek 138 |
| Jediná sdílená znovupoužitelná current-state komponenta Icon | Uncertain / nestanoveno | pro ikony nebyla v původní rekonstrukci povýšena žádná COMP; `DESIGN-component-index.md` §2/§3 potvrzuje, že žádná mapovaná current-state COMP neexistuje |
| Uzavřený enum glyfů odpovídající target `IconName` | Uncertain | current-state ikonové subjekty se s target sadou 9 názvů překrývají jen částečně; neproběhla žádná inspekce zdroje/DOM |
| Osa stylu dle tenantu (line/filled) | Uncertain | current-state evidence je pouze pro CZ, bez srovnávacího RO rozhraní |
| Přístupnost (jakákoli instance) | Uncertain | pro žádnou inventarizovanou instanci není evidence z DOM/záznamu |
| Kanonický kontrakt targetu (props/varianty/stavy/tokeny/a11y) | Confirmed (jako target fakt) | `_ar/evidence/design-system/components.md` §1 "Icon"; `DESIGN-component-index.md` řádek 3; zdroj `packages/ui/src/components/Icon/{Icon.tsx, Icon.contract.md, Icon.module.css}` |

---

## Open Questions

- Zda current-state Patronus implementuje kterýkoli z inventarizovaných ikonám podobných elementů
  prostřednictvím jedné sdílené komponenty (icon font, sprite, nebo sdílený SVG wrapper) oproti
  zcela nezávislému per-modulovému markupu — nelze rozřešit ze statických snímků; vyžadovalo by to
  inspekci zdroje/DOM v `intake/current-solution/_source/patronus/` (mimo evidenční rozsah tohoto
  dokumentu, jak je napsán), aby bylo možné otázku uzavřít.
- Zda je glyf primárního CTA "Přispět 🤝" reprezentativní (tj. current-state ikony jsou obecně
  založené na emoji/textu) nebo jde o izolovaný případ vedle jinak SVG/icon-font piktogramů jinde
  — `Uncertain`, byla zaznamenána pouze jedna instance doslovného emoji.
- Zda má current-state Patronus jakékoli RO-tenant rozhraní se srovnatelnou sadou ikon, a pokud
  ano, zda vykazuje stylistické rozlišení line/filled obdobné target přepínači `data-theme`
  — v aktuální sadě evidence neexistuje žádná RO current-state evidence.
- Zda target uzavřený enum 9 názvů `IconName` má být zamýšlen jako superset, subset nebo prosté
  nahrazení ad hoc pozorovaných current-state ikonových subjektů (lístek, sociální sítě, podání
  rukou, batoh, "Můj účet" nemají přímý target-name protějšek) — to je rozhodnutí návrhu rebuildu,
  nelze je rozřešit z current-state evidence, a je zde vlajkováno pro informaci týmu rebuildu,
  nikoli zodpovězeno.

---

## Source references

**Target:** `DESIGN-component-index.md` řádek 3 (tabulka Index); plný katalogový záznam
`_ar/evidence/design-system/components.md` §1 "Icon" a mapování v §2–§4; poznámka ke slotu tokenu
`DESIGN-tokens.md` (žádný vyhrazený token vlastněný komponentou Icon — viz Sloty tokenů výše).
Kanonická zdrojová cesta:
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Icon/`
(`Icon.tsx`, `Icon.stories.tsx`, `Icon.module.css`, `Icon.contract.md`, `index.ts`).

**Current-state:** `_ar/spec-draft/WIRE/WIRE0001_HomepageStoryCatalogue.md` (řádky 67, 83, 90, 103,
139, 252, 265); `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` (řádky 64, 66, 73–74,
92, 138, 140–141, 264); snímky
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
`_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`.
