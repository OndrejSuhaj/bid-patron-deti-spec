# SRV0019 — Document Import Adapter (OneDrive)

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C6 — Documents & Fulfilment

## SRV Category
Integration Adapter

## Responsibility Type
Adapter

## Purpose
Imports invoice PDFs from a OneDrive/SharePoint drive via Microsoft Graph and attaches them to campaign applications (municipality-audit attachments). It is the inbound document-ingestion boundary — the counterpart to SRV0011 which generates documents.

## Current Implementation Shape
- **Import command:** `OnedriveCommand` (`onedrive:import:invoices`) — pulls invoice PDFs from a OneDrive/SharePoint drive and stores them to `private://attachments_audit`, attaching to campaign applications. `Evidence:` `PSRC/web/modules/custom/onedrive/src/Command/OnedriveCommand.php`; [integrations.md §4](../repo-map/integrations.md); [entrypoints.md §8](../repo-map/entrypoints.md).
- **Auth:** token from `https://login.microsoftonline.com/{tenant}/oauth2/token`, `grant_type=password` (ROPC) with hardcoded tenant id, client id, client secret, username, password (all `<redacted>`). `Evidence:` `PSRC/web/modules/custom/onedrive/src/Command/OnedriveCommand.php`; [integrations.md §4 Correction, §11](../repo-map/integrations.md).
- **SDK:** `microsoft/microsoft-graph ^1.70`. `Evidence:` [integrations.md §4](../repo-map/integrations.md) (`composer.json`).
- **Target field:** `application.attachments_audit` (private files "for the Municipality"). `Evidence:` [db-models.md `application`](../evidence/db-models.md).
- **Triggers:** CLI console command only (`onedrive:import:invoices`); no route/cron/queue evidenced. `Evidence:` [entrypoints.md §8](../repo-map/entrypoints.md).

## Structural Issues
- **Hardcoded credentials (ROPC)** — cleartext tenant/client id/secret + username/password in the command, and the OAuth grant is Resource Owner Password Credentials (deprecated, high-risk). `Evidence:` [integrations.md §4 Correction, §11](../repo-map/integrations.md).
- **CLI-only ingestion** — import runs from a console command with no managed schedule/retry. `Evidence:` [entrypoints.md §8](../repo-map/entrypoints.md).
- **Writes into the application aggregate** — the adapter attaches files directly onto `application.attachments_audit` (C1), coupling an import adapter into the application entity. `Evidence:` [db-models.md `application`](../evidence/db-models.md).
- **Vendor lock-in** — tied to MS Graph SDK + OneDrive drive layout. `Evidence:` [integrations.md §11](../repo-map/integrations.md).

## Target Shape (for rewrite)
A `DocumentImport` port with a OneDrive/Graph adapter using modern OAuth (client-credentials or delegated, no ROPC), secrets from vault, and a scheduled/retryable job. Imported files handed to SRV0011/SRV0001 via an explicit command rather than direct entity writes.

## Integration Dependencies
- Microsoft Graph / OneDrive — token `https://login.microsoftonline.com/{tenant}/oauth2/token` (ROPC); drive read + file download. `Partial` (verify pass) — [integrations.md §4](../repo-map/integrations.md).

## Boundaries
Does NOT generate documents → SRV0011. Does NOT own the application it attaches to → SRV0001. Does NOT own bank/invoice reconciliation → SRV0009.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- How import is scheduled in practice (cron wrapper around the CLI?). `Missing evidence: onedrive:import:invoices invocation trace.`
- Matching logic: which invoice attaches to which application. `Missing evidence: OnedriveCommand attach logic trace.`
- Are the ROPC credentials still active / rotated. `Missing evidence: credential provenance (redacted in source).`
