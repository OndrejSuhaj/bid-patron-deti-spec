---
doc_id: API0010
title: Partner Logos API
canonical_layer: API
spec_type: api-contract
status: canonical
modules: []
contract_type: rest-internal
references:
  - EN0020
  - ACL0009
---

# API0010 – API pro loga partnerů

## Účel

Read-only REST zdroj vystavený custom modulem `partner`, který vykresluje veřejné seznamy log
"podporují nás" / "spřátelené organizace" — typicky widget v patičce webu — z publikovaných záznamů
Partnera (EN0020). Existují tři varianty pluginu v jedné rodině `partners_rest_resource*`; aktuálně je
funkční pouze jedna (viz Poznámky k verzování).

Evidence: `partner/src/Plugin/rest/resource/PartnersResource.php`,
`partner/src/Plugin/rest/resource/v20/PartnersResource.php`,
`partner/src/Plugin/rest/resource/v32/PartnersResource.php`,
`config/rest.resource.partners_rest_resource{,_v20,_v32}.yml`,
`config/user.role.{anonymous,authenticated}.yml`. Klasifikace: **Confirmed** (kód i aktivovaná
konfigurace jsou přítomny pro všechny tři varianty; dosažitelnost se liší — viz Autorizace).

V tomto modulu neexistuje žádný soubor `partner.routing.yml` — celé HTTP rozhraní je deklarováno
čistě přes anotace pluginu `@RestResource` (`uri_paths.canonical`) a odpovídající konfigurační
záznamy `rest.resource.*.yml`, nikoli přes routovací soubor Symfony.

---

## Konzumenti

- Veřejný frontend e-shopu (anonymní návštěvníci) — jediná aktuálně funkční varianta (v20) je
  dosažitelná bez autentizace.
- Autentizované relace dárců/uživatelů — kryté oprávněními role `authenticated` (superset oprávnění
  role anonymous); žádné odlišné chování specifické pouze pro autentizované uživatele nebylo
  evidováno.

---

## Endpointy

### Get Partner Logos

- **Metoda / cesta (v1, base):** `GET /api/partners` (plugin `partners_rest_resource`;
  `rest.resource.partners_rest_resource.yml` → `status: true`) — **na úrovni kódu vypnuto**, viz
  Poznámky k verzování.
- **Metoda / cesta (v2.0):** `GET /api/2.0/partners` (plugin `partners_rest_resource_v20`;
  `rest.resource.partners_rest_resource_v20.yml` → `status: true`) — **aktuální živá verze**.
- **Metoda / cesta (v3.2):** `GET /api/3.2/partners` (plugin `partners_rest_resource_v32`;
  `rest.resource.partners_rest_resource_v32.yml` → `status: true`) — **v konfiguraci povoleno, ale v
  kódu odstřihnuto**, viz Poznámky k verzování.
- **Formát:** pouze `json` (všechny tři varianty).

Pro tento modul neexistuje žádná varianta v3.1 ani v3.3 — zadání úlohy zmiňující v3.1/v3.2/v3.3
neodpovídá tomu, co je na disku; pro `partner` existují pouze REST pluginy/konfigurační záznamy v1
(bez verze), v2.0 a v3.2. Zaznamenáno jako mezera v evidenci, nikoli vymyšleno.

---

## Autorizace

Zkříženě ověřeno vůči `config/user.role.anonymous.yml` a `config/user.role.authenticated.yml`
(REST oprávnění vázaná na role, `restful <method> <plugin_id>`) a vůči nastavení
`configuration.authentication: [cookie]` každého zdroje. Neuplatňuje se žádný požadavek
`_permission`/`_access` na úrovni routy (neexistuje routovací soubor; jde o čisté REST-plugin routy).

