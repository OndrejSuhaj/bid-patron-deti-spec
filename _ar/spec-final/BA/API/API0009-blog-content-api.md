---
doc_id: API0009
title: Blog Content API
canonical_layer: API
spec_type: api-contract
status: canonical
modules: []
contract_type: rest-public
references:
  - EN0024
  - EN0004
  - EN0008
---

# API0009 – Blog Content API

## Účel

Umožnit veřejnému web/SPA klientovi číst redakční obsah Blog (EN0024): výpis kategorií s jejich
příspěvky, jednu kategorii podle slugu, jeden příspěvek podle slugu (s doporučeními) a plochý seznam
všech příspěvků. Jde o čistě čtecí (read-only) rozhraní pro doručování obsahu marketingové/redakční
kapacity Blog — v aktuálním zdrojovém kódu neexistuje žádný REST endpoint pro vytvoření/úpravu/smazání
Blogu; autorská tvorba probíhá přes administrátorské entity formuláře Drupalu (admin routy
`blog.routing.yml`, mimo rozsah této REST smlouvy).

## Konzumenti

- **Anonymní nebo přihlášený návštěvník** — veřejný web/SPA kanál. Žádné chování specifické pro
  konzumenta nebylo zjištěno: všechny čtyři endpointy vykonávají stejný dotaz bez ohledu na identitu
  nebo roli volajícího, nad rámec brány oprávnění na úrovni REST metody popsané v sekci Autorizace.

## Typ smlouvy

`rest-public` — čtyři **dotazovací** GET endpointy, všechny v jedné verzi, `v3.2`
(`/api/3.2/blog/...`). Na rozdíl od sesterských rodin REST resource v tomto kódu (např. kampaně,
žádosti) neexistuje v aktuálním zdrojovém kódu žádná varianta `v3.0`/`v3.1`/`v3.3` pro žádný Blog
resource — pro každý resource existuje pouze jedna plugin třída, všechny v jmenném prostoru
`Drupal\blog\Plugin\rest\resource\v32`. Neexistuje proto žádná mezi-verzová behaviorální odchylka ke
sloučení; v3.2 je prostě jediná a současná verze.

| Resource | Metoda | Cesta | Plugin ID | Zdroj |
|---|---|---|---|---|
| Category dashboard | GET | `/api/3.2/blog/dashboard` | `categories_resource_v32` | `CategoriesResource.php` |
| Single category | GET | `/api/3.2/blog/category/{slug}` | `category_resource_v32` | `CategoryResource.php` |
| Single post | GET | `/api/3.2/blog/post/{slug}` | `post_resource_v32` | `PostResource.php` |
| Post listing | GET | `/api/3.2/blog/posts` | `posts_resource_v32` | `PostsResource.php` |

## Autorizace

- **Mechanismus:** Drupal core REST. Všechny čtyři konfigurace `rest.resource.*` deklarují
  `authentication: [cookie]` a `methods: [GET]`, `formats: [json]`
  (`rest.resource.categories_resource_v32.yml`, `rest.resource.category_resource_v32.yml`,
  `rest.resource.post_resource_v32.yml`, `rest.resource.posts_resource_v32.yml`).
- **Přidělení rolí (Confirmed):** oprávnění `restful get categories_resource_v32`,
  `restful get category_resource_v32`, `restful get post_resource_v32` a
  `restful get posts_resource_v32` jsou všechna přidělena **oběma** rolím `anonymous` i
  `authenticated` (`user.role.anonymous.yml`, `user.role.authenticated.yml`). Endpointy jsou tak
  fakticky plně veřejné — deklarace autentizace `cookie` nevyžaduje relaci, protože samotná role
  anonymous již dané oprávnění má.
- **Bez kontroly přístupu na úrovni entity:** žádná ze čtyř metod `get()` daných resourců nevolá
  vlastní access control handler entity Blog (`BlogEntityAccessControlHandler`, který podmiňuje
  přístup oprávněními `view published blog entity entities` / `view unpublished blog entity entities`).
  Všechny čtyři resource dotazují základní tabulku `blog` a taxonomické tabulky přímo přes
  `\Drupal::database()`, a obcházejí tak kontrolu přístupu na úrovni entity zcela.
