---
doc_id: ARCH0002
title: Context Interaction Map (Patronus)
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
---

# ARCH0002 — Mapa kontextových interakcí (Patronus)

> Vygenerováno pomocí **AR:ARCHWriter** · 2026-07-02 · fáze system-reconstruction (pouze syntéza, bez čtení kódu).
>
> **Vstupy (vše `_ar/**`):** [`SRV-architecture-map.md`](SRV-architecture-map.md) (kontexty C1..C11, směry
> závislostí), [`SRV-target-list.md`](SRV-target-list.md) (spouštěče pro jednotlivé SRV), [`SRV-flow-traceability.md`](SRV-flow-traceability.md),
> [`UC-candidates.md`](UC-candidates.md) / [`UC-srv-traceability.md`](UC-srv-traceability.md) (kotvy UC),
> [`CONSISTENCY-boundaries.md`](CONSISTENCY-boundaries.md) (§2 mechanismus na jednotlivý tok, §3 rizikové vzory),
> [`DOMAIN-kernel.md`](DOMAIN-kernel.md) (INV/HS), [`DOMAIN-aggregates.md`](DOMAIN-aggregates.md) (příslušnost AG),
> repo-map [`integrations.md`](../repo-map/integrations.md) / [`entrypoints.md`](../repo-map/entrypoints.md).
>
> **Zásada.** Pouze současný stav; každý řetězec je vysledovatelný ke kontextu (Cx) / cílovému SRV / názvu
> integrace a k identifikátoru INV/HS/UC/FLW. Žádné detaily na úrovni kódu. **Kritická pravda o současném stavu
> (z CONSISTENCY-boundaries):** většina řetězců, které by přepis chtěl mít asynchronní, je **dnes synchronní**
> (vedlejší efekty při uložení entity nebo dispatch události v rámci requestu). Takové řetězce jsou níže
> označeny; tam, kde je cesta neaktivní (dormant), je to vyznačeno a náprava je uvedena jako `[recommendation]`.
> Viz ARCH0001 §3–§4 pro taxonomii vrstev a účely kontextů.

---

## Legenda (notace)

| Notace | Význam |
|---|---|
| `A --sync--> B` | **Synchronní** volání v rámci requestu: A volá B a čeká (stejné vlákno požadavku / transakce) |
| `A ~~event~~> B` | **Událostní (event-like)** přechod: A vyvolá doménovou událost / vedlejší efekt při uložení entity, na který reaguje B (**dnes synchronní v rámci requestu**, pokud není označeno `[async]`) |
| `A ==queue==> B` | Hranice **asynchronní fronty**: A zařadí do fronty; worker/cron ji mimo pořadí (out-of-band) vyprázdní do B (skutečně asynchronní) |
| `A ..cron/CLI..> B` | Naplánovaný nebo CLI-spouštěný pull/push (na pozadí, nikoli vyvolaný requestem) |
| `A ..external..> X` | Volání **ven** do externího systému X (hranice adaptéru) |
| `X ~~webhook~~> A` | Externí systém X volá **dovnitř** (callback / IPN / webhook) |
| `⟂ DORMANT` | Cesta existuje v kódu, ale v současném stavu je neaktivní (`[recommendation]` zrušit/přebudovat) |
| `⚠ looks-async / is-sync` | Hranice, kterou by přepis považoval za asynchronní, ale která je **dnes synchronní v rámci requestu** |

Kontexty, na které se odkazuje (z ARCH0001 §4): **C1** Žádost & Lead · **C2** Riziko & Scoring · **C3** Kampaň &
Příběh · **C4** Dary & Platby · **C5** Finance & Párování plateb · **C6** Dokumenty & Plnění · **C7**
Party / CRM · **C8** Messaging & Marketing · **C9** Identita & Přístup · **C10** Vyhledávání & Indexace · **C11**
Platformová & Integrační vrstva.

---

## Hlavní end-to-end řetězce (orientace pro nového architekta)

Dva reprezentativní řetězce, poté systematický rozpad synchronní/asynchronní/událostní v podsekcích.

