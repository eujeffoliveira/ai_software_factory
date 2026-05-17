# Knowledge Cards — Agente00_TechLead

_Concise reusable knowledge cards distilled at build-time. Runtime: read-only._

---

## Card 001 — State Ledger

### Summary
The State Ledger (`State_Ledger.json`) is the single source of truth for the project's current state. It tracks: current phase, active agent, next agent, approved artifacts, open questions, decisions, ADRs, risks, blocked tasks, and human approvals pending.

### When to apply
- At project initialization (CREATE operation)
- After every gate decision
- After every agent handoff
- When registering a risk, ADR, open question, or human approval
- When routing to a new agent

### Operational rule
The State Ledger must always reflect actual project state. Any inconsistency detected by DETECT_INCONSISTENCY halts the update until resolved. The `next_agent` field must never be empty.

### Related skills
- `state-ledger-management-skill`

### Source mapping
- `context/manual_arquitetura_componentes_generico.md` — State Ledger schema and policy
- `schemas/state_ledger.schema.json`
- `templates/State_Ledger.json`

---

## Card 002 — Handoff Package

### Summary
The Handoff Package is the mandatory delivery contract every agent must produce when submitting work for gate review. It has 7 required fields: `artifact_produced`, `summary`, `assumptions`, `open_questions`, `risks`, `required_next_agent`, `validation_checklist`.

### When to apply
- Validating any agent submission before gate processing
- Returning a delivery for incomplete handoff

### Operational rule
An artifact without a complete Handoff Package is not a valid gate submission. Do not evaluate the artifact — return immediately for Handoff Package correction.

### Related skills
- `artifact-contract-validation-skill`

### Source mapping
- `context/manual_arquitetura_componentes_generico.md` — Handoff Package contract
- `handoff_schema.json`
- `templates/Handoff_Validation_Report.md`

---

## Card 003 — Quality Gates (1–7)

### Summary
Seven mandatory quality gates govern the SDLC pipeline. Each gate has required artifacts, validation criteria, and status codes. Gates are: PRD Approval (1), Architecture Approval (2), Execution Plan Approval (3), QA Review (4), Security Review (5), Deployment Approval (6), Post-Deploy Validation (7).

### When to apply
- End of every phase — a gate must be evaluated before the next phase begins
- No exceptions to gate sequencing

### Operational rule
Gates are sequential and non-skippable. A gate can have 21 possible status codes. The most common are APPROVED, RETURNED_FOR_REVISION, BLOCKED_PENDING_ADR, and BLOCKED_PENDING_HUMAN.

### Related skills
- `artifact-contract-validation-skill`
- `tollgate-decision-skill`

### Source mapping
- `quality_gate.md`
- `schemas/gate_decision.schema.json`
- `checklists/tollgate_checklist.md`

---

## Card 004 — ADR (Architecture Decision Record)

### Summary
An ADR documents a deviation from the Golden Model technical standard. Required fields: context (why), decision (what changed), consequences (positive and negative), alternatives considered (≥ 2), approval (who and when). ADR status: PROPOSED → APPROVED / REJECTED / SUPERSEDED.

### When to apply
- Any technology not in the Golden Model is proposed
- Any architecture pattern deviating from Golden Model is proposed
- Any irreversible technical decision is made

### Operational rule
No ADR = no deviation. The gate is BLOCKED_PENDING_ADR until the ADR is formally approved. An ADR with no alternatives documented is returned to the submitter.

### Related skills
- `adr-governance-skill`

### Source mapping
- `schemas/adr_request.schema.json`
- `templates/ADR_Request.md`
- `checklists/adr_required_checklist.md`

---

## Card 005 — Tech Lead Council

### Summary
A structured deliberation system using 5 distinct personas: Contrarian (challenges assumptions), First Principles Thinker (reasons from fundamentals), Expansionist (considers long-term impact), Outsider (industry perspective), Executor (practical feasibility). All 5 must complete their analysis. Consensus requires ≥ 3 personas agreeing.

