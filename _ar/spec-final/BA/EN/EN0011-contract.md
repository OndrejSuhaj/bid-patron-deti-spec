---
doc_id: EN0011
title: Contract
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0001  # Application — owns the contract/delivery_note/acceptance_protocol/appendix references
  - EN0012  # ContractTemplate — source of generated content
  - EN0008  # User — owner
  - EN0015  # TaxPayer — RO tax-redirect pairing
  - BR-ContractAndESignature
---

# EN0011 — Smlouva

## Účel

Generovaný právní dokument (darovací smlouva, protokol o převzetí daru, dodatek, nájemní smlouva
apod.) náležející k žádosti (EN0001). Každá smlouva nese vyrenderovaný obsah dokumentu, dle země
čitelné číslo smlouvy pro člověka a prochází dvoukrokovým elektronickým podpisem (nejprve manažer,
poté fundraiser). Každé podepsání vytváří novou revizi dokumentu.

---

## Životní cyklus

- Vytvořeno (nepodepsáno)
- Podepsáno manažerem
- Podepsáno fundraiserem

Smlouva nemá vlastní samostatné pole stavu — viz Invarianty (BR-ContractAndESignature). Výše uvedené
stavy jsou vyjádřeny přítomností podpisového razítka manažera v obsahu dokumentu a následně vyplněným
záznamem elektronického podpisu a potvrzovacím dokumentem.

---

## Přechody stavů

Vytvořeno (nepodepsáno) → Podepsáno manažerem
trigger: UC0004.2 (Správa smlouvy a podpisu — kontrola a podpis manažerem)

Podepsáno manažerem → Podepsáno fundraiserem
trigger: UC0004.3 (Správa smlouvy a podpisu — elektronický podpis fundraisera)

Tytéž přechody synchronně řídí stav nadřazené žádosti (EN0001) (viz BR-ContractAndESignature;
hlavní tok UC0004, FLW0008).

---

## Atributy

### Atributy spravované systémem

- public_id (řetězec; jen ke čtení; dle země čitelné číslo smlouvy pro člověka; viz Invarianty)
- int_id (celé číslo; jen ke čtení; sekvenční čítač v rámci roku, na kterém je založeno `public_id`;
  viz Invarianty)
- obsah dokumentu (generovaný obsah vytvořený ze šablony smlouvy — EN0012 — s dosazenými údaji ze
  žádosti / profilu žádosti; nejde o pole vyplňované uživatelem)
- vyrenderovaný dokument (generovaný PDF soubor vytvořený z obsahu dokumentu)
- digital_signature (záznam elektronického podpisu; obsahuje podpisová data fundraisera a hash
  integrity obsahu; vyplní se po dosažení stavu podepsáno fundraiserem)
- digital_signature_confirmation (generovaný potvrzovací dokument obsahující ověřovací kód, vytvořený
  po dosažení stavu podepsáno fundraiserem)
- příznak publikace (boolean; výchozí hodnota publikováno; nesouvisí s postupem podepisování — viz
  Invarianty)

### Atributy vyplňované uživatelem

- name (krátký text; povinné; popisek entity)
- attachment_contract (příloha/přílohy typu obrázek; nepovinné; nahrané skeny podepsané smlouvy)
- attachment_gift_proof (příloha/přílohy typu obrázek; nepovinné; nahrané skeny podepsaného protokolu
  o převzetí)
- napsané jméno fundraisera k podpisu (odesláno v kroku elektronického podpisu fundraisera; validuje
  se, ale neukládá se jako samostatné pole — viz Invarianty)

---

## Invarianty

- Smlouva nemá vlastní samostatné pole stavu kromě příznaku publikace; postup podepisování je
  pozorovatelný pouze přes přítomnost/obsah výše uvedených polí — viz BR-ContractAndESignature.
- Postup podepisování řídí stav nadřazené žádosti (EN0001) — viz BR-ContractAndESignature.
- Napsané jméno fundraisera k podpisu musí odpovídat registrované identitě fundraisera, aby bylo možné
  dosáhnout stavu podepsáno fundraiserem — viz BR-ContractAndESignature.
- Krok podpisu fundraisera může provést pouze fundraiser vedený u dané žádosti — viz
  BR-ContractAndESignature.
- Číslování `public_id`/`int_id` je sekvenční v rámci roku a jedinečnost v aktuálním stavu není při
  souběžném generování zaručena — viz BR-ContractAndESignature.
- Postup podepisování (vytvoření → podpis manažera → podpis fundraisera) není v aktuálním stavu
  zaručeně atomický — viz BR-ContractAndESignature.

---

## Vztahy

- EN0001 (Žádost) — vlastnící agregát; odkazováno jako `contract`, `delivery_note`,
  `acceptance_protocol` nebo `appendix` žádosti
- EN0012 (ContractTemplate) — zdrojová šablona pro generovaný obsah dokumentu
- EN0008 (Uživatel) — vlastník
- EN0015 (TaxPayer) — RO varianta přesměrování daně páruje záznam TaxPayer s právě jednou smlouvou o
  přesměrování — viz BR-ContractAndESignature

---

## Otevřené otázky

1. Číslování `public_id`/`int_id` nemá potvrzené omezení jedinečnosti na úrovni dat — chování při
   souběžném generování není vyřešeno (mezera v aktuálním stavu; viz BR-ContractAndESignature).
2. Existuje stav smlouvy „zrušeno/neplatné", nebo se nahrazení provádí čistě přesměrováním odkazu
   žádosti spolu s novými revizemi smlouvy? Nedoloženo.
3. Zda může smlouva platně dosáhnout stavu podepsáno fundraiserem bez přítomného vyrenderovaného
   dokumentu (což ovlivňuje, co pokrývá hash integrity záznamu podpisu), není v aktuální evidenci
   vyřešeno.
