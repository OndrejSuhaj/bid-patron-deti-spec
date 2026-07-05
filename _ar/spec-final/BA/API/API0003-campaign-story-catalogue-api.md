---
doc_id: API0003
title: Campaign / Story Catalogue API
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-public
references:
  - UC0023
  - UC0021
  - EN0004
  - EN0005
  - EN0009
  - FN0006
  - FN0024
  - BR-CampaignStoryLifecycle
  - BR-CampaignRecommendationDormant
---

# API0003 – API katalogu příběhů (Campaign)

## Účel

Veřejné, read-only HTTP rozhraní, které umožňuje klientovi (konzumující SPA a — pro jeden endpoint —
crawleru produktového katalogu Facebooku) vypisovat, filtrovat, stránkovat a načítat detail publikovaných
příběhů (Story/Příběh, EN0004) a dotazovat se na historii donátorových interakcí s dary vůči příběhům. Jde
o čtecí stranu domény Campaign/Story-Lifecycle (FN0006), která stojí za veřejným katalogem příběhů
(UC0023) a — pokud je dodáno `user_id`/`user_uuid` — zpřístupňuje data o interakcích jednotlivého donátora
používaná (dormantní) doporučovací funkcí (UC0021 / FN0024 / BR-CampaignRecommendationDormant).

Tento kontrakt slučuje pět **verzí** REST resource pluginu endpointu pro výpis příběhů (`v3.0`–`v3.3`, plus
dvojici `v2.3`), které v aktuálním zdrojovém kódu souběžně existují pod
`web/modules/custom/campaign/src/Plugin/rest/resource/`. Všechny verze jsou současně povolené
(`status: true` v každém `rest.resource.*.yml` níže) — v tomto zdroji není žádný důkaz o tom, že by starší
verze byly vyřazeny; jsou zdokumentovány jako jeden kontrakt s vyznačenými rozdíly mezi verzemi.

## Konzumenti

- Anonymní návštěvník webu / veřejně přístupná SPA (všechny list/detail endpointy — Confirmed na základě
  `authentication: cookie` + oprávnění `restful get ...` udělených roli `anonymous`, viz Autorizace).
- Přihlášená relace donátora (doplňuje `total_amount_donated` / `feedback` / filtry vázané na interakce u
  několika endpointů).
- Crawler produktového katalogu Facebooku (pouze `GET /api/2.2/campaigns_ads` — neautentizovaný strojový
  konzument XML feedu ve stylu Google Shopping, nikoli prohlížečová relace).

## Autorizace

- **Confirmed, všechny endpointy v tomto kontraktu jsou veřejně dostupné.** Každý příslušný konfigurační
  soubor `rest.resource.*.yml` deklaruje `authentication: [cookie]` a žádný požadavek
  `_permission`/`_access` na úrovni route (jde o resource REST modulu, nikoli o `*.routing.yml` route —
  REST modul Drupalu řídí přístup výhradně oprávněním `restful get <resource_id>`).
- `config/user.role.anonymous.yml` uděluje roli anonymous **všechna** z: `restful get
  campaign_rest_resource_v30`, `restful get campaign_rest_resource_v32`, `restful get
  campaigns_interacted_resource`, `restful get campaigns_recommended_resource`, `restful get
  campaigns_rest_resource_v30`, `restful get campaigns_rest_resource_v31`, `restful get
  campaigns_rest_resource_v32`, `restful get campaigns_rest_resource_v33`, `restful get
  fbfeed_rest_resource` (zdroj: `config/user.role.anonymous.yml:93,103–110,116`).
- Čistý dopad: **pro žádný endpoint v tomto kontraktu není vyžadováno přihlášení/relace/token**;
  autentizační poskytovatel `cookie` pouze *personalizuje* odpověď (viz pole závislá na autentizaci u
  jednotlivých endpointů níže), pokud je přítomen platný cookie relace — přístup jím ale není podmíněn.
- Jedinou výjimkou pouze na úrovni konfigurace je `entity.campaign` (`plugin_id: entity:campaign`,
  `rest.resource.entity.campaign.yml`): `status: false` — **zakázáno**, není součástí živého povrchu
  tohoto kontraktu. Uvedeno jen pro úplnost.
