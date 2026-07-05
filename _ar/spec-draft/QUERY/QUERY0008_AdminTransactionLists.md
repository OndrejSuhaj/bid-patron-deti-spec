---
doc_id: QUERY0008
title: Admin Transaction / Payment & Voucher Lists
canonical_layer: QUERY
spec_type: query-spec
status: draft
query_type: list
references:
  - EN0009
  - EN0010
  - EN0013
  - EN0004
  - EN0008
  - UC0005
  - UC0006
  - UC0009
  - FN0007
  - FN0010
  - FN0011
  - ARCH0006
  - ARCH0007
---

# QUERY0008 – Admin Transaction / Payment & Voucher Lists

## Purpose

Back-office lists over the transaction ledger and its derivatives (recurring payments, vouchers).
Grouped as one contract because they share the `transaction` base entity and the same finance
back-office intent, sliced into several displays (payments, payments-by-date, without-story,
not-donations, refunded), plus recurring and voucher siblings.

Evidence: `config/views.view.view_transactions.yml` (5 displays),
`config/views.view.recurring.yml`, `config/views.view.vouchers.yml`,
`config/views.view.payments_report.yml`.

## Consumers

- content_admin, risk_manager, manager, marketing, front (transactions/recurring);
  manager, marketing (vouchers). Per-view role gating recorded below.

## Source Entities

- EN0009 – Transaction (base; `ext_status`, `price`, `is_donation`, `is_voucher`, `is_recurring`, `is_sent_to_bank`, `bank_vs`, `bank_date`, `bank_month`, `ext_trans_id`, `ext_fee`, `test`, `transparent`, `parent`, `campaign`)
- EN0010 – RecurringTransaction (recurring list)
- EN0013 – Voucher (voucher list)
- EN0004 – Campaign (story link)
- EN0008 – User (donor mail column)

## Filters and Grouping

| View / display (path) | Filter slice | Role scope | Notes |
|---|---|---|---|
| `view_transactions` default (`admin/transactions`) | Payments with story; exposed id/campaign/ext_status/mail/bank_month/ext_trans_id/transparent/type | content_admin, risk_manager, manager, marketing, front | Full list 200/page. Confirmed. |
| `view_transactions` page_1 "Payments without story" (`admin/transactions` default title) | see above | as above | Confirmed. |
| payments-by-date (`admin/reports/payments-by-date`) | `ext_status = PAID` + created range (exposed) | as above | Confirmed. |
| transactions_without_campaign | `campaign` empty, `ext_status=PAID`, `is_donation=1`, `is_voucher=0` | as above | Confirmed. |
| transactions_not_donations | `campaign` empty, `ext_status=PAID`, `is_donation=0` | as above | Confirmed. |
| refunded (`admin/transactions/refunded`) | `ext_status = REFUNDED` | as above | Confirmed. |
| `recurring` (`admin/transactions/recurring`) | Recurring schedules | content_admin, risk_manager, manager, marketing, front | 100/page. Confirmed. |
| `vouchers` (`admin/vouchers`) | Vouchers; exposed status/is_applied/campaign/recipient_email/id | manager, marketing | 200/page. Confirmed. |
| `payments_report` (`admin/reports/payments-report`) | Rendered transaction entities | access: none (open) | See Open Items. Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| ledger columns | `ext_status`, `price`, `bank_vs`, `bank_date`, `bank_month`, `ext_trans_id`, `ext_fee`, `is_recurring`, `is_voucher`, `type`, `comment`, `parent` | Owned by EN0009. Confirmed. |
| `mail` | Donor email (user join) | PII. Confirmed. |
| `transparent_views_field` | Transparency flag projection | Computed views field. Confirmed. |
| recurring columns | `price`, `day`, `last_recurring_payment`, `created`, `canceled`, donor mail | Owned by EN0010. Confirmed. |
| voucher columns | code, price, status, applied/expiration, sender/recipient email, comgate id/status | Owned by EN0013; PII (emails). Confirmed. |

## Result Shape

- Paginated back-office tables; exposed filters; per-display column sets.

## References

- UC: UC0005 (Make a Donation), UC0006 (Confirm Payment), UC0009 (Redeem/Validate Voucher)
- FN: FN0007 (Donation & Payment Processing), FN0010 (Recurring Donation Scheduling), FN0011 (Voucher)
- EN: EN0009, EN0010, EN0013, EN0004, EN0008
- ARCH: ARCH0006 (Donations & Payments), ARCH0007 (Finance & Reconciliation)

## Open Items

- **Hazard (unguarded access):** `payments_report` (`admin/reports/payments-report`) has view access
  `type: none` — the display itself imposes no role/permission; it relies entirely on the route/menu
  wrapper for protection. Flag for ACL closure. `Conflict — requires clarification.`
- Country/tenant scoping is not applied by these views (single-DB-per-country assumption pending).
