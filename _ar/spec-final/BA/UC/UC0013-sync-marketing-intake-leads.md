---
doc_id: UC0013
title: Sync Marketing & Intake Leads
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0013 — Synchronizace marketingových a intake leadů

## Záhlaví

| Pole | Hodnota |
|---|---|
| ID UC | UC0013 |
| Název | Synchronizace marketingových a intake leadů |
| Bounded Context | C8 |
| Primární aktér(ři) | Integration(Facebook), System |
| Typ spouštění | Webhook/Async |

## Aktéři a odpovědnosti

- **Integration(Facebook)** — externí platforma Meta/Facebook: zamýšlený zdroj příchozích webhook volání Lead Ads (dnes nefunkční); zároveň cíl odchozích relayů událostí přes Conversions API (CAPI).
- **Integration(Mautic)** — externí marketingový CRM systém; přijímá odchozí upsert kontaktů, aby marketingové kampaně mohly cílit na známé kontakty (EN0006).
- **Integration(GTM/Pixel)** — externí analytická/tag-management plocha přijímající signály o konverzích/událostech pro marketingovou atribuci.
- **System** — platforma Patronus: hostuje webhook endpoint a (na odchozí straně) sestavuje a odesílá payloady s kontakty/událostmi do marketingových a analytických integrací.

## Záměr

Udržovat marketingové a analytické nástroje Patronu v synchronizaci s aktivitou platformy: na odchozí straně odesílat známé kontakty (EN0006) a platební/dárcovské události (transakce, EN0009) do marketingového CRM (Mautic) a do Facebook Conversions API / analytických nástrojů pro cílení kampaní a atribuci. Na příchozí straně platforma vystavuje webhook určený k příjmu odeslaných formulářů Facebook Lead Ads jako nových leadů, avšak tato příchozí cesta je potvrzeně neimplementovaná.

## Předpoklady

- Webhook endpoint pro Facebook Lead Ads je na platformě nakonfigurován a povolen, přijímá jak volání pro ověření odběru (subscription-verification), tak volání pro doručení leadu (pouze příchozí dílčí tok).
- V Patronu existuje kontakt (EN0006) nebo transakce (EN0009) jako zdrojový záznam pro odchozí synchronizaci (odchozí dílčí toky).
- Přihlašovací údaje/konfigurace odchozí integrace pro Mautic a Facebook CAPI jsou zajištěny (doklady k této konfiguraci jsou pouze na úrovni indexu; nejsou hloubkově vytěženy).

## Hlavní tok

### UC0013.1 — Odchozí synchronizace kontaktu do Mautic CRM (částečné doklady)
1. System: detekuje změnu nebo událost u kontaktu (EN0006), která splňuje podmínky pro marketingovou synchronizaci.
2. System: sestaví payload pro upsert kontaktu ze záznamu kontaktu (EN0006).
3. Integration(Mautic): přijme upsert kontaktu a aktualizuje svůj vlastní záznam kontaktu.

### UC0013.2 — Odchozí relay konverzní události do Facebook CAPI (částečné doklady)
1. System: detekuje kvalifikující událost na transakci (EN0009), například dokončený dar.
2. System: sestaví payload konverzní události odkazující na transakci (EN0009).
3. Integration(Facebook): přijme přeposlanou konverzní událost přes Conversions API pro účely atribuce.

## Alternativní toky

### AF1 — Ověření odběru webhooku Facebook Lead Ads (dle pozorování)
1. Integration(Facebook): odešle na webhook endpoint Patronu požadavek na ověření odběru, obsahující ověřovací token a hodnotu challenge.
2. System: porovná dodaný ověřovací token s nakonfigurovaným tokenem.
3. System: pokud se token shoduje, vrátí Integration(Facebook) hodnotu challenge, čímž dokončí ověření odběru.
4. System: pokud se token neshoduje, odpoví, že token je neplatný.

Výsledek: Handshake ověření odběru webhooku buď uspěje, nebo selže; v obou případech nejsou čteny ani zapisovány žádné doménové entity.

### AF2 — Příchozí příjem leadu z Facebook Lead Ads — Status: Planned / Not Implemented
1. Integration(Facebook): odešle na webhook endpoint Patronu volání pro doručení leadu obsahující data odeslaného leadu.
2. System: odpoví, že token je neplatný, bez ohledu na obsah nebo platnost volání.

Výsledek: **Status: Planned / Not Implemented.** Ověření příchozího payloadu ve skutečnosti neprobíhá, nevzniká žádný kontakt (EN0006) ani žádost (EN0001) a nedochází k žádnému navazujícímu zpracování. Integration(Facebook) obdrží odpověď ve tvaru úspěchu (HTTP 200), zatímco lead je tiše zahozen — jde o potvrzenou mezeru v současném stavu, nikoli o navrženou cestu odmítnutí. Původně zamýšlené chování (ověřit token, přijmout lead, vytvořit žádost (EN0001) a/nebo kontakt (EN0006)) v běžícím systému dnes neexistuje.

## Následné podmínky

- Odchozí dílčí toky (UC0013.1, UC0013.2): marketingové CRM (Mautic) a/nebo nástroje Facebook CAPI/analytika drží aktualizovaný záznam odrážející kontakt (EN0006) nebo transakci (EN0009), která synchronizaci vyvolala; samotná synchronizace nezpůsobuje žádnou změnu stavu entit v Patronu.
- AF1: odběr webhooku je potvrzen jako aktivní (nebo je pokus o ověření odmítnut); nedochází ke změně stavu žádné entity.
- AF2: nevzniká ani se neaktualizuje žádná entita; data odeslaného leadu jsou ztracena; Integration(Facebook) není o selhání informován.

## Sledovatelnost (Traceability)

Cílové SRV:
- Mautic-CRM-Adapter
- FacebookCAPI-Adapter
- Analytics-Adapter (GTM/Pixel)

Entity EN:
- EN0006 Contact — předmět odchozí synchronizace do Mautic (UC0013.1); byl by entitou vytvořenou příchozím příjmem leadu, pokud by byl implementován (AF2)
- EN0009 Transaction — předmět odchozího relayu konverze do Facebook CAPI (UC0013.2)

Hranice integrací:
- Facebook (webhook Lead Ads příchozí — AF1/AF2; Conversions API odchozí — UC0013.2)
- Mautic (CRM odchozí — UC0013.1)
- GTM/Pixel (analytika odchozí — seskupeno s UC0013.2 pod cílové SRV Analytics-Adapter)

Doklady k tokům (Flow Evidence):
- FLW0029 (vytěžený dossier; webhook Facebook Lead Ads — potvrzuje chování AF1 při ověření odběru a stav neimplementováno u AF2)
- FL049 (nevytěžený záznam ve flow-indexu; upsert kontaktu do Mautic — základ pro UC0013.1)
- FL051 (nevytěžený záznam ve flow-indexu; relay Facebook CAPI — základ pro UC0013.2)

## Úroveň dokladů (Evidence Level)

Partial — AF1/AF2 jsou Confirmed vůči vytěženému dossieru FLW0029 (doménová klasifikace SRV0014; nejsou čteny ani zapisovány žádné entity); UC0013.1/UC0013.2 se opírají o nevytěžené, pouze indexové odkazy na toky (FL049, FL051) pro EN0006 (Contact), resp. EN0009 (Transaction), takže odchozí dílčí toky jsou uvedeny na úrovni, kterou index podporuje, a hlubší vnitřní kroky nejsou tvrzeny.
