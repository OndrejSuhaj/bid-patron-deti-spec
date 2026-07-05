---
doc_id: QUERY0002
title: Fundraiser & Patron Account Zones
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: list
references:
  - EN0001
  - EN0002
  - EN0008
  - EN0005
  - UC0024
  - FN0001
  - FN0018
  - ARCH0003
---

# QUERY0002 – Fundraiser & Patron Account Zones

## Purpose

Read-model behind the two applicant-side account zones: the fundraiser's account ("Účet žadatele",
`zona/zadatel`) and the patron's account ("Účet patrona", `zona/patron`). Each lists the
applications (žádosti) the current user owns in their respective role, rendered as an
application teaser. A third, near-identical read-model (`fundraisers_applications`, path `account`)
renders the same list with child name and a re-fill link and also serves a patron block.

Evidence: `sync_config/config_czech/views.view.fundraiser_zone.yml`,
`sync_config/config_czech/views.view.patron_zone.yml`,
`config/views.view.fundraisers_applications.yml`.

## Consumers

- Fundraiser / applicant (role `fundraiser`) — `zona/zadatel`.
- Patron (role `patron`) — `zona/patron`.
- Authenticated user on `account` (fundraiser context) + patron block (`fundraisers_applications`).

## Source Entities

- EN0001 – Application (base row; the žádost)
- EN0002 – ApplicationProfile (fundraiser_profile / patron_profile relationship; child name fields)
- EN0008 – User (the current fundraiser/patron; argument scope)
- EN0005 – Patron (patron role party, patron_zone)

## Filters and Grouping

| Filter / Grouping | Meaning | Notes |
|---|---|---|
| `fundraiser = current_user` | fundraiser_zone: only the applicant's own applications | Argument `fundraiser`, `default: current_user`, `validate entity:user restrict_roles fundraiser`. Confirmed. |
| `patron = current_user` | patron_zone: only the patron's own applications | Argument `patron`, `default: current_user`, `restrict_roles patron`. Confirmed. |
| access: role `fundraiser` / `patron` | Each zone gated to its role | View access `type: role`. Confirmed. |
| distinct rows | fundraiser_zone dedups applications | `query_tags: fundraiser_applications`, `distinct: true`. Confirmed. |
| `fundraiser` (query param → current_user) | `fundraisers_applications` default vs `account`/patron displays | Argument default varies per display (query_parameter, current_user, patron current_user). Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| application teaser | Rendered application row (view mode `fundraiser_s_teaser`) | Fundraiser/patron zones render the entity, not scalar fields. Confirmed. |
| `name` | Application name | fundraiser_zone default field. Confirmed. |
| `child_first_name` / `child_last_name` | Child of the application (from profile) | `fundraisers_applications` only, via profile relationship. Confirmed. |
| `state` | Application status | `fundraisers_applications`. Status vocabulary owned by EN/STAT, not restated here. |
| application re-fill link | Deep link to continue/edit the application | `application_refill_link` computed field. Confirmed. |

## Result Shape

- Zone pages: unpaged list of the current user's applications rendered as teasers.
- `fundraisers_applications`: page (`account`) + blocks (fundraiser / patron), unpaged.

## References

- UC: UC0024 (Manage Donor Account — applicant-side account surfaces), UC0025 (Resume/Discard Draft)
- FN: FN0001 (Application Intake Management), FN0018 (Identity, Session & Access Control — role gating)
- EN: EN0001, EN0002, EN0008, EN0005
- ARCH: ARCH0003 (Application & Lead Domain)

## Open Items

- Access is enforced purely by Drupal role + the `current_user` argument; there is no additional
  owner-equality assertion inside the view beyond the argument. Confirm whether URL tampering on the
  `fundraisers_applications` `query_parameter` default (default display) can leak another user's list
  — the `account`/patron page displays override to `current_user`, but the default display uses a
  query parameter. `Conflict — requires clarification.`