**A. Platba daru (peněžní uzel).**
```
Customer --sync--> C4 Payment-Processing ..external..> ComGate | Netopia | MAIB           (UC0005; adaptéry SRV0008)
ComGate ~~webhook~~> C4 ComGate-Adapter --sync--> C4 Payment-Processing                    (UC0006; ⚠ callback fakticky veřejný, bez HMAC — HS12)
   C4 Transaction→PAID ~~event~~> vedlejší efekty C3/C4/C7/C8/C11 (vše synchronně, jedno uložení):  (HS03; INV01/03/07/08/10/21; FLW0003)
      ~~event~~> C3 Campaign  (přepočet vybrané částky; auto-dokončení, pokud vybraná částka ≥ cíl)    (INV01/INV03)
      ~~event~~> C4 Transaction (potomek) (rozdělení přeplatku → transparentní účet)           (INV07)
      ~~event~~> C4 RecurringTransaction (aktivace příznaku 0→1, idempotentní)                     (INV08)
      ~~event~~> C4 Voucher (povýšení na uhrazený)                                                (INV10)
      ~~event~~> C7 Party/User (přidělení role `supporter` při první úhradě PAID)                        (INV21)
      ~~event~~> C8 Messaging (poděkování) + C11 Ops (Slack)                                  (⚠ is-sync — HS13)
   C3 Campaign auto-dokončení ~~event~~> C1 Application (→ dokončeno)                          (INV03; bez obalení transakcí)
   C1/C3/C4 uložení entity ==search-index queue==> C10 Search (Elasticsearch)                   (UC0018; skutečně asynchronní)
```

**B. Změna stavu žádosti (orchestrační šev).**
```
Admin --sync--> C1 Application-Lifecycle (nastavení stavu; bez kontroly legality u 2 ze 3 formulářů)      (UC0002; HS02)
   C1 uložení Application ~~event~~> Application-Status-Orchestrator → 3 odběratelé (SYNC):    (SRV0002; HS01; FLW0001/0002)
      ~~event~~> C2 Scoring-&-Risk   (při `to_check`: přepočet low-risk skóre, přímý update)   (INV16; UC0002.2)
      ~~event~~> C1 ApplicationReaction (zpráva v zóně / tlačítka / vytvoření relace / deaktivace) (INV14; EN0026)
      ~~event~~> C8 Transactional-Messaging-Orchestrator (notifikace)                      (UC0012; ⚠ is-sync — HS13)
         └─ (vnořeno v odběrateli notifikace) C6 Document-Generation: vytvoření smlouvy + ApplicationSession       (INV11; UC0004)
   C1 uložení Application ~~event~~> C3 Campaign (sesouhlasení stavu/kategorie daru; desynchronizace →       (INV04; ⚠ pouze upozornění,
      Slack/Telegram alert, NEOPRAVENO)                                                       neopraveno)
   C1 uložení Application ==search-index queue==> C10 Search                                     (UC0018; asynchronní)
```

---

## (a) Synchronní volání

Volání v rámci requestu, ve stejném vlákně (a efektivně synchronní fan-outy při uložení entity). Směr odpovídá
povoleným směrům závislostí v [SRV-architecture-map §3].

**Kontext → externí systém (adaptér, odchozí):**
```
C4 Payment-Processing        --sync--> ..external..> ComGate (CZ) | Netopia (RO) | MAIB (MD)   (UC0005; SRV0008)
C2 Scoring-&-Risk            --sync--> ..external..> MVČR doklady  (kontrola identity/dokladu)    (UC0003; SRV0004)
C2 Scoring-&-Risk (AJAX)     --sync--> ..external..> ARES  (obchodní rejstřík; ⚠ bez timeoutu)    (UC0003; SRV0004; HS-integrations)
C3 Campaign-&-Story          --sync--> ..external..> Nager.Date  (RO pracovní den pro deadline;      (FLW0021; ⚠ FAIL-OPEN —
                                                        ⚠ fail-open: API nedostupné ⇒ pravidlo obejito)      pravidlo tiše obejito)
C8 Messaging-Orchestrator    --sync--> ..external..> WhoisXMLAPI (validace e-mailové domény)      (UC0012; SRV0013)
C8 Messaging-Orchestrator    --sync--> ..external..> Mautic (transakční odeslání; fronta vypnuta) (UC0012; ⚠ is-sync — HS13)
```

