# UC0006 — Confirm Payment (Gateway Callback)

## Header

| Field | Value |
|---|---|
| UC ID | UC0006 |
| Name | Confirm Payment (Gateway Callback) |
| Bounded Context | C4 |
| Primary Actor(s) | Integration(PaymentGateway), System |
| Trigger Type | Webhook |

## Actors & Responsibilities

- **Integration(ComGate)** — CZ payment gateway; sends a server-to-server status callback for CZK payments and reports the gateway status and fee.
- **Integration(Netopia)** — RO payment gateway (MobilPay); sends an encrypted server-to-server confirmation (IPN) for RO payments, and separately returns the buyer's browser to a read-only result page.
- **Integration(MAIB)** — MD payment gateway; returns the buyer's browser with a reference id, which the System then uses to actively poll MAIB for the authoritative status.
- **System** — validates each callback/return, resolves the target Transaction (EN0009), maps the gateway-specific status vocabulary to the domain status, persists the outcome, and runs all downstream money side-effects (campaign totals, voucher promotion, recurring activation, role promotion, confirmation messaging, search indexing).
- **Customer** — the donor whose browser is redirected back from the gateway (Netopia, MAIB); receives a visual success/failure result but does not perform a status-changing action.

## Intent

Confirm the outcome of a payment initiated at a gateway and, on confirmation, update the Transaction (EN0009) and its dependent domain state (Campaign totals, Voucher, RecurringTransaction, User role, confirmation messaging) so that the donation is faithfully reflected across the platform — regardless of which of the three regional gateways (ComGate/CZ, Netopia/RO, MAIB/MD) is the source of truth for that Transaction.

## Preconditions

- A Transaction (EN0009) already exists in a non-final status (typically PENDING), created earlier when the donation/payment was initiated (see UC0005 — Make a Donation), and carries the gateway correlation identifier the callback will match against (external transaction id, order UUID, or gateway reference, depending on gateway).
- The relevant gateway configuration (merchant credentials, shared secret/keys, environment) is present for the region.
- For MAIB: the Transaction also carries the caller IP address captured at initiation, used when the System re-queries MAIB for status.

## Main Flow

### UC0006.1 — ComGate confirmation (CZ)

1. Integration(ComGate): Send a server-to-server status callback containing the merchant identification, shared secret, amount, currency, gateway reference, gateway transaction id, gateway status, and fee.
2. System: Validate the callback by comparing the submitted merchant identification and shared secret against the configured values; reject the callback if they do not match.
3. System: Look up the Transaction (EN0009) matching the callback's amount, gateway reference, and gateway transaction id.
4. System: If no matching Transaction is found, respond to Integration(ComGate) with a failure acknowledgement and take no further action.
5. System: If a matching Transaction is found, record the gateway status (PENDING / PAID / CANCELLED / AUTHORIZED / REFUNDED) and the gateway fee on the Transaction, and save it.
6. System: Respond to Integration(ComGate) with a success acknowledgement.
7. System: Apply the shared post-save side effects described in UC0006.4 for this Transaction.

### UC0006.2 — Netopia confirmation and browser return (RO)

1. Integration(Netopia): Send an encrypted server-to-server confirmation (IPN) containing the encrypted payment outcome and the donation order reference.
2. System: Decrypt the confirmation using the configured merchant key; if decryption fails, respond with a temporary-error acknowledgement and take no further action.
3. System: Resolve the target Transaction (EN0009) from the decrypted order reference.
4. System: Map the gateway-reported action to a domain status (confirmed → PAID; confirmed-pending/paid-pending/paid → PENDING; canceled → CANCELLED; credit → REFUNDED; unrecognized action or an error code → CANCELLED).
5. System: If a matching Transaction was resolved and the mapped status differs from the Transaction's current status, record the new status on the Transaction and save it; otherwise take no further action.
6. System: If the Transaction is linked to a RecurringTransaction (EN0010), record the gateway payment token and its expiry on the RecurringTransaction.
7. System: Respond to Integration(Netopia) with an acknowledgement reflecting success or failure.
8. System: Apply the shared post-save side effects described in UC0006.4 for this Transaction.
9. Customer: Return to the donation result page after completing payment at the gateway.
10. System: Resolve the Transaction by its order reference and display a success or failure result to the Customer, without changing any status (read-only).

