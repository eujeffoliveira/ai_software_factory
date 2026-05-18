# Agente07_DevSecOps — Sentinel Security Framework

SENTINEL is a security scoring framework that tracks the security posture of a project through 6 dimensions, producing an SSS (Security Sentinel Score) used to gate deployments.

## Files

| File | Purpose |
|------|---------|
| `sentinel-certificate.md` | Certificate template — issued when SSS >= threshold |
| `sentinel-state.json` | Current SENTINEL state (score, phase, dimension scores) |
| `k6-template.js` | k6 load testing template with 5 profiles |

## SSS Score Dimensions

| Dimension | Code | Description | Weight |
|-----------|------|-------------|--------|
| S1-SHIELD | Shield | Authentication & authorization controls | 20% |
| S2-SCAN | Scan | Dependency vulnerability scanning | 15% |
| S3-SEAL | Seal | Data encryption and secrets management | 20% |
| S4-SENTRY | Sentry | Monitoring, logging, alerting | 15% |
| S5-SPEC | Spec | Security testing coverage | 15% |
| S6-GUARD | Guard | LGPD/compliance and governance | 15% |

**Deployment gate: SSS >= 80**

## Using sentinel-state.json

Update after each security review cycle:

```json
{
  "version": "1.0.0",
  "phase": "PRE_FLIGHT",
  "sss": 0,
  "threshold": 80,
  "dimensions": {
    "S1-SHIELD": {"score": 0, "max": 100, "status": "PENDING"},
    "S2-SCAN": {"score": 0, "max": 100, "status": "PENDING"},
    "S3-SEAL": {"score": 0, "max": 100, "status": "PENDING"},
    "S4-SENTRY": {"score": 0, "max": 100, "status": "PENDING"},
    "S5-SPEC": {"score": 0, "max": 100, "status": "PENDING"},
    "S6-GUARD": {"score": 0, "max": 100, "status": "PENDING"}
  }
}
```

## k6-template.js Load Test Profiles

| Profile | VUs | Duration | Use Case |
|---------|-----|----------|---------|
| smoke | 1 | 30s | Verify test works, baseline |
| load | 10 | 5m | Normal expected traffic |
| stress | 20→50 | 10m | Above-normal traffic |
| spike | 0→100→0 | 5m | Sudden traffic burst |
| endurance | 10 | 30m | Sustained load, memory leaks |

```bash
# Run smoke test
k6 run --env PROFILE=smoke Agente07_DevSecOps/tools/sentinel/k6-template.js

# Run load test against staging
BASE_URL=https://staging.example.com k6 run --env PROFILE=load k6-template.js
```

Thresholds: p95 < 2000ms, error rate < 5%
