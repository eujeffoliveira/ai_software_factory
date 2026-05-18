# UI Specification
## Feature: [Feature Name]
## Date: [YYYY-MM-DD]
## Implementation Target: Agente05_DevFrontend
## Wireframe Reference: Wireframes.md §[Feature]
## UX Flow Reference: UX_Flow.md §[Feature]
## Designed by: Agente09_UxUiDesigner

> This document is the implementation contract for Agente05_DevFrontend. Every component, state, copy text, design token, ARIA label, and responsive behavior must be specified completely. If Agente05 would need to make a design decision to implement any part of this spec, the spec is incomplete.

---

## Component: [ComponentName] (e.g., EntityListPage)

**Route**: `/entity/list`
**Type**: Server Component
**Justified by**: _N/A — Server Component is the default. Mark Client Component only when justified by interactivity, browser API, or real-time updates._

### Props Interface

```typescript
interface EntityListPageProps {
  // All fields must exist in API_Contract.json or Architecture.md Prisma schema
  entities: Array<{
    id: string
    name: string
    description: string | null
    category: string
    createdAt: string  // ISO 8601
    updatedAt: string  // ISO 8601
  }>
  totalCount: number
  currentPage: number
  pageSize: number        // Always 20
  searchQuery?: string    // Active search term, if any
  activeFilters?: string[] // Active filter values, if any
}
```

---

### Loading State

- **Trigger**: While `GET /api/entities` is resolving
- **Implementation**: `loading.tsx` file or `<Suspense>` boundary wrapping the list
- **Skeleton layout**:
  - 5 skeleton cards, each matching `EntityCard` dimensions: full-width, `h-[80px]`, `rounded-[radius]`
  - Within each skeleton card:
    - Title placeholder: `w-1/3 h-[16px] bg-muted animate-pulse rounded`
    - Description placeholder: `w-2/3 h-[12px] bg-muted animate-pulse rounded mt-2`
    - Meta placeholder: `w-1/4 h-[12px] bg-muted animate-pulse rounded mt-2`
  - Header skeleton: Single-line bar `w-48 h-[24px]` for the page title
- **ARIA**: Container `role="status"` `aria-label="Loading entities..."`
- **Delay**: Show skeleton after 200ms to avoid flash on fast loads

---

### Error State

- **Trigger**: `GET /api/entities` returns 5xx or network timeout
- **Icon**: `cloud-off` — size `h-12 w-12`, color `text-muted-foreground`
- **Heading**: "We couldn't load your entities" — `text-lg font-semibold text-foreground`
- **Body copy**: "There was a problem fetching your data. This is usually temporary — please try again." — `text-sm text-muted-foreground`
- **Retry button**: Label "Try again" — `variant="outline"` — triggers data refetch
- **ARIA**: Container `role="alert"` — announced immediately by screen readers

---

### Empty State

**Empty State A — No entities exist (new user / first visit)**

- **Trigger**: API returns `{ entities: [], totalCount: 0 }` with no active search or filter
- **Icon**: `inbox` — size `h-12 w-12`, color `text-muted-foreground`
- **Heading**: "No entities yet" — `text-lg font-semibold text-foreground`
- **Body copy**: "Create your first entity to get started. Entities appear here once you add them." — `text-sm text-muted-foreground`
- **CTA**: Button — "Create your first entity" — `variant="default"` — opens Create Entity modal
  - `aria-label="Create your first entity"`

**Empty State B — Search returned no results**

- **Trigger**: API returns `{ entities: [], totalCount: 0 }` with active `searchQuery`
- **Icon**: `search-x` — size `h-12 w-12`, color `text-muted-foreground`
- **Heading**: `No results for "[searchQuery]"` — `text-lg font-semibold text-foreground`
- **Body copy**: "Try adjusting your search or check for typos." — `text-sm text-muted-foreground`
- **CTA**: Button — "Clear search" — `variant="ghost"` — clears search input and re-fetches

**Empty State C — Filters returned no results**

- **Trigger**: API returns `{ entities: [], totalCount: 0 }` with active `activeFilters`
- **Icon**: `filter-x` — size `h-12 w-12`, color `text-muted-foreground`
- **Heading**: "No entities match your filters" — `text-lg font-semibold text-foreground`
- **Body copy**: "Try removing or changing your active filters." — `text-sm text-muted-foreground`
- **CTA**: Button — "Clear filters" — `variant="ghost"` — resets all active filters and re-fetches

---

### Populated State

_See Wireframes.md §Screen 1 for structural layout._

The populated state renders the entity list. Key elements:

**PageHeader**:
- Left: Page title "Entities" — `text-2xl font-bold text-foreground`
- Right: "+ New Entity" button — `variant="default"` `aria-label="Create new entity"`

**SearchBar**:
- Input — `placeholder="Search entities..."` `aria-label="Search entities"`
- Icon: `search` left-aligned inside input
- Clear button: × appears when input has text — `aria-label="Clear search"`

