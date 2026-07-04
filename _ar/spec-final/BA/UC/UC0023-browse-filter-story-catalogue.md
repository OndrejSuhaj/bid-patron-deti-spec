---
doc_id: UC0023
title: Browse & Filter Story Catalogue
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0023 — Procházení a filtrování katalogu příběhů

## Záhlaví

| Pole | Hodnota |
|---|---|
| ID UC | UC0023 |
| Název | Procházení a filtrování katalogu příběhů |
| Ohraničený kontext | C3 |
| Primární aktér(y) | Anonymní návštěvník, Dárce, Systém |
| Typ spouštění | UI (načtení veřejné stránky / AJAX) |

## Aktéři a odpovědnosti

- **Anonymní návštěvník / Dárce** — otevře veřejný katalog příběhů (homepage a rovnocenné výpisové
  plochy), přepíná mezi segmentačními záložkami (zbývající částka / samoživitel / kraj / brzy skončí),
  volitelně vybere kraj na interaktivní mapě a klikne na výzvu k akci na kartě příběhu, aby přešel do
  darovacího flow (UC0005) pro zvolenou kampaň (Příběh, EN0004).
- **Systém** — vyhodnotí aktuální množinu publikovaných a aktivních kampaní, aplikuje požadované
  parametry filtrování/řazení/stránkování nad read-side `campaign`, spočítá počty aktivních kampaní
  pro jednotlivé kraje zobrazované v přepínači krajů a vrátí veřejnou projekci karty každé kampaně
  (fotografie, název, kategorie, cílová vs. vybraná částka, příznak viditelnosti zbývající částky,
  termín/zbývající čas, příznak dostupnosti zpětné vazby).

## Účel

Umožnit anonymnímu návštěvníkovi nebo dárci objevovat aktivní kampaně (Příběhy) prostřednictvím
veřejného, filtrovatelného a stránkovaného katalogu — segmentovaného podle zbývající částky
(výchozí), žadatelů-samoživitelů ("samoživitel"), kraje ČR nebo nejbližšího termínu — aby si mohli
vybrat, koho podpořit, a pokračovat do darovacího flow (UC0005). Jde o primární vstupní bod akvizice
dárců do domény Campaign/Story-Lifecycle (SRV0005) a o čistě čtecí/prohlížecí schopnost: nemění stav
kampaně ani žádosti.

## Předpoklady

- Existuje jedna nebo více kampaní (EN0004) s vyplněným `campaign_status`; u anonymního návštěvníka
  dotaz navíc vyžaduje, aby Drupal příznak `status` (publikováno) kampaně byl `1` — viz
  `CampaignsResource::addUserData()` (zdroj: `web/modules/custom/campaign/src/Plugin/rest/resource/v33/CampaignsResource.php:217-223`).
- Procházení nevyžaduje autentizaci; přihlášený uživatel může předat dodatečné filtry vázané na
  interakci (viz alternativní tok AF3).

## Hlavní tok

1. Návštěvník: načte veřejný katalog příběhů (homepage nebo rovnocennou výpisovou plochu).
2. Systém: nastaví jako výchozí zobrazení segmentaci **"Zbývající částka"** — Confirmed výchozí
   přistávací záložka dle UI evidence; podkladové výchozí řazení, pokud není zadán explicitní query
   parametr `order`, je `ORDER BY c.id DESC` (`applyOrder()`, větev bez zadaného řazení) — **Partial**:
   přesný řadicí klíč napojený na tuto výchozí záložku na straně front-end klienta není z tohoto
   repozitáře evidován (spotřebovávající SPA není součástí tohoto zdrojového stromu — viz Evidence
   Level).
3. Systém: dotáže tabulku `campaign` na ID kampaní, přičemž postupně aplikuje uživatelské zúžení
   rozsahu, poté požadované filtry, poté vyloučení a nakonec řazení (`getCampaigns()` —
   `CampaignsResource.php:115-154`).
4. Systém: rozstránkuje množinu ID podle query parametrů `offset`/`limit` (výchozí `limit` = 10, pokud
   není zadán; `-1` vyžádá až 1000) a vrátí `has_more_results` / `total_count` spolu se stránkou
   (`loadCampaigns()`, `applyRange()`, `getOffset()`, `getLimit()` — `CampaignsResource.php:156-215`).