- **Riziko — týká se současného stavu, nejde o doporučení pro cílový stav:** celý katalog příběhů, včetně
  souhrnů interakcí donátora na jednotlivý endpoint (`CampaignsInteractedResource`,
  pole `total_amount_donated`) a seznamu doporučených příběhů donátora (`CampaignsRecommendedResource`),
  je dostupný **jakémukoli anonymnímu volajícímu, který dodá platné `user_uuid`/`user_id`** — neprovádí se
  žádná kontrola, že volající *je* tímto uživatelem. Jde o expozici historie darů jiného donátora ve stylu
  IDOR (Insecure Direct Object Reference) prostřednictvím uhodnutí/enumerace UUID. Označeno jako riziko
  současného stavu dle projektových instrukcí, zde neopravováno.

## Požadavek

### Přehled endpointů

| # | Metoda + cesta | Plugin ID | Konfigurační soubor | Parametry query/path |
|---|---|---|---|---|
| 1 | `GET /api/3.3/campaigns` | `campaigns_rest_resource_v33` | `rest.resource.campaigns_rest_resource_v33.yml` | viz „Filtry výpisu“ níže (používá ploché parametry `filter_*`) |
| 2 | `GET /api/3.2/campaigns` | `campaigns_rest_resource_v32` | `rest.resource.campaigns_rest_resource_v32.yml` | viz „Filtry výpisu“ níže (používá vnořené parametry `filter[...]`) |
| 3 | `GET /api/3.1/campaigns` | `campaigns_rest_resource_v31` | `rest.resource.campaigns_rest_resource_v31.yml` | viz „Filtry výpisu“ níže (vnořené `filter[...]`) |
| 4 | `GET /api/3.0/campaigns` | `campaigns_rest_resource_v30` | `rest.resource.campaigns_rest_resource_v30.yml` | viz „Filtry výpisu“ níže (vnořené `filter[...]`, bez uživatelského omezení) |
| 5 | `GET /api/3.2/campaign/{slug}` | `campaign_rest_resource_v32` | `rest.resource.campaign_rest_resource_v32.yml` | path: `slug` |
| 6 | `GET /api/3.0/campaign/{hash}` | `campaign_rest_resource_v30` | `rest.resource.campaign_rest_resource_v30.yml` | path: `hash` — **Uncertain/nefunkční**, viz Otevřené body |
| 7 | `GET /api/2.3/campaigns/interacted/{user_uuid}` | `campaigns_interacted_resource` | `rest.resource.campaigns_interacted_resource.yml` | path: `user_uuid`; query: `campaign_id` (volitelné) |
| 8 | `GET /api/2.3/campaigns/recommended/{user_uuid}` | `campaigns_recommended_resource` | `rest.resource.campaigns_recommended_resource.yml` | path: `user_uuid` |
| 9 | `GET /api/2.2/campaigns_ads` | `fbfeed_rest_resource` | `rest.resource.fbfeed_rest_resource.yml` | query: `image` (`1200x628` nebo výchozí `800x800`) |

Aktuální verze v aktivním použití klientem je odhadována jako **v3.3** (nejvyšší číslo, funkčně
nejkompletnější list endpoint — flag filtr, injektování promo/nekonečného příběhu, zpracování
transparentního účtu); v3.0–v3.2 a dvojice v2.3 zůstávají nasazeny souběžně, aniž by v kódu byl jakýkoli
příznak deprecation. **Partial** — kterou verzi/verze živá SPA skutečně volá, není v tomto pouze
backendovém zdrojovém stromu evidováno.

