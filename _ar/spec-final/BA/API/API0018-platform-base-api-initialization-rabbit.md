---
doc_id: API0018
title: Platform Base API (Initialization & RabbitMQ Stub)
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-public
references:
  - EN0004
  - EN0009
  - FN0006
  - UC0023
---

# API0018 – Základní platformové API (inicializace a RabbitMQ stub)

## Účel

Dvě nesouvisející, nízkoúrovňové HTTP rozhraní exponovaná vlastními REST resource pluginy modulu
`patron_base` (`web/modules/custom/patron_base/src/Plugin/rest/resource/`):

1. **`GET /api/init`** — jediný bezparametrický dotaz, který vrací globální, celosite agregované
   hodnoty (počty aktivních/dokončených Campaign, průměrné/celkové uhrazené částky darů, počet
   podporovatelů, rozpad podle regionu/kategorie a "transparentní účet" důkazní hodnoty) konzumované
   veřejnou úvodní/landing stránkou k zobrazení statistik důvěryhodnosti/důkazu. **Confirmed**, zdroj:
   `InitializationResource.php`.
2. **`POST /api/2.2/rabbitmq`** — verzovaný (`v2.2`) stub endpoint, který přijme libovolné tělo
   požadavku a bezpodmínečně vrátí napevno zakódované potvrzení úspěchu, aniž by odeslaná data jakkoli
   četl, validoval, zařazoval do fronty nebo persistoval. **Confirmed**, zdroj:
   `v22/RabbitMQRestResource.php`.

Oba endpointy nesdílí žádný datový model, žádného konzumenta ani žádný vztah v rámci lifecycle; jsou
seskupeny do jediného kontraktu pouze proto, že představují celý REST-resource-plugin povrch
vlastněný modulem `patron_base` (`InitializationResource` a `RabbitMQRestResource` jsou jediné dvě
třídy pod `src/Plugin/rest/resource/`). Další dva HTTP-facing endpointy modulu
(`POST /api/file` — upload souborů, `GET /api` — vyhledání base-URL) jsou obyčejné Drupal
`_controller` routy deklarované v `patron_base.routing.yml`, nikoli REST resource pluginy, a jsou zde
zmíněny jen jako přiléhající povrch modulu, nikoli jako součást payload scope tohoto kontraktu
(viz Open Items).

## Konzumenti

- **`GET /api/init`** — veřejně přístupná úvodní/landing stránka (anonymní návštěvník webu nebo
  jakákoli session), která zobrazuje globální statistiky důkazu/důvěryhodnosti (počty campaign,
  celkovou darovanou částku, počet podporovatelů, mapu regionů). **Confirmed** podle tvaru vracených
  dat (`globals.campaigns`, `globals.proof_stats`, `globals.region_stats`, `globals.transparent`);
  žádný volající frontendový template/JS není v tomto backend-only source stromu přítomen, takže
  přesná renderující plocha je **Partial**.
- **`POST /api/2.2/rabbitmq`** — neznámý/nezdokumentovaný konzument. Žádná odkazová vazba na tuto
  cestu neexistuje nikde jinde ve skenovaném modulu `patron_base` ani jinde ve stromu custom modulů
  (cross-checked proti `_ar/evidence/flow-index.md` FL056, který nezávisle hodnotí tento endpoint jako
  `Hypothesis` — "is RabbitMQ actually used or scaffolding?"). **Uncertain** — žádný potvrzený
  konzument.

## Autorizace

- **`GET /api/init`** — veřejně dostupný, přihlášení není vyžadováno. **Confirmed**:
  `rest.resource.initialization_rest_resource.yml` deklaruje `authentication: [cookie]`,
  `methods: [GET]`, žádné omezení route pomocí `_permission`/`_access` (pro tuto cestu neexistuje
  v `patron_base.routing.yml` žádná dedikovaná route — je registrována čistě jako Drupal
  REST-modulový resource, chráněný obecným oprávněním
  `restful get initialization_rest_resource`).
  `config/user.role.anonymous.yml` i `config/user.role.authenticated.yml` obě udělují
  `restful get initialization_rest_resource` (zdroj: `user.role.anonymous.yml:119`,
  `user.role.authenticated.yml:129`). Žádný jiný role file toto oprávnění neuděluje ani neomezuje.
- **`POST /api/2.2/rabbitmq`** — rovněž veřejně dostupný, přihlášení není vyžadováno. **Confirmed**:
  `rest.resource.rabbitmq_rest_resource_v22.yml` deklaruje `authentication: [cookie]`,
  `methods: [POST]`, žádné omezení `_permission`/`_access`. `config/user.role.anonymous.yml` i
  `config/user.role.authenticated.yml` obě udělují `restful post rabbitmq_rest_resource_v22`
  (zdroj: `user.role.anonymous.yml:165`, `user.role.authenticated.yml:175`). Žádný jiný role file
  toto oprávnění neuděluje ani neomezuje.
