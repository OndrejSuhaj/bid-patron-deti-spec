---
doc_id: FN0022
title: Search Indexing & Synchronisation
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0018
  - UC0002
  - UC0011
  - UC0016
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
---

# FN0022 – Indexování a synchronizace vyhledávání

## Účel

Poskytovat funkci indexování pro vyhledávání využívanou v UC0018: při změně vyhledatelných entit se
jejich reprezentace propagují do externího vyhledávacího indexu, aby vyhledávací a fulltextové funkce
četly aktuální data namísto přímého čtení z primárního úložiště.

---

## Odpovědnosti

Tato funkce má na starosti:

- Detekci, že vyhledatelná entita byla vytvořena nebo změněna, a její zařazení do fronty pro
  indexování jako vedlejší efekt při uložení.
- Vyprazdňování indexovací fronty pomocí periodické úlohy, sestavení dokumentu vyhledávacího indexu
  z aktuálních dat entity a jeho upsert do externího vyhledávacího indexu.
- Ponechání entity ve frontě, případně její opětovné zařazení do fronty, pokud volání indexace selže,
  aby mohlo být zopakováno při dalším běhu.
- Podporu samostatného, nezávisle plánovaného úplného opětovného nahrání registru organizací do
  odděleného externího indexu organizací.

---

## Související případy užití

- UC0018 – Indexování entit pro vyhledávání
- UC0002 – Orchestrace změny stavu žádosti (spouštěč vedlejšího efektu indexování)
- UC0011 – Správa životního cyklu kampaně / příběhu (spouštěč vedlejšího efektu indexování)
- UC0016 – Správa záznamů subjektů (spouštěč vedlejšího efektu indexování)

---

## Související entity

- EN0001 – Žádost
- EN0004 – Kampaň
- EN0009 – Transakce
- EN0018 – Organizace
- EN0008 – Uživatel

---

## Integrace

- Elasticsearch / App Search — primární fulltextový vyhledávací index pro vyhledatelné entity
  (viz ARCH0002_ContextInteractionMap.md, C10 Search & Indexing).
- Samostatný, oddělený externí index organizací Elastic Cloud, aktualizovaný nezávislým denním
  úplným opětovným nahráním (viz ARCH0002_ContextInteractionMap.md).

---

## Omezení

- Základní tok synchronizace vyhledávacího indexu je nyní vytěžen (FLW0032, dříve index toku FL055) —
  Status: Confirmed pro cestu enqueue-on-postSave + worker-drain + App Search upsert. Zařazení do
  fronty (všech pět indexovaných typů entit) i vyprazdňování frontou pracovníka (claim → sestavení
  dokumentu → POST → smazání při úspěchu / uvolnění při selhání) je doloženo end-to-end.
- Zbytkový status Partial platí pouze pro **plánování vyprazdňování**: vlastní cron modulu pro
  vyprazdňování je zakomentovaný a pracovník fronty nemá žádný cron klíč, takže vyprazdňování závisí
  na externím plánovači, který příkaz pro vyprazdňování spouští (v kódu nedoloženo). Pokud jej nic
  nespouští, fronta neomezeně roste a index zastarává.
- Vedlejší efekt indexování je dále Confirmed, jelikož se objevuje v rámci dalších případů užití
  (UC0002, UC0011, UC0016).
- Rizika integrity dat / GDPR potvrzená pomocí FLW0032: chybí mazání z indexu při smazání entity
  (osiřelé dokumenty / přetrvávání osobních údajů po smazání); cesta tvrdého selhání cURL smaže
  položku fronty, jako by byla indexována (tichá mezera v indexu); dokumenty žádosti odesílají rodná
  čísla (`rc`) žadatele o dar a dítěte, e-maily, telefony a jména do externího SaaS indexu bez
  maskování na úrovni polí; ochrana proti duplicitám používá porovnání podřetězcem
  `LIKE '%{id}%'`, které může kolidovat napříč id/typy.
- Opětovné nahrání indexu organizací je úplné opětovné nahrání při každém naplánovaném běhu, bez
  inkrementálního kurzoru, a míří na oddělený pevně zakódovaný externí endpoint odlišný od hlavního
  vyhledávacího indexu.
- Jde o jednu z mála skutečně asynchronních, oddělených cest v rekonstruovaném systému (fronta +
  periodická úloha, namísto přímého synchronního zpracování).
