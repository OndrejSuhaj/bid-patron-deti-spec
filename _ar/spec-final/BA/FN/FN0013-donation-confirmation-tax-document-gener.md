---
doc_id: FN0013
title: Donation Confirmation & Tax Document Generation
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0010
  - EN0014
  - EN0008
  - EN0009
  - EN0022
  - EN0015
  - EN0011
---

# FN0013 – Potvrzení o daru a generování daňových dokladů

## Účel

Vytvářet oficiální daňové doklady z historie plateb dárce: vypočítat celkovou uhrazenou částku darů
dárce za požadovaný rok a vygenerovat CZ potvrzení o daru ("Potvrzení o daru") jako PDF snímek
doručovaný e-mailem; a jako přidruženou RO variantu zaznamenat deklaraci přesměrování daně 2 %/3,5 %.
Jde o funkci daňové dokumentace, kterou využívá UC0010.

---

## Odpovědnosti

- Určit cílového dárce (přihlášeného uživatele nebo dárce dohledaného podle e-mailu) a vypočítat jeho
  celkovou uhrazenou částku darů a datum posledního daru za požadovaný rok, volitelně omezené na
  konkrétní příběh.
- Vytvořit a uložit neměnný snímek DonationConfirmation (identita žadatele, vypočtená celková částka,
  částka slovy, rok potvrzení) a vygenerovat z něj CZ daňové potvrzení ve formátu PDF.
- Odeslat PDF potvrzení e-mailem (přes FN0019) a archivovat každý pokus o odeslání.
- Podporovat přidruženou RO deklaraci přesměrování daně (vytváří záznam Contract a záznam TaxPayer
  a připojuje jej k exportu pro podání) jako samostatnou zemní variantu funkce daňové dokumentace.

---

## Související případy užití

UC0010 – Vystavení potvrzení o daru (daňové) (primární).

---

## Související entity

EN0014 – DonationConfirmation (uložený CZ snímek daňového potvrzení, který tato funkce vytváří).
EN0008 – User (určený dárce/žadatel, jehož uhrazené dary jsou potvrzovány).
EN0009 – Transaction (zdroj pouze pro čtení pro výpočet celkové uhrazené částky darů za požadovaný rok).
EN0022 – EmailArchive (archivní záznam pokusu o odeslání e-mailu s potvrzením).
EN0015 – TaxPayer (RO záznam poplatníka pro přesměrování daně — přidružená zemně specifická entita).
EN0011 – Contract (RO doklad deklarace přesměrování daně — přidružená zemně specifická entita).

---

## Integrace

Žádné přímé — generování dokumentu je interní systémová odpovědnost. Odeslání PDF potvrzení e-mailem
zajišťuje funkce transakčního zasílání zpráv (FN0019 – Transakční zasílání zpráv a šablonování), která
archivuje odeslání přes EmailArchive (EN0022) a přenáší jej přes Mautic. Viz ARCH0002_ContextInteractionMap
pro přehled integrační krajiny.

---

## Omezení

- Celková uhrazená částka darů se počítá sečtením částek Transaction cestou, která obchází funkci
  zpracování plateb darů (FN0007) — jde o přímé čtení agregátu místo volání služby, což provazuje
  správnost této funkce se strukturou dat Transaction.
- Neexistuje žádná pojistka idempotence: opakované požadavky pro stejného dárce/rok vždy vytvoří
  samostatný záznam DonationConfirmation a samostatný e-mail, bez jakékoli deduplikace.
- Snímek DonationConfirmation je uložen dříve, než dojde k pokusu o vygenerování dokumentu a jeho
  odeslání, takže selhání generování nebo odeslání zanechá v evidenci záznam potvrzení, aniž by kdy
  byl odeslán odpovídající e-mail — tichý, částečně dokončený výsledek.
- Dílčí funkce RO deklarace přesměrování daně je Partial/nezmapovaná do detailu: je doložena pouze jako
  odkaz na přidružený tok a nečte celkové částky Transaction ani nevytváří PDF DonationConfirmation,
  což z ní činí samostatný mechanismus, nikoli lokalizovanou variantu CZ cesty potvrzení.

---

## Poznámka

Kanonické místo pro generování dokumentů, na které odkazují sesterské funkce FN0002 a FN0007. Generování
dokumentu smlouvy pro UC0004 spravuje FN0009 (Generování smlouvy a elektronický podpis); tato funkce
spravuje rodinu daňových/potvrzovacích dokumentů (CZ potvrzení o daru a přidruženou RO deklaraci
přesměrování daně).
