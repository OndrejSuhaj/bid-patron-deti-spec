---
doc_id: FN0024
title: Campaign Recommendation (Dormant)
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0021
  - EN0004
  - EN0007
  - EN0008
  - EN0009
---

# FN0024 – Doporučování kampaní (neaktivní)

## Účel

Domnělá funkcionalita, která by se měla učit vzorce dárcovského chování jednotlivých Uživatelů z
jejich uhrazených Transakcí, trénovat prediktivní model pro každého Uživatele a ukládat
personalizovaný seřazený seznam doporučených Kampaní u Uživatele/Účtu. Tato funkcionalita je
v současném systému neaktivní z několika nezávislých důvodů a popisuje pouze rekonstruovaný
hypotetický kontrakt, nikoli živé současné chování.

## Odpovědnosti

- (Hypoteticky) Při uhrazené Transakci s identifikovatelným vlastníkem zařadit do fronty trénovací
  úlohu, která sestaví pozitivní/negativní příklady kampaní a předá je interní klasifikační službě
  pro vytvoření modelu pro daného Uživatele.
- (Hypoteticky) Ohodnotit kandidátní Kampaně natrénovaným modelem, seřadit je podle predikované
  preference a přepsat záznam seřazených doporučení u Uživatele/Účtu.
- (Hypoteticky) Podporovat administrativní příkazy pro opětovné natrénování všech modelů / přepočet
  všech skóre a plánovaný spouštěč přepočtu skóre jako alternativní vstupní body do téže
  trénovací/skórovací funkcionality.

## Související případy užití

UC0021 – Doporučování kampaní (NEAKTIVNÍ)

## Související entity

EN0009 – Transakce

EN0008 – Uživatel

EN0007 – Účet

EN0004 – Kampaň

## Integrace

Žádné. Trénování a skórování modelu je interní klasifikační funkcionalita, nikoli síťová integrace
s externím systémem — v souladu s přehledem integrací uvedeným v ARCH0002 (mapa kontextových
interakcí), který tuto funkcionalitu mezi externími integracemi platformy neuvádí.

## Omezení

- **Status: Neaktivní.** Funkcionalita je od začátku do konce nefunkční z pěti nezávislých důvodů:
  spouštěcí notifikace „Transaction updated" (aktualizace transakce) není nikdy skutečně vyvolána,
  odpovědný modul není nainstalován, klasifikační služba není nakonfigurována, podpůrná knihovna
  strojového učení chybí a úložiště pro výsledek seřazených doporučení neexistuje. Kterýkoli z
  těchto důvodů samostatně by postačoval k zablokování funkcionality.
- Popis v tomto dokumentu je pouze rekonstruovaný hypotetický kontrakt (podle UC0021 a jeho
  podkladových důkazů o toku), nikoli pozorovatelné současné chování.
- V případě opětovné aktivace by uložený natrénovaný model podléhal riziku deserializace při
  načtení a trénovací/skórovací logika nemá žádné rozlišení podle tenantů — reaktivovaná
  funkcionalita by počítala doporučení bez ohledu na hranice tenantů CZ/RO/MD.
- Toto je kanonické místo, na které ostatní vrstvy odkazují ve věci „doporučování kampaní" (FN0024),
  aniž by opakovaly tento status neaktivity.
