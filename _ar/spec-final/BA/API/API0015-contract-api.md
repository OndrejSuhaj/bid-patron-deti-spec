---
doc_id: API0015
title: Contract API
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-internal
references:
  - UC0004
  - EN0011
  - EN0001
  - FN0009
  - ACL0007
---

# API0015 – Contract API

## Účel

Vlastní modul `contract` vystavuje přesně **jeden** REST resource plugin: read-only sondu stavu pro
Smlouvu (EN0011) k Žádosti (EN0001). Všechny ostatní HTTP povrchy tohoto modulu (`contract.routing.yml`)
související se smlouvami jsou interní Drupal **HTML admin/back-office routy** (výpis, vytvoření,
odeslání manažerovi, odeslání fundraiserovi, formulář e-podpisu) — nikoli REST/JSON kontrakty — a jsou
z tohoto dokumentu vyloučeny; viz Otevřené body.

Evidence: `contract/src/Plugin/rest/resource/v30/ApplicationContractResource.php`,
`config/rest.resource.application_contract_resource.yml`, `contract/contract.routing.yml`,
`contract/contract.permissions.yml`. Klasifikace: **Confirmed** pro existenci a implementaci
endpointu; **Confirmed**, že je aktuálně v konfiguraci vypnutý (viz Poznámky k verzování).

Zadání této úlohy zmiňovalo sloučení variant v3.1/v3.2/v3.3 do jednoho dokumentu. Žádné takové
varianty v kódu ani konfiguraci modulu `contract` neexistují — nalezen byl pouze jediný REST plugin
namespace `v30` a jediná konfigurační entita `rest.resource.application_contract_resource.yml`.
Zaznamenáno jako mezera v evidenci, nikoli vymyšleno: **tento modul nemá jinou verzovou řadu než v3.0.**

---

## Konzumenti

- Autentizovaná back-office relace (koordinátor/manažer) — jediný realistický aktuální konzument,
  odvozený z deklarovaného účelu pluginu ("get view modes by entity and bundle" — viz hazard u
  nesouhlasícího docblocku) a z jeho umístění vedle admin-only rout pracovního postupu smlouvy.
- Anonymní volající — technicky povolen konfigurací rolí (viz Autorizace), ačkoli není evidován žádný
  UI ani dokumentovaný flow, který by jej vyvolával anonymně. Označeno jako hazard, nikoli jako
  potvrzený konzument.

---

## Endpointy

### 1. Získání stavu smlouvy žádosti

- **Metoda / cesta:** `GET /api/3.0/application/contract/{application_uuid}`
  (plugin `application_contract_resource`, třída `ApplicationContractResource`)
- **Formát:** pouze `json`.
- **Stav konfigurace na úrovni resource:** `status: false` v
  `config/rest.resource.application_contract_resource.yml` — REST resource je aktuálně
  **vypnutý**. Je zde dokumentován jako kandidát na current-state kontrakt (kód i role-grants
  existují), nikoli jako živý, volatelný endpoint. Viz Poznámky k verzování a Hazardy.

Na tomto pluginu není definována žádná jiná metoda (`POST`/`PATCH`/`DELETE`).

---

## Autorizace

- **Mechanismus:** REST resource plugin (nikoli požadavek `_permission`/`_access` na úrovni Drupal
  routingu). Režim autentizace je `cookie` (`configuration.authentication: [cookie]`); neexistuje
  žádné schéma tokenu/API klíče. Autorizace je řízena čistě Drupal oprávněním
  `restful get application_contract_resource`.
- **Přidělení rolí:** potvrzeně přiděleno **oběma rolím `anonymous` i `authenticated`** (viz ACL0007
  pro úplnou current-state access matrix domény Smlouva; toto konkrétní přidělení je tam uvedeno).
  Žádná užší role (koordinátor/manažer) není samostatně vyžadována — jakýkoli volající splňující
  kteroukoli z obou obecných rolí, přihlášený nebo ne, který se dostane k (aktuálně vypnutému)
  resource, by prošel autorizací.
- **Bez kontroly přístupu na úrovni entity:** metoda `get()` resource nenačítá cílovou entitu
  `ContractEntity` ani nekonzultuje `ContractEntityAccessControlHandler` — parametr cesty
  `{application_uuid}` vůbec nepoužívá (viz Hazardy). Neexistuje tedy žádné zúžení autorizace
  per-Žádost nebo per-Smlouva nad rámec výše uvedeného obecného role oprávnění.
