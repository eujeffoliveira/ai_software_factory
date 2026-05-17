# architecture-tradeoff-analysis-skill Checklist

## Pre-execution
- [ ] Decision question framed as a question ("Should we use X or Y for [context]?") — not as a conclusion
- [ ] At least 2 alternatives identified — including the Golden Path default if applicable
- [ ] Triggering context known: routine, ADR authoring, Council mediation, gate review, or stakeholder request
- [ ] Relevant evaluation criteria identified from `knowledge/heuristics.md`

## During execution
- [ ] Each alternative described clearly (not just named)
- [ ] Evaluation criteria chosen are relevant to the decision context (don't use performance criteria for a security decision)
- [ ] Each alternative scored per criterion: HIGH / MEDIUM / LOW (no numeric scores unless PRD has explicit thresholds)
- [ ] Primary tension named explicitly (the single core trade-off axis)
- [ ] Gains list: at least 1 specific concrete benefit for the chosen option
- [ ] Sacrifices list: at least 1 specific concrete cost for the chosen option
- [ ] No binary language: no "Option A is right / Option B is wrong" framing
- [ ] Revisit trigger stated: specific measurable condition that would make this decision wrong in hindsight
- [ ] Recommendation: one of `supports_current_architecture`, `recommends_change`, `escalate_to_council`

## Post-execution
- [ ] Trade-off section appended to `Architecture.md §Trade-offs` or `Architecture_Decisions.md`
- [ ] If recommendation is `recommends_change`: next action stated and sent to Tech Lead
- [ ] If recommendation is `escalate_to_council`: Council mediation triggered

## Runtime Knowledge Policy
- [ ] Skill does not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime
- [ ] Consult: `Agente02_SoftwareArchitect/knowledge/` (heuristics.md, knowledge_cards.md, decision_rules.md) and project artifacts as input only
