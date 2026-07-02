---
doc_id: BR-MultiTenantCountryScoping
title: Multi-Tenant CZ/RO/MD Scoping
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0001
  - EN0004
  - EN0009
  - SYSTEM
references:
  - EN0001
  - EN0004
  - EN0009
  - UC0008
  - FN0005
---

# BR – Multi-Tenant CZ/RO/MD Scoping

## Purpose

Governs how the CZ/RO/MD countries are separated in the current state and records that no
tenant/country column exists on the core entities and that several cross-cutting data paths are not
country-scoped.

## Tenancy model (current-state)

- Current-state: the three countries SHALL be treated as served by one shared instance, with no
  tenant/country column on the core case, story, and money entities (EN0001, EN0004, EN0009) and no
  domain-modeled multi-tenancy; country-differentiated behaviour SHALL be expressed only through
  runtime country branches and per-country configuration.
- Current-state: country separation on the core case, story, and money entities (EN0001, EN0004,
  EN0009) SHALL NOT be assumed enforced at the data level.

## Cross-tenant data-path scoping (current-state)

- Current-state: reporting exports SHALL NOT be assumed country-scoped — standard exports SHALL be
  treated as global across CZ/RO/MD rather than filtered to one country.
- Current-state: the country/role scoping of deduplication and merge actions is governed by
  `BR-PartyIdentityAndDeduplication` (referenced here only for the cross-tenant angle).
- Current-state: the recommendation subsystem, if reactivated, SHALL be treated as carrying no
  tenant scoping.

## Per-country processing gates

- Current-state per-country gating exists for bank reconciliation (owned by
  `BR-BankReconciliationAndMatching`), the CZ donation confirmation (owned by
  `BR-DonationConfirmationAndTax`), and external identity/registry verification and the RO
  recurring-charge run (see UC0008, FN0005). This rule records only that such gates exist and are
  enforced via hardcoded checks rather than a modeled tenant/country attribute, and that the RO
  recurring-charge run lacks an equivalent environment guard.

## Non-Goals

- This rule does not define the CZ-only donation confirmation's content or issuance mechanics (owned
  by BR-DonationConfirmationAndTax) or the CZ-only reconciliation matching mechanics (owned by
  BR-BankReconciliationAndMatching) — it references those gates only for their country-scoping
  angle.
- This rule does not define the country- or role-scoping gap in deduplication/merge actions beyond
  the scoping fact itself (owned by BR-PartyIdentityAndDeduplication).
- This rule does not define the unfiltered PII content or authorization level of reporting exports
  (owned by the reporting/data-access business rule where present) — it records only the absence of
  a country filter on those exports.
- This rule does not prescribe a target-state tenant model or country-column design; it records
  current-state behaviour only.
