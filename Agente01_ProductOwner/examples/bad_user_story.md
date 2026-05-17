# Bad User Stories — INVEST Violations

_Three user stories with different violations, annotated to explain each problem._

---

## BAD-001 — Technical Task Disguised as a User Story

> **Story:** As a developer, I want to implement a PostgreSQL database schema for the appointments module, so that appointment data can be persisted.

<!-- PROBLEMA — V (Valuable): "As a developer" means this story delivers value to the development team, not to any business user or client. A user story must deliver value to an end user or stakeholder — not to the team building it. Remove this "story" entirely and route it to the Architect's execution plan. -->

<!-- PROBLEMA — N (Negotiable): "PostgreSQL database schema" and "appointments module" are implementation decisions, not a negotiable user goal. The schema design belongs in the Architecture phase, not in the PRD. This story embeds a technology decision that should be made by the Software Architect, potentially conflicting with the Golden Model. -->

<!-- PROBLEMA — T (Testable): "Data can be persisted" is not a user-observable outcome. There is no acceptance criterion that a QA engineer or stakeholder could verify from a user perspective. What does "persisted correctly" look like to a user? -->

**What the correct approach looks like:**
Remove this story from the PRD entirely. The corresponding user-visible requirement is captured in US-001 (booking) and US-002 (schedule view). Data persistence is an implementation concern for the Architecture phase.

---

## BAD-002 — Missing Business Benefit

> **Story:** As a client, I want to receive a confirmation email after booking, so that I receive a confirmation email after booking.

<!-- PROBLEMA — V (Valuable): The "so that" clause repeats the action verbatim. This is a red flag that the benefit was never identified. Why does the client want a confirmation email? The real benefit is: "so that I have a record of my booking details and can add it to my calendar." Without a real benefit, the team cannot evaluate whether the story is worth building or make informed trade-off decisions. -->

<!-- PROBLEMA — N (Negotiable): Without a clear benefit, the story cannot be negotiated. Does the team send a rich HTML email? A plain text email? A push notification? The lack of benefit makes all these choices arbitrary — the team cannot reason about which approach better serves the user's goal. -->

<!-- PROBLEMA — E (Estimable): "Receive a confirmation" could mean an instant push notification, a same-day email, a next-day digest, or a calendar invite. Without a stated benefit or metric, the team cannot estimate meaningfully. -->

**What the correct version looks like:**
> As a client, I want to receive a confirmation email after booking, so that I have my appointment details accessible and can add the event to my personal calendar without re-typing the information.

---

## BAD-003 — Too Large to Estimate and Not Independent

> **Story:** As an administrator, I want to manage the entire back-office of the scheduling system including user accounts, service types, business hours, reporting, integrations with third-party calendars, and billing configuration, so that the business operates efficiently.

<!-- PROBLEMA — S (Small): This story covers at minimum 6 separate features: user accounts, service types, business hours, reporting, calendar integrations, and billing. It would take multiple sprints to complete. A story this size cannot be planned, estimated, or demonstrated as a single unit. It is an epic and must be decomposed. -->

<!-- PROBLEMA — I (Independent): The billing configuration part likely depends on a payment integration not in scope. Calendar integrations depend on external APIs. These sub-features are not independent of each other or of external systems. Treating them as one story creates hidden dependencies. -->

<!-- PROBLEMA — E (Estimable): No development team can give a meaningful estimate for a story this broad. The "or" in "efficiently" leaves the definition of done entirely open. The team would spend more time debating scope than estimating. -->

<!-- PROBLEMA — T (Testable): "The business operates efficiently" cannot be tested. No acceptance criterion can be written for this outcome. There is no observable system state that indicates "efficient operation." -->

**What the correct approach looks like:**
Decompose into separate stories per capability:
- US-010: "As an administrator, I want to create and deactivate staff accounts, so that access to the scheduling system stays current with team membership."
- US-011: "As an administrator, I want to define the business's weekly operating hours, so that the booking interface only offers times when the business is open."
- US-012: "As an administrator, I want to view a monthly summary of appointment volumes by staff member, so that I can assess utilization and plan staffing."
Each of these is Independent, Small, Estimable, and Testable.