| Endpoint | Anonymous | Authenticated | Poznámky |
|---|---|---|---|
| `GET /api/partners` (`partners_rest_resource`) | Nepřiděleno žádné roli | Nepřiděleno žádné roli | Žádný soubor role (anonymous, authenticated, ani žádná z dalších 13 custom rolí) nepřiděluje `restful get partners_rest_resource`. Nedosažitelné žádnou standardní rolí bez ohledu na konfigurační příznak `status: true`. **Confirmed absent**, nikoli otevřená položka. |
| `GET /api/2.0/partners` (`partners_rest_resource_v20`) | **Povoleno** — přiděleno `restful get partners_rest_resource_v20` | Povoleno (superset oprávnění anonymous) | Confirmed. |
| `GET /api/3.2/partners` (`partners_rest_resource_v32`) | **Povoleno** — přiděleno `restful get partners_rest_resource_v32` | Povoleno (superset oprávnění anonymous) | Confirmed dosažitelné, ale viz Poznámky k verzování — dosažení endpointu aktuálně vrací prázdnou odpověď bez ohledu na data. |

Žádná ze tří resources nekonzultuje řízení přístupu na úrovni entity (`PartnerEntityAccessControlHandler`)
— každá čte přímo přes `\Drupal::entityQuery()` (v20) nebo přes raw SQL (v32, v mrtvé cestě kódu),
místo aby procházela přístupově řízeným úložištěm entit, které ovládá back-office CRUD formuláře
(`administer partner entities` / `edit partner entities` / `delete partner entities` /
`view published partner entities` / `view unpublished partner entities` v `partner.permissions.yml`
— mimo rozsah této smlouvy, pouze back-office).

---

## Požadavek

### Vstupy

Žádné. Všechny tři varianty nepřijímají žádné parametry cesty, query parametry ani tělo požadavku —
GET jednoduše vrací celý aktuální seznam log.

---

## Odpověď

### Úspěch (v2.0 — aktuální živý tvar)

| Pole | Význam | Poznámky |
|---|---|---|
| `[0].title` | Literální popisek skupiny `"Podporují nás"` | Pevný český text, není odvozen z dat. |
| `[0].logos` | Pole záznamů Partnera (EN0020) s `category = support_us` | Viz tvar položky níže. |
| `[1].title` | Literální popisek skupiny `"Spřátelené organizace"` | Pevný český text, není odvozen z dat. |
| `[1].logos` | Pole záznamů Partnera (EN0020) s `category = partners` | Viz tvar položky níže. |

Každá položka v poli `logos`:

| Pole | Význam | Poznámky |
|---|---|---|
| `title` | Atribut `name` Partnera (EN0020) | |
| `img_src` | Absolutní/relativní URL loga Partnera, jak ji vrací `url()` file entity | |
| `img_width` | Šířka obrázku loga v pixelech | Čteno přes službu `image.factory`; zahrnuto pouze pokud je obrázek platný. |
| `img_height` | Výška obrázku loga v pixelech | Stejná podmínka platnosti jako `img_width`. |
| `link_url` | Atribut `link` Partnera (EN0020) (surová hodnota `uri`, nerozlišená) | |

Záznamy jsou seřazeny vzestupně podle atributu `order` Partnera (EN0020). Vracejí se pouze
publikované záznamy (EN0020 `published = true`) — je uplatněno `entityQuery()->accessCheck()`, a
záznam Partnera bez souboru loga, nebo jehož soubor loga neprojde kontrolou platnosti
`image.factory`, je z obou polí tiše vynechán.

### Úspěch (v1 — base, vypnuto v kódu)

| Pole | Význam | Poznámky |
|---|---|---|
| `error` | Literální řetězec `"disabled"` | Celý endpoint vždy vrací tento jednopolový objekt s HTTP 200, bez ohledu na volajícího nebo data — viz Poznámky k verzování. |

### Úspěch (v3.2 — povoleno, ale odstřihnuto)

| Pole | Význam | Poznámky |
|---|---|---|
| *(žádné)* | Vždy prázdné JSON pole `[]` | HTTP 200. Metoda obsahuje nepodmíněné `return new ResourceResponse([]);` před jakýmkoli kódem pro načtení dat — viz Poznámky k verzování. |

