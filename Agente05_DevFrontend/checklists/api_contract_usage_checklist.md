# API Contract Usage Checklist

**Agent:** Agente05_DevFrontend
**Run:** Before implementing any component that consumes API data

## Runtime Knowledge Policy

> Consult `Agente05_DevFrontend/knowledge/principles.md` (P8, P12) and `Agente05_DevFrontend/knowledge/decision_rules.md` (DR015, DR017, DR018) for contract consumption rules. Do not consult `context/` at runtime.

---

## Section 1: Contract Verification (Do Before Writing Any Code)

- [ ] **CV-01** Opened `API_Contract.json` and located the relevant feature domain section
- [ ] **CV-02** Found the specific endpoint(s) this component will consume
- [ ] **CV-03** Noted the HTTP method (GET, POST, etc.) and path for each endpoint
- [ ] **CV-04** Noted the request schema (query params, request body fields)
- [ ] **CV-05** Noted the response schema (all fields, their types, required vs. optional)
- [ ] **CV-06** Noted any enum values in the response (status fields, type fields, etc.)

**If an endpoint the component needs is NOT in the contract:**
→ STOP. Do not implement. Escalate to Agente00_TechLead immediately.

---

## Section 2: TypeScript Interface Derivation (P12, DR018)

- [ ] **TS-01** Created TypeScript interface(s) for API response types
- [ ] **TS-02** Every field in the interface matches a field in the contract response schema
- [ ] **TS-03** No extra fields added that aren't in the contract
- [ ] **TS-04** No fields assumed/invented based on what "probably exists"
- [ ] **TS-05** Field types match contract types (string, number, boolean, string enum, etc.)
- [ ] **TS-06** Date fields typed as `string` (ISO 8601) — not `Date` object (serialization boundary)
- [ ] **TS-07** Optional fields in contract are `optional?: type` in TypeScript (not required)
- [ ] **TS-08** Enum values match contract enum values exactly (same casing)
- [ ] **TS-09** No `any` used for response types

---

## Section 3: Server Component Data Fetching

- [ ] **SC-01** Using the Server Action imported from `features/[domain]/actions/` (not raw fetch)
- [ ] **SC-02** Server Action return type matches the contract response shape
- [ ] **SC-03** Null/undefined case handled (what if the API returns null?)
- [ ] **SC-04** Array results have an empty array fallback (never `.map()` on undefined)

---

## Section 4: SWR Polling Data Fetching

- [ ] **SWR-01** SWR endpoint URL matches the contract path exactly
- [ ] **SWR-02** Fetcher function handles non-ok responses (`if (!r.ok) throw new Error(...)`)
- [ ] **SWR-03** `useSWR` typed with the contract response type: `useSWR<ContractResponseType>`
- [ ] **SWR-04** No invented query parameters not defined in the contract

---

## Section 5: Server Action Calls (Mutations)

- [ ] **SA-01** Server Action called directly (not via `fetch()` to an API route)
- [ ] **SA-02** Input shape sent to the Server Action matches the contract request schema
- [ ] **SA-03** No extra fields sent that aren't in the contract request schema
- [ ] **SA-04** Error response from Server Action handled (`result.success === false`)

---

## Section 6: Contract Compliance Confirmation

- [ ] **COMP-01** Every URL called by this component exists in `API_Contract.json`
- [ ] **COMP-02** Every response field used is defined in the contract
- [ ] **COMP-03** No invented endpoint paths
- [ ] **COMP-04** No invented response fields used in the UI

---

**Sign-off:** All contract references verified → proceed to component implementation
