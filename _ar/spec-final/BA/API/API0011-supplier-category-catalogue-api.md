---
doc_id: API0011
title: Supplier / Category Catalogue API
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-internal
references:
  - EN0019
  - EN0033
  - ARCH0008
---

# API0011 – API katalogu dodavatelů a kategorií (Supplier / Category Catalogue)

## Účel

Veřejné, read-only HTTP rozhraní zpřístupňující taxonomii "Oblasti pomoci" — termíny nejvyšší úrovně
GiftCategory (EN0033), jejich podřízené podkategorie a záznamy dodavatelů Supplier (EN0019) navázané
na jednotlivé podkategorie prostřednictvím `supplier_to_category`. Jde o jednoendpointové vyhledávání
v katalogu bez jakýchkoli požadavkových parametrů: jedno volání vrátí celý strom
kategorie/podkategorie/dodavatel v jediném payloadu. Modul nevystavuje žádné HTTP rozhraní pro
vytváření/úpravu/mazání entit Supplier ani SupplierToCategory — tyto entity se správují výhradně
prostřednictvím obecných HTML admin formulářů Drupalu pro content entity
(`/admin/structure/supplier`, `/admin/structure/supplier_to_category`), které jsou mimo rozsah tohoto
kontraktu na úrovni API (jde o HTML admin routy, nikoli o systémový REST/JSON kontrakt).

Tento kontrakt slučuje dvě **verze** REST resource pluginu pro totéž vyhledávání
(`v2.3` a `v3.2`), které v aktuálním zdrojovém kódu koexistují v adresáři
`web/modules/custom/supplier/src/Plugin/rest/resource/`. Obě jsou zapnuté současně
(`status: true` v obou konfiguracích `rest.resource.*.yml`) — nic nenasvědčuje tomu, že by starší
verze byla vyřazena. Pro tento modul neexistuje varianta `v3.1` ani `v3.3` (**Confirmed** — pod
`src/Plugin/rest/resource/` existují jen dva adresáře: výchozí namespace = v2.3, a `v32/`).

## Konzumenti

- Anonymní návštěvník webu / veřejně přístupná SPA — **Confirmed**, viz Autorizace.
- Přihlášená session dárce/uživatele — stejná odpověď; stav session nemá na payload žádný vliv
  (**Confirmed**, v žádné z metod `get()` se nečte podmínka na `$this->currentUser`, přestože je tato
  property injektovaná).

## Autorizace

- **Confirmed, oba endpointy tohoto kontraktu jsou veřejně dostupné — přihlášení/session/token se
  nevyžaduje.** Obě podkladové konfigurace `rest.resource.*.yml` deklarují `authentication: [cookie]`
  a žádný požadavek `_permission`/`_access` na úrovni routy — jde o zdroje REST modulu Drupalu (v tomto
  modulu neexistuje žádný `supplier.routing.yml`), takže přístup je hlídán čistě přes oprávnění
  `restful get <resource_id>`, nikoli přes oprávnění na úrovni entity `view published supplier
  entities` / `view published supplier to category entities` definovaná v `supplier.permissions.yml`.
- `config/user.role.anonymous.yml` přiděluje anonymní roli **obě** oprávnění `restful get
  suppliers_resource` i `restful get suppliers_resource_v32` (zdroj: `config/user.role.anonymous.yml:131-132`,
  blok závislostí řádky 64-65).
- `config/user.role.authenticated.yml` přiděluje shodně stejná dvě oprávnění (zdroj:
  `config/user.role.authenticated.yml:141-142`, blok závislostí řádky 67-68).
- Žádná jiná konfigurace role (`manager`, `risk_manager`, `marketing` atd.) tato dvě oprávnění
  `restful get ...` nepřiděluje ani neomezuje — pouze role `manager` a `risk_manager` mají
  *entity-level* oprávnění `add/edit/delete/view (un)published supplier(-to-category) entities`, která
  upravují HTML admin CRUD formuláře, nikoli tento REST kontrakt.
