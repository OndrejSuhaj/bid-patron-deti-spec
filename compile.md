# Repository Markdown Compilation

> Compact, faithful compilation of ApplicationRenaissance (AR) framework documentation.
> Optimized for LLM consumption. Excludes: `compile.md`, `README_AR.md`.

## Included Files

- docs/cross-layer-discipline.md
- docs/definition-of-done.md
- docs/registry-format.md
- docs/rules-ACL.md
- docs/rules-API.md
- docs/rules-ARCH.md
- docs/rules-BR.md
- docs/rules-COMP.md
- docs/rules-COPY.md
- docs/rules-CS.md
- docs/rules-EN.md
- docs/rules-ES.md
- docs/rules-FN.md
- docs/rules-IA.md
- docs/rules-JOB.md
- docs/rules-MSG.md
- docs/rules-QUERY.md
- docs/rules-spec-final.md
- docs/rules-UC.md
- docs/rules-WIRE.md
- docs/template-parity.md
- orchestration/00-glossary-governance/agents/GlossaryCandidateCollector.md
- orchestration/00-glossary-governance/agents/GlossaryDriftAnalyzer.md
- orchestration/00-glossary-governance/agents/GlossaryPromoter.md
- orchestration/00-glossary-governance/agents/GlossaryPublisher.md
- orchestration/00-glossary-governance/tasks/GlossaryCandidateCollector-task.md
- orchestration/00-glossary-governance/tasks/GlossaryDriftAnalyzer-task.md
- orchestration/00-glossary-governance/tasks/GlossaryPromoter-task.md
- orchestration/00-glossary-governance/tasks/GlossaryPublisher-task.md
- orchestration/01-evidence-collection/agents/ChangeLogEvidenceCurator.md
- orchestration/01-evidence-collection/agents/DBIntrospector.md
- orchestration/01-evidence-collection/agents/FlowInspector.md
- orchestration/01-evidence-collection/agents/FlowMiner.md
- orchestration/01-evidence-collection/agents/PDFEvidenceCurator.md
- orchestration/01-evidence-collection/agents/RepoCartographer.md
- orchestration/01-evidence-collection/agents/SRVCurator.md
- orchestration/01-evidence-collection/agents/SRVRestructurer.md
- orchestration/01-evidence-collection/tasks/ChangeLogEvidenceCurator-task.md
- orchestration/01-evidence-collection/tasks/DBIntrospector-task.md
- orchestration/01-evidence-collection/tasks/FlowInspector-task.md
- orchestration/01-evidence-collection/tasks/FlowMiner-task.md
- orchestration/01-evidence-collection/tasks/PDFEvidenceCurator-task.md
- orchestration/01-evidence-collection/tasks/RepoCartographer-task.md
- orchestration/01-evidence-collection/tasks/SRVCurator-task.md
- orchestration/01-evidence-collection/tasks/SRVRestructurer-task.md
- orchestration/02-system-reconstruction/agents/ARCHWriter.md
- orchestration/02-system-reconstruction/agents/AggregateBoundaryModeler.md
- orchestration/02-system-reconstruction/agents/DomainKernelSynthesizer.md
- orchestration/02-system-reconstruction/agents/ENExtractor.md
- orchestration/02-system-reconstruction/agents/UCComposer.md
- orchestration/02-system-reconstruction/tasks/ARCHWriter-task.md
- orchestration/02-system-reconstruction/tasks/AggregateBoundaryModeler-task.md
- orchestration/02-system-reconstruction/tasks/DomainKernelSynthesizer-task.md
- orchestration/02-system-reconstruction/tasks/ENExtractor-task.md
- orchestration/02-system-reconstruction/tasks/UCComposer-task.md
- orchestration/03-spec-driven-documentation/agents/ARCHDomainAssembler.md
- orchestration/03-spec-driven-documentation/agents/BRExtractor.md
- orchestration/03-spec-driven-documentation/agents/CrossLayerAuditor.md
- orchestration/03-spec-driven-documentation/agents/ENCanonicalizer.md
- orchestration/03-spec-driven-documentation/agents/ESSynthesizer.md
- orchestration/03-spec-driven-documentation/agents/FNSynthesizer.md
- orchestration/03-spec-driven-documentation/agents/MSGSynthesizer.md
- orchestration/03-spec-driven-documentation/agents/RefIntegrityValidator.md
- orchestration/03-spec-driven-documentation/agents/RewriteDecisionCompiler.md
- orchestration/03-spec-driven-documentation/agents/SpecClosureEvaluator.md
- orchestration/03-spec-driven-documentation/agents/SpecFinalGenerator.md
- orchestration/03-spec-driven-documentation/agents/UCAtomizer.md
- orchestration/03-spec-driven-documentation/tasks/ARCHDomainAssembler-task.md
- orchestration/03-spec-driven-documentation/tasks/BRExtractor-task.md
- orchestration/03-spec-driven-documentation/tasks/CrossLayerAuditor-task.md
- orchestration/03-spec-driven-documentation/tasks/ENCanonicalizer-task.md
- orchestration/03-spec-driven-documentation/tasks/ESSynthesizer-task.md
- orchestration/03-spec-driven-documentation/tasks/FNSynthesizer-task.md
- orchestration/03-spec-driven-documentation/tasks/MSGSynthesizer-task.md
- orchestration/03-spec-driven-documentation/tasks/RefIntegrityValidator-task.md
- orchestration/03-spec-driven-documentation/tasks/RewriteDecisionCompiler-task.md
- orchestration/03-spec-driven-documentation/tasks/SpecClosureEvaluator-task.md
- orchestration/03-spec-driven-documentation/tasks/SpecFinalGenerator-task.md
- orchestration/03-spec-driven-documentation/tasks/UCAtomizer-task.md
- orchestration/04-spec-driven-closure/agents/ACLMatrixSynthesizer.md
- orchestration/04-spec-driven-closure/agents/APIContractSynthesizer.md
- orchestration/04-spec-driven-closure/agents/JobContractSynthesizer.md
- orchestration/04-spec-driven-closure/agents/QuerySpecSynthesizer.md
- orchestration/04-spec-driven-closure/tasks/ACLMatrixSynthesizer-task.md
- orchestration/04-spec-driven-closure/tasks/APIContractSynthesizer-task.md
- orchestration/04-spec-driven-closure/tasks/JobContractSynthesizer-task.md
- orchestration/04-spec-driven-closure/tasks/QuerySpecSynthesizer-task.md
- orchestration/90-optional-bonus/inventory-closure/agents/EntityInventoryCloser.md
- orchestration/90-optional-bonus/inventory-closure/agents/MissingCoreEntityWriter.md
- orchestration/90-optional-bonus/inventory-closure/tasks/EntityInventoryCloser-task.md
- orchestration/90-optional-bonus/inventory-closure/tasks/MissingCoreEntityWriter-task.md
- orchestration/90-optional-bonus/ui-coverage/agents/GapClosureSpecWriter.md
- orchestration/90-optional-bonus/ui-coverage/agents/ScreenshotCoverageAuditor.md
- orchestration/90-optional-bonus/ui-coverage/agents/UIGapToSpecPlanner.md
- orchestration/90-optional-bonus/ui-coverage/tasks/GapClosureSpecWriter-task.md
- orchestration/90-optional-bonus/ui-coverage/tasks/ScreenshotCoverageAuditor-task.md
- orchestration/90-optional-bonus/ui-coverage/tasks/UIGapToSpecPlanner-task.md
- orchestration/90-optional-bonus/ux-reconstruction/agents/COMPSynthesizer.md
- orchestration/90-optional-bonus/ux-reconstruction/agents/COPYSynthesizer.md
- orchestration/90-optional-bonus/ux-reconstruction/agents/IASynthesizer.md
- orchestration/90-optional-bonus/ux-reconstruction/agents/WIRESynthesizer.md
- orchestration/90-optional-bonus/ux-reconstruction/tasks/COMPSynthesizer-task.md
- orchestration/90-optional-bonus/ux-reconstruction/tasks/COPYSynthesizer-task.md
- orchestration/90-optional-bonus/ux-reconstruction/tasks/IASynthesizer-task.md
- orchestration/90-optional-bonus/ux-reconstruction/tasks/WIRESynthesizer-task.md
- orchestration/99-legacy/agents/BRSynthesizer.md
- orchestration/99-legacy/tasks/BRSynthesizer-task.md
- templates/project-skeleton/CLAUDE_template.md
- templates/project-skeleton/glossary-arbitration-decisions.md
- templates/project-skeleton/glossary-scope.md
- templates/project-skeleton/glossary-source-pack.md
- templates/template-ACL.md
- templates/template-API.md
- templates/template-ARCH.md
- templates/template-BR.md
- templates/template-COMP.md
- templates/template-COPY.md
- templates/template-CS.md
- templates/template-EN.md
- templates/template-ES.md
- templates/template-FN.md
- templates/template-IA.md
- templates/template-JOB.md
- templates/template-MSG.md
- templates/template-QUERY.md
- templates/template-spec-final.md
- templates/template-UC.md
- templates/template-WIRE.md

## Compression Notes

- **Standard AR agent boilerplate**: All agents share: scope restricted to `_ar/**`, idempotent (refresh in place, no duplicates), invoked via `Run AR:<AgentName>`. Stated fully for the first agent in each pipeline stage, then referenced as "Standard AR agent conventions apply."
- **Templates**: `template-ACL.md` compiled in full as reference template. Subsequent templates note only their unique frontmatter fields and sections vs. the ACL reference.
- **Task files**: Slim wrappers around their agent spec. Compiled as pre-check + deliverables + extra rules only.
- **Cross-layer discipline**: Each `docs/rules-<LAYER>.md` includes a "Cross-references (reference, don't restate)" section (per-layer references + never-inline list); see `docs/cross-layer-discipline.md` for the full ownership table. Stage 03/04/90 authoring agents declare `tooling/docs/cross-layer-discipline.md` as a normative source; the canonicalizers (EN/UC/BR) and `CrossLayerAuditor` carry a hard rule against restating another layer's owned content.
- **Template parity**: the 12 BA + 4 UX layer templates/rules mirror arg-emitee's `authoring/{templates,rules}/` (canonical source); each `rules-<LAYER>.md` opens with a `> See also: cross-layer-discipline.md` callout and templates show `status: draft | canonical`. Structural drift is detected by `scripts/check-template-parity.sh`. See `docs/template-parity.md` for the policy and the intentional AR deltas it preserves.

---

# Section 1 — Root & Rules & Templates

## docs/cross-layer-discipline.md
**Type:** discipline (governs all layers)

Single source of truth for how AR canonical layers relate. **Reference, don't restate:** each fact has one canonical owner (a doc_id); other layers cite it, never inline it. **Ownership:** EN=entity semantics/lifecycle/attributes/entity-local invariants; BR=rules/cross-entity invariants/domain policies; UC=flows/triggers/pre-postconditions; FN=capabilities; ARCH=structure; ES=external systems; MSG=messages; CS=observed FE behavior; API/JOB/ACL/QUERY=contracts; IA/WIRE/COMP/COPY=UX surfaces. A per-layer **refers-to / never-inlines** table makes the boundaries concrete. **Enforcement:** a >50-char near-verbatim block of another layer's owned content = restatement violation → replace with a doc_id reference; `CrossLayerAuditor` detects/rewrites these after drafting (SpecFinalGenerator won't). Exceptions: `references:` frontmatter, ≤50-char orientation summary next to a doc_id, cross-layer pointer. Also: skip placeholder-only sections (except Open Questions / evidence-gap); unknowns → Hypothesis/Open Question, never restate to fill a gap; code+DB+flow authoritative, observation/screenshot suggestive. Precedence: glossary > this doc > `rules-<LAYER>` > template.

---

## docs/definition-of-done.md
**Type:** closure criteria (governs SpecClosureEvaluator)

AR reconstruction-closure Definition of Done — adapts arg-emitee's DoD philosophy, NOT its delivery tiers (AR has no slices/modules). 4 closure dimensions: current-state understanding / architecture & planning / greenfield rewrite readiness / generation-grade contract readiness (04 only). Per-dimension checkable criteria (layers canonical, coverage, open questions recorded, registries current, cross-layer dedup done, rewrite blockers visible). Closure states: not-started → in-evidence → in-reconstruction → reconstructed-but-not-closed → closed-with-limitations → closed (or blocked). Confidence: Confirmed/Partial/Uncertain/Blocked. "What does NOT count as closed": a folder with docs ≠ canonical; files existing ≠ closed; a verdict without the checklist; narrative optimism. Weighed factors (NOT auto-blockers): dangling refs / collisions / orphans (REFERENCE-INTEGRITY) + unresolved restatements (CROSS-LAYER-audit) lower confidence and go to backlog; deferred cross-tier refs are recorded. No scoring — per-criterion PASS/PARTIAL/BLOCKED.

---

## docs/registry-format.md
**Type:** format (governs all registries)

Single source of truth for `_REGISTRY.md` format — used by draft registries (RefIntegrityValidator) and published registries (SpecFinalGenerator). Schema: semantic header `# <LAYER> Registry — <SemanticName>` + format-spec pointer + table `| ID | Title | Status | Module(s) | Owner mode | Created |`. Status lifecycle reserved→draft→canonical→deprecated (draft registries `draft`, published `canonical`). Owner mode: draft `AR`, published `Mode P (import)`; Module(s) `[]` default. doc_id: `LAYER####` / `BR-<name>` / `IA-<slug>` / `COPY-<scope>`. Atomicity: doc_id + row together (no orphans). Cross-references: every references/affects/realizes_uc/trigger doc_id must resolve to a row; dangling = violation, collisions reported (never auto-renumbered). Draft `_ar/spec-draft/<LAYER>/_REGISTRY.md` carries over to published `_ar/spec-final/<tier>/<LAYER>/_REGISTRY.md`.

---

## docs/rules-ACL.md
**Type:** rules

ACL documents define who can do what on which resource and under what scope: actors/roles, resources, actions, scope constraints, inheritance/exception notes. They do NOT describe UI layout or auth provider implementation.

**Naming:** `ACLxxxx – <Domain Name>` (e.g. ACL0001 – Invoicing Access)

**Required Frontmatter:**
- `doc_id: ACLxxxx`, `title`, `canonical_layer: ACL`, `spec_type: access-control`, `status: draft | canonical`
- Optional: `references:` (UCxxxx, FNxxxx, ENxxxx, BR-<RuleName>)

**Recommended Structure:** Purpose, Actor Model, Resources, Matrix, Exceptions, References, Open Items

**Matrix minimum columns:** Actor/Role, Resource, Action, Scope, Notes

**Restrictions — must NOT contain:** identity provider configuration, framework guards, middleware names, route middleware chains, UI-only assumptions presented as confirmed grants

---

## docs/rules-API.md
**Type:** rules

API documents define stable system-facing contracts: what an interface does, who can call it, what it accepts/returns, side effects, failure outcomes. They do NOT describe framework implementation.

**Naming:** `APIxxxx – <Contract Name>` (e.g. API0001 – Create Invoice)

**Required Frontmatter:**
- `doc_id: APIxxxx`, `title`, `canonical_layer: API`, `spec_type: api-contract`, `status: draft | canonical`, `contract_type: command | query | callback | utility`
- Optional: `references:` (UCxxxx, ENxxxx, FNxxxx, BR-<RuleName>)

**Recommended Structure:** Purpose, Consumers, Authorization, Request, Response, Side Effects, Failure Outcomes, References, Open Items

**Restrictions — must NOT contain:** controller names, framework decorators, route handler class names, ORM details, database schema dumps, inferred fields without support, UI-only assumptions presented as API truth

---

## docs/rules-ARCH.md
**Type:** rules

ARCH documents describe high-level system structure: system scope, major structural components, how they relate. They do NOT describe business behavior or implementation.

**Naming:** `ARCHxxxx – <Architecture Topic>` (e.g. ARCH0001 – Application Overview)

**Required Frontmatter:**
- `doc_id: ARCHxxxx`, `title`, `canonical_layer: ARCH`, `spec_type: architecture`, `status: draft | canonical`
- Optional: `references:` (FNxxxx, ESxxxx)

**Recommended Structure:** Purpose, System Overview, Structural Components, Interaction Model

**Section Meaning:**
- Purpose — what architectural perspective the doc describes
- System Overview — short description of system and scope
- Structural Components — major contexts/subsystems
- Interaction Model — conceptual description of component interaction

**Restrictions — must NOT contain:** use case flows, entity models, implementation details

---

## docs/rules-BR.md
**Type:** rules

BR documents define rules constraining system behavior across entities or use cases: domain policies, system governance, cross-entity constraints. They do NOT describe process flow.

**Naming:** `BR-<RuleName>`

**Required Frontmatter:**
- `doc_id: BR-<RuleName>`, `title`, `canonical_layer: BR`, `spec_type: business-rule`, `status: draft | canonical`, `affects:` (ENxxxx, UCxxxx, SYSTEM)
- Optional: `references:` (ENxxxx, UCxxxx)

**Structure:** Purpose, one or more `<Rule Section>`, optional Non-Goals. Each rule section defines one group of constraints using normative language: SHALL, MUST, SHALL NOT. Rules should be deterministic.

**Restrictions — must NOT contain:** step-by-step flows, implementation details

---

## docs/rules-CS.md
**Type:** rules

CS documents capture critical FE and business-visible runtime scenarios used to reconstruct actual system behavior from observable application flow. Use CS when: recording what actually happens in the running app; primary evidence is FE runtime observation (screenshots, recordings, live interaction); need to distinguish observed vs. inferred behavior. CS describes **observed behavior**, not designed behavior.

**Naming:** `CS{XXXX} – <Actor Verb Object>`. File: `CS{XXXX}_{Title}.md`.

**Required Frontmatter:** `doc_id: CSxxxx`, `title`, `canonical_layer: CS`, `spec_type: critical-scenario`, `status: draft | canonical`. Optional: `scope`, `priority` (P0|P1|P2), `impact` (High|Medium|Low), `references` (UCxxxx, ENxxxx).

**Evidence Types:** FE evidence (directly observed runtime behavior), Observed fact (confirmed by FE evidence), Prior analytical context (generic earlier analysis), Previous analysis output (specific earlier analytical artifact), Working assumption (plausible but unconfirmed), Legacy hint (weak historical or indirect signal).

**Evidence Priority Rule:** FE evidence wins over all other reference types. Mismatches recorded as working assumption / inconsistency / open question / note from prior analysis. Prior analysis may strengthen preconditions, hidden dependencies, likely follow-up logic, likely missing context — but must not override directly observed FE behavior and must not be treated as immutable truth.

**Certainty Classification:** Every claim classifiable as Confirmed (directly observed) | Probable (FE + prior analysis) | Assumed (plausible, unconfirmed) | Uncertain (insufficient evidence; open question) | Inconsistent (FE contradicts prior analysis or other FE).

**Required Sections:** Purpose, Preconditions, Main Flow (numbered: User Action / System Response / Evidence / Notes), Observed Facts, Open Questions.
**Recommended:** Business Meaning, Primary Role, Scenario Type (read-only / controlled-write / mixed), Working Assumptions, Prior Analytical Hints, Scenario Continuations, Screenshot Index.
**Optional:** Test Data/Variants, What to Observe Carefully, Required Capture, Probable Domain Elements, Probable Capabilities, Reconstruction Value, Safety Notes, Execution Notes.

**Sequencing Rule:** Breadth-first — main scenario → direct follow-ups → follow-up-of-follow-ups (prevents deep-tree reconstruction losing primary flow context).

**Screenshot Storage:** `_ar/evidence/runtime/prtsc/CS{XXXX}_{scenario-slug}/{file}.png`. Naming convention is a project-level adaptation point.

**Anonymization:** Personal data (names, emails, phones, addresses) anonymized in artifact text and screenshot annotations (raw screenshots may contain real data only in controlled environments).

**Artifact Language:** English (default). Conversation language is project-level adaptation point. Markdown mandatory.

**Variant Depth Rule:** Short/standard/extended variants keep same canonical scope and follow-up hooks; differ only in depth.

**Restrictions — must NOT contain:** implementation code, framework-specific configuration, inferred backend behavior as confirmed fact, API contract definitions, database schema details, deployment/infrastructure details, claims overriding FE evidence based solely on prior analysis.

**Project-Level Adaptation Points:** conversation language, specific analytical aids and their role, screenshot naming convention, evidence storage path, scenario scope/working order, priority scheme semantics, variant depth policy. Should be documented in a project-level CS configuration note, not hardcoded into general rules.

---

## docs/rules-EN.md
**Type:** rules

EN documents describe domain entities and their lifecycle: entity meaning, lifecycle states, data model, invariants.

**Naming:** `ENxxxx – <Entity Name>`

**Required Frontmatter:**
- `doc_id: ENxxxx`, `title`, `canonical_layer: EN`, `spec_type: entity`, `status: draft | canonical | active`

**Recommended Structure:** Purpose, Lifecycle, State Transitions, Attributes, Invariants, Relationships

**Section Meaning:**
- Purpose — what the entity represents / detailed domain explanation
- Lifecycle — possible states
- State Transitions — valid transitions and triggers
- Attributes — entity attributes
- Invariants — conditions that must always hold true
- Relationships — references to other entities

**Restrictions — must NOT contain:** implementation logic, API design, database schema definitions

---

## docs/rules-ES.md
**Type:** rules

ES documents describe external systems interacting with the platform: role, integration context, interaction boundaries. They do NOT define business behavior.

**Naming:** `ESxxxx – <External System Name>` (e.g. ES0001 – Auth0)

**Required Frontmatter:**
- `doc_id: ESxxxx`, `title`, `canonical_layer: ES`, `spec_type: external-system`, `status: draft | canonical`
- Optional: `references:` (UCxxxx, FNxxxx)

**Recommended Structure:** Purpose, System Overview, Integration Model, Data Exchange, Constraints

**Restrictions — must NOT contain:** implementation code, API payload definitions

---

## docs/rules-FN.md
**Type:** rules

FN documents describe internal system capabilities supporting use cases (e.g. payment matching, authorization model, event infrastructure, email delivery). They describe capabilities, NOT workflows.

**Naming:** `FNxxxx – <Capability Name>`

**Required Frontmatter:**
- `doc_id: FNxxxx`, `title`, `canonical_layer: FN`, `spec_type: functional-capability`, `status: draft | canonical`
- Optional: `references:` (UCxxxx, ENxxxx, ESxxxx)

**Recommended Structure:** Purpose, Responsibilities, Related Use Cases, Related Entities, Integrations, Constraints

**Restrictions — must NOT contain:** implementation code, framework configuration

---

## docs/rules-JOB.md
**Type:** rules

JOB documents describe background execution contracts: why the job exists, triggers, input scope, side effects, failure/idempotency handling. They do NOT describe infrastructure deployment.

**Naming:** `JOBxxxx – <Job Name>` (e.g. JOB0001 – Generate Periodic Invoices)

**Required Frontmatter:**
- `doc_id: JOBxxxx`, `title`, `canonical_layer: JOB`, `spec_type: job-contract`, `status: draft | canonical`, `job_type: scheduler | poller | async-consumer | repair | batch`
- Optional: `references:` (FNxxxx, UCxxxx, ENxxxx, ESxxxx)

**Recommended Structure:** Purpose, Trigger Model, Input Scope, Processing Rules, Side Effects, Idempotency, Failure Handling, References, Open Items

**Restrictions — must NOT contain:** infra configuration files, cron syntax (unless contractually required), queue library names, worker class names, container/runtime deployment notes

---

## docs/rules-MSG.md
**Type:** rules

MSG documents describe transactional messages sent to users (confirmation emails, notifications, system reports): when sent, who receives, what information.

**Naming:** `MSGxxxx – <Message Name>` (e.g. MSG0001 – Published Report Notification)

**Required Frontmatter:**
- `doc_id: MSGxxxx`, `title`, `canonical_layer: MSG`, `spec_type: transactional-message`, `status: draft | canonical`
- Optional: `trigger:` (UCxxxx), `references:` (ENxxxx)

**Recommended Structure:** Purpose, Trigger, Recipients, Message Content

**Restrictions — must NOT contain:** HTML templates, email styling, mail provider configuration

---

## docs/rules-QUERY.md
**Type:** rules

QUERY documents define read-side specifications: why the read model exists, source entities, filters/grouping, derived outputs, what consumer receives. They do NOT define SQL or storage implementation.

**Naming:** `QUERYxxxx – <Specification Name>` (e.g. QUERY0001 – Invoice Listing)

**Required Frontmatter:**
- `doc_id: QUERYxxxx`, `title`, `canonical_layer: QUERY`, `spec_type: query-spec`, `status: draft | canonical`, `query_type: list | detail | summary | dashboard | export | search`
- Optional: `references:` (UCxxxx, ENxxxx, FNxxxx, BR-<RuleName>)

**Recommended Structure:** Purpose, Consumers, Source Entities, Filters and Grouping, Derived Outputs, Result Shape, References, Open Items

**Restrictions — must NOT contain:** SQL, ORM query builders, endpoint handler names, UI component tree, guessed formulas without support

---

## docs/rules-UC.md
**Type:** rules

UC documents describe system behavior triggered by actors: interactions, system responses, lifecycle changes of entities.

**Naming:** `UCxxxx – <Actor> <Verb> <Object>` (e.g. UC0001 – Issuer creates bond issue draft)

**Required Structure:** Trigger, Preconditions, Main Flow, Alternative Flows, Postconditions, Affected Entities, Evidence level

**Evidence level labels (closed set; one line, label first, optional short justification):**
- **Confirmed** — flow fully specified from authoritative sources; no material gap
- **Partial** — core flow specified; one or more alternative flows, edge cases, or postconditions inferred and not fully evidenced
- **Uncertain** — at least one main-flow step rests on inference; sources conflict or are silent
- **Blocked** — flow cannot be completed without an external decision (open question, missing authority, pending integration confirmation)

**Rules:**
- Main Flow must be numbered
- Lifecycle changes must be explicitly stated (e.g. "System changes Bond Issue state Draft -> Locked")
- Alternative flow identifiers: `<step-number><letter>` (e.g. 3A – Validation fails)

**Restrictions — must NOT contain:** implementation logic, API endpoints, controller names

---

## docs/rules-spec-final.md
**Type:** rules

Governs `_ar/spec-final/**` only (the publishable hand-off layer); `_ar/spec-draft/**` stays flat/unchanged. Makes the final layer a drop-in tree for an arg-emitee rebuild (`_ar/BA`/`_ar/UX`).

**Layer→tier map (single source of truth):** BA = EN, UC, BR, FN, ARCH, ES, MSG, CS, API, JOB, ACL, QUERY. UX (optional, synthesized by the ux-reconstruction branch) = IA, WIRE, COMP, COPY. CS is BA.

**Target layout:** `_ar/spec-final/<tier>/<LAYER>/` with one `_REGISTRY.md` per layer; UX folders published when ux-reconstruction drafts exist, else scaffolded empty.

**File naming:** `<doc_id>-<kebab-title>.md` (doc_id bare token preserved, never renumbered/translated; kebab from title, accents folded, ≤40 chars). BR keeps `BR-<rule-name>`; IA `IA-<project-slug>`; COPY `COPY-<scope>`.

**Frontmatter conformance:** required `doc_id`, `title`, `canonical_layer`, `status` (=canonical for published; lifecycle reserved→draft→canonical→deprecated), `modules: []` (program-wide; arg-emitee Mode M re-scopes). Carry over `spec_type`, `references`, and layer-specific fields (contract_type/job_type/query_type/affects/trigger/scope...).

**Registry:** header `# <LAYER> Registry — <SemanticName>` + format-spec pointer; table `| ID | Title | Status | Module(s) | Owner mode | Created |`; one row per doc; Status canonical; Module(s) `[]`; Owner mode `Mode P (import)` (enum: Mode P | Mode M (<module>) | Mode B (<slice-id>) | Mode C); atomic (doc + row together); no dangling references (every `references:` doc_id resolves in target layer registry).

**Czech translation (unchanged):** translate headings/prose/lists/explanatory table text; keep IDs, doc_id tokens, filenames, inline identifiers, code blocks, glossary terms stable.

---

## docs/rules-IA.md
**Type:** rules

UX layer. Reconstructs project-level information architecture from observed UI evidence; one doc per project. **Naming:** `IA-<project-slug>` (file `IA-<project-slug>.md`). **Frontmatter:** doc_id, title, canonical_layer, spec_type: information-architecture, scope: program, status, owners, language (cs|en), references. **Structure:** Sources/Authority, Top-Level Navigation, Screen Map (stable `S###`), Entry Points(→UC), Cross-Module Flows(→UC), Information Hierarchy(→EN), Module Boundaries, Open IA Questions (mandatory), NOT-COVER. **NOT-FOR:** API/ES/ARCH/EN-attributes/BR-values/ACL/UC-detail/WIRE-COMP-COPY (reference doc_ids). **Evidence:** observed UI suggestive not authoritative; mint stable screen-ids for WIRE; unknowns → Open Questions.

---

## docs/rules-WIRE.md
**Type:** rules

UX layer. Reconstructs a single screen from UI evidence; one doc per screen. **Naming:** `WIRExxxx – <Screen Name>` (file `WIRE{xxxx}_{ScreenName}.md`). **Frontmatter:** doc_id, title, canonical_layer, spec_type: wireframe, modules, **screen_id (from IA)**, **realizes_uc [UCxxxx] (REQUIRED)**, status, references. **Structure:** Purpose, Layout Zones, Components Used(→COMP or `inline`), Interactions, States (default/empty/loading/error or N/A), Validation Surfaces(→BR), Data Bindings(→EN/QUERY), Conditional Visibility(→ACL/BR), Accessibility. **NOT-FOR:** navigation(IA)/component-contracts(COMP)/text(COPY)/backend. **Evidence:** observed UI wins for on-screen; unobserved states Assumed/Uncertain; classify claims, cite screenshots.

---

## docs/rules-COMP.md
**Type:** rules

UX layer. Reconstructs a reusable component from UI evidence; one doc per component (evidence-gated). **Naming:** `COMPxxxx – <Component Name>` (file `COMP{xxxx}_{Name}.md`). **Frontmatter:** doc_id, title, canonical_layer, spec_type: component, modules, status, design_source (optional), references. **Structure:** Purpose, Props/Inputs, Variants, States (idle/hover/focused/disabled/loading/error), Events, Accessibility (ARIA/keyboard/focus/SR), Usage Constraints, Dependencies, Composition(→COMP). **NOT-FOR:** WIRE-layout/COPY-text/backend/EN-attributes/ACL. **Evidence-gated:** create COMP only on observable reuse across ≥2 WIRE; else leave WIRE `inline`. Unobservable states/a11y → Uncertain, not fabricated.

---

## docs/rules-COPY.md
**Type:** rules

UX layer. Reconstructs user-facing text from UI evidence; one doc per scope. **Naming:** `COPY-<scope>` (`module-<slug>` | `shared-<purpose>`; file `COPY-<scope>.md`). Keys `<scope>.<screen-or-component>.<role>`. **Frontmatter:** doc_id, title, canonical_layer, spec_type: copy, scope, modules, language (cs|en|multi), status, references. **Structure:** Purpose, Labels, Helper Texts, Empty States, Loading Texts, Error/Validation(→BR/EN), CTAs(→UC), Microcopy Conventions. **NOT-FOR:** EN-attributes/BR-content/WIRE/COMP. **Evidence:** transcribe text verbatim; implied strings Assumed/Uncertain; glossary for cs/en normalization; AR scope default `shared-*`/`module-<project-slug>`, modules `[]`.

---

## docs/template-parity.md
**Type:** parity policy

The 12 BA + 4 UX layer templates/rules are kept in structural parity with arg-emitee's `authoring/templates/` + `authoring/rules/` (canonical source for shared section structure; AR mirrors it). Records the intentional AR deltas that must survive a sync: Cross-references section (task C), `references:` frontmatter (task D), UC Evidence level, CS Evidence Convention/certainty, UX Evidence section, AR draft frontmatter. Drift is detected by `scripts/check-template-parity.sh` (compares `##` headings of the 16 templates + 12 BA rules, ignoring AR deltas; the 4 UX rules follow AR's uniform house structure). Two separate repos, no symlink — parity is policy + automated check (like the shared glossary skeleton).

