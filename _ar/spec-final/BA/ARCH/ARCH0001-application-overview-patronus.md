---
doc_id: ARCH0001
title: Application Overview (Patronus)
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
---

# ARCH0001 — Přehled aplikace (Patronus)

> Vygenerováno agentem **AR:ARCHWriter** · 2026-07-02 · fáze rekonstrukce systému (pouze syntéza, bez čtení kódu).
>
> **Vstupy (vše `_ar/**`):** repo-map [`entrypoints.md`](../repo-map/entrypoints.md), [`modules.md`](../repo-map/modules.md),
> [`integrations.md`](../repo-map/integrations.md); vrstva SRV [`SRV-architecture-map.md`](SRV-architecture-map.md)
> (kontexty C1..C11, 4vrstvá taxonomie), [`SRV-target-list.md`](SRV-target-list.md) (36 cílových SRV);
> vrstva UC [`UC-candidates.md`](UC-candidates.md) (22 UC) + [`UC-srv-traceability.md`](UC-srv-traceability.md);
> důkazy DB [`db-inventory.md`](../evidence/db-inventory.md); vrstva DOMAIN [`DOMAIN-kernel.md`](DOMAIN-kernel.md)
> (INV01..INV28, stavové automaty, hotspoty HS01..HS16), [`DOMAIN-aggregates.md`](DOMAIN-aggregates.md) (AG1..AG13),
> [`CONSISTENCY-boundaries.md`](CONSISTENCY-boundaries.md).
>
> **Zásada.** Popisuje **SOUČASNÝ** systém Patronus tak, jak funguje dnes; **nejde** o cílový stav `it-zadani`.
> Každé architektonické tvrzení je dohledatelné k povrchu repo-map, k identifikátoru SRV/kontextu, k názvu integrace nebo
> k identifikátoru DOMAIN (ENxxxx / UCxxxx / AGxx / INVxx / HSxx / FLWxxxx). Žádné detaily na úrovni kódu (žádné názvy
> souborů/tříd/metod, žádné tokeny tabulek/sloupců). Doménový **status vocabulary** (PAID, `to_check`, `scoring_ok`, `campaign_uncompleted`, …)
> a pojmenované **integrace** (ComGate, Netopia, MAIB, Moneta, Mautic, …) jsou zachovány jako termíny ubikvitního jazyka.
> Úroveň důvěryhodnosti (`Confirmed` / `Partial` / `Hypothesis`) je převzata beze změny ze zdrojových artefaktů.

---

## 1. Účel systému

Patronus je **platforma pro dary / patronátní podporu dětí** fungující ve třech zemích — **ČR / RO / MD**
(Česká republika, Rumunsko, Moldavsko). Jejím smyslem je propojit **žadatele** (fundraisera) (který žádá o pomoc
jménem **dítěte**) s **patronem** / dárcem (který tuto pomoc financuje), provést případ rizikovou kontrolou a
právní smlouvou, publikovat jej jako veřejný fundraisingový **příběh (Story/Příběh)** a vybrat a spárovat peníze,
které jej financují [DOMAIN-kernel §1; EN0001; EN0004; EN0008].

Doména se točí kolem tří hlavních konceptů a peněz, které jimi protékají:

- **Lead / žádost (Application/Žádost)** — záznam případu. „Lead" **není** samostatná entita; jde o ranou
  fázi příjmu/koordinace téhož záznamu žádosti, takže jeden workflow s ~66 stavy pokrývá stavy z éry leadu
  i z éry žádosti na jednom poli [EN0001; DOMAIN-kernel §1; INV19]. Zpracováváno jako agregát záznamu případu
  (EN0001, AG1) — obsluhované SRV Application-Lifecycle, Application-Status-Orchestrator a
  ApplicationAction-Processor (C1); jeho rozeslání stavu čte ApplicationReaction (EN0026), připojuje
  ApplicationLog (EN0025) a řídí Scoring-&-Risk / Blacklist (C2, EN0016/EN0017) a povrch pro příjem leadů
  z Facebooku [modules.md §2] — a use-case UC0001 (odeslání), UC0002 (orchestrace změny stavu),
  UC0016 (deduplikace/sloučení).
- **Příběh / kampaň (Story/Campaign, Příběh)** — veřejný fundraisingový příběh vygenerovaný ze schválené žádosti;
  nese cílovou částku, průběžnou vybranou částku, termín a stav životního cyklu [EN0004]. Zpracováváno jako agregát
  Campaign/Story (EN0004, AG2) a UC0011 (životní cyklus kampaně/příběhu).
- **Dar / transakce (Donation/Transaction)** — každá příchozí platba (jednorázová, firemní, opakovaná, poukazová
  nebo import z banky/AISP) [EN0009]. Zpracováváno jako agregát Transaction (EN0009, AG3) a agregát
  RecurringTransaction (EN0010, AG4), zachycované prostřednictvím adaptérů brány pro danou zemi
  (ComGate/Netopia/MAIB, C4), a use-case UC0005 (darování) / UC0006 (callback brány) / UC0007 (opakovaná platba) /
  UC0008 (párování plateb).

