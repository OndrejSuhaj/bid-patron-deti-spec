---
doc_id: BR-PaymentAndMoneyIntegrity
title: Payment & Money Integrity
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0009
  - EN0004
  - EN0008
  - SYSTEM
references:
  - EN0009
  - EN0004
  - EN0008
  - UC0005
  - UC0006
---

# BR – Integrita plateb a peněz

## Účel

Upravuje integritu peněžního záznamu (transakce, EN0009) a účinky dosažení stavu PAID platbou:
rozdělení přeplatku, jednorázové peněžní vedlejší efekty a současnou absenci idempotence a záruk
jedinečnosti plateb.

## Přípustnost a identita peněžního záznamu (současný stav)

- Systém MUSÍ odmítnout dar odeslaný vůči kampani (EN0004), jejíž průběžná vybraná částka již
  dosahuje nebo přesahuje cílovou částku.
- Současný stav: u Systému se NESMÍ předpokládat vynucení jedinečnosti na úrovni databáze pro
  identifikátor zprávy platební brány použitý k přiřazení callbacku k příslušné transakci (EN0009);
  tato kontrola identity je vynucována pouze na úrovni aplikace — jde o doloženou race podmínku při
  souběžných callbacích, nikoli o záruku přiřazení callbacku k transakci právě jednou. (Opakovaná
  nebo mimo pořadí přijatá potvrzení jinak konvergují ke stejné transakci — viz UC0006 AF2 — místo
  vytváření duplicitních záznamů.)

## Rozdělení přeplatku

- Pokud uhrazená transakce (EN0009) způsobí, že průběžná vybraná částka kampaně (EN0004) přesáhne
  cílovou částku, Systém MUSÍ rozdělit přebytek do dceřiné transakce zaúčtované na
  transparentní/sběrný účet, propojené s původní transakcí jako s nadřazenou, tak aby vybraná částka
  kampaně nepřesáhla cílovou částku.
- Dceřiná transakce vzniklá rozdělením přeplatku NESMÍ nést poplatek platební brány a MUSÍ být
  označena jako pohyb na transparentním účtu.

## Účinky prvního přechodu do stavu PAID

- Při prvním přechodu transakce (EN0009) do stavu PAID Systém MUSÍ: přepočítat financování cílové
  kampaně (EN0004), aktivovat navázaný trvalý plán a navázaný dárkový poukaz, přidělit vlastníkovi
  transakce (EN0008) roli podporovatele a spustit zprávu s potvrzením uhrazeného daru.
- Zpráva s potvrzením uhrazeného daru MUSÍ být odeslána nejvýše jednou na transakci.
- Současný stav: u kaskády vedlejších efektů stavu PAID se NESMÍ předpokládat transakčnost,
  idempotence vůči callbackům ani neopakovatelnost — opakovaná potvrzení pro tutéž transakci v
  současnosti znovu spouští přepočet financování kampaně a znovu zařazují související vedlejší
  efekty do fronty, místo aby byla ošetřena jako no-op.

## Co není cílem

Toto pravidlo nedefinuje autentizaci callbacku platební brány ani mapování stavu brány na doménový
stav (viz BR-PaymentGatewayCallbacks), pravidla životního cyklu kampaně
(dokončení/nedokončení/zamítnutí naplnění) nad rámec přípustnosti peněz (viz
BR-CampaignStoryLifecycle), mechaniku aktivace trvalého plánu (viz BR-RecurringDonationPolicy),
mechaniku aktivace/uplatnění dárkového poukazu (viz BR-VoucherPolicy), mechaniku přidělení role
podporovatele (viz BR-AccessControlAndRoles) ani obecné podmínky pro odesílání transakčních zpráv
(viz BR-TransactionalMessaging).
