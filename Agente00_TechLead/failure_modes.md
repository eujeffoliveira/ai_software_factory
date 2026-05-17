# Failure Modes — Tech Lead

## How to Use

When a failure mode is detected, apply the described action immediately. Do not proceed until the failure is resolved or escalated.

---

## FM-01 — Mandatory Artifact Missing

**Symptom:** Agent delivers a Handoff Package but the primary artifact for the phase is absent.

**Probable cause:** Agent skipped or partially completed their deliverable.

**Tech Lead action:**
1. Issue gate status: BLOCKED (do not assign an official gate code — just block).
2. Return artifact to the responsible agent with a correction request listing exactly what is missing.
3. Update State Ledger: blocked_tasks += [task], next_action = "return to [AgentID]".

**Next agent:** Same agent that produced the incomplete handoff.

**Requires human:** No.

---

## FM-02 — Handoff Package Incomplete

**Symptom:** Artifact was delivered but the Handoff Package is missing required fields (summary, risks, open_questions, checklist, or required_next_agent).

**Probable cause:** Agent did not follow the handoff contract.

**Tech Lead action:**
1. Do not process the gate.
2. Return with specific list of missing Handoff Package fields.
3. Note in State Ledger: "Handoff Package incomplete from [AgentID]".

**Next agent:** Same agent.

**Requires human:** No.

---

## FM-03 — PRD Missing Acceptance Criteria

**Symptom:** Gate 1 — PRD does not have BDD/Gherkin acceptance criteria for one or more user stories.

**Probable cause:** Product Owner wrote feature descriptions instead of testable criteria.

**Tech Lead action:**
1. Gate 1 status: NEEDS_MORE_REQUIREMENTS.
2. List the specific user stories that lack acceptance criteria.
3. Return to Product Owner with examples from `examples/bad_prd.md`.

**Next agent:** Agente01_ProductOwner.

**Requires human:** Only if product scope is genuinely unclear.

---

## FM-04 — Architecture Deviates from Golden Path Without ADR

**Symptom:** Gate 2 — Architecture includes technology choices or patterns that deviate from the Golden Model but no ADR exists.

**Probable cause:** Architect made an unsanctioned deviation.

**Tech Lead action:**
1. Gate 2 status: NEEDS_REVISION.
2. List each deviation and the corresponding ADR requirement.
3. Send `ADR_Request.md` to Software Architect.
4. Block gate until ADR is approved.

**Next agent:** Agente02_SoftwareArchitect.

**Requires human:** Yes, if the deviation involves significant cost, security, or compliance.

---

## FM-05 — Execution Plan Has Oversized Tasks

**Symptom:** Gate 3 — One or more tasks in the Execution Plan are too large, combining multiple concerns or multiple files.

**Probable cause:** Task Planner did not apply atomicity rules.

**Tech Lead action:**
1. Gate 3 status: NEEDS_TASK_SPLIT.
2. List the tasks that need decomposition with specific reasons.
3. Reference `checklists/task_atomicity_checklist.md` in the correction request.

**Next agent:** Agente03_SoftwareEngineer.

**Requires human:** No.

---

## FM-06 — QA Report Has Blocking Failures

**Symptom:** Gate 4 — QA Report status is FAIL_BLOCKING.

**Probable cause:** Critical acceptance criteria failed or critical bugs found.

**Tech Lead action:**
1. Gate 4 status: FAIL_BLOCKING.
2. Block pipeline immediately.
3. Create correction briefing for Dev Backend/Frontend with the exact failing items from the QA Report.
4. Update State Ledger with blocked_tasks.

**Next agent:** Agente04_DevBackend or Agente05_DevFrontend (based on failure domain).

**Requires human:** Only if the failure reveals a scope or architecture problem.

---

## FM-07 — Security Audit Blocked

**Symptom:** Gate 5 — Security Audit status is BLOCKED_SECURITY_RISK or BLOCKED_PRIVACY_RISK.

**Probable cause:** Critical vulnerability or data protection compliance violation found by DevSecOps.

**Tech Lead action:**
1. Gate 5 status: BLOCKED_SECURITY_RISK or BLOCKED_PRIVACY_RISK.
2. Immediately escalate to human with `Human_Escalation_Request.md`.
3. Block pipeline — do not route to DevOps.
4. Update State Ledger: human_approvals_required += [security risk decision].

**Next agent:** HUMAN (mandatory before any further action).

**Requires human:** Yes — always.

---

## FM-08 — Deployment Without Rollback Plan

**Symptom:** Gate 6 — Deployment Plan submitted without a Rollback Plan.

**Probable cause:** DevOps skipped the rollback requirement.

**Tech Lead action:**
1. Gate 6 status: NEEDS_ROLLBACK_PLAN.
2. Block deployment.
3. Return to DevOps with explicit requirement for `Rollback_Plan.md`.
4. Cite rollback plan mandatory policy from `context_view.md`.

**Next agent:** Agente08_DevOps.

**Requires human:** No — but production approval still required after rollback plan is provided.

---

## FM-09 — Gate Bypass Attempt

**Symptom:** An agent or user requests to skip a gate or advance without the mandatory artifact.

**Probable cause:** Timeline pressure, confusion about process, or intentional shortcut.

**Tech Lead action:**
1. Refuse the bypass. State clearly that gate skipping is not allowed.
2. Log the bypass attempt in State Ledger: decisions += [BYPASS_ATTEMPT_REFUSED].
3. Explain which artifact is missing and why it is required.
4. If the pressure comes from the user (human), explain the risk and offer to escalate to a formal decision.

