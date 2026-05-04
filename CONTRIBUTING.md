# Contributing

Use short-lived branches off `main` and open a pull request back to `main`.
Keep the PR focused on one change, describe the validation you ran, and wait
for CI before merging.

## Pull request flow

1. Create a branch from an up-to-date `main`.
2. Make the smallest coherent change and include tests for behavior changes.
3. Add a Towncrier fragment under `changelog.d/` unless the PR is docs,
   tests-only, or otherwise has no user-visible release note.
4. Open the PR to `main` and complete the PR template.
5. Merge after review approval and green CI.

Towncrier fragment categories are `breaking`, `added`, `changed`, `fixed`, and
`removed`. Name fragments descriptively, for example
`changelog.d/proof-validation.fixed.md`.

## Local checks

CI runs the changelog draft, pytest, Ruff lint, and Ruff format checks. Run the
relevant subset locally before opening the PR:

```bash
uv venv --python 3.13
uv pip install -e ".[dev]"
.venv/bin/python -m towncrier build --draft --version 0.0.0
.venv/bin/pytest tests/ -v
ruff check src/ tests/
ruff format --check src/ tests/
```

## Repo notes

- `axiom-encode encode` depends on corpus provisions; use local
  `axiom-corpus/data/corpus/provisions` artifacts when exercising encode paths.
- Keep generated encoding outputs, traces, repair manifests, and eval artifacts
  out of commits unless a fixture is intentionally part of the test.
- Do not include model credentials or Supabase secrets in PRs.
