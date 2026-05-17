# Non-Functional Requirements Checklist

Use this checklist to verify that all 10 NFR categories are complete and contain measurable metrics before Gate 1 submission.

---

## General NFR Quality

- [ ] All 10 categories are present in `Non_Functional_Requirements.md`
- [ ] No category is empty or contains only "N/A" without justification
- [ ] Every NFR has a unique ID following NFR-[CATEGORY]-NNN convention
- [ ] Every NFR has an explicit priority (MUST / SHOULD / COULD)
- [ ] Every NFR has an acceptance criterion (how it will be verified)

---

## 1. Performance (NFR-PERF)

- [ ] At least one performance NFR with a response time threshold (e.g., "P95 ≤ Xs")
- [ ] Threshold specifies a percentile (P50, P95, P99) — not just "average"
- [ ] Load condition is specified where relevant (e.g., "under N concurrent users")

---

## 2. Security (NFR-SEC)

- [ ] At least one NFR covers authentication requirements
- [ ] At least one NFR covers authorization requirements
- [ ] NFR specifies expected HTTP status codes for unauthorized access (401, 403)
- [ ] Encryption requirements are stated if sensitive data is transmitted or stored

---

## 3. Privacy (NFR-PRIV)

- [ ] PII fields are explicitly identified (not just "personal data")
- [ ] At least one NFR states what must NOT appear in logs or error messages
- [ ] Data minimization principle addressed (only collect what is needed)
- [ ] Consent mechanism or access control stated where applicable

---

## 4. Availability (NFR-AVAIL)

- [ ] Uptime target specified as a percentage (e.g., "99.5% monthly")
- [ ] Measurement period defined (monthly / annually)
- [ ] Planned maintenance exclusions stated if applicable
- [ ] Recovery Time Objective (RTO) stated if known

---

## 5. Observability (NFR-OBS)

- [ ] Logging format specified (structured JSON or equivalent)
- [ ] Events that must be logged are identified (state changes, errors)
- [ ] Log delivery timing specified where relevant
- [ ] Monitoring alerting requirements stated if applicable

---

## 6. Auditability (NFR-AUDIT)

- [ ] Audit trail requirement is present (which actions must be auditable)
- [ ] Audit record content specified (user ID, action, timestamp, before/after)
- [ ] Audit retention period specified
- [ ] Audit access control specified (who can query audit logs)

---

## 7. Accessibility (NFR-ACC)

- [ ] WCAG standard and level referenced (e.g., "WCAG 2.1 Level AA")
- [ ] Keyboard navigation requirement stated
- [ ] Screen reader compatibility addressed if applicable
- [ ] Verification method stated (automated scan, manual checklist)

---

## 8. Maintainability (NFR-MAINT)

- [ ] Code quality metric stated (e.g., no circular dependencies, max complexity)
- [ ] Test coverage threshold stated for business logic
- [ ] Enforcement mechanism noted (lint rule, CI check, manual review)

---

## 9. Scalability (NFR-SCALE)

- [ ] Concurrent user target stated
- [ ] Data volume limit stated (records, storage size)
- [ ] Growth expectation noted (e.g., "must not require architectural changes for 12 months")

---

## 10. Data Retention (NFR-DRET)

- [ ] Retention period specified for each major data type
- [ ] Deletion policy specified (soft delete, hard delete, archival)
- [ ] Right-to-erasure compliance stated if applicable
- [ ] Regulatory or legal basis for retention period cited if known

---

**NFR section is ready when:** All 10 sections above are checked and every NFR has a measurable metric. NFRs without metrics will be returned for revision at Gate 1.
