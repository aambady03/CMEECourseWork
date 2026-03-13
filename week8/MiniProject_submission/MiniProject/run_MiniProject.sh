#!/usr/bin/env bash
# =============================================================================
# run_MiniProject.sh
# Master script — runs the full MiniProject pipeline from data to PDF report.
#
# Usage:  bash run_MiniProject.sh
#         (run from the MiniProject/ root directory)
#
# Pipeline:
#   1. data_preparation.R   — clean raw data, QC, save data/data_clean.csv
#   2. model_fitting.R      — fit Quadratic/Logistic/Gompertz, save AICc table
#   3. model_comparison.R   — delta-AICc, Akaike weights, summary plots
#   4. model_averaging.R    — model-averaged r_max, TPC regression, TPC plot
#   5. tpc_multispecies.R   — three-species TPC comparison figure
#   6. pdflatex + bibtex    — compile LaTeX report to PDF
# =============================================================================

set -euo pipefail   # exit on error, unset variable, or pipe failure

# ---------------------------------------------------------------------------
# Resolve project root (directory containing this script)
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "============================================================"
echo " MiniProject pipeline — starting"
echo " Working directory: $SCRIPT_DIR"
echo "============================================================"

# ---------------------------------------------------------------------------
# Create output directories if they don't exist
# ---------------------------------------------------------------------------
mkdir -p data results report

# ---------------------------------------------------------------------------
# Step 1: Data preparation
# ---------------------------------------------------------------------------
echo ""
echo ">>> [1/6] Running data_preparation.R ..."
Rscript code/data_preparation.R
echo "    Done."

# ---------------------------------------------------------------------------
# Step 2: Model fitting
# ---------------------------------------------------------------------------
echo ""
echo ">>> [2/6] Running model_fitting.R ..."
Rscript code/model_fitting.R
echo "    Done."

# ---------------------------------------------------------------------------
# Step 3: Model comparison
# ---------------------------------------------------------------------------
echo ""
echo ">>> [3/6] Running model_comparison.R ..."
Rscript code/model_comparison.R
echo "    Done."

# ---------------------------------------------------------------------------
# Step 4: Model averaging + TPC
# ---------------------------------------------------------------------------
echo ""
echo ">>> [4/6] Running model_averaging.R ..."
Rscript code/model_averaging.R
echo "    Done."

# ---------------------------------------------------------------------------
# Step 5: Multi-species TPC figure
# ---------------------------------------------------------------------------
echo ""
echo ">>> [5/6] Running tpc_multispecies.R ..."
Rscript code/tpc_multispecies.R
echo "    Done."

# ---------------------------------------------------------------------------
# Step 6: Compile LaTeX report
# ---------------------------------------------------------------------------
echo ""
echo ">>> [6/6] Compiling LaTeX report ..."
cd report

# Run pdflatex twice + bibtex to resolve references and citations
pdflatex -interaction=nonstopmode report.tex
bibtex report
pdflatex -interaction=nonstopmode report.tex
pdflatex -interaction=nonstopmode report.tex

cd "$SCRIPT_DIR"
echo "    Done. Report: report/report.pdf"

# ---------------------------------------------------------------------------
echo ""
echo "============================================================"
echo " MiniProject pipeline complete."
echo " Output PDF: report/report.pdf"
echo "============================================================"
