# Changelog

All notable changes to Axiom Encode will be documented here.

## Unreleased

### Changed

- Renamed the package, CLI, imports, docs, and telemetry environment variables from the old project handle to `axiom-encode` / `axiom_encode`.
- Removed retired orchestrator, SDK orchestrator, encoder harness, and public stub/coverage/benchmark commands.
- Switched the active encoding path to Axiom RuleSpec YAML backed by `axiom-rules`.
- Renamed transcript session sync from SDK sessions to agent sessions.
- Extracted model pricing rates into `src/axiom_encode/harness/pricing_rates.toml` with a `version` and `effective_date`.