Podpůrné účely doložené v inventáři modulů a v UC: rizikový scoring a blacklisting (UC0003), generování smluv
a elektronický podpis (UC0004), daňové doklady — potvrzení o daru pro ČR a přesměrování 2 % daně pro RO
(UC0010), správa stran/CRM (UC0016), autentizace a GDPR (UC0014/UC0015), reporting a export csv (UC0017) a
sada integračních/infrastrukturních schopností (indexování pro vyhledávání, provozní alerting, workflow engine,
import faktur). Patronus je technicky **zakázková aplikace v Drupalu (PHP)** — 52 zakázkových modulů, 3 zakázková
témata, exportovaná konfigurace — přičemž jádro/kontrib moduly Drupalu jsou mimo rozsah [modules.md §1, §4].

---

## 2. Hranice systému

**Uvnitř systému (vlastněno Patronusem).** Celý životní cyklus Application/Lead → Scoring → Contract → Campaign →
Donation a jeho data: ~37 zakázkových entit v MariaDB (viz §6), ~66stavový workflow žádosti, logika financování
kampaní, zpracování transakcí/opakovaných plateb/poukazů, párování plateb, generování dokumentů, záznamy stran,
reportingové projekce a orchestrace transakčních zpráv [db-inventory §2; DOMAIN-kernel §1; SRV-target-list vrstva D].
Všech 11 bounded kontextů C1..C11 (viz §4) leží uvnitř hranice systému.

**Mimo systém (nevlastněno).** Patronus je závislý na sadě externích systémů, ale nevlastní je (viz §5):
platební brány (**ComGate**, **Netopia/MobilPay**, **MAIB**), bankovní API **Moneta** a klientská schránka
**IMAP** pro bankovní avíza, CRM / marketingová platforma **Mautic**, analytika **Facebook** (Pixel +
Conversions API) a **Google Tag Manager**, státní registry (**MVČR** — kontrola neplatnosti dokladu, **ARES** —
obchodní rejstřík), kalendář státních svátků **Nager.Date**, úložiště faktur **OneDrive / Microsoft Graph**,
**Elasticsearch** (úložiště auditního logu + vyhledávací index + samostatný index `organisations` v Elastic Cloud)
a provozní alertingové kanály **Slack** / **Telegram** [integrations.md §1–§10; SRV-architecture-map §4].

**Model stran (kdo jedná uvnitř hranice).** Každý aktér je **uživatel (User)** odlišený *rolí*, nikoli
samostatným typem účtu [EN0008; db-inventory §5 uvádí 15 rolí, mj. administrator, coordinator,
senior_coordinator, accountant, content_admin, risk_manager, marketing, fundraiser, patron, supporter,
organisation_worker, front, manager]. Osobní/institucionální detail pro jakoukoli stranu (dítě, žadatel, patron,
škola, zaměstnavatel, lead) je uložen v jediném přetíženém úložišti **kontakt (Contact)**, rozlišeném pouze
diskriminátorem role [EN0006; HS08]. Tři obchodní pojmy jsou záměrně přetížené a musí být drženy odděleně:
„Lead" = fáze příjmu žádosti (viz výše); „Patron" pokrývá roli uživatele patron, kontakt patron a veřejný
zobrazovací profil patrona na příběhu (EN0008 / EN0006 / EN0005); „Account" (EN0007) není ani bankovní účet,
ani uživatel Drupalu a je součástí **dormant** (neaktivního) doporučovacího subsystému [DOMAIN-kernel §1; INV27].

**Multi-tenantní hranice CZ / RO / MD (slabá / implicitní).** Tři země obsluhuje **jedna instance Drupalu**
s **jazykovou negotiací pomocí URL path-prefixu** (prefixy `cs, en, ru, ro`) a s per-country frontendy pro CZ
a RO (MD nemá vlastní frontend) — neexistuje **doménová multi-tenancy** ani **sloupec tenant/country** na
klíčových entitách [integrations.md §10; modules.md §4]. Chování podle země je místo toho vyjádřeno pomocí
runtime větvení podle země, platebních modulů pro jednotlivé regiony a natvrdo zapsaných kontrol země —
strukturální riziko zaznamenané jako **HS11** a znovu rozebrané v §8.

**Co systém NEVLASTNÍ / co je explicitně vyloučeno.** Výše uvedené externí registry a brány; produkční
přihlašovací údaje / DSN / topologie DB (zdroj je GDPR-očištěný — `Blocked`) [db-inventory §1, §6]; jádro/kontrib
Drupalu a vendorované knihovny (mimo rozsah analýzy) [modules.md]; a *obsahová* matice notifikací (stav → role →
text → kanál), kterou vlastní důkazy z test-scenarios a vrstva MSG, nikoli tato ARCH fáze [integrations.md §2].

---

## 3. Architektura na vysoké úrovni

Patronus je **monolit v Drupalu 10 (PHP)** postavený téměř výhradně ze zakázkových modulů nad Entity/Field API
Drupalu, s MariaDB jako primárním úložištěm [db-inventory §1; modules.md §1]. Na koncepční úrovni je vrstven
následovně (bez detailů na úrovni kódu — každá vrstva je role doložená citovaným povrchem repo-map):

1. **Vstupní povrchy (web + pozadí).** Jeden HTTP front controller bootstrapuje všechny webové požadavky; ~28
   modulů deklaruje routy (administrace workflow žádosti/leadu, callbacky bran, JSON/session API) obsluhované
   ~56 controllery a ~185 formuláři [entrypoints.md §1–§3, §7]. Souběžně existují povrchy na pozadí: naplánovaná
   (cron) práce v 9 modulech, 5 queue workerů a CLI/konzolové příkazy [entrypoints.md §8].
