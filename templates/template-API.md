---
doc_id: APIxxxx
title: <Contract Name>
canonical_layer: API
spec_type: api-contract
status: draft | canonical
contract_type: command
references:
  - UCxxxx
  - ENxxxx
  - FNxxxx
---

# APIxxxx – <Contract Name>

## Purpose

<What this contract exists to do.>

## Consumers

- <actor or system client>

## Authorization

- <required session / token / role / tenant scope>
- <or "open item" if not yet fully confirmed>

## Request

### Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `<field>` | <business meaning> | yes/no | <constraints or open items> |

## Response

### Success

| Field | Meaning | Notes |
|---|---|---|
| `<field>` | <business meaning> | <notes> |

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `<error>` | <business/business-technical failure> | yes/no | <notes> |

## Side Effects

- <created/updated entity or emitted message>
- <related state transition>

## References

- UC:
- EN:
- FN:
- BR:

## Open Items

- <uncertain payload or authorization point>