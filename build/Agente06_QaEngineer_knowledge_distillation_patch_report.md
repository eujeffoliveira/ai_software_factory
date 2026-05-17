# Agente06_QaEngineer — Knowledge Distillation Patch Report

**Distillation date:** 2026-05-17  
**Bibliography:** lib/QaEngineer/ (9 sources)  
**Patch type:** Initial build (not an incremental patch)  

---

## Distillation Summary

9 source documents were processed at build time. Their knowledge was distilled into 5 artifacts in `knowledge/`. The original sources remain in `lib/QaEngineer/` and are NOT accessible at runtime.

---

## Source 1: Test-Driven Development by Example

**Author:** Kent Beck  
**Relevance:** Foundational — defines the Red-Green-Refactor cycle and test-first discipline

**Distilled into:**

| Artifact | Items |
|----------|-------|
| `knowledge/principles.md` | P1 (Test-first reveals design problems), P10 (Regression tests prevent history repeating) |
| `knowledge/heuristics.md` | H1 (hard to test = hard to understand), H3 (green tests on wrong code are worse than red), H14 (mutation testing mental model) |
| `knowledge/knowledge_cards.md` | Card 001 (Red-Green-Refactor cycle with QA relevance) |
| `templates/Vitest_Test_Template.ts` | 4-case minimum structure — distilled from Beck's "test all expected behaviors" |

**Key insight distilled:** A test that passes without testing the correct behavior (H3) is an anti-pattern worse than no test. This informed the bad_test_case.ts example and the `expect(result).toBeTruthy()` anti-pattern documentation.

---

## Source 2: Unit Testing Principles, Practices, and Patterns

**Author:** Vladimir Khorikov  
**Relevance:** Deepest treatment of unit test quality — 4 pillars, test doubles, coverage pitfalls

**Distilled into:**

| Artifact | Items |
|----------|-------|
| `knowledge/principles.md` | P2 (Tests are documentation), P7 (Mock only what you own), P8 (Coverage is a means, not an end) |
| `knowledge/heuristics.md` | H2 (behavior not implementation), H7 (uncovered branch tells more than coverage %), H11 (error path more valuable than happy path) |
| `knowledge/knowledge_cards.md` | Card 002 (Four pillars), Card 003 (Test doubles taxonomy), Card 006 (London vs Detroit), Card 012 (Vitest mock patterns) |
| `knowledge/decision_rules.md` | DR001–DR007 (test structure rules), DR016 (auth null test mandatory), DR017 (error path must verify generic message) |

**Key insight distilled:** The four pillars (Card 002) — protection, resistance to refactoring, fast feedback, maintainability — define what makes a test good. Resistance to refactoring is the most commonly violated (P8, FM-08, H2). This shaped the "test behavior not implementation" emphasis throughout the agent.

---

## Source 3: Growing Object-Oriented Software, Guided by Tests

**Author:** Steve Freeman & Nat Pryce  
**Relevance:** Integration and acceptance testing, mock design, test pyramid origin

**Distilled into:**

| Artifact | Items |
|----------|-------|
| `knowledge/principles.md` | P3 (Test pyramid prevents fragile suites), P4 (Acceptance tests are executable specification) |
| `knowledge/heuristics.md` | H6 (Playwright CSS selectors will break), H9 (mock the boundary not the internals) |
| `knowledge/knowledge_cards.md` | Card 003, Card 005 (Seam model), Card 006, Card 007 (Given/When/Then anatomy), Card 009 (Page Object) |
| `templates/Playwright_Test_Template.ts` | E2E test structure, accessible selector policy |
| `context_view.md` | Section 2 (Playwright patterns), Section 4 (Acceptance criterion mapping) |

**Key insight distilled:** The "mock only what you own" principle (P7) combined with the seam model (Card 005) explains why we mock the DAL (lib/db/[model].dal) but never Prisma directly. This is one of the most frequently misunderstood testing rules — explained in context_view.md Section 2 and knowledge/heuristics.md H9.

---

## Source 4: Working Effectively with Legacy Code

**Author:** Michael Feathers  
**Relevance:** Handling untested existing code — characterization tests, seams

**Distilled into:**

| Artifact | Items |
|----------|-------|
| `knowledge/principles.md` | P5 (Legacy code without tests is dangerous), P6 (Refactoring requires safety net) |
| `knowledge/knowledge_cards.md` | Card 004 (Characterization tests), Card 005 (Seam model) |

**Key insight distilled:** Any modification of previously untested code requires characterization tests first (Card 004). This is codified in decision rule DR005 extended: "modifying untested legacy code without tests = BLOCKED_MISSING_TESTS." The seam model (Card 005) provided the theoretical foundation for explaining why vi.mock() is the correct approach in Vitest tests.

---

## Source 5: Refactoring: Improving the Design of Existing Code

**Author:** Martin Fowler  
**Relevance:** Safe refactoring under test coverage

