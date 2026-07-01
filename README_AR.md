# ApplicationRenaissance — Reverse Engineering and Spec Reconstruction Framework

ApplicationRenaissance (AR) is a framework for reverse engineering existing software systems and reconstructing a deterministic, spec-driven system description.

The framework is built around three main steps:

1. Evidence collection
2. System reconstruction
3. Spec-driven documentation

The goal is to move from raw evidence to a structured specification that can support:

- system understanding
- architecture reconstruction
- vendor takeover
- rewrite planning
- client-readable documentation


--------------------------------------------------
Approach
--------------------------------------------------

The proposed approach consists of three main steps.

### 1. Evidence collection

Gather all available sources of information about the system, such as:

- repository structure
- database schema
- historical changes
- existing documentation
- screenshots of the user interface

These materials form the evidential foundation for further analysis.

In other words: first we determine what we actually know.

### 2. System reconstruction

Using the available evidence, reconstruct key aspects of the system, including:

- main entities and their lifecycles
- core processes and data flows
- business rules
- services and responsibilities
- overall architecture

The goal is to build a consistent model of the system independent of implementation details.

In other words: describe how the system works, not how it happens to be written.

### 3. Spec-driven documentation

Convert the reconstructed knowledge into the documentation structure used by the spec-driven development methodology.

The result is documentation that can serve as:

- input for designing a new system
- support for architectural decisions
- a clear reference for the client

Ideally something that both architects and clients can read and actually understand.


--------------------------------------------------
Core Goals
--------------------------------------------------

ApplicationRenaissance aims to reconstruct:

- 100 percent business logic visibility
- approximately 80 percent technical implementation coverage
- rewrite-ready architecture documentation

The resulting artifacts should allow a new team to understand, redesign, and rewrite a system without relying on the original developers.


--------------------------------------------------
Repository Rules
--------------------------------------------------

All generated artifacts must be written into:

_ar/

Production code must never be modified unless explicitly requested.

Ignore folders during analysis:

node_modules/
build/
dist/
.next/
.expo/
coverage/


--------------------------------------------------
Required Project Structure
--------------------------------------------------

Recommended working structure:

_ar/
  coverage/
  evidence/
  repo-map/
  spec-draft/            flat working layout: spec-draft/<LAYER>/
  spec-final/            tiered hand-off layout (drop-in for arg-emitee):
    BA/<LAYER>/          EN UC BR FN ARCH ES MSG CS API JOB ACL QUERY
    UX/<LAYER>/          IA WIRE COMP COPY (reserved)
  tasks/

  prtsc/ optional UI screenshots
  pdf/ optional external documents

Note: spec-draft stays flat; only spec-final is tiered into BA/UX, with one
`_REGISTRY.md` per layer and files named `<doc_id>-<kebab-title>.md`. See
`docs/rules-spec-final.md`.

The repository should also contain AR tooling:

tooling/

At minimum:

tooling/orchestration/
tooling/docs/
tooling/templates/


--------------------------------------------------
AR Job Invocation Convention
--------------------------------------------------

Agents are executed using:

Run AR:<AgentName>

Example:

Run AR:RepoCartographer

Each agent is defined in a markdown file inside the orchestration tree.

Task files, if used, should mirror the same grouping and use a consistent naming convention:

AgentName-task.md


--------------------------------------------------
Specification Layers
--------------------------------------------------

Canonical specification layers:

ARCH  architecture navigation and domain overview
FN    internal functional capabilities
UC    use cases describing behaviour
EN    domain entities
BR    business rules
ES    external systems
MSG   transactional messages

Supporting reconstruction layers:

SRV   service reconstruction
FLOW  execution flow traces
repo-map
evidence

Final publishable specification typically consists of:

ARCH
FN
UC
EN
BR
ES
MSG
CS

The above BA-tier layers are published under `_ar/spec-final/BA/<LAYER>/`. The UX-tier layers
(IA, WIRE, COMP, COPY) are produced by the optional `ux-reconstruction` branch and published
under `_ar/spec-final/UX/<LAYER>/` (scaffolded empty when that branch has not run).


