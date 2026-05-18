# Agente09_UxUiDesigner — Decision Heuristics

> Distilled from build-time bibliography and Golden Path conventions. Heuristics are practical rules of thumb for navigating common design trade-offs. They are not absolute — use judgment when two heuristics conflict, and escalate to Tech Lead when uncertain.

---

## H1 — When uncertain about information hierarchy, use the "5-second rule"

**Question it answers:** Is this layout clear enough?

**Rule:** A user should be able to answer "What is this page for?" and "What can I do here?" within 5 seconds of landing on it. If the page title, primary action, and top content do not communicate this instantly, the hierarchy needs work.

**Application:** After sketching a wireframe, mentally simulate landing on the page cold. If the primary action and purpose are not immediately apparent from the wireframe structure alone, restructure before proceeding to UI_Spec.

---

## H2 — When choosing between familiar and novel, choose familiar

**Question it answers:** Should I use an established UI pattern or design something new?

**Rule:** Novel patterns impose a learning cost on every user. Unless the novel pattern provides a substantial UX benefit that cannot be achieved any other way, use the established convention. The benefit must outweigh the cost of learning.

**Application:** Before proposing any custom component, verify that no standard pattern (Button, Select, Modal, Breadcrumb, DataTable, Accordion, Tab) covers the need. If a standard pattern is 80% of the way there, customize it rather than starting from scratch.

---

## H3 — When a flow has a decision point, always document both branches

**Question it answers:** How detailed does UX Flow branching need to be?

**Rule:** Every `[DECISION: condition → A | B]` annotation in a UX flow creates two paths. Both must be documented. If only one path is documented, the UX flow is incomplete and the frontend developer will invent the other path.

**Application:** After completing the happy path, systematically ask: "What if the user is not authenticated?", "What if the API call fails?", "What if the list is empty?", "What if the user doesn't have permission?" Each answer becomes an error path or edge case.

---

## H4 — When designing a form, always work backward from the error state

**Question it answers:** What makes a form good?

**Rule:** The quality of a form's error handling is more important than the quality of its happy path, because errors are where users abandon. Design the error state for each field first (what goes wrong, what message appears, how does the field look), then design the success path.

**Application:** For each form field, write down the error scenario before the happy path: "User submits empty required field — what shows?", "User enters email without @-sign — what shows?", "User enters 500 characters in a 280-char field — what shows?" These answers go in the UI_Spec before anything else.

---

## H5 — When choosing between more features and less, choose less for the first release

**Question it answers:** How much should be in the first design?

**Rule:** Lean UX principle — design the minimum that lets users accomplish the core task. Additional features add complexity, delay implementation, and may not be needed. If a feature is not in the PRD, do not design it. If it seems essential, escalate and get it added to the PRD first.

**Application:** If a design instinct says "we should also add X" — check the PRD first. If X is not there, file an escalation (ESC-NNN) to Tech Lead and document the suggestion. Proceed without X until approved.

---

## H6 — When a screen has a list, always design the empty state before the populated state

**Question it answers:** Which state should I design first for a list screen?

**Rule:** The empty state is the first state a new user sees. It sets expectations, guides action, and represents the brand's voice. A good empty state turns a "nothing here" moment into a "here's how to get started" moment. Design it first so the populated state can reference it conceptually.

