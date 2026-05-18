# Skills Manifest — Agente01_ProductOwner

_All skills available to the Product Owner at runtime. Each skill has a local `skill.md`, input/output schemas, checklist, and good/bad examples._

---

## Skill Index

| Skill ID | Name | Trigger | Output Artifact |
|---|---|---|---|
| SK-PO-01 | requirements-interview-skill | Briefing received with gaps | Requirements_Interview_Log.md |
| SK-PO-02 | prd-generation-skill | All elicitation complete | PRD.md |
| SK-PO-03 | user-story-mapping-skill | Features identified | User_Story_Map.md |
| SK-PO-04 | bdd-acceptance-criteria-skill | User stories defined | Acceptance_Criteria.md |
| SK-PO-05 | scope-boundary-skill | Features identified | Scope_Boundary.md |
| SK-PO-06 | requirements-quality-review-skill | PRD drafted | PRD review report |
| SK-PO-07 | non-functional-requirements-skill | PRD nearly complete | Non_Functional_Requirements.md |
| SK-PO-08 | open-questions-management-skill | Any question arises | Open_Questions.md |
| SK-PO-09 | business-rules-extraction-skill | Business logic in input | Business_Rules.md |
| SK-PO-10 | product-risk-analysis-skill | PRD near completion | Product_Risks.md |

---

## SK-PO-01 — Requirements Interview Skill

**Path:** `skills/requirements-interview-skill/`
**Purpose:** Generate structured interview questions from a briefing, categorize them by type, and record stakeholder answers in a structured log.
**Activates when:** Tech Lead briefing is received and one or more of the following is unclear: business objective, target users, core features, success criteria, constraints.
**Output:** Structured question set + `Requirements_Interview_Log.md`
**Key constraint:** Questions must be routed to the Tech Lead — never directly to humans.

---

## SK-PO-02 — PRD Generation Skill

**Path:** `skills/prd-generation-skill/`
**Purpose:** Compose a complete PRD from elicited requirements following the mandatory PRD template.
**Activates when:** Business objective, target users, and core features are confirmed via elicitation.
**Output:** `PRD.md` following `templates/PRD.md` structure.
**Key constraint:** Must apply `checklists/prd_quality_checklist.md` before producing final output.

---

## SK-PO-03 — User Story Mapping Skill

**Path:** `skills/user-story-mapping-skill/`
**Purpose:** Decompose features into epics and user stories following INVEST criteria, produce a story map with priority and acceptance criteria references.
**Activates when:** Features and user types are confirmed.
**Output:** `User_Story_Map.md` with all US-NNN entries.
**Key constraint:** Every story must pass `checklists/invest_checklist.md`.

---

## SK-PO-04 — BDD Acceptance Criteria Skill

**Path:** `skills/bdd-acceptance-criteria-skill/`
**Purpose:** Write Given/When/Then acceptance criteria for each user story covering happy path, edge cases, and negative scenarios.
**Activates when:** User stories are defined.
**Output:** `Acceptance_Criteria.md` with all AC-NNN-NN entries.
**Key constraint:** Must apply `checklists/bdd_acceptance_checklist.md`. Criteria with "fast", "easy", or "intuitive" must be rewritten with measurable metrics.

---

## SK-PO-05 — Scope Boundary Skill

**Path:** `skills/scope-boundary-skill/`
**Purpose:** Explicitly define in-scope and out-of-scope features with rationale for exclusions.
**Activates when:** Features are identified and PRD is being drafted.
**Output:** `Scope_Boundary.md`.
**Key constraint:** Both in-scope and out-of-scope sections are mandatory. Scope without out-of-scope is incomplete.

---

## SK-PO-06 — Requirements Quality Review Skill

**Path:** `skills/requirements-quality-review-skill/`
**Purpose:** Review the complete PRD package against all quality dimensions before Gate 1 submission.
**Activates when:** PRD and all supporting artifacts are drafted.
**Output:** Quality review report with PASS/FAIL per criterion.
**Key constraint:** All blocking issues must be resolved before handoff. No "close enough" approvals.

---

## SK-PO-07 — Non-Functional Requirements Skill

**Path:** `skills/non-functional-requirements-skill/`
**Purpose:** Generate comprehensive NFRs across all 10 mandatory categories with measurable metrics.
**Activates when:** PRD functional sections are complete.
**Output:** `Non_Functional_Requirements.md`.
**Key constraint:** Every NFR must have a concrete, measurable metric. Vague NFRs are not accepted.

---

## SK-PO-08 — Open Questions Management Skill

**Path:** `skills/open-questions-management-skill/`
**Purpose:** Register, classify, track, and escalate open questions as OQ-NNN entries.
**Activates when:** Any unresolved question arises during any phase.
**Output:** Updated `Open_Questions.md`.
**Key constraint:** BLOCKING questions must be escalated to Tech Lead before Gate 1 submission.

---

## SK-PO-09 — Business Rules Extraction Skill

**Path:** `skills/business-rules-extraction-skill/`
**Purpose:** Identify and formally document business rules from stakeholder input as BR-NNN entries.
**Activates when:** Business logic or constraints appear in elicited information.
**Output:** `Business_Rules.md`.
**Key constraint:** Every rule must be attributed to a stakeholder source. Unattributed rules become OQ-NNN.

---

## SK-PO-10 — Product Risk Analysis Skill

**Path:** `skills/product-risk-analysis-skill/`
**Purpose:** Identify product-level risks (delivery, scope, adoption, compliance, data), classify by impact and likelihood, propose mitigations.
**Activates when:** PRD is nearly complete.
**Output:** `Product_Risks.md` with all PRISK-NNN entries.
**Key constraint:** HIGH impact risks require a documented mitigation strategy, not just identification.

---

## Runtime Knowledge Policy

All skills in this manifest operate under the following policy:

- **Allowed**: `Agente01_ProductOwner/knowledge/`, local skill files, schemas, templates, checklists, examples, project inputs from Tech Lead
- **Blocked**: `context/`, `lib/`, `*.pdf`, raw books, global build documents
- If a skill requires theoretical knowledge not in `knowledge/`, request a build patch. Do not attempt to read raw sources at runtime.

---

## Executable Tools

The following shared runtime tools are available via the repository root `tools/` directory.

### Factory Validation Scripts (`tools/factory-scripts/`)

| Tool | Command | Purpose |
|------|---------|---------|
| `validate-framework.sh` | `bash tools/factory-scripts/validate-framework.sh` | Validates the full factory structure before milestone reviews |
| `credential-preflight.sh` | `bash tools/factory-scripts/credential-preflight.sh [project-root]` | Validates API credentials before integration cycles |
| `agent-metrics.sh` | `bash tools/factory-scripts/agent-metrics.sh` | Reports agent activity for sprint retrospectives |

### MCP Knowledge Server (`tools/mcp-knowledge-search/`)

Exposes the full bibliography and agent knowledge base as a searchable MCP tool. Use during backlog refinement to cross-reference requirements against known constraints in agent knowledge.

| Tool | Command |
|------|---------|
| `search_knowledge` | MCP tool call — searches across all indexed documents |
| `knowledge_stats` | MCP tool call — lists available knowledge sources |

### Document Generation (`tools/document-generation/`)

| Tool | Purpose |
|------|---------|
| `spellcheck_document.py` | Spell-check deliverable documents (PPTX, DOCX, MD) before client handoff |
| `validate_office_file.py` | Validate structural integrity of Office deliverables |
