# Acceptance Criteria

**Project:** [PROJECT_NAME]
**Date:** [DATE]
**Version:** [VERSION]
**Stories Covered:** [COUNT]

---

## Format Guide

Each acceptance criterion uses Gherkin format:

```
Given [initial context / precondition]
When [action performed by user or system]
Then [expected observable outcome]
And [additional expected outcome, if needed]
```

**Naming convention:** AC-[STORY_ID_3DIGITS]-[SEQUENCE_2DIGITS]
**Example:** AC-001-01 = First criterion for US-001

**Scenario types required per story:**
- `[HP]` Happy Path — standard successful flow
- `[EC]` Edge Case — valid but unusual condition
- `[NS]` Negative Scenario — invalid input or unauthorized action

---

## US-001 — [STORY_TITLE]

_Story: As a [user], I want [action], so that [benefit]_

### AC-001-01 [HP] — [Scenario title]

```gherkin
Given [precondition describing the valid state]
When [user performs the primary action]
Then [system produces the expected result]
And [additional verifiable outcome]
```

**Acceptance Metric:** <!-- FILL: Any measurable threshold, e.g., "response in < 2s" -->

---

### AC-001-02 [EC] — [Scenario title]

```gherkin
Given [precondition with edge condition, e.g., boundary value]
When [user performs the action]
Then [system handles the edge case correctly]
```

**Acceptance Metric:** <!-- FILL: Specific metric or N/A -->

---

### AC-001-03 [NS] — [Scenario title]

```gherkin
Given [precondition]
When [user attempts an invalid or unauthorized action]
Then [system rejects the action]
And [user receives a clear error message: "[EXACT_MESSAGE_OR_FORMAT]"]
```

**Acceptance Metric:** N/A

---

## US-002 — [STORY_TITLE]

_Story: As a [user], I want [action], so that [benefit]_

### AC-002-01 [HP] — [Scenario title]

```gherkin
Given [precondition]
When [action]
Then [expected outcome]
```

**Acceptance Metric:** <!-- FILL -->

---

### AC-002-02 [EC] — [Scenario title]

```gherkin
Given [precondition with edge condition]
When [action]
Then [edge case result]
```

**Acceptance Metric:** <!-- FILL -->

---

### AC-002-03 [NS] — [Scenario title]

```gherkin
Given [precondition]
When [invalid action]
Then [rejection and error message]
```

**Acceptance Metric:** N/A

---

## US-003 — [STORY_TITLE]

_Story: As a [user], I want [action], so that [benefit]_

### AC-003-01 [HP] — [Scenario title]

```gherkin
Given [precondition]
When [action]
Then [expected outcome]
```

**Acceptance Metric:** <!-- FILL -->

---

### AC-003-02 [NS] — [Scenario title]

```gherkin
Given [precondition]
When [invalid action]
Then [rejection and error]
```

**Acceptance Metric:** N/A

---

## Coverage Summary

| Story | HP | EC | NS | Total Criteria |
|---|---|---|---|---|
| US-001 | AC-001-01 | AC-001-02 | AC-001-03 | 3 |
| US-002 | AC-002-01 | AC-002-02 | AC-002-03 | 3 |
| US-003 | AC-003-01 | — | AC-003-02 | 2 |
| **Total** | | | | **[COUNT]** |
