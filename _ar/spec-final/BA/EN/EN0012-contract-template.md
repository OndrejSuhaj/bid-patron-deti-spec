---
doc_id: EN0012
title: ContractTemplate
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0011  # Contract — instances generated from this template
  - BR-ContractAndESignature  # governs Contract generation from a ContractTemplate
  - UC0004  # Manage Contract & Signature — consumes the template at Contract creation
---

# EN0012 — Šablona smlouvy

## Účel

Znovupoužitelná, editovatelná šablona dokumentu sloužící k vygenerování Smlouvy (EN0011) daného typu
smlouvy. Tělo šablony je zdrojem textace, který se po dosazení dat stane obsahem dokumentu
vygenerované Smlouvy.

---

## Životní cyklus

Editovatelný obsah — na úrovni entity není doložen žádný stavový automat. Každá úprava vytváří novou
revizi téže šablony; obsah zůstává překladatelný napříč jazyky.

Žádný stav publikace/vyřazení není potvrzen — viz Otevřené otázky.

---

## Přechody stavů

Nedoloženo. Šablona je udržována jako trvalý obsah a při vytváření Smlouvy je pouze spotřebována,
nikoli posouvána mezi stavy.

- Spouštěč spotřeby: UC0004 (Správa smlouvy a podpisu) — šablona pro zvolený typ smlouvy je
  aplikována při vytváření Smlouvy; průběh dosazování viz UC0004.

---

## Atributy

### Systémem spravované atributy

- owner (reference na EN0008 – Uživatel; vlastnící/spravující uživatel šablony)

### Uživatelem zadávané atributy

- name (řetězec; povinné; popisek šablony)
- html (text; povinné; tělo šablony — textace dosazovaná daty Žádosti/Profilu žádosti při generování
  Smlouvy)
- contract_type (výčet; povinné; hodnoty: good / service / transfer / nno / appendix /
  delivery_note / acceptance_protocol / rental_contract / rental_agreement / ukraine)

---

## Invarianty

- Šablona smlouvy pro zvolený typ smlouvy musí existovat jako předpoklad pro vytvoření Smlouvy;
  spotřeba Šablony smlouvy při generování Smlouvy se řídí pravidlem BR-ContractAndESignature
  (viz UC0004).
- Není potvrzeno omezení jedinečnosti ani omezení na jednu aktivní šablonu na contract_type — viz
  Otevřené otázky.

---

## Vztahy

- EN0011 – Smlouva: Šablona smlouvy je zdrojem textace pro Smlouvy z ní vygenerované (Smlouva si
  neuchovává trvalou referenci zpět na šablonu, ze které byla vygenerována).
- EN0008 – Uživatel: vlastnící/spravující uživatel.

---

## Otevřené otázky

1. Existuje potvrzený stav publikace/aktivace Šablony smlouvy, nebo je šablona vždy použitelná ihned
   po vytvoření? (Uncertain — nebyl pozorován žádný potvrzený stavový slovník.)
2. Jak se vybere jediná Šablona smlouvy, pokud pro stejný contract_type existuje více záznamů (jeden
   aktivní záznam? nejnovější? podle jazyka?)? Chybějící evidence.
3. Hodnoty contract_type zahrnují appendix / delivery_note / acceptance_protocol, které odpovídají
   samostatným referenčním slotům na EN0001 (Žádost); zda je toto mapování striktně 1:1, není
   potvrzeno.