- Čistý efekt pro oba endpointy: **anonymní, neautentizovaný přístup — k zavolání kterékoli z nich
  není potřeba session, token ani role.** Žádný z endpointů nečte `$this->currentUser` způsobem, který
  by větvil chování (`InitializationResource` injektuje `AccountProxyInterface`, ale přiřazení do
  property je zakomentované; `RabbitMQRestResource` ji injektuje, ale nikdy ji v `post()` nečte).

## Request

### Přehled endpointů

| # | Metoda + cesta | Plugin ID | Konfigurační soubor |
|---|---|---|---|
| 1 | `GET /api/init` | `initialization_rest_resource` | `rest.resource.initialization_rest_resource.yml` |
| 2 | `POST /api/2.2/rabbitmq` | `rabbitmq_rest_resource_v22` | `rest.resource.rabbitmq_rest_resource_v22.yml` |

### Poznámky k verzování

Obě plugin ID i task brief popisují tento modul jako pokrývající verzové řady `v3.1`/`v3.2`/`v3.3`
jinde v platformě (jak je vidět u jiných modulů, např. u rodin Campaign/Supplier).
**Žádný z endpointů v tomto kontraktu tento vzor nedodržuje** — **Confirmed**, kód:

- `initialization_rest_resource` nemá **žádný verzový segment** ve svém `uri_paths` (`canonical`
  = `/api/init`) a **neexistuje žádný alternativní verzový adresář** pod
  `src/Plugin/rest/resource/` pro "initialization" resource. Existuje přesně jedna verze tohoto
  endpointu v aktuálním zdrojovém kódu.
- `rabbitmq_rest_resource_v22` nese označení **`v2.2`** (jak v příponě svého plugin ID, tak ve svém
  `uri_paths` — `create` = `/api/2.2/rabbitmq`), což je *starší*, nikoli novější, než řada
  `v3.x` viditelná jinde v platformě. Žádná varianta `v2.3`, `v3.0`, `v3.1`, `v3.2` ani `v3.3`
  tohoto resource neexistuje nikde ve stromu custom modulů (**Confirmed** — jediný podadresář
  `v22/` je jediným verzovým namespace pod
  `patron_base/src/Plugin/rest/resource/`).

Aktuální verze pro oba endpointy je tedy prostě **jediná existující verze** — pro tento modul
neexistuje žádné slučování více verzí, na rozdíl od jiných API kontraktů v této sadě (např.
dvojice Supplier v2.3/v3.2 v API0011).

### Vstupy — `GET /api/init`

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| *(žádné)* | Bezparametrický dotaz | — | **Confirmed** — `get()` nečte žádný query/path parametr a nepřijímá žádné argumenty. |

### Vstupy — `POST /api/2.2/rabbitmq`

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| *(neomezeno)* | Tělo požadavku je přijímáno jako `array $data` dle signatury metody | ne | **Confirmed** — tělo metody `post(array $data)` nikdy nečte `$data`; jakékoli JSON tělo (nebo žádné) je přijato a tiše zahozeno. Neexistuje žádná validace pole, tvaru ani content-type. |

## Response

### Úspěch — `GET /api/init`

| Pole | Význam | Poznámky |
|---|---|---|
| `globals.campaigns.active` | počet Campaign (EN0004) se `campaign_status = active` | integer; entity query na entity typu `campaign`, `accessCheck()` ponechaný na výchozí hodnotě (povoleno) |
| `globals.campaigns.completed` | počet Campaign se `campaign_status` v `[completed, completed_partly]` | integer |
| `globals.proof_stats.payment_avg` | průměrná výše daru | **napevno zakódovaná konstanta `500`** — **Confirmed, nikoli počítaný průměr**; tělo metody ignoruje reálná data Transaction (EN0009) a vždy vrací literál `500` |
| `globals.proof_stats.payments_total_amount` | suma uhrazených částek darů | integer; raw SQL `SUM(price)` nad `{transaction}` filtrovaný na `ext_status = 'PAID' AND is_donation = 1 AND test = 0` |
| `globals.proof_stats.supporters_total` | počet distinktních dárců | integer; raw SQL `COUNT(DISTINCT user_id)` nad `{transaction}` se stejným filtrem `PAID`/`is_donation`/`test` |
| `globals.region_stats` | rozpad počtu aktivních Campaign podle regionu a kategorie, plus souhrn `combined` za region | object; klíče jsou napevno zakódované CZ region-slug a gift-category-slug labely (14 regionů, 6 kategorií) mapované z raw ID taxonomických termů zapečených do PHP zdrojového kódu (ID termů `kraj` 1–14, ID termů `gift_category` 71–76); řádky s hodnotou `kraj`/`gift_category` **mimo** tyto napevno zakódované rozsahy ID jsou z odpovědi tiše vypuštěny (žádný fallback/"jiné" bucket) |
| `globals.transparent.campaigns` | počet Campaign s příznakem "transparent" | integer; `1060 + COUNT(DISTINCT campaign) FROM transaction WHERE transparent=1` — `1060` je **napevno zakódovaný historický základní offset** přičtený k živému počtu |
| `globals.transparent.allocated` | celková částka směrovaná přes transparentní/sběrný účet, s vyloučením vlastní Campaign tohoto účtu | integer; `SUM(price) FROM transaction WHERE transparent='1' AND ext_status='PAID' AND campaign != <transparent_account setting>` |

