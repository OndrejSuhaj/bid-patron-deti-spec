# SRV0018 — Observability & Ops Alerting

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C11 — Platform / Integration Fabric

## SRV Category
Infrastructure / Security

## Responsibility Type
Adapter

## Purpose
Routes operational error/health signals and request/response audit data to external ops channels. It consolidates the Slack and Telegram PSR-3 logger adapters (error alerting) and the Elasticsearch audit-log writer into one observability boundary. This is ops-facing, not user messaging.

## Current Implementation Shape
- **Slack alerting:** `slack_integration` registers `logger.slack` channel — posts `ERROR` → `webhook_url_errors`, `CRITICAL` → `webhook_url_checks` via `httpClient->post()`; webhook URLs from `Settings::get('slack')`. `Evidence:` `PSRC/web/modules/custom/slack_integration/`; [integrations.md §5](../repo-map/integrations.md); [entrypoints.md §5](../repo-map/entrypoints.md).
- **Telegram alerting:** `telegram_integration` registers `logger.telegram` channel — forwards error-severity logs to `https://api.telegram.org/bot{botId}/sendMessage`; token/chat id from `Settings::get('telegram')` (`<redacted>`). Class docblock mislabeled `SlackLogger` (copy-paste). `Evidence:` `PSRC/web/modules/custom/telegram_integration/`; [integrations.md §5](../repo-map/integrations.md).
- **Audit-log store:** `elasticsearch` module `Elasticsearch` class — writes request/response audit records (ip, UA, method, query, request, response, status, referer, timing) to `http://elasticsearch:9200`; does NOT query/search. `Evidence:` `PSRC/web/modules/custom/elasticsearch/src/Elasticsearch.php`; [integrations.md §4](../repo-map/integrations.md).
- **Triggers:** PSR-3 logger channels fire on log events (severity-filtered); audit writer on request lifecycle. `Evidence:` [integrations.md §4,§5](../repo-map/integrations.md).

## Structural Issues
- **Thin adapter duplication** — Slack + Telegram loggers are near-identical PSR-3 forwarders; the Telegram class is even mislabeled `SlackLogger`. `Evidence:` [integrations.md §5](../repo-map/integrations.md); [SRV-candidates.md §5](SRV-candidates.md).
- **Audit store shares ES cluster with search** — the `elasticsearch` module (audit) and `patron_search` (search, SRV0016) write to the same hardcoded cluster; roles conflated at infra level. `Evidence:` [integrations.md §4](../repo-map/integrations.md).
- **Placeholder module metadata** — `elasticsearch` module ships the scaffold description ("My Awesome Module"). `Evidence:` [modules.md §1](../repo-map/modules.md).
- **Plaintext audit endpoint** — `http://elasticsearch:9200` hardcoded, no TLS. `Evidence:` [integrations.md §4](../repo-map/integrations.md).

## Target Shape (for rewrite)
A single Observability adapter with one alerting port (Slack/Telegram/… as channels) driven by structured log severity, and an audit-sink port writing request/response records to a dedicated store (separate from the search cluster). Endpoints/tokens from config; TLS.

## Integration Dependencies
- Slack — webhook URLs from `Settings::get('slack')`. `Confirmed`.
- Telegram — `https://api.telegram.org/bot{botId}/sendMessage`. `Confirmed`.
- Elasticsearch (audit log) — `http://elasticsearch:9200`. `Confirmed`.
`Evidence:` [integrations.md §4,§5](../repo-map/integrations.md).

## Boundaries
Does NOT do user/transactional messaging → SRV0013. Does NOT do search indexing (separate ES use) → SRV0016. Does NOT own the platform kernel/workflow → SRV0017.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Exact severity→channel routing and whether both Slack + Telegram fire. `Missing evidence: logger channel severity filters.`
- Audit-record write frequency/volume and retention. `Missing evidence: Elasticsearch::write() call frequency.`
- Firebase's real role (kreait dep present, call-site unverified). `Missing evidence: kreait/firebase-php call-site.`
