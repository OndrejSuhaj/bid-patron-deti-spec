---
doc_id: ARCH0008
title: Documents & Fulfilment Domain
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - EN0011
  - EN0012
  - EN0014
  - EN0015
  - EN0019
  - EN0020
  - EN0024
  - UC0004
  - UC0010
  - UC0019
  - FN0009
  - FN0013
  - FN0017
  - ES0013
  - MSG0026
  - MSG0027
  - MSG0028
  - BR-ContractAndESignature
  - BR-DonationConfirmationAndTax
---

# ARCH0008 – Doména dokumentů a plnění

> Navigační dokument domény pro ohraničený kontext **C6 Documents & Fulfilment** (ARCH0001 §4).
> Pouze navigační vrstva — odkazuje na hlubší artefakty pomocí `doc_id`, neopakuje jejich obsah. Current-state.

## Účel

Vysvětluje architektonický pohled na **vrstvu právních a fiskálních dokumentů**: jak se generuje a
elektronicky podepisuje darovací smlouva, jak vznikají CZ daňová potvrzení a RO deklarace přesměrování
2 % daně, a jak se z externího úložiště importují podpůrné faktury. Tyto dokumenty podmiňují a
zaznamenávají přechod ze schválené žádosti do živého, financovaného příběhu.

---

## Přehled systému

C6 generuje darovací smlouvu ze šablony s dvoukrokovým elektronickým podpisem, jehož průběh zpětně
řídí stav vlastnící žádosti v C1 ([EN0011](../EN/EN0011_Contract.md); ARCH0002 §(c)).
Dále vytváří neměnný CZ snímek potvrzení o daru (Potvrzení o daru) vypočtený z uhrazených
darů, RO záznam daňového poplatníka pro přesměrování daně a stahuje PDF faktury z externího úložiště
pro přiložení k žádostem ([ARCH0001](../ARCH0001_ApplicationOverview.md) §4, §5). Kontext dále obsahuje
marketingové/redakční obsahové entity (seznam partnerů, vlastní blog) a registr dodavatelů, na který
odkazují další domény. Několik dokumentových akcí je podmíněno zemí a probíhá na bázi best-effort (stav
postoupí i v případě, že chybí příjemce notifikace nebo PDF — ARCH0001 §5, FN0009).

---

## Strukturální komponenty

- **Document-Generation-&-Fulfilment** (doménová služba) — vykreslení smlouvy + elektronický podpis,
  daňové doklady, plnění poukazů/dokumentů. Kapacity:
  [FN0009](../FN/FN0009_ContractGenerationSignature.md) (smlouva),
  [FN0013](../FN/FN0013_DonationConfirmationTaxDocument.md) (daňové doklady).
- **OneDrive-Graph-Adapter** (integrační adaptér) — CLI import faktur z externího úložiště.
  Kapacita: [FN0017](../FN/FN0017_DocumentImportOneDrive.md).
- **Rezidentní agregáty** — AG5 Contract (kořen [EN0011](../EN/EN0011_Contract.md)); AG10
  DonationConfirmation ([EN0014](../EN/EN0014_DonationConfirmation.md), write-once CZ daňový snímek);
  AG11 TaxPayer ([EN0015](../EN/EN0015_TaxPayer.md), write-once RO záznam přesměrování daně).
- **Referenční / obsahové entity** — ContractTemplate ([EN0012](../EN/EN0012_ContractTemplate.md)),
  registr dodavatelů Supplier ([EN0019](../EN/EN0019_Supplier.md)), seznam partnerů Partner
  ([EN0020](../EN/EN0020_Partner.md)), vlastní Blog ([EN0024](../EN/EN0024_Blog.md)).

---

## Interakční model

Dle [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(b)/(c):

- Vytvoření smlouvy je vyvoláno **synchronně** ze stavového rozhraní **C1** ve stavu podpisu, a
  každý krok podpisu zapisuje stav žádosti zpět do **C1**
  ([UC0004](../UC/UC0004_ManageContractAndSignature.md); ARCH0002 §(c)).
- Potvrzení o daru čte uhrazené transakce z **C4** pro výpočet potvrzené celkové částky a volitelně
  propojuje kampaň z **C3** ([UC0010](../UC/UC0010_IssueDonationConfirmation.md)).
- Import faktur je CLI-spouštěné příchozí stažení z Microsoft Graph / OneDrive, které se připojuje
  k žádosti v **C1** (opětovný vstup do rozvětvení stavů) ([UC0019](../UC/UC0019_ImportInvoicesFromOneDrive.md);
  [ES0013](../ES/ES0013_MicrosoftGraphOneDrive.md); ARCH0002 §(b)).
- Zprávy týkající se smlouvy a daní jsou odesílány prostřednictvím **C8** (kontrola manažerem,
  životní cyklus podpisu, daňové potvrzení).

---

## Provazby (cross-links)

- **relatedEN:** EN0011, EN0012, EN0014, EN0015, EN0019, EN0020, EN0024
- **relatedUC:** UC0004, UC0010, UC0019
- **relatedFN:** FN0009, FN0013, FN0017
- **relatedES:** ES0013 (Microsoft Graph / OneDrive)
- **relatedMSG:** MSG0026, MSG0027, MSG0028 (smlouva a daně; přenos vlastní C8)
- **relatedBR:** BR-ContractAndESignature
  ([../BR/BR-ContractAndESignature.md](../BR/BR-ContractAndESignature.md)),
  BR-DonationConfirmationAndTax ([../BR/BR-DonationConfirmationAndTax.md](../BR/BR-DonationConfirmationAndTax.md))

> **Poznámka k navigaci.** Obsahové/referenční entity EN0019/EN0020/EN0024 nemají žádný transakční
> životní cyklus (DOMAIN-aggregates §3); jsou zde zařazeny jako plnění dokumentů/obsahu, aby byla
> navigovatelná každá EN entita, nikoli proto, že by nesly dokumentové chování.
