from pathlib import Path

import pytest

from axiom_encode.harness.validator_pipeline import ValidatorPipeline


def _repo_roots() -> tuple[Path, Path]:
    foundation_root = Path(__file__).resolve().parents[2]
    policy_repo_path = foundation_root / "rules-us" / "statute"
    axiom_rules_path = foundation_root / "axiom-rules"
    if not policy_repo_path.exists():
        pytest.skip("rules-us/statute repo not present")
    if not axiom_rules_path.exists():
        pytest.skip("axiom-rules repo not present")
    return policy_repo_path, axiom_rules_path


def test_repo_cross_statute_definitions_are_imported():
    policy_repo_path, axiom_rules_path = _repo_roots()
    pipeline = ValidatorPipeline(
        policy_repo_path=policy_repo_path,
        axiom_rules_path=axiom_rules_path,
        enable_oracles=False,
    )

    failures: list[str] = []
    for rulespec_file in sorted(policy_repo_path.rglob("*.yaml")):
        issues = pipeline._check_cross_statute_definition_imports(rulespec_file)
        if not issues:
            continue
        relative = rulespec_file.relative_to(policy_repo_path.parent)
        for issue in issues:
            failures.append(f"{relative}: {issue}")

    assert not failures, "Cross-statute definition import failures:\n" + "\n".join(
        failures
    )
