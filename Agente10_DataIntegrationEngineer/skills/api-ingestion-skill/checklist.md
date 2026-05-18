# api-ingestion-skill Checklist

## Pre-Execution
- [ ] External API documentation available
- [ ] Integration_Requirements.md reviewed for in-scope endpoints

## Execution
- [ ] API maturity classified (STABLE/BETA/ALPHA/UNDOCUMENTED)
- [ ] Authentication method identified and security rated
- [ ] All env var names documented (no literal values)
- [ ] Rate limits documented and consumption estimated
- [ ] Reliability profile assessed (SLA, latency, webhook delivery)
- [ ] Client file path: lib/integrations/[service].client.ts
- [ ] All public methods documented
- [ ] Timeout specified (default 10,000ms)
- [ ] API version pinned in base URL
- [ ] Zod schemas defined for all response shapes
- [ ] .passthrough() used (not .strict()) for unstable APIs
- [ ] Retry configuration specified
- [ ] Circuit breaker configuration specified
- [ ] Dead letter mechanism specified
- [ ] Webhook security specified if webhooks used (HMAC, timingSafeEqual)
- [ ] Out-of-scope capabilities documented

## Runtime Knowledge Policy
- [ ] Knowledge from Agente10_DataIntegrationEngineer/knowledge/ only
- [ ] context/ and lib/ not accessed

## Post-Execution
- [ ] External_API_Assessment.md produced using template
- [ ] literal_credentials_present = false in output
- [ ] Risk entries added to Data_Risks.md for API reliability and auth security
- [ ] Ready for data-mapping-skill
