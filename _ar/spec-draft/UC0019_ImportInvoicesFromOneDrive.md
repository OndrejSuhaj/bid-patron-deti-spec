# UC0019 — Import Invoices from OneDrive

## Header

| Field | Value |
|---|---|
| UC ID | UC0019 |
| Name | Import Invoices from OneDrive |
| Bounded Context | C6 |
| Primary Actor(s) | Scheduler, Integration(OneDrive) |
| Trigger Type | CLI |

## Actors & Responsibilities

- **Scheduler** — invokes the invoice-import command on a recurring or ad-hoc basis (manual operator run or external scheduling mechanism; no in-system cron wiring evidenced).
- **Integration(OneDrive)** — hosts the shared invoice folder in a cloud drive and exposes its contents (file listing, file download) via the Microsoft Graph API.
- **System** — authenticates to the integration, lists and filters incoming invoice files, resolves each file to a Campaign (EN0004), persists the invoice as an attachment on the associated Application (EN0001), and triggers downstream status/side-effect processing.

## Intent

Automatically pull newly deposited invoice documents from a shared cloud-drive folder and attach each invoice to the correct Application (EN0001) record via its associated Campaign (EN0004), so that finance/back-office staff do not have to manually download and upload invoice files.

## Preconditions

- A valid connection to Integration(OneDrive) can be established (valid credentials/authorization for the configured drive account).
- The target shared folder in Integration(OneDrive) is reachable and contains zero or more candidate files.
- The operator/scheduler runs the import in "persist" mode (as opposed to a dry-run/listing-only mode) for any attachment to actually be saved.
- Each invoice file name encodes a Campaign (EN0004) identifier following an implicit naming convention.

## Main Flow

### UC0019.1 — Authenticate and list invoice files
1. Scheduler: initiate a scheduled or manual run of the invoice-import job, optionally bounded by a maximum item count.
2. System: request an access token from the identity provider on behalf of a configured service account.
3. Integration(OneDrive): issue an access token for the configured drive account.
4. System: request the list of items in the configured shared invoice folder, up to the configured item limit.
5. Integration(OneDrive): return the list of folder items (file names and metadata).

### UC0019.2 — Resolve and attach each invoice to its Application
1. System: for each returned item, discard it if its file name does not indicate an invoice document (non-PDF).
2. System: derive a Campaign (EN0004) reference from the invoice file name using the naming convention.
3. System: look up the Campaign (EN0004) by the derived reference.
4. System: skip the item and record an error if no matching Campaign (EN0004) is found.
5. System: skip persistence for the item if the run is in listing-only (dry-run) mode.
6. Integration(OneDrive): provide the invoice file content for download.
7. System: download the invoice content and store it as a new attachment file.
8. System: resolve the Application (EN0001) associated with the Campaign (EN0004).
9. System: append the new attachment to the Application's (EN0001) invoice-attachment collection.
10. System: save the Application (EN0001) without creating a new revision.
11. System: trigger the Application status/side-effect processing described in UC0002 (Application-Status-Orchestrator) as a consequence of saving the Application (EN0001), even though only the attachment collection changed.

## Alternative Flows

### AF1 — Authentication failure
1. Integration(OneDrive): reject the access-token request (invalid or expired service-account credentials).
2. System: abort the entire import run without processing any files.

Outcome: no invoices are imported for this run; the failure is not retried automatically within the run.

### AF2 — Folder listing or file download failure
1. Integration(OneDrive): fail to return the folder listing, or fail to return a file's content on download.
2. System: abort processing (for a listing failure, the whole run stops; for a single-file download failure, that item's processing stops).

Outcome: partial or no import results for the run; already-processed items in the same run remain persisted.

### AF3 — Unresolvable Campaign reference from file name
1. System: derive a Campaign (EN0004) reference from the file name that does not match any existing Campaign (EN0004).
2. System: record an error for the item and continue with the next item.

Outcome: the invoice file is not imported; no Application (EN0001) is modified for that item.

### AF4 — Campaign without an associated Application
1. System: resolve a Campaign (EN0004) successfully but find no associated Application (EN0001) linked to it.
2. System: fail to complete the attachment step for that item (evidence indicates this case is not gracefully guarded and can abort processing of that item).

Outcome: the invoice file is not attached; the condition is evidenced as a defect risk rather than a designed alternative outcome. Evidence Level: Partial.

### AF5 — Re-import of an already-imported invoice
1. Scheduler: re-run the import job over a folder containing a previously imported invoice file.
2. System: repeat the resolve-and-attach steps for the same file with no check for prior import.
3. System: append a duplicate attachment reference to the same Application's (EN0001) invoice-attachment collection.

Outcome: the Application (EN0001) ends up with a duplicate attachment entry; no idempotency safeguard is evidenced. Evidence Level: Partial.

## Postconditions

- Zero or more new attachment files exist, each linked to an Application (EN0001) that was resolved via a Campaign (EN0004) named in the source folder.
- Each successfully processed Application (EN0001) has its invoice-attachment collection extended and is saved without a new revision.
- Each successfully processed Application (EN0001) save triggers the standard Application status/side-effect fan-out (per UC0002), including downstream notification and search re-index processing, even when only the attachment changed.
- Items whose file name does not resolve to an existing Campaign (EN0004), or whose Campaign (EN0004) has no associated Application (EN0001), remain unprocessed and are recorded as errors.
- No cleanup of transient downloaded content is guaranteed after processing.

## Traceability

Target SRVs:
- OneDrive-Graph-Adapter
- Application-Status-Orchestrator

EN entities:
- EN0001 Application — receives the imported invoice as an attachment and is re-saved, triggering status/side-effect processing
- EN0004 Campaign — resolved from the invoice file name; used to locate the target Application

Integration boundaries:
- OneDrive (via Microsoft Graph API) — file listing and content download

Flow Evidence:
- FLW0028 (OneDrive invoice import)

## Evidence Level

Confirmed — grounded in FLW0028 (Confirmed confidence) mapped to SRV0019/OneDrive-Graph-Adapter and SRV0002/Application-Status-Orchestrator per UC-srv-traceability.md row 76, with entity behavior corroborated by EN0001 (invoice-attachment collection, save-triggered status fan-out) and EN0004 (Campaign-to-Application relation); the no-idempotency and missing-Application-guard risks are marked Partial per the underlying dossier's own confidence annotations and surfaced here as AF4/AF5 rather than asserted as designed behavior.
