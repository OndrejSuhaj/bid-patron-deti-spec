---
doc_id: EN0019
title: Supplier
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0002  # ApplicationProfile — gift_supplier references Supplier
---

# EN0019 — Dodavatel

## Účel

Registr dodavatelů daru / dodavatelů zboží. Reprezentuje firmu, od které je (nebo by byl) pořízen
předmět daru požadovaný v žádosti. Dodavatel je back-office referenční data s odlehčeným životním
cyklem, čtená z profilu žádosti (EN0002) a z reportingových/exportních toků.

---

## Životní cyklus

Publikováno
Nepublikováno

Pro Dodavatele neexistuje žádný další slovník doménových stavů nad rámec stavu
publikováno/nepublikováno.

---

## Přechody stavů

Hypothesis — Not evidenced in current sources. Pro Dodavatele není zmapován žádný tok vytvoření,
úpravy ani publikování/zrušení publikace; potvrzen je pouze tvar dat a jeho použití jako reference
na straně čtení (z EN0002 a v reportingových exportech). Chybějící evidence: use case, který
vytváří nebo spravuje záznamy Dodavatele.

---

## Atributy

### Systémem spravované atributy

- status (boolean; povinný; publikováno / nepublikováno; výchozí hodnota publikováno)
- created (timestamp; spravováno systémem)
- changed (timestamp; spravováno systémem)
- owner (reference na EN0008 – Uživatel; volitelné)

### Uživatelem zadávané atributy

- name (text; povinný; zobrazovaný název dodavatele)
- company identifier (text; volitelné; registrované IČO firmy)
- data-box identifier (text; volitelné; ID datové schránky pro oficiální elektronické doručování)
- street (text; volitelné)
- city (reference na referenční položku typu město; volitelné)
- postal code (text; volitelné)

---

## Invarianty

- Dodavatel bez aktivního výčtu doménového stavu je řízen pouze stavem publikováno/nepublikováno;
  žádné další pravidlo životního cyklu není doloženo.
- Conflict/Uncertain — související mapování mezi Dodavatelem a kategorií oblasti nápovědy (s URL
  e-shopu) existuje jako samostatná struktura bez potvrzeného omezení jedinečnosti pro dvojici
  Dodavatel–kategorie; zda jsou duplicitní mapování zamýšlená, není vyřešeno.

---

## Vztahy

- EN0002 – Profil žádosti (gift_supplier: profil žádosti volitelně odkazuje na Dodavatele, který má
  zajistit požadovaný dar)
- EN0008 – Uživatel (vlastník záznamu Dodavatele)

---

## Otevřené otázky

1. Kdo vytváří/spravuje záznamy Dodavatele (administrativní use case vs. automatické vytvoření)?
   Žádný tok vytvoření ani úpravy není doložen.
2. Je duplicitní mapování Dodavatel–kategorie očekávané, nebo by měla být dvojice jedinečná?
   Nedoloženo.
3. Odkaz na město u Dodavatele je vytvářen ad hoc z volného textu — je nekontrolovaný růst slovníku
   referenčních dat měst zamýšlený? Nedoloženo.
