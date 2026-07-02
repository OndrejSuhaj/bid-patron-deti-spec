---
doc_id: ARCH0006
title: Donations & Payments Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
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

# ARCH0006 – Donations & Payments Domain

> Domain navigation document for bounded context **C4 Donations & Payments** (ARCH0001 §4).
> Navigation layer only — links deeper artifacts by `doc_id`, does not restate them. Current-state.

## Purpose

Explains the architectural perspective of the **money hub**: how every incoming payment — one-off,
corporate, recurring, or voucher purchase — is captured through a per-region gateway, confirmed via
callback, and driven to PAID, which is the single most consequential transition in the platform. This
is the third primary domain concept (ARCH0001 §1) and the origin of most cross-domain cascades.

---

## System Overview

C4 owns the transaction record and its external payment status
(PENDING → AUTHORIZED / PAID / CANCELLED / REFUNDED), the recurring-subscription schedule, and the
prepaid voucher (Dobrošek). Its architectural centre of gravity is the **first transition to PAID**,
the platform's most consequential save-time cascade: its multi-effect side-effect contract
(recompute/split/activate/promote/grant/notify) and its non-transactional, non-idempotent current-state
are owned by [BR-PaymentAndMoneyIntegrity](../BR/BR-PaymentAndMoneyIntegrity.md), §"Effects on first
transition to PAID" ([ARCH0001](../ARCH0001_ApplicationOverview.md) §7, §8 Risk 1;
ARCH0002 chain A; the money-hub hazard is HS03). One payment gateway serves each region (CZ/RO/MD), and
the callback route is effectively public with no HMAC (HS12).

---

## Structural Components

- **Payment-Processing** (Domain service) — the shared PAID entry point and money-side hub. Capability:
  [FN0007](../FN/FN0007_DonationPaymentProcessing.md).
- **Payment gateway adapters** (Integration adapters) — the three per-region gateways grouped as one
  capability. Capability: [FN0008](../FN/FN0008_PaymentGatewayIntegration.md).
- **RecurringPayment-Processor** (Async processor) — cron-driven periodic charging. Capability:
  [FN0010](../FN/FN0010_RecurringDonationScheduling.md).
- **Voucher issuance & redemption** — capability: [FN0011](../FN/FN0011_VoucherRedemption.md).
- **Resident aggregates** — AG3 Transaction (root [EN0009](../EN/EN0009_Transaction.md); overpayment
  child is a self-split row); AG4 RecurringTransaction (root
  [EN0010](../EN/EN0010_RecurringTransaction.md), spawns child Transactions); AG6 Voucher (root
  [EN0013](../EN/EN0013_Voucher.md)).

---

## Interaction Model

Per [ARCH0002](../ARCH0002_ContextInteractionMap.md) chain A and §(a)/(b)/(c):

- Outbound-then-inbound with the region gateways: donation checkout calls out; the gateway calls back /
  redirects to confirm ([UC0005](../UC/UC0005_MakeADonation.md),
  [UC0006](../UC/UC0006_ConfirmPayment.md); [ES0001](../ES/ES0001_ComGate.md),
  [ES0002](../ES/ES0002_NetopiaMobilPay.md), [ES0003](../ES/ES0003_Maib.md)).
- On PAID, fans out synchronously to **C3 Campaign** (recompute + auto-complete), **C7 Party** (grant
  supporter role), **C8 Messaging** (thank-you) and **C11 Ops** (Slack) — ARCH2 chain A.
- Resolves anonymous donors into User+Contact via **C9 Identity & Access**, and targets the donation
  story via **C3** (ARCH0002 §(a)).
- The recurring cron and the voucher promotion re-enter the same PAID hub
  ([UC0007](../UC/UC0007_ProcessRecurringDonation.md),
  [UC0009](../UC/UC0009_RedeemValidateVoucher.md)); PAID records also arrive from **C5 reconciliation**.
- The **dormant** C3 recommendation path would be triggered from the PAID event — inert today.

---

## Cross-links

- **relatedEN:** EN0009, EN0010, EN0013
- **relatedUC:** UC0005, UC0006, UC0007, UC0009 (participates in UC0008, UC0010)
- **relatedFN:** FN0007, FN0008, FN0010, FN0011
- **relatedES:** ES0001 (ComGate), ES0002 (Netopia/MobilPay), ES0003 (MAIB)
- **relatedMSG:** MSG0019, MSG0020, MSG0021, MSG0022, MSG0023, MSG0024, MSG0025 (donation / recurring / voucher; transport owned by C8)
- **relatedBR:** BR-PaymentAndMoneyIntegrity
  ([../BR/BR-PaymentAndMoneyIntegrity.md](../BR/BR-PaymentAndMoneyIntegrity.md)),
  BR-PaymentGatewayCallbacks ([../BR/BR-PaymentGatewayCallbacks.md](../BR/BR-PaymentGatewayCallbacks.md)),
  BR-RecurringDonationPolicy ([../BR/BR-RecurringDonationPolicy.md](../BR/BR-RecurringDonationPolicy.md)),
  BR-VoucherPolicy ([../BR/BR-VoucherPolicy.md](../BR/BR-VoucherPolicy.md))