- **Publikování jen zveřejněných záznamů je implicitní, nikoli ověřované přístupovou kontrolou
  (Confirmed / hraničící s bezpečnostním rizikem):**
  - `PostsResource` a `BlogService::getPosts()` (používané `CategoryResource` /
    `CategoriesResource`) filtrují `blog.status = 1` přímo v SQL — neuveřejněné příspěvky jsou tedy
    vyloučeny konstrukcí dotazu, nikoli přístupovou kontrolou. `PostResource` naproti tomu načítá
    příspěvek podle slugu (`select id from blog where slug=:slug`) **zcela bez filtru `status`**:
    neuveřejněný příspěvek Blogu je plně čitelný jakýmkoli volajícím (včetně anonymního), pokud je
    jeho slug znám nebo uhodnut. Toto je současné riziko (hazard): neuveřejněný/rozpracovaný obsah
    Blogu je vystaven přes `GET /api/3.2/blog/post/{slug}` anonymním volajícím, což je v rozporu s
    bránou oprávnění `view unpublished blog entity entities`, kterou jinak entitní model definuje
    (EN0024; `BlogEntityAccessControlHandler`).
- **Žádný požadavek na CSRF** nad rámec výchozích nastavení Drupal core pro autentizované cookie
  relace; v praxi se neuplatní, protože GET požadavky a anonymní přístup CSRF token nevyžadují.
- **Žádné omezení frekvence (rate limiting) ani throttling** není přítomno v žádné ze čtyř resource
  tříd ani jejich konfigurací.

## Požadavek (Request)

### `GET /api/3.2/blog/dashboard` — Category dashboard

Žádné parametry v cestě ani v query stringu. Vrací hero příspěvek plus všechny aktivní kategorie
blogu s jejich příspěvky.

### `GET /api/3.2/blog/category/{slug}` — Single category

| Pole | Význam | Povinné | Poznámky |
|---|---|---|---|
| `slug` (path) | Hodnota `field_slug` taxonomického termu kategorie | ano | Prázdný nebo nerozpoznatelný slug vrací výsledek `invalid_slug` popsaný níže. |
| `limit` (query) | Velikost stránky pro seznam příspěvků kategorie | ne | Čteno přímo z query stringu požadavku uvnitř `BlogService::getPosts()`/`hasMoreResults()`; uplatní se pouze pokud jsou přítomny současně `limit` i `offset` s neprázdnou hodnotou — jinak se vrací celý nepaginovaný seznam příspěvků. Není dokumentováno jako explicitní REST parametr v anotaci pluginu; klasifikováno jako Partial. |
| `offset` (query) | Posun (offset) pro paginaci seznamu příspěvků kategorie | ne | Stejné párové chování jako u `limit`; při absenci má výchozí hodnotu `0`, ale samotná výchozí hodnota paginaci nespouští — viz Open Items. |

### `GET /api/3.2/blog/post/{slug}` — Single post

| Pole | Význam | Povinné | Poznámky |
|---|---|---|---|
| `slug` (path) | Hodnota pole `slug` příspěvku blogu | ano | Prázdný nebo nerozpoznatelný slug vrací výsledek `invalid_slug` popsaný níže. Není uplatněn žádný filtr `status` — viz riziko v sekci Autorizace. |

### `GET /api/3.2/blog/posts` — Post listing

Žádné parametry v cestě ani v query stringu. Vrací každý řádek příspěvku blogu (`blog.status` není
filtrováno — viz poznámka o riziku v sekci Side Effects), od nejnovějšího vytvořeného, bez paginace.

## Odpověď (Response)

### Úspěch — `GET /api/3.2/blog/dashboard`

