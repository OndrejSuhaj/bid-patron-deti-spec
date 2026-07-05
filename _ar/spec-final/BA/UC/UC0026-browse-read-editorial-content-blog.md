---
doc_id: UC0026
title: Browse & Read Editorial Content (Blog)
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0026 — Procházení a čtení redakčního obsahu (Blog)

## Záhlaví

| Field | Value |
|---|---|
| UC ID | UC0026 |
| Name | Browse & Read Editorial Content (Blog) |
| Bounded Context | C3 |
| Primary Actor(s) | Anonymous visitor / reader, System |
| Trigger Type | UI (public page load) |

## Aktéři a odpovědnosti

- **Anonymní návštěvník / čtenář** — otevře veřejný výpis blogu, aby procházel redakční články seskupené
  podle tematické kategorie, a otevře jednotlivý článek, aby si přečetl jeho celý text, texty navázané na
  kampaň a výzvy k darování. Neprovádí žádnou mutaci; jde o čistě konzumní schopnost (čtení obsahu).
- **System** — vyhodnocuje aktuálně zvýrazněný ("top"/sticky) příspěvek a pro každou tematickou kategorii
  nejnověji změněné články pro stránku výpisu; na vyžádání vykresluje celý obsah jednotlivého článku
  (včetně případné výzvy k akci nastavené autorem); vynucuje viditelnost publikováno/nepublikováno
  prostřednictvím přístupových práv k node/entitě.

## Záměr

Umožnit anonymnímu návštěvníkovi objevovat a číst redakční obsah "blogu" — výpis článků seskupených podle
tematického štítku s jedním zvýrazněným top příspěvkem a detailní zobrazení článku obsahující text,
propagaci navázanou na kampaň a vstupní body pro darování (včetně dárcovského kanálu DMS SMS) — bez nutnosti
ověření a bez mutace jakéhokoli stavu domény. Jde o current-state chování zjištěné z kódu (browse/read);
**není** (zatím) součástí redesign kánonu `bid-patron-deti` (rebuild epic E0004 není postaven) a
neuvádí se zde žádný cílový (target-state) UI/IA návrh.

## Předpoklady

- Existuje jeden nebo více článků blogu a jsou publikované (viditelné pro anonymního návštěvníka); veřejná
  routa `/blog` vyžaduje pouze oprávnění `access content` (`blog.routing.yml`).
- K procházení výpisu ani k otevření článku není vyžadováno žádné ověření.

## Hlavní tok

### UC0026.1 — Procházení výpisu blogu (obrazovka S013, `/blog`)

1. Návštěvník: vyžádá veřejnou stránku výpisu blogu (`/blog`).
2. System: vyhodnotí routu `blog` na `NodeBlogController::startPage()` (`blog.routing.yml`,
   `permission: access content`).
3. System: načte aktuálně zvýrazněný/"top" příspěvek — entitu `node` typu `blog` s příznakem `sticky`
   — a vykreslí jej v zobrazovacím módu `top_post`
   (`NodeBlogController::startPage()`; `core.entity_view_display.node.blog.top_post.yml`).
