---
doc_id: QUERY0001
title: Donor / Supporter Zone Contributions
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: summary
references:
  - EN0009
  - EN0004
  - EN0034
  - EN0008
  - UC0024
  - FN0007
  - ARCH0006
---

# QUERY0001 – Donor / Supporter Zone Contributions

## Purpose

Read-model behind the logged-in supporter's account zone ("Moje zóna"): the donor's own
**paid, real (non-test) donations** aggregated per story, plus the two headline sums
("transparently donated" / "allocated") shown on the donor account. Lets a supporter see which
stories they supported and how much.

Evidence: `sync_config/config_czech/views.view.supporter_zone.yml` (page `zona/darce`);
sibling block `config/views.view.donations.yml` (identical read-model, block display);
`web/modules/custom/campaign/src/Plugin/rest/resource/v33/CampaignsResource.php`
`getTransparentAmountDonated()` / `getTransparentAmountAllocated()` (donor headline sums).

## Consumers

- Supporter / donor (role `supporter`) — own account zone only.
- Story-catalogue API donor context (interacted / allocated amounts on the donor's own record).

## Source Entities

- EN0009 – Transaction (base row; `price`, `ext_status`, `is_donation`, `user_id`, `campaign`, `test`, `transparent`, `is_recurring`)
- EN0004 – Campaign (grouping key / story name)
- EN0034 – DonorAccountView (the donor projection this zone materialises)
- EN0008 – User (the current donor; argument scope)

## Filters and Grouping

| Filter / Grouping | Meaning | Notes |
|---|---|---|
| `user_id = current_user` | Restricts to the logged-in donor's own transactions | View argument `user_id`, `default: current_user`; no override path. Confirmed. |
| `ext_status = 'PAID'` | Only settled payments count | Hard-coded view filter. Confirmed. |
| `is_donation = 1` | Excludes non-donation transactions (e.g. vouchers) | Hard-coded view filter. Confirmed. |
| group by `campaign` | One row per supported story | View `group_by: true`, `campaign` grouped, `price` aggregated as `sum`. Confirmed. |
| access: role `supporter` | Zone page/block visible only to supporters | View access `type: role`. Confirmed. |

For the two donor headline sums the source is raw SQL in `CampaignsResource`, **country-conditional**:
CZ sums `transaction.price WHERE transparent = 1 AND user_id = :uid`; non-CZ sums
`... WHERE is_recurring = 1 AND user_id = :uid`. "Allocated" repeats this but excludes the
transparent/infinite account (`campaign <> :transparent_account`). No `ext_status` filter is
applied to these two headline sums (contrast the view above). Confirmed / Partial (semantics of
`transparent` vs `is_recurring` split not fully evidenced).

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| `campaign` | Story the donations belong to | Entity-reference label, links to story. Confirmed. |
| `price` (sum) | Total paid donated by this donor to that story | Integer sum over grouped rows. Confirmed. |
| donor "donated" total | Headline: lifetime transparent (CZ) / recurring (non-CZ) donated | Raw-SQL `SUM(price)`, no `ext_status`/`test` guard → see Open Items. Partial. |
| donor "allocated" total | As above, excluding the transparent/infinite account | Raw-SQL `SUM(price)`. Partial. |

## Result Shape

- Zone page (`zona/darce`) and reusable block: flat list, one row per story, no pager (all rows).
- Sorted by `campaign` ascending.
- Headline sums: two scalar integers rendered on the donor account object.

## References

- UC: UC0024 (Manage Donor Account)
- FN: FN0007 (Donation & Payment Processing — the money semantics referenced, not restated)
- EN: EN0009, EN0004, EN0034, EN0008
- ARCH: ARCH0006 (Donations & Payments Domain)

## Open Items

- **Hazard (raw-SQL sum bypasses the persisted value):** the donor headline sums are computed by
  ad-hoc `SUM(price)` raw SQL in `CampaignsResource` rather than reusing the story `campaign_raised`
  read path; the two definitions can diverge. See QUERY0004 Open Items and BR ownership.
- **Hazard (no test/settled guard on headline sums):** the "donated"/"allocated" raw-SQL sums do
  not filter `ext_status = 'PAID'` or `test = 0`, unlike the per-story zone view — pending/test rows
  may be counted. Confirm intended semantics with BR/FN0007.
- The `transparent` (CZ) vs `is_recurring` (non-CZ) branch selecting which rows count as the donor's
  contributions is not explained in current sources — `Hypothesis — Not evidenced in current sources.`