| Pole | Význam | Poznámky |
|---|---|---|
| `hero_post` | Krátká forma dat (viz níže) jediného příspěvku s příznakem `is_hero_post` (EN0024) | Prázdný objekt/array, pokud aktuálně žádný příspěvek není označen jako hero. |
| `categories[]` | Pole objektů kategorie v plné formě | Viz "Plná forma kategorie" níže; jedna položka na aktivní taxonomický term `blog_category`, seřazeno podle váhy termu. |

**Plná forma kategorie** (`BlogService::getCategoryFull()`):

| Pole | Význam | Poznámky |
|---|---|---|
| `id` | ID taxonomického termu kategorie | Celé číslo. |
| `name` | Zobrazovaný název kategorie | |
| `total_posts` | Počet příspěvků odkazujících na tuto kategorii | Nefiltrováno podle stavu zveřejnění — počítá přímo referenční tabulku `blog__category`, takže neuveřejněné příspěvky jsou zahrnuty do počtu, přestože jsou vyloučeny z `posts[]`. Klasifikováno jako Confirmed pozorované chování; označeno jako vnitřní nekonzistence, zde neopravováno. |
| `has_more_results` | Zda existují další příspěvky nad rámec aktuální stránky | Má význam pouze pokud byly dodány `limit`/`offset`; jinak vždy `false` — viz poznámky v sekci Požadavek. |
| `slug` | `field_slug` kategorie | |
| `color` | `field_color` kategorie | |
| `icon` | Krátká/odvozená URL obrázku `field_icon` kategorie, přes sdílený pomocník pro URL obrázků | Implementační detail odvození URL zde záměrně neopakován. |
| `posts[]` | Krátká forma dat příspěvku (volání dashboard) nebo plná forma (volání jedné kategorie s `withHeroPost=true`) | Viz níže Krátká forma / Plná forma příspěvku. Při volání dashboard je hero příspěvek vyloučen z `posts[]` každé kategorie (filtr `is_hero_post=0`); při volání jedné kategorie vyloučen není. |

### Úspěch — `GET /api/3.2/blog/category/{slug}`

Stejná "Plná forma kategorie" jako výše, přičemž `posts[]` zahrnuje hero příspěvek, pokud je v dané
kategorii přítomen (viz poznámka výše).

### Úspěch — `GET /api/3.2/blog/post/{slug}`

**Plná forma příspěvku** (`BlogEntity::getFullData()`):

| Pole | Význam | Poznámky |
|---|---|---|
| `id` | ID příspěvku blogu | Celé číslo. |
| `slug` | Slug příspěvku | |
| `categories[]` | Objekty kategorií v krátké formě (`name`, `slug`, `color`, `icon`) pro kategorie tohoto příspěvku | Filtrováno na aktivní (`status = 1`) termy, seřazeno podle váhy. |
| `name` | Titulek příspěvku | |
| `body` | Tělo příspěvku, převedeno z uloženého HTML na prostý text/text se strženým Markdownem | Serverová konverze pomocí konvertoru HTML-to-Markdown se stripováním tagů; nikoli syrové HTML pole. |
| `intercept` | Úvodní/teaser text příspěvku (`perex`), stejná konverze HTML na text | Název pole v odpovědi je `intercept`, nikoli `perex` — pojmenování je zachováno tak, jak je pozorováno ve zdroji. |
| `published` | Datum vytvoření příspěvku, formátováno jako `YYYY-MM-DDT23:59:59` | Pevná časová složka konce dne; nejde o skutečný časový otisk vytvoření. |
| `image` | Krátká/odvozená URL hlavního obrázku příspěvku | |
| `gallery[]` | Krátké/odvozené URL galerijních obrázků příspěvku | |
| `cta_type` | Druh CTA: `button`, `cards`, `application_cta`, nebo `null` | Viz EN0024 pro tento atribut; podpole CTA níže jsou přítomna podmíněně podle typu. |
| `cta_button_text` | Popisek tlačítka CTA | Přítomno pouze pro `cta_type = button` nebo `cards`; u `button` pouze pokud existuje rozpoznatelný cíl (explicitní odkaz, nebo navázaná Kampaň EN0004, která je `active` a má slug) — jinak je `cta_type` serverem vynulován a toto pole je vynecháno. |
| `cta_button_link` | Cílová URL tlačítka CTA | Pro `button` s navázaným cílem Kampaně odvozeno jako `/pribeh/{campaign.slug}` místo uložené URL. Pro `cards` uložený/konfigurovaný odkaz. |
| `cta_cards_ids[]` | ID až 3 Kampaní (EN0004) vybraných konfigurovaným filtrem CTA | Přítomno pouze pro `cta_type = cards`; výběr je jeden z: nejdříve končící aktivní, nejnižší procentuální podpora aktivní, aktivní v regionu, nebo aktivní v kategorii (viz EN0024 `cta_filter`). Dotazováno tímto modulem přímo proti tabulce `campaign` — nikoli přes API/FN kapacitu Kampaně. |
| `cta_title` | Nadpisový text CTA | Přítomno pouze pro `cta_type = application_cta`. |
| `recommendations[]` | Až 3 objekty příspěvku v krátké formě | Nejnověji vytvořené **zveřejněné** příspěvky s vyloučením aktuálního (`status=1`, `id <> current`); viz níže Krátká forma příspěvku. |

