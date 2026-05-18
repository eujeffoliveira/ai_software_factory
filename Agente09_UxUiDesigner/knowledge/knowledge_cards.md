# Agente09_UxUiDesigner — Knowledge Cards

> Reusable concept cards distilled from build-time bibliography. Each card captures a core UX/UI concept with its definition, application, and implementation guidance for the Golden Path stack. Reference these cards at runtime instead of consulting raw sources.

---

## Card 001 — Hick's Law

**Source:** Laws of UX — Jon Yablonski
**Concept:** The time it takes to make a decision increases logarithmically with the number of options.

**Formula:** T = b × log₂(n + 1) — where T is decision time, b is empirical constant, n is number of equally likely alternatives.

**Design application:**
- Limit primary navigation items to ≤ 7 (ideally 5)
- Show only the most common actions; move rare actions to "More" menus
- Simplify complex forms with progressive disclosure (wizard steps)
- Prioritize the most important action visually so it stands out from alternatives

**Implementation note:** In Tailwind, use visual weight hierarchy: primary button (`bg-primary-color font-semibold`), secondary button (`variant="outline"`), tertiary action (`variant="ghost"` or text link). Never present three equally weighted primary buttons.

---

## Card 002 — Fitts's Law

**Source:** Laws of UX — Jon Yablonski
**Concept:** The time to acquire a target is a function of the distance to the target and the size of the target.

**Formula:** T = a + b × log₂(D/W + 1) — where D is distance, W is target width.

**Design application:**
- Minimum touch target: 44×44px (WCAG 2.5.5, Apple HIG, Material Design)
- Place frequently used controls where they are reachable by the dominant thumb (bottom half of mobile screen)
- Make CTAs larger and more prominent — the bigger the target, the faster to click
- Avoid placing destructive actions (delete) adjacent to safe actions (save) with similar sizes

**Implementation note:** In Tailwind: `min-h-[44px] min-w-[44px]` for all interactive elements. On mobile, use `p-3` or larger padding around icon buttons to meet the touch target minimum without making the icon itself large.

---

## Card 003 — Miller's Law

**Source:** Laws of UX — Jon Yablonski / George A. Miller (1956)
**Concept:** The average person can hold 7±2 chunks of information in working memory at a time.

**Design application:**
- Navigation menus: 5–7 items maximum
- Form groups: 4–6 related fields per group before a new section
- Lists: paginate at 10–20 items (users cannot effectively process longer lists)
- Table columns: show the 5–7 most important columns; hide the rest in an expandable row
- Onboarding steps: wizards should have ≤ 7 steps; more than 7 steps need restructuring

**Implementation note:** Pagination is specified in UI_Spec with: page size (10 or 20 items), navigation type (numbered pages or load-more), and ARIA: `aria-label="Page navigation"` on the pagination container.

---

## Card 004 — Gestalt Proximity Principle

**Source:** Laws of UX — Jon Yablonski
**Concept:** Objects that are near each other are perceived as belonging to the same group.

**Design application:**
- Form labels immediately above their input (8px gap) — not separated by other elements
- Related actions grouped together (save + cancel in same row, not on opposite sides)
- Form sections: logical groupings with section headings and 24px+ gap between sections
- Data in tables: related columns visually closer than unrelated columns

**Implementation note:** In Tailwind: use `space-y-1` (4px) between label and input, `space-y-6` (24px) between form sections, `gap-2` (8px) between related buttons. Never put the "Cancel" button far from the "Save" button.

---

## Card 005 — Progressive Disclosure

**Source:** Don't Make Me Think — Steve Krug / Don Norman's design principles
**Concept:** Show only the information and options relevant to the user's current task. Reveal additional options on demand.

**Patterns that implement progressive disclosure:**
1. **Wizard** — one step at a time for multi-step forms
2. **Accordion** — show summary, expand for details
3. **"Show more" / "Read more"** — show first N items, reveal rest on click
4. **Tooltip / Popover** — show detail on hover/focus
5. **Contextual actions** — show actions only after item selection
6. **Advanced options toggle** — basic options visible, advanced hidden behind "Advanced ▼"

