---
doc_id: UC0018
title: Index Entities for Search
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0018 — Indexace entit pro vyhledávání

## Header

| Field | Value |
|---|---|
| UC ID | UC0018 |
| Name | Index Entities for Search |
| Bounded Context | C10 |
| Primary Actor(s) | Systém, Scheduler |
| Trigger Type | Async/Cron |

## Actors & Responsibilities

- **Systém** — detekuje, že se prohledávatelná entita změnila, a zařadí ji do fronty k indexaci; sestavuje payload indexu pro entitu ve frontě.
- **Scheduler** — pravidelně spouští dávkovou úlohu, která vyprazdňuje indexační frontu.
- **Integrace (Elasticsearch)** — externí vyhledávací index, který ukládá a poskytuje indexované dokumenty entit.

## Intent

Udržovat externí vyhledávací index synchronizovaný s prohledávatelnými entitami platformy Patron (Žádost, Campaign, Transakce, Organizace, Uživatel) tak, aby funkce vyhledávání a vyhledávání záznamů mohly dotazovat aktuální data bez přímého dotazování primárního úložiště.

## Preconditions

- Existuje prohledávatelná entita (Žádost (EN0001), Campaign (EN0004), Transakce (EN0009), Organizace (EN0018) nebo Uživatel (EN0008)), která byla vytvořena nebo změněna.
- Integrace Elasticsearch/App Search je dostupná.
- Je nakonfigurována dávková indexační úloha (fronta a/nebo cron), která běží.

## Main Flow

### UC0018.1 — Zařazení entity do indexační fronty

1. Systém: Detekuje, že prohledávatelná entita (Žádost, Campaign, Transakce, Organizace nebo Uživatel) byla vytvořena nebo změněna.
2. Systém: Zařadí entitu do fronty pro indexaci ve vyhledávání.

### UC0018.2 — Zpracování indexační fronty

1. Scheduler: Spustí pravidelnou indexační úlohu.
2. Systém: Přečte další entitu z indexační fronty.
3. Systém: Sestaví dokument pro vyhledávací index z aktuálních dat entity.
4. Integrace (Elasticsearch): Uloží nebo aktualizuje dokument entity ve vyhledávacím indexu.
5. Systém: Po úspěšné indexaci odebere entitu z indexační fronty.

## Alternative Flows

### AF1 — Selhání indexačního volání

1. Integrace (Elasticsearch): Odmítne nebo se jí nepodaří zpracovat indexační požadavek.
2. Systém: Ponechá entitu ve frontě (případně ji do fronty zařadí znovu) pro pozdější pokus o indexaci.

Outcome: Entita zůstává neshodná s vyhledávacím indexem, dokud se nezdaří následující pokus o indexaci; primární data nejsou ovlivněna.

## Postconditions

- Vyhledávací index obsahuje aktuální dokument pro indexovanou entitu (při úspěchu).
- Indexační fronta již neobsahuje odkazy na úspěšně indexované entity.
- Primární data entit (Žádost, Campaign, Transakce, Organizace, Uživatel) zůstávají indexací nezměněna.

## Traceability

Target SRVs:
- SearchIndex-Processor
- Elasticsearch-Adapter

EN entities:
- EN0001 Žádost — prohledávatelný typ entity indexovaný pro vyhledávání
- EN0004 Campaign — prohledávatelný typ entity indexovaný pro vyhledávání
- EN0009 Transakce — prohledávatelný typ entity indexovaný pro vyhledávání
- EN0018 Organizace — prohledávatelný typ entity indexovaný pro vyhledávání
- EN0008 Uživatel — prohledávatelný typ entity indexovaný pro vyhledávání

Integration boundaries:
- Elasticsearch / App Search

Flow Evidence:
- FLW0032 (mined; was flow-index FL055) — Elasticsearch upload queue (`es_upload_queue`) entity indexing: enqueue-on-postSave from all five indexed entity types + `EsUploadQueue` worker drain → Elastic App Search `/documents`. Covers UC0018.1 (queue), UC0018.2 (drain/index), AF1 (failure → item released/retried).

## Evidence Level

Confirmed — synchronizační tok vyhledávacího indexu je nyní zmapován (FLW0032). Cesta zařazení do fronty (`postSave` entit Žádost, Campaign, Transakce, Organizace, Uživatel → fronta) a vyprazdňování fronty workerem (převzetí → sestavení dokumentu → POST do externího App Search indexu → smazání při úspěchu / uvolnění při selhání) jsou doloženy end-to-end. Zbytkový status Partial se týká pouze **plánování vyprazdňování fronty**: vlastní cron modulu pro vyprazdňování je zakomentovaný a worker nenese žádný cron klíč, takže vyprazdňování závisí na externím scheduleru, který příkaz pro vyprazdňování spouští (v kódu nedoloženo) — zaznamenáno jako current-state riziko asynchronnosti / zastarávání dat, nikoli jako vymyšlené chování. Další zjištěné nedostatky (chybí mazání z indexu → osiřelé dokumenty s osobními údaji; tvrdé selhání cURL tiše smaže položku fronty; osobní údaje včetně rodných čísel odesílány do externího SaaS indexu; ochrana proti deduplikaci na základě shody podřetězců) jsou current-state fakta převzatá z dossier, nikoli mezery v evidenci.
