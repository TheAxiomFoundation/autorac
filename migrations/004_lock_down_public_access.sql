-- Tighten RLS policies on Axiom Encode telemetry tables.
-- Apply this before exposing any public dashboard.

DO $$
BEGIN
    IF to_regclass('public.encoding_runs') IS NOT NULL THEN
        ALTER TABLE public.encoding_runs ENABLE ROW LEVEL SECURITY;
        DROP POLICY IF EXISTS "Allow public read" ON public.encoding_runs;
        DROP POLICY IF EXISTS "Allow service write" ON public.encoding_runs;
        DROP POLICY IF EXISTS "encoding_runs_read_all" ON public.encoding_runs;
        DROP POLICY IF EXISTS "encoding_runs_service_write" ON public.encoding_runs;
        CREATE POLICY "Allow service write" ON public.encoding_runs
            FOR ALL TO service_role
            USING (true)
            WITH CHECK (true);
    END IF;
END
$$;

DO $$
BEGIN
    IF to_regclass('axiom_encode.agent_transcripts') IS NOT NULL THEN
        ALTER TABLE axiom_encode.agent_transcripts ENABLE ROW LEVEL SECURITY;
        DROP POLICY IF EXISTS "Allow anonymous access to agent_transcripts" ON axiom_encode.agent_transcripts;
        DROP POLICY IF EXISTS "Allow service access to agent_transcripts" ON axiom_encode.agent_transcripts;
        CREATE POLICY "Allow service access to agent_transcripts" ON axiom_encode.agent_transcripts
            FOR ALL TO service_role
            USING (true)
            WITH CHECK (true);
    END IF;

    IF to_regclass('axiom_encode.runs') IS NOT NULL THEN
        ALTER TABLE axiom_encode.runs ENABLE ROW LEVEL SECURITY;
        DROP POLICY IF EXISTS "Allow public read access to runs" ON axiom_encode.runs;
        DROP POLICY IF EXISTS "Allow service write access to runs" ON axiom_encode.runs;
        CREATE POLICY "Allow service write access to runs" ON axiom_encode.runs
            FOR ALL TO service_role
            USING (true)
            WITH CHECK (true);
    END IF;

    IF to_regclass('axiom_encode.sessions') IS NOT NULL THEN
        ALTER TABLE axiom_encode.sessions ENABLE ROW LEVEL SECURITY;
        DROP POLICY IF EXISTS "Allow public read access to sessions" ON axiom_encode.sessions;
        DROP POLICY IF EXISTS "Allow service write access to sessions" ON axiom_encode.sessions;
        CREATE POLICY "Allow service write access to sessions" ON axiom_encode.sessions
            FOR ALL TO service_role
            USING (true)
            WITH CHECK (true);
    END IF;

    IF to_regclass('axiom_encode.session_events') IS NOT NULL THEN
        ALTER TABLE axiom_encode.session_events ENABLE ROW LEVEL SECURITY;
        DROP POLICY IF EXISTS "Allow public read access to events" ON axiom_encode.session_events;
        DROP POLICY IF EXISTS "Allow service write access to events" ON axiom_encode.session_events;
        CREATE POLICY "Allow service write access to events" ON axiom_encode.session_events
            FOR ALL TO service_role
            USING (true)
            WITH CHECK (true);
    END IF;

    IF to_regclass('axiom_encode.agent_sessions') IS NOT NULL THEN
        ALTER TABLE axiom_encode.agent_sessions ENABLE ROW LEVEL SECURITY;
        DROP POLICY IF EXISTS "Allow public read agent_sessions" ON axiom_encode.agent_sessions;
        DROP POLICY IF EXISTS "Allow service write agent_sessions" ON axiom_encode.agent_sessions;
        CREATE POLICY "Allow service write agent_sessions" ON axiom_encode.agent_sessions
            FOR ALL TO service_role
            USING (true)
            WITH CHECK (true);
    END IF;

    IF to_regclass('axiom_encode.agent_session_events') IS NOT NULL THEN
        ALTER TABLE axiom_encode.agent_session_events ENABLE ROW LEVEL SECURITY;
        DROP POLICY IF EXISTS "Allow public read agent_session_events" ON axiom_encode.agent_session_events;
        DROP POLICY IF EXISTS "Allow service write agent_session_events" ON axiom_encode.agent_session_events;
        CREATE POLICY "Allow service write agent_session_events" ON axiom_encode.agent_session_events
            FOR ALL TO service_role
            USING (true)
            WITH CHECK (true);
    END IF;
END
$$;
