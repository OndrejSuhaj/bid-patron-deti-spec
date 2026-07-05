---
doc_id: QUERY0003
title: Public Story Catalogue
canonical_layer: QUERY
spec_type: query-spec
status: canonical
modules: []
query_type: search
references:
  - EN0004
  - EN0033
  - EN0009
  - EN0008
  - UC0023
  - FN0006
  - FN0024
  - ARCH0005
---

# QUERY0003 – Veřejný katalog příběhů

## Účel

Read-model stojící za veřejným/front-end výpisem příběhů (příběhy dětí k podpoře). Dynamický
select-dotaz nad kampaněmi (příběhy) s filtrováním, řazením, offsetovým stránkováním, vylučováním a
merchandisingovým vkládáním (transparentní/nekonečný účet, promo příběh, dočasný promo příběh). Jde o
primární plochu pro procházení a filtrování, kterou dárci používají při výběru příběhu.

Evidence: `web/modules/custom/campaign/src/Plugin/rest/resource/v33/CampaignsResource.php`
(a také předchůdci v30–v32). Filtr regionu se mapuje na `c.kraj`; kategorie na `c.gift_category`.

## Konzumenti

- Veřejní / anonymní a přihlášení dárci (front-end výpis příběhů a infinite scroll).
- Personalizované varianty pro přihlášené uživatele (příběhy, se kterými uživatel interagoval / doporučené příběhy).

## Zdrojové entity

- EN0004 – Campaign (základní řádek; příběh; `campaign_status`, `kraj`, `gift_category`, `completed`, `campaign_deadline`, `campaign_percentual_raised`, `parent`)
- EN0033 – GiftCategory (cíl filtru kategorie)
- EN0009 – Transaction (join pro řazení podle data interakce / množinu interakcí)
- EN0008 – User (personalizace pro doporučené / interagované příběhy)

## Filtry a seskupování

| Filtr / seskupení | Význam | Poznámky |
|---|---|---|
| `filter_status` → `c.campaign_status` | Jeden nebo více stavů příběhu (IN při více hodnotách) | Slovník stavů vlastní EN/STAT. Confirmed. |
| `filter_category` → `c.gift_category` | Kategorie daru (mapovaná z mapy slugů) | Confirmed. |
| `filter_region` → `c.kraj` | Region (mapa slug → id kraje, 14 krajů ČR) | Confirmed. |
| `filter_id` → `c.id` (IN) | Explicitní seznam id příběhů, filtrovaný na čísla | Confirmed. |
| `filter_flag` → přeloženo na `c.id` IN | Názvy příznaků přeloženy na id kampaní pomocí raw-SQL vyhledávání nad `application__flag` | Prázdná množina příznaků vynutí prázdný výsledek (`c.id = 0`). Confirmed. |
| `filter_organization_id` → `c.id` IN | Příběhy vázané na organizaci (uuid → org → id přes raw SQL) | Confirmed. |
| `filter_user_interacted_campaigns` | Omezení na příběhy, kterým aktuální uživatel přispěl darem | Pouze pro přihlášené; u anonymních vynuceno prázdné. Confirmed. |
| `filter_user_recommended_campaigns` | Omezení na doporučené příběhy pro uživatele | Pouze pro přihlášené; u anonymních vynuceno prázdné. Viz FN0024 (dormantní). Confirmed. |
| výchozí strážce publikace | `c.status = 1` uplatněný ve výchozí větvi stavu | Confirmed. |
| `exclude` | Čárkou oddělený seznam id příběhů k odstranění (`NOT IN`), plus id nekonečné kampaně | Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| objekt krátkých dat příběhu | Datová položka za příběh (`id`, `type`, `url_hash`, `status`, `category`, `name`, `photo`, `full_amount`, `raised_amount`, `hide_raised_amount`, `campaign_ends`, `campaign_finished`, `has_feedback`, `_percentual_support`) | Z `CampaignEntity::getShortData()`; `raised_amount`/`_percentual_support` čtou perzistovaná pole `campaign_raised` / `campaign_percentual_raised` (viz QUERY0008, jak jsou tato pole udržována). Confirmed. |
| `interacted_at` / `total_amount_donated` | Pro řazení podle interakce: maximální datum daru + sumarizovaná darovaná částka za příběh | Raw-SQL UNION nad `transaction` seskupený podle příběhu/parenta. Confirmed. |
| vložené příběhy | Nekonečný/transparentní účet, promo příběh, dočasný promo příběh vložené do výsledku na fixní offsety | Merchandising, nikoli DB filtr. Confirmed. |

## Filtry a seskupování — řazení

| Klíč řazení | Řazení | Poznámky |
|---|---|---|
| `latest` (výchozí) | `id` DESC | Výchozí, pokud řazení není zadáno / je neznámé. Confirmed. |
| `finished_recently` | `completed` DESC | Confirmed. |
| `ends_soon` | `campaign_deadline` ASC + `HAVING deadline > now` | Přidává vypočítaný unixový výraz deadline. Confirmed. |
| `least_percentual_support` | `campaign_percentual_raised` ASC | Confirmed. |
| `interacted_at` | join na `transaction`, omezeno na aktuálního uživatele | Pouze přihlášení uživatelé s existujícími interakcemi. Confirmed. |

## Tvar výsledku

- Offsetově stránkovaný seznam objektů krátkých dat příběhu (infinite scroll; request parametr `offset`, velikost stránky je interní).
- Merchandisingové kampaně vložené na fixní pozice (offset < 6 pro nekonečnou; index 3 pro promo; index 5 pro dočasnou promo).

## Odkazy

- UC: UC0023 (Procházení / filtrování katalogu příběhů)
- FN: FN0006 (Životní cyklus kampaně / příběhu), FN0024 (Doporučování kampaní — dormantní)
- EN: EN0004, EN0033, EN0009, EN0008
- ARCH: ARCH0005 (Doména kampaní a příběhů)

## Otevřené položky

- **Riziko (raw-SQL uvnitř read resource):** překlad flag→id, organisation→id, množina interakcí a
  dva pomocné výpočty darované částky jsou ad-hoc raw SQL zabudované přímo v REST resource; některé
  obcházejí standardní cestu čtení entit. Zaznamenáno jako observace, nikoli restatováno jako BR.
- Mapa slug→id regionu (14 krajů ČR) je hard-coded v kódu (a duplikovaná i v
  RenderRegionsController, viz QUERY0005) — pro non-CZ tenanty není evidován žádný regionální filtr. Partial.
- Konstanty velikosti stránky / stránkovacího okna jsou interní součástí resource a nejsou zde plně vyčteny.
