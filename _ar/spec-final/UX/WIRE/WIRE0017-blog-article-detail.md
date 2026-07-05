---
doc_id: WIRE0017
title: Blog Article Detail
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S014
realizes_uc: [UC0026]
status: imported
references:
  - UC0026
  - EN0024
  - COMP0002
  - COMP0003
  - COMP0001
  - COMP0015
  - COMP0018
  - COMP0019
  - COMP0004
---

# WIRE0017 – Detail článku blogu

## Účel

Veřejná, anonymnímu návštěvníkovi určená editoriální obsahová stránka na `/blog/<slug>` — detailní
zobrazení jednoho článku blogu Patronus (`EN0024`), na kterou se návštěvník dostane z výpisu blogu
(`WIRE0016`, S013) přes hero odkaz "Číst více →" nebo kliknutím na titulek/kartu článku. Jedná se o
čistě prohlížecí/čtenářskou obrazovku: návštěvník si přečte titulek článku, meta údaje (datum +
kategorie tag), hero kampaňový obrázek a textový obsah, poté může pokračovat na jednu z výzev k daru
uvedených v článku (fixní měsíční částky, vlastní částka, nebo popis **kanálu DMS SMS daru** —
předání do darovacího flow `UC0005`), sdílet článek nebo otevřít související článek. Realizuje
podflow `UC0026` **UC0026.2 — Otevření a přečtení článku (obrazovka S014)**.

Aktér: anonymní návštěvník / čtenář (bez pozorované ani předpokládané autentizace; na tomto zachycení
nebyla pozorována žádná odlišná varianta pro přihlášeného uživatele nad rámec afordance "Můj účet" ve
sdílené hlavičce).

**Poznámka current-vs-target:** tento dokument rekonstruuje **současný stav** Patronus (`/blog/<slug>`
tak, jak existuje na živém webu dnes). Blog/O nás **nejsou** zatím součástí kánonu přestavby
`bid-patron-deti` — přestavba je řeší v rámci samostatného, dosud nepostaveného epicu (E0004). Nic
zde není záměrem cílového designu; jde výhradně o věrný popis současného stavu.

---

## Layoutové zóny

```
+--------------------------------------------------------------+
| Global nav — logo | Jak to funguje | Blog | O nás |          |
|                    Požádat o pomoc (CTA) | Můj účet           |
+--------------------------------------------------------------+
| "← Zpět na všechny články" back-link                         |
+--------------------------------------------------------------+
| Article header                                               |
|   H1 title ("Patron dětí, Nova pomáhá a Ondřej Sokol …")     |
|   DATE ("19. 05. 2026") | #TAG-CHIP ("#O čem se mluví")       |
+--------------------------------------------------------------+
| Hero image (full-width campaign banner —                     |
|   "DARUJME PRÁZDNINY / Nova pomáhá / a každý dar zdvojnásobí")|
+--------------------------------------------------------------+
| Article body (prose)                                         |
|   lead paragraph                                             |
|   pull-quotes / cited speakers (Ondřej Sokol, Edita          |
|     Mrkousová, Anna Ševerová)                                 |
|   campaign-matching copy ("televize Nova navýší až do        |
|     celkové výše 750 000 Kč")                                 |
|   DMS-SMS donation copy block ("… zvolit trvalou dárcovskou  |
|     SMS na číslo 87 777: DMS TRV PATRONDETI 90 nebo 290")     |
|   inline links ("na svém webu", "hlavní stránku našeho webu")|
+--------------------------------------------------------------+
| Share row — "SDÍLEJTE ČLÁNEK S PŘÁTELI"                      |
|   [Sdílet] [Tweetnout] [LinkedIn] [Zkopírovat odkaz]          |
+--------------------------------------------------------------+
| "Nepřehlédněte" — related articles                          |
|   [card] [card] [card w/ campaign CTA "Pomůžu"]              |
+--------------------------------------------------------------+
| Footer — cookie notice, company info, nav link clusters,     |
|          payment-provider logos, collection account no.      |
+--------------------------------------------------------------+
```

