# Agente09_UxUiDesigner — Decision Rules

> Distilled from build-time bibliography and Golden Path conventions. These are binding if-then rules that govern design decisions at runtime.

---

## DR001 — Async data fetch requires all 4 states

**Rule:** IF a page or component fetches data asynchronously (API call, Server Action, SWR) THEN design all four states: loading, error, empty, and populated — no exceptions.

**Applies to:** List pages, detail pages, dashboard widgets, charts, user-specific content, any component receiving data as props that may be loading.

**Exception:** None. Static content with no async dependency does not need a loading state, but must still handle error states if the page itself could fail to load.

**Gate impact:** Missing state → `BLOCKED_MISSING_STATES`

---

## DR002 — List screens require an empty state with message and optional CTA

**Rule:** IF a screen displays a list of entities THEN design an empty state with: (1) illustrative icon from design system, (2) heading explaining what is empty, (3) body copy explaining why and what to do, (4) CTA button when the user can take an action to populate it.

**Applies to:** Any page with a table, card grid, feed, or list of items.

**Empty state copy formula:** Heading: "No [entities] yet" or "Your [entity collection] is empty". Body: "Once you [create/add/connect] a [entity], it will appear here." CTA: "[Primary verb] [entity]" → navigates to creation flow.

**Exception:** CTA is optional if the user cannot create items (read-only view, filtered result with no matching items). In the filter case, the message should explain the filter mismatch, not suggest creating items.

---

## DR003 — Check for existing components before proposing new ones

**Rule:** IF a new visual pattern is needed THEN check if an existing design system component covers the need before proposing a new component. Only propose a new component if no existing component can fulfill the need, even with configuration.

**Check order:**
1. Button (with variant: primary, secondary, destructive, ghost, outline)
2. Card (with header, content, footer slots)
3. Dialog / Modal
4. Sheet / Drawer
5. Select / Combobox
6. Tabs
7. Badge / Tag
8. Alert / Toast
9. Accordion
10. DataTable

**Documentation required for new components:** If none of the above covers the need, document in `new_components_proposed` with `justification` explaining why no existing component works.

---

## DR004 — Feature affecting multiple screens requires full UX flow before wireframing

**Rule:** IF a feature involves navigation between multiple screens THEN complete the `UX_Flow.md` for the full journey before producing any wireframes. Wireframes cannot precede the flow.

**Why:** Wireframing individual screens before mapping the journey produces orphaned screens, missed states, and flows that don't connect. The UX Flow determines which screens exist and in what order.

**Exception:** If the feature involves only a single screen with no navigation (e.g., an in-page widget), a flow is not required — go directly to wireframe + spec.

---

## DR005 — Ambiguous acceptance criterion requires escalation before designing

**Rule:** IF a PRD acceptance criterion cannot be designed without making a product decision THEN stop and escalate to Agente00_TechLead — do not improvise the design direction.

**Escalation triggers:**
- "User can manage X" — manage how? Add, edit, delete, reorder?
- "Show relevant content" — relevant by what criteria?
- "User can filter" — by what fields, single or multi-select?
- "Notifications" — in-app, email, push, or all three?

**Process:** File escalation as `ESC-NNN` in the Handoff Package. Document the question and the blocked design decision. Wait for resolution before designing that section.

---

## DR006 — Color status requires a secondary non-color indicator

**Rule:** IF color is used to communicate status (active/inactive, success/error, warning/info) THEN add a secondary indicator (icon, text label, or pattern) that conveys the same information without relying on color.

**Compliant examples:**
- Active status: green dot + "Active" text label (not just green dot)
- Error field: red border + error icon + error text below (not just red border)
- Warning badge: amber background + ⚠ icon + "Warning" text (not just amber badge)

**Non-compliant examples:**
- Green dot vs. gray dot with no text
- Red-bordered input with no icon or error text

**WCAG reference:** Success Criterion 1.4.1 (Use of Color — Level A)

---

## DR007 — Interactive elements require all interactive states specified

**Rule:** IF a component is interactive (clickable, tappable, focusable) THEN specify all relevant states: default, hover, active (pressed), disabled, focus (keyboard), and loading (if applicable).

**Minimum state set for buttons:** default, hover, active, disabled.
**Additional states for inputs:** default, focused, filled, invalid, disabled.
**Additional states for links:** default, hover, visited, active.

**Format:** Use the `Interactive Elements` table in `UI_Spec.md` with one row per element.

---

## DR008 — Form fields require full specification

**Rule:** IF a form field appears in any component THEN specify for that field: (1) visible label text, (2) placeholder text (if any), (3) validation rules (required, min/max length, pattern, type), (4) error message for each validation rule, (5) character limit counter if applicable, (6) helper text if applicable.

**Exception:** Labels may be omitted visually on search inputs if the search icon and button are sufficient context — but `aria-label` must still be specified.

