# =============================================================================
# author: "Anaga Ambady"
# model_comparison.R
# Stage 3 — AICc-based model comparison, Akaike weights, and summary plots
#
# Inputs:  results/aicc_table.csv
#          data/data_clean.csv
#          `results` list in memory (from model_fitting.R)
# Outputs: results/model_comparison.csv
#          results/plot_battle.png          (model win frequencies)
#          results/plot_delta_tiers.png     (ΔAICc evidence tiers)
# =============================================================================

library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)

# Shared colour palette used across all plots in this project
model_colours <- c(Quadratic = "#E69F00", Logistic = "#009E73", Gompertz = "#CC79A7")

# =============================================================================
# SECTION 1: LOAD DATA AND ATTACH METADATA
# =============================================================================

aicc_table <- read_csv("results/aicc_table.csv")
data_clean  <- read_csv("data/data_clean.csv")

# One metadata row per curve (Species, Temp, Medium)
meta <- data_clean %>%
  select(Unique_ID, Species, Temp, Medium) %>%
  distinct()

aicc_full <- aicc_table %>%
  left_join(meta, by = "Unique_ID")

# =============================================================================
# SECTION 2: CONVERGENCE CHECK
# A model "converged" if its AICc is a finite number.
# Only curves where all three models converged enter the comparison —
# mixing partial sets would make delta-AICc values incomparable.
# =============================================================================

convergence <- aicc_full %>%
  mutate(
    conv_Quadratic = is.finite(AICc_Quadratic),
    conv_Logistic  = is.finite(AICc_Logistic),
    conv_Gompertz  = is.finite(AICc_Gompertz),
    all_converged  = conv_Quadratic & conv_Logistic & conv_Gompertz
  )

cat("=== Convergence Summary ===\n")
cat(sprintf("Total curves:            %d\n",   nrow(convergence)))
cat(sprintf("Quadratic converged:     %d (%.1f%%)\n",
            sum(convergence$conv_Quadratic), 100 * mean(convergence$conv_Quadratic)))
cat(sprintf("Logistic converged:      %d (%.1f%%)\n",
            sum(convergence$conv_Logistic),  100 * mean(convergence$conv_Logistic)))
cat(sprintf("Gompertz converged:      %d (%.1f%%)\n",
            sum(convergence$conv_Gompertz),  100 * mean(convergence$conv_Gompertz)))
cat(sprintf("All 3 converged:         %d (%.1f%%)\n",
            sum(convergence$all_converged),
            100 * sum(convergence$all_converged) / nrow(convergence)))
cat(sprintf("Excluded (partial/none): %d\n\n",
            nrow(convergence) - sum(convergence$all_converged)))

# =============================================================================
# SECTION 3: COMPUTE DELTA-AICc AND AKAIKE WEIGHTS
#
# Per-curve method:
#   Step 1 — delta-AICc:    d_i = AICc_i - min(AICc)        best model = 0
#   Step 2 — rel. likelih.: L_i = exp(-0.5 * d_i)            best model = 1
#   Step 3 — normalise:     w_i = L_i / sum(L)               weights sum to 1
#
# w_i = estimated probability that model i is the best approximating model
# given this candidate set and dataset (Burnham & Anderson 2002).
# =============================================================================

comparison <- convergence %>%
  filter(all_converged) %>%
  mutate(
    # Step 1: delta-AICc
    best_AICc = pmin(AICc_Quadratic, AICc_Logistic, AICc_Gompertz),
    dAIC_Quad = AICc_Quadratic - best_AICc,
    dAIC_Logi = AICc_Logistic  - best_AICc,
    dAIC_Gomp = AICc_Gompertz  - best_AICc,

    # Step 2: relative likelihoods
    L_Quad = exp(-0.5 * dAIC_Quad),
    L_Logi = exp(-0.5 * dAIC_Logi),
    L_Gomp = exp(-0.5 * dAIC_Gomp),

    # Step 3: Akaike weights
    L_sum  = L_Quad + L_Logi + L_Gomp,
    w_Quad = L_Quad / L_sum,
    w_Logi = L_Logi / L_sum,
    w_Gomp = L_Gomp / L_sum,

    # Best model = lowest AICc on that curve
    best_model = case_when(
      AICc_Quadratic == best_AICc ~ "Quadratic",
      AICc_Logistic  == best_AICc ~ "Logistic",
      AICc_Gompertz  == best_AICc ~ "Gompertz"
    ),

    # Clear winner = ΔAICc > 2 over the next-best competitor
    second_best_AICc = apply(
      cbind(AICc_Quadratic, AICc_Logistic, AICc_Gompertz), 1,
      function(x) sort(x)[2]
    ),
    clear_winner = (second_best_AICc - best_AICc) > 2
  ) %>%
  select(Unique_ID, Species, Temp, Medium,
         AICc_Quadratic, AICc_Logistic, AICc_Gompertz,
         dAIC_Quad, dAIC_Logi, dAIC_Gomp,
         w_Quad, w_Logi, w_Gomp,
         best_model, clear_winner)

