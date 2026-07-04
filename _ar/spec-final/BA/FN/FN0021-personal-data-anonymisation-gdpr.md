---
doc_id: FN0021
title: Personal-Data Anonymisation (GDPR)
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0015
  - EN0008
  - EN0006
  - FN0015
  - FN0022
---

# FN0021 – Anonymizace osobních údajů (GDPR)

## Účel

Umožňuje autorizovanému uživateli back-office na vyžádání vymazat přihlašovací osobní údaje strany
(e-mail a zobrazované jméno) ze záznamu Uživatel (EN0008), aby bylo možné vyřídit žádost o výkon
práva na výmaz podle GDPR, a zařadí do fronty navazující re-synchronizace, které z této mutace
vyplývají.

---

## Odpovědnosti

Tato funkční kapacita odpovídá za:

- Vyhledání Uživatele (EN0008) podle zadané e-mailové adresy, vymazání pole e-mail u nalezeného
  Uživatele a nahrazení jeho zobrazovaného jména náhodně vygenerovanou hodnotou, a uložení
  aktualizovaného záznamu.
- Zařazení anonymizovaného Uživatele do fronty pro re-synchronizaci vyhledávacího indexu (FN0022)
  a pro re-synchronizaci marketingového CRM (FN0015) jako vedlejší efekty téhož požadavku.
- Pokus o odeslání požadavku na smazání kontaktu v marketingovém CRM v rámci téhož požadavku,
  pokud je aktuální prostředí produkční.

---

## Související případy užití

- UC0015 – Anonymizace osobních údajů (GDPR)

---

## Související entity

- EN0008 – Uživatel
- EN0006 – Kontakt

---

## Integrace

Tato funkční kapacita sama o sobě nevlastní žádné přímé volání externího systému. Navazující
upsert/smazání kontaktu v marketingovém CRM je delegováno na FN0015 (Marketingová / CRM
synchronizace), která cílí na Mautic — viz ARCH0002_ContextInteractionMap pro přehled integrační
krajiny platformy.

---

## Omezení

- Výmaz je částečný a end-to-end neodpovídá požadavkům GDPR: mění se pouze pole e-mail a
  zobrazované jméno Uživatele; pole jméno/příjmení Uživatele a veškeré osobní údaje uložené na
  souvisejících záznamech Žádosti a Kontaktu (EN0006) — včetně rodného čísla, adresy a
  telefonního čísla vázaných na tutéž stranu — zůstávají nedotčeny, bez kaskády do těchto záznamů.
- Cesta smazání kontaktu v marketingovém CRM, volaná v produkci, je definovaná, ale prázdná
  funkční kapacita, která na straně CRM neprovádí žádné skutečné odstranění.
- Re-synchronizace marketingového CRM, kterou tato kapacita zařazuje do fronty (a kterou vyčerpává
  FN0015), znovu provede upsert kontaktního záznamu anonymizované strany se stále vyplněným
  jménem a příjmením, což jde proti záměru výmazu, místo aby jej dokončilo.
- Žádný potvrzovací krok, opětovná autentizace ani druhé schválení akci anonymizace nepodmiňují.
- Jakmile je e-mail Uživatele u dané strany v rámci úspěšného běhu vymazán, opakovaný požadavek na
  tutéž původní e-mailovou adresu už tuto stranu nemůže dohledat ani znovu zacílit.
