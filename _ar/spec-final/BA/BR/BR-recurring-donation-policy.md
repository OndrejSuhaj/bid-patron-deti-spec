---
doc_id: BR-RecurringDonationPolicy
title: Recurring Donation Policy
canonical_layer: BR
spec_type: business-rule
status: canonical
modules: []
affects:
  - EN0010
  - EN0009
  - SYSTEM
references:
  - EN0010
  - EN0009
  - EN0004
  - UC0007
  - UC0006
---

# BR – Zásady trvalého daru

## Účel

Upravuje životní cyklus rozvrhu trvalého daru: jeho aktivaci závislou na prvním uhrazeném daru,
periodické strhávání plateb a výběr splatných záznamů a rizika optimistického vypořádání a
dvojího strhnutí platby vyplývající z tohoto životního cyklu v současném stavu.

---

## Vytvoření a aktivace rozvrhu

- Rozvrh trvalého daru SHALL být vytvořen jako neaktivní společně se svým prvním darem a SHALL
  záviset na výchozím daru — rozvrh SHALL NOT existovat bez něj.
- Rozvrh trvalého daru SHALL se aktivovat (z neaktivního na aktivní) pouze tehdy, když jeho výchozí
  dar dosáhne stavu PAID, a tato aktivace SHALL být idempotentní.

---

## Periodické strhávání plateb a výběr splatných záznamů

- Každé periodické strhnutí platby SHALL vytvořit nový podřízený záznam daru odvozený od rozvrhu a
  SHALL jej zařadit do sdíleného zpracování peněžní stránky.
- Rozvrh SHALL být vybrán ke strhnutí platby pouze tehdy, když je splatný podle svého nastaveného
  dne, není zrušený a od jeho posledního úspěšného strhnutí uplynul minimální interval.
- Úspěšné strhnutí platby SHALL posunout časové razítko posledního úspěšného strhnutí u rozvrhu;
  neúspěšné nebo zamítnuté strhnutí SHALL NOT toto razítko posunout a SHALL NOT samo o sobě zrušit
  nebo deaktivovat rozvrh.

---

## Rizika vypořádání a souběžnosti v současném stavu

- Současný stav: u strhnutí platby SHALL NOT být předpokládáno, že odráží potvrzené vypořádání —
  strhnutí platby je v současnosti zaznamenáno optimisticky jako PAID na základě volání platební
  brány, které proběhne bez chyby, ještě před asynchronním potvrzením ze strany platební brány.
- Současný stav: výběr splatných záznamů a strhávání plateb SHALL NOT být předpokládáno jako
  atomické — během strhávání platby není na rozvrhu držen žádný nárok (claim) ani zámek, takže
  souběžné běhy nesou riziko dvojího strhnutí platby, kryté pouze intervalovým oknem na úrovni
  aplikace.
- Současný stav: není zjištěno, zda zrušení rozvrhu zároveň přepne jeho aktivní stav na neaktivní
  (časové razítko zrušení se zapisuje).

---

## Regionální rozsah

- Současný stav: periodické strhávání plateb je řízeno konfigurací podle regionu; u platební brány
  MD SHALL NOT být předpokládána potvrzená cesta periodického strhávání plateb.

---

## Ne-cíle

Toto pravidlo nedefinuje zpracování peněžní stránky uplatňované na dar po jeho vytvoření (→
BR-PaymentAndMoneyIntegrity), ani transakční zprávy odesílané při úspěchu/neúspěchu strhnutí platby
nebo při upomínání (→ BR-TransactionalMessaging). Neopakuje atributy daru ani rozvrhu (→ EN0009,
EN0010) ani krokový cron flow (→ UC0007, UC0006).