5. Systém: pro každé ID kampaně na dané stránce načte `CampaignEntity` a vrátí jeho veřejnou projekci
   karty přes `getShortData()` — id, typ, slug (`url_hash`), publikačně normalizovaný stav, popisek
   kategorie, název, text CTA tlačítka, výpisovou fotografii, cílovou částku (`full_amount`), vybranou
   částku, příznak `hide_raised_amount`, ISO termín (`campaign_ends`), datum dokončení, příznak
   dostupnosti zpětné vazby a procentuální naplnění (`CampaignEntity.php:1247-1272`).
6. Návštěvník: přepne na záložku **"Samoživitelé"** — Uncertain mechanismus; viz AF1.
7. Návštěvník: přepne na záložku **"Filtrovat podle krajů"**.
8. Systém: vykreslí fragment přepínače krajů — mobilní `<select>` a desktopovou SVG mapu — sestavené
   ze 14 krajů ČR (referenční entity `kraj`) a pro každý kraj počet aktuálně `active` kampaní k němu
   přiřazených; kraj s nulovým počtem je vykreslen jako zakázaná (disabled) volba
   (`RenderRegionsController::render()` / `getActiveCampaignCountsByRegion()` —
   `web/modules/custom/campaign/src/Controller/RenderRegionsController.php:71-134`), obsluhováno na
   veřejné route `/campaign/regions/render` (oprávnění `access content`; `campaign.routing.yml`).
9. Návštěvník: vybere kraj na mapě (nebo v mobilním selectu).
10. Systém: znovu spustí dotaz katalogu (krok 3) s `filter_region` nastaveným na slug vybraného kraje,
    namapovaný na serverové straně na odpovídající ID entity `kraj`, a omezí dotaz na
    `c.kraj = <id kraje>` (`applyFilters()`, větev `region` — `CampaignsResource.php:322-341`).
11. Návštěvník: přepne na záložku **"Brzy skončí"**.
12. Systém: znovu spustí dotaz katalogu s `order=ends_soon`, který řadí podle `campaign_deadline`
    vzestupně a omezuje výsledky na kampaně, jejichž termín (konec dne) je stále v budoucnosti
    (`applyOrder()`, větev `ends_soon` — `CampaignsResource.php:406-414`).
13. Návštěvník: zvolí výzvu k akci na kartě příběhu ("Podpořím `<jméno>`" nebo variantu pro sbírkový
    účet "Nechám to na vás").
14. Systém: předá řízení do darovacího flow pro zvolenou kampaň (viz UC0005 — mimo rozsah tohoto UC
    nad rámec předání).

## Alternativní toky

### AF1 — Mechanismus filtru záložky "Samoživitelé" — Uncertain

1. Návštěvník: vybere záložku "Samoživitelé".
2. Systém: očekává se, že zúží katalog na kampaně, jejichž navázaná žádost/žadatel je označen
   příznakem samoživitel.

Nalezená evidence: `CampaignEntity` deklaruje boolean pole `single_parent` s getterem `isSingleParent()`
(`CampaignEntity.php:267-269,867`), takže podkladový datový bod na agregátu kampaně existuje. Mapa
filtrů `applyFilters()` v aktuální (v33) `CampaignsResource` — REST endpointu, z nějž vychází hlavní tok
tohoto UC — však **neobsahuje** parametr `filter_single_parent` (ani ekvivalent); napojeny jsou pouze
`id`, `status`, `category`, `flag`, `region`, `user_interacted_campaigns`,
`user_recommended_campaigns` a `organization_id` (`CampaignsResource.php:228-385`). Žádná jiná
serverová filtrační cesta pro `single_parent` nebyla nalezena v `web/modules/custom/campaign/` ani jinde
v prohledaném zdrojovém kódu.

**Uncertain — záložka je doložena UI evidencí (`_ar/evidence/ui/ui-observed-areas.md` §1) a podkladové
pole je na entitě kampaně Confirmed, ale napojení filtru není v tomto backendovém zdroji evidováno.**
Možná vysvětlení, která nelze z tohoto repozitáře rozhodnout: (a) filtr se aplikuje na straně klienta
v konzumující SPA nad již načtenou stránkou (při větším objemu dat nepravděpodobné, ale samotná SPA
není součástí tohoto zdrojového stromu), (b) novější/neobjevená verze REST resource nebo endpoint
založený na Views tento filtr nese, nebo (c) záložka je v současnosti nefunkční / UI stub. Označeno jako
Evidence Gap — viz Evidence Level.