- Čistý dopad: **jde o neautentizovaný, veřejný datový feed** — model oprávnění publish/unpublish na
  úrovni entity Supplier/SupplierToCategory nemá žádný vliv na to, kdo může tyto dva endpointy volat;
  řídí pouze samostatné HTML admin rozhraní.

## Požadavek

### Přehled endpointů

| # | Metoda + cesta | ID pluginu | Konfigurační soubor |
|---|---|---|---|
| 1 | `GET /api/3.2/suppliers` | `suppliers_resource_v32` | `rest.resource.suppliers_resource_v32.yml` |
| 2 | `GET /api/2.3/suppliers` | `suppliers_resource` | `rest.resource.suppliers_resource.yml` |

Aktuální verzí je pravděpodobně **v3.2** (vyšší číslo, odpovídá obecné linii verzování API `v3.x`
platformy vídané i v jiných modulech, např. rodině Campaign v API0003). Obě verze zůstávají nasazené
souběžně, bez jakéhokoli deprecation označení ve zdrojovém kódu. **Partial** — kterou verzi ve
skutečnosti volá živá SPA, není z tohoto pouze backendového zdrojového stromu evidováno.

### Vstupy

Ani jeden z endpointů nepřijímá žádný query parametr, path parametr ani tělo požadavku. Oba jsou
bezparametrová `GET` vyhledávání, která při každém volání vrací celý aktuální katalog — **Confirmed**,
žádná z metod `get()` nečte `\Drupal::request()` ani žádný argument metody.

## Odpověď

### Úspěch — oba endpointy

Obě verze vracejí identický *tvar* odpovědi; liší se pouze mechanismus načítání taxonomie a filtr
nepublikovaných termínů (viz sekce Poznámky k verzování níže). Odpověď se necachuje
(`addCacheableDependency(['#cache' => false])` — **Confirmed**, v obou třídách).

| Pole | Význam | Poznámky |
|---|---|---|
| `category` | objekt klíčovaný ID taxonomického termínu (GiftCategory termín nejvyšší úrovně, EN0033) | každá hodnota: `{ name, tooltips }` |
| `category.<tid>.name` | zobrazovaný název kategorie | string |
| `category.<tid>.tooltips` | pole textů nápovědy (tooltip), nebo `null` | zdrojové pole `tooltips` (na termínu je uloženo jako string oddělený čárkami) rozdělené podle `,`; `null`, pokud je pole prázdné |
| `subcategory` | objekt klíčovaný ID taxonomického termínu (podřízený termín GiftCategory, EN0033) | každá hodnota: `{ name, parent }` |
| `subcategory.<tid>.name` | zobrazovaný název podkategorie | string |
| `subcategory.<tid>.parent` | ID termínu nadřazené kategorie | integer |
| `supplier` | objekt klíčovaný ID entity Supplier (EN0019) | každá hodnota: `{ name, url, parent }` — **vyhrává poslední zápis (last-write-wins)**: pokud je dodavatel navázán na více než jednu podkategorii prostřednictvím `supplier_to_category`, v odpovědi se zachová pouze jedno mapování (objekt je klíčovaný ID dodavatele, takže pozdější iterace smyčky pro téhož dodavatele přepíše dřívější) |
| `supplier.<id>.name` | zobrazovaný název dodavatele (`SupplierEntity::getName()`, atribut `name` z EN0019) | string |
| `supplier.<id>.url` | URL e-shopu pro danou dvojici dodavatel/kategorie (`SupplierToCategory.url`, vztah z EN0019) | string, může být prázdný |
| `supplier.<id>.parent` | ID termínu podkategorie, ke kterému je toto mapování dodavatele připojeno | integer — odráží ten řádek `supplier_to_category`, který byl pro daného dodavatele zpracován jako poslední (viz poznámka o last-write-wins výše) |

