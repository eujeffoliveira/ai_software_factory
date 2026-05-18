/**
 * K6 Load Test Template
 *
 * Perfis pré-configurados: smoke | load | stress | spike | endurance
 *
 * Uso:
 *   k6 run --env BASE_URL=https://app.example.com k6-template.js
 *   k6 run --env BASE_URL=https://app.example.com --env STAGES=stress k6-template.js
 *   k6 run --env BASE_URL=https://app.example.com --env AUTH_TOKEN="Bearer xxx" k6-template.js
 *
 * Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/shared/templates/sentinel
 */
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Counter, Rate, Trend } from 'k6/metrics';

const errorRate = new Rate('errors');
const responseTime = new Trend('response_time_ms');
const requestCount = new Counter('request_count');

// CUSTOMIZAR: adicionar rotas da aplicacao
const ROUTES = JSON.parse(__ENV.ROUTES || 'null') ?? [
  '/',
  '/login',
  '/dashboard',
  '/api/health',
];

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';
const AUTH_TOKEN = __ENV.AUTH_TOKEN || '';

// Perfis de carga pré-configurados
const STAGE_PROFILES = {
  smoke: [
    { duration: '30s', target: 5 },
  ],
  load: [
    { duration: '2m', target: 10 },
    { duration: '5m', target: 50 },
    { duration: '2m', target: 0 },
  ],
  stress: [
    { duration: '2m', target: 20 },
    { duration: '5m', target: 100 },
    { duration: '2m', target: 0 },
  ],
  spike: [
    { duration: '1m', target: 10 },
    { duration: '30s', target: 200 },
    { duration: '1m', target: 10 },
    { duration: '2m', target: 0 },
  ],
  endurance: [
    { duration: '2m', target: 30 },
    { duration: '5m', target: 30 },
    { duration: '2m', target: 0 },
  ],
};

const stageName = __ENV.STAGES || 'smoke';
const stages = STAGE_PROFILES[stageName] || STAGE_PROFILES.smoke;

export const options = {
  stages,
  thresholds: {
    response_time_ms: ['p(95)<2000'],
    errors: ['rate<0.05'],
    http_req_duration: ['p(95)<2000'],
    http_req_failed: ['rate<0.05'],
  },
};

export default function () {
  const route = ROUTES[Math.floor(Math.random() * ROUTES.length)];
  const url = `${BASE_URL}${route}`;

  const headers = {
    'Content-Type': 'application/json',
    ...(AUTH_TOKEN ? { Authorization: AUTH_TOKEN } : {}),
  };

  const response = http.get(url, { headers, timeout: '10s' });

  const success = check(response, {
    'status is 2xx or 3xx': (r) => r.status >= 200 && r.status < 400,
    'response time < 2s': (r) => r.timings.duration < 2000,
  });

  errorRate.add(!success);
  responseTime.add(response.timings.duration);
  requestCount.add(1);

  sleep(Math.random() * 2 + 1); // 1-3 segundos entre requisicoes
}

export function handleSummary(data) {
  return {
    stdout: JSON.stringify(
      {
        metrics: {
          p95_ms: data.metrics.response_time_ms?.values?.['p(95)'],
          error_rate: data.metrics.errors?.values?.rate,
          total_requests: data.metrics.request_count?.values?.count,
        },
        thresholds_passed: !Object.values(data.thresholds || {}).some((t) => t.ok === false),
      },
      null,
      2
    ),
  };
}