2. **Doménové entity.** ~37 zakázkových content/config entit nese většinu doménového stavu jako v kódu
   definovaná základní pole (viz §6) [db-inventory §2].
3. **Služby / orchestrace.** ~38 souborů s definicí služeb napříč ~28 moduly vystavuje doménové a workflow
   služby (např. workflow službu, akční službu, rozesílání pošty, tokeny, naplánované publikování)
   [entrypoints.md §5]. **Hlavním orchestračním švem platformy je zakázková událost změny stavu žádosti**,
   kterou konzumují tři odběratelé (notifikace, reakce, scoring) — opakující se vzor „reaguj na změnu stavu
   žádosti" [entrypoints.md §6; SRV0002; UC0002; HS01].
4. **Integrační adaptéry.** Hranice pro jednotlivé dodavatele (platební brány, bankovní API, CRM, registry,
   úložiště, index, alerting) žijí ve vyhrazených modulech, které obalují externí protokol/SDK (viz §5)
   [integrations.md; SRV-architecture-map §4].
5. **Asynchronní procesory.** Práce řízená cronem a frontami (opakované platby, párování plateb, export csv,
   indexování pro vyhledávání, naplánované publikování, dormant doporučovací procesor) běží mimo cestu
   požadavku [entrypoints.md §8; SRV-target-list vrstva P].

Rekonstrukce SRV organizuje každou službu do **4vrstvé taxonomie** [SRV-architecture-map §2; SRV-target-list],
což je koncepční architektura, kterou by měl přepis zachovat:

| Vrstva | Role | Počet cílových SRV | Příklady (podle názvu cílového SRV) |
|---|---|---|---|
| **D — doménové služby** | Vlastní životní cyklus entit a business pravidla | 10 | Application-Lifecycle, Scoring-&-Risk, Campaign-&-Story-Lifecycle, Payment-Processing, Bank-Reconciliation, Document-Generation-&-Fulfilment, Party-&-Contact-Management, Reporting-ReadModel, Identity-&-Access, Reference-Data |
| **O — aplikační orchestrátory** | Koordinují doménové služby napříč kontexty | 3 | Application-Status-Orchestrator, Transactional-Messaging-Orchestrator, Workflow-Engine |
| **A — integrační adaptéry** | Izolují vždy jednu externí hranici | 16 | ComGate/Netopia/MAIB-Adapter, Moneta-AISP-Adapter, BankMail-IMAP-Adapter, MVCR-/ARES-Adapter, Mautic-/FacebookCAPI-/Analytics-/Email-/WhoisXML-Adapter, OneDrive-Graph-Adapter, Elasticsearch-Adapter, Ops-Logging-Adapters |
| **P — asynchronní procesory** | Práce na pozadí řízená cronem/frontami | 7 | RecurringPayment-, Reconciliation-, CSV-Export-, SearchIndex-, ScheduledPublish-, CampaignRecommendation- (dormant), ApplicationAction-Processor |

**Celkem: 36 cílových SRV (D:10 · O:3 · A:16 · P:7)** [SRV-target-list Summary]. Je zásadní, že toto čisté
vrstvení je **cílová podoba rekonstrukce**; dnes je několik z těchto „služeb" realizováno jako vedlejší efekty
uložení entity, nikoli jako plnohodnotné služby — nejdůležitější jsou orchestrátor stavu (**HS01**) a platební
peněžní uzel (**HS03**). Viz §8.

---

## 4. Mapa bounded kontextů

Jedenáct bounded kontextů (C1..C11), odvozených přímo z [SRV-architecture-map §1–§2]. Každý řádek uvádí
jednořádkový účel kontextu, cílové SRV, které vlastní (z `SRV-target-list.md`), a agregáty (AGxx), jejichž
životní cyklus v něm žije (z `DOMAIN-aggregates.md`).

