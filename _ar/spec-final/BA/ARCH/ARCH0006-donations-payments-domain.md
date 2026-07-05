---
doc_id: ARCH0006
title: Donations & Payments Domain
layer: ARCH
spec_type: architecture
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - EN0009
  - EN0010
  - EN0013
  - UC0005
  - UC0006
  - UC0007
  - UC0009
  - FN0007
  - FN0008
  - FN0010
  - FN0011
  - ES0001
  - ES0002
  - ES0003
  - MSG0019
  - MSG0020
  - MSG0021
  - MSG0022
  - MSG0023
  - MSG0024
  - MSG0025
  - BR-PaymentAndMoneyIntegrity
  - BR-PaymentGatewayCallbacks
  - BR-RecurringDonationPolicy
  - BR-VoucherPolicy
---

# ARCH0006 – Doména darů a plateb

> Navigační dokument domény pro ohraničený kontext **C4 Dary a platby** (ARCH0001 §4).
> Pouze navigační vrstva — odkazuje na hlubší artefakty pomocí `doc_id`, neopakuje jejich obsah. Current-state.

## Účel

Vysvětluje architektonický pohled na **peněžní uzel**: jak je každá příchozí platba — jednorázový dar,
firemní dar, trvalý dar nebo nákup poukazu — zachycena přes regionální bránu, potvrzena přes
callback a dovedena do stavu PAID, což je jediný nejzávažnější přechod na celé platformě. Jde
o třetí primární doménový koncept (ARCH0001 §1) a zdroj většiny mezidoménových kaskád.

---

## Přehled systému

C4 vlastní záznam transakce a jeho platební stav
(PENDING → AUTHORIZED / PAID / CANCELLED / REFUNDED), rozvrh trvalých darů (subscription) a
předplacený dárkový poukaz (Dobrošek). Architektonickým těžištěm je **první přechod do stavu PAID**,
nejzávažnější save-time kaskáda na platformě: její vícenásobná smlouva vedlejších efektů
(přepočet/rozdělení/aktivace/povýšení/přidělení role/notifikace) a její current-state netransakční,
neidempotentní charakter jsou vlastněny dokumentem
[BR-PaymentAndMoneyIntegrity](../BR/BR-PaymentAndMoneyIntegrity.md), §"Effects on first
transition to PAID" ([ARCH0001](../ARCH0001_ApplicationOverview.md) §7, §8 Risk 1;
ARCH0002 chain A; hazard peněžního uzlu je HS03). Každý region (CZ/RO/MD) obsluhuje jedna platební
brána a callback route je fakticky veřejná bez HMAC (HS12).

---

## Strukturální komponenty

- **Payment-Processing** (doménová služba) — sdílený vstupní bod do stavu PAID a peněžní uzel. Kapacita:
  [FN0007](../FN/FN0007_DonationPaymentProcessing.md).
- **Adaptéry platebních bran** (integrační adaptéry) — tři regionální brány sdružené do jedné
  kapacity. Kapacita: [FN0008](../FN/FN0008_PaymentGatewayIntegration.md).
- **RecurringPayment-Processor** (asynchronní procesor) — periodické strhávání plateb řízené cronem. Kapacita:
  [FN0010](../FN/FN0010_RecurringDonationScheduling.md).
- **Vydávání a uplatnění poukazů** — kapacita: [FN0011](../FN/FN0011_VoucherRedemption.md).
- **Rezidentní agregáty** — AG3 Transaction (kořen [EN0009](../EN/EN0009_Transaction.md); potomek
  pro přeplatek je řádek vzniklý vlastním rozdělením); AG4 RecurringTransaction (kořen
  [EN0010](../EN/EN0010_RecurringTransaction.md), zakládá potomka Transaction); AG6 Voucher (kořen
  [EN0013](../EN/EN0013_Voucher.md)).

---

## Interakční model

Podle [ARCH0002](../ARCH0002_ContextInteractionMap.md) chain A a §(a)/(b)/(c):

- Odchozí-poté-příchozí komunikace s regionálními bránami: checkout daru volá bránu ven; brána
  volá zpět / přesměrovává za účelem potvrzení ([UC0005](../UC/UC0005_MakeADonation.md),
  [UC0006](../UC/UC0006_ConfirmPayment.md); [ES0001](../ES/ES0001_ComGate.md),
  [ES0002](../ES/ES0002_NetopiaMobilPay.md), [ES0003](../ES/ES0003_Maib.md)).
- Při přechodu do PAID se synchronně rozvětvuje do **C3 Campaign** (přepočet + automatické dokončení),
  **C7 Party** (přidělení role patrona), **C8 Messaging** (poděkování) a **C11 Ops** (Slack) — ARCH2 chain A.
- Řeší anonymní dárce převodem na User+Contact přes **C9 Identity & Access** a cílí dar na příslušný
  příběh přes **C3** (ARCH0002 §(a)).
- Cron pro trvalé dary a povýšení poukazu se opětovně vstupují do stejného uzlu PAID
  ([UC0007](../UC/UC0007_ProcessRecurringDonation.md),
  [UC0009](../UC/UC0009_RedeemValidateVoucher.md)); záznamy PAID přicházejí i z **C5 párování plateb**.
- **Neaktivní** doporučovací cesta v C3 by byla spouštěna z události PAID — dnes je nečinná.

---

## Provázání (Cross-links)

- **relatedEN:** EN0009, EN0010, EN0013
- **relatedUC:** UC0005, UC0006, UC0007, UC0009 (účastní se UC0008, UC0010)
- **relatedFN:** FN0007, FN0008, FN0010, FN0011
- **relatedES:** ES0001 (ComGate), ES0002 (Netopia/MobilPay), ES0003 (MAIB)
- **relatedMSG:** MSG0019, MSG0020, MSG0021, MSG0022, MSG0023, MSG0024, MSG0025 (dar / trvalý dar / poukaz; transport vlastní C8)
- **relatedBR:** BR-PaymentAndMoneyIntegrity
  ([../BR/BR-PaymentAndMoneyIntegrity.md](../BR/BR-PaymentAndMoneyIntegrity.md)),
  BR-PaymentGatewayCallbacks ([../BR/BR-PaymentGatewayCallbacks.md](../BR/BR-PaymentGatewayCallbacks.md)),
  BR-RecurringDonationPolicy ([../BR/BR-RecurringDonationPolicy.md](../BR/BR-RecurringDonationPolicy.md)),
  BR-VoucherPolicy ([../BR/BR-VoucherPolicy.md](../BR/BR-VoucherPolicy.md))
