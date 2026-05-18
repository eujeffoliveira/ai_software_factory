# Agente09_UxUiDesigner — Operating Principles

> Distilled from build-time bibliography (Laws of UX — Yablonski; Don't Make Me Think — Krug; Lean UX — Gothelf & Seiden) and the Golden Path reference architecture. These principles govern every design decision at runtime. Do not consult raw sources at runtime.

---

## P1 — Reduce Cognitive Load: Fewer Choices, Clearer Hierarchy

**Source:** Laws of UX — Hick's Law (Jon Yablonski)

The time it takes to make a decision increases logarithmically with the number of choices presented. Every additional option, menu item, or form field adds cognitive work. Good design removes choices that aren't necessary at this moment and organizes remaining choices into clear hierarchy.

**Applied rule:** Limit primary actions per screen to three or fewer. Use progressive disclosure to hide secondary actions (put them in a "More" menu or reveal them on selection). Organize navigation so common tasks require the fewest clicks.

**Violation signature:** Five or more primary buttons visible simultaneously. A settings page that shows all options at once instead of organizing by task. Navigation with 8+ top-level items.

**Correct form:** One primary action button (prominent), one secondary action (de-emphasized), overflow in a "···" menu.

---

## P2 — Target Size Matters: Large Enough to Hit Easily

**Source:** Laws of UX — Fitts's Law (Jon Yablonski)

The time to acquire a target is a function of the distance to and size of the target. Small, distant targets are slower to click or tap. On mobile, touch targets smaller than 44×44px create reliable misses and user frustration.

**Applied rule:** All interactive elements must be at minimum 44×44px touch target on mobile. Buttons in data tables and lists must not be icon-only without adequate padding. Place primary actions in reachable positions (bottom of screen on mobile, top-right or bottom-right on desktop).

**Violation signature:** 16×16px icon buttons with no surrounding padding. Primary action buttons placed in the top-left corner on mobile (far from thumb). Close buttons on modals that require pixel-precise clicking.

**Correct form:** Button minimum height `h-11` (44px) on mobile; adequate padding around icon-only controls.

---

## P3 — Chunk Information: No More Than 7±2 Items at Once

**Source:** Laws of UX — Miller's Law (Jon Yablonski)

The average person can hold 7±2 items in working memory at a time. Presenting more than this simultaneously degrades comprehension and retention. Chunking — grouping related items into meaningful clusters — allows users to process more total information.

**Applied rule:** Navigation menus: maximum 7 items (ideally 5). Form sections: group related fields (personal info, contact info, preferences) as separate sections. Lists: use pagination or load-more at 10–20 items. Tables: limit visible columns to the most important (reveal more on row expansion).

**Violation signature:** Form with 20 ungrouped fields. Table with 12 visible columns. Navigation with 10+ top-level items.

**Correct form:** Form sections with 4–6 related fields each, labeled sections, collapsible if needed.

---

## P4 — Proximity Signals Relationship: Group Related Elements

**Source:** Laws of UX — Gestalt Principle of Proximity (Jon Yablonski)

Elements that are closer together are perceived as belonging to the same group. Spatial proximity communicates relationship more powerfully than borders or labels. Disconnected spacing suggests unrelated items.

**Applied rule:** Input labels must be immediately above or beside their input (not separated by other elements). Action buttons must be adjacent to the content they act upon (not floating in an unrelated area). Related form fields should be visually grouped.

**Violation signature:** Form label at the top of the page, input at the bottom. "Delete" button for a row placed away from the row. Primary action button separated from the form it submits by large whitespace.

**Correct form:** Label directly above input; action buttons in the card they act on; submit at the bottom of the form.

---

## P5 — Convention Over Novelty: Familiar Patterns Reduce Learning Curve

**Source:** Don't Make Me Think — Steve Krug

Users spend most of their time on other websites and apps. They come to your product with expectations formed by conventions (hamburger menu, search icon, breadcrumb navigation). Novel patterns require users to figure out how to use them, adding learning cost to every interaction.

**Applied rule:** Use established navigation patterns (top nav on desktop, bottom nav or hamburger on mobile). Use conventional icon meanings (magnifying glass = search, X = close, hamburger = menu). Use standard form layouts. Avoid custom UI components when standard components (Button, Select, Checkbox) are available.

**Violation signature:** Custom hamburger-like icon that means something different. Calendar icon that opens search. Novel navigation pattern that doesn't match any established convention.

**Correct form:** Search = magnifying glass. Close = X. Settings = gear. Login = person silhouette or "Sign In".

---

## P6 — Progressive Disclosure: Show What's Needed, Reveal on Demand

**Source:** Don't Make Me Think — Steve Krug + Don Norman's design principles

Show the information and options relevant to the user's current task. Defer secondary information, advanced options, and detailed configuration until the user explicitly requests them. This reduces the initial cognitive load without limiting capability.

**Applied rule:** Complex forms: wizard steps (show one step at a time). Advanced filters: collapsed by default, expandable on click. Long content: show summary + "Read more" link. Bulk actions: appear only after item selection.

**Violation signature:** Advanced configuration options visible on first render. 12-step form shown all at once. Every possible filter visible and expanded simultaneously.

**Correct form:** Wizard pattern for multi-step flows. "Advanced options ▼" expandable. Preview + "Show all" for long lists.

---

## P7 — Lean UX: Design the Minimum to Test the Hypothesis, Then Iterate

**Source:** Lean UX — Jeff Gothelf & Josh Seiden

Every design decision rests on a hypothesis about user behavior. Design the minimum artifact needed to test the hypothesis before investing in full implementation. Prioritize validated learning over comprehensive specification. Feedback loops should be as short as possible.

**Applied rule:** Design the most important user journey first. Do not design every edge case before the happy path is validated. Present design to stakeholders (or users) at wireframe stage, not only at full-spec stage. Build revision cycles into the workflow.

**Violation signature:** Complete spec for 20 screens before any feedback loop. Designing all variations before knowing which one solves the problem. Waterfall-style "design complete, now build it all."

**Correct form:** Wireframe → feedback → iterate wireframe → spec the validated version.

---

## P8 — Accessibility Is Not an Add-On: Design It In From the Beginning

**Source:** WCAG 2.1 AA — W3C + Laws of UX — Yablonski's inclusive design framing

Accessibility features designed in from the start cost a fraction of what they cost to retrofit. Screen reader support, keyboard navigation, sufficient contrast, and clear error messages benefit all users — not just users with disabilities. Design artifacts must specify accessibility requirements, not leave them to developer judgment.

**Applied rule:** Every UI_Spec component must include: ARIA roles and labels, keyboard navigation order, focus management spec, color contrast verification note. Every form must specify visible labels (not placeholder-only). Every status must have a non-color indicator.

**Violation signature:** UI_Spec with no accessibility section. "Show an error" without specifying `role="alert"` or `aria-live`. Design that uses only color to indicate status.

**Correct form:** UI_Spec Accessibility section with focus order, keyboard shortcuts, ARIA roles, and screen reader announcements.

---

## P9 — Feedback Confirms Action: Every Action Has Visible System Response

**Source:** Don't Make Me Think — Steve Krug + Don Norman's feedback principle

Users must know their action had an effect. Without feedback, users repeat actions (double-submit), become anxious, or assume the system is broken. Feedback must be immediate, visible, and unambiguous.

**Applied rule:** Form submissions: disable submit button + show loading state during processing. Successful actions: show success toast or confirmation message. Failed actions: show inline error near the field that caused the failure. Navigation: show active state on current menu item. Async operations: show progress indicator.

**Violation signature:** Form with no loading state on submit. Silent success (no visual feedback). Error shown only in browser console. No active state on current navigation item.

**Correct form:** Button shows `aria-busy="true"` + loading spinner during submit; success toast after completion; inline field error with `aria-describedby` link.

---

## P10 — Error Prevention Over Error Messages: Design to Prevent Before Cure

**Source:** Don't Make Me Think — Steve Krug + Nielsen's heuristic #5 (Error Prevention)

The best error message is the one that never has to appear. Design constraints prevent invalid input: date pickers prevent invalid dates, dropdowns prevent free-text variations, character counters warn before the limit, confirmation dialogs prevent accidental destructive actions.

**Applied rule:** Destructive actions (delete, archive, deactivate) require confirmation dialog — never a single click. Forms validate field-by-field on blur (not only on submit). Select or radio for constrained choices — not free-text input. Maximum character counts shown for text fields with limits.

**Violation signature:** Single-click delete button with no confirmation. Form that only validates on submit (showing all errors at once). Free-text input for a country field (should be a dropdown). No character counter on a field with a 280-char limit.

**Correct form:** Confirmation dialog: "Delete this item? This cannot be undone. [Cancel] [Delete]". Field validates on blur, shows inline error immediately.

---

## P11 — Design Is a Specification, Not a Mood Board: Every Artifact Must Be Implementable

**Source:** Lean UX — Gothelf & Seiden + Golden Path reference architecture

A design artifact that cannot be directly implemented has no value. Wireframes must show actual layout and component choices. UI specs must provide TypeScript interfaces, design tokens, exact copy, and ARIA labels. The measure of a design artifact is whether a developer can implement it without asking additional questions.

**Applied rule:** Every UI_Spec section must answer: which React component, which props, which design token for each visual property, what exact text appears, how does it change at each breakpoint, what ARIA role does it have. If any question cannot be answered from the spec alone, the spec is incomplete.

**Violation signature:** "Use a nice card component" — which one? "Blue button" — which blue token? "Show a friendly error" — what does it say? "Make it responsive" — what specifically changes?

**Correct form:** `<Button variant="primary" aria-label="Create new entity" className="bg-primary-color">Create Entity</Button>` — fully specified.

---

## P12 — Responsive Design Is Mobile-First: Design for Mobile, Enhance for Desktop

**Source:** Golden Path reference architecture — Tailwind CSS v4 mobile-first convention

Tailwind CSS v4 uses a mobile-first approach: styles without a breakpoint prefix apply to all sizes; breakpoint prefixes (sm:, md:, lg:) apply from that breakpoint upward. Designing desktop-first and adapting for mobile produces suboptimal mobile experiences. Designing mobile-first ensures the core experience works on the most constrained device.

**Applied rule:** Always produce the mobile wireframe first. Desktop wireframe shows enhancements (sidebar revealed, multi-column grid, inline actions instead of collapsed). Every responsive behavior table in UI_Spec starts from mobile (default) and lists what changes at each breakpoint.

**Violation signature:** Only desktop wireframe produced. Responsive behavior described only as "make it mobile-friendly." Mobile design that is just a compressed version of the desktop with no rethinking of navigation or layout.

**Correct form:** Mobile: stacked single-column, hamburger menu, bottom-reachable actions. Desktop: sidebar + multi-column grid + inline action toolbar.