---

## templates/template-ACL.md
**Type:** template

Full template (reference for all templates — shared pattern: YAML frontmatter, heading `# {doc_id} – {title}`, sections matching rules):

```yaml
---
doc_id: ACLxxxx
title: <Domain Name>
canonical_layer: ACL
spec_type: access-control
status: draft | canonical
references:
  - UCxxxx
  - FNxxxx
  - ENxxxx
---
```

**Sections:**
- `# ACLxxxx – <Domain Name>`
- `## Purpose` — what access-controlled area this covers
- `## Actor Model` — role/actor/position, scope notes
- `## Resources` — resource list
- `## Matrix` — table: Actor/Role | Resource | Action | Scope | Notes
- `## Exceptions` — temporary/unresolved exceptions, inheritance/override notes
- `## References` — UC, FN, EN, BR
- `## Open Items` — uncertain grants or scope rules

---

## templates/template-API.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter adds: `contract_type: command`
- Sections: Purpose, Consumers, Authorization (required session/token/role/tenant scope), Request (Inputs table: Field | Meaning | Required | Notes), Response (Success table: Field | Meaning | Notes; Failure Outcomes table: Outcome | Meaning | Retryable | Notes), Side Effects, References, Open Items

---

## templates/template-ARCH.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter: minimal (no references by default)
- Sections: Purpose, System Overview, Structural Components (bullet list), Interaction Model
- Sections separated by `---` dividers

---

## templates/template-BR.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter: `doc_id: BR-<RuleName>`, adds `affects:` (ENxxxx)
- Heading: `# BR – <Rule Title>`
- Sections: Purpose, `<Rule Section>` (using SHALL/MUST/SHALL NOT normative language), Non-Goals

---

## templates/template-CS.md
**Type:** template

Differs significantly from other templates.

**Frontmatter:**
```yaml
doc_id: CSxxxx
title: <Actor Verb Object>
canonical_layer: CS
spec_type: critical-scenario
status: draft | canonical
scope: <module / hotspot>
priority: P0 | P1 | P2
impact: High | Medium | Low
references:
  - UCxxxx
  - ENxxxx
```

**Sections (in order):**
1. Purpose — defines one critical FE and business-visible runtime scenario
2. Evidence Convention — list of evidence types (FE evidence, Observed fact, Prior analytical context, Previous analysis output, Working assumption, Legacy hint); rule: FE evidence has priority
3. Business Meaning
4. Primary Role
5. Scenario Type — Read-only | Controlled-write | Mixed
6. Preconditions
7. Working Assumptions
8. Prior Analytical Hints — non-binding hints from earlier analysis, architecture notes, or legacy documentation
9. Main Flow — per step: User Action, System Response, Evidence (FE evidence | Working assumption | Prior analytical context), Notes
10. Observed Facts
11. What to Observe Carefully
12. Screenshot Index — paths `_ar/evidence/runtime/prtsc/CSxxxx_<scenario-slug>/<file>.png`
13. Probable Domain Elements — non-binding proposal of likely business objects
14. Probable Capabilities — non-binding proposal of likely functional capabilities
15. Scenario Continuations — potential follow-up scenarios
16. Open Questions
17. Execution Notes — approved environment, tenant, dataset, account used, execution date

---

## templates/template-EN.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter: adds optional `references:` (BRxxxx rules constraining the entity, ENxxxx relationships)
- Sections: Purpose, Lifecycle (Draft/Active/Archived), State Transitions (with triggers), Attributes (split: System-managed / User-provided; format: `<Field Name> (<Type>; required|optional|conditional; description)`), Invariants, Relationships

---

## templates/template-ES.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter: adds optional `references:` (ARCHxxxx architectural context)
- Sections: Purpose, System Overview, Integration Model (API calls / webhooks / scheduled sync), Data Exchange, Constraints

---

## templates/template-FN.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter: minimal (no references)
- Sections: Purpose, Responsibilities (bullet list), Related Use Cases (UCxxxx), Related Entities (ENxxxx), Integrations (ESxxxx), Constraints

---

## templates/template-JOB.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter adds: `job_type: scheduler`, `references:` (FNxxxx, ENxxxx, ESxxxx)
- Sections: Purpose, Trigger Model, Input Scope, Processing Rules, Side Effects, Idempotency, Failure Handling, References (FN/UC/EN/ES), Open Items

---

## templates/template-MSG.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter: `trigger:` (UCxxxx) plus optional `references:` (ENxxxx)
- Sections: Purpose, Trigger (UCxxxx), Recipients, Message Content (entity name, event date, link to related resource)

---

## templates/template-QUERY.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter adds: `query_type: list`, `references:` (UCxxxx, ENxxxx, FNxxxx)
- Sections: Purpose, Consumers, Source Entities, Filters and Grouping (table: Filter/Grouping | Meaning | Notes), Derived Outputs (table: Output | Meaning | Notes), Result Shape, References, Open Items

---

## templates/template-UC.md
**Type:** template

Differences from template-ACL pattern:
- Frontmatter: adds optional `references:` (ENxxxx, BRxxxx, ACLxxxx, APIxxxx, ESxxxx, JOBxxxx)
- No `## Purpose` section
- Sections: Trigger, Preconditions, Main Flow (numbered steps with lifecycle transition example: "System changes Entity state Draft -> Active"), Alternative Flows (e.g. "3A – Validation fails"; if none: "No alternative flows are defined"), Postconditions, Affected Entities (ENxxxx)

---

## templates/template-spec-final.md
**Type:** template

Companion to `rules-spec-final.md` — the conformant publication envelope for `_ar/spec-final/{BA,UX}/<LAYER>/`. Document body keeps the source layer template's structure; only envelope (path, filename, frontmatter) + per-layer registry are defined here.

**Published frontmatter:** `doc_id` (preserved bare; BR: `BR-<rule-name>`), `title`, `canonical_layer`, `status: canonical`, `modules: []`; optional carried over `spec_type`, `references`, layer-specific fields. Path `_ar/spec-final/<tier>/<LAYER>/<doc_id>-<kebab-title>.md`.

**`_REGISTRY.md` (one per layer):** format defined in `registry-format.md`. At publication, rows are carried over from the draft registries (built by RefIntegrityValidator) and re-stamped Status `canonical`, Owner mode `Mode P (import)`, Module(s) `[]`. Reserved UX registries hold only the header. UX docs carry layer-specific required fields (WIRE: screen_id + realizes_uc; IA/COPY: scope+language; COMP: design_source).

---

## templates/template-IA.md
**Type:** template

UX layer (one per project). Frontmatter: doc_id `IA-<project-slug>`, scope: program, owners, language. Sections: 1 Sources/Authority, 2 Top-Level Navigation, 3 Screen Map (`S###` per module, →EN), 4 Entry Points (table →UC), 5 Cross-Module Flows (→UC), 6 Information Hierarchy (→EN), 7 Module Boundaries, 8 Open IA Questions (mandatory table), 9 NOT-COVER. Reconstructed from UI evidence; references BA doc_ids, never inlines them.

---

## templates/template-WIRE.md
**Type:** template

UX layer (one per screen). Frontmatter adds: `screen_id: Sxxx`, `realizes_uc: [UCxxxx]` (required), `modules: []`. Sections: Purpose, Layout Zones (ASCII sketch), Components Used (table →COMP or `inline`), Interactions (Entry/Primary/Secondary/Exit), States (default/empty/loading/error), Validation Surfaces (→BR), Data Bindings (→EN/QUERY), Conditional Visibility (→ACL/BR), Accessibility Notes, Evidence (certainty + screenshot path).

---

## templates/template-COMP.md
**Type:** template

UX layer (one per component). Frontmatter adds: `design_source` (optional), `modules: []`. Sections: Purpose, Props/Inputs (table), Variants (axes), States (idle/hover/focused/disabled/loading/error), Events (table), Accessibility (ARIA/keyboard/focus/SR; Uncertain if unobservable), Usage Constraints, Dependencies, Composition (→COMP), Examples (optional; 1–3 observed usages), Evidence (reuse certainty across ≥2 screens).

---

## templates/template-COPY.md
**Type:** template

UX layer (one per scope). Frontmatter: doc_id `COPY-<scope>`, scope (`module-<slug>`|`shared-<purpose>`), language, `modules: []`. Sections: Purpose, Labels, Helper Texts, Empty States, Loading Texts, Error/Validation Messages (→BR/EN), CTAs (→UC), Microcopy Conventions, Evidence. Keys `<scope>.<screen-or-component>.<role>`; text transcribed verbatim.

---

## templates/project-skeleton/CLAUDE_template.md
**Type:** skeleton

Project constitution for AR-driven system reconstruction. Intended as the CLAUDE.md for analyzed repositories.

### Tooling Location
All AR tooling under `tooling/` (may be symlink). Core locations: `tooling/orchestration/01-evidence-collection/`, `02-system-reconstruction/`, `03-spec-driven-documentation/`, `90-optional-bonus/`, `99-legacy/`, `tooling/docs/`, `tooling/templates/`.

### AR Job Invocation Convention
When user writes `Run AR:<AgentName>`: (1) locate/load agent spec under `tooling/orchestration/`, (2) load matching task file if exists, (3) strictly follow both, (4) resolve paths relative to repo root. Task naming: `AgentName-task.md`. If multiple task files, use the one matching current pipeline branch/run scope.

### Pipeline Structure
1. **Evidence collection** — repo mapping, DB introspection, PDF evidence extraction, changelog extraction, SRV scouting, flow scouting/mining
2. **System reconstruction** — entity extraction, UC composition, domain kernel synthesis, aggregate boundary modeling, architecture overview
3. **Spec-driven documentation** — UC atomization, EN canonicalization, ARCH domain assembly, FN/ES/MSG/BR synthesis, rewrite decision compilation, spec closure evaluation, final publication

### Write Scope Restriction (STRICT)
May write ONLY to `_ar/**`. Must NEVER modify: production source code, configuration files, CI/CD, package manifests, lock files, database schema, infrastructure config, generated application assets. Exception: only if explicitly instructed by user.

### Repository Scope (Monorepo Awareness)
Treat each deployable unit as potential bounded context candidate. Do not assume FE/BE share identical models. Respect cross-app/cross-package boundaries. Prefer evidence over naming assumptions.
Ignore: `node_modules/`, `build/`, `dist/`, `.next/`, `.expo/`, `coverage/`, `.turbo/`, `.cache/`, `generated/`, `out/`

### Documentation Layers (Strict Discipline)
**Canonical:** EN (entities/invariants), UC (orchestration/business intent), ARCH (system structure), FN (internal capabilities), ES (external systems), MSG (transactional messages), BR (business rules), CS (observed FE-evidence critical scenarios)
**Supporting:** SRV (service boundaries), FLOW (execution flow evidence), Evidence (source-backed extraction)
**Publication tier:** drafts authored flat in `_ar/spec-draft/<LAYER>/`; final publishable layer tiered into `_ar/spec-final/BA/<LAYER>/` + reserved `_ar/spec-final/UX/<LAYER>/`, one `_REGISTRY.md` per layer, as a drop-in hand-off for an arg-emitee rebuild (see `tooling/docs/rules-spec-final.md`).
Must not mix layers. No code-level detail in UC/ARCH; no hidden domain rules in SRV; no workflow in BR; no external system in FN; no message contract in ES.

### Evidence-First Rule
No claim unless traceable to: repo source code, existing documentation, `_ar/evidence/**`, `_ar/pdf/**`, extracted changelogs, or already reconstructed AR artifacts.
- Uncertain → mark: `Hypothesis — Not evidenced in current sources.`
- Planned but not implemented → mark: `Status: Planned / Implemented / Unknown`

### Anti-Hallucination Rule
If info missing: do NOT guess/invent/fill gaps silently; state absence. If sources disagree: do NOT resolve silently; record discrepancy in `_ar/evidence/**`; mark: `Conflict — requires clarification.`

### Architecture Discipline
Do not redesign unless instructed. Do not suggest improvements unless a dedicated analysis/decision agent is running. Default: faithful reconstruction. Describe how the system works, not how it should work. Separate current-state from future-state.

### Agent and Task Discipline
Agent spec = reusable methodology; task file = run-specific scope/constraints. If conflict: task wins for current run; agent remains default. If no task: follow agent spec only; keep scope conservative.

### Output Quality Standard
Must be: deterministic, structured, rewrite-ready, traceable, layer-consistent, evidence-based.
Avoid: narrative fluff, marketing language, vague summaries, implementation leakage in business layers, silent confidence inflation.

### Primary Objective
Reconstruct to level where: system understood without browsing raw code, architecture reasoned about explicitly, greenfield rewrite can start without original developers, client receives clear layered spec-driven documentation.

### Operational Default
Order: (1) evidence collection, (2) system reconstruction, (3) spec-driven documentation. When in doubt: prefer faithful reconstruction over interpretation; narrower scope over expansion; explicit uncertainty over confident invention.

### Glossary Governance
Canonical sources: `_ar/repo-map/glossary-master.csv` (machine-readable truth), `_ar/repo-map/glossary.md` (published), `_ar/evidence/terminology/**` (candidates/drift/conflicts), `_ar/tasks/glossary-source-pack.md` (approved source whitelist).

Rules:
- No new canonical term without source-backed evidence
- Unsupported terms may only be proposed/ambiguous/legacy/rejected
- Terminology-sensitive agents must consult glossary workflow before writing canonical artifacts
- English canonical terminology is primary; Czech equivalents maintained for publication but must not redefine English meaning
- Drift detected → prefer: candidate collection → drift analysis → promotion → glossary publication before updating spec layers

### Runtime Truth Policy
Default location: `_ar/tasks/Runtime-truth-policy.md`. Runtime behavior = evidence only within approved scope. Runtime observation authoritative for current observable behavior, NOT automatically for business semantics or rewrite design. Conflicts with canonical artifacts must be recorded explicitly. Agents must not silently promote runtime observations into canonical business meaning unless policy explicitly allows.

---

## templates/project-skeleton/glossary-arbitration-decisions.md
**Type:** skeleton

Records human decisions needed to unblock glossary promotion.

**Status values:** approved, blocked, legacy, keep-in-english, defer, human-arbitration-required, split-concepts

**Recorded Decisions:**

| ID | Term Group | Decision | Reason Summary |
|---|---|---|---|
| ARB-001 | vytezovani family (9 compounds) | defer | OQ-007: "extraction" vs "data mining" unresolved; all compounds inherit ambiguity; unblock when translations/ checked or domain owner confirms |
| ARB-002 | Claude AI model version names (4 entries) | defer | Product-version identifiers, not stable domain terminology; evidence files only; never suitable for canonical glossary |
| ARB-003 | kosilka / kos / pohled (DMS permission boundaries) | human-arbitration-required | Three permission names with unclear concept boundaries (OQ-001/002/003); potential split-concepts needed; unblock by inspecting src/Entity/ and templates/dms/ |
| ARB-004 | upozorneni (alert vs notification) | human-arbitration-required | OQ-005: generic Czech word used as UI category, notification type, and possibly entire notification system; unblock by inspecting templates/notification/ |
| ARB-005 | zaloha family (7 terms) | human-arbitration-required | OQ-008/009, DRIFT-004/006: master has "deposit" framing, app uses "advance" framing; three Czech terms map to "advance payment" (synonym proliferation risk). Required: choose (a) adopt "advance" as canonical, (b) keep "deposit", or (c) keep both with scope notes |

**Pending (not yet evaluated):** DPH abbreviation (likely add as synonym), vrubopis (defer until smarteca p~58 checked), agenda/DMS (split-concepts if both meanings needed), vytezovani final resolution (check translations/).

---

## templates/project-skeleton/glossary-scope.md
**Type:** skeleton

**In scope:** document types, invoice settings terminology, payment/cashier-adjacent terminology, invoice lifecycle labels, accounting support vocabulary for Czech publication of invoicing artifacts.

**Out of scope:** broad CRM vocabulary, non-invoicing domain language, rewrite-only naming proposals.

**Preferred output policy:** lowercase-only terms, lean canonical rows, source-backed promotion only.

---

## templates/project-skeleton/glossary-source-pack.md
**Type:** skeleton

Approved terminology sources for glossary workflow.

### Source Policy
- Term may be collected as candidate when it has explicit source backing
- Term may be promoted into `_ar/repo-map/glossary-master.csv` only when source-backed AND not blocked by open semantic conflict
- If source-backed but semantically disputed: keep out of canonical promotion until human arbitration recorded

### Approved Sources

**Tier A — Direct term sources:**
1. `_ar/pdf/smartecaCZ.pdf` — Czech terms; use only explicit or conservative page-based pairing
2. `_ar/pdf/smartecaEN.pdf` — English terms; same pairing rule
3. `_ar/evidence/terminology/cz-chart-of-accounts-basic_0.xlsx` — paired CZ/EN accounting terms

**Tier B — Project evidence sources:**
4. `_ar/spec-draft/**` — project usage evidence; not authoritative alone for promotion
5. `_ar/evidence/**` — runtime/review evidence; candidate collection and drift analysis only
6. `_ar/spec-draft/DOMAIN-ubiquitous-language.md` — domain synthesis reference; helpful for alignment, not sufficient alone

