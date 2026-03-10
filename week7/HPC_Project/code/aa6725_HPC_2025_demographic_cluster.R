# CMEE 2024 HPC exercises R code pro forma
# For stochastic demographic model cluster run

# ==============================================================================
# Initial Setup
# ==============================================================================

# Clear workspace
rm(list = ls())

# Source main function
source("Demographic.R")
source("aa6725_HPC_2025_main.R")

# Allocate job no.
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Local testing
if(is.na(iter)) {
  iter <- 1
}

# Set the random number seed to iter
set.seed(iter)

# ==============================================================================
# Define Matrices and Parameters
# ==============================================================================

# Define the growth matrix (survival and stage transitions)
growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0,
                          0.5, 0.4, 0.0, 0.0,
                          0.0, 0.4, 0.7, 0.0,
                          0.0, 0.0, 0.25, 0.4),
                        nrow = 4, ncol = 4, byrow = TRUE)

# Define the reproduction matrix
reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6,
                                0.0, 0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0, 0.0),
                              nrow = 4, ncol = 4, byrow = TRUE)

# Define the clutch distribution
clutch_distribution <- c(0.06, 0.08, 0.13, 0.15, 0.16, 0.18, 0.15, 0.06, 0.03)

# Set simulation length: 120 time steps
simulation_length = 120

# Number of simulations per job
simulation_times = 150

# ==============================================================================
# Initial Conditions
# ==============================================================================

if (iter >= 1 && iter <= 25) {
  # Initial condition 1: Large population of 100 adults 
  initial_state <- state_initialise_adult(num_stages = 4, initial_size = 100)
  scenario_name <- "Large adult population"
  
} else if (iter <= 50) {
  # Initial condition 2: Small population of 10 adults 
  initial_state <- state_initialise_adult(num_stages = 4, initial_size = 10)
  scenario_name <- "Small adult population"
  
} else if (iter <= 75) {
  # Initial condition 3: Large population of 100 individuals spread evenly
  initial_state <- state_initialise_spread(num_stages = 4, initial_size = 100)
  scenario_name <- "Large spread population"
  
} else {
  # Initial condition 4: Small population of 10 individuals spread evenly
  initial_state <- state_initialise_spread(num_stages = 4, initial_size = 10)
  scenario_name <- "Small spread population"
}

# Create file name
output_filename <- paste0("demographic_sim_results_", iter, ".rda")

# ==============================================================================
# Results Storage Setup
# ==============================================================================
# Run 150 Simulations and Save Results
# ==============================================================================

results_sim <- vector("list", simulation_times)

for (i in 1:simulation_times) {
  
  sim_result <- stochastic_simulation(
    initial_state,
    growth_matrix,
    reproduction_matrix,
    clutch_distribution,
    simulation_length
  )

# Force correct length in case of early extinction
  if (length(sim_result) < simulation_length + 1) {
    sim_result <- c(sim_result, rep(0, (simulation_length + 1) - length(sim_result)))
  }
  
  results_sim[[i]] <- sim_result
}
  
save(results_sim, file = output_filename)

print(paste("Successfully saved results to", output_filename))

