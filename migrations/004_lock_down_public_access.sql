-- Reassert the clean public-read/service-write policy surface.

ALTER TABLE IF EXISTS encodings.encoding_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS lab.agent_transcripts ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS lab.sdk_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS lab.sdk_session_events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS anon_read ON encodings.encoding_runs;
CREATE POLICY anon_read ON encodings.encoding_runs
    FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS authenticated_read ON encodings.encoding_runs;
CREATE POLICY authenticated_read ON encodings.encoding_runs
    FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS anon_read ON lab.agent_transcripts;
CREATE POLICY anon_read ON lab.agent_transcripts
    FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS authenticated_read ON lab.agent_transcripts;
CREATE POLICY authenticated_read ON lab.agent_transcripts
    FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS anon_read ON lab.sdk_sessions;
CREATE POLICY anon_read ON lab.sdk_sessions
    FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS authenticated_read ON lab.sdk_sessions;
CREATE POLICY authenticated_read ON lab.sdk_sessions
    FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS anon_read ON lab.sdk_session_events;
CREATE POLICY anon_read ON lab.sdk_session_events
    FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS authenticated_read ON lab.sdk_session_events;
CREATE POLICY authenticated_read ON lab.sdk_session_events
    FOR SELECT TO authenticated USING (true);

GRANT USAGE ON SCHEMA encodings TO postgres, service_role, anon, authenticated;
GRANT USAGE ON SCHEMA lab TO postgres, service_role, anon, authenticated;

GRANT SELECT ON encodings.encoding_runs TO anon, authenticated;
GRANT SELECT ON lab.agent_transcripts TO anon, authenticated;
GRANT SELECT ON lab.sdk_sessions TO anon, authenticated;
GRANT SELECT ON lab.sdk_session_events TO anon, authenticated;

GRANT ALL ON encodings.encoding_runs TO postgres, service_role;
GRANT ALL ON lab.agent_transcripts TO postgres, service_role;
GRANT ALL ON lab.sdk_sessions TO postgres, service_role;
GRANT ALL ON lab.sdk_session_events TO postgres, service_role;