### Forbidden Promotion Shortcuts
- Do not promote only because term appears repeatedly in drafts
- Do not promote only because term appears in runtime notes
- Do not invent Czech or English equivalents
- Do not collapse distinct concepts because labels look similar

### Current Policy
- Lowercase-only formatting preferred
- One preferred Czech + one preferred English term per canonical row
- Allowed synonyms go in `allowed_synonyms_cz` / `allowed_synonyms_en`, never in the preferred term field


---

# Section 2 — Glossary Governance & Evidence Collection

## orchestration/00-glossary-governance/agents/GlossaryCandidateCollector.md
**Type:** agent

**Mission:** Collect source-backed terminology candidates from evidence, draft spec artifacts, and approved external terminology packs. Creates a conservative candidate layer to stabilize canonical English terminology and Czech publication equivalents without promoting unsupported terms.

This agent does NOT publish the glossary, does NOT decide canonical terms, only extracts and normalizes candidates with provenance.

**Purpose in pipeline:** Evidence-ingestion agent. Use when new external terminology sources, evidence artifacts, runtime notes, or canonical drafts contain terminology not yet reflected in the glossary, or a terminology refresh is needed.

**Inputs:**
- Required: `_ar/repo-map/glossary-master.csv` (if exists), `_ar/spec-draft/**`, `_ar/evidence/**`
- Strongly recommended: `_ar/pdf/**`, `_ar/prtsc/**`, `_ar/repo-map/glossary.md`, `_ar/spec-draft/DOMAIN-ubiquitous-language.md`
- Optional: `_ar/tasks/glossary-source-pack.md`, `_ar/tasks/glossary-scope.md`, approved bilingual lexicons / chart of accounts / customer terminology sheets

**Outputs:**
- Required: `_ar/evidence/terminology/glossary-candidates.md`, `glossary-source-index.md`, `glossary-candidate-report.md`
- Optional: `_ar/evidence/terminology/glossary-unpaired-source-terms.md`

**Scope rules:**
- Allowed writes: `_ar/evidence/**`
- Do not modify: `_ar/repo-map/glossary-master.csv`, `_ar/repo-map/glossary.md`, existing EN/UC/BR/FN/ARCH artifacts, production code, config, migrations, runtime assets

**Hard rules:**
1. Do NOT invent translations.
2. Do NOT infer bilingual pairs unless source or task explicitly allows a conservative pairing rule.
3. Every candidate term MUST include exact source and locator.
4. If pairing uncertain, keep in unresolved/unpaired section rather than forcing a pair.
5. Do NOT promote candidates into canonical glossary files.
6. Preserve lowercase-only formatting if active glossary policy requires it.
7. Keep one preferred term candidate per row; alternatives go to synonym fields or notes.
8. If source is internally inconsistent, record the conflict explicitly.

**Candidate format:** Each candidate records (where available): concept candidate ID, preferred Czech term, preferred English term, allowed Czech/English synonyms, source, locator, confidence status (`jasne` or `prijatelne`), notes on ambiguity/conflict.

**Procedure:**
1. **Load active glossary context** -- Read current glossary master, active source-pack/scope task, relevant draft and evidence artifacts.
2. **Extract source-backed terminology** -- From external dictionaries/lexicons, runtime dossiers, evidence reports, draft EN/UC/FN/BR/ARCH artifacts, domain vocabulary.
3. **Normalize candidate representation** -- Normalize into working format. Separate: clear pairs, acceptable pairs (allowed by task policy), unresolved/conflicting terms.
4. **Refresh source index** -- Source name, type, trust level, extraction scope, notable caveats.
5. **Write candidate artifacts** -- Refresh candidate file, source index, and candidate report in place.

**Required files:**
- `glossary-candidates.md`: source-backed candidate rows, grouped by source/category, unresolved candidates clearly separated
- `glossary-source-index.md`: approved terminology sources used, short description, where applied, caveats/pairing restrictions
- `glossary-candidate-report.md`: source pack used, files scanned, candidate row count, unresolved groups, recommended next step

**Idempotency:** Safely re-runnable. Refresh in place, no duplicates, no renamed copies.

**Completion criteria:** All three required files exist, every candidate has provenance, unresolved pairings remain explicitly unresolved, no canonical glossary files modified.

**Invocation:** `Run AR:GlossaryCandidateCollector`

---

## orchestration/00-glossary-governance/agents/GlossaryDriftAnalyzer.md
**Type:** agent

**Mission:** Analyze terminology drift between canonical glossary, domain vocabulary, and current draft spec. Detects inconsistent term usage, missing canonical terms, synonym drift, overloaded terms, Czech publication gaps. Reports only -- does NOT publish glossary changes.

**Purpose:** Comparison and control agent. Use after `DOMAIN-ubiquitous-language.md` refresh, artifact changes, candidate ingestion, or before canonicalization/publication.

**Inputs:**
- Required: `_ar/repo-map/glossary-master.csv`, `_ar/spec-draft/**`, `_ar/evidence/terminology/glossary-candidates.md` (if exists)
- Strongly recommended: `glossary.md`, `DOMAIN-ubiquitous-language.md`, `DOMAIN-kernel.md`
- Optional: `_ar/evidence/**`, `_ar/tasks/glossary-scope.md`

**Outputs:**
- Required: `_ar/evidence/terminology/glossary-drift-report.md`, `glossary-open-questions.md`, `glossary-missing-terms.md`
- Optional: `glossary-canonicalization-hints.md`

**Scope:** Writes only to `_ar/evidence/**`. Do not modify glossary-master.csv, glossary.md, `_ar/spec-draft/**`, production code/config/migrations/runtime.

**Hard rules:**
1. Do NOT invent missing terms.
2. Do NOT rewrite EN/UC/FN/BR/ARCH/DOMAIN artifacts.
3. Every drift item MUST reference the compared artifact or source section.
4. Distinguish clearly: missing canonical term / inconsistent usage / acceptable synonym use / ambiguous concept boundary / Czech publication gap.
5. If term conflict changes business meaning, raise as open question (not style issue).
6. Do NOT silently collapse distinct concepts into one glossary entry.

**Procedure:** Load canonical baseline -> Load current terminology surfaces -> Compare usage (inconsistent glossary terms, draft terms missing from glossary, multiple EN/CZ labels per concept, CZ publication gaps) -> Classify drift deterministically -> Write reports in place.

**Required files:**
- `glossary-drift-report.md`: compared sources summary, drift items by category, impacted artifacts, recommended next steps
- `glossary-open-questions.md`: concept-boundary conflicts, unresolved source conflicts, cases needing human arbitration
- `glossary-missing-terms.md`: terms in draft but absent from glossary, terms missing Czech equivalent for publication

**Completion:** All compared sources listed, drift classified (not just enumerated), semantic questions separated from style drift, no glossary/draft modified.

**Invocation:** `Run AR:GlossaryDriftAnalyzer`

---

## orchestration/00-glossary-governance/agents/GlossaryPromoter.md
**Type:** agent

**Mission:** Promote approved, source-backed terminology into canonical machine-readable glossary master. Maintains one stable glossary source of truth for downstream agents. Updates `glossary-master.csv` but does NOT rewrite published glossary markdown directly.

**Purpose:** Controlled canonicalization agent. Use after candidate collection, drift analysis, and human arbitration decisions are available.

**Inputs:**
- Required: `_ar/repo-map/glossary-master.csv`, `glossary-candidates.md`, `glossary-drift-report.md`
- Strongly recommended: `glossary-open-questions.md`, `DOMAIN-ubiquitous-language.md`, `glossary-arbitration-decisions.md`
- Optional: `glossary.md`, `_ar/evidence/**`

**Outputs:**
- Required: `_ar/repo-map/glossary-master.csv`, `_ar/evidence/terminology/glossary-promotion-report.md`
- Optional: `glossary-rejected-promotions.md`

**Scope:** Writes to `_ar/repo-map/**` and `_ar/evidence/**`. Do not modify `_ar/spec-draft/**`, production code/config/migrations/runtime.

**Hard rules:**
1. No promotion without explicit provenance.
2. No promotion of terms blocked by open semantic conflict unless task authorizes.
3. Exactly one preferred Czech + one preferred English term per canonical concept row.
4. Synonyms stored separately from preferred terms.
5. Preserve lowercase-only if policy requires.
6. No deletion of existing rows unless task explicitly permits retirement with explanation.
7. Source-backed but ambiguous terms: reject and record.
8. Do NOT rewrite downstream draft artifacts.

**Canonical glossary columns:** concept_id, preferred_cz, allowed_synonyms_cz, preferred_en, allowed_synonyms_en, source, locator, status. If project schema differs, preserve it.

**Procedure:** Load promotion baseline -> Build worklist (safe to promote / blocked by ambiguity / rejected by conflict) -> Refresh glossary master (update in place, append safe new rows, no duplicates) -> Record decisions in promotion report (promoted, refreshed, blocked, rejected rows + required human follow-up).

**Required file -- glossary-promotion-report.md:** before/after summary, promoted rows, refreshed rows, blocked rows with reason, rejected rows with reason, recommended next step.

**Completion:** `glossary-master.csv` exists, all promotions source-backed, blocked explicit, one preferred EN+CZ per row, no draft files modified.

**Invocation:** `Run AR:GlossaryPromoter`

---

## orchestration/00-glossary-governance/agents/GlossaryPublisher.md
**Type:** agent

**Mission:** Publish canonical glossary master into markdown glossary (`_ar/repo-map/glossary.md`) consumed by downstream AR agents. Publishing bridge only -- does NOT invent terms, does NOT change draft spec.

**Purpose:** Bridge agent. Use when glossary master changed, downstream agents need refreshed input, or final publication needs stable Czech equivalents.

**Inputs:**
- Required: `_ar/repo-map/glossary-master.csv`
- Strongly recommended: `glossary-promotion-report.md`, `glossary-drift-report.md`
- Optional: `glossary-publish-notes.md`

**Outputs:**
- Required: `_ar/repo-map/glossary.md`, `_ar/repo-map/glossary-publish-report.md`
- Optional: `glossary-missing-publication-notes.md`

**Scope:** Writes only to `_ar/repo-map/**`. Do not modify `_ar/spec-draft/**`, `_ar/spec-final/**`, `_ar/evidence/**`, production code/config/migrations/runtime.

**Hard rules:**
1. No rows absent from canonical glossary master.
2. No silent rewriting of preferred terms during publication.
3. Preserve exact canonical preferred CZ+EN terms.
4. Preserve lowercase-only if required.
5. Render synonyms clearly but keep preferred terms visually distinct.
6. If glossary master incomplete for publication, report gap rather than guess.
7. Do NOT modify draft or final spec artifacts.

**Published glossary format:** Per concept: concept ID, preferred CZ, preferred EN, allowed CZ/EN synonyms, source, locator, status. Markdown tables or grouped sections; must be deterministic and diffable.

**Procedure:** Load canonical glossary master + publish notes -> Render stable markdown -> Write publish report (rows published, gaps, restrictions, next step).

**Completion:** `glossary.md` exists, `glossary-publish-report.md` exists, published rows match canonical master, no unsupported terms introduced.

**Invocation:** `Run AR:GlossaryPublisher`

---

## orchestration/00-glossary-governance/tasks/GlossaryCandidateCollector-task.md
**Type:** task

**Goal:** Collect source-backed terminology candidates for active BENE glossary workflow.

**Focus areas:** invoicing, invoice settings, document-type, payment/cashier-adjacent terminology, approved accounting vocabulary for Czech publication support.

**Required sources:** `glossary-master.csv`, `_ar/spec-draft/**`, `_ar/evidence/**`, `smartecaCZ.pdf`, `smartecaEN.pdf`, `cz-chart-of-accounts-basic_0.xlsx`, `glossary-source-pack.md`, `glossary-scope.md`. Report gaps if missing, continue with available.

**Extraction policy:**
1. Only source-backed terms
2. Lowercase if safe
3. If CZ maps to multiple EN, do not force pair
4. If source provides paired CZ+EN, preserve
5. Uncertain rows as `prijatelne` not `jasne`
6. Record source conflicts explicitly
7. Do not modify canonical glossary

**Structure hints:** Group into: document types, invoice settings/config, payment/cashier, accounting support vocabulary, unresolved/conflicting. Omit empty sections.

**Success:** All candidates source-backed, unresolved remain unresolved, ready for drift analysis, no canonical glossary changed.

---

## orchestration/00-glossary-governance/tasks/GlossaryDriftAnalyzer-task.md
**Type:** task

**Goal:** Analyze terminology drift for active BENE glossary -- invoicing hotspot focus.

**Focus:** domain vocabulary, entity naming, invoice settings language, document-type distinctions, Czech publication safety.

**Required inputs:** `glossary-master.csv`, `glossary.md`, `DOMAIN-ubiquitous-language.md`, `_ar/spec-draft/EN/**`, `UC/**`, `FN/**`, `BR/**`, `ARCH/**`, `glossary-candidates.md`. Report missing, continue.

**Comparison policy:**
1. `glossary-master.csv` = canonical baseline
2. `DOMAIN-ubiquitous-language.md` = strongest draft vocabulary signal
3. Report drift without rewriting
4. Separate naming drift from concept-boundary conflicts
5. Surface Czech translation gaps for publication
6. Explicitly flag conflicts around: invoice, tax document, deposit/proforma, corrective document naming, invoice setting, cashier-adjacent distinctions

**Success:** All major drift classified, human-only decisions explicit, report usable by downstream canonicalization, no files changed.

---

## orchestration/00-glossary-governance/tasks/GlossaryPromoter-task.md
**Type:** task

**Goal:** Promote safe, source-backed terminology into canonical BENE glossary master.

**Focus:** invoicing hotspot, document-type, invoice settings, Czech publication terms backed by approved sources.

**Promotion policy:**
1. Only rows with explicit source + locator
2. Lowercase-only rows
3. One preferred CZ + one preferred EN per row
4. Alternative labels in `allowed_synonyms_*`, `|`-separated
5. Semantically disputed terms: do not promote
6. Existing rows: refresh in place, no duplicates
7. No removal unless task explicitly names for retirement

**Deliverables:** `glossary-master.csv`, `glossary-promotion-report.md`. Optional: `glossary-rejected-promotions.md`.

**Success:** Promoted rows safe for downstream, blocked promotions excluded, glossary stays lean and machine-readable.

---

## orchestration/00-glossary-governance/tasks/GlossaryPublisher-task.md
**Type:** task

**Goal:** Publish canonical BENE glossary master into markdown for downstream AR agents.

**Publication policy:**
1. `glossary-master.csv` = single source of truth
2. Lowercase-only
3. One preferred CZ + EN per row
4. Synonyms shown clearly, not merged into preferred fields
5. Source + locator visible per row
6. Missing publication note: record gap, don't guess

**Deliverables:** `glossary.md`, `glossary-publish-report.md`. Optional: `glossary-missing-publication-notes.md`.

**Success:** Downstream agents can safely read `glossary.md`, stable Czech/English terminology bridge for final publication, no invented rows.

---

## orchestration/01-evidence-collection/agents/ChangeLogEvidenceCurator.md
**Type:** agent

**Mission:** Extract traceable facts from change logs, Jira/Asana exports, ticket dumps, and similar change history sources into structured evidence. Captures business intent, decisions, behavior expectations, implementation notes (kept separate from canonical spec). Evidence and gap-mapping only -- does NOT patch UC/EN/SRV/ARCH directly.

**Scope:**
- Allowed writes: `_ar/evidence/**`, `_ar/spec-draft/CHG-gap-closure.md`, `_ar/spec-draft/ADR-candidates.md`
- Do not modify: source code, config, canonical spec, UC/EN/SRV/ARCH files
- Primary source: `_ar/pdf/**`. Abort if no usable source files found.

**Inputs:**
- Read ONLY from `_ar/pdf/**`
- Context inputs (for mapping only, not as change-history sources): `UC-candidates.md`, `SRV-target-list.md`, `EN-candidates.md`, `unmapped.md`

**Outputs:** `_ar/evidence/changelog-index.md`, `_ar/evidence/changelog-facts.md`, `_ar/spec-draft/CHG-gap-closure.md`, `_ar/spec-draft/ADR-candidates.md`

**Hard rules:**
1. Read ONLY from `_ar/pdf/**` as source.
2. Write ONLY to approved output files.
3. Do NOT modify UC/EN/SRV/ARCH.
4. Do NOT invent facts.
5. Every fact: source reference (file + page/section).
6. Every fact: status (`Planned` | `Implemented` | `Unknown`).
7. Implementation notes separate from canonical spec implications.
8. Preserve uncertainty rather than force confidence.

**Fact model (per fact in changelog-facts.md):**
```
## CHG-FACT-0001
**Source:** <file>, page/section X
**Ticket/Key:** <JIRA-123 or None>
**Date:** <if present>
**Category:** BR | UC | EN | SRV | ARCH | ADR | IMPL
**Statement:** 1-3 sentences, normalized.
**Rationale/Intent:** short quote/paraphrase of why.
**Proposed Mapping:** UC: / EN: / SRV: / ARCH: / ADR: / Unknown:
**Confidence:** Explicit | Implicit | Interpretative
**Status:** Planned | Implemented | Unknown
```

**Output intent:**
- `changelog-index.md`: source file list, time range, ticket/key patterns, main domains touched
- `changelog-facts.md`: atomic facts, one rule/change per fact, normalized, traceable
- `CHG-gap-closure.md`: facts mapped to spec gaps -- sections: UC corrections, missing UC, EN changes, SRV implications, ARCH implications, implementation-only notes. Each line references CHG-FACT IDs.
- `ADR-candidates.md`: ADR/ARCH facts only -- decision statement, options, trade-off, impacted contexts, source ref. Do NOT write full ADRs.

**Quality bar:** Atomic, traceable, skimmable, reusable, explicit about confidence/status.

**Procedure:** Index source set -> Extract atomic facts -> Build gap-closure map -> Build ADR candidate list.

**Idempotency:** Re-runnable; refresh in place, no duplicates/renames.

**Completion:** All output files exist, every fact source-backed with status, facts atomic, gap-closure mapping exists, ADR candidates listed without becoming full ADRs.

**Invocation:** `Run AR:ChangeLogEvidenceCurator`

---

## orchestration/01-evidence-collection/agents/DBIntrospector.md
**Type:** agent

**Mission:** Extract fact-based description of the database model from the repository: entities/models, relations, constraints, validation signals, data-backed system outputs. Evidence collection only -- no redesign, no inference of undocumented schema behavior, no inventing constraints.

**Scope:** Writes to `_ar/**`. Do not modify production code, config, lockfiles, migrations, schema, generated assets. Ignore `node_modules/`, build/dist folders, generated assets.

**Inputs (priority order):**
1. Prisma: `prisma/schema.prisma`, `prisma/migrations/**`
2. SQL migrations: `migrations/**`, `db/**`, `*.sql`
3. ORM models: TypeORM, Sequelize, Drizzle, other
4. Infrastructure: `docker-compose.yml`, `.env.example`, `DATABASE_URL`, DB containers
5. Validation: zod, joi, yup, class-validator, DTO schemas, request validation middleware (only if confirmed via evidence)

**Outputs:** `_ar/evidence/db-inventory.md`, `db-models.md`, `db-constraints-and-validation.md`, `_ar/repo-map/data-model-signals.md`. Also update DB sections of `_ar/coverage/mapped.md` and `unmapped.md`.

**Hard rules:**
1. Write ONLY to `_ar/**`.
2. Do NOT modify production code/config/lockfiles/migrations/schema.
3. Ask before running terminal commands, show exact command.
4. Do NOT invent schema rules, TTL values, constraints, or validation logic.
5. Unconfirmed assumptions: mark `Hypothesis`.
6. Every hard claim: `Evidence:` line.
7. Prefer confirmed schema evidence over application assumptions.
8. App-level validation not explicitly confirmed: do not present as fact.

**Evidence rule:** `Evidence: <file path>`. Prefer schema field names, model names, constant names, migration identifiers over raw line numbers. If uncertain: `Hypothesis: ...` / `Missing evidence: ...`

**Coverage states:** `Mapped (deep)`, `Indexed only`, `Unmapped`.

**Output intent:**
- `db-inventory.md`: DB technology, engine, ORM, connection source, models/tables, enums, open questions
- `db-models.md`: per-model: fields, relations, notes, risks, hypotheses
- `db-constraints-and-validation.md`: unique constraints, indexes, FK, app-level validation (if confirmed), hypotheses/missing evidence
- `data-model-signals.md`: model count, likely core domain entities, likely aggregates, output-oriented models

**Procedure:** Detect DB technology -> Inventory extraction (models, tables, enums, joins, ownership) -> Relations and constraints (fields, types, required/optional, defaults, PK/FK, unique, index, cascade) -> Validation signals -> System outputs (reports, invoices, exports, audit logs) -> Coverage update.

**Idempotency/Completion/Invocation:** Standard pattern. `Run AR:DBIntrospector`

---

## orchestration/01-evidence-collection/agents/FlowInspector.md
**Type:** agent

**Mission:** Create high-signal Flow Atlas -- identifies where flows start, likely SRV ownership, entity/integration touchpoints, and which flows to mine next. Wide-scope, shallow-depth scouting. Does NOT perform deep behavioral reconstruction, write UC/EN artifacts, or redesign SRVs.

**Pipeline position:** After SRVCurator + SRVRestructurer, before FlowMiner + UCComposer. May run before ENExtractor but must not author EN artifacts.

**Scope:** Writes to `_ar/evidence/**` and `_ar/spec-draft/**`. Do not modify production code, config, tests, lockfiles, dependencies, migrations, generated assets, existing SRV documents.

**Inputs:**
- Mandatory (stop if missing): `SRV-architecture-map.md`, `SRV-target-list.md`
- Strongly recommended: `entrypoints.md`, `modules.md`, `integrations.md`, `db-inventory.md`, `mapped.md`, `unmapped.md`
- Optional: `FLOW-risk-heuristics.md`

**Outputs:** `_ar/evidence/flow-index.md`, `_ar/spec-draft/FLOW-candidates.md`. Optional: `FLOW-triggers-map.md`.

**Hard rules:**
1-6. Standard write/no-modify/no-UC/no-EN/no-invent/discovery-only rules.
7. All confirmed claims must include trigger evidence.
8. Incomplete evidence: `Hypothesis` or `Partial`.
9. Use existing SRV target map; do not redesign boundaries.
10. Be concise -- atlas, not deep documentation.

**Discovery targets:** Web routes/controllers, API endpoints, CLI commands, scheduled jobs, async message handlers/queues, event listeners, external integration entrypoints (inbound mail, webhooks, payment callbacks, databox polling, websockets).

**flow-index.md fields:** FlowID, Trigger Type, Trigger Evidence, Primary SRV Candidate, Secondary SRV Candidates, Entity Touchpoints, Integration Boundaries, Depth Recommendation, Risk Tags, Confidence.
- Confidence: `Confirmed` | `Partial` | `Hypothesis`
- Trigger types: `UI Route` | `API Endpoint` | `CLI` | `Scheduler` | `Async Message` | `Listener` | `Webhook` | `Other`
- Depth recommendation: `Mine` | `Later` | `Skip`

**FLOW-candidates.md:** Top 20 for mining, top 10 highest-risk, top 10 architecture-defining, observed trigger patterns, missing evidence blockers. Every recommended flow references a FlowID.

**FLOW-triggers-map.md:** Grouped by trigger type, SRV candidate, integration boundary.

**Risk tags:** Money/VAT, Async, External Integration, Multi-tenant, Security, Legal/Gov, Data Loss, Idempotence.

**Procedure:** Load/validate inputs -> Trigger discovery -> Flow candidate identification (stable FlowIDs) -> SRV mapping -> Entity touchpoint scan (name only) -> Integration boundary detection -> Risk tagging -> Write atlas outputs.

**Completion:** `flow-index.md` + `FLOW-candidates.md` exist, >=30 triggers indexed (or all), >=15 flows recommended for mining, every recommended flow has Primary SRV, risk tags consistent, all hard claims evidence-based.

**Invocation:** `Run AR:FlowInspector`

---

## orchestration/01-evidence-collection/agents/FlowMiner.md
**Type:** agent

**Mission:** Deep reconstruction of selected business flows from legacy implementation to produce: traceable behavior evidence, side effects/invariants, DB write/read footprints, integration boundaries, async breaks, failure modes. Evidence and behavior digests only -- does NOT write UC/EN, redesign SRVs, copy implementation code, or write UI-level descriptions.

**Pipeline position:** MUST run AFTER SRVRestructurer + FlowInspector output exists, BEFORE UCComposer. May run before ENExtractor; should emit lifecycle evidence EN work can reuse.