--------------------------------------------------
Pipeline Overview
--------------------------------------------------

AR is organized into three main stages:

1. Evidence collection
2. System reconstruction
3. Spec-driven documentation

In addition, the framework contains:

- optional bonus branches
- legacy agents kept only for compatibility or future review


--------------------------------------------------
1. Evidence Collection
--------------------------------------------------

This stage collects and structures evidence before interpretation.

### Core agents

RepoCartographer

Purpose:
- map repository structure
- identify entrypoints, modules, and integration signals

DBIntrospector

Purpose:
- extract persistence structure
- identify entities, relations, and constraints

PDFEvidenceCurator

Purpose:
- extract evidence from external documentation
- recover historical requirements and domain terms

ChangeLogEvidenceCurator

Purpose:
- extract domain signals from historical changes
- recover missing features and terminology

SRVCurator

Purpose:
- identify service candidates from implementation
- reconstruct service boundaries as evidence

SRVRestructurer

Purpose:
- normalize SRV evidence into a layered service model

FlowInspector

Purpose:
- detect candidate flows and entrypoints

FlowMiner

Purpose:
- reconstruct actual orchestration flows
- produce lifecycle and traceability evidence


### Result of this step

This step should answer:

- what evidence exists
- what parts of the system are visible
- what can be stated with confidence

### Glossary

For domain-heavy or terminology-sensitive projects, AR may also use an optional glossary workflow. See chapter at the end of this document. 

--------------------------------------------------
2. System Reconstruction
--------------------------------------------------

This stage builds a consistent system model from the collected evidence.

### Core agents

ENExtractor

Purpose:
- reconstruct domain entities
- identify lifecycle signals

UCComposer

Purpose:
- reconstruct business use cases from flows and entities

DomainKernelSynthesizer

Purpose:
- define canonical domain concepts
- identify shared invariants and state machines

AggregateBoundaryModeler

Purpose:
- define aggregate roots and consistency boundaries

ARCHWriter

Purpose:
- produce base architecture documents
- describe system-level structure


### Optional bonus agents

EntityInventoryCloser

Purpose:
- close long-tail entity coverage
- document the full persisted landscape without expanding everything into EN pages

MissingCoreEntityWriter

Purpose:
- create only the highest-value missing EN pages that are already evidenced


### Result of this step

This step should answer:

- what the system is made of
- how the core domain behaves
- what the main lifecycles, boundaries, and flows are


--------------------------------------------------
3. Spec-Driven Documentation
--------------------------------------------------

This stage converts the reconstructed system model into clean, publishable, spec-driven documentation.

### Core agents

UCAtomizer

Purpose:
- split orchestration-heavy UC documents into smaller domain-oriented use cases

ENCanonicalizer

Purpose:
- clean EN documents
- remove implementation leakage
- preserve lifecycle, invariants, and relationships in canonical form

ARCHDomainAssembler

Purpose:
- create one domain ARCH page per major domain
- make ARCH the primary navigation layer

FNSynthesizer

Purpose:
- synthesize the internal capability layer
- replace SRV and FLOW as publish-facing capability artifacts

ESSynthesizer

Purpose:
- synthesize the external systems layer

MSGSynthesizer

Purpose:
- synthesize the transactional message layer

BRExtractor

Purpose:
- extract canonical business rules
- normalize them into deterministic rule language

CrossLayerAuditor

Purpose:
- enforce the cross-layer authoring discipline (single-source-of-truth)
- detect content one layer restates but another owns, and rewrite it to doc_id references
- de-duplicates what spec-final-generator deliberately will not; run after layer synthesis, before closure

RefIntegrityValidator

Purpose:
- build the draft-phase _REGISTRY.md per layer (the authoritative list of doc_ids)
- validate referential integrity: doc_id uniqueness, and that every reference resolves
- report dangling references and collisions as Open Questions (no renumbering, no invention)
- run after CrossLayerAuditor; the draft registries carry over into publication

RewriteDecisionCompiler

Purpose:
- produce rewrite strategy recommendations

SpecClosureEvaluator

