# etl-planning-skill Checklist

## Pre-Execution
- [ ] Data_Mapping.md available
- [ ] Total record count estimated
- [ ] Source data format confirmed
- [ ] LGPD assessment completed if migration includes personal data

## Execution
- [ ] Extraction strategy defined (batch size, pagination, rate limit budget)
- [ ] Transformation pipeline defined with TypeScript function signatures
- [ ] Load order defined respecting referential integrity
- [ ] Idempotency specified (upsert with externalId for all entity types)
- [ ] Progress tracking checkpointing defined
- [ ] Rollback plan documented
- [ ] Performance estimate calculated (duration, API calls)
- [ ] Vercel function timeout checked (max 10 min for Pro plan)
- [ ] sync_log monitoring specified per batch

## Runtime Knowledge Policy
- [ ] Knowledge from Agente10_DataIntegrationEngineer/knowledge/ only
- [ ] context/ and lib/ not accessed

## Post-Execution
- [ ] ETL plan embedded in Integration_Spec.md
- [ ] Rollback plan approved by Agente00_TechLead (for production migrations)
- [ ] Performance estimate within acceptable bounds