**Scope:** Writes to `_ar/**`. Do not modify production code, config, schema, migrations, lockfiles, generated assets. Ignore `node_modules/`, build/dist, caches, minified bundles. UI assets only if sole encoded behavior source.

**Inputs:**
- Mandatory (stop if `flow-index.md` missing): `SRV-architecture-map.md`, `SRV-target-list.md`, `flow-index.md`, `FLOW-candidates.md`
- Context: `integrations.md`, `db-inventory.md`, `db-models.md`, `db-constraints-and-validation.md`, `unmapped.md`, `FLOW-risk-heuristics.md`

**Outputs:**
- Per-flow dossiers: `_ar/evidence/flow/FLW0001_<slug>.md` etc.
- Traceability: `_ar/spec-draft/SRV-flow-traceability.md`
- Optional: `_ar/spec-draft/EN-lifecycle-evidence.md`

**Hard rules:**
1. Write ONLY to `_ar/**`.
2. Ask before terminal commands.
3. Unconfirmed: mark `Hypothesis`.
4-6. No UC/EN/SRV writing/altering.
7. No implementation code copying.
8. Evidence: file paths and symbols only.
9. Long code excerpts prohibited.
10. Focus only on shortlisted flows.

**Evidence rule:** File paths, symbols, route/handler names, service methods, listener names, repository usage, config refs. No long snippets. Inferred = `Hypothesis`.

**Required dossier structure:**
- **A Header:** FlowID, Flow Name, Primary SRV, Trigger Evidence, Confidence Level
- **B Behavior Digest:** Trigger, Preconditions, Main Steps, Postconditions, Side Effects, Integration Calls, Failure Modes
- **C Data Footprint:** Entities Written/Read, Constraints involved, Multi-tenant scope assumptions
- **D Evidence Block:** Controller paths, Service methods, Repository usage, Event listeners, Async messages, Config evidence

**Traceability (SRV-flow-traceability.md):** SRV-to-FlowIDs, FlowID-to-SRV dependencies, boundary violations, cross-context writes, orchestrator SRV evidence. Must explain why flow supports or challenges current SRV boundary.

**Optional lifecycle evidence (EN-lifecycle-evidence.md):** Per central entity: observed state changes, where evidenced, confirmed vs hypothesis. Evidence-only, not an EN document.

**Mining method:** Start at trigger -> Trace orchestration -> Enumerate side effects -> Map data writes/reads -> Detect integrations -> Record failure modes -> Assign confidence.

**Confidence values:** `Confirmed` (direct evidence), `Partial` (some evidence, gaps), `Hypothesis` (inferred from naming/structure).

**Quality bar:** >=10 dossiers (or all), each with Behavior Digest + Data Footprint + Evidence Block, `SRV-flow-traceability.md` updated with all mined FlowIDs, >=5 risk items across flows, no UC/EN authored.

**Idempotency/Completion/Invocation:** Standard pattern. `Run AR:FlowMiner`

---

## orchestration/01-evidence-collection/agents/PDFEvidenceCurator.md
**Type:** agent

**Mission:** Extract evidence from external PDF documents into structured markdown evidence artifacts. Preserves business descriptions, historical requirements, terminology, process descriptions, architectural hints, constraints, assumptions. Does not treat PDF as canonical truth by default, does not rewrite spec directly, does not invent unsupported structure.

**Scope:** Writes to `_ar/**`. Do not modify production code, config, source documents, generated assets. Primary input: `_ar/pdf/`. Ignore unrelated folders, caches, binaries outside scope.

**Inputs:**
- Primary: PDFs in `_ar/pdf/`
- Secondary context: `glossary.md`, `modules.md`, `integrations.md`
- PDFs treated as supporting evidence unless task states authoritative.

**Outputs:** Under `_ar/evidence/pdf/` -- one markdown per PDF or meaningful group, optional index file. Coverage files updated if task requires.

**Hard rules:**
1. Write ONLY to `_ar/**`.
2. Do NOT modify source PDFs.
3. Ask before terminal commands.
4. Do NOT invent requirements/terms/process details.
5. Every hard claim: `Evidence:` line (pdf file + page/section).
6. Plausible but unsupported: `Hypothesis`.
7. Distinguish: direct evidence / inferred interpretation / unresolved ambiguity.
8. Do NOT silently promote PDF statements into canonical spec truth.

**Quality bar:** Skimmable, evidence-based, reusable, explicit confidence, structured enough for EN/UC/ARCH/FN/BR/ES/MSG reconstruction later.

**Output captures:** Document purpose, terminology, process/feature descriptions, architectural hints, constraints, gaps/contradictions vs repo evidence, sections worth follow-up. Large sets may produce per-document summaries, topic summaries, cross-document terminology.

**Procedure:** Identify input set (individual / topic / batch) -> Extract evidence (vocabulary, processes, roles, artifacts, constraints, external systems, architecture, intent) -> Separate evidence from interpretation -> Write to `_ar/evidence/pdf/` -> Optional indexing.

**Idempotency/Completion/Invocation:** Standard pattern. `Run AR:PDFEvidenceCurator`

---

## orchestration/01-evidence-collection/agents/RepoCartographer.md
**Type:** agent

**Mission:** Produce high-signal navigation map of the repository: main modules, entrypoints, integration surfaces, mapped/unmapped areas. Reusable without repeated uncontrolled scanning. Evidence collection only -- no business logic reconstruction, no architecture inference beyond direct evidence.

**Scope:** Writes to `_ar/**`. Do not modify source code, config, generated assets, project metadata outside `_ar/**`. Ignore `node_modules/`, `.expo/`, caches, generated assets.

**Inputs:** Repository root. Evidence from: source folders, package manifests, build/runtime config, scripts, docs, platform folders, infrastructure descriptors. Prefer targeted inspection over broad scanning.

**Outputs:** `_ar/repo-map/entrypoints.md`, `modules.md`, `integrations.md`, `_ar/coverage/mapped.md`, `unmapped.md`

**Hard rules:**
1. Write ONLY to `_ar/**`.
2. Do NOT modify code/configs.
3. Ask before terminal commands.
4. Ignore node_modules/.expo/caches/generated.
5. Do NOT invent numeric config values.
6. Every hard claim: `Evidence: <paths>`.
7. Plausible but unsupported: `Hypothesis`.
8. Coverage statuses: `Mapped (deep)` | `Indexed only` | `Unmapped`.

**Coverage semantics:**
- `Mapped (deep)`: purpose, important files, main role describable
- `Indexed only`: noticed and roughly classified, not deeply inspected
- `Unmapped`: not yet meaningfully inspected

**Output intent:**
- `entrypoints.md`: app bootstrap, backend startup, routing roots, worker/mobile/scheduled/deployment entrypoints
- `modules.md`: main repo modules/bounded areas -- what exists, where, what it owns
- `integrations.md`: external services, APIs, data stores, platform bridges, messaging/auth/storage/payment/analytics
- `mapped.md`: areas with `Mapped (deep)` or `Indexed only`
- `unmapped.md`: areas not covered enough for reconstruction

**Procedure:** Identify repo shape -> Entrypoints -> Modules -> Integrations -> Assign coverage -> Refresh outputs.

**Idempotency/Completion/Invocation:** Standard pattern. `Run AR:RepoCartographer`

---

## orchestration/01-evidence-collection/agents/SRVCurator.md
**Type:** agent

**Mission:** Reconstruct and redesign system Service layer architecture (architecture-first) for rewrite planning. SRVs are architectural boundaries, not function inventory. Must: identify real bounded contexts, separate domain logic from orchestration, reduce fragmentation, detect smells, propose target SRV structure. Does not modify production code or patch EN/UC/ARCH.

**Scope:** Writes only to `_ar/spec-draft/**`. Do not modify production code, config, lockfiles, migrations, generated assets, non-SRV draft artifacts.

**Inputs:** Repository source, `entrypoints.md`, `modules.md`, `integrations.md`, `db-inventory.md`, `db-models.md`, `db-constraints-and-validation.md`, `EN-candidates.md` (all if they exist). May search for pre-existing SRV specs.

**Outputs:** `_ar/spec-draft/SRV-candidates.md`, `_ar/spec-draft/SRVxxxx_<Name>.md` per SRV.

**Hard rules:**
1. Write ONLY to `_ar/spec-draft/**`.
2. Never modify production code.
3. Do NOT invent behavior.
4. All hard claims: evidence.
5. Incomplete evidence: `Hypothesis` + state what's missing.
6. Each SRV: exactly one bounded context.
7. Multi-context service: flag as architectural issue.
8. No SRVs from passive join tables without behavior evidence.
9. Do NOT skip consolidation.
10. Do NOT skip architectural validation.

**SRV Discovery (mandatory first step):** Search for existing SRV specs in `spec/**/SRV*.md`, `docs/**/SRV*.md`, `**/services/SRV*.md`. If found: `Spec Alignment` mandatory in all drafts, report count+paths. If none: state `No SRV spec files found by search.` Failure to perform invalidates the run.

**Phase 1 -- Structural Discovery:** Identify core domain areas, integration boundaries, background processing, infrastructure layers. Output in `SRV-candidates.md`: `## Detected Bounded Contexts` with real context names backed by evidence.

**Phase 2 -- Context Assignment:** Each SRV = exactly one bounded context. Multi-context = explicit architectural issue flag.

**Phase 3 -- Consolidation:** Merge (shared DB models, shared integration boundary, thin wrappers). Split (multiple integration boundaries, mixed domain/infra, orchestration dumping grounds). All decisions justified with evidence.

**Phase 4 -- Smell Detection:** Per SRV: Orchestration Smell, God Processor, Thin Adapter duplication, Hidden Domain Logic, Vendor Lock-in boundary.

**Phase 5 -- Target SRV Map:** Rewrite-ready structure grouped by bounded context with clear architectural roles.

**SRV Classification:**
- Category: Domain Service | Integration Adapter | Projection/Reporting | Infrastructure/Security | Background Processing | UI/Application Service
- Responsibility Type: Core Domain | Adapter | Orchestrator | Infrastructure

**Confirmed vs Transitional SRV:** Confirmed = at least one Trigger + Input evidence + Output evidence. Missing any = Transitional SRV.

**Required SRV draft structure (SRVxxxx_<Name>.md):** Bounded Context, SRV Category, Responsibility Type, Purpose, Current Implementation Shape, Structural Issues (overreach, mixed concerns, transactional risks, lock-in), Target Shape, Integration Dependencies, Boundaries (what NOT owned), Spec Alignment (mandatory if specs exist), Open Questions (max 5 with missing evidence guidance).

**SRV-candidates.md required content:** SRV Spec Discovery summary, Bounded Context map, Promotion table, Consolidation decisions, Smell detection summary, Proposed Target SRV Structure, Tiered gap list (Tier 1/2/3 missing evidence).

**Procedure:** SRV Spec Discovery -> Structural Discovery -> Candidate Drafting -> Consolidation -> Smell Detection -> Target SRV Map.

**Non-goals:** No production code patching, no DB redesign, no UC/EN/ARCH writing.

**Idempotency/Completion/Invocation:** Standard pattern. `Run AR:SRVCurator`

---

## orchestration/01-evidence-collection/agents/SRVRestructurer.md
**Type:** agent

**Mission:** Restructure existing SRV outputs into a rewrite-ready architecture by enforcing a 4-layer SRV taxonomy and producing a consolidated target SRV map. Does NOT discover new SRVs from code; operates only on already-produced SRV documents and their summaries.

**Scope:** Write ONLY to `_ar/spec-draft/**`. Do not modify production code, prior SRV drafts, or prior EN drafts. Append-only to `SRV-candidates.md`; never rewrites previous discovery notes.

**Inputs:** `SRV-candidates.md`, all `SRV*.md` drafts, `EN-candidates.md` (if present), `_ar/repo-map/modules.md` (if present), `_ar/repo-map/integrations.md` (if present). Report missing optional files and proceed.

**Outputs:** `SRV-architecture-map.md`, `SRV-restructuring-actions.md`, `SRV-target-list.md`. Append-only: new section `Architecture-First Restructuring Summary` in `SRV-candidates.md`.

**Hard rules:**
1. Write ONLY to `_ar/spec-draft/**`.
2. Do NOT modify production code or prior SRV/EN drafts.
3. Do NOT invent behavior. Use only existing SRV drafts/candidates/context.
4. Do NOT discover new SRVs from code or re-read repository code.
5. Do NOT generate UC or EN, redesign DB, or propose code changes.
6. Missing metadata → state `Unclear from SRV drafts` and list which drafts lack it.

**Four-Layer Taxonomy:**
1. **Domain Services** — own business capabilities and domain rules; do not call external vendors directly; do not run background loops.
2. **Application Orchestrators** — coordinate multi-step flows across Domain Services/Adapters; explicit orchestration boundaries; no core domain invariants.
3. **Integration Adapters** — own one external boundary each (ERP, payments, email, search, storage, analytics); encapsulate vendor lock-in and mapping; no domain decisions beyond protocol mapping/retries.
4. **Async Processors** — queue consumers, cron jobs, sync processors, workers; trigger Orchestrators/Domain Services; never embed large domain logic; explicit triggers, retry, and idempotency.

**Procedure:**
1. **Normalize SRV metadata:** Layer, Bounded Context (use declared or infer from Purpose + integrations), Integration Boundary (if any), Primary Trigger Type (endpoint | resolver | job | cron | internal).
2. **Detect structural smells:** mixed integration boundaries (2+ vendors/systems), god processor, orchestrator masquerading as domain, adapter masquerading as domain, processor containing substantial domain logic.
3. **Produce consolidation actions:** merge / split / rename candidates.
4. **Produce Target SRV Map:** grouped by Bounded Context + Layer; annotate dependencies between layers, vendor lock-in points, transitional (legacy-only) vs. stable (rewrite core) SRVs.

**Output intent:**
- `SRV-architecture-map.md` — bounded contexts, 4-layer grouping, dependency notes, vendor lock-in boundaries
- `SRV-restructuring-actions.md` — proposed merges/splits/renames with justification citing SRV id/name; `Do not touch` list for clean SRVs
- `SRV-target-list.md` — final consolidated list; per target SRV: Name, Layer, Context, Primary Trigger, External Boundary (if adapter), Source SRVs
- Appended `Architecture-First Restructuring Summary` in `SRV-candidates.md` — append-only

**Formatting:** short tables/bullets; no speculation; `Unclear from SRV drafts` when unsure.

Standard AR agent boilerplate applies (idempotency: refresh outputs in place, no duplicate variants/renamed copies, continue append-only for summary section; invocation `Run AR:SRVRestructurer`).

---

## orchestration/01-evidence-collection/tasks/ChangeLogEvidenceCurator-task.md
**Type:** task

Compact wrapper for `ChangeLogEvidenceCurator` agent. Strict source: read ONLY `_ar/pdf/**`, abort if none. Write ONLY to: `changelog-index.md`, `changelog-facts.md`, `CHG-gap-closure.md`, `ADR-candidates.md`. Do NOT modify UC/EN/SRV/ARCH. Every fact: source reference + status (Planned | Implemented | Unknown).

---

## orchestration/01-evidence-collection/tasks/DBIntrospector-task.md
**Type:** task

Compact wrapper for `DBIntrospector` agent. Write ONLY to `_ar/**`. Enforce evidence rule strictly. Do not invent constraints/TTL/validation. Uncertain = `Hypothesis`. Priority: Prisma schema > migrations > ORM models > docker-compose/env > validation libraries. Deliverables: `db-inventory.md`, `db-models.md`, `db-constraints-and-validation.md`, `data-model-signals.md`, coverage file DB sections.

---

## orchestration/01-evidence-collection/tasks/FlowInspector-task.md
**Type:** task

**Pre-execution checklist:** Confirm reading of `SRV-architecture-map.md`, `SRV-target-list.md`, plus optional `entrypoints.md`, `modules.md`, `integrations.md`, `db-inventory.md`, `mapped.md`, `unmapped.md`, `FLOW-risk-heuristics.md`. List present/missing. Stop if SRV mandatory inputs missing.

**Mandatory phases:** Trigger Discovery, Flow Candidate Identification, SRV Mapping, Entity Touchpoint Scan, Integration Boundary Detection, Risk Tagging.

**Flow fields required:** FlowID, TriggerType, TriggerEvidence, Primary SRV Candidate, Entity Touchpoints, Integration Boundaries, Risk Tags, Depth Recommendation, Confidence Level. Weak evidence = `Hypothesis`.

**Risk tags:** Money/VAT, Async, External Integration, Multi-tenant, Security, Legal/Gov, Data Loss, Idempotence.

**Prohibited:** Deep flow logic reconstruction, writing UC/EN, modifying SRV docs, inventing behavior.

**Deliverables:** `flow-index.md`, `FLOW-candidates.md`. Optional: `FLOW-trigger-map.md`.

**Exit criteria:** >=30 flows discovered (or all), >=15 recommended for mining, every flow mapped to Primary SRV, >=5 high-risk flows.

---

## orchestration/01-evidence-collection/tasks/FlowMiner-task.md
**Type:** task

**Pre-execution checklist:** Confirm reading of `SRV-architecture-map.md`, `SRV-target-list.md`, `flow-index.md`, `FLOW-candidates.md`, plus optional DB/integration/coverage files. Stop if `flow-index.md` missing.

**Scope selection:** Default top 10 from `FLOW-candidates.md`, max 20 per run. Each flow references a FlowID.

**Mandatory phases:** Trigger Trace, Orchestration Trace, Side Effect Discovery, Data Footprint Mapping, Integration Detection, Failure Mode Discovery.

**Prohibited:** Writing UC/EN, redesigning SRVs, copying implementation code, UI-level descriptions.

**Deliverables:** `_ar/evidence/flow/FLWxxxx_<slug>.md` per flow, `SRV-flow-traceability.md`. Optional: `EN-lifecycle-evidence.md`.

**Exit criteria:** >=10 dossiers (or all), each with Behavior Digest + Data Footprint + Evidence Block, `SRV-flow-traceability.md` updated, >=5 architectural risks.

---

## orchestration/01-evidence-collection/tasks/PDFEvidenceCurator-task.md
**Type:** task

Compact wrapper for `PDFEvidenceCurator` agent. Write ONLY to `_ar/**`. Input: `_ar/pdf/`. Treat PDFs as evidence unless stated otherwise. Enforce evidence rule. Do not invent requirements/process/architecture. Uncertain = `Hypothesis`. Deliverables: markdown evidence under `_ar/evidence/pdf/`. Optional: index file for multi-PDF sets.

---

## orchestration/01-evidence-collection/tasks/RepoCartographer-task.md
**Type:** task

Compact wrapper for `RepoCartographer` agent. Write ONLY to `_ar/**`. No code/config modification. Ask before terminal commands. Ignore `node_modules/`, `.expo/`, caches, generated assets. No invented numeric config values -- use Evidence or Hypothesis. Deliverables: `entrypoints.md`, `modules.md`, `integrations.md`, `mapped.md`, `unmapped.md`. Quality: every hard claim has `Evidence: <paths>`, coverage uses `Mapped (deep)` / `Indexed only` / `Unmapped`, outputs skimmable and link-rich.

---

## orchestration/01-evidence-collection/tasks/SRVCurator-task.md
**Type:** task

**Pre-execution checklist:**
1. SRV Spec Discovery performed (count + paths)
2. Confirm reading of: `entrypoints.md`, `modules.md`, `integrations.md`, `db-inventory.md`, `db-models.md`, `db-constraints-and-validation.md`, `EN-candidates.md`
3. Confirm detected deployables (backend, storefront, admin, shared modules)
Do not proceed if any step skipped.

**Mandatory phases:** SRV Spec Discovery, Structural Discovery, Candidate Drafting, SRV Consolidation, SRV Smell Detection, Target SRV Map Proposal.

**Confirmed SRV requirements:** At least one Trigger + Input evidence + Output evidence. Missing = Transitional. Each SRV: Category, Bounded Context, Responsibility Type, Deployment/Location.

**Prohibited:** SRVs from passive join tables without behavior, inventing behavior, skipping consolidation, skipping architectural validation.

**Deliverables:** `SRV-candidates.md` (with: Spec Discovery summary, Bounded Context map, Promotion table, Consolidation decisions, Smell summary, Target Structure, Tiered gap list), `SRVxxxx_<Name>.md` per SRV. Write only to `_ar/spec-draft/**`.

---

## orchestration/01-evidence-collection/tasks/SRVRestructurer-task.md
**Type:** task

**Pre-check:** Confirm reading of `SRV-candidates.md`, all `SRV*.md`, `EN-candidates.md`, `modules.md`, `integrations.md`. Report missing optionals, proceed.

**Deliverables:**
- `_ar/spec-draft/SRV-architecture-map.md`
- `_ar/spec-draft/SRV-restructuring-actions.md`
- `_ar/spec-draft/SRV-target-list.md`
- Append `Architecture-First Restructuring Summary` section to `SRV-candidates.md`

**Execution rules:**
- Do NOT discover new SRVs from code -- use only existing drafts/candidates/context files
- Do NOT modify prior SRV drafts or EN drafts
- Do NOT invent behavior or hidden responsibilities
- Missing metadata: state `Unclear from SRV drafts`

**Exit criteria:** Four-layer taxonomy applied, restructuring actions explicit, target SRV list traceable to source SRVs, append-only summary added to `SRV-candidates.md`.


---

# Section 3 — System Reconstruction

## orchestration/02-system-reconstruction/agents/ENExtractor.md
**Type:** agent

**Mission:** Transform repository findings into domain entity drafts. Reconciles database truth, code usage truth, and existing spec truth. Produces EN drafts and an EN candidate table. Does NOT modify code/schema. Does NOT invent domain behavior without evidence.

**Scope:** Writes ONLY to `_ar/spec-draft/**`. No modifications to production code, configuration, lockfiles, migrations, schema files, generated assets.

**Mandatory Inputs:**
- `_ar/evidence/db-inventory.md`
- `_ar/evidence/db-models.md`
- `_ar/evidence/db-constraints-and-validation.md`
- `_ar/repo-map/modules.md`
- `_ar/repo-map/integrations.md`
- any discovered EN spec files

Optional supporting inputs may be used but mandatory inputs define minimum valid run.

**Outputs:**
- `_ar/spec-draft/EN-candidates.md`
- `ENxxxx_<Name>.md` files under `_ar/spec-draft/`

**Hard Rules:**
1. Write ONLY to `_ar/spec-draft/**`.
2. Do NOT modify code or schema.
3. Do NOT invent domain behavior without evidence.
4. Every hard claim must include `Evidence:`.
5. Do NOT claim spec absence without explicit search.
6. Confidence cannot be High without usage evidence.
7. Enum presence does NOT by itself confirm lifecycle transitions.
8. Keep domain meaning separate from infrastructure and implementation detail.

**Spec Discovery (Mandatory -- failure invalidates the run):**
Search for existing EN docs in `spec/**/EN*.md`, `docs/**/EN*.md`, `**/entities/EN*.md`. If any EN file exists, Spec Alignment becomes mandatory for all promoted entities. If spec exists under a different path, adapt. If no EN spec files found, state explicitly only after search confirms zero results.

**Entity Promotion Decision:**
- Step 1 -- Is this a domain concept? Promote if: business meaning, lifecycle semantics, API/UI participation, exists in spec. Reject if: pure join table, pure technical artifact, enum/config only, transient runtime state without domain meaning.
- Step 2 -- Assign category: Persisted | Content | Planned | Runtime-only.

**Lifecycle Rule:** Allowed statuses may be confirmed from schema evidence. Transitions confirmed ONLY with code path evidence. Otherwise express as `Hypothesis:` / `Missing evidence:`. Enum presence alone is not enough.

**Domain vs Infrastructure Separation:** EN describes domain meaning. Hashes, token storage, middleware, validation libraries, implementation mechanics must NOT be treated as core EN narrative. Move to `_ar/spec-draft/SRV-candidates.md` or `_ar/evidence/**`.

**Spec Alignment Rule:** If any EN spec file discovered, each promoted entity must include:
```
## Spec Alignment
- Corresponds to: ENxxxx -- <Name>
- Matches:
- Drift:
- Missing in code:
- Extra in code:
- Evidence:
```
If spec exists but entity has no counterpart: `No corresponding spec entity found.`
If no EN spec files exist anywhere: `No EN spec files found in repository.`

**Required EN Draft Structure:**
```
# ENxxxx -- <Name>
## Description
## Entity Category
## Origin (DB artifacts, Code touchpoints, Evidence)
## Core Fields
## Technical Fields (if needed)
## Relations
## Allowed Statuses (Evidence)
## Lifecycle (Confirmed transitions or Hypothesis/Missing evidence)
## Spec Alignment
## Open Questions (max 5)
```

**EN-candidates Table Format:**

| Entity | Promote | Category | Confidence | Rationale | Schema Evidence | Usage Evidence |