**Application:** Empty state = icon + heading (what's empty and why) + body copy (what they should do) + CTA (the action to take). Never just "No items found." That is not a design — it is an error message.

---

## H7 — When in doubt about accessibility, be more accessible, not less

**Question it answers:** Is this accessible enough?

**Rule:** When there is uncertainty about whether an accessibility measure is needed, include it. Adding an `aria-label` that wasn't strictly required has zero cost. Missing an `aria-label` that was required produces a WCAG AA violation. The asymmetry makes "more accessible" the dominant strategy.

**Application:** If uncertain whether a decorative icon needs an alt attribute: add `alt=""`. If uncertain whether a region needs an ARIA landmark: add `role="region"` with `aria-label`. If uncertain whether a live region needs `aria-live`: add `aria-live="polite"`.

---

## H8 — When two design options are equally usable, choose the one that reuses existing components

**Question it answers:** Should I use an existing component or build a new one?

**Rule:** Component reuse maintains visual consistency, reduces implementation cost, and leverages tested accessibility behavior. A new component is only justified when the existing component cannot cover the need even with configuration or variant selection.

**Application:** Explicitly check: does a Button cover this? Does a Card cover this? Does a Dialog cover this? Does a Select cover this? If yes to any of these: use the existing component and specify its props. Document the justification if a new component is genuinely needed.

---

## H9 — When writing copy for error states, explain what happened and what to do

**Question it answers:** What should error messages say?

**Rule:** Good error messages have two parts: (1) what went wrong in non-technical terms, and (2) what the user should do next. Bad error messages have only part 1 ("An error occurred"), or worse, expose technical details ("ECONNREFUSED: 127.0.0.1:5432").

**Application:** Error message template: "[What went wrong in plain language]. [What to do next]." Example: "We couldn't load your tasks right now. Try refreshing the page." Never: "Error 500: Internal Server Error" or "null is not an object."

---

## H10 — When sizing interactive elements for mobile, err toward larger

**Question it answers:** How big should touch targets be?

**Rule:** WCAG 2.5.5 recommends 44×44px minimum touch target. When an element is used frequently or is a primary action, make it larger. On mobile, users' thumbs vary greatly in size, and a target that seems "big enough" on a high-precision mouse is often too small for touch.

**Application:** Primary action buttons: `min-h-[48px]` on mobile. List item tap targets: full-width clickable area (not just the text). Icon buttons in tables: add adequate padding around the icon to meet the 44px threshold. Do not rely solely on visual size — the interactive area can extend beyond the visible element.

---

## H11 — When a flow requires multiple steps, show progress to the user

**Question it answers:** How should multi-step flows be designed?

**Rule:** Users who cannot see how long a process is will abandon it or feel anxious. Multi-step flows (wizards, onboarding, checkout) must show progress: a step indicator, progress bar, or breadcrumb showing where the user is and how many steps remain.

**Application:** Wizard flows: step indicator at the top ("Step 2 of 4: Contact Information"). Long forms: show section headers with progress indicator. For processes with unknown duration (file upload, background job): show a progress bar or indeterminate spinner with a status message.

---

## H12 — When designing for internationalization, leave room for text expansion

**Question it answers:** How do I future-proof text-heavy components?

**Rule:** Languages other than English typically require 30–40% more horizontal space for the same content. A layout designed tightly for English copy will break visually when translated. Design with enough breathing room for text to expand.

**Application:** Buttons: do not make the width exact to the English label — allow flex growth. Data table cells: allow text wrap rather than truncating at specific character counts. Error messages: do not place them in containers with fixed small widths.

---

## H13 — When choosing between icon-only and labeled controls, prefer labeled on first use

**Question it answers:** Should this control show only an icon or an icon with a label?

**Rule:** Icon-only controls save space but require users to already know what the icon means. On first use, or for non-standard icons, labels are essential. Progressive disclosure applies: on desktop with enough space, show icon + label; on mobile, icon only with tooltip on long press (but the icon must be standard enough to be recognized).

**Application:** Navigation: always label on desktop; acceptable to icon-only on mobile if icons are universally recognizable (home, search, profile, settings). Action buttons in forms: always labeled. Action icons in data table rows (edit, delete, view): label on hover/focus. Toolbar icons: tooltip on hover, accessible label always in `aria-label`.

---

## H14 — When a loading state takes longer than expected, communicate it actively

**Question it answers:** What if loading takes a long time?

**Rule:** Users tolerate waiting better when they know something is happening. For operations expected to take more than 2 seconds: show an active loading state. For operations expected to take more than 10 seconds: show a progress indicator or estimate. For background jobs: show async notification when complete.

**Application:** Skeleton loaders: for page-level data fetches (0.5–3 seconds). Spinner + message ("Processing your upload..."): for user-triggered actions (1–10 seconds). Progress bar with percentage: for uploads, large data operations. Toast notification: "Your export is ready. [Download]" for background completions.

---

## H15 — When designing destructive actions, create friction proportional to the consequence

**Question it answers:** How much confirmation is needed for a dangerous action?

**Rule:** The amount of friction before a destructive action should be proportional to the cost of undoing it. Soft-delete (recoverable): confirmation dialog. Hard delete (not recoverable): confirmation dialog with explicit warning about irreversibility. Account deletion or mass data deletion: type-to-confirm pattern.

**Application:**
- Archive (recoverable) → confirmation dialog: "Archive this item? You can restore it from the archive."
- Delete (not recoverable) → warning dialog: "Delete this item? This cannot be undone."
- Delete all data or account → type-to-confirm: "Type DELETE to confirm" — adds intentional friction.
- Single item delete with undo available → toast with undo link (no dialog needed, undo available for ~5 seconds).