### Chybové výstupy

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| Žádná dokumentovaná chybová cesta | Všechny tři varianty vždy vracejí HTTP 200 při úspěšném volání; u žádné z nich není evidováno, že by za jakéhokoli vstupu vyhazovala výjimku nebo vracela jiný než 200 stav, protože žádná z nich vstup nepřijímá. | n/a | **Confirmed** — v metodě `get()` žádné z variant není přítomna žádná logika ošetření výjimek ani validace. |

---

## Vedlejší efekty

- Všechny tři varianty jsou pouze pro čtení. Tato rodina endpointů nevytváří, neaktualizuje ani
  nemaže žádnou entitu.

---

## Poznámky k verzování

V kódové základně koexistují tři varianty pluginu a (nezvykle) všechny tři jsou v REST konfiguraci
současně `status: true`, ale funkčně živá je pouze jedna:

- **v1 (base, `partners_rest_resource`, `/api/partners`):** metoda `get()` je stub, který
  nepodmíněně vrací `{"error": "disabled"}` — nikdy se nedostane k žádnému dotazu, načtení entity
  ani kontrole role. V kombinaci s tím, že žádná role nemá přidělené oprávnění `restful get` tohoto
  pluginu (viz Autorizace), je tento endpoint dvojnásobně nefunkční: nedosažitelný z důvodu oprávnění
  a i při přímém dosažení administrátorským/bypass účtem se jedná o no-op. **Confirmed** mrtvý
  endpoint, aktuální stav tak, jak je.
- **v2.0 (`partners_rest_resource_v20`, `/api/2.0/partners`):** jediná varianta s funkční datovou
  logikou — načítá všechny entity `partner` přes `\Drupal::entityQuery('partner')->accessCheck()`,
  seřazené vzestupně podle `order`, u každého záznamu zjišťuje soubor loga a rozměry přes
  `image.factory` a záznamy dělí do dvou pevných česky popsaných skupin podle `category`. **Toto je
  aktuální živá verze** konzumovaná veřejným webem.
- **v3.2 (`partners_rest_resource_v32`, `/api/3.2/partners`):** obsahuje téměř identickou
  implementaci jako v2.0 (raw SQL `SELECT id FROM partner ORDER BY order ASC` místo
  `entityQuery()`, a `createFileUrl()` místo `url()` pro soubor loga) — celá tato implementace je
  ale nedosažitelný mrtvý kód: jako úplně první příkaz metody `get()`, ještě před SQL dotazem a
  logikou skupinování, se vyskytuje nepodmíněné `return new ResourceResponse([]);`. Metoda je
  povolena v konfiguraci, přidělena oběma rolím (anonymous i authenticated), ale vždy vrací prázdné
  pole bez ohledu na data Partnera (EN0020). **Confirmed** přímou inspekcí — nejde o hypotézu, mrtvý
  kód je v aktuálním zdrojovém kódu přítomen a nedosažitelný.

Žádná evidence neukazuje, která z těchto tří variant je zamýšlena jako kanonická do budoucna; z
čistě aktuálně-behaviorálního hlediska je v2.0 jedinou variantou, která dnes vrací reálná data.

---

## Rizika (aktuální stav)

- **Tři povolené endpointy, jeden funkční:** všechny tři konfigurační záznamy REST (`status: true`)
  a obě veřejně přístupné role (anonymous, authenticated) přidělují oprávnění konzistentní s tím, že
  by všechny tři endpointy měly být živé, ale v1 je stub a v3.2 je mrtvý kód za předčasným `return`.
  Volající nebo integrátor, který zkontroluje pouze vrstvu konfigurace/oprávnění (bez čtení PHP), by
  rozumně, ale nesprávně dospěl k závěru, že `/api/3.2/partners` je „nejnovější" a preferovaný
  endpoint — ve skutečnosti je aktuálně ze všech tří nejméně užitečný. **Confirmed**, jde o riziko
  typu údržbové pasti, nikoli o bezpečnostní riziko.
