# Agente09_UxUiDesigner — Context View

> Compiled build-time context. This file replaces `context/` at runtime. All UX/UI design conventions, token definitions, wireframe syntax, and accessibility requirements needed for runtime operation are contained here. Do not consult `context/` or `lib/` at runtime.

---

## 1. Pipeline Position

Agente09 is an **optional agent** activated by Agente00_TechLead when a feature requires UX/UI design work before frontend implementation begins.

```
Agente01_ProductOwner → PRD.md ──┐
                                   ├──► Agente09_UxUiDesigner ──► Design Package
Agente02_SoftwareArchitect ────────┘     (UX_Flow.md +           │
→ Architecture.md                        Wireframes.md +          ▼
                                         UI_Spec.md)    Agente05_DevFrontend
```

**Entry condition**: Both PRD.md (Gate 1 approved) and Architecture.md (Gate 2 approved) must be available before design work begins.

**Exit condition**: Design Package delivered to Agente05_DevFrontend via Tech Lead, with Design Review status `READY_FOR_FRONTEND`.

---

## 2. Frontend Tech Stack (Design Must Account For)

The following implementation stack governs design decisions. Every design artifact must be feasible within these constraints.

| Layer | Technology | Design Implication |
|-------|-----------|-------------------|
| Framework | Next.js 16 (App Router) | Server Components are default; Client Components only when justified (interactivity, browser APIs, real-time) |
| UI Library | React 19 + TypeScript 5 | Component props must be specified as TypeScript interfaces |
| Styling | Tailwind CSS v4 | Use breakpoint tokens (sm: md: lg: xl:); design mobile-first |
| Images | `next/image` | Every image needs: src, alt text, width, height, aspect ratio |
| Loading | `loading.tsx` / Suspense skeletons | Loading states must match content layout (skeleton, not spinner) |
| Error | `error.tsx` / error boundaries | Error states need user-friendly message + retry action |
| Charts | Recharts v3 | Specify chart type, data shape, axis labels, empty state |
| Auth | NextAuth v5 + Google OAuth | Auth-required flows must show auth gate in UX Flow |

---

## 3. UX Flow Conventions (Markdown-Based)

UX Flows are documented in Markdown using structured sections. This is the canonical format for all flows produced by this agent.

### Flow Structure

```markdown
# UX Flow
## Feature: [Feature Name]
## Related PRD Section: [Section reference]
## Date: [YYYY-MM-DD]

## Actors
- **Primary**: [Role] — [goal]
- **Secondary**: [Role if any] — [goal]

## Entry Points
- [URL/screen] — [from what context]

## Happy Path

### Step 1: [Screen/Action Name]
- **Actor**: [who]
- **Action**: [what they do]
- **Screen**: [URL/route]
- **State**: Populated | Loading | Empty
- **Outcome**: [what happens]

### Step 2: ...

## Error Paths

### Error: [Error name]
- **Trigger**: [condition that causes this error]
- **Screen**: [what the user sees]
- **Recovery**: [how user recovers]

## Edge Cases
- [Empty state]: When [condition], show [empty state description]
- [Permission denied]: When [condition], show [message]

## Decision Points
- [Step N] → [DECISION: condition → Path A | Path B]
```

### Flow Annotation Conventions

| Annotation | Meaning |
|-----------|---------|
| `[AUTH REQUIRED]` | Step requires active session — redirect to `/auth/signin` if not authenticated |
| `[DECISION: condition → A \| B]` | Branching point — both paths must be documented |
| `[LOADING]` | Step shows loading state while data is fetched |
| `[EMPTY]` | Step shows empty state when data set is zero items |
| `[ERROR: type]` | Step shows error state — type describes the failure |
| `[PERMISSION: role]` | Step requires specific role or permission |

---

## 4. Wireframe Conventions (ASCII Box-Based)

Wireframes use ASCII box drawing characters to represent layout structure. They show component hierarchy and content placement — NOT visual design, colors, or styling.