Purpose:
- evaluate whether the documentation is sufficient for understanding, planning, or rewrite
- runs as a measurable checklist against `docs/definition-of-done.md` (per-dimension PASS/PARTIAL/BLOCKED + closure state + confidence), consuming the referential-integrity and cross-layer audit reports

spec-final-generator

Purpose:
- copy canonical draft artifacts into _ar/spec-final/
- preserve identifiers and structure
- translate the final publication layer into Czech


### Result of this step

This step should answer:

- how the system should be documented for architects
- how the system should be documented for clients
- whether the system is ready for redesign or rewrite


--------------------------------------------------
Optional Bonus Branches
--------------------------------------------------

These branches are useful but not always needed in the main path.

### UI coverage branch

ScreenshotCoverageAuditor

Purpose:
- compare reconstructed spec with actual UI surface

UIGapToSpecPlanner

Purpose:
- turn UI coverage gaps into structured documentation tasks

GapClosureSpecWriter

Purpose:
- convert approved UI gaps into EN and UC artifacts

When to use:
- screenshots exist
- UI is an important source of missing behaviour
- coverage validation matters


### UX reconstruction branch

IASynthesizer
WIRESynthesizer
COMPSynthesizer
COPYSynthesizer

Purpose:
- reconstruct the UX-tier layers (IA, WIRE, COMP, COPY) from observed UI evidence
- produce a publishable UX surface that drops into an arg-emitee rebuild's `_ar/UX/`

Run order (dependencies): IASynthesizer (screen map) -> WIRESynthesizer (screen_id + realizes_uc)
-> COMPSynthesizer + COPYSynthesizer. Re-run spec-final-generator afterwards to publish UX into
`_ar/spec-final/UX/`.

When to use:
- screenshots exist and the UI-coverage branch has run
- the rebuild needs a UX specification (navigation, screens, components, copy), not just the domain core

Notes:
- evidence-gated: nothing is reconstructed without UI evidence; COMP is created only on observable reuse
- observed UI is suggestive, not canonical; unknowns are surfaced as Open Questions


### Inventory closure branch

EntityInventoryCloser
MissingCoreEntityWriter

When to use:
- takeover requires wide entity visibility
- spec closure requires long-tail coverage
- current-state completeness matters more than minimal rewrite core


--------------------------------------------------
Legacy Agents
--------------------------------------------------

BRSynthesizer

Status:
legacy

Current role:
- optional high-level BR orientation layer

Why legacy:
- it overlaps conceptually with ARCHDomainAssembler and BRExtractor
- it may still be useful for orientation
- it should not be treated as part of the core canonical pipeline until re-evaluated


--------------------------------------------------
Recommended Execution Order
--------------------------------------------------

Typical core workflow:

RepoCartographer
DBIntrospector

PDFEvidenceCurator
ChangeLogEvidenceCurator

SRVCurator
SRVRestructurer

FlowInspector
FlowMiner

ENExtractor
UCComposer
DomainKernelSynthesizer
AggregateBoundaryModeler
ARCHWriter

UCAtomizer
ENCanonicalizer
ARCHDomainAssembler
FNSynthesizer
ESSynthesizer
MSGSynthesizer
BRExtractor

CrossLayerAuditor
RefIntegrityValidator

RewriteDecisionCompiler
SpecClosureEvaluator
spec-final-generator


Optional additions:

EntityInventoryCloser
MissingCoreEntityWriter

ScreenshotCoverageAuditor
UIGapToSpecPlanner
GapClosureSpecWriter

IASynthesizer
WIRESynthesizer
COMPSynthesizer
COPYSynthesizer
spec-final-generator   (re-run to publish UX tier)


Legacy optional:

BRSynthesizer


--------------------------------------------------
Practical Notes
--------------------------------------------------

Do not run UI analysis too early.

Screenshots are observational evidence, not canonical truth.

Domain truth should come primarily from:

- source code
- database structure
- orchestration flows

UI analysis is useful mainly for:

- coverage validation
- discovering undocumented behaviour
- identifying user-visible features that are missing in the spec

Do not use spec-final-generator to repair weak draft artifacts.
If the draft is weak, fix the relevant canonical layer first.


