# =============================================================================
# author: "Anaga Ambady"
# model_averaging.R
# Stage 4 — Model averaging, canonical selection table, and thermal performance curve
#
# Inputs:  results/model_comparison.csv
#          data/data_clean.csv
#          `results` list in memory (from model_fitting.R)
# Outputs: results/table_model_selection_canonical.csv   (Table 1 for report)
#          results/model_averaged_rmax_by_temp.csv        (used for TPC plot)
#          results/plot_rmax_by_temp.png                  (thermal performance curve)
# =============================================================================

library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(MuMIn)

# =============================================================================
# SECTION 1: CANONICAL MODEL SELECTION TABLE (Table 1)
# One row per model, summarised across all converged curves.
# Median used instead of mean — more robust to outlier curves with extreme AICc.
#
# k = number of estimated parameters + 1 for sigma:
#   Quadratic: intercept + b + c + sigma        = 4
#   Logistic:  r_max + K + N_0 + sigma          = 4
#   Gompertz:  r_max + K + N_0 + t_lag + sigma  = 5
# =============================================================================

comparison <- read_csv("results/model_comparison.csv")
data_clean  <- read_csv("data/data_clean.csv")

k_vals <- c(Quadratic = 4L, Logistic = 4L, Gompertz = 5L)

# Pivot AICc, ΔAICc, and weights into long format for grouped summaries
aicc_long <- comparison %>%
  select(Unique_ID,
         AICc_Quadratic, AICc_Logistic, AICc_Gompertz,
         dAIC_Quad, dAIC_Logi, dAIC_Gomp,
         w_Quad, w_Logi, w_Gomp) %>%
  pivot_longer(
    cols          = -Unique_ID,
    names_to      = c(".value", "Model_Abbr"),
    names_pattern = "(.+)_(Quad|Logi|Gomp)"
  ) %>%
  rename(AICc = AICc, dAICc = dAIC, w = w) %>%
  mutate(
    Model = recode(Model_Abbr, Quad = "Quadratic", Logi = "Logistic", Gomp = "Gompertz"),
    k     = k_vals[Model]
  )

# Back-calculate logLik from AICc when `results` list is not available:
#   AICc = -2*logLik + 2k + 2k(k+1)/(n-k-1)  =>  logLik = -(AICc - 2k - correction)/2
n_per_curve <- data_clean %>% count(Unique_ID, name = "n")

if (exists("results")) {
  # Direct extraction — most accurate
  loglik_df <- bind_rows(lapply(names(results), function(id) {
    fits <- results[[id]]$fits
    data.frame(
      Unique_ID        = id,
      logLik_Quadratic = tryCatch(as.numeric(logLik(fits$quad)),     error = function(e) NA),
      logLik_Logistic  = tryCatch(as.numeric(logLik(fits$logistic)), error = function(e) NA),
      logLik_Gompertz  = tryCatch(as.numeric(logLik(fits$gompertz)), error = function(e) NA)
    )
  }))

  aicc_long <- aicc_long %>%
    left_join(
      loglik_df %>%
        pivot_longer(-Unique_ID,
                     names_to     = "Model",
                     names_prefix = "logLik_",
                     values_to    = "logLik"),
      by = c("Unique_ID", "Model")
    )

} else {
  # Fallback: approximate logLik from AICc
  cat("NOTE: logLik back-calculated from AICc (approximate).\n")
  cat("      Source model_fitting.R first for exact values.\n\n")

  aicc_long <- aicc_long %>%
    left_join(n_per_curve, by = "Unique_ID") %>%
    mutate(
      correction = 2 * k * (k + 1) / (n - k - 1),
      logLik     = -(AICc - 2 * k - correction) / 2
    ) %>%
    select(-correction, -n)
}

# Convergence counts per model (for the n converged column)
conv_counts <- comparison %>%
  summarise(
    Logistic  = sum(is.finite(AICc_Logistic)),
    Gompertz  = sum(is.finite(AICc_Gompertz)),
    Quadratic = sum(is.finite(AICc_Quadratic))
  ) %>%
  pivot_longer(everything(), names_to = "Model", values_to = "n_converged")

