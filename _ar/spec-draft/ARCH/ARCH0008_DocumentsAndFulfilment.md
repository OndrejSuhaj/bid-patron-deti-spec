---
doc_id: ARCH0008
title: Documents & Fulfilment Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
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

# ARCH0008 – Documents & Fulfilment Domain

> Domain navigation document for bounded context **C6 Documents & Fulfilment** (ARCH0001 §4).
> Navigation layer only — links deeper artifacts by `doc_id`, does not restate them. Current-state.

## Purpose

Explains the architectural perspective of the **legal and fiscal document layer**: how the donation
contract is generated and e-signed, how CZ tax confirmations and RO 2% tax-redirect declarations are
produced, and how supporting invoices are imported from external storage. These documents gate and
record the movement from an approved application into a live, funded story.

---

## System Overview

C6 generates the donation contract from a template with a two-step e-signature, whose progression
drives the owning Application's state back in C1 ([EN0011](../EN/EN0011_Contract.md); ARCH0002 §(c)).
It also produces the immutable CZ donation-confirmation snapshot (Potvrzení o daru) computed from paid
donations, the RO tax-redirect payer record, and pulls invoice PDFs from external storage to attach to
applications ([ARCH0001](../ARCH0001_ApplicationOverview.md) §4, §5). The context additionally holds
marketing/editorial content entities (partner list, custom blog) and the supplier registry that other
domains reference. Several document actions are country-gated and best-effort (status advances even if a
notification recipient or PDF is missing — ARCH0001 §5, FN0009).

---

## Structural Components

- **Document-Generation-&-Fulfilment** (Domain service) — contract render + e-signature, tax
  documents, voucher/document fulfilment. Capabilities:
  [FN0009](../FN/FN0009_ContractGenerationSignature.md) (contract),
  [FN0013](../FN/FN0013_DonationConfirmationTaxDocument.md) (tax documents).
- **OneDrive-Graph-Adapter** (Integration adapter) — CLI invoice import from external storage.
  Capability: [FN0017](../FN/FN0017_DocumentImportOneDrive.md).
- **Resident aggregates** — AG5 Contract (root [EN0011](../EN/EN0011_Contract.md)); AG10
  DonationConfirmation ([EN0014](../EN/EN0014_DonationConfirmation.md), write-once CZ tax snapshot);
  AG11 TaxPayer ([EN0015](../EN/EN0015_TaxPayer.md), write-once RO redirect record).
- **Reference / content entities** — ContractTemplate ([EN0012](../EN/EN0012_ContractTemplate.md)),
  Supplier registry ([EN0019](../EN/EN0019_Supplier.md)), Partner list
  ([EN0020](../EN/EN0020_Partner.md)), custom Blog ([EN0024](../EN/EN0024_Blog.md)).

---

## Interaction Model

Per [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(b)/(c):

- Contract creation is invoked **synchronously** from **C1**'s status seam at the signing state, and
  each signature step writes the Application's state back into **C1**
  ([UC0004](../UC/UC0004_ManageContractAndSignature.md); ARCH0002 §(c)).
- Tax confirmation reads paid transactions from **C4** to compute the confirmed total and optionally
  links a **C3** campaign ([UC0010](../UC/UC0010_IssueDonationConfirmation.md)).
- Invoice import is a CLI-triggered inbound pull from Microsoft Graph / OneDrive that attaches to a
  **C1** Application (re-entering the status fan-out) ([UC0019](../UC/UC0019_ImportInvoicesFromOneDrive.md);
  [ES0013](../ES/ES0013_MicrosoftGraphOneDrive.md); ARCH0002 §(b)).
- Contract and tax messages are dispatched via **C8** (manager-check, signature lifecycle, tax
  certificate).

---

## Cross-links

- **relatedEN:** EN0011, EN0012, EN0014, EN0015, EN0019, EN0020, EN0024
- **relatedUC:** UC0004, UC0010, UC0019
- **relatedFN:** FN0009, FN0013, FN0017
- **relatedES:** ES0013 (Microsoft Graph / OneDrive)
- **relatedMSG:** MSG0026, MSG0027, MSG0028 (contract & tax; transport owned by C8)
- **relatedBR:** BR-ContractAndESignature
  ([../BR/BR-ContractAndESignature.md](../BR/BR-ContractAndESignature.md)),
  BR-DonationConfirmationAndTax ([../BR/BR-DonationConfirmationAndTax.md](../BR/BR-DonationConfirmationAndTax.md))

> **Navigation note.** Content/reference entities EN0019/EN0020/EN0024 own no transactional lifecycle
> (DOMAIN-aggregates §3); they are grouped here as document/content fulfilment so that every EN is
> navigable, not because they carry document behaviour.