**Krátká forma příspěvku** (`BlogEntity::getShortData()`; používá se pro `hero_post`, položky
výpisu/doporučení a `posts[]` dashboardu):

| Pole | Význam | Poznámky |
|---|---|---|
| `slug` | Slug příspěvku | |
| `link_text` | Lokalizovaný popisek výzvy k akci ("Číst více") | Serverem vyrenderovaný UI text vložený do API payloadu, nikoli uživatelská data. |
| `categories[]` | Objekty kategorií v krátké formě | Stejná forma jako v plné formě příspěvku. |
| `name` | Titulek příspěvku | |
| `intercept` | Úvodní/teaser text, konvertovaný z HTML na text (bez značek tučně/kurzíva) | Prázdný řetězec, pokud je `perex` prázdné (nikoli vynecháno). |
| `published` | Stejný pevný formát data konce dne jako v plné formě příspěvku | |
| `image` | Krátká/odvozená URL hlavního obrázku | |

### Úspěch — `GET /api/3.2/blog/posts`

Holé JSON pole objektů v plné formě příspěvku (stejná forma jako `getFullData()` u jednoho příspěvku
výše, včetně `recommendations`... — **Partial/nejisté**: `PostsResource::get()` volá pro každý
příspěvek `getFullData()`, ale navíc nevolá `getRecommendations()` tak, jak to dělá `PostResource`;
každý objekt příspěvku v tomto výpisu má tedy plnou formu příspěvku **bez** pole `recommendations`).
Seřazeno podle `created DESC`, nefiltrováno podle stavu zveřejnění (viz poznámka o riziku v sekci Side
Effects), a bez paginace.

### Chybové výsledky (Failure Outcomes)

| Výsledek | Platí pro | Význam | HTTP status | Opakovatelné | Poznámky |
|---|---|---|---|---:|---|
| `invalid_slug` | Category, Post | Dodaný `{slug}` je prázdný nebo se nepodařilo rozpoznat žádný term/příspěvek | 400 | ano | Tělo odpovědi: `{"status":"invalid","error":"invalid_slug"}`. |
| *(nemodelováno)* | Dashboard, Posts listing | U žádného z resourců neexistuje chybová větev; oba vždy vrací 200 s (případně prázdným) výsledkem | — | — | Pokud neexistují žádné kategorie nebo příspěvky, jsou pole jednoduše prázdná — nejde o chybový stav. |

## Vedlejší efekty (Side Effects)

- **Žádné** — všechny čtyři endpointy jsou čistě čtecí; žádná entita není vytvořena, upravena ani
  smazána a není odesláno žádné hlášení/notifikace (FN/MSG se na tuto smlouvu nevztahují).
