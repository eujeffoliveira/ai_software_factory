# GOOD Wireframe Example
## Why this is a good example:
# - Both desktop and mobile layouts present
# - Component inventory named and complete
# - All four states annotated with specifics
# - Layout hierarchy clear from ASCII structure
# - No colors, fonts, or decorative specifications
# - Mobile-specific behavior notes included
# - SCREEN-NNN IDs used

---

# Wireframes
## Feature: Task Management
## Date: 2026-05-17
## UX Flow Reference: UX_Flow.md §Create Task
## Designed by: Agente09_UxUiDesigner

---

## Screen 1: Task List — `/tasks`
**SCREEN-001**
**UX Flow Steps**: Steps 1, 5
**Layout type**: Full page
**Layout zones**: [Global Header] + [Page Header] + [Controls Bar] + [Task List] + [Pagination]

---

### Desktop Layout (lg: and above)

```
PAGE: /tasks
LAYOUT: [Global Header] + [Main Content]

┌────────────────────────────────────────────────────────────────────────────────┐
│ GLOBAL HEADER                                                                   │
│ [Logo]     [Nav: Dashboard | Tasks | Projects | Settings]     [User Avatar ▼] │
├────────────────────────────────────────────────────────────────────────────────┤
│ PAGE HEADER                                                                     │
│ [Page Title: Tasks (h1)]                                       [+ New Task]   │
│ ──────────────────────────────────────────────────────────────────────────────  │
│ CONTROLS BAR                                                                    │
│ [Search: Search tasks...    🔍]      [Filter by Project ▼]  [Sort: Newest ▼]  │
│ [Active: Project A ×] [Active: Overdue ×]    "Showing 1–20 of 47 tasks"       │
│ ──────────────────────────────────────────────────────────────────────────────  │
│ TASK LIST                                                                       │
│                                                                                 │
│ ┌──────────────────────────────────────────────────────────────────────────┐   │
│ │ Task Card                                                                 │   │
│ │ [☐ Checkbox]  [Task Name (truncated, 1 line)]  [Project Badge]  [···]   │   │
│ │               [Due: MMM DD]  [Assigned: Avatar]                          │   │
│ └──────────────────────────────────────────────────────────────────────────┘   │
│ (repeat × 20 per page)                                                          │
│                                                                                 │
│ PAGINATION                                                                      │
│ [← Previous]   [1] [2] [3] ... [5]   [Next →]                                │
│ "Showing 1–20 of 47 tasks"                                                     │
└────────────────────────────────────────────────────────────────────────────────┘
```

**Component inventory**:
- `GlobalHeader` — logo, nav links, user avatar with dropdown (profile, sign out)
- `PageHeader` — h1 "Tasks" + primary "+ New Task" button
- `SearchBar` — search input with leading magnifying glass icon + clear (×) button
- `FilterDropdown` — "Filter by Project" multi-select dropdown
- `SortDropdown` — "Sort: Newest" single-select dropdown with sort options
- `ActiveFilterChips` — dismissible chips for each active filter (× to remove)
- `ResultsCount` — "Showing X–Y of Z tasks" text
- `TaskCard` — checkbox (bulk action) + task name + project badge + action menu + metadata row
- `ProjectBadge` — color-coded badge with project name
- `TaskActionMenu` (···) — dropdown: Edit, Mark complete, Move to project, Delete
- `Pagination` — prev/next + numbered pages + results count

---

### Mobile Layout (< sm:)

```
MOBILE: /tasks

┌──────────────────────────────────┐
│ GLOBAL HEADER                     │
│ [Logo]                    [☰]    │
├──────────────────────────────────┤
│ PAGE HEADER                       │
│ Tasks                             │
│ [+ New Task]  (full width, h-11) │
├──────────────────────────────────┤
│ CONTROLS                          │
│ [Search tasks...         🔍]     │
│ [Filter ▼]  [Sort ▼]  (inline)  │
│                                   │
│ [Project A ×]  [Overdue ×]       │
│ "47 tasks"                        │
├──────────────────────────────────┤
│ TASK LIST                         │
│                                   │
│ ┌──────────────────────────────┐ │
│ │ Task Card                    │ │
│ │ [Task Name (2 lines max)]    │ │
│ │ [Project Badge]  [Due date]  │ │
│ │                         [···]│ │
│ └──────────────────────────────┘ │
│ (repeat × N)                      │
│                                   │
│ [Load More Tasks ↓] (full width) │
│ "Showing 20 of 47"               │
└──────────────────────────────────┘
```

**Mobile-specific behavior**:
- Hamburger (☰) opens full-screen navigation drawer from left
- "+ New Task" is full-width sticky below page header on first scroll, then follows content
- Checkbox for bulk select is hidden on mobile (bulk actions not available on mobile)
- Task card (···) opens a bottom sheet with: Mark Complete / Edit / Delete
- Pagination replaced with "Load More Tasks" button with count
- Filter and Sort are side-by-side chips; tapping opens a bottom sheet for each