**Vyloučení platná pro obě verze (Confirmed, kód):**
- Legacy termín nejvyšší úrovně **tid 1722 ("Mimořádná pomoc")** a všechny jeho podřízené termíny jsou
  z `category`/`subcategory`/`supplier` vždy vyloučeny — stejné historické vyloučení, jak je popsáno
  u EN0033.

### Poznámky k verzování (behaviorální rozdíly mezi v2.3 a v3.2)

| Aspekt | v2.3 (`suppliers_resource`) | v3.2 (`suppliers_resource_v32`) |
|---|---|---|
| Zdroj taxonomie | služba `patron_base.default`, `getTaxonomyTermsSortedByWeight('category')` — raw SQL `SELECT tid FROM taxonomy_term_field_data WHERE vid=:vid ORDER BY weight ASC`, každý řádek načtený přes `Term::load()` | `\Drupal::entityTypeManager()->getStorage('taxonomy_term')->loadTree('category')` — standardní tree loader, vrací objekty typu stdClass reprezentující strom (`tid`, `name`, `parents`, `status`, `tooltips`) |
| Filtr nepublikovaných termínů | **Neaplikuje se** — **Confirmed**: podmínka pro přeskočení ve smyčce v2.3 kontroluje pouze `tid == 1722` / `parentId == 1722`; příznak `status`/published nekontroluje vůbec, takže nepublikované termíny category/subcategory jsou v odpovědi zahrnuty | **Aplikuje se** — **Confirmed**: v3.2 navíc přeskakuje každý termín, kde `$category->status == 0`, ve stejné podmínce jako vyloučení tid 1722 |
| Metoda určení nadřazeného termínu | `$category->parent->referencedEntities()` (entity reference pole na načteném objektu `Term`) | `$category->parents[0]` (pole na návratovém objektu tree loaderu) |
| Přístup k poli tooltips | `$category->tooltips->value` | `$category->tooltips` (property přímo na objektu stromu, bez `->value`) |

Čistý rozdíl v aktuálním stavu: **v2.3 může zpřístupnit nepublikovanou GiftCategory/subcategory (a
jakékoli dodavatele k ní navázané), kterou v3.2 správně skrývá.** Jde o reálnou behaviorální divergenci
mezi dvěma živými, souběžně zapnutými verzemi, nikoli pouze o refaktoring — označeno jako riziko níže.

### Chybové výstupy

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `200` s `category: [], subcategory: [], supplier: []` | ve slovníku `category` neexistují žádné termíny (nebo jsou všechny vyloučeny) | ano | v kódu nejde o chybovou cestu — obě metody `get()` vždy vrací `200`; neexistuje žádné zpracování výjimek ani větev pro "not found" |
| Nezachycená chyba PHP (např. `TypeError`/`Error` při dereferenci `null` entity reference) | řádek `supplier_to_category` odkazuje na smazaného/chybějícího dodavatele nebo termín kategorie | neevidováno — **Uncertain**, v žádném z těl smyčky neexistuje defenzivní kontrola na `null` před dereferencí `->entity->id()` / `->getName()` | projevilo by se jako obecná chyba 5xx, nikoli jako strukturovaná chyba API; nepotvrzeno proti živé instanci dle `_ar/tasks/Runtime-truth-policy.md` |

## Vedlejší efekty

Žádné. Oba endpointy jsou čistě read operace — nevzniká, neupravuje se ani se nemaže žádný stav
entity Supplier, SupplierToCategory ani taxonomického termínu (**Confirmed** — v žádné z metod `get()`
se nevolá `->save()`).

## Rizika (aktuální stav)

- **v2.3 nefiltruje nepublikované termíny GiftCategory; v3.2 ano.** Kategorie nebo podkategorie
  nepublikovaná pomocí admin formuláře taxonomie (s úmyslem skrýt ji z žadatelsky orientovaných
  povrchů) zůstává viditelná — spolu s jakýmikoli dodavateli na ni navázanými — přes stále zapnutý
  endpoint v2.3. Jakýkoli konzument, který ještě volá `/api/2.3/suppliers`, vidí zastaralé/odebrané
  kategorie a mapování dodavatelů, které `/api/3.2/suppliers` správně potlačuje.