- **Global nav** — logo (→ S001), "Jak to funguje" (→ S016), "Blog" (→ S013 listing), "O nás"
  (→ S015), CTA "Požádat o pomoc" (→ S006), "Můj účet" (→ přihlašovací zóna). — Confirmed
  (`_ar/prtsc/screencapture-…darujme-prazdniny-2026-07-04-13_17_24.png`; sdílený vzor hlavičky dle
  `COMP0002`).
- **Back-link** — "← Zpět na všechny články" nad titulkem, vede zpět na výpis blogu (S013). —
  Confirmed (screenshot; `ui-observed-areas.md` §15 CTA: "Zpět na všechny články").
- **Hlavička článku** — H1 titulek, poté meta řádek kombinující datum publikace/změny a jeden tag
  kategorie ("19. 05. 2026 | #O čem se mluví"). — Confirmed. Váže se na `EN0024` `name` + `created`/
  datum + `category`.
- **Hero obrázek** — full-width kampaňový banner obrázek přímo pod hlavičkou (vizuál "Darujme
  prázdniny / Nova pomáhá" s Ondřejem Sokolem). — Confirmed. Váže se na `EN0024` `image`.
- **Tělo článku** — dlouhý textový obsah: tučně zvýrazněný úvodní odstavec, několik odstavců textu
  proložených kurzívou zvýrazněnými citacemi přisouzenými jmenovaným mluvčím, pasáž o násobení daru
  kampaní, blok DMS-SMS textu o daru a textové odkazy v textu. Jde o autorský obsah článku (`EN0024`
  `body`), nikoli o systémem počítanou projekci. — Confirmed jako pozorovaný text (viz Interakce §DMS
  a Otevřené otázky ohledně povahy tvrzení o násobení).
- **Blok DMS-SMS textu o daru** — závěrečný odstavec výzvy k akci vybízející čtenáře k založení
  trvalého daru přes web ("kliknout na vybrané kolečko v banneru") nebo přes **trvalou
  dárcovskou SMS** ("na číslo 87 777: DMS TRV PATRONDETI 90 nebo 290"). Vykreslen jako text s
  vloženým zvýrazněním a odkazy — na obrazovce není přítomen žádný samostatný donační widget/
  formulář. — Confirmed (screenshot; `ui-observed-areas.md` §15; `UC0026.2` krok 5).
- **Share row** — popsaný řádek "SDÍLEJTE ČLÁNEK S PŘÁTELI" se čtyřmi tlačítky: "Sdílet" (Facebook),
  "Tweetnout" (X/Twitter), "LinkedIn" a "Zkopírovat odkaz". — Confirmed (screenshot;
  `ui-observed-areas.md` §15). Pozn.: popsaná tlačítka se zde liší od ikon-only ShareRow pozorovaného
  na `WIRE0002`/`WIRE0003` — viz Použité komponenty.
- **Související články "Nepřehlédněte"** — nadpis následovaný třemi teaser kartami souvisejících
  článků (náhledový obrázek + datum + tag kategorie + titulek + perex); třetí karta je promo karta
  ve stylu kampaně ("Podpořme děti s Downovým syndromem") s tlačítkem "Pomůžu" místo obyčejného
  teaseru. — Confirmed layout (screenshot); dotaz stojící za výběrem "souvisejících" článků není
  doložen (viz Datové vazby / Otevřené otázky).
- **Patička** — sdílená globální patička (cookie lišta, firemní blok, shluky navigačních odkazů,
  loga platebních poskytovatelů, číslo sbírkového účtu "57574646/0600"). — Confirmed; viz `COMP0003`.

---

## Použité komponenty

Každý vizuální prvek je dohledatelný na `COMPxxxx` doc_id, nebo je označen jako `inline`. Pro
vlastní vzory těla článku a karet souvisejících článků na této obrazovce zatím neproběhl žádný
dedikovaný promotion pass na úrovni vrstvy WIRE — viz poznámky níže.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Global nav | `COMP0002` | context=public | Sdílený chrome hlavičky, shodný vzor jako S001/S013/S016/atd. — viz `COMP0002` SiteHeader. |
| Nav brand logo | `COMP0019` | — | Vložen uvnitř `COMP0002`; wordmark "patron dětí" + tagline "společně za lepší dětství". |
| CTA "Požádat o pomoc" (nav) | `COMP0001` | primary, small | Tlačítko CTA v rámci hlavičky; stejný vzor popisku/cíle jako pozorováno jinde (`COMP0001` Button). |
| Back-link "← Zpět na všechny články" | inline | textový odkaz se šipkou zpět | Nepotvrzeno jako instance `COMP0001` Button (prostý text + úvodní šipka, bez chrome tlačítka). |
| Hlavička článku (titulek + datum + tag) | inline | — | Editoriální hlavička článku; jinde nebyla pozorována jako samostatně znovupoužitelná komponenta — `inline`. |
| Tag kategorie článku ("#O čem se mluví") | `COMP0018` | label=text blog tagu | **Probable** opětovné použití vizuálu pilulkového tag-chipu dokumentovaného jako aktuální podoba `COMP0018` CategoryChip (barevná pilulka + text s prefixem "#"). Rozsah `COMP0018` v současném stavu se týká tagů kategorií Story/kampaň; tagy blogových článků jsou **vizuálně podobné, ale nepotvrzeně identické** použití — označeno jako pravděpodobné, nikoli tvrzené. Stejná výhrada jako u `WIRE0016`. Viz Otevřené otázky. |
| Hero obrázek | inline | full-width banner obrázek | Vykreslen jako hlavní obrázek článku (`EN0024` `image`); není znovupoužitelnou komponentou. |
| Textový obsah článku | inline | rich-text body | Dlouhý autorský obsah (odstavce, kurzívou zvýrazněné citace, tučné zvýraznění, textové odkazy). Není komponentou — `inline`. |
| Karta souvisejícího článku (velká, v "Nepřehlédněte") | inline | náhledový obrázek + datum + tag chip + titulek + perex | Vizuálně stejný teaser vzor jako karty sekcí na `WIRE0016`; tam i zde ponechán jako `inline` (nepovýšeno — slouží editoriálnímu obsahu, bez prvků financování/progresu, tudíž **není** opětovným použitím `COMP0008` StoryCard). |
| Promo karta souvisejícího článku ("Podpořme děti…" + "Pomůžu") | inline (karta) + `COMP0001` (tlačítko) | primary "Pomůžu" | Kampaňově stylizovaná varianta související karty s tlačítkem CTA `COMP0001`; okolní kontejner promo karty je `inline`. — Probable (tlačítko je jasnou instancí `COMP0001`; rám promo karty není modelován samostatně). |
| Share row ("Sdílet"/"Tweetnout"/"LinkedIn"/"Zkopírovat odkaz") | `COMP0015` | variant=popsaná tlačítka; networks=[Facebook, X, LinkedIn] + copy-link | **Probable** opětovné použití `COMP0015` ShareRow. Odchylka: tato instance vykresluje **popsaná** tlačítka a navíc akci "Zkopírovat odkaz" (copy-link), zatímco obě Confirmed instance `COMP0015` (`WIRE0002`/`WIRE0003`) vykreslují **pouze ikonové** sítě (FB/X/IG/LinkedIn/WhatsApp/Messenger[/Email]). Zaznamenáno jako popsaná/blogová varianta stejného konceptu share row, nikoli tvrzeno jako identická. Viz Otevřené otázky. |
| Cookie consent bar (patička) | `COMP0004` | — | Sdílená cookie lišta; "Tyto stránky používají … soubory cookie … Další informace." — viz `COMP0004`. |
| Patička | `COMP0003` | — | Sdílená globální patička, shodný vzor jako u ostatních veřejných obrazovek; viz `COMP0003` SiteFooter. |

---

## Interakce

1. **Vstup** — navigace na `/blog/<slug>` z výpisu blogu (`WIRE0016`, S013) přes hero odkaz "Číst
   více →", kliknutí na titulek/kartu článku, nebo kliknutí na kartu souvisejícího článku
   "Nepřehlédněte"; adresa je také přímo dostupná přes URL → stav: `default`. — Confirmed vzor route
   (`ui-observed-areas.md` §15 `urlPath`; `UC0026.2` krok 1: kanonická/alias route node, nikoli route
   vlastněná modulem `blog`).
2. **Back-link — "← Zpět na všechny články"** — kliknutí na "← Zpět na všechny články" → navigace zpět
   na výpis blogu (S013, `/blog`). Pouze čtení/navigace; bez mutace. — Confirmed (screenshot).
3. **Odkazy v textu — "na svém webu" / "hlavní stránku našeho webu"** — kliknutí → navigace na
   katalog příběhů webu / donační plochu na homepage (S001). — Confirmed jako přítomné odkazy
   (screenshot); přesné cíle odvozeny z textu odkazu, nikoli potvrzeny proklikem. — Probable cíl.
4. **DMS-SMS text o daru** — závěrečný odstavec instruuje čtenáře k založení trvalého daru na webu
   nebo přes trvalou dárcovskou SMS na číslo 87 777 (`DMS TRV PATRONDETI 90 / 290`). Jde o
   **informativní text**, nikoli interaktivní widget — na obrazovce se nevykresluje žádný donační
   formulář/pole; následování route webu předává do darovacího flow (`UC0005`, mimo rozsah nad rámec
   předání, dle `UC0026.2` krok 5). — Confirmed (screenshot; `ui-observed-areas.md` §15).
5. **Akce share row** — "Sdílet" / "Tweetnout" / "LinkedIn" otevírají příslušný sdílecí záměr dané
   sítě pro URL tohoto článku; "Zkopírovat odkaz" zkopíruje URL článku do schránky. — Confirmed jako
   přítomné akce (screenshot); skutečné chování sdílení/kopírování a cílová URL nejsou ze statické
   evidence pozorovatelné (viz `COMP0015` — "cílový obsah share-behavior … not observable"). —
   Probable chování.
6. **Kliknutí na související článek ("Nepřehlédněte")** — kliknutí na kartu souvisejícího článku →
   navigace na detail daného článku (S014, rekurzivně `UC0026.2`); tlačítko "Pomůžu" na promo kartě →
   vstup do daru pro danou kampaň (`UC0005`). — Probable (afordance kliknutí na celou kartu není
   potvrzena proklikem; "Pomůžu" je jasné CTA tlačítko).
7. **Výstup** — přes back-link (na S013), global nav (na S001/S015/S016/S006), odkazy v patičce, nebo
   předání do sdílení/daru; neexistuje žádný výstup typu "zrušit"/"odeslat", protože jde o čtenářskou
   obrazovku pouze pro čtení. — Confirmed.

---

## Stavy

### default
Plně vykreslená stránka článku dle zachycení: back-link, hlavička článku (titulek + datum + tag),
hero kampaňový obrázek, textový obsah (úvodní odstavec, citace, text o násobení daru kampaní, blok
DMS-SMS daru), popsaný share row, související články "Nepřehlédněte", zakončeno sdílenou patičkou. —
Confirmed
(`_ar/prtsc/screencapture-patrondeti-cz-blog-patron-deti-nova-pomaha-a-ondrej-sokol-zvou-do-kampane-darujme-prazdniny-2026-07-04-13_17_24.png`; `ui-observed-areas.md` §15).

### empty
`N/A — vykreslený detail článku není nikdy "prázdný"` ve smyslu prohlížecí/čtenářské obrazovky: článek
je buď publikovaný a vykreslený (default), nebo vůbec nedostupný. Publikovaný článek bez žádných
souvisejících článků by vykreslil blok "Nepřehlédněte" prázdný/nepřítomný, ale neexistuje žádné
zachycení s nulou souvisejících článků, které by toto zpracování potvrdilo. — `Uncertain — not
captured` pro dílčí případ nepřítomnosti souvisejících článků; jinak N/A.

### loading
Nepozorováno. Zda se článek vykresluje synchronně (statická/SSR stránka node — v souladu s
`UC0026.2` popisujícím standardní kanonické vykreslení node Drupal), nebo s nějakým asynchronním
načítáním těla/souvisejícího obsahu, není z jediného statického screenshotu doloženo; v zachycení
není viditelný žádný indikátor načítání. — `Uncertain — not captured` (předpokládáno synchronní SSR
vykreslení, dle zakotvení v kódu `UC0026.2`, ale na této obrazovce neověřeno).

### error
Nepozorováno. Nepublikovaný nebo neexistující `/blog/<slug>` by se řídil přístupovými právy node /
zpracováním 404 v Drupalu (`UC0026.2` krok 2: publikované nody viditelné anonymním uživatelům dle
standardního přístupu k node) — žádné zpracování chyby/404/přístup-odepřen pro detail blogu není v
evidenci zachyceno. — `Uncertain — not captured`.

---

## Validační plochy

Jde o obsahovou/prohlížecí obrazovku pouze pro čtení, bez pozorovaných polí formuláře nebo vstupu
zadávaného uživatelem — žádné validační plochy se neuplatňují.

`N/A — no input controls observed on this screen (Controls / Form fields / Tables: none, per
_ar/evidence/ui/ui-observed-areas.md §15)`.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Hlavička článku — titulek | `EN0024` | — | Váže se na `name` článku (titulek H1). — Confirmed mapování na `EN0024`. |
| Hlavička článku — datum + tag | `EN0024` | — | Váže se na `created`/datum změny ("19. 05. 2026") a `category` (tag chip "#O čem se mluví"). — Confirmed. Nebyl identifikován žádný QUERY dokument pro "získání článku dle slug"; `UC0026.2` toto zakotvuje ve standardním kanonickém vykreslení node Drupal, nikoli v dotazu modulu `blog`. |
| Hero obrázek | `EN0024` | — | Váže se na hlavní `image` článku (kampaňový banner). — Confirmed mapování. |
| Tělo článku (text, citace, text o násobení daru kampaní, blok DMS-SMS) | `EN0024` | — | Váže se na `body` (autorský rich-text obsah). Tvrzení o násobení daru kampaní ("Nova navýší až do celkové výše 750 000 Kč") a instrukce DMS-SMS jsou **autorský text článku**, nikoli systémem počítaná projekce — viz `UC0026.2` poznámka ke kroku 4. — Confirmed jako vazba na `body`; Uncertain, zda nějaké strukturované pole `cta_*` (dle `EN0024`) řídí část tohoto obsahu, nebo je vše volný text v `body`. |
| Související karty "Nepřehlédněte" | `EN0024` | — | Každá související karta se váže na `name`, `perex` (výtah), `image`, datum `created` a `category` publikovaného příspěvku blogu. Logika výběru/řazení "souvisejících" (stejná kategorie? aktuálnost? ruční výběr?) **není doložena** — nebyl identifikován žádný QUERY dokument; pozn.: všechny tři pozorované související karty nesou tag "#Děti s Downovým syndromem", odlišný od tagu "#O čem se mluví" aktuálního článku, takže "související" **není** prostě stejná kategorie. — Probable (vazba); Uncertain (pravidlo výběru). |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | nic nepozorováno | Anonymní/veřejné — řízeno standardním přístupem k node Drupal; publikované nody `blog` viditelné anonymním uživatelům (`UC0026.2` krok 2). Pro tento rekonstrukční pass neexistuje žádná vrstva ACL AR. |
| Odkaz "Můj účet" v nav | Předpokládaná varianta pro přihlášený stav (na tomto zachycení nedoloženo) | Viz IA / jiné obrazovky pro variantu nav u přihlášeného uživatele; zde mimo rozsah. |
| Nepublikovaný článek (`EN0024` status = Unpublished) | Přístup k node Drupal / lifecycle `EN0024` (Published/Unpublished) | Předpokládá se nedostupnost pro anonymní návštěvníky (access-denied / 404) — na této obrazovce samostatně nepotvrzeno, v souladu s lifecyklem publikace/depublikace zaznamenaným v `EN0024` a `UC0026.2`. — Probable. |
| Blok souvisejících článků "Nepřehlédněte" | dostupnost souvisejících článků (dotaz nedoložen) | Předpokládá se vynechání/prázdný stav, pokud neexistují žádné související články (viz Stavy §empty) — nezachyceno. — Uncertain. |

Pro tuto obrazovku nebyl nalezen žádný dokument BR ani ACL řídící viditelnost; je považována za
bezpodmínečně veřejný obsah, v souladu s odpovídajícím zjištěním `WIRE0016` pro sesterskou obrazovku
výpisu blogu.

---

## Poznámky k přístupnosti

Nepozorováno ve statické screenshotové evidenci — v rámci tohoto rekonstrukčního passu neproběhla
žádná inspekce DOM/ARIA. Následující je `Uncertain`/`Evidence Pending`:

- **Pořadí tabulátoru:** Předpokládá se, že sleduje vizuální/DOM pořadí (nav → back-link → hlavička
  článku → odkazy v textu → share row → související karty → patička) — neověřeno.
- **Fokus při vstupu:** Nepozorováno (předpokládá se začátek dokumentu / skip-to-content dle
  standardního načtení stránky — neověřeno).
- **Fokus při přechodu stavu:** Nepozorováno (žádný přechod stavu nezachycen — viz Stavy).
- **Landmarks:** Nepozorováno; přítomnost sémantických landmarks `<nav>`/`<main>`/`<article>`/
  `<footer>` a přístupná hierarchie nadpisů článku není ze samotného screenshotu potvrzena.
- **Klávesové zkratky:** Žádné nepozorovány; u čtenářské obsahové obrazovky se ani neočekávají.

`Evidence Pending — static screenshot only; no DOM/ARIA capture available.`

---

## Otevřené otázky

- `UC0026` (podflow `UC0026.2`) je realizujícím UC pro tuto obrazovku; `UC0026` nyní existuje na
  disku (`_ar/spec-draft/UC/UC0026_BrowseReadBlog.md`) a explicitně pojmenovává S014 jako svou
  obrazovku detailu článku, takže vazba na realizující UC je ověřitelná (na rozdíl od sesterského
  `WIRE0016`, který byl napsán před příchodem `UC0026`). Na samotné vazbě UC nezůstává žádný otevřený
  blokující bod.
- Zda je tag kategorie článku (kandidát na opětovné použití `COMP0018`) skutečně stejný
  vizuální/komponentový vzor jako tag kategorie Story/kampaň dokumentovaný pod `COMP0018`, nebo
  samostatně stylovaný tag pouze pro blog, je **Uncertain** — přeneseno z `WIRE0016`.
- Zda je popsaný share row na této obrazovce stejnou komponentou `COMP0015` ShareRow (vykreslenou v
  popsané/blogové variantě s přidanou akcí copy-link "Zkopírovat odkaz"), nebo samostatnou komponentou
  sdílení pouze pro blog, je **Uncertain** — obě Confirmed instance `COMP0015` jsou pouze ikonové;
  odchylka popisků + copy-link je zaznamenána, nikoli sladěna. Pokud se potvrdí jako odlišná, může být
  namístě samostatný COMP pro sdílení v blogu (nebo popsaná varianta `COMP0015`).
- Pravidlo výběru souvisejících článků "Nepřehlédněte" **není doloženo** — tři pozorované související
  karty sdílejí tag ("#Děti s Downovým syndromem") odlišný od tagu aktuálního článku, takže výběr dle
  stejné kategorie je vyloučen, ale skutečné pravidlo (ruční kurátorství, aktuálnost, taxonomická
  vazba atd.) je neznámé; nebyl identifikován žádný QUERY dokument.
- Zda je údaj o násobení daru kampaní ("750 000 Kč") a detaily DMS-SMS volný text v `body`, nebo jsou
  částečně řízeny strukturovanými poli `EN0024` `cta_*`, je **Uncertain** — `UC0026.2` krok 4 to
  považuje za autorský text, nikoli systémovou projekci.
- Stavy `loading` a `error`/404 jsou **Uncertain — not captured**; předpoklad synchronního SSR je
  zakotven v popisu kanonického vykreslení node v `UC0026.2`, ale na této obrazovce neověřen.
- Dle konstituce projektu jsou Blog/O nás explicitně mimo kánon přestavby `bid-patron-deti` pro tuto
  chvíli (epic přestavby **E0004**, dosud nepostaven) — tento dokument je pouze rekonstrukcí
  současného stavu a nenese žádný implicitní záměr cílového designu/přestavby pro tuto obrazovku.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Celkový layout, zóny, back-link, hlavička, hero obrázek, tělo, share row, blok souvisejících, patička | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-blog-patron-deti-nova-pomaha-a-ondrej-sokol-zvou-do-kampane-darujme-prazdniny-2026-07-04-13_17_24.png`; `_ar/evidence/ui/ui-observed-areas.md` §15 |
| Route (`/blog/<slug>`), vstup z výpisu, realizující `UC0026.2` (S014) | Confirmed | `ui-observed-areas.md` §15 `urlPath`; `UC0026` Main Flow UC0026.2; `_ar/spec-draft/WIRE/WIRE0016_BlogArticleListing.md` (sesterský výpis, S013 → S014) |
| Vazby hlavička/datum/tag/hero/tělo → atributy `EN0024` | Confirmed (titulek/datum/tag/obrázek/tělo) / Uncertain (`cta_*` vs. volný text) | `EN0024` Attributes; `UC0026` UC0026.2 kroky 3–5 |
| Text o násobení daru kampaní + kanál DMS-SMS daru = autorský text článku (nikoli systémová projekce) | Confirmed (text přítomen) / Uncertain (strukturovaný vs. volný text zdroj) | screenshot; `ui-observed-areas.md` §15 ("Nova navýší až do celkové výše 750 000 Kč", "DMS TRV PATRONDETI 90 nebo 290"); `UC0026` UC0026.2 poznámka ke kroku 4 |
| Global nav / brandmark / patička / cookie lišta chrome | Confirmed | `COMP0002`, `COMP0019`, `COMP0003`, `COMP0004` (sdílený chrome prakticky na každé veřejné obrazovce) |
| Tag kategorie ≈ opětovné použití `COMP0018` CategoryChip | Probable / Uncertain | rozsah `COMP0018` v současném stavu omezen na tagy Story/kampaň; použití v blogu vizuálně podobné, nepotvrzeno jako identické (stejná výhrada jako u `WIRE0016`) |
| Share row ≈ opětovné použití `COMP0015` ShareRow (popsaná varianta + copy-link) | Probable / Uncertain | Confirmed instance `COMP0015` jsou pouze ikonové (`WIRE0002`/`WIRE0003`); tato instance je popsaná + přidává "Zkopírovat odkaz" |
| Pravidlo výběru souvisejících článků "Nepřehlédněte" | Uncertain | screenshot ukazuje související karty s jiným tagem než má článek — pravidlo nedoloženo; žádný QUERY dokument |
| Stavy empty / loading / error(404) | Uncertain / not captured | pro tuto obrazovku nebyly nalezeny žádné další screenshoty ani evidence; předpoklad SSR vykreslení zakotven v `UC0026` UC0026.2 |
| Přístupnost | Evidence Pending | pouze screenshotová evidence; žádné DOM/ARIA zachycení k dispozici |
| Blog mimo kánon přestavby (E0004, nepostaveno) | Confirmed | konstituce projektu / instrukce úlohy — pouze současný stav, žádný detail cílového designu nebyl vymýšlen |
