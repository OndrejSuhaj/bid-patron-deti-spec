---
doc_id: FN0005
title: External Registry & Identity Verification
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0003
  - EN0001
  - EN0006
---

# FN0005 – Externí registry a ověření identity

## Účel

Ověřit identitu žadatele a údaje o podnikatelské činnosti vůči externím vládním/registrovým zdrojům během
risk assessmentu — CZ dotaz do registru podnikatelských subjektů (ARES) a CZ ověření neplatnosti dokladu /
občanského průkazu (MVČR) — tak, aby scoring (FN0004) mohl na základě ověřených dat případ propustit nebo
zastavit. Sdružuje obě hranice ověřovacích adaptérů do jedné capability.

## Odpovědnosti

- Provést dotaz do registru podnikatelských subjektů (ARES) podle IČO za účelem obohacení/ověření údajů
  o organizaci a podnikatelské činnosti žadatele během scoringu.
- Provést kontrolu platnosti identifikačního dokladu (MVČR) za účelem odhalení neplatných/blokovaných
  dokladů v rámci risk gate.
- Vrátit výsledky ověření capabilitě scoringu (FN0004); každý dotaz je vyvolán živě pro danou žádost —
  žádná cachovací vrstva není doložena.

## Související případy užití

UC0003 (scoringové dotazy).

## Související entity

EN0001 (posuzovaný případ), EN0006 (strana, jejíž identita/podnikatelská činnost je ověřována).

## Integrace

ARES (CZ registr podnikatelských subjektů), MVČR (CZ kontrola neplatnosti dokladu / občanského průkazu).

## Omezení

- Registry jsou omezeny na CZ; pro RO/MD není doloženo žádné rovnocenné ověření.
- Dotaz do ARES nemá na volání nastaven timeout — zaseknutý registr může zablokovat obalující požadavek.
- Selhání degraduje risk gate, ale neblokuje jej (nedostupnost ověření je tolerována).