**Next agent:** Agent responsible for the missing artifact.

**Requires human:** If user explicitly demands the bypass, escalate with risk explanation and request human decision.

---

## FM-10 — Inter-Agent Conflict

**Symptom:** Two agents have produced contradictory artifacts or recommendations (e.g., Architect and DevSecOps disagree on authorization approach).

**Probable cause:** Architectural ambiguity, scope gap, or different interpretation of requirements.

**Tech Lead action:**
1. Register conflict in State Ledger: risks += [inter-agent conflict on [topic]].
2. Analyze whether the conflict can be resolved by the existing architecture (context_view.md).
3. If resolvable: issue ruling with justification, brief both agents, update State Ledger.
4. If not resolvable: trigger Council.
5. If conflict involves irreversible decision: escalate to human.

**Next agent:** COUNCIL or HUMAN depending on severity.

**Requires human:** Yes if the conflict involves irreversible, costly, or security decisions.

---

## FM-11 — Human Approval Pending — Pipeline Stalled

**Symptom:** A gate requires human approval and the human has not yet responded.

**Probable cause:** Human is unavailable or request was not communicated clearly.

**Tech Lead action:**
1. Pipeline is blocked. Do not route to next agent.
2. Confirm that `Human_Escalation_Request.md` was delivered.
3. If request was delivered and no response received: report status to user, restate the specific question.
4. Do not make the irreversible decision on behalf of the human.

**Next agent:** HUMAN.

**Requires human:** Yes — this is the definition of this failure mode.

---

## FM-12 — Runtime Access to Blocked Source

**Symptom:** A request or operation requires reading from `context/`, `lib/`, or any blocked global source during runtime.

**Probable cause:** Agent is missing compiled context, or prompt engineering error.

**Tech Lead action:**
1. Refuse the access.
2. Log: "Attempted runtime access to blocked source [path]".
3. Look for the required information in `context_view.md` (compiled local view).
4. If the required information is genuinely absent from `context_view.md`, flag as a build gap.
5. Do NOT read from global context even if information is not in the local view.

**Next agent:** None (internal resolution).

**Requires human:** Only if the missing information is critical and blocks all progress.

---

## FM-13 — Post-Deploy Failure / Rollback Required

**Symptom:** Gate 7 — Post-Deploy Report status is ROLLBACK_REQUIRED or INCIDENT_OPENED.

**Probable cause:** Critical issue found in production after deployment.

**Tech Lead action:**
1. Gate 7 status: ROLLBACK_REQUIRED or INCIDENT_OPENED.
2. Escalate to human immediately.
3. Route to DevOps for rollback execution (per the pre-approved Rollback Plan).
4. Update State Ledger: risks += [production incident], human_approvals_required += [rollback decision].
5. Do not authorize rollback without human confirmation.

**Next agent:** HUMAN → then Agente08_DevOps.

**Requires human:** Yes — always for production rollback.

---

## FM-14 — Missing ADR for Critical Decision Already Made

**Symptom:** During gate review, the Tech Lead discovers that a critical Golden Path deviation was already implemented without an ADR.

**Probable cause:** ADR requirement was missed or overlooked by the Architect or Dev agent.

**Tech Lead action:**
1. Block gate regardless of other validation results.
2. Request retroactive ADR creation from Software Architect.
3. Document as a process gap in State Ledger: risks += [ADR retroactive required for [decision]].
4. Once ADR is created and approved: resume gate evaluation.

**Next agent:** Agente02_SoftwareArchitect.

**Requires human:** Yes if the deviation has significant cost, security, or compliance implications.

---

## FM-15 — Runtime Attempt to Access Raw Bibliography

**Symptom:** The agent or a skill attempts to read `01-bibliografia/`, raw PDFs, raw books, or global build documents during runtime.

**Probable cause:** The knowledge was not properly distilled during build-time, or a runtime instruction is trying to bypass the local knowledge boundary (e.g., "read Accelerate.pdf to answer this").

**Tech Lead action:**
1. Refuse the raw access path immediately.
2. Log: "Attempted runtime access to raw bibliography source [path]".
3. Look for the required information in `knowledge/` distilled artifacts:
   - `knowledge/principles.md`
   - `knowledge/heuristics.md`
   - `knowledge/decision_rules.md`
   - `knowledge/knowledge_cards.md`
4. If the required knowledge is not in `knowledge/`: use what is available and flag as a build gap.
5. Do NOT read raw PDFs, books, or `lib/` even if the concept is not in local distilled artifacts.

**Next agent:** None (internal resolution).

**Requires human:** Only if the missing knowledge is critical for a gate decision and cannot be approximated from existing local artifacts.

**Blocks flow:** Yes, if the missing knowledge is required for the current gate decision.

---

## FM-16 — Missing Distilled Knowledge

**Symptom:** The agent needs a concept, principle, or decision rule that exists only in raw bibliography and is absent from `knowledge/`.

**Probable cause:** The build did not extract enough knowledge into local artifacts. A new book was added to the bibliography after the last build, or a knowledge card was not generated for a needed concept.

**Tech Lead action:**
1. Do not read raw bibliography at runtime.
2. Use the closest available concept from `knowledge/` as an approximation.
3. Document the gap: "Knowledge gap — [concept] needed from [source] — not in knowledge/".
4. Request a build patch to update `knowledge/` with the needed distillation.
5. If the gap is blocking a critical gate: escalate to build operator through the Tech Lead workflow.

**Next agent:** Build operator (human).

**Requires human:** Yes if the gap blocks a gate decision.

**Blocks flow:** Depends on whether the knowledge is required for the current gate.
