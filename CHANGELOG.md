# Changelog

All notable changes to Axiom Encode will be documented here.

## Unreleased

### Added

- `axiom-encode encode` now logs a linked SDK-style session for each eval-backed run, using `session_id=encode-<run_id>`.
- Failed eval-backed encode runs now emit a sibling `*.repair.json` manifest with the run/session IDs, trace path, output path, and repair/rerun actions.

### Changed

- Renamed the package, CLI, imports, docs, and telemetry environment variables from the old project handle to `axiom-encode` / `axiom_encode`.
- Removed retired orchestrator, SDK orchestrator, encoder harness, and public stub/coverage/benchmark commands.
- Switched the active encoding path to Axiom RuleSpec YAML backed by `axiom-rules`.
- Renamed transcript session sync from SDK sessions to agent sessions.
- Supabase run sync now uploads the linked SDK session for eval-backed encode runs when write credentials are configured.
- Extracted model pricing rates into `src/axiom_encode/harness/pricing_rates.toml` with a `version` and `effective_date`.