Odpověď je cacheovatelná až na 1 hodinu (`#cache max-age: 3600`, cache context `url`, cache tag
`campaigns` — **Confirmed**, `ResourceResponse::addCacheableDependency()`).

### Úspěch — `POST /api/2.2/rabbitmq`

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | fixní literál | vždy string `"success"`, HTTP `200` — **Confirmed**, bezpodmínečně; žádná větev v `post()` nemůže produkovat jinou hodnotu |

### Chybové výstupy

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `GET /api/init` — nezachycená PHP chyba | chybějící/nesprávně nastavené `Settings::get('transparent_account')`, nebo taxonomické ID `kraj`/`gift_category` odchýlené od napevno zakódovaných map, by mohlo způsobit null-dereference nebo chybu ve tvaru SQL | nezdokumentováno | **Uncertain** — v žádné z privátních helper metod neexistuje try/catch ani defenzivní kontrola; projevilo by se jako obecný 5xx, nikoli strukturovaná API chyba. Neověřeno proti živé instanci dle `_ar/tasks/Runtime-truth-policy.md`. |
| `POST /api/2.2/rabbitmq` — žádné zaznamenané | endpoint nemá žádnou chybovou větev | n/a | **Confirmed** — každé volání, které se dostane do `post()` (tj. projde vlastním zpracováním REST/serializer požadavku v Drupalu), vrátí `200 {"status":"success"}` bez ohledu na obsah payloadu. |

## Vedlejší efekty

- **`GET /api/init`** — žádné. Čisté čtení napříč `campaign` a `{transaction}`; žádný entitní ani
  databázový řádek není vytvořen, upraven ani smazán (**Confirmed** — v žádné metodě neexistuje
  `->save()` ani `INSERT`/`UPDATE` příkaz).
