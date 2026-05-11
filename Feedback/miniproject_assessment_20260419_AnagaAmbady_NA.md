# MiniProject Assessment for Anaga Ambady

## Computing

### A1 — Project Organisation

The project was incorrectly submitted within two subdirectories in `week8` (!). But apart from that, the project is easy to navigate: `code/`, `data/`, `results/`, and `report/` are all present, the run entry point is clearly named `run_MiniProject.sh`, and the README gives language versions plus a staged pipeline overview from data cleaning through report compilation. That structure supports reproducibility well because a reader can quickly identify where each analysis stage lives and what files are expected at each step. But `results/` contains committed outputs (`plot_battle.png`, `plot_tpc_multispecies.png`, `plot_delta_tiers.png`, `growth_curve.png`), which the rubric treats as a reproducibility hygiene issue, the README does not clearly explain what each package is for in a fully complete way. In future work keep `results/` empty in the repository and tighten the README package-purpose descriptions so every dependency is explicitly justified.

### A2 — Single-Script Reproducibility

#### Workflow & Solution Quality

`run_MiniProject.sh` starts from the project root, creates output directories, runs `code/data_preparation.R` successfully, but stopped at `code/model_fitting.R` because `MuMIn` was unavailable. The orchestration itself is logical: the script sequences six concrete stages, uses `set -euo pipefail`, resolves its own location robustly, and includes the LaTeX compilation step rather than leaving report generation manual. The main reproducibility weakness is that the pipeline depends on packages that are not checked before execution, so the run fails early and no PDF is produced in the grading environment. A a logical steep would have been to add a preflight dependency check with a clear install message, and to ask whether each non-core dependency is truly necessary here—especially `MuMIn`, since AICc is already computed manually as a fallback in `code/model_fitting.R`, so removing or minimising that dependency would make the pipeline more portable.

### A3 — Code Quality & Style

#### Script-level Technical Feedback

The codebase is substantial and well documented, with a high comment density of 0.248. `code/model_fitting.R` is the clearest example of good modularisation: functions such as `logistic_model`, `gompertz_model`, `get_start_vals`, and `fit_and_plot_curve` separate model definition, starting-value estimation, and per-curve fitting into readable units, while `code/model_comparison.R` adds a focused helper in `classify_delta` for evidence-tier summaries. The larger scripts `code/model_averaging.R` and `code/model_comparison.R` are still readable because of strong sectioning and comments, but they rely more on long top-level procedural blocks than on reusable helper functions. A concrete improvement would be to refactor `code/model_averaging.R` into named helper functions for table generation, parameter extraction, and TPC plotting so that the longest script becomes as modular as `code/model_fitting.R`.

### A4 — Model Fitting & Statistical Analysis

#### NLLS

The fitting strategy goes well beyond the minimum requirement: the project fits Quadratic, Logistic, and Gompertz models, with NLLS implemented through `nlsLM()` for the two sigmoidal models and ordinary least squares reserved for the polynomial baseline. Starting values are handled carefully in `get_start_vals`, using observed minima and maxima, steepest finite-difference slopes for `r_max`, and a heuristic for `t_lag`, while `tryCatch()` wrappers around each fit provide sensible protection against nonlinear failures. Model comparison is coherent and technically appropriate, using AICc, delta-AICc, Akaike weights, convergence summaries, and downstream model-averaged `r_max`; the report also gives concrete convergence counts for all three models. A concrete improvement would be to report failed-fit reasons per curve to a CSV and make any parameter bounds or biological constraints explicit in the `nlsLM()` calls, which would strengthen both robustness and interpretability.

### A5 — Version Control & Workflow Discipline

The repository has 118 commits in total, which suggests sustained activity, but none are recorded as touching `MiniProject/`, so there is no visible evidence of iterative development for this component itself. That makes it difficult for me to reward version-control discipline confidently at the project level, even though the submission is otherwise well developed. Future work could include ensuring the MiniProject files are committed incrementally with descriptive messages so the analysis history is visible and reviewable.

## Report

### B1 — Report Format & Presentation

The report meets most formal requirements cleanly: it uses the `article` class at 11pt, includes 1.5 spacing and `lineno`, stays within the word limit at 3190 words, and contains 6 display items with 6 captions, which is exactly in the target range. The bibliography style is non-numeric (`apalike` via `natbib`), and the abstract is present at about 165 words, which is slightly short of the nominal 200-word target but still comfortably self-contained. The main presentational weakness is not the LaTeX structure but the missing compiled PDF in the grading run, which is tied to pipeline failure rather than report content. On presentation alone, this is a strong and compliant write-up.

### B2 — Introduction & Objectives

The introduction gives a clear biological setup around bacterial growth, sigmoidal population dynamics, and temperature-dependent performance, and it builds naturally toward the two project questions rather than jumping straight into methods. It also explains why Logistic and Gompertz models differ biologically, which helps the modelling choices emerge from the system rather than from software convenience. But the framing is not strongly anchored in both required MQB E&E modelling chapter themes, and and the objectives are not sharply separated into biological versus methodological aims. Could have made the metabolism-to-population link more explicit and state, in separate terms, the biological question about temperature-dependent growth and the methodological question about comparative model fit.

### B3 — Methods (including Computing Tools)

The Methods section is very good. It covers data provenance and preprocessing, states all three model forms with equations, explains starting-value estimation, describes NLLS via `nlsLM()`, defines AICc and Akaike weights mathematically, and includes a proper Computing Tools subsection naming R, Bash, LaTeX, and the relevant packages. The section is also pitched at the right level: it is reproducible without becoming a line-by-line code narration. A next step would be to align the Computing Tools subsection even more tightly with the actual implementation, since the report mentions Python orchestration via `subprocess` but the submitted code evidence shows the executable pipeline is driven by `run_MiniProject.sh` plus R scripts.

### B4 — Results & Display Items

The Results section is well populated and logically ordered, moving from overall model performance to head-to-head comparison and then to the thermal response of model-averaged `r_max`. There are 6 display items in total, all captioned, and the section includes the key comparison outputs expected for this project, especially AIC-based summaries and log-likelihood information in Table 1. The prose mostly stays within factual reporting, although a few phrases edge toward interpretation when describing biological plausibility and model superiority. Future submissions would benefit from keeping the Results section slightly tighter and reserving the strongest interpretive language for the Discussion.

### B5 — Discussion, Conclusions & Abstract

The Discussion returns clearly to the project aims, interprets the poor performance of the Quadratic model in biological terms, and gives a coherent take-home message about sigmoidal models and unimodal thermal responses. Limitations are discussed concretely, including excluded non-convergent curves, omitted Baranyi modelling, and unpartitioned species-level heterogeneity, and the abstract is concise and informative about background, methods, key findings, and conclusions. The main ceiling on this section is advanced-method engagement: the discussion proposes mixed-effects modelling and a Baranyi extension, but it does not engage substantively with MLE, Bayesian inference, or AI/ML approaches, which the rubric requires for top-band performance in B5. A stronger discussion would explain, for example, how Bayesian hierarchical modelling could quantify species-level heterogeneity and uncertainty in `r_max`, or how likelihood-based inference could retain partially converged information more flexibly than the current complete-case comparison.

## Summary

Final classification (student-facing):

- Part A (Computing): Merit
- Part B (Report): Distinction
- Overall: Distinction
