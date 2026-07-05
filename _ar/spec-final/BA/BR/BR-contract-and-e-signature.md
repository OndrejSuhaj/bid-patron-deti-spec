---
doc_id: BR-ContractAndESignature
title: Contract & E-Signature
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0011
  - EN0001
  - EN0008
  - EN0012
  - EN0004
  - EN0015
  - SYSTEM
references:
  - EN0011
  - EN0012
  - EN0001
  - EN0008
  - EN0004
  - EN0015
  - UC0004
  - UC0010
---

# BR – Smlouva a elektronický podpis

## Účel

Upravuje generování smlouvy, dvoukrokový průběh podepisování, který řídí stav případu, validaci
podpisu vypsáním jména, číslování smluv po jednotlivých letech a současné neatomické a na souběh
náchylné aspekty tohoto průběhu.

---

## Průběh podepisování řídí případ

- Průběh podepisování smlouvy SHALL být vyjádřen prostřednictvím stavu případu: vytvoření/odeslání
  smlouvy (EN0011) SHALL převést vlastnící žádost (EN0001) do stavu smlouva, podpis manažera SHALL
  ji převést do stavu čeká na podpis a podpis fundraisera SHALL ji převést do stavu smlouva
  podepsána žadatelem.
- Smlouva SHALL NOT nést vlastní nezávislý výčet stavů — průběh podepisování SHALL být jediným
  navenek pozorovatelným záznamem o tom, jak daleko smlouva pokročila.
- Vypsané jméno fundraisera u podpisu SHALL odpovídat registrovanému celému jménu fundraisera, aby
  byl podpis přijat; neshodující se vypsané jméno SHALL být odmítnuto a SHALL NOT posunout stav
  žádosti.
- Pouze aktér vedený jako fundraiser dané žádosti SHALL smět provést krok podpisu fundraisera na
  smlouvě této žádosti.

---

## Číslování

- Čitelné číslo smlouvy SHALL být hodnota postupně přidělovaná v rámci jednotlivých let; veřejné
  číslo pro CZ SHALL dále obsahovat variabilní symbol navázané kampaně (EN0004).
- Současný stav: jedinečnost čísla smlouvy SHALL NOT být považována za vynucenou na úrovni dat —
  souběžné generování čísla je náchylné na souběh (current-state gap).

---

## Mezery současného stavu

- Current-state: notifikace o kontrole manažerem SHALL NOT být považována za blokující postup —
  pokud kontrolující příjemce nebo vyrenderovaný dokument nejsou v okamžiku odeslání k dispozici,
  notifikace se přeskočí, zatímco stav žádosti přesto postoupí do kroku kontroly manažerem
  (current-state gap).
- Current-state: přechody stavů řetězce podepisování (vytvoření → podpis manažera → podpis
  fundraisera) SHALL NOT být považovány za obalené transakcí — selhání uprostřed sekvence může
  ponechat smlouvu a stav její vlastnící žádosti v částečně dokončené, nekonzistentní kombinaci
  (current-state gap).

---

## Párování RO daňového přesměrovacího prohlášení

- Záznam RO daňového poplatníka pro přesměrování daně (EN0015) SHALL být spárován s právě jednou
  přesměrovací smlouvou (EN0011).
- Current-state: RO daňové přesměrovací prohlášení je samostatný mechanismus a SHALL NOT být
  považováno za znovupoužívající cestu CZ potvrzení o daru — nečte celkovou vyplacenou částku daru
  ani neprodukuje dokument potvrzení o daru (Partial evidence).

---

## Non-Goals

Toto pravidlo nedefinuje samotné notifikační kontrakty kontroly manažerem nebo k podpisu (→
BR-TransactionalMessaging). Nedefinuje slovník stavů žádosti ani obecné řízení přechodů (→
BR-ApplicationStatusGovernance) — na toto řízení odkazuje pouze v souvislosti s výše uvedenými
přechody řízenými smlouvou. Nedefinuje mechaniku generování RO daňového přesměrovacího dokumentu ani
smlouvu CZ daňového potvrzení, které sdílí širší daňovou rodinu s BR-DonationConfirmationAndTax.
Neopakuje atributy entit Smlouva, ContractTemplate, Žádost, User ani TaxPayer (→ EN0011, EN0012,
EN0001, EN0008, EN0015) ani krok-za-krokem tok smlouvy/podepisování (→ UC0004, UC0010).
