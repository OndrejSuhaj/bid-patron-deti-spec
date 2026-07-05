---
doc_id: JOB0014
title: Transactional Mail Queue Consumer
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: async-consumer
references:
  - FN0019
  - EN0022
  - ES0006
---

# JOB0014 – Transactional Mail Queue Consumer

## Purpose

Consume queued transactional-message send requests and dispatch each e-mail via the messaging
service. The would-be async delivery path of FN0019 (Transactional Messaging & Templating).

Classification: **Confirmed** (worker exists) — but **currently dormant / bypassed** (see Trigger
Model): the messaging service sends synchronously and does not use this queue in current source.

## Trigger Model

- Asynchronous consumer (queue worker `id="mailing_queue"`). The worker delegates each item to the
  messaging service's direct-send method.
- **Currently bypassed:** the messaging service's use-queue flag is disabled, so mails are sent
  **synchronously in-request/in-save** rather than enqueued; and no cron key or module cron drains
  this queue. In the current state the queue is effectively unused. `Confirmed`.
- Evidence: `patron_base/src/Plugin/QueueWorker/MailingQueue.php` (`id="mailing_queue"`) delegating to
  the messaging service; queue-disabled flag noted across FLW0007/FLW0012/FLW0022 and FN0019.

## Input Scope

- Queue items carrying recipient addresses, template name, params, reply-to, attachments, and
  arguments (a fully-prepared send request). See EN0022.

## Processing Rules

- Per item: call the messaging service's direct-send method with the queued arguments, which resolves
  the per-country template, applies the environment send-gate, and archives the message.

## Side Effects

- Outbound e-mail via the messaging transport (Mautic, ES0006) and a message-archive record — but
  only if/when the queue is actually drained. In current state these effects occur synchronously in
  the calling flow instead, not through this worker.

## Idempotency

- No idempotency key on the send request; re-processing a claimed-but-not-deleted item would re-send.
  In practice the queue is not exercised in current state (see Trigger Model).

## Failure Handling

- Delivery failure semantics would follow whatever drain loop invokes the worker; none is wired
  today. Because sends are synchronous instead, a slow/failing transport blocks or aborts the
  enclosing persistence (documented under FN0019).

## References

- FN: FN0019
- UC: UC0012 and the calling triggers (UC0002/UC0004/UC0006/UC0010/UC0011/UC0015)
- EN: EN0022
- ES: ES0006
- Evidence: MailingQueue worker; FN0019 (USE_QUEUE disabled)

## Open Items

- **Status: Present but bypassed.** The queue and worker exist but are not driven in current state
  (synchronous send + no drain). Recorded so the rebuild treats async mail delivery as a *target*
  shape, not confirmed current behaviour.
