# UC0005 — Make a Donation

## Header

| Field | Value |
|---|---|
| UC ID | UC0005 |
| Name | Make a Donation |
| Bounded Context | C4 |
| Primary Actor(s) | Customer, Integration(PaymentGateway) |
| Trigger Type | API |

## Actors & Responsibilities

- **Customer** — initiates a one-off or recurring donation against a Campaign (EN0004); may be anonymous (identified only by e-mail) or an already-authenticated donor.
- **System** — validates the donation request, resolves or creates the donor identity, creates the Transaction (EN0009) and, for recurring donations, the RecurringTransaction (EN0010) schedule; selects the country payment gateway and returns a redirect target to the Customer.
- **Integration(PaymentGateway)** — country-specific payment gateway (ComGate for CZ, Netopia/MobilPay for RO, MAIB for MD) that receives the transaction request and produces the page/URL the Customer is redirected to for payment capture.

## Intent

Let a Customer contribute money to a Campaign (EN0004), either as a single donation or as a recurring monthly pledge, and hand the payment off to the appropriate country payment gateway for capture. Actual payment confirmation (funds captured, status becomes PAID) is handled by the separate gateway-callback use case (UC0006).

## Preconditions

- A target Campaign (EN0004) exists and is not yet fully funded (its raised amount has not reached its target amount).
- The donation amount is a valid numeric value.
- The operating country (CZ / RO / MD) is configured, which determines which payment gateway integration is used.

## Main Flow

### UC0005.1 — Submit donation and resolve donor identity

1. Customer: submits a donation request for a Campaign (EN0004), giving an amount and, if not already logged in, an e-mail address and name; optionally marks the donation as recurring.
2. System: validates that the donation amount is numeric; rejects the request if it is not.
3. System: loads the target Campaign (EN0004) and rejects the request if the Campaign does not exist or is already fully funded.
4. System: resolves the donor identity — if the Customer is already logged in, the existing User (EN0008) is used as the donor.
5. System: if the Customer is not logged in, validates the given e-mail address and looks up an existing User (EN0008) by e-mail.
6. System: if no matching User (EN0008) is found, registers a new User (EN0008) with a supporter role together with a linked Contact (EN0006) record for the donor.
7. System: if a matching User (EN0008) is found but does not yet hold the supporter role, grants the supporter role to that User.
8. System: if the resolved donor User (EN0008) account is currently blocked, sends an account-activation message to the donor.
9. System: normalizes the donation amount to a whole-unit value; for the Czech market, raises amounts below the minimal unit up to that minimum.
10. System: creates a Transaction (EN0009) linked to the donor User (EN0008) and the target Campaign (EN0004), in PENDING status, recording whether the donor was authenticated and marking the Transaction as a test transaction outside the production environment.

### UC0005.2 — Set up recurring schedule (optional)

1. System: if the Customer requested a recurring donation, creates a RecurringTransaction (EN0010) linked to the newly created Transaction (EN0009), in an inactive state, with a monthly charge period and a charge day derived from today's date (capped so it always falls within a month).
2. System: if creation of the RecurringTransaction (EN0010) fails, logs the failure and continues without a recurring schedule; the recurring intent is lost for this donation.

### UC0005.3 — Hand off to country payment gateway

1. System: selects the payment gateway integration to use based on the configured operating country — Integration(MAIB) for Moldova, Integration(Netopia) for Romania, otherwise Integration(ComGate) for Czechia.
2a. Integration(MAIB): for Moldova, receives the transaction details (amount, currency, campaign reference) and prepares a payment page or redirect target for the Customer.
2b. Integration(Netopia): for Romania, receives the transaction details (amount, currency, campaign reference) and prepares a payment page or redirect target for the Customer.
2c. Integration(ComGate): otherwise, for Czechia, receives the transaction details (amount, currency, campaign reference) and prepares a payment page or redirect target for the Customer.
3. System: returns a successful response to the Customer containing the payment-gateway redirect target.
4. Customer: is redirected to the selected payment gateway integration to complete payment capture (continued in UC0006).

## Alternative Flows

### AF1 — Donation amount invalid

1. Customer: submits a donation request with a non-numeric amount.
2. System: rejects the request without creating a Transaction (EN0009).

Outcome: No Transaction (EN0009) is created; the Customer must resubmit with a valid amount.

### AF2 — Campaign missing or already fully funded

1. Customer: submits a donation request for a Campaign (EN0004) that does not exist, or whose raised amount already meets its target.
2. System: rejects the request without creating a Transaction (EN0009).

Outcome: No Transaction (EN0009) is created.

### AF3 — Donor account blocked at donation time

1. System: resolves the donor identity to a User (EN0008) whose account is blocked.
2. System: sends an account-activation message to the donor.
3. System: continues creating the Transaction (EN0009) as in UC0005.1, regardless of the account being blocked.

Outcome: The Transaction (EN0009) is created; the donor separately receives an activation message to regain full account access.

### AF4 — Recurring schedule creation fails

1. System: attempts to create a RecurringTransaction (EN0010) as in UC0005.2 and the creation fails.
2. System: logs the failure.

Outcome: The donation Transaction (EN0009) still proceeds to the payment gateway; no recurring schedule exists for it.

## Postconditions

- A Transaction (EN0009) exists in PENDING status, linked to the donor User (EN0008) and the target Campaign (EN0004); money has not yet been captured.
- If the donation was recurring and schedule creation succeeded, a RecurringTransaction (EN0010) exists, inactive, linked to the Transaction (EN0009).
- For first-time anonymous donors, a new User (EN0008) with the supporter role and a linked Contact (EN0006) now exist.
- The Customer holds a redirect target to the selected Integration(PaymentGateway) to complete payment; final confirmation and status change to PAID is handled by UC0006.

## Traceability

Target SRVs:
- Payment-Processing
- ComGate-Adapter
- Netopia-Adapter
- MAIB-Adapter
- Identity-&-Access
- Campaign-&-Story-Lifecycle

EN entities:
- EN0009 Transaction — the donation payment record created in PENDING status
- EN0010 RecurringTransaction — the recurring-donation schedule, created inactive alongside the Transaction
- EN0004 Campaign — the donation target; read to validate funding status
- EN0006 Contact — created alongside a new donor User for first-time anonymous donors
- EN0008 User — the donor identity; resolved, created, or role-upgraded during the donation

Integration boundaries:
- Integration(ComGate) — Czech payment gateway
- Integration(Netopia) — Romanian payment gateway
- Integration(MAIB) — Moldovan payment gateway

Flow Evidence:
- FLW0006 (Create transaction / donate)

## Evidence Level

Confirmed — grounded in FLW0006 (Confirmed confidence) for the donation-creation and gateway-dispatch behavior, and in EN0009/EN0010/EN0004/EN0006/EN0008 for entity fields and lifecycle states; the recurring-schedule-creation-failure and blocked-account paths are Confirmed as swallowed/logged behavior per the same dossier, not hypothesized.