--------------------------------------------------
Target Folder Structure
--------------------------------------------------

The final target structure should mirror the three-step approach and separate core, optional, and legacy agents.

tooling/
  docs/
    rules-ARCH.md
    rules-BR.md
    rules-EN.md
    rules-ES.md
    rules-FN.md
    rules-MSG.md
    rules-UC.md
    rules-spec-final.md

  templates/
    template-ARCH.md
    template-BR.md
    template-EN.md
    template-ES.md
    template-FN.md
    template-MSG.md
    template-UC.md
    template-spec-final.md

  orchestration/
    01-evidence-collection/
      agents/
        RepoCartographer.md
        DBIntrospector.md
        PDFEvidenceCurator.md
        ChangeLogEvidenceCurator.md
        SRVCurator.md
        SRVRestructurer.md
        FlowInspector.md
        FlowMiner.md
      tasks/
        RepoCartographer-task.md
        DBIntrospector-task.md
        PDFEvidenceCurator-task.md
        ChangeLogEvidenceCurator-task.md
        SRVCurator-task.md
        SRVRestructurer-task.md
        FlowInspector-task.md
        FlowMiner-task.md

    02-system-reconstruction/
      agents/
        ENExtractor.md
        UCComposer.md
        DomainKernelSynthesizer.md
        AggregateBoundaryModeler.md
        ARCHWriter.md
      tasks/
        ENExtractor-task.md
        UCComposer-task.md
        DomainKernelSynthesizer-task.md
        AggregateBoundaryModeler-task.md
        ARCHWriter-task.md

    03-spec-driven-documentation/
      agents/
        UCAtomizer.md
        ENCanonicalizer.md
        ARCHDomainAssembler.md
        FNSynthesizer.md
        ESSynthesizer.md
        MSGSynthesizer.md
        BRExtractor.md
        CrossLayerAuditor.md
        RefIntegrityValidator.md
        RewriteDecisionCompiler.md
        SpecClosureEvaluator.md
        spec-final-generator.md
      tasks/
        UCAtomizer-task.md
        ENCanonicalizer-task.md
        ARCHDomainAssembler-task.md
        FNSynthesizer-task.md
        ESSynthesizer-task.md
        MSGSynthesizer-task.md
        BRExtractor-task.md
        CrossLayerAuditor-task.md
        RefIntegrityValidator-task.md
        RewriteDecisionCompiler-task.md
        SpecClosureEvaluator-task.md
        spec-final-generator-task.md

    90-optional-bonus/
      ui-coverage/
        agents/
          ScreenshotCoverageAuditor.md
          UIGapToSpecPlanner.md
          GapClosureSpecWriter.md
        tasks/
          ScreenshotCoverageAuditor-task.md
          UIGapToSpecPlanner-task.md
          GapClosureSpecWriter-task.md

      ux-reconstruction/
        agents/
          IASynthesizer.md
          WIRESynthesizer.md
          COMPSynthesizer.md
          COPYSynthesizer.md
        tasks/
          IASynthesizer-task.md
          WIRESynthesizer-task.md
          COMPSynthesizer-task.md
          COPYSynthesizer-task.md

      inventory-closure/
        agents/
          EntityInventoryCloser.md
          MissingCoreEntityWriter.md
        tasks/
          EntityInventoryCloser-task.md
          MissingCoreEntityWriter-task.md

    99-legacy/
      agents/
        BRSynthesizer.md
      tasks/
        BRSynthesizer-task.md


--------------------------------------------------
Naming Convention
--------------------------------------------------

Recommended final convention:

- agent spec files:
  AgentName.md

- task files:
  AgentName-task.md

Do not mix naming styles such as:

- snake_case.md
- kebab-case.md
- AgentName-task.md

Choose one convention and keep it consistent.

Recommended convention for AR:
AgentName.md
AgentName-task.md


--------------------------------------------------
Using AR on a New Project
--------------------------------------------------

When applying AR to another project you may need to adjust:

- ignored folders depending on framework
- persistence introspection depending on storage technology
- external evidence sources
- UI evidence format
- spec naming conventions
- how strongly you use optional late-phase normalization agents such as ENCanonicalizer or EntityInventoryCloser

