# architecture-tradeoff-analysis-skill

## Purpose

Formally analyze and document trade-offs for significant architectural decisions by explicitly naming what is gained AND what is sacrificed. Trade-off analysis prevents binary "right/wrong" thinking and ensures that future engineers and agents understand the cost of each architectural choice. Output is written as a trade-off section in `Architecture.md` or `Architecture_Decisions.md`.

## When to Use

- When evaluating competing architectural approaches where the choice is not obvious
- When the Tech Lead Council is triggered because agents disagree on an architectural direction
- When a non-obvious trade-off exists between simplicity, performance, scalability, maintainability, or cost
- When an ADR is being authored and needs a formal consequences section
- When a stakeholder asks "why did we choose X instead of Y?"

## Inputs

- `Architecture.md` or a specific decision under review (as text excerpt)
- `knowledge/heuristics.md` — decision heuristics (H1–HN) for the current agent
- `knowledge/knowledge_cards.md` — reusable concept cards with trade-off principles
- `knowledge/decision_rules.md` — if-then rules (DR001–DRNNN) for architectural choices

## Outputs

- Trade-off analysis section written to `Architecture.md` (under "§ Trade-offs") or to `Architecture_Decisions.md` (under the relevant decision)
- Summary: decision name, alternatives compared, chosen option, explicit list of gains and sacrifices

## Procedure

1. **Name the decision clearly** — state the decision as a question: "Should we use X or Y for [context]?" The question form prevents premature closure.

2. **Enumerate alternatives** — list all viable alternatives (minimum 2). Include the Golden Path default even if it was already ruled out.

3. **Define evaluation criteria** — choose the criteria that matter for this specific decision. Common criteria sets:
   - **Performance vs. simplicity**: response time, throughput, code complexity, onboarding time
   - **Scalability vs. cost**: horizontal scale ceiling, infrastructure cost at current load, at 10x load
   - **Maintainability vs. flexibility**: lines of code, number of abstractions, ease of change, risk of abstraction leakage
   - **Security vs. developer experience**: attack surface, time-to-implement, audit log burden

4. **Score each alternative per criterion** — use a 3-level scale: HIGH / MEDIUM / LOW. Do not use numeric scores unless PRD has explicit metric thresholds.

5. **Identify the primary tension** — name the single core tension: e.g., "Simplicity vs. future scalability" or "Developer velocity vs. operational maturity."

6. **Write the trade-off statement** — for the chosen option:
   - What is gained: list specific, concrete benefits
   - What is sacrificed: list specific, concrete costs
   - Under what conditions does this trade-off look wrong in hindsight: state the trigger condition that would make this the wrong choice (e.g., "If MAU exceeds 500k within 18 months, this choice will require rework")

7. **Document the recommendation** — state whether the analysis supports the current Architecture.md decision or recommends a change. If recommending a change, state the next action (trigger ADR, escalate to Council).

8. **Write to output location** — append to `Architecture.md §Trade-offs` or `Architecture_Decisions.md`. Follow the template structure in `templates/TradeoffAnalysis_Template.md`.

## Quality Gate

The trade-off analysis passes this skill's quality check when:
- At least 2 alternatives are compared
- Both gains AND sacrifices are explicitly stated for the chosen option
- At least 1 concrete criterion with HIGH/MEDIUM/LOW scoring per alternative
- The primary tension is named (not implicit)
- The "wrong in hindsight" trigger condition is stated
- No binary "this is right / that is wrong" language — only trade-off language

## Failure Modes

- **Analysis without data:** Claiming "Option A is faster" without evidence → use "expected" framing and identify how to verify (benchmark, load test)
- **Only positives documented:** Writing gains but no sacrifices → the analysis is incomplete and misleading; always name the cost
- **Binary thinking:** Framing as "Option A is correct, Option B is wrong" → no option is correct in absolute terms; rephrase as "Option A is preferred given [criteria set]"
- **Missing trigger condition:** Not stating when the chosen option becomes the wrong option → always write "this choice is revisited if [condition]"
- **Criteria mismatch:** Using performance criteria for a decision that is primarily about security → choose criteria relevant to the decision context

## RAG Policy

Authorized collections at runtime:
- `software_architecture_fundamentals` (knowledge/knowledge_cards.md — architectural characteristics, fitness functions)
- `building_microservices` (knowledge/knowledge_cards.md — service decomposition trade-offs)
- `data_intensive_applications` (knowledge/knowledge_cards.md — consistency/availability/partition tolerance)

Blocked at runtime: `context/`, `lib/`, raw PDFs

## Architecture Compliance

This skill's output follows:
- `context_view.md §2` — Architectural Principles (P1–P8)
- `knowledge/heuristics.md` — decision heuristics for Agente02

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente02_SoftwareArchitect/knowledge/`
- `Agente02_SoftwareArchitect/context_view.md`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
