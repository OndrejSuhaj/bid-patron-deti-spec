---
doc_id: WIRE0016
title: Blog Article Listing
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S013
realizes_uc: [UC0026]
status: imported
references:
  - UC0026
  - EN0024
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0018
  - COMP0019
  - COMP0020
---

# WIRE0016 – Výpis blogových článků

## Účel

Veřejná, anonymnímu návštěvníkovi přístupná editorialní/obsahová stránka na `/blog` ("Blog" v
globální navigaci), zobrazující marketingové/editorialní příspěvky blogu Patronusu (`EN0024`)
seskupené pod hlavním/hero článkem, po němž následuje několik tematicky otagovaných sekcí. Jde o
čistou prohlížecí obrazovku: návštěvník si prohlédne hero příběh a poté prochází teasery článků
seskupené podle témat, přičemž pomocí "Číst více →" nebo kliknutím na název článku se dostane na
detailní obrazovku článku (S014, aktuálně nezrekonstruovanou — viz Otevřené otázky).

Podle `_ar/spec-draft/WIRE-synthesis-report.md` §2/§4 byla tato obrazovka v předchozím průchodu
WIRESynthesizeru **přeskočena jako blocked-no-uc** ("Čistý editorialní/obsahový agregátor; žádný
uživatelský cíl kromě procházení otagovaných článků"), a čekala právě na ten "lightweight
browse/read content" UC, který report doporučil. Tento dokument předpokládá, že tato mezera byla od
té doby uzavřena pomocí `UC0026` dle zadání této úlohy; v době vzniku tohoto dokumentu neexistuje pod
`_ar/spec-draft/UC/` žádný soubor `UC0026` (adresář vrstvy UC je v tomto workspace aktuálně
prázdný) — odkaz na realizující UC je zde uveden podle zadání, nikoli nezávisle ověřen vůči dokumentu
UC. Viz Otevřené otázky.

Aktér: anonymní návštěvník (neevidována ani neimplikována žádná autentizace; nebyla pozorována žádná
odlišná varianta pro přihlášeného uživatele).

**Poznámka current-vs-target:** tento dokument rekonstruuje **současný stav** Patronusu (`/blog` tak,
jak existuje na živém webu dnes). Blog/O nás **nejsou** součástí kánonu přestavby `bid-patron-deti` —
přestavba je řeší v rámci samostatného, nezahájeného epiku (E0004). Nic zde uvedeného nemá být čteno
jako záměr cílového návrhu; jde výhradně o věrný popis současného stavu.

---

## Zóny rozvržení

```
+--------------------------------------------------------------+
| Global nav — logo | Jak to funguje | Blog (current) | O nás | |
|                    Požádat o pomoc (CTA) | Můj účet           |
+--------------------------------------------------------------+
| Hero article band                                             |
|   [large photo]  DATE | #TAG-CHIP                              |
|                  Headline                                     |
|                  Excerpt paragraph                             |
|                  "Číst více →"                                 |
+--------------------------------------------------------------+
| Section — "#O čem se mluví"                                   |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Section — "#Pomohli jsme"                                     |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Section — "#Chcete vědět"                                     |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Section — "#Rozhovory"                                        |
|   [big card] [big card]                                       |
+--------------------------------------------------------------+
| Section — "#Pomoc pro děti s autismem"                        |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Section — "#Děti s Downovým syndromem"                        |
|   [big card] [big card] [3 small list rows w/ thumbnails]      |
+--------------------------------------------------------------+
| Footer — cookie notice, company info, nav link clusters,      |
|          payment-provider logos, collection account no.       |
+--------------------------------------------------------------+
```

- **Globální navigace** — logo (→ S001), "Jak to funguje" (→ S016), "Blog" (aktuální stránka),
  "O nás" (→ S015), CTA "Požádat o pomoc" (→ S006), "Můj účet" (→ zóna autentizace). — Confirmed.
- **Hero pás článku** — jeden velký zvýrazněný příspěvek: fotka, datum, jeden tag chip ("#O čem se
  mluví"), titulek ("Patron dětí, Nova pomáhá a Ondřej Sokol zvou do kampaně Darujme prázdniny"),
  odstavec s výtahem, odkaz "Číst více →". — Confirmed. Váže se na příznak `is_hero_post` entity
  `EN0024`.
- **Tematické sekce** — šest opakujících se sekcí, každá uvozena barevným nadpisem ve stylu tagu
  ("#O čem se mluví", "#Pomohli jsme", "#Chcete vědět", "#Rozhovory", "#Pomoc pro děti s autismem",
  "#Děti s Downovým syndromem"). Každá sekce je smíšená mřížka: dvě větší karty článků (fotka, datum,
  tag chip, titulek, krátký výtah) vlevo, plus až tři menší řádky se seznamem (miniatura + datum +
  tag chip + titulek, bez výtahu) naskládané vpravo. Sekce "#Rozhovory" je pozorována pouze se dvěma
  velkými kartami bez menších řádků seznamu. — Confirmed vzor rozvržení; **Uncertain**, zda je
  kompozice dvě-velké + N-malé pevnou šablonou, nebo se liší podle počtu dostupných článků na daný
  tag (pozorováno pouze 6 instancí sekcí, přičemž jedna z nich — #Rozhovory — se od ostatních již
  liší).
- **Patička** — sdílená globální patička (lišta se souhlasem s cookies, blok se společností, shluky
  navigačních odkazů, loga platebních poskytovatelů, číslo sbírkového účtu). — Confirmed; viz
  `COMP0003`.

---

## Použité komponenty

Každý vizuální prvek se dohledá k `COMPxxxx` doc_id, nebo je označen jako `inline`. Pro vlastní
opakující se kartu této obrazovky zatím neproběhl žádný dedikovaný promotion pass na úrovni vrstvy
WIRE — viz poznámky níže.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Globální navigace | `COMP0002` | context=public | Sdílený chrome hlavičky, shodný vzor jako u S001/S016/atd. — viz `COMP0002` SiteHeader. |
| Logo/brand v navigaci | `COMP0019` | — | Vnořeno v `COMP0002`; wordmark "patron dětí" + značka srdce/stuha. |
| CTA "Požádat o pomoc" (navigace) | `COMP0001` | primary, small | CTA tlačítko v rámci hlavičky; stejný vzor labelu/cíle jako jinde pozorováno (`COMP0001` Button). |
| Karta hero článku | inline | velká/featured varianta | Není potvrzeno, že jde o stejnou podkladovou komponentu jako karty článků v sekcích níže — odlišné vizuální proporce (fotka přes celou šířku + větší typografie). Vedena jako `inline`, nepovýšena, do doby doložení na ≥2 obrazovkách (jde o jedinou obrazovku, kde je pozorováno rozvržení hero-článku). |
| Nadpis sekce (tag label, např. "#O čem se mluví") | inline | — | Barevný nadpisový text pro každou sekci, plní zároveň roli seskupovacího tagu; není potvrzeno, že je totožný s `COMP0018` CategoryChip (současný stav tohoto COMP je vymezen na indikátor kategorie Story/Campaign na `WIRE0001`/`WIRE0002`, nikoli blogové tagy — viz poznámka o divergenci níže). |
| Tag chip článku (na jednotlivých kartách, např. pilulka "#O čem se mluví" na kartě) | `COMP0018` | label=text blogového tagu | **Probable** znovupoužití vzoru vizuálu pilulkového tag-chipu zdokumentovaného jako pozorovaný současný tvar `COMP0018` CategoryChip (barevná pilulka + text). Vlastní rozsah současného stavu `COMP0018` jsou kategorie Story/Campaign (pilulka ve stat-strip, odznak na kartě, tag v postranním panelu) — blogové tagy článků jsou **vizuálně podobné, ale nepotvrzeně totožné** použití; zde je to označeno jako pravděpodobné/kandidátní znovupoužití, nikoli potvrzené jako jisté. Viz Otevřené otázky. |
| Karta článku (velká, 2 na sekci) | inline | fotka + datum + tag chip + titulek + výtah | Opakuje se ve všech 6 sekcích; vizuálně podobná anatomii foto-titulek-CTA komponenty `COMP0008` StoryCard, ale slouží editorialnímu obsahu, nikoli Campaign/Story, a neobsahuje žádné prvky financování/postupu/CTA tlačítka — **není** vedena jako znovupoužití `COMP0008`; ponechána jako `inline`. |
| Řádek seznamu článku (malý, až 3 na sekci) | inline | miniatura + datum + tag chip + titulek | Kompaktní varianta sekundární karty; není v podkladech pozorována jako samostatně znovupoužitelná komponenta jinde — `inline`. |
| Odkaz "Číst více →" (pouze hero) | inline | textový odkaz s glyfem šipky | Není potvrzeno jako instance `COMP0001` Button (nepozorován žádný button chrome — pouze prostý text + ikona šipky). |
| Glyf šipky u "Číst více →" | `COMP0020` | dekorativní | V souladu s obecným použitím inline-glyfu `COMP0020` Icon jinde; konkrétní identita ikony nepotvrzena. |
| Patička | `COMP0003` | — | Sdílená globální patička, shodný vzor jako u ostatních veřejných obrazovek; viz `COMP0003` SiteFooter. |

---

## Interakce

1. **Vstup** — přímá navigace na `/blog` přes odkaz "Blog" v globální navigaci → stav: `default`. —
   Confirmed (route + vstupní bod navigace; `_ar/spec-draft/IA/IA-patronus.md` řádky 84, 212).
2. **Primární akce — "Číst více →"** — kliknutí na odkaz read-more u hero článku → navigace na
   detailní obrazovku daného článku (S014, `/blog/<slug>`). Tato obrazovka sama o sobě nerealizuje
   žádný krok UC orientovaný na mutaci; jde pouze o navigaci typu čtení/procházení. — Confirmed cílový
   vzor (tvar route pozorován na záznamu podkladů pro S014), byť samotné S014 zůstává
   nezrekonstruováno jako vlastní dokument WIRE (viz Otevřené otázky).
3. **Sekundární akce — kliknutí na titulek/kartu článku** — kliknutí na fotku nebo titulek libovolné
   karty článku v sekci → předpokládaná navigace na vlastní detailní obrazovku daného článku,
   analogicky k "Číst více →" u hero. Na menších kartách/řádcích není zobrazena žádná odlišná
   vizuální afordance (žádný samostatný odkaz "read more") — předpokládá se, že klikatelná je celá
   karta. — **Probable**, nezávisle nepotvrzeno zachyceným proklikem.
4. **Sekundární akce — nadpis sekce s tagem / tag chip článku** — zda kliknutí na nadpis sekce
   (např. "#O čem se mluví") nebo na tag chip jednotlivého článku filtruje výpis na daný tag, nebo
   jde čistě o statický popisek, **není pozorováno** (nezachycen žádný aktivní/hover stav, žádný
   snímek obrazovky s filtrovaným zobrazením). — Uncertain, v souladu s obecnou poznámkou
   "controls: category tag chips per article (grouping; interactivity not confirmed)" v
   `ui-observed-areas.md` §14.
5. **Výstup** — přes globální navigaci (na S001/S015/S016/S006) nebo odkazy v patičce; neexistuje
   žádný explicitní výstup typu "cancel"/"submit", neboť jde o čistě obsahovou obrazovku pouze pro
   čtení. — Confirmed.

---

## Stavy

### default
Plně vykreslená stránka tak, jak byla zachycena: hero pás článku, po němž následuje šest tematických
sekcí, každá naplněná kartami článků, končící sdílenou patičkou. — Confirmed
(`_ar/prtsc/screencapture-patrondeti-cz-blog-2026-07-04-13_16_59.png`).

### empty
Nepozorováno. Zda je tematická sekce s nula otagovanými články zcela skryta, vykreslena s
zástupným obsahem, nebo prostě k tomu nikdy nedochází (pevná editorialní kurace), není známo —
v záznamu neexistují žádné podklady pro sekci bez článků (všech šest pozorovaných sekcí je
naplněno). — `Uncertain — not captured`.

### loading
Nepozorováno. Zda se výpis vykresluje synchronně (statická/SSR editorialní stránka), nebo
asynchronně (např. mechanismus "load more" doplňující další sekce/články), není doloženo jediným
statickým screenshotem; pod poslední sekcí v záznamu není vidět žádná stránkovací kontrola ani
"load more". — `Uncertain — not captured`.

### error
Nepozorováno. Pro tuto obrazovku není doloženo žádné ošetření chyby/selhání (např. selhání
načtení článků). — `Uncertain — not captured`.

---

## Validační plochy

Jde o čistě obsahovou/prohlížecí obrazovku pouze pro čtení, bez formulářových polí nebo
uživatelem zadávaného vstupu — žádné validační plochy se neuplatňují.

`N/A — no input controls observed on this screen (Controls / Form fields: none, per
_ar/evidence/ui/ui-observed-areas.md §14: "Form fields / Tables: none")`.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Hero pás článku | `EN0024` | — | Váže se na jediný příspěvek blogu s příznakem `is_hero_post = true`; zobrazená pole: `name` (titulek), `perex` (výtah), `image`, datum `created`/publikace, `category`. — Confirmed mapování na atributy `EN0024`; nebyl identifikován žádný QUERY dokument pro "načtení aktuálního hero příspěvku". |
| Karta článku v sekci / řádek seznamu | `EN0024` | — | Každá karta/řádek se váže na `name`, `perex` (pouze u velkých karet), `image`, datum `created` a `category` (řídí tag chip/seskupení sekce) jednoho publikovaného příspěvku blogu. — Confirmed mapování; dotaz/filtr, který seskupuje příspěvky do pojmenované sekce podle tagu (a řadí/omezuje je na 2 velké + až 3 malé), není doložen — nebyl identifikován žádný QUERY dokument. |
| Nadpis sekce (tag label) | `EN0024` (odkaz na taxonomii `category`) | — | Seskupení sekcí ("#O čem se mluví" atd.) odpovídají atributu `category` entity `EN0024` (klasifikační termín blogové kategorie); podkladový seznam taxonomických termínů není samostatně modelován jako entita AR (dle vztahů `EN0024`). — Probable. |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (ref. ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | nepozorováno žádné | Anonymní/veřejné — nepozorováno žádné omezení podle role; vrstva ACL pro tento rekonstrukční průchod zatím neexistuje. |
| Navigační odkaz "Můj účet" | Předpokládaná varianta pro autentizovaný stav (na tomto záznamu nedoloženo) | Viz IA / jiné obrazovky pro variantu navigace přihlášeného uživatele; mimo rozsah zde. |
| Nepublikované příspěvky blogu (`EN0024` status = Unpublished) | Životní cyklus `EN0024` (Published/Unpublished) | Předpokládá se úplné vyloučení z výpisu (zobrazují se pouze příspěvky se stavem `Published`) — na této obrazovce nezávisle nepotvrzeno, v souladu s obecným publikačním životním cyklem zaznamenaným u `EN0024`. — Probable. |

Pro tuto obrazovku nebyl nalezen žádný dokument BR ani ACL řídící viditelnost; je vedena jako
bezpodmínečně veřejný obsah, v souladu s obdobným zjištěním `WIRE0019` pro druhou obsahovou/prohlížecí
obrazovku.

---

## Poznámky k přístupnosti

Nepozorováno ve statických podkladech screenshotu — v rámci tohoto rekonstrukčního průchodu nebyla
provedena žádná inspekce DOM/ARIA. Následující body jsou `Uncertain`/`Evidence Pending`:

- **Pořadí tabulátoru:** Předpokládá se, že sleduje vizuální/DOM pořadí (navigace → hero článek →
  karty sekce 1 → karty sekce 2 → … → karty sekce 6 → patička) — neověřeno.
- **Fokus při vstupu:** Nepozorováno.
- **Fokus při přechodu stavu:** Nepozorováno (nezachycen žádný přechod stavu — viz Stavy).
- **Landmarky:** Nepozorováno; přítomnost sémantických landmarků `<nav>`/`<main>`/`<article>`/
  `<footer>` nelze pouze ze screenshotu potvrdit.
- **Klávesové zkratky:** Žádné nepozorovány; pro obsahovou prohlížecí obrazovku se ani žádné
  neočekávají.

---

## Otevřené otázky

- `UC0026` je zadáním této úlohy uveden jako realizující UC (uzavírající mezeru "blocked-no-uc"
  zaznamenanou v `_ar/spec-draft/WIRE-synthesis-report.md` §2/§4 pro S013). V době vzniku tohoto
  dokumentu neexistuje pod `_ar/spec-draft/UC/` žádný soubor `UC0026` (adresář vrstvy UC je v tomto
  workspace aktuálně prázdný) — tento dokument WIRE nese referenci podle zadání, ale odkaz **není**
  zatím nezávisle ověřitelný vůči dokumentu UC. Označit k dohledání, jakmile bude `UC0026` vytvořen.
- Zda je tag chip článku (kandidát na znovupoužití `COMP0018`) skutečně stejným
  vizuálním/komponentovým vzorem jako category chip Story/Campaign zdokumentovaný v rámci rozsahu
  současného stavu `COMP0018` (pilulka ve stat-strip, odznak na katalogové kartě, tag v postranním
  panelu detailu příběhu), nebo jde o samostatně stylovaný prvek tagu specifický pouze pro blog, který
  se pouze vizuálně podobá, je **Uncertain** — tímto rekonstrukčním průchodem nevyřešeno. Pokud se
  potvrdí odlišnost, může být namístě samostatný blog-tag COMP místo začlenění do `COMP0018`.
- Zda jsou nadpisy sekcí s tagem / tag chipy článků interaktivní (filtrují výpis), je Uncertain —
  nebyl zachycen žádný snímek aktivního/filtrovaného stavu; viz `ui-observed-areas.md` §14: "category
  tag chips per article (grouping; interactivity not confirmed)."
- Zda kliknutí na kartu/řádek článku v sekci (nejen na "Číst více →" u hero) skutečně naviguje na
  detailní obrazovku daného článku, je Probable, ale nezávisle proklikem nepotvrzeno.
- Zda pod hranicí viditelnosti existují další články/sekce nad rámec jediného zachyceného
  screenshotu (stránkování, "load more" nebo nekonečné scrollování), je nepotvrzeno — v záznamu není
  vidět žádná taková kontrola.
- S014 (Blog — detail článku, `/blog/<slug>`) zůstává v době vzniku tohoto dokumentu nezrekonstruováno
  jako vlastní dokument WIRE (rovněž blocked-no-uc dle stejného předchozího průchodu syntézy);
  navigační cíl "Číst více →" / kliknutí na kartu na této obrazovce je proto Confirmed pouze jako
  vzor route (dle `ui-observed-areas.md` §15), nikoli jako křížově odkazovaný doc_id WIRE.
- Dle projektové konstituce jsou Blog/O nás explicitně mimo kánon přestavby `bid-patron-deti` (rebuild
  epic **E0004**, nezahájeno) — tento dokument je pouze rekonstrukcí současného stavu a neimplikuje
  nic ohledně cílového/rebuild návrhu této obrazovky.

---

## Podklady (Evidence)

| Oblast tvrzení | Jistota | Podklad |
|---|---|---|
| Celkové rozvržení, zóny, hero pás, šest tematických sekcí | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-blog-2026-07-04-13_16_59.png`; `_ar/evidence/ui/ui-observed-areas.md` §14 |
| Route, vstupní bod navigace | Confirmed | `_ar/spec-draft/IA/IA-patronus.md` řádky 84, 212 |
| Obrazovka dříve blocked-no-uc; UC0026 uzavírá tuto mezeru dle zadání úlohy | Confirmed (historie blokace) / Uncertain (existence souboru UC0026) | `_ar/spec-draft/WIRE-synthesis-report.md` §2, §4; adresář `_ar/spec-draft/UC/` je aktuálně prázdný |
| Vazba hero článku → `is_hero_post` entity `EN0024` | Confirmed | Atributy/invarianty `EN0024` ("Nejvýše jeden příspěvek blogu je v daný okamžik aktuálním hero příspěvkem") |
| Seskupení sekcí → atribut `category` entity `EN0024` | Probable | Atributy `EN0024` (odkaz `category`) a poznámka o vztazích (taxonomie samostatně nemodelována) |
| Tag chip článku ≈ znovupoužití `COMP0018` CategoryChip | Uncertain | Vlastní rozsah současného stavu `COMP0018` je omezen na indikátory kategorie Story/Campaign na `WIRE0001`/`WIRE0002`; použití u blogu tam dosud nebylo zahrnuto |
| Chrome globální navigace / patičky | Confirmed | `COMP0002`, `COMP0003` (sdílený chrome, "přítomný jako chrome prakticky na každé obrazovce") |
| Interaktivita tag chipů/nadpisů (filtr vs. statické) | Uncertain | `ui-observed-areas.md` §14: "interactivity not confirmed" |
| Stavy empty / loading / error | Uncertain / nezachyceno | pro tuto obrazovku nebyly nalezeny žádné další screenshoty ani podklady |
| Přístupnost | Evidence Pending | pouze podklady ze screenshotu; žádný záznam DOM/ARIA není k dispozici |
| Blog mimo kánon přestavby (E0004, nezahájeno) | Confirmed | Projektová konstituce / zadání úlohy — pouze současný stav, žádný cílový detail nevymyšlen |
