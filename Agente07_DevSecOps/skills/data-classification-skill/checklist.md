# Data Classification Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/checklists/data_classification_checklist.md` and `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 009) before executing. Do NOT access `context/` or `lib/`.

## Entity Discovery
- [ ] All Prisma models touched by the feature listed (from schema.prisma)
- [ ] All fields within those models listed (not just table-level)
- [ ] All API response shapes listed (from API_Contract.json)
- [ ] All log entries listed (audit_log, sync_log)

## Per Entity Classification
- [ ] RESTRICTED criteria checked: health, financial, government ID, biometric, HIPAA/PCI
- [ ] CONFIDENTIAL criteria checked: email, name, preferences, behavioral data, user content
- [ ] INTERNAL criteria: internal IDs, timestamps, config, aggregate stats
- [ ] PUBLIC criteria: marketing content, public labels

## Highest Tier Determination
- [ ] Highest tier across all entities identified
- [ ] If RESTRICTED: issue BLOCKED_PENDING_HUMAN immediately — stop other reviews
- [ ] If CONFIDENTIAL: privacy_review_required: true
- [ ] If INTERNAL/PUBLIC: privacy_review_required: false (log check only)

## Output
- [ ] Data_Classification.md produced
- [ ] entities array populated for all identified entities
- [ ] highest_tier correctly set
- [ ] immediate_action correctly set based on highest_tier
