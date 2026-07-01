# Transactional Message Documentation Rules (MSG)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

MSG documents describe transactional messages sent to users.

Examples:

- confirmation emails
- notifications
- system reports

They define:

- when a message is sent
- who receives it
- what information it contains

---

## Naming

MSGxxxx – <Message Name>

Examples:

MSG0001 – Published Report Notification

---

## Required Frontmatter

---
doc_id: MSGxxxx
title: <Message Name>
canonical_layer: MSG
spec_type: transactional-message
status: draft | canonical
---

Optional:

trigger:
  - UCxxxx

references:
  - ENxxxx

---

## Recommended Structure

## Purpose  
## Trigger  
## Recipients  
## Message Content  

---

## Cross-references (reference, don't restate)

MSG owns transactional messages (trigger, recipients, content). It references other layers by
`doc_id` and never restates their content:

- References: `UCxxxx`, `ENxxxx`.
- Never inline (cite instead): entity attributes (→ `EN`), rule content (→ `BR`).

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

MSG documents must not contain:

- HTML templates
- email styling
- mail provider configuration