**Kontext → kontext (v rámci requestu):**
```
C1 Application-Lifecycle     --sync--> C9 Identity-&-Access   (vytvoření User+Contact při odeslání) (UC0001; INV12)
C4 Payment-Processing        --sync--> C9 Identity-&-Access   (anonymní dárce → User+Contact)    (UC0006; INV12)
C4 Payment-Processing        --sync--> C3 Campaign-&-Story    (rozřešení/zacílení příběhu daru) (UC0005/UC0006; INV06)
C1 Application-Status-Orch.  --sync--> C2 Scoring-&-Risk       (dispatch odběrateli scoringu)    (UC0002; SRV0002)
C1 Application-Status-Orch.  --sync--> C6 Document-Generation  (vytvoření smlouvy ve stavu podpisu)  (UC0004; INV11)
C1 Application-Status-Orch.  --sync--> C8 Messaging-Orch.      (dispatch notifikace)             (UC0002/UC0012)
C6 Document-Generation       --sync--> C1 Application          (podpis řídí stav Application) (UC0004; INV11)
C2 Scoring-&-Risk            --sync--> C1 Application (`scoring_ok`) + C7 Party/Contact (klasifikace) (UC0003; INV15; ⚠ přímý update podle e-mailu, bez LIMIT — HS08)
C3 Campaign publish          --sync--> C1 Application (→ active)  (dva agregáty, ⚠ bez obalení transakcí)   (UC0011; INV13)
```

> **Klíčové synchronní riziko:** platební „peněžní uzel“ (řetězec A) a orchestrátor stavů (řetězec B) jsou dva
> největší synchronní fan-outy. Oba běží uvnitř jednoho uložení entity z každé zápisové cesty bez obalení
> transakcí a bez idempotence — **HS01, HS03**. `[recommendation]` povýšit na transakční příkazy + oddělené
> události (CONSISTENCY-boundaries §4, body 1–2).

---

## (b) Hranice asynchronních front

Skutečně mimopořadové (out-of-band) cesty (worker fronty nebo cron vyprazdňuje až po vyvolávajícím requestu).

```
C1/C3/C4/C7 uložení entity   ==search-index queue==> C10 SearchIndex-Processor --sync--> ..external..> Elasticsearch   (UC0018; skutečně asynchronní; tok index-sync zmapován FLW0032 — Confirmed; zbytkové Partial: pouze plánování vyprazdňování fronty, HS16)
C7 Party/User uložení        ==CRM-sync queue==>   C8 Mautic-CRM-Adapter      ..external..> Mautic (upsert kontaktu)   (UC0013/UC0015; FLW0019/FLW0020)
C4 RecurringTransaction      ..cron..> C4 RecurringPayment-Processor --sync--> ..external..> platební brána (zúčtování)         (UC0007; ⚠ optimistické PAID — HS04)
C5 (bankovní/gateway platby)    ..cron/CLI..> C5 Reconciliation-Processor: Moneta poll | IMAP import | ComGate transferSync
                                             --sync--> ..external..> Moneta | IMAP schránka | ComGate transfer-sync        (UC0008; ⚠ křehké/se ztrátami — HS05)
C5 Reporting-ReadModel       ..cron..> C5 CSV-Export-Processor ..> souborový systém /tmp   (⚠ globální, bez filtru na tenanta, PII v datovém úložišti — HS07)  (UC0017)
C6 (zdroj faktur)          ..CLI..>  C6 OneDrive-Graph-Adapter ..external..> MS Graph → přiložení k C1 Application     (UC0019; FLW0028)
C7 Organisation denně        ..cron..> C7/C10 → ..external..> Elasticsearch Cloud `organisations` (⚠ úplný re-push, bez kurzoru)  (UC0016/UC0018; FLW0024)
C11 naplánované publikování        ..cron..> C11 ScheduledPublish-Processor ~~event~~> CMS page/page_cz (publikace)  (UC0022; naplánované publikování zmapováno FLW0033 — Confirmed; ⚠ cílí na uzly CMS, nikoli na Application/Campaign, obchází bránu Workflow-Engine, přísná rovnost publish_date=dnes, HS16)
```

