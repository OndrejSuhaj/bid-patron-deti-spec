---
doc_id: EN0005
title: Patron
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0004 (Campaign)
  - EN0008 (User)
  - EN0006 (Contact)
  - BR-CampaignStoryLifecycle
  - UC0011
---

# EN0005 — Patron

## Účel

Patron je veřejně zobrazovaný profil patrona uváděný na stránce příběhu (Campaign) — jméno, příjmení
a fotografie prezentované veřejnosti jako „patron tohoto dítěte". Jde pouze o zobrazovací záznam, odlišný
od patronské *role* uživatele (`EN0008`) i od *kontaktních* údajů patrona uchovávaných v Kontaktu
(`EN0006`); entita Patron existuje výhradně za účelem nesení veřejné prezentace připojené k příběhu
(`EN0004`).

---

## Životní cyklus

Publikováno  
Nepublikováno

Nejsou pozorovány žádné další stavy životního cyklu vlastněné entitou; Patron nese pouze příznak
publikace/zrušení publikace a nemá vlastní stavový workflow.

---

## Přechody stavů

(žádný) → Publikováno / Nepublikováno  
trigger: UC0011 — vytvořeno nebo upraveno v rámci vytváření příběhu; žádný nezávislý přechod není
doložen (Hypothesis; viz Otevřené otázky).

---

## Atributy

### Atributy spravované systémem

- příznak publikace (boolean; povinný; řídí, zda je profil veřejně viditelný)

### Atributy zadávané uživatelem

- příjmení (řetězec; povinné; popisek entity)
- jméno (řetězec; povinné)
- druhé příjmení (řetězec; povinné; duplicita příjmení — viz Otevřené otázky)
- fotografie (obrázek; volitelné; odkaz na mediální/souborový aktivum)

---

## Invarianty

- Příběh má nejvýše jednoho Patrona — viz `BR-CampaignStoryLifecycle`.
- Připravenost příběhu k publikaci vyžaduje nastaveného Patrona — viz `BR-CampaignStoryLifecycle`.

---

## Vztahy

- EN0004 — Campaign (příběh odkazuje na svůj jeden veřejný profil Patrona)
- EN0008 — User (patronská role, uchovávaná odděleně od tohoto veřejného zobrazovacího profilu)
- EN0006 — Contact (kontaktní údaje patrona, uchovávané odděleně od tohoto veřejného zobrazovacího
  profilu)

---

## Otevřené otázky

- Proč nesou atributy příjmení a druhé příjmení stejný veřejný popisek — je atribut druhého příjmení
  nepoužívaný/mrtvý?
- Je Patron někdy znovu použit napříč více příběhy, nebo je vždy v poměru jedna ku jedné se svým
  příběhem?
- Jak tento veřejný profil Patrona v praxi souvisí s patronskou rolí uživatele a kontaktem patrona —
  jsou prezentační data duplikována napříč všemi třemi, a pokud ano, jak je udržována konzistence?
- Žádný potvrzený use case nesleduje vytvoření nebo úpravu Patrona nezávisle na vytváření příběhu;
  výše uvedený trigger přechodu je Hypothesis, nikoli Confirmed flow.
