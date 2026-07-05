---
doc_id: ACL0007
title: Contract & Document Access
canonical_layer: ACL
spec_type: access-control
status: draft
references:
  - EN0011
  - EN0012
  - EN0014
  - UC0004
  - UC0010
  - FN0009
  - FN0013
  - BR-ContractAndESignature
  - BR-DonationConfirmationAndTax
  - ARCH0008
---

# ACL0007 – Contract & Document Access

## Purpose

Access to Contract (EN0011), ContractTemplate (EN0012), contract routing between roles, and
DonationConfirmation / tax document (EN0014). Actor model owned by ACL0001.

## Actor Model

- `coordinator`, `senior_coordinator`, `manager` handle contracts. Contract routing between roles is
  governed by `send contract to fundraiser` and `send contract to manager`. `manager` administers
  contract templates. DonationConfirmation is primarily a public/system-generated artifact (public
  POST via REST — ACL0009).
- Scope is `global` (no country filter — ACL0001 G-03).

Evidence: `config/user.role.coordinator.yml`, `config/user.role.senior_coordinator.yml`,
`config/user.role.manager.yml`; permission defs `contract/contract.permissions.yml`,
`donation_confirmation/donation_confirmation.permissions.yml`.

## Resources

- Contract (EN0011) — CRUD, revisions
- Contract routing — `send contract to fundraiser`, `send contract to manager`
- ContractTemplate (EN0012) — CRUD (`administer contract template entities`)
- DonationConfirmation (EN0014) — create (public REST), view

## Matrix

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `coordinator` | Contract (EN0011) | add, edit, view published/unpublished | global | `add/edit contract entities`, `view (un)published contract entities`. |
| `coordinator` | Contract routing | send to manager | global | `send contract to manager`. |
| `senior_coordinator` | Contract (EN0011) | add, edit, view | global | Same as coordinator. |
| `senior_coordinator` | Contract routing | send to fundraiser, send to manager | global | `send contract to fundraiser` + `send contract to manager`. |
| `manager` | Contract (EN0011) | add, edit, view | global | `add/edit contract entities`, `view (un)published contract entities`. |
| `manager` | Contract routing | send to fundraiser, send to manager | global | Both send permissions. |
| `manager` | ContractTemplate (EN0012) | administer, edit, view | global | `administer/edit contract template entities`, `view (un)published contract template entities`. |
| `content_admin`/`manager` (contract transitions) | Application transitions `ceka_na_podpis`,`smlouva_podepsana_zadatelem` | use | global | Contract-signature workflow transitions in role config. |
| `anonymous` | Contract fetch | GET | public | `restful get application_contract_resource`. |
| `anonymous`/`authenticated` | DonationConfirmation (EN0014) | create | public | `restful post donation_confirmation_resource_v31/_v32`. |

## Exceptions

- Contract entities use a custom storage class (`contract/src/ContractEntityStorage.php`) with direct
  DB access; this is a data-layer concern owned by BR-ContractAndESignature, noted here only as the
  authorization surface.
- Contract-signature workflow transitions inherit the transition-legality gaps (ACL0001 G-02/G-06).
- DonationConfirmation creation is a public REST action; tax-document authorization is
  ownership/token-based in resource code, not a role grant.

## References

- UC: UC0004 (manage contract & signature), UC0010 (issue donation confirmation)
- FN: FN0009 (contract generation/signature), FN0013 (donation confirmation / tax document)
- EN: EN0011 (Contract), EN0012 (ContractTemplate), EN0014 (DonationConfirmation)
- BR: BR-ContractAndESignature, BR-DonationConfirmationAndTax
- ARCH: ARCH0008 (Documents and Fulfilment)

## Open Items

- Fundraiser/patron read access to their own contract/confirmation via REST is ownership-based
  (resource code); deferred to the API/contract pass.