- **Odlišnost od UI e-sign routy:** HTML route modulu
  `application.contract.sign` (`/application/{application}/contract`) používá *odlišný*,
  nikoli REST mechanismus autorizace — vlastní požadavek routy `_application_role: fundraiser`
  (`ApplicationAccessCheck`), který ověřuje, že přihlášený Drupal uživatel je konkrétním fundraiserem
  (nebo patronem) dané Žádosti, nikoli obecné oprávnění. Tato route je mimo rozsah tohoto REST kontraktu
  (viz Otevřené body), ale je zde zmíněna, aby nedošlo k zaměnění obou modelů autorizace.

---

## Požadavek

### Získání stavu smlouvy žádosti — Vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `application_uuid` (path) | UUID cílové Žádosti (EN0001) | ano (dle vzoru routy) | **Implementací resource není čten ani validován** — `get()` parametr přijímá, ale nikdy jej nedereferencuje (viz Hazardy). Jakákoli hodnota, včetně neexistujícího nebo chybného UUID, vede ke stejné odpovědi. |

Žádné tělo požadavku (`GET`).

---

## Odpověď

### Získání stavu smlouvy žádosti — Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | Literální řetězec `"success"` | HTTP 200. Napevno zakódováno — neodráží žádný skutečný stav Smlouvy (EN0011), průběh podpisu ani stav Žádosti (EN0001). |

Žádná další pole nejsou vracena. Neexistuje pole reportující existenci smlouvy, připravenost dokumentu,
stav podpisu ani jakákoli data popsaná v lifecycle smlouvy a podpisu z UC0004 / FN0009.

### Chybové výstupy

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| Žádné evidováno | Implementace nemá žádné podmínkové větve — vždy vrací HTTP 200 s literálním úspěšným payloadem, bez ohledu na dodanou hodnotu `application_uuid`. | n/a | **Confirmed** přímou inspekcí `ApplicationContractResource::get()` — není zakódována žádná validace, žádná výjimková cesta, žádný případ 404/403. |

---

## Vedlejší efekty

- Read-only dle deklarovaného záměru. **Confirmed žádné vedlejší efekty** — metoda `get()` neprovádí
  žádné načtení entity, žádný zápis a žádný dispatch jakéhokoli druhu; vrací statické pole.
- Odpověď je označena jako nekešovatelná (`addCacheableDependency(['#cache' => false])`), takže každé
  volání znovu provádí (triviální) handler — to nemá žádný pozorovatelný vedlejší efekt, jde jen o
  poznámku k cachování.

---

## Poznámky k verzování

- Existuje pouze jedna verze: **v3.0** (`/api/3.0/...`). Žádný REST plugin, záznam v routingu ani
  konfigurační entita `v31`/`v32`/`v33` pro `application_contract_resource` nebyl nalezen nikde v
  `contract/src/Plugin/rest/` ani `config/rest.resource.*`. Toto je zaznamenáno jako potvrzená
  absence, nikoli jako opomenutí v tomto dokumentu.
- Resource v3.0 je **aktuální verzí** už z definice (je jediná), ale **aktuálně není živá**:
  `rest.resource.application_contract_resource.yml` má `status: false`. Zda byla někdy zapnuta v
  produkci, a pokud ano, kdy/proč byla vypnuta, není v dostupných zdrojích evidováno — viz Otevřené
  body.

---

## Hazardy (current-state)

- **Stub/mrtvá implementace maskující se za endpoint stavu smlouvy:** `ApplicationContractResource::get()`
  svůj vlastní argument `$application_uuid` zcela ignoruje a nepodmíněně vrací
  `{"status":"success"}`. URI endpointu (`/api/3.0/application/contract/{application_uuid}`) i
  `label` pluginu ("Application contract resource") obojí naznačují, že reportuje o Smlouvě konkrétní
  Žádosti, ale žádné takové vyhledání v kódu neexistuje. **Confirmed**
  (`contract/src/Plugin/rest/resource/v30/ApplicationContractResource.php:81-83`).