| Kontext | Účel (jedna věta) | Vlastněné cílové SRV | Rezidentní agregáty |
|---|---|---|---|
| **C1 Žádost a lead** | Životní cyklus případu od příjmu leadu přes ~66stavový workflow | Application-Lifecycle (D), Application-Status-Orchestrator (O), ApplicationAction-Processor (P) | **AG1** Application (kořen EN0001; členové ApplicationProfile ×2, ApplicationSession, ApplicationLog) |
| **C2 Riziko a scoring** | Hodnocení rizika, low-risk scoring, blacklisting, kontroly identity/registrů | Scoring-&-Risk (D), MVCR-DocValidity-Adapter (A), ARES-Registry-Adapter (A) | **AG9** Risk (kořen ScoringRecord EN0017; člen Blacklist EN0016) |
| **C3 Kampaň a příběh** | Životní cyklus veřejného fundraisingového příběhu a (dormant) doporučování | Campaign-&-Story-Lifecycle (D), CampaignRecommendation-Processor (P, **dormant**) | **AG2** Campaign (kořen EN0004; členové Patron EN0005, Feedback EN0021, CampaignLog EN0028) |
| **C4 Dary a platby** | Dary, zachycení platby na bráně, opakované předplatné | Payment-Processing (D), ComGate-/Netopia-/MAIB-Adapter (A), RecurringPayment-Processor (P) | **AG3** Transaction (kořen EN0009), **AG4** RecurringTransaction (kořen EN0010), **AG6** Voucher (kořen EN0013) |
| **C5 Finance a párování plateb** | Párování plateb banka/brána, reportingový read-model, export csv | Bank-Reconciliation (D), Reporting-ReadModel (D), Moneta-AISP-/BankMail-IMAP-/ComGate-TransferSync-Adapter (A), Reconciliation-Processor (P), CSV-Export-Processor (P) | **AG12** BankTransactionMail (EN0029), **AG13** ComgateBankReconciliation (EN0030); read-modely CostsSnapshot/ReportSnapshot |
| **C6 Dokumenty a plnění** | Smlouvy, daňová potvrzení, poukazy, import faktur | Document-Generation-&-Fulfilment (D), OneDrive-Graph-Adapter (A) | **AG5** Contract (EN0011), **AG10** DonationConfirmation (EN0014), **AG11** TaxPayer (EN0015) |
| **C7 Strana / CRM** | Univerzální úložiště stran (User + Contact), organizace, poznámky | Party-&-Contact-Management (D) | **AG7** Party (kořen User EN0008; členové Contact EN0006, Account EN0007 *dormant*, UserNote EN0023), **AG8** Organisation (EN0018) |
| **C8 Zprávy a marketing** | Transakční zprávy, synchronizace CRM/analytiky, kontrola domény | Transactional-Messaging-Orchestrator (O), Mautic-CRM-/FacebookCAPI-/Analytics-/Email-/WhoisXML-Adapter (A) | (žádný transakční kořen agregátu; EmailArchive EN0022 je log jednotlivých odeslání — DOMAIN-aggregates §3) |
| **C9 Identita a přístup** | Autentizace, session, role, GDPR anonymizace | Identity-&-Access (D) | (přispívá do **AG7** Party; auth/GDPR příkazy na User EN0008) |
| **C10 Vyhledávání a indexování** | Synchronizace entit → vyhledávací index | SearchIndex-Processor (P), Elasticsearch-Adapter (A) | (žádný rezidentní agregát — indexuje AG1/AG2/AG3/AG8 jako vedlejší efekt uložení; **Partial**, HS16) |
| **C11 Platforma / integrační vrstva** | Workflow engine, referenční data, naplánované publikování, provozní alerting | Workflow-Engine (O), Reference-Data (D), ScheduledPublish-Processor (P), Ops-Logging-Adapters (A) | (žádný rezidentní agregát; referenční/konfigurační entity ApplicationReaction/ApplicationAction, geo/PSČ referenční data) |

Poznámky: rezidence agregátů se řídí vlastnícím kontextem každého kořene agregátu v `DOMAIN-aggregates.md §1`;
C9 se překrývá s C7 na agregátu Party (Identity-&-Access a Party-&-Contact-Management sdílejí AG7 podle
DOMAIN-aggregates AG7). C10 a C11 jsou **málo/částečně zmapované** (HS16).

---

## 5. Integrační krajina

Externí systémy z [integrations.md], se směrem, spouštěčem a dopadem selhání v současném stavu. Dopady selhání
jsou zakotveny v hotspotech/tocích DOMAIN tam, kde jsou doloženy; jinak je dopad uveden konzervativně na základě
role integrace. Úroveň důvěryhodnosti převzata z `integrations.md`.

