---
doc_id: ES0013
title: Microsoft Graph / OneDrive
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0017
  - UC0019
---

# ES0013 – Microsoft Graph / OneDrive

## Purpose

Microsoft Graph / OneDrive provides the shared cloud folder from which Patronus imports invoice
documents and attaches them to the campaign Applications they belong to. It is the invoice-storage
counterpart of the Integration Landscape's document/fulfilment boundary (ARCH0001 §5 row 13).

---

## System Overview

Microsoft Graph / OneDrive is Microsoft's cloud file-storage service and the API surface used to
access files held in a shared OneDrive/SharePoint drive. For this integration it acts purely as an
external document repository: the platform reads files that a client-side process has placed in a
shared folder, it does not manage or edit them there.

---

## Integration Model

Inbound (pull), CLI-triggered — not part of the platform's normal request/response or event flow:

- a console-invoked import authenticates against Microsoft Graph and downloads invoice files from a
  shared OneDrive folder, then attaches each downloaded file to the owning Application (UC0019);
- a listing-only dry-run mode is supported, which enumerates the available files without downloading
  or attaching them.

This corresponds to ARCH0002's chain (b), the CLI invoice-import chain from the OneDrive source
through the platform's OneDrive-facing boundary into the Application it attaches to.

---

## Data Exchange

- Inbound: invoice document files, whose filenames imply the target campaign, are downloaded and
  attached as documents to the corresponding Application (conceptual only — the Application/Campaign
  relationship itself is owned by EN0001/EN0004, not restated here).
- No listing/field-level payload contract is defined at this layer; the dry-run mode exchanges the
  same file listing without transferring file content.

---

## Constraints

- Current-state only; the constraints below describe the system as implemented, not a target design.
- Authentication uses a resource-owner-password-credential (ROPC) grant with credentials held in
  cleartext in source, a vendor/auth lock-in rather than a delegated or app-only grant
  (ARCH0001 §5 row 13; ARCH0001 "CLI / console commands" / "Secrets" notes).
- The import has no de-duplication: re-running it against the same folder appends duplicate
  attachments to the same Application rather than recognising already-imported invoices.
- A Campaign that has no owning Application is not guarded against during import — the filename-based
  campaign match can proceed without a valid attachment target.
- Downloaded file content is not cleaned up after attachment, leaving residual local copies.
- Import failure leaves invoices unattached to their Application rather than retried or queued
  (ARCH0001 §5 row 13; FLW0028).
