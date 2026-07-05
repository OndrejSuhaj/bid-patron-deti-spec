---
doc_id: FN0009
title: Contract Generation & E-Signature
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0004
  - EN0011
  - EN0012
  - EN0001
  - EN0002
  - FN0002
  - FN0019
  - BR-ContractAndESignature
---

# FN0009 – Generování smlouvy a elektronický podpis

## Účel

Vygenerovat právně závazný dokument smlouvy pro žádost z opakovaně použitelné šablony, provést jej
interní kontrolou/podpisem manažera a získat elektronický podpis fundraisera formou vypsaného jména —
výsledkem je podepsané PDF, protokol o převzetí a dokument potvrzující podpis, které podmiňují posun
případu k jeho aktivnímu příběhu. Jde o schopnost C6 pro dokumenty a podpis, kterou využívá UC0004.

## Odpovědnosti

- Vytvořit smlouvu ze zvoleného typu smlouvy, přiřadit jí čitelné číslo smlouvy podle pravidla
  číslování smluv (BR-ContractAndESignature), dosadit data ze žádosti/profilu žádosti do odpovídající
  šablony smlouvy a vykreslit ji do PDF.
- Provést smlouvu krokem kontroly manažerem (notifikace kontrolující osobě) a při zapnutém digitálním
  podpisu vtisknout do dokumentu obrázek podpisu manažera a datum.
- Nabídnout fundraiserovi relaci podpisu v jeho zóně, ověřit vypsané jméno oproti registrovanému jménu
  fundraisera, zaznamenat elektronický podpis a vygenerovat PDF potvrzující podpis nesoucí ověřovací
  kód/QR kód.
- Podporovat starší nedigitální předání (odeslání vykresleného PDF notifikací namísto vtištění podpisu)
  a variantu nájemní smlouvy s předem podepsanou nájemní smlouvou.
- Posouvat stav vlastnící žádosti v jednotlivých krocích při každém milníku podepisování prostřednictvím
  FN0002.

## Související případy užití

UC0004 – Správa smlouvy a podpisu (primární).

## Související entity

EN0011 – Smlouva (vygenerovaný, podepsaný dokument produkovaný touto schopností).
EN0012 – Šablona smlouvy (zdrojová šablona vykreslená do obsahu smlouvy).
EN0001 – Žádost (agregát, jehož stav je posunut při každém milníku podepisování).
EN0002 – Profil žádosti (zdroj dat fundraisera/patrona/daru dosazovaných do smlouvy).

## Integrace

Žádné — vykreslování dokumentu je interní odpovědností systému; odchozí doručování notifikací
(oznámení o kontrole manažerem, starší předání PDF fundraiserovi) zajišťuje schopnost transakčního
zasílání zpráv (FN0019). Krajinu integrací viz ARCH0002_ContextInteractionMap; podle současných
podkladů není v rámci této schopnosti přímo volán žádný externí systém.

## Omezení

- Notifikace o kontrole manažerem se přeskočí — přestože stav žádosti se přesto posune — pokud není
  k dispozici kontrolující osoba nebo vykreslené PDF, což vytváří tichou mezeru vyžadující ruční
  dohledání.
- UI pro vytvoření smlouvy je omezeno podle země: některé nájemce (tenanti) nemají formulář pro
  vytvoření smlouvy ve své zóně a alternativní postup pro tyto nájemce není z podkladů zjištěn
  (Partial).
- Přechody stavů napříč řetězcem podepisování (razítko manažera, předání, podpis fundraisera) nejsou
  obaleny do jedné transakce, takže při selhání kroku uprostřed sekvence je možné částečné dokončení.
