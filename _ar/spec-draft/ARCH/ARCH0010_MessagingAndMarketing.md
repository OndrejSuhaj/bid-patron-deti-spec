---
doc_id: ARCH0010
title: Messaging & Marketing Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
references:
  - ARCH0001
  - ARCH0002
  - EN0022
  - UC0012
  - UC0013
  - UC0015
  - FN0015
  - FN0016
  - FN0019
  - ES0006
  - ES0007
  - ES0008
  - ES0009
  - MSG0005
  - MSG0006
  - BR-TransactionalMessaging
  - BR-DataProtectionAndErasure
  - BR-MarketingAndAnalyticsRelay
---

# ARCH0010 – Messaging & Marketing Domain

> Domain navigation document for bounded context **C8 Messaging & Marketing** (ARCH0001 §4).
> Navigation layer only — links deeper artifacts by `doc_id`, does not restate them. Current-state.

## Purpose

Explains the architectural perspective of the **transactional messaging transport and marketing/CRM
sync**: how every user-facing message (email + in-zone) is templated, gated and dispatched, and how
party data and conversion signals are synced out to the marketing/CRM and analytics platforms. This is
the shared transport behind the messages that the other domains trigger.

---

## System Overview

C8 hosts the transactional-messaging orchestrator that resolves a per-country template, applies an
environment send-gate, and always archives a send record regardless of transmission
([EN0022](../EN/EN0022_EmailArchive.md); [FN0019](../FN/FN0019_TransactionalMessaging.md)). Its two
architectural traits of note: the mail queue is **disabled**, so all sends run synchronously
in-request / in-save — a slow or failing transport can block or abort the enclosing persistence
([ARCH0001](../ARCH0001_ApplicationOverview.md) §7; ARCH0002 §(b), HS13); and Mautic doubles as both
the CRM contact store and the actual mail transport. The context also relays conversion/analytics
signals (marketing-only, no domain impact) and carries a **GDPR anti-erasure hazard** — the CRM-sync
queue re-upserts an anonymised user with names intact (ARCH0001 §8 Risk 3).

The individual message *contracts* (trigger, recipients, intent) live in the **MSG** layer; this
domain owns the transport, and the message-owning domains (C1–C6, C9) each navigate the specific MSGs
they trigger.

---

## Structural Components

- **Transactional-Messaging-Orchestrator** (Orchestrator) — template resolution, send-gate, archive.
  Capability: [FN0019](../FN/FN0019_TransactionalMessaging.md).
- **Marketing / CRM adapter** (Integration adapter) — Mautic contact-upsert queue + GDPR sync.
  Capability: [FN0015](../FN/FN0015_MarketingCrmSync.md).
- **Conversion / analytics relay** (Integration adapters) — Facebook (CAPI + Pixel + Lead Ads stub)
  and Google Tag Manager. Capability: [FN0016](../FN/FN0016_ConversionAnalyticsRelay.md).
- **Email-domain-check adapter** — WhoisXML validation folded into the messaging path (FN0019).
- **No resident transactional aggregate** — EmailArchive ([EN0022](../EN/EN0022_EmailArchive.md)) is a
  per-send log, not an aggregate root (DOMAIN-aggregates §3).

---

## Interaction Model

Per [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(b)/(c):

- Called **synchronously** by almost every domain to dispatch messages: C1 status seam, C4 payment
  hub, C3 story lifecycle, C6 documents/tax, C9 auth — via
  [UC0012](../UC/UC0012_DispatchTransactionalMessage.md) (ARCH0002 §(a), the mail queue is disabled).
- Outbound to **Mautic** for transactional send and, on a queue, for CRM contact upsert
  ([ES0006](../ES/ES0006_Mautic.md); [UC0013](../UC/UC0013_SyncMarketingIntakeLeads.md);
  [UC0015](../UC/UC0015_AnonymizePersonalData.md); ARCH0002 §(b)/(c) — anti-erasure re-upsert).
- Outbound conversion/analytics relay to **Facebook** and **Google Tag Manager**
  ([ES0007](../ES/ES0007_Facebook.md), [ES0008](../ES/ES0008_GoogleTagManager.md)); the inbound
  Facebook Lead Ads webhook is a confirmed **not-implemented** stub (ARCH0001 §5, FN0016).
- Outbound email-domain validation to **WhoisXML** ([ES0009](../ES/ES0009_WhoisXmlApi.md)).
- Ops alerting (Slack/Telegram) is **not** transactional messaging — it is owned by C11
  ([ARCH0012](ARCH0012_PlatformSearchAndOperations.md)).

---

## Cross-links

- **relatedEN:** EN0022
- **relatedUC:** UC0012, UC0013, UC0015
- **relatedFN:** FN0015, FN0016, FN0019
- **relatedES:** ES0006 (Mautic), ES0007 (Facebook), ES0008 (Google Tag Manager), ES0009 (WhoisXML)
- **relatedMSG:** MSG0005, MSG0006 (the grouped status-fan-out catch-alls; C8 owns the transport for
  all 30 MSGs — each higher-salience message is navigated from its triggering domain, MSG-message-map)
- **relatedBR:** BR-TransactionalMessaging
  ([../BR/BR-TransactionalMessaging.md](../BR/BR-TransactionalMessaging.md)); the marketing
  anti-erasure rule lives in BR-DataProtectionAndErasure; the marketing CRM-sync, conversion/analytics
  relay, and inbound-lead-intake rules are owned by BR-MarketingAndAnalyticsRelay.
