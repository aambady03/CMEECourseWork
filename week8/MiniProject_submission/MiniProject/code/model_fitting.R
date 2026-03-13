# =============================================================================
# author: "Anaga Ambady"
# model_fitting.R
# Stage 2 — Fit Quadratic, Logistic, and Gompertz models to every growth curve
#
# Inputs:  data/data_clean.csv
# Outputs: results/growth_curves.pdf   (all curve fits overlaid)
#          results/aicc_table.csv      (AICc per model per curve)
# =============================================================================

library(readr)
library(minpack.lm)   # nlsLM — more robust than base nls()
library(dplyr)
library(ggplot2)
library(MuMIn)        # AICc()
library(tidyr)

# =============================================================================
# SECTION 1: LOAD CLEANED DATA AND SPLIT INTO PER-CURVE LIST
# =============================================================================

data_clean <- read.csv("data/data_clean.csv")

# One list element per unique growth curve — lapply iterates over these
subsets <- split(data_clean, data_clean$Unique_ID)

# =============================================================================
# SECTION 2: MODEL DEFINITIONS (all operate in log10 space)
# =============================================================================

# --- LOGISTIC ---
# Analytical solution to dN/dt = r_max * N * (1 - N/K).
# Biologically grounded: resource competition limits growth.
# Symmetric S-curve — no lag phase (growth begins immediately at t = 0).
# Parameters: r_max (growth rate), K (carrying capacity), N_0 (initial pop).
logistic_model <- function(t, r_max, K, N_0) {
  n0 <- 10^N_0
  k  <- 10^K
  Nt <- k / (1 + ((k - n0) / n0) * exp(-r_max * t))
  return(log10(Nt))
}

# --- GOMPERTZ (Zwietering 1990) ---
# Phenomenological S-curve with asymmetric inflection at ~37% of growth range.
# Adds a lag phase parameter (t_lag) relative to the Logistic — 5 params vs 4.
# r_max is the true maximum slope (the exp(1) term ensures this).
# Parameters: r_max, K (N_max), N_0, t_lag.
gompertz_model <- function(t, r_max, K, N_0, t_lag) {
  return(N_0 + (K - N_0) *
           exp(-exp(r_max * exp(1) * (t_lag - t) /
                      ((K - N_0) * log(10)) + 1)))
}

# =============================================================================
# SECTION 3: STARTING VALUE HEURISTICS
# Per-curve data-driven starting values passed directly into nlsLM().
# Good starting values are critical for NLLS convergence.
# =============================================================================

get_start_vals <- function(df) {
  t <- df$Time
  N <- df$Log10N
  N_linear <- 10^N

  N_0_start <- min(N_linear, na.rm = TRUE)
  K_start   <- max(N_linear, na.rm = TRUE)

  # Approximate r_max from the steepest observed slope (in log10 space)
  slopes      <- diff(N) / diff(t)
  r_max_start <- max(max(slopes, na.rm = TRUE) * log(10), 0.01)

  # t_lag: time at which slope first exceeds 50% of its maximum
  lag_idx     <- which(slopes >= 0.5 * max(slopes, na.rm = TRUE))[1]
  t_lag_start <- if (!is.na(lag_idx) && lag_idx > 1) t[lag_idx] else t[1]

  list(N_0 = N_0_start, K = K_start, r_max = r_max_start, t_lag = t_lag_start)
}

# =============================================================================
# SECTION 4: FIT ALL MODELS AND PRODUCE PER-CURVE PLOT
# Returns a list with: $plot (ggplot), $aicc (1-row data frame), $fits (models)
# =============================================================================

