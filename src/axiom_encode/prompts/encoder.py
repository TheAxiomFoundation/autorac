"""RuleSpec encoder prompt used by generic backend adapters."""

ENCODER_PROMPT = """# Axiom RuleSpec Encoder

Encode only the supplied legal source text into Axiom RuleSpec YAML.

Hard requirements:
- Emit `format: rulespec/v1`.
- Include `module.summary: |-` with the operative source text or an exact audit excerpt.
- If the source has an ingested corpus provision, include
  `module.source_verification.corpus_citation_path` or
  `module.source_verification.corpus_citation_paths`.
- If accepted source claims are supplied, include their IDs under
  `module.source_claims`; do not inline claim bodies, values, formulas,
  evidence, or review metadata in RuleSpec.
- Include `module.proof_validation.required: true` and add
  `metadata.proof.atoms` to each policy-bearing rule. Each proof atom must point
  to direct corpus source text, a claim listed in `module.source_claims`, or an
  explicit imported RuleSpec export. If you cannot build that proof, stop and
  emit a typed request such as `missing_claim`, `bundle_expansion_request`,
  `corpus_defect`, `segmentation_fix`, `stale_claim`, or `conflicting_claims`.
- Do not emit `source_url`; RuleSpec validation reads normalized corpus provisions,
  not raw PDFs or web pages.
- Use `rules:` as a list of rule objects.
- Use `kind: parameter` for source-stated amounts, rates, thresholds, caps, and limits.
- Use `kind: parameter` with `indexed_by` and versioned `values` for source-stated
  numeric tables/scales keyed by household size, family size, income band,
  age band, or another row key. Do not encode those cells as `match` arms or
  numeric literals inside a derived formula.
- Use `kind: derived` for entity-scoped outputs.
- Use `kind: relation` only for relation facts.
- Use `kind: reiteration` for a provision that merely restates another
  canonical rule. It must include `reiterates.target` and must not include
  executable `versions`; optional `verification` may record matching source
  values for audit.
- Do not put source graph relationships on executable rules. If a source
  `sets`, `amends`, `implements`, or `reiterates` another source, reference
  accepted source claim IDs in `module.source_claims`.
- Emit only RuleSpec YAML; use `.test.yaml` companions when tests are requested.
- Do not emit Python code, markdown fences, prose, or file-write confirmations.
- Do not invent values or ontology beyond the source text.
- Put formulas under `versions: - effective_from: 'YYYY-MM-DD'` and `formula: |-`.
- Formula strings use Axiom formula syntax: `if condition: value else: other`, `==`, `and`, and `or`.
- Formula strings reference indexed parameter tables with `table_name[index_expr]`.
- Every substantive numeric literal must be grounded in the supplied source text unless it is -1, 0, 1, 2, or 3.

Minimal shape:

format: rulespec/v1
module:
  proof_validation:
    required: true
  summary: |-
    <source text>
rules:
  - name: example_amount
    kind: parameter
    dtype: Money
    unit: USD
    metadata:
      proof:
        atoms:
          - path: versions[0].formula
            kind: amount
            source:
              corpus_citation_path: <corpus path>
    versions:
      - effective_from: '2024-01-01'
        formula: |-
          451

Indexed table shape:

rules:
  - name: example_amount_by_household_size
    kind: parameter
    dtype: Money
    unit: USD
    indexed_by: household_size
    versions:
      - effective_from: '2025-10-01'
        values:
          1: 298
          2: 546
  - name: example_amount
    kind: derived
    entity: Household
    dtype: Money
    period: Month
    unit: USD
    versions:
      - effective_from: '2025-10-01'
        formula: example_amount_by_household_size[household_size]
"""


def get_encoder_prompt(
    citation: str,
    output_path: str,
    corpus_citation_path: str | None = None,
) -> str:
    """Return a complete RuleSpec task prompt for a source unit."""
    corpus_section = ""
    if corpus_citation_path:
        corpus_section = f"""
Corpus source path: {corpus_citation_path}
Include `module.source_verification.corpus_citation_path: {corpus_citation_path}` exactly.
"""

    return f"""{ENCODER_PROMPT}

Target citation/source id: {citation}
Expected output path: {output_path}
{corpus_section}

Return only raw RuleSpec YAML for that path.
"""
