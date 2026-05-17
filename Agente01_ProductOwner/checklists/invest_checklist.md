# INVEST Checklist

Use this checklist to evaluate whether each user story satisfies the INVEST criteria before including it in the PRD.

---

## I — Independent

_The story can be developed and delivered without depending on another story being completed first._

- [ ] This story does not require another specific story to be done first
- [ ] If a dependency exists, it has been made explicit and the dependency story is also in scope
- [ ] The story can be prioritized, moved, or deferred without breaking other stories
- [ ] The story does not share data or UI elements that force sequential development with another story

**Red flags:** "This story requires US-NNN to be done first" without documenting the dependency. Stories that are just sub-tasks of a larger story split incorrectly.

---

## N — Negotiable

_The story is not a fixed contract. Details are open to discussion between the Product Owner and the development team._

- [ ] The story describes the goal and benefit — it does not prescribe a specific UI layout or technical approach
- [ ] The acceptance criteria leave room for implementation flexibility
- [ ] The story can be re-scoped or adjusted if a simpler approach achieves the same benefit
- [ ] No wireframes or mockups are treated as requirements (they are guides, not mandates)

**Red flags:** "The button must be in the top-right corner and be blue." Stories that dictate exact UI components. Stories with implementation constraints that belong in the architecture phase.

---

## V — Valuable

_The story delivers value to a specific user or stakeholder. If it delivers no value on its own, it is not a user story._

- [ ] The "so that [benefit]" clause is a genuine business or user benefit — not a restatement of the action
- [ ] A real user persona is identified (not "user" or "system")
- [ ] Removing this story would be noticed by the user or stakeholder
- [ ] The story does not exist only to enable another story (that would make it a task, not a story)

**Red flags:** "As a developer, I want to set up the database so that data can be stored." No benefit stated. Benefit is the same as the action ("I want to log in so that I am logged in").

---

## E — Estimable

_The development team can estimate the effort required for this story._

- [ ] The story has enough detail that a developer can reason about the work involved
- [ ] There are no unknowns that would prevent estimation (if unknown, it becomes a spike or an OQ-NNN)
- [ ] The story is not so vague that the team could not agree on a size
- [ ] Domain-specific terms in the story are explained or linked to a business rule (BR-NNN)

**Red flags:** "As an admin, I want to configure the system so that it works correctly." Too vague to estimate. Story contains unresolved business logic that should be captured in BR-NNN first.

---

## S — Small

_The story is small enough to be completed in a single sprint (or equivalent time box)._

- [ ] The story describes one coherent piece of user-facing functionality
- [ ] The story is not an epic in disguise (if it contains "and" more than twice, consider splitting)
- [ ] The story can be verified as done or not done by end of sprint
- [ ] If the story feels "too big," candidate split points have been identified

**Red flags:** Stories with more than 5 acceptance criteria may be too large. Stories that cover an entire module or feature area. Stories with "and also" in the title or description.

---

## T — Testable

_The story has clear acceptance criteria that allow a tester or stakeholder to determine if it is done._

- [ ] Acceptance criteria follow Gherkin format (Given/When/Then)
- [ ] Every acceptance criterion has a deterministic outcome ("the system displays X" not "the system behaves correctly")
- [ ] Performance-related criteria have measurable thresholds
- [ ] No criterion uses ambiguous language: "fast", "easy", "friendly", "smooth", "appropriate"
- [ ] A QA engineer could write a test case from the acceptance criteria without asking clarifying questions

**Red flags:** "The UI should be intuitive." "The form should work." "Users should feel confident." Criteria that can only be verified subjectively.

---

## Scoring

After running through all six sections, count the criteria satisfied:

| INVEST Dimension | Criteria Satisfied | Total | Pass? |
|---|---|---|---|
| Independent | | 4 | |
| Negotiable | | 4 | |
| Valuable | | 4 | |
| Estimable | | 4 | |
| Small | | 4 | |
| Testable | | 5 | |

**Story passes INVEST when:** All 6 dimensions have at least 3 of 4 (or 4 of 5 for Testable) criteria satisfied, with no red flags present.

**Story fails INVEST when:** Any dimension has 2 or fewer criteria satisfied, or a red flag is present. Return the story for revision before including in the PRD.