The orchestration pipeline itself should remain stable.


--------------------------------------------------
Glossary
--------------------------------------------------
## Optional Terminology / Glossary Branch

Use this branch only for projects with strong domain vocabulary, regulated terminology, bilingual publication needs, or repeated naming drift between evidence, entities, use cases, and client wording.

Typical examples:
- accounting / tax / legal systems
- healthcare / insurance / logistics / ERP
- projects with Czech UI wording but English canonical documentation
- projects where the same label is reused for module, entity, document type, and UI item

### Purpose

This branch helps AR:

- collect source-backed terminology candidates
- detect terminology drift before it contaminates canonical layers
- publish a stable Czech/English terminology bridge for downstream agents

It is optional.
For simple projects, skip it.

---

## Prerequisites

Before using this branch, these files should exist:

### Canonical glossary storage
- `_ar/repo-map/glossary-master.csv`  
  Machine-readable source of truth for approved glossary terms. See template:
  `_ar/templates/project-skeleton/.`

- `_ar/repo-map/glossary.md`  
  Published glossary for downstream agents.  
  This is generated from `glossary-master.csv` and should normally not be edited manually.

### Glossary governance inputs
- `_ar/tasks/glossary-source-pack.md`  
  Approved terminology source whitelist and source hierarchy. See template:
  `_ar/templates/project-skeleton/.`

- `_ar/tasks/glossary-scope.md`  
  Defines which terminology areas are currently in scope. See template:
  `_ar/templates/project-skeleton/.`

- `_ar/tasks/glossary-arbitration-decisions.md`  
  Human decisions for blocked or ambiguous term families. See template:
  `_ar/templates/project-skeleton/.`

### Working evidence area
- `_ar/evidence/terminology/`  
  Output folder for candidate extraction, drift reports, and glossary governance artifacts.

### Optional supporting inputs
- `_ar/pdf/**`
- `_ar/evidence/pdf/**`
- `_ar/evidence/changelog-*.md`
- `_ar/spec-draft/**`
- `_ar/repo-map/**`

These are not required for every run, but the glossary branch is only useful if terminology candidates can be extracted from real evidence.

---

## Agents

### GlossaryCandidateCollector
Path:
- `tooling/orchestration/00-glossary-governance/agents/GlossaryCandidateCollector.md`

Task:
- `tooling/orchestration/00-glossary-governance/tasks/GlossaryCandidateCollector-task.md`

Purpose:
- collect source-backed terminology candidates from evidence
- keep candidates conservative
- do not promote unsupported terms into the canonical glossary

Typical outputs:
- `_ar/evidence/terminology/glossary-candidates.md`
- `_ar/evidence/terminology/glossary-source-index.md`
- `_ar/evidence/terminology/glossary-candidate-report.md`
- `_ar/evidence/terminology/glossary-open-questions.md`
- `_ar/evidence/terminology/glossary-missing-terms.md`

### GlossaryDriftAnalyzer
Path:
- `tooling/orchestration/00-glossary-governance/agents/GlossaryDriftAnalyzer.md`

Task:
- `tooling/orchestration/00-glossary-governance/tasks/GlossaryDriftAnalyzer-task.md`

Purpose:
- compare candidates and draft artifacts against the current glossary
- surface duplicates, near-matches, synonym drift, overloaded terms, and blocked families
- separate safe promotion candidates from terms that require arbitration

Typical outputs:
- `_ar/evidence/terminology/glossary-drift-report.md`
- updates to existing terminology reports if needed

### Optional continuation

#### GlossaryPromoter
Path:
- `tooling/orchestration/00-glossary-governance/agents/GlossaryPromoter.md`

Task:
- `tooling/orchestration/00-glossary-governance/tasks/GlossaryPromoter-task.md`

Purpose:
- promote only safe, source-backed terms into `_ar/repo-map/glossary-master.csv`

#### GlossaryPublisher
Path:
- `tooling/orchestration/00-glossary-governance/agents/GlossaryPublisher.md`

