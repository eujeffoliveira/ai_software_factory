# Agente09_UxUiDesigner — Skills Manifest

This manifest indexes all skills available to the UX/UI Designer agent. Each skill entry includes its purpose, trigger conditions, inputs, outputs, and the path to its full specification.

---

## Skill Index

| Skill ID | Skill Name | When to Trigger |
|----------|-----------|----------------|
| S01 | `ux-flow-design-skill` | When a feature requires mapping user journeys before wireframing |
| S02 | `wireframe-spec-skill` | When user flows are defined and screens need structural layout |
| S03 | `ui-state-design-skill` | When every async component needs all 4 states specified |
| S04 | `usability-review-skill` | When design artifacts are complete and need usability validation |
| S05 | `design-system-application-skill` | When visual elements need to be mapped to generic design tokens |

---

## S01 — ux-flow-design-skill

**Path**: `skills/ux-flow-design-skill/skill.md`

**Purpose**: Maps complete user journeys from PRD acceptance criteria — including happy paths, error paths, authentication gates, empty state paths, and decision branch points.

**Trigger when**:
- A new feature appears in the PRD that requires frontend interaction
- An existing feature is being redesigned and the journey needs re-mapping
- The Tech Lead requests a UX Flow as part of the design activation

**Do NOT trigger when**:
- The feature is backend-only (no user-facing screens)
- A UX Flow already exists and is not being modified

**Primary inputs**:
- `PRD.md` — acceptance criteria and user stories
- `Architecture.md` — routes, data models, API contracts

**Primary output**:
- `UX_Flow.md` — complete user journey map

**Key rules**:
- Every flow must include at least one error path and one edge case
- Authentication-required steps must be explicitly marked `[AUTH REQUIRED]`
- Decision points must document both branches

---

## S02 — wireframe-spec-skill

**Path**: `skills/wireframe-spec-skill/skill.md`

**Purpose**: Produces structural ASCII wireframes for every primary screen identified in the UX Flow, showing layout hierarchy and component placement for both mobile and desktop breakpoints.

**Trigger when**:
- UX Flow (`UX_Flow.md`) is complete and identifies the screens to be designed
- A new screen is being added to an existing feature

**Do NOT trigger when**:
- UX Flow is not yet complete (wireframes cannot precede the flow)
- The screen is a purely backend confirmation (no unique layout needed)

**Primary inputs**:
- `UX_Flow.md` — identifies which screens to wireframe
- `Architecture.md` — data shape that informs content structure
- `context_view.md §4` — wireframe syntax and conventions

**Primary output**:
- `Wireframes.md` — ASCII structural wireframes with mobile + desktop layouts

**Key rules**:
- Every screen needs both mobile (< sm:) and desktop (lg:+) layouts
- All four states must be annotated on each wireframe (even if detailed in Screen_States.md)
- Wireframes show structure only — no colors, no font specifications

---

## S03 — ui-state-design-skill

**Path**: `skills/ui-state-design-skill/skill.md`

**Purpose**: Explicitly designs all four states (loading, error, empty, populated) for every component or page that fetches asynchronous data, producing the detailed UI_Spec.md component specifications.

**Trigger when**:
- Any component fetches data from an API or Server Action
- A wireframe has been produced and needs its states fully specified
- A page has a list, table, chart, or any data-driven view

**Do NOT trigger when**:
- The component is purely static (no async data, no loading state needed)

**Primary inputs**:
- `Wireframes.md` — structural layout to derive skeleton shape from
- `Architecture.md` / `API_Contract.json` — data shape for TypeScript interfaces
- `context_view.md §5 + §7` — UI spec conventions and state specifications

**Primary output**:
- `UI_Spec.md` — complete component specification with TypeScript props, all 4 states, accessibility, responsive behavior, design tokens

**Key rules**:
- No component may have fewer than 4 states if it loads async data
- Loading skeletons must match the populated layout (no generic spinners)
- All copy text must be exact (no placeholder text in the final spec)

---

## S04 — usability-review-skill

**Path**: `skills/usability-review-skill/skill.md`

**Purpose**: Evaluates the complete design package against established usability principles (Hick's Law, Fitts's Law, Gestalt, progressive disclosure, Don't Make Me Think conventions) to identify friction points, cognitive overload, and inconsistencies before handoff to frontend.

**Trigger when**:
- The full design package (UX_Flow.md + Wireframes.md + UI_Spec.md) is complete
- A specific design decision is being questioned for usability impact
- A usability concern has been flagged by Tech Lead or Product Owner

**Do NOT trigger when**:
- Design artifacts are still incomplete (usability review requires a complete package)

**Primary inputs**:
- `UX_Flow.md`, `Wireframes.md`, `UI_Spec.md` — the complete design package
- `knowledge/principles.md` + `knowledge/heuristics.md` — usability principles

**Primary output**:
- Usability review findings: list of issues with severity and recommended fix
- Updated design artifacts with issues resolved
- `checklists/usability_checklist.md` — completed and signed off

**Key rules**:
- Critical usability issues (blocks task completion) must be fixed before `READY_FOR_FRONTEND`
- Medium issues should be noted and recommended for fix; high-severity issues block handoff
- Low issues are documented as backlog items

---

## S05 — design-system-application-skill

**Path**: `skills/design-system-application-skill/skill.md`

**Purpose**: Maps every visual element in the design artifacts to a generic design token from the authorized token set. Identifies any design token gaps (tokens needed but not defined). Ensures zero hardcoded values in any design artifact.

**Trigger when**:
- `UI_Spec.md` is being written or reviewed
- A new visual pattern is being introduced
- A review of an existing spec reveals potential hardcoded values

**Do NOT trigger when**:
- The design artifact only contains structural wireframes (no color/token assignments yet)

**Primary inputs**:
- `UI_Spec.md` (draft) — to be reviewed and corrected
- `context_view.md §6` — generic design token definitions
- `agent_config.json` — golden_path.design_tokens section

**Primary output**:
- `UI_Spec.md` (corrected) — with all visual properties mapped to generic tokens
- Token gap report (if any tokens are missing from the authorized set)
- `checklists/design_system_application_checklist.md` — completed

**Key rules**:
- Zero hardcoded hex values allowed in any artifact
- Zero org-specific token names allowed (e.g., `raiz-orange`, `brand-teal` are forbidden)
- Any new token need must be escalated to Tech Lead before the design is finalized