| # | Externí systém | Kontext / SRV | Směr | Spouštěč | Dopad selhání (současný stav) |
|---|---|---|---|---|---|
| 1 | **ComGate** (platební brána pro ČR) | C4 / ComGate-Adapter | Obousměrný (odchozí vytvoření + příchozí callback) | Checkout daru + callback stavu brány (UC0005/UC0006) | Callback route je fakticky veřejná, bez HMAC; tiché nenalezení shody ponechá zaplacenou transakci nikdy neoznačenou jako PAID → ztracené párování plateb (**HS12**) |
| 2 | **Netopia / MobilPay** (platební brána pro RO) | C4 / Netopia-Adapter | Obousměrný (odchozí + IPN redirect) | Dar RO + IPN (UC0006) | Nejsilnější vendor lock-in (vendorované SDK); RO cron pro opakované platby postrádá guard prostředí (**HS11**) — ztráta zachycení platby/tokenu při selhání |
| 3 | **MAIB** (eCommerce brána pro MD) | C4 / MAIB-Adapter | Obousměrný (odchozí + opakovaný dotaz) | Dar MD + opakovaný dotaz na stav (UC0006) | Lock-in na mutual-TLS certifikát + heslo; selhání opakovaného dotazu ponechá transakci uvíznutou ve stavu PENDING |
| 4 | Bankovní API **Moneta** (ČR, AISP) | C5 / Moneta-AISP-Adapter | Příchozí (dotazování) | Denní cron párování plateb (UC0008) | Nastaví čas posledního běhu před prací + vždy dotazuje „včerejšek" → selhání uprostřed běhu natrvalo přeskočí den, bez opakování (**HS05**) |
| 5 | Schránka **IMAP** pro bankovní avíza (ČR) | C5 / BankMail-IMAP-Adapter | Příchozí (dotazování) | Cron import (UC0008) | Parsuje HTML pomocí pevného XPath → prázdné hodnoty při změně šablony; nestabilní idempotenční klíč → chybný/duplicitní import (**HS05**) |
| 6 | **Synchronizace převodů/vypořádání ComGate** (ČR) | C5 / ComGate-TransferSync-Adapter | Příchozí (pull) | CLI / cron synchronizace převodů (UC0008) | Párování plateb je omezeno (limitem řádků) → přebytečné řádky rozdělených plateb zůstanou tiše neoznačené; žádné ošetření chyb HTTP/JSON (**HS05**) |
| 7 | **Mautic** (marketing / CRM) | C8 / Mautic-CRM-Adapter | Odchozí | Zařazení do fronty při uložení uživatele + transakční odeslání (UC0012/UC0013/UC0015) | Transakční e-mail je odesílán **synchronně** přes Mautic uvnitř uložení entity; pomalé/selhávající volání blokuje/přeruší uložení, bez opakování (**HS13**); anti-erasure re-upsert při GDPR anonymizaci (**HS06**) |
| 8 | **Facebook Conversions API (CAPI)** | C8 / FacebookCAPI-Adapter | Odchozí (relay) | Relay endpoint pro Pixel-eventy (UC0013) | Pouze ztráta marketingového signálu; příchozí FB Lead webhook je potvrzený **neimplementovaný** stub (**Partial**, HS16) |
| 9 | **Google Tag Manager / FB Pixel (Analytics)** | C8 / Analytics-Adapter | Odchozí (klientská stránka) | Vykreslení stránky (UC0013) | Pouze ztráta analytického signálu; žádný dopad na doménu (**Partial**) |
| 10 | **WhoisXMLAPI** (validace e-mailové domény) | C8 / WhoisXML-DomainCheck-Adapter | Odchozí | Volané při zprávách/kontrole domény (UC0012) | Kontrola platnosti domény není dostupná → mezera ve validaci (zmírněno cachovanými výsledky) |
| 11 | **ARES** (obchodní rejstřík ČR) | C2 / ARES-Registry-Adapter | Odchozí | AJAX vyhledání ve scoringu (UC0003) | Žádný timeout na volání → zaseknutý registr může zpozdit požadavek |
| 12 | **MVČR** (kontrola neplatnosti dokladu ČR) | C2 / MVCR-DocValidity-Adapter | Odchozí | Kontrola identity ve scoringu (UC0003) | Kontrola platnosti dokladu není dostupná → degradovaná riziková kontrola |
| 13 | **OneDrive / Microsoft Graph** (import faktur) | C6 / OneDrive-Graph-Adapter | Příchozí (pull) | CLI import faktur (UC0019) | Lock-in na ROPC password-grant; selhání importu → faktury nejsou připojeny k žádostem kampaně |
| 14 | **Elasticsearch** (auditní úložiště + vyhledávací index + `organisations` v Elastic Cloud) | C10/C11 / Elasticsearch-Adapter | Odchozí (zápis/indexování) | Zařazení do fronty při uložení entity + cron; denní plný re-push organizací (UC0018/UC0016) | Skutečně asynchronní pro vyhledávání (fronta); tok synchronizace indexu je nyní zmapován (FLW0032) — Confirmed; zbytkový **Partial** pouze u plánování vyprazdňování fronty (HS16); index organizací je při každém běhu plný re-push (bez kurzoru) |
| 15 | **Slack** | C11 / Ops-Logging-Adapters | Odchozí | Kanál loggeru při ERROR/CRITICAL (UC0020) | Pouze ztráta alertu o chybě/stavu; používá se také k upozornění (nikoli opravě) na desynchronizaci Application↔Campaign (INV04) |
| 16 | **Telegram** | C11 / Ops-Logging-Adapters | Odchozí | Kanál loggeru při závažnosti error (UC0020) | Pouze ztráta alertu o chybě; nese alert o desynchronizaci (INV04) |
| 17 | **Nager.Date** (kalendář státních svátků) | C3 / Campaign-&-Story-Lifecycle | Odchozí | Validace termínu kampaně RO | **Fail-open**: pokud je API nedostupné ⇒ datum je považováno za pracovní den, pravidlo pracovního dne pro RO je tiše obejito (FLW0021) |

**Počet integrací: 17 externích systémů / hranic.** (Firebase je composer závislost s příkazem, který
**neprovádí** žádné volání Firebase SDK — `Uncertain`, vyloučeno z aktivní krajiny; SMS nemá vyhrazenou bránu —
`likely none` [integrations.md §5]. Elasticsearch je uveden jednou jako hranice, ačkoli má tři odlišná
současná použití — auditní úložiště, vyhledávací index, index organizací v Elastic Cloud [integrations.md §4].)

---

## 6. Datová architektura

**Engine a datové API.** Patronus persistuje do **MariaDB** (kompatibilní s MySQL) přes **Drupal 10 Entity/Field
API** (content/config entity s SQL úložištěm content entit); **neexistuje Doctrine ani jiný ORM** [db-inventory §1].
Produkční DSN/přihlašovací údaje/topologie **chybí** (GDPR-očištěno) — engine je odvozen z kontejnerového image
+ povoleného driveru, nikoli ze živého připojení (`Blocked`) [db-inventory §1, §6].

**Zakázkové entity (skutečný datový model).** **37 zakázkových typů entit** (36 content entit + 1 config entita),
z nichž **32 je povýšeno na doménové entity EN** a zařazeno do agregátů (13 kořenů, 10 členů, 4
referenční/config, 3 content, 2 read-model) [db-inventory §2; DOMAIN-aggregates §4]. Nejtěžší záznamy jsou žádost
a její ~100polní ApplicationProfile (uložený dvakrát na jednu žádost), kampaň, transakce a univerzální kontakt
[DOMAIN-kernel §1; HS10, HS08]. Hrstka core entit Drupalu (node bundly, user, taxonomy-term, media) nese config
pole, ale nejsou to zakázkové typy entit [db-inventory §2].

