---
doc_id: ES0006
title: Mautic
layer: ES
spec_type: external-system
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0015
  - FN0019
  - UC0012
  - UC0013
  - UC0015
---

# ES0006 – Mautic

## Účel

Mautic slouží jako marketingové/CRM úložiště kontaktů, do kterého platforma průběžně synchronizuje
záznamy uživatelů (party), a — přestože je odchozí komunikační schopnost platformy interně
pojmenovaná „SmartMailing" — zároveň funguje jako jediný odchozí transportní kanál pro transakční
zprávy platformy [ARCH0001 §5 row 7; FN0015; FN0019].

---

## Přehled systému

Mautic je platforma pro marketingovou automatizaci / CRM, která spravuje marketingové kontakty a
odesílá e-maily. V rámci současné integrační architektury Patronusu plní zároveň dvě role: je
referenčním CRM systémem, který zrcadlí uživatele (party) platformy jako marketingové kontakty, a
zároveň je skutečným systémem pro transport e-mailů, jehož prostřednictvím se odesílají všechny
šablonované transakční zprávy — pod názvem „SmartMailing" komunikační schopnosti se tedy neskrývá
žádný samostatný SMTP transport [ARCH0001 §5 row 7; FN0019].

---

## Integrační model

Pouze odchozí komunikace, ve dvou odlišných režimech interakce [ARCH0001 §5 row 7; ARCH0002]:

- **Asynchronní fronta pro upsert kontaktů.** Záznamy uživatelů (Contact/User) jsou při uložení
  uživatele odesílány do Mauticu jako upsert kontaktu, a to prostřednictvím fronty pro CRM
  synchronizaci — jde o skutečně asynchronní (eventuální) cestu této integrace (UC0013; spouští se
  také jako vedlejší efekt anonymizace v UC0015).
- **Synchronní odeslání transakční zprávy.** Každé odeslání transakční zprávy předává zprávu
  Mauticu jako odchozímu transportu, a to synchronně v rámci requestu/uložení, protože mailová
  fronta platformy je vypnutá (UC0012).

---

## Výměna dat

Pouze koncepční odchozí datové toky, bez vlastnictví detailu na úrovni payloadu/polí zde:

- Data pro upsert uživatele/kontaktu při CRM synchronizaci — vlastnictví atributů náleží entitám
  Contact a User (viz EN0006, EN0008).
- Požadavky na odeslání transakční zprávy — vlastnictví obsahu, šablony a archivace náleží
  komunikační schopnosti a záznamu EmailArchive (viz FN0019; vrstva MSG).

Žádný vstupní datový tok z Mauticu do platformy není doložen.

---

## Omezení

- **Synchronní odeslání při selhání blokuje/přeruší operaci, bez opakování.** Transakční e-mail se
  odesílá přes Mautic synchronně v rámci uložení entity/requestu; pomalé nebo neúspěšné volání
  blokuje nebo přeruší probíhající uložení, bez mechanismu opakování [ARCH0001 §5 row 7, HS13;
  FN0019].
- **Riziko obnovení dat při GDPR anonymizaci.** Fronta pro CRM synchronizaci znovu odešle upsert
  anonymizovaného uživatele do Mauticu, zatímco pole jména/příjmení jsou stále vyplněná, čímž se po
  požadavku na výmaz znovu vytvoří marketingový kontakt s neporušenými jmény; produkční cesta mazání
  podle e-mailu, která se při anonymizaci volá, je no-op a k žádnému skutečnému odstranění na straně
  Mauticu nedochází [ARCH0001 §5 row 7, HS06; FN0015].
- **Nejednoznačnost pojmenování, nikoli samostatný systém.** Integrační inventář vedle Mauticu
  uvádí také službu `patron_base.smartmailing`; rekonstruovaná evidence považuje Mautic za skutečné
  CRM a transport skrývající se pod tímto názvem. Tato otázka pojmenování SmartMailing vs. Mautic je
  zde zaznamenána jako otevřený bod, nikoli rozdělena do samostatného ES [FN0019].

Pouze současný stav — tento dokument popisuje integrační hranici Mauticu tak, jak je implementována
dnes, nikoli žádný budoucí redesign.
