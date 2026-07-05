---
doc_id: API0013
title: Organisation Dashboard Stats API
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-internal
references:
  - EN0018
  - EN0001
  - EN0008
  - FN0018
---

# API0013 – Statistické API dashboardu organizace

## Účel

Read-only HTTP lookup, který vrací zobrazovaný název jedné organizace (EN0018) a sadu čítačů žádostí
(Application, EN0001) rozdělených do skupin podle moderačního stavu — určeno k napájení dashboardu na
straně organizace, který shrnuje, kolik žádostí navázaných na pracovníky organizace je aktivních,
ve zpracování, čekajících, neúspěšných nebo dokončených. Modul `organisation` neposkytuje **žádný
jiný HTTP povrch pro koncového uživatele**: nemá žádný REST resource pro create/update/delete a jeho
`organisation.routing.yml` definuje pouze tři HTML admin routy (`workers_list`, `workers.add_form`,
`workers.edit_form`, `remove_organisation_duplicates_form`) plus entity CRUD/admin UI prostřednictvím
`OrganisationEntityHtmlRouteProvider` — jde o HTML formuláře v admin tématu Drupalu, nikoli o
systémové JSON/REST kontrakty, a jsou tedy mimo rozsah tohoto dokumentu vrstvy API (**Confirmed** —
žádný požadavek `_format`, žádná REST resource anotace na žádné z těchto rout).

Tento kontrakt slučuje dvě **verze** REST resource pluginu se stejným lookupem (`v3.0` a `v3.2`) pod
`web/modules/custom/organisation/src/Plugin/rest/resource/{v30,v32}/OrganisationResource.php`.
**Confirmed** — pro tento modul neexistuje varianta `v3.1` ani `v3.3`; pod
`src/Plugin/rest/resource/` existují pouze dva adresáře. Obě těla třídy jsou byte-for-byte identická
až na namespace, `id`/`label` pluginu a `uri_paths.canonical` — mezi verzemi tohoto modulu není
žádný rozdíl v chování (na rozdíl např. od katalogu dodavatelů v API0011, kde se v3.2/v2.3 liší).

## Konzumenti

- Autentizovaný uživatel na straně organizace (např. key account manager nebo pracovník organizace),
  který zobrazuje dashboard organizace — **Hypothesis, not evidenced**: žádný UC/FN dokument v
  `_ar/spec-draft/UC/` nebo `_ar/spec-draft/FN/` v současnosti nemapuje flow dashboardu, který by
  tento endpoint volal; odvozeno pouze z tvaru odpovědi (název + čítače příběhů/žádostí) a query
  parametru `organisation_id`.
- Na základě níže uvedených zjištění k autorizaci je endpoint technicky dosažitelný i pro anonymního
  volajícího, který zná nebo uhodne platné UUID organizace — viz Hazards (rizika).

## Autorizace

- Obě konfigurace REST resource deklarují `authentication: [cookie]` a `methods: [GET]`,
  `formats: [json]` (zdroj: `config/rest.resource.organisation_resource_v30.yml`,
  `config/rest.resource.organisation_resource_v32.yml`). Ani třída resource, ani
  `organisation.routing.yml` nedefinují pro tento endpoint požadavek `_permission` nebo `_access` na
  úrovni routy — REST modul Drupalu řídí přístup výhradně obecným oprávněním
  `restful get <plugin_id>` (**Confirmed** — `OrganisationResource extends ResourceBase` bez
  vlastního přepsání `access()`).
- **Confirmed hazard: oprávnění `restful get organisation_resource_v30` a
  `restful get organisation_resource_v32` jsou obě udělena anonymní roli** (zdroj:
  `config/user.role.anonymous.yml`, blok `permissions:`, řádky 130–131) **a zároveň** autentizované
  roli (zdroj: `config/user.role.authenticated.yml`, blok `permissions:`, řádky 32–33). Žádný jiný
  soubor role (`organisation_worker`, `patron`, `manager`, `coordinator` atd.) toto oprávnění
  samostatně neuděluje ani neomezuje — granty pro anonymní/autentizovanou roli jsou jediným
  existujícím zámkem.
- Čistý efekt: **přestože je deklarováno `authentication: cookie`, k volání tohoto endpointu ve
  skutečnosti není vyžadována žádná relace/přihlášení**, protože anonymní role již oprávnění
  `restful get` má. Jakýkoli volající, který dodá platné `organisation_id` (UUID organizace),
  obdrží název dané organizace a rozpad počtu žádostí bez jakékoli autentizace.
- Neexistuje žádná kontrola tenantu/vlastnictví: resource neověřuje, že volající uživatel je
  pracovníkem, key account managerem nebo vlastníkem požadované organizace (EN0018) — resolvuje
  jakékoli UUID organizace uvedené v query stringu a vrátí jeho čítače bez ohledu na identitu
  volajícího. Křížová vazba: **FN0018 (Identity & Access Control)** upravuje obecný model oprávnění;
  tento endpoint stojí mimo jakákoli oprávnění na úrovni entity `organisation` definovaná v
  `organisation.permissions.yml` (`view published organisation entity entities`,
  `edit organisation entity entities` atd.) — ta upravují pouze HTML admin routy, nikoli tento REST
  kontrakt.

