---
doc_id: EN0016
title: Blacklist
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0001  # Application — the case a blacklist entry is linked to
  - EN0006  # Contact — the party a list entry classifies
  - EN0008  # User — the author of a list entry
  - BR-ScoringAndRiskGating          # blacklist creation, gating, propagation to Contact
  - BR-PartyIdentityAndDeduplication # e-mail-keyed propagation hazard (no party uniqueness)
  - UC0003  # Assess Applicant Risk (Scoring) — creates and reads Blacklist entries
---

# EN0016 — Blacklist

## Účel

Záznam Blacklist zaznamenává rozhodnutí o rizikové klasifikaci provedené vůči konkrétní roli
strany (fundraiser, patron, dárce daru, nebo spotter) uvedené na žádosti (EN0001). Zachycuje
samotnou klasifikaci (úroveň white-listu nebo úplnou blokaci) spolu s denormalizovanými
identifikačními údaji klasifikované strany, které slouží ke zpětnému namapování klasifikace na
záznam kontaktu (EN0006) dané strany. Záznamy Blacklist jsou trvalým záznamem scoringových
rozhodnutí vzniklých při posouzení rizika (viz BR-ScoringAndRiskGating).

---

## Životní cyklus

- Active — záznam existuje jako neměnný klasifikační záznam.

Pro záznam Blacklist neexistuje žádný další automat životního cyklu: není doloženo, že by byl po
vytvoření aktualizován nebo odstraněn (otevřená otázka — status append-only není potvrzen).

---

## Přechody stavů

(žádný) → Active
spouštěč: UC0003 — Assess Applicant Risk (Scoring), dílčí tok manuálního scoringu (vytvoření
klasifikačního záznamu blacklistu)

Žádné další přechody nejsou doloženy.

---

## Atributy

### Atributy spravované systémem

- author (odkaz na EN0008 – User; povinné; uživatel, který klasifikaci zaznamenal)
- created (časové razítko; systémem zaznamenaný čas vytvoření)
- changed (časové razítko; systémem zaznamenaný čas poslední změny)

### Atributy zadávané uživatelem

- classification (výčet; povinné; hodnoty: ZD, Z, N — úrovně white-listu — nebo Black List;
  viz BR-ScoringAndRiskGating pro způsob odvození a gatingu klasifikace)
- party role (výčet; povinné; hodnoty: fundraiser, patron, gift, spotter — klasifikovaná role)
- application (odkaz na EN0001 – Application; povinné; případ, ke kterému klasifikační rozhodnutí
  patří)
- first name / last name (text; nepovinné; identifikační údaj klasifikované strany)
- national identification number (text; nepovinné; identifikační údaj klasifikované strany)
- e-mail (text; nepovinné; identifikační údaj použitý pro namapování klasifikace na kontakt)
- phone (text; nepovinné; identifikační údaj klasifikované strany)
- company name / company identification number (text; nepovinné; identifikační údaj v případě,
  že klasifikovanou stranou je organizace)
- note (text; nepovinné; volná textová poznámka)

---

## Invarianty

- Každý záznam Blacklist musí být propojen se žádostí (EN0001) — viz BR-ScoringAndRiskGating.
- Klasifikace záznamu Blacklist je vytvořena společně se změnou stavu žádosti a odpovídajícím
  zápisem klasifikace kontaktu (EN0006), jako jeden zaznamenaný výsledek scoringu — viz
  BR-ScoringAndRiskGating.
- Propagace klasifikace záznamu Blacklist na kontakt (EN0006) je párována podle e-mailové adresy
  a není omezena na jeden jednoznačně identifikovaný kontakt — viz
  BR-PartyIdentityAndDeduplication.

---

## Vztahy

- EN0001 — Application (povinné; případ, vůči kterému záznam klasifikuje stranu)
- EN0006 — Contact (záznam strany, jejíž klasifikace je aktualizována hodnotou klasifikace tohoto
  záznamu)
- EN0008 — User (autor, který záznam zaznamenal)

---

## Otevřené otázky

1. Je záznam Blacklist po vytvoření někdy aktualizován nebo odstraněn, nebo je záznam pouze
   append-only? Žádná cesta k odblokování (delist) není doložena.
2. Může propagace párovaná podle e-mailu na kontakt (EN0006) ovlivnit záznamy kontaktů
   nesouvisející se stranou, která je skutečně klasifikována? Sledováno jako riziko v rámci
   BR-PartyIdentityAndDeduplication; rozsah dopadu není plně doložen.
3. Některé konfigurační plochy odkazují na identifikační/klasifikační pole, která nejsou součástí
   potvrzené sady atributů této entity — zda na nich závisí nějaké živé chování, není potvrzeno.
