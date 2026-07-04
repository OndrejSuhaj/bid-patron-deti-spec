---
doc_id: EN0033
title: GiftCategory
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0001  # Application — category (Application-level "Area of assistance", synced to Campaign)
  - EN0002  # ApplicationProfile — gift_category / gift_subcategory (fundraiser-perspective requested-gift classification)
  - EN0004  # Campaign — gift_category (kept in lock-step with Application.category)
  - EN0019  # Supplier — subcategory-to-supplier linking (supplier_to_category)
  - UC0001  # Submit Application — step 2 "Dar, kterým vám pomůžeme" captures gift_category/gift_subcategory
---

# EN0033 — GiftCategory

## Účel

GiftCategory (dárová kategorie / oblast pomoci) je katalog referenčních dat, ze kterého žadatel vybírá
— v kroku 2 průvodce žádostí ("Dar, kterým vám pomůžeme" / "Rychlá volba daru") — za účelem klasifikace
životní situace a konkrétní požadované věcné pomoci/daru. Nejedná se o **pevný enum na úrovni kódu**:
jde o dvouúrovňový **taxonomický slovník** (`category`, administrátorský štítek "Oblast pomoci"), jehož
termíny nejvyšší úrovně tvoří dárové **kategorie** ("Jakou životní situaci řešíte?") a jehož podřízené
termíny tvoří dárové **podkategorie** ("Jaký dar by dítěti pomohl?"). Každý termín podkategorie nese
serializovaný **přepis parametrů jednotlivých polí**, který přeznačí/překonfiguruje formulář kroku 2
(popisky polí, placeholdery, kardinalitu příloh, volitelný validátor časového rozsahu) — to je mechanismus
stojící za pozorovaným chováním u "Tábory" (přidává pole "V jaké termínu se tábor uskuteční" a přeznačuje
pole organizace/přílohy). — **Confirmed** (kód).

GiftCategory určuje, co může žadatel požadovat (`ApplicationProfile.gift_category` /
`gift_subcategory`, EN0002), a je propagováno do výsledné žádosti (`Application.category`,
EN0001) a po zveřejnění do veřejné kampaně/příběhu (`Campaign.gift_category`, EN0004) —
jednosměrná synchronizace ze žádosti do kampaně při uložení, nikoli sdílená reference.

---

## Životní cyklus

Termíny GiftCategory mají obecný životní cyklus taxonomického termínu Drupalu:

- Publikováno (`status = 1`) — vybratelné ve výběru v kroku 2 i na administrátorských obrazovkách správy
  kategorií.
- Nepublikováno (`status = 0`) — vyloučeno z výběru na straně žadatele (`SuppliersResource` ve variantě
  REST v32 filtruje `status == 0` ven — **Confirmed**, kód).

Nad rámec standardního příznaku publikace taxonomického termínu neexistuje pro GiftCategory žádný další
doménově specifický stavový slovník. — **Confirmed**.

---

## Přechody stavů

(žádný) → Publikováno
spouštěč: vytvořeno/upraveno prostřednictvím administrátorského formuláře taxonomického termínu Drupalu
pro slovník `category` (bundle `taxonomy_term.category`), s využitím field widgetu `category_parameters`
pro přepisy jednotlivých polí — **Confirmed**
(`web/modules/custom/application/src/Plugin/Field/FieldWidget/CategoryParametersWidget.php`,
`config/core.entity_form_display.taxonomy_term.category.default.yml`). Počáteční katalog (9
kategorií/podkategorií zachycených v UI evidenci) byl naplněn/opraven jednorázovou funkcí pro opravu dat,
`patron_base_update_cz_categories()` v `patron_base.module` — **Confirmed**, jde ale o rutinu pro
naplnění obsahu při nasazení, nikoli o opakující se runtime spouštěč; změny katalogu po tomto naplnění
se provádějí běžnou úpravou taxonomického termínu (Hypothesis pro průběžný/současný administrátorský
proces — žádný dossier nedokládá následnou úpravu).

Publikováno ↔ Nepublikováno
spouštěč: Hypothesis — Not evidenced in current sources: žádný administrátorský UC dossier nedokumentuje,
kdo publikuje/depublikuje termín GiftCategory nebo za jakých okolností.

---

## Atributy

### Systémově spravované atributy

