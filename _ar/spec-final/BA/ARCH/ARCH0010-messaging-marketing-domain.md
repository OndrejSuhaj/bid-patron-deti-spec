---
doc_id: ARCH0010
title: Messaging & Marketing Domain
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - EN0022
  - UC0012
  - UC0013
  - UC0015
  - FN0015
  - FN0016
  - FN0019
  - ES0006
  - ES0007
  - ES0008
  - ES0009
  - MSG0005
  - MSG0006
  - BR-TransactionalMessaging
  - BR-DataProtectionAndErasure
  - BR-MarketingAndAnalyticsRelay
---

# ARCH0010 – Doména Messaging & Marketing

> Navigační dokument domény pro ohraničený kontext **C8 Messaging & Marketing** (ARCH0001 §4).
> Pouze navigační vrstva — odkazuje na hlubší artefakty pomocí `doc_id`, neopakuje jejich obsah. Current-state.

## Účel

Vysvětluje architektonický pohled na **transport transakčních zpráv a synchronizaci s
marketingem/CRM**: jak je každá zpráva určená uživateli (e-mail + notifikace v zóně) šablonována,
podléhá bráně (gate) a odeslána, a jak jsou data o straně (party) a konverzní signály
synchronizovány ven do marketingové/CRM platformy a analytických platforem. Jde o sdílený transport
stojící za zprávami, které spouštějí ostatní domény.

---

## Přehled systému

C8 hostí orchestrátor transakčních zpráv, který určí šablonu pro danou zemi, aplikuje bránu (gate)
podle prostředí a vždy archivuje záznam o odeslání bez ohledu na výsledek přenosu
([EN0022](../EN/EN0022_EmailArchive.md); [FN0019](../FN/FN0019_TransactionalMessaging.md)). Dva
architektonické rysy, které stojí za povšimnutí: fronta pošty (mail queue) je **vypnutá**, takže
všechna odesílání běží synchronně v rámci requestu / ukládání — pomalý nebo selhávající transport
může zablokovat nebo přerušit probíhající perzistenci
([ARCH0001](../ARCH0001_ApplicationOverview.md) §7; ARCH0002 §(b), HS13); a Mautic slouží zároveň
jako úložiště CRM kontaktů i jako skutečný transport pošty. Kontext dále předává konverzní/analytické
signály (pouze marketingové, bez dopadu na doménu) a nese **riziko GDPR anti-erasure** — fronta
CRM synchronizace znovu upsertuje anonymizovaného uživatele se zachovanými jmény (ARCH0001 §8 Risk 3).

Jednotlivé *kontrakty* zpráv (spouštěč, příjemci, záměr) žijí ve vrstvě **MSG**; tato doména vlastní
transport a domény vlastnící zprávy (C1–C6, C9) si každá navigují konkrétní MSG, které spouštějí.

---

## Strukturální komponenty

- **Transactional-Messaging-Orchestrator** (Orchestrátor) — určení šablony, brána pro odeslání
  (send-gate), archivace. Capability: [FN0019](../FN/FN0019_TransactionalMessaging.md).
- **Marketing / CRM adapter** (Integrační adaptér) — fronta upsertu kontaktů do Mautic + GDPR
  synchronizace. Capability: [FN0015](../FN/FN0015_MarketingCrmSync.md).
- **Conversion / analytics relay** (Integrační adaptéry) — Facebook (CAPI + Pixel + Lead Ads stub)
  a Google Tag Manager. Capability: [FN0016](../FN/FN0016_ConversionAnalyticsRelay.md).
- **Email-domain-check adapter** — validace přes WhoisXML zapojená do cesty zasílání zpráv (FN0019).
- **Žádný rezidentní transakční agregát** — EmailArchive ([EN0022](../EN/EN0022_EmailArchive.md)) je
  log jednotlivých odeslání, nikoli kořen agregátu (DOMAIN-aggregates §3).

---

## Interakční model

Podle [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(b)/(c):

- Volána **synchronně** téměř každou doménou k odeslání zpráv: stavový seam C1, platební hub C4,
  životní cyklus příběhu C3, dokumenty/daně C6, autentizace C9 — přes
  [UC0012](../UC/UC0012_DispatchTransactionalMessage.md) (ARCH0002 §(a), fronta pošty je vypnutá).
- Odchozí komunikace do **Mautic** pro transakční odeslání a přes frontu pro upsert CRM kontaktu
  ([ES0006](../ES/ES0006_Mautic.md); [UC0013](../UC/UC0013_SyncMarketingIntakeLeads.md);
  [UC0015](../UC/UC0015_AnonymizePersonalData.md); ARCH0002 §(b)/(c) — anti-erasure re-upsert).
- Odchozí konverzní/analytický relay do **Facebook** a **Google Tag Manager**
  ([ES0007](../ES/ES0007_Facebook.md), [ES0008](../ES/ES0008_GoogleTagManager.md)); příchozí
  webhook Facebook Lead Ads je potvrzený **neimplementovaný** stub (ARCH0001 §5, FN0016).
- Odchozí validace e-mailové domény do **WhoisXML** ([ES0009](../ES/ES0009_WhoisXmlApi.md)).
- Provozní alerting (Slack/Telegram) **není** transakční zasílání zpráv — vlastní jej C11
  ([ARCH0012](ARCH0012_PlatformSearchAndOperations.md)).

---

## Cross-links

- **relatedEN:** EN0022
- **relatedUC:** UC0012, UC0013, UC0015
- **relatedFN:** FN0015, FN0016, FN0019
- **relatedES:** ES0006 (Mautic), ES0007 (Facebook), ES0008 (Google Tag Manager), ES0009 (WhoisXML)
- **relatedMSG:** MSG0005, MSG0006 (skupinové stavové catch-all zprávy; C8 vlastní transport pro
  všech 30 MSG — každá zpráva s vyšší prioritou je navigována ze své spouštěcí domény, MSG-message-map)
- **relatedBR:** BR-TransactionalMessaging
  ([../BR/BR-TransactionalMessaging.md](../BR/BR-TransactionalMessaging.md)); pravidlo marketingové
  anti-erasure žije v BR-DataProtectionAndErasure; pravidla marketingové CRM synchronizace,
  konverzního/analytického relaye a příjmu inbound leadů vlastní BR-MarketingAndAnalyticsRelay.
