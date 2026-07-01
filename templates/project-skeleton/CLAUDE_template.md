# Project Constitution — AR-driven System Reconstruction

This repository is being analyzed and documented using ApplicationRenaissance (AR) orchestration tooling.

This is a documentation-first reconstruction effort.

The goal is to:

- extract business logic faithfully
- reconstruct the current system in a deterministic way
- produce rewrite-ready specifications without modifying the analyzed application


--------------------------------------------------
Tooling Location
--------------------------------------------------

All AR tooling is available inside this repository under:

tooling/

In practice, this repository may use `tooling/` as a symlink to a shared ApplicationRenaissance toolkit.

All agent and task references must therefore be resolved relative to this repository through `tooling/`.

Core locations:

- `tooling/orchestration/01-evidence-collection/`
- `tooling/orchestration/02-system-reconstruction/`
- `tooling/orchestration/03-spec-driven-documentation/`
- `tooling/orchestration/90-optional-bonus/`
- `tooling/orchestration/99-legacy/`
- `tooling/docs/`
- `tooling/templates/`


--------------------------------------------------
AR Job Invocation Convention
--------------------------------------------------

When the user writes:

Run AR:<AgentName>

You MUST:

1. Locate and load the matching agent spec under the `tooling/orchestration/` tree.
2. If a matching task file exists for the requested run, load it too.
3. Strictly follow both the agent spec and the task.
4. Resolve all paths relative to this repository root.

Agent specs are organized by pipeline stage, not in a single flat folder.

Task files may be grouped alongside the same stage structure.

Preferred task naming convention:

AgentName-task.md

If multiple matching task files exist, use the one that matches the current pipeline branch and run scope.


--------------------------------------------------
Pipeline Structure
--------------------------------------------------

AR work in this repository is organized into three main stages.

### 1. Evidence collection

This stage gathers and structures evidence about the system.

Typical agent areas:

- repository mapping
- database introspection
- PDF evidence extraction
- changelog evidence extraction
- SRV scouting
- flow scouting and flow mining

### 2. System reconstruction

This stage builds a consistent model of the current system from the evidence.

Typical agent areas:

- entity extraction
- use case composition
- domain kernel synthesis
- aggregate boundary modeling
- architecture overview writing

### 3. Spec-driven documentation

This stage transforms reconstructed knowledge into the target specification layers.

Typical agent areas:

- UC atomization
- EN canonicalization
- ARCH domain assembly
- FN synthesis
- ES synthesis
- MSG synthesis
- BR extraction
- rewrite decision compilation
- spec closure evaluation
- final publication generation

Optional or bonus branches may exist under:

- `tooling/orchestration/90-optional-bonus/`

Legacy agents may exist under:

- `tooling/orchestration/99-legacy/`


--------------------------------------------------
Write Scope Restriction (STRICT)
--------------------------------------------------

You may write ONLY to:

