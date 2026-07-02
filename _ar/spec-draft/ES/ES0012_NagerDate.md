---
doc_id: ES0012
title: Nager.Date
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0006
  - UC0011
---

# ES0012 – Nager.Date

## Purpose

Nager.Date provides the Romanian public-holiday calendar the platform consults so that a
campaign/story deadline can be validated as falling on a working day. It exists to answer a single
narrow question — "is this date a public holiday?" — for the RO market's deadline rule, without
Patronus maintaining its own holiday calendar.

---

## System Overview

Nager.Date is a public-holiday calendar service: given a date and a country, it reports whether
that date is a public holiday in that country. It is one of the outbound external systems named in
the Integration Landscape (`ARCH0001` §5, row 17) and in the context→external chain for the
Campaign-&-Story context (`ARCH0002`).

---

## Integration Model

Outbound, synchronous lookup. The platform calls Nager.Date at the point a Romania-scoped
campaign/story deadline is edited and saved — as part of validating that field — not as part of a
scheduled/cron job. Results are cached by the platform for a long duration, and the call itself is
made with a short timeout suited to a validation-time check rather than a background sync
(`ARCH0001` §5 row 17; `ARCH0002` context→external chains).

---

## Data Exchange

- **Outbound (Patronus → Nager.Date):** a date to check together with the country scope (Romania).
- **Inbound (Nager.Date → Patronus):** a public-holiday indication for that date (conceptually,
  yes/no).

No other data is exchanged; the exchange is limited to this single working-day determination.

---

## Constraints

- **Scope:** Romania-only; the check applies solely to the RO campaign/story deadline rule
  (`ARCH0001` §5 row 17; `FN0006`).
- **Fail-open failure impact:** if Nager.Date is unavailable or the lookup fails, the date is
  treated as a working day and the RO working-day rule is silently bypassed rather than blocking
  the action — a current-state gap, not a designed exception path (`ARCH0001` §5 row 17;
  `ARCH0002` — flagged fail-open in the context→external chain; `FN0006`; `UC0011`).
- **Timing:** the lookup runs synchronously at deadline edit/save (field validation); it is not
  part of any scheduled job.
- **Current-state only:** this describes Nager.Date's role as integrated today; the working-day
  business rule it feeds is owned and described by `FN0006` / `UC0011`, not restated here.
