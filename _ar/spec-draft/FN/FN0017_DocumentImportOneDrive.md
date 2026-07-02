---
doc_id: FN0017
title: Document Import (OneDrive)
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0019
  - EN0001
  - EN0004
---

# FN0017 – Document Import (OneDrive)

## Purpose

Automatically pull newly deposited invoice documents from a shared OneDrive folder (via Microsoft
Graph) and attach each invoice to the correct Application via a Campaign reference encoded in the
file name, so back-office staff do not have to manually download and upload invoices.

## Responsibilities

- Authenticate to Microsoft Graph on behalf of a configured service account and list items in the
  configured shared invoice folder, up to a configured item limit.
- Filter listed items to invoice (PDF) files, derive the Campaign reference from each file name using
  an implicit naming convention, and resolve the target Campaign and its associated Application.
- Download the invoice content, store it as an attachment, append it to the Application's
  invoice-attachment collection, and save the Application — which re-enters the Application status
  and side-effect fan-out capability (FN0002) even though only the attachment changed.
- Support a listing-only (dry-run) mode that authenticates, lists, and resolves candidate items
  without persisting any attachment.
- Record an error and continue processing remaining items when a file name does not resolve to an
  existing Campaign, rather than aborting the whole run.

## Related Use Cases

UC0019 (Import Invoices from OneDrive).

## Related Entities

EN0001 (Application — receives the imported invoice as an attachment and is re-saved), EN0004
(Campaign — resolved from the invoice file name to locate the target Application).

## Integrations

OneDrive / Microsoft Graph API (named-integration cluster; see ARCH0002 integrations landscape,
row for the OneDrive-invoice-source boundary — no ES layer exists yet for this boundary).

## Constraints

- Authentication is a resource-owner-password-credentials (ROPC) grant against a fixed tenant,
  client, and service-account credential set — a vendor/credential lock-in shape rather than a
  delegated or app-only flow.
- No dedupe safeguard: re-running the import over a folder containing an already-imported invoice
  appends a duplicate attachment entry to the same Application (Partial evidence — not a designed
  outcome).
- A Campaign resolved successfully but with no associated Application is not gracefully guarded;
  evidence indicates this can fail that item's processing rather than being a designed alternative
  outcome (Partial evidence).
- The attachment-only save still triggers the full Application status/side-effect fan-out (FN0002),
  including downstream notification and search re-index processing, even when no status changed.
- No cleanup of transient downloaded content is guaranteed after processing.
