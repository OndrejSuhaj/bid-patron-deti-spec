---
doc_id: BR-DonationConfirmationAndTax
title: Donation & Tax Confirmation
canonical_layer: BR
spec_type: business-rule
status: canonical
modules: []
affects:
  - EN0014
  - EN0009
  - EN0008
  - EN0015
  - SYSTEM
references:
  - EN0014
  - EN0009
  - EN0008
  - EN0015
  - UC0010
---

# BR – Potvrzení o daru a daňové potvrzení

## Účel

Upravuje CZ potvrzení o daru (daňové potvrzení): serverem počítanou celkovou potvrzenou částku daru,
jeho neměnný snímek (snapshot), dostupnost pouze pro CZ a současnou absenci idempotence.

---

## Serverem počítaná potvrzená celková částka

- Potvrzená celková částka potvrzení o daru (EN0014) MUSÍ být součet vypočtený na serveru z
  netestovacích, jako dar označených, uhrazených transakcí (EN0009) daného dárce (EN0008), volitelně
  ohraničený rokem potvrzení a příběhem (Campaign).
- Údaje o identitě dárce zachycené na potvrzení o daru SE MAJÍ považovat za snímek dodaný volajícím,
  nikoli za nezávisle ověřená data; potvrzená celková částka je naproti tomu MUSÍ být autoritativní a
  odvozená serverem.
- Vystavení potvrzení MUSÍ být přerušeno a žádné potvrzení o daru (DonationConfirmation, EN0014)
  nesmí být vytvořeno, pokud je vypočtená celková částka pro požadovaného dárce a rok nulová.

---

## Neměnný snímek (immutable snapshot)

- Potvrzení o daru MUSÍ být uloženo jako neměnný, jednorázově zapsaný snímek identity dárce,
  potvrzené celkové částky, částky slovy a roku potvrzení (EN0014); jednou vytvořené zachycené
  hodnoty se NESMÍ považovat za živé odkazy zpět na dárce nebo na podkladové transakce (EN0009).
- Současný stav: snímek MUSÍ být uložen před tím, než je vygenerován a odeslán příslušný dokument
  potvrzení; selhání během generování nebo odesílání proto může vést k tomu, že uložený záznam
  potvrzení existuje, aniž by byla odeslána odpovídající zpráva (mezera v současném stavu — viz
  UC0010).

---

## Dostupnost a idempotence (současný stav)

- Potvrzení o daru (EN0014) MUSÍ být dostupné pouze pro zemi CZ; konfigurace zemí RO a MD toto
  potvrzení ani dokument NESMÍ generovat.
- Současný stav: vystavování potvrzení o daru NENÍ v současnosti chráněno žádným mechanismem
  idempotence — opakované požadavky pro téhož dárce a stejný rok potvrzení nezávisle na sobě vždy
  vystaví samostatný záznam potvrzení o daru (EN0014) a samostatně odešlou zprávu, místo aby byly
  deduplikovány nebo odmítnuty (mezera v současném stavu).

---

## Co pravidlo neřeší

- Toto pravidlo nedefinuje generování, rozvržení ani mechaniku doručení CZ dokumentu potvrzení
  (spravuje UC0010 a na něj navazující kontrakt zprávy).
- Toto pravidlo nepokrývá RO deklaraci přesměrování daně ("2 %"/"3,5 %") a její párování se
  smlouvou / daňovým poplatníkem (Contract/TaxPayer, EN0015) — tento mechanismus je samostatným RO
  protějškem CZ potvrzení a je upraven jinde.
- Toto pravidlo nedefinuje podmínky odeslání ani kontrakt příjemce e-mailu s potvrzením — spravují
  pravidla transakčních zpráv odkazující na MSG0028.

---

*Poznámka: Dokument spravuje pravidla CZ potvrzení o daru. Odeslání e-mailu s potvrzením a podmínky
jeho odeslání spravují business pravidla transakčních zpráv (viz MSG0028). Párování RO deklarace
přesměrování daně patří k business pravidlům smlouvy / elektronického podpisu; tento dokument
pokrývá pouze celkovou potvrzenou částku a snímek CZ potvrzení.*
