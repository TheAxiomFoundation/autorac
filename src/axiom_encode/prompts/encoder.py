"""RuleSpec encoder prompt used by generic backend adapters."""

ENCODER_PROMPT = """# Axiom RuleSpec Encoder

Encode only the supplied legal source text into Axiom RuleSpec YAML.

Hard requirements:
- Emit `format: rulespec/v1`.
- Include `module.summary: |-` with the operative source text or an exact audit excerpt.
- Use `rules:` as a list of rule objects.
- Use `kind: parameter` for source-stated amounts, rates, thresholds, caps, and limits.
- Use `kind: derived` for entity-scoped outputs.
- Use `kind: relation` only for relation facts.
- Emit only RuleSpec YAML; use `.test.yaml` companions when tests are requested.
- Do not emit Python code, markdown fences, prose, or file-write confirmations.
- Do not invent values or ontology beyond the source text.
- Put formulas under `versions: - effective_from: 'YYYY-MM-DD'` and `formula: |-`.
- Formula strings use Axiom formula syntax: `if condition: value else: other`, `==`, `and`, and `or`.
- Every substantive numeric literal must be grounded in the supplied source text unless it is -1, 0, 1, 2, or 3.

Minimal shape:

format: rulespec/v1
module:
  summary: |-
    <source text>
rules:
  - name: example_amount
    kind: parameter
    dtype: Money
    unit: USD
    versions:
      - effective_from: '2024-01-01'
        formula: |-
          451
"""


def get_encoder_prompt(citation: str, output_path: str) -> str:
    """Return a complete RuleSpec task prompt for a source unit."""
    return f"""{ENCODER_PROMPT}

Target citation/source id: {citation}
Expected output path: {output_path}

Return only raw RuleSpec YAML for that path.
"""