**Cesty fronty, které dnes NEJSOU skutečně asynchronní (⚠ looks-async / is-sync):**
```
C1/C4 (události stavu a peněz) ==mail queue==> C8 Email-Adapter     ⚠ FRONTA VYPNUTA — e-mail se odesílá SYNCHRONNĚ v rámci requestu; worker fronty je MRTVÝ KÓD (HS13; CONSISTENCY-boundaries §2)
```

---

## (c) Událostní (event-like) přechody / vedlejší efekty při uložení entity

Řetězce doménových událostí a vedlejších efektů při uložení. **Pokud není označeno `[async]`, je každý z nich
dnes synchronní v rámci requestu** (CONSISTENCY-boundaries §2, hlavní zjištění). Mechanismus a riziko jsou
uvedeny odkazem na INV/HS/FLW.

**Fan-out stavu žádosti (orchestrační šev) — SYNCHRONNÍ, při každém uložení:**
```
C1 uložení Application ~~event~~> Application-Status-Orchestrator (SRV0002) → 3 odběratelé:
   ~~event~~> C1 ApplicationReaction  (zpráva v zóně / tlačítka / vytvoření relace + hromadná deaktivace)  (INV14; EN0026; FLW0001)
   ~~event~~> C2 Scoring-&-Risk       (přepočet low-risk skóre při `to_check`, přímý update)          (INV16; FLW0002)
   ~~event~~> C8 Messaging            (notifikace)                                                (UC0012; ⚠ is-sync — HS13)
⚠ bez kontroly změny stavu, bez idempotence (opakovaný log/odeslání i při nezměněném re-save), bez izolace — HS01/HS02
```

**Transaction PAID „peněžní uzel“ — SYNCHRONNÍ kaskáda z každé zápisové cesty (callback / cron / import):**
```
C4 Transaction → PAID ~~event~~>
   ~~event~~> C3 Campaign      (přepočet vybrané částky; auto-dokončení, pokud vybraná částka ≥ cíl)   (INV01/INV03)
   ~~event~~> C4 Transaction (potomek) (rozdělení přeplatku → transparentní účet)               (INV07)
   ~~event~~> C4 Recurring     (aktivace 0→1)                                                (INV08, idempotentní)
   ~~event~~> C4 Voucher       (povýšení na uhrazený) + e-mail kupujícímu + Slack                          (INV10)
   ~~event~~> C7 Party/User    (přidělení role `supporter` při první úhradě PAID)                             (INV21)
   ~~event~~> C8 Messaging + C11 Ops (děkovný e-mail + Slack)                               (⚠ is-sync — HS13)
⚠ znovu-vstupující (re-entrant) vnořené uložení Campaign; bez idempotence callbacku; riziko rekurze / duplicitních záznamů — HS03
```

**Meziagregátové vazby životního cyklu (synchronní vedlejší efekty):**
```
C3 Campaign auto-dokončení / zrušení dokončení ~~event~~> C1 Application (→ dokončeno / `campaign_uncompleted`)   (INV03/INV05; FLW0022; ⚠ bez obalení transakcí)
C1 uložení Application                     ~~event~~> C3 Campaign (sesouhlasení stavu/kategorie daru)           (INV04; ⚠ desynchronizace → Slack/Telegram POUZE UPOZORNĚNÍ, neopraveno)
C6 kroky podpisu smlouvy                  ~~event~~> C1 Application (→ smlouva / waiting_signature / contract_signed)  (INV11; FLW0008)
C2 schválení scoringu                      ~~event~~> C1 Application (`scoring_ok`) + C7 Contact (klasifikace)  (INV15; ⚠ přímý update e-mailu bez LIMIT — HS08)
C7 dedup Contact / C1 sloučení leadů / C8 dedup Org ~~event~~> přepojení referencí + TVRDÉ SMAZÁNÍ duplikátu + vlastnícího Usera  (INV17/18/19; ⚠ bez transakce, bez dry-run — HS09)
C7 uložení anonymizovaného Usera                 ==CRM-sync queue==> C8 Mautic (znovu-upsert se zachovanými jmény)         (⚠ ANTI-ERASURE — HS06; FLW0020)
```