- **`POST /api/2.2/rabbitmq`** — **žádné**, přestože cesta a název pluginu implikují akci
  publikování do fronty. **Confirmed** — tělo požadavku není nikdy zkoumáno, žádný RabbitMQ
  klient/služba není vyvolána a žádná zpráva není zařazena do fronty, publikována ani persistována
  nikde v `post()`. Název endpointu je jediným důkazem, že RabbitMQ integrace byla někdy zamýšlena;
  implementace je no-op stub. To je v souladu s již existujícím nezávislým flow-mining důkazem
  (`_ar/evidence/flow-index.md` FL056: "RabbitMQ ... Hypothesis"; `_ar/spec-draft/FLOW-candidates.md`:
  "is RabbitMQ actually used or scaffolding?"; `_ar/spec-draft/DOMAIN-ubiquitous-language.md`:
  "Messaging infrastructure endpoint (Hypothesis-confidence, not confirmed in current behavior);
  transport plumbing, not a domain concept").

## Rizika (current-state)

- **`POST /api/2.2/rabbitmq` je veřejný, neautentizovaný no-op stub, který vždy hlásí úspěch.**
  Kdokoli (bez nutnosti přihlášení) může `POST`-nout na tuto cestu libovolný payload a obdrží
  `200 {"status":"success"}` bez ohledu na to, co — pokud vůbec něco — se s ním měl stát. Pokud
  jakýkoli aktuální nebo historický volající (interní nebo partnerský) považuje tuto odpověď
  `200`/`success` za potvrzení, že zpráva byla skutečně zařazena do fronty/přeposlána, je tento
  volající tiše uváděn v omyl — odpověď je bezpodmínečná a nemá žádný vztah k tělu požadavku.
  V tomto source stromu neexistuje žádný důkaz o tom, co — pokud vůbec něco — tento endpoint aktuálně
  volá.
- **`GET /api/init` míchá reálné agregační dotazy s napevno zakódovanými konstantami prezentovanými
  jako vypočítaná data** (`payment_avg` je vždy literál `500`; počet transparentních campaign
  přičítá fixní historický offset `1060`). Rewrite, který by tuto odpověď považoval za věrnou hodnotu
  "průměrného daru" nebo "počtu campaign" bez zohlednění těchto konstant, by reprodukoval
  zastaralé/fabrikované hodnoty místo živé finanční reality platformy.
- **Žádná paginace, filtrování, rate limiting, HMAC ani podepisování požadavků na žádném z
  endpointů** — v souladu s celoprojektovým current-state vzorem, kdy anonymní veřejné endpointy
  nemají ve skenovaném zdrojovém kódu žádnou další transportní kontrolu integrity nebo throttlingu.
  Zde je toto povýšeno na named hazard (nikoli jen rutinní poznámku) specificky pro
  `/api/2.2/rabbitmq`, protože neautentizovaný endpoint, který přijme a zahodí libovolné tělo, je
  otevřenou plochou pro objem požadavků/log-noise, i když dnes neprovádí žádnou akci měnící stav.
- **`region_stats` tiše vypouští řádky, jejichž ID `kraj`/`gift_category` leží mimo napevno
  zakódované rozsahy 1–14 / 71–76** — pokud budou někdy přidány nové regiony nebo kategorie darů
  jako taxonomické termy s ID mimo tyto rozsahy, zmizí z veřejného rozpadu podle regionu/kategorie
  bez jakékoli chyby nebo log signálu.
- **`InitializationResource` injektuje `AccountProxyInterface $current_user`, ale nikdy jej
  nepřiřadí do property (řádek s přiřazením je zakomentovaný)** — mrtvý konstruktorový parametr;
  sám o sobě nejde o bezpečnostní riziko (endpoint je záměrně přístupný anonymně), ale ukazuje, že
  třída byla pravděpodobně adaptována ze session-aware resource, aniž by adaptace byla dokončena.

## Odkazy

- EN: EN0004 (Campaign — atributy `campaign_status`, `kraj`/region a `gift_category` čtené
  rozpadem podle regionu/kategorie a počty aktivních/dokončených), EN0009 (Transaction —
  příznaky paid/donation/test čtené raw-SQL proof-stat a transparent-allocation dotazy)
- FN: FN0006 (Campaign / Story Lifecycle Management — vlastní slovník stavů Campaign, proti kterému
  tento endpoint počítá)
- UC: UC0023 (Browse & Filter Story Catalogue — veřejná úvodní/katalogová plocha, kterou tyto
  proof statistiky endpointu podle odhadu podporují; UC0023 samotný dokumentuje *jiný*,
  `campaign`-modulem vlastněný endpoint pro počet regionů, `/campaign/regions/render` — nejde o
  stejný kontrakt, viz Open Items)

## Otevřené otázky

- **Žádný UC/FN dossier přímo nedokumentuje konzumentskou stranu `/api/init`.** Odhad úvodní
  stránky/landing je odvozen z tvaru response payloadu (`globals.proof_stats`,
  `globals.transparent`, `globals.region_stats` všechny čtené jako veřejné hodnoty
  "důvěryhodnost/důkaz"), nikoli z vytěženého frontend call site — v tomto backend-only source
  stromu neexistuje žádný volající template/JS.
- **`region_stats` v `/api/init` se svým předmětem (CZ rozpad podle regionu aktivních Campaign)
  překrývá se samostatně dokumentovaným endpointem `/campaign/regions/render` (vlastněným modulem
  `campaign`, popsaným v UC0023)**, ale jde o odlišnou implementaci s odlišným tvarem payloadu
  (kombinovaný rozpad podle kategorie vs. plochý počet aktivních Campaign za region v UC0023 pro
  picker widget). Zda jsou obě současně živé v produkci, nebo zda jedna nahradila druhou, **není v
  tomto source stromu zdokumentováno**.
- **Pro `POST /api/2.2/rabbitmq` neexistuje žádný důkaz o konzumentovi.** Zda je tento stub volán
  nějakou aktuální interní job, legacy partnerskou integrací, nebo jde o mrtvé/opuštěné
  scaffolding, je **Unknown** — označeno konzistentně s již existujícím `Hypothesis`-úrovňovým
  flow důkazem (FL056).
- **`POST /api/file` (upload souboru) a `GET /api` (vyhledání base-URL)** jsou přiléhající
  HTTP plochy vlastněné `patron_base` dostupné pod `/api/*`, ale jde o obyčejné Drupal `_controller`
  routy (deklarované v `patron_base.routing.yml`, chráněné oprávněním `access content`), nikoli o
  REST resource pluginy. Jsou záměrně **mimo scope** tohoto kontraktu, který je omezen na
  REST-resource-plugin plochu modulu dle task brief; pokud by budoucí pass chtěl pro ně kontrakt,
  měly by být scoped jako samostatný dokument, nikoli sloučeny sem.
- **Cesta nezachycené chyby na `/api/init`** (chybně nastavený `transparent_account` setting,
  odchylující se taxonomická ID) je výše zaznamenána jako **Uncertain**; žádná verifikace proti
  živé instanci není dostupná v rámci aktuální Runtime-truth-policy.