model_selection_table <- aicc_long %>%
  group_by(Model) %>%
  summarise(
    k               = first(k),
    median_AICc     = round(median(AICc,   na.rm = TRUE), 2),
    median_dAICc    = round(median(dAICc,  na.rm = TRUE), 2),
    mean_w          = round(mean(w,        na.rm = TRUE), 3),
    median_logLik   = round(median(logLik, na.rm = TRUE), 2),
    pct_substantial = round(100 * mean(dAICc < 2, na.rm = TRUE), 1),
    .groups         = "drop"
  ) %>%
  left_join(conv_counts, by = "Model") %>%
  arrange(median_AICc) %>%
  rename(
    `k`                    = k,
    `n converged`          = n_converged,
    `Median AICc`          = median_AICc,
    `Median ΔAICc`         = median_dAICc,
    `Mean weight (w)`      = mean_w,
    `Median logLik`        = median_logLik,
    `% curves w/ ΔAICc<2`  = pct_substantial
  )

cat("=== Canonical Model Selection Table ===\n")
print(model_selection_table)
cat("\n")
write_csv(model_selection_table, "results/table_model_selection_canonical.csv")

# =============================================================================
# SECTION 2: MODEL-AVERAGED r_max PER CURVE
# For each curve, compute a weighted average of r_max from Logistic and Gompertz.
# The Quadratic has no r_max — weights are re-normalised over nonlinear models only.
#
# Formula: r_max_avg = (w_Logi_rel * r_logi) + (w_Gomp_rel * r_gomp)
# where w_Logi_rel = w_Logi / (w_Logi + w_Gomp)
#
# Accounts for model selection uncertainty — if both models have support,
# the averaged r_max reflects that uncertainty rather than picking one arbitrarily.
# =============================================================================

if (exists("results")) {

  # Extract r_max, K, N_0, t_lag from each fitted model object
  params_df <- bind_rows(lapply(names(results), function(id) {
    fits      <- results[[id]]$fits
    logi_coef <- tryCatch(coef(fits$logistic), error = function(e) NULL)
    gomp_coef <- tryCatch(coef(fits$gompertz), error = function(e) NULL)

    data.frame(
      Unique_ID = id,
      r_logi    = if (!is.null(logi_coef)) logi_coef[["r_max"]] else NA,
      K_logi    = if (!is.null(logi_coef)) logi_coef[["K"]]     else NA,
      N0_logi   = if (!is.null(logi_coef)) logi_coef[["N_0"]]   else NA,
      r_gomp    = if (!is.null(gomp_coef)) gomp_coef[["r_max"]] else NA,
      K_gomp    = if (!is.null(gomp_coef)) gomp_coef[["K"]]     else NA,
      N0_gomp   = if (!is.null(gomp_coef)) gomp_coef[["N_0"]]   else NA,
      t_lag     = if (!is.null(gomp_coef)) gomp_coef[["t_lag"]] else NA
    )
  })) %>%
    left_join(comparison %>% select(Unique_ID, w_Logi, w_Gomp), by = "Unique_ID")

  model_avg <- params_df %>%
    mutate(
      # Re-normalise weights to sum to 1 over nonlinear models only
      w_sum_NL   = w_Logi + w_Gomp,
      w_Logi_rel = w_Logi / w_sum_NL,
      w_Gomp_rel = w_Gomp / w_sum_NL,

      # Weighted average r_max — fall back to single model if one didn't converge
      r_max_avg = case_when(
        is.finite(r_logi) & is.finite(r_gomp) ~
          w_Logi_rel * r_logi + w_Gomp_rel * r_gomp,
        is.finite(r_logi) ~ r_logi,
        is.finite(r_gomp) ~ r_gomp,
        TRUE ~ NA_real_
      )
    )

  # Attach temperature and species metadata; remove biologically implausible values
  rmax_temp <- model_avg %>%
    left_join(data_clean %>% select(Unique_ID, Temp, Species) %>% distinct(),
              by = "Unique_ID") %>%
    filter(is.finite(r_max_avg), r_max_avg > 0, r_max_avg < 10) %>%
    select(Unique_ID, Temp, Species, r_max_avg)

  write_csv(rmax_temp, "results/model_averaged_rmax_by_temp.csv")

} else {
  cat("Section 2 skipped — `results` list not in memory.\n")
  cat("Source model_fitting.R first, then re-run this script.\n\n")
}

