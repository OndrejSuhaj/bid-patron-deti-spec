---
doc_id: ES0011
title: MVČR (invalid-document check)
canonical_layer: ES
spec_type: external-system
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0005
  - UC0003
---

# ES0011 – MVČR (kontrola neplatných dokladů)

## Účel

MVČR poskytuje risk gate autoritativní signál o tom, zda je český doklad totožnosti/občanský průkaz
uvedený na žádosti evidován jako neplatný, aby scoring (`FN0005`) mohl zohlednit výsledek státní
validace platnosti dokladu v rámci rizikového rozhodnutí o žadateli, aniž by byla platforma sama
autoritou pro platnost dokladů.

---

## Přehled systému

MVČR je registr neplatných dokladů Ministerstva vnitra České republiky — státní registr, který u
daného dokladu totožnosti sděluje, zda je tento doklad aktuálně evidován jako neplatný. Jde o jednu
z hranic státních registrů uvedených v Integration Landscape (`ARCH0001` §5, řádek 12; rovněž uvedeno
mezi „státními registry" v `ARCH0001` §2), seskupenou s `ARES` pod stejnou rolí CZ registru/ověření
identity ve `FN0005`, ale jde o samostatnou externí hranici odlišnou od ARES — MVČR odpovídá na otázku
platnosti dokladu, ARES odpovídá na otázku týkající se obchodního rejstříku.

---

## Integrační model

Odchozí. Platforma provádí dotaz na platnost dokladu vůči MVČR jako součást identitní kontroly v
rámci scoringu (`UC0003`), v okamžiku, kdy jsou validována čísla občanských průkazů uvedená na
žádosti. Jde o synchronní, on-demand volání prováděné během scoringu (`ARCH0002` (a) synchronní
externí), nikoli o plánovanou nebo obousměrnou výměnu — z MVČR do Patronusu neexistuje žádný příchozí
callback ani feed.

---

## Výměna dat

Odchozí: identifikátor občanského průkazu/dokladu ke kontrole, odesílaný za strany uvedené na žádosti
v průběhu scoringu. Příchozí: indikace neplatnosti/platnosti daného dokladu. Jde pouze o koncepční
popis — nejsou zde uváděny žádné detaily požadavku/odpovědi na úrovni jednotlivých polí; identitní
data, vůči kterým je kontrola prováděna, vlastní `EN0006` a nejsou v tomto dokumentu znovu popisována.

---

## Omezení

- **Dopad výpadku:** není-li kontrola platnosti dokladu dostupná, risk gate je degradován, nikoli
  blokován — scoring pokračuje bez potvrzeného výsledku platnosti dokladu (`ARCH0001` §5 řádek 12;
  `UC0003`).
- **Rozsah:** platí pouze pro CZ; pro RO ani MD neexistuje ekvivalent této kontroly (`FN0005`).
- **Odlišnost hranice:** je součástí clusteru adaptérů CZ registru/ověření identity dokumentovaného
  jako jedna schopnost ve `FN0005`, avšak MVČR je samostatná externí hranice odlišná od `ARES` — obě
  se nesmí sloučit do jediného ES.
- **Pouze současný stav:** tento dokument odráží integraci tak, jak je doložena dnes; není zde
  uváděna žádná změna cílového stavu.
