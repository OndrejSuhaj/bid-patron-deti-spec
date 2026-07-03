# UC0022 — Run Platform Workflow Engine & Scheduled Publish

## Header

| Field | Value |
|---|---|
| UC ID | UC0022 |
| Name | Run Platform Workflow Engine & Scheduled Publish |
| Bounded Context | C11 |
| Primary Actor(s) | System, Scheduler |
| Trigger Type | Config/Cron |

## Actors & Responsibilities

- **Scheduler** — runs the platform's recurring scheduled-publish cron on a fixed tick, without human interaction (the lifecycle cron itself is owned by UC0011).
- **System** — hosts the Workflow-Engine allowed-transition/readiness gate that governs which state changes are legal, and (for the scheduled-publish path owned here) is expected to promote date-gated content to published state through that gate; the lifecycle transitions the gate governs are exercised by UC0011.
- **Admin** — (supporting, not primary) manually triggers a publish/activation action that passes through the same Workflow-Engine gate; included here only to name the gate, not as this UC's owning flow — that flow is UC0011.
- **Reference-Data** (supporting lookup) — provides shared reference values (e.g. geographic lookups) consulted incidentally by publish logic; not a decision-making actor.

## Intent

Provide the platform-wide Workflow-Engine allowed-transition/readiness gate that governs legal state changes, and run the scheduled-publish job that promotes date-gated CMS content to its published state without a human actor initiating each change. The lifecycle transitions the gate governs (campaign publish, deadline-driven uncompletion) are exercised by UC0011 and are not narrated here. Note (from the mined scheduled-publish dossier FLW0033): the scheduled-publish job is a direct node-publish path that does not itself route through the Workflow-Engine gate.

## Preconditions

- A workflow/transition configuration exists that defines allowed states and role-gated transitions for the Application (EN0001).
- The Scheduler tick (platform cron) is configured and running.
- For the scheduled-publish sub-flow owned here: CMS `page`/`page_cz` node content items exist that are unpublished and carry a `publish_date` equal to the current day (evidenced — FLW0033; see Evidence Level).

## Main Flow

> Scope note: the allowed-transition and readiness gate enforced by the Workflow-Engine SRV is not narrated here — it is exercised in full by UC0011 (campaign publish, UC0011.1; deadline-driven campaign uncompletion, UC0011.2). See UC0011 for that flow, its Alternative Flows, and its Postconditions. This UC owns only the scheduled-publish sub-flow below (FLW0033).

### UC0022.1 — Scheduled publish of date-gated content (Confirmed — FLW0033)

1. Scheduler: triggers the scheduled-publish job on every platform cron tick (`patron_base_cron`).
2. System: selects CMS `page`/`page_cz` nodes that are unpublished (`status = 0`) and whose `publish_date` equals **today** (strict date-equality, in the site default timezone), ordered by node id ascending, and promotes each to published (`status 0 → 1`).
3. System: for the first due node (lowest nid) that carries the `replace_homepage` flag, performs a `/homepage` alias swap — the previous homepage node is unpublished, its `/homepage` alias is renamed `/homepage-{oldNid}`, and a new `/homepage` alias is created for the newly-published node. At most one homepage swap occurs per run.
4. System: writes an info log line recording the published node ids and whether the homepage was replaced.

> Status: Confirmed (FLW0033). Scope correction from the mined dossier: the scheduled-publish job promotes CMS `page`/`page_cz` **node** bundles only — it does **not** publish Applications (EN0001) or Campaigns (EN0004); campaign publishing/auto-complete lives in a separate flow (campaign_cron / UC0011). The strict `publish_date = today` equality (not `<=`) means a missed cron day or a past-dated node is never auto-published (stays unpublished until manual publish) — a current-state correctness risk carried from the dossier. This scheduled-publish path does **not** route through the Workflow-Engine transition-legality gate; that gate's non-enforcement is a separate current-state gap (see Evidence Level).

## Alternative Flows

