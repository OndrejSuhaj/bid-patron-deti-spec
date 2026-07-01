# SRV0012 — Party & Contact Management

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C7 — Party / CRM

## SRV Category
Domain Service

## Responsibility Type
Core Domain

## Purpose
Owns the party/CRM hub: the central `contact` store (person/institution — child, fundraiser, patron, school, employer, lead), plus accounts, organisations (with workers), partners, suppliers, and contact notes. Nearly every domain references a `contact`, making this the shared identity-of-people layer of the platform.

## Current Implementation Shape
- **Contact hub:** `ContactEntity` (985 LOC) — revisionable, `fieldable=FALSE`, `field_name` discriminator (fundraiser/child/school/patron/lead/…), `blacklist_type` (written by scoring), composite index `contact_email_phone_field_name_type`. `Evidence:` `PSRC/web/modules/custom/contact/src/Entity/ContactEntity.php` (wc -l verified 985); [db-models.md `contact`](../evidence/db-models.md).
- **Accounts:** `AccountEntity` (patron/fundraiser record) + RO `TaxPayerEntity` (tax-redirect, see SRV0011). `Evidence:` `PSRC/web/modules/custom/account/src/Entity/AccountEntity.php`.
- **Organisations:** `OrganisationEntity` (workers via custom `worker_entity_reference` with `is_admin` column) + raw-SQL `getEntityByName()` merge. `Evidence:` `PSRC/web/modules/custom/organisation/src/Entity/OrganisationEntity.php`; [db-models.md `organisation`](../evidence/db-models.md).
- **Partners / suppliers / notes:** `PartnerEntity`, `SupplierEntity` (+`SupplierToCategory`), `UserNoteEntity` (linked from `contact.user_note`). `Evidence:` `PSRC/web/modules/custom/{partner,supplier,user_note}/src/Entity/`.
- **Triggers:** contact routes (~3 controllers, ~8 forms), organisation/partner/supplier/user_note routes. `Evidence:` [entrypoints.md §2,§3,§7](../repo-map/entrypoints.md).

## Structural Issues
- **God Entity + discriminator overloading** — one 985 LOC `contact` table serves many roles via `field_name`; `fieldable=FALSE` forces all variation into base fields. `Evidence:` [db-models.md `contact`](../evidence/db-models.md); [SRV-candidates.md §5](SRV-candidates.md).
- **Raw-SQL merge/dedup without transaction/dry-run** — `contact` dedup and `organisation` merge use raw SQL. `Evidence:` [SRV-candidates.md §5 No referential integrity](SRV-candidates.md).
- **Cross-context write-in** — `contact.blacklist_type` is written by SRV0003 (scoring), coupling risk into the party aggregate. `Evidence:` [SRV-candidates.md §4](SRV-candidates.md).
- **No dedup uniqueness** — phone `unique=NO`; no DB unique key on identity attributes; `supplier_to_category` has no composite uniqueness. `Evidence:` [db-models.md `contact`,`supplier_to_category`](../evidence/db-models.md).

## Target Shape (for rewrite)
A Party aggregate with typed sub-roles (individual/institution/organisation) instead of a discriminator field. Merge/dedup as an explicit transactional command with dry-run. Blacklist state received as an event from SRV0003, not written by scoring directly. DB-enforced identity uniqueness where dedup is intended.

## Integration Dependencies
None (internal domain).

## Boundaries
Does NOT own risk/blacklist decisions (only stores `blacklist_type` set by scoring) → SRV0003. Does NOT own applications/campaigns that reference contacts → SRV0001/SRV0005. Does NOT own authentication/roles → SRV0015. Does NOT own tax-document generation (owns the `tax_payer` record; PDF filing is SRV0011).

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Contact dedup/merge rules and transactional safety. `Missing evidence: contact/organisation raw-SQL merge trace.`
- Is `account` (party) the same as the Drupal `user` or a separate profile? `Missing evidence: account↔user relationship trace.`
- Organisation `worker` schema constraints (`is_admin`, composite index). `Missing evidence: WorkerEntityReferenceItemFieldType::schema() (not opened).`
