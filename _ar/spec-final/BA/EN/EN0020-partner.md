---
doc_id: EN0020
title: Partner
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0008  # User — owner
---

# EN0020 — Partner

## Účel

Partner představuje marketingovou položku typu logo "podporují nás" zobrazovanou na veřejném webu
(typicky v patičce). Jde o odlehčený marketingový/prezentační obsah — název, odkaz vedoucí ven,
obrázek loga, pozici pro řazení a kategorii odlišující položky "podporují nás" od položek
"partneři" — bez jakéhokoli doménového chování nad rámec zobrazení a řazení. Nesouvisí s
taxonomickou klasifikací `partners` používanou jinde v systému (viz Otevřené otázky).

---

## Životní cyklus

- Nepublikováno
- Publikováno

Hypothesis — Not evidenced in current sources. Žádný evidovaný use case ani flow nepokrývá
vytvoření, editaci ani publikování Partnera; potvrzen je pouze datový model. Chybějící evidence:
administrativní cesta vytvoření/editace a prezentační komponenta, která vykresluje publikované
záznamy Partnera.

---

## Přechody stavů

Nepublikováno → Publikováno
trigger: Unknown — Not evidenced in current sources.

Publikováno → Nepublikováno
trigger: Unknown — Not evidenced in current sources.

---

## Atributy

### Systémem spravované atributy

- `owner` (odkaz na EN0008 – User; nepovinné; autor záznamu)
- `created` (časové razítko; spravováno systémem; čas vytvoření)
- `changed` (časové razítko; spravováno systémem; čas poslední změny)

### Uživatelem zadávané atributy

- `category` (výčet; povinné; hodnoty: `support_us` / `partners`; jde o klasifikaci, nikoli stav
  životního cyklu)
- `name` (text, max. 50 znaků; nepovinné; popisek záznamu)
- `link` (text, max. 200 znaků; nepovinné; odchozí URL)
- `logo` (obrázek; nepovinné; veřejně dostupné)
- `order` (celé číslo; nepovinné; pozice pro řazení při zobrazení)
- `published` (booleovská hodnota; příznak publikování — viz Životní cyklus)

---

## Invarianty

- Entita musí mít vždy platný stav životního cyklu (příznak `published`).
- Není známo žádné mezientitní ani řídicí pravidlo, které by Partnera omezovalo; žádný dokument BR
  na tuto entitu v současnosti neodkazuje.

---

## Vztahy

- EN0008 — User (vlastník/autor záznamu Partnera)

---

## Otevřené otázky

1. Jak se `order` používá při vykreslování seznamu partnerů — je hodnota globálně jedinečná, nebo
   volně nastavitelná?
2. Projevuje se rozdělení `category` (`support_us` vs. `partners`) v odlišných oblastech webu?
3. V systému jinde existuje samostatná taxonomická klasifikace `partners`, která s touto entitou
   nesouvisí — hrozí mezi nimi překryv nebo záměna názvů při reálném používání?
4. Žádný use case ani business rule na Partnera v současnosti neodkazuje; triggery přechodů stavů
   nejsou potvrzeny.
