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
- (Expected) Run a scheduled-publish tick that evaluates date-gated content against the current
  time and applies the publish transition through the gate when due (UC0022).

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

- Partial — the scheduled-publish flow was never mined beyond an un-mined flow-index reference, so
  its mechanism is a coverage stub only and must not be treated as a confirmed mechanism.
- Transition-legality is not actually enforced on the live change forms in current state: a state
  change can reach any of the workflow's states with no server-side transition or role check. This
  gate is therefore largely a target-shape reconstruction rather than confirmed current behaviour.
- Kept broad by design: the underlying scheduled-publish job is un-mined and legality enforcement is
  largely absent in current state, so this capability is defined at the minimum abstraction the
  evidence supports.