### AF2 — Kraj bez aktivních kampaní

1. Návštěvník: otevře záložku "Filtrovat podle krajů".
2. Systém: vykreslí kraj s počtem `0` jako zakázanou (disabled) `<option>` v mobilním selectu
   (`buildRegionLabel()` / `$disabled = $count === 0 ? ' disabled' : ''` —
   `RenderRegionsController.php:88-96`).

Výsledek: návštěvník nemůže vybrat kraj bez aktivních kampaní v mobilním ovládacím prvku; chování
desktopové SVG mapy pro kraj s nulovým počtem není dále evidováno (interaktivita/zákaz výběru na
samotné SVG mapě je delegována na theme hook `map` / vykreslování na straně front-endu, zde
nezkoumáno).

### AF3 — Přihlášený dárce požaduje pohledy vázané na interakci

1. Dárce (přihlášený): požádá o katalog s nastaveným `filter_user_interacted_campaigns` nebo
   `filter_user_recommended_campaigns`.
2. Systém: pokud je uživatel přihlášen, zúží množinu ID kampaní na kampaně, vůči kterým má dárce
   uhrazenou transakci (přes `getInteractedCampaigns()` — `CampaignsResource.php:459-486`), nebo na
   uložený seznam doporučených kampaní dárce (`$currentUser->getRecommendedCampaigns()`); pokud
   uživatel není přihlášen, filtr vrátí prázdnou výslednou množinu (`CampaignsResource.php:351-377`).

Výsledek: **Confirmed** jako schopnost na úrovni REST téhož endpointu; nepotvrzeno jako veřejná
záložka katalogu v UI — žádná evidence ze snímků obrazovky neukazuje tyto záložky jako viditelné pro
návštěvníka, proto jsou zde zaznamenány jako kódem doložená schopnost podkladového read modelu, nikoli
jako součást anonymního hlavního toku. `user_recommended_campaigns` se navíc překrývá s UC0021
(Recommend Campaigns — DORMANT); toto UC netvrdí, že jsou doporučovací data v současnosti naplněna.

### AF4 — Žádné výsledky pro zadanou kombinaci filtrů

1. Systém: filtrovaný/seřazený dotaz na ID vrátí nulu řádků.
2. Systém: vrátí prázdné pole `data` s `total_count = 0` a `has_more_results = false`.

Nad rámec AF1–AF4 nejsou definovány žádné další alternativní toky; jde o čistě čtecí
prohlížecí/filtrovací schopnost bez chybových cest na zápisové straně.

## Následné podmínky

- Tímto UC se nemění stav žádné kampaně, žádosti ani jiného doménového agregátu — jde o čistou čtecí
  projekci nad existujícími daty `campaign`.
- Návštěvník má k dispozici stránku projekcí karet kampaní (a na záložce kraje vykreslený přepínač
  krajů s aktuálními počty aktivních kampaní) postačující k výběru kampaně a pokračování do UC0005
  (Make a Donation).

## Sledovatelnost (Traceability)

Cílové SRV:
- Campaign-&-Story-Lifecycle (SRV0005) — čtecí strana agregátu, kterou toto UC promítá

Entity EN:
- EN0004 Campaign — Příběh, který je procházen a filtrován; toto UC čte `campaign_status`,
  `type`, `gift_category`, `kraj` (kraj), `single_parent`, `campaign_raised`,
  `campaign_percentual_raised`, `gift_price`, `campaign_deadline`, `hide_campaign_raised` a
  vztah k sobě samému `parent` (skupina/promo)
- EN0005 Patron — veřejný profil patrona zobrazovaný na každé kartě kampaně (v tomto UC pouze ke
  čtení)
- EN0009 Transaction — čtena (nikoli zapisována) pro vyhodnocení `user_interacted_campaigns` (AF3) a
  pro odvození `campaign_raised` navazujícím procesem (vlastněno UC0011/SRV0005, tímto UC
  nepřepočítáváno)

