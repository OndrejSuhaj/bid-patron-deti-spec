---
doc_id: EN0034
title: DonorAccountView
canonical_layer: EN
spec_type: entity
spec_subtype: projection
status: canonical
modules: []
references:
  - EN0008  # User — the current-user scope the projection is filtered by (Supporter role, INV21)
  - EN0009  # Transaction — the projected rows (is_donation=1, ext_status=PAID), grouped by campaign
  - EN0004  # Campaign — the grouping key ("supported story") of the projection
  - EN0014  # DonationConfirmation — mockup-only element, NOT evidenced in this projection (see Evidence Gaps)
  - EN0021  # Feedback — mockup-only element, NOT evidenced in this projection (see Evidence Gaps)
  - BR-PaymentAndMoneyIntegrity
---

# EN0034 — Zobrazení účtu dárce

## Účel

DonorAccountView je **read-model projekce** nad uhrazenými transakcemi (EN0009), seskupenými podle
příběhu (EN0004) a sečtenými za jednotlivý příběh, ohraničenými na aktuálně přihlášeného uživatele
(EN0008) — tedy „které příběhy tento dárce podpořil a jakou částkou u každého z nich". Projekce
napájí dárci určenou stránku účtu („Moje zóna" / zóna dárce) a sama o sobě není perzistentním
agregátem: nemá vlastní tabulku, žádný životní cyklus ani writer — je zcela vytvářena dotazem nad
řádky Transaction v okamžiku čtení.

*Míra jistoty: Partial.* **Jádro projekce** (historie darů seskupená podle podpořeného příběhu) je
v kódu **Confirmed** (viz Evidence). Bohatší kompozice dashboardu naznačená UI evidencí — countdown
sledovaného příběhu / stav vybírání, stahovatelná potvrzení, zpětná vazba a rozdělení na záložky
„Pro vás / Všechny (N)" — je **Hypothesis**, doložená pouze mockupem vloženým do marketingového
e-mailu, nikoli reálným snímkem obrazovky ani kódem. Viz Evidence Gaps níže; kompozici z mockupu
neposuzujte jako potvrzené současné chování.

## Evidence

**Confirmed (kód):**

- `sync_config/config_czech/views.view.supporter_zone.yml` — Drupal View s názvem „Supporter zone"
  (`id: supporter_zone`, titulek stránky „Moje zóna"), `base_table: transaction`, publikovaný na
  cestě `zona/darce`.
  - **Pole:** `campaign` (entity-reference label na Campaign, seskupeno) a `price` (integer,
    `group_type: sum` — sečteno za skupinu podle příběhu). Přesně tyto dva sloupce; žádné jiné pole
    tento view neprojektuje.
  - **Filtry:** `ext_status = PAID` a `is_donation = 1` (boolean true) — zahrnuty jsou pouze uhrazené
    transakce darů (nedárcovské a neuhrazené/zrušené transakce jsou vyloučeny).
  - **Argument (rozsah):** `user_id`, `default_argument_type: current_user` — view je kontextově
    filtrován na aktuálně přihlášeného uživatele; neexistuje explicitní procházení podle jiného
    uživatele.
  - **Přístup:** `type: role`, `role: supporter` — omezeno na uživatele s rolí `supporter`
    (`config/user.role.supporter.yml`).
  - **`group_by: true`** na úrovni view — potvrzuje sémantiku agregace (jeden řádek na příběh, ke
    kterému uživatel přispěl, se sečtenou částkou).
  - Tento view existuje **pouze v config splitu `config_czech`**
    (`config/config_split.config_split.config_czech.yml`, `complete_list` obsahuje
    `views.view.supporter_zone`) — jde tedy v doložené konfiguraci o artefakt **výhradně pro CZ
    tenant**; ekvivalentní view `supporter_zone` mimo `sync_config/config_czech/` nebyl nalezen.
- Ve stejném CZ config splitu existují sourozenecké, na roli vázané „zone" views, což potvrzuje, že
  jde o jeden z rodiny read-model dashboardů podle role, nikoli o ojedinělý případ:
  `views.view.fundraiser_zone.yml` (`base_table: application`, cesta `zona/zadatel`) a
  `views.view.patron_zone.yml` (`base_table: application`, cesta `zona/patron`). Ty napájí zobrazení
  účtu žadatele/patrona a jsou pro tuto entitu zaměřenou na dárce **mimo rozsah** (uvedeny zde pouze
  jako podpůrný kontext pro vzor „account zone").
- `web/modules/custom/account/src/Plugin/rest/resource/v32/ProfileResource.php` —
  `GET /api/3.2/user/profile` a `POST /api/3.2/user/profile` potvrzují samostatný, reálný, kódem
  podložený kontrakt čtení/editace profilu (jméno, e-mail, avatar `user_image`) přihlášeného
  uživatele — jde o schopnost **profilu** účtu (viz kandidát `UC0024` v
  `_ar/spec-draft/UI-gap-promotions.md`, zde nemodelováno) a je **odlišná** od zde dokumentovaného
  read-modelu historie darů. Potvrzuje, že headless oblast účtu existuje, sama však historii darů
  neprojektuje.
- `_ar/spec-draft/DOMAIN-kernel.md` (INV21) a `_ar/spec-draft/DOMAIN-ubiquitous-language.md`
  (role „Supporter") již dokumentují, že role `supporter` je uživateli automaticky přidělena při
  jeho první uhrazené transakci — což je v souladu s přístupovou podmínkou pro tento view a je
  jejím předpokladem.

**Hypothesis (pouze UI mockup, nikoli v kódu):**

- `screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png` — e-mail „Dokončete svůj uživatelský
  účet 🎉" obsahuje mobilní mockup dashboardu účtu zobrazující: záložky „Pro vás" / „Všechny
  (67)"; kartu příběhu s textem „Přispěli jste 1 250 Kč", countdown („ZBÝVÁ 10 DNÍ") a dvojici
  cíl/vybráno („83 240 Kč / 101 591 Kč"); textový obsah slibující „příběhy, na které jste
  přispěl/a, částku, kterou jste daroval/a, **potvrzení o darech, zpětné vazby**" vše „pod jednou
  střechou". Žádný odpovídající reálný snímek tohoto dashboardu nebyl pořízen (viz
  `_ar/evidence/ui/ui-observed-areas.md` §19 a `_ar/coverage/ui-gap-analysis.md` řádek 231).

## Životní cyklus

Neaplikuje se — DonorAccountView je bezstavová projekce v okamžiku čtení, nikoli perzistentní
entita s vlastním záznamovým životním cyklem. Nemá vlastní události vzniku, aktualizace ani
smazání; její obsah se mění pouze v důsledku změn v podkladových záznamech Transaction (EN0009) a
Campaign (EN0004), které čte.

## Přechody stavů

Žádné. Neexistuje stavový automat: projekce je při každém čtení znovu spočítána z aktuálních dat
Transaction a Campaign.

## Atributy

### Confirmed (z view `supporter_zone`)

- Podpořený příběh (odkaz na EN0004 – Campaign; seskupovací klíč) — jeden řádek za každý odlišný
  příběh, ke kterému má aktuální uživatel uhrazenou transakci daru.
- Přispěná částka (integer; odvozeno; `sum(price)` uhrazených, dárcovských transakcí aktuálního
  uživatele k danému příběhu).

### Hypothesis — nedoloženo v současných zdrojích (pouze mockup; neposuzovat jako potvrzené)

- Stav vybírání za jednotlivý příběh (cílová částka, vybraná částka, countdown zbývajících dnů) —
  viditelný na kartě příběhu v e-mailovém mockupu, ale není přítomen jako pole samotného view
  `supporter_zone` (tato informace žije na Campaign, EN0004, a vyžadovala by, aby view — nebo jiný
  read-model — ji rovněž projektoval; žádné takové rozšíření není doloženo).
  Pole cíl/vybráno/deadline u příběhu na EN0004 samotné skutečně existují; zda je reálný dashboard
  do této projekce spojuje, není potvrzeno.
- Stahovatelná potvrzení o darech (odkaz na EN0014 – DonationConfirmation na dar/příběh) — žádné
  pole ani vazba na DonationConfirmation nebyly nalezeny na `supporter_zone` ani na žádném
  sourozeneckém view; schopnost daňového potvrzení v účtu je **samostatný, kódem potvrzený**
  samoobslužný formulář (route `donation_confirmation.page`, `/donation-confirmation`), který do
  této projekce zapojen není.
- Zpětná vazba od podpořeného dítěte/rodiny (odkaz na EN0021 – Feedback) — žádné pole ani vazba na
  Feedback nebyly nalezeny na `supporter_zone`; Feedback je v kódu vytvářena administrátorem za
  žádost (`feedback.campaign_feedback_form`, `/admin/application/{application}/feedback`), přičemž
  ve zdrojích nebyla nalezena žádná dárci určená route ani view s výpisem „moje zpětné vazby".
  Rozdělení na záložky „Pro vás / Všechny (67)" (personalizovaný výběr vs. celkový počet 67
  položek) — na `supporter_zone` ani na žádném souvisejícím view/resource nebyl nalezen odpovídající
  parametr, filtr ani pole s počtem.

## Invarianty

- Do projekce jsou zahrnuty pouze transakce s `ext_status = PAID` a `is_donation = 1` — širší
  pravidla stavu platby/peněz, na kterých toto závisí, viz BR-PaymentAndMoneyIntegrity.
- Projekce je ohraničena na požadujícího uživatele prostřednictvím výchozí hodnoty argumentu
  `current_user` — dárce může přes tento view vidět pouze svou vlastní historii darů; neexistuje
  doložená cesta pro procházení napříč uživateli.
- Přístup vyžaduje roli `supporter`, která (podle DOMAIN-kernel INV21) je přidělena až po první
  uhrazené transakci — dárce bez uhrazených darů nemá vyplněné (ani přístupné) DonorAccountView.
- Pouze pro CZ v doložené konfiguraci: view `supporter_zone` je přítomen výhradně v config splitu
  `config_czech`; žádný ekvivalent nebyl nalezen v základní/sdílené konfiguraci ani v jiných
  pozorovaných config splitech. Zda RO/MD tenanti mají ekvivalentní view zóny dárce pod jinou cestou
  config splitu, je **Unknown** — v tomto průchodu nebylo hledáno/nalezeno; označeno jako Evidence
  Gap.

## Vztahy

- EN0009 – Transaction (zdrojové řádky: uhrazené, dárcovské transakce vlastněné aktuálním
  uživatelem)
- EN0004 – Campaign (seskupovací klíč; „podpořený příběh")
- EN0008 – User (ohraničující/vlastnící strana; musí mít roli `supporter`)
- EN0014 – DonationConfirmation — **není** potvrzeným vztahem této projekce; uvedeno pouze proto,
  že jej naznačuje UI mockup (viz Evidence Gaps)
- EN0021 – Feedback — **není** potvrzeným vztahem této projekce; uvedeno pouze proto, že jej
  naznačuje UI mockup (viz Evidence Gaps)

## Evidence Gaps

1. **Kompozice nad rámec historie darů podle příběhu je nepotvrzená.** View `supporter_zone`
   projektuje přesně dva sloupce (Campaign, sečtená price). Bohatší dashboard naznačený
   e-mailovým mockupem (countdown/stav vybírání za jednotlivý příběh, stahovatelná potvrzení,
   zpětná vazba, záložky „Pro vás / Všechny (67)") **nemá odpovídající view, controller ani REST
   resource** nalezené v `web/modules/custom/` v tomto průchodu. Buď (a) je tato bohatší kompozice
   vykreslována na straně klienta skládáním více existujících endpointů (data ekvivalentní
   `supporter_zone` + DonationConfirmation + Feedback, načtené odděleně a sloučené na frontendu,
   který tento repozitář neobsahuje), nebo (b) mockup předjímá/přeceňuje dosud nevybudovanou
   funkcionalitu. Ze samotného tohoto backendového zdroje to nelze vyřešit — **doporučujeme cílený
   follow-up**: dohledat/prozkoumat samostatnou frontendovou aplikaci určenou dárcům (není
   přítomna v `intake/current-solution/_source/patronus`, který je pouze Drupal backend), pokud je
   v rozsahu této rekonstrukce.
2. **Ekvivalent pro RO/MD neznámý.** `views.view.supporter_zone.yml` existuje pouze pod
   `sync_config/config_czech/`. Zda tenanti Rumunska/Moldavska vystavují ekvivalentní view zóny
   dárce (pod jiným config splitem, nebo sdíleným, který toto hledání neodhalilo), zůstává
   nevyřešeno.
3. **Sémantika záložek „Pro vás / Všechny (67)" neznámá.** Žádný filtr/argument na
   `supporter_zone` (ani žádném sourozeneckém view) neodpovídá rozdělení personalizovaný
   výběr-vs-celkový počet. Zda se „Všechny (67)" vztahuje na všechny aktivní příběhy platformy
   (nesouvisející s vlastními příspěvky dárce) spíše než na koncept účtu dárce vůbec, zůstává
   nevyřešeno.
4. **Vztah k `ProfileResource` / oblasti profilu účtu je hranicí dokumentace, nikoli datovým
   vztahem.** Schopnost editace profilu (`/api/3.2/user/profile`) a tato projekce historie darů
   jsou dva samostatné, aktuálně nekombinované backendové povrchy; zda reálný frontend prezentuje
   obě jako jednu kompozitní stránku „Můj účet" (podle screenshotů `/muj-ucet/nastaveni` a
   mockupu dashboardu), je otázkou kompozice na frontendu mimo tuto Drupal-backendovou evidenci.

## Otevřené otázky

1. Existuje jednotný backendový endpoint „dashboardu" (REST resource), který agreguje historii
   darů + potvrzení + zpětnou vazbu pro frontend účtu, odlišný od klasického Drupal View
   `supporter_zone`? V tomto průchodu nenalezeno — view může být legacy/back-office přidružený,
   zatímco novější REST dashboard existuje jinde, nebo je view skutečným mechanismem za
   `zona/darce`, přičemž bohatší mockup je aspirační/budoucí obsah v drip e-mailu.
2. Existuje RO/MD ekvivalent `zona/darce` / `supporter_zone` pod jiným názvem config splitu, a
   pokud ano, je jeho složení polí identické?
3. Měly by být prvky „stahovatelná potvrzení" a „zpětná vazba" z mockupu, pokud budou potvrzeny
   jako reálné, přidány jako nová pole/vztahy do této projekce, nebo je lépe je modelovat jako
   samostatné read-modely skládané na straně klienta, spíše než je začlenit do
   `DonorAccountView`? Ponecháno otevřené do vyřešení Evidence Gap 1.
