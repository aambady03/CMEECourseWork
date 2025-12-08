##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
##Description: A script to illustrate Girko's Circular Law using R

# Install and load required packages
# Check if ggplot2 is installed, if not, install it
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
library(ggplot2)

# --- 1. Define the Ellipse Function ---
build_ellipse <- function(hradius, vradius){
  # function that returns an ellipse
  npoints = 250
  a <- seq(0, 2 * pi, length = npoints + 1)
  x <- hradius * cos(a)
  y <- vradius * sin(a)

  return(data.frame(x = x, y = y))
}

# --- 2. Simulation Parameters and Data Generation ---
N <- 250 # Assign size of the matrix (N x N)
M <- matrix(rnorm(N * N), N, N) # Build the random matrix (elements from standard normal distribution)
eigvals <- eigen(M)$values # Find the eigenvalues

# Build a dataframe for the eigenvalues
eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals))

# Calculate the predicted radius according to Girko's Circular Law
# Radius is sqrt(N)
my_radius <- sqrt(N)

# Create the dataframe for the boundary circle (the 'ellipse' with equal radii)
ellDF <- build_ellipse(my_radius, my_radius)
names(ellDF) <- c("Real", "Imaginary") # rename the columns for plotting consistency

# --- 3. Plotting the Results ---

# Initialize the plot with the eigenvalues data
p <- ggplot(eigDF, aes(x = Real, y = Imaginary))

# Add points for the eigenvalues (using shape 3 for a '+' cross)
p <- p + geom_point(shape = I(3), size = 1) +
  theme_bw() + # Use a clean theme
  labs(title = paste("Girko's Circular Law Simulation (N =", N, ")"),
       x = "Real Part of Eigenvalue",
       y = "Imaginary Part of Eigenvalue")

# Add a theme modification to remove the legend, as alpha and fill are fixed
p <- p + theme(legend.position = "none",
               plot.title = element_text(hjust = 0.5)) # Center the title

# Add the vertical and horizontal axes
p <- p + geom_hline(aes(yintercept = 0), linetype = "dashed", color = "gray50")
p <- p + geom_vline(aes(xintercept = 0), linetype = "dashed", color = "gray50")

# Finally, add the predicted circular boundary (the ellipse)
p <- p + geom_polygon(data = ellDF,
                      aes(x = Real, y = Imaginary),
                      fill = "red",
                      alpha = 0.1, # Use a lower alpha for better visibility of points
                      color = "red", # Add an outline to the circle
                      linewidth = 0.5)

# Print the plot
print(p)

# --- 4. Save the Figure as PDF ---

# Define the full path for the output file
output_path <- file.path(../results, "Girko.pdf")

# Save the plot to PDF file
ggsave(output_path, plot = p, device = "pdf", width = 7, height = 7)

cat("\nPlot saved successfully to:", output_path, "\n")