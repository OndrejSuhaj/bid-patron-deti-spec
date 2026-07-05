---
doc_id: EN0029
title: BankTransactionMail
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0009  # Transaction — produced or updated from the same inbound notification
  - EN0008  # User — owner of the audit record
  - BR-BankReconciliationAndMatching
  - UC0008  # Reconcile Bank Transactions (sub-flow UC0008.2 — bank notification e-mail import)
---

# EN0029 — BankTransactionMail

## Účel

Auditní záznam o příchozím e-mailu s bankovním oznámením ("avízo") zpracovaném během párování
plateb. Zachycuje skutečnost, že byla zpracována oznamovací zpráva, nikoli samotnou platbu — platbu
reprezentuje Transaction (EN0009). Jeden záznam BankTransactionMail existuje pro každou zpracovanou
oznamovací zprávu, bez ohledu na to, zda tato zpráva vytvořila Transaction, či nikoli.

---

## Životní cyklus

- Recorded (zaznamenáno) — jediný stav; entita je pouze pro přidávání (append-only).

---

## Přechody stavů

Žádné. BankTransactionMail má jediný, konečný stav: jakmile je záznam vytvořen, již není nikdy
aktualizován ani dále přecházen do jiného stavu.

- (vytvořeno) → Recorded (zaznamenáno)
  spouštěč: UC0008 (dílčí tok UC0008.2 — import e-mailu s bankovním avízem)

---

## Atributy

### Atributy spravované systémem

- Owner (odkaz na EN0008 – User; volitelné) — strana přiřazená k auditnímu záznamu.
- Received at (datum a čas; povinné) — čas přijetí oznamovací zprávy.

### Atributy zadávané uživatelem

Žádné — záznam je generován výhradně z příchozí oznamovací zprávy; nemá žádné atributy zadávané
uživatelem.

---

## Invarianty

- Viz BR-BankReconciliationAndMatching — pro každou zpracovanou zprávu s bankovním avízem se zapíše
  jeden auditní záznam, bez ohledu na výsledek.
- BankTransactionMail sám o sobě neobsahuje uložený odkaz na Transaction (EN0009), kterou případně
  vytvořil; korelace mezi nimi je externí (viz Otevřené otázky).

---

## Vztahy

- EN0008 – User (vlastník auditního záznamu)
- EN0009 – Transaction (oznámení může v rámci stejného procesu párování plateb — UC0008.2 —
  vytvořit nebo aktualizovat Transaction; jde o behaviorální asociaci, nikoli uložený odkaz)

---

## Otevřené otázky

1. Conflict — není jisté, zda je předmět oznámení (subject) na záznamu spolehlivě persistován
   (ve zdrojových podkladech byl pozorován nesoulad v pojmenování pole mezi hodnotou, která se
   nastavuje, a polem definovaným pro uložení).
2. Neexistuje uložené propojení ze záznamu BankTransactionMail zpět na Transaction (EN0009), kterou
   vytvořil; spárování jednoho s druhým se opírá o externí korelaci (např. variabilní symbol nebo
   identifikátor zprávy), nikoli o vztah mezi entitami.
3. Záznamy se zapisují i v případě, že se parsování oznámení nezdaří, dle chybového scénáře
   popsaného v BR-BankReconciliationAndMatching — není potvrzeno, zda jsou neúspěšné a úspěšné
   importy na záznamu samotném rozlišitelné.
