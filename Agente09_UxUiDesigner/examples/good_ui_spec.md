# GOOD UI Spec Example
## Why this is a good example:
# - TypeScript interface derived from API contract fields
# - All 4 states designed with exact copy text
# - Design tokens used throughout (no hardcoded hex)
# - Responsive behavior table with specific layout changes per breakpoint
# - Accessibility section with focus order, ARIA, and keyboard behavior
# - Interactive elements table covers all states
# - Charts fully specified per DR012

---

# UI Specification
## Feature: Task Management
## Date: 2026-05-17
## Implementation Target: Agente05_DevFrontend
## Wireframe Reference: Wireframes.md §Screen 1 — Task List
## UX Flow Reference: UX_Flow.md §Create Task

---

## Component: TaskListPage
**Route**: `/tasks`
**Type**: Server Component
**Justified by**: No browser API required; data fetched server-side; no real-time updates needed.

### Props Interface

```typescript
interface TaskListPageProps {
  // All fields verified against GET /api/tasks response schema in API_Contract.json
  tasks: Array<{
    id: string
    name: string                    // max 255 chars
    description: string | null      // max 500 chars; null if not set
    projectId: string
    projectName: string             // denormalized from join
    projectColor: string            // token name: "primary-color" or "secondary-color"
    dueDate: string | null          // ISO 8601 date (YYYY-MM-DD); null if not set
    isOverdue: boolean              // computed: dueDate < today AND status != 'complete'
    status: 'pending' | 'in_progress' | 'complete'
    createdAt: string               // ISO 8601 datetime
  }>
  totalCount: number
  currentPage: number
  pageSize: 20                      // Always 20 — paginated
  searchQuery: string | undefined   // Active search query, undefined if no search
  activeFilters: {
    projectIds?: string[]
    statuses?: Array<'pending' | 'in_progress' | 'complete'>
    overdue?: boolean
  }
}
```

---

### Loading State

- **Trigger**: While `GET /api/tasks` is resolving (Server Component suspense boundary)
- **Implementation**: `app/tasks/loading.tsx`
- **Skeleton layout**: 7 skeleton cards matching `TaskCard` dimensions
  - Each skeleton card: `w-full h-[72px] bg-muted animate-pulse rounded-[radius]`
  - Within each skeleton:
    - Name placeholder: `w-2/3 h-[16px] bg-muted-foreground/20 rounded`
    - Meta row placeholder: `w-1/3 h-[12px] bg-muted-foreground/20 rounded mt-2`
  - Gap between skeleton cards: `gap-3`
- **ARIA**: Container `role="status"` `aria-label="Loading tasks..."`
- **Skeleton items**: `aria-hidden="true"`

---

### Error State

- **Trigger**: `GET /api/tasks` returns 5xx or network failure
- **Icon**: `wifi-off` — `h-12 w-12 text-muted-foreground`
- **Heading**: "We couldn't load your tasks" — `text-lg font-semibold text-foreground`
- **Body**: "There was a problem connecting to the server. This is usually temporary — please try again." — `text-sm text-muted-foreground text-center max-w-xs`
- **Retry button**: Label "Try again" — `variant="outline"` — `aria-label="Try loading tasks again"` — triggers page reload via `router.refresh()`
- **Container**: `role="alert"` — announces to screen readers on render
- **Layout**: `flex flex-col items-center justify-center gap-4 py-16`

---

### Empty State

**Empty State A — No tasks yet (new user)**

- **Trigger**: `{ tasks: [], totalCount: 0 }` with no active search or filters
- **Icon**: `clipboard-list` — `h-12 w-12 text-muted-foreground`
- **Heading**: "No tasks yet" — `text-lg font-semibold text-foreground`
- **Body**: "Create your first task to start tracking your work. Tasks appear here once you add them." — `text-sm text-muted-foreground text-center max-w-xs`
- **CTA**: Button — "Create your first task" — `variant="default"` — `aria-label="Create your first task"` — opens Create Task modal

**Empty State B — Search returned no results**

- **Trigger**: `{ tasks: [], totalCount: 0 }` with `searchQuery` non-empty
- **Icon**: `search-x` — `h-12 w-12 text-muted-foreground`
- **Heading**: `No results for "${searchQuery}"` — escape HTML entities in the search query
- **Body**: "Try checking the spelling, or use fewer, broader words." — `text-sm text-muted-foreground text-center max-w-xs`
- **CTA**: Button — "Clear search" — `variant="ghost"` — clears `searchQuery`, re-fetches

**Empty State C — Filters returned no results**

- **Trigger**: `{ tasks: [], totalCount: 0 }` with any `activeFilters` non-empty
- **Icon**: `filter-x` — `h-12 w-12 text-muted-foreground`
- **Heading**: "No tasks match your filters" — `text-lg font-semibold text-foreground`
- **Body**: "Try adjusting your active filters to see more results." — `text-sm text-muted-foreground text-center max-w-xs`
- **CTA**: Button — "Clear all filters" — `variant="ghost"` — resets all `activeFilters`, re-fetches

---

### Populated State

See Wireframes.md §Screen 1 for full layout.

**Page Header section**:
- Page title "Tasks": `text-2xl font-bold text-foreground` as `<h1>`
- "+ New Task" button: `variant="default"` `aria-label="Create new task"` `className="bg-primary-color"`

