---
doc_id: EN0030
title: ComgateBankReconciliation
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0009  # Transaction — the money record the settlement logically reconciles
  - EN0008  # User — owner of the settlement record
  - BR-BankReconciliationAndMatching
  - UC0008  # Reconcile Bank Transactions
---

# EN0030 — Vypořádání ComGate -> banka

## Účel

Reprezentuje účetní záznam o vypořádání převodu prostředků z platební brány na bankovní účet,
vytvářený ve chvíli, kdy účetní ručně zaúčtuje přesun prostředků od platební brány na bankovní účet.
Existuje proto, aby účetní evidence měla vlastní záznam o události vypořádání, oddělený od peněžních
záznamů (Transakce, EN0009), které toto vypořádání fakticky páruje.

Samotná entita nenese žádný obsah vypořádání (částku, identifikátor výplaty od brány, časové rozmezí
ani odkaz na spárované transakce) — viz Otevřené otázky. Vlastní efekt párování (označení transakcí
jako bankovně vypořádaných) se aplikuje přímo na záznamy Transakce (EN0009) a touto entitou není
zprostředkován; pravidlo párování/zaúčtování viz BR-BankReconciliationAndMatching a use case
vypořádání viz UC0008.

---

## Životní cyklus

- Vytvořeno
- Publikováno / Nepublikováno (jednoduchý příznak viditelnosti; nejde o stav workflow)

Žádné další stavy životního cyklu nejsou doloženy.

---

## Přechody stavů

(žádný) → Vytvořeno
trigger: UC0008 (ruční zaznamenání vypořádání, hranice dílčího toku UC0008.3 — viz Vztahy a
Otevřené otázky; samotné vytvoření záznamu je ruční účetní akce, nikoli automatizovaný krok
samotného UC0008.3)

Vytvořeno → Publikováno / Nepublikováno
trigger: není doloženo jako samostatný přechod; příznak publikování se nastavuje při vytvoření
(výchozí: Publikováno) bez potvrzené cesty k jeho následné změně.

Žádné další přechody (např. archivace, smazání) nejsou doloženy.

---

## Atributy

### Systémem spravované atributy

- Vlastník (odkaz na EN0008 – Uživatel; povinné; výchozí hodnota je aktuální uživatel v okamžiku vytvoření)
- Časové razítko vytvoření (datetime; povinné)
- Časové razítko poslední změny (datetime; povinné)

### Uživatelem zadávané atributy

- Popisek (text; nepovinné; krátký volný text pojmenovávající záznam vypořádání)
- Publikováno (boolean; povinné; výchozí: Publikováno; příznak viditelnosti bez dalšího významu pro workflow)

---

## Invarianty

- Jak je vypořádání od brány spárováno a zaúčtováno proti Transakci (EN0009), viz
  BR-BankReconciliationAndMatching — toto pravidlo řídí efekt párování, nikoli vlastní pole této entity.
- Kromě standardní přítomnosti polí entity není pro vlastní atributy této entity doložen žádný další invariant.

---

## Vztahy

- EN0008 – Uživatel (vlastník záznamu o vypořádání)
- EN0009 – Transakce (logicky spárovaná vypořádáním, které tato entita zaznamenává; žádný atribut
  této entity ji nepropojuje s konkrétními transakcemi, které pokrývá — viz Otevřené otázky)

---

## Otevřené otázky

1. Doklady k vlastním datům této entity se omezují na vlastníka, popisek a příznak publikování — jaký
   obsah vypořádání (částku, identifikátor výplaty od brány, časové rozmezí) akce zaznamenání ve
   skutečnosti zachycuje a zda je ukládán na této entitě, nebo je aplikován pouze na Transakci
   (EN0009), zůstává nevyřešeno.
2. Žádný atribut nespojuje tuto entitu s konkrétní transakcí/transakcemi, které páruje — jak je
   záznam o vypořádání přiřazován k platbám, které pokrývá, zůstává nevyřešeno.
3. Zda je tato entita pouze auditní záznam doprovázející samostatný efekt párování na Transakci,
   nebo zda akce zaznamenání ukládá bohatší data, která nejsou v kanonických dokladech zachycena,
   zůstává nevyřešeno — Conflict/Uncertain, tímto kanonizačním průchodem nevyřešeno.