**When to use:** Long forms (> 8 fields), complex configuration, feature discovery (show when ready), content that is optional detail.

**When NOT to use:** Critical security warnings (must be upfront). Required information (must not be hidden). Primary content (the main thing users came for).

---

## Card 006 — WCAG 2.1 AA Quick Reference

**Source:** W3C Web Content Accessibility Guidelines 2.1
**Concept:** The minimum accessibility standard required for the Golden Path.

**Key AA criteria:**
| Success Criterion | Requirement | Level |
|------------------|-------------|-------|
| 1.1.1 Non-text Content | Images have alt text | A |
| 1.3.1 Info and Relationships | Structure conveyed via markup (labels, lists, headings) | A |
| 1.3.3 Sensory Characteristics | Instructions don't rely solely on shape/color/size | A |
| 1.4.1 Use of Color | Color not the only visual means of conveying info | A |
| 1.4.3 Contrast (Minimum) | Text: 4.5:1; Large text: 3:1 | AA |
| 1.4.4 Resize Text | Text resizable to 200% without loss of content | AA |
| 2.1.1 Keyboard | All functionality operable via keyboard | A |
| 2.4.3 Focus Order | Focus order preserves meaning | A |
| 2.4.7 Focus Visible | Keyboard focus indicator visible | AA |
| 3.2.1 On Focus | No unexpected context change on focus | A |
| 3.3.1 Error Identification | Errors identified in text | A |
| 3.3.2 Labels or Instructions | Labels/instructions for user input | A |
| 4.1.2 Name, Role, Value | UI components have accessible name, role, state | A |

---

## Card 007 — Loading State Design Pattern

**Source:** Golden Path reference architecture — Next.js loading.tsx convention
**Concept:** Loading states must match the layout of the populated state (skeleton) so the page doesn't visually shift when data arrives.

**Components of a correct loading state:**
1. Skeleton blocks matching the shape and position of real content
2. `animate-pulse` (Tailwind) or equivalent CSS animation on skeleton blocks
3. `role="status"` on the container
4. `aria-label="Loading [content type]..."` on the container
5. Skeleton color: `bg-muted` (matches surface token)
6. Avoid revealing the full page chrome (header, nav) while skeleton is visible — those load instantly

**Example spec:**
```
Loading State — Task List
- 3 skeleton cards
- Each card: full width, h-[80px], bg-muted, rounded-[radius], animate-pulse
- Skeleton blocks within card:
  - Title placeholder: w-1/2, h-[16px], bg-muted-foreground/20
  - Subtitle placeholder: w-1/4, h-[12px], bg-muted-foreground/20, mt-2
- Container: role="status" aria-label="Loading tasks..."
```

---

## Card 008 — Error State Design Pattern

**Source:** Don't Make Me Think — Steve Krug (error recovery) + Golden Path error.tsx convention
**Concept:** Error states must give users a clear, non-technical explanation and a recovery path.

**Components of a correct error state:**
1. Illustrative icon (not a red X — use a soft, friendly icon)
2. Heading: what went wrong in plain language
3. Body copy: what to do next (not what the technical error was)
4. Recovery action: "Try again" button that retries the fetch
5. Optional: secondary action (contact support, go home)
6. ARIA: `role="alert"` on the container (announced immediately by screen readers)

**Copy formula:**
- Heading: "Something went wrong" or "[Entity] couldn't load"
- Body: "We had trouble [loading/saving/processing] [entity]. Please try again." (If it persists, contact support.)
- Button: "Try again"

**Never include in error messages:**
- HTTP status codes ("Error 500")
- Internal function names
- Database error messages
- Stack trace fragments

---

## Card 009 — Empty State Design Pattern

**Source:** Don't Make Me Think — Steve Krug + Lean UX principle (use empty state as onboarding)
**Concept:** Empty states are the first impression for new users and must guide them to action, not leave them confused.

**Components of a correct empty state:**
1. Illustrative icon (represents the entity type — subtle, friendly)
2. Heading: explains what's empty (not just "No items")
3. Body: explains why it's empty and what to do
4. CTA button: primary action to add the first item (omit if user has read-only access)

