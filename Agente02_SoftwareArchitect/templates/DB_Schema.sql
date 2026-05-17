-- DB Schema — [Project Name]
-- Version: 1.0
-- Date: YYYY-MM-DD
-- Architect: Agente02_SoftwareArchitect
-- NOTE: This is a supplementary SQL representation.
-- The authoritative source is Prisma_Schema_Proposal.prisma.
-- Migrations are managed via `prisma migrate deploy`.

-- ============================================================
-- AUDIT AND SYNC TABLES (mandatory)
-- ============================================================

CREATE TABLE audit_logs (
  id            TEXT        PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  actor_user_id TEXT        NOT NULL,
  actor_email   TEXT        NOT NULL,          -- PII: operational
  action        TEXT        NOT NULL,
  entity_type   TEXT        NOT NULL,
  entity_id     TEXT,
  metadata      JSONB,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_actor ON audit_logs(actor_user_id);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);

CREATE TABLE sync_logs (
  id          TEXT        PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  job         TEXT        NOT NULL,
  executed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  duration_ms INTEGER     NOT NULL,
  status      TEXT        NOT NULL CHECK (status IN ('success', 'error', 'partial')),
  counts      JSONB,
  error_msg   TEXT
);

CREATE INDEX idx_sync_logs_job ON sync_logs(job);
CREATE INDEX idx_sync_logs_executed ON sync_logs(executed_at DESC);

-- ============================================================
-- IDENTITY AND AUTH
-- ============================================================

CREATE TABLE users (
  id         TEXT        PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  email      TEXT        UNIQUE NOT NULL,       -- PII: personal
  name       TEXT,                              -- PII: personal
  image      TEXT,
  role       TEXT        NOT NULL DEFAULT 'user',
  status     TEXT        NOT NULL DEFAULT 'pending'
                         CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);

-- ============================================================
-- DOMAIN MODELS
-- (Replace with actual entities from PRD and Architecture.md)
-- ============================================================

-- Example entity — replace with your actual domain entities
CREATE TABLE example_entities (
  id         TEXT        PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  name       TEXT        NOT NULL,
  status     TEXT        NOT NULL DEFAULT 'active',
  owner_id   TEXT        NOT NULL REFERENCES users(id),
  metadata   JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_example_entities_owner ON example_entities(owner_id);
CREATE INDEX idx_example_entities_status ON example_entities(status);

-- ============================================================
-- NOTES
-- ============================================================
-- 1. All tables use snake_case naming
-- 2. All IDs are TEXT using gen_random_uuid() for UUID generation
-- 3. All timestamps use TIMESTAMPTZ (timezone-aware)
-- 4. Prisma field names are camelCase; mapped via @map in schema.prisma
-- 5. For destructive changes, always use phased migrations
-- 6. Never modify this file directly for production -- use Prisma migrations
