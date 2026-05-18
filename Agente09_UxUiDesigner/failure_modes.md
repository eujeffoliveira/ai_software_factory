# Agente09_UxUiDesigner — Failure Modes

This document catalogs the 8 known failure modes for the UX/UI Designer agent. Each entry includes the failure mode ID, symptom, root cause, impact, and corrective action.

---

## FM-01: Missing Screen State

**Symptom**: A component or page fetches async data but the design artifact (`UI_Spec.md`) does not include one or more of the four mandatory states: loading, error, empty, or populated.

**Root Cause**: Designer focused only on the happy path (populated state) without systematically considering what happens during data fetch, on failure, or when the result set is empty. Often occurs under time pressure or when the feature seems "simple."

**Impact**: Agente05_DevFrontend must invent the state design during implementation, making product decisions outside their responsibility. Results in inconsistent UI, often a blank page or unhandled error. WCAG violations possible if error states are not accessible.

**Corrective Action**:
1. For every component in `UI_Spec.md` that fetches data, check for all four states
2. Apply `ui-state-design-skill` to the affected component
3. Loading: specify skeleton layout (not spinner), ARIA `role="status"`, `aria-label`
4. Error: specify user-friendly message + retry button
5. Empty: specify icon + heading + body copy + optional CTA
6. Resubmit after running `checklists/ui_spec_checklist.md`

**Gate impact**: `BLOCKED_MISSING_STATES` — blocks `READY_FOR_FRONTEND`

---

## FM-02: Design Not Traceable to PRD

**Symptom**: A screen, component, or interaction exists in `Wireframes.md` or `UI_Spec.md` but has no corresponding acceptance criterion in `PRD.md`. The `prd_coverage` section of the Handoff Package is incomplete or missing the coverage entry.

**Root Cause**: Designer added a feature based on intuition ("users would probably want this") without verifying it is in the PRD. Common when designers apply patterns from previous projects without confirming applicability.

**Impact**: Scope creep. Agente05_DevFrontend implements a feature that was never reviewed or approved by the Product Owner. Creates downstream rework when the Product Owner rejects the implementation at Gate 4 or beyond.

**Corrective Action**:
1. Review every screen and component against PRD acceptance criteria
2. For any element without a PRD trace: either find the correct PRD section, remove the element, or escalate to Tech Lead to determine if scope addition is acceptable
3. Update `prd_coverage` in the Handoff Package for all affected items
4. Do not re-submit until every design element is traceable

**Gate impact**: `BLOCKED_PRD_MISMATCH` — blocks `READY_FOR_FRONTEND`

---

## FM-03: New UI Component Proposed When Existing Component Would Suffice

**Symptom**: `UI_Spec.md` or the `new_components_proposed` array in the Handoff Package contains a new component for a pattern (e.g., "Status Badge", "Action Dropdown") that is already available in the design system library.

**Root Cause**: Designer did not check the design system inventory before proposing a new pattern. May have assumed the system lacked the component or preferred a custom solution.

**Impact**: Agente05_DevFrontend implements a duplicate component, increasing codebase complexity and visual inconsistency. Wasted implementation time. Creates maintenance debt.

**Corrective Action**:
1. Review the design system component inventory for the pattern in question
2. If an existing component covers the need: replace the new component proposal with a reference to the existing component and its required props configuration
3. If the existing component cannot cover the need (after honest evaluation): document why in the `justification` field of `new_components_proposed`
4. Apply `design-system-application-skill` before submitting

**Gate impact**: `RETURNED_FOR_REVISION`

---

## FM-04: Wireframe Lacks Mobile Layout

**Symptom**: `Wireframes.md` shows only a desktop layout for one or more primary screens. No mobile (< sm:) variant is provided.

**Root Cause**: Designer defaulted to "desktop-first" thinking. Assumed the mobile layout was self-evident from the desktop version. Or prioritized speed over completeness.

**Impact**: Agente05_DevFrontend must improvise the mobile layout, making layout decisions that should be design decisions. Results in poor mobile UX, inconsistent responsive behavior, and likely user experience failures on mobile devices.

**Corrective Action**:
1. Apply `wireframe-spec-skill` to all primary screens that are missing mobile layouts
2. Produce mobile wireframes using the `< sm:` convention in `context_view.md §4`
3. Key mobile considerations: all primary actions reachable without horizontal scroll; hamburger nav; stacked layout for content grids; tap targets minimum 44px × 44px
4. Update `Wireframes.md` before resubmitting

**Gate impact**: `RETURNED_FOR_REVISION`

---

## FM-05: UI_Spec Too Vague for Implementation