**Anti-pattern:** Specifying only the placeholder as the label. Placeholder text disappears on input and is not read consistently by screen readers.

---

## DR009 — Images require dimensions and alt text specification

**Rule:** IF an image appears in any component THEN specify: (1) `src` source description (even if placeholder), (2) `alt` text content (meaningful for informative images, `""` for decorative), (3) `width` and `height` in pixels for `next/image`, (4) aspect ratio if dimensions are flexible.

**Why:** `next/image` requires explicit dimensions to prevent layout shift (CLS). Missing alt text is a WCAG A violation. Specifying dimensions in the design prevents the developer from guessing.

**next/image example spec:**
```
Image: User avatar
src: [user.avatarUrl] — fallback to initials if null
alt: "[user.name]'s profile picture"
width: 40
height: 40
aspect ratio: 1:1 (square, circular via border-radius: 50%)
```

---

## DR010 — Mobile: all primary actions reachable without horizontal scroll

**Rule:** IF a mobile wireframe is being produced THEN all primary actions must be reachable within the vertical scroll area — no horizontal scroll. Primary actions must be reachable with one thumb without repositioning the phone.

**Primary action placement on mobile:**
- CTA button: bottom of screen content or sticky footer
- Form submit: at the end of the form, full width
- Navigation: hamburger (top) or tab bar (bottom)
- Dangerous action: always requires a separate confirmation — never in the same thumb zone as safe actions

**Exception:** Horizontal scroll is allowed for secondary UI elements (image carousels, horizontal filter chips, tab bars with many tabs). Primary actions may not be behind horizontal scroll.

---

## DR011 — Design contradicting PRD must be flagged to Tech Lead

**Rule:** IF a design decision contradicts the PRD (adds scope, removes scope, or interprets a requirement differently) THEN flag to Agente00_TechLead immediately — do not silently modify scope.

**Process:** Note the contradiction in the Handoff Package `open_questions` array with `blocking: true`. Include: which PRD section, what the PRD says, what the design currently shows, and the reason for the discrepancy.

**Do not:** Modify the PRD. Modify the design without approval. Proceed with the discrepancy unaddressed.

---

## DR012 — Charts require full Recharts specification

**Rule:** IF a chart is needed in the design THEN specify: (1) Recharts component type, (2) TypeScript data interface, (3) x-axis configuration (dataKey, label, tick format), (4) y-axis configuration (label, unit, domain if relevant), (5) tooltip content, (6) legend (yes/no, position, labels), (7) color tokens per series, (8) empty state design, (9) responsive container dimensions.

**Recharts component types to choose from:**
- `LineChart` — trends over time
- `BarChart` — comparisons between categories
- `AreaChart` — cumulative trends, showing volume
- `PieChart` — proportions of a whole (use sparingly — bar chart often clearer)
- `ComposedChart` — combination of the above

**Anti-pattern:** "Show a chart of [metric]" with no chart type or data shape specified.

---

## DR013 — WCAG AA contrast failure requires escalation

**Rule:** IF a design token combination (text color on background color) fails the WCAG AA contrast ratio (< 4.5:1 for normal text, < 3:1 for large text) THEN escalate to Agente00_TechLead for design system token value update — do not hardcode a custom color to compensate.

**Process:** Document the failing combination in the Handoff Package `escalations` array. Specify which token pair fails, at what ratio, and what ratio is needed. Do not proceed with the design until the token values are updated.

**Why not hardcode:** Hardcoded colors break the white-label design system. Token values are resolved at instantiation — design artifacts must never contain specific color values.

---

## DR014 — Complete spec unlocks READY_FOR_FRONTEND

**Rule:** IF all of the following are true THEN the Design Package is `READY_FOR_FRONTEND`:
- `UX_Flow.md` complete with error paths
- `Wireframes.md` complete with mobile + desktop for all primary screens
- `UI_Spec.md` complete with all 4 states for every async component
- All copy text is final (no placeholder text)
- All design tokens are generic (no hardcoded values)
- All interactive elements have ARIA labels specified
- All PRD requirements are traced in `prd_coverage`
- All self-review checklists are completed
- No blocking open questions remain

**Otherwise:** Return to the incomplete item and complete it before asserting `gate_ready: true`.

---

## DR015 — UX flows referencing API data must verify endpoint existence

**Rule:** IF a UX flow step or UI_Spec TypeScript interface references data that must come from an API call THEN verify that the corresponding endpoint and data fields exist in `API_Contract.json` or the `Architecture.md` Prisma schema before finalizing the design.

**Verification process:**
1. For each data field in a TypeScript interface: find the corresponding field in `API_Contract.json` response schema or Prisma model
2. If field is not present: flag as gap in the Handoff Package `open_questions` (directed to Agente02_SoftwareArchitect via Tech Lead)
3. Do not include the field in the final spec until the backend confirms it will be provided

**Anti-pattern:** Designing a UI that shows `user.organizationName` when the API only returns `user.organizationId`.
