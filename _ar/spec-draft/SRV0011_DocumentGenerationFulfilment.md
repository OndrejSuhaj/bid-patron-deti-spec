# SRV0011 — Document Generation & Fulfilment

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C6 — Documents & Fulfilment

## SRV Category
Domain Service

## Responsibility Type
Core Domain

## Purpose
Generates and manages the platform's legal/fulfilment documents: contracts (with e-signature), donation confirmations (Potvrzení o daru), gift vouchers (Dobrošek), and RO tax-redirect payer filings. It renders PDFs via mPDF and owns the lifecycle of these document entities, typically triggered by application status or payment (PAID) events.

## Current Implementation Shape
- **Contracts:** `ContractEntity` (revisionable) — `html` → mPDF PDF in `preSave`; `digital_signature` (SHA-512 hash blob) + QR confirmation PDF; `public_id`/`int_id` sequential per-year (CZ). `ContractTemplateEntity` (reusable HTML, translatable). `Evidence:` `PSRC/web/modules/custom/contract/src/Entity/{ContractEntity,ContractTemplateEntity}.php`; [db-models.md](../evidence/db-models.md).
- **Donation confirmations:** `DonationConfirmationEntity` (Potvrzení o daru, `donation_total`, `confirmation_year`, GDPR consent). `Evidence:` `PSRC/web/modules/custom/donation_confirmation/src/Entity/DonationConfirmationEntity.php`.
- **Vouchers:** `VoucherEntity` (Dobrošek — code, recipient, delivery email/print, expiration; owner derived via transaction→user_id). `Evidence:` `PSRC/web/modules/custom/voucher/src/Entity/VoucherEntity.php`; `hook_cron` (voucher). `Evidence:` [entrypoints.md §8](../repo-map/entrypoints.md).
- **RO tax redirect:** `TaxPayerEntity` (2%/3.5% donation redirect, links to contract). `Evidence:` `PSRC/web/modules/custom/account/src/Entity/TaxPayerEntity.php`; [db-models.md `tax_payer`](../evidence/db-models.md).
- **PDF engine:** `mpdf/mpdf ^8.1` + `mpdf/qrcode ^1.1`. `Evidence:` [integrations.md §4](../repo-map/integrations.md) (`composer.json`).
- **Triggers:** contract routes `/admin/application/{application}/contract*`, `donation_confirmation` routes, `voucher` routes + cron. `Evidence:` [entrypoints.md §2](../repo-map/entrypoints.md).

## Structural Issues
- **PDF rendering inside `preSave`** — contract entity renders mPDF and writes a `file` during save, mixing document generation with persistence. `Evidence:` [db-models.md `contract`](../evidence/db-models.md).
- **App-level numbering race** — `contract.int_id`/`public_id` computed as MAX+1 per-year with no DB unique key; race-prone under concurrency. `Evidence:` [db-models.md `contract` Verification](../evidence/db-models.md).
- **Fulfilment triggered by transaction flags** — voucherization/confirmation initiated from `TransactionEntity` `postSave` side-effects rather than an explicit event. `Evidence:` [SRV-candidates.md §5](SRV-candidates.md).
- **Weak email typing** — `donation_confirmation.email`/`voucher.recipient_email` stored as plain strings (no validation). `Evidence:` [db-models.md](../evidence/db-models.md).

## Target Shape (for rewrite)
A document-generation service with a `PdfRenderer` port, invoked by explicit events (application-signed, payment-PAID, voucher-purchased). Contract numbering via a DB sequence/unique constraint. Templates versioned; document storage behind a repository; delivery (email/print) delegated to SRV0013.

## Integration Dependencies
- mPDF (in-process PDF generation). `Confirmed` — [integrations.md §4](../repo-map/integrations.md). No external endpoint.

## Boundaries
Does NOT own transactions that trigger fulfilment → SRV0007. Does NOT send the documents → SRV0013. Does NOT import external invoices → SRV0019. Does NOT own campaigns referenced on confirmations → SRV0005.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Exact trigger for each document type (status vs. payment vs. manual). `Missing evidence: contract/voucher/confirmation generation call-sites.`
- e-signature verification/validation flow (SHA-512 blob). `Missing evidence: digital_signature validation code.`
- Voucher expiration/reminder cron behaviour. `Missing evidence: voucher hook_cron trace.`
