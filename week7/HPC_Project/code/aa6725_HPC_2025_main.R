  # CMEE 2024 HPC exercises R code main pro forma
  # You don't HAVE to use this but it will be very helpful.
  # If you opt to write everything yourself from scratch please ensure you use
  # EXACTLY the same function and parameter names and beware that you may lose
  # marks if it doesn't work properly because of not using the pro-forma.
  
  name <- "Anaga Ambady"
  preferred_name <- "Anaga"
  email <- "aa6725@imperial.ac.uk"
  username <- "aa6725"
  
  # Please remember *not* to clear the work space here, or anywhere in this file.
  # If you do, it'll wipe out your username information that you entered just
  # above, and when you use this file as a 'toolbox' as intended it'll also wipe
  # away everything you're doing outside of the toolbox.  For example, it would
  # wipe away any automarking code that may be running and that would be annoying!
  
  # Section One: Stochastic demographic population model
  # Source the demographic functions
  source("Demographic.R")
  
  # Question 0
  # Create a function to initialize the population in two starting scenarios:
  # One with all individuals in the adult stage 
  # And one with individuals spread evenly across all stages 
  
  state_initialise_adult <- function(num_stages, initial_size) {
    # Create a vector of zeros
    state <- rep(0, num_stages)
    
    # Put all individuals in the last stage (adults)
    state[num_stages] <- initial_size
    
    return(state)
  }
  
  # Spreads population evenly across stages
  # If not divisible, extras go to younger stages first
  # Example: num_stages=3, initial_size=8 → {3, 3, 2}
  
  state_initialise_spread <- function(num_stages, initial_size) {
    # Find how many go in each stage (rounded down)
    base_per_stage <- floor(initial_size / num_stages)
    
    # How many are left over
    remainder <- initial_size %% num_stages
    
    # Give everyone the base amount
    state <- rep(base_per_stage, num_stages)
    
    # Give the extras to the youngest stages
    if (remainder > 0) {
      state[1:remainder] <- state[1:remainder] + 1
    }
    
    return(state)
  }
  
  # Question 1
  question_1 <- function() {
    
    # Load growth matrix: how individuals survive and develop
    growth_matrix <- matrix(c(
      0.1, 0.0, 0.0, 0.0,    # Row 1: eggs
      0.5, 0.4, 0.0, 0.0,    # Row 2: caterpillars
      0.0, 0.4, 0.7, 0.0,    # Row 3: pupae
      0.0, 0.0, 0.25, 0.4    # Row 4: adults
    ), nrow = 4, ncol = 4, byrow = TRUE)
    
    # Reproduction matrix: how adults make eggs: only adults(column 4) make eggs
    reproduction_matrix <- matrix(c(
      0.0, 0.0, 0.0, 2.6,    
      0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 0.0
    ), nrow = 4, ncol = 4, byrow = TRUE)
    
    # Combine them to get the full projection matrix
    projection_matrix <- growth_matrix + reproduction_matrix
    
    # Reference starting conditions
    initial_adults <- state_initialise_adult(num_stages = 4, initial_size = 100)
    initial_spread <- state_initialise_spread(num_stages = 4, initial_size = 100)
    
    # Run deterministic simulations for both starting conditions
    result_adults <- deterministic_simulation(initial_adults, projection_matrix, 24)
    result_spread <- deterministic_simulation(initial_spread, projection_matrix, 24)
    
    # Plot the results
    png(filename = "../results/question_1.png", width = 800, height = 500)
        plot(0:24, result_adults, type="l", col="blue", lwd=2,xaxs = "i", xlim = c(0, 24) ,ylim=range(c(result_adults, result_spread)), main="Effect of Initial Age Distribution on Population Growth", xlab="Time Step", ylab="Total Population Size")
        lines(0:24, result_spread, col="red", lwd=2)
        legend("top", legend=c("All adults (0,0,0,100)", "Spread across stages (25,25,25,25)"), col=c("blue", "red"), lty=1, lwd=2, horiz=TRUE, bty="n")
    dev.off()
  }
  
  # Question 2: Stochastic (Random) Population Model Comparison
  # Use both starting populations but now with randomness
  # (realism) through a "clutch distribution" (variation in eggs laid)
  question_2 <- function() {
    
  # Set up the same projection matrices as in Q1
    
    # Growth matrix (survival and stage transitions)
    growth_matrix <- matrix(c(
      0.1,  0.0,  0.0,  0.0,
      0.5,  0.4,  0.0,  0.0,
      0.0,  0.4,  0.7,  0.0,
      0.0,  0.0,  0.25, 0.4
    ), nrow = 4, ncol = 4, byrow = TRUE)
    
    # Reproduction matrix (only adults make eggs)
    reproduction_matrix <- matrix(c(
      0.0,  0.0,  0.0,  2.6,
      0.0,  0.0,  0.0,  0.0,
      0.0,  0.0,  0.0,  0.0,
      0.0,  0.0,  0.0,  0.0
    ), nrow = 4, ncol = 4, byrow = TRUE)
    
    
    # Add clutch distribution for stochasticity in egg laying
    # This vector represents probability of laying 1, 2, 3, ... 9 eggs
    
    clutch_distribution <- c(0.06, 0.08, 0.13, 0.15, 0.16, 0.18, 0.15, 0.06, 0.03)
    # Index:                  1     2     3     4     5     6     7     8     9
    
   # Create the same two starting conditions as in Q1
    initial_adults <- state_initialise_adult(num_stages = 4, initial_size = 100)
    initial_spread <- state_initialise_spread(num_stages = 4, initial_size = 100)
    
    # Run stochastic simulations for both starting conditions
    result_adults_stoc <- stochastic_simulation(initial_adults, growth_matrix, reproduction_matrix, clutch_distribution, 24)
    result_spread_stoc <- stochastic_simulation(initial_spread, growth_matrix, reproduction_matrix, clutch_distribution, 24)
    
    # Plot the results
    png(filename="../results/question_2.png", width=800, height=500)
    y_limit <- range(c(result_adults_stoc, result_spread_stoc))
    plot(0:24, result_adults_stoc, type="l", col="blue", lwd=2, xaxs = "i", ylim=y_limit, main="Stochastic Population Model: Effect of Initial Conditions", xlab="Time Step", ylab="Total Population Size")
    lines(0:24, result_spread_stoc, col="red", lwd=2)
    legend("top", legend=c("All adults (0,0,0,100)", "Spread across stages (25,25,25,25)"), col=c("blue", "red"), lty=1, lwd=2, horiz=TRUE, bty="n")
    
    dev.off()
  }

    
  # Questions 3 and 4 involve writing code elsewhere to run your simulations on the cluster
  
  # Question 5
  question_5 <- function(){
    
    # Initialize a vector to store extinction counts for each condition
    count_extinctions <- rep(0, 4)
  
    # Loop through all 100 simulation sets (files)
    for(simulation_set in 1:100){
      # simulation_set = file number (equivalent to 'iter' in cluster code)
      
     # Determine which condition this file corresponds to based on its file no.
     # This matches the cluster code's if-else for iter ranges
      if(simulation_set <= 25) {
        current_condition = 1  # Large adult population
      } else if(simulation_set <= 50) {
        current_condition = 2  # Small adult population
      } else if(simulation_set <= 75) {
        current_condition = 3  # Large spread population
      } else if(simulation_set <= 100) {
        current_condition = 4  # Small spread population
      }
      
      # Load simulation results for this file 
      # Construct filename (matches cluster's output_filename)
      file_name = paste("../data/demographic_sim_results_", simulation_set, ".rda", sep="")
      
      # Load file - this creates a variable called 'results_sim' in memory
      load(file_name)
      
      # Loop through each of the 150 simulations in this file
      # match the simulation loop in the cluster code: for (i in 1:simulation_times) where simulation_times=150
      for(simulation_number in 1:150){
       
        # Extract ONE simulation from the list
        simulation_data <- results_sim[simulation_number]
        
        # Get the LAST population value from this simulation to check for extinction
        t_value <- simulation_data[[1]][length(simulation_data[[1]])]
        
        if(t_value == 0){
          # Increment extinction count for this condition
          count_extinctions[current_condition] <- count_extinctions[current_condition] + 1
        }
      }
    }
    
    # Calculate the proportion of simulations that went extinct for each condition
    rate_of_extinction <- count_extinctions / rep(25 * 150, 4)
    
    # Print for debugging
    print("Extinction counts:")
    print(count_extinctions)
    print("Extinction proportions:")
    print(rate_of_extinction)
    
    # Small adult (2), Small spread (4), Large adult (1), Large spread (3)
    plot_data <- rate_of_extinction[c(2, 4, 1, 3)]
    
    # Assign names that match cluster to the extinction rates for clarity in plotting and interpretation
    names(rate_of_extinction) = c("Small 10 adult",
                                  "Small 10 spread",  
                                  "Large 100 adult",    
                                  "Large 100 spread")     
    
   # Create a bar plot to visualize the extinction rates for each condition
    png(filename="../results/question_5.png", width = 800, height = 500)
    par(mar = c(9, 5, 4, 2), family = "serif", las = 1)
    
  bp  <-barplot(plot_data,
            ylab = "Proportion of Extinctions", 
            ylim = c(0, 0.20),
            main = "Proportion of Simulations Resulting in Extinction",
            las = 1,
            col = "palegreen4",
            border = "white",
            names.arg = c("Small adult \n(10)",
                          "Small spread\n(10)",
                          "Large spread\n(100)",
                          "Large adult\n(100)"),
            cex.names = 1.0,
            cex.axis = 1.1,
            cex.lab = 1.2,
            cex.main = 1.3)
    axis(side = 1, at = c(-1, max(bp) + 1), labels = FALSE, lwd = 1, pos = 0)
    mtext("Initial Condition", side = 1, line = 5, cex = 1.2)
    
    dev.off()
    
    # Identify which condition had the highest extinction rate and write an explanation
    most_extinct_idx <- which.max(rate_of_extinction)
    most_extinct_name <- names(rate_of_extinction)[most_extinct_idx]
    highest_proportion <- rate_of_extinction[most_extinct_idx]
    
    Sys.sleep(0.1)
    
    written_explanation <- paste0(
      "The ", most_extinct_name, " was most likely to go extinct ",
      "(proportion = ", round(highest_proportion, 3), "). ",
      "This occurs because smaller populations are more vulnerable to demographic stochasticity, ",
      "where random fluctuations in survival and reproduction can drive the entire population to zero. ",
      "Since the population only contains 10 individuals spread across the life stages, ",
      "the population lacks the reproductive buffer that larger populations have. ",
      "Furthermore, the spread distribution means that there are fewer adults at any given time to produce offspring. ",
      "This means that the population is more likely to collapse completely before enough new individuals can be born to sustain it, ",
      "increasing the risk of extinction."
    )
    
    return(written_explanation)
  }
  
  # Question 6
  question_6 <- function(){
    
    # For every time step, store total population size
    total_population_100_spread <- rep(0, 121)
    total_population_10_spread <- rep(0, 121)
    
    # Process stochastic simulation 
    for (simulation_set in 51:100) {
      file_name = paste("../data/demographic_sim_results_", simulation_set, ".rda", sep="")
      load(file_name)
      
      for (sim_index in 1:150) {
        
        simulation_data <- results_sim[[sim_index]]  
        
        if (simulation_set <= 75) {
          total_population_100_spread <- total_population_100_spread + simulation_data
        } else {
          total_population_10_spread <- total_population_10_spread + simulation_data
        }
      }
    }
    
    # Average stochastic population trends
    average_population_100_spread <- total_population_100_spread / (25 * 150)
    average_population_10_spread <- total_population_10_spread / (25 * 150)
    
    # Deterministic simulation for comparison
    growth_matrix <- matrix(c(
      0.1, 0.0, 0.0, 0.0,
      0.5, 0.4, 0.0, 0.0,
      0.0, 0.4, 0.7, 0.0,
      0.0, 0.0, 0.25, 0.4
    ), nrow = 4, ncol = 4, byrow = TRUE)
    
    reproduction_matrix <- matrix(c(
      0.0,  0.0,  0.0,  2.6,
      0.0,  0.0,  0.0,  0.0,
      0.0,  0.0,  0.0,  0.0,
      0.0,  0.0,  0.0,  0.0
    ), nrow = 4, ncol = 4, byrow = TRUE)
    
  projection_matrix <- growth_matrix + reproduction_matrix
  
    initial_state_large <- state_initialise_spread(4, 100)
    initial_state_small <- state_initialise_spread(4, 10)
    
    # Run deterministic simulations
    
    deterministic_large <- deterministic_simulation(
      state_initialise_spread(4, 100),
      projection_matrix,
      120
    )
    
    deterministic_small <- deterministic_simulation(
      state_initialise_spread(4, 10),
      projection_matrix,
      120
    )
    
    # Calculate deviations (trends)
    deviation_large <- average_population_100_spread / deterministic_large
    deviation_small <- average_population_10_spread / deterministic_small
    
    
    # Plot your graph here
    png(filename="../results/question_6.png", width = 600, height = 400)
    y_range <- range(c(deviation_large, deviation_small), na.rm = TRUE)
    par(mar = c(5, 5, 4, 2))
    
    plot(0:120, deviation_large, type = "l", col = "blue", lwd = 2,
         ylim = y_range,
         xlab = "Time Step ",
         ylab = "Deviation from Deterministic Model",
         main = "Deviation of Stochastic Model from Deterministic Model")
         
    lines(0:120, deviation_small, col = "red", lwd = 2)
    
    abline(h = 1, lty = 2, col = "gray")
    
    # make the legend on the side with a box around it
    legend("topright", 
           legend = c("Large population (100)", "Small population (10)"), 
           col = c("blue", "red"), 
           lty = 1, 
           lwd = 2, 
           bty = "o",      # Box around it
           bg = "white",   # Solid background so it doesn't overlap lines
           cex = 0.8)      # Makes the whole legend smaller
    
    Sys.sleep(0.1)
    dev.off()
    
    return("The deterministic model approximates the stochastic model much better for large populations. Small populations experience greater demographic stochasticity, leading to larger deviations from deterministic predictions.")
  }
  
  # Section Two: Individual-based ecological neutral theory simulation 
  # creating two initial populations with different levels of diversity
  # CREATING A function to calc species richness 2 types of pop, one with more diversity than the other
  # creating a function to randomly pick 2 individuals from a community w/o replacement
  
  # Question 7
  species_richness <- function(community){
      # Find unique species(types) in the community
      species_types <- unique(community)
      # The count of unique species = species richness
      richness <- length(species_types)
      return(richness)
    }

  
  # Question 8
  init_community_max <- function(size){
    # Creating a sequence representing individuals that have max diversity from 1 to size
    max_diversity <- 1:size
    return(max_diversity)
  }

  # Question 9
  init_community_min <- function(size){
    # Generate an initial sequence where all individuals belong to a single species
    min_diversity <- rep(1, size)
    return(min_diversity)
  }

  
  # Question 10
  choose_two <- function(max_value){
    # Sample 2 distinct numbers from 1 to max_value without replacement
    chosen_indices <- sample(1:max_value, size = 2, replace = FALSE)
    return(chosen_indices)
  }
  
  # Question 11
  neutral_step <- function(community){
    # Follows neutral theory, where an an individual that dies is replaced by the offspring of another individual
    # The first choice dies, while the others reproduces 
    selected_individuals<- choose_two(length(community))
    # Replace the species of the dying individual with the species of the reproducing individual
    community[selected_individuals[1]] <- community[selected_individuals[2]]
    return(community)
  }
  
  # Question 12
  # One generation = half the population dying (on average), not everyone dying.
  neutral_generation <- function(community){
    # Calculate total size of the community
    community_size <- length(community)
    # Calculate the number of individuals in one generation, round if needed
    replacement_steps <- floor(community_size / 2)
    # Execute neutral steps for one generation
    for (i in 1:replacement_steps) {
      community <- neutral_step(community)
    }
    return(community)
  }

  # Question 13
  neutral_time_series <- function(community,duration)  {
    # Use a vector to store richness at each time point
    richness_history<- numeric(duration + 1)
    # Record the species richness of the initial community
    current_community <- community
    richness_history[1] <- species_richness(community)
    # Run the simulation for the specified duration
    for (i in 1:duration) {
      current_community <- neutral_generation(current_community)
      richness_history[i + 1] <- species_richness(current_community)
    }
    return(richness_history)
  }
 
  
  # Question 14
  question_14 <- function() {
    # Create a max. diversity community
    initial_community <- init_community_max(100)
    # Run a simulation for 200 generations
    richness_time_sim <- neutral_time_series(initial_community, 200)
    print(richness_time_sim)
    
    # Plot parameters
    png(filename="../results/question_14.png", width = 600, height = 400)
    # Plotting results 
    plot(richness_time_sim, type="l", main= "Neutral Model Simulation across 200 generations",xlab="Generation",xaxs = "i",xlim= c(0, 200),yaxs = "i",ylim= c(0, 100), ylab="Species Richness")
    dev.off()
    
    return("The initial state for the simulation is a maximally diverse community of 100 indivduals, over 200 hundred generations, the species richness declines as extinct indivduals are not being replaced and speciation or immigration is not occuring and the system trends towards fixation of a single species" )
  
  }
  
  # Question 15 (performs NM with speciation)
  # Replaces exactly one individual with likelihood of a speciation event
  neutral_step_speciation <- function(community,speciation_rate) {
    
    # Generates 1 random number between 0 and 1 and depending on speciation rate allows for speciation to occur
    if (runif(1) < speciation_rate) {
    # Speciation event 
    death_index <- sample.int(length(community), 1)
    new_species_id <- max(community) + 1
    community[death_index] <- new_species_id
    }else{
      # normal reproduction event
      community <- neutral_step(community)
    }
    return(community)
  }
  
  # Question 16
  #Replaces roughly half the population.
  # speciation in NM means replacing a dying individual with a new species with a certain probability
  #speciation_rate is the probability of speciation occurring during a neutral step
  neutral_generation_speciation <- function(community,speciation_rate)  {
    # Calculate the size of the community
    community_size <- length(community)
    # Determine the number of steps, rounding up or down randomly if size is odd
    if (community_size %% 2 == 0) {
      steps <- community_size / 2
    } else {
      steps <- ifelse(runif(1) < 0.5, floor(community_size / 2), ceiling(community_size / 2))
    }
    
    # Perform neutral steps with speciation for one generation  
    for (i in 1:steps) {
      community <- neutral_step_speciation(community, speciation_rate)
    }
    
    return(community)
  }
  
  # Question 17
  neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
    # Initialize a vector to store species richness over time
    richness_over_time <- numeric(duration + 1)
    # Record the species richness of the initial community
    current_state <-community
    richness_over_time[1] <- length(unique(current_state))
    # Run through each time step and calculate richness
    for (time_step in 1:duration) {
      current_state <- neutral_generation_speciation(current_state, speciation_rate)
      richness_over_time[time_step + 1] <- length(unique(current_state))
    }
    return(richness_over_time)
  }
  
  # Question 18
  question_18 <- function()  {
    # Parameters
    community_size <- 100
    speciation_rate <- 0.1
    generations <- 200
    
    # Create a max. diversity community
    start_max <- init_community_max(community_size) # 100 unique species
    start_min <- rep(1, community_size)
    
    # run a simulation for 200 generations for both conditions
    richness_max <- neutral_time_series_speciation(start_max, speciation_rate, generations)
    richness_min <- neutral_time_series_speciation(start_min, speciation_rate, generations)
    
      # plot parameters
    png(filename="../results/question_18.png", width = 600, height = 400)
    plot(0:generations, richness_max, 
         type = "l", 
         col = "#0072B2",  # Colorblind-friendly blue
         lwd = 2, 
         ylim = c(0, 100), 
         main = "Neutral Model with Speciation across 200 Generations", 
         xlab = "Generation", 
         xaxs = "i",
         ylab = "Species Richness")
    
    # Add min diversity simulation line
    lines(0:generations, richness_min, 
          col = "#D55E00",  # Colorblind-friendly orange/red
          lwd = 2)
    
    # Add legend at the right corner with a box around it
    legend("topright", 
           legend = c("Max Diversity Start", "Min Diversity Start"), 
           col = c("#0072B2", "#D55E00"), 
           lty = 1, 
           lwd = 2, 
           bty = "o",      # Box around it
           bg = "white",   # Solid background so it doesn't overlap lines
           cex = 0.8)      # Makes the whole legend smaller
    
    dev.off()
    #Sys.sleep(0.1)
    
    return("The plot shows that neutral dynamics reach a stable equilibrium, regardless of intial coniditons over time. The maximum diversity scenario shows a reduction in species richness due to extinction events, while the minimum diversity scenario shows an increase in species richness due to speciation events. Both scenarios converge towards a similar equilibrium since the rate of speciation balances the rate of extinction over time in a neutral model.The equilibrium state is more dependent on community size, speciation rate and random drift rather than initial conditions. Larger communities mean that more species can coexist,while  higher speciation rates means more species are being maintained but stochastic processes are more key to the maintainence of biodiversity at an equilibrium level.")
  }

  # Question 19
  species_abundance <- function(community)  {
    # Count how many indivs of each species
    species_counts <- table(community)
    
    # Sorted from the most to the least abundant
    sorted_abundance <- sort(species_counts, decreasing = TRUE)
    
    # Return as a simple numeric vector
    return(as.vector(sorted_abundance))
  }
  
  # Question 20
  octaves <- function(abundance_vector) {
    # Handle empty input instead of crashing
    if (length(abundance_vector) == 0) {
      return(integer(0))
    }
    # Determine the octave class for each abundance value
    # What power of 2 is this abundance? and floor removes decimals(rounding down)
    # Adding 1 because log2(1) is 0, and octaves must start from 1 
    
    octave_classes_for_each_species <- floor(log2(abundance_vector))
   
     # Count the number of species in each octave class
     # Tabulate function sums octave counts 
     # A vector of octaves are returned containing the levels across the population
    species_per_octave <- tabulate(octave_classes_for_each_species + 1)
    return(species_per_octave)
    
  }
  
  # Question 21
  # Helper function
  sum_vect <- function(x, y) {
    if (length(x) < length(y)) {
      x <- c(x, rep(0, length(y) - length(x)))
    } else if (length(y) < length(x)) {
      y <- c(y, rep(0, length(x) - length(y)))
    }
    return(x + y)
  }
  
  
  # Question 22
  question_22 <- function() {
    
    # Parameters 
    speciation_rate <- 0.1
    community_size <- 100
    burn_in_gen <- 200
    simulation_length <- 2000
    recording_interval <- 20
    num_recordings <- simulation_length / recording_interval
    
    # Initial communities
    starts <- list(
      Max = init_community_max(community_size),
      Min = init_community_min(community_size)
    )
    
    results <- list()  # store mean octave distributions
    
    # Run simulations 
    for (name in names(starts)) {
      community <- starts[[name]]
      all_octaves <- vector("list", num_recordings)
      
      # Burn-in phase
      for (g in 1:burn_in_gen) {
        community <- neutral_generation_speciation(community, speciation_rate)
      }
      
      # Recording phase
      for (s in 1:num_recordings) {
        for (g in 1:recording_interval) {
          community <- neutral_generation_speciation(community, speciation_rate)
        }
        all_octaves[[s]] <- octaves(species_abundance(community))
      }
      
      # Mean octave calculation
      total_octave <- all_octaves[[1]]
      for (i in 2:num_recordings) {
        total_octave <- sum_vect(total_octave, all_octaves[[i]])
      }
      
      results[[name]] <- total_octave / num_recordings
    }
    
    mean_octaves_max <- results$Max
    mean_octaves_min <- results$Min
    
    # Plot 
    
    # Plotting Parameters
    png(filename = "../results/question_22.png", width = 1000, height = 500, res = 100)
    
    # Global academic styles: Serif font and horizontal y-axis labels
    par(mfrow = c(1, 2), 
        mar = c(5, 5, 4, 2), 
        oma = c(0, 0, 2, 0),
        family = "serif", 
        las = 1)
    
    # Determine global Y limit for perfect comparison
    y_limit <- max(c(mean_octaves_min, mean_octaves_max), na.rm = TRUE) * 1.15
    
    # 1. Min Diversity Plot
    bp_min <- barplot(mean_octaves_min,
                      main = "Min Diversity Start",
                      xlab = "Abundance Class (Octave)",
                      ylab = "Mean Number of Species",
                      col = "#D55E00", # Academic orange
                      border = "white",
                      ylim = c(0, y_limit),
                      axes = FALSE,    # Custom axis for L-frame
                      cex.main = 1.3,
                      yaxs = "i")      # Remove bottom gap
    
    axis(side = 2, lwd = 1.5)          # Clean Y-axis
    abline(h = 0, lwd = 1.5)           # Crisp X-axis baseline
    
    # 2. Max Diversity Plot
    bp_max <- barplot(mean_octaves_max,
                      main = "Max Diversity Start",
                      xlab = "Abundance Class (Octave)",
                      ylab = "Mean Number of Species",
                      col = "#0072B2", # Academic blue
                      border = "white",
                      ylim = c(0, y_limit),
                      axes = FALSE,
                      cex.main = 1.3,
                      yaxs = "i")
    
    axis(side = 2, lwd = 1.5)
    abline(h = 0, lwd = 1.5)
    
    # Figure-wide Title
    mtext("Equilibrium Species Abundance Distributions", outer = TRUE, cex = 1.5, font = 2)
    dev.off()
    return("The high resemblance between both bar plots in both conditions show that initial conditions do not mainly contribute to the long-term species abundance distribution in a neutral model with speciation.Despite the strong variability between the sample size (i.e 1 vs 100), both distributions show a similar trend, with many rare epecies (shown as high bars in octaves 1-2) and progressively fewer common species(declining bars in higher octaves). This pattern can be explained as: when the neutral model with speciation reaches a dynamic equilibriumwhere the rate of speciation is balanced by the rate of random extinction events. The equilibrium abundance distribution relies mainly on the speciation rate (0.1), and community size (100), rather than the initialconditions. The burn-in period (warm-up time for simulation) of 200 generations was sufficient to observe a convergence and disregard the initial conditions for both scenarios. The plot supports the neutral theory:initial conditions are treated as transient, while the long-term state of equilibrium is maintained by ecological parameters.")
  }

  # Question 23
  neutral_cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name) {
      
    # Initialize sim
    sim_start_timer <- proc.time()[3]
    wall_time_secs <- wall_time *60
    
    # Create a min diversity community
    community <- init_community_min(size)
    
    # Storage vectors
    richness_time_series <- numeric(0)
    octave_snapshots_list <- list()
    
    generation <- 0
    
    # Main simulation loop
    while((proc.time()[3] - sim_start_timer) < wall_time_secs) {
      
      # Run one generation with speciation
      community <- neutral_generation_speciation(community, speciation_rate)
      generation <- generation + 1
      
      # Record species richness ONLY during burn-in
      if (generation <= burn_in_generations && generation %% interval_rich == 0) {
        richness_time_series <- c(richness_time_series, species_richness(community))
      }
      
      # Record octave distribution at specified intervals
      if (generation %% interval_oct == 0) {
        abundance <- species_abundance(community)
        octave_snapshots_list[[length(octave_snapshots_list) + 1]] <- octaves(abundance)
      }
    }
    # Calculate actual runtime
    actual_runtime_seconds <- proc.time()[3] - sim_start_timer
    
    # Save results
    save(richness_time_series,
         octave_snapshots_list,
         community,
         actual_runtime_seconds,
         speciation_rate,
         size,
         wall_time,
         interval_rich,
         interval_oct,
         burn_in_generations,
         file = output_file_name)
    
    return(paste("Simulation complete:", generation, "generations in", 
                 round(actual_runtime_seconds, 2), "seconds"))
  }
  
  # Questions 24 and 25 involve writing code elsewhere to run your simulations on
  # the cluster
  
  # Question 26 
  process_neutral_cluster_results <- function() {
    
    # Define group sizes based on cluster order
    size_groups <- list(
      "500"  = 1:25,
      "1000" = 26:50,
      "2500" = 51:75,
      "5000" = 76:100
    )
    
    combined_results <- list(
      "500"  = NULL,
      "1000" = NULL,
      "2500" = NULL,
      "5000" = NULL
    )
  # Loop through each size group and process files
    for (size in names(size_groups)) {
      
      cat("Processing size:", size, "\n")
      
      file_indices <- size_groups[[size]]
      accumulated_octave <- NULL
      snapshot_count <- 0
      
      for (index in file_indices) {
        file_name <- paste("../data/aa6725_neutral_", index, ".rda", sep = "")
        
        if (!file.exists(file_name)) {
          cat("  Warning: File", file_name, "not found. Skipping.\n")
          next
        }
        
        # Load into an isolated environment so it CANNOT
        # overwrite combined_results or any other local variable 
        e <- new.env(parent = emptyenv())
        load(file_name, envir = e)
        
        # Pull out what we need from that environment
        octave_snapshots_list <- e$octave_snapshots_list
        burn_in_generations   <- e$burn_in_generations
        interval_oct          <- e$interval_oct
        
        burn_in_snapshots <- burn_in_generations / interval_oct
        total_snapshots   <- length(octave_snapshots_list)
        
        if (total_snapshots > burn_in_snapshots) {
          post_burn_in_snapshots <- octave_snapshots_list[(burn_in_snapshots + 1):total_snapshots]
          
          for (snapshot in post_burn_in_snapshots) {
            if (is.null(accumulated_octave)) {
              accumulated_octave <- snapshot
            } else {
              accumulated_octave <- sum_vect(accumulated_octave, snapshot)
            }
            snapshot_count <- snapshot_count + 1
          }
        } else {
          cat("  Warning: Job", index, "has no post-burn-in data. Skipping.\n")
        }
      }
      
      if (!is.null(accumulated_octave) && snapshot_count > 0) {
        combined_results[[size]] <- accumulated_octave / snapshot_count
        cat("  Size", size, ": processed", snapshot_count, "snapshots\n")
      } else {
        cat("  Size", size, ": NO DATA\n")
      }
    }
    
    # Delete any old/corrupt .rda before saving fresh
    if (file.exists("../results/aa6725_neutral_combined.rda")) {
      file.remove("../results/aa6725_neutral_combined.rda")
    }
    
    save(combined_results, file = "../results/aa6725_neutral_combined.rda")
    cat("\nSaved to ../results/aa6725_neutral_combined.rda\n")
    cat("Sizes with data:", names(combined_results)[!sapply(combined_results, is.null)], "\n")
    
    return(combined_results)
  }
  
  plot_neutral_cluster_results <- function() {
    # Load the combined results
    load("../results/aa6725_neutral_combined.rda")
    
    # Use a high-resolution PNG or PDF for academic quality
    png(filename = "../results/plot_neutral_cluster_results.png", 
        width = 1200, height = 900, res = 120) # Added 'res' for sharper text
    
    # Global graphical parameters
    par(mfrow = c(2, 2),
        mar   = c(5, 5, 3, 2),   
        oma   = c(2, 1, 5, 1),
        family = "serif",        # Standard academic font
        las    = 1)              # Horizontal axis labels for readability
    
    colours <- c("500"  = "#0072B2", "1000" = "#D55E00", 
                 "2500" = "#009E73", "5000" = "#CC79A7")
    
    for (size_name in c("500", "1000", "2500", "5000")) {
      octave_data <- combined_results[[size_name]]
      
      if (is.null(octave_data) || length(octave_data) == 0) {
        plot.new()
        text(0.5, 0.5, paste("No data for size", size_name), family = "serif")
        next
      }
      
      y_max <- max(octave_data, na.rm = TRUE)
      n_oct <- length(octave_data)
      lower <- 2^(0:(n_oct - 1))
      upper <- 2^(1:n_oct) - 1
      oct_labels <- ifelse(lower == upper, as.character(lower), paste0(lower, "-", upper))
      
      # Base Plot
      # yaxs = "i" removes the gap at the bottom of the bars
      bp <- barplot(octave_data,
                    main      = paste("Community Size =", size_name),
                    ylab      = "Mean Number of Species",
                    col       = colours[size_name],
                    border    = "white",         # Subtle bar separation
                    ylim      = c(0, y_max * 1.1),
                    names.arg = oct_labels,
                    cex.main  = 1.4,
                    cex.lab   = 1.2,
                    cex.axis  = 1.0,
                    cex.names = 0.8,
                    las       = 2,               # Vertical x-labels
                    axes = FALSE,              # Suppress default axes for custom styling
                    yaxs      = "i",             # Internal axis style
                    space     = 0.2)             # Consistent spacing
      
      # Sharp Axis Lines (Academic 'L' frame)
      abline(h = 0, lwd = 1.5, col = "black")
      axis(side = 2, lwd = 1.5, pos = 0) # Ensures Y axis touches X axis
      
      mtext("Abundance Class (individuals)", side = 1, line = 4, cex = 0.9)
    }
    
    # Overall Figure Title
    mtext("Equilibrium Species Abundance Distributions (Neutral Model)",
          outer = TRUE, cex = 1.8, font = 2, line = 1.5, family = "serif")
    
    dev.off()
    cat("High-resolution serif plot saved to ../results/plot_neutral_cluster_results.png\n")
  }
  
  # Challenge questions - these are substantially harder and worth fewer marks.
  # I suggest you only attempt these if you've done all the main questions. 
  
  # Challenge question A

  compute_Challenge_A <- function(output_file = "../data/processed_population_data.rda") {
    cat("Starting data processing...\n")
    
  # A function to process all 100 cluster files and extract population size at 
  # each time step for each simulation, then plot the results
    
    # Constants for pre-allocation
    n_files <- 100
    sims_per_file <- 150
    timesteps <- 121
    total_rows <- n_files * sims_per_file * timesteps
    
    # Pre-allocate data frame
    # We can pre-fill simulation_number and time_step to save time inside the loop
    population_size_df <- data.frame(
      simulation_number = rep(1:(n_files * sims_per_file), each = timesteps),
      initial_condition = character(total_rows),
      time_step = rep(0:(timesteps - 1), n_files * sims_per_file),
      population_size = numeric(total_rows),
      stringsAsFactors = FALSE
    )
    
    row_idx <- 1
    
    for (file_num in 1:n_files) {
      file_name <- paste0("../data/demographic_sim_results_", file_num, ".rda")
      
      if(!file.exists(file_name)) {
        cat("Warning: File", file_num, "not found. Skipping.\n")
        next
      }
      
      # Load into a temporary environment to avoid workspace pollution
      temp_env <- new.env()
      load(file_name, envir = temp_env)
      results_sim <- temp_env$results_sim
      
      # Labeling logic
      init_cond <- if (file_num <= 25) "Large adult (100)" else 
        if (file_num <= 50) "Small adult (10)" else 
          if (file_num <= 75) "Large spread (100)" else "Small spread (10)"
      
      # Optimization: Flatten the list of 150 simulations into one vector
      # This is much faster than looping through the 150 simulations individually
      all_sim_data <- unlist(results_sim)
      n_elements <- length(all_sim_data)
      
      # Fill the dataframe in chunks
      idx_range <- row_idx:(row_idx + n_elements - 1)
      population_size_df$population_size[idx_range] <- all_sim_data
      population_size_df$initial_condition[idx_range] <- init_cond
      
      row_idx <- row_idx + n_elements
      if(file_num %% 10 == 0) cat("Processed", file_num, "files...\n")
    }
    
    # Save the hand-over file
    save(population_size_df, file = output_file)
    cat("Data processing complete. Hand-over file saved to:", output_file, "\n")
    return(output_file)
  }
  
  Challenge_A <- function(input_file = "../data/processed_population_data.rda") {
    library(ggplot2)
    
    if(!file.exists(input_file)) stop("Hand-over file not found! Run processing function first.")
    
    cat("Loading processed data for plotting...\n")
    load(input_file) # Loads 'population_size_df'
    
    cat("Generating plot (this may still take a moment due to 15,000 lines)...\n")
    png(filename = "../results/Challenge_A.png", width = 1000, height = 600)
    
    
    p <- ggplot(population_size_df, 
                aes(x = time_step, 
                    y = population_size, 
                    group = simulation_number, 
                    colour = initial_condition)) +
      # Reduced alpha slightly for better visibility of 15,000 overlapping lines
      geom_line(alpha = 0.05) + 
      
      scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) + 
      scale_x_continuous(expand = c(0, 0)) +
      
      labs(title = "15,000 Stochastic Population Simulations",
           subtitle = "Visualizing trends across different initial age distributions",
           x = "Time Step",
           y = "Population Size",
           colour = "Initial Condition") +
      
      # Cleaning up the theme
      theme_classic() + # theme_classic() removes grid lines and grey background automatically
      theme(
        text = element_text(family = "serif"), # Use serif font for an academic journal feel
        plot.title = element_text(face = "bold", size = 14),
        axis.title = element_text(face = "bold"),
        legend.position = "right",
        legend.background = element_rect(fill = "white", color = "black", size = 0.2),
        panel.grid.major = element_blank(), # Explicitly double-check grid removal
        panel.grid.minor = element_blank()
      ) +
      guides(colour = guide_legend(override.aes = list(alpha = 1))) # Make legend lines solid
    
    # Save with high resolution
    ggsave("../results/Challenge_A.png", plot = p, width = 8, height = 5, dpi = 300)
    dev.off()
    
    cat("Plot saved to ../results/Challenge_A.png\n")
  }
    
  # Challenge question B
  compute_Challenge_B <- function() {
    n_sim <- 100
    n_gen <- 2000
    speciation_rate <- 0.1
    
    # Preallocate for n_gen + 1 to include Gen 0 (Total: 2001 rows)
    richness_max <- matrix(0, nrow = n_gen + 1, ncol = n_sim)
    richness_min <- matrix(0, nrow = n_gen + 1, ncol = n_sim)
    
    for (i in seq_len(n_sim)) {
      community_max <- init_community_max(100)
      community_min <- init_community_min(100)
      
      # RECORD INITIAL STATE (Gen 0)
      richness_max[1, i] <- species_richness(community_max)
      richness_min[1, i] <- species_richness(community_min)
      
      for (t in 1:n_gen) {
        community_max <- neutral_generation_speciation(community_max, speciation_rate)
        community_min <- neutral_generation_speciation(community_min, speciation_rate)
        
        # Store at index t + 1
        richness_max[t + 1, i] <- species_richness(community_max)
        richness_min[t + 1, i] <- species_richness(community_min)
      }
      if (i %% 10 == 0) cat("Completed simulation", i, "\n")
    }
    save(richness_max, richness_min, file = "../data/processed_richness_data.rda")
  }  
  
  Challenge_B <- function() {
    if(!file.exists("../data/processed_richness_data.rda")) {
      stop("Run compute_Challenge_B() first.")
    }
    load("../data/processed_richness_data.rda")
    
    n_sim <- ncol(richness_max)
    n_gen_plus_1 <- nrow(richness_max) # This is 2001
    gens <- 0:(n_gen_plus_1 - 1)      # Creates sequence 0:2000
    
    mean_max <- rowMeans(richness_max)
    mean_min <- rowMeans(richness_min)
    tcrit <- qt(1 - 0.028/2, df = n_sim - 1)
    
    se_max <- apply(richness_max, 1, sd) / sqrt(n_sim) * tcrit
    se_min <- apply(richness_min, 1, sd) / sqrt(n_sim) * tcrit
    
    png(filename="../results/Challenge_B_Plot.png", width = 800, height = 500, res = 100)
    par(mar = c(5, 5, 4, 2), family = "serif", las = 1)
    
    # Initialize plot with L-frame (axes=FALSE)
    plot(gens, mean_max, type = "n", ylim = c(0, 100), xaxs = "i", yaxs = "i",
         xlab = "Generation", ylab = "Mean Species Richness",
         main = "Neutral Model Convergence to Dynamic Equilibrium", axes = FALSE)
    
    # Custom crisp axes
    axis(1, lwd = 1.2)
    axis(2, lwd = 1.2)
    abline(h = 0, lwd = 1.2) # Baseline
    
    # Plot Series
    lines(gens, mean_min, col = "#0072B2", lwd = 2) # Min (Blue)
    lines(gens, mean_min + se_min, col = "#0072B2", lty = 3)
    lines(gens, mean_min - se_min, col = "#0072B2", lty = 3)
    
    lines(gens, mean_max, col = "#D55E00", lwd = 2) # Max (Orange)
    lines(gens, mean_max + se_max, col = "#D55E00", lty = 3)
    lines(gens, mean_max - se_max, col = "#D55E00", lty = 3)
    
    legend("topright", bty = "n", lwd = 2, lty = c(1, 1, 3),
           legend = c("Max Initial Richness", "Min Initial Richness", "97.2% CI"),
           col = c("#D55E00", "#0072B2", "darkgray"))
    
    dev.off()
    
    return("The system reaches dynamic equilibrium in approximately 200 generations, where richness stabilizes at a mean of ~25 species regardless of initial diversity.")
  }  
  
  # Challenge question C
  compute_Challenge_C <- function() {
    # Parameters
    community_size <- 100
    speciation_rate <- 0.1
    n_generations <- 200      # length of each simulation
    n_reps <- 50             # replicates per starting richness
    
    richness_values <- 1:community_size
    n_richness <- length(richness_values)
    
    # Pre-allocate matrix (row = initial richness, col = generation)
    # We use n_generations + 1 to include Gen 0
    mean_richness_matrix <- matrix(0, nrow = n_richness, ncol = n_generations + 1)
    
    cat("Running", n_richness, "richness levels x", n_reps, "replicates each...\n")
    
    for (richness_idx in seq_along(richness_values)) {
      init_richness <- richness_values[richness_idx]
      richness_sum <- numeric(n_generations + 1)
      
      for (replicate_idx in 1:n_reps) {
        # Create community with specific initial richness
        community <- rep(x = 1:init_richness, length.out = community_size)
        richness_sum[1] <- richness_sum[1] + species_richness(community)
        
        for (gen in 1:n_generations) {
          community <- neutral_generation_speciation(community, speciation_rate)
          richness_sum[gen + 1] <- richness_sum[gen + 1] + species_richness(community)
        }
      }
      # Calculate mean across replicates for this initial richness level
      mean_richness_matrix[richness_idx, ] <- richness_sum / n_reps
      
      if (init_richness %% 10 == 0) {
        cat("  Completed initial richness:", init_richness, "\n")
      }
    }
    
    # Save the data for the plotting function
    save(mean_richness_matrix, file = "../data/challenge_c_data.rda")
    cat("Simulations complete! Data saved to ../data/challenge_c_data.rda\n")
  }
  
  Challenge_C <- function() {
    # Check if data exists
    if(!file.exists("../data/challenge_c_data.rda")) {
      stop("Run compute_Challenge_C() first to generate the data.")
    }
    
    # Load the matrix
    load("../data/challenge_c_data.rda")
    
    n_richness <- nrow(mean_richness_matrix)
    n_generations <- ncol(mean_richness_matrix) - 1 # subtracting 1 for Gen 0
    community_size <- 100 # Adjust if you changed this in the compute function
    
    # Plot setup
    png(filename = "../results/Challenge_C.png", width = 900, height = 600)
    par(mar = c(5, 5, 4, 8), las = 1)
    
    # Set up the empty plot area (log scale for x-axis as per your original)
    plot(1:n_generations, mean_richness_matrix[1, -1],
         log  = "x",
         type = "n",
         xlim = c(1, n_generations),
         ylim = c(0, community_size),
         xlab = "Generation (Log Scale)",
         ylab = "Mean Species Richness",
         main = "Neutral Model: Averaged Time Series\nfor Different Initial Species Richnesses",
         cex.main = 1.2,
         cex.lab  = 1.1)
    
    grid(col = "gray93", lty = 1)
    
    # Draw all intermediate richness lines in grey
    for (i in 1:n_richness) {
      lines(1:n_generations, mean_richness_matrix[i, -1], col = "grey70", lwd = 1.2)
    }
    
    # Highlight the boundaries (Min and Max initial richness)
    lines(1:n_generations, mean_richness_matrix[1,   -1], col = "#D55E00", lwd = 3)
    lines(1:n_generations, mean_richness_matrix[n_richness, -1], col = "#0072B2", lwd = 3)
    
    # Legend
    legend("topright",
           legend = c("Min initial richness", "Max initial richness"),
           col = c("#D55E00", "#0072B2"),
           lwd = 3,
           bty = "o",
           bg = "white",
           cex = 0.9)
    
    dev.off()
    cat("Plot saved as ../results/Challenge_C.png\n")
    
    return(mean_richness_matrix)
  }
 
   # Challenge question D
  process_burn_in_data <- function(data_path = "../data/") {
    # This function processes the richness time series from multiple .rda files,
    # averages them by community size, and prepares the data for plotting.
    size_groups <- list("500"=1:25, "1000"=26:50, "2500"=51:75, "5000"=76:100)
    results <- list()
    
    # Vectorized rolling mean is significantly faster
    fast_rolling_mean <- function(x, w = 20) as.numeric(stats::filter(x, rep(1/w, w), sides = 1))
    
    for (sz in names(size_groups)) {
      cat("Processing size:", sz, "\n")
      valid_files <- 0
      running_richness <- NULL
      gen_axis <- NULL
      
      for (idx in size_groups[[sz]]) {
        f_name <- paste0(data_path, "aa6725_neutral_", idx, ".rda")
        if (!file.exists(f_name)) next
        
        e <- new.env()
        load(f_name, envir = e)
        
        if (is.null(e$richness_time_series)) next
        
        if (is.null(running_richness)) {
          running_richness <- e$richness_time_series
          gen_axis <- seq(e$interval_rich, by = e$interval_rich, length.out = length(e$richness_time_series))
        } else {
          # Using a simple '+' if lengths match, or your sum_vect if they don't
          running_richness <- running_richness + e$richness_time_series 
        }
        valid_files <- valid_files + 1
      }
      
      avg_richness <- running_richness / valid_files
      
      # Calculate Stability
      smoothed <- fast_rolling_mean(avg_richness)
      n <- length(smoothed)
      final_mean <- mean(smoothed[max(1, floor(n * 0.9)):n], na.rm = TRUE)
      threshold <- 0.02 * final_mean
      
      stable_gen <- NA
      for (i in 1:(n - 1)) {
        if (all(abs(smoothed[i:n] - final_mean) < threshold, na.rm = TRUE)) {
          stable_gen <- gen_axis[i]
          break
        }
      }
      
      results[[sz]] <- list(richness = avg_richness, gens = gen_axis, 
                            stable_gen = stable_gen, smoothed = smoothed)
    }
    
    save(results, file = paste0(data_path, "processed_burn_in_data.rda"))
    cat("Processed data saved.\n")
  }
  
  Challenge_D <- function(processed_file = "../data/processed_burn_in_data.rda") {
    # This function processes the richness time series from multiple .rda files,
    # averages them by community size, and prepares the data for plotting.
    
    if (!file.exists(processed_file)) stop("Run the processing script first!")
    
    load(processed_file) # Loads 'results'
    
    png(filename = "../results/Challenge_D.png", width = 1000, height = 650, res = 100)
    par(mar = c(5, 5, 4, 10), las = 1)
    
    colours <- c("500"="#0072B2","1000"="#D55E00","2500"="#009E73","5000"="#CC79A7")
    
    # Find global limits for the plot
    y_max <- max(sapply(results, function(x) max(x$richness, na.rm=TRUE)))
    x_max <- max(sapply(results, function(x) max(x$gens, na.rm=TRUE)))
    
    plot(NULL, xlim = c(0, x_max), ylim = c(0, y_max * 1.1),
         xlab = "Generation", ylab = "Mean Species Richness",
         main = "Mean Species Richness During Burn-in by Community Size",
         cex.main = 1.3, cex.lab = 1.1,xaxs = "i", yaxs = "i", axes = FALSE) 
    
    # Custom L-frame axes for cleaner look
    axis(1, lwd = 1.2)
    axis(2, lwd = 1.2)
    abline(h = 0, lwd = 1.2)
    abline(v = 0, lwd = 1.2)
    
    grid(nx = NULL, ny = 6, col = "grey90", lty = 1)
    grid(nx = NULL, ny = 6, col = "grey90", lty = 1)
    
    for (sz in names(results)) {
      dat <- results[[sz]]
      
      # Draw Raw (faint) and Smoothed (bold)
      lines(dat$gens, dat$richness, col = adjustcolor(colours[sz], 0.2), lwd = 1)
      lines(dat$gens, dat$smoothed, col = colours[sz], lwd = 2.5)
      
      # Vertical stabilization lines
      if (!is.na(dat$stable_gen)) {
        abline(v = dat$stable_gen, col = colours[sz], lty = 2, lwd = 1.5)
        mtext(dat$stable_gen, side = 3, at = dat$stable_gen, col = colours[sz], cex = 0.8)
      }
    }
    
    # Primary Legend: Positioned in the right margin
    legend("topleft", inset = c(1.02, 0), title = "Community Size",
           legend = names(results), col = colours, lwd = 3, bty = "n", cex = 0.9)
    
    # Aesthetic Legend: Placed within the plot bottom-right
    legend("bottomright", inset = c(0.02, 0.02), bty = "n", cex = 0.7,
           legend = c("Raw richness", "Smoothed (w=20)", "Equilibrium"),
           col = c("grey60", "grey30", "grey30"), lwd = c(1, 2.5, 1.5), lty = c(1, 1, 2))
    
    dev.off()
  }

  
  Challenge_E <- function() {
    
    png(filename="Challenge_E", width = 600, height = 400)
    # plot your graph here
    Sys.sleep(0.1)
    dev.off()
    
    return("type your written answer here")
  }
  
