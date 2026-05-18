# Wireframes
## Feature: [Feature Name]
## Date: [YYYY-MM-DD]
## UX Flow Reference: UX_Flow.md §[Feature]
## Designed by: Agente09_UxUiDesigner

> These wireframes are structural specifications — they define layout, hierarchy, and component placement. They do not specify colors, fonts, or visual styling. Design tokens are specified in UI_Spec.md.

---

## Screen 1: [Screen Name] — [/route/path]
**UX Flow Steps**: [e.g., Steps 1, 2]
**Layout type**: Full page
**Layout zones**: [Header] + [Main Content] + [Optional Sidebar]

---

### Desktop Layout (lg: and above)

```
PAGE: /entity/list
LAYOUT: [Header] + [Main Content Area]

┌────────────────────────────────────────────────────────────────┐
│ HEADER                                                          │
│ [Logo]      [Nav: Home | Entities | Settings]      [Avatar ▼] │
├────────────────────────────────────────────────────────────────┤
│ MAIN CONTENT                                                    │
│                                                                 │
│ [Page Title: Entities]                        [+ New Entity]  │
│ ─────────────────────────────────────────────────────────────   │
│ [Search Input                        🔍]   [Filter ▼] [Sort ▼]│
│                                                                 │
│ ┌─────────────────────────────────────────────────────────┐   │
│ │ Entity Card                                              │   │
│ │ [Entity Icon]  [Entity Name]    [Category Badge]  [···] │   │
│ │                [Description (truncated, 1 line)]         │   │
│ │                [Created: MMM DD, YYYY]                   │   │
│ └─────────────────────────────────────────────────────────┘   │
│ (repeat × N, up to 20 per page)                                │
│                                                                 │
│ [← Previous]    Page [N] of [M]    [Next →]                   │
└────────────────────────────────────────────────────────────────┘
```

**Component inventory** (for cross-reference with UI_Spec.md):
- `GlobalHeader` — logo, navigation, user avatar dropdown
- `PageHeader` — page title + primary action button
- `SearchBar` — search input with icon
- `FilterDropdown` — multi-select filter
- `SortDropdown` — sort order selector
- `EntityCard` — repeating list item card
- `CategoryBadge` — pill-shaped category label
- `ActionMenu` (···) — card-level action dropdown
- `Pagination` — page navigation controls

---

### Mobile Layout (< sm:)

```
MOBILE: /entity/list

┌──────────────────────────────┐
│ HEADER                        │
│ [Logo]                 [☰]   │
├──────────────────────────────┤
│ MAIN CONTENT                  │
│                               │
│ Entities                      │
│ [+ New Entity]  (full width)  │
│                               │
│ [Search              🔍]      │
│ [Filter ▼]  [Sort ▼]         │
│                               │
│ ┌────────────────────────┐   │
│ │ Entity Card             │   │
│ │ [Icon] [Name]     [···]│   │
│ │ [Description, 2 lines] │   │
│ │ [Category] [Date]      │   │
│ └────────────────────────┘   │
│ (repeat × N)                  │
│                               │
│ [Load More ↓]  (full width)  │
└──────────────────────────────┘
```

**Mobile-specific notes:**
- Hamburger (☰) opens full-height navigation drawer
- Filter and Sort stack horizontally when both visible
- Cards are full-width (single column)
- Action menu (···) opens a bottom sheet on mobile
- Pagination is replaced with "Load More" button on mobile

---

### States

| State | Description |
|-------|-------------|
| **Loading** | 5 skeleton cards, each matching the entity card dimensions (full-width, ~80px height). Skeleton blocks use `animate-pulse`. Header loads instantly (non-async). |
| **Empty** | No cards visible. Empty state component centered in main content area. Full spec: UI_Spec.md §EntityListPage – Empty State |
| **Error** | No cards visible. Error state component centered in main content area. Full spec: UI_Spec.md §EntityListPage – Error State |
| **Populated** | The wireframe above shows the populated state with N entity cards |

---

## Screen 2: [Screen Name] — [/route/path]
**UX Flow Steps**: [e.g., Steps 2, 3, 4]
**Layout type**: Modal (overlays Screen 1)
**Modal dimensions**: Desktop — 480px wide, auto height (max 600px); Mobile — full-width bottom sheet

---

### Desktop Layout (lg: and above) — Modal

```
MODAL: Create Entity

┌────────────────────────────── Overlay ──────────────────────────────┐
│                                                                       │
│   ┌──────────────────────────────────────────────────────────┐      │
│   │ Create Entity                                        [X]  │      │
│   │ ─────────────────────────────────────────────────────     │      │
│   │                                                           │      │
│   │ Name *                                                    │      │
│   │ [Text Input — required                              ]     │      │
│   │                                                           │      │
│   │ Description                                               │      │
│   │ [Textarea — optional, 3 rows              ] 0/500        │      │
│   │                                                           │      │
│   │ Category *                                                │      │
│   │ [Select ▼ — required                       ]             │      │
│   │                                                           │      │
│   │ ─────────────────────────────────────────────────────     │      │
│   │ [Cancel]                          [Create Entity ▶]      │      │
│   └──────────────────────────────────────────────────────────┘      │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

---

### Mobile Layout (< sm:) — Bottom Sheet

```
MOBILE MODAL: Create Entity (bottom sheet)

┌──────────────────────────────┐
│                               │
│   ─────────── [handle] ──────│
│   Create Entity          [X] │
│   ──────────────────────────  │
│                               │
│   Name *                      │
│   [Text Input          ]      │
│                               │
│   Description                 │
│   [Textarea, 3 rows    ]      │
│   0/500                       │
│                               │
│   Category *                  │
│   [Select ▼            ]      │
│                               │
│   ──────────────────────────  │
│   [Create Entity]  (full-w)  │
│   [Cancel]         (full-w)  │
└──────────────────────────────┘
```

**Mobile-specific notes:**
- Bottom sheet slides up from bottom edge
- Drag handle at top allows dismissal by swiping down
- Buttons stack vertically, primary first
- Keyboard awareness: sheet shifts up when keyboard appears

---

### States

| State | Description |
|-------|-------------|
| **Default (empty form)** | All fields empty. Submit button disabled. Cancel enabled. |
| **Partially filled** | Some required fields empty. Submit still disabled if any required field is empty. |
| **All valid** | All required fields filled and valid. Submit button enabled. |
| **Submitting** | Submit button shows loading state (spinner + label "Creating..."). Form inputs disabled to prevent changes. |
| **Error** | Form-level error message shown below the last field. Specific field errors shown inline. Form remains open. |

_Note: This is a form component — the 4-state pattern applies differently. See UI_Spec.md §CreateEntityModal for full state specification._

---

## Screen 3: [Add additional screens following the same pattern]

_Duplicate the screen template above for each additional screen identified in the UX Flow._

---

## Wireframe Index

| Screen ID | Screen Name | Route | Mobile | Desktop | UX Flow Steps |
|-----------|-------------|-------|--------|---------|---------------|
| SCREEN-001 | Entity List | /entity/list | Yes | Yes | 1, 5 |
| SCREEN-002 | Create Entity Modal | /entity/list (modal) | Yes (bottom sheet) | Yes (modal) | 2, 3, 4 |
| [SCREEN-NNN] | [Name] | [/route] | [Yes/No] | [Yes/No] | [Steps] |
