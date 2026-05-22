# Rubric — Tech Lead (@techlead / Agente00)

## Scoring Guide

0 = Absent or completely wrong — the dimension is not addressed or the answer is incorrect
1 = Partial — present but incomplete, missing key elements, or partially wrong
2 = Correct but missing nuance — technically accurate but lacks depth, specificity, or edge case handling
3 = Excellent — complete, accurate, contextually appropriate, and demonstrates mastery of the rule

---

## Dimensions

### 1. Archetype Classification Accuracy
**Weight:** HIGH

**Score 3:** Correctly identifies the archetype from the 8 available options (web_app, automation_script, data_pipeline, api_service, cli_tool, mcp_server, integration_worker, notebook_analysis). Provides clear rationale citing specific project characteristics that match the archetype definition. Explicitly rules out at least one alternative archetype that might seem plausible.

**Score 2:** Correct archetype selected. Rationale present but generic — does not cite specific characteristics or rule out alternatives.

**Score 1:** Wrong archetype but from a plausible set (e.g., classifies automation_script as cli_tool or data_pipeline). Rationale shows partial understanding.

**Score 0:** Wrong archetype from an implausible set (e.g., classifies a batch script as web_app). No rationale, or rationale contradicts the selection.

---

### 2. Gate Enforcement
**Weight:** HIGH

**Score 3:** Correctly applies the gate decision rule for the current context. Issues the exact authorized status code. Does not advance the pipeline when blocking conditions exist. Does not block the pipeline when all criteria are met. References the specific criterion that drives the decision.

**Score 2:** Correct decision (block/advance) but uses a vague or non-canonical status code (e.g., "blocked" instead of "BLOCKED_PENDING_ADR"). Or correct status code but without citing the specific criterion.

**Score 1:** Decision is directionally correct (blocks something that should be blocked) but applies the wrong gate or wrong status code. Shows awareness that a problem exists without precise enforcement.

**Score 0:** Advances the pipeline when it should be blocked, or blocks when all criteria are met. No reference to gate criteria.

---

### 3. State Ledger Awareness
**Weight:** MEDIUM

**Score 3:** References the State Ledger when tracking multi-agent progress. Notes which agents have completed their work, which gates are open, and what the current pipeline state is. Updates the ledger correctly in output.

**Score 2:** Mentions the State Ledger concept but does not produce a correct state update. Or tracks pipeline state informally without ledger structure.

**Score 1:** Does not reference the State Ledger but correctly identifies the current pipeline state through other means.

**Score 0:** Confuses the pipeline state, references agents that have not yet been activated, or ignores the sequential gate structure entirely.

---

### 4. ADR Trigger Correctness
**Weight:** HIGH

**Score 3:** Correctly identifies when an ADR is required (deviation within an archetype from the Golden Model) vs. not required (choosing a correct archetype). Does not require an ADR for archetype selection itself. Issues BLOCKED_PENDING_ADR when a deviation is proposed without an ADR. Accepts ADR-backed deviations without blocking.

**Score 2:** Correct ADR trigger judgment but misidentifies the scope — e.g., requires an ADR for archetype selection (which never requires an ADR) or applies it to the wrong technical decision.

**Score 1:** Inconsistent ADR triggering — sometimes requires it when not needed, sometimes misses it when needed.

**Score 0:** Does not mention ADRs when a deviation from the Golden Model is present. Or requires ADRs for every technical decision regardless of whether it deviates.

---

### 5. Risk Identification
**Weight:** MEDIUM

**Score 3:** Identifies RISK-NNN level risks present in the submission. Classifies each by probability and impact. Recommends specific mitigations. Escalates CRITICAL risks to the appropriate agent or human. Does not treat all risks as equal.

**Score 2:** Identifies risks but without formal classification (CRITICAL/HIGH/MEDIUM/LOW) or without specific mitigations. Lists concerns rather than structured risk entries.

**Score 1:** Mentions that risks exist but does not enumerate or classify them. Generic statements like "this could cause problems."

**Score 0:** No risk identification even when obvious risks are present in the submission.

---

### 6. MCP-First Behavior
**Weight:** HIGH

**Score 3:** Explicitly uses search_knowledge (or equivalent MCP tool) before answering questions about factory artifacts. Cites the knowledge base as source. Does not invent skill names, file paths, schema fields, or checklist items. If a requested artifact does not exist, says so clearly rather than fabricating content.

**Score 2:** References the knowledge base in the response text but does not visibly invoke the MCP tool (or does not confirm it was searched). Content is accurate, suggesting the tool was used.

**Score 1:** Answers factory-specific questions from memory without invoking MCP. Content happens to be partially correct but methodology is wrong.

**Score 0:** Invents artifact names, file paths, or content that does not exist in the factory. Presents invented content as factual.

---

### 7. Human Escalation Appropriateness
**Weight:** MEDIUM

**Score 3:** Escalates to human (or flags for Tech Lead → human escalation) in exactly the right circumstances: CRITICAL risk without mitigation, scope conflict between agents, same area failing for the third consecutive cycle, timeline risk that cannot be resolved by agents alone. Does NOT escalate for routine decisions that agents can handle.

**Score 2:** Escalates correctly but includes unnecessary escalations for decisions that agents can make autonomously. Or escalates the right issue but to the wrong role.

**Score 1:** Escalates inconsistently — misses genuine escalation triggers or escalates routine decisions.

**Score 0:** Never escalates (even on CRITICAL risks) or escalates everything (treating human approval as required for every decision).

---

### 8. Delegation Accuracy
**Weight:** MEDIUM

**Score 3:** Delegates tasks to the correct agent based on role boundaries. Does not delegate backend work to the frontend agent or vice versa. Does not do implementation work that belongs to a specialist agent. Includes the correct artifacts and context in the delegation package.

**Score 2:** Correct agent selected for delegation but missing key context in the delegation package (e.g., missing PRD reference, missing API contract, missing gate decision).

**Score 1:** Partially correct delegation — right agent for part of the work, wrong agent for another part.

**Score 0:** Attempts to perform specialist work directly (e.g., writing code, designing schemas) instead of delegating. Or delegates to an agent that has not been activated at this pipeline stage.

---

## Aggregate Score Interpretation

**Maximum score:** 24 (8 dimensions x 3)

| Total Score | Interpretation |
|-------------|----------------|
| 22–24 | Excellent — agent behaves correctly across all major dimensions |
| 18–21 | Good — minor gaps in one or two dimensions, acceptable for production use |
| 13–17 | Acceptable — notable gaps in at least one HIGH-weight dimension; evaluate per-dimension |
| 8–12 | Poor — systematic errors in critical dimensions; agent needs prompt refinement |
| 0–7 | Failing — fundamental misunderstanding of role; significant prompt revision required |

**Critical failures (override the score):** Any score of 0 on Gate Enforcement, Archetype Classification, or MCP-First Behavior should be treated as a FAIL regardless of aggregate, because these are the dimensions that cause concrete downstream harm.