---

### States

| State | Description |
|-------|-------------|
| **Loading** | 7 skeleton cards, each full-width, `h-[72px]`, `animate-pulse`. Skeleton name block: `w-2/3 h-[16px]`. Skeleton meta: `w-1/3 h-[12px]`. Loading container: `role="status" aria-label="Loading tasks..."` |
| **Empty** | No cards. Centered empty state component. 3 variants: new-user (inbox icon + "No tasks yet" + CTA), search-empty, filter-empty. Full spec: Screen_States.md §TaskListPage |
| **Error** | No cards. Centered error state: `wifi-off` icon + "We couldn't load your tasks" + "Try again" button. `role="alert"`. Full spec: Screen_States.md §TaskListPage |
| **Populated** | The desktop wireframe above shows this state. Task cards with real data, pagination active, filter chips visible if filters applied. |

---

## Screen 2: Create Task Modal — `/tasks` (modal overlay)
**SCREEN-002**
**UX Flow Steps**: Steps 2, 3, 4
**Layout type**: Modal (desktop) / Bottom Sheet (mobile)
**Modal dimensions**: Desktop — `max-w-[480px]`, `max-h-[90vh]` scrollable; Mobile — full-width, slides from bottom

---

### Desktop Layout (lg: and above) — Modal

```
MODAL OVERLAY — Create Task

┌──────────────────────── Backdrop (dimmed overlay) ──────────────────────────────┐
│                                                                                   │
│   ┌─────────────────────────────────────────────────────────────────────────┐   │
│   │ [Dialog Header]                                                          │   │
│   │  Create Task                                                     [X]    │   │
│   │ ─────────────────────────────────────────────────────────────────────   │   │
│   │                                                                          │   │
│   │  Task Name *                                                             │   │
│   │  [Text Input — required — placeholder "Enter task name"]                │   │
│   │                                               [0/255 chars]              │   │
│   │                                                                          │   │
│   │  Description                                                             │   │
│   │  [Textarea — optional — 3 rows — placeholder "Add a description..."]    │   │
│   │                                               [0/500 chars]              │   │
│   │                                                                          │   │
│   │  Project *                                     Due Date                 │   │
│   │  [Select ▼ — required]                        [Date Picker ▼]          │   │
│   │                                                                          │   │
│   │ ─────────────────────────────────────────────────────────────────────   │   │
│   │  [Form-level error message — shown only on server error]                │   │
│   │                                                                          │   │
│   │  [Cancel]                                      [Create Task]            │   │
│   └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                   │
└───────────────────────────────────────────────────────────────────────────────────┘
```

---

### Mobile Layout (< sm:) — Bottom Sheet

```
MOBILE BOTTOM SHEET — Create Task

┌──────────────────────────────────┐
│  ─── [drag handle] ───           │
│  Create Task               [X]   │
│  ─────────────────────────────── │
│                                  │
│  Task Name *                     │
│  [Text Input (full width)]       │
│  0/255                           │
│                                  │
│  Description                     │
│  [Textarea (full width, 3 rows)] │
│  0/500                           │
│                                  │
│  Project *                       │
│  [Select ▼ (full width)]         │
│                                  │
│  Due Date                        │
│  [Date Picker ▼ (full width)]    │
│                                  │
│  [Form-level error — if any]     │
│                                  │
│  [Create Task]  (full width)     │
│  [Cancel]       (full width)     │
└──────────────────────────────────┘
```

**Mobile-specific behavior**:
- Bottom sheet slides up from screen bottom; drag handle at top
- Dismissible by dragging down or tapping outside
- Keyboard appears when input is focused; sheet shifts up to keep form visible
- Buttons stack vertically: primary first (Create Task), secondary below (Cancel)

---

### States

| State | Description |
|-------|-------------|
| **Default (empty form)** | All fields empty. Character counters show 0. Submit disabled. Cancel enabled. Focus on Task Name input. |
| **Valid — ready to submit** | Required fields filled. Submit enabled. |
| **Submitting** | Submit button: label "Creating..." with spinner. Form inputs `disabled`. Cancel hidden during submit. |
| **Error (server)** | Form-level error message: "We couldn't create your task. Please try again." Submit re-enabled. Inline field errors if applicable. |

---

## Wireframe Index

| Screen ID | Screen Name | Route | Mobile Layout | Desktop Layout | UX Flow Steps |
|-----------|-------------|-------|---------------|----------------|---------------|
| SCREEN-001 | Task List | /tasks | Yes (single column + load-more) | Yes (card list + pagination) | 1, 5 |
| SCREEN-002 | Create Task Modal | /tasks (modal) | Yes (bottom sheet) | Yes (dialog) | 2, 3, 4 |
