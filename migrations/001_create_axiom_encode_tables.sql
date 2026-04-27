-- Axiom Encode Supabase Schema
-- Run this in Supabase SQL editor to create the tables

-- Create axiom_encode schema
CREATE SCHEMA IF NOT EXISTS axiom_encode;

-- =============================================================================
-- Encoding Runs table - tracks each encoding attempt
-- =============================================================================
CREATE TABLE IF NOT EXISTS axiom_encode.runs (
    id TEXT PRIMARY KEY,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    citation TEXT NOT NULL,
    file_path TEXT,
    statute_text TEXT,

    -- Complexity factors (JSONB for flexibility)
    complexity JSONB DEFAULT '{}'::JSONB,

    -- The encoding journey
    iterations JSONB DEFAULT '[]'::JSONB,
    total_duration_ms INTEGER DEFAULT 0,

    -- Reviewer and oracle validation scores
    review_scores JSONB,

    -- Agent info
    agent_type TEXT DEFAULT 'encoder',
    agent_model TEXT DEFAULT 'claude-opus-4-5-20251101',

    -- RuleSpec content (could be large)
    rulespec_content TEXT,

    -- Session linkage
    session_id TEXT,

    -- Sync metadata
    synced_at TIMESTAMPTZ DEFAULT NOW(),
    source_db TEXT DEFAULT 'local'
);

CREATE INDEX IF NOT EXISTS idx_runs_citation ON axiom_encode.runs(citation);
CREATE INDEX IF NOT EXISTS idx_runs_timestamp ON axiom_encode.runs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_runs_agent ON axiom_encode.runs(agent_type, agent_model);

-- =============================================================================
-- Sessions table - Claude Code session transcripts
-- =============================================================================
CREATE TABLE IF NOT EXISTS axiom_encode.sessions (
    id TEXT PRIMARY KEY,
    run_id TEXT REFERENCES axiom_encode.runs(id),
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,
    model TEXT,
    cwd TEXT,
    event_count INTEGER DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    input_tokens INTEGER DEFAULT 0,
    output_tokens INTEGER DEFAULT 0,
    cache_read_tokens INTEGER DEFAULT 0,
    cache_creation_tokens INTEGER DEFAULT 0,
    estimated_cost_usd NUMERIC(10, 4) DEFAULT 0,
    synced_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sessions_run ON axiom_encode.sessions(run_id);
CREATE INDEX IF NOT EXISTS idx_sessions_started ON axiom_encode.sessions(started_at DESC);

-- =============================================================================
-- Session Events table - individual events within sessions
-- =============================================================================
CREATE TABLE IF NOT EXISTS axiom_encode.session_events (
    id TEXT PRIMARY KEY,
    session_id TEXT NOT NULL REFERENCES axiom_encode.sessions(id),
    sequence INTEGER NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    event_type TEXT NOT NULL,
    tool_name TEXT,
    content TEXT,
    metadata JSONB DEFAULT '{}'::JSONB,
    synced_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_events_session ON axiom_encode.session_events(session_id);
CREATE INDEX IF NOT EXISTS idx_events_type ON axiom_encode.session_events(event_type);

-- =============================================================================
-- Artifact Versions table - SCD2 versioning of plugins, specs, etc.
-- =============================================================================
CREATE TABLE IF NOT EXISTS axiom_encode.artifact_versions (
    id TEXT PRIMARY KEY,
    artifact_type TEXT NOT NULL,
    content_hash TEXT NOT NULL,
    version_label TEXT,
    content TEXT,
    effective_from TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    effective_to TIMESTAMPTZ,
    metadata JSONB DEFAULT '{}'::JSONB,
    synced_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_artifact_type ON axiom_encode.artifact_versions(artifact_type);
CREATE INDEX IF NOT EXISTS idx_artifact_current ON axiom_encode.artifact_versions(artifact_type, effective_to);
CREATE INDEX IF NOT EXISTS idx_artifact_hash ON axiom_encode.artifact_versions(content_hash);

-- =============================================================================
-- Run-Artifact junction table
-- =============================================================================
CREATE TABLE IF NOT EXISTS axiom_encode.run_artifacts (
    run_id TEXT NOT NULL REFERENCES axiom_encode.runs(id),
    artifact_version_id TEXT NOT NULL REFERENCES axiom_encode.artifact_versions(id),
    PRIMARY KEY (run_id, artifact_version_id)
);

-- =============================================================================
-- Views for easy querying
-- =============================================================================

-- Latest runs with summary
CREATE OR REPLACE VIEW axiom_encode.runs_summary AS
SELECT
    r.id,
    r.timestamp,
    r.citation,
    r.file_path,
    r.agent_type,
    r.agent_model,
    r.total_duration_ms,
    jsonb_array_length(r.iterations) as iteration_count,
    (r.iterations->-1->>'success')::boolean as final_success,
    r.review_scores->>'rulespec_reviewer' as rulespec_score,
    r.review_scores->>'formula_reviewer' as formula_score,
    r.review_scores->>'parameter_reviewer' as parameter_score,
    r.review_scores->>'integration_reviewer' as integration_score
FROM axiom_encode.runs r
ORDER BY r.timestamp DESC;

-- =============================================================================
-- Row Level Security (RLS)
-- =============================================================================
-- Keep base tables private. Public access should go through narrow RPCs only.

ALTER TABLE axiom_encode.runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE axiom_encode.sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE axiom_encode.session_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE axiom_encode.artifact_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE axiom_encode.run_artifacts ENABLE ROW LEVEL SECURITY;

-- Write access requires service_role. Public dashboard access should use
-- security-definer views or RPCs that expose only the intended fields.
CREATE POLICY "Allow service write access to runs" ON axiom_encode.runs
    FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "Allow service write access to sessions" ON axiom_encode.sessions
    FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "Allow service write access to events" ON axiom_encode.session_events
    FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "Allow service write access to artifacts" ON axiom_encode.artifact_versions
    FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "Allow service write access to run_artifacts" ON axiom_encode.run_artifacts
    FOR ALL TO service_role USING (true) WITH CHECK (true);

COMMENT ON SCHEMA axiom_encode IS 'Axiom Encode experiment tracking - encoding runs, sessions, calibration';
COMMENT ON TABLE axiom_encode.runs IS 'Individual encoding runs with iterations, reviewer scores, and oracle scores';
COMMENT ON TABLE axiom_encode.sessions IS 'Agent session transcripts';
COMMENT ON TABLE axiom_encode.session_events IS 'Individual events within sessions';
COMMENT ON TABLE axiom_encode.artifact_versions IS 'SCD2 versioned artifacts (RuleSpec schema, prompts, and validators)';
