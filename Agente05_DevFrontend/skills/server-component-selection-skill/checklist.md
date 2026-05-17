# Server Component Selection — Checklist

## Pre-Execution
- [ ] Component name and requirements are clearly stated
- [ ] File path is specified

## Decision Checks (DR001–DR005)
- [ ] DR001 (useState/useReducer): checked — result documented
- [ ] DR002 (useEffect/useRef): checked — result documented
- [ ] DR003 (event handlers): checked — result documented
- [ ] DR004 (browser APIs): checked — result documented
- [ ] DR005 (Recharts/browser library): checked — result documented

## Decision Output
- [ ] `component_type` set to ServerComponent or ClientComponent
- [ ] `justification` written (1–3 sentences)
- [ ] If ClientComponent: `client_trigger` identifies which DR applies
- [ ] `recommended_template` selected
- [ ] Companion file needs documented

## Client Component Boundary Review (if ClientComponent)
- [ ] Minimum boundary evaluated — can it be pushed deeper in the tree?
- [ ] Static parts remain as Server Components if possible

## Runtime Knowledge Policy
- [ ] Decision based only on `knowledge/decision_rules.md` DR001–DR006
- [ ] No external React documentation consulted at runtime