Confidence: High = DB + usage evidence; Medium = schema confirmed, usage partial; Low = schema or spec only.

**Procedure:**
1. Spec Discovery -- search for existing EN spec files, record result.
2. Entity inventory review -- DB inventory, models, constraints, modules, integrations.
3. Promotion decision -- classify domain entities.
4. Draft EN pages -- write/refresh EN drafts using required structure.
5. Build EN-candidates table -- summarize promotion decisions, confidence, evidence.

**Idempotency:** Re-runnable. Refresh in place; no duplicates or renamed copies.

**Completion Criteria:** Spec Discovery performed; `EN-candidates.md` exists; promoted entities have EN drafts; hard claims evidence-based; confidence justified; lifecycle claims follow strict rule; domain/infrastructure separated.

**Invocation:** `Run AR:ENExtractor`

---

## orchestration/02-system-reconstruction/agents/UCComposer.md
**Type:** agent

**Mission:** Compose orchestration-first Use Case layer from SRV architecture, EN entity definitions, and Flow evidence. Does NOT rediscover services or entities. Does NOT read repository code.

**Scope:** Writes ONLY to `_ar/spec-draft/**`. Does not modify EN drafts, SRV drafts, production code, configuration, repository source files.

**Mandatory Inputs:**
- Architecture: `_ar/spec-draft/SRV-architecture-map.md`, `SRV-target-list.md`, `SRV-candidates.md`
- Entity: `_ar/spec-draft/EN-candidates.md` (if exists), all `EN*.md` in `_ar/spec-draft/`
- Flow evidence: `_ar/evidence/flow-index.md`, `_ar/spec-draft/FLOW-candidates.md`, `SRV-flow-traceability.md` (if exists), `EN-lifecycle-evidence.md` (if exists)
- Coverage: `_ar/repo-map/modules.md` (if exists), `_ar/coverage/unmapped.md` (if exists)

**Outputs:**
- `_ar/spec-draft/UC-candidates.md`
- `_ar/spec-draft/UC-srv-traceability.md`
- `UCxxxx_<Name>.md` files under `_ar/spec-draft/`

**Hard Rules:**
1. Write ONLY to `_ar/spec-draft/**`.
2. Do NOT modify EN or SRV drafts.
3. Do NOT read repository code.
4. Do NOT invent behavior.
5. Every UC must map to at least one Target SRV.
6. Flow evidence is advisory but authoritative when available.
7. No code-level details (file paths, class names, method names).
8. Use EN entity names and business terminology only.

**Flow Awareness:** Use flow evidence to confirm orchestration paths, detect entity lifecycle transitions, prioritize root UCs, avoid inventing absent flows. If FlowMiner evidence exists, prefer those flows as root UC anchors.

**Non-negotiable Writing Rules:**
- R1 -- Actor-tagged steps: every step prefixed with actor. Allowed actors: `Customer:`, `Admin:`, `System:`, `External(<SystemName>):`, `Support:`, `Scheduler:`, `Integration(<SystemName>):`
- R2 -- One action per step.
- R3 -- No code-level detail.
- R4 -- Domain terminology only.
- R5 -- Evidence Level: each UC ends with `Evidence Level:` (Confirmed / Partial / Hypothesis) with rationale referencing SRV, EN, Flow evidence. Never raw code.

**UC Tree:** Anchor flows from Orchestrator SRVs, externally triggered SRVs, strong FlowMiner evidence. Each anchor becomes one root UC with subflows as sections (UCxxxx.1, UCxxxx.2, etc.).

**Required UC File Template:**
```
# UCxxxx -- <Name>
## Header (table: UC ID, Name, Bounded Context, Primary Actor(s), Trigger Type)
## Actors & Responsibilities
## Intent
## Preconditions
## Main Flow (sub-flows UCxxxx.1, UCxxxx.2 with actor-tagged steps)
## Alternative Flows (AF1, AF2... with actor-tagged steps and Outcome)
## Postconditions
## Traceability (Target SRVs, EN entities, Integration boundaries, Flow Evidence FLWxxxx)
## Evidence Level
```

**Coverage Enforcement:** Every Target SRV in at least one UC. Every Orchestrator SRV becomes root UC. External Adapters in at least one UC. SRV with no flow evidence gets a system UC stub.

**Procedure:**
1. Load architecture, entity, and flow evidence inputs.
2. Identify anchor flows (prefer mined and externally triggered orchestration paths).
3. Build UC tree (root UCs and subflows).
4. Write UC files (required structure, actor-tagged format).
5. Write UC indexes (`UC-candidates.md`, `UC-srv-traceability.md`).

**Idempotency:** Re-runnable. Refresh in place; no duplicates or renamed copies.

**Completion Criteria:** `UC-candidates.md` and `UC-srv-traceability.md` exist; root-level UC files exist; every UC maps to at least one Target SRV; actor-tagged step rules followed; flow evidence used; no code-level detail leaked.

**Invocation:** `Run AR:UCComposer`

---

## orchestration/02-system-reconstruction/agents/DomainKernelSynthesizer.md
**Type:** agent

**Mission:** Synthesize the core business domain kernel: canonical domain concepts, ubiquitous language, cross-entity invariants, key state machines. Transforms distributed EN/UC/Flow knowledge into a coherent domain model for rewrite. Does NOT modify EN, UC, or SRV documents.

**Scope:** Writes ONLY to `_ar/spec-draft/**`. No modification of existing EN/UC/SRV documents, production code, configuration.

**Mandatory Inputs:**
- All `EN*.md` and `UC*.md` under `_ar/spec-draft/`
- `_ar/spec-draft/SRV-architecture-map.md`, `SRV-target-list.md`
- `_ar/spec-draft/EN-lifecycle-evidence.md` (if exists)
- `_ar/evidence/flow/*.md` (if they exist)
- If any file group missing, report and continue with available inputs.

**Outputs:**
- `_ar/spec-draft/DOMAIN-kernel.md` (core concepts, cross-entity invariants, key state machines, domain hotspots)
- `_ar/spec-draft/DOMAIN-ubiquitous-language.md` (canonical vocabulary, definitions, synonyms, rejected/ambiguous terms)

**Hard Rules:**
1. Write ONLY to `_ar/spec-draft/**`.
2. Do NOT modify existing EN, UC, or SRV documents.
3. Do NOT invent domain rules.
4. All hard claims must reference EN, UC, or Flow evidence.
5. If evidence insufficient, mark as `Hypothesis`.

**Steps:**
1. Domain concept extraction -- identify core concepts across entity names, UC narratives, flow descriptions. Produce normalized concept list. Detect synonyms, overlapping/overloaded terms.
2. Ubiquitous language -- canonical vocabulary with definition, related entities, related use cases. Flag ambiguous/overloaded terms.
3. Cross-entity invariants -- rules spanning multiple entities (derived totals, consistency constraints, lifecycle dependencies, ownership rules). Each must reference entity names + UC/Flow evidence.
4. Core state machines -- simplified state machines from lifecycle evidence and UC flows.

**Procedure:** (1) Read EN, UC, flow evidence. (2) Extract domain concepts. (3) Identify invariants. (4) Synthesize state machines. (5) Write `DOMAIN-kernel.md` and `DOMAIN-ubiquitous-language.md`.

**Non-goals:** Does NOT change entity definitions, introduce architecture changes, generate new SRVs, rewrite UCs.

**Idempotency:** Re-runnable. Refresh in place; no duplicates or renamed copies.

**Completion Criteria:** Both DOMAIN files exist; hard claims evidence-based; invariants tied to EN/UC/Flow evidence; state machines simplified and traceable; existing documents untouched.

**Invocation:** `Run AR:DomainKernelSynthesizer`

---

## orchestration/02-system-reconstruction/agents/AggregateBoundaryModeler.md
**Type:** agent

**Mission:** Derive domain aggregate model and transactional boundaries. Analyzes EN entities, UC flows, SRV architecture to determine aggregate roots, aggregate members, transaction boundaries, consistency rules. Goal: rewrite-ready domain model.

**Scope:** Writes ONLY to `_ar/spec-draft/**`. No modification of existing EN/UC/SRV files, production code, configuration.

**Mandatory Inputs:**
- All `EN*.md` and `UC*.md` under `_ar/spec-draft/`
- `_ar/spec-draft/SRV-target-list.md`
- `_ar/spec-draft/SRV-flow-traceability.md` (if exists)

**Outputs:**
- `_ar/spec-draft/DOMAIN-aggregates.md` (aggregate definitions, roots, entity membership, lifecycle dependencies)
- `_ar/spec-draft/CONSISTENCY-boundaries.md` (transactional zones, eventual consistency flows, cross-aggregate coordination)

**Hard Rules:**
1. Write ONLY to `_ar/spec-draft/**`.
2. Do NOT modify existing EN, UC, or SRV files.
3. Do NOT invent domain behavior.
4. All aggregate decisions must reference EN relationships or UC flows.

**Steps:**
1. Candidate aggregate roots -- identify lifecycle anchors (lifecycle state machines, ownership of subordinates, transactional boundaries in UC flows).
2. Aggregate membership -- member entities, relationship direction, lifecycle coupling per root.
3. Consistency boundaries -- strong vs eventual consistency zones, cross-aggregate interactions. Flag risky patterns: cross-aggregate writes, multi-context transactions, shared mutable entities.
4. Command ownership -- owning SRV, primary UC flows, command boundaries per aggregate.

**Procedure:** (1) Read EN, UC, SRV inputs. (2) Identify aggregate roots. (3) Determine membership. (4) Determine consistency boundaries. (5) Write `DOMAIN-aggregates.md` and `CONSISTENCY-boundaries.md`.

**Non-goals:** Does NOT modify entity definitions, UC files, or redesign SRV architecture.

**Idempotency:** Re-runnable. Refresh in place; no duplicates or renamed copies.

**Completion Criteria:** Both output files exist; aggregate decisions tied to EN/UC evidence; transaction and consistency boundaries explicit; EN/UC/SRV files unchanged.

**Invocation:** `Run AR:AggregateBoundaryModeler`

---

## orchestration/02-system-reconstruction/agents/ARCHWriter.md
**Type:** agent

**Mission:** Produce rewrite-ready Application Overview: what the system is, why it exists, how it is structured, technological and integration boundaries. Does NOT analyze code. Builds strictly on existing AR artifacts (synthesis-only).

**Scope:** Writes ONLY to `_ar/spec-draft/**`. No modification of EN/SRV/UC files, production code, repository source files.

**Mandatory Inputs:**
- `_ar/repo-map/entrypoints.md`, `modules.md`, `integrations.md`
- `_ar/spec-draft/SRV-architecture-map.md`, `SRV-target-list.md`
- `_ar/spec-draft/UC-candidates.md`
- `_ar/evidence/db-inventory.md` (if exists)
- If any required input missing, report which are unavailable.

