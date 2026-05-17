# Data Requirements Checklist

Use this checklist to verify that data requirements in the PRD are complete, appropriately scoped, and free of architectural decisions.

---

## Entity Identification

- [ ] All core business entities are identified (e.g., User, Appointment, Report)
- [ ] Each entity has a brief description of what it represents in business terms
- [ ] Key business-level attributes are listed for each entity (e.g., "name, status, creation date") — not column names
- [ ] Relationships between entities are noted at a conceptual level (e.g., "an Appointment belongs to one User")
- [ ] Entities referenced in user stories are all accounted for in data requirements

---

## PII and Sensitive Data

- [ ] All fields that contain personally identifiable information (PII) are explicitly flagged
- [ ] PII fields are named using business language (e.g., "full name, email address, phone number")
- [ ] Sensitive business data (e.g., financial figures, proprietary content) is flagged separately from PII
- [ ] Data sensitivity classification aligns with the privacy NFRs (NFR-PRIV)

---

## Retention and Lifecycle

- [ ] Data retention requirements are stated at entity level where known
- [ ] Retention requirements are consistent with NFR-DRET entries
- [ ] Data deletion or archival policy is noted (even if "unknown — see OQ-NNN")
- [ ] If right-to-erasure applies, which entities are subject to it is stated

---

## Boundaries — What Does NOT Belong Here

- [ ] No database schema is included (no table names, column names, or indexes)
- [ ] No ORM model definitions are included (no Prisma syntax, no SQL DDL)
- [ ] No normalization decisions are included (that is the Architect's domain)
- [ ] No storage technology is specified (no "PostgreSQL", "Redis", "S3")
- [ ] No API field names are specified (that is the API contract domain)
- [ ] No implementation decisions about how data is persisted are included

---

## Completeness

- [ ] Data requirements are present in both the PRD (Section 11) and are consistent with NFRs
- [ ] Volume expectations are noted if known (order of magnitude is sufficient — e.g., "tens of thousands of records")
- [ ] Any external data dependencies (imported data, third-party feeds) are identified
- [ ] Any data migration requirements from existing systems are noted or explicitly stated as out-of-scope

---

**Data Requirements section is ready when:** All items above are checked. Any schema-level decisions found in this section will be moved to the Architect's briefing and removed from the PRD.