_ar/**

You must NEVER modify:

- production source code
- configuration files
- CI/CD files
- package manifests
- lock files
- database schema files
- infrastructure configuration
- generated application assets

Exception:
Only if explicitly instructed by the user.


--------------------------------------------------
Repository Scope (Monorepo Awareness)
--------------------------------------------------

This repository may be a monorepo.

You must:

- treat each deployable unit as a potential bounded context candidate
- avoid assuming frontend and backend share identical models
- respect cross-app and cross-package boundaries
- prefer evidence over repository naming assumptions

Ignore these folders completely:

- node_modules/
- build/
- dist/
- .next/
- .expo/
- coverage/
- .turbo/
- .cache/
- generated/
- out/


--------------------------------------------------
Documentation Layers (Strict Discipline)
--------------------------------------------------

All documentation must follow AR layer discipline.

Canonical layers:

- EN — Entities and invariants
- UC — Orchestration and business intent
- ARCH — System-level structure and navigation
- FN — Internal functional capabilities
- ES — External systems
- MSG — Transactional messages
- BR — Canonical business rules
- CS — Observed critical scenarios (FE-evidence runtime behavior)

Publication tier:

- Drafts are authored flat in `_ar/spec-draft/<LAYER>/`.
- The final publishable layer is tiered into `_ar/spec-final/BA/<LAYER>/` and reserved
  `_ar/spec-final/UX/<LAYER>/`, with one `_REGISTRY.md` per layer, as a drop-in hand-off
  for an arg-emitee rebuild. See `tooling/docs/rules-spec-final.md`.

Supporting layers:

- SRV — Service boundaries and service reconstruction
- FLOW — Execution flow evidence
- Evidence — Source-backed factual extraction

You must not mix layers.

Examples:

- no code-level implementation detail in UC or ARCH
- no hidden domain rules inside SRV
- no workflow detail inside BR
- no external system definition hidden inside FN
- no message contract hidden inside ES


--------------------------------------------------
Evidence-First Rule
--------------------------------------------------

No architectural or business claim may be written unless it is traceable to at least one of:

- repository source code
- existing documentation
- `_ar/evidence/**`
- `_ar/pdf/**`
- extracted change logs
- already reconstructed AR artifacts

If uncertain, explicitly mark it as:

Hypothesis — Not evidenced in current sources.

If something appears planned but not implemented, mark it as:

Status: Planned / Implemented / Unknown


--------------------------------------------------
Anti-Hallucination Rule
--------------------------------------------------

If information is missing:

- do NOT guess
- do NOT invent
- do NOT fill logical gaps silently
- explicitly state absence of evidence

If multiple sources disagree:

- do NOT resolve the conflict silently
- record the discrepancy in `_ar/evidence/**`
- mark it clearly as:

Conflict — requires clarification.


--------------------------------------------------
Architecture Discipline
--------------------------------------------------

Do not redesign the system unless explicitly instructed.

Do not suggest improvements unless a dedicated analysis or decision agent is running.

Default priority:
faithful reconstruction of the current system.

This means:

- describe how the system works
- do not replace it with how it should ideally work
- separate current-state evidence from future-state recommendations


--------------------------------------------------
Agent and Task Discipline
--------------------------------------------------

When following an AR agent:

- treat the agent spec as reusable methodology
- treat the task file as run-specific scope and constraints

Do not duplicate task-specific scope into canonical artifacts unless the agent explicitly requires it.

If an agent and task conflict:

- task wins for the current run only
- agent remains the reusable default behavior

If no task is provided:

- follow the agent spec only
- keep scope conservative
- do not broaden scope unnecessarily


--------------------------------------------------
Output Quality Standard
--------------------------------------------------

All produced documentation must be:

- deterministic
- structured
- rewrite-ready
- traceable
- layer-consistent
- evidence-based

Avoid:

- narrative fluff
- marketing language
- vague summaries without traceability
- implementation leakage in business-facing layers
- silent confidence inflation


--------------------------------------------------
Primary Objective
--------------------------------------------------

Reconstruct the analyzed system to a level where:

- the current system can be understood without browsing raw code constantly
- the architecture can be reasoned about explicitly
- a greenfield rewrite can be started without depending on the original developers
- the client can receive clear, layered, spec-driven documentation


--------------------------------------------------
Operational Default
--------------------------------------------------

Default working order:

1. Evidence collection
2. System reconstruction
3. Spec-driven documentation

Optional and legacy branches should be used only when relevant to the current run.

When in doubt:

- prefer faithful reconstruction over interpretation
- prefer narrower scope over uncontrolled expansion
- prefer explicit uncertainty over confident invention

--------------------------------------------------
Glossary Governance
--------------------------------------------------

Project terminology is governed through the AR glossary workflow.

Canonical glossary sources:

- `_ar/repo-map/glossary-master.csv` — machine-readable source of truth
- `_ar/repo-map/glossary.md` — published glossary for downstream agents
- `_ar/evidence/terminology/**` — candidate extraction, drift reports, and conflict logs
- `_ar/tasks/glossary-source-pack.md` — approved source whitelist and source hierarchy

Rules:

- No new canonical preferred term may be introduced without source-backed evidence.
- Terms without sufficient support may exist only as proposed, ambiguous, legacy, or rejected candidates.
- When terminology-sensitive agents run, they must consult the glossary workflow outputs before writing canonical artifacts.
- English canonical terminology is primary.
- Czech equivalents are maintained for publication readiness, but must not silently redefine English canonical meaning.

If terminology drift is detected, prefer:
1. candidate collection
2. drift analysis
3. promotion
4. glossary publication
before updating downstream specification layers.

--------------------------------------------------
Runtime Truth Policy
--------------------------------------------------

If the repository includes a runtime truth policy for the current pass, agents must respect it.

Default runtime policy location:

- `_ar/tasks/Runtime-truth-policy.md`

Rules:

- Runtime behavior may be used as evidence only within the approved scope.
- Runtime observation is authoritative for current observable behavior, not automatically for business semantics or rewrite design.
- If runtime evidence conflicts with canonical artifacts, record the conflict explicitly and resolve it through the appropriate evidence or repair flow.
- Agents must not silently promote runtime observations into canonical business meaning unless the runtime policy explicitly allows it.