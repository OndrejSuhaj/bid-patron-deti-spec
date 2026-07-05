# Zpráva o sesouhlasení design systému — COMP/WIRE ↔ kanonická redesign knihovna

> **Účel.** Zaznamenává, co bylo sesouhlaseno mezi rekonstruovanou current-state UX vrstvou komponent
> (`_ar/spec-draft/COMP/`, `_ar/spec-draft/WIRE/`) a kanonickým design systémem pro rebuild
> `bid-patron-deti` (`packages/ui`, `docs/design/`), na základě zjištění v
> `_ar/evidence/design-system/components.md` a `_ar/evidence/design-system/design-canon.md`.
>
> **Disciplína (dle projektové konstituce).** Kanonická redesign knihovna je **target state**, obdobně
> autoritativní jako `it-zadani` — popisuje, co `bid-patron-deti` staví, nikoli co Patronus dělá dnes.
> Rekonstruovaná vrstva COMP/WIRE zůstává **current-state** pravdou, ukotvenou na statické UI evidenci
> (`_ar/evidence/ui/**`). Sesouhlasení sjednocuje názvy, povyšuje komponenty, které current-state vrstva
> nedostatečně modelovala, a zaznamenává divergence — **ne**přepisuje current-state fakta směrem k cíli
> a **ne**importuje cílové nároky jako current-state fakt.
>
> Autor: AR discovery/reconciliation pass · datováno **2026-07-05** · nekomitováno (write scope je pouze
> `_ar/spec-draft/DESIGN-reconciliation-report.md`; dle instrukce úkolu se nekomituje).

---

## 1. Co toto sesouhlasení přineslo

Jako kotevní body sesouhlasení byly ustanoveny dva kanonické referenční artefakty:

- **`DESIGN-tokens.md`** — sémantický model tokenů používaný napříč kanonickou knihovnou komponent
  (barva/rozestupy/typografie/radius/stín/layout sloty; tenant-vázané vs. sdílené dimenze; konkrétní
  CZ/RO hodnoty). Umožňuje, aby jakákoli COMP smlouva citovala token slot místo opakování hodnoty.
- **`DESIGN-component-index.md`** — kanonický katalog komponent (7 Atoms + 9 Blocks + 1 Page =
  17 jednotek), každá s účelem, props, variantami/stavy, spotřebovávanými tokeny a kompozicí — zdroj
  pravdy sesouhlasení pro „co cílová komponenta ve skutečnosti je".

