---
doc_id: EN0019
title: Supplier
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0002  # ApplicationProfile — aprofile.gift_supplier → supplier
---

# EN0019 — Supplier

## Description
Gift supplier / vendor registry. Represents a company from which the gift/donation item is (or would be) purchased. Referenced from the application profile's `gift_supplier` field and joined into CSV exports; a separate `supplier_to_category` mapping (rejected as a join table) associates a supplier with help-area categories and an e-shop URL. Suppliers are back-office reference data with light lifecycle.

## Entity Category
Persisted · Confidence: Medium
(Schema confirmed; usage is read-oriented — referenced by ApplicationProfile and CSV export JOINs; no rich transition flow mined.)

## Origin
- DB artifacts: base_table `supplier`. No `.install` / no hook_schema. (Sibling entity `supplier_to_category` in same module is a join-like mapping, not promoted.)
- Code touchpoints:
  - `supplier/src/Entity/SupplierEntity.php` — entity.
  - `application/src/Entity/ApplicationProfileEntity.php` — `aprofile.gift_supplier` (er → supplier).
  - `export_csv/src/Controller/ExportCSVController.php:798,928` — `LEFT JOIN supplier ON aprofile.gift_supplier = supplier.id`.
  - `scoring/src/Form/ScoringForm.php:1362-1371` — reads supplier name/ICO for the gift sub-form.
Evidence: db-models.md `supplier`; grep confirms `gift_supplier` join (ExportCSVController.php:798,928) and scoring read.

## Core Fields
- `name` (string 150; required; "Nazev"; entity label)
- `ico` (string 20; optional; company ID)
- `datova_schranka` (string 20; optional; data box ID)
- `street` (string 100; optional)
- `city` (er → taxonomy_term `city`, auto_create=TRUE; optional)
- `zip` (string 10; optional)
- `status` (boolean; publish flag; default TRUE)

## Technical Fields
- `user_id` (er → EN0008 User; optional; owner)
- `created` / `changed` (timestamps)
Evidence: db-models.md `supplier`.

## Relations
- `user_id` → EN0008 User (owner). Evidence: db-models.md.
- `city` → taxonomy_term (city vocabulary; auto_create). Evidence: db-models.md.
- Inbound: EN0002 ApplicationProfile `gift_supplier` → supplier. Evidence: db-models.md `aprofile`; ExportCSVController.php:798.
- `supplier_to_category` (separate entity) maps supplier ↔ category (help area) + e-shop URL; no field on `supplier` links back to it. Evidence: db-models.md `supplier_to_category`.

## Allowed Statuses
`status` boolean only (published / unpublished); no domain status enum. Evidence: db-models.md `supplier`.

## Lifecycle
Hypothesis — Not evidenced in current sources. No create/transition flow dossier covers Supplier; only schema + read-side references (ApplicationProfile relation, CSV JOIN) are confirmed. Missing evidence: create/edit/delete code path.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Who creates/maintains suppliers (admin UI vs. auto-create)? No write flow mined.
2. `supplier_to_category` has no composite uniqueness (supplier+category) — is duplicate mapping expected? (db-models.md flags this.)
3. `city` uses auto_create on a taxonomy term — is supplier city meant to grow the city vocabulary uncontrolled?