### Filtry výpisu — endpoint #1 (v3.3, ploché query parametry `filter_*`)

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `filter_id` | čárkou oddělená ID příběhů k zahrnutí | ne | pouze numerické, nečíselné tokeny se tiše zahazují |
| `filter_status` | čárkou oddělené hodnoty `campaign_status` | ne | `=` u jedné hodnoty, `IN` u více; pokud vynecháno, výpis není filtrován podle statusu (všechny řádky s nenulovým `campaign_status`) |
| `filter_category` | jeden slug kategorie (`health_care`, `family`, `medical_equipment`, `education`, `sport`, `leisure`) | ne | mapováno na napevno zakódované ID taxonomického termu |
| `filter_region` | jeden slug CZ kraje (14 hodnot, např. `praha`, `stredocesky`) | ne | mapováno na napevno zakódované ID termu `kraj` |
| `filter_flag` | čárkou oddělené hodnoty příznaku | ne | vyřešeno přes join přes `application` → `application__flag`; prázdná shoda ⇒ prázdná výsledná množina |
| `filter_user_interacted_campaigns` | `1`/pravdivá hodnota | ne | vyžaduje autentizovanou relaci; anonymně ⇒ prázdný výsledek |
| `filter_user_recommended_campaigns` | `1`/pravdivá hodnota | ne | vyžaduje autentizovanou relaci; anonymně ⇒ prázdný výsledek; viz UC0021 (dormantní — aktuálně nevrací žádná data ani při přihlášení) |
| `filter_organization_id` | UUID organizace | ne | resolvuje se na množinu příběhů navázaných na žádosti pracovníků dané organizace |
| `order` | jedna z hodnot `latest`, `finished_recently`, `ends_soon`, `least_percentual_support`, `interacted_at` | ne | výchozí (bez `order`) je `id DESC`; `ends_soon` navíc omezuje na budoucí termíny |
| `exclude` | čárkou oddělená ID příběhů | ne | pouze numerické |
| `offset` | celé číslo | ne | výchozí `0` |
| `limit` | celé číslo | ne | výchozí `10`; `-1` znamená „až 1000“ |
| `uid` | celočíselné ID uživatele | ne | **respektováno pouze pokud je volající anonymní** (`current_user->id() === 0`) — umožňuje anonymnímu volajícímu vydávat se za konkrétní ID uživatele pro účely omezení interakcí/doporučení; viz Rizika |
| `tu_index` | celé číslo | ne | pokud přítomno, vynutí vložení jediného „nekonečného/transparentního“ příběhu platformy na vypočítanou pozici ve výsledné množině (komentář ve zdrojovém kódu: „Univerzální příběh“) |

Endpointy #2–#4 (`v3.2`/`v3.1`/`v3.0`) přijímají stejnou *sémantiku* filtrů prostřednictvím **vnořené**
struktury query parametrů `filter[key]=value` (např. `filter[status]=active`) namísto plochých parametrů
`filter_status=...` — to je zásadní rozdíl mezi rodinou v3.0–v3.2 a v3.3. v3.0 navíc nemá žádné omezení
podle interakcí na základě `user_id`/relace (žádná uživatelská větev v `addUserData()` nad rámec výchozího
publikovaného statusu). v3.1 zavádí `user_id` (query parametr, dle UUID) plus filtry
`user_interacted_campaigns`/`user_recommended_campaigns`/`organisation_id`. v3.2 nahrazuje query parametr
`user_id` implicitním omezením podle aktuální relace a doplňuje injektování promo řádku
„nekonečného/transparentního účtu“ (heuristika offset-3, pouze neprodukční prostředí). v3.3 nahrazuje
plochý tvar filtrů vnořeným, doplňuje `filter_flag`, generalizuje injektování nekonečného příběhu přes
`tu_index` a doplňuje výše popsaný anonymní override `uid`.

### Požadavek na detail — endpointy #5/#6

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `slug` (v3.2, path) | veřejný slug příběhu | ano | vyřešeno nejprve proti živému sloupci `campaign.slug`, poté proti `campaign_slug_archive` pro historický slug (případ redirectu, viz Odpověď) |
| `hash` (v3.0, path) | zamýšlen jako „unikátní hash“ | ano | **Uncertain/nefunkční** — viz Otevřené body; handler v3.0 tento parametr ve skutečnosti na příběh nevyřeší |

