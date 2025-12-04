## Author: Anaga Ambady
## Date: October 2025
# Description: This script loads predator-prey data, performs log-log
## regression, analyzes results by Lifestage, and saves the plot and results table.
## Uses dot notation for column names (e.g., Prey.mass) to match read.csv/read_csv behavior.

# ----------------------------------------------------------------------
# 1. Setup, Library Loading, and Path Definitions
# ----------------------------------------------------------------------
# The tidyverse includes ggplot2 (plotting) and dplyr (data manipulation)
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
library(tidyverse)

# Define directories and file paths
data_dir <- "../data"
results_dir <- "../results"

# Ensure the results directory exists
if (!dir.exists(results_dir)) {
  dir.create(results_dir, recursive = TRUE)
}

# Define output paths
results_csv_path <- file.path(results_dir, "PP_Regress_Results.csv")
results_pdf_path <- file.path(results_dir, "PP_Regress_Plot.pdf")

# ----------------------------------------------------------------------
# 2. Data Loading and Cleaning
# ----------------------------------------------------------------------

# Load the predator-prey data
ecol_archives <- read.csv(file.path(data_dir, "EcolArchives-E089-51-D1.csv"))

# Convert Prey.mass from mg to g where applicable
ecol_archives$Prey.mass[ecol_archives$Prey.mass.unit == "mg"] <- ecol_archives$Prey.mass[ecol_archives$Prey.mass.unit == "mg"] / 1000
ecol_archives$Prey.mass.unit[ecol_archives$Prey.mass.unit == "mg"] <- "g"

# ----------------------------------------------------------------------
# 3. REGRESSION ANALYSIS AND STATISTIC EXTRACTION (DO NOT TOUCH)
# ----------------------------------------------------------------------

# Perform the regression for each group and extract overall model metrics (R^2, F, P)
model_stats <- ecol_archives |>
  group_by(Type.of.feeding.interaction, Predator.lifestage) |>
  # FIX: Use 'reframe' and conditional logic to handle groups with insufficient data.
  reframe({
    # Check if group has enough data points for two variables (intercept + slope)
    if (n() > 2) {
      # Run the linear model
      model <- lm(log10(Prey.mass) ~ log10(Predator.mass))
      glance_data <- summary(model)
      
      # Extract statistics (Original logic preserved)
      tibble(
        slope = coef(model)[2],
        intercept = coef(model)[1],
        R_squared = sqrt(glance_data$r.squared),
        F_statistic = glance_data$fstatistic[1], 
        p_value = glance_data$coefficients["log10(Predator.mass)", "Pr(>|t|)"]
      )
    } else {
      # Return NA for groups that fail to run the model
      tibble(
        slope = NA_real_,
        intercept = NA_real_,
        R_squared = NA_real_,
        F_statistic = NA_real_,
        p_value = NA_real_
      )
    }
  })
# Save the results table to a CSV file
write.csv(model_stats, file = results_csv_path, row.names = FALSE)


# ---------------------------------------------------------------------
# 4. Create and Save the Plot 
# ----------------------------------------------------------------------

# The plot maps log10 values explicitly and facets by feeding interaction type,
# while coloring points/lines by predator life stage.
P <- ggplot(ecol_archives,
            # Map log10 of masses for accurate representation and labeling
            aes(x = (Prey.mass),
                y = (Predator.mass),
                color = Predator.lifestage)) +
  
  # Add points with transparency
  geom_point(alpha = 0.5, size = 1.5, shape = I(3)) +
  
  # Add regression lines for each colored group (lifestage)
  # FIX: Changed 'size' to 'linewidth' to avoid deprecation warning
  geom_smooth(method = "lm", se = TRUE, fullrange = TRUE, linewidth = 0.7) +
  
  # Create separate panels for each feeding interaction type (Script 1's faceting)
  facet_wrap(Type.of.feeding.interaction ~ ., ncol = 1, strip.position = "right") +
  
  # Labels and Titles reflecting the log transformation
  labs(
    x = "Prey mass in grams",
    y = "Predator mass in grams",
    color = "Predator Lifestage",
    title = paste0("Predator-Prey Mass Relationship")
  ) +
  
  # Custom Theme and Layout 
  theme_bw() +
  theme(
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.box = "horizontal",
    strip.placement = "outside",
    plot.margin = margin(10, 20, 10, 10),
    strip.text = element_text(face = "bold"),
    plot.title = element_text(hjust = 0.5)
  )+ scale_y_continuous(trans = "log10") + scale_x_continuous(trans = "log10")+ guides(colour = guide_legend(nrow = 1))

P 

# Save the plot to a PDF file
# Using ggsave is generally safer/better within the tidyverse environment
ggsave(results_pdf_path, P, width = 8, height = 12) 

# ----------------------------------------------------------------------
# 5. Final Output and Confirmation 
# ----------------------------------------------------------------------

cat("\nAnalysis complete and results saved.\n")
cat(paste("Plot saved to:", results_pdf_path, "\n"))
cat(paste("Results table saved to:", results_csv_path, "\n"))

