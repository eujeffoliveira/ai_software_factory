# Product Risk Analysis Skill

## Purpose
Identify product-level risks from the PRD, open questions, and scope boundary, classify them by impact and probability, and propose concrete mitigations.

## When to Use
- When the PRD is nearly complete and product risks need to be formally assessed before Gate 1 submission.
- When a new open question or scope change introduces a risk that must be registered.

## Inputs
- `PRD.md` (draft) — the product requirements document to analyze for risk signals
- `open_questions[]` — unresolved questions that represent uncertainty and therefore risk
- `scope_boundary` — the scope definition (in-scope creates delivery risks; out-of-scope deferral creates adoption risks)

## Outputs
- `Product_Risks.md` — risk register with PRISK-NNN entries following `templates/Product_Risks.md` format

## Constraints
- Risks must be product-level: scope, business, user adoption, data quality, regulatory, integration
- Technical implementation risks (e.g., "Choosing the wrong ORM") are NOT product risks — they are architecture risks for the Architect to assess
- Every HIGH-impact risk must have a concrete mitigation strategy — not just "monitor and react"
- Risks are not problems — they are potential future problems. Do not register already-known failures as risks
- Risk categories: scope / business / user / data / regulatory / integration

## Risk Category Definitions

- **Scope:** Risk that the defined scope is too large or too small (these are distinct risks requiring different mitigations — register them separately). Scope risks must be specific: "Risk that scope is too large because [feature X] is not clearly out-of-scope, leading to [consequence]" OR "Risk that scope is too small because [stakeholder Y's need] is not covered, leading to [consequence]".
- **Business:** Risk that the product fails to achieve its business objective (low adoption, wrong problem solved, business model change)
- **User:** Risk related to the target users not using or adopting the system as expected (UX friction, training needs, resistance)
- **Data:** Risk related to data quality, migration, volume, or PII handling
- **Regulatory:** Risk related to compliance requirements that may block launch or require costly changes
- **Integration:** Risk related to dependencies on external systems, third-party APIs, or data feeds not controlled by this team

## Step-by-Step Procedure

1. **Scan the PRD for risk signals.**
   - Objectives that depend on user behavior change → user adoption risk
   - Features with unresolved BLOCKING open questions → scope risk
   - Data requirements with PII or regulatory sensitivity → regulatory/data risk
   - Out-of-scope items that stakeholders may later demand → scope creep risk
   - Features depending on third-party services → integration risk
   - Business problem with quantified impact that the PRD's features may not fully address → business risk

2. **For each risk signal:** formulate a risk statement in the form "Risk that [what could go wrong] because [why it might happen], leading to [consequence]."

3. **Classify impact (HIGH/MEDIUM/LOW)** based on consequence severity:
   - HIGH: Would prevent product launch, cause significant user harm, or result in regulatory breach
   - MEDIUM: Would significantly degrade user experience or business value without preventing launch
   - LOW: Would cause minor friction or delay without major business impact

4. **Classify probability (HIGH/MEDIUM/LOW)** based on available evidence:
   - HIGH: Known signals or precedents suggest this is likely
   - MEDIUM: Possible but no strong evidence
   - LOW: Unlikely given current context

5. **For each HIGH-impact risk:** define a concrete mitigation strategy. Mitigation must be actionable (e.g., "conduct usability test with 5 target users before development" not "do research"). If a HIGH-impact risk cannot be mitigated within current constraints, do one of: (a) propose escalation to human operator for explicit risk acceptance before Gate 1, or (b) recommend descoping the feature driving the risk and adding it to `Scope_Boundary.md` as out-of-scope. Do not leave a HIGH-impact risk with no mitigation and no escalation path.

6. **For each HIGH×HIGH risk:** escalate in the handoff as a flag for the Architect.

7. **Write `Product_Risks.md`** using the template. Include both the summary table and full detail records for each risk.

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