- **Nesoulad docblocku a účelu:** docblock třídy uvádí "Provides a resource to get view modes by
  entity and bundle" — nesouvisející s názvem třídy, URI ani reálným (no-op) chováním. To nasvědčuje
  tomu, že plugin může být zkopírovaný scaffolding, který nebyl nikdy dokončen/zapojen na skutečnou
  logiku. **Confirmed** přímou inspekcí textu docblocku; implikace (copy-paste původ) je
  **Hypothesis — dále neevidováno.**
- **Anonymní přidělení role u resource bez kontroly přístupu per-entita:** `anonymous` má
  `restful get application_contract_resource` (dle ACL0007), a implementace neprovádí žádné vlastní
  načtení entity ani kontrolu accesscontrolhandlerem. Pokud by byl tento resource znovu zapnut
  (`status: true`) bez doplnění opravy autorizace/načtení entity, byl by z principu veřejně volatelný,
  ačkoli dnes neuniká žádná skutečná data Smlouvy (viz předchozí hazard) — riziko je latentní, vázané
  na budoucí znovu-zapnutí, nikoli na aktuální exponovanost. **Confirmed** přidělení + **Confirmed**
  absence kontroly na úrovni entity; **Hypothesis** ohledně budoucího rizika při nezměněném
  znovu-zapnutí.
- **Vypnuto, ale plně zapojeno:** na rozdíl od resource, který je vypnutý *a zároveň* nemá přidělenou
  roli (dvojnásobně nedosažitelný, jak je vidět jinde v tomto kódu), je tento resource vypnutý na
  úrovni konfigurace (`status: false`), ale stále plně role-granted `anonymous`/`authenticated`.
  Jeho znovu-zapnutí vyžaduje pouze jediné přepnutí konfigurace (`status: true`) — bez doprovodné
  změny oprávnění — což je cesta zpět k veřejné exponovanosti s nižším odporem než u resource
  vyžadujících změnu konfigurace i oprávnění současně. **Confirmed**.

---

## Odkazy

- UC: UC0004 (Řízení smlouvy a podpisu — orchestrovaný flow, o kterém název/URI tohoto endpointu
  naznačuje, že by měl reportovat, ale nedělá to)
- EN: EN0011 (Smlouva), EN0001 (Žádost)
- FN: FN0009 (Generování smlouvy a e-podpis)
- ACL: ACL0007 (Přístup ke smlouvě a dokumentům — vlastní přidělení role `anonymous`/`authenticated`
  pro `application_contract_resource` citované výše)

---

## Otevřené body

- HTML admin/back-office routy modulu (`contract.application`, `contract.application.create`,
  `contract.application.checking`, `contract.application.send_to_fundraiser`,
  `application.contract.sign`) v `contract.routing.yml` jsou Drupal form/controller routy, nikoli
  REST/JSON kontrakty, a jsou mimo rozsah tohoto API dokumentu. Implementují skutečný flow generování
  Smlouvy, schválení manažerem a e-podpisu fundraiserem popsaný v UC0004/FN0009. Zde vyznačeno, aby
  je budoucí UI/ARCH-orientovaný průchod neztratil; výše nejsou modelovány jako endpointy.
- Zda byl `application_contract_resource` někdy živý v produkci (`status: true`) před aktuálním
  snapshotem `status: false`, a proč byl vypnut, není evidováno — zaznamenáno jako
  **Uncertain**, zde neřešeno.
- Zda na pouhé HTTP-200 odpovědi tohoto endpointu aktuálně závisí nějaký externí/mobilní klient
  (např. jako naivní ping "je subsystém smlouvy nahoře", vzhledem k tomu, že payload nenese žádná
  skutečná data), není v dostupných zdrojích evidováno. Pokud taková závislost existuje, odstranění
  nebo oprava endpointu v rebuildu by byla breaking change; vyznačeno k vyjasnění s klientem, zde
  nepředpokládáno.
- Žádný dokument vrstvy BR pojmenovaný specificky pro (ne)chování tohoto endpointu nebyl nalezen;
  `BR-ContractAndESignature` (odkazovaný z EN0011/FN0009) obsahově řídí generování/podpis Smlouvy, ale
  o tomto REST resource se nezmiňuje — konzistentní s tím, že resource je nezapojený scaffolding,
  nikoli modelované business pravidlo.