**Outputs:**
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`

**Hard Rules:**
1. Write ONLY to `_ar/spec-draft/**`.
2. Do NOT modify EN, SRV, or UC files.
3. Do NOT read repository source code.
4. Do NOT invent functionality.
5. Architecture statements must be traceable to repo-map or SRV artifacts.

**ARCH0001 Required Sections:** (1) System Purpose, (2) System Boundaries, (3) High-Level Architecture, (4) Bounded Context Map (from `SRV-architecture-map.md`), (5) Integration Landscape (include direction and failure impact), (6) Data Architecture, (7) Operational Model, (8) Architectural Risks (top 5 structural risks from artifacts).

**ARCH0002:** Textual interaction map (e.g., `Context A -> Context B -> External System`). Must document synchronous calls, async queue boundaries, event-like transitions.

**Writing Rules:** No marketing language, no code-level detail, no repetition of full SRV definitions. Explain system to a new architect quickly and clearly.

**Procedure:** (1) Read repo-map and SRV inputs. (2) Synthesize system overview. (3) Synthesize context interaction map. (4) Refresh both ARCH output files.

**Idempotency:** Re-runnable. Refresh in place; no duplicates or renamed copies.

**Completion Criteria:** Both ARCH files exist; required sections present; statements traceable to repo-map/SRV artifacts; no code reading used; EN/SRV/UC files unchanged.

**Invocation:** `Run AR:ARCHWriter`

---

## orchestration/02-system-reconstruction/tasks/ENExtractor-task.md
**Type:** task

**Pre-check:** Spec Discovery must be performed. Report (1) how many EN spec files found, (2) their paths. Confirm reading of: `_ar/evidence/db-inventory.md`, `db-models.md`, `db-constraints-and-validation.md`, `_ar/repo-map/modules.md`, `integrations.md`.

**Enforcement Rules:** If ANY EN spec file exists, Spec Alignment mandatory. Do NOT claim "no spec found" without reporting search results. Confidence cannot be High without usage evidence. Enum does NOT imply lifecycle transitions. Keep domain separate from infrastructure.

**Deliverables:** `_ar/spec-draft/EN-candidates.md`; EN drafts under `_ar/spec-draft/`.

---

## orchestration/02-system-reconstruction/tasks/UCComposer-task.md
**Type:** task

**Pre-check:** Confirm reading of architecture inputs (`SRV-architecture-map.md`, `SRV-target-list.md`, `SRV-candidates.md`), entity inputs (all `EN*.md` in `_ar/spec-draft/`), flow evidence inputs (`flow-index.md`, `FLOW-candidates.md`, `SRV-flow-traceability.md` if exists, `EN-lifecycle-evidence.md` if exists), coverage inputs (`_ar/coverage/unmapped.md` if exists).

**Deliverables:** `UC-candidates.md`, `UC-srv-traceability.md`, one UC file per root-level UC.

**Format Constraints:** Every Main Flow and Alternative Flow step prefixed with actor and colon (`Customer:`, `Admin:`, `System:`, `External(<System>):`).

**Flow-aware Constraint:** When FlowMiner evidence exists: prefer those flows as UC anchors, reference FlowIDs in Traceability, do not invent flows contradicting mined evidence.

---

## orchestration/02-system-reconstruction/tasks/DomainKernelSynthesizer-task.md
**Type:** task

Note: This task file is identical to the agent spec (`DomainKernelSynthesizer.md`). No additional pre-check, deliverables, or rules beyond the agent spec.

---

## orchestration/02-system-reconstruction/tasks/AggregateBoundaryModeler-task.md
**Type:** task

**Pre-check:** Confirm reading of all `EN*.md` and `UC*.md` under `_ar/spec-draft/`, `SRV-target-list.md`, `SRV-flow-traceability.md` (if exists).

**Deliverables:** `_ar/spec-draft/DOMAIN-aggregates.md`, `CONSISTENCY-boundaries.md`.

**Rules:** Do NOT modify EN, UC, or SRV files. Do NOT invent domain behavior. All aggregate decisions must reference EN relationships or UC flows.

---

## orchestration/02-system-reconstruction/tasks/ARCHWriter-task.md
**Type:** task

**Pre-check:** Confirm reading of `_ar/repo-map/entrypoints.md`, `modules.md`, `integrations.md`, `SRV-architecture-map.md`, `SRV-target-list.md`, `UC-candidates.md`, `db-inventory.md` (if exists). If any required inputs missing, report them.

**Deliverables:** `ARCH0001_ApplicationOverview.md`, `ARCH0002_ContextInteractionMap.md`.

**Rules:** Do NOT modify EN, SRV, or UC files. Do NOT read repository source code. Do NOT invent undocumented behavior. Architecture statements must be traceable to repo-map or SRV artifacts.


---

# Section 4 — Spec-Driven Documentation

## orchestration/03-spec-driven-documentation/agents/UCAtomizer.md
**Type:** agent

**Mission:** Transform orchestration-heavy UC documents into smaller, domain-oriented, elementary UC documents. Not a discovery step -- restructures already reconstructed behavior into granular UC model for rewrite-ready specification.

**Normative sources:** `tooling/docs/rules-UC.md`, `tooling/templates/template-UC.md`. Rules win over template. Task overrides win only for that run.

**Inputs (required):** `_ar/spec-draft/UC/`, `EN/`, `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`, `ARCH0001_ApplicationOverview.md`, `ARCH0002_ContextInteractionMap.md`
**Inputs (recommended):** `SRV-target-list.md`, `SRV-flow-traceability.md`, `EN-lifecycle-evidence.md`, `_ar/evidence/flow/`, `_ar/repo-map/glossary.md`

**Outputs:** New UC files in `_ar/spec-draft/UC/`. Mandatory: `UC-atomization-map.md`, `UC-atomization-report.md`. Optional: `_ar/evidence/uc-atomization-notes.md`

**Scope:** Write only to `_ar/spec-draft/**`, `_ar/evidence/**`. No production code/config/migrations/runtime. Do not overwrite original source UC files unless task explicitly allows replacement.

**Hard rules:**
1. Do NOT invent new business behavior.
2. Do NOT derive new UC solely from implementation detail.
3. Do NOT include file paths, class names, method names, routes, or code identifiers in new UC documents.
4. Every new UC must remain grounded in existing EN, UC, and flow evidence.
5. Preserve canonical terminology from spec and glossary.
6. If evidence insufficient to split safely, keep source UC grouped and record ambiguity.

**Numbering rule:** Source-preserving decomposition: `UC0001` -> `UC0101`, `UC0102`...; `UC0007` -> `UC0701`, `UC0702`...; `UC0048` -> `UC4801`, `UC4802`... Each new UC must include decomposition origin information.

**Procedure:**
1. Load source UC set, identify UCs for atomization.
2. Load active rules and template.
3. Identify decomposition seams: trigger shifts, actor-intent shifts, entity lifecycle changes, business outcome boundaries.
4. Propose target atomized UC set with numbering, titles, affected entities, trigger/outcome boundaries.
5. Write atomized UC files per active rules/template/glossary.
6. Write mapping and report (decomposition map, atomization report, unresolved ambiguities, FN/MSG candidate notes).

**UC-atomization-map.md columns:** Original UC | New UC | Reason for split | Affected Entities | Notes

**UC-atomization-report.md sections:** input UC set, active rules/template used, UCs atomized, UCs left unchanged, numbering applied, ambiguities/blocked splits, FN candidate observations, MSG candidate observations, recommended next step.

**Idempotency:** Re-runnable; refresh in place, no duplicate variants or renamed copies.

**Invocation:** `Run AR:UCAtomizer`

---

## orchestration/03-spec-driven-documentation/tasks/UCAtomizer-task.md
**Type:** task

Standard AR agent boilerplate applies (load agent spec, write only to `_ar/spec-draft/**` and `_ar/evidence/**`, no production code).

**Pre-check:** Confirm reading of all required/recommended inputs per agent spec, plus `tooling/docs/rules-UC.md` and `tooling/templates/template-UC.md` if present.

**Extra rules:** Keep new UC layer smaller in granularity, more domain-oriented. Preserve origin continuity through numbering and decomposition origin. If split not safely supported, leave UC grouped and record reason.

---

## orchestration/03-spec-driven-documentation/agents/ENCanonicalizer.md
**Type:** agent

**Mission:** Canonicalize EN layer -- rewrite existing EN documents from evidence-first, implementation-heavy descriptions into canonical domain entity specifications. EN must describe: entity purpose, attributes, relationships, invariants, lifecycle, state transitions. EN must NOT describe: source file locations, classes, listeners, controllers, services, routes, framework mechanics, implementation traces. Not a discovery step -- refines already reconstructed EN artifacts.

**Inputs (required):** `_ar/spec-draft/EN/`
**Inputs (recommended):** `UC/`, `FN/`, `BR/`, `ARCH/`, `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`, `DOMAIN-ubiquitous-language.md`, `EN-lifecycle-evidence.md`, `_ar/evidence/flow/`, `_ar/repo-map/glossary.md`

**Outputs:** Refreshed EN files in `_ar/spec-draft/EN/`. Mandatory: `EN-canonicalization-map.md`, `EN-canonicalization-report.md`. Optional: `_ar/evidence/en-canonicalization-notes.md`

**Scope:** Standard AR scope. Do not overwrite non-EN artifacts.

**Hard rules:**
1. Do NOT invent new entity semantics not supported by canonical artifacts.
2. Do NOT include file paths, class names, method names, listener/controller/service names, route strings, framework config, ORM mapping mechanics, or vendor library names in EN.
3. Do NOT describe entity behavior as workflow steps.
4. Do NOT describe reusable system capabilities as entity responsibilities.
5. Do NOT turn unresolved evidence gaps into canonical entity facts.
6. Every EN must remain grounded in existing EN, UC, FN, BR, ARCH, and DOMAIN artifacts.
7. Preserve canonical terminology.
8. If evidence insufficient, keep fact out of canonical EN text and record ambiguity in report.

**Procedure:**
1. Load active rules and template.
2. Load current EN set for canonicalization.
3. For each EN: separate canonical business facts from implementation traces; identify ambiguities for report.
4. Refresh or create canonical EN files per rules/template.
5. Refresh or create map and report (including unresolved ambiguities/gaps).

**EN-canonicalization-map.md columns:** EN File | Source Artifacts | Removed Technical Traces | Preserved Lifecycle Facts | Notes

**EN-canonicalization-report.md sections:** active rules/template, EN files refreshed, implementation trace categories removed, lifecycle sections rewritten, ambiguities left out, missing artifacts preventing stronger canonicalization, recommended next step.

Standard AR agent boilerplate applies (idempotency, invocation `Run AR:ENCanonicalizer`).

---

## orchestration/03-spec-driven-documentation/tasks/ENCanonicalizer-task.md
**Type:** task

Standard AR task wrapper. **Extra rules:** Refresh existing EN files in place. Remove implementation leakage from main EN text. Preserve business meaning, relations, invariants, lifecycle, state transitions. Move unresolved implementation evidence to the report.

---

## orchestration/03-spec-driven-documentation/agents/ARCHDomainAssembler.md
**Type:** agent

**Mission:** Assemble domain-oriented ARCH layer where each major domain gets one ARCH document. ARCH becomes primary domain navigation layer; deeper artifacts linked through EN, UC, FN, ES, MSG references. Not a discovery step -- reorganizes/consolidates already reconstructed architectural and domain knowledge.

**Inputs (required):** `ARCH0001_ApplicationOverview.md`, `ARCH0002_ContextInteractionMap.md`, `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`
**Inputs (recommended):** `BR/`, `EN/`, `UC/`, `FN/`, `ES/`, `MSG/`, `DOMAIN-ubiquitous-language.md`, `_ar/repo-map/glossary.md`

**Outputs:** Domain ARCH files in `_ar/spec-draft/ARCH/`. Mandatory: `ARCH-domain-map.md`, `ARCH-domain-assembly-report.md`. Optional: `_ar/evidence/arch-domain-assembly-notes.md`

**Scope:** Standard AR scope. Do NOT overwrite `ARCH0001_ApplicationOverview.md` or `ARCH0002_ContextInteractionMap.md`. Do not delete source overview artifacts unless task explicitly allows cleanup.

**Hard rules:**
1. Do NOT invent new domains, responsibilities, or architectural boundaries.
2. Do NOT rediscover behavior from code.
3. Do NOT use BR as the primary domain overview layer.
4. Do NOT include UC flows, entity model detail, implementation detail, file paths, class names, method names, routes, or framework mechanics.
5. Every domain ARCH must remain grounded in existing BR, EN, UC, FN, DOMAIN, and existing ARCH artifacts.
6. Preserve canonical terminology.
7. If evidence insufficient to isolate a domain cleanly, keep it broader and record uncertainty.

**Target model:** System-wide architecture overview documents + one domain ARCH per major domain + stable cross-links to EN/UC/FN/ES/MSG + practical reading path. Good domain ARCH: explains purpose, boundaries, key structural components, references deeper artifacts, aids navigation. Bad domain ARCH: becomes BR catalog, UC/FN summary, raw inventory, or leaks implementation.

**Procedure:**
1. Load active rules and template.
2. Load source overview layer, identify domain candidates.
3. Define domain assembly set (decide per-candidate if own ARCH doc warranted, assign stable name/ID, identify linked artifacts).
4. Refresh or create domain ARCH files.
5. Refresh or create map and report.

**ARCH-domain-map.md columns:** Domain ARCH | Source Artifacts | Related EN | Related UC | Related FN | Related ES/MSG | Notes

**ARCH-domain-assembly-report.md sections:** active rules/template, domains assembled, source overview artifacts consumed, domains left broader and why, missing downstream artifacts weakening navigation, recommended next step.

Standard AR agent boilerplate applies (idempotency, invocation `Run AR:ARCHDomainAssembler`).

---

## orchestration/03-spec-driven-documentation/tasks/ARCHDomainAssembler-task.md
**Type:** task

Standard AR task wrapper. **Extra rules:** Do not include workflow or implementation detail. Keep ARCH domain-oriented and navigational. Preserve deeper reading paths to EN, UC, FN, ES, and MSG.

---

## orchestration/03-spec-driven-documentation/agents/FNSynthesizer.md
**Type:** agent

**Mission:** Synthesize canonical FN (functional capability) layer replacing the publish role of SRV and FLOW documents. Describes what the system is internally capable of doing in a stable, implementation-agnostic way. Not a discovery step -- synthesizes from already reconstructed UC, EN, SRV, FLOW, and ARCH knowledge.

**Inputs (required):** `EN/`, `UC/`, `ARCH0001_ApplicationOverview.md`, `ARCH0002_ContextInteractionMap.md`
**Inputs (recommended):** `ARCH/`, `SRV-target-list.md`, `SRV-flow-traceability.md`, `EN-lifecycle-evidence.md`, `_ar/evidence/flow/`, `_ar/repo-map/glossary.md`
**Inputs (optional):** `BR/`, `ES/`, `MSG/`

**Outputs:** FN files in `_ar/spec-draft/FN/`. Mandatory: `FN-capability-map.md`, `FN-synthesis-report.md`. Optional: `_ar/evidence/fn-synthesis-notes.md`

**Scope:** Standard AR scope. Do not overwrite or delete SRV/FLOW artifacts unless task explicitly requests cleanup.

**Hard rules:**
1. Do NOT invent new capabilities not supported by reconstructed artifacts.
2. Do NOT copy implementation detail from SRV or FLOW into FN.
3. Do NOT include file paths, class names, method names, routes, controller/repository/queue names, or framework mechanics in FN.
4. Every FN must remain grounded in existing UC, EN, SRV, FLOW, and ARCH artifacts.
5. Preserve canonical terminology.
6. If evidence insufficient, keep capability broader and record uncertainty.
7. Do not mirror SRV one-to-one.
8. Do not mirror FLOW one-to-one.

**Procedure:**
1. Load active rules and template.
2. Load UC, EN, ARCH, SRV, FLOW material; identify repeated capability clusters.
3. Define capability set (per-candidate: own FN doc?, stable name/ID, linked artifacts).
4. Refresh or create FN files.
5. Refresh or create map and report.

**FN-capability-map.md columns:** FN | Source UC | Source EN | Source SRV/FLOW | Related ARCH | Related ES/MSG | Notes

**FN-synthesis-report.md sections:** active rules/template, capability set synthesized, source artifacts used, capabilities kept broader and why, missing downstream artifacts, recommended next step.

Standard AR agent boilerplate applies (idempotency, invocation `Run AR:FNSynthesizer`).

---

## orchestration/03-spec-driven-documentation/tasks/FNSynthesizer-task.md
**Type:** task

Standard AR task wrapper. **Extra rules:** Keep FN layer capability-oriented and implementation-agnostic. Do not mirror SRV or FLOW one-to-one. If evidence too orchestration-heavy, keep capabilities broader and record reason.

---

## orchestration/03-spec-driven-documentation/agents/ESSynthesizer.md
**Type:** agent

**Mission:** Synthesize External System layer. ES documents what external systems exist, how the system integrates with them, and what architectural boundary they represent. ES does NOT describe business behavior or workflows. Not a discovery step.

**Inputs (primary):** `FN/`, `UC/`, `ARCH/`
**Inputs (secondary):** `BR/`, `EN/`, `_ar/repo-map/glossary.md`
**Inputs (optional):** `_ar/evidence/**`

**Outputs:** ES files in `_ar/spec-draft/ES/`. Mandatory: `ES-system-map.md`, `ES-synthesis-report.md`. Optional: `_ar/evidence/es-synthesis-notes.md`

**Scope:** Standard AR scope. Do not overwrite non-ES artifacts.

**Hard rules:**
1. ES must represent systems outside the platform boundary.
2. ES must not describe business workflows.
3. ES must not include implementation code, API payload definitions, framework config, controller/service names, file paths, or library names.
4. ES documents describe only: system role, integration boundary, conceptual data exchange, constraints.
5. Internal subsystems must not become ES documents.

**Procedure:**
1. Load active rules and template.
2. Scan FN integrations, UC references, ARCH external boundaries, supporting BR/EN.
3. Normalize: merge duplicate external-system names/aliases into one canonical ES target.
4. Refresh or create ES files.
5. Refresh or create map and report.

**ES-system-map.md columns:** ES | System | Used By FN | Used By UC | Related ARCH | Notes

**ES-synthesis-report.md sections:** active rules/template, systems discovered, merged duplicates, uncertain integrations, systems intentionally excluded, recommended next step.

Standard AR agent boilerplate applies (idempotency, invocation `Run AR:ESSynthesizer`).

---

## orchestration/03-spec-driven-documentation/tasks/ESSynthesizer-task.md
**Type:** task

Standard AR task wrapper. **Extra rules:** One document per external system. Preserve numbering if exists. Keep ES implementation-agnostic. Do not model internal subsystems as ES.

---

## orchestration/03-spec-driven-documentation/agents/MSGSynthesizer.md
**Type:** agent

**Mission:** Synthesize Transactional Message layer. MSG documents describe: when a message is sent, who receives it, what information it contains. Not a discovery step -- synthesizes from UC, FN, ES, EN, and ARCH artifacts.

**Inputs (required):** `UC/`, `FN/`
**Inputs (recommended):** `EN/`, `ES/`, `ARCH/`, `_ar/repo-map/glossary.md`
**Inputs (optional):** `BR/`, `_ar/evidence/**`

**Outputs:** MSG files in `_ar/spec-draft/MSG/`. Mandatory: `MSG-message-map.md`, `MSG-synthesis-report.md`. Optional: `_ar/evidence/msg-synthesis-notes.md`

**Scope:** Standard AR scope. Do not overwrite non-MSG artifacts.

**Hard rules:**
1. Do NOT invent new messages not supported by reconstructed artifacts.
2. Do NOT include templates, styling, mail provider config, SMTP settings, framework config, file paths, class names, method names, routes, library names, or implementation mechanics in MSG.
3. MSG describes the message contract, not delivery implementation.
4. Every MSG must remain grounded in existing UC, FN, ES, EN, and ARCH artifacts.
5. Preserve canonical terminology.
6. If evidence insufficient, keep MSG broader and record uncertainty.
7. Do not turn MSG into ES, UC flow, or FN capability text.

**Procedure:**
1. Load active rules and template.
2. Load UC, FN, EN, ES, ARCH; identify message candidates.
3. Define message set (per-candidate: own MSG doc?, stable name/ID, linked artifacts).
4. Refresh or create MSG files.
5. Refresh or create map and report.

**MSG-message-map.md columns:** MSG | Source UC | Source FN | Related EN | Related ES | Notes

**MSG-synthesis-report.md sections:** active rules/template, message set synthesized, source artifacts, messages kept broader and why, missing downstream artifacts, implementation/infrastructure details excluded, recommended next step.

Standard AR agent boilerplate applies (idempotency, invocation `Run AR:MSGSynthesizer`).

---

## orchestration/03-spec-driven-documentation/tasks/MSGSynthesizer-task.md
**Type:** task

Standard AR task wrapper. **Extra rules:** Keep MSG message-oriented and implementation-agnostic. Keep trigger, recipients, and business message purpose explicit. Keep infrastructure detail out of canonical MSG text. If evidence weak, keep MSG broader and record reason.

---

## orchestration/03-spec-driven-documentation/agents/BRExtractor.md
**Type:** agent

**Mission:** Extract, normalize, and maintain Business Rule layer. Extracts rule statements from already reconstructed canonical artifacts and refreshes BR layer as a stable, non-duplicative rule catalog. BR must remain: normative, deterministic, implementation-agnostic, free of workflow description. Not a discovery step.

**Inputs (required):** `FN/`, `EN/`, `UC/`, `ARCH/` if present, `ARCH0001_ApplicationOverview.md`, `ARCH0002_ContextInteractionMap.md`
**Inputs (recommended):** `BR/`, `ES/`, `MSG/`, `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`, `DOMAIN-ubiquitous-language.md`, `_ar/repo-map/glossary.md`

**Outputs:** BR files in `_ar/spec-draft/BR/`. Mandatory: `BR-rule-map.md`, `BR-extraction-report.md`. Optional: `_ar/evidence/br-extraction-notes.md`

**Scope:** Standard AR scope. Do not overwrite non-BR artifacts.

**Hard rules:**
1. Do NOT invent rules not supported by canonical artifacts.
2. Do NOT include step-by-step flows in BR.
3. Do NOT include implementation details, code identifiers, file paths, routes, framework mechanics, library names, or evidence commentary in BR.
4. BR must contain deterministic rule statements, not process descriptions.
5. Every rule must remain grounded in existing FN, EN, UC, ARCH, ES, or MSG artifacts.
6. Preserve canonical terminology.
7. If evidence insufficient, leave statement out of BR and record in report.
8. Preserve existing grouped BR structure when present.

**Existing-structure rule:** If project already has an established BR layout (shared/system BR docs, domain-scoped BR docs, grouped collections), that structure is the canonical target layout. Refresh in place, preserve numbering/filenames/stable rule IDs, do not create parallel structure unless task explicitly requests restructuring. If no stable layout exists, create deterministic structure and record in `BR-rule-map.md`.

**Procedure:**
1. Load active rules and template.
2. Detect BR target structure from existing `_ar/spec-draft/BR/`.
3. Extract rule candidates from FN, EN, UC, ARCH, ES, MSG artifacts.
4. Normalize and deduplicate: normalize wording, merge duplicates, identify canonical ownership, preserve existing IDs, discard evidence-only statements.
5. Refresh or create BR files.
6. Refresh or create map and report.

**BR-rule-map.md columns:** BR File | Rule ID / Section | Source Artifacts | Ownership | Notes

**BR-extraction-report.md sections:** active rules/template, BR structure detected/preserved, source artifacts, rules extracted, rules merged as duplicates, rules left out (insufficient evidence), ambiguities/missing artifacts, recommended next step.

Standard AR agent boilerplate applies (idempotency, invocation `Run AR:BRExtractor`).

---

## orchestration/03-spec-driven-documentation/tasks/BRExtractor-task.md
**Type:** task

Standard AR task wrapper. **Extra rules:** Refresh existing canonical BR files in place. Preserve existing grouped BR structure. Keep BR rule-oriented, deterministic, implementation-agnostic. Keep unresolved evidence gaps out of canonical BR text; move to report.

---

## orchestration/03-spec-driven-documentation/agents/CrossLayerAuditor.md
**Type:** agent

Standard AR agent conventions apply (idempotent; writes only to `_ar/spec-draft/** + _ar/evidence/**`; invocation `Run AR:CrossLayerAuditor`). Runs late in stage 03, after layer synthesis/canonicalization, before SpecClosureEvaluator.

**Mission:** Enforce `cross-layer-discipline.md` — detect content one layer restates but another owns, and rewrite the restatement into a doc_id reference. De-duplicates across layers (the step SpecFinalGenerator refuses). Does not change meaning or discover new content.
**Normative sources:** `tooling/docs/cross-layer-discipline.md` (ownership — authoritative), glossary.
**Inputs:** all `_ar/spec-draft/<LAYER>/`, `cross-layer-discipline.md`; recommended glossary + per-layer rules.
**Outputs:** refreshed layer docs (restatement → reference); `_ar/spec-draft/CROSS-LAYER-audit.md`; `CrossLayerAuditor-report.md`.
**Hard rules:** never change meaning; never delete a layer's OWNED content; replace only borrowed restatement with the owner's doc_id (+ ≤50-char orientation); if owner missing/context-poor → flag + Open Question, don't move content; unresolved reference → Open Question, not deletion; preserve identifiers; >50-char threshold + documented exceptions.

---

## orchestration/03-spec-driven-documentation/tasks/CrossLayerAuditor-task.md
**Type:** task

Standard AR task wrapper. Pre-check: cross-layer-discipline.md, glossary, all `_ar/spec-draft/<LAYER>/`, per-layer rules. Deliverables: refreshed layer docs, `CROSS-LAYER-audit.md`, `CrossLayerAuditor-report.md`. Rules: de-duplicate only, never change meaning or delete owned content; replace borrowed restatement with doc_id reference; flag missing owners as Open Questions; run after authoring, before closure.

---

## orchestration/03-spec-driven-documentation/agents/RefIntegrityValidator.md
**Type:** agent

Standard AR agent conventions apply (idempotent; writes only to `_ar/spec-draft/** + _ar/evidence/**`; invocation `Run AR:RefIntegrityValidator`). Runs after CrossLayerAuditor, before SpecClosureEvaluator/SpecFinalGenerator.

**Mission:** Build draft-phase `_REGISTRY.md` per layer (authoritative doc_id list) and validate referential integrity (doc_id uniqueness + every reference resolves). Does not discover content, change meaning, or repair references — reports problems as Open Questions. Draft analog of the publication registries (straight carry-over).
**Normative sources:** `tooling/docs/registry-format.md` (schema — authoritative), `tooling/docs/cross-layer-discipline.md`, glossary; fallback to rules-spec-final registry section.
**Inputs:** all `_ar/spec-draft/<LAYER>/`, registry-format.md; recommended per-layer `*-map.md`, `CROSS-LAYER-audit.md`, glossary.
**Outputs:** `_ar/spec-draft/<LAYER>/_REGISTRY.md` (status draft, Owner mode AR); `_ar/spec-draft/REFERENCE-INTEGRITY.md`; `RefIntegrityValidator-report.md`.
**Hard rules:** never invent doc_ids/rows/ref targets; never renumber/rename (collisions → Open Question); never edit doc content; one row per doc_id; validate references/affects/realizes_uc/trigger/screen_id; classify resolved/dangling/deferred.
**REFERENCE-INTEGRITY.md columns:** Citing doc | Field | Referenced ID | Status | Note (+ summary counts).

---

## orchestration/03-spec-driven-documentation/tasks/RefIntegrityValidator-task.md
**Type:** task

Standard AR task wrapper. Pre-check: registry-format.md, cross-layer-discipline.md, all `_ar/spec-draft/<LAYER>/`, `*-map.md`, CROSS-LAYER-audit.md, glossary. Deliverables: per-layer `_REGISTRY.md` (draft), `REFERENCE-INTEGRITY.md`, `RefIntegrityValidator-report.md`. Rules: build + validate only; never renumber/invent/edit content; collisions + dangling refs → Open Questions; run after CrossLayerAuditor, before closure.

---

## orchestration/03-spec-driven-documentation/agents/RewriteDecisionCompiler.md
**Type:** agent

**Mission:** Compile architectural findings into a rewrite decision pack -- synthesizes architectural risks, technical debt, rewrite blockers, and architecture decision candidates. Supports rewrite strategy and sequencing. Evaluation and synthesis pass only; does not discover new behavior.

**Inputs (mandatory):** `SRV-restructuring-actions.md`, `SRV-architecture-map.md`, all `EN*.md` under `_ar/spec-draft/`, all `UC*.md` under `_ar/spec-draft/`, `UC-srv-traceability.md`, `_ar/coverage/unmapped.md` if exists.

**Outputs:** `_ar/spec-draft/REWRITE-decision-pack.md`, `_ar/spec-draft/REWRITE-sequencing.md`

**Scope:** Write ONLY to `_ar/spec-draft/**`. Do NOT modify existing SRV, EN, or UC files, production code, or configuration.

**Hard rules:**
1. Write ONLY to `_ar/spec-draft/**`.
2. Do NOT modify existing SRV, EN, or UC files.
3. Do NOT invent system behavior.
4. All risks, debts, and rewrite blockers must reference evidence.
5. Do NOT redesign architecture in detail.
6. Do NOT propose implementation-level patch plans.

**Evaluation model:**
1. **Risk extraction:** architectural smells, vendor lock-in, cross-context coupling, state consistency risks, integration fragility.
2. **Debt classification:** Rewrite Blocker | Architectural Risk | Legacy Debt | Operational Risk.
3. **ADR candidates:** problem statement, affected components, trade-off summary.
4. **Rewrite sequencing:** domain areas first, integration boundaries later, infrastructure last. Highlight highest-risk flows and highest business-impact areas.

**REWRITE-decision-pack.md:** risk catalog, debt classification, ADR candidate list, rewrite blockers, supporting evidence references.

**REWRITE-sequencing.md:** recommended rewrite order, migration phases, stabilization strategy, sequencing rationale.

Standard AR agent boilerplate applies (idempotency, invocation `Run AR:RewriteDecisionCompiler`).

---

## orchestration/03-spec-driven-documentation/tasks/RewriteDecisionCompiler-task.md
**Type:** task

Standard AR task wrapper (write only to `_ar/spec-draft/**`, do not modify existing SRV/EN/UC).

**Pre-check:** Confirm reading of `SRV-architecture-map.md`, `SRV-restructuring-actions.md`, `UC-srv-traceability.md`, all EN/UC files under spec-draft, `_ar/coverage/unmapped.md` if exists.

**Deliverables:** `REWRITE-decision-pack.md`, `REWRITE-sequencing.md`

**Extra rules:** All risks must reference evidence. Do not invent behavior. Do not redesign architecture in detail. Do not propose implementation-level patch plans.

---

## orchestration/03-spec-driven-documentation/agents/SpecClosureEvaluator.md
**Type:** agent

**Mission:** Evaluate whether project documentation is sufficiently complete to declare the system: (a) sufficiently described as-is, (b) sufficiently described for architecture planning, (c) sufficiently described for greenfield rewrite preparation. If present, also evaluate whether specification has progressed to a generation-grade contract layer through API, JOB, ACL, QUERY contracts. Produces explicit closure verdict from existing artifacts. Final consolidation and evaluation pass; no new domain discovery. The verdict is **measurable**: each dimension is checked against `tooling/docs/definition-of-done.md` and reported as a per-criterion PASS/PARTIAL/BLOCKED checklist + closure state + confidence label.

**Normative sources:** `tooling/docs/definition-of-done.md` (closure criteria — authoritative), `tooling/docs/registry-format.md`, `tooling/docs/cross-layer-discipline.md`, `_ar/repo-map/glossary.md`.

**Inputs (required):** `EN/`, `UC/`, `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`, `ARCH0001_ApplicationOverview.md`, `ARCH0002_ContextInteractionMap.md`, `REWRITE-decision-pack.md` (if present), `REWRITE-sequencing.md` (if present), `ENTITY-inventory.md`, `ENTITY-classification.md`, `ENTITY-coverage-matrix.md`, `EntityInventoryCloser-report.md` (if present)
**Inputs (recommended):** `REFERENCE-INTEGRITY.md`, `RefIntegrityValidator-report.md`, `CROSS-LAYER-audit.md`, `CrossLayerAuditor-report.md`, `_ar/spec-draft/<LAYER>/_REGISTRY.md` (integrity + coverage signals), `GapClosureSpecWriter-report.md`, `MissingCoreEntityWriter-report.md`, `UI-gap-open-questions.md`, `_ar/coverage/ui-gap-analysis.md`, `_ar/evidence/flow/`
**Inputs (optional 04 contract layers if present):** `API/`, `JOB/`, `ACL/`, `QUERY/`, `API-contract-map.md`, `API-synthesis-report.md`, `JOB-map.md`, `JOB-synthesis-report.md`, `ACL-*.md`, `QUERY-*.md`. Absence of 04 artifacts is not a failure; evaluate from core layers only and state explicitly that generation-grade contract coverage was not yet assessed or is only partially available.

**Outputs:** `_ar/spec-draft/SPEC-CLOSURE.md`. Optional: `SPEC-CLOSURE-backlog.md`

**Scope:** Write to `_ar/spec-draft/**`, `_ar/coverage/**`, `_ar/evidence/**`. Do NOT modify production code, existing EN/UC/DOMAIN/ARCH files, numbering, or prior reports.

**Hard rules:**
1. Do NOT invent closure.
2. Do NOT downgrade known blockers.
3. Distinguish clearly: sufficient for current-state understanding vs. architecture design vs. greenfield rewrite.
4. If API/JOB/ACL/QUERY are present, distinguish core rewrite readiness from generation-grade contract readiness.
5. Treat blocked EN pages, open questions, rewrite blockers, and missing contract layers separately.
6. Use evidence already present in reports and canonical artifacts.
7. If closure differs by context, state explicitly.
8. Do NOT hide uncertainty behind optimistic summary language.
9. Do NOT treat absent optional 04 artifacts as "failed" if the run occurred before those layers were expected.
10. Produce a precise verdict, not a motivational one.
11. Evaluate each dimension against `tooling/docs/definition-of-done.md` and report a per-criterion checklist (PASS/PARTIAL/BLOCKED + evidence) — not a narrative-only verdict.
12. Assign each dimension a closure state and confidence label from `definition-of-done.md`.
13. Report referential-integrity factors (dangling refs, collisions, orphans from REFERENCE-INTEGRITY.md; unresolved restatements from CROSS-LAYER-audit.md); they lower confidence and go to backlog but do NOT auto-force BLOCKED. Deferred cross-tier refs are recorded, not penalized.

**Evaluation model:**
1. **Read closure signals:** EN/UC coverage, kernel/aggregate completeness, ARCH completeness, rewrite blockers, inventory report, gap-closure reports, API/JOB/ACL/QUERY layers; plus REFERENCE-INTEGRITY.md, CROSS-LAYER-audit.md, draft registries.
2. **Evaluate each dimension against `definition-of-done.md`** → per-criterion PASS/PARTIAL/BLOCKED checklist (entity/UC/bounded-context/architecture coverage, blocked artifacts, open questions, rewrite blockers; +04 contract coverage/consistency if present). Also assess cross-cutting factors: referential integrity, cross-layer dedup, registry currency.
3. **Assign closure state + confidence + verdict** per dimension (states not-started→in-evidence→in-reconstruction→reconstructed-but-not-closed→closed-with-limitations→closed, or blocked; confidence Confirmed/Partial/Uncertain/Blocked) for current-state understanding, architecture & planning, greenfield rewrite readiness (+generation-grade contract readiness if 04 present, else "not yet assessed"/"not in scope"). Weigh referential factors (lower confidence, not auto-BLOCKED).
4. **Backlog** if not fully closed: core reconstruction / rewrite-decision / optional 04 contract / referential-integrity factors.

**SPEC-CLOSURE.md required structure:** Purpose; Input baseline (incl. integrity/audit reports + registries read); Closure by dimension (per-criterion checklist table `Criterion | Status | Evidence` + closure state + confidence); Referential-integrity & cross-layer factors summary; Open blockers; Verdict (state+confidence per dimension); Minimum remaining work (backlog: core/rewrite/04/referential-integrity); Recommended next step. If 04 evaluated, include contract-layer closure status and whether spec is rewrite-ready or also generation-grade ready.

**Quality bar:** Must clearly answer: Can the system be described as-is with confidence? What is still missing? Is remaining gap small/medium/foundational? What is next smallest useful action? If 04 present: is the system only core-spec complete or also contract-spec complete?

**Idempotency:** Refresh outputs in place; no duplicate/renamed copies. When additional 04 artifacts appear in later runs, re-evaluate closure using newly available layers, update verdicts/backlog in place, do not preserve stale "not assessed" wording if the layers now exist.

Standard AR agent invocation: `Run AR:SpecClosureEvaluator`.

---

## orchestration/03-spec-driven-documentation/tasks/SpecClosureEvaluator-task.md
**Type:** task

Standard AR task wrapper (write to `_ar/spec-draft/**`, `_ar/coverage/**`, `_ar/evidence/**`; do not modify production code or existing core artifacts).

**Pre-check:** Confirm reading of all required inputs per agent spec plus optional recommended inputs. Optional 04 inputs if present: `API/`, `JOB/`, `ACL/`, `QUERY/`, `API-contract-map.md`, `API-synthesis-report.md`, `JOB-map.md`, `JOB-synthesis-report.md`, `ACL-*.md`, `QUERY-*.md`.

**Deliverables:** `SPEC-CLOSURE.md`. Optional: `SPEC-CLOSURE-backlog.md`.

**Extra rules:** Do not invent closure. Do not downgrade known blockers. Distinguish current-state understanding, architecture planning, and greenfield rewrite readiness. If API/JOB/ACL/QUERY are present, include them in the evaluation. If absent, do not fail the run; explicitly state layers were not yet available or not assessed. Keep blockers and remaining work explicit. Refresh outputs in place on repeated runs.

---

## orchestration/03-spec-driven-documentation/agents/SpecFinalGenerator.md
**Type:** agent

**Mission:** Create final publication layer in `_ar/spec-final/` by copying canonical spec artifacts from `_ar/spec-draft/`, conforming them to the BA/UX hand-off layout, and translating full textual content into Czech. Publication, conformance, and translation step only. Does NOT reinterpret, invent, repair, normalize, synthesize, merge, or deduplicate (cross-layer de-duplication is enforced upstream by CrossLayerAuditor). Selects canonical source artifacts, copies to the tiered layout `_ar/spec-final/{BA,UX}/<LAYER>/`, preserves identifiers (doc_id)/structure/references, conforms filenames and frontmatter per `rules-spec-final.md` and writes a `_REGISTRY.md` per layer, translates full human-readable content into Czech. Result is a drop-in tree for an arg-emitee rebuild.

**Normative sources:** `_ar/repo-map/glossary.md` (wins for terminology), `tooling/docs/rules-spec-final.md`, `tooling/templates/template-spec-final.md`. Rules win over template for behavior/structure. Task overrides win only for that run.

**Inputs (required):** `_ar/spec-draft/`, `_ar/repo-map/glossary.md`
**Supported canonical input folders:** `ARCH/`, `BR/`, `EN/`, `ES/`, `FN/`, `MSG/`, `UC/`, `CS/`
**Optional canonical input folders (04 layers if present):** `API/`, `JOB/`, `ACL/`, `QUERY/`
**Optional UX input folders (ux-reconstruction branch, if present):** `IA/`, `WIRE/`, `COMP/`, `COPY/`
**Optional top-level inputs:** `ARCH0001_ApplicationOverview.md`, `ARCH0002_ContextInteractionMap.md`, `SPEC-CLOSURE.md`, `BR-rule-map.md`, `FN-capability-map.md`, `MSG-message-map.md`, `ES-system-map.md`, `UC-atomization-map.md`, `API-contract-map.md`, `API-synthesis-report.md`, `JOB-map.md`, `JOB-synthesis-report.md`, `ACL-*.md`, `QUERY-*.md`. Absence of 04 is not an error; publish only canonical layers that exist at run time.

**Outputs:** Tiered folders per layer→tier map: BA-tier `_ar/spec-final/BA/<LAYER>/` (ARCH, BR, EN, ES, FN, MSG, UC, CS; plus API, JOB, ACL, QUERY if corresponding draft layers exist) + UX-tier `_ar/spec-final/UX/<LAYER>/` (IA, WIRE, COMP, COPY — published when ux-reconstruction drafts exist, else scaffolded empty). Files named `<doc_id>-<kebab-title>.md`; one `_REGISTRY.md` per layer folder. Mandatory: `final-publication-map.md`, `final-publication-report.md`. Optional: `README.md`

**Scope:** Write ONLY to `_ar/spec-final/**`. Do NOT modify `_ar/spec-draft/**`, `_ar/evidence/**`, production code, config, migrations, runtime assets.

**Hard rules:**
1. Do NOT invent new business meaning during translation.
2. Do NOT summarize instead of translating.
3. Do NOT leave major narrative sections untranslated unless explicitly required.
4. Do NOT remove canonical structure.
5. DO rename files to `<doc_id>-<kebab-title>.md` per `rules-spec-final.md` (envelope only); never alter/renumber/translate the `doc_id` token itself.
6. Do NOT translate IDs (rule, entity, UC, capability, message, ES, aggregate, doc_id tokens).
7. Do NOT translate inline code-like field identifiers or code blocks.
8. Do NOT translate glossary-controlled terms inconsistently with glossary.
9. If glossary term missing and safe literal translation uncertain, preserve English term and record gap in report.
10. Do NOT fail merely because optional layers are not yet present.
11. Do NOT publish non-canonical working files just because they exist in `_ar/spec-draft/`.

**Translation model:** Full Czech translation of human-readable content — headings, prose, bullets, explanatory table text. References, IDs, filenames, technical identifiers remain stable.

**Procedure:**
1. Load publication rules (glossary, rules, template).
2. Detect canonical source set from `_ar/spec-draft/`.
3. Select publication scope and resolve tier (required core BA layers incl. CS if present; optional 04 layers if present and canonical; missing optional skipped and recorded; UX layers published when present, else scaffolded).
4. Conform and publish full Czech copies: route to `_ar/spec-final/<tier>/<LAYER>/`, rename to `<doc_id>-<kebab-title>.md`, conform frontmatter (preserve doc_id; `status: canonical`; `modules: []`; carry over spec_type/references/layer-specific), translate content.
5. Write registries: one `_REGISTRY.md` row per doc (`ID | Title | Status | Module(s) | Owner mode | Created`, status canonical, Module(s) `[]`, Owner mode `Mode P (import)`; semantic header `# <LAYER> Registry — <SemanticName>`); validate references resolve (no dangling); scaffold empty UX registries when absent.
6. Refresh publication map and report.

**final-publication-map.md columns:** Final File | Source Draft | Tier | Layer | Translation Mode | Glossary Notes | Notes

**final-publication-report.md sections:** source layers published, files copied, files refreshed, layers skipped because unavailable, newly added layers/files on this run, glossary-controlled terms used, missing glossary entries, identifiers preserved in English, translation ambiguities, recommended next step.

**Idempotency:** Refresh target files in place (conformant name is deterministic); no duplicate or alternately-named variants of the same doc_id; refresh the layer `_REGISTRY.md` row rather than appending. When new canonical layers appear in `_ar/spec-draft/` after earlier run, add them to `_ar/spec-final/` in the correct tier, refresh map/report in place, do not duplicate previously published files.

Standard AR agent invocation: `Run AR:SpecFinalGenerator`.

---

## orchestration/03-spec-driven-documentation/tasks/SpecFinalGenerator-task.md
**Type:** task

Standard AR task wrapper (write ONLY to `_ar/spec-final/**`; do not modify `_ar/spec-draft/**`).

**Pre-check:** Confirm reading of `_ar/repo-map/glossary.md`, all core canonical layer folders if present (ARCH, BR, EN, ES, FN, MSG, UC, CS), optional 04 layer folders if present (API, JOB, ACL, QUERY), `tooling/docs/rules-spec-final.md` and `tooling/templates/template-spec-final.md` if present. Optional top-level documents may be included if requested.

**Deliverables:** Tiered BA-tier folders in `_ar/spec-final/BA/<LAYER>/` (ARCH, BR, EN, ES, FN, MSG, UC, CS) when corresponding drafts exist; optional 04 BA folders (API, JOB, ACL, QUERY) when drafts exist. Publish UX-tier folders (IA, WIRE, COMP, COPY) when ux-reconstruction drafts exist; otherwise scaffold them with an empty `_REGISTRY.md`. One `_REGISTRY.md` per layer; files named `<doc_id>-<kebab-title>.md`. Plus `final-publication-map.md` and `final-publication-report.md`. Optional: `README.md`.

**Extra rules:** Conform filenames to `<doc_id>-<kebab-title>.md` and frontmatter to the BA/UX schema per `tooling/docs/rules-spec-final.md`; preserve doc_id tokens, structure, references; route each layer to its tier; write per-layer `_REGISTRY.md`; validate references (no dangling). Translate full human-readable content into Czech. Keep IDs, doc_id tokens, inline field names, code blocks, and technical tokens stable. Use glossary as authoritative terminology source. If 04 layers not yet present, skip them without error and record in report. If 04 layers present on later rerun, publish them and refresh map/report in place. Do not publish non-canonical working artifacts.


---

# Section 5 — Spec-Driven Closure, Optional Bonus & Legacy

## orchestration/04-spec-driven-closure/agents/ACLMatrixSynthesizer.md
**Type:** agent

Standard AR agent conventions apply (idempotent/re-runnable, refresh in place; invocation: `Run AR:ACLMatrixSynthesizer`; writes only to `_ar/**`).

**Mission:** Synthesize a canonical access-control layer mapping actors, roles, resources, actions, and scope constraints into a stable ACL matrix for rewrite/generation planning. Does NOT invent roles unsupported by evidence. Does NOT replace business rules or UI behavior.

**When to use:** FN, UC, BR, ARCH already stable; permission behavior must be explicit; rewrite scope requires role/resource/action clarity.

**Inputs:**
- Required: `_ar/spec-draft/FN/`, `UC/`, `BR/`, `ARCH/`, `EN/`
- Strongly recommended: `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`, `_ar/repo-map/glossary.md`
- Optional: `CS/`, `_ar/evidence/flow/`, `_ar/tasks/Runtime-truth-policy.md`

**Outputs:**
- `_ar/spec-draft/ACL/ACLxxxx_<DomainName>.md`
- `_ar/spec-draft/ACL-matrix.md`
- `_ar/spec-draft/ACL-synthesis-report.md`
- Optional: `_ar/evidence/acl-synthesis-notes.md`

**Hard rules:**
1. Do NOT invent roles, scopes, or grants unsupported by evidence.
2. Distinguish clearly: actor role vs business position vs technical session/auth requirement.
3. ACL must be resource/action/scope rules, not prose-only.
4. Keep unresolved access behavior explicit.
5. Do NOT collapse domain ownership gaps into fake permission certainty.
6. Keep glossary-governed terminology.
7. Do NOT let UI-only visibility stand in for confirmed authorization rules.

**Procedure:** (1) Load FN, UC, BR, ARCH, EN, domain vocab. (2) Extract actors, roles, positions, resources, actions, scope modifiers, exceptions. (3) Build stable matrix of who/what/scope. (4) Write domain ACL docs. (5) Refresh matrix and report with open items.

**Do not modify:** `_ar/spec-final/**`, production code, runtime assets, identity provider config.

---

## orchestration/04-spec-driven-closure/tasks/ACLMatrixSynthesizer-task.md
**Type:** task

**Pre-check:** Confirm reading of FN/, UC/, BR/, ARCH/, EN/, DOMAIN-kernel.md, DOMAIN-aggregates.md, glossary.md, `tooling/docs/rules-ACL.md`, `tooling/templates/template-ACL.md` (if present).

**Deliverables:** ACL files in `_ar/spec-draft/ACL/`, `ACL-matrix.md`, `ACL-synthesis-report.md`. Optional: `acl-synthesis-notes.md`.

**Extra rules:**
- Express access as resource/action/scope rules.
- Keep business position and technical auth distinct.
- Keep tenant scoping visible.
- Keep unresolved permissions explicit.
- Do not infer authorization only from UI visibility.

**Success:** ACL matrix is explicit and reviewable; unresolved access visible; no unsupported grants introduced.

---

## orchestration/04-spec-driven-closure/agents/APIContractSynthesizer.md
**Type:** agent

Standard AR agent conventions apply. Invocation: `Run AR:APIContractSynthesizer`.

**Mission:** Synthesize canonical API contracts -- stable request/response contracts, endpoint intent, authorization expectations, side-effect expectations for system-facing APIs. Does NOT write controllers. Does NOT infer undocumented payload fields. Does NOT replace ES, FN, or UC.

**When to use:** EN, UC, FN, BR, ARCH stable; need implementation-facing API contracts; rewrite planning requires endpoint/payload clarity; frontend/mobile/automation/partner integration contracts needed.

**Inputs:**
- Required: `EN/`, `UC/`, `FN/`, `BR/`, `ARCH/`
- Strongly recommended: `ES/`, `MSG/`, `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`, `glossary.md`
- Optional: `_ar/evidence/flow/`, `CS/`, `Runtime-truth-policy.md`

**Outputs:**
- `_ar/spec-draft/API/APIxxxx_<ContractName>.md`
- `_ar/spec-draft/API-contract-map.md`
- `_ar/spec-draft/API-synthesis-report.md`
- Optional: `_ar/evidence/api-synthesis-notes.md`

**Hard rules:**
1. Do NOT invent endpoints unsupported by reconstructed artifacts.
2. Do NOT treat UI behavior alone as sufficient API evidence.
3. Do NOT include controller names, route handlers, framework decorators, or code-level middleware.
4. Every API contract must anchor in at least one UC or FN capability.
5. Separate command-style from query-style contracts.
6. Keep payloads semantic and business-oriented, not DB-field dumps.
7. Uncertain fields go to Open Items, not prescribed.
8. Do NOT duplicate ES content; reference ES for external boundary context.
9. Do NOT define transport-layer implementation beyond contract clarity needs.
10. Use glossary-governed terminology.

**Required contract model:** Each API contract must define: contract purpose, initiating actor/system client, contract type (command | query | callback | utility), authorization expectation, request shape, response shape, side effects, failure outcomes, related EN/UC/FN/BR references, open items.

**Procedure:** (1) Load EN, UC, FN, BR, ARCH, domain vocab. (2) Derive candidates from UC triggers, FN capabilities, ES boundaries, MSG dependencies; UI/runtime only secondary. (3) Group duplicates into stable contracts; separate commands from queries. (4) Write one API doc per stable contract with deterministic business-facing names. (5) Refresh contract map and synthesis report.

**Do not modify:** `_ar/spec-final/**`, production code, migrations, runtime assets, generated schemas outside `_ar/**`.

---

## orchestration/04-spec-driven-closure/tasks/APIContractSynthesizer-task.md
**Type:** task

**Pre-check:** Confirm reading of EN/, UC/, FN/, BR/, ARCH/, ES/, MSG/, glossary.md, `tooling/docs/rules-API.md`, `tooling/templates/template-API.md` (if present).

**Deliverables:** API files in `_ar/spec-draft/API/`, `API-contract-map.md`, `API-synthesis-report.md`. Optional: `api-synthesis-notes.md`.

**Extra rules:**
- One document per stable API contract.
- Prefer business-facing contract names.
- Distinguish command and query contracts.
- Do not prescribe uncertain payload fields.
- Do not define controller/framework implementation.
- Keep aligned with EN, UC, FN, BR, glossary.

**Success:** API layer traceable to canonical artifacts; major contracts documented; uncertain fields explicit; no unsupported endpoints introduced.

---

## orchestration/04-spec-driven-closure/agents/JobContractSynthesizer.md
**Type:** agent

Standard AR agent conventions apply. Invocation: `Run AR:JobContractSynthesizer`.

**Mission:** Synthesize canonical job/batch contracts for scheduled, background, polling, retry, and async system work. Defines stable operational contracts without collapsing into implementation details. Does NOT document infrastructure deployment. Does NOT prescribe worker libraries or scheduler technology.

**When to use:** Flow and ARCH already identified cron/polling/async/retry behavior; rewrite planning needs explicit background execution contracts; idempotency and side effects matter.

**Inputs:**
- Required: `FN/`, `ARCH/`, `_ar/evidence/flow/`, `BR/`
- Strongly recommended: `UC/`, `ES/`, `MSG/`, `DOMAIN-aggregates.md`, `glossary.md`
- Optional: `Runtime-truth-policy.md`

**Outputs:**
- `_ar/spec-draft/JOB/JOBxxxx_<JobName>.md`
- `_ar/spec-draft/JOB-map.md`
- `_ar/spec-draft/JOB-synthesis-report.md`
- Optional: `_ar/evidence/job-synthesis-notes.md`

**Hard rules:**
1. Do NOT invent background jobs unsupported by evidence.
2. Do NOT document exact infrastructure implementation unless required for contract semantics.
3. Every JOB contract must define trigger model, input scope, side effects, and failure handling intent.
4. Preserve idempotency concerns explicitly where known.
5. Distinguish: scheduled jobs, polling jobs, async consumers, compensating/repair jobs.
6. Keep webhook callbacks out unless they function as internal background contracts after receipt.
7. Use glossary-governed terminology.

**Procedure:** (1) Load FN, ARCH, FLOW, BR, related artifacts. (2) Find cron-driven work, polling loops, async consumers, retry/repair loops, periodic generators. (3) Group variants into stable job contracts. (4) One doc per stable background contract. (5) Refresh map and report.

**Do not modify:** `_ar/spec-final/**`, production code, infra config, CI/CD config, queue/cron config files.

---

## orchestration/04-spec-driven-closure/tasks/JobContractSynthesizer-task.md
**Type:** task

**Pre-check:** Confirm reading of FN/, ARCH/, `_ar/evidence/flow/`, BR/, UC/, ES/, MSG/, glossary.md, `tooling/docs/rules-JOB.md`, `tooling/templates/template-JOB.md` (if present).

**Deliverables:** JOB files in `_ar/spec-draft/JOB/`, `JOB-map.md`, `JOB-synthesis-report.md`. Optional: `job-synthesis-notes.md`.

**Extra rules:**
- One document per stable background contract.
- Make trigger model explicit.
- Keep idempotency visible.
- Keep transport/infrastructure details out unless needed for contract meaning.
- Preserve uncertainty instead of inventing scheduler mechanics.

**Success:** Major background contracts documented; job scope and side effects explicit; unsupported scheduler details not invented.

---

## orchestration/04-spec-driven-closure/agents/QuerySpecSynthesizer.md
**Type:** agent

Standard AR agent conventions apply. Invocation: `Run AR:QuerySpecSynthesizer`.

**Mission:** Synthesize canonical query and report specifications for read-side behavior -- stable read models, report semantics, filters, aggregations, derived fields, output intent. Does NOT write SQL. Does NOT invent dashboards unsupported by evidence.

**When to use:** EN, UC, FN, BR, ARCH stable; read-side behavior matters for reporting/dashboarding/generation planning; team needs explicit query/report contracts.

**Inputs:**
- Required: `EN/`, `UC/`, `FN/`, `BR/`, `ARCH/`
- Strongly recommended: `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`, `glossary.md`
- Optional: `CS/`, `_ar/coverage/ui-gap-analysis.md`, `UI-gap-promotions.md`, `_ar/evidence/flow/`, `Runtime-truth-policy.md`

**Outputs:**
- `_ar/spec-draft/QUERY/QUERYxxxx_<SpecName>.md`
- `_ar/spec-draft/QUERY-map.md`
- `_ar/spec-draft/QUERY-synthesis-report.md`
- Optional: `_ar/evidence/query-synthesis-notes.md`

**Hard rules:**
1. Do NOT invent read models unsupported by evidence.
2. Distinguish query/report purpose from implementation mechanics.
3. Every spec must define source entities, filters, derived outputs, and user intent.
4. Do NOT include SQL, ORM query builders, or controller names.
5. Keep dashboard observations broader if underlying computation not fully confirmed.
6. Use glossary-governed terminology.
7. Do NOT let screenshot layout alone become report semantics.

**Procedure:** (1) Load EN, UC, FN, BR, ARCH, optional UI/runtime evidence. (2) Find list views, dashboards, summaries, reporting exports, search/filter surfaces, detail projections. (3) Group overlapping read-side surfaces into stable specs. (4) One doc per stable read-side contract. (5) Refresh map and report.

**Do not modify:** `_ar/spec-final/**`, production code, SQL files, BI/dashboard config, runtime assets.

---

## orchestration/04-spec-driven-closure/tasks/QuerySpecSynthesizer-task.md
**Type:** task

**Pre-check:** Confirm reading of EN/, UC/, FN/, BR/, ARCH/, DOMAIN-kernel.md, DOMAIN-aggregates.md, glossary.md, `tooling/docs/rules-QUERY.md`, `tooling/templates/template-QUERY.md` (if present). Optional evidence inputs may be used.

**Deliverables:** QUERY files in `_ar/spec-draft/QUERY/`, `QUERY-map.md`, `QUERY-synthesis-report.md`. Optional: `query-synthesis-notes.md`.

**Extra rules:**
- One document per stable read-side contract.
- Focus on purpose, source entities, filters, derived outputs, output intent.
- Do not include SQL or implementation queries.
- Keep uncertain computation rules explicit.

**Success:** Major query/report contracts documented; read-side semantics explicit; unsupported reporting behavior not invented.

---

## orchestration/90-optional-bonus/inventory-closure/agents/EntityInventoryCloser.md
**Type:** agent

Standard AR agent conventions apply. Invocation: `Run AR:EntityInventoryCloser`.

**Mission:** Build a complete as-is inventory of the application's persisted entity landscape without expanding into hundreds of full EN pages. Closes remaining long tail by classifying all entities into a consistent inventory and coverage matrix. This is a consolidation/coverage-closure step, NOT a discovery substitute for EN extraction or domain modeling.

**When to use:** Project wants to close current-state documentation; remaining entities too numerous for full EN pages; team wants as-is inventory; rewrite decisions may happen later. Do NOT use as replacement for ENExtractor, UCComposer, DomainKernelSynthesizer, or AggregateBoundaryModeler.

**Inputs:**
- Required: `EN/`, `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`, `ARCH0001_ApplicationOverview.md`, `ARCH0002_ContextInteractionMap.md`, `REWRITE-decision-pack.md`, `REWRITE-sequencing.md`, `_ar/repo-map/data-model-signals.md`, `_ar/evidence/db-inventory.md`, `_ar/evidence/db-models.md`, `_ar/coverage/mapped.md`, `_ar/coverage/unmapped.md`
- Code evidence: `src/**`, `packages/**`
- Optional: `UI-gap-promotions.md`, `UI-gap-open-questions.md`, `ui-gap-analysis.md`, `_ar/evidence/ui/**`

**Outputs:**
- `_ar/spec-draft/ENTITY-inventory.md` -- complete inventory table with columns: Canonical Name, Code Alias/Class Name, Table/Persistence Signal, Bounded Context, Entity Class, Company Scoped, Existing EN, Coverage Status, Rewrite Relevance, Notes
- `_ar/spec-draft/ENTITY-classification.md` -- classification model + entities grouped by class
- `_ar/spec-draft/ENTITY-coverage-matrix.md` -- coverage across EN, UC, Domain Kernel, Aggregate Map, ARCH, UI Evidence, Decision Pack
- `_ar/spec-draft/EntityInventoryCloser-report.md` (mandatory) -- total count, classification summary, coverage summary, top missing high-value entities, deferred/platform groups, ambiguous entities, closure verdict
- Optional: `ENTITY-deferred-candidates.md`, `ENTITY-platform-dependencies.md`

**Hard rules:**
1. Do NOT invent entities, relations, or lifecycle states.
2. Do NOT create full EN pages for entire remaining entity set.
3. Use existing EN pages as canonical anchors.
4. If same concept has multiple code aliases, document one canonical name + record aliases.
5. Classify each entity exactly one of: Domain, Configuration, Join/Assignment, Projection/Reporting, Audit/Log, Infrastructure/Technical, Uncertain.
6. Keep current-state focus; do NOT force rewrite design decisions into inventory.
7. If entity cannot be confidently classified, mark `Uncertain`.
8. Preserve current AR numbering and references.
9. Do not rename files in this pass.

**Procedure:** (1) Discover all persisted entity classes from ORM, DB inventory, migration evidence, repo-map signals. (2) Merge with existing EN coverage -- determine full/partial/no coverage. (3) Classify every entity (primary class + bounded context, aggregate ownership, company-scoped, doc status, rewrite relevance). (4) Write inventory and coverage tables. (5) Report gaps: total found, covered/partial/uncovered, top undocumented, platform/deferred groups, recommended next step.

**Failure mode:** If code and DB evidence disagree: mark `Uncertain`, record conflict. If entity appears shared/platform: mark `Platform Suspicion`, do not promote to core domain unless evidence justifies.

**Scope also allows:** `_ar/coverage/**`. Prefer adding inventory artifacts over rewriting existing core artifacts. Do not modify existing EN/UC IDs, production code, DB schema, migrations, runtime config.

---

## orchestration/90-optional-bonus/inventory-closure/tasks/EntityInventoryCloser-task.md
**Type:** task

**Goal:** Create complete as-is entity inventory so project can be closed as "this is how the system looks today" without full EN pages for long tail. Supports current-state understanding, handover, future rewrite prep, risk visibility.

**Execution mode:** Conservative, evidence-first, classification-focused. Do NOT expand remaining entities into full EN documents.

**Pre-check:** Same required inputs as agent spec plus code evidence (`src/**`, `packages/**`). UI artifacts only as secondary evidence.

**Classification model:** Every entity gets exactly one primary class (Domain / Configuration / Join-Assignment / Projection-Reporting / Audit-Log / Infrastructure-Technical / Uncertain) plus: canonical name, code alias, likely bounded context, company-scoped (yes/no/unknown), existing EN coverage (yes/partial/no), rewrite relevance (high/medium/low), platform suspicion (yes/no).

**Extra rules:**
- Include all reasonably identifiable persisted entities.
- Treat existing EN files as canonical anchors.
- Prefer short inventory entries over speculative narrative.
- Mark shared/platform entities as `Platform Suspicion`.
- Do not write large batches of new EN files.
- Do not broadly rewrite existing EN files.
- Do not make rewrite architecture decisions beyond rewrite relevance.

**Stop conditions:** Stop and record under `Blocked Reconciliation Issues` if: code/DB evidence irreconcilable; entity count differs significantly across sources unexplained; large cluster cannot be assigned even provisional context.

**Success:** All identifiable persisted entities in inventory; every entity classified with coverage status; core vs long-tail distinguished; platform suspicion separated; report gives credible as-is closure verdict.

---

## orchestration/90-optional-bonus/inventory-closure/agents/MissingCoreEntityWriter.md
**Type:** agent

Standard AR agent conventions apply. Invocation: `Run AR:MissingCoreEntityWriter`.

**Mission:** Close remaining high-value entity documentation gaps by writing a small number of missing core EN pages already evidenced across existing AR artifacts but lacking dedicated EN files. Late consolidation phase only. NOT a broad EN expansion tool -- writes only a small, explicitly requested set.

**Inputs:**
- Required: `ENTITY-inventory.md`, `ENTITY-classification.md`, `ENTITY-coverage-matrix.md`, `EntityInventoryCloser-report.md`, `EN/`, `DOMAIN-kernel.md`, `DOMAIN-aggregates.md`, `ARCH0001_ApplicationOverview.md`, `ARCH0002_ContextInteractionMap.md`, `REWRITE-decision-pack.md`, `REWRITE-sequencing.md`
- Strongly recommended: `UC/`, `_ar/evidence/flow/`, `SRV-flow-traceability.md`, `EN-lifecycle-evidence.md`
- Code evidence: `src/**`, `packages/**`
- Optional: `UI-gap-promotions.md`, `UI-gap-open-questions.md`, `_ar/evidence/ui/**`

**Outputs:**
- New EN files in `_ar/spec-draft/EN/`
- `_ar/spec-draft/MissingCoreEntityWriter-report.md` (mandatory)
- Optional: `_ar/evidence/missing-core-entity-evidence.md`

**Hard rules:**
1. Do NOT invent entities, fields, lifecycle states, or invariants.
2. Do NOT run as broad long-tail entity writer.
3. Only write entities explicitly requested by task.
4. Do NOT write blocked EN pages unless blocking question resolved in this run.
5. Preserve canonical English naming from current spec layer.
6. Code aliases only in alias/origin notes.
7. If evidence partial, write EN page only if `Evidence Pending` can be stated explicitly.
8. Prefer aggregate/kernel/UC/flow evidence over UI inference.
9. Do NOT renumber existing EN files.
10. Every created EN page must carry confidence label: Confirmed / Partial.

**EN file quality bar:** Must include: canonical English title, purpose, aliases/code class notes, bounded context, aggregate role/relation, key relations, lifecycle or `Evidence Pending`, invariants if evidenced, traceability references, confidence level. Do not: dump raw ORM fields without interpretation, infer state machines from labels alone, hide uncertainty.

**Procedure:** (1) Load inventory, identify explicitly requested missing core entities. (2) Per entity: locate class/persistence anchor, table/signal, owning aggregate, UC/kernel/ARCH/REWRITE references, company scoping, lifecycle. (3) Write EN pages where evidence sufficient. (4) Report: created files, blocked files, unresolved evidence gaps, recommended next step.

**Failure mode:** If evidence insufficient: do not fabricate; either write partial EN with explicit `Evidence Pending` or mark blocked in report.

**Do not modify:** production code, config, migrations, runtime assets, existing EN numbering, existing EN files (unless task explicitly allows small cross-reference update).

---

## orchestration/90-optional-bonus/inventory-closure/tasks/MissingCoreEntityWriter-task.md
**Type:** task

**Goal:** Close a small, explicitly requested set of missing core EN pages already evidenced but absent. Narrow run, not broad EN expansion.

**Pre-check:** Same required inputs as agent spec plus strongly recommended UC/, flow/, SRV-flow-traceability.md, EN-lifecycle-evidence.md, UI artifacts, code evidence.

**Required task parameters (operator must define):**
- Exact entity list for this run
- Whether partial EN pages are allowed
- Whether blocked entities may be skipped
- Whether small cross-reference update to existing EN files is allowed

If exact entity list not provided, do not broaden scope.

**Deliverables:** New EN files in `_ar/spec-draft/EN/`, `MissingCoreEntityWriter-report.md`. Optional: `missing-core-entity-evidence.md`.

**Extra rules:**
- Only write explicitly requested entities.
- If evidence partial, only write if `Evidence Pending` can be stated.
- If insufficient and partial pages not allowed, mark blocked in report.
- Preserve canonical English naming and existing EN numbering.

---

## orchestration/90-optional-bonus/ui-coverage/agents/ScreenshotCoverageAuditor.md
**Type:** agent

Standard AR agent conventions apply. Invocation: `Run AR:ScreenshotCoverageAuditor`.

**Mission:** Compare observed UI surface from screenshots with reconstructed specification; identify documented, partially documented, and undocumented areas.

**Hard constraints:**
- MUST NOT modify production code or existing spec files.
- MUST NOT invent business logic from screenshots alone.
- Screenshots are observational evidence, not canonical truth.
- Every hard claim must include evidence.

**Mandatory inputs:** All `_ar/prtsc/**`, `_ar/spec-draft/**`, `_ar/spec-final/**` (if exists), `_ar/coverage/**`, `_ar/repo-map/modules.md` (if exists), `_ar/evidence/**` (if relevant).

**Screenshot interpretation rules:**
- Distinguish UI projection from domain concept.
- Do NOT infer new entity from table column alone.
- Do NOT infer new UC from button alone.
- Mark uncertainty explicitly.
- If behavior may belong to NexCRM/shared platform, flag as `Platform Suspicion`.

**Coverage classification per observed area:** Covered | Partial | Missing | Uncertain/Platform suspicion.

**Procedure:** (1) Index screenshots in `_ar/prtsc/**`. (2) Per screenshot: identify module/screen/visible concepts, visible actions/filters; compare against spec-draft/spec-final; classify coverage. (3) Cross-screen summary. (4) Identify highest-value gaps.

**Outputs:**
- `_ar/coverage/ui-screen-index.md`
- `_ar/coverage/ui-gap-analysis.md`
- `_ar/evidence/ui/ui-observed-areas.md`

---

## orchestration/90-optional-bonus/ui-coverage/tasks/ScreenshotCoverageAuditor-task.md
**Type:** task

**Pre-check:** Read all `_ar/prtsc/**`; `_ar/spec-draft/**`; `_ar/coverage/**`; `_ar/spec-final/**` if exists; `_ar/repo-map/modules.md` if exists; `_ar/evidence/**` if relevant.

**Rules:** Do NOT modify existing EN/UC/SRV files. Do NOT infer domain logic from layout alone. Every hard claim must include evidence. Mark uncertain areas explicitly. Flag possible NexCRM/shared-platform behavior separately.

**Deliverables:** `_ar/coverage/ui-screen-index.md`, `_ar/coverage/ui-gap-analysis.md`, `_ar/evidence/ui/ui-observed-areas.md`.

---

## orchestration/90-optional-bonus/ui-coverage/agents/UIGapToSpecPlanner.md
**Type:** agent

Standard AR agent conventions apply. Invocation: `Run AR:UIGapToSpecPlanner`.

**Mission:** Transform UI coverage gaps into structured follow-up actions for the spec-driven workflow without inventing unsupported domain truth.

**Hard constraints:**
- MUST NOT modify production code.
- MUST NOT directly rewrite existing EN/UC/SRV files.
- Screenshot-derived conclusions are provisional unless supported by existing evidence.
- Every hard claim must include evidence.

**Mandatory inputs:** `_ar/coverage/ui-screen-index.md`, `ui-gap-analysis.md`, `_ar/evidence/ui/ui-observed-areas.md`, `_ar/spec-draft/**`, `_ar/coverage/**`, `_ar/evidence/**` (if relevant).

**Mandatory decision categories (each gap must be classified):**
- Promote to EN candidate
- Promote to UC candidate
- Promote to FLOW/EVIDENCE follow-up
- Treat as UI projection only
- Open question
- Platform/NexCRM suspicion

**Promotion rules:**
- New EN candidate only if business meaning visible beyond presentation.
- New UC candidate only if user intent visible and not already covered.
- FLOW follow-up if behavior exists but mechanism unknown.
- UI projection if screen only visualizes known entity/service.
- Platform suspicion if likely shared modules or NexCRM bundles.

**Outputs:**
- `_ar/spec-draft/UI-gap-promotions.md`
- `_ar/spec-draft/UI-gap-open-questions.md`
- `_ar/coverage/ui-followups.md`

---

## orchestration/90-optional-bonus/ui-coverage/tasks/UIGapToSpecPlanner-task.md
**Type:** task

**Pre-check:** Read `_ar/coverage/ui-screen-index.md`, `ui-gap-analysis.md`, `_ar/evidence/ui/ui-observed-areas.md`, `_ar/spec-draft/**`, `_ar/coverage/**`, `_ar/evidence/**` (if relevant).

**Rules:** Do NOT rewrite existing EN/UC/SRV files. Do NOT promote gaps without evidence. Classify every gap using mandatory decision categories. Flag NexCRM/shared-platform suspicion separately.

**Deliverables:** `_ar/spec-draft/UI-gap-promotions.md`, `_ar/spec-draft/UI-gap-open-questions.md`, `_ar/coverage/ui-followups.md`.

---

## orchestration/90-optional-bonus/ui-coverage/agents/GapClosureSpecWriter.md
**Type:** agent

Standard AR agent conventions apply. Invocation: `Run AR:GapClosureSpecWriter`.

**Mission:** Close promoted UI/spec gaps by converting already-approved gap candidates into concrete EN and UC draft artifacts using only existing evidence and code-backed verification. Resolves the "promoted but not yet written" artifact gap.

**Prerequisites:** Runs after RepoCartographer, DBIntrospector, SRVCurator, SRVRestructurer, FlowInspector, FlowMiner, ENExtractor, UCComposer, DomainKernelSynthesizer, AggregateBoundaryModeler, ScreenshotCoverageAuditor, UIGapToSpecPlanner.

**Inputs:**
- Required: `UI-gap-promotions.md`, `UI-gap-open-questions.md`, `_ar/coverage/ui-followups.md`
- Strongly recommended: `DOMAIN-kernel.md`, `DOMAIN-ubiquitous-language.md`, `DOMAIN-aggregates.md`, `CONSISTENCY-boundaries.md`, `UC-candidates.md`, `UC-srv-traceability.md`, `EN/`, `_ar/evidence/flow/`, `SRV-target-list.md`, `SRV-flow-traceability.md`
- Code evidence: `src/**`, `packages/**`
- Optional: `_ar/prtsc/**`, `_ar/evidence/ui/**`, `ui-screen-index.md`, `ui-gap-analysis.md`

**Outputs:**
- New EN files in `_ar/spec-draft/EN/`, new UC files in `_ar/spec-draft/UC/`
- `_ar/spec-draft/GapClosureSpecWriter-report.md` (mandatory)
- Optional: `_ar/evidence/gap-closure-evidence.md`

**Hard rules:**
1. Do NOT invent business behaviour.
2. Do NOT create EN/UC unless evidence sufficient.
3. If evidence incomplete, create only if artifact can carry `Evidence Pending` sections without pretending completeness.
4. Preserve reserved numbering from `UI-gap-promotions.md` and `ui-followups.md`.
5. Do NOT renumber existing EN or UC files.
6. Do NOT overwrite existing EN/UC unless task explicitly requests update.
7. Screenshots are observational evidence, never canonical truth over code.
8. Code + flow evidence outrank screenshot interpretation.
9. Open questions must be resolved from code if possible; otherwise keep open explicitly.
10. Always state confidence per artifact: Confirmed / Partial.

**EN quality bar:** Purpose, core responsibilities, relations, lifecycle (or note not yet evidenced), invariants if evidenced, evidence gaps, cross-references. Do not dump ORM fields blindly, infer states from labels alone, or invent hidden business logic.

**UC quality bar:** Intent, primary actors, preconditions, main flow, alternatives, postconditions, risks, traceability, evidence level. Do not write raw controller traces, overuse HTTP/framework details, or silently upgrade hypothesis to confirmed.

**Procedure:** (1) Load promoted work, build worklist by P1/P2/P3. (2) Resolve blocking OQs needed by scope (from code if possible). (3) Write EN artifacts with evidence + explicit unresolved parts. (4) Write UC artifacts domain-oriented with traceability. (5) Closure report: created/updated files, resolved/unresolved OQs, blocked artifacts, recommended next step.

**Failure mode:** If evidence insufficient: do not fabricate; write blocked item into report; name exact missing evidence; recommend precise next investigation.

---

## orchestration/90-optional-bonus/ui-coverage/tasks/GapClosureSpecWriter-task.md
**Type:** task

**Goal:** Close highest-value promoted UI/spec gaps into EN and UC drafts. Execution mode: conservative, evidence-first, no invention.

**Primary scope (this run only):**
- EN targets: EN0022 SyntheticAccount, EN0023 AccountingJournalEntry, EN0024 CostCentre, EN0025 Zakazka, EN0026 Cinnost, EN0027 Predkontace, EN0028 UnitOfMeasure, EN0029 InvoiceSetting
- UC targets: UC0035 AccountingYearClose, UC0036 LedgerRecalculation, UC0037 AccountingDimensionManagement, UC0038 ResultsDashboardRendering, UC0039 InvoiceSettingsConfiguration, UC0040 ContactDocumentHistoryView, UC0042 RecurringInvoiceTemplateManagement, UC0043 CompanyMemberInviteAndPositionAssignment, UC0048 CompanyContextSelection

**Open questions to resolve first:** OQ-001 (per-invoice-module permissions vs TariffUser RBAC), OQ-004 (DataBox credentials storage -- may leave unresolved if not needed), OQ-005 ("Light" invoice variant meaning), OQ-006 (Zakazka lifecycle states), OQ-007 (Predkontace scoping), OQ-010 (Role "Skupina" field).

**Priority order:** Step A (Accounting context): EN0022-EN0028, UC0035-UC0037. Step B (Invoice settings/reporting): EN0029, UC0038-UC0039. Step C (high-value UX/domain): UC0040, UC0042, UC0043, UC0048.

**Allowed updates to existing files:** `UC-candidates.md`, `UC-srv-traceability.md`, `EN-candidates.md`, existing EN/UC only for cross-reference addendum. No broad rewrites.

**Mandatory report** (`GapClosureSpecWriter-report.md`): files created, files updated, OQs resolved, OQs unresolved, artifacts blocked, confidence summary (Confirmed/Partial), recommended next step.

**Stop conditions:** Required entity not found in code/evidence; UI contradicts code; numbering conflict; artifact would require guessing core business logic.

**Success:** Requested P1 artifacts created or explicitly blocked; InvoiceSetting ambiguity handled safely; accounting domain advanced; report states what remains before RewriteDecisionCompiler.

**Next step:** If successful: `Run AR:RewriteDecisionCompiler`. If major P1 blocked: name exact follow-up investigation.

---

## orchestration/90-optional-bonus/ux-reconstruction/agents/IASynthesizer.md
**Type:** agent

Standard AR agent conventions apply (idempotent, refresh in place; writes only to `_ar/spec-draft/**` + `_ar/evidence/**`; invocation `Run AR:IASynthesizer`). First step of the optional `ux-reconstruction` branch.

**Mission:** Reconstruct the single project-level IA (`_ar/spec-draft/IA/IA-<project-slug>.md`) from observed UI evidence + reconstructed BA layers. Does not discover from code.
**Inputs:** Required `_ar/coverage/ui-screen-index.md`, `_ar/evidence/ui/ui-observed-areas.md`, `_ar/prtsc/**`; recommended UC/EN/ACL/ARCH, CS + `_ar/evidence/runtime/prtsc/**`, flow, glossary; optional ES/BR, `_ar/repo-map/modules.md`.
**Outputs:** `_ar/spec-draft/IA/IA-<project-slug>.md`, `IA-screen-map.md`, `IA-synthesis-report.md`.
**Key rules:** mint stable screen-ids (S001…) for WIRE; observed UI suggestive not authoritative; reference UC/EN/ACL/ARCH by doc_id, never inline; Open IA Questions mandatory; don't override `modules.md`.

---

## orchestration/90-optional-bonus/ux-reconstruction/agents/WIRESynthesizer.md
**Type:** agent

Standard AR agent conventions apply. Runs after IASynthesizer.

**Mission:** Reconstruct one WIRE per screen (`_ar/spec-draft/WIRE/WIRExxxx_<Screen>.md`) from UI evidence + BA layers.
**Inputs:** Required IA + `IA-screen-map.md`, UC/, `_ar/prtsc/**`, `ui-observed-areas.md`; recommended EN/BR, CS; optional QUERY/ACL/COMP.
**Outputs:** WIRE files, `WIRE-screen-coverage.md`, `WIRE-synthesis-report.md`.
**Key rules:** `realizes_uc` (≥1 UC) REQUIRED; `screen_id` matches IA; cover 4 states (default/empty/loading/error) or `N/A`; components → COMP or `inline`; validation → BR; unobserved states Assumed/Uncertain; classify + cite screenshots.

---

## orchestration/90-optional-bonus/ux-reconstruction/agents/COMPSynthesizer.md
**Type:** agent

Standard AR agent conventions apply. Runs after WIRESynthesizer. Most evidence-thin UX layer — evidence-gated.

**Mission:** Reconstruct reusable components (`_ar/spec-draft/COMP/COMPxxxx_<Name>.md`) from the WIRE surface + UI evidence.
**Inputs:** Required WIRE/ + `WIRE-screen-coverage.md`, `ui-observed-areas.md`, `_ar/prtsc/**`; recommended EN, glossary; optional ACL, CS.
**Outputs:** COMP files, `COMP-inventory-map.md`, `COMP-synthesis-report.md`.
**Key rules:** create a COMP ONLY on observable reuse across ≥2 WIRE; else leave WIRE `inline`. Six states or `N/A`/`Uncertain`; unobservable a11y → Uncertain, not fabricated; sub-COMP/EN/ACL by doc_id; `modules: []`. May update a WIRE's `inline`→`COMPxxxx` reference only.

---

## orchestration/90-optional-bonus/ux-reconstruction/agents/COPYSynthesizer.md
**Type:** agent

Standard AR agent conventions apply. Runs after WIRESynthesizer (may run alongside COMPSynthesizer).

**Mission:** Reconstruct copy specs (`_ar/spec-draft/COPY/COPY-<scope>.md`) by transcribing observed UI text and linking it to rules/use cases.
**Inputs:** Required `_ar/prtsc/**`, `ui-observed-areas.md`, WIRE/; recommended COMP, BR/EN, UC, glossary; optional CS.
**Outputs:** COPY files, `COPY-key-index.md`, `COPY-synthesis-report.md`.
**Key rules:** transcribe text VERBATIM (no paraphrase/invention); keys `<scope>.<screen-or-component>.<role>`; validation → BR/EN, CTA → UC; implied strings Assumed/Uncertain; default scope `shared-*`/`module-<project-slug>`, `modules: []`, `language` set; glossary for cs/en.

---

## orchestration/90-optional-bonus/ux-reconstruction/tasks/IASynthesizer-task.md
**Type:** task

Standard AR task wrapper (write only to `_ar/spec-draft/**` + `_ar/evidence/**`; do not modify `_ar/coverage/**`). Pre-check: ui-screen-index, ui-observed-areas, prtsc, UC/EN/ACL/ARCH, CS/flow, glossary, rules/template-IA. Deliverables: `IA-<project-slug>.md`, `IA-screen-map.md`, `IA-synthesis-report.md`. Rules: stable screen-ids; reference not restate; Open IA Questions mandatory.

---

## orchestration/90-optional-bonus/ux-reconstruction/tasks/WIRESynthesizer-task.md
**Type:** task

Standard AR task wrapper. Pre-check: IA + screen-map, UC/, prtsc, ui-observed-areas, EN/BR/QUERY/ACL/COMP, CS, glossary, rules/template-WIRE. Deliverables: WIRE files, `WIRE-screen-coverage.md`, `WIRE-synthesis-report.md`. Rules: `realizes_uc`+`screen_id`; 4 states or N/A; COMP/inline; validation→BR; classify+cite.

---

## orchestration/90-optional-bonus/ux-reconstruction/tasks/COMPSynthesizer-task.md
**Type:** task

Standard AR task wrapper. Pre-check: WIRE + coverage, ui-observed-areas, prtsc, EN/ACL, CS, glossary, rules/template-COMP. Deliverables: COMP files (evidenced reuse only), `COMP-inventory-map.md`, `COMP-synthesis-report.md`. Rules: reuse ≥2 WIRE else inline; six states or N/A/Uncertain; reference EN/ACL/sub-COMP by doc_id; `modules: []`.

---

## orchestration/90-optional-bonus/ux-reconstruction/tasks/COPYSynthesizer-task.md
**Type:** task

Standard AR task wrapper. Pre-check: prtsc, ui-observed-areas, WIRE/COMP, BR/EN/UC, CS, glossary, rules/template-COPY. Deliverables: COPY files per scope, `COPY-key-index.md`, `COPY-synthesis-report.md`. Rules: verbatim text; key convention; validation→BR/EN, CTA→UC; default scope shared/module-<project-slug>, modules `[]`; implied→Uncertain.

---

## orchestration/99-legacy/agents/BRSynthesizer.md
**Type:** agent (legacy)

Standard AR agent conventions apply. Invocation: `Run AR:BRSynthesizer`.

**Mission:** Create a high-level business architecture layer in `_ar/spec-draft/BR/` that summarizes the largest architectural and domain truths already discovered. Acts as a navigation and orientation layer above EN and UC documentation. Helps readers understand major domains, responsibilities, entity/UC membership, cross-domain concepts, and external integrations. Only synthesizes existing information -- no new knowledge invented.

**Reads from:** `_ar/spec-draft/**`, `_ar/evidence/**`, `_ar/repo-map/**`, `_ar/coverage/**`.
**Writes only to:** `_ar/spec-draft/BR/**`. Must not modify any files outside this directory.

**Mandatory outputs:**
- `BR0000_Index.md` -- entry point: purpose, structure explanation, list of all BR docs, recommended next reading
- `BR0001_DomainMap.md` -- system domain landscape: detected domains with short descriptions, references to domain BR docs
- `BR0002_CoreConcepts.md` -- cross-domain concepts: definition, importance, EN/UC/ARCH references (only if clearly evidenced)
- `BR0003_ExternalIntegrations.md` -- external systems: purpose, interacting domains, referenced flows/artifacts
- One doc per detected domain: `BR1xxx_<DomainName>.md`

**Domain detection:** Only from evidence (entity clusters, flow clusters, repo modules, architecture docs, UI areas, recurring terminology). Prefer fewer strong domains over many weak ones. Weak evidence stays in broader domain.

**Domain document required structure:** (1) Purpose. (2) Boundaries. (3) Main responsibilities. (4) Key entities with EN refs. (5) Key use cases with UC refs. (6) Important flows/system realities. (7) Related integrations. (8) Suggested reading path.

**Content rules -- must not:** invent missing behavior, create new architectural concepts, speculate about undocumented functionality, reinterpret weak hints as facts, rewrite EN/UC documentation. All claims must be traceable.

**Cross-referencing:** Reference EN, UC, FLOW, ARCH, DOMAIN docs, repo modules where appropriate. Guide reader toward deeper detail. Do not over-attach references.

**Style:** Concise, factual, architecture-aware, readable by technical and business stakeholders. Avoid implementation detail, internal service names (unless essential), raw code references, DB schema duplication. Layer must remain navigational, not analytical.

**Naming:** `BR0000_Index.md`, `BR0001_DomainMap.md`, `BR0002_CoreConcepts.md`, `BR0003_ExternalIntegrations.md`, `BR1001_<DomainName>.md`, `BR1002_<DomainName>.md`, etc. Domain numbering stable within project.

**Procedure:** (1) Scan reconstructed docs. (2) Detect major domains. (3) Create BR directory if missing. (4) Create index, domain map, core concepts, external integrations, one doc per domain. (5) Insert cross-references. (6) Stop after writing BR docs.

**Completion report:** List of created BR files, detected domains, uncertain domain classifications.

---

## orchestration/99-legacy/tasks/BRSynthesizer-task.md
**Type:** task (legacy)

**Goal:** Create high-level business architecture layer in `_ar/spec-draft/BR/` summarizing known architectural truths for orientation and navigation.

**Constraints:** Do not invent new knowledge. Only synthesize from existing artifacts. Do not modify any existing files. Write only to `_ar/spec-draft/BR/`.

**Mandatory files:** `BR0000_Index.md`, `BR0001_DomainMap.md`, `BR0002_CoreConcepts.md`, `BR0003_ExternalIntegrations.md`, plus one doc per detected domain.

**Domain detection:** From entity clusters, flow clusters, repo modules, architecture docs, recurring terminology. Fewer strong domains preferred.

**Content per domain doc:** Purpose, boundaries, main responsibilities, main entities, major use cases, relevant flows, relevant integrations, recommended deeper reading.

**Cross-referencing:** Reference EN, UC, FLOW, ARCH files, repo modules to help reader navigate.

**Success:** BR directory exists; all mandatory files exist; domain documents created; BR layer provides clear navigation; no unsupported claims introduced.