- **Cache je u každé odpovědi explicitně vypnuta** (`addCacheableDependency(false)` /
  `addCacheableDependency(['#cache' => false])`) u všech čtyř resourců — každý požadavek znovu
  vykonává své SQL dotazy; pro tento obsah není nalezen důkaz žádné interní vrstvy cache.
- **Riziko — vystavení neuveřejněného obsahu (Confirmed):** `GET /api/3.2/blog/post/{slug}` vrací
  příspěvek blogu bez ohledu na jeho pole `status` (zveřejněný/neuveřejněný), jakémukoli volajícímu
  včetně anonymního — ve vyhledávacím dotazu `PostResource::get()` není žádný filtr `status = 1` a
  neprovádí se ani kontrola přístupu na úrovni entity. Na rozdíl od toho `PostsResource` a
  `BlogService::getPosts()` filtr `status = 1` v SQL uplatňují. Jde o přímou současnou mezeru v
  důvěrnosti rozpracovaného/neuveřejněného redakčního obsahu, kdykoli se jeho slug stane známým
  (např. přes odkazy náhledu, procházení zastaralého odkazu vyhledávačem, nebo uhodnutím slugu,
  protože slugy jsou generovány deterministicky z titulku — viz EN0024).
- **Hraničící s rizikem — přímé mezimodulové SQL proti tabulce `campaign`:** logika řešení CTA
  "cards" a "button" v `BlogEntity::getCtaInfo()` dotazuje tabulku `campaign` přímo (sloupce
  `campaign_status`, `campaign_deadline`, `campaign_percentual_raised`, `kraj`, `gift_category`)
  místo přes jakoukoli servisní/API hranici Kampaně (EN0004). Jde o implementační provázanost,
  nikoli o autorizační riziko, ale je zaznamenáno, protože to znamená, že odpovědi Blog API mohou
  odrážet data životního cyklu Kampaně (EN0004), která tato smlouva jinak nevlastní ani nevaliduje.

## Odkazy (References)

- EN: EN0024, EN0004, EN0008
- UC: žádné — žádný dokument UC v aktuální rekonstrukci nemodeluje doručování obsahu Blogu jako
  use case (viz Open Questions v EN0024; Blog je zjevně administrován/konzumován mimo modelované
  toky Žádost/Příběh/Lead).
- FN: žádné — žádný dokument kapacity FN v současnosti nevlastní doručování obsahu Blogu.
- BR: žádné — žádný dokument BR v současnosti Blog neomezuje (viz EN0024).

## Otevřené body (Open Items)

- **Smlouva paginace není deklarována:** query parametry `limit`/`offset` jsou u endpointů
  kategorie čteny ad hoc z požadavku uvnitř `BlogService::getPosts()`/`hasMoreResults()`, s pravidlem
  aktivace "buď oba přítomny, nebo se neuplatní žádný", které je z pohledu klienta snadné zneužít
  (dodání pouze `offset` tiše vrátí celý nepaginovaný seznam). Zde neopravováno; zaznamenáno jako
  pozorované současné chování.
- **Vystavení neuveřejněného příspěvku přes `PostResource`** (viz riziko v Side Effects) je
  zaznamenáno jako současné chování, neřešeno — zda jde o zamýšlený mechanismus náhledu nebo o
  opomenutí, není v současných zdrojích doloženo.
- **Nekonzistence `total_posts` vs. `posts[]`** (nefiltrovaný počet vs. výpis pouze zveřejněných)
  je zaznamenána jako pozorovaná, nesmířena.
- **Pro Blog neexistuje vlastnictví UC/FN/BR** v současných vrstvách spec-draft; tento dokument API
  je zakotven pouze v EN0024. Pokud budoucí průchod UC/FN později pokryje doručování redakčního
  obsahu, `references` této smlouvy by měly být odpovídajícím způsobem aktualizovány.
- Zda má základní obsahový svazek platformy "blog" (uvedený jako kolize v pojmenování v EN0024)
  vlastní REST vystavení, je mimo rozsah tohoto dokumentu — tato smlouva pokrývá pouze
  `BlogEntity` vlastního modulu `blog` a jeho čtyři REST resourcy.