**EntityCard** (repeating):
- Entity name: `text-base font-medium text-foreground` — truncated at 1 line with `text-ellipsis overflow-hidden`
- Description: `text-sm text-muted-foreground` — truncated at 2 lines
- Category badge: `bg-secondary-color/10 text-secondary-color text-xs font-medium px-2 py-0.5 rounded`
- Date: `text-xs text-muted-foreground` — formatted "MMM DD, YYYY"
- Action menu (···): `aria-label="Entity actions for [entity.name]"` — opens dropdown: Edit / Delete

**Pagination**:
- `aria-label="Pagination"` on the nav element
- Current page: `bg-primary-color text-white` (uses token)
- Other pages: `variant="outline"`
- Prev / Next: disabled at boundaries with `aria-disabled="true"`
- Text: "Showing [from]–[to] of [totalCount] entities" — `text-sm text-muted-foreground`

---

### Interactive Elements

| Element | Component Type | States | Design Token | ARIA |
|---------|---------------|--------|-------------|------|
| "+ New Entity" button | Button/default | default / hover / active / disabled | `bg-primary-color` | `aria-label="Create new entity"` |
| Search input | Input | default / focused / filled / cleared | `border` focus `ring-primary-color` | `aria-label="Search entities"` placeholder="Search entities..." |
| Filter dropdown | Select | closed / open / active-filters | `bg-background border` | `aria-label="Filter entities"` `aria-expanded` |
| Sort dropdown | Select | closed / open / selected | `bg-background border` | `aria-label="Sort entities by"` |
| Entity card | div[role=listitem] | default / hover | `bg-background` hover `bg-muted/50` | (see Accessibility section) |
| Action menu ··· | Button/ghost | default / hover / open | `text-muted-foreground` | `aria-label="Entity actions for [name]"` `aria-haspopup="menu"` |
| Pagination prev/next | Button/outline | default / hover / disabled | `border` | `aria-label="Go to previous page"` / `"Go to next page"` |

---

### Responsive Behavior

| Breakpoint | Layout Changes |
|------------|---------------|
| Mobile (default, < sm:) | Single-column card list; hamburger nav; Search and Filter stack vertically; "+ New Entity" full-width below title; Load More replaces pagination |
| sm: (640px+) | Filter and Sort appear inline with Search; cards remain single-column |
| md: (768px+) | No major change; cards get slightly more padding |
| lg: (1024px+) | Full header navigation visible (no hamburger); sidebar may appear if applicable; numbered pagination replaces Load More |
| xl: (1280px+) | Content max-width constrained to 1200px; cards may go 2-column in large viewports |

---

### Accessibility

- **Focus order**: 1. Global navigation (Tab) → 2. Page title → 3. "+ New Entity" button → 4. Search input → 5. Filter → 6. Sort → 7. First entity card → 8. Card action menu → 9. Next entity card (repeat) → 10. Pagination controls
- **Keyboard**: Enter on entity card → navigates to `/entity/[id]`; Esc → closes any open dropdown or modal
- **Screen reader**: List container `role="list"` `aria-label="Entities, [totalCount] total"`. Each card `role="listitem"`. Count update on search: `aria-live="polite"` region announces "[N] entities found"
- **Color independence**: Category badge — color + text label (not color alone). Action menu — icon + accessible label (not icon alone)
- **Images**: Entity icon — if using generic avatar: `alt=""` (decorative). If entity-specific image: `alt="[entity.name] icon"`

---

## Component: [NextComponentName]

_Repeat the template block above for each additional component in this feature._

---

## Charts (if applicable)

_If this feature includes a chart, use this block:_

### Chart: [ChartName — e.g., Entity Activity Over Time]

**Recharts Component**: `LineChart`
**Container**: `<ResponsiveContainer width="100%" height={300}>`
**Route**: `/dashboard`

**Data Interface**:
```typescript
interface EntityActivityData {
  date: string        // ISO 8601 date (YYYY-MM-DD), used as X-axis key
  count: number       // Entity actions on that date
}
```

**X-Axis**: `dataKey="date"` | Label: "Date" | Tick format: "MMM DD"
**Y-Axis**: `label="Actions"` | Unit: "" | Domain: `[0, 'auto']`
**Tooltip**: "Date: [formatted date] | Actions: [count]"
**Legend**: No legend (single series)
**Series**: `dataKey="count"` `stroke="primary-color"` `fill="primary-color"` `fillOpacity={0.1}`

**Empty State**: Same pattern as EntityListPage empty state A. Icon: `bar-chart-2`. Heading: "No activity data yet". Body: "Activity will appear here once entities are created and used."

---

## Open Questions

_List any design decisions that could not be finalized without additional input._

| ID | Question | Blocking | Directed To |
|----|----------|----------|------------|
| OQ-001 | [Question text] | Yes/No | [Agente01 / Agente02 / Tech Lead] |

---

## Assumptions Made

_List any assumptions made where the PRD or Architecture was silent._

| Assumption | Impact if Wrong |
|------------|----------------|
| [Assumption text] | [What would need to change] |
