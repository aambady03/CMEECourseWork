# CMEE 2024 HPC exercises R code pro forma
# For neutral model cluster run

# Clear workspace
rm(list = ls())

# Source main function file
source("aa6725_HPC_2025_main.R")

# ----------------------------------------------------------------------------
# Get job number from cluster
# ----------------------------------------------------------------------------
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Local testing: If running locally (not on cluster), iter will be NA
if(is.na(iter)) {
  iter <- 1
  cat("WARNING: Running in local test mode with iter = 1\n")
}

# ----------------------------------------------------------------------------
# Set the random number seed to iter
# ----------------------------------------------------------------------------
set.seed(iter)

# ----------------------------------------------------------------------------
# Determine community size based on job number
# ----------------------------------------------------------------------------
if (iter >= 1 && iter <= 25) {
  size <- 500
} else if (iter >= 26 && iter <= 50) {
  size <- 1000
} else if (iter >= 51 && iter <= 75) {
  size <- 2500
} else if (iter >= 76 && iter <= 100) {
  size <- 5000
} else {
  stop("Invalid iter value: must be between 1 and 100")
}

# ----------------------------------------------------------------------------
# Set simulation parameters
# ----------------------------------------------------------------------------
speciation_rate <- 0.0061118

interval_rich <- 1
interval_oct <- size / 10
burn_in_generations <- 8 * size
wall_time <- 11.5 * 60  # 11.5 hours in minutes

# Create unique filename for this job
output_file_name <- paste0("aa6725_neutral_", iter, ".rda")

# ----------------------------------------------------------------------------
# Run the simulation
# ----------------------------------------------------------------------------
cat("===========================================\n")
cat("Starting simulation for job", iter, "\n")
cat("Community size:", size, "\n")
cat("Speciation rate:", speciation_rate, "\n")
cat("Burn-in generations:", burn_in_generations, "\n")
cat("Interval rich:", interval_rich, "\n")
cat("Interval oct:", interval_oct, "\n")
cat("Wall time:", wall_time, "minutes\n")
cat("Output file:", output_file_name, "\n")
cat("===========================================\n")

# Call the neutral_cluster_run function
neutral_cluster_run(
  speciation_rate = speciation_rate,
  size = size,
  wall_time = wall_time,
  interval_rich = interval_rich,
  interval_oct = interval_oct,
  burn_in_generations = burn_in_generations,
  output_file_name = output_file_name
)

cat("===========================================\n")
cat("Job", iter, "completed successfully!\n")
cat("===========================================\n")
febfvefivbfvbe