fit_and_plot_curve <- function(df) {
  id <- unique(df$Unique_ID)[1]
  sv <- get_start_vals(df)

  # --- Quadratic (linear model — statistical baseline, no biological mechanism) ---
  fit_quad <- tryCatch(
    lm(Log10N ~ poly(Time, 2, raw = TRUE), data = df),
    error = function(e) NULL
  )

  # --- Logistic (NLLS) ---
  fit_logistic <- tryCatch(
    nlsLM(Log10N ~ logistic_model(t = Time, r_max, K, N_0), data = df,
          start   = list(r_max = sv$r_max, K = log10(sv$K), N_0 = log10(sv$N_0)),
          control = nls.lm.control(maxiter = 200)),
    error = function(e) NULL
  )

  # --- Gompertz (NLLS) ---
  fit_gompertz <- tryCatch(
    nlsLM(Log10N ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), data = df,
          start   = list(r_max = sv$r_max, K = log10(sv$K),
                         N_0 = log10(sv$N_0), t_lag = sv$t_lag),
          control = nls.lm.control(maxiter = 200)),
    error = function(e) NULL
  )

  # --- Predictions over a smooth time grid ---
  t_seq   <- seq(min(df$Time), max(df$Time), length.out = 200)
  pred_df <- data.frame(Time = t_seq)

  safe_pred <- function(fit, nd) {
    if (is.null(fit)) return(rep(NA, nrow(nd)))
    tryCatch(predict(fit, newdata = nd), error = function(e) rep(NA, nrow(nd)))
  }

  pred_df$Quadratic <- safe_pred(fit_quad,     pred_df)
  pred_df$Logistic  <- safe_pred(fit_logistic, pred_df)
  pred_df$Gompertz  <- safe_pred(fit_gompertz, pred_df)

  pred_long <- pred_df %>%
    pivot_longer(-Time, names_to = "Model", values_to = "Log10N") %>%
    filter(!is.na(Log10N))

  # --- Plot ---
  p <- ggplot() +
    geom_point(data = df,
               aes(x = Time, y = Log10N),
               size = 2, alpha = 0.8, colour = "black") +
    geom_line(data = pred_long,
              aes(x = Time, y = Log10N, colour = Model, linetype = Model),
              linewidth = 0.9) +
    scale_colour_manual(values = c(Quadratic = "#E69F00",
                                   Logistic  = "#009E73",
                                   Gompertz  = "#CC79A7")) +
    scale_linetype_manual(values = c(Quadratic = "dashed",
                                     Logistic  = "solid",
                                     Gompertz  = "solid")) +
    labs(title    = df$ID_short[1],
         x        = "Time",
         y        = expression(log[10](N)),
         colour   = "Model",
         linetype = "Model") +
    theme_bw(base_size = 11) +
    theme(plot.title = element_text(size = 8, face = "bold"))

  # --- AICc extraction ---
  # Falls back to manual calculation if AICc() fails (e.g. lm edge cases)
  get_aicc <- function(fit) {
    if (is.null(fit)) return(NA)
    val <- tryCatch(AICc(fit), error = function(e) NA)
    if (!is.finite(val)) {
      n   <- length(residuals(fit))
      k   <- length(coef(fit)) + 1
      rss <- sum(residuals(fit)^2)
      aic <- n * log(rss / n) + 2 * k
      val <- aic + (2 * k * (k + 1)) / (n - k - 1)
    }
    val
  }

  aicc_row <- data.frame(
    Unique_ID      = id,
    AICc_Quadratic = get_aicc(fit_quad),
    AICc_Logistic  = get_aicc(fit_logistic),
    AICc_Gompertz  = get_aicc(fit_gompertz)
  )

  list(plot  = p,
       aicc  = aicc_row,
       fits  = list(quad = fit_quad, logistic = fit_logistic, gompertz = fit_gompertz))
}

# =============================================================================
# SECTION 5: RUN ACROSS ALL CURVES AND SAVE OUTPUTS
# =============================================================================

results <- lapply(subsets, fit_and_plot_curve)

# Save all growth curve plots to a single PDF
pdf("results/growth_curves.pdf", width = 7, height = 7)
for (res in results) print(res$plot)
dev.off()

# Compile and save AICc table
aicc_table <- bind_rows(lapply(results, `[[`, "aicc"))
write.csv(aicc_table, "results/aicc_table.csv", row.names = FALSE)

cat("=== Model Fitting Summary ===\n")
cat("Curves fitted:         ", length(results), "\n")
cat("Outputs: results/growth_curves.pdf\n")
cat("         results/aicc_table.csv\n")
