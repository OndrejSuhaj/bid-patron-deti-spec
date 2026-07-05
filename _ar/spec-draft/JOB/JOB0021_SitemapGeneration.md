---
doc_id: JOB0021
title: Sitemap Generation
canonical_layer: JOB
spec_type: job-contract
status: draft
job_type: batch
references:
  - FN0006
  - EN0004
---

# JOB0021 – Sitemap Generation

## Purpose

Generate the public `sitemap.xml` listing all published Campaign/Story URLs plus a static page list.
A supporting SEO batch for FN0006 (Campaign / Story Lifecycle Management) content surfaces.

Classification: **Confirmed**.

## Trigger Model

- Batch / CLI (Drupal Console) command `sitemap:create`. Operator- or externally-invoked; no cron
  wiring in source.
- Evidence: `sitemap/src/Command/GenerateSitemapCommand.php` (`setName('sitemap:create')`).

## Input Scope

- All published Campaign rows (id + changed timestamp), plus a static page list fetched from a JSON
  file at the SPA base URL (with a hardcoded external pastebin fallback). See EN0004.

## Processing Rules

- Build a URL set: one entry per static page and one per published Campaign (canonical URL, last-mod
  from the changed timestamp, fixed change-frequency/priority); write the XML to the public files
  area.

## Side Effects

- Writes `sitemap.xml` to the public files area. Outbound HTTP GET to fetch the static page list
  (SPA URL, or the pastebin fallback). No domain-entity mutation.

## Idempotency

- **Idempotent** — each run fully regenerates and overwrites the sitemap file from current published
  campaigns.

## Failure Handling

- If the SPA page-list JSON is unreachable, it falls back to a hardcoded external pastebin URL; if
  both fail, only campaign URLs are emitted. No retry loop.

## References

- FN: FN0006
- UC: UC0011
- EN: EN0004
- Evidence: GenerateSitemapCommand

## Open Items

- Dependence on an external pastebin URL as a fallback data source is a fragility/security concern
  (documented, not redesigned). Scheduling is not evidenced in source. `Hypothesis`.
