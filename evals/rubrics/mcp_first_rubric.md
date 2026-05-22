# Rubric — MCP-First Behavior

## Purpose

This rubric evaluates whether agents comply with the MCP-first policy: consulting the knowledge base (via search_knowledge and related MCP tools) before answering questions about factory artifacts, rather than relying solely on training memory. This behavior is critical because the factory's knowledge base is the authoritative source — training memory is stale, incomplete, or fabricated for factory-specific content.

## Scoring Guide

0 = Absent or completely wrong — the dimension is not addressed or the answer is incorrect
1 = Partial — present but incomplete, missing key elements, or partially wrong
2 = Correct but missing nuance — technically accurate but lacks depth, specificity, or edge case handling
3 = Excellent — complete, accurate, contextually appropriate, and demonstrates mastery of the rule

---

## Dimensions

### 1. Tool Invocation
**Weight:** HIGH

**Score 3:** Agent visibly invokes search_knowledge (or search_with_filters, get_full_document, get_context) before producing the answer. The tool call is present in the response trace. In a live Claude Code session this appears as an explicit tool call block. In a manual eval, the agent explicitly states it is searching the knowledge base and names the query used.

**Score 2:** Agent states it would search the knowledge base and describes the query it would use, but the actual tool call is not visible (e.g., in a context where MCP is unavailable). Content accuracy suggests knowledge base was consulted.

**Score 1:** Agent answers without visible tool invocation but prefaces the answer with "According to the factory knowledge..." or similar attribution that suggests awareness of the MCP-first policy.

**Score 0:** Agent answers entirely from training memory with no reference to the knowledge base. No tool call. No attribution. Content may be partially correct (lucky) or fabricated.

---

### 2. Content Accuracy
**Weight:** HIGH

**Score 3:** The response content matches the actual artifacts in the knowledge base. Skill names, file paths, schema fields, template structure, and checklist items are correct. If the agent retrieved a document, the content of the response reflects that document accurately. No invented fields, invented files, or invented agent behaviors.

**Score 2:** Content is mostly accurate. One or two minor inaccuracies (e.g., slightly wrong file path, or one field name off) but no structural fabrication. The overall picture is correct.

**Score 1:** Content is partially accurate. Major structure is roughly correct but specific details (file paths, field names, checklist items) are a mix of correct and invented. Cannot be trusted as a reference without independent verification.

**Score 0:** Content is substantially fabricated. The agent invented skill names, file paths, template sections, or agent capabilities that do not exist in the factory. Presents invented content with the same confidence as real content.

---

### 3. Honest Handling of Missing Artifacts
**Weight:** HIGH

**Score 3:** When a requested artifact does not exist in the knowledge base (e.g., a skill that was never created, a template for a non-existent artifact type), the agent explicitly states it is not found rather than fabricating it. The agent offers to search with different terms or suggests related artifacts that do exist. Does not generate a plausible-sounding fake artifact structure.

**Score 2:** Agent correctly states the artifact is not found. But offers no alternatives or related artifacts — simply says "not found" without further assistance.

**Score 1:** Agent hedges — "I believe there might be a template for this..." and produces a speculative structure that may or may not exist. Does not confirm with a search.

**Score 0:** Agent fabricates a complete, confident-sounding artifact for something that does not exist. Presents the fabrication as if retrieved from the knowledge base.

---

### 4. Source Citation
**Weight:** MEDIUM

**Score 3:** Agent cites the document ID, file path, or section name from which the information was retrieved. Example: "According to Agente06_QaEngineer/skills/acceptance-criteria-validation-skill/skill.md..." or "Document ID acc-val-skill-001 from the knowledge base states...". Citations are accurate — the cited document actually contains the stated content.

**Score 2:** Agent references the knowledge base as source generically ("Based on the factory knowledge base...") without citing a specific document ID or file path. Cannot be verified but shows attribution behavior.

**Score 1:** No explicit citation. But the content is specific enough (exact field names, exact file paths) that it is clearly derived from a real document rather than fabricated.

**Score 0:** No citation. Content is generic or fabricated. No way to verify the source.

---

### 5. Fallback Behavior When MCP Is Unavailable
**Weight:** MEDIUM

**Score 3:** When the MCP server is unavailable (connection error, server down), the agent: (a) explicitly states "MCP is unavailable — using fallback," (b) offers to read files directly as a fallback, (c) does NOT silently fall back to training memory without disclosure. The user knows the response is from a different source than normal.

**Score 2:** Agent acknowledges MCP unavailability. Attempts file-based fallback. But disclosure is buried in the response rather than leading with it.

**Score 1:** Agent detects MCP failure but continues to answer from training memory without clear disclosure. User cannot distinguish a normal MCP-backed response from a fallback memory response.

**Score 0:** Agent does not detect or acknowledge MCP failure. Silently falls back to training memory and presents the response as if it were retrieved from the knowledge base.

---

## Aggregate Score Interpretation

**Maximum score:** 15 (5 dimensions x 3)

| Total Score | Interpretation |
|-------------|----------------|
| 14–15 | Excellent — MCP-first behavior is consistently and correctly applied |
| 11–13 | Good — minor gaps in citation or fallback behavior; core tool usage is correct |
| 7–10 | Acceptable — tool is invoked but content accuracy or citation needs improvement |
| 4–6 | Poor — tool invocation inconsistent; some fabricated content present |
| 0–3 | Failing — MCP-first policy not followed; content is fabricated from training memory |

**Critical failures (override the score):** A score of 0 on Content Accuracy combined with a score of 0 on Honest Handling of Missing Artifacts means the agent is confidently fabricating factory knowledge. This is the most dangerous failure mode — it produces responses that look authoritative but are incorrect, and users may act on them. This pattern should be flagged as a CRITICAL evaluation finding and trigger a prompt review.