- **Žádná paginace, filtrování ani výběr polí na žádném z endpointů** — při každém volání se vrací
  celý katalog; nejde o bezpečnostní riziko, ale o charakteristiku škálovatelnosti/efektivity převzatou
  beze změny (nic nenasvědčuje tomu, že by to způsobilo provozní problém, proto to zde dále
  neeskalujeme).
- **Vazba `parent` mezi dodavatelem a podkategorií je ztrátová, pokud je dodavatel mapován na více
  podkategorií** (viz poznámka "last-write-wins" v sekci Odpověď) — odpověď nemůže reprezentovat
  dodavatele spojeného s více než jednou podkategorií; viditelné je pouze poslední zpracované mapování.
  To odpovídá otevřené otázce "žádné potvrzené omezení jedinečnosti pro dvojici dodavatel–kategorie",
  která je již zaznamenaná u EN0019.
- **Na žádném z endpointů není evidováno žádné rate limiting, HMAC ani podepisování requestů** — v
  souladu s celoprojektovým aktuálním vzorem, kdy veřejné/anonymní read endpointy nemají v prozkoumaném
  zdrojovém kódu žádnou další kontrolu integrity na transportní úrovni nebo throttling. Zde konkrétně
  nízká závažnost, protože payload jsou neosobní referenční data (kategorie, podkategorie, veřejný
  seznam dodavatelů), nikoli osobní údaje dárce/žadatele.

## Odkazy

- EN: EN0019 (Supplier — entita dodavatele a vztah `supplier_to_category`), EN0033
  (GiftCategory — taxonomický slovník `category`, jeho dvouúrovňová struktura category/subcategory,
  pole `tooltips` a vyloučení tid 1722 "Mimořádná pomoc" popsané již tam)
- ARCH: ARCH0008 (Documents & Fulfilment — označuje registr dodavatelů jako referenční data
  konzumovaná dalšími back-office toky)

## Otevřené body

- **Žádný dokument UC/FN nepodkládá spotřebitelské využití tohoto endpointu.** Žádný use-case ani
  dokument o schopnosti v `_ar/spec-draft/UC/` nebo `_ar/spec-draft/FN/` v současnosti nemapuje, kde/jak
  žadatelsky orientované nebo admin UI volá `/api/{2.3,3.2}/suppliers` (např. pro naplnění nápovědy
  "doporučený dodavatel" během podání žádosti, viz mezera "spotřeba automatického napojení dodavatelů"
  již zaznamenaná u EN0033). Tento kontrakt je podložen přímo zdrojovým kódem REST resource a
  dokumenty entit EN0019/EN0033; budoucí průchod UC může sekci "Účel" zpřesnit, jakmile bude tento
  konzumující tok zmapován.
- **Kterou verzi (v2.3 nebo v3.2) skutečně volá živá SPA/admin UI** není v tomto pouze backendovém
  zdrojovém stromu evidováno (**Partial**).
- **Cesta nezachycené chyby při visící referenci `supplier_to_category`** je výše zaznamenána jako
  **Uncertain**; ověření proti živé instanci není dle aktuální Runtime-truth-policy k dispozici.
- **CRUD rozhraní pro Supplier / SupplierToCategory je z tohoto kontraktu úmyslně vyloučeno** — tyto
  entity se udržují pouze prostřednictvím obecných HTML admin formulářů Drupalu
  (`SupplierEntityForm`, `SupplierToCategoryForm`, `*DeleteForm`), které nejsou systémovým REST/JSON
  API. Pokud by budoucí rebuild potřeboval dokumentovaný admin-API kontrakt pro správu dodavatelů,
  ve zdrojovém kódu v současnosti neexistuje a bylo by potřeba jej vymezit jako nový kontrakt, nikoli
  jej slučovat do tohoto.
