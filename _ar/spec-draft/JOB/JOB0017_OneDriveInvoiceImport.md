---
doc_id: JOB0017
title: OneDrive Invoice Import
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: batch
references:
  - FN0017
  - EN0001
  - EN0004
  - ES0013
---

# JOB0017 – OneDrive Invoice Import

## Purpose

Pull invoice PDFs from a shared SharePoint/OneDrive folder, derive the target Campaign from each file
name, and attach the file to that Campaign's Application audit-attachment field. Realises FN0017
(Document Import — OneDrive).

Classification: **Confirmed** (CLI path); scheduling mechanism **Hypothesis**.

## Trigger Model

- Batch / CLI command `onedrive:import:invoices [limit] [savefiles] [errorsonly]`. No cron/hook
  wiring in the module — operator- or externally-invoked.
- Evidence: `onedrive/src/Command/OnedriveCommand.php` (`configure()` sets the command name).
  Dossier: FLW0028. (Correction: it is a Drupal Console command, not a Drush command.)

## Input Scope

- Children of one hardcoded drive folder, page size = the limit arg; only `.pdf` items are processed.
  The Campaign id is derived from the file name. A dry-run mode lists without persisting. See EN0004.

## Processing Rules

- Acquire a Microsoft Graph token (ROPC password grant); list the folder; per PDF: derive the
  Campaign id from the file name, load the Campaign, and (when save is requested) download the file,
  write it to the private audit-attachments area, and append its id to the Campaign's Application
  audit-attachment field, saving the Application without a new revision.

## Side Effects

- New managed file under the private audit-attachments area; the Campaign's Application re-saved with
  the attachment appended. See EN0001, EN0004.
- The Application save re-enters the FN0002 fan-out (status-update event, search-index enqueue →
  JOB0013, campaign re-sync) even though only an attachment changed.
- Cross-system calls: Microsoft identity token endpoint + Graph list/download (ES0013). Leaves the
  downloaded temp file uncleaned.

## Idempotency

- **Not idempotent:** re-running re-downloads and appends a **duplicate** attachment id (the field is
  unlimited-cardinality with no dedupe). Documented current-state hazard.

## Failure Handling

- Token/list/download failures are uncaught → the whole run aborts. A Campaign with no Application, or
  a malformed file name, is unguarded / mis-mapped. A failed file write is logged and skipped, no
  retry. Documented current-state hazards (FLW0028).

## References

- FN: FN0017, FN0002
- UC: UC0019
- EN: EN0001, EN0004
- ES: ES0013
- Evidence: FLW0028

## Open Items

- ROPC lock-in with hardcoded cleartext credentials (`<redacted>`); no region/tenant filter (a mixed
  folder can misattach across CZ/RO/MD). Scheduling is not evidenced in source. `Hypothesis`.
