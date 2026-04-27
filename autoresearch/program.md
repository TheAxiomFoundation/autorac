# Axiom Encode Prompt Tuning

## Goal

Improve Axiom Encode's source-slice RuleSpec behavior by editing the eval prompt surface and keeping only changes that improve frozen benchmark readiness.

## Editable Surface

Preferred prompt-edit target:

- `src/axiom_encode/harness/eval_prompt_surface.py`

Do not weaken deterministic validators, benchmark manifests, source registries, or promotion/sync scripts just to make a benchmark pass.

## Frozen Benchmarks

Run all of:

- `benchmarks/uk_wave18_remaining_repair.yaml`
- `benchmarks/uk_wave19_failure_repair.yaml`
- `benchmarks/uk_wave19_branch_conjunction_repair.yaml`
- `benchmarks/uk_autoresearch_partner_disjunction.yaml`
- `benchmarks/uk_autoresearch_semantic_margin.yaml`

Treat those as the inner-loop training set.

## Final Review Holdout

A candidate is not accepted on training score alone. It must also avoid regressing:

- `benchmarks/uk_autoresearch_final_review.yaml`

Do not spend iterations on naming cleanup, readability tweaks, or token-count reduction unless benchmark evidence shows the naming itself causes semantic or reviewer failure.