**Strukturální fakt — měkké reference, ŽÁDNÉ databázové cizí klíče.** Každý vztah mezi entitami je **měkká
reference (pouze target-id)**; Patronus nevynucuje **žádné DB cizí klíče** a u většiny identifikačních polí ani
**žádná omezení jedinečnosti** [db-inventory §2, §4; DOMAIN-aggregates modelovací výhrada; INV23/24/25; HS08].
Téměř všechny zakázkové tabulky nemají **žádné zdrojově deklarované schéma** — SQL schéma je generováno
frameworkem z definic polí (považováno za konvenci, nikoli důkaz); existují pouze dvě zakázkové zdrojově
deklarované tabulky, plus několik raw-SQL auditních/cache tabulek vytvořených přes update hooks (např. auditní
log změn stavu žádosti, cache e-mailových domén) [db-inventory §1, §4]. Tato absence referenční integrity je
jedinou největší strukturální charakteristikou datového modelu a hlavní příčinou destruktivních manuálních
procesů deduplikace/sloučení [HS08, HS09; INV17/18/19/23].

**Agregáty.** Transakční jádro je organizováno do **13 agregátů (AG1..AG13)** — devět vlastní transakční jádro,
plus čtyři write-once agregáty pro záznamy/importní audit — rekonstruovaných jako **logické/doménové hranice
(nikoli vynucené schématem)**, protože neexistují cizí klíče [DOMAIN-aggregates §1–§2, modelovací výhrada].
Kořeny: Application (AG1), Campaign (AG2), Transaction (AG3), RecurringTransaction (AG4), Contract (AG5),
Voucher (AG6), Party/User (AG7), Organisation (AG8), Risk/Scoring (AG9), DonationConfirmation (AG10), TaxPayer
(AG11), BankTransactionMail (AG12), ComgateBankReconciliation (AG13).

**Read-modely / projekční entity.** Reporting je obsluhován projekčními entitami — CostsSnapshot (EN0031) a
ReportSnapshot (EN0032) — plus logem jednotlivých odeslání EmailArchive (EN0022); tyto nemají žádný transakční
životní cyklus [DOMAIN-aggregates §3; UC0017].

**Model stavu / workflow.** Kanonický současný status vocabulary je Drupal content-moderation workflow s
**~66 stavy** (~40 přechody) navázaný na zakázkovou entitu žádosti, pokrývající stavy Lead/Application/Story
na jednom poli (např. `new`, `to_check`, `scoring`/`scoring_ok`, `contract`/`waiting_signature`/`contract_signed`,
`active`, `completed`, `campaign_uncompleted`, rodina `canceled_*`, `duplicate`) [db-inventory §5; EN0001;
DOMAIN-kernel §3.1]. Stav transakce je samostatný enum (PENDING/AUTHORIZED/PAID/CANCELLED/REFUNDED)
[db-inventory §5; DOMAIN-kernel §3.3]. Dále 24 config entit skupin stavů/filtrů funnelu a 15 uživatelských rolí
[db-inventory §5].

**Multi-tenantní rozsah dat.** Na klíčových entitách neexistuje **žádný sloupec country/tenant**; data ČR/RO/MD
koexistují ve stejných tabulkách a jsou oddělena pouze runtime větvením podle země a moduly pro jednotlivé země —
takže rozsah dat mezi tenanty není vynucen na datové vrstvě (proto jsou exporty csv globální napříč zeměmi)
[HS07, HS11; integrations.md §10].

---

## 7. Provozní model

Runtime povrchy, z [entrypoints.md] křížově odkázané na vrstvy procesorů/adaptérů SRV.

**HTTP / synchronní cesta požadavku.** Jeden front controller Drupalu bootstrapuje všechny webové požadavky
[entrypoints.md §1]. **~28 modulů deklaruje routy** [entrypoints.md §2] ve třech rodinách rout: admin UI
a CRUD pro workflow žádosti/leadu, callback/webhook endpointy platebních bran pro jednotlivé regiony
(ComGate / Netopia / MAIB / Moneta) a JSON/session API (session token, user-exists, magic-link, login,
aktivační e-mail). Ty jsou obsluhovány **~56 controllery** a **~185 formuláři** — platforma náročná na
zadávání dat [entrypoints.md §3, §7]. Některé routy jsou také deklarovány jako **REST zdroje** (např. relay
zdroj pro Facebook CAPI) [integrations.md §3].

**Event subscribers (orchestrační šev).** **6 event subscriberů**, z nichž **tři** reagují na zakázkovou
**událost změny stavu žádosti** (notifikace, reakce, scoring) — hlavní orchestrační šev platformy
[entrypoints.md §6; SRV0002; UC0002]. Toto rozeslání je **synchronní, v rámci požadavku, při každém uložení
žádosti**, nikoli oddělená sběrnice (HS01) — viz §8.

**Vedlejší efekty uložení entity.** Určující provozní rys: velká část „orchestrace" je implementována jako
**vedlejší efekty uložení entit**, nikoli jako explicitní úlohy — rozeslání stavu žádosti (HS01) a „peněžní
uzel" pro transakci ve stavu PAID, který přepočítává kampaň, dělí přeplatek, povyšuje opakovanou platbu/poukaz,
uděluje role a odesílá poštu, vše uvnitř uložení z každé cesty zápisu (HS03) [DOMAIN-kernel §4;
CONSISTENCY-boundaries §2–§3; FLW0002/0003]. To spojuje zápisy napříč agregáty do jednoho vlákna požadavku bez
transakčního obalení.

