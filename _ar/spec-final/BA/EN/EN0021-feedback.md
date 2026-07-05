---
doc_id: EN0021
title: Feedback
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0001  # Application — feedback is authored in the context of an Application's fundraiser/campaign
  - EN0004  # Campaign (Story) — feedback.campaign → Campaign
  - EN0008  # User — feedback author/fundraiser → User
  - EN0003  # ApplicationSession — feedback-form session created on entry into a feedback-waiting status
  - UC0002  # Orchestrate Application Status Change — creates the feedback session on entry into a feedback-waiting Application status
---

# EN0021 — Zpětná vazba

## Účel

Zpětná vazba po skončení příběhu, kterou fundraiser vytváří pro dárce, kteří podpořili jeho příběh ("zpětná vazba pro dárce, kteří vám pomohli"). Obsahuje volný text zprávy a volitelné přiložené obrázky a je kontextově vázaná na fundraisera (EN0008) a Příběh (EN0004), kterého se týká.

---

## Životní cyklus

- Vytvořeno
- Odesláno
- Publikováno / Nepublikováno (nezávislý příznak publikace)

---

## Přechody stavů

(žádný) → Vytvořeno
spouštěč: vytvoření zpětné vazby fundraiserem nebo back-office v kontextu Příběhu (EN0004); naplněno z kontextu fundraisera a příběhu asociované Žádosti (EN0001).

Vytvořeno → Odesláno
spouštěč: odeslání vytvořené zpětné vazby na cestě zpětné vazby k příběhu (zaznamenává se časová značka odeslání).

Související (přidružené, nikoli přímý stav této entity): vstup navázané Žádosti (EN0001) do stavu čekání na zpětnou vazbu vytvoří odpovídající ApplicationSession (EN0003) nesoucí formulář zpětné vazby — spouštěč: UC0002 (Řízení změny stavu žádosti), krok rozvětvení pro stavy čekání na zpětnou vazbu. Vztah mezi touto ApplicationSession (EN0003) a výsledným záznamem zpětné vazby viz Otevřené otázky.

---

## Atributy

### Systémově spravované atributy

- `sent` (časová značka; volitelné; zaznamenává, kdy byla zpětná vazba odeslána)
- `status` (boolean; volitelné; příznak publikace; výchozí hodnota publikováno)
- reference na autora (reference na EN0008 – Uživatel; volitelné; zaznamenávající/vlastnící uživatel)
- `created` / `changed` (časová značka; systémově spravované časové značky záznamu)

### Uživatelem zadávané atributy

- `name` (řetězec; povinné; popisek entity popisující záznam zpětné vazby)
- `body` (volný text; povinné; text zprávy zpětné vazby pro dárce)
- fundraiser (reference na EN0008 – Uživatel; volitelné; fundraiser, jehož jménem je zpětná vazba vytvářena)
- campaign (reference na EN0004 – Příběh; volitelné; Příběh, kterého se zpětná vazba týká)
- images (přílohy souborů; volitelné; neomezený počet; podpůrné obrázky přiložené ke zpětné vazbě)

---

## Invarianty

- Zpětná vazba musí mít vždy platný stav životního cyklu (viz Životní cyklus).
- Žádný vyhrazený dokument business pravidel v současnosti neřídí přechody ani jedinečnost Zpětné vazby; na přilehlý stav Žádosti čekání na zpětnou vazbu se vztahuje pouze obecné řízení stavů žádosti (viz BR-ApplicationStatusGovernance), nikoli přímo vlastní pole této entity.

---

## Vztahy

- EN0001 – Žádost (kontextový zdroj hodnot fundraisera a příběhu zachycených při vytvoření)
- EN0004 – Příběh (zpětná vazba se týká tohoto Příběhu)
- EN0008 – Uživatel (autor zpětné vazby / fundraiser)

---

## Otevřené otázky

1. Je Zpětná vazba zobrazována dárcům veřejně a řídí příznak publikace tuto viditelnost? Nedoloženo.
2. Jedna cesta vytvoření nezaznamenává časovou značku odeslání, zatímco druhá ano — je odeslání relevantní napříč všemi cestami vytvoření, nebo pouze u té, která ji nastavuje? Nedoloženo.
3. Vztah mezi touto entitou a stavem Žádosti čekání na zpětnou vazbu (viz rozvětvení UC0002, které při vstupu do tohoto stavu vytváří session s formulářem zpětné vazby): existuje přesně jeden záznam Zpětné vazby na Žádost, nebo na Příběh, a vede session vždy k záznamu Zpětné vazby? Nedoloženo — Conflict/Uncertain, v současných zdrojích nevyřešeno.
4. Žádný UC v aktuální sadě konceptů přímo nemodeluje vytvoření Zpětné vazby fundraiserem jako vlastní tok (UC-candidates.md přiřazuje tuto entitu k UC0011, avšak žádný potvrzený krok v UC0011 nepokrývá vytvoření Zpětné vazby); spouštěč vytvoření zaznamenaný výše je odvozen z evidence entity, nikoli z vytěženého toku use case — považovat za Partial evidenci.
