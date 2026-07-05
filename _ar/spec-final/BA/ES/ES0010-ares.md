---
doc_id: ES0010
title: ARES
layer: ES
spec_type: external-system
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0005
  - UC0003
---

# ES0010 – ARES

## Účel

ARES je integrován za účelem vyhledání dat českého registru firem pro dané identifikační číslo
společnosti během risk scoringu, aby manuální scoringový proces mohl ověřit údaje o
organizaci/zaměstnavateli uvedené v žádosti. Jedná se o jeden z odchozích cílových systémů uvedených
v Integration Landscape (`ARCH0001` §5, řádek 11).

---

## Přehled systému

ARES je český veřejný registr firem — vládou provozovaná vyhledávací služba, která vrací registrační
údaje o společnosti pro dané identifikační číslo (IČO). Patronus jej využívá jako registrovou
věštírnu (oracle); sám o sobě neuchovává žádná doménová data Patronusu a nehraje žádnou jinou roli
kromě zodpovězení tohoto dotazu.

---

## Integrační model

Odchozí: platforma volá ARES synchronně ze scoringového procesu, spuštěného AJAX dotazem na obrazovce
scoringu (`FN0005`; `UC0003`), odděleně od vlastního zpracování odeslání scoringového formuláře.
`ARCH0002` umísťuje toto volání do kontextu Scoring-&-Risk, synchronně s požadavkem, který jej
vyvolává (§(a) Synchronní volání).

Tato hranice je vymezena pouze na CZ — neexistuje žádný doložený ekvivalent registrového vyhledávání
pro RO/MD (`ARCH0001` §5, řádek 11).

---

## Výměna dat

- **Odchozí:** identifikační číslo společnosti (IČO) k vyhledání.
- **Příchozí:** záznam z registru firem pro danou entitu.

Pouze koncepční úroveň — zde není uváděn žádný detail na úrovni payloadu nebo polí; data
organizace/žadatele, která tato integrace obohacuje nebo ověřuje, vlastní `EN0006` (Kontakt) a
`EN0018` (Organizace).

---

## Omezení

- **Dopad selhání:** volání nemá nastavený timeout, takže zaseknutá odpověď registru může zablokovat
  navazující scoringový požadavek (`ARCH0001` §5, řádek 11).
- **Rozsah pouze CZ:** pro toto registrové vyhledávání neexistuje žádný ekvivalent RO/MD.
- **Pouze hraniční role:** tato integrace provádí výhradně vyhledávání v registru firem — spadá pod
  stejnou capability jako CZ kontrola neplatných dokladů/identity (MVČR) (`FN0005`), ale jde o
  samostatnou externí hranici odlišnou od ní.
- **Pouze current-state:** toto odráží integraci tak, jak je doložena dnes; zde není uváděna žádná
  target-state změna.