### Syntax Reference

```
┌─────────────────────────────┐   Top-level container / page boundary
│ SECTION LABEL               │   Section header (ALL CAPS)
├─────────────────────────────┤   Section divider
│ [Component Name]            │   Named component in brackets
│ [Icon] [Label] [Action ▼]  │   Inline component group
│ ─────────────────────────── │   Horizontal rule / separator
│ (repeat × N)                │   Repetition annotation
└─────────────────────────────┘   Container end
```

### Standard Desktop Wireframe Template

```
PAGE: /route/path
LAYOUT: [Header] + [Optional Sidebar] + [Main Content] + [Optional Footer]

HEADER
  ┌──────────────────────────────────────────────┐
  │ [Logo]    [Nav: Item1 | Item2 | Item3]  [Avatar ▼] │
  └──────────────────────────────────────────────┘

MAIN CONTENT — Desktop (lg: and above)
  ┌──────────────────────────────────────────────┐
  │ [Page Title]                      [+ Action] │
  │ ────────────────────────────────────────────  │
  │ [Search Input          🔍]  [Filter ▼]        │
  │                                               │
  │ ┌──────────────────────────────────────────┐ │
  │ │ Item Card                                │ │
  │ │ [Avatar] [Title]          [Action Menu ▼]│ │
  │ │ [Subtitle / Meta]                        │ │
  │ └──────────────────────────────────────────┘ │
  │ (repeat × N)                                  │
  │                                               │
  │ [← Prev]  Page 1 of N  [Next →]              │
  └──────────────────────────────────────────────┘
```

### Standard Mobile Wireframe Template

```
MAIN CONTENT — Mobile (< sm:)
  ┌─────────────────────┐
  │ HEADER               │
  │ [Logo]       [☰]    │
  ├─────────────────────┤
  │ [Page Title]         │
  │ [+ Action]           │
  │                      │
  │ [Search 🔍]          │
  │ [Filter ▼]           │
  │                      │
  │ ┌───────────────┐   │
  │ │ Item Card     │   │
  │ │ [Title]       │   │
  │ │ [Meta]  [···] │   │
  │ └───────────────┘   │
  │ (repeat × N)         │
  │                      │
  │ [Load More ↓]        │
  └─────────────────────┘
```

### State Labels in Wireframes

After each wireframe, annotate all four states:

```
### States
- **Loading**: [Skeleton description — what cards/shapes appear, matching content layout]
- **Empty**: [What message and CTA appear — see Screen_States.md for full spec]
- **Error**: [What error message and action button appear — see Screen_States.md]
- **Populated**: [The wireframe above shows this state]
```

---

## 5. UI Specification Conventions

### Component Specification Structure

Each component in `UI_Spec.md` follows this structure:

```markdown
## Component: [ComponentName]
**Route**: [/path/to/page]
**Type**: Server Component | Client Component
**Justified by**: [reason if Client Component — interactivity / real-time / browser API]

### Props Interface
```typescript
interface [ComponentName]Props {
  // Fields derived from API_Contract.json or Architecture.md
  items: Array<{
    id: string
    title: string
    createdAt: string  // ISO 8601
  }>
  totalCount: number
  currentPage: number
}
```

### States

#### Loading State
- Skeleton: [N] placeholder cards, each [width × height], `animate-pulse` class
- Background: `bg-muted` for skeleton blocks
- ARIA: `role="status"` `aria-label="Loading [content type]..."`
- Duration: show after 200ms delay (avoid flash for fast loads)

#### Empty State
- Icon: `[icon-name]` from design system icon set
- Heading: "[Exact heading text]"
- Body: "[Exact body copy explaining why empty and what to do]"
- CTA: Button — label "[Exact CTA text]" → navigates to [route] | triggers [action]
- Token: icon in `text-muted-foreground`, heading in `text-foreground`

#### Error State
- Message: "[User-friendly error message — NOT technical. Never expose error codes or stack traces.]"
- Secondary: "[Optional clarification or support link]"
- Action: Button — label "Try again" → retries the data fetch
- Token: error icon in `destructive`, message in `text-foreground`

#### Populated State
- [Describe the full layout referencing the wireframe]
- [List all interactive elements]

### Interactive Elements

| Element | Type | Default | Hover | Active | Disabled | Token |
|---------|------|---------|-------|--------|----------|-------|
| [Button] | primary | `bg-primary-color text-foreground` | `opacity-90` | `scale-95` | `opacity-50 cursor-not-allowed` | `primary-color` |

### Responsive Behavior

| Breakpoint | Changes |
|------------|---------|
| Mobile (default) | Single column; stacked actions; hamburger nav |
| sm: (640px+) | Two-column card grid |
| lg: (1024px+) | Sidebar visible; three-column grid; inline actions |

### Accessibility
- **Focus order**: [1. Search, 2. Filter, 3. Items left-to-right top-to-bottom, 4. Pagination]
- **Keyboard**: Enter on card → opens detail; Esc → closes any open dropdown
- **Screen reader**: `aria-label="[N] items found"` on list container; `aria-live="polite"` on count update
- **ARIA roles**: `role="list"` on item container; `role="listitem"` on each card
- **Images**: All `<Image>` elements have meaningful `alt` text; decorative images `alt=""`
- **Color**: Status not communicated by color alone — icon + text + color used together
```

---

## 6. Design Tokens (Generic)

These are the canonical design token names for all design artifacts. Never substitute org-specific values, hex codes, or hardcoded colors. Values are resolved at instantiation time.

| Token | Usage |
|-------|-------|
| `primary-color` | Brand primary — buttons, links, active states, focus rings |
| `secondary-color` | Brand secondary — secondary actions, badges, accents |
| `text-foreground` | Primary text — headings, body copy, labels |
| `text-muted-foreground` | Secondary text — helper text, placeholders, metadata |
| `bg-background` | Page background — the base layer |
| `bg-muted` | Elevated surfaces — cards, sidebars, inputs, skeleton backgrounds |
| `border` | Dividers, card borders, input outlines |
| `radius` | Border radius — applied to cards, buttons, inputs |
| `destructive` | Error states, delete actions, critical alerts |
| `success` | Success states, confirmation messages, completed actions |
| `warning` | Warning states, pending actions, attention required |

---

## 7. Screen State Specifications

Every component or page that loads async data MUST have all four states explicitly designed.

### State 1: Loading
**When**: Data is being fetched. No content is available yet.
**Implementation**: Skeleton placeholder matching the layout of the populated state. Use `animate-pulse` class. Structure matches real content so layout does not shift when data arrives.
**ARIA**: `role="status"` with `aria-label="Loading [content type]..."`
**Do not use**: Spinner alone (no layout placeholder). Blank white page.

### State 2: Error
**When**: Data fetch failed (network error, server error, timeout).
**User message**: Friendly, non-technical. Tells user what to try, not what broke.
**Recovery**: Always provide a "Try again" button that retries the fetch.
**ARIA**: Error message in `role="alert"` container.
**Do not use**: Technical error messages (`Error 500: ECONNREFUSED`). Empty page.

### State 3: Empty
**When**: Data fetch succeeded but the result set is zero items.
**Components**: Icon (illustrative, from design system) + heading + body copy + optional CTA.
**CTA**: Shown when user can take an action to populate the empty state (e.g., "Create your first [entity]").
**Do not use**: Blank page. "No data" alone without guidance.

### State 4: Populated
**When**: Data fetch succeeded and results are available.
**Content**: Full layout as shown in the wireframe.
**Considerations**: Pagination, load-more, or infinite scroll pattern (specify which); search/filter behavior when results are narrowed to zero (transitions to empty state, not error state).

---

## 8. WCAG 2.1 AA Accessibility Requirements

