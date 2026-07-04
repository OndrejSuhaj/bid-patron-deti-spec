---
doc_id: FN0026
title: Reference Data & Geographic Lookup
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0001
  - UC0022
---

# FN0026 – Referenční data a vyhledávání geografických údajů

## Účel

Poskytovat sdílená referenční/vyhledávací data — především geografickou hierarchii ČR (kraj/okres/
obec/PSČ) — využívaná okrajově při zadávání adresy a v logice publikování (UC0001, UC0022). Jde o
podpůrnou vyhledávací funkcionalitu bez vlastního doménového životního cyklu.

---

## Odpovědnosti

Funkcionalita odpovídá za:

- Zjišťování geografických referenčních hodnot (kraj / okres / obec / PSČ) pro zadání adresy u
  žádosti (UC0001).
- Poskytování sdílených referenčních číselníků okrajově využívaných logikou publikování a validace
  (UC0022).

---

## Související případy užití

- UC0001 – Podání žádosti (Žádost) (zadání adresy, vyhledání/vytvoření referenčních dat)
- UC0022 – Běh workflow enginu platformy a plánované publikování (okrajové vyhledávání referenčních
  dat logikou publikování)

---

## Související entity

Žádné. Podkladové geografické tabulky jsou považovány za referenční/konfigurační data, nikoli za
povýšené doménové entity (viz seznam zamítnutých kandidátů na EN v glosáři).

---

## Integrace

Žádné. Tato funkcionalita nevolá žádný externí systém (viz ARCH0002_ContextInteractionMap.md).

---

## Omezení

- Pouze podpůrné vyhledávání — tato funkcionalita se neobjevuje v žádném samostatném flow a
  nevlastní žádný doménový agregát; podkladové geografické tabulky jsou považovány za
  referenční/konfigurační data, nikoli za doménové entity.
- Záměrně udržováno minimalistické: Referenční data nemají vlastní samostatný případ užití; jsou zde
  zdokumentována pouze proto, aby byly pokryty jejich dotyky v rámci UC0001 a UC0022, aniž by se
  vymýšlelo chování nad rámec toho, co tyto případy užití dokládají.