**Design variations:**
- **New user (onboarding empty):** "You haven't created any [entities] yet. [Create your first [entity] →]"
- **Filter empty:** "No [entities] match your filter. [Clear filters]"
- **Search empty:** "No results for "[search term]". Check your spelling or try a different search."
- **Error-related empty:** After an error is dismissed, show the empty state, not another error

**Implementation note:** Icon size: `h-12 w-12` for the icon container. Icon color: `text-muted-foreground`. Heading: `text-lg font-semibold text-foreground`. Body: `text-sm text-muted-foreground`. CTA button: primary variant.

---

## Card 010 — Mobile Navigation Patterns

**Source:** Don't Make Me Think — Krug + Mobile-first Tailwind convention
**Concept:** Mobile navigation must be thumb-reachable, space-efficient, and instantly recognizable.

**Pattern selection guide:**
| App Type | Recommended Pattern | When |
|----------|-------------------|------|
| ≤ 5 top-level sections | Bottom tab bar | Primary sections navigated frequently |
| > 5 sections | Hamburger → Drawer | Many sections, less frequent switching |
| Deep hierarchy | Breadcrumb + Back | Multi-level navigation within a section |
| Single section | In-page anchors | Long single-page content |

**Bottom tab bar spec:** Fixed at bottom of screen. Height: `h-16` (64px). Each tab: icon (24×24px) + label (12px). Active tab: `text-primary-color`. Inactive: `text-muted-foreground`. Maximum 5 tabs.

**Hamburger drawer spec:** Icon top-left or top-right. Drawer slides in from left. Full-height overlay. Close on: tap outside, swipe left, Esc key. First-level navigation items: `h-12` minimum (48px touch target).

---

## Card 011 — Form Design Best Practices

**Source:** Don't Make Me Think — Krug + WCAG form requirements
**Concept:** Forms are the highest friction point in any product. Every unnecessary field, unclear label, or poor error message costs conversions and creates support tickets.

**Checklist for every form:**
- [ ] One column layout (two-column forms require more reading time to parse)
- [ ] Labels above inputs (not beside — avoids horizontal scanning)
- [ ] No placeholder-only labels (placeholder disappears on input)
- [ ] Required fields marked visually AND via `aria-required="true"`
- [ ] Inline validation on blur (not only on submit)
- [ ] Error messages specific ("Enter a valid email" not "Invalid email")
- [ ] Character counters for fields with limits
- [ ] Password fields have show/hide toggle
- [ ] Submit button at the bottom, full-width on mobile
- [ ] Submit disabled during processing (prevents double-submit)
- [ ] Success feedback after submission (toast, redirect, or confirmation message)

**Implementation note in spec:** For each field, fill the 6-field template (label, placeholder, validation, error, character limit, helper). Never leave any field as "standard input."

---

## Card 012 — Recharts Implementation Guide

**Source:** Golden Path reference architecture — Recharts v3 specification
**Concept:** Charts must be fully specified in the design artifact so the frontend developer can implement without making data or visual decisions.

**Mandatory chart spec fields:**
```
Chart Component: [LineChart | BarChart | AreaChart | PieChart | ComposedChart]
Container: <ResponsiveContainer width="100%" height={[N]}>
Data interface: { [key]: [type], ... }[]

X-Axis:
  dataKey: "[field]"
  label: "[axis label]"
  tick format: "[e.g., 'MMM DD' for dates, 'N' for numbers]"

Y-Axis:
  label: "[axis label]"
  unit: "[unit string, e.g., '$', '%', 'ms']"
  domain: [auto | [min, max]]

Tooltip:
  Content: "[field1]: [value] | [field2]: [value]"
  Format: "[e.g., currency, percentage, date]"

Legend: [Yes/No] — Position: [top | bottom | right] — Labels: [from data key | custom]

Series / Bars:
  Series 1: dataKey="[field]" fill="primary-color" stroke="primary-color"
  Series 2: dataKey="[field]" fill="secondary-color" stroke="secondary-color"

Empty state:
  [Same spec as other empty states — icon + heading + body]

Notes:
  [Any chart-specific behavior: click to filter, drill-down, reference lines]
```
