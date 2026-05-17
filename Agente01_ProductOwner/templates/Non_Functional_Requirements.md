# Non-Functional Requirements

**Project:** [PROJECT_NAME]
**Date:** [DATE]
**Version:** [VERSION]

---

## Policy

- Every NFR must include a **measurable metric**. NFRs without a metric are not accepted.
- NFRs use naming convention: `NFR-[CATEGORY]-[NNN]`
- All 10 categories are mandatory. If a category has no applicable NFR for this project, state "N/A — [reason]".
- NFRs are product requirements. Implementation decisions (e.g., which caching layer to use) belong to the Architect.

---

## 1. Performance

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-PERF-001 | <!-- FILL: Performance requirement --> | <!-- FILL: Measurable threshold, e.g., "P95 ≤ 2s" --> | MUST | <!-- FILL: How to verify this metric --> |
| NFR-PERF-002 | <!-- FILL: Additional performance requirement --> | <!-- FILL: Metric --> | SHOULD | <!-- FILL: Acceptance criterion --> |

---

## 2. Security

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-SEC-001 | <!-- FILL: Authentication/authorization requirement --> | <!-- FILL: e.g., "All endpoints return 401 for unauthenticated requests" --> | MUST | <!-- FILL --> |
| NFR-SEC-002 | <!-- FILL: Data protection or encryption requirement --> | <!-- FILL: Metric --> | MUST | <!-- FILL --> |

---

## 3. Privacy

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-PRIV-001 | <!-- FILL: PII handling requirement --> | <!-- FILL: e.g., "PII fields X, Y, Z not present in application logs" --> | MUST | <!-- FILL --> |
| NFR-PRIV-002 | <!-- FILL: Consent or access control requirement --> | <!-- FILL: Metric --> | MUST | <!-- FILL --> |

---

## 4. Availability

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-AVAIL-001 | <!-- FILL: Uptime requirement --> | <!-- FILL: e.g., "≥ 99.5% monthly availability excluding planned maintenance" --> | MUST | <!-- FILL: How measured / SLA definition --> |
| NFR-AVAIL-002 | <!-- FILL: Recovery time objective --> | <!-- FILL: e.g., "RTO ≤ 30 minutes for full service restoration" --> | SHOULD | <!-- FILL --> |

---

## 5. Observability

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-OBS-001 | <!-- FILL: Logging requirement --> | <!-- FILL: e.g., "Structured JSON logs for all state-changing operations within 500ms" --> | MUST | <!-- FILL --> |
| NFR-OBS-002 | <!-- FILL: Monitoring/alerting requirement --> | <!-- FILL: Metric --> | SHOULD | <!-- FILL --> |

---

## 6. Auditability

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-AUDIT-001 | <!-- FILL: Audit trail requirement --> | <!-- FILL: e.g., "All admin actions recorded with user ID, action type, timestamp, and before/after values" --> | MUST | <!-- FILL --> |
| NFR-AUDIT-002 | <!-- FILL: Audit retention requirement --> | <!-- FILL: e.g., "Audit logs retained for 24 months and queryable by authorized administrators" --> | MUST | <!-- FILL --> |

---

## 7. Accessibility

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-ACC-001 | <!-- FILL: Accessibility standard requirement --> | <!-- FILL: e.g., "All interactive components comply with WCAG 2.1 Level AA" --> | MUST | <!-- FILL: How to verify — automated scan + manual checklist --> |
| NFR-ACC-002 | <!-- FILL: Keyboard navigation requirement --> | <!-- FILL: e.g., "All workflows completable using keyboard-only navigation" --> | SHOULD | <!-- FILL --> |

---

## 8. Maintainability

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-MAINT-001 | <!-- FILL: Code quality or structure requirement --> | <!-- FILL: e.g., "Zero circular dependencies between domain modules" --> | MUST | <!-- FILL: Enforced by lint rule or checked manually --> |
| NFR-MAINT-002 | <!-- FILL: Documentation or testability requirement --> | <!-- FILL: e.g., "Unit test coverage ≥ 80% for business logic modules" --> | SHOULD | <!-- FILL --> |

---

## 9. Scalability

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-SCALE-001 | <!-- FILL: User concurrency requirement --> | <!-- FILL: e.g., "System supports up to 500 concurrent sessions without performance degradation beyond NFR-PERF-001 thresholds" --> | MUST | <!-- FILL --> |
| NFR-SCALE-002 | <!-- FILL: Data volume scalability requirement --> | <!-- FILL: e.g., "System handles up to 1 million records per entity without architectural changes" --> | SHOULD | <!-- FILL --> |

---

## 10. Data Retention

| ID | Description | Metric | Priority | Acceptance Criterion |
|---|---|---|---|---|
| NFR-DRET-001 | <!-- FILL: Retention period requirement --> | <!-- FILL: e.g., "User records retained for 5 years after account closure" --> | MUST | <!-- FILL --> |
| NFR-DRET-002 | <!-- FILL: Deletion / right-to-erasure requirement --> | <!-- FILL: e.g., "User data deletable within 30 days of verified written request" --> | MUST | <!-- FILL --> |

---

## Summary Table

| Category | NFR Count | MUST | SHOULD | All Metrics Present |
|---|---|---|---|---|
| Performance | [N] | [N] | [N] | [Yes/No] |
| Security | [N] | [N] | [N] | [Yes/No] |
| Privacy | [N] | [N] | [N] | [Yes/No] |
| Availability | [N] | [N] | [N] | [Yes/No] |
| Observability | [N] | [N] | [N] | [Yes/No] |
| Auditability | [N] | [N] | [N] | [Yes/No] |
| Accessibility | [N] | [N] | [N] | [Yes/No] |
| Maintainability | [N] | [N] | [N] | [Yes/No] |
| Scalability | [N] | [N] | [N] | [Yes/No] |
| Data Retention | [N] | [N] | [N] | [Yes/No] |