- `tid` (integer; systémově spravováno; ID taxonomického termínu; primární identifikátor, na který se
  jinde v doméně odkazují pole `gift_category` / `gift_subcategory` / `category`)
- `vid` (string; systémově spravováno; pevná hodnota `category` — strojový název slovníku;
  administrátorský štítek "Oblast pomoci")
- `parent_target_id` (reference na GiftCategory (sebe sama); systémově spravováno; `0`/nevyplněno =
  **kategorie** nejvyšší úrovně, nenulové = **podkategorie** dané kategorie — dvouúrovňová hierarchie je
  vyjádřena taxonomickým rodičovstvím, nikoli dvěma samostatnými bundly — **Confirmed**,
  `config/views.view.gift_categories.yml` filtr `parent_target_id > 0`)
- `weight` (integer; systémově spravováno; pořadí zobrazení ve výběru v kroku 2)
- `status` (boolean; systémově spravováno; publikováno/nepublikováno — viz Životní cyklus)

### Uživatelsky zadávané atributy (spravované přes administrátorský formulář taxonomického termínu)

- `name` (string; povinné; zobrazovaný popisek kategorie/podkategorie pro žadatele, např. "ŠVP,
  JAZYKOVÝ KURZ, ŠKOLNÍ VÝLETY", "TÁBORY – POBYTOVÉ, PŘÍMĚSTSKÉ")
- `body` (text, formátovaný; volitelné; vysvětlující popis zobrazený po rozbalení řádku kategorie
  — "Více informací" — např. popis Tábory "Požádat můžete o jakékoli tábory anebo soustředění…")
- `tooltips` (string; volitelné; hodnoty oddělené čárkou; základní pole přidané k `taxonomy_term` obecně
  modulem `patron_base` — nejde o úložiště specifické pro kategorii; konzumováno REST zdrojem Supplier
  jako seznam tooltipů pro danou kategorii — **Confirmed**, `patron_base.module`
  `patron_base_entity_base_field_info()`, `supplier/src/Plugin/rest/resource/SuppliersResource.php`)
- `scoring` (string/JSON; volitelné; základní pole přidané k `taxonomy_term` obecně modulem `patron_base`;
  popis "Json" v kódu. **Hypothesis** — žádný dossier nepotvrzuje, že je toto pole pro termíny
  GiftCategory konkrétně naplňováno nebo čteno; doloženo je pouze jeho obecné zavedení na `taxonomy_term`)
- `parameters` (string, serializované PHP pole; volitelné; **kontrakt přepisu formuláře na úrovni
  jednotlivých polí** — viz Invarianty; úložiště pole `field.storage.taxonomy_term.parameters`, připojeno
  pouze k bundlu `taxonomy_term.category` přes `field.field.taxonomy_term.category.parameters`)

---

## Kontrakt přepisu `parameters` (model dynamických polí pro jednotlivé podkategorie)

**Confirmed** — kód: `CategoryParametersWidget::formElement()` (administrátorská editace) a
`patron_base_update_cz_categories()` (naplnění dat) v
`web/modules/custom/application/src/Plugin/Field/FieldWidget/CategoryParametersWidget.php` a
`web/modules/custom/patron_base/patron_base.module`.

`parameters` je PHP-serializované asociativní pole, jedna položka pro každé přepisovatelné pole v
darovém bloku kroku 2 entity ApplicationProfile. Každá položka může nést:

- `title` (string) — nahrazuje výchozí popisek pole.
- `placeholder` (string) — nahrazuje výchozí placeholder pole.
- `cardinality` (integer, pouze pole příloh) — počet povolených souborů.
- `validate` (boolean, pouze `gift_note`) — označí pole pro validaci časového rozsahu.

Klíče přepisovatelných polí pozorované v datech naplnění: `name`, `school_teacher_name`, `phone`,
`email`, `attachment_1` … `attachment_6`, `gift_note`, `gift_price`, `notice`. Prázdný přepis (`''`)
ponechá pole na výchozím popisku úrovně ApplicationProfile; neprázdný přepis pole přeznačí/
překonfiguruje pouze pro danou konkrétní podkategorii.

**Potvrzený příklad (Tábory, přesně odpovídající UI evidenci):** naplněná data pro podkategorii tid
2572 ("TÁBORY – POBYTOVÉ, PŘÍMĚSTSKÉ") přepisují `name` → "Název a adresa organizátora tábora",
`attachment_2` → "Zde přiložte přihlášku na tábor" (kardinalita 3) a přidávají `gift_note` → "V jaké
termínu se tábor uskuteční" (placeholder "Termín") — to je přesně to přeznačení pro danou kategorii,
které je pozorováno na screenshotech kroku 2.

**Potvrzený katalog dle naplnění (9 kategorií nejvyšší úrovně, tid → název, pořadí dle weight):**

| tid | Kategorie (česky, dle naplnění) | Weight |
|---|---|---|
| 2505 | ŠVP, JAZYKOVÝ KURZ, ŠKOLNÍ VÝLETY | 0 |
| 0 (naklonováno z 2505, nový tid přiřazen při uložení) | LYŽAŘSKÝ KURZ | 1 |
| 994 | KROUŽKY, SOUSTŘEDĚNÍ A VYBAVENÍ PRO NĚ | 2 |
| 2572 | TÁBORY – POBYTOVÉ, PŘÍMĚSTSKÉ | 3 |
| 72 | ŠKOLNÉ A INTERNÁT | 4 |
| 992 | NOTEBOOK | 5 |
| 3042 | AUTOMOBIL jako zdravotní pomůcka | 6 |
| 71 | POMŮCKY A SLUŽBY pro ZDRAVOTNĚ ZNEVÝHODNĚNÉ DĚTI | 7 |
| 991 | BALÍK ŠKOLNÍCH POTŘEB | 8 |

To odpovídá 9 kategoriím pozorovaným v UI evidenci jedna ku jedné (znění i pořadí názvů). tid 71
a 72 v seed funkci se rovněž používají jako **rodičovské tidy pro dva dodatečně vytvořené termíny
podkategorií** (větev funkce `$tid == 71 || $tid == 72` vytváří pod každým z nich podřízený termín) —
přesný výsledný katalog podkategorií (názvy/tidy podkategorií nad rámec toho, co seed funkce vytváří
přímo) **nelze plně vyčíslit pouze ze statického zdrojového kódu**; samotný obsah taxonomie (které
termíny podkategorií dnes existují, pod kterým rodičem, s jakými aktuálními `parameters`) žije v
databázi, nikoli ve verzovaném exportu konfigurace — **Evidence Pending** (viz Evidenční mezery).

Samostatný legacy termín nejvyšší úrovně, **tid 1722 "Mimořádná pomoc"** (nouzová pomoc z doby COVID;
odkazovaný doslovně v `ApplicationCreateResource.php` jako natvrdo zakódovaná výchozí hodnota a
explicitně vyloučený ze seznamu kategorií na straně žadatele v `SuppliersResource::get()`), existuje ve
stejném slovníku, ale **není** jednou z 9 aktuálních kategorií — **Confirmed**, historický/vyloučený,
není součástí aktivního výběru.

---

## Invarianty

- Termín GiftCategory je buď **kategorie** (`parent_target_id` prázdné/0), nebo **podkategorie**
  (`parent_target_id` nastaveno na tid kategorie); výběr na straně žadatele v kroku 2 i projekce
  view/REST `gift_categories` dělí slovník podle tohoto pravidla — **Confirmed**.
- `ApplicationProfile.gift_category` (EN0002) se odvozuje z `ApplicationProfile.gift_subcategory`, pokud
  nebyla explicitně nastavena — tj. výběr podkategorie implikuje její rodičovskou kategorii —
  **Confirmed**, poznámka k atributu EN0002 (definice polí v `ApplicationProfileEntity.php`).
- Přepis `parameters` u podkategorie se uplatní pouze na pole kroku 2 entity ApplicationProfile u žádostí
  nesoucích danou konkrétní `gift_subcategory` — kategorie/podkategorie bez záznamu přepisu (nebo s
  prázdným řetězcem) se vrátí k výchozím popiskům/placeholderům polí entity ApplicationProfile —
  **Confirmed** (`CategoryParametersWidget`).
- `Application.category` (EN0001, pole "Oblast pomoci" na úrovni žádosti — samostatné úložiště oproti
  `ApplicationProfile.gift_category`, ale odkazující na stejnou taxonomii/bundle `category`) se při
  uložení žádosti synchronizuje do pole `gift_category` (EN0004) navázané kampaně, kdykoli se změní —
  jednosměrná, neatomická propagace, nikoli sdílená reference — **Confirmed**,
  `ApplicationEntity::updateCampaignCategory()` (`web/modules/custom/application/src/Entity/ApplicationEntity.php`).
- Dodavatelé (EN0019) mohou být navázáni na podkategorii přes entitu `supplier_to_category`, zobrazenou
  přes stejnou REST projekci kategorie (`SuppliersResource`) — **Confirmed**, ale využití tohoto vztahu
  dodavatel–podkategorie na straně žadatele (např. automatické navržení dodavatele) **není v dossieru
  dokladováno** — **Evidence Pending**.
- tid 1722 ("Mimořádná pomoc") je vyloučen z výběru na straně žadatele, ale zůstává platnou hodnotou
  `gift_category` na existujících/legacy žádostech — **Confirmed**, vyloučení na úrovni kódu +
  natvrdo zakódované historické přiřazení.

---

## Vztahy

- EN0001 — Application (pole `category`; klasifikace na úrovni žádosti, propagovaná do kampaně)
- EN0002 — ApplicationProfile (pole `gift_category`, `gift_subcategory`; klasifikace zachycená na straně
  žadatele v kroku 2, přičemž `gift_category` lze odvodit z `gift_subcategory`)
- EN0004 — Campaign (pole `gift_category`; udržováno synchronně s `Application.category` — viz
  BR-CampaignStoryLifecycle / `updateCampaignCategory`)
- EN0019 — Supplier (přes `supplier_to_category`; podkategorie může uvádět seznam přidružených
  dodavatelů)
- UC0001 — Submit Application (v kroku 2 "Dar, kterým vám pomůžeme" se vybírá GiftCategory a přepis
  `parameters` přeznačuje viditelná pole)

---

## Evidenční mezery

- **Úplný aktuální katalog podkategorií.** Naplňovací funkce (`patron_base_update_cz_categories`)
  potvrzuje 9 kategorií nejvyšší úrovně a jejich přepisy `parameters` přesně tak, jak jsou pozorovány
  v UI, plus dvě podkategorie vytvořené inline pod tid 71/72, ale úplný, aktuální seznam všech termínů
  podkategorií (názvy, tidy, aktuální `parameters`) je taxonomický **obsah** v databázi, nikoli přítomný
  v žádném verzovaném exportu konfigurace/obsahu v tomto zdrojovém stromu. Vyřešení vyžaduje buď export/
  dump databázových tabulek `taxonomy_term_data`/`taxonomy_term__parameters` pro slovník `category`, nebo
  další pull z živé instance/content-staging prostředí — mimo rozsah statického pass pouze ze zdrojového
  kódu (viz `_ar/tasks/Runtime-truth-policy.md`).
- **Využití pole `scoring` u termínů GiftCategory.** Základní pole `scoring` existuje obecně na
  `taxonomy_term` (přidáno modulem `patron_base`); žádný dossier nepotvrzuje, zda/jak je naplňováno nebo
  čteno konkrétně pro termíny bundlu `category`. Výše označeno jako Hypothesis; není tvrzeno jako aktivní
  chování GiftCategory.
- **Administrátorská správa po naplnění dat.** Žádný use-case dossier nedokumentuje aktuální
  administrátorský postup pro přidání 10. kategorie, vyřazení některé z nich nebo úpravu `parameters`
  po počátečním naplnění — mechanismus (administrátorský formulář taxonomického termínu) je potvrzen
  konfigurací, ale provozní proces/vlastnictví nikoli.
- **Konzumace automatického napojení dodavatele.** `supplier_to_category` je potvrzen jako datový model,
  ale žádný důkaz neukazuje, že by ho formulář na straně žadatele využíval (např. k předvyplnění/návrhu
  dodavatele pro vybranou podkategorii).

Žádná z uvedených mezer nebrání publikaci této entity na úrovni jistoty **Partial**: struktura taxonomie
kategorie/podkategorie, mechanismus přepisu jednotlivých polí a katalog 9 kategorií odpovídající UI
evidenci jsou všechny **Confirmed** v kódu; otevřený zůstává pouze živý/aktuální úplný výčet podkategorií
a několik okrajových chování.