**Controls Bar section**:
- Search: `<Input placeholder="Search tasks..." aria-label="Search tasks" />` with leading search icon
- Clear search: `<Button variant="ghost" aria-label="Clear search" onClick={clearSearch}>×</Button>` — visible only when search has value
- Filter dropdown: `aria-label="Filter tasks"` `aria-expanded={isOpen}` — opens multi-select panel
- Sort dropdown: `aria-label="Sort tasks by"` — options: Newest (default), Oldest, Due Date, Name A–Z, Name Z–A
- Active filter chips: `<Badge variant="secondary">Project Name <button aria-label="Remove Project Name filter">×</button></Badge>`
- Results count: `text-sm text-muted-foreground` — "[from]–[to] of [totalCount] tasks"

**Task Card**:
- Container: `role="listitem"` — hover background `bg-muted/50`
- Checkbox: `<Checkbox aria-label="Select task [task.name]" />` — for bulk actions (desktop only; hidden on mobile with `hidden sm:flex`)
- Task name: `text-base font-medium text-foreground truncate` — max 1 line, overflow ellipsis
- Overdue indicator: if `task.isOverdue`, show `<span className="text-destructive text-xs">Overdue</span>` icon `⚠` alongside due date — color + text + icon (not color alone, per DR006)
- Project badge: background `bg-secondary-color/10` text `text-secondary-color text-xs font-medium`
- Due date: `text-xs text-muted-foreground` — formatted "MMM DD, YYYY"; if null, not shown
- Action menu (···): `<Button variant="ghost" size="icon" aria-label={`Task actions for ${task.name}`} aria-haspopup="menu">`

---

### Interactive Elements

| Element | Component | States | Token | ARIA |
|---------|-----------|--------|-------|------|
| "+ New Task" button | Button/default | default: `bg-primary-color` / hover: `opacity-90` / active: `scale-95` / disabled: `opacity-50` | `primary-color` | `aria-label="Create new task"` |
| Search input | Input | default: `border` / focused: `ring-2 ring-primary-color` / filled: has × button | `border`, `primary-color` (focus ring) | `aria-label="Search tasks"` `placeholder="Search tasks..."` |
| Task checkbox | Checkbox | unchecked / checked: `bg-primary-color` / indeterminate / disabled | `primary-color` | `aria-label="Select task [task.name]"` |
| Action menu ··· | Button/ghost | default: `text-muted-foreground` / hover: `bg-muted` / open: `bg-muted` | `muted-foreground`, `bg-muted` | `aria-label="Task actions for [task.name]"` `aria-haspopup="menu"` `aria-expanded` |
| Pagination prev | Button/outline | default: `border` / hover: `bg-muted` / disabled: `opacity-50 cursor-not-allowed` | `border`, `bg-muted` | `aria-label="Go to previous page"` `aria-disabled={isFirst}` |
| Pagination next | Button/outline | default: `border` / hover: `bg-muted` / disabled: `opacity-50 cursor-not-allowed` | `border`, `bg-muted` | `aria-label="Go to next page"` `aria-disabled={isLast}` |

---

### Responsive Behavior

| Breakpoint | Layout Changes |
|------------|---------------|
| Mobile (default) | Single-column layout; hamburger nav; "+ New Task" full-width below title; search full-width; filter/sort chips side-by-side; task cards full-width, checkbox hidden, action menu opens bottom sheet; Load More button instead of pagination |
| sm: (640px+) | Checkbox appears on cards; filter and sort shown inline with search |
| md: (768px+) | No major changes; cards get `px-4` padding |
| lg: (1024px+) | Global nav visible (no hamburger); numbered pagination replaces Load More; "+ New Task" returns to top-right |
| xl: (1280px+) | Content constrained to `max-w-[1200px] mx-auto` |

---

### Accessibility

- **Focus order**: 1. Skip-to-main link → 2. Navigation links (Tab) → 3. User menu → 4. Page title (non-interactive) → 5. "+ New Task" button → 6. Search input → 7. Filter dropdown → 8. Sort dropdown → 9. First task checkbox → 10. First task name (interactive, opens detail) → 11. First task action menu → 12. Next task (repeat 9–11) → 13. Pagination controls
- **Keyboard**: Tab navigates; Enter on task card opens task detail (`/tasks/[id]`); Esc closes any open dropdown/menu; Arrow keys navigate dropdown options; Space toggles task checkbox
- **Screen reader**: `<ul>` with `role="list"` `aria-label="Tasks, [totalCount] total"` — screen readers announce count. Each `<li>` has `role="listitem"`. When search/filter changes results: `<p aria-live="polite">[N] tasks found</p>` updates dynamically.
- **Color independence**: Overdue tasks use `⚠` icon + "Overdue" text label + `text-destructive` token (not color alone per DR006). Task status uses text label + icon, not color alone.
- **Images**: No images in this component — avatars use text initials as fallback; if user photo used: `alt="[user.name]'s avatar"`

---

## Open Questions

None — all fields verified against `API_Contract.json` v1.2.

## Assumptions Made

| Assumption | Impact if Wrong |
|------------|----------------|
| `task.projectColor` returns a token name (`"primary-color"` or `"secondary-color"`), not a hex value | If it returns a hex, project badge coloring logic changes — frontend would need to map hex to token or use inline style |
| Pagination uses offset-based pagination (page number × page size) | If cursor-based pagination is used, `currentPage` and `totalCount` props change shape |