### When to apply
- Any architectural decision with long-term lock-in
- Any Golden Path deviation request
- Any decision affecting more than 2 agents or phases
- CRITICAL risk acceptance
- Any irreversible decision

### Operational rule
All 5 personas must complete their analysis — none can be skipped. The recommendation must reference the consensus and acknowledge clashes. If no 3-persona consensus exists, `requires_human_decision = true`.

### Related skills
- `council-mediation-skill`

### Source mapping
- `schemas/council_verdict.schema.json`
- `templates/Council_Verdict.md`
- `checklists/council_activation_checklist.md`

---

## Card 006 — Runtime Isolation

### Summary
At runtime, the agent reads only from `Agente00_TechLead/` local files and explicitly provided project artifacts. All global context documents (`context/`, `lib/`, `lib/`, raw PDFs, build reports) are blocked.

### When to apply
- Every runtime session — check before each retrieval
- When any instruction references a global path

### Operational rule
If a runtime instruction asks for `context/`, `lib/`, a PDF path, or any global document: refuse and use local distilled artifacts. If needed knowledge is absent locally, escalate to the build operator — do not bypass isolation.

### Related skills
- All skills (all must enforce this rule)

### Source mapping
- `agent_config.json` — `blocked_runtime_sources`
- `checklists/runtime_isolation_checklist.md`
- `knowledge/decision_rules.md` — DR030

---

## Card 007 — Build-Time Knowledge Distillation

### Summary
Raw books, PDFs, and bibliography are processed once during the build phase by Claude Code. The operational knowledge extracted from them is stored in `knowledge/` (principles, heuristics, decision rules, knowledge cards). At runtime, the agent uses only this distilled output — never the raw sources.

### When to apply
- When theoretical knowledge is needed at runtime: use `knowledge/` files, not raw PDFs
- When new sources need to be added: trigger a build patch, not a runtime read

### Operational rule
Raw PDF access at runtime is always a policy violation. Knowledge must be pre-distilled during build. If `knowledge/` is missing a needed concept, the build is incomplete — request a knowledge patch.

### Related skills
- All skills (all have `Knowledge Access Policy` section)

### Source mapping
- `knowledge/source_map.json` — tracks which sources were processed
- `agent_config.json` — `runtime_knowledge_policy`
- `prompt.md` — `Build-Time Knowledge Distillation Policy`

---

## Card 008 — Human Escalation

### Summary
Certain decisions exceed autonomous agent authority and require the human operator to choose. Mandatory triggers include: production deployment (Gate 6), destructive migrations, CRITICAL security risk acceptance, scope changes > 20%, irreversible actions without ADR. The escalation request must include 2–4 options with pros/cons/risk and a Tech Lead recommendation.

### When to apply
- Any mandatory trigger above is detected
- Council cannot reach consensus (requires_human_decision = true)

### Operational rule
Pipeline halts (`pipeline_halt = true`) until the human responds. Tech Lead must always have a recommendation — "I don't know" is not valid. Human decision must be documented in State Ledger decisions array.

### Related skills
- `human-escalation-skill`

### Source mapping
- `schemas/human_escalation.schema.json`
- `templates/Human_Escalation_Request.md`
- `checklists/human_escalation_checklist.md`

---

## Card 009 — Risk Register

### Summary
The risk register tracks all project risks with: ID (RISK-NNN), description, severity (CRITICAL/HIGH/MEDIUM/LOW), likelihood, category (9 options), status (OPEN/MITIGATED/ESCALATED/ACCEPTED/CLOSED), mitigation, and owner. CRITICAL risks require mitigation or escalation. Accepted CRITICAL risks require human approval.

### When to apply
- When an agent reports a new risk in their handoff package
- When a risk's severity or status changes
- Before every gate decision (check for open CRITICAL risks)

### Operational rule
Any open CRITICAL risk with no mitigation blocks any gate. The Tech Lead cannot self-accept a CRITICAL risk. Risk IDs must be sequential and zero-padded: RISK-001, RISK-002, etc.

