---
doc_id: BR-VoucherPolicy
title: Voucher (Dobrošek) Policy
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0013
  - EN0009
  - EN0004
  - SYSTEM
references:
  - EN0013
  - EN0009
  - EN0004
  - UC0009
  - UC0006
---

# BR – Zásady dárkového poukazu (Dobrošek)

## Účel

Upravuje dárkový poukaz (EN0013) napříč jeho dvěma provázanými dimenzemi stavu — uhrazeno a uplatněno —
včetně jednorázového uplatnění, přeřazení nákupního daru na jediného příjemce a current-state rizik
souvisejících s neunikátností kódu a souběhem (race condition) při uplatnění.

---

## Dimenze uhrazení

- Dárkový poukaz SMÍ přejít do stavu uhrazeno/připraveno k použití pouze tehdy, když jeho nákupní
  transakce (EN0009) dosáhne stavu PAID.
- Vlastník dárkového poukazu SE ODVOZUJE od jeho nákupní transakce (EN0009) a NESMÍ být ukládán
  nezávisle na této transakci.

---

## Uplatnění (jednorázové, jediný příjemce)

- Dárkový poukaz SMÍ být uplatněn pouze tehdy, když je již uhrazen a dosud nebyl uplatněn.
- Při uplatnění SE dárkový poukaz naváže na přesně jeden cílový příběh (EN0004), označí se jako
  uplatněný a opatří se časovým razítkem uplatnění.
- Při uplatnění SE nákupní transakce (EN0009) přeřadí na cílový příběh (EN0004), takže darovaná částka
  je připsána příběhu, který si příjemce zvolil.
- Validace dárkového poukazu i jeho uplatnění OBĚ VYŽADUJÍ, aby byl dárkový poukaz ve stavu uhrazeno
  a dosud neuplatněno; dárkový poukaz, který je neuhrazený nebo již uplatněný, NESMÍ být validován jako
  použitelný ani opětovně uplatněn.

---

## Current-state rizika unikátnosti a souběhu

- Current-state: u kódu dárkového poukazu SE NESMÍ předpokládat unikátnost na úrovni dat; systém
  aktuálně unikátnost kódu dárkového poukazu nevynucuje (current-state gap). Uplatnění podle kódu se
  při kolizi kódů může vztáhnout na libovolný odpovídající dárkový poukaz.
- Current-state: u kontroly „dosud neuplatněno“ a aktualizace při uplatnění SE NESMÍ předpokládat, že
  jsou provedeny jako jediná chráněná operace; systém mezi nimi aktuálně nevynucuje vzájemné vyloučení
  (current-state gap). Dva téměř současné požadavky na uplatnění téhož dárkového poukazu mohou oba
  projít kontrolou „dosud neuplatněno“ dříve, než je uložena kterákoli z aktualizací, což vede
  k dvojímu uplatnění.
- Current-state: u validace a uplatnění dárkového poukazu SE NESMÍ předpokládat vyžadování
  autentizace ani omezení frekvence požadavků (rate limiting); systém aktuálně ani jednu z těchto
  kontrol nevynucuje (current-state gap).

---

## Co není cílem

- Toto pravidlo nedefinuje perzistované atributy dárkového poukazu, typy polí ani podobu uložení —
  viz EN0013.
- Toto pravidlo nedefinuje krokový průběh požadavku na validaci/uplatnění — viz UC0009.
- Toto pravidlo nedefinuje mechaniku přechodu do stavu PAID na platební straně nákupní transakce —
  viz BR-PaymentAndMoneyIntegrity (vlastní kaskádu PAID) a UC0006.
- Toto pravidlo nedefinuje obsah ani podmínky odesílání zpráv potvrzujících nákup nebo uplatnění —
  viz BR-TransactionalMessaging.
