---
doc_id: FN0007
title: Donation & Payment Processing (Money Hub)
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0005
  - UC0006
  - UC0007
  - UC0008
  - UC0009
  - UC0010
  - EN0009
  - EN0004
  - EN0013
  - EN0010
  - EN0008
  - BR-PaymentAndMoneyIntegrity
---

# FN0007 – Zpracování darů a plateb (Money Hub)

## Účel

Vlastnit záznam daru/platby (Transakce, EN0009) a vše, co se odehraje ve chvíli, kdy dosáhne stavu
PAID — doménový uzel pro peníze (money hub). Zakládá platby, zaznamenává stav potvrzený platební
bránou a spouští kaskádu peněžních vedlejších efektů (přepočet kampaně, rozdělení přeplatku,
promoce trvalého daru/dárkového poukazu, přidělení role, potvrzovací zpráva, indexace), která
následuje na každé cestě, jež může přivést Transakci do stavu PAID — online checkout, callback
platební brány, opakovaná platba, párování plateb s bankou/platební bránou a nákup/uplatnění
dárkového poukazu.

## Odpovědnosti

- Vytvořit Transakci (EN0009) při zahájení daru/platby a nést korelační identifikátor platební
  brány, přičemž samotné volání dodavatele deleguje na FN0008.
- Zaznamenat potvrzený externí platební stav (PENDING / AUTHORIZED / PAID / CANCELLED / REFUNDED)
  a poplatek platební brány, přičemž cílovou Transakci dohledává z dat callbacku/návratu.
- Při prvním přechodu do stavu PAID: přepočítat vybranou celkovou částku cílové Kampaně (EN0004)
  a spustit její dokončení (FN0006); rozdělit přeplatek do dceřiné Transakce vůči transparentnímu
  účtu; promovat navázaný Dárkový poukaz (FN0011) a Trvalý dar (RecurringTransaction, EN0010);
  přidělit vlastníkovi roli podporovatele (FN0018); a spustit poděkovací potvrzení (FN0019).
- Rozdělit přeplatek do dceřiné Transakce na transparentním účtu podle pravidla pro rozdělení
  přeplatku (BR-PaymentAndMoneyIntegrity), bez ohledu na cestu potvrzení.
- Sloužit jako sdílený vstupní bod do stavu PAID jak pro Transakce vzniklé párováním plateb
  (import z banky/AISP a párování vypořádání platební brány, FN0012), tak pro Transakce z opakované
  platby (FN0010) i Transakce z nákupu dárkového poukazu (FN0011) — každá cesta, která potvrzuje
  přijetí peněz, se sbíhá do stejné kaskády přepočtu/rozdělení/promoce.
- Přeřadit nákupní Transakci na nový cílový Kampaň, když je uplatněn s ní svázaný Dárkový poukaz
  (EN0013), tak aby celková částka daru byla přiřazena Kampani, kterou si příjemce skutečně zvolil.
- Sloužit jako zdroj pouze pro čtení celkových uhrazených darů dárce za daný rok, který je
  využíván při vystavování potvrzení o daru (daňových), aniž by tento dokument sám vytvářel.

## Související případy užití

UC0005 (Zadat dar — zakládá Transakci), UC0006 (Potvrdit platbu — přistává zde callback platební
brány), UC0007 (Zpracovat opakovanou platbu — přistávají zde dceřiné platby), UC0008 (Párovat
bankovní transakce — přistávají zde Transakce z párování s bankou/platební bránou), UC0009
(Uplatnit/ověřit dárkový poukaz — při uplatnění přeřazuje nákupní Transakci), UC0010 (Vystavit
potvrzení o daru — čte odtud celkové uhrazené dary).

## Související entity

EN0009 Transakce (kořen této kapacity), EN0004 Kampaň (cíl financování, přepočítávaný při přechodu
do PAID), EN0013 Dárkový poukaz (promován při PAID, přeřazuje Transakci při uplatnění), EN0010
Trvalý dar (RecurringTransaction) (promován/aktivován při PAID), EN0008 Uživatel (vlastník, kterému
je při PAID přidělena role podporovatele).

## Integrace

Žádné přímo — hranice dodavatelských platebních bran (ComGate, Netopia/MobilPay, MAIB) jsou
izolovány ve FN0008; hranice banky/AISP a poštovní schránky používané pro párování plateb jsou
izolovány ve FN0012. Konsolidovaný přehled integrací viz ARCH0002.

## Omezení

- Kaskáda spouštěná při PAID běží synchronně uvnitř ukládání entity z každé zapisující cesty,
  netransakčně a reentrantně (vnořené ukládání kampaně); nemá žádnou idempotenci callbacku, takže
  opakovaná oznámení platební brány znovu přepočítávají celkové částky Kampaně a znovu zařazují
  indexaci pro vyhledávání do fronty, místo aby byla ošetřena jako no-op.
- Jedinečnost identity platby je zajištěna pouze na úrovni aplikace — na záznamu Transakce neexistuje
  žádný databázový klíč ani idempotenční klíč, na který se přitom spoléhají jak cesta párování
  plateb, tak cesta callbacku platební brány při hledání shody.
- Jedinečnost kódu dárkového poukazu není vynucena na úrovni dat, takže přeřazení Transakce
  vyvolané dárkovým poukazem (UC0009) se při kolizi kódů může navázat na libovolný odpovídající
  záznam Dárkového poukazu; možný je i souběžný race condition při uplatnění, protože kontrola
  „ještě neuplatněno" a aktualizace nejsou ošetřeny společně jedním zámkem — obojí jsou
  zaznamenaná rizika, nikoli zamýšlené chování.
- Neaktivní (dormantní) událost změny stavu Transakce, která by jinak řídila doporučování kampaní
  (FN0024), je vypnutá — kaskáda popsaná v tomto dokumentu probíhá pouze přes přímou cestu při
  ukládání, nikdy přes odběr událostí (event subscription).
