---
doc_id: ES0004
title: Moneta
canonical_layer: ES
spec_type: external-system
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0012
  - UC0008
---

# ES0004 – Moneta

## Účel

Moneta poskytuje český bankovní feed informací o účtu (AISP), který platforma pravidelně dotazuje
za účelem importu příchozích bankovních plateb pro účely párování darů. Jde o zdroj důkazu
"peníze dorazily na účet" pro CZ trh, který funkce párování plateb (FN0012) porovnává s očekávanými
dary (UC0008).

---

## Přehled systému

Moneta je česká banka vystavující API pro informace o účtu (AISP), které vrací data o účtu a
transakcích pro účty, k jejichž čtení má platforma oprávnění. V rámci integrační krajiny platformy
jde o jeden z několika bankovních/bránových zdrojů napájejících párování plateb, vedle e-mailové
schránky s bankovními avízy a synchronizace převodů/vypořádání ComGate (ARCH0001 §5). Jde o
integraci pouze pro CZ: nemá žádnou roli v současných tocích pro RO nebo MD.

---

## Integrační model

Příchozí (dotazování). Denní cron pro párování plateb iniciuje odchozí, autentizovaný dotaz vůči
AISP API služby Moneta, omezený na jediný bankovní účet nakonfigurovaný pro platformu; platforma
následně porovná vrácené platby s očekávanými dary (UC0008, dílčí tok UC0008.1). Ze strany Moneta
neexistuje žádný příchozí push/webhook — veškerá interakce je iniciována platformou, jednou denně,
podle cron/CLI řetězce párování plateb v ARCH0002 (řetězec (b)).

---

## Výměna dat

- Odchozí: autentizovaný požadavek určující nakonfigurovaný bankovní účet, následovaný stránkovaným
  dotazem na transakce omezeným na předchozí den ("včerejšek").
- Příchozí: záznamy o příchozích bankovních platebních transakcích pro daný účet a časové okno,
  použité jako vstup pro párování plateb vůči záznamům darů (pouze koncepčně — detail
  entit/atributů náleží EN0009/EN0029 a zde se neopakuje).

---

## Omezení

- Integrace pouze pro CZ — neběží pro RO ani MD (ARCH0001 §5, řádek 4).
- Denní dotazování zapíše značku posledního běhu ještě před provedením samotného stahování a vždy
  dotazuje "včerejšek"; selhání uprostřed běhu proto daný den trvale přeskočí bez opakování pokusu —
  jde o tichou mezeru v párování plateb (ARCH0001 §5, řádek 4, HS05; UC0008 AF1).
- Platba vrácená v jiné měně, než je očekávaná, zastaví zpracování zbytku daného dne importu z
  Moneta (UC0008).
- Popisuje pouze současný stav — integraci tak, jak je dnes implementována, nikoli cílový návrh.