Task:
- `tooling/orchestration/00-glossary-governance/tasks/GlossaryPublisher-task.md`

Purpose:
- publish `_ar/repo-map/glossary-master.csv` into `_ar/repo-map/glossary.md`

---

## Recommended usage

Use the branch in this order:

1. `GlossaryCandidateCollector`
2. `GlossaryDriftAnalyzer`
3. Optional: `GlossaryPromoter`
4. Optional: `GlossaryPublisher`

Use it:
- after PDF / changelog evidence runs
- after major EN / UC / Domain passes if terminology drift appears
- before terminology-sensitive downstream normalization or publication

Do not use it to invent terminology.
Do not promote terms without source-backed evidence.
If a term family is ambiguous, keep it blocked until arbitration is recorded.

---

## Minimal execution examples

```text
Run AR:GlossaryCandidateCollector
Run AR:GlossaryDriftAnalyzer
Run AR:GlossaryPromoter
Run AR:GlossaryPublisher
```


--------------------------------------------------
Extended Closure Branch (spec-driven generation)
--------------------------------------------------

In addition to the three core steps, AR offers an optional **extended closure branch** that adds four specification layers required when the goal is not only to reconstruct and document the system, but to move toward **spec-driven generation of the application**.

This branch is intended to be used only after the core canonical backbone is already stable.

### Core backbone expected before this branch

- EN
- UC
- ARCH
- DOMAIN
- BR
- FN
- ES
- MSG

### Strongly recommended before this branch

- RewriteDecisionCompiler
- EntityInventoryCloser
- SpecClosureEvaluator

### Branch location

All extension agents live under:

- tooling/orchestration/04-spec-driven-closure/agents/
- tooling/orchestration/04-spec-driven-closure/tasks/

Supporting rules live under tooling/docs/ and supporting templates under tooling/templates/.

### Why this branch exists

The core AR pipeline can reconstruct entities, use cases, architecture, business rules, capabilities, external systems, and transactional messages. That is strong enough for reverse engineering, rewrite planning, architectural reasoning, and layered documentation.

It is still not enough for robust spec-driven application generation. The gaps are:

- API contracts
- background job / batch contracts
- explicit access-control matrix
- query and report specifications

This branch fills exactly those gaps.

### Layers added by this branch

#### 1. API contracts

Purpose:
- define stable system-facing command/query/callback contracts
- specify request and response shapes
- make side effects and authorization expectations explicit

Output area:
- _ar/spec-draft/API/
- _ar/spec-draft/API-contract-map.md
- _ar/spec-draft/API-synthesis-report.md

Agent: APIContractSynthesizer
Rules: tooling/docs/rules-API.md
Template: tooling/templates/template-API.md

#### 2. JOB / batch contracts

Purpose:
- define scheduled, polling, async, and batch execution contracts
- make trigger model, side effects, idempotency, and failure handling explicit

Output area:
- _ar/spec-draft/JOB/
- _ar/spec-draft/JOB-map.md
- _ar/spec-draft/JOB-synthesis-report.md

Agent: JobContractSynthesizer
Rules: tooling/docs/rules-JOB.md
Template: tooling/templates/template-JOB.md

#### 3. ACL matrix

Purpose:
- define who can do what, on which resource, and under what scope
- separate actor role, business position, and technical auth requirement
- make access behavior explicit for generation and review

Output area:
- _ar/spec-draft/ACL/
- _ar/spec-draft/ACL-matrix.md
- _ar/spec-draft/ACL-synthesis-report.md

Agent: ACLMatrixSynthesizer
Rules: tooling/docs/rules-ACL.md
Template: tooling/templates/template-ACL.md

#### 4. QUERY / report specs

Purpose:
- define read-side contracts
- specify list/detail/summary/dashboard/export semantics
- capture filters, grouping, derived outputs, and result intent

Output area:
- _ar/spec-draft/QUERY/
- _ar/spec-draft/QUERY-map.md
- _ar/spec-draft/QUERY-synthesis-report.md

Agent: QuerySpecSynthesizer
Rules: tooling/docs/rules-QUERY.md
Template: tooling/templates/template-QUERY.md