**Naplánované (cron) procesory.** **Práce řízená cronem v 9 modulech** [entrypoints.md §8]: účtování opakovaných
plateb podle brány (RecurringPayment-Processor, UC0007), párování plateb s bankou (Reconciliation-Processor:
dotazování Monety + import IMAP, UC0008), životní cyklus termínu kampaně (campaign uncomplete, UC0011), poukaz,
plus cron služba pro naplánované publikování (ScheduledPublish-Processor, UC0022) [SRV-target-list vrstva P].
Samostatný cronem vyvolávaný **export csv** zapisuje reportingové soubory do `/tmp` (CSV-Export-Processor,
UC0017) [integrations.md §8; HS07].

**Queue workeři.** **5 queue workerů** [entrypoints.md §8]: odesílání e-mailů, synchronizace s Mautic CRM,
indexování do Elasticsearch (SearchIndex-Processor, UC0018) a dva workeři pro doporučování kampaní (scoring +
trénování ML). Fronta pro indexování pro vyhledávání a fronta synchronizace s Mautic CRM jsou skutečně eventuální
cesty; e-mailový queue worker je **mrtvý kód** (rozesílání pošty běží synchronně, fronta je vypnutá — HS13)
a fronta doporučování je napájena **zakomentovanou / dormant** událostí (HS14; INV27)
[CONSISTENCY-boundaries §2; SRV-target-list].

**CLI / konzolové příkazy.** Příkazy Drush + Drupal Console pro import faktur z OneDrive (UC0019), synchronizaci
převodů ComGate, hromadné nahrání do Elasticsearch a sadu **jednorázových migračních příkazů** (backfilly,
nikoli runtime) [entrypoints.md §8].

**Řízení podle prostředí / tenanta.** Řízení probíhá pomocí **runtime větvení podle země a natvrdo zapsaných
kontrol země**, nikoli pomocí konfigurace: cron pro opakované platby a import banky jsou omezeny na ČR natvrdo
zapsanými kontrolami a RO cron pro Netopia nápadně **postrádá guard prostředí** — provozní riziko (HS11)
[DOMAIN-kernel §4]. Tajemství jsou u většiny integrací čtena z nastavení/prostředí, ale ve dvou zdrojových
místech (OneDrive, Facebook CAPI) existují natvrdo zapsané přihlašovací údaje — označeno pro zpevnění cílového
stavu, nikoli jako tvrzení o vadě současného chování [integrations.md §11].

---

## 8. Architektonická rizika

Top 5 strukturálních rizik, odvozených z hotspotů DOMAIN (HSxx), CONSISTENCY-boundaries a mezer v pokrytí.
(Kompletní mapa 15 hotspotů je v `DOMAIN-kernel §4`; tato sekce upřednostňuje pět rizik s nejširším strukturálním
dopadem pro přepis.)

**Riziko 1 — Žádné skutečné hranice konzistence: orchestrace a peněžní logika jsou netransakční vedlejší efekty
uložení entity.**
*Důkazy:* HS01 (orchestrace stavu jako vedlejší efekt uložení — každé uložení žádosti bezpodmínečně rozešle
událost stavu 3 synchronním odběratelům, bez ochrany proti nezměněnému stavu, bez idempotence, bez izolace,
navazující raw-SQL zápisy), HS03 (uložení transakce ve stavu PAID spouští přepočet kampaně + rozdělení
přeplatku + povýšení opakované platby/poukazu + udělení role + e-mail/Slack + vnořené kaskádové uložení, z každé
cesty zápisu, re-entrantní, bez idempotence callbacku); „headline truth" CONSISTENCY-boundaries (žádné DB cizí
klíče; kritické toky napříč agregáty se provádějí synchronně a netransakčně); INV01/03/07/21; FLW0001/0002/0003.
*Dopad:* Selhání uprostřed průběhu ponechá částečně aktualizovaný graf napříč agregáty; opakovaná uložení
znovu loguje/znovu odesílá; vnořená uložení riskují rekurzi/nadbytečné řádky. Toto je nejhlubší strukturální
problém a důvod, proč přepis musí tyto operace povýšit na plnohodnotné transakční příkazy + idempotentní,
oddělené události.

**Riziko 2 — Přetížené univerzální god-objekty party/Contact + Application/Profile, bez referenční integrity
nebo jedinečnosti.**
*Důkazy:* HS08 (jeden kontakt reprezentuje dítě/žadatele/patrona/školu/zaměstnavatele/lead podle
diskriminátoru, pouze měkké reference, žádný jedinečný klíč na rodném čísle/telefonu/e-mailu, klasifikace
zapisovaná raw update podle e-mailu **bez LIMIT**, který může přepsat nesouvisející kontakty), HS10 (žádost
váže ~20 měkkých referencí a ApplicationProfile nese ~100 polí ×2 na žádost, s provázáním vlastníků napříč
profily a raw-SQL zápisy obcházejícími vrstvu entit); INV15/23; db-inventory §2, §4.
*Dopad:* Hromadí se duplicity (což vynucuje destruktivní manuální sloučení v Riziku 3), zápisy klasifikace
mohou zasáhnout nezamýšlené záznamy a god-objekty odolávají bezpečné změně. Přepis musí rozdělit role stran
a přidat skutečná omezení identity/jedinečnosti.