Obě jsou **target-state referencemi** (analogicky autoritě `it-zadani` pro „co se má stavět"), udržované
odděleně od current-state COMP smluv, které informují.

---

## 2. Přejmenování COMP (sjednocení názvů, current-state smlouva zachována)

Tři již rekonstruované COMP jsou **stejný koncept** jako kanonická komponenta pod **jiným názvem**.
Obsah rekonstruované smlouvy (current-state pozorování, Open Questions) je zachován; sjednocuje se pouze
název/křížová reference na kanonický název pro budoucí čtenáře.

| Rekonstruovaný COMP | Current-state název | Kanonický název | Poznámka |
|---|---|---|---|
| COMP0001 | PrimaryButton | **Button** | Kanonický `Button` formalizuje osu `variant` (primary/secondary/ghost) + `size` (md/lg) + `block`. Tím se řeší obě Open Questions COMP0001: nepovýšené „secondary/zelené tlačítko" = `variant="secondary"/"ghost"`; „full-width Uncertain" = `block`. Řešení je zaznamenáno jako target evidence, nikoli zpětně promítnuto do current-state pozorování (jen vyplněný červený idle stav zůstává `Confirmed` current-state). |
| COMP0002 | GlobalHeader | **SiteHeader** | Kanonická verze doplňuje explicitní stav mobilního hamburgeru a řeší identitu tlačítka „Požádat o pomoc" jako Open Question: jde o ghost `Button`. |
| COMP0003 | GlobalFooter | **SiteFooter** | Kanonický footer je plně prop-driven, s pevnou strukturou. Open Question `promoSlot` u COMP0003 (WIRE0014 promo pás) **nemá** kanonický protějšek — cílová strana ji řeší jako „nejde o obecnou schopnost" (viz §6 otevřené body). |

## 3. Sesouhlasení StoryCard (COMP0008)

COMP0008 **StoryCard** je jediný případ **shody podle názvu** — stejný koncept, stejný název na obou
stranách. Sesouhlasení sjednocuje jeho *kompozici*: kanonický `StoryCard` je explicitně `CategoryChip` +
`ProgressBar`, barva řízená kategorií, s fallbackem na monogram; **nemá** lifecycle variantu „completed".
Current-state rozdělení COMP0008 na active/completed zůstává tak, jak je — je to **current-state
pozorování**, nikoli kanonická osa, a je zaznamenáno jako takové, nikoli zahozeno.

## 4. Dvanáct povýšených COMP (COMP0010–COMP0021)

Dvanáct kanonických komponent nemělo **žádný** rekonstruovaný COMP protějšek — existovaly pouze jako
vložené řádky/text uvnitř WIRE0002 (nebo, u chrome atomů, uvnitř COMP0002/COMP0003). Každá je nyní
povýšena do vlastního COMP souboru, čímž se current-state dokumentace sesouhlasí s reálnou hranicí
komponenty:

| Nový COMP | Kanonická komponenta | Byl vložen v |
|---|---|---|
| COMP0010 | DonationBox | WIRE0002 sidebar („Progress block", „Amount input", CTA „Přispět 🤝", řádky recurring/voucher) — **nejvyšší priorita mezery**; šest rozptýlených řádků je jeden blok se stavy `live/urgent/funded` |
| COMP0011 | StoryHero | WIRE0002 „Media zone" |
| COMP0012 | PatronCard | WIRE0002 „karta komentáře patrona" |
| COMP0013 | PledgeStrip | WIRE0002 „trust banner" |
| COMP0014 | RailCta | WIRE0002 CTA „Chci podporovat pravidelně" / „Mám dobrošek" |
| COMP0015 | ShareRow | WIRE0002 řádek ikon sociálních sítí |
| COMP0016 | ProgressBar | vloženo v COMP0008 + WIRE0002 sidebar |
| COMP0017 | TimeLeftPill | páska „ZBÝVÁ …" vložená v COMP0008 / WIRE0002 „Zbývá měsíc" |
| COMP0018 | CategoryChip | pilulka kategorie/tagu, dříve zamítnutá pro povýšení (jen 1 WIRE-evidovaná obrazovka) |
| COMP0019 | Brandmark | zahrnuto v chrome COMP0002/COMP0003 |
| COMP0020 | Icon | glyfy zpracovávané jako vložená dekorace ve všech WIRE |
| COMP0021 | Input | „obecný textový input", záměrně nepovýšený primitiv (nízká priorita; obě strany jej považují za primitiv) |

Každý povýšený COMP je zapsán proti **current-state WIRE evidenci** pro skutečně pozorovanou
anatomii/chování, s křížovou referencí na kanonickou komponentu pouze pro objasnění
názvu/hranice — nikoli s importem kanonických props nebo stavů jako current-state faktu.

## 5. Pět current-only COMP (bez kanonického protějšku)

Pět rekonstruovaných COMP **nemá** kanonickou komponentu — redesign knihovna je buď nemá v rozsahu,
nebo je ještě nepostavila:

| COMP | Proč chybí v kánonu | Klasifikace |
|---|---|---|
| COMP0004 CookieConsentBanner | Není v rozsahu `packages/ui` (záležitost app-shell/consent-platform) | Redesign nemá (mimo rozsah knihovny) |
| COMP0005 WizardStepper | Knihovna kryje jen storefront + detail příběhu; wizard pro podání žádosti nepostaven | Redesign zatím nepostaveno |
| COMP0006 ConsentCheckbox | Modál daru (e-mail + souhlasy) explicitně odložen jako budoucí blok ve smlouvách `DonationBox`/`StoryDetail` | Redesign **odloženo** (jmenovaný budoucí rozsah) |
| COMP0007 FileUploadDropzone | Patří k nepostaveným wizard/account plochám | Redesign zatím nepostaveno |
| COMP0009 EmailEntryForm | Atomy (`Input`+`Button`) existují; kompozit pro autentizaci a plocha autentizace nepostaveny | Redesign zatím nepostaveno (atomy existují) |

Tyto zůstávají jako **current-state-only** COMP; kromě výše uvedené poznámky k nim nebyla přidána žádná
kanonická referencia, protože na cílové straně na co sesouhlasit ještě nic není.

## 6. Kanonická kompozice WIRE0002 a divergence

WIRE0002 (detail příběhu + modál daru) je **jediná** rekonstruovaná obrazovka s kanonickým redesign
protějškem — stránka `StoryDetail` (E0001, `Done`). Sesouhlasení kompozice:

- Kanonická anatomie: `SiteHeader` → breadcrumb → H1 → **hlavní sloupec** (`StoryHero` → lede →
  `PatronCard` → prose) + **sticky pravý rail** (`DonationBox` → `RailCta` recurring → `RailCta`
  promo, jen CZ → `ShareRow`) → full-width divider `PledgeStrip` (přítomný v každém stavu) →
  mřížka „Další děti" (3× `StoryCard`) → `SiteFooter` → mobilní sticky CTA lišta (≤900px, skrytá při
  naplnění).
- Tato kompozice vysvětluje dříve nevyřešenou Open Question WIRE0002 o „duplicitním sidebaru": jde o
  jeden blok `DonationBox`, vykreslený jako jedna souvislá jednotka místo šesti nezávislých vložených
  řádků.

**Zaznamenané divergence (current vs. target — udrženy oddělené, nevyřešené):**

| Aspekt | Current-state WIRE0002 (pozorováno) | Kanonický redesign |
|---|---|---|
| Vstup daru | Vložený modál daru (částka + kontakt + souhlasy) na stránce | Modál zachován, ale vyčleněn jako **budoucí** blok; kanon stránka končí u `onDonate(amount)` |
| Přednastavené částky daru | Live CZ používá fixní 500 bez ohledu na příběh | Fixní čisté presety (500/1000/2000 Kč), explicitní pravidlo „kapacita, ne velikost cíle" + doplnění zbytku jedním klikem |
| Tag kategorie | Fialová pilulka v breadcrumbu + jiný badge na kartách (dvě zpracování) | Jeden jednotný `CategoryChip` (ikona+barva), stejná oblast = stejná barva napříč chip/card wash/monogram |
| Komentář patrona | **Přepínač** „Zobrazit komentář Patrona" | `PatronCard` vyžaduje komentář **vždy viditelný** — reálná změna chování current→target |
| Voucher (dobrošek) | CZ funkce, vložené „Mám dobrošek"/„Koupím dobrošek" (S005) | Formalizováno jako **per-tenant modul**: promo `RailCta` (jen CZ) + `DonationBox.voucherLabel`; uplatnění zůstává v boxu; RO nemá žádný |
| Naléhavost | Čas zobrazen na fotce | Vlastní token `color.urgent`, plnohodnotná alert-badge pilulka + pulz, oddělené od brandu |
| 100 %/dodavatel | Přítomno (CZ červený pás ethos) | Povýšeno na výrazný full-width divider `PledgeStrip`, dodavatel v prvním pádu (strojově vyplnitelné) |

## 7. Přezapojení chrome WIRE0001

Chrome (header/footer) WIRE0001 (homepage/katalog příběhů) je přezapojen tak, aby se skládal z
povýšených atomů/blocks místo monolitického popisu: `SiteHeader` nyní skládá `Brandmark` + `Button`
(ghost, „Požádat o pomoc") + `Icon` (uživatel); `SiteFooter` skládá `Brandmark` (malý) + natvrdo
zapsané sociální glyfy. Mřížka `StoryCard` uvnitř WIRE0001 je přezapojena tak, aby explicitně skládala
`CategoryChip` + `ProgressBar` (dříve vložené textové/pilulkové popisy) dle sesouhlasení COMP0008 (§3).
**Samotná stránka** katalogu (filtrovací záložky, layout S001) **nemá** kanonický protějšek — kanon je
pouze blok `StoryCard`, znovu použitý; okolní kompozice stránky zůstává current-state-only (cíl: E0004,
`Plánováno`).

---

## 8. Zaznamenané průřezové odchylky

- **Multi-tenant CZ/RO.** Rekonstrukce je single-tenant CZ (Patronus jak je nasazen). Kanonická
  knihovna je CZ+RO multi-tenant přes `data-theme`, s hodnotami tokenů per tenant (barva/radius/stín/
  typografie) a obsahovými fixture. Sesouhlasené COMP zaznamenávají dimenzi tenanta jako **cílový
  záměr** (na redesign straně je jako nasazená instance jen CZ — RO je demonstrací theming ve Storybooku,
  nikoli druhým nasazením); current-state COMP nejsou přepisovány jako multi-tenant.
- **Přístupnost vynucena vs. Uncertain.** Rekonstrukce označuje přístupnost jednotně jako `Uncertain`
  (bez dostupné DOM evidence). Kanonická knihovna přístupnost vynucuje (`@storybook/addon-a11y`,
  `test: "error"`) s konkrétními rozhodnutími pro každou smlouvu (role, `aria-*`, focus ring =
  `color.accent`, kontrast ověřen u obou tenantů). Sesouhlasené COMP mohou citovat kanonické rozhodnutí
  o přístupnosti jako **cílový záměr** vedle current-state označení `Uncertain` — tyto dva nejsou
  slučovány do jednoho tvrzení.
- **RO vynechává voucher.** Cesta promo dobrošku/voucheru (varianta `RailCta` promo, `DonationBox
  .voucherLabel`) je na cílové straně explicitně **jen CZ**, v RO skryta. Current-state chování
  voucheru v Patronusu (S005, WIRE0002 „Mám dobrošek") je pozorováno pouze pro CZ; ani na current-state
  straně neexistuje žádná RO evidence voucheru — absence je konzistentní na obou stranách, ale z
  různých důvodů (cíl: záměrný per-tenant modul; current-state: nesebraná RO evidence).

---

## 9. Otevřené body

- **Kanonizována je jen S002.** Detail příběhu (WIRE0002) je jediná obrazovka s kanonickým redesignem
  (E0001, `Done`). Katalog (S001), modál daru (modál S002 + poděkování S003), wizard pro podání žádosti
  (S007–S008e), autentizace (S009–S010) a účetní zóny (S011–S012, S017–S022) všechny **čekají** na
  epiky **E0003–E0005** (`Draft`/`Plánováno`). Sesouhlasení pro tyto nelze provést, dokud tyto epiky
  nevyprodukují kanonické stránky — jakékoli tvrzení, že „redesign dělá X" na jiné obrazovce než S002,
  je v současnosti nepodložené.
- **Sada kategorií příběhu potřebuje `@analyst`.** Kanonický model tokenů rozvrhuje tři kategorie
  (rozvoj/zdraví/obživa), ale vázání per-tenant seznamu označuje jako `needs: @analyst`
  (`tokens.md` §5.3). Vlastní current-state evidence AR (9 kategorií daru ve wizardu žádosti v S008b;
  process-maps) by mohla toto informovat, ale **nesmí** to tiše vyřešit — označeno k následnému
  zpracování `@analyst`, nerozhodnuto zde.
- **Modál daru zatím není kanon.** Current-state modál (vložená částka + kontakt + souhlasy na
  stránce, dle WIRE0002) je odlišný od cílového inline `DonationBox` (končí u `onDonate(amount)`,
  modál explicitně odložen jako budoucí blok dle „Mimo scope" ve smlouvě `StoryDetail.contract.md`).
  Nezávazné zkoumání modálu v redesignu nepovažujte za kánon a current-state modál nepovažujte za
  nahrazený — obě platí, zaznamenány oddělně (viz tabulka divergencí §6).

---

## 10. Doporučený další krok

Publikovat sesouhlasenou sadu COMP a dvě kanonické DESIGN reference do `_ar/spec-final/UX/**`
(index komponent + tokeny jako vyhrazená oblast **DESIGN**, zrcadlená nebo křížově odkazovaná z
`_ar/spec-final/BA/**` tam, kde je užitečný obchodně orientovaný odkaz), přeloženo do češtiny dle
pravidla publikační úrovně (`tooling/docs/rules-spec-final.md`). Konkrétně:

1. Povýšit `DESIGN-tokens.md` a `DESIGN-component-index.md` do oblasti `_ar/spec-final/UX/DESIGN/`
   (nebo rovnocenné vrstvené oblasti) s `_REGISTRY.md`, jasně označené jako **target-state reference**.
2. Přenést přejmenované/povýšené COMP0001–COMP0021 (current-state smlouvy, kanonické křížové
   reference zachovány) do `_ar/spec-final/UX/COMP/` dle stejného pravidla vrstvení.
3. Zachovat pět current-only COMP (COMP0004–0007, COMP0009) a tabulky divergencí (§6, §8) v
   předávaném balíčku beze změny, aby rebuild tým viděl jak current-state pravdu, tak cílový směr bez
   zaměňování, dle pravidla konstituce current-vs-target.

---

## 11. Zdrojové cesty

- `_ar/evidence/design-system/components.md` — kanonický katalog + mapovací tabulka (zdroj §2–§7).
- `_ar/evidence/design-system/design-canon.md` — design kánon, model tokenů, mapování WIRE↔redesign
  obrazovek (zdroj §6–§9).
- `_ar/spec-draft/COMP/COMP0001..COMP0021*.md` — rekonstruované + povýšené smlouvy komponent.
- `_ar/spec-draft/WIRE/WIRE0001_HomepageStoryCatalogue.md`,
  `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` — přezapojené tabulky Components-Used.
- Kanonická knihovna (rebuild projekt, target-state):
  `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/`,
  `docs/design/{README.md,tokens.md,explorations/*.html}`.
