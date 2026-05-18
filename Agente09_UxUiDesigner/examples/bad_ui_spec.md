# BAD UI Spec Example
## Why this is a BAD example — annotated with failure modes

---

# DEFECTS IN THIS EXAMPLE:
# 1. No TypeScript props interface (FM-05)
# 2. "Show loading spinner" — no skeleton spec (FM-01, FM-05)
# 3. Hardcoded hex colors — #3B82F6, #EF4444, etc. (token violation)
# 4. No empty state designed (FM-01)
# 5. No accessibility section (P8 violation)
# 6. Responsive behavior is "make it responsive" — not specific (FM-05)
# 7. Copy text is placeholder text, not final (FM-05)
# 8. Interactive element states not specified

---

# UI Specification
## Feature: Tasks
## Date: 2026-05-17

---

## Task List Component

This component shows a list of tasks for the user.

### States

#### Loading
Show a loading spinner in the middle of the page while the data loads.

#### Error
Show an error message if something goes wrong.

#### Populated
Show the list of tasks. Each task has a name, status, and due date.
Make it look clean and professional.

---

### Props

The component receives tasks from the API. It should handle the task data properly.

---

### Styling

Use blue (#3B82F6) for the primary action button.
Use red (#EF4444) for overdue tasks.
Use green (#22C55E) for completed tasks.
Make the background white (#FFFFFF).

### Responsive

Make it mobile-friendly.

---

# ANNOTATION OF DEFECTS:

## No TypeScript Props Interface (FM-05 — CRITICAL)
"The component receives tasks from the API" is not a spec. Agente05_DevFrontend
cannot write TypeScript types from this description. Questions unanswered:
- What is the shape of each task object? (id? name? fields?)
- Is description nullable?
- What is the type of dueDate? (string? Date? ISO 8601?)
- Is projectId included or just projectName?
- What is the type of status? ('pending' | 'in_progress' | 'complete'? or boolean?)
- Are there pagination props (totalCount, currentPage, pageSize)?

Without a TypeScript interface, the developer invents all of this — creating a mismatch with the API.

## "Show a loading spinner" (FM-01, FM-05 — CRITICAL)
This is not a loading state spec. Problems:
1. Spinners don't prevent layout shift — when data arrives, the page reflows
2. No ARIA — `role="status"` and `aria-label` are missing (screen readers don't know the page is loading)
3. "In the middle of the page" — middle of what? The viewport? The content area? What is the background?

Correct approach: Skeleton matching the populated layout — card shapes, text placeholder bars, `animate-pulse`.

## "Show an error message if something goes wrong" (FM-01, FM-05 — CRITICAL)
Not a spec. Questions unanswered:
- What icon is shown?
- What is the exact heading text?
- What is the exact body copy? (must follow "What went wrong. What to do next." formula)
- Is there a retry button? What does it do?
- What is the ARIA role? (must be `role="alert"`)
- What token colors are used?

## No Empty State Designed (FM-01 — CRITICAL)
The spec has no empty state. When a new user visits `/tasks` for the first time,
they will see... nothing? A blank white area? That is what this spec produces.
The developer has no guidance on what empty looks like.

## Hardcoded Hex Values — CRITICAL VIOLATION
`#3B82F6`, `#EF4444`, `#22C55E`, `#FFFFFF` are all hardcoded hex values.
This violates the white-label design system rule:
1. These colors are Tailwind CSS specific colors, not the organization's brand
2. When this repo is forked for a client, these colors will not match the client's brand
3. There is no way to change them without manually hunting through spec files

Correct: `bg-primary-color` for the action button, `text-destructive` for overdue, `text-success` for complete, `bg-background` for the background.

## "Make it look clean and professional" — Not a Spec
This is design intent, not specification. It tells the developer nothing. Every developer will interpret "clean and professional" differently. This produces inconsistent output.

## "Make it mobile-friendly" — Not Responsive Spec (FM-05)
This tells the developer nothing. Correct spec:
- Mobile: single-column, full-width cards, hamburger nav, Load More instead of pagination
- sm: (640px+): two-column card grid
- lg: (1024px+): three-column grid, numbered pagination, sidebar visible

## No Accessibility Section (P8 violation — blocks submission)
Missing:
- No focus order specified
- No keyboard navigation behavior
- No ARIA labels on interactive elements
- No screen reader announcements for dynamic content
- Overdue status communicated only by red color — WCAG 1.4.1 violation (color as only indicator)

## "Make it look clean and professional" / "properly" — Vague Language
These phrases are mood board language, not implementation specifications. The measure of a good spec is: can Agente05_DevFrontend implement this without asking any clarifying questions?
The answer here is: NO. Every section raises unanswered questions.

## Correct gate outcome if this were submitted:
Status: BLOCKED_MISSING_STATES
Issues:
  1. FM-01: Loading state is a spinner with no skeleton spec or ARIA
  2. FM-01: Error state has no copy text, no icon, no retry button, no role="alert"
  3. FM-01: Empty state is completely missing
  4. Token violation: 4 hardcoded hex values (#3B82F6, #EF4444, #22C55E, #FFFFFF)
  5. BLOCKED_ACCESSIBILITY_VIOLATION: overdue uses only red color — no secondary indicator
  6. FM-05: No TypeScript props interface
  7. FM-05: Responsive behavior is "make it mobile-friendly" — no specific layout changes
Action required: Rewrite using UI_Spec template from templates/UI_Spec.md