### Related skills
- `risk-register-management-skill`

### Source mapping
- `schemas/risk_register.schema.json`
- `templates/Risk_Register.md`
- `examples/good_state_ledger.json`

---

## Card 010 — Golden Model (Tech Stack)

### Summary
The mandatory technical standard for all projects built by this factory. Non-negotiable without an approved ADR. Key elements: Next.js 16 (App Router, proxy.ts), React 19, TypeScript 5, PostgreSQL/Supabase, Prisma 7 (migrate deploy for staging/prod), Vercel, NextAuth v5 + Google OAuth, Tailwind CSS v4, Zod, Vitest, Playwright, Recharts v3, Vercel Cron.

### When to apply
- Architecture validation (Gate 2)
- Any technology discussion
- Any code review for Golden Path compliance
- ADR evaluation

### Operational rule
No deviation from the Golden Model is accepted without a formal ADR. The most common violations to watch for: middleware.ts (use proxy.ts), `prisma db push` in production (use `prisma migrate deploy`), Pages Router (use App Router), non-idempotent jobs.

### Related skills
- `adr-governance-skill`
- `artifact-contract-validation-skill`

### Source mapping
- `context/reference_architecture_generico.md` (compiled into context_view.md)
- `agent_config.json` — `tech_stack_governance`

---

## Card 011 — DORA Metrics

### Summary
Four key metrics from Accelerate/DORA research that predict software delivery performance: (1) Deployment Frequency — how often code deploys to production; (2) Lead Time for Changes — time from commit to production; (3) Change Failure Rate — % of deployments causing incidents; (4) MTTR (Mean Time to Restore) — time to recover from failure. Elite performers deploy multiple times/day with <1h lead time, <5% failure rate, <1h MTTR.

### When to apply
- Gate 6 (deploy) and Gate 7 (post-deploy) health assessments
- State Ledger metrics section

### Operational rule
Target elite/high DORA performance. Declining trends register as risks. Two consecutive poor gates require human escalation.

### Source mapping
- Módulo 10 — Métricas (course material, build-time only)
- Accelerate — Forsgren, Humble, Kim (lib/TechLead/)
- `knowledge/decision_rules.md` — DR032, DR033, DR034

---

## Card 012 — IT Governance vs IT Management

### Summary
IT Governance (who decides and how accountability is set) vs IT Management (day-to-day execution of decisions). In the context of the AI Software Factory: Governance = gate structure, ADR policy, human escalation triggers, risk thresholds. Management = agent routing, artifact validation, State Ledger maintenance. The Tech Lead exercises both but must distinguish them — governance decisions often require human override capability.

### When to apply
- When a decision has policy-setting implications (governance) vs execution implications (management)

### Operational rule
Governance decisions that set precedents (new ADR approval, new risk threshold, pipeline rule change) must be logged as policy decisions in the State Ledger — not as ordinary gate decisions.

### Source mapping
- Módulo 12 — Governança de TI (course material, build-time only)
- ISO 38500
- `knowledge/principles.md` — P12
- `knowledge/decision_rules.md` — DR036

---

## Card 013 — SWEBOK Knowledge Areas (relevant to Tech Lead)

### Summary
The Software Engineering Body of Knowledge defines 15 knowledge areas. Most relevant to Tech Lead: Requirements (Gate 1), Design (Gate 2), Construction (Gate 3–4), Testing (Gate 4), Maintenance, Configuration Management (versioning/ADRs), Engineering Management (gates/metrics), Engineering Process (pipeline), Quality (Gates 4–5), Security.

### When to apply
- When assessing completeness of an agent's output — each knowledge area maps to one or more gates

### Operational rule
A complete SDLC pipeline should cover all relevant SWEBOK areas. Gaps in the factory's coverage (e.g., no formal Maintenance agent) should be registered as known limitations.

### Source mapping
- Módulo 10 — SWEBOK (course material, build-time only)
- `quality_gate.md` — gate-to-knowledge-area mapping
