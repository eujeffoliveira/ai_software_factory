# Council Mediation Skill

## Purpose
Activate the Tech Lead Council (5 personas) to deliberate on a complex or contentious decision, synthesize their analyses, and produce a structured verdict with a clear recommendation.

## When to Use (Mandatory)
- Any architectural decision with long-term lock-in risk
- Any Golden Path deviation request (tech stack change)
- Any decision affecting more than 2 agents or 2 phases
- Disagreement between agents that cannot be resolved at agent level
- CRITICAL severity risk acceptance
- Any irreversible decision (data deletion, schema drop, major refactor)

## When to Use (Recommended)
- Novel technology being introduced not covered by Golden Model
- Performance vs. maintainability tradeoffs with no clear answer
- Make-or-buy decisions above a complexity threshold
- Security implications unclear

## Inputs
- `topic` — the question or decision to be deliberated
- `context` — background, current state, constraints
- `options` — 2–4 options to evaluate (each with pros, cons, risks)
- `affected_phases` — list of phases impacted
- `urgency` — LOW / MEDIUM / HIGH / CRITICAL
- `prior_decision` — any prior decision being revisited (if applicable)

## The 5 Council Personas

### 1. Contrarian
- Role: Challenge every assumption, identify hidden weaknesses
- Focus: What could go wrong? What are we overlooking?
- Output: Critique of each option's weakest points

### 2. First Principles Thinker
- Role: Strip away assumptions, reason from fundamentals
- Focus: What is the actual problem? Is this the simplest solution?
- Output: First-principles analysis of the core tradeoff

### 3. Expansionist
- Role: Consider the broadest impact — team, organization, future
- Focus: Long-term consequences, scalability, maintainability debt
- Output: Impact analysis across time horizons

### 4. Outsider
- Role: Industry perspective — what would a world-class team do?
- Focus: Best practices, anti-patterns, what successful teams avoid
- Output: Industry benchmarks and cautionary patterns

### 5. Executor
- Role: Practical implementation focus — what can actually be delivered?
- Focus: Team capacity, timeline, risk of over-engineering
- Output: Feasibility assessment and implementation path

## Outputs
- `persona_analyses` — 5 analyses, one per persona
- `consensus` — points all personas agree on
- `clashes` — explicit disagreements between personas
- `blind_spots` — risks identified that no option fully addresses
- `recommendation` — final recommendation with rationale
- `one_thing_to_do_first` — single most important next action
- `requires_human_decision` — boolean, true if Council cannot resolve

## Procedure

1. Frame the deliberation topic clearly
2. For each persona (in order): Contrarian → First Principles → Expansionist → Outsider → Executor
   - Analyze the topic from that persona's lens
   - Evaluate each option from that perspective
   - Identify the key concern or insight
3. Synthesize consensus points (where ≥ 3 personas agree)
4. Document clashes (where personas explicitly disagree on the recommendation)
5. Identify blind spots not covered by any option
6. Issue recommendation: which option, why, with what safeguards
7. State one_thing_to_do_first — the single most critical next action
8. Set `requires_human_decision = true` if: no consensus, CRITICAL risk, irreversible action, or political dimension

## Quality Gate
Every persona must produce an analysis — no persona can be skipped. The recommendation must reference the consensus and acknowledge the clashes.

## Failure Modes
- Only 1–2 options provided → request more options before proceeding
- Topic is too vague → request clarification before deliberation
- All 5 personas recommend different options → set `requires_human_decision = true`

## RAG Authorized
- `factory_architecture` — factory patterns and agent roles
- `golden_model` — tech stack standards
- `tech_literature` — Staff Engineer, Mythical Man-Month, Accelerate insights
- `quality_practices` — testing and delivery practices

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:

- its local files (`skill.md`, schemas, checklist, examples)
- `Agente00_TechLead/knowledge/` (especially `knowledge_cards.md` and `principles.md` for Council context)
- project artifacts provided as input

Any theoretical knowledge required by this skill (e.g., Accelerate DORA metrics, Brooks's Law, Staff Engineer archetypes) must be pre-distilled during build-time into `knowledge/`. The Council personas reason from distilled knowledge, not from runtime PDF access.
