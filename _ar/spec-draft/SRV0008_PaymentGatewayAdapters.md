# SRV0008 — Payment Gateway Adapters

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C4 — Donations & Payments

## SRV Category
Integration Adapter

## Responsibility Type
Adapter

## Purpose
Wraps the three per-country card/payment gateways — ComGate (CZ), Netopia/MobilPay (RO), MAIB (MD) — behind payment-initiation and status-check operations, plus their return/callback controllers. It translates gateway protocols into SRV0007 transaction state changes. Each vendor is a distinct lock-in boundary.

## Current Implementation Shape
- **ComGate (CZ):** `AgmoPaymentsSimpleProtocol` — curl POST `createTransaction` / `checkTransactionStatus`; callback controller `TransactionStatusUpdate`. `Evidence:` `PSRC/web/modules/custom/comgate/src/AgmoPaymentsSimpleProtocol.php`; [integrations.md §1](../repo-map/integrations.md); [entrypoints.md §3](../repo-map/entrypoints.md).
- **Netopia/MobilPay (RO):** `NetopiaService` — `https://secure.mobilpay.ro` (prod) / `https://sandboxsecure.mobilpay.ro` (env-switched); controllers `NetopiaConfirmController`, `NetopiaPaymentResultController`. Vendored SDK via `require_once` (not Composer). `Evidence:` `PSRC/web/modules/custom/netopia/src/NetopiaService.php`; [integrations.md §1](../repo-map/integrations.md).
- **MAIB (MD):** `MaibService` — `https://maib.ecommerce.md:11440/ecomm01/MerchantHandler`; client cert `CURLOPT_SSLCERT` (`/var/www/patronus/cert.pem`, passphrase `<redacted>`); `MaibController`. Custom lib `patron/maibapi` v1.0.1 from `github.com/rostislavl/maibapi.git`. `Evidence:` `PSRC/web/modules/custom/maib/src/MaibService.php`; [integrations.md §1](../repo-map/integrations.md); `composer.json`.
- **Triggers:** gateway callback/return routes (`comgate/*`, `netopia/*`, `maib/*`), `hook_cron` (comgate, netopia status polling). `Evidence:` [entrypoints.md §2,§8](../repo-map/entrypoints.md).

## Structural Issues
- **Vendor Lock-in ×3** — three divergent gateway integrations with no common port; MAIB uses a hardcoded cert path + passphrase; Netopia SDK is vendored via `require_once` not Composer. `Evidence:` [integrations.md §1,§11](../repo-map/integrations.md); [SRV-candidates.md §5](SRV-candidates.md).
- **No abstraction seam** — SRV0007 currently calls vendor services directly rather than a `PaymentGateway` interface. `Evidence:` [SRV-candidates.md §4 Splits](SRV-candidates.md).
- **Secrets handling mixed** — Netopia/MAIB/ComGate read from Settings/env (good), but MAIB cert path/passphrase are environment-bound and hardcoded-adjacent. `Evidence:` [integrations.md §11](../repo-map/integrations.md).

## Target Shape (for rewrite)
One `PaymentGateway` port (initiate, capture, refund, checkStatus, verifyCallback) with three adapters. Callbacks normalized to a single internal event consumed by SRV0007. Secrets from a vault; SDKs via Composer; sandbox/prod via config, not code branches.

## Integration Dependencies
- ComGate — curl `createTransaction`/`checkTransactionStatus` (CZ/CZK). `Confirmed`.
- Netopia/MobilPay — `https://secure.mobilpay.ro` / `https://sandboxsecure.mobilpay.ro`. `Confirmed`.
- MAIB — `https://maib.ecommerce.md:11440/ecomm01/MerchantHandler` (client-cert TLS). `Confirmed`.
`Evidence:` [integrations.md §1](../repo-map/integrations.md).

## Boundaries
Does NOT own transaction state/domain rules → SRV0007. Does NOT reconcile bank statements → SRV0009. Does NOT issue receipts/vouchers → SRV0011.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Callback authenticity/signature verification per gateway. `Missing evidence: callback verification code per controller.`
- Recurring-token capture path per vendor (which support tokenized recurring). `Missing evidence: token capture trace per adapter.`
- ComGate `checkTransactionStatus` polling cron cadence/gating. `Missing evidence: comgate hook_cron trace.`
