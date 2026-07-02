---
doc_id: ES0015
title: Slack
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0023
  - FN0007
  - UC0020
---

# ES0015 – Slack

## Purpose

Slack is an external team-messaging channel used purely for internal, outbound notifications: it gives
operations staff near-real-time visibility into error and health conditions raised elsewhere in the
platform, and — on a separate payment code path — receives donation / voucher-purchase business-event
pings. It is one of the two ops-alerting boundaries in the Integration Landscape (ARCH0001 §5, row 15).

---

## System Overview

Slack is a team-messaging platform. At this integration boundary it acts purely as a receiver of
inbound webhook posts to operational channels — it is not addressed for any user-facing or
transactional purpose, only for internal ops alerting.

---

## Integration Model

Outbound only, via incoming webhooks, in two distinct modes:

- **Ops-alert logger channel** (UC0020, FN0023): a logging channel forwards messages when a loggable
  condition reaches ERROR or CRITICAL severity, routed to separate error and check channels. Its
  webhook targets are supplied by deployment configuration (not embedded in code).
- **Business-event ping** (FN0007; FLW0003 / FLW0005 / FLW0007): on a successful donation or
  voucher-purchase payment, a confirmation ping is posted to a webhook target embedded in the payment
  code path (hardcoded), gated to the CZ tenant in production only.

Both are best-effort side-effects embedded in other flows, not dedicated request-response exchanges.
This corresponds to ARCH0002's ops-alert/audit listener chain (Slack alongside Telegram).

---

## Data Exchange

- Outbound only. Mode 1: operational error/health alert messages (ERROR/CRITICAL severity). Mode 2:
  donation / voucher-purchase confirmation pings.
- Conceptual, ops- and business-event-facing content only — not user-facing/transactional messaging
  and not domain data. No payload or field-level detail is defined here.

---

## Constraints

- Delivery is best-effort: a failed post only loses the notification — it does not affect the outcome
  of the originating process.
- Two configuration postures coexist: the ops-alert logger channel's webhook targets come from
  deployment configuration, whereas the donation / voucher-purchase ping uses a webhook target
  hardcoded in the payment code path (FLW0003 / FLW0005 / FLW0007) — a lock-in / rotation risk. The
  ops-alert listener flow itself was un-mined (**Partial**, HS16) (ARCH0001 §5 row 15).
- The Application↔Campaign desync warning (INV04) is **not** carried by Slack: DOMAIN-kernel and
  CONSISTENCY-boundaries (the INV04 owners) record it as Telegram-only (see ES0016). ARCH0001 §5 row 15
  and ARCH0002 group Slack + Telegram together for ops alerting generally, but the desync-specific
  channel is Telegram. **Conflict — requires clarification** (ARCH vs DOMAIN/CONSISTENCY), flagged for
  the cross-layer audit.
- Ops error alerting + donation/voucher pings only — distinct from transactional user messaging
  (Mautic / MSG layer). Grouped with Telegram in the ops-alerting cluster (FN0023) but a separate
  vendor boundary.
- Current-state only; these constraints reflect the system as implemented, not a target design.
