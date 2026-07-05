---
doc_id: ES0012
title: Nager.Date
layer: ES
spec_type: external-system
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0006
  - UC0011
---

# ES0012 – Nager.Date

## Účel

Nager.Date poskytuje kalendář rumunských státních svátků, který platforma využívá k ověření, že
termín kampaně/příběhu připadá na pracovní den. Slouží k zodpovězení jediné úzce vymezené otázky –
„je toto datum státním svátkem?“ – pro pravidlo termínu na trhu RO, aniž by si Patronus musel
udržovat vlastní kalendář svátků.

---

## Přehled systému

Nager.Date je služba poskytující kalendář státních svátků: na základě zadaného data a země sdělí,
zda je toto datum v dané zemi státním svátkem. Jde o jeden z odchozích externích systémů uvedených
v Integration Landscape (`ARCH0001` §5, řádek 17) a v řetězci kontext→externí systém pro kontext
Campaign-&-Story (`ARCH0002`).

---

## Integrační model

Odchozí, synchronní dotaz. Platforma volá Nager.Date v okamžiku, kdy je upravován a ukládán termín
kampaně/příběhu vázaný na RO – jako součást validace tohoto pole – nikoli v rámci plánované
úlohy/cron jobu. Výsledky si platforma ukládá do mezipaměti (cache) na dlouhou dobu a samotné volání
probíhá s krátkým timeoutem odpovídajícím kontrole prováděné v okamžiku validace, nikoli
synchronizaci na pozadí (`ARCH0001` §5 řádek 17; `ARCH0002` řetězce kontext→externí systém).

---

## Výměna dat

- **Odchozí (Patronus → Nager.Date):** datum k ověření spolu s rozsahem země (Rumunsko).
- **Příchozí (Nager.Date → Patronus):** informace o tom, zda je dané datum státním svátkem
  (koncepčně ano/ne).

Žádná další data se nevyměňují; výměna je omezena pouze na toto určení pracovního dne.

---

## Omezení

- **Rozsah:** pouze Rumunsko; kontrola se vztahuje výhradně na pravidlo termínu kampaně/příběhu
  pro RO (`ARCH0001` §5 řádek 17; `FN0006`).
- **Dopad selhání typu fail-open:** pokud je Nager.Date nedostupný nebo dotaz selže, je dané datum
  považováno za pracovní den a pravidlo pracovního dne pro RO je tiše obejito, místo aby akci
  zablokovalo – jde o mezeru současného stavu, nikoli o navrženou výjimkovou cestu (`ARCH0001` §5
  řádek 17; `ARCH0002` – označeno jako fail-open v řetězci kontext→externí systém; `FN0006`;
  `UC0011`).
- **Časování:** dotaz probíhá synchronně při úpravě/uložení termínu (validace pole); není součástí
  žádné plánované úlohy.
- **Platí pouze pro současný stav:** tento dokument popisuje roli Nager.Date tak, jak je dnes
  integrována; business pravidlo pracovního dne, které tento systém napájí daty, je vlastněno a
  popsáno v `FN0006` / `UC0011` a zde se neopakuje.