### When to use this branch

Use this branch only when the project needs to go beyond reconstruction and publication into:

- implementation-ready contracts
- frontend/backend generation planning
- integration contract planning
- access-control formalization
- reporting/read-model formalization

Do **not** use this branch too early. It should not be used while EN is still unstable, while UC still carries major structural ambiguity, while DOMAIN and ARCH are still moving, or while FN / BR / ES / MSG are missing or weak.

### Recommended timing

1. finish core AR reconstruction
2. stabilize canonical layers
3. complete or nearly complete closure of major ambiguities
4. run this branch

Minimum baseline before this branch:

- EN/
- UC/
- ARCH/
- DOMAIN-kernel.md
- DOMAIN-aggregates.md
- BR/
- FN/
- ES/
- MSG/

### Recommended execution order

1. Run AR:APIContractSynthesizer
2. Run AR:JobContractSynthesizer
3. Run AR:ACLMatrixSynthesizer
4. Run AR:QuerySpecSynthesizer

Reason for this order:
- API depends on stable behavior and entity language
- JOB depends on stable flow/capability/side-effect understanding
- ACL depends on stable actor/resource/capability boundaries
- QUERY depends on stable domain, capability, and reporting semantics

### Hard discipline for this branch

This branch must preserve AR principles: evidence first, no silent invention, no hidden redesign, glossary-governed terminology, clear separation of layers, rewrite-facing documentation.

These new layers must **not** become copies of controller code, SQL dumps, framework annotations, queue/cron config snapshots, auth middleware inventories, or UI screenshots rewritten as specs without evidence support. They must remain canonical, publish-facing, and implementation-agnostic.

### Relationship to existing AR layers

- **API** depends on: UC, FN, BR, EN, ARCH, ES. Does not replace ES, MSG, FN.
- **JOB** depends on: FLOW, FN, ARCH, BR, ES. Does not replace ARCH operational notes, MSG.
- **ACL** depends on: FN, UC, BR, EN, ARCH, DOMAIN. Does not replace auth architecture notes or business rules.
- **QUERY** depends on: EN, UC, FN, BR, ARCH, optional UI/runtime evidence. Does not replace dashboards themselves, BI implementation, or SQL layer.

### Output philosophy

Each document created by this branch should be deterministic, traceable, business-readable, implementation-agnostic, narrow enough to be useful, and explicit about uncertainty. If something is unknown, keep it in open items — do not guess, do not silently promote inferred details into canonical contract text.

### Expected value of this branch

Core AR gives a strong reconstruction. This branch starts turning reconstruction into **generation-grade specification**. If completed well, it makes the reconstructed system far more useful for frontend generation, backend contract generation, integration adapter generation, permission implementation, reporting/read-model implementation, and batch/job orchestration planning.


--------------------------------------------------
Maintaining template parity
--------------------------------------------------

The 12 BA layer templates/rules (and the 4 UX ones) are kept in structural parity with the sister
arg-emitee project's `docs/authoring/templates/` and `docs/authoring/rules/`, which are the
canonical source for the shared section structure. AR mirrors that structure and adds its own
intentional deltas (the per-rule "Cross-references" section, `references:` frontmatter, the UC
"Evidence level" and CS evidence/certainty discipline, and AR's draft frontmatter).

The two repos are separate (no symlink); parity is a maintained policy plus an automated check:

- Policy and the per-layer intentional deltas: `docs/template-parity.md`
- Drift check: `scripts/check-template-parity.sh [path-to-arg-emitee-docs]` (defaults to a sibling
  checkout; reports `in parity` / `DRIFT` and exits non-zero on drift).


--------------------------------------------------
compile.md
--------------------------------------------------

The repository ships with a file called `compile.md` at the repo root.

Purpose:
- single-file, compacted compilation of all AR framework documentation (rules, templates, orchestration agents and tasks)
- optimized for LLM consumption — intended as a single context input when using AR tooling with external LLM tools
- excludes: `compile.md` itself and `README_AR.md`

It is a derived artifact. When source docs change significantly, regenerate it so that it stays faithful to the current state of the framework.
