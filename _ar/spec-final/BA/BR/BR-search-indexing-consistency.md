---
doc_id: BR-SearchIndexingConsistency
title: Search Indexing Consistency
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
  - SYSTEM
references:
  - EN0001
  - EN0004
  - EN0009
  - EN0018
  - EN0008
  - UC0018
---

# BR – Konzistence indexace pro vyhledávání

## Účel

Upravuje, jak se změny prohledávatelných entit promítají do externího vyhledávacího indexu,
zajištění opakování při selhání této propagace a současné chování s úplným opětovným odesláním
(full re-push) organizačního indexu (UC0018).

---

## Propagace a opakování

- Vytvořená nebo změněná prohledávatelná entita (Žádost `EN0001`, Campaign `EN0004`, Transakce
  `EN0009`, Organizace `EN0018`, User `EN0008`) MUSÍ být zařazena do fronty pro indexaci vyhledávání
  jako vedlejší efekt uložení.
- Dokument vyhledávacího indexu pro entitu ve frontě MUSÍ být sestaven z aktuálních dat dané entity
  v okamžiku, kdy periodická indexační úloha frontu vyprazdňuje.
- Entita, jejíž indexační volání selže, MUSÍ zůstat ve frontě, nebo MUSÍ být do fronty zařazena
  znovu, aby byla indexace opakována při některém z pozdějších běhů.
- Indexace pro vyhledávání MUSÍ být považována za asynchronní, eventuálně konzistentní cestu:
  vyhledávací index SE MŮŽE opožďovat za primárním úložištěm a primární data entity NESMÍ být
  ovlivněna výsledky indexace (úspěchem ani selháním).

---

## Organizační index (současný stav)

- Registr organizací (`EN0018`) MUSÍ být odesílán do samostatného, dedikovaného vyhledávacího
  indexu organizací podle nezávislého plánu odděleného od hlavní fronty pro indexaci vyhledávání.
- Současný stav: běh organizačního indexu představuje úplné opětovné odeslání (full re-push) celého
  registru bez inkrementálního kurzoru — v současnosti se NEPROPAGUJE pouze změněná podmnožina
  (mezera v současném stavu).
- Současný stav: hlavní tok synchronizace vyhledávacího indexu nad rámec zařazení do fronty při
  uložení a chování periodického vyprazdňování popsaného v `UC0018` je nyní zmapován (FLW0032) se
  zbytkovým stavem Partial pouze u plánování vyprazdňování (cron vyprazdňování modulu je
  zakomentován; vyprazdňování musí vyvolat externí scheduler); žádné další chování indexace na
  úrovni jednotlivých kroků se NESMÍ předpokládat.

---

## Co není cílem

Toto pravidlo nedefinuje schéma dokumentu vyhledávacího indexu, mechanismus úložiště indexační
fronty ani smlouvu request/response externí integrace vyhledávání. Neupravuje, které změny entit
spouštějí zařazení do fronty — toto spouštěcí chování patří use casům, které mění záznamy Žádosti,
Campaign, Transakce, Organizace a User. Toto pravidlo vlastní pouze propagaci indexace a záruky
konzistence samotné.
