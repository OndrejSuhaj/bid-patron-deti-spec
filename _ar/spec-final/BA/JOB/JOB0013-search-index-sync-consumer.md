---
doc_id: JOB0013
title: Search Index Sync Consumer
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: async-consumer
references:
  - FN0022
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
  - ES0014
---

# JOB0013 – Konzument synchronizace vyhledávacího indexu

## Účel

Vyprazdňovat frontu indexování entit a pro každou změněnou entitu (uživatel, žádost, kampaň,
organizace, transakce) vytvořit a upsertovat jeden vyhledávací dokument do externího indexu App
Search. Jde o klíčovou asynchronní cestu FN0022 (Indexování a synchronizace vyhledávání).

Klasifikace: **Confirmed** (cesta fronty); **Partial** (plánování vyprazdňování — viz Model spouštění).

## Model spouštění

- Asynchronní konzument. Položky se zařazují do fronty z ukládacího handleru pěti indexovaných typů
  entit.
- **Vyprazdňování NENÍ automatické:** worker fronty nemá cron klíč a vlastní cron vyprazdňování tohoto
  modulu je **zakomentované**, takže si ho jádro Drupalu (core cron) nenárokuje. Vyprazdňování probíhá
  pouze tehdy, když operátor nebo externí scheduler vyvolá CLI příkaz pro vyprázdnění (viz JOB0022).
  Pokud nikdo vyprázdnění nespustí, fronta neomezeně roste a index zastarává.
- Evidence: zařazení do fronty přes sdílený pomocný helper pro přidání do fronty z pěti ukládacích
  handlerů entit; worker `patron_search/src/Plugin/QueueWorker/EsUploadQueue.php`
  (`id="es_upload_queue"`, bez cron klíče). Dossier: FLW0032.

## Rozsah vstupu

- Položky fronty nesou typ entity + id. Worker při vyprazdňování znovu načte **živou** entitu (indexuje
  aktuální stav, nikoli stav v okamžiku zařazení do fronty). Max. 500 položek na jedno vyvolání
  vyprázdnění, doba zámku (claim lease) 1 hodina na položku. Viz EN0001, EN0004, EN0009, EN0018, EN0008.

## Pravidla zpracování

- Pro každou položku: dispatch podle typu entity na odpovídající builder dokumentu; připojení
  společných polí (kompozitní id, typ, popisek, odkazy, časová razítka); odstranění prázdných polí;
  upsert jednoho dokumentu do externího indexu App Search přes odchozí POST; throttling 1sekundovým
  spánkem na dokument.

## Vedlejší účinky

- Jeden vyhledávací dokument upsertován pro každou zpracovanou entitu do indexu App Search (ES0014).
  Žádná lokální mutace entity (čisté čtení + odchozí POST).
- **Únik osobních údajů (právní/GDPR riziko):** dokumenty žádostí odesílají rodná čísla, e-maily,
  telefony a jména dárce a dítěte do externího indexu bez jakéhokoli maskování. Všichni tenanti se
  míchají v jednom společném indexu. `Confirmed`.
- Telegram alert pro provoz při chybě odeslání (FN0023).

## Idempotence

- Upsert je klíčován kompozitním id entity, takže opakované zpracování přepisuje stejný dokument
  (externě idempotentní). Ochrana proti duplicitám na straně zařazování do fronty sloučí opakovaná
  uložení do jedné čekající položky (ale jeho porovnávání podřetězcem může potlačit legitimní zařazení
  do fronty — viz Zpracování chyb).

## Zpracování chyb

- Při chybě jednotlivého dokumentu je položka **uvolněna** (lze opakovat) a je vyvolán alert; trvalé
  chyby dokumentu se opakují do nekonečna. Chybějící přístupové údaje k indexu → worker vyhodí výjimku
  a položka se opakuje do nekonečna bez jakéhokoli pokroku.
- **Tichá mezera v indexu:** tvrdá síťová chyba vrátí prázdnou parsovanou odpověď, chybová smyčka
  neprojde žádnou iterací, položka je vyhodnocena jako úspěšná a **smazána**, přestože nic nebylo
  zaindexováno.
- **Bez mazání z indexu:** smazané entity zanechávají osiřelé dokumenty (osobní údaje přetrvávají i po
  smazání entity).
- Kolize na základě porovnání podřetězcem v ochraně proti duplicitám může zahodit legitimní aktualizaci
  indexu. Všechna zdokumentovaná rizika současného stavu (FLW0032).

## Reference

- FN: FN0022, FN0023
- UC: UC0018, UC0016
- EN: EN0001, EN0004, EN0009, EN0018, EN0008
- ES: ES0014
- Evidence: FLW0032

## Otevřené body

- Zda externí scheduler skutečně vyvolává CLI příkaz pro vyprázdnění, **není podloženo ve zdrojích**
  (`Hypothesis`); vlastní cron vyprazdňování modulu je zakomentované. Toto je zbývající Partial pro
  FN0022. Viz JOB0022 pro příkazy vyprázdnění / úplného přeindexování.
