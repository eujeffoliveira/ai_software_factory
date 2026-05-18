# BAD Wireframe Example
## Why this is a BAD example — annotated with failure modes

---

# DEFECTS IN THIS EXAMPLE:
# 1. Only desktop layout — no mobile wireframe (FM-04)
# 2. No state annotations (loading/error/empty not noted)
# 3. Vague component descriptions — "list of tasks here"
# 4. No component inventory
# 5. No SCREEN-NNN ID
# 6. Color specified in a wireframe (wireframes are structural only)
# 7. No UX Flow step references
# → Applies to: FM-04 (no mobile), FM-05 (vague spec)

---

# Wireframes
## Feature: Tasks
## Date: 2026-05-17

---

## Task Page

Desktop view:

```
+--------------------------------------------------+
|  Header with logo and navigation menu            |
+--------------------------------------------------+
|                                                  |
|  Tasks page title    [blue button: Add Task]     |
|                                                  |
|  Search box          Filter options              |
|                                                  |
|  List of tasks here                              |
|  (each one shows the task name and some info)    |
|                                                  |
|  Navigation at the bottom                        |
|                                                  |
+--------------------------------------------------+
```

---

# ANNOTATION OF DEFECTS:

## Missing Mobile Layout (FM-04 — CRITICAL)
There is no mobile wireframe. Agente05_DevFrontend will have to invent the entire
mobile layout. This is a design decision that belongs to the UX/UI Designer.

Questions left unanswered:
- Does the header collapse to a hamburger on mobile?
- Does the "+ Add Task" button stay in the header or move?
- Does the search move below the page title?
- Does the filter become a bottom sheet or dropdown?
- Does the task list change layout?
- What is the tap target for each task?

## Vague Component Descriptions (FM-05)
"List of tasks here" is not a spec. It tells the developer:
- How many tasks per page? (undefined)
- What does each task card show? (undefined — "task name and some info" is meaningless)
- How do users interact with a task? (click? tap? swipe?)
- Is there an action menu? Where is it?
- Is there a checkbox for bulk selection?

"Navigation at the bottom" — which navigation? Pagination? Load More? Tab bar?

## Color Specified in Wireframe (Wrong)
"blue button: Add Task" — wireframes do not specify colors. Colors are design tokens
defined in UI_Spec.md. Specifying "blue" here:
1. Is likely a hardcoded color (violation of design token rules)
2. Is premature (color is resolved at design system instantiation)
3. Conflicts with the purpose of wireframes (structural, not visual)

Correct: `[+ Add Task]` — no color mentioned; color is specified in UI_Spec.md.

## Missing State Annotations
The wireframe has no states section. The developer does not know:
- What shows while the task list is loading?
- What shows if the API fails?
- What shows if the user has no tasks yet?
- What shows when a search returns no results?

## No Component Inventory
There is no named component list. "List of tasks here" does not map to any
component in Architecture.md. The developer cannot cross-reference this wireframe
with the UI_Spec.

## No SCREEN-NNN ID
The screen has no ID. The Handoff Package cannot reference it. The UI_Spec
cannot link to it.

## Correct gate outcome if this were submitted:
Status: RETURNED_FOR_REVISION
Issues:
  1. FM-04: No mobile wireframe for Task List page — add mobile layout
  2. FM-05: Components are vague ("list of tasks", "some info") — specify component names
  3. Structural: Color specified in wireframe — remove; move to UI_Spec.md tokens
  4. Structural: States not annotated — add loading/error/empty/populated state notes
  5. Structural: No SCREEN-001 ID — add before re-submission
