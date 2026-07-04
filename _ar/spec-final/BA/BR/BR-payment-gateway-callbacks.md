---
doc_id: BR-PaymentGatewayCallbacks
title: Payment Gateway Callback Authenticity & Status Mapping
canonical_layer: BR
spec_type: business-rule
status: canonical
modules: []
affects:
  - EN0009
  - EN0010
  - SYSTEM
references:
  - EN0009
  - EN0010
  - UC0005
  - UC0006
  - UC0007
---

# BR – Autenticita callbacků platební brány a mapování stavů

## Účel

Upravuje způsob, jakým jsou potvrzení jednotlivých regionálních plateních bran ověřována a mapována
na doménový platební stav, a zaznamenává současné mezery v autenticitě tohoto procesu.

## Jedna platební brána na region

- Každý region MUSÍ směrovat platby přes právě jednu platební bránu (CZ bránu, RO bránu nebo MD
  bránu).

## Ověřování potvrzení (současný stav)

- Potvrzení platební brány MUSÍ být ověřeno vlastním schématem dané brány, nikoli spoléháním na
  návratová data dodaná prohlížečem.
- Současný stav: u callback endpointů platebních bran se NESMÍ předpokládat, že nesou kryptografický
  podpis, a nemají žádnou ochranu proti replay útoku ani zajištění idempotence; autenticita v
  současnosti stojí na opakovatelně použitelném sdíleném tajemství nebo na opětovném dotazu (re-poll).
- Současný stav: potvrzení, které podle svých korelačních identifikátorů neodpovídá žádné existující
  transakci (EN0009), ponechá danou transakci neoznačenou, aniž by se spustilo záložní párování —
  platba, která byla u platební brány ve skutečnosti dokončena, tak může zůstat trvale nezaznamenaná
  jako dar uhrazen.

## Mapování stavů

- Nativní slovník stavů každé platební brány MUSÍ být před aplikací výsledku na peněžní záznam
  namapován na doménový platební stav (PENDING / AUTHORIZED / PAID / CANCELLED / REFUNDED).
- Současný stav: na návratovou hodnotu z prohlížeče u MD brány SE NESMÍ spoléhat jako na zdroj
  vypořádání — jakýkoli nezrušený výsledek z prohlížeče je dárci v současnosti zobrazen jako úspěch,
  zatímco autoritativní stav pochází z opětovného dotazu na straně serveru.

## Co není cílem

Toto pravidlo nedefinuje navazující kaskádu po dar uhrazen (přepočet financování kampaně, povýšení
role, potvrzovací zprávy) ani jedinečnost platební identity, které upravuje BR-PaymentAndMoneyIntegrity.
Nedefinuje provedení opakované platby ani mechaniku zachycení tokenu platební brány, které upravuje
BR-RecurringDonationPolicy. Neopakuje atributy Transaction ani RecurringTransaction (→ EN0009, EN0010)
ani krok-za-krokem potvrzovací tok pro jednotlivé platební brány (→ UC0006, UC0005, UC0007).
