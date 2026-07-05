---
doc_id: ACL0005
title: Donations & Payments Access
canonical_layer: ACL
spec_type: access-control
status: draft
references:
  - EN0009
  - EN0010
  - UC0005
  - UC0006
  - UC0007
  - FN0007
  - FN0008
  - FN0010
  - BR-PaymentAndMoneyIntegrity
  - BR-PaymentGatewayCallbacks
  - BR-RecurringDonationPolicy
  - ARCH0006
---

# ACL0005 – Donations & Payments Access

## Purpose

Access to Transaction (EN0009), RecurringTransaction (EN0010), the donation-creation REST surface,
and the payment-gateway callback routes (ComGate ES0001, Netopia ES0002, MAIB ES0003, Moneta ES0004).
Actor model owned by ACL0001.

## Actor Model

- Donation creation is a **public** action: `anonymous` and `authenticated` may POST transactions and
  vouchers via REST.
- `supporter` may cancel **their own** recurring transaction.
- `manager` is the only back-office role with Transaction CRUD.
- Payment-gateway callbacks are effectively public (`access content`), relying on gateway signatures.

Evidence: `config/user.role.anonymous.yml`, `config/user.role.authenticated.yml`,
`config/user.role.supporter.yml`, `config/user.role.manager.yml`; routing
`comgate/comgate.routing.yml`, `maib/maib.routing.yml`, `netopia/netopia.routing.yml`,
`monetaapi/monetaapi.routing.yml`; permission defs `transaction/transaction.permissions.yml`,
`transaction_recurring/transaction_recurring.permissions.yml`.

## Resources

- Transaction (EN0009) — create (public REST), CRUD (back-office)
- RecurringTransaction (EN0010) — cancel (own, public REST)
- Voucher apply/validate (transaction context) — public REST
- Payment gateway callbacks — ComGate/MAIB status update, Netopia confirm/redirect

## Matrix

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `anonymous` | Transaction (EN0009) | create | public | `restful post transaction_rest_resource`, `..._32`, `transaction_voucher__*`, `transaction_vouchers__*`. |
| `anonymous` | Voucher apply/validate | POST | public | `restful post voucher_apply_resource(_v32)`, `voucher_validation_resource(_v32)`. |
| `anonymous` | Donation confirmation | POST | public | `restful post donation_confirmation_resource_v31/_v32`. |
| `authenticated` | Transaction (EN0009) | create | public | Same transaction/voucher POST allow-list as anonymous. |
| `supporter` | RecurringTransaction (EN0010) | cancel | own | `cancel own recurring transaction` + `restful post transaction_recurring_cancel_resource`. Ownership enforced in resource code. |
| `manager` | Transaction (EN0009) | add, edit, view published/unpublished | global | `add/edit transaction entities`, `view (un)published transaction entities`. |
| `anonymous`/`authenticated` (via route) | ComGate callback `/transaction/status_update` | POST/update | public | Route requires only `access content` (ACL0001 G-05). Evidence: `comgate/comgate.routing.yml`. |
| `anonymous`/`authenticated` (via route) | MAIB callback `/transaction/status_update` | update | public | Route requires only `access content` (ACL0001 G-05). Evidence: `maib/maib.routing.yml`. |
| `anonymous`/`authenticated` (via route) | Netopia confirm/redirect/result | POST/redirect | public | All three Netopia routes require only `access content` (ACL0001 G-05). Evidence: `netopia/netopia.routing.yml`. |
| — | Moneta `/monetaapiid` | — | none | Route `_access: 'FALSE'` — disabled/unreachable. Evidence: `monetaapi/monetaapi.routing.yml`. |

## Exceptions

- **Public donation creation is intentional** (end-user donation flow). It is listed here because it
  is an authorization surface, not because it is a defect.
- **Payment-gateway callback routes carry no Patronus ACL** beyond `access content`; authenticity is
  delegated to gateway-side signatures/IPN validation, not to role permissions (ACL0001 G-05). Rule
  semantics owned by BR-PaymentGatewayCallbacks.
- `supporter` recurring-cancel is scoped `own` by resource-plugin ownership logic, not by a role
  scope column.

## References

- UC: UC0005 (make a donation), UC0006 (confirm payment), UC0007 (process recurring donation)
- FN: FN0007 (donation/payment processing), FN0008 (payment gateway integration), FN0010 (recurring donation scheduling)
- EN: EN0009 (Transaction), EN0010 (RecurringTransaction)
- ES: ES0001 (ComGate), ES0002 (Netopia), ES0003 (MAIB), ES0004 (Moneta)
- BR: BR-PaymentAndMoneyIntegrity, BR-PaymentGatewayCallbacks, BR-RecurringDonationPolicy
- ARCH: ARCH0006 (Donations and Payments)

## Open Items

- Per-resource ownership predicates for public transaction/voucher POST are resource-plugin details
  deferred to the API/contract pass.