### Požadavky na interakce/doporučení — endpointy #7/#8

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `user_uuid` (path) | UUID účtu cílového donátora | ano | vyřešeno prostřednictvím služby `account`; neznámé UUID ⇒ 404 (viz Chybové výsledky) |
| `campaign_id` (query, pouze endpoint #7) | omezí sumu interakcí na jeden příběh | ne | pokud vynecháno, vrací souhrny za jednotlivé příběhy pro všechny příběhy, vůči kterým má donátor uhrazenou (PAID) transakci |

### Požadavek na feed — endpoint #9

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `image` (query) | výběr stylu obrázku | ne | `1200x628`, pokud je hodnota přesně tato, jinak `800x800` |

## Odpověď

### Úspěch — endpointy #1–#4 (výpis)

| Pole | Význam | Poznámky |
|---|---|---|
| `data` | pole projekcí karet příběhů | viz „Projekce karty příběhu“ níže; každá položka doplňuje `total_amount_donated`/`interacted_at`, pokud je požadavek omezen na interakce |
| `total_count` | celé číslo | počet odpovídajících ID příběhů před stránkováním |
| `has_more_results` | boolean | `true`, pokud `offset + limit < total_count` |
| `__limit` (pouze v3.2/v3.3) | celé číslo | odráží efektivně použitý `limit` |
| `__query` (pouze neprodukční prostředí) | řetězec | ladicí řetězec s raw SQL — viz Rizika |
| `__user_id`, `__user_load`, `__displayInfiniteCampaign` (v3.3, pouze neprodukční prostředí) | ladicí pole | viz Rizika |

**Projekce karty příběhu** (`CampaignEntity::getShortData()`, `CampaignEntity.php:1247-1272`):

| Pole | Význam | Poznámky |
|---|---|---|
| `id` | ID příběhu (celé číslo) | |
| `type` | typ příběhu | `basic`, `promo`, `long_term`, `short_term` (EN0004) |
| `url_hash` | veřejný slug | název pole je historický; nese aktuální slug, nikoli hash |
| `status` | normalizovaný štítek stavu publikace | odvozený, nikoli přímo raw `campaign_status` |
| `category` | štítek kategorie | vyhledán z fixní mapy kategorií |
| `name` | název příběhu | |
| `button_text` | text CTA tlačítka | |
| `photo` | URL obrázku (krátká forma) | fotka pro list stránku, pokud je nastavena, jinak hlavní foto |
| `full_amount` | cílová částka (celé číslo) | |
| `raised_amount` | částka vybraná k dnešnímu dni (celé číslo) | |
| `hide_raised_amount` | boolean | zobrazovací příznak — viz BR-CampaignStoryLifecycle |
| `campaign_ends` | ISO datum termínu | |
| `campaign_finished` | datum ukončení nebo null | |
| `has_feedback` | boolean | u anonymního volajícího vždy `false` |
| `_percentual_support` | procento vybrané částky | |
| `total_amount_donated`, `interacted_at` | doplněno, pokud je výpis omezen na interakce | jinak nepřítomno |
| `user_allocated`, `recurring_amount`, `recurring_day`, `infinite_campaign` (v3.3, pouze řádek transparentního účtu) | pole specifická pro transparentní účet | viz otevřený bod BR-CampaignStoryLifecycle k mechanismu sběrného účtu |

### Úspěch — endpointy #5/#6 (detail)

Základní payload je `CampaignEntity::getFullData()` (`CampaignEntity.php:1344-1398`):

| Pole | Význam | Poznámky |
|---|---|---|
| `id`, `url_hash`, `status`, `category`, `name`, `button_text`, `full_amount`, `raised_amount`, `hide_raised_amount`, `campaign_ends`, `type`, `campaign_finished` | stejná sémantika jako projekce karty | |
| `gift` | objekt: `title`, `description`, `photo` | fundraisingový „dar“, na který se vybírá |
| `description_full`, `description_short` | dlouhý/krátký popis příběhu | HTML převedeno na text v plain/markdown-like formě pro `description_full` |
| `photo` | URL hlavního obrázku | |
| `patron` | objekt: `name`, `photo`, `about`, `position`, `public_email` (vždy `null`) | přítomno pouze pokud je navázán veřejný profil patrona (EN0005) |
| `kids_count`, `slider` | přítomno pouze pokud je příběh `isPromo()` | |
| `og` | objekt: `type`, `title`, `description`, `image` | Open Graph metadata pro sdílení na sociálních sítích |
| `feedback` (pouze v3.2, pouze přihlášený volající) | objekt: `intercept_title`, `intercept`, `content`, `featured_image` | jedna poděkovací zpráva od fundraisera, pokud existuje (EN0021) |
| `total_amount_donated` (pouze v3.2, pouze přihlášený volající) | celé číslo | suma uhrazených (paid) transakcí tohoto volajícího vůči tomuto příběhu (EN0009) |
| `redirect_301` (pouze v3.2) | řetězec s novým slugem | vrácen namísto plného payloadu, pokud je požadovaný slug nalezen pouze v archivu historických slugů |

### Úspěch — endpoint #7 (interacted)

Odpověď je mapa klíčovaná podle ID příběhu:

| Pole | Význam | Poznámky |
|---|---|---|
| `<campaign_id>.total_amount_donated` | suma uhrazených (PAID) transakcí tohoto donátora vůči danému příběhu | |
| `<campaign_id>.interacted_at` | časové razítko nejnovější takové transakce | |

### Úspěch — endpoint #8 (recommended)

Tělo odpovědi je to, co vrátí `$user->getRecommendedCampaigns()` — **Partial**: tvar vracený touto metodou
zde není znovu dokumentován (spadá pod agregát User/EN0008); podle UC0021 (dormantní) toto v současnosti v
živém systému nevrací žádná naplněná doporučovací data.

### Úspěch — endpoint #9 (Facebook feed)

Tělo `application/xml`, RSS 2.0 ve stylu Google Shopping s namespace `g:`; jeden `<item>` pro každý
aktivní, publikovaný příběh, pole: `g:id`, `g:title`, `g:description`, `g:link`, `g:brand` (konstanta
`patrondeti`), `g:condition` (konstanta `new`), `g:image_link`, `g:availability` (heuristika `in stock`/`out
of stock` podle procenta vybrané částky), `g:price`, `g:expiration_date`, `g:custom_label_0..3` (cílová
částka, počet zbývajících dnů, zbývající částka do cíle, vybraná částka).

### Chybové výsledky

| Výsledek | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `200` s `{"status":"failed","error":"Not Found"}` | detail endpoint (#5/#6), žádný odpovídající příběh / slug | ano | **Riziko** — stav „nenalezeno“ je signalizován HTTP 200, nikoli 404; volající musí kontrolovat tělo odpovědi |
| `404` s `{"error":"user_not_found"}` | endpointy #7/#8, `user_uuid` se nevyřeší prostřednictvím služby `account` | ano | zde je použit správný HTTP status, nekonzistentně vůči #5/#6 |
| `EntityMalformedException` (neošetřená) | endpoint #9, neexistuje žádný aktivní+publikovaný příběh | ne | vyhozena, není zachycena do strukturované chybové odpovědi — Facebooku crawleru se projeví jako obecná odpověď 5xx |
| prázdné `data: []`, `total_count: 0` | endpointy #1–#4, žádný příběh nevyhovuje kombinaci filtrů | ano | nejde o chybu; dokumentováno jako prázdný výsledek AF4 (UC0023) |

## Vedlejší efekty

Žádné. Každý endpoint v tomto kontraktu je čistě čtecí — nevzniká, neaktualizuje se ani nemaže žádný stav
agregátu příběhu, žádosti, transakce ani jiného agregátu (Confirmed — ve žádné z devíti resource tříd se
nevyskytuje volání `->save()`/zápis; v souladu s postpodmínkami UC0023). Handler výpisu endpointu #1
provádí zápis do stránkovací cache Drupalu za specifické konfigurace (pouze v3.0, trvalý cache tag
`api_campaigns`) — jde o infrastrukturní vedlejší efekt s cachováním, nikoli o doménový vedlejší efekt na
stav, a jinak zde není dále rozváděn.

## Rizika (současný stav)

- **Data o interakcích/doporučeních jsou dostupná pouze na základě UUID, bez jakékoli kontroly
  vlastnictví** (endpointy #7, #8 a omezení `user_id`/`filter_user_interacted_campaigns`/
  `filter_user_recommended_campaigns` na #1–#4): jakýkoli volající, který získá nebo uhodne `user_uuid`
  donátora, může načíst souhrny celkově darovaných částek tohoto donátora, časová razítka interakcí na
  jednotlivé příběhy a (potenciální) seznam doporučených příběhů, zcela bez autentizace. Jde o expozici
  soukromí donátora v současném systému.
- **Anonymní override `uid` na v3.3** (`campaigns_rest_resource_v33`): pokud je požadavek neautentizovaný,
  endpoint respektuje klientem dodaný query parametr `uid`, jako by šlo o vlastního uživatele relace
  volajícího, pro veškeré omezení dle interakcí/trvalých darů — což prohlubuje předchozí bod tím, že
  odstraňuje i krok vyhledání dle UUID (`uid` je uhodnutelné sekvenční celé číslo, nikoli UUID).
- **Debugovací/introspekční pole unikají mimo striktní produkční gate**: `__query` (raw SQL, s vázanými
  parametry zpětně interpolovanými pro čitelnost) a na v3.3 také `__user_id`/`__user_load`/
  `__displayInfiniteCampaign` jsou zahrnuty v JSON odpovědi vždy, když
  `Settings::get('environment') !== 'production'` — jde o hradlo řízené konfigurací prostředí, nikoli
  požadavkem; jakékoli nesprávně nakonfigurované prostředí neoznačené jako produkční (např. staging
  dostupný z internetu) odhalí anonymnímu volajícímu endpointů #1–#4 interní strukturu SQL.
- **Nekonzistentní signalizace „nenalezeno“**: detail endpointy #5/#6 vrací HTTP `200` s tělem
  `{"status":"failed"}` pro nenalezený příběh, zatímco #7/#8 správně používají HTTP `404` — při rewritu se
  nesmí předpokládat jednotná HTTP sémantika napříč touto rodinou endpointů bez opětovné verifikace každého
  z nich.
- **U žádného endpointu v tomto kontraktu není evidováno rate limiting, HMAC ani podepisování požadavků** —
  konzistentní s projektově širokým vzorcem současného stavu, kdy veřejné/anonymní endpointy nemají v
  prozkoumaném zdrojovém kódu žádnou další kontrolu integrity na transportní úrovni ani throttling.
- **Endpoint #6 (`v3.0` detail) je evidován jako nefunkční, nikoli pouze jako legacy**: viz Otevřené body.

## Odkazy

- UC: UC0023 (Procházení a filtrování katalogu příběhů — primární behaviorální podklad pro endpointy
  #1–#4), UC0021 (Doporučování příběhů, DORMANTNÍ — podklad pro endpoint #8 a filtr
  `user_recommended_campaigns`)
- EN: EN0004 (Campaign — projektovaný agregát), EN0005 (Patron — zobrazen v detailu),
  EN0009 (Transaction — zdroj souhrnů interakcí), EN0021 (Feedback — zobrazen v detailu v3.2)
- FN: FN0006 (CampaignStoryLifecycle), FN0024 (CampaignRecommendation)
- BR: BR-CampaignStoryLifecycle (odvozená pole vybrané částky/procenta, zpracování transparentního účtu,
  příznak hide-raised-amount), BR-CampaignRecommendationDormant (skutečné současné chování endpointu #8)

## Otevřené body

- **Endpoint #6 (`GET /api/3.0/campaign/{hash}`) nepoužívá svůj vlastní path parametr.** Handler
  (`v30\CampaignResource::get($hash = NULL)`, `CampaignResource.php:84-113`) parametr `$hash` zcela
  ignoruje a místo toho se pokouší regexem vyextrahovat numerické ID příběhu z
  `$this->campaign->getSlug()` — ale `$this->campaign` není před tímto řádkem nikdy přiřazeno (žádný
  konstruktor/výchozí hodnota vlastnosti), takže toto volání v běžném chování PHP skončí chybou volání
  metody na null objektu. Zaznamenáno jako
  **Uncertain — evidováno jako nefunkční ve čteném zdrojovém kódu, nepotvrzeno proti živé instanci** (žádná
  runtime instance není k dispozici dle `_ar/tasks/Runtime-truth-policy.md`). Zde neopravováno; oznámeno
  týmu rebuildu k rozhodnutí, zda je detail v3.0 ještě potřeba/dostupný.
- **Kterou verzi/verze endpointu aktuální produkční SPA skutečně volá** není v tomto pouze backendovém
  zdrojovém stromu evidováno (Partial, převzato z UC0023).
- **Přesný tvar odpovědi `$user->getRecommendedCampaigns()`** (endpoint #8) tu není znovu dokumentován —
  spadá pod agregát User (EN0008), nikoli pod tento API kontrakt; oznámeno, aby budoucí průchod EN0008
  mohl tento kontrakt upřesnit, pokud to bude potřeba.
- **Mechanismus sběrného účtu / „sloučeného příběhu“** označovaný poli pro transparentní účet
  (`user_allocated`, `recurring_amount`, `recurring_day`, `infinite_campaign`) není jednoznačně namapován
  na jedinou kombinaci `type`/`parent` — stejný otevřený bod je již sledován u EN0004/UC0023 (OQ-05); zde
  znovu neřešen.
- **`/campaign/regions/render`** (`campaign.routing.yml`, controller `RenderRegionsController::render`) je
  HTML route Drupalu, nikoli REST resource — vykresluje fragment výběru kraje spotřebovaný katalogovým UI
  (UC0023, krok 8), ale vrací markup, nikoli JSON/XML datový kontrakt, proto je z tohoto API kontraktu
  úmyslně **vyloučen**. Stejně tak `/fundraising/campaign/{campaign}/content`,
  `/fundraising/campaign/{campaign}/slug_history`, `/admin/campaign/{id}/set-active` a
  `/admin/campaign/{campaign}/pay-remaining-amount` ze stejného routovacího souboru jsou interní
  administrátorské/back-office HTML routy, nikoli veřejné REST kontrakty, a jsou zde vyloučeny — patří do
  budoucího back-office API kontraktu, pokud pro tento modul někdy vznikne.
