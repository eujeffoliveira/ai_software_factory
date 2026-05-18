# Screen States Specification
## Feature: [Feature Name]
## Date: [YYYY-MM-DD]
## Wireframe Reference: Wireframes.md §[Feature]
## UI Spec Reference: UI_Spec.md §[Feature]
## Designed by: Agente09_UxUiDesigner

> This document provides the full specification for all four states of every async component in the feature. States summarized in Wireframes.md are fully detailed here. Agente05_DevFrontend implements directly from this document.

---

## Component: [ComponentName — e.g., EntityListPage]
**Route**: `/entity/list`
**Async data**: Yes — fetches from `GET /api/entities`

---

### State 1: Loading

**When this state appears**: While the `GET /api/entities` API call is in progress. The screen transitions here immediately on mount, before data arrives.

**Implementation approach**: `loading.tsx` file in the Next.js App Router `/entity/list/` directory.

**Skeleton layout** (must mirror the populated state to prevent layout shift):

```
Loading Skeleton — EntityListPage

┌─────────────────────────────────────────────────────┐
│ [Title skeleton      ────────────]   [Button ──────]│
│ ──────────────────────────────────────────────────  │
│ [Search skeleton ──────────────────]  [···]  [···]  │
│                                                     │
│ ┌─────────────────────────────────────────────────┐ │
│ │ [Name ──────────────] [Badge ──]           [···]│ │
│ │ [Description placeholder ──────────────────]    │ │
│ │ [Date ───────]                                  │ │
│ └─────────────────────────────────────────────────┘ │
│ (repeat × 5 skeleton cards)                         │
└─────────────────────────────────────────────────────┘
```

**Skeleton implementation spec**:
- Skeleton card: `w-full h-[88px] bg-muted animate-pulse rounded-[radius]`
- Within each skeleton card:
  - Name line: `w-1/3 h-[16px] bg-muted-foreground/20 rounded`
  - Description line: `w-2/3 h-[12px] bg-muted-foreground/20 rounded mt-2`
  - Date line: `w-1/5 h-[12px] bg-muted-foreground/20 rounded mt-2`
- Title skeleton: `w-32 h-[28px] bg-muted animate-pulse rounded`
- Gap between skeleton cards: `gap-3`
- Show 5 skeleton cards regardless of actual expected count

**ARIA**:
- Container: `role="status"` `aria-label="Loading entities..."`
- Skeleton items: `aria-hidden="true"` (purely presentational)

**Delay behavior**: Show skeleton immediately — no artificial delay. Avoid 200ms delay in new implementations (causes perceived slowness).

---

### State 2: Error

**When this state appears**: When `GET /api/entities` returns a 5xx response, a network error, or a timeout. Does NOT appear for 4xx authorization errors (see Error Path 1 — Authentication Required in UX_Flow.md).

**Layout** (centered in the main content area, vertically centered in the available space):

```
Error State — EntityListPage

        [cloud-off icon — h-12 w-12 text-muted-foreground]

        We couldn't load your entities
        [text-lg font-semibold text-foreground]

        There was a problem fetching your data.
        This is usually temporary — please try again.
        [text-sm text-muted-foreground, centered, max-w-xs]

        [Try again]
        [Button variant="outline" — triggers refetch]
```

**Full component spec**:
- Outer container: `flex flex-col items-center justify-center gap-4 py-16`
- Icon: `cloud-off` from design system, `h-12 w-12 text-muted-foreground`
- Heading: "We couldn't load your entities" — `text-lg font-semibold text-foreground text-center`
- Body: "There was a problem fetching your data. This is usually temporary — please try again." — `text-sm text-muted-foreground text-center max-w-xs`
- Retry button: label "Try again" — `variant="outline"` — `onClick`: trigger refetch of `GET /api/entities`
  - `aria-label="Try loading entities again"`

**ARIA**: `role="alert"` on the outer container — announces the error message to screen readers immediately upon render.

**Never show**:
- HTTP status codes (500, 503, etc.)
- Internal error names (ECONNREFUSED, TypeError, etc.)
- Stack trace fragments
- "Error loading page" or any other generic non-informative message

---

### State 3: Empty

_EntityListPage has three distinct empty states depending on context. Design each separately._

---

#### Empty State A: New User / No Entities Exist

**When this state appears**: `GET /api/entities` returns `{ items: [], totalCount: 0 }` and there is no active search query or filter.

**Layout**:

```
Empty State A — No Entities

        [inbox icon — h-12 w-12 text-muted-foreground]

        No entities yet
        [text-lg font-semibold text-foreground]

        Create your first entity to get started.
        Entities appear here once you add them.
        [text-sm text-muted-foreground, centered, max-w-xs]

        [Create your first entity]
        [Button variant="default" — opens Create Entity modal]
```

**ARIA**: `aria-label="Create your first entity"` on the CTA button. Container: `role="region"` `aria-label="Empty entity list"`.

---

#### Empty State B: Search Returned No Results

**When this state appears**: `GET /api/entities?search=[query]` returns `{ items: [], totalCount: 0 }` and `searchQuery` is non-empty.

**Layout**:

```
Empty State B — Search Empty

        [search-x icon — h-12 w-12 text-muted-foreground]

        No results for "[searchQuery]"
        [text-lg font-semibold text-foreground]

        Try adjusting your search or check for typos.
        [text-sm text-muted-foreground, centered, max-w-xs]

        [Clear search]
        [Button variant="ghost" — clears searchQuery, re-fetches]
```

**Note**: The search query is rendered verbatim in the heading — sanitize display to prevent XSS (escape HTML entities).

---

#### Empty State C: Filter Returned No Results

**When this state appears**: `GET /api/entities?filter=[values]` returns `{ items: [], totalCount: 0 }` and `activeFilters` is non-empty.

**Layout**:

```
Empty State C — Filter Empty

        [filter-x icon — h-12 w-12 text-muted-foreground]

        No entities match your filters
        [text-lg font-semibold text-foreground]

        Try removing or changing your active filters.
        [text-sm text-muted-foreground, centered, max-w-xs]

        [Clear filters]
        [Button variant="ghost" — resets all activeFilters, re-fetches]
```

---

### State 4: Populated

**When this state appears**: `GET /api/entities` returns `{ items: [...], totalCount: N }` where `N > 0`.

**Summary**: See Wireframes.md §Screen 1 for structural layout.

Key populated state behaviors:
- Items render as `EntityCard` components in a `role="list"` container
- Pagination renders when `totalCount > pageSize` (pageSize = 20)
- Search input shows its current value when `searchQuery` is non-empty
- Active filters show highlighted state when `activeFilters` is non-empty
- "Showing X–Y of Z entities" meta text appears below the filter bar

**Transition from loading to populated**: No flash — skeleton maintains same layout dimensions as cards, so no layout shift occurs.

**Transition from populated to empty** (when user searches/filters to zero results): Animate out cards, animate in empty state B or C. Duration: 150ms ease-out.

---

## Component: [NextComponentName]

_Repeat the full state specification block above for each additional async component in this feature._

---

## State Summary Table

| Component | Loading | Error | Empty | Populated | Source |
|-----------|---------|-------|-------|-----------|--------|
| EntityListPage | loading.tsx skeleton (5 cards) | cloud-off icon + retry | 3 variants (A/B/C) | Card list + pagination | API: GET /api/entities |
| [ComponentName] | [skeleton description] | [error spec] | [empty spec] | [populated ref] | [data source] |