4. System: načte celý strom taxonomie `blog_category` (tematické štítky, např. "#O čem se mluví",
   "#Pomohli jsme", "#Chcete vědět", "#Rozhovory", "#Pomoc pro děti s autismem", "#Děti s Downovým
   syndromem" — UI evidence §14).
5. System: pro každý kategoriový term dotáže maximálně 5 uzlů typu `blog` označených danou kategorií
   (kromě top/sticky příspěvku), seřazených podle nejnovější změny, s ověřením přístupu
   (`NodeBlogController::startPage()`, `getQuery()->accessCheck(TRUE)`).
6. System: vykreslí první 2 nalezené články na kategorii v zobrazovacím módu `category_post` a
   případné zbývající (až 3 další) v módu `small_category_post`
   (`core.entity_view_display.node.blog.category_post.yml`,
   `core.entity_view_display.node.blog.small_category_post.yml`).
7. System: sestaví stránku pomocí theme hooku `blogs_page` (`blog_theme()`) a šablony
   `blogs-page.html.twig` — nejprve top příspěvek, poté jedna sekce na kategoriový term (nadpis +
   mřížka náhledů článků), s tagováním pro invalidaci cache na seznam uzlů `blog` a na seznam taxonomie
   `blog_category`.
8. Návštěvník: u každého náhledu článku vidí jeho titulek, datum publikace/změny, kategoriový štítek,
   perex a náhledový obrázek (UI evidence §14: "blog articles (title, date, category tag, excerpt,
   thumbnail)").
9. Návštěvník: klikne na odkaz článku "Číst více →" nebo na jeho titulek, čímž článek otevře (UC0026.2).

### UC0026.2 — Otevření a čtení článku (obrazovka S014, `/blog/<slug>`)

1. Návštěvník: klikne na odkaz na kanonickou stránku jednotlivého článku (`/blog/<slug>` — Drupal
   canonical/alias routa pro uzel typu `blog`; nejde o routu vlastněnou přímo modulem `blog`).
2. System: vyhodnotí přístup k uzlu pro požadovaný článek (publikované uzly jsou viditelné anonymním
   návštěvníkům podle standardního přístupu k uzlům; na články typu `node` se nevztahuje žádné
   blog-specifické přepsání přístupových práv — v kontrastu se samostatným access handlerem
   `BlogEntity` v AF1).
3. System: vykreslí celé zobrazení článku — titulek, datum, kategoriový štítek, tělo textu a hero
   obrázek (UI evidence §15).
4. System: vykreslí veškerý propagační text navázaný na kampaň vložený v těle článku (např. popis
   kampaně s násobením daru a jejím stropem, pozorováno jako "televize Nova navýší až do celkové výše
   750 000 Kč" — UI evidence §15); tento text je autorsky vytvořený obsah, nikoli systémem počítaná
   projekce tvrzená tímto UC.
5. System: vykreslí vedle článku vstupní body pro darování — přednastavené pevné měsíční částky, možnost
   vlastní částky a text **dárcovského kanálu DMS SMS** (pozorováno: "trvalou dárcovskou SMS na číslo
   87 777: DMS TRV PATRONDETI 90 nebo 290" — UI evidence §15); kliknutí na kterýkoli z nich předává řízení
   do darovacího flow (UC0005 — mimo rozsah tohoto UC kromě samotného předání).
6. System: vykreslí podpůrné UI — zpětný odkaz "Zpět na všechny články", akce sdílení na sítích
   ("Sdílet" / "Tweetnout" / "LinkedIn" / "Zkopírovat odkaz") a odkazy na související články.
7. Návštěvník: přečte si článek a volitelně klikne na výzvu k darování (→ UC0005) nebo na odkaz na
   související článek (→ UC0026.2, rekurzivně).

## Alternativní toky

### AF1 — Existuje samostatný obsahový typ "BlogEntity", ale není to procházený obsah

1. System: kódová báze navíc definuje vlastní entitní typ `blog` postavený na config entitě
   (`BlogEntity`, `blog.permissions.yml`: `view published/unpublished blog entity entities`, `edit`,
   `delete`, `add`) s vlastním access handlerem (`BlogEntityAccessControlHandler`) a operacemi
   "publikovat na homepage" / "nastavit jako aktivní" dostupnými pouze administrátorům
   (`PublishToHomepageController`), podmíněnými oprávněním `edit blog entity entities`.
2. System: tento typ `BlogEntity` je odlišný od typu `node` s názvem `blog`, který
   `NodeBlogController::startPage()` skutečně dotazuje pro veřejný výpis (UC0026.1 kroky 3–5).

Výsledek: Potvrzeno jako dvě samostatné cesty v kódu sdílející název "blog" (viz EN0024 Otevřená otázka
4). Toto UC dokumentuje pouze čtenářskou cestu výpisu/detailu na bázi typu `node`, protože právě to UI
evidence (§14–§15) a veřejné směrování (`blog.routing.yml`) prokazují jako procházený obsah; zda je typ
`BlogEntity` čtenářům někde samostatně zpřístupněn, **není doloženo** v prohledaném zdrojovém kódu a zde
se to netvrdí.

### AF2 — Neexistuje žádný sticky/top příspěvek

1. System: dotaz na entitu typu `node` bundle `blog` s příznakem `sticky` nevrátí žádný výsledek.
2. System: `reset($sticky)` nad prázdným polem vrátí `false`/`null`; následné volání `$top_post->id()`
   by selhalo nad null objektem.

Výsledek: **Hypothesis — Not evidenced in current sources.** V `NodeBlogController::startPage()` kolem
`$top_post` není přítomna žádná obranná kontrola na null; zda je existence alespoň jednoho sticky
příspěvku zaručena redakčním procesem (takže tato cesta v praxi nikdy nenastane) nebo jde o latentní
defekt, nelze vyřešit pouze z kódu.

### AF3 — Kategorie bez odpovídajících článků

1. System: term `blog_category` nemá žádné uzly typu `blog` jím označené (kromě top příspěvku).
2. System: sekce kategorie se přesto vykreslí (nadpis podle termu), ale s prázdnou mřížkou náhledů.

Výsledek: Potvrzeno strukturou dotazu/vykreslení (`startPage()` vždy emituje záznam
`$rendered_blogs[$term->id()]` pro každý term bez ohledu na počet shod); výsledný vizuál prázdné sekce
není samostatně doložen v UI screenshotech.

## Následné podmínky

- Žádný doménový agregát (Application/žádost, Campaign, Transaction/transakce atd.) není tímto UC
  vytvořen, změněn ani modifikován při čtení — jde o čistě read/render schopnost.
- Návštěvník má k dispozici vykreslený výpis (top příspěvek + mřížka náhledů podle kategorie) nebo
  vykreslený detail článku (text, propagace navázaná na kampaň, výzvy k darování včetně DMS SMS)
  dostatečný buď k dalšímu čtení (související články, zpětný odkaz), nebo k pokračování do darovacího
  flow (UC0005).
- Cache vykreslení na úrovni stránky je tagována na seznam uzlů `blog` a na seznam termů taxonomie
  `blog_category`, takže nový/změněný/přeznačený článek invaliduje cachovaný render výpisu.

## Sledovatelnost (Traceability)

Target SRVs:
- Žádný dedikovaný — toto UC je zakotveno přímo ve vrstvě routing/controller/theme vlastního modulu
  `blog`; kandidát SRV/cílové služby pro procházení redakčního obsahu nebyl v této rekonstrukční fázi
  definován (Blog je mimo redesign kánon podle rebuild epic E0004, nepostaveno).

EN entities:
- EN0024 Blog — entita redakčního obsahu, jejíž atributy `name`, `perex`, `body`, `image`/`gallery`,
  `category`, `is_hero_post` a `cta_*` popisují zamýšlený tvar domény; pozn.: evidence hlavního toku
  tohoto UC (`NodeBlogController`) ve skutečnosti operuje nad typem `node` bundle `blog` (s
  drupal-core poli `sticky`/taxonomie `category`), nikoli nad config-entitním typem `BlogEntity`, který
  EN0024 dokumentuje v plném rozsahu — viz AF1 a EN0024 Otevřená otázka 4 pro nevyřešený vztah dvou
  bundlů
- EN0004 Campaign — odkazováno pouze jako propagační/CTA obsah navázaný v rámci autorsky vytvořeného
  textu článku (UC0026.2 krok 4); není touto vlastní logikou UC čteno ani zapisováno
- EN0008 User — autor článku (`user_id` na `BlogEntity`); ve zdokumentovaném UI se čtenáři nezobrazuje

Integration boundaries:
- Žádné (interní read/render; při samotném procházení/čtení blogu není volán žádný externí systém).
  Dárcovský kanál DMS SMS zmíněný v textu článku (UC0026.2 krok 5) je externí dárcovský kanál, ale jeho
  zpracování je mimo rozsah tohoto UC (pouze předání řízení).

Flow Evidence:
- Pro tuto schopnost neexistuje žádný FLW dossier (nebyl zahrnut do rozsahu původní fáze sběru evidence;
  vyplynul z auditu mezer v pokrytí UI, obdobně jako v případě UC0023 pro nezmapované veřejné plochy
  procházení). Evidence sestává místo toho z:
  - Kód: `web/modules/custom/blog/blog.routing.yml` (routa `blog`, `/blog`, oprávnění `access
    content`)
  - Kód: `web/modules/custom/blog/blog.module` (`blog_theme()` — theme hook `blogs_page`)
  - Kód: `web/modules/custom/blog/src/Controller/NodeBlogController.php` (`startPage()` — logika
    dotazu/vykreslení top příspěvku a jednotlivých kategorií)
  - Kód: `web/modules/custom/blog/templates/blogs-page.html.twig` (struktura šablony výpisu)
  - Kód: `web/modules/custom/blog/blog.permissions.yml`,
    `web/modules/custom/blog/src/BlogEntityAccessControlHandler.php` (samostatný přístupový model
    `BlogEntity` — viz AF1)
  - Kód: `web/modules/custom/blog/src/Controller/PublishToHomepageController.php` (administrátorská
    mutace `is_hero_post`/`status` na `BlogEntity` — mimo rozsah tohoto čtenářského UC, zaznamenáno
    pouze na podporu AF1)
  - Konfigurace: `core.entity_view_display.node.blog.top_post.yml`,
    `core.entity_view_display.node.blog.category_post.yml`,
    `core.entity_view_display.node.blog.small_category_post.yml`, `node.type.blog.yml`
  - Obrazovky: S013 (Blog — výpis článků, `/blog`), S014 (Blog — detail článku, `/blog/<slug>`) podle
    `_ar/spec-draft/IA-screen-map.md`
  - Screenshoty: `screencapture-patrondeti-cz-blog-2026-07-04-13_16_59.png` (§14),
    `screencapture-patrondeti-cz-blog-patron-deti-nova-pomaha-a-ondrej-sokol-zvou-do-kampane-darujme-prazdniny-2026-07-04-13_17_24.png`
    (§15), podle `_ar/evidence/ui/ui-observed-areas.md` §14–§15
  - EN0024 (entita Blog), pro křížovou referenci atributů/tvaru domény zmíněnou v AF1

## Úroveň důkazu

Confirmed — routa výpisu, logika controlleru, theme hook a šablona (`blog.routing.yml`,
`NodeBlogController::startPage()`, `blog_theme()`, `blogs-page.html.twig`) existují v kódu a přímo
odpovídají UI evidenci v `_ar/evidence/ui/ui-observed-areas.md` §14 (náhledy titulek/datum/kategoriový
štítek/perex/náhledový obrázek seskupené podle tematického štítku, se zvýrazněným top příspěvkem) a §15
(text článku, propagace navázaná na kampaň, dárcovský kanál DMS SMS, výzvy k darování). Nejednoznačnost
dvou bundlů/entitních typů "blog" (AF1) a neošetřená cesta prázdného sticky dotazu (AF2) jsou
zaznamenány jako dílčí body Hypothesis/Uncertain, aniž by snižovaly celkový status Confirmed samotné
schopnosti procházení/čtení. Jde výhradně o current-state dokumentaci; blog je nepostaven v redesign
kánonu `bid-patron-deti` (rebuild epic E0004) a neuvádí se zde žádný cílový (target-state) návrh.