> The failure and gate-rejection alternatives for the lifecycle-cron and readiness-gate paths (deadline-batch error handling, readiness/workflow configuration blocking a publish action) are owned by UC0011 (see UC0011 AF1–AF3) and are not restated here.

### AF1 — Scheduled-publish failure / homepage-swap no-op

1. System: encounters an error while publishing a due node or swapping the homepage alias.

Outcome (FLW0033): the publish loop and homepage swap perform several independent saves with **no DB transaction**, so a fatal mid-run can leave partial writes (e.g. `/homepage` alias renamed with no alias serving `/homepage`). Any exception is logged (channel `reports`) and **re-thrown**, aborting the remainder of the `patron_base` cron run. The homepage swap also silently no-ops (publishes the node but does not switch the homepage) when no `/homepage` alias exists or it does not point at a `/node/{n}` path.

## Postconditions

- The lifecycle-transition and readiness-gate postconditions (over-deadline uncompletion, gate-passing activation, and the resulting notifications and re-indexing) are owned by UC0011 — see UC0011 Postconditions; they are not restated here.
- Scheduled-publish sub-flow (UC0022.1, FLW0033): zero-or-more `page`/`page_cz` nodes with `publish_date == today` transition unpublished → published; if a published node carried `replace_homepage` (first by nid), the `/homepage` alias now points to it, the old alias is renamed `/homepage-{oldNid}`, and the previously-homepaged node is unpublished; an info log line records the batch. Nodes whose publish day was missed remain unpublished (strict-equality gap).

## Traceability

Target SRVs:
- Workflow-Engine
- ScheduledPublish-Processor
- Reference-Data

EN entities:
- EN0001 Application — subject of the Workflow-Engine transition configuration and its state changes (the gate exercised by UC0011); NOT a subject of the scheduled-publish sub-flow (FLW0033 confirms scheduled publish targets CMS `page`/`page_cz` node bundles, not Application).
- EN0004 Campaign — subject of the readiness-gated transitions on publish/uncompletion (exercised by UC0011); NOT a subject of the scheduled-publish sub-flow (per the FLW0033 scope correction). The CMS `page`/`page_cz` content published by UC0022.1 is a Drupal node bundle with no dedicated EN entity.

Integration boundaries:
- None (internal scheduler / entity + path_alias mutation; no external system called by this UC — confirmed by FLW0033).

Flow Evidence:
- FLW0033 (mined; was flow-index FL057) — `patron_base_cron` scheduled publish: date-equal publish of `page`/`page_cz` nodes + first-flagged `/homepage` alias swap. This UC's own Confirmed anchor for the scheduled-publish sub-flow (UC0022.1).
- FLW0021 / FLW0022 (borrowed from UC0011, not owned here — the Workflow-Engine allowed-transition/readiness gate is exercised by UC0011.1 campaign publish and UC0011.2 deadline-driven uncompletion; cited for cross-reference only, not as UC0022's own anchors)

## Evidence Level

Confirmed for the scheduled-publish sub-flow (UC0022.1), now that FLW0033 is mined: the `patron_base_cron` job, the strict `publish_date = today` node selection, the publish loop, and the `/homepage` alias swap are evidenced in a dedicated service class. Scope correction from the dossier: scheduled publish targets CMS `page`/`page_cz` nodes only (not Application/Campaign), and it does not route through the Workflow-Engine gate.

The **Workflow-Engine allowed-transition/readiness gate** itself is evidenced only indirectly here, by cross-reference to UC0011 (which owns FLW0021/FLW0022 as its Confirmed anchors); UC0022 does not re-narrate those flows. Its **transition-legality is largely not enforced in current state** — the live change forms let a state change reach any of the workflow's states with no server-side transition or role check (see SRV-flow-traceability §5 boundary violation 5, FLW0002). This is a current-state BR/behavioural gap, **not** an evidence gap: FLW0033 confirms the scheduled-publish flow is now evidenced but does not close the unenforced-legality gap.
