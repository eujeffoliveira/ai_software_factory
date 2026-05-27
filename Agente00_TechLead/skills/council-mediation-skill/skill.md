# Council Mediation Skill

## Purpose
Activate the Tech Lead Council (5 personas) to deliberate on a complex or contentious decision, synthesize their analyses, and produce a structured verdict with a clear recommendation.

## When to Use (Mandatory)
- Any architectural decision with long-term lock-in risk
- Any Golden Path deviation request (tech stack change)
- Any decision affecting more than 2 agents (distinct functional teams or services) or more than 2 phases (distinct lifecycle stages such as ingest → process → serve)
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
- `context` — background, current state, constraints, and measurable success criteria
- `options` — 3–4 options to evaluate (each with pros, cons, risks); minimum 3 required for meaningful deliberation
- `affected_phases` — list of phases impacted
- `urgency` — LOW / MEDIUM / HIGH / CRITICAL
- `prior_decision` — any prior decision being revisited (if applicable)

## Input Validation

Before running the Council, validate all inputs. If any condition below is true, **do not proceed** — respond with the specified error and wait for corrected input.

| Condition | Response |
|---|---|
| `topic` or `context` is missing | `INPUT_ERROR: missing [field]. Required: topic (question), context (background + success metrics + constraints).` |
| `topic` or `context` lacks concrete constraints or success metrics | `CLARIFY: Provide target metrics, stakeholders, and constraints (max 3 bullets) before deliberation.` |
| `options` has fewer than 3 entries | `INPUT_ERROR: Provide at least 3 distinct options (each with pros, cons, risks). Received: N option(s).` |
| `options` has more than 4 entries | `INPUT_ERROR: Provide at most 4 options. Consolidate options and resubmit.` |
| Any option is missing pros, cons, or risks | `INPUT_ERROR: Option "[name]" is missing [field]. Each option requires pros, cons, and risks.` |

## The 5 Council Personas

### 1. Contrarian
- Role: Challenge every assumption, identify hidden weaknesses
- Focus: What could go wrong? What are we overlooking?
- Output: Critique of each option's weakest points

### 2. First Principles Thinker
- Role: Strip away assumptions, reason from fundamentals
- Focus: What is the actual problem? Is this the simplest solution?
- Output: First-principles analysis of the core tradeoff. If the provided options do not address the core problem, state that explicitly: (a) explain why, (b) map each option to the core problem and evaluate remaining relevance, and (c) propose an alternative option if needed.

### 3. Expansionist
- Role: Consider the broadest impact — team, organization, future
- Focus: Long-term consequences, scalability, maintainability debt
- Output: Impact analysis across time horizons

### 4. Outsider
- Role: Industry perspective — what would a world-class team do?
- Focus: Best practices, anti-patterns, what successful teams avoid
- Output: Industry benchmarks and cautionary patterns drawn from pre-distilled knowledge in `Agente00_TechLead/knowledge/`. If external benchmarking is relevant but not available in distilled form, state: "External benchmark recommended but not pre-distilled — recommend human review."

### 5. Executor
- Role: Practical implementation focus — what can actually be delivered?
- Focus: Team capacity, timeline, risk of over-engineering
- Output: Feasibility assessment and implementation path

## Persona Analysis Schema

Each persona's analysis in `persona_analyses` must follow this structure (150–300 words per persona):

```
summary: 1–3 sentences describing the persona's overall assessment
key_concerns:
  - bullet list of top concerns
option_evaluations:
  <option_name>:
    pros: [list]
    cons: [list]
    risks: [list]
    confidence: low | medium | high
suggested_mitigation: (optional) one concrete mitigation if applicable
```

## Outputs
- `persona_analyses` — 5 analyses, one per persona (see Persona Analysis Schema above)
- `consensus` — points where ≥ 3 personas support the same recommendation or share the same critical concern
- `clashes` — explicit disagreements about recommendations or critical assumptions; each clash must include: (a) personas involved, (b) whether they recommend different options or the same option for different reasons, (c) a 1-sentence summary of the disagreement
- `blind_spots` — risks identified that no option fully addresses
- `recommendation` — final recommendation (100–200 words): which option, why, with what safeguards; must reference consensus points and acknowledge all clashes
- `one_thing_to_do_first` — one actionable step formatted as `"[Recommended owner role]: [Action] (due in X days)"`. Example: `"Tech Lead: Define data retention policy before schema migration (due in 3 days)"`
- `requires_human_decision` — boolean, true if Council cannot resolve (see Decision Procedure step 4)

## Decision Procedure

Apply rules in this exact order:

1. **Validate inputs** — run Input Validation table; stop and return error if any condition is triggered
2. **Run persona analyses** — execute all 5 personas in order: Contrarian → First Principles → Expansionist → Outsider → Executor; no persona may be skipped
3. **Compute consensus** — consensus = any recommendation or critical concern supported by ≥ 3 personas
4. **Set `requires_human_decision`** — set to `true` if **any** of the following:
   - Fewer than 3 personas support the same recommendation (no consensus)
   - `urgency` == CRITICAL
   - Any option is irreversible (e.g., data deletion, schema drop, migration with no rollback)
   - Decision affects more than 1 organizational stakeholder group (cross-team or cross-department impact)
5. **Identify blind spots** — risks not addressed by any option
6. **Issue recommendation** — select the option with strongest consensus support; if `requires_human_decision` is true, frame recommendation as advisory
7. **State `one_thing_to_do_first`** — using the format defined in Outputs

## Quality Gate
Every persona must produce an analysis — no persona can be skipped. The recommendation must reference the consensus and acknowledge all clashes. If `requires_human_decision` is true, the recommendation must explicitly state that human approval is required before action.

## Failure Modes
- Fewer than 3 options provided → trigger Input Validation error; do not proceed
- Topic or context is vague or lacks success metrics → trigger CLARIFY response; do not proceed
- All 5 personas recommend different options → set `requires_human_decision = true`; frame recommendation as advisory summary of tradeoffs

## Knowledge Access Policy

**Allowed runtime sources (exhaustive list):**
- Local skill files: `skill.md`, `input.schema.json`, `output.schema.json`, `checklist.md`, `examples/`
- `Agente00_TechLead/knowledge/` — especially `knowledge_cards.md`, `principles.md`, `heuristics.md`, `decision_rules.md`
- Project artifacts provided as inputs

**Disallowed at runtime:**
- Raw PDFs, raw books, `lib/`, `context/`, or any global build document

Any theoretical knowledge required by this skill (Accelerate DORA metrics, Brooks's Law, Staff Engineer archetypes, industry benchmarks) must be pre-distilled during build-time into `knowledge/`. The Council personas reason from distilled knowledge only. If a persona requires a benchmark not present in distilled knowledge, it must state that explicitly and recommend human review — it must not attempt to access external sources.

If unsure whether a source is allowed, default to disallowed.
