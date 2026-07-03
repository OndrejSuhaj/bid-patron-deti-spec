---
doc_id: FN0025
title: Workflow / Transition-Legality Engine & Scheduled Publish
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0022
  - UC0011
  - EN0001
  - EN0004
---

# FN0025 – Workflow / Transition-Legality Engine & Scheduled Publish

## Purpose

Provide the platform-wide allowed-transition / readiness gate that is expected to govern which
Application (EN0001) and Campaign (EN0004) state changes are legal and role-permitted, and run the
scheduled-publish job expected to promote date-gated content to its published state through that
gate without a human actor. This is the canonical slot for transition-legality named as a forward
reference from FN0002 (Application Status Orchestration & Reaction Fan-out), which explicitly
excludes server-side transition-legality enforcement from its own scope.

## Responsibilities

- Hold the workflow/transition configuration that defines the allowed states and role-gated
  transitions for the Application's (EN0001) large content-moderation workflow.
- Evaluate the allowed-transition / readiness gate that lifecycle actions — campaign publish and
  deadline-driven campaign uncompletion (UC0011) — pass through.
- Run a scheduled-publish tick (`patron_base_cron`) that selects unpublished CMS `page`/`page_cz`
  nodes whose `publish_date` equals today and promotes them to published, plus a first-flagged
  `/homepage` alias swap (UC0022; confirmed by FLW0033). This path publishes CMS node bundles
  directly and does not route through the transition-legality gate.

## Related Use Cases

UC0022 (Run Platform Workflow Engine & Scheduled Publish — primary; owns the scheduled-publish
sub-flow); UC0011 (Manage Campaign / Story Lifecycle — exercises the allowed-transition/readiness
gate for campaign publish and deadline-driven uncompletion).

## Related Entities

EN0001 (Application — subject of the workflow/transition configuration and its state changes);
EN0004 (Campaign — candidate subject of the date-gated scheduled-publish transition, and of the
gate exercised on publish/uncompletion).

## Integrations

None.

## Constraints

- The scheduled-publish flow is now mined (FLW0033, was flow-index FL057) — Confirmed. Scope
  correction: it publishes CMS `page`/`page_cz` node bundles only (not campaign/blog), using a strict
  `publish_date = today` equality selection, plus an optional first-flagged `/homepage` alias swap.
- Strict-equality selection is a current-state correctness risk (FLW0033): a missed cron day or a
  past-dated node is never auto-published — the node stays unpublished until published by hand. The
  homepage-alias swap is non-atomic (no DB transaction) and any exception is re-thrown, aborting the
  rest of the `patron_base` cron run.
- The scheduled-publish path does **not** route through the transition-legality gate — it publishes
  nodes directly.
- Transition-legality is largely **not enforced** on the live change forms in current state: a state
  change can reach any of the workflow's states with no server-side transition or role check. This
  gate is therefore largely a target-shape reconstruction rather than confirmed current behaviour.
  This is a current-state BR/behavioural gap, not an evidence gap — FLW0033 evidences the
  scheduled-publish flow but does not close the unenforced-legality gap.