These requirements apply to every design artifact. Non-compliance blocks `READY_FOR_FRONTEND`.

### Color and Contrast
- Normal text (< 18pt / < 14pt bold): minimum **4.5:1** contrast ratio against background
- Large text (≥ 18pt / ≥ 14pt bold): minimum **3:1** contrast ratio against background
- Interactive elements (buttons, links): minimum **3:1** against adjacent colors
- Status never communicated by color alone — always add an icon, text, or pattern

### Keyboard Navigation
- All interactive elements reachable by Tab key
- Logical Tab order following visual reading order (left-to-right, top-to-bottom)
- No keyboard traps (modal focus trapping is intentional — all others are defects)
- Focus indicator visible — do not remove the default browser focus ring without providing a better one
- Dropdowns/menus: Arrow keys navigate options; Esc closes; Enter selects

### Form Accessibility
- Every input has a visible label (not just placeholder text)
- Label is programmatically associated (`for`/`id` or `aria-labelledby`)
- Placeholder text is supplementary only — not the primary label
- Error messages are specific and actionable ("Enter a valid email address" not just "Error")
- Error messages linked to the input via `aria-describedby`
- Required fields marked with `aria-required="true"` and visual indicator

### Images and Icons
- Informative images: `alt="[descriptive text]"`
- Decorative images: `alt=""` (empty string, not omitted)
- Functional images (button icons): `alt="[action description]"` or `aria-label` on the button
- Specify all image dimensions for `next/image` — prevents layout shift

### Screen Reader Support
- Headings form a logical hierarchy (h1 → h2 → h3; no skipped levels)
- Lists use `role="list"` and `role="listitem"` (required for screen readers to announce count)
- Dynamic content updates use `aria-live="polite"` (non-critical) or `aria-live="assertive"` (critical)
- Custom components have appropriate ARIA roles and states (e.g., `aria-expanded`, `aria-selected`)

---

## 9. Recharts Design Specifications

When a feature requires a chart, the designer must specify:

| Field | What to specify | Example |
|-------|----------------|---------|
| Chart type | Recharts component name | `LineChart`, `BarChart`, `PieChart`, `AreaChart` |
| Data shape | TypeScript interface | `{ date: string; value: number }[]` |
| X-axis | Label, data key, tick format | `dataKey="date"`, formatted as "MMM DD" |
| Y-axis | Label, unit, min/max if relevant | `label="Revenue (USD)"` |
| Tooltip | What data appears on hover | Date + value + percentage of total |
| Legend | Yes/No, position, labels | Bottom-center, labels from data key |
| Colors | Design token per series | Series 1: `primary-color`, Series 2: `secondary-color` |
| Empty state | What to show when data array is empty | Same empty state spec as other async components |
| Responsive | Container dimensions | `<ResponsiveContainer width="100%" height={300}>` |

---

## 10. Anti-Patterns (Never Do These)

| Anti-pattern | Why it's wrong | Correct approach |
|-------------|---------------|-----------------|
| Hardcode hex colors (`#FF5733`) in spec | Breaks design system, not reusable | Use `primary-color`, `destructive`, etc. |
| Design only the happy path | Frontend can't implement undefined states | Design all 4 states for every async component |
| "Show a loading spinner" | No layout structure defined | Specify skeleton matching content layout |
| Desktop-only wireframe | Mobile is default in Tailwind | Always produce both mobile and desktop layouts |
| "Make it look good" | Not a spec | Specify component, token, state, ARIA, copy |
| Propose new UI component first | Wastes implementation effort | Check if existing component covers the need |
| Reference org-specific tokens | Breaks white-label | Use only generic token names from §6 |
| Vague copy ("Success!") | Final spec needs exact text | Write exact production copy for all messages |
| Skip accessibility section | WCAG AA compliance is mandatory | Specify ARIA labels, focus order, keyboard behavior |
| Use placeholder text as label | Inaccessible to screen readers | Provide visible label + supplementary placeholder |
