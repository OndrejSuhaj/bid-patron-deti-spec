---
doc_id: BR-TransactionalMessaging
title: Transactional Messaging & Send-Gate
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0022
  - EN0001
  - SYSTEM
references:
  - EN0022
  - EN0001
  - EN0026
  - UC0012
  - UC0002
---

# BR – Transakční komunikace a brána odesílání (Send-Gate)

## Účel

Upravuje způsob, jakým jsou transakční zprávy propouštěny bránou odesílání, šablonovány, archivovány
a odesílány, včetně brány odesílání dle prostředí, rozlišení šablony podle země, ochran proti
opakovanému odeslání a současných mezer v podobě synchronního odesílání a nesledovaného doručení.

## Brána odesílání a rozlišení šablony

- Transakční zpráva SMÍ být odeslána pouze tehdy, pokud to umožňuje brána odesílání dle prostředí —
  v produkci, nebo příjemcům na interním seznamu povolených adres — jinak MUSÍ být potlačena.
- Zpráva MUSÍ rozlišit svou šablonu podle mapy šablon pro danou zemi; nerozlišitelný název šablony
  MUSÍ přerušit odeslání se zalogovanou chybou.
- Současný stav: pokud je šablona definována pouze pro jednu zemi, NESMÍ se předpokládat, že ostatní
  země danou zprávu odesílají (například potvrzení o daru pouze pro CZ).

## Archivace

- Zpráva MUSÍ být archivována za každého příjemce (EN0022) bez ohledu na to, zda byla odeslána,
  s výjimkou přerušeného pokusu kvůli nerozlišitelné šabloně, který NESMÍ vytvořit archivní záznam.
- Současný stav: na pole stavu doručení v archivu se NESMÍ spoléhat — nikdy se nezapisují, takže
  potlačené odeslání je nerozlišitelné od doručeného.

## Ochrany proti opakovanému odeslání (současný stav)

- Poděkování za uhrazený dar MUSÍ být odesláno nejvýše jednou za dar.
- Současný stav: notifikace o nedokončení do termínu nemá žádnou ochranu proti opakovanému odeslání
  a MUSÍ být považována za rizikovou z hlediska opětovného odeslání.

## Provázanost odesílání (současný stav)

- Současný stav: odesílání zpráv je synchronní v rámci požadavku nebo uložení volajícího (fronta je
  vypnutá), takže pomalý nebo selhávající přenos může zablokovat nebo přerušit navazující operaci
  perzistence, a neexistuje žádné opakování pokusu (retry).

## Co není cílem

Toto pravidlo nedefinuje jednotlivé spouštěče, příjemce ani obsah jednotlivých zpráv (ty vlastní
samostatně vrstva MSG — viz katalog MSG, např. MSG0019 pro poděkování za uhrazený dar a MSG0015 pro
notifikaci o nedokončení do termínu), životní cyklus stavu Žádosti (EN0001) nebo kampaně/příběhu,
který danou zprávu vyvolává (viz BR-ApplicationStatusGovernance, BR-CampaignStoryLifecycle), ani
provozní/interní alerting (Slack/Telegram), který je mimo rozsah zde a vlastní jej
BR-OperationalAlerting.
