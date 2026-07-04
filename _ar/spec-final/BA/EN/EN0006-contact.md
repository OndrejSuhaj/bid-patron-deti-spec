---
doc_id: EN0006
title: Contact
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0001 (Application)
  - EN0002 (ApplicationProfile)
  - EN0008 (User)
  - EN0018 (Organisation)
  - EN0023 (UserNote)
  - BR-PartyIdentityAndDeduplication
  - BR-ScoringAndRiskGating
  - BR-DataProtectionAndErasure
  - UC0001
  - UC0003
  - UC0016
---

# EN0006 — Kontakt

## Účel

Kontakt je univerzální záznam subjektu (party) pro doménu: jednotné úložiště reprezentující jakoukoli
osobu nebo instituci, která se účastní případu — dítě, žadatel/fundraiser, patron, škola, zaměstnavatel
nebo dosud nekvalifikovaný lead — rozlišené pomocí diskriminátoru role. Nese osobní údaje subjektu
(jméno, rodné číslo/národní identifikační číslo, telefon, e-mail, adresu) a rizikovou/blacklistovou
klasifikaci udržovanou scoringovým procesem. Případy a profily případů odkazují na Kontakt pro
zúčastněné osoby a instituce; Kontakt může být volitelně propojen s Uživatelem (účtem, přes který
subjekt přistupuje do systému) a s volným textovým anotačním záznamem.

---

## Životní cyklus

- Aktivní — normální stav Kontaktu od jeho vzniku; samostatné rozlišení publikováno/nepublikováno není
  považováno za doménový stav životního cyklu (viz Atributy ohledně příznaku publikace).
- Sloučeno-zaniklý (terminální) — prohrávající záznam při sloučení duplicit; záznam je odstraněn,
  nikoli ponechán v neaktivním stavu (viz BR-PartyIdentityAndDeduplication).

Otevřená otázka: zda pro Kontakt existuje trvalý stav „vymazáno" nebo „archivováno", není vyřešeno —
viz Invarianty a Otevřené otázky níže.

---

## Přechody stavů

(žádný) → Aktivní
trigger: UC0001 — Podání žádosti (samoregistrace, nebo Admin povýší data profilu případu na
Kontakt/Uživatele)

Aktivní → Aktivní (aktualizována riziková klasifikace)
trigger: UC0003 — Vyhodnocení rizika žadatele (Scoring); viz BR-ScoringAndRiskGating pro zápis
klasifikace a jeho riziko napříč subjekty (cross-party hazard)

Aktivní → Aktivní (reference přesměrovány na přežívající Kontakt)
trigger: UC0016 — Správa záznamů subjektů (Dedup / sloučení)

Aktivní → Sloučeno-zaniklý (terminální)
trigger: UC0016 — Správa záznamů subjektů (Dedup / sloučení); viz BR-PartyIdentityAndDeduplication
ohledně destruktivní, netransakční povahy tohoto přechodu

---

## Atributy

### Systémem spravované atributy

- Diskriminátor role (výčtový typ; povinný; rozlišuje žadatele/fundraisera, sekundární adresu
  žadatele, kontakt na zaměstnavatele žadatele, dítě, školu, patrona, lead nebo nedefinováno — určuje,
  která role/role případu může na tento Kontakt odkazovat)
- Druh subjektu (výčtový typ; povinný; osoba nebo instituce; výchozí hodnota je osoba)
- Riziková klasifikace (výčtový typ; volitelný; hodnoty odpovídající statusu whitelist/greylist/
  blacklist; zapisuje scoringový proces — viz BR-ScoringAndRiskGating; nejedná se o stav životního
  cyklu)
- Příznak publikace (boolean; povinný; výchozí hodnota aktivní/publikováno; není považován za doménový
  stav životního cyklu)
- Formát zobrazovaného jména (výčtový typ; volitelný; celé / zkrácené / skryté)

### Uživatelem zadávané atributy

- Jméno / příjmení (text; povinné pro Kontakt typu osoba)
- Rodné číslo / IČO (text; volitelné; používá se jako kritérium pro shodu při deduplikaci — viz
  BR-PartyIdentityAndDeduplication)
- Telefon (text; volitelný; není jedinečný; používá se jako kritérium pro shodu při deduplikaci)
- E-mail (text; volitelný; používá se jako kritérium pro shodu při deduplikaci a jako klíč pro zápis
  scoringové klasifikace — viz BR-ScoringAndRiskGating)
- Ulice / PSČ (text; volitelné)
- Město (odkaz na referenční záznam lokality; volitelný)
- Titul před jménem / titul za jménem (text; volitelné)

Otevřená otázka: odvozené datum narození a odvozený indikátor pohlaví jsou v záznamu přítomny, ale
jejich naplnění z rodného čísla není potvrzeno jako aktivní — důkazy jsou Partial.

---

## Invarianty

- Identita subjektu (party) není vynucena jako jedinečná — viz BR-PartyIdentityAndDeduplication.
- Reference z případu nebo profilu případu na Kontakt jsou pouze měkké reference (soft references) —
  viz BR-PartyIdentityAndDeduplication.
- Zápis rizikové klasifikace na Kontakt je klíčován e-mailem a není omezen na jediný odpovídající
  záznam — viz BR-ScoringAndRiskGating.
- Kontakt odstraněný jako prohrávající strana při sloučení duplicit je smazán přímo, místo aby prošel
  cestou výmazu — viz BR-DataProtectionAndErasure a BR-PartyIdentityAndDeduplication.
- Osobní údaje Kontaktu nejsou kaskádovitě zpracovány use case GDPR výmazu — viz
  BR-DataProtectionAndErasure.

---

## Vztahy

- EN0001 (Application) — odkazuje na tento Kontakt pro role dítěte a kontaktní osoby leadu v případu.
- EN0002 (ApplicationProfile) — odkazuje na tento Kontakt pro role žadatele, sekundární adresy
  žadatele, zaměstnavatele žadatele, dítěte, školy a patrona.
- EN0008 (User) — Kontakt může být propojen s Uživatelským účtem, přes který subjekt přistupuje do
  systému; Uživatel odkazuje zpět na svůj vlastnící Kontakt.
- EN0018 (Organisation) — Organizace drží referenci na Kontakt.
- EN0023 (UserNote) — Kontakt může mít jeden propojený volný textový anotační záznam.

---

## Otevřené otázky

- Zápis scoringové klasifikace je klíčován e-mailem bez omezení počtu odpovídajících záznamů — může
  neúmyslně ovlivnit i jiné Kontakty než zamýšlený subjekt? (viz BR-ScoringAndRiskGating)
- Jaká jsou přesná pravidla řídící přechody mezi hodnotami rizikové klasifikace? Důkazy jsou Partial.
- Vzhledem k tomu, že GDPR výmaz nekaskáduje do osobních údajů Kontaktu (viz
  BR-DataProtectionAndErasure), jaká je případná cesta jejich vyřazení?
- Je naplnění odvozeného data narození/pohlaví z rodného čísla aktivní, současně platné chování, nebo
  je nevyužívané? Důkazy jsou Partial.
