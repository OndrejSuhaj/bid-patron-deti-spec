---
doc_id: EN0017
title: ScoringRecord
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0001  # Application — scoring snapshot and low-risk score are attributes of the Application
  - EN0002  # ApplicationProfile — fundraiser/patron profile data consumed to compute scoring
  - EN0006  # Contact — blacklist classification propagated by scoring
  - EN0016  # Blacklist — risk-list entries created alongside scoring
  - BR-ScoringAndRiskGating
  - UC0003
---

# EN0017 — Scoring záznam

## Účel

ScoringRecord představuje výsledek rizikového posouzení pro žádost (EN0001): ručně provedené
scoringové hodnocení (rizikové faktory dárce, patrona, daru a dítěte, verdikt schválení a rozhodnutí
o zařazení do blacklistu) společně se systémově odvozeným low-risk skóre a jeho rozpadem po
jednotlivých složkách. Jde o záznam, který určuje, zda může žádost postoupit směrem k naplnění, a
který řídí rizikovou klasifikaci promítanou do záznamů kontaktu (EN0006) a blacklistu (EN0016).

ScoringRecord nemá vlastní samostatnou identitu ani životní cyklus: ruční scoringový snímek i
low-risk skóre jsou vedeny jako atributy žádosti (EN0001), kterou hodnotí, nikoli jako samostatný
adresovatelný záznam. V doméně je definován samostatný nosič scoringových dat, klíčovaný libovolným
názvem a identifikátorem hodnocené entity, ten však není produkován žádným současným procesem —
Status: Planned/dormant.

---

## Životní cyklus

ScoringRecord nemá vlastní stavy životního cyklu. Vzniká a je obnovován jako vedlejší produkt událostí
životního cyklu žádosti (EN0001):

- **Absent** — pro žádost dosud nebylo zaznamenáno žádné scoringové hodnocení.
- **Manually assessed** — pro žádost byl odeslán a uložen scoringový verdikt spolu s podpůrnými poli.
- **Low-risk assessed** — pro žádost bylo vypočteno a uloženo systémově odvozené low-risk skóre a jeho
  rozpad.

Tyto stavy se vzájemně nevylučují: žádost může nést low-risk hodnocení, ruční hodnocení, nebo obojí
současně, každé nezávisle obnovované.

---

## Přechody stavů

Absent → Manually assessed
trigger: UC0003 (UC0003.1 — ruční rizikový scoring)

Manually assessed → Manually assessed (re-assessed)
trigger: UC0003 (UC0003.1 — každé odeslání scoringového formuláře znovu uloží snímek)

Absent → Low-risk assessed
trigger: UC0003 (UC0003.2 — automatický low-risk scoring při změně stavu žádosti)

Low-risk assessed → Low-risk assessed (recomputed)
trigger: UC0003 (UC0003.2 — přepočet při každé kvalifikující změně stavu žádosti)

---

## Atributy

### Systémově spravované atributy

- Low-risk skóre (celé číslo; nepovinné; celkové odvozené rizikové skóre; zaznamenává se jako
  nedostupné, pokud chybí požadovaná data o aktérovi nebo profilu; viz BR-ScoringAndRiskGating)
- Rozpad low-risk skóre (strukturované; nepovinné; příspěvky jednotlivých složek tvořících low-risk
  skóre)
- Hodnotící uživatel (reference na EN0008 – Uživatel; nepovinné; administrátor, který provedl ruční
  hodnocení)
- Čas záznamu hodnocení (časové razítko; systémově spravované)
- Čas přiřazení hodnocení (časové razítko; nepovinné)

### Uživatelem zadávané atributy

- Rizikové pole dárce (strukturované; podmíněné; vstupy hodnocení týkající se dárce, hodnoty: ok/ko
  pro každé pole)
- Rizikové pole patrona (strukturované; podmíněné; vstupy hodnocení týkající se patrona, hodnoty:
  ok/ko pro každé pole)
- Rizikové pole daru (strukturované; podmíněné; vstupy hodnocení týkající se daru, hodnoty: ok/ko pro
  každé pole)
- Poznámka koordinátora (text; nepovinné)
- Rozhodnutí koordinátora (boolean; nepovinné)
- Verdikt schválení (řetězec; povinné pro ruční hodnocení; odeslané scoringové rozhodnutí, např.
  schváleno/neschváleno/mezistav; podmiňuje přechod žádosti, viz BR-ScoringAndRiskGating)
- Klasifikace blacklistu (reference na EN0016 – Blacklist; podmíněné; klasifikace zvolená pro dárce
  a/nebo patrona v průběhu hodnocení)

---

## Invarianty

- Ruční hodnocení a low-risk hodnocení jsou nezávisle udržované reprezentace scoringu téže žádosti a
  mohou existovat obě zároveň, aniž by jedna nahrazovala druhou; viz BR-ScoringAndRiskGating.
- Postup stavu žádosti v důsledku scoringu je podmíněn pravidly definovanými v
  BR-ScoringAndRiskGating (podmínka verdiktu schválení a přepis koordinátorem přes low-risk práh),
  nikoli samotným ScoringRecordem.
- Klasifikace blacklistu vzniklá při hodnocení se promítá do záznamu kontaktu (EN0006); rozsah a
  rizikové charakteristiky tohoto promítání upravuje BR-ScoringAndRiskGating.
- Nečinný nosič hodnocené entity není naplňován žádným současným procesem; viz Otevřené otázky.

---

## Vztahy

- EN0001 – Žádost (entita, ke které je scoringové hodnocení a low-risk skóre připojeno)
- EN0002 – Profil žádosti (data profilu dárce/patrona využívaná k výpočtu hodnocení)
- EN0006 – Kontakt (záznam osoby, jejíž klasifikace blacklistu je vedlejším efektem hodnocení
  aktualizována)
- EN0016 – Blacklist (záznam v rizikovém seznamu vytvořený spolu s ručním hodnocením)

---

## Otevřené otázky

1. Je nečinný nosič hodnocené entity (obecné, na entitě nezávislé úložiště scoringového JSON
   klíčované názvem a identifikátorem hodnocené entity) legacy/opuštěný, nebo je zamýšlen k naplnění
   mimo rozsah nebo externím klientem? Žádný současný proces pro něj záznamy neprodukuje.
   Hypothesis — Not evidenced in current sources.
2. Vztah mezi ručně hodnocenou reprezentací a low-risk hodnocenou reprezentací: jsou obě průběžně
   využívány navazujícími procesy, nebo jedna reprezentace po svém vzniku nahrazuje druhou?
   Conflict — requires clarification.
3. Výpočet low-risk skóre čte vstupy o zaměstnání a platbě daru na straně patrona z profilu dárce
   (EN0002) namísto z profilu patrona — viz BR-ScoringAndRiskGating pro popis provázání vlastníků,
   které to v současném stavu způsobuje.
