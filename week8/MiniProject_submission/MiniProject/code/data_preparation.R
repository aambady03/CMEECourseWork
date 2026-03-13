# =============================================================================
# author: "Anaga Ambady"
# data_preparation.R
# Stage 1 — Data import, cleaning, and quality control
#
# Inputs:  data/logistic_growth_data.csv
# Outputs: data/data_clean.csv
# =============================================================================

library(dplyr)
library(readr)

# =============================================================================
# SECTION 1: LOAD AND CLEAN RAW DATA
# =============================================================================

df <- read.csv("data/logistic_growth_data.csv")

# Remove rows with any NA values
data <- na.omit(df)

# Remove zero/negative PopBio values — biologically impossible for counts.
# Negative OD values result from blank subtraction (OD_sample - OD_blank)
# and cannot be log-transformed; they represent instrument artefacts.
data$PopBio[data$PopBio <= 0] <- NA
data <- na.omit(data)

# Semi-log transformation: log10(N) vs linear Time.
# Standard in microbiology — exponential phase becomes a straight line.
# log10 used throughout for consistency with Gompertz/Baranyi definitions.
data$Log10N <- log10(data$PopBio)

# Remove non-finite values produced by log transformation
data <- data[is.finite(data$Log10N), ]

# Remove zero/negative time — growth cannot precede inoculation
data <- data[data$Time > 0, ]

# =============================================================================
# SECTION 2: CREATE UNIQUE CURVE IDENTIFIERS
# Species + Temp + Medium + Rep + Citation ensures true uniqueness —
# the same species/temp/medium can appear in multiple papers.
# ID_short omits Citation for readable plot titles.
# =============================================================================

data <- data %>%
  mutate(
    Unique_ID = paste(Species, Temp, Medium, Rep, Citation, sep = "_"),
    ID_short  = paste(Species, Temp, Medium, Rep, sep = "_")
  )

# =============================================================================
# SECTION 3: QUALITY CONTROL — REMOVE UNINFORMATIVE CURVES
# Minimum 6 points: required for 4-parameter NLLS (k+2 rule)
# Minimum growth range 0.3 log10 units: at least one doubling (10^0.3 ≈ 2)
# =============================================================================

curve_qc <- data %>%
  group_by(Unique_ID) %>%
  summarise(
    n_points     = n(),
    growth_range = max(Log10N, na.rm = TRUE) - min(Log10N, na.rm = TRUE),
    .groups      = "drop"
  )

good_ids <- curve_qc %>%
  filter(n_points >= 6, growth_range >= 0.3) %>%
  pull(Unique_ID)

data_clean <- data %>%
  filter(Unique_ID %in% good_ids) %>%
  # Remove within-curve outliers: points >3 SD from the curve mean.
  # Captures instrument errors (pipetting, contamination) not biology.
  group_by(Unique_ID) %>%
  filter(abs(Log10N - mean(Log10N, na.rm = TRUE)) < 3 * sd(Log10N, na.rm = TRUE)) %>%
  filter(n() >= 6) %>%   # re-check minimum points after outlier removal
  ungroup()

# =============================================================================
# SECTION 4: SAVE AND SUMMARISE
# =============================================================================

write.csv(data_clean, file = "data/data_clean.csv", row.names = FALSE)

cat("=== Data Preparation Summary ===\n")
cat("Rows after cleaning:   ", nrow(data_clean), "\n")
cat("Unique curves:         ", n_distinct(data_clean$Unique_ID), "\n")
cat("Curves removed by QC:  ", n_distinct(data$Unique_ID) - n_distinct(data_clean$Unique_ID), "\n")
cat("PopBio units present:  ", paste(unique(data_clean$PopBio_units), collapse = ", "), "\n")
cat("Output: data/data_clean.csv\n")