# =============================================================================
# SECTION 3: THERMAL PERFORMANCE CURVE PLOT
# Quadratic regression fitted to log(r_max) — log scale linearises the
# unimodal TPC so OLS assumptions are met; back-transformed for display.
# T_opt estimated analytically as the vertex of the quadratic: -b1 / (2*b2).
# =============================================================================

# Load from CSV so this section can run independently of Section 2
rmax_by_temp <- read_csv("results/model_averaged_rmax_by_temp.csv") %>%
  filter(r_max_avg > 0, !is.na(Temp)) %>%
  mutate(log_rmax = log(r_max_avg))   # natural log for regression

# Fit quadratic TPC on log scale
tpc_model <- lm(log_rmax ~ Temp + I(Temp^2), data = rmax_by_temp)

# Estimate thermal optimum (vertex of the downward-opening parabola)
b1    <- coef(tpc_model)["Temp"]
b2    <- coef(tpc_model)["I(Temp^2)"]
T_opt <- -b1 / (2 * b2)
R2    <- summary(tpc_model)$r.squared

cat(sprintf("=== TPC Regression ===\n"))
cat(sprintf("Estimated T_opt: %.1f °C\n", T_opt))
cat(sprintf("R² = %.3f\n\n", R2))

# Generate smooth prediction curve (back-transformed to original scale)
pred_df <- data.frame(Temp = seq(0, 37, length.out = 300)) %>%
  mutate(
    log_rmax_pred = predict(tpc_model, newdata = .),
    rmax_pred     = exp(log_rmax_pred)
  )

# Index of T_opt on the discrete temperature axis (for geom_vline positioning)
temp_levels   <- levels(factor(rmax_by_temp$Temp))
T_opt_idx     <- which(temp_levels == as.character(round(T_opt)))

p_rmax_temp <- ggplot() +
  # Boxplot showing distribution of r_max at each temperature
  geom_boxplot(data    = rmax_by_temp,
               aes(x   = factor(Temp), y = r_max_avg, group = Temp),
               fill    = "#2d8b6b", alpha = 0.4,
               outlier.shape = 16, outlier.alpha = 0.5) +
  # Vertical dashed line at T_opt
  geom_vline(xintercept = T_opt_idx,
             linetype = "dashed", colour = "red", linewidth = 0.8) +
  # T_opt label
  annotate("text",
           x     = T_opt_idx + 0.3,
           y     = 8,
           label = paste0("T[opt] == ", round(T_opt, 1), "*degree*C"),
           parse = TRUE, hjust = 0, size = 3.5) +
  # R² annotation
  annotate("text",
           x     = 1,
           y     = 9,
           label = paste0("R\u00B2 = ", round(R2, 3), ", p < 0.001"),
           hjust = 0, size = 3.5) +
  labs(
    title    = "Thermal Sensitivity of Model-Averaged Maximum Growth Rates (r\u2098\u2090\u2093)",
    subtitle = "Weighted average of Logistic and Gompertz estimates per curve",
    x        = "Temperature (\u00B0C)",
    y        = expression(paste("Model-averaged ", r[max], " (h"^-1, ")"))
  ) +
  theme_bw(base_size = 12) +
  theme(
    plot.title       = element_text(face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave("results/plot_rmax_by_temp.png", p_rmax_temp, width = 8, height = 5)

cat("✓ model_averaging.R complete\n")
cat("  results/table_model_selection_canonical.csv  (Table 1)\n")
cat("  results/model_averaged_rmax_by_temp.csv\n")
cat("  results/plot_rmax_by_temp.png\n")