### UC0006.3 — MAIB confirmation (MD)

1. Customer: Return from the MAIB gateway to the platform's status-confirmation endpoint, carrying the gateway's transaction reference.
2. System: Look up the Transaction (EN0009) whose stored gateway reference matches the returned value.
3. System: If no matching Transaction is found, redirect the Customer to the default landing page and take no further action.
4. System: If a matching Transaction is found, actively query Integration(MAIB) for the authoritative status of that gateway reference (server-to-server, using the platform's own credentials — the browser-supplied reference is not trusted on its own).
5. System: Map the MAIB-reported result to a domain status (OK → PAID; PENDING → PENDING; FAILED or DECLINED → CANCELLED; unrecognized or unreachable gateway → PENDING).
6. System: Record the mapped status on the Transaction and save it.
7. System: Apply the shared post-save side effects described in UC0006.4 for this Transaction.
8. System: Redirect the Customer to the donation Campaign (EN0004) page with a success or failure indicator; any status other than CANCELLED is shown to the Customer as success, including a still-PENDING outcome.

### UC0006.4 — Shared confirmation side effects (all gateways)

1. System: If this save is the Transaction's first transition to PAID, send a payment thank-you confirmation to the donor (Transactional-Messaging-Orchestrator).
2. System: Mark the Transaction as having sent that confirmation.
3. System: If the Transaction's owner (User, EN0008) is currently blocked at the moment of PAID confirmation, send an account-activation message to that owner.
4. System: If the Transaction reaches PAID and its owner does not yet hold the supporter role, grant the owner the supporter role.
5. System: If a Voucher (EN0013) purchase is linked to this Transaction and the Transaction reaches PAID, mark the matching unpaid Voucher as paid/ready-to-use.
6. System: Send the voucher-purchase confirmation to the Voucher's recipient.
7. System: If the Transaction reaches PAID and carries voucher-generation data with no Voucher yet created, generate the corresponding Voucher record(s) and their fulfilment documents (Document-Generation-&-Fulfilment).
8. System: Recompute the target Campaign's (EN0004) raised amount and percentage funded from all PAID Transactions against it, and save the Campaign.
9. System: If the recomputed raised amount now meets or exceeds the Campaign's target, mark the Campaign and its owning Application as complete and, in production, send a campaign-success confirmation.
10. System: If the recomputed raised amount exceeds the Campaign's target (overpayment), reduce this Transaction's recorded amount to the remaining need.
11. System: Create a new Transaction for the difference against the platform's transparent/general account.
12. System: If the Transaction reaches PAID and is linked to a RecurringTransaction (EN0010) that is not yet active, activate that RecurringTransaction.
13. System: Enqueue the Transaction for search-index synchronization.

## Alternative Flows

### AF1 — Callback authenticity cannot be established (ComGate)

1. Integration(ComGate): Send a status callback with a missing or mismatched shared secret or merchant identification.
2. System: Reject the callback without changing the Transaction; respond with a failure acknowledgement.

Outcome: The Transaction remains in its prior status; no side effects run. (Callback authenticity is governed by BR-PaymentGatewayCallbacks § Confirmation authentication — shared-secret-only, no signature/replay guard.)

### AF2 — Repeated or out-of-order gateway notifications

1. Integration(PaymentGateway): Resend a status notification the System already processed, or send notifications out of chronological order.
2. System: Re-apply the mapping and, where the resulting status differs from the Transaction's stored status, re-save the Transaction and re-run the shared side effects in UC0006.4; where the status is unchanged, most one-time side effects (confirmation message, voucher promotion, recurring activation) are skipped because they are guarded by an already-done marker, but campaign-total recomputation and search-index enqueue run again regardless.

Outcome: The Transaction converges on the gateway's latest reported status; recurring re-processing of campaign totals is a known side effect of repeated notifications, not a controlled idempotent no-op. Partial — this is a system behavior inferred from the flow evidence rather than a designed idempotence guarantee.

### AF3 — MAIB gateway unreachable during status verification

1. System: Attempt to query Integration(MAIB) for the authoritative status and receive no usable response (timeout or transport failure).
2. System: Treat the outcome as PENDING, record it on the Transaction, and save it.
3. System: Redirect the Customer to the Campaign result page, which — because only CANCELLED is treated as failure — displays a success indicator even though the payment is not yet confirmed PAID.

Outcome: The Transaction stays PENDING pending a later confirmed callback/poll; the Customer may see a success message ahead of actual confirmation. Partial — flow evidence documents this outcome explicitly as a donor-facing discrepancy.

### AF4 — Automatic-event-driven side effects (dormant)

1. System: (Not executed) A domain event signaling the Transaction's status change is defined but its dispatch is disabled in the current build.

Outcome: No listener reacts to Transaction status changes through this event path; any current-state cascade described in UC0006.4 happens only through the direct save-time steps, not through event subscription. Hypothesis / dormant feature — evidenced as present-but-disabled in the source-level flow dossiers, not exercised at runtime.

## Postconditions

- The Transaction (EN0009) carries the gateway-confirmed status (PENDING, PAID, CANCELLED, AUTHORIZED, or REFUNDED) and, where reported, the gateway fee.
- On first PAID confirmation: the donor has received a payment confirmation message; the owning User (EN0008) holds the supporter role; any linked Voucher (EN0013) is promoted to paid/ready-to-use or newly generated with its fulfilment document; any linked RecurringTransaction (EN0010) is active.
- The target Campaign's (EN0004) raised amount and percentage-funded reflect all PAID Transactions against it, and the Campaign (and its owning Application) is marked complete if fully funded.
- If the confirmed amount overpaid the Campaign's target, a new Transaction exists recording the surplus against the platform's transparent/general account.
- The Transaction is queued for search-index synchronization.
- For Netopia and MAIB, the donor's browser has been shown a result page reflecting the outcome (MAIB: any non-cancelled outcome, including still-pending, is shown as success).

## Traceability

Target SRVs:
- ComGate-Adapter
- Netopia-Adapter
- MAIB-Adapter
- Payment-Processing
- Campaign-&-Story-Lifecycle
- Document-Generation-&-Fulfilment
- Identity-&-Access
- Transactional-Messaging-Orchestrator

EN entities:
- EN0009 Transaction — the record whose status is confirmed and saved; hub of all money-side effects in this UC
- EN0004 Campaign — donation target whose raised amount/completion is recomputed on each confirmed Transaction
- EN0013 Voucher — promoted to paid/ready-to-use or generated when a linked Transaction reaches PAID
- EN0010 RecurringTransaction — activated, and (Netopia) receives its gateway token, when the linked Transaction reaches PAID
- EN0008 User — Transaction owner; gains the supporter role and may receive an activation message on PAID

Integration boundaries:
- ComGate (CZ payment gateway)
- Netopia/MobilPay (RO payment gateway)
- MAIB (MD payment gateway)

Governing rules:
- BR-PaymentGatewayCallbacks — callback authenticity & status mapping

Flow Evidence:
- FLW0003 (ComGate payment status callback)
- FLW0004 (Netopia/MobilPay confirm + redirect)
- FLW0005 (MAIB payment status callback)

## Evidence Level

Confirmed — grounded in FLW0003/FLW0004/FLW0005 mined flow dossiers (Confidence: Confirmed in all three) and EN0009/EN0004/EN0013/EN0010/EN0008 entity drafts for status vocabulary, fields, and relations; AF2 (repeated-notification behavior), AF3 (MAIB unreachable), and AF4 (dormant event dispatch) are called out as Partial/Hypothesis per the dossiers' own Failure Modes sections, not asserted as designed behavior.
