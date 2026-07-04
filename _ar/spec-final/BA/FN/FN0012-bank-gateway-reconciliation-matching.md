---
doc_id: FN0012
title: Bank & Gateway Reconciliation / Matching
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0008
  - EN0009
  - EN0029
  - EN0030
  - EN0004
---

# FN0012 – Párování plateb s bankou a platební bránou / Matching

## Účel

Udržovat záznamy Transakce (EN0009) v souladu se skutečným vypořádáním u banky / platební brány:
importovat bankovní připsané platby, které nebyly iniciovány přes online platební tok, a označovat
platby iniciované platební bránou jako potvrzeně vypořádané na bankovní účet, aby součty Kampaně
(EN0004) a potvrzení pro dárce odrážely skutečně přijaté peníze. Sdružuje tři zdrojové adaptéry
párování plateb platné pouze pro CZ — dotazování na API transparentního účtu banky, import poštovní
schránky s bankovními avízy a synchronizaci seznamu převodů platební brány — do jedné schopnosti
párování/vypořádání plateb, odlišné od zpracování potvrzení platební brány, které náleží FN0008, a
od uzlu peněžních vedlejších efektů, který náleží FN0007.

---

## Odpovědnosti

Tato schopnost odpovídá za:

- Dotazování na API transparentního účtu CZ banky (Moneta AISP) v denní kadenci ohledně
  příchozích plateb, párování každé platby s existujícími Transakcemi podle bankovní reference a
  vytváření nových uhrazených Transakcí přiřazených k transparentní sběrné Kampani platformy pro
  dosud neevidované platby.
- Import e-mailů s bankovním avízem o platbě (aviz) z klientské poštovní schránky, parsování
  detailů platby z těla zprávy a jejich normalizaci do stejného interního formátu párování, jaký se
  používá jinde v této schopnosti.
- Rozlišování každého normalizovaného řádku bankovního avíza mezi shodou vypořádání platební brány
  (aktualizace existující Transakce jako vypořádané bankou) a novým darem typu banka-banka
  (vytvoření nové Transakce), a zaznamenání jednoho auditního záznamu (EN0029, BankTransactionMail)
  na každou zpracovanou zprávu bez ohledu na výsledek.
- Synchronizaci seznamu převodů/vypořádání platební brány (ComGate): párování podle identifikátoru
  transakce platební brány a nastavení variabilního symbolu a příznaku vypořádání bankou na
  existujících Transakcích, omezené stropem počtu shod na jeden běh.
- Identifikaci platícího dárce u nově spárované platby — na základě dřívější Transakce ze stejného
  zdrojového účtu, nebo pomocí e-mailového markeru přítomného v avízu — aby vytvořená Transakce
  mohla nést vlastníka.
- Přepočet vybrané částky dotčené Kampaně pokaždé, když je touto schopností vytvořena nebo spárována
  Transakce, a předání každé výsledné uhrazené Transakce peněžnímu uzlu (FN0007) k jeho sdíleným
  navazujícím vedlejším efektům.
- Vynucování ochran běhu pro jednotlivé zdroje (idempotentní denní import, gating pouze pro
  produkci/CZ), aby žádný zdroj nebyl v rámci vlastní kadence běhu zpracován dvakrát.

---

## Související případy užití

UC0008 – Párování bankovních transakcí

---

## Související entity

EN0009 – Transakce
EN0029 – BankTransactionMail
EN0030 – ComgateBankReconciliation
EN0004 – Kampaň

---

## Integrace

- Moneta — CZ banka s transparentním účtem, API pro informace o účtu (AISP) dotazované ohledně
  příchozích plateb.
- Poštovní schránka s bankovními avízy klienta — IMAP schránka obsahující e-maily s avízem o platbě
  ("aviz").
- ComGate — CZ platební brána, API seznamu převodů / detailu převodu pro vypořádání, používané k
  potvrzení, které platby přes platební bránu byly vypořádány na bankovní účet.

Uvedeno podle integračního prostředí C5 (Finance & Reconciliation) z ARCH0002_ContextInteractionMap
a zdrojových adaptérů párování plateb zaznamenaných v SRV-target-list.md; pro tyto hranice zatím
neexistují žádné artefakty vrstvy ES.

---

## Omezení

- Pouze CZ: žádný ze tří zdrojů párování plateb neběží pro RO/MD.
- Denní zdroj Moneta si značku posledního běhu ukládá před stažením dat a vždy dotazuje "včerejšek";
  neúspěšný běh se neopakuje a platby z vynechaného dne jsou tiše přeskočeny (zaznamenaná mezera,
  nikoli opravené chování).
- Bankovní platba v jiné než očekávané měně zastaví zbytek daného denního dávkového zpracování
  Moneta, místo aby byla izolovaně přeskočena.
- Parsování bankovního avíza závisí na pevném rozvržení zprávy; při odchylce šablony může přesto
  vytvořit Transakci nebo auditní záznam z neúplných/prázdných polí, místo aby zprávu odmítlo
  (riziko křehkého parsování).
- Synchronizace převodů ComGate omezuje stropem počet řádků Transakcí aktualizovaných za jeden běh;
  vypořádání rozdělené na více řádků, než je tento strop, ponechá zbytek neoznačený až do dalšího
  běhu (částečné vypořádání).
- Nespárovaný kandidát na vypořádání ComGate nalezený přes zdroj bankovních avíz zůstává neoznačený
  jako přečtený pro opakovaný pokus pouze prostřednictvím dalšího běhu téhož zdroje — zdroj
  synchronizace převodů ComGate sám opakování neprovádí.
- Každá Transakce vytvořená nebo aktualizovaná touto schopností vstupuje do celého netransakčního
  řetězce vedlejších efektů peněžního uzlu (FN0007) — přepočet kampaně, rozdělení přeplatku,
  notifikace, indexování — se stejným nedostatkem atomicity jako u jakéhokoli jiného zápisu
  Transakce.
- Automatické (cron) plánování zdroje synchronizace převodů ComGate je Hypothesis — jeho
  manuální/CLI spuštění je Confirmed, dle poznámky o úrovni evidence v UC0008.