- **Žádné přístupově řízené načtení entity:** ani v20 (přímá kontrola přístupu pouze přes
  `entityQuery`, bez konzultace `PartnerEntityAccessControlHandler`), ani mrtvá cesta kódu v32 (raw
  SQL, žádná kontrola přístupu) neprocházejí vlastním handlerem přístupu k entitě modulu. U v20 je to
  aktuálně neškodné, protože jedinou branou je `accessCheck()` v kombinaci s výchozím přístupem k
  entitě bezpečným pro anonymous/authenticated; u (aktuálně nedosažitelné) raw-SQL cesty v32 by
  opětovné povolení tohoto kódu v nezměněné podobě zcela obešlo filtrování podle publikačního stavu,
  protože SQL dotaz načítá všechna ID bez ohledu na pole `status` (published), které se uplatňuje
  pouze implicitně přes kontrolu přístupu k entitě, nikoli v SQL dotazu. **Partial** — označeno jako
  latentní riziko v mrtvém kódu, nikoli jako pozorovaný incident, protože cesta kódu v32 není
  aktuálně dosažitelná.
- **Žádná invalidace cache tagů při zápisu:** `PartnerEntity::postSave()` obsahuje zakomentované
  volání `Cache::invalidateTags(['partners'])` — invalidace cache při vytvoření/aktualizaci Partnera
  (EN0020) je ve zdrojovém kódu aktuálně vypnuta. V kombinaci s výše uvedenými veřejnými GET
  endpointy se úprava loga/názvu/pořadí záznamu Partnera v back-office nemusí promptně promítnout
  volajícím `/api/2.0/partners`, pokud je před endpointem nasazena jakákoli vrstva cachování
  stránky/odpovědi. **Confirmed** přímou inspekcí zakomentovaného řádku; samotné navazující chování
  cachování je **Unknown** (mimo rozsah evidence tohoto modulu).

---

## Reference

- EN: EN0020 (Partner)
- ACL: ACL0009 (Identity Access and Public API — aktuálně nedokumentuje oprávnění tohoto modulu;
  označeno jako mezera, viz Otevřené položky)
- UC: žádné — žádný use case v aktuální sadě draftů nemodeluje autorský vstup, editaci Partnera
  (EN0020) ani veřejnou konzumaci tohoto endpointu jako orchestrovaný flow (viz Otevřené otázky u
  EN0020).
- FN: žádná — žádná funkční kapacita v aktuální sadě draftů (`_ar/spec-draft/FN/`) nepokrývá funkci
  zobrazení log partnerů; tato smlouva je zakotvena přímo na EN0020 podle záměru Hard Rule 4
  (zakotvení na kanonický rekonstruovaný artefakt), protože aktuálně neexistuje žádná FN/UC, na
  kterou by se dalo zakotvit. Viz Otevřené položky.

---

## Otevřené položky

- Žádný dokument FN (funkční kapacita) ani UC (use case) aktuálně nemodeluje „zobrazení log
  partnerů na veřejném webu" jako kapacitu/flow. Tato smlouva je zakotvena pouze na EN0020 (entita).
  Budoucí průchod na vrstvě FN by mohl chtít doplnit minimální záznam kapacity (analogicky ke vzoru
  minimal-by-design u FN0026), aby tato smlouva měla i jiné než entitní zakotvení.
- ACL0009 (Identity Access and Public API) aktuálně neuvádí oprávnění rolí modulu `partner`; tento
  dokument je proto zaznamenává přímo z `config/user.role.*.yml`. Doporučuje se ACL0009 aktualizovat
  tak, aby tento modul zahrnovalo, pro konzistenci se způsobem, jakým jsou tam sledovány ostatní
  veřejné REST endpointy.
- Zda je base endpoint v1 (`/api/partners`, stub) a mrtvý-kód endpoint v3.2 záměrný historický
  artefakt (nahrazený, ale ponechaný pro kompatibilitu), nebo náhodný pozůstatek, není evidováno —
  zaznamenáno jako `Uncertain`, zde neřešeno.
- EN0020 sama zmiňuje (Otevřená otázka 3) možnou kolizi názvů mezi bundlem `partner` této entity a
  nesouvisející taxonomickou klasifikací `partners` používanou jinde v systému; tato smlouva API to
  dále neřeší.
