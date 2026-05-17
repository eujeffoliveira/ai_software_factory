# adr-authoring-skill

## Purpose

Write a properly structured Architecture Decision Record (ADR) for any Golden Path deviation, irreversible architectural decision, or significant design choice that future developers and agents must understand. Every ADR produced by this skill starts with status `PROPOSED` and must be reviewed and approved by the Tech Lead before the blocked gate can advance.

## When to Use

- When `golden-path-compliance-skill` flags a deviation from the Golden Model
- When any decision is irreversible or costly to reverse (schema changes, auth strategy, deploy platform)
- When a new external service, library, or pattern not in the Golden Path is introduced
- When the Tech Lead Council requests formal documentation of a contested architectural decision
- When Gate 2 is blocked with `BLOCKED_PENDING_ADR`

## Inputs

- `decision_context` — a concise description of the problem or deviation that triggered the ADR (from Architecture.md, compliance report, or Tech Lead brief)
- `adr_template_path` — path to `Agente02_SoftwareArchitect/templates/ADR_Template.md`
- `prd_requirement_id` — the PRD requirement or NFR that drives this decision (must trace back to at least one)
- `existing_adrs` — list of existing ADR IDs to avoid number collisions (optional)
- `context_view_path` — `Agente02_SoftwareArchitect/context_view.md` (§4 ADR Governance, §1.3 deviation list)

## Outputs

- `docs/adr/ADR-NNN-kebab-case-title.md` — the completed ADR file
- Updated reference in `Architecture_Decisions.md` — one-line entry: `ADR-NNN: [title] | Status: PROPOSED | Triggers gate: [gate]`

## Procedure

1. **Assign ADR number** — determine next available NNN by inspecting existing `docs/adr/` files and `existing_adrs` input. Zero-pad to three digits (e.g., `ADR-003`).

2. **Write the title** — one sentence, kebab-case for filename, title-case for document heading. Format: `Use [alternative] instead of [Golden Path default] for [reason context]`.

3. **Status** — always set to `PROPOSED`. Never set to `ACCEPTED`, `SUPERSEDED`, or `DEPRECATED` in the initial write. Tech Lead changes the status after review.

4. **Context section** — describe the problem in 3–5 sentences. Include: what situation triggered this decision, which PRD requirement it relates to, and what constraint makes the Golden Path default impractical or undesirable.

5. **Decision section** — state the chosen option in one clear sentence beginning with "We will…".

6. **Alternatives considered** — document at least 2 alternatives including the Golden Path default. For each alternative record:
   - What it is
   - Why it was considered
   - Why it was rejected (or why it was chosen)

7. **Consequences section** — list positive consequences (what becomes easier or better), negative consequences (what becomes harder or is sacrificed), and risks introduced. Be explicit — no "it might cause issues" vagueness.

8. **PRD traceability** — cite the exact PRD requirement ID that justifies this deviation.

9. **Verify completeness** — run `checklists/adr_authoring_checklist.md` before finalizing.

10. **Add entry to `Architecture_Decisions.md`** — reference ADR number, title, and status.

## Quality Gate

An ADR passes this skill's quality check when:
- Status is exactly `PROPOSED` (not ACCEPTED, not blank)
- At least 2 alternatives are documented with rejection rationale
- Decision section has a single clear "We will…" statement
- Consequences section lists at least one positive and one negative consequence
- PRD requirement ID is cited
- Filename matches pattern `ADR-NNN-kebab-case-title.md`

## Failure Modes

- **Immediate approval:** Writing status as `ACCEPTED` without Tech Lead review → hard block; status must be `PROPOSED`
- **Vague context:** Context section says "we chose X" without explaining the problem → rewrite to describe the forcing function first
- **Missing alternatives:** Only one option documented → add at least the Golden Path default as a considered-and-rejected alternative
- **No PRD traceability:** ADR exists without linking to a PRD requirement → every ADR must answer "what user need drives this?"
- **Number collision:** Two ADRs assigned the same NNN → always scan existing files before assigning

## RAG Policy

Authorized collections at runtime:
- `architecture_reference_full` (context_view.md §4 ADR Governance, §1.3 deviation list)
- `decision_rules_index` (knowledge/decision_rules.md)

Blocked at runtime: `context/`, `lib/`, raw PDFs, `base_teorica.md`

## Architecture Compliance

ADR format follows `context_view.md §4`. The status lifecycle is:
`PROPOSED → ACCEPTED → SUPERSEDED` or `PROPOSED → REJECTED`

Gate 2 remains `BLOCKED_PENDING_ADR` until the Tech Lead changes the ADR status to `ACCEPTED`.

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente02_SoftwareArchitect/knowledge/`
- `Agente02_SoftwareArchitect/context_view.md`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