**Symptom**: `UI_Spec.md` contains instructions like "show a button", "display error message", "make it responsive", or "add loading spinner" without specific component details, design tokens, copy text, ARIA labels, or dimensional specifications.

**Root Cause**: Designer described intent instead of specification. Treated the UI_Spec as a brief to another designer, not as an implementation contract for a frontend developer.

**Impact**: Agente05_DevFrontend must make design decisions: which button variant, what error message copy, how does the responsive layout change, what is the ARIA label? This creates inconsistency across the product and requires multiple review cycles.

**Corrective Action**:
1. For every vague element, apply the full component specification template from `context_view.md §5`
2. Every button needs: variant (primary/secondary/destructive), label text, action, ARIA label, disabled condition
3. Every message needs: exact copy text, token for text color, icon (if any)
4. "Responsive" must become: a table specifying what changes at each Tailwind breakpoint
5. Loading must become: skeleton layout description, ARIA attributes
6. Run `checklists/ui_spec_checklist.md` against every component before resubmitting

**Gate impact**: `RETURNED_FOR_REVISION`

---

## FM-06: Color Used as Only Indicator of Status

**Symptom**: `UI_Spec.md` specifies a status indicator (e.g., active/inactive, success/error, warning) using only color differentiation, with no secondary indicator (icon, text label, or pattern).

**Root Cause**: Designer used a visual shorthand (green = success, red = error) without considering users with color vision deficiencies. The design seems obvious visually but fails WCAG 1.4.1 (Use of Color).

**Impact**: Users with color blindness (approximately 8% of males) cannot distinguish the states. WCAG AA violation. Legal accessibility compliance risk. `BLOCKED_ACCESSIBILITY_VIOLATION` from Design Review.

**Corrective Action**:
1. For every status indicator that currently uses only color: add a secondary indicator
2. Use icon + color + text: e.g., ✓ Active (green) | ✗ Inactive (gray) — not just green dot vs. gray dot
3. Update the `Interactive Elements` table in `UI_Spec.md` to document the icon and label alongside the token
4. Run `checklists/accessibility_basics_checklist.md` to catch all occurrences before resubmitting

**Gate impact**: `BLOCKED_ACCESSIBILITY_VIOLATION` — blocks `READY_FOR_FRONTEND`

---

## FM-07: Design References API Data Not in API Contract

**Symptom**: `UI_Spec.md` TypeScript interfaces or `UX_Flow.md` steps reference data fields (e.g., `lastLoginAt`, `organizationId`, `tags[]`) that do not exist in `API_Contract.json` or the Architecture data models.

**Root Cause**: Designer assumed data availability based on domain intuition, without verifying against the actual API contract or Prisma schema from `Architecture.md`. May have referenced a previous project's data shape.

**Impact**: Agente05_DevFrontend writes component props for data that the backend cannot provide. Discovered at integration time, causing frontend rework. Potentially blocks Gate 4 QA review.

**Corrective Action**:
1. Cross-reference every field in every `Props Interface` against `API_Contract.json` and `Architecture.md` Prisma schema
2. For any field not in the contract: remove it from the interface, or escalate to Agente02_SoftwareArchitect via Tech Lead to request the field be added to the contract
3. Update `UX_Flow.md` steps that referenced the unavailable data
4. Apply `ux-flow-design-skill` DR015 check before resubmitting

**Gate impact**: `RETURNED_FOR_REVISION`

---

## FM-08: Design Implies Scope Not in PRD (Scope Creep)

**Symptom**: The design package as a whole implements more functionality than specified in the PRD. For example: a PRD requires a "view list" feature, but the design adds "bulk actions", "export to CSV", and "advanced filters" without PRD backing.

**Root Cause**: Designer applied "obvious improvements" or "nice-to-have" features without checking PRD scope. Sometimes occurs when the designer is experienced with similar products and applies patterns from memory. Can also happen when a single PRD requirement is over-interpreted.

**Impact**: Agente05_DevFrontend implements extra features consuming sprint capacity. Extra features are then discovered at Gate 4 or Gate 5 with no documented requirements, acceptance criteria, or security review. They must be removed (wasted work) or retroactively specified (process violation).

**Corrective Action**:
1. Remove or mark as out-of-scope any design element without a PRD acceptance criterion
2. If the additional feature is genuinely needed: escalate to Agente00_TechLead, who will engage Agente01_ProductOwner for a PRD amendment
3. Do not include the additional feature in the design until a PRD amendment is approved
4. Update `prd_coverage` to reflect the corrected scope
5. Note: suggesting improvements is welcome; implementing them without approval is not

**Gate impact**: `BLOCKED_PRD_MISMATCH` — blocks `READY_FOR_FRONTEND`
