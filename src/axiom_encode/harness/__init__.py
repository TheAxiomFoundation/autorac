# Encoding harness
# Feedback loop for AI-assisted RuleSpec encoding
# Self-contained -- no external plugin dependencies.

from .backends import (
    AgentSDKBackend,
    ClaudeCodeBackend,
    CodexCLIBackend,
    EncoderBackend,
    EncoderRequest,
    EncoderResponse,
    PredictionScores,
)
from .encoding_db import (
    ComplexityFactors,
    EncodingDB,
    EncodingRun,
    Iteration,
    IterationError,
    ReviewResult,
    ReviewResults,
    create_run,
)
from .evals import (
    EvalResult,
    EvalRunnerSpec,
    evaluate_artifact,
    parse_runner_spec,
    run_model_eval,
)
from .metrics import (
    CalibrationMetrics,
    CalibrationSnapshot,
    compute_calibration,
    get_calibration_trend,
    print_calibration_report,
    save_calibration_snapshot,
)
from .validator_pipeline import (
    PipelineResult,
    ValidationResult,
    ValidatorPipeline,
    validate_file,
)

__all__ = [
    # Encoding DB
    "EncodingDB",
    "EncodingRun",
    "ComplexityFactors",
    "IterationError",
    "Iteration",
    "ReviewResult",
    "ReviewResults",
    "create_run",
    # Validator Pipeline
    "ValidatorPipeline",
    "ValidationResult",
    "PipelineResult",
    "validate_file",
    # Encoder Backends
    "EncoderBackend",
    "ClaudeCodeBackend",
    "CodexCLIBackend",
    "AgentSDKBackend",
    "EncoderRequest",
    "EncoderResponse",
    "PredictionScores",
    "EvalRunnerSpec",
    "EvalResult",
    "parse_runner_spec",
    "evaluate_artifact",
    "run_model_eval",
    # Calibration Metrics
    "CalibrationMetrics",
    "CalibrationSnapshot",
    "compute_calibration",
    "print_calibration_report",
    "save_calibration_snapshot",
    "get_calibration_trend",
]