**Ops-alert / audit listener (C11):**
```
chyba/závažnost v libovolném kontextu ~~event~~> C11 Ops-Logging-Adapters ..external..> Slack (ERROR/CRITICAL) | Telegram   (UC0020; ops listener zmapován FLW0034 — Confirmed; ⚠ únik PII, sendMessageToZoneChannel() je no-op, synchronně blokující; dílčí tok ES auditu stále Partial, HS16)
libovolný request ~~event~~> C10/C11 ..external..> Elasticsearch (auditní záznam requestu/response)                       (integrations.md §4)
```

**Neaktivní (dormant) událostní cesta (`⟂ DORMANT`):**
```
C4 Transaction → PAID ⟂ DORMANT ~~event~~> C3 CampaignRecommendation-Processor ==queue==> C7 Account (ML predikce)
   ⚠ neaktivní z 5 důvodů (dispatch události zakomentován, modul není nainstalován, klasifikátor YAML zakomentován,
     ML knihovna chybí, pole úložiště zakomentováno) — INV27; HS14; UC0021; FLW0030.
   [recommendation] explicitně rozhodnout o zrušení nebo přebudování; NEPOVAŽOVAT za živé současné chování.
```

---

## Shrnutí pro čtenáře — co dnes skutečně překračuje reálnou hranici

- **Pouze tři cesty jsou skutečně asynchronní/oddělené:** indexace pro vyhledávání (`==search-index queue==>`;
  tento tok je nyní zmapován — FLW0032, Confirmed, zbytkové Partial pouze u plánování vyprazdňování fronty), fronta
  upsertu kontaktů do Mauticu a cron/CLI procesory (opakované platby, párování plateb,
  CSV export, import z OneDrive, naplánované publikování, denní indexace organizací).
- **Vše ostatní, co „vypadá jako“ událost, je synchronní v rámci requestu** — orchestrační šev stavů
  (HS01), peněžní uzel Transaction (HS03), sesouhlasení Application↔Campaign (INV04, pouze upozornění), vazba
  podpisu Contract→Application (INV11), klasifikace scoring→Contact (INV15/HS08), a dokonce i „zafrontovaná“
  transakční pošta (fronta vypnuta — HS13). Toto jsou hranice, které musí přepis učinit skutečně asynchronními
  (viz CONSISTENCY-boundaries §4).
- **Externí hranice** představuje 17 systémů z ARCH0001 §5; nejrizikovější jsou neautentizované platební
  callbacky (HS12), křehké nohy párování plateb (HS05) a fail-open kontrola pracovního dne přes Nager.Date.
- **Jedna neaktivní (dormant) cesta** (doporučení) je přítomna, ale neaktivní — jde o rozhodnutí zrušit nebo
  přebudovat, nikoli o současné chování.

---

### Poznámka k dohledatelnosti

Pouze syntéza. Každý řetězec odkazuje na kontext (C1..C11) / cílové SRV / název integrace a na identifikátor
INV/HS/UC/FLW z vrstev DOMAIN a SRV — pomocí id, bez opakování jejich vnitřních detailů a bez čtení zdrojového
kódu repozitáře. Neobjevují se žádné názvy souborů/tříd/metod, `.php`/`::` ani syrové tokeny tabulek/sloupců
jako tvrzení; jedinými doslovnými tokeny jsou doménový **slovník stavů**, pojmenované **integrace** a název
jednoho externího Elastic indexu. Míra jistoty je zachována
(`Confirmed` / `Partial` / `Hypothesis`); tato mapa popisuje **současný stav** a nezahrnuje cílový záměr z `it-zadani`.
Doplňující dokument: [ARCH0001_ApplicationOverview.md](ARCH0001_ApplicationOverview.md).
