#!/usr/bin/env bash
# Runs the notebook headless and writes the outputs back into the same file.
set -euo pipefail
cd "$(dirname "$0")"

LOG="run_$(date +%Y%m%d_%H%M%S).log"

.venv/bin/python -u -m jupyter nbconvert \
    --to notebook --execute --inplace \
    --ExecutePreprocessor.timeout=1800 \
    --ExecutePreprocessor.kernel_name=python3 \
    hands_on_outbreak_analytics.ipynb 2>&1 | tee "$LOG"

echo "Done. Log: $LOG"
