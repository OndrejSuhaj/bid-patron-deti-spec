---
doc_id: ACL0008
title: Party, Contact & CRM Access
canonical_layer: ACL
spec_type: access-control
status: draft
references:
  - EN0006
  - EN0018
  - EN0020
  - EN0023
  - UC0016
  - FN0014
  - FN0015
  - BR-PartyIdentityAndDeduplication
  - BR-MarketingAndAnalyticsRelay
  - ARCH0009
---

# ACL0008 – Party, Contact & CRM Access

## Purpose

Access to party/CRM resources: Contact (EN0006), Organisation (EN0018), Partner (EN0020), UserNote
(EN0023), contact search, and organisation forms. Actor model owned by ACL0001.

## Actor Model

- Contact CRUD and search are held by most back-office roles (coordinator, senior_coordinator, front,
  manager, risk_manager, content_admin, marketing) plus `fundraiser` (add/edit contact only).
- Organisation management is held by `manager` (full) and `marketing` (add/edit); org-worker linkage
  is via `add organisation form` / `view created organisation`.
- UserNote is held by the operational back-office roles.
- Scope is `global` (no country filter — ACL0001 G-03).

Evidence: `config/user.role.*.yml`; permission defs `contact/contact.permissions.yml`,
`organisation/organisation.permissions.yml`, `partner/partner.permissions.yml`,
`user_note/user_note.permissions.yml`.

## Resources

- Contact (EN0006) — CRUD, revisions, search
- Organisation (EN0018) — CRUD, `add organisation form`, `view created organisation`
- Partner (EN0020) — edit, view
- UserNote (EN0023) — CRUD, revisions

## Matrix

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `fundraiser` | Contact (EN0006) | add, edit | global | `add/edit contact entities` — the only substantive fundraiser grant. |
| `coordinator` | Contact (EN0006) | add, edit, view, revisions, search | global | `add/edit contact entities`, `search contacts`, `view all contact revisions`. |
| `coordinator` | UserNote (EN0023) | add, edit, view revisions | global | `add/edit user note entities`, `view all user note revisions`. |
| `senior_coordinator` | Contact / UserNote | add, edit, view, revisions, search | global | Same base as coordinator. |
| `front` | Contact / UserNote | add, edit, view, revisions, search | global | `add/edit contact entities`, `search contacts`, `add/edit user note entities`. |
| `risk_manager` | Contact / UserNote | edit, view, revisions, search | global | `edit contact entities`, `search contacts`, `add/edit user note entities`. |
| `content_admin` | Contact (EN0006) | add, edit, view published/unpublished, revisions, search | global | `add/edit contact entities`, `search contacts`, `view all contact revisions`. |
| `content_admin` | UserNote (EN0023) | add, edit | global | `add/edit user note entities`, `view all user note revisions`. |
| `marketing` | Contact (EN0006) | add, edit, view, revisions, search | global | `add/edit contact entities`, `search contacts`. |
| `manager` | Contact (EN0006) | add, edit, view, revisions, search | global | Full contact CRUD + `search contacts`. |
| `manager` | Organisation (EN0018) | add, edit, view published/unpublished, `add organisation form` | global | `add/edit organisation entity entities`, `add organisation form`. |
| `manager` | Partner (EN0020) | edit, view published/unpublished | global | `edit partner entities`, `view (un)published partner entities`. |
| `manager` | UserNote (EN0023) | add, edit, view revisions | global | Full UserNote CRUD. |
| `marketing` | Organisation (EN0018) | add, edit, view, `add organisation form`, `view created organisation` | global | `add/edit organisation entity entities`. |
| `marketing` | Partner (EN0020) | edit, view published | global | `edit partner entities`. |
| `anonymous` | Organisation (public) | GET | public | `restful get organisation_resource_v30/_v32`, `profile_organisation_resource`, `email_organisation_resource`. |
| `authenticated` | ARES registry search | search by IČO | public | `ares search by ico`. |

## Exceptions

- Contact entities use a custom storage class and deduplication controller
  (`contact/src/ContactEntityStorage.php`, `contact/src/Controller/ContactRemoveDuplicatesController.php`)
  with direct DB access; owned by BR-PartyIdentityAndDeduplication, noted here only as the
  authorization surface.
- No country/tenant scope on any contact/organisation grant (ACL0001 G-03).

## References

- UC: UC0016 (maintain party records), UC0013 (sync marketing intake leads)
- FN: FN0014 (party/contact management), FN0015 (marketing/CRM sync)
- EN: EN0006 (Contact), EN0018 (Organisation), EN0020 (Partner), EN0023 (UserNote)
- ES: ES0010 (ARES), ES0006 (Mautic)
- BR: BR-PartyIdentityAndDeduplication, BR-MarketingAndAnalyticsRelay
- ARCH: ARCH0009 (Party and CRM)

## Open Items

- `organisation_worker` effective access to its own organisation is not expressed as a role permission
  (`delete own files` only); any org-scoped read is ownership/linkage-based in code, deferred to the
  API/contract pass.