## Požadavek

### Přehled endpointů

| # | Metoda + cesta | Plugin ID | Konfigurační soubor |
|---|---|---|---|
| 1 | `GET /api/3.2/organisation` | `organisation_resource_v32` | `rest.resource.organisation_resource_v32.yml` |
| 2 | `GET /api/3.0/organisation` | `organisation_resource_v30` | `rest.resource.organisation_resource_v30.yml` |

Aktuální verzí je odvozena **v3.2** (vyšší číslo, v souladu s obecnou verzovací linií `v3.x`
platformy pozorovanou i u dalších modulů). Obě verze zůstávají současně aktivní (`status: true`
v obou konfiguracích) bez jakéhokoli označení zastaralosti ve zdrojovém kódu. **Partial** — kterou
verzi skutečně volá živý konzument, není v tomto pouze backendovém zdrojovém stromu evidováno.

### Vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `organisation_id` | UUID organizace (EN0018), která se má vyhledat | ano (funkčně) | Čte se z query stringu (`\Drupal::request()->query->get('organisation_id')`), nikoli jako path parametr. **Confirmed** — pokud je vynechán nebo neodpovídá žádnému UUID organizace, lookup nevrátí shodu a endpoint odpoví chybou ve tvaru 404 popsanou níže; neexistuje samostatný výsledek pro "chybějící parametr". |

Tělo požadavku se nečte; jde o `GET` lookup bez těla (pouze query string).

## Odpověď

### Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `name` | Zobrazovaný název organizace (atribut `name` EN0018) | string, přes `OrganisationEntity::getName()` |
| `count.active_stories` | počet žádostí (EN0001), jejichž aktuální stav spadá do skupiny `org_stats_active_stories` A jejichž `patron` (reference EN0001 na patrona) je jedním z pracovníků této organizace | integer; viz poznámka k Side Effects/skupinám stavů níže |
| `count.processing_applications` | totéž, rozděleno skupinou `org_stats_processing_applications` | integer |
| `count.waiting_applications` | totéž, rozděleno skupinou `org_stats_waiting_applications` | integer |
| `count.failed_stories` | totéž, rozděleno skupinou `org_stats_failed_stories` | integer |
| `count.finished_stories` | totéž, rozděleno skupinou `org_stats_finished_stories` | integer |
| `stats.total_amount` | zamýšlená celková částka darů/daru přiřazená k organizaci | **Confirmed hardcoded to the literal `0`** v obou verzích resource — pole má vždy hodnotu `0` bez ohledu na skutečná data o darech; není počítáno žádným dotazem. Označeno jako riziko níže. |

Každá skupina `count.*` je definována stejnojmenným objektem jednoduché konfigurace Drupalu
(`patron_base.application_statuses.org_stats_<bucket>`), který určuje, které z přibližně 60
moderačních stavů žádosti do dané skupiny patří (mapa stav → příslušnost ke skupině, hodnoty `'0'`
pro "není v této skupině" nebo strojový název stavu pro "je v této skupině"). Samotné definice
skupin jsou konfigurace, nikoli obsah business rule vlastněný tímto API dokumentem — viz EN0001 pro
slovník stavů žádosti a BR-ApplicationStatusGovernance pro správu samotného modelu stavů.

Implementace `getApplicationsByStates()` dotazuje přímo syrovou DB tabulku `application`
(`SELECT COUNT(*) FROM application WHERE state IN (:states) AND patron IN (:worker_ids)`), a obchází
tak entity API — **Confirmed**, detail na úrovni kódu je zde uveden pouze pro vysvětlení hranic pole
(state ∈ skupina AND patron ∈ pole `worker` této organizace, EN0018), nikoli jako implementační
předpis.

Odpověď se nekešuje (`addCacheableDependency(['#cache' => false])` — **Confirmed**, obě verze).

### Chybové výstupy

| Výsledek | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `404` `{"error": "organisation_not_found"}` | žádná entita organizace neodpovídá dodanému UUID `organisation_id` (včetně případu, kdy je parametr zcela vynechán) | ano (s platným UUID) | Jediná strukturovaná chybová cesta v resource; **Confirmed**, obě verze identické. |
| Nezachycená chyba PHP | `getApplicationsByStates()` je volána s podmínkou `count($states) && count($states)` (stejná podmínka duplikovaná v obou verzích) — pokud organizace má **nulu pracovníků** (`getWorkers()` vrací prázdné pole), dotaz se přesto provede s prázdným placeholderem `:organisation_workers[]` | **Uncertain** — není evidováno proti živé instanci, zda expandované binding pole (`[]`) v Drupalu prázdné pole toleruje, nebo vyvolá chybu; pro případ nulového počtu pracovníků neexistuje žádný defenzivní early-return | Označeno jako otevřená otázka, nikoli jako potvrzený pád — bez runtime evidence dle `_ar/tasks/Runtime-truth-policy.md`. |

