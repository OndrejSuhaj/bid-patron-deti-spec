---
doc_id: BR-AccessControlAndRoles
title: Access Control & Role Assignment
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0008
  - EN0006
  - SYSTEM
references:
  - EN0008
  - EN0006
  - UC0014
  - UC0001
---

# BR – Řízení přístupu a přiřazování rolí

## Účel

Upravuje model přístupu založený na rolích, způsob, jakým je role přiřazena uživateli (včetně automatického
udělení role patron při prvním uhrazeném daru), a současné mezery v autentizaci a autorizaci, které ovlivňují,
kdo dnes může v systému provádět jaké akce.

## Model rolí

- Každý aktér MUSÍ být reprezentován jako uživatel (EN0008), rozlišovaný rolí, nikoli samostatným typem účtu
  pro jednotlivé druhy aktérů.
- Autorizace k akci MUSÍ být určena rolí (rolemi) přiřazenou jednajícímu uživateli.
- Uživatel MUSÍ mít možnost mít současně přiřazeno více rolí (např. fundraiser, který je zároveň patronem).

## Přiřazení role patron

- Uživateli MUSÍ být role patron udělena při prvním daru v jeho vlastnictví, který dosáhne stavu uhrazeno,
  přičemž pokud již roli má, udělení role je no-op (nemá žádný efekt).

## Autentizace (současné mezery)

- Přihlašovací token magic-link MUSÍ být platný po pevně stanovenou dobu 90 dní od vydání a po vypršení MUSÍ
  být odmítnut; token s časovým razítkem vydání v budoucnosti MUSÍ být rovněž odmítnut.
- Současný stav: nelze předpokládat, že je na všech přihlašovacích rozhraních vynucena ochrana proti hrubé
  síle (flood-control) — je respektována pouze na nejnovějším přihlašovacím rozhraní; na ostatních současných
  přihlašovacích rozhraních se kontrola flood-control sice vyhodnotí, ale její výsledek je zahozen, takže
  opakované neúspěšné pokusy nejsou fakticky blokovány a čítače neúspěšných pokusů se nenavyšují (současná
  mezera).
- Současný stav: nelze předpokládat, že jsou přihlašovací pokusy zaznamenávány — cesta pro zápis historie
  přihlášení existuje, ale je vypnutá, takže nevzniká žádná auditní stopa přihlašovacích pokusů (současná
  mezera).
- Současný stav: administrativní vytvoření uživatele (a jeho propojeného kontaktu, EN0006) z případu žádosti
  je spouštěno požadavkem typu čtení, který přitom mění stav, autorizovaným pouze jedinou kontrolou oprávnění
  bez CSRF ochrany a bez dalšího potvrzovacího kroku (současná mezera).

## Ne-cíle

- Toto pravidlo nedefinuje úplný katalog rolí ani mapování role na oprávnění — viz glosář a EN0008.
- Toto pravidlo nedefinuje GDPR výmaz osobních údajů uživatele — viz BR-DataProtectionAndErasure.
- Toto pravidlo nedefinuje zajištění strany (vytvoření kontaktu/uživatele z případu) ani identifikaci/deduplikaci
  strany — viz BR-PartyIdentityAndDeduplication.
- Toto pravidlo nepředepisuje nápravu v cílovém stavu (vynucený flood-control všude, auditování přihlašovacích
  pokusů, CSRF chráněné administrativní akce); zaznamenává pouze chování v současném stavu.