Otevřená položka převzatá z EN0004 / SRV0005 (tímto UC neřešená): karta příběhu "SBÍRKOVÝ ÚČET" /
sbírkový účet (skupina) pozorovaná v UI evidenci nemá v poli `type` samostatnou hodnotu
(`basic | promo | long_term | short_term` — `CampaignEntity.php:825-838`); nejpravděpodobněji je
realizována prostřednictvím nadřazené kampaně typu `long_term`/`short_term` ("sloučený příběh")
s dětskými kampaněmi navázanými přes vztah k sobě samému `parent`, nebo prostřednictvím jedné pevně
dané kampaně "transparentního účtu" (`Settings::get('transparent_account')`, použité pro
neúčelové/obecné dary — např. `CampaignsResource.php:41-42,80,178-192,434-436`). Žádné z těchto
mapování není samo o sobě potvrzeno vůči konkrétnímu textu karty "Nechám to na vás" — zaznamenáno jako
**Partial**, sledováno pod **OQ-05** (`_ar/spec-draft/UI-gap-open-questions.md`) a odpovídající
otevřenou otázkou již zaznamenanou u EN0004 / SRV0005. Toto UC netvrdí, který mechanismus karta
skupiny/sbírkového účtu používá.

Integrační hranice:
- Žádné (interní read model; při samotném procházení/filtrování není volán žádný externí systém).

Důkazy z toků (Flow Evidence):
- Pro tuto schopnost neexistuje FLW dossier (nebyla zahrnuta do původního evidence-collection průchodu
  — vyplynula až z auditu pokrytí UI). Evidence místo toho tvoří:
  - Kód: `web/modules/custom/campaign/src/Plugin/rest/resource/v33/CampaignsResource.php` (REST čtecí
    endpoint `/api/3.3/campaigns`, nahrazující v30–v32 ve stejném adresářovém stromu)
  - Kód: `web/modules/custom/campaign/src/Controller/RenderRegionsController.php` +
    `campaign.routing.yml` (`/campaign/regions/render`)
  - Kód: `web/modules/custom/campaign/src/Entity/CampaignEntity.php` (`getShortData()`, `categories`,
    povolené hodnoty `type`, `single_parent`, `isPromo()`, `getPromoId()`)
  - Snímky obrazovky: `screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
    `screencapture-patrondeti-cz-2026-07-04-13_16_09.png`,
    `screencapture-patrondeti-cz-2026-07-04-13_16_21.png`,
    `screencapture-patrondeti-cz-2026-07-04-13_16_37.png` (dle
    `_ar/evidence/ui/ui-observed-areas.md` §1)
  - Záznam o promoci: `_ar/spec-draft/UI-gap-promotions.md` §2, gap G-03

## Úroveň důkazu

**Partial** — základní mechanika čtyř záložek katalogu (stránkované čtení aktivních kampaní; filtry
podle kategorie, stavu a kraje; řazení `ends_soon` a `least_percentual_support` přímo odpovídající
sémantice záložek "Brzy skončí" a "Zbývající částka"; aktuální počty aktivních kampaní u přepínače
krajů a zakazování voleb s nulovým počtem) je **Confirmed** přímou kódovou evidencí v
`CampaignsResource` (v33) a `RenderRegionsController`, křížově ověřenou proti snímkům obrazovky v
`_ar/evidence/ui/ui-observed-areas.md` §1. Na úrovni Partial (nikoli Confirmed) drží tento dokument
dva body: (1) serverové napojení filtru záložky "Samoživitelé" není evidováno (AF1 — pole
`single_parent` na entitě existuje, ale žádný REST parametr filtru jej v prohledaném zdrojovém kódu
nekonzumuje); (2) mechanismus karty skupiny/sbírkového účtu není jednoznačně namapován na kombinaci
hodnot `type`/`parent` (sledováno jako OQ-05, v souladu s již dříve zaznamenanou otevřenou otázkou u
EN0004 a SRV0005). Pro tuto schopnost neexistuje žádné pokrytí formou FLW dossier ani process-mapy a
konzumující front-end klient (samostatná SPA zmiňovaná pouze v komentářích kódu, např.
`campaign.module:106`, `patron-spa/src/pages/story/_id.vue`) je mimo tento zdrojový strom, takže přesné
napojení záložek na query parametry na straně klienta je odvozeno z filtračního/řadicího kontraktu
serveru, nikoli pozorováno přímo.