## Vedlejší efekty

Žádné. Oba endpointy jsou čistě read — nevytváří se, neaktualizuje se ani nemaže se žádný stav
organizace, žádosti ani jiné entity (**Confirmed** — v žádné metodě `get()` není volání `->save()`).

## Rizika (current-state)

- **Anonymní, neautentizovaný čtecí přístup k čítačům žádostí pro danou organizaci.** Obě oprávnění
  `restful get organisation_resource_v30`/`v32` jsou udělena anonymní roli
  (`config/user.role.anonymous.yml`), přestože je v konfiguraci resource deklarováno
  `authentication: cookie`. Jakýkoli externí volající, který dodá (nebo enumeruje/uhodne) platné UUID
  organizace, si může přečíst název dané organizace a úplný rozpad stavů žádostí bez přihlášení. Je
  to stejný current-state vzor jako u několika dalších veřejných endpointů typu "restful get" na této
  platformě (např. katalog dodavatelů v API0011), avšak zde jde o provozní data specifická pro
  konkrétní organizaci (počty žádostí navázané na personál této organizace), nikoli o obecná veřejná
  referenční data — jde tedy o materiálně vyšší citlivost než u veřejného katalogového feedu.
- **Žádná kontrola tenantu/vlastnictví.** Resource nikdy neověřuje, že volající uživatel je s
  požadovanou organizací asociován (jako vlastník, key account manager nebo pracovník) — vrátí
  čítače jakékoli organizace jakémukoli volajícímu, který dodá její UUID, čímž se ještě zesiluje výše
  uvedené riziko anonymního přístupu.
- **`stats.total_amount` je v obou verzích resource hardcoded na `0`** — název tohoto pole
  implikuje reálný peněžní součet, ale kód jej nikdy nepočítá ani nedotazuje; jakýkoli konzument,
  který se na toto pole spoléhá pro celkovou hodnotu darů, čte trvale zastaralou placeholder hodnotu.
  Zde je zaznamenáno jako kódem potvrzený current-state defekt, nikoli jako hypotéza.
- **Žádné stránkování, filtrování ani výběr polí** — dále nezvyšováno; odpověď je malý objekt čítačů
  s fixním tvarem, nikoli listový resource.
- **U žádného z endpointů není evidováno rate limiting, HMAC ani podepisování požadavků** — v
  souladu s celoprojektovým current-state vzorem, kdy REST resources v prozkoumaném zdrojovém kódu
  nemají žádnou další kontrolu integrity na transportní úrovni ani throttling.
- **UUID organizace není tajemství a jako takové se s ním ani nezachází** — UUID jsou typicky
  vystavena i jinde (např. v odkazech admin UI, exportech); v kombinaci s výše uvedeným rizikem
  anonymního přístupu to v současném systému efektivně dělá ze statistik žádostí po organizacích
  uhodnutelný/enumerovatelný veřejný zdroj dat.

## Reference

- EN: EN0018 (Organisation — název, soupis pracovníků, key account manager), EN0001 (Application —
  reference `patron` a slovník moderačních stavů, který skupiny čítačů rozdělují)
- FN: FN0018 (Identity & Access Control — obecný model oprávnění; zámek `restful get` tohoto
  endpointu stojí mimo oprávnění na úrovni entity `organisation`, která FN0018 jinak upravuje)
- UC: žádné neidentifikováno — viz Open Items
- BR: BR-ApplicationStatusGovernance (upravuje slovník stavů žádosti rozdělený konfiguračními
  skupinami `org_stats_*`; pouze odkazováno, nikoli opakováno)

## Otevřené otázky

- **Žádný UC/FN podklad nezakotvuje použití tohoto endpointu na straně konzumenta.** Žádný dokument
  use-case ani capability v současnosti nemapuje, kde/jak UI dashboardu organizace volá
  `/api/{3.0,3.2}/organisation`. Tento kontrakt je zakotven přímo ve zdrojovém kódu REST resource a
  v entitních dokumentech EN0018/EN0001; budoucí UC průchod může zpřesnit sekce "Účel" a "Konzumenti"
  poté, co bude tento konzumentský flow zmapován.
- **Kterou verzi (v3.0 nebo v3.2) skutečně volá živé SPA/admin UI** není v tomto pouze backendovém
  zdrojovém stromu evidováno (**Partial**).
- **Chování dotazu při prázdném soupisu pracovníků je Uncertain** — zda organizace s nulou
  pracovníků způsobí nezachycenou chybu, nebo prostě vrátí `0` pro každou skupinu, není potvrzeno
  proti živé instanci (viz Chybové výstupy).
- **Grant anonymního přístupu může být neúmyslný** (výchozí nastavení REST oprávnění Drupalu
  ponechané otevřené, nikoli záměrné rozhodnutí o veřejném API) — zaznamenáno pouze jako current-state
  fakt; zda je to zamýšlené, je Unknown a mělo by být potvrzeno s vlastníkem produktu/bezpečnosti
  předtím, než rebuild tuto přístupovou cestu buď zachová, nebo uzavře.