write_csv(comparison, "results/model_comparison.csv")
cat(sprintf("=== Model Comparison: %d curves (all-converged) ===\n\n", nrow(comparison)))

# =============================================================================
# SECTION 4: PLOT 1 — MODEL WIN FREQUENCIES ("BATTLE" BAR CHART)
# Bar height = number of curves where each model had the lowest AICc.
# Mean Akaike weight when winning is annotated — captures margin of victory,
# not just rank (e.g. w = 0.99 vs w = 0.34 both "win" but differ greatly).
# =============================================================================

overall_wins <- comparison %>%
  count(best_model, name = "n_wins") %>%
  mutate(pct = round(100 * n_wins / sum(n_wins), 1)) %>%
  arrange(desc(n_wins))

# Mean weight only from curves where a given model actually won
mean_w_when_winning <- comparison %>%
  mutate(w_winner = case_when(
    best_model == "Quadratic" ~ w_Quad,
    best_model == "Logistic"  ~ w_Logi,
    best_model == "Gompertz"  ~ w_Gomp
  )) %>%
  group_by(best_model) %>%
  summarise(mean_w = round(mean(w_winner, na.rm = TRUE), 3), .groups = "drop")

battle_data <- overall_wins %>%
  left_join(mean_w_when_winning, by = "best_model")

p_battle <- ggplot(battle_data,
                   aes(x = reorder(best_model, -n_wins),
                       y = n_wins,
                       fill = best_model)) +
  geom_col(width = 0.55, colour = "grey30") +
  geom_text(aes(label = paste0(n_wins, " wins\n(mean w = ", mean_w, ")")),
            vjust = -0.3, size = 3.5) +
  scale_fill_manual(values = model_colours, guide = "none") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2))) +
  labs(
    title    = "Model Selection Frequencies and Relative Support",
    subtitle = paste0("n = ", nrow(comparison),
                      " curves  |  mean w = average Akaike weight when winning"),
    x = NULL,
    y = "Number of curves"
  ) +
  theme_bw(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

ggsave("results/plot_battle.png", p_battle, width = 6, height = 5)

# =============================================================================
# SECTION 5: PLOT 2 — DELTA-AICc EVIDENCE TIER STACKED BAR
# Categorise every model–curve pair by conventional evidence thresholds:
#   ΔAICc < 2          substantial support
#   2–4                moderate
#   4–7                little
#   7–10               very little
#   > 10               essentially no support
# =============================================================================

classify_delta <- function(d) {
  case_when(
    d  < 2              ~ "Substantial (< 2)",
    d >= 2  & d <= 4    ~ "Moderate (2–4)",
    d  > 4  & d <= 7    ~ "Little (4–7)",
    d  > 7  & d <= 10   ~ "Very little (7–10)",
    d  > 10             ~ "No support (> 10)",
    TRUE                ~ NA_character_
  )
}

support_levels <- c("Substantial (< 2)", "Moderate (2–4)",
                    "Little (4–7)", "Very little (7–10)", "No support (> 10)")

tier_colours <- c(
  "Substantial (< 2)"  = "#009E73",
  "Moderate (2–4)"     = "#56B4E9",
  "Little (4–7)"       = "#E69F00",
  "Very little (7–10)" = "#D55E00",
  "No support (> 10)"  = "#CC79A7"
)

delta_classified <- comparison %>%
  mutate(
    support_Quad = classify_delta(dAIC_Quad),
    support_Logi = classify_delta(dAIC_Logi),
    support_Gomp = classify_delta(dAIC_Gomp)
  )

delta_summary <- bind_rows(
  delta_classified %>% count(tier = support_Quad) %>% mutate(Model = "Quadratic"),
  delta_classified %>% count(tier = support_Logi) %>% mutate(Model = "Logistic"),
  delta_classified %>% count(tier = support_Gomp) %>% mutate(Model = "Gompertz")
) %>%
  mutate(
    tier  = factor(tier, levels = support_levels),
    pct   = round(100 * n / nrow(comparison), 1),
    Model = factor(Model, levels = c("Logistic", "Gompertz", "Quadratic"))
  )

p_tiers <- ggplot(delta_summary,
                  aes(x = Model, y = pct, fill = tier)) +
  geom_col(width = 0.55, colour = "grey30") +
  scale_fill_manual(values = tier_colours, drop = FALSE) +
  scale_y_continuous(labels = scales::percent_format(scale = 1)) +
  labs(
    title    = "Distribution of Delta-AICc Evidence Tiers",
    subtitle = "Green = substantial support (ΔAICc < 2); purple = no support (ΔAICc > 10)",
    x        = NULL,
    y        = "% of curves",
    fill     = "Evidence tier"
  ) +
  theme_bw(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

ggsave("results/plot_delta_tiers.png", p_tiers, width = 7, height = 4.5)

cat("✓ model_comparison.R complete\n")
cat("  results/model_comparison.csv\n")
cat("  results/plot_battle.png\n")
cat("  results/plot_delta_tiers.png\n")