**Riziko 3 — Destruktivní, netransakční deduplikace/sloučení a anti-erasure GDPR.**
*Důkazy:* HS09 (deduplikace kontaktů + párování leadů + deduplikace organizací běží bez DB transakce, bez
dry-run, natvrdo mažou duplicitní kontakty *a* jejich vlastnící uživatele obcházejíc zrušení/anonymizaci,
přepojují vlastníka jen u některých referencí a jiné ponechávají viset, bez rozsahu podle země/role), HS06
(GDPR výmaz pouze vyprázdní hodnoty na místě a znovu provede upsert uživatele do Mautic, který znovu vytvoří
kontakt se jmény zachovanými — právo na výmaz není splněno); INV17/18/19; FLW0020/0023/0024/0025.
*Dopad:* Nevratná ztráta dat / napůl sloučené grafy při selhání, visící reference a mezera v souladu s GDPR.

**Riziko 4 — Implicitní multi-tenancy ČR/RO/MD s únikem dat mezi tenanty a adaptéry s vendor lock-inem.**
*Důkazy:* HS11 (chování podle země je runtime větvení + natvrdo zapsané hodnoty pro jednotlivé země, žádný
sloupec tenant/country; rozdělení plateb podle brány, přičemž Netopia je nejsilnější vendor lock-in přes
vendorované SDK; RO přesměrování daně je samostatný tok; RO cron pro Netopia postrádá guard prostředí), HS07
(export csv vypisuje rodná čísla/jména/adresy/rizikové verdikty do `/tmp` **bez filtru podle
země/tenanta** — exporty jsou globální napříč ČR/RO/MD, soubory nejsou nikdy smazány, nešifrované PII v klidu);
SRV-architecture-map §4 (tabulka vendor lock-inu); integrations.md §10.
*Dopad:* Expozice PII mezi tenanty, žádná čistá izolace podle země a obtížně vyměnitelní dodavatelé
plateb/CRM/úložiště.

**Riziko 5 — Dormant/plánované a málo/nezmapované subsystémy přítomné v kódu, ale nikoli v živém chování.**
*Důkazy:* HS14 (subsystém doporučování kampaní — UC0021, AG7 Account — je neaktivní z 5 nezávislých důvodů:
zakomentované rozeslání události, modul není nainstalován, zakomentovaný klasifikátor YAML, chybějící knihovna
ML, zakomentované úložné pole; INV27), HS16 (SRV s málo/částečným pokrytím, jejichž toky byly nyní zmapovány
v dávce 4 — synchronizace vyhledávacího indexu (C10) → FLW0032, naplánované publikování + Workflow-Engine (C11)
→ FLW0033, listener provozních alertů → FLW0034 — které **potvrdily toky, ale odhalily zbytkové mezery
současného stavu, nikoli je uzavřely** (plánování vyprazdňování fronty nevynuceno, legálnost přechodu
nevynucena, dílčí tok auditu ES není indexován), plus **potvrzený neimplementovaný** příchozí Facebook lead
webhook); UC-srv-traceability §4 (po dávce 4 je jediným non-Confirmed pokrytím dormant doporučovací procesor
UC0021 a neimplementovaný příchozí FB webhook UC0013).
*Dopad:* Přepis nesmí **zacházet** s dormant/stub funkcemi jako s živým chováním současného stavu; každá
vyžaduje explicitní rozhodnutí zrušit-nebo-přebudovat. Toky z dávky 4 (FLW0032/FLW0033/FLW0034) jsou nyní
zmapovány, ale jejich zbytkové mezery současného stavu (plánování vyprazdňování fronty, legálnost přechodu,
indexování auditu ES) musí být vyřešeny dříve, než se na pokrytí SRV bude spoléhat jako na úplné, správné
chování.

---

## Poznámka k dohledatelnosti

Tento přehled je dokument **pouze syntézy**. Každé architektonické tvrzení výše odkazuje na povrch repo-map
(entrypoints / modules / integrations), bounded kontext (C1..C11) nebo cílové SRV, pojmenovanou integraci, nebo
identifikátor DOMAIN (ENxxxx / UCxxxx / AGxx / INVxx / HSxx / FLWxxxx) — **podle identifikátoru, bez opakování**
interního detailu těchto artefaktů a bez čtení zdrojového kódu repozitáře. Jako tvrzení se neobjevují žádné
názvy souborů/tříd/metod, žádné tokeny `.php`/`::` a žádné syrové tokeny tabulek/sloupců; jedinými zachovanými
doslovnými tokeny jsou doménový **status vocabulary**, pojmenované **externí systémy / integrace**, i18n
jazykové prefixy (cs/en/ru/ro) a jeden název externího indexu Elastic — vše legitimní termíny ubikvitního
jazyka / externích artefaktů. Štítky důvěryhodnosti (`Confirmed` / `Partial` / `Hypothesis`) jsou převzaty
beze změny; tento dokument popisuje **současný** systém a nezahrnuje cílový záměr `it-zadani`. Detail interakcí
mezi kontexty a mezi kontextem a externími systémy je v doprovodném dokumentu
[ARCH0002_ContextInteractionMap.md](ARCH0002_ContextInteractionMap.md).