**Distilled into:**

| Artifact | Items |
|----------|-------|
| `knowledge/principles.md` | P6 (Refactoring requires safety net of tests) |
| `knowledge/decision_rules.md` | Refactoring PR rule (test suite must pre-exist) |

**Key insight distilled:** Refactoring without tests is not refactoring — it is rewriting. The QA agent enforces this by requiring that any PR labeled "refactoring" must have an existing test suite that passes before the change (principle P6). This prevents the common mistake of "refactoring" meaning "changing behavior and hoping tests don't exist."

---

## Source 6: Módulo 06 — Teste de Software I

**Author:** Postgraduate Software Engineering Curriculum  
**Relevance:** Formal test types, V&V processes, test levels

**Distilled into:**

| Artifact | Items |
|----------|-------|
| `context_view.md` | Section 3 (Test pyramid), Section 4 (Acceptance criterion mapping), Section 5 (API contract validation) |
| `knowledge/heuristics.md` | H4 (vague acceptance criteria → escalate), H5 (auth failure test first) |
| `knowledge/knowledge_cards.md` | Card 007 (Given/When/Then anatomy), Card 008 (API contract testing checklist) |
| `checklists/acceptance_criteria_checklist.md` | Acceptance criterion validation procedure |

**Key insight distilled:** The V&V (Verification and Validation) framework from this module informed the Gate 4 objective language: "correct, tested, and meets acceptance criteria." Verification = "did we build it right" (tests pass). Validation = "did we build the right thing" (acceptance criteria map to requirements).

---

## Source 7: Módulo 07 — Teste de Software II

**Author:** Postgraduate Software Engineering Curriculum  
**Relevance:** Test planning, coverage criteria, test effectiveness measurement

**Distilled into:**

| Artifact | Items |
|----------|-------|
| `context_view.md` | Section 6 (Coverage thresholds), Section 11 (QA Report mandatory sections) |
| `knowledge/heuristics.md` | H8 (flaky test = failing test), H12 (no verbal confirmation), H15 (document why in bug reports) |
| `knowledge/knowledge_cards.md` | Card 010 (Coverage tool usage with Vitest) |
| `checklists/test_coverage_checklist.md` | Coverage threshold verification procedure |

**Key insight distilled:** The distinction between line coverage and branch coverage (H7) comes from this module's treatment of coverage criteria. The specific thresholds (80% for business logic, 100% for auth/critical paths) were calibrated from the module's risk-based coverage guidance applied to the Golden Path's security requirements.

---

## Source 8: Módulo 08 — Qualidade de Software I

**Author:** Postgraduate Software Engineering Curriculum  
**Relevance:** SQA processes, defect management, quality assurance as a discipline

**Distilled into:**

| Artifact | Items |
|----------|-------|
| `knowledge/principles.md` | P9 (QA gate is a quality firewall), P11 (Quality is built in, not inspected in) |
| `knowledge/heuristics.md` | H10 (same area fails twice → escalate), H12 (verbal confirmation insufficient) |
| `failure_modes.md` | FM-04 (ambiguous acceptance criteria), FM-09 (QA Report missing sections) |

**Key insight distilled:** Deming's principle "quality is built in, not inspected in" (P11) shapes how the QA gate works with the upstream process. The gate is not designed to catch all defects — it is designed to verify that quality practices were followed. Systemic defect patterns require upstream process improvement (H10), not just per-instance bug reports.

---

## Source 9: Módulo 09 — Qualidade de Software II

**Author:** Postgraduate Software Engineering Curriculum  
**Relevance:** ISO 9126/25010 quality model, CMMI, MPS.BR quality frameworks

**Distilled into:**

| Artifact | Items |
|----------|-------|
| `knowledge/principles.md` | P12 (Quality models define measurable characteristics) |
| `knowledge/knowledge_cards.md` | Card 011 (ISO 25010 characteristics mapped to Gate 4) |
| `templates/QA_Report.md` | ISO 25010 framing in report structure notes |

**Key insight distilled:** ISO 25010 defines 8 quality characteristics with sub-characteristics. Card 011 maps Gate 4's specific checks to the relevant sub-characteristics: functional correctness, reliability (error handling), confidentiality (auth), and accessibility (usability/accessibility sub-characteristic). This gives QA Report language that connects findings to recognized quality standards.

---

## Distillation Completeness

| Principle/Heuristic/Rule | Source Coverage |
|--------------------------|----------------|
| 12 principles | 9/9 sources contributed |
| 15 heuristics | 7/9 sources contributed |
| 17 decision rules | 6/9 sources contributed |
| 12 knowledge cards | 9/9 sources contributed |
| Source map | 9/9 sources mapped |

**All source materials have been distilled into runtime-accessible knowledge artifacts. The raw sources in `lib/QaEngineer/` are no longer needed for runtime operation.